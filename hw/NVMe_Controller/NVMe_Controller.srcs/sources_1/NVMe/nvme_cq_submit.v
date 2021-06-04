`timescale 1ns / 1ps
/**
* NVMeCHA: NVMe Controller featuring Hardware Acceleration
* Copyright (C) 2021 State Key Laboratory of ASIC and System, Fudan University
* Contributed by Yunhui Qiu
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

//////////////////////////////////////////////////////////////////////////////////
// Company:  State Key Laboratory of ASIC and System, Fudan University
// Engineer: Yunhui Qiu
// 
// Create Date: 03/25/2020 10:40:53 AM
// Design Name: 
// Module Name: nvme_cq_submit
// Project Name: SSD Controller
// Target Devices: 
// Tool Versions: 
// Description: submit NVMe CQ data
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module nvme_cq_submit #(
    parameter DATA_WIDTH = 256
)(
    input                         clk,
    input                         rst_n,
    
    // host submission queu
    input      [63:0]             cq_base_addr,
    input      [15:0]             cq_size,
    input      [15:0]             cq_head,
//    output reg [15:0]             cq_tail,
    input      [15:0]             sq_id,
    input      [15:0]             sq_head,
    
    // C2H DMA descriptor
    input                         c2h_dsc_byp_ready,   
    output reg                    c2h_dsc_byp_load, 
    output reg [63 : 0]           c2h_dsc_byp_src_addr,   
    output reg [63 : 0]           c2h_dsc_byp_dst_addr,   
    output reg [27 : 0]           c2h_dsc_byp_len,   
    output reg [15 : 0]           c2h_dsc_byp_ctl,  
    
    // AXI ST interface to submit cmd completion data
    input                         axis_c2h_tready,
    output                        axis_c2h_tvalid,
    output     [DATA_WIDTH-1:0]   axis_c2h_tdata,
    output     [DATA_WIDTH/8-1:0] axis_c2h_tkeep,
    output                        axis_c2h_tlast,
    
    // input respond data
    output reg                    o_res_ready,
    input                         i_res_valid,
    input      [127:0]            i_res_data,
    
    // interrupt
    input                         usr_irq_enable,
    output reg                    usr_irq_req,
    input                         usr_irq_ack 
);
    
    
localparam
    CQ_ADDR_WIDTH      = 5;
    
reg  [15 : 0]              cq_tail;

reg  [CQ_ADDR_WIDTH-1 : 0] cq_bram_src_addr; // DMA DSC src_addr, 16B aligned unit
reg  [CQ_ADDR_WIDTH-1 : 0] cq_bram_waddr;  // DMA real-time writing address, 16B aligned
reg  [CQ_ADDR_WIDTH-1 : 0] cq_bram_raddr;  // Reading address of sq data, 32B aligned
reg  [CQ_ADDR_WIDTH-1 : 0] cq_diff_wr_src;  // waddr - src_addr
//wire [CQ_ADDR_WIDTH-1 : 0] over_threshold;

wire         cq_bram_wen;
wire [127:0] cq_bram_wdata;
wire         cq_bram_ren;
wire [127:0] cq_bram_rdata;

reg phase_tag_tmp;
reg phase_tag_pre;

wire         t_axis_tready;
reg          t_axis_tvalid;                        
reg  [127:0] t_axis_tdata;
reg  [ 15:0] t_axis_tkeep;
reg          t_axis_tlast; 


// Completion Queue data buffer in PL
pl_cq_bram pl_cq_bram (
  .clka (clk                             ),    // input wire clka
  .ena  (cq_bram_wen                     ),    // input wire ena
  .wea  (cq_bram_wen                     ),    // input wire [0 : 0] wea
  .addra(cq_bram_waddr[CQ_ADDR_WIDTH-1:0]),    // input wire [4 : 0] addra
  .dina (cq_bram_wdata                   ),    // input wire [127 : 0] dina
  .clkb (clk                             ),    // input wire clkb
  .enb  (cq_bram_ren                     ),    // input wire enb
  .addrb(cq_bram_raddr[CQ_ADDR_WIDTH-1:0]),    // input wire [4 : 0] addrb
  .doutb(cq_bram_rdata                   )     // output wire [127 : 0] doutb
);

//assign over_threshold = 64;

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    o_res_ready <= 1'b0;
end else if((cq_bram_raddr - cq_bram_waddr) >= 4 || (cq_bram_raddr == cq_bram_waddr)) begin // have at least 4 slots
    o_res_ready <= 1'b1;
end else begin
    o_res_ready <= 1'b0;
end

assign cq_bram_wen   = i_res_valid & o_res_ready;
assign cq_bram_wdata = i_res_data;

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    cq_bram_waddr <= {CQ_ADDR_WIDTH {1'b0}};
end else if(i_res_valid & o_res_ready) begin
    cq_bram_waddr <= cq_bram_waddr + 1;
end


// CQ buffer read ports
// CQ Data Submitting FSM
//    loop submitting in batch
//      1. receive at least T_MIN entries:
//         a) submit if there is enough space in host CQ
//         b) wait till there is
//      2. receive less than T_MIN entries:
//         wait until attaining or timeout

localparam
    T_MIN_SLOTS = 2,  
    TIMEOUT     = 16'ha; //10 cycles

localparam
    CQ_IDLE = 2'h0,
    CQ_GEN  = 2'h1,
    CQ_WAIT = 2'h2,
    CQ_FIN  = 2'h3;

reg  [ 1 : 0] cq_state;
reg  [15 : 0] cq_diff_head_tail; // head - tail
reg  [27 : 0] cq_dsc_len;
reg  [15 : 0] time_cnt;

wire          dsc_fifo_full;
wire          dsc_fifo_empty;
wire          dsc_fifo_ren;
wire [15 : 0] dsc_fifo_rdata;


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    cq_diff_head_tail <= 16'h0;
end else if(cq_head > cq_tail) begin
    cq_diff_head_tail <= cq_head - cq_tail - 16'h1;
end else if(cq_head == 16'h0) begin
    cq_diff_head_tail <= cq_size - cq_tail - 16'h1;
end else begin
    cq_diff_head_tail <= cq_size - cq_tail;
end

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    cq_diff_wr_src <= {CQ_ADDR_WIDTH {1'b0}};
end else begin
    cq_diff_wr_src <= cq_bram_waddr - cq_bram_src_addr;
end

//assign cq_diff_head_tail = (cq_head > cq_tail) ? (cq_head - cq_tail - 16'h1) : (cq_size - cq_tail - (cq_head == 0));  
//assign cq_diff_wr_src = cq_bram_waddr - cq_bram_src_addr;

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    cq_state   <= CQ_IDLE;
    cq_dsc_len <= 28'h0; 
end else begin
    case(cq_state)
    CQ_IDLE: begin
        if((cq_diff_wr_src > 0) && (cq_diff_head_tail > 0) && (cq_diff_head_tail <= cq_diff_wr_src)) begin // Host CQ has no enough space
            cq_state   <= CQ_GEN;
            cq_dsc_len <= {cq_diff_head_tail, 4'h0}; 
        end else if((cq_diff_wr_src >= T_MIN_SLOTS) && (cq_diff_head_tail > cq_diff_wr_src)) begin // Host CQ has enough space
            cq_state   <= CQ_GEN;
            cq_dsc_len <= {cq_diff_wr_src, 4'h0};  
        end else if((cq_diff_wr_src > 0) && (cq_diff_wr_src < T_MIN_SLOTS) && (cq_diff_head_tail > cq_diff_wr_src)) begin
            cq_state   <= CQ_WAIT;
        end
    end
    CQ_WAIT: begin
        if((time_cnt >= TIMEOUT) && (cq_diff_head_tail > cq_diff_wr_src)) begin
            cq_state   <= CQ_GEN;
            cq_dsc_len <= {cq_diff_wr_src, 4'h0}; 
        end else if(time_cnt >= TIMEOUT) begin
            cq_state   <= CQ_GEN;
            cq_dsc_len <= {cq_diff_head_tail, 4'h0};
        end 
    end
    CQ_GEN: begin
        if(c2h_dsc_byp_ready & (~dsc_fifo_full)) begin // XDMA ready to receive desc & dsc_fifo not full
            cq_state   <= CQ_FIN;
        end
    end
    CQ_FIN: begin // cq_tail and cq_bram_src_addr updated
            cq_state   <= CQ_IDLE;
    end
    endcase
end


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    time_cnt <= 16'h0;
end else if(cq_state == CQ_WAIT) begin
    time_cnt <= time_cnt + 16'h1;
end else begin
    time_cnt <= 16'h0;
end


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    cq_bram_src_addr <= 'h0;
end else if((cq_state == CQ_GEN) & c2h_dsc_byp_ready & (~dsc_fifo_full)) begin
    cq_bram_src_addr <= cq_bram_src_addr + cq_dsc_len[CQ_ADDR_WIDTH+3:4];
end


//wire [16:0] cq_tail_tmp;
//assign cq_tail_tmp = cq_tail + cq_dsc_len[20:4]; 
//assign cq_tail_tmp = cq_tail + (cq_dsc_len >> 4) + cq_dsc_len[4]; // even

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    cq_tail <= 16'h0;
    phase_tag_tmp <= 1'b1;
end else if((cq_state == CQ_GEN) & c2h_dsc_byp_ready & (~dsc_fifo_full) & (cq_dsc_len[19:4] < cq_size - cq_tail)) begin
    cq_tail <= cq_tail + cq_dsc_len[19:4]; // will not overlap cq_size
//    cq_tail <= (cq_tail_tmp < cq_size)? cq_tail_tmp : (cq_tail_tmp - cq_size);
end else if((cq_state == CQ_GEN) & c2h_dsc_byp_ready & (~dsc_fifo_full)) begin
    cq_tail <= 16'h0;
    phase_tag_tmp <= ~phase_tag_tmp;
end


always@(posedge clk) phase_tag_pre <= phase_tag_tmp;



always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    c2h_dsc_byp_load     <= 1'h0;
    c2h_dsc_byp_len      <= 28'h0;
    c2h_dsc_byp_src_addr <= 64'h0;
    c2h_dsc_byp_dst_addr <= 64'h0;
    c2h_dsc_byp_ctl      <= 16'h0;
end else if((cq_state == CQ_GEN) & c2h_dsc_byp_ready & (~dsc_fifo_full)) begin
    c2h_dsc_byp_load     <= 1'h1;
    c2h_dsc_byp_len      <= cq_dsc_len;
    c2h_dsc_byp_src_addr <= 64'h0;
    c2h_dsc_byp_dst_addr <= cq_base_addr + {cq_tail, 4'h0};
    c2h_dsc_byp_ctl      <= 16'h10;
end else begin
    c2h_dsc_byp_load     <= 1'h0;
//    c2h_dsc_byp_len      <= 28'h0;
//    c2h_dsc_byp_src_addr <= 64'h0;
//    c2h_dsc_byp_dst_addr <= 64'h0;
//    c2h_dsc_byp_ctl      <= 16'h0;
end



// descriptor FIFO to buffer dsc_len and phase tag
cq_dsc_fifo cq_dsc_len_fifo (
  .clk  (clk             ),    // input wire clk
  .rst  (~rst_n          ),    // input wire srst
  .din  ({phase_tag_pre, c2h_dsc_byp_len[18:4]}),    // input wire [15 : 0] din
  .wr_en(c2h_dsc_byp_load),    // input wire wr_en
  .rd_en(dsc_fifo_ren    ),    // input wire rd_en
  .dout (dsc_fifo_rdata  ),    // output wire [15 : 0] dout
  .full (dsc_fifo_full   ),    // output wire full
  .empty(dsc_fifo_empty  )     // output wire empty
);


// ********* read cq data from bram and format into AXI4-Stream ******

localparam
        RD_IDLE = 2'd0,
        RD_LEN  = 2'd1,
        RD_DATA = 2'd2,
        RD_FIN  = 2'd3;
        
reg   [ 1:0] rd_state; 
reg   [14:0] remain_entry;  
//reg   [15:0] rd_cnt;
//reg   [15:0] tail_add;
wire         cq_phase_tag;
wire [127:0] cq_entry;
//wire [127:0] cq_entry_1;

assign dsc_fifo_ren = (rd_state == RD_IDLE) & (~dsc_fifo_empty);
assign cq_bram_ren  = dsc_fifo_ren || (rd_state == RD_LEN) || (t_axis_tready & t_axis_tvalid & (rd_state == RD_DATA));

always@(posedge clk or negedge rst_n)
if(!rst_n)
    cq_bram_raddr <= {CQ_ADDR_WIDTH {1'b0}};
else if(cq_bram_ren) // over-read for one time
    cq_bram_raddr <= cq_bram_raddr + 1; 
else if(t_axis_tready & t_axis_tvalid & (rd_state == RD_FIN)) // read one more entries
    cq_bram_raddr <= cq_bram_raddr - 1; 


assign cq_phase_tag = dsc_fifo_rdata[15];

assign cq_entry = {cq_bram_rdata[127:113], cq_phase_tag, cq_bram_rdata[111:96], sq_id, sq_head, cq_bram_rdata[63:0]};
//assign cq_entry_1 = {cq_bram_rdata[255:241], cq_phase_tag, cq_bram_rdata[239:224],sq_id, sq_head, cq_bram_rdata[191:128]};

always@(posedge clk or negedge rst_n)
begin
  if(!rst_n) begin
      rd_state      <= RD_IDLE;
      remain_entry  <= 15'h0;
      t_axis_tdata  <= 128'h0;
      t_axis_tkeep  <= 16'h0;
      t_axis_tvalid <= 1'b0;
      t_axis_tlast  <= 1'b0;
  end else begin
    case(rd_state)
        RD_IDLE:begin
            if(~dsc_fifo_empty) begin  
                rd_state   <= RD_LEN;
            end
        end
        RD_LEN: begin 
            t_axis_tvalid <= 1'b1;
            t_axis_tdata  <= cq_entry;      
            t_axis_tkeep  <= 16'hffff;        
            remain_entry  <= dsc_fifo_rdata[14:0] - 15'h1;                         
            if(dsc_fifo_rdata[14:0] <= 15'h1) begin
               rd_state     <= RD_FIN;
               t_axis_tlast <= 1'b1; 
            end else begin
               rd_state     <= RD_DATA;
               t_axis_tlast <= 1'b0;                
            end
        end
        RD_DATA:begin
            if(t_axis_tready & t_axis_tvalid &(remain_entry <= 15'h1)) begin
                t_axis_tdata  <= cq_entry; 
                t_axis_tlast  <= 1'b1;
                rd_state      <= RD_FIN;
            end else if(t_axis_tready & t_axis_tvalid) begin
                t_axis_tdata  <= cq_entry; 
                t_axis_tlast  <= 1'b0;
                remain_entry  <= remain_entry - 15'h1;
                rd_state      <= RD_DATA;
            end 
        end
        RD_FIN:begin
            if(t_axis_tready & t_axis_tvalid) begin
                t_axis_tvalid <= 1'b0;
//                t_axis_tkeep  <= 16'h0;
//                t_axis_tdata  <= 128'h0;
                t_axis_tlast  <= 1'b0;
                rd_state      <= RD_IDLE;
             end
        end
     endcase
   end
end  


// Data width converter, 128b to 256b
pl_cq_dwidth_convert pl_cq_dwidth_convert (
      .aclk         (clk            ),    // input wire aclk
      .aresetn      (rst_n          ),    // input wire aresetn
      .s_axis_tvalid(t_axis_tvalid  ),    // input wire s_axis_tvalid
      .s_axis_tready(t_axis_tready  ),    // output wire s_axis_tready
      .s_axis_tdata (t_axis_tdata   ),    // input wire [127 : 0] s_axis_tdata
      .s_axis_tkeep (t_axis_tkeep   ),    // input wire [15 : 0] s_axis_tkeep
      .s_axis_tlast (t_axis_tlast   ),    // input wire s_axis_tlast
      .m_axis_tvalid(axis_c2h_tvalid),    // output wire m_axis_tvalid
      .m_axis_tready(axis_c2h_tready),    // input wire m_axis_tready
      .m_axis_tdata (axis_c2h_tdata ),    // output wire [255 : 0] m_axis_tdata
      .m_axis_tkeep (axis_c2h_tkeep ),    // input wire [31 : 0] m_axis_tkeep
      .m_axis_tlast (axis_c2h_tlast )     // output wire m_axis_tlast
); 


// Interrupt

localparam
    IRQ_IDLE = 1'h0,
    IRQ_GEN  = 1'h1;

reg  irq_state;

always@(posedge clk or negedge rst_n)
if(!rst_n) begin
    irq_state   <= IRQ_IDLE;
    usr_irq_req <= 1'b0;
end else begin
    case(irq_state)
        IRQ_IDLE: begin
            if(usr_irq_enable & t_axis_tready & t_axis_tvalid & (rd_state == RD_FIN)) begin
                irq_state   <= IRQ_GEN;
                usr_irq_req <= 1'b1;
            end           
        end
        IRQ_GEN: begin
            if(usr_irq_ack) begin
                irq_state   <= IRQ_IDLE;
                usr_irq_req <= 1'b0;
            end
        end
    endcase
end
      
    
endmodule
