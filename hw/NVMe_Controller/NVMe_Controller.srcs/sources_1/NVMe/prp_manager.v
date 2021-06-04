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
// Create Date: 11/16/2020 09:28:09 PM
// Design Name: 
// Module Name: prp_manager
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Manage PRP entries, supporting PRP List
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module prp_manager#(
    parameter DATA_WIDTH = 256
)(
    input                        clk,
    input                        rst_n,
    output                       o_req_ready,
    input                        i_req_valid,
    input      [  7:0]           i_req_opc,   // operation code
    input      [ 15:0]           i_req_cid,   // Command ID
    input      [127:0]           i_req_dptr,  // data pointer
    input      [ 15:0]           i_req_nlb,   // number of logical blocks
    input      [  7:0]           mps_width,   // memeory page size bitwidth
    input      [  7:0]           lbads_width, // LBA data size bitwidth
    // output PRP number, address...
    input                        prp_fifo_ren,
    output     [ 63:0]           prp_fifo_rdata,
    output                       prp_fifo_empty,
    // H2C DMA descriptor
    input                        h2c_dsc_byp_ready,   
    output reg                   h2c_dsc_byp_load, 
    output reg [63 : 0]          h2c_dsc_byp_src_addr,   
    output reg [63 : 0]          h2c_dsc_byp_dst_addr,   
    output reg [27 : 0]          h2c_dsc_byp_len,   
    output reg [15 : 0]          h2c_dsc_byp_ctl,
    
    // AXI ST interface to fetch programming data
    output                       axis_h2c_tready,
    input                        axis_h2c_tvalid,
    input  [DATA_WIDTH-1:0]      axis_h2c_tdata,
    input  [DATA_WIDTH/8-1:0]    axis_h2c_tkeep,
    input                        axis_h2c_tlast
);


// Output PRP data format
// QWord 0 : header
//           [15 : 0]  prp_num, number of PRP addresses
//           [31 : 16] cid, commmand id
//           [39 : 32] opc, operation code
// QWord 1 : [31 : 0]  start_len, data length of the first PRP transfer
//           [63 : 32] last_len, data length of the last PRP transfer
// QWord 2 : prp_addr 1
// QWord 3 : prp_addr 2
// ...
// QWord n : prp_addr n

localparam
    IDLE      = 3'h0,
    HEADER    = 3'h1,
    FIRST     = 3'h2,
    SECOND    = 3'h3,
    DSC_SLICE = 3'h4,
    DSC_LOAD  = 3'h5,
    DSC_WAIT  = 3'h6,
    DATA      = 3'h7,
    FIFO_DEPTH = 16'h200,
    T_DEPTH    = 16'h80,
    FIFO_RSVD  = 16'h20;
    
reg  [ 2:0] state;
//reg  [ 2:0] state_dly;
//reg  [ 2:0] next_state;

reg  [31:0] mem_page_size;
reg  [31:0] offset_mask;
reg  [31:0] prp_max_num;
reg  [31:0] prp_mask;

reg  [63:0] prp1;
reg  [63:0] prp2;
reg  [ 7:0] opc_reg;
reg  [15:0] cid_reg;
reg  [31:0] start_offset;
reg  [31:0] data_len;
reg  [15:0] prp_num;
reg  [31:0] start_len;
reg  [31:0] last_len_tmp;
reg  [31:0] last_len;
//reg         prp_addr_align;
reg  [31:0] prpl_start_offset;
reg  [15:0] prpl_left_num;

reg  [ 1:0] cnt;
reg  [15:0] left_num;
reg  [18:0] dsc_len; 
reg  [63:0] dsc_src_addr;
reg         prpl_fetch_once;
//reg  [ 3:0] prpl_overfetch_num;
//reg  [15:0] prpl_fetch_cnt;

wire          fifo_full;
//wire          fifo_empty;
reg           fifo_wen;
reg  [63 : 0] fifo_wdata;
//wire          fifo_ren;
//wire [63 : 0] fifo_rdata;
wire [ 8 : 0] fifo_data_count;

reg  [15 : 0] fifo_left_cnt;
reg  [15 : 0] pre_alloc_cnt;

wire         t_axis_h2c_tready;
wire         t_axis_h2c_tvalid;
wire [63:0]  t_axis_h2c_tdata;
wire [ 7:0]  t_axis_h2c_tkeep;
wire         t_axis_h2c_tlast;


// Data width converter, 256b to 64b
axis_dwidth_converter_256to64 axis_dwidth_converter_256to64 (
      .aclk         (clk              ),    // input wire aclk
      .aresetn      (rst_n            ),    // input wire aresetn
      .s_axis_tvalid(axis_h2c_tvalid  ),    // input wire s_axis_tvalid
      .s_axis_tready(axis_h2c_tready  ),    // output wire s_axis_tready
      .s_axis_tdata (axis_h2c_tdata   ),    // input wire [255 : 0] s_axis_tdata
      .s_axis_tkeep (axis_h2c_tkeep   ),    // input wire [31 : 0] s_axis_tkeep
      .s_axis_tlast (axis_h2c_tlast   ),    // input wire s_axis_tlast
      .m_axis_tvalid(t_axis_h2c_tvalid),    // output wire m_axis_tvalid
      .m_axis_tready(t_axis_h2c_tready),    // input wire m_axis_tready
      .m_axis_tdata (t_axis_h2c_tdata ),    // output wire [63 : 0] m_axis_tdata
      .m_axis_tkeep (t_axis_h2c_tkeep ),    // input wire [7 : 0] m_axis_tkeep
      .m_axis_tlast (t_axis_h2c_tlast )     // output wire m_axis_tlast
);


//assign prp1 = i_req_dptr[63:0];
//assign prp2 = i_req_dptr[127:64];

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    mem_page_size <= 32'h0;
end else begin 
    mem_page_size <= 32'h1 << mps_width;
end

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    offset_mask <= 32'h0;
end else begin 
    offset_mask <= (32'h1 << mps_width) - 32'h1;
end

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    prp_max_num <= 32'h0;
end else begin 
    prp_max_num <= 32'h1 << (mps_width - 32'h3);
end

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    prp_mask <= 32'h0;
end else begin 
    prp_mask <= (32'h1 << (mps_width - 32'h3)) - 32'h1;
end


// Pipeline: 0 
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    opc_reg <= 8'h0;
end else if((state == IDLE) & i_req_valid) begin
    opc_reg <= i_req_opc;
end

// Pipeline: 0 
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    cid_reg <= 16'h0;
end else if((state == IDLE) & i_req_valid) begin
    cid_reg <= i_req_cid;
end

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    prp1 <= 16'h0;
end else if((state == IDLE) & i_req_valid) begin 
    prp1 <= i_req_dptr[63:0];
end

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    prp2 <= 16'h0;
end else if((state == IDLE) & i_req_valid) begin
    prp2 <= i_req_dptr[127:64];
end

// Pipeline: 0 
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    start_offset <= 32'h0;
end else if((state == IDLE) & i_req_valid) begin // low mps_width bits
    start_offset <= i_req_dptr[31:0] & offset_mask;
end

// Pipeline: 0 
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    data_len <= 32'h0;
end else if((state == IDLE) & i_req_valid) begin 
    data_len <= (i_req_nlb + 32'h1) << lbads_width;
end

// Pipeline: 0
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    prpl_start_offset <= 32'h0;
end else if((state == IDLE) & i_req_valid) begin // low mps_width bits
    prpl_start_offset <= i_req_dptr[95:64] & offset_mask; 
//    prpl_start_offset <= {i_req_dptr[95:69], 5'h0} & offset_mask; // overfetch to align to 32B
end

//// Pipeline: 0
//always@(posedge clk or negedge rst_n)
//if(~rst_n) begin
//    prp_addr_align <= 1'h0;
//end else if((state == IDLE) & i_req_valid & (i_req_dptr[4:0] | i_req_dptr[68:64])) begin // XDMA require host_addr[4:0] == 0h
//    prp_addr_align <= 1'h0;
//end else if((state == IDLE) & i_req_valid) begin 
//    prp_addr_align <= 1'h1;
//end 

// Pipeline: 1
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    prp_num <= 16'h0;
//end else if(~prp_addr_align) begin 
//    prp_num <= 16'h0;
end else begin 
    prp_num <= (start_offset + data_len + offset_mask) >> mps_width;
end




// Pipeline: 1
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    start_len <= 32'h0;
end else begin 
    start_len <= mem_page_size - start_offset;
end

// Pipeline: 1
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    last_len_tmp <= 32'h0;
end else begin 
    last_len_tmp <= (start_offset + data_len) & offset_mask;
end

// Pipeline: 2
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    last_len <= 32'h0;
end else begin 
    last_len <= (last_len_tmp == 32'h0)? mem_page_size : last_len_tmp;
end

//// Pipeline: 1
//always@(posedge clk or negedge rst_n)
//if(~rst_n) begin
//    prpl_max_num <= 16'h0;
//end else begin 
//    prpl_max_num <= ((1 << mps_width) - prpl_start_offset) >> 3;
//end


assign o_req_ready = (state == IDLE);

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    state      <= IDLE;
    cnt        <= 2'h0;
    dsc_len    <= 19'h0;
    left_num   <= 16'h0;
    prpl_left_num <= 16'h0;
    dsc_src_addr  <= 64'h0;
    prpl_fetch_once <= 1'h0;
//    prpl_overfetch_num <= 4'h0;
end else begin
    case(state)
        IDLE: begin
            if(i_req_valid) begin
                state    <= HEADER;
                cnt      <= 2'h0;               
            end
        end
        HEADER: begin
//            if((cnt == 2'h1) && (~prp_addr_align)) begin
//                state    <= IDLE;
//            end else if(cnt == 2'h2) begin
            if(cnt == 2'h2) begin 
                state    <= FIRST;
                left_num <= prp_num;
            end else begin
                state    <= HEADER;
                cnt      <= cnt + 2'h1;               
            end 
        end
        FIRST: begin
            if(left_num <= 16'h1) begin // only PRP1 is used
                state    <= IDLE;               
            end else if(left_num == 16'h2) begin // PRP2 is address
                state    <= SECOND;                
            end else begin // PRP2 is PRP List pointer
                state    <= DSC_SLICE;
                left_num <= left_num - 16'h1; 
                dsc_src_addr  <= prp2;
//                left_num <= left_num - 16'h1 + prp2[4:3]; // overfetch
//                dsc_src_addr  <= {prp2[63:5], 5'h0};
                prpl_left_num <= (mem_page_size - prpl_start_offset) >> 3; // max left number
//                prpl_overfetch_num <= prp2[4:3];
            end
        end
        SECOND: begin
                state    <= IDLE;
        end
        DSC_SLICE: begin
            if((left_num <= prpl_left_num) && (left_num + FIFO_RSVD <= fifo_left_cnt)) begin // only one PRP List and only fetch once
                dsc_len    <= left_num << 3; 
                left_num   <= 16'h0;                 
                state      <= DSC_LOAD;    
                prpl_fetch_once <= 1'h1;       
            end else if((left_num > prpl_left_num) && (prpl_left_num + FIFO_RSVD <= fifo_left_cnt)) begin // more than one PRP Lists and fetch once for this PRP List
                dsc_len    <= prpl_left_num << 3; // last entry is the next PRP List pointer
                left_num   <= left_num - prpl_left_num + 16'h1; 
                state      <= DSC_LOAD; 
                prpl_fetch_once <= 1'h1; 
            end else if(fifo_left_cnt > T_DEPTH + FIFO_RSVD ) begin // fetch more than once for this PRP List
                dsc_len    <= T_DEPTH << 3;
                left_num   <= left_num - T_DEPTH;
                state      <= DSC_LOAD; 
                prpl_fetch_once <= 1'h0; 
                prpl_left_num   <= prpl_left_num - T_DEPTH;
            end  
        end
        DSC_LOAD: begin
            if(h2c_dsc_byp_ready) begin
                state        <= DSC_WAIT; 
                dsc_src_addr <= dsc_src_addr + dsc_len;
            end
        end
        DSC_WAIT: begin // wait for the update of prpl_left_num
            if(prpl_fetch_once)
                state    <= DATA;
            else
                state    <= DSC_SLICE;
        end
        DATA: begin
            if((t_axis_h2c_tready & t_axis_h2c_tvalid & t_axis_h2c_tlast) && (pre_alloc_cnt == 16'h1) && (left_num > 16'h0)) begin
                state        <= DSC_SLICE;
                dsc_src_addr <= {t_axis_h2c_tdata[63:2], 2'h0}; // last PRP List Entry is the next PRP List pointer
                prpl_left_num <= (prp_max_num - t_axis_h2c_tdata[31:3] - t_axis_h2c_tdata[2]) & prp_mask; // max left number
//                prpl_left_num <= ((1 << mps_width) - ({t_axis_h2c_tdata[31:5], 5'h0} & offset_mask)) >> 3; // max left number
//                prpl_left_num <= (prp_max_num - {t_axis_h2c_tdata[31:5], 2'h0}) & prp_mask; // max left number
//                prpl_overfetch_num <= t_axis_h2c_tdata[4:3];
            end else if((t_axis_h2c_tready & t_axis_h2c_tvalid & t_axis_h2c_tlast) && (pre_alloc_cnt == 16'h1)) begin
                state        <= IDLE;
            end
        end
    endcase
end


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    h2c_dsc_byp_load     <= 1'h0;
    h2c_dsc_byp_len      <= 28'h0;
    h2c_dsc_byp_src_addr <= 64'h0;
    h2c_dsc_byp_dst_addr <= 64'h0;
    h2c_dsc_byp_ctl      <= 16'h0;
end else if((state == DSC_LOAD) && h2c_dsc_byp_ready) begin
    h2c_dsc_byp_load     <= 1'h1;
    h2c_dsc_byp_len      <= dsc_len;
    h2c_dsc_byp_src_addr <= dsc_src_addr;
    h2c_dsc_byp_dst_addr <= 64'h0;
    h2c_dsc_byp_ctl      <= 16'h10;
end else begin
    h2c_dsc_byp_load     <= 1'h0;
//    h2c_dsc_byp_len      <= 28'h0;
//    h2c_dsc_byp_src_addr <= 64'h0;
//    h2c_dsc_byp_dst_addr <= 64'h0;
//    h2c_dsc_byp_ctl      <= 16'h0;
end


prp_fifo prp_fifo (
  .clk       (clk             ),    // input wire clk
  .rst       (~rst_n          ),    // input wire srst
  .din       (fifo_wdata      ),    // input wire [63 : 0] din
  .wr_en     (fifo_wen        ),    // input wire wr_en
  .rd_en     (prp_fifo_ren    ),    // input wire rd_en
  .dout      (prp_fifo_rdata  ),    // output wire [63 : 0] dout
  .full      (fifo_full       ),    // output wire full
  .empty     (prp_fifo_empty  ),     // output wire empty
  .data_count(fifo_data_count )  // output wire [8 : 0] data_count
);

assign t_axis_h2c_tready = ~fifo_full;

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    pre_alloc_cnt <= 16'h0;
end else if((state == DSC_LOAD) & h2c_dsc_byp_ready & (t_axis_h2c_tready & t_axis_h2c_tvalid)) begin
    pre_alloc_cnt <= pre_alloc_cnt + dsc_len[18:3] - 16'h1;
end else if((state == DSC_LOAD) & h2c_dsc_byp_ready) begin
    pre_alloc_cnt <= pre_alloc_cnt + dsc_len[18:3];
end else if(t_axis_h2c_tready & t_axis_h2c_tvalid) begin
    pre_alloc_cnt <= pre_alloc_cnt - 16'h1;
end


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    fifo_left_cnt <= 16'h0;
end else begin
    fifo_left_cnt <= FIFO_DEPTH - fifo_data_count - pre_alloc_cnt;
end


//always@(posedge clk or negedge rst_n)
//if(~rst_n) begin
//    fifo_left_cnt <= 16'h0;
//end else if(pre_alloc_cnt < 16'h100) begin // keep pre_alloc_cnt < 16'h100
//    fifo_left_cnt <= FIFO_DEPTH - fifo_data_count - pre_alloc_cnt;
//end else begin
//    fifo_left_cnt <= 16'h0;
//end

//always@(posedge clk or negedge rst_n)
//if(~rst_n) begin
//    state_dly <= IDLE;
//end else begin 
//    state_dly <= state;
//end

//always@(posedge clk or negedge rst_n)
//if(~rst_n) begin
//    prpl_fetch_cnt <= 16'h0;
//end else if((state == FIRST) || ((state_dly == DATA) && (state == DSC_SLICE)))begin 
//    prpl_fetch_cnt <= 16'h0;
//end else if(t_axis_h2c_tready & t_axis_h2c_tvalid) begin
//    prpl_fetch_cnt <= prpl_fetch_cnt + 16'h1;
//end



always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    fifo_wen   <= 1'h0;
    fifo_wdata <= 64'h0;
end else if((state == HEADER) && (cnt == 2'h1)) begin
    fifo_wen   <= 1'h1;
    fifo_wdata <= {opc_reg, cid_reg, prp_num};
end else if((state == HEADER) && (cnt == 2'h2)) begin
    fifo_wen   <= 1'h1;
    fifo_wdata <= {last_len, start_len};
end else if(state == FIRST) begin
    fifo_wen   <= 1'h1;
    fifo_wdata <= prp1;
end else if(state == SECOND) begin
    fifo_wen   <= 1'h1;
    fifo_wdata <= {prp2[63:12], 12'h0}; // 4K aligned
end else if((state == DATA) && (t_axis_h2c_tready & t_axis_h2c_tvalid & t_axis_h2c_tlast) && (pre_alloc_cnt == 16'h1) && (left_num > 16'h0))begin 
    fifo_wen   <= 1'h0;
//    fifo_wdata <= 64'h0;
end else if(t_axis_h2c_tready & t_axis_h2c_tvalid)begin 
    fifo_wen   <= 1'h1;  // remove PRP List Pointer
    fifo_wdata <= {t_axis_h2c_tdata[63:12], 12'h0}; // 4K aligned
end else begin
    fifo_wen   <= 1'h0;
//    fifo_wdata <= 64'h0;
end


endmodule
