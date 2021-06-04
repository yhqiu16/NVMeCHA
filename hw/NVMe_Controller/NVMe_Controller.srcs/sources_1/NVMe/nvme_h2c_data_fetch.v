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
// Create Date: 03/26/2020 04:53:40 PM
// Design Name: 
// Module Name: nvme_h2c_data_fetch
// Project Name: SSD Controller
// Target Devices: 
// Tool Versions: 
// Description: fetch data from host to card
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "nvme_param.vh"

module nvme_h2c_data_fetch#(
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
    input                        axis_h2c_tlast,   
    
    input  [23 : 0]              m_data_avail, // data available to write (left space)
    input                        m_axis_tready,
    output                       m_axis_tvalid,                        
    output [DATA_WIDTH-1 : 0]    m_axis_tdata,
    output [DATA_WIDTH/8-1:0]    m_axis_tkeep,
    output                       m_axis_tlast   
);

localparam
    DSC_IDLE  = 5'b00001,
    DSC_SUM   = 5'b00010,
    DSC_SLICE = 5'b00100,
    DSC_GEN   = 5'b01000,
    DSC_WAIT  = 5'b10000;

localparam TRAN_SIZE = `DMA_TRAN_SIZE;
    
reg    [4 : 0] dsc_state;

wire           fifo_full;
wire           fifo_prog_full;
wire           fifo_empty;
wire           fifo_wen;
wire [127 : 0] fifo_wdata;
wire           fifo_ren;
wire [127 : 0] fifo_rdata;
reg  [ 27 : 0] left_bytes;
reg  [ 27 : 0] sent_bytes;
reg  [ 27 : 0] dsc_len;
reg  [ 23 : 0] buf_pre_alloc_bytes; // due to descriptor 
reg  [ 23 : 0] buf_left_bytes;

assign axis_h2c_tready = m_axis_tready;
assign m_axis_tvalid = axis_h2c_tvalid;
assign m_axis_tdata = axis_h2c_tdata;
assign m_axis_tkeep = axis_h2c_tkeep;
assign m_axis_tlast = axis_h2c_tlast;


assign fifo_wen = o_cmd_ready & i_cmd_valid;
assign fifo_wdata = {i_cmd_id, i_data_len, i_host_addr};
assign o_cmd_ready = ~fifo_prog_full;

// descriptor FIFO to buffer dsc_len
nvme_data_cmd_fifo h2c_data_cmd_fifo (
  .clk      (clk             ),    // input wire clk
  .rst      (~rst_n          ),    // input wire srst
  .din      (fifo_wdata      ),    // input wire [127 : 0] din
  .wr_en    (fifo_wen        ),    // input wire wr_en
  .rd_en    (fifo_ren        ),    // input wire rd_en
  .dout     (fifo_rdata      ),    // output wire [127 : 0] dout
  .full     (fifo_full       ),    // output wire full
  .empty    (fifo_empty      ),    // output wire empty
  .prog_full(fifo_prog_full  )     // output wire prog_full
);

assign fifo_ren = (dsc_state == DSC_IDLE) && (~fifo_empty);

// record the remain buffer space used for DMA
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    buf_pre_alloc_bytes <= 24'h0;
end else if(((dsc_state == DSC_GEN) & h2c_dsc_byp_ready) & (m_axis_tready & m_axis_tvalid)) begin
    buf_pre_alloc_bytes <= buf_pre_alloc_bytes + dsc_len[23:0] - 24'h20;
end else if((dsc_state == DSC_GEN) & h2c_dsc_byp_ready) begin
    buf_pre_alloc_bytes <= buf_pre_alloc_bytes + dsc_len[23:0];
end else if(m_axis_tready & m_axis_tvalid) begin
    buf_pre_alloc_bytes <= buf_pre_alloc_bytes - 24'h20;
end

// m_data_avail: real-time left buffer space
// buf_left_bytes: consider the data DMA to tranfer
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    buf_left_bytes <= 24'h0;
end else begin
    buf_left_bytes <= m_data_avail - buf_pre_alloc_bytes;
end


// Descriptor submitting FSM
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    dsc_state <= DSC_IDLE;
    left_bytes <= 28'h0;
    sent_bytes <= 28'h0;
    dsc_len    <= 28'h0;
end else begin
    case(dsc_state)
        DSC_IDLE: begin
            if(~fifo_empty) begin
                dsc_state <= DSC_SUM;
            end
        end
        DSC_SUM : begin
            left_bytes <= fifo_rdata[91:64];
            sent_bytes <= 28'h0;
            dsc_state <= DSC_SLICE;
        end
        DSC_SLICE: begin
            if((left_bytes > TRAN_SIZE) && (buf_left_bytes >= TRAN_SIZE)) begin // external buffer has enough space
                dsc_state  <= DSC_GEN;
                dsc_len    <= TRAN_SIZE;
                left_bytes <= left_bytes - TRAN_SIZE;                 
            end else if((left_bytes <= TRAN_SIZE) && (buf_left_bytes >= left_bytes)) begin // external buffer has enough space
                dsc_state  <= DSC_GEN;
                dsc_len    <= left_bytes;
                left_bytes <= 28'h0; 
            end
        end
        DSC_GEN: begin
            if(h2c_dsc_byp_ready) begin
                dsc_state <= DSC_WAIT;
                sent_bytes <= sent_bytes + dsc_len;
            end
        end 
        DSC_WAIT: begin // wait buf_left_bytes update
            if(left_bytes == 28'h0) begin
                dsc_state <= DSC_IDLE;
            end else begin
                dsc_state <= DSC_SLICE;
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
end else if((dsc_state == DSC_GEN) && h2c_dsc_byp_ready) begin
    h2c_dsc_byp_load     <= 1'h1;
    h2c_dsc_byp_len      <= dsc_len;
    h2c_dsc_byp_src_addr <= fifo_rdata[63:0] + sent_bytes;
    h2c_dsc_byp_dst_addr <= 64'h0;
    h2c_dsc_byp_ctl      <= 16'h10;
end else begin
    h2c_dsc_byp_load     <= 1'h0;
//    h2c_dsc_byp_len      <= 28'h0;
//    h2c_dsc_byp_src_addr <= 64'h0;
//    h2c_dsc_byp_dst_addr <= 64'h0;
//    h2c_dsc_byp_ctl      <= 16'h0;
end


endmodule
