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
// Create Date: 03/26/2020 11:05:26 PM
// Design Name: 
// Module Name: nvme_c2h_data_submit
// Project Name: SSD Controller
// Target Devices: 
// Tool Versions: 
// Description: submit data from card to host
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "nvme_param.vh"

//`define HAS_PARAM_FIFO

module nvme_c2h_data_submit #(
    parameter DATA_WIDTH = 256
)(
    input                        clk,
    input                        rst_n,
    
    // host submission queu
    output                       o_cmd_ready,
    input                        i_cmd_valid,
    input      [63:0]            i_host_addr, // data addr in host memory
    input      [31:0]            i_data_len,  // transfer length of data
    input      [15:0]            i_cmd_id,    // command id
    input      [ 3:0]            i_cmd_type,  // cmd type
    input                        i_cmd_last,  // last command in a group
    
    // respond to CQ
    input                        i_res_ready,
    output reg                   o_res_valid,
    output reg [127 : 0]         o_res_data,
    
    // C2H DMA descriptor
    input                        c2h_dsc_byp_ready,   
    output reg                   c2h_dsc_byp_load, 
    output reg [63 : 0]          c2h_dsc_byp_src_addr,   
    output reg [63 : 0]          c2h_dsc_byp_dst_addr,   
    output reg [27 : 0]          c2h_dsc_byp_len,   
    output reg [15 : 0]          c2h_dsc_byp_ctl, 
    
    // AXI ST interface to submit h2c data
    input                        axis_c2h_tready,
    output                       axis_c2h_tvalid,
    output [DATA_WIDTH-1:0]      axis_c2h_tdata,
    output [DATA_WIDTH/8-1:0]    axis_c2h_tkeep,
    output                       axis_c2h_tlast,
    
    // axi4-stream interface of reading data and parameter
    output                       s_axis_tready,
    input                        s_axis_tvalid,
    input  [DATA_WIDTH-1 : 0]    s_axis_tdata,
    input  [DATA_WIDTH/8-1 : 0]  s_axis_tkeep,
    input  [ 15 : 0]             s_axis_tid,
    input  [  3 : 0]             s_axis_tuser,
    input                        s_axis_tlast 
);

localparam
    DSC_IDLE  = 3'h0,
    DSC_SUM   = 3'h1,
    DSC_SLICE = 3'h2,
    DSC_GEN   = 3'h3,
    DSC_FIN   = 3'h4,
    DSC_WAIT  = 3'h5,
    RES_WAIT  = 3'h6;
    
localparam TRAN_SIZE = `DMA_TRAN_SIZE;
    
reg    [2 : 0] dsc_state;

wire           data_fifo_full;
wire           data_fifo_prog_full;
wire           data_fifo_empty;
wire           data_fifo_wen;
wire [127 : 0] data_fifo_wdata;
wire           data_fifo_ren;
wire [127 : 0] data_fifo_rdata;

reg  [ 63 : 0] host_addr;
//reg  [ 63 : 0] host_addr_r;
reg  [ 27 : 0] sent_bytes;
reg  [ 27 : 0] left_bytes;
reg  [ 27 : 0] dsc_len;
wire [ 27 : 0] data_len;
//reg  [ 19 : 0] data_len_dly; // max 1MB
reg  [ 19 : 0] data_cnt; // max 1MB
reg            cmd_last;
//reg  [ 19 : 0] data_page_cnt;
reg            eop; // end of packet
//reg            final_eop; // end of packet
reg  [ 15 : 0] cmd_id;

wire           fsm_ready;

`ifdef HAS_PARAM_FIFO
wire           param_fifo_full;
wire           param_fifo_prog_full;
wire           param_fifo_empty;
wire           param_fifo_wen;
wire [127 : 0] param_fifo_wdata;
wire           param_fifo_ren;
wire [127 : 0] param_fifo_rdata;

assign o_cmd_ready = ~(data_fifo_prog_full | param_fifo_prog_full);

assign data_fifo_wen   = o_cmd_ready & i_cmd_valid & (i_cmd_type == 4'h0);
assign data_fifo_wdata = {i_cmd_last, i_cmd_id, i_data_len, i_host_addr};

assign param_fifo_wen   = o_cmd_ready & i_cmd_valid & (i_cmd_type == 4'h1);
assign param_fifo_wdata = {i_cmd_id, i_data_len, i_host_addr};

assign data_fifo_ren  = (dsc_state == DSC_IDLE) && s_axis_tvalid && (s_axis_tuser == 4'h0);
assign param_fifo_ren = (dsc_state == DSC_IDLE) && s_axis_tvalid && (s_axis_tuser == 4'h1);

//assign host_addr = (s_axis_tuser == 4'h1)? param_fifo_rdata[63:0] : data_fifo_rdata[63:0];
assign data_len  = (s_axis_tuser == 4'h1)? param_fifo_rdata[91:64] : data_fifo_rdata[91:64];

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    cmd_last <= 1'b1;
end else if(dsc_state == DSC_SUM) begin
    cmd_last <= (s_axis_tuser == 4'h1)? 1'b1 : data_fifo_rdata[112];
end

// descriptor FIFO to buffer dsc_len
nvme_data_cmd_fifo c2h_param_cmd_fifo (
  .clk      (clk                  ),    // input wire clk
  .rst      (~rst_n               ),    // input wire srst
  .din      (param_fifo_wdata     ),    // input wire [127 : 0] din
  .wr_en    (param_fifo_wen       ),    // input wire wr_en
  .rd_en    (param_fifo_ren       ),    // input wire rd_en
  .dout     (param_fifo_rdata     ),    // output wire [127 : 0] dout
  .full     (param_fifo_full      ),    // output wire full
  .empty    (param_fifo_empty     ),    // output wire empty
  .prog_full(param_fifo_prog_full )  // output wire prog_full
);

`else

assign o_cmd_ready = ~data_fifo_prog_full;

assign data_fifo_wen   = o_cmd_ready & i_cmd_valid;
assign data_fifo_wdata = {i_cmd_last, i_cmd_id, i_data_len, i_host_addr};
assign data_fifo_ren  = (dsc_state == DSC_IDLE) && s_axis_tvalid & (~data_fifo_empty);

//assign host_addr = data_fifo_rdata[63:0];
assign data_len  = data_fifo_rdata[91:64];

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    cmd_last <= 1'b1;
end else if(dsc_state == DSC_SUM) begin
    cmd_last <= data_fifo_rdata[112];
end

`endif

// descriptor FIFO to buffer dsc_len
nvme_data_cmd_fifo c2h_data_cmd_fifo (
  .clk      (clk                  ),    // input wire clk
  .rst      (~rst_n               ),    // input wire srst
  .din      (data_fifo_wdata      ),    // input wire [127 : 0] din
  .wr_en    (data_fifo_wen        ),    // input wire wr_en
  .rd_en    (data_fifo_ren        ),    // input wire rd_en
  .dout     (data_fifo_rdata      ),    // output wire [127 : 0] dout
  .full     (data_fifo_full       ),    // output wire full
  .empty    (data_fifo_empty      ),    // output wire empty
  .prog_full(data_fifo_prog_full  )  // output wire prog_full
);


// only fsm_ready, s_axis_tready can be high
assign fsm_ready = (dsc_state == DSC_FIN);

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    host_addr <= 64'h0;
end else if(dsc_state == DSC_SUM) begin
    host_addr <= data_fifo_rdata[63:0];
end

//always@(posedge clk) host_addr_r <= host_addr;

// Descriptor submitting FSM
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    dsc_state <= DSC_IDLE;
    sent_bytes <= 28'h0;
    left_bytes <= 28'h0;
    dsc_len    <= 28'h0;
    cmd_id     <= 16'h0;
    o_res_valid <= 1'h0;
    o_res_data  <= 128'h0;
end else begin
    case(dsc_state)
        DSC_IDLE: begin
            if(s_axis_tvalid & (~data_fifo_empty)) begin // wait until axis data coming
                dsc_state <= DSC_SUM;
            end
        end
        DSC_SUM: begin // get the length of the large-size data
            left_bytes <= data_len;
            sent_bytes <= 28'h0;
            dsc_state <= DSC_SLICE;            
        end
        DSC_SLICE: begin // slice large-size data to multiple small-size data
            if(left_bytes > TRAN_SIZE) begin
                dsc_state  <= DSC_GEN;
                dsc_len    <= TRAN_SIZE;
                left_bytes <= left_bytes - TRAN_SIZE;              
            end else begin
                dsc_state  <= DSC_GEN;
                dsc_len    <= left_bytes;
                left_bytes <= 28'h0; 
            end
        end
        DSC_GEN: begin // generate descriptor
            if(c2h_dsc_byp_ready) begin
                dsc_state <= DSC_FIN;
                sent_bytes <= sent_bytes + dsc_len;
            end
        end
        DSC_FIN: begin // AXI-Stream data transfer
//            if(s_axis_tready & s_axis_tvalid & s_axis_tlast) begin
            if(s_axis_tready & s_axis_tvalid & eop) begin
                dsc_state <= DSC_WAIT;
                cmd_id    <= s_axis_tid;
            end
        end
        DSC_WAIT: begin
            if((left_bytes == 28'h0) & cmd_last) begin // generate response data
                dsc_state <= RES_WAIT;
                o_res_valid <= 1'h1;
                o_res_data  <= {16'h0, cmd_id, 96'h0};
            end else if(left_bytes == 28'h0) begin
                dsc_state <= DSC_IDLE;
            end else if(s_axis_tvalid) begin // Wait for next page data
                dsc_state <= DSC_SLICE;
            end
        end
        RES_WAIT: begin // wait response submitting
            if(i_res_ready & o_res_valid) begin 
                dsc_state <= DSC_IDLE;
                o_res_valid <= 1'h0;
//                o_res_data <= 128'h0;
            end
        end
    endcase
end



always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    c2h_dsc_byp_load     <= 1'h0;
    c2h_dsc_byp_len      <= 28'h0;
    c2h_dsc_byp_src_addr <= 64'h0;
    c2h_dsc_byp_dst_addr <= 64'h0;
    c2h_dsc_byp_ctl      <= 16'h0;
end else if((dsc_state == DSC_GEN) && c2h_dsc_byp_ready) begin
    c2h_dsc_byp_load     <= 1'h1;
    c2h_dsc_byp_len      <= dsc_len;
    c2h_dsc_byp_src_addr <= 64'h0;
    c2h_dsc_byp_dst_addr <= host_addr + sent_bytes;
    c2h_dsc_byp_ctl      <= 16'h10;
end else begin
    c2h_dsc_byp_load     <= 1'h0;
//    c2h_dsc_byp_len      <= 28'h0;
//    c2h_dsc_byp_src_addr <= 64'h0;
//    c2h_dsc_byp_dst_addr <= 64'h0;
//    c2h_dsc_byp_ctl      <= 16'h0;
end

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    data_cnt <= 20'h0;
end else if(dsc_state == DSC_GEN) begin
    data_cnt <= 20'h0;
end else if((dsc_state == DSC_FIN) & (s_axis_tready & s_axis_tvalid)) begin
    data_cnt <= data_cnt + 20'h20;
end

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    eop <= 1'h0;
end else if(s_axis_tready & s_axis_tvalid & ((data_cnt + 20'h40 >= dsc_len) && (data_cnt + 20'h20 < dsc_len)) ) begin
    eop <= 1'h1;
end else if(s_axis_tready & s_axis_tvalid) begin
    eop <= 1'h0;
end

//assign eop = o_rready & i_rvalid & (data_cnt >= fifo_rdata[91:64] - 28'h20);

//always@(posedge clk or negedge rst_n)
//if(~rst_n) begin
//    data_len_dly <= 20'h0;
//end else if(dsc_state == DSC_SUM) begin
//    data_len_dly <= data_len[19:0];
//end

//always@(posedge clk or negedge rst_n)
//if(~rst_n) begin
//    data_cnt <= 20'h0;
//end else if(s_axis_tready & s_axis_tvalid & (data_cnt + 20'h20 >= data_len_dly)) begin
//    data_cnt <= 20'h0;
//end else if(s_axis_tready & s_axis_tvalid) begin
//    data_cnt <= data_cnt + 20'h20;
//end


//always@(posedge clk or negedge rst_n)
//if(~rst_n) begin
//    data_page_cnt <= 20'h0;
//end else if(s_axis_tready & s_axis_tvalid & (data_cnt + 20'h20 >= data_len_dly)) begin
//    data_page_cnt <= 20'h0;
//end else if(s_axis_tready & s_axis_tvalid & (data_page_cnt >= TRAN_SIZE - 20'h20)) begin
//    data_page_cnt <= 20'h0;
//end else if(s_axis_tready & s_axis_tvalid) begin
//    data_page_cnt <= data_page_cnt + 20'h20;
//end

//always@(posedge clk or negedge rst_n)
//if(~rst_n) begin
//    eop <= 1'h0;
//end else if(s_axis_tready & s_axis_tvalid & ( (data_page_cnt == TRAN_SIZE - 20'h40) | 
//            ((data_cnt + 20'h40 >= data_len_dly) & (data_cnt + 20'h20 < data_len_dly)) )) begin
//    eop <= 1'h1;
//end else if(s_axis_tready & s_axis_tvalid) begin
//    eop <= 1'h0;
//end


//always@(posedge clk or negedge rst_n)
//if(~rst_n) begin
//    final_eop <= 1'h0;
//end else if(s_axis_tready & s_axis_tvalid & ((data_cnt + 20'h40  >= data_len_dly) & 
//            (data_cnt + 20'h20 < data_len_dly)) ) begin
//    final_eop <= 1'h1;
//end else if(s_axis_tready & s_axis_tvalid) begin
//    final_eop <= 1'h0;
//end


assign s_axis_tready   = axis_c2h_tready & fsm_ready;
assign axis_c2h_tvalid = s_axis_tvalid & fsm_ready;
assign axis_c2h_tdata  = s_axis_tdata;
assign axis_c2h_tkeep  = s_axis_tkeep;
assign axis_c2h_tlast  = eop;
//assign axis_c2h_tlast  = s_axis_tlast;


//always@(posedge clk or negedge rst_n)
//if(~rst_n) begin
//    o_res_valid <= 1'h0;
//    o_res_data <= 128'h0;
//end else if(s_axis_tready & s_axis_tvalid & final_eop & cmd_last) begin
//    o_res_valid <= 1'h1;
//    o_res_data <= {16'h0, s_axis_tid, 96'h0};
//end else if(i_res_ready & o_res_valid) begin
//    o_res_valid <= 1'h0;
////    o_res_data <= 128'h0;
//end

endmodule
