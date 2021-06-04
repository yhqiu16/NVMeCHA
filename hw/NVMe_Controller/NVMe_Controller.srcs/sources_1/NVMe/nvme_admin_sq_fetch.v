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
// Create Date: 03/24/2020 09:59:09 PM
// Design Name: 
// Module Name: nvme_admin_sq_fetch
// Project Name: SSD Controller
// Target Devices: 
// Tool Versions: 
// Description: fetch NVMe Admin SQ data
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module nvme_admin_sq_fetch #(
    parameter DATA_WIDTH     = 256
)(
    input                        clk,
    input                        rst_n,
    
    // host submission queu
    input      [63:0]            sq_base_addr,
    input      [15:0]            sq_size, // number of slots
    input      [15:0]            sq_tail, // slot index
    output reg [15:0]            sq_head, // slot index
    
    // H2C DMA descriptor
    input                        h2c_dsc_byp_ready,   
    output reg                   h2c_dsc_byp_load, 
    output reg [63 : 0]          h2c_dsc_byp_src_addr,   
    output reg [63 : 0]          h2c_dsc_byp_dst_addr,   
    output reg [27 : 0]          h2c_dsc_byp_len,   
    output reg [15 : 0]          h2c_dsc_byp_ctl,  
    
    // AXI ST interface to fetch cmd submission data
    output                       axis_h2c_tready,
    input                        axis_h2c_tvalid,
    input  [DATA_WIDTH-1:0]      axis_h2c_tdata,
    input  [DATA_WIDTH/8-1:0]    axis_h2c_tkeep,
    input                        axis_h2c_tlast,
    
    // PS-side
    output     [  7:0]           wr_ptr,
    // BRAM Ports, Read Only
    input                        bp_clk,
    input                        bp_rst,
    input                        bp_en,
    input      [ 15:0]           bp_we,
    input      [ 12:0]           bp_addr,
    input      [127:0]           bp_wrdata,
    output     [127:0]           bp_rddata    
);

localparam
    T_EMPTY_SLOT_BYTES = 28'h100, // 256B
    SQ_ADDR_WIDTH      = 9;
    

// SQ head and tail pointers 
//reg  [31 : 0]  sq_tail;
//reg  [31 : 0]  sq_head;


reg  [SQ_ADDR_WIDTH-1 : 0] sq_bram_dst_addr; // DMA DSC dst_addr
reg  [SQ_ADDR_WIDTH-1 : 0] sq_bram_waddr;  // DMA real-time writing address
reg  [SQ_ADDR_WIDTH-1 : 0] sq_bram_raddr;  // Reading address of sq data
wire [SQ_ADDR_WIDTH-1 : 0] sq_diff_rd_dst;  // raddr - dst_addr

wire         sq_bram_wen;
wire [255:0] sq_bram_wdata;

assign wr_ptr = sq_bram_waddr[SQ_ADDR_WIDTH-1 : 6]; // sq entry pointer

// Submission Queue data buffer in PL
pl_asq_bram pl_asq_bram (
  .clka (clk                             ),    // input wire clka
  .ena  (sq_bram_wen                     ),    // input wire ena
  .wea  (sq_bram_wen                     ),    // input wire [0 : 0] wea
  .addra(sq_bram_waddr[SQ_ADDR_WIDTH-1:5]),    // input wire [3 : 0] addra
  .dina (sq_bram_wdata                   ),    // input wire [255 : 0] dina
  .clkb (clk                             ),    // input wire clkb
  .enb  (bp_en                           ),    // input wire enb
  .addrb(bp_addr[SQ_ADDR_WIDTH-1:4]      ),    // input wire [4 : 0] addrb
  .doutb(bp_rddata                       )     // output wire [127 : 0] doutb
);

// sq bram write ports
// always have buffer space guaranteeing by the control of H2C DMA descriptors submitting
assign axis_h2c_tready = 1'b1;
assign sq_bram_wen     = axis_h2c_tready &axis_h2c_tvalid;
assign sq_bram_wdata   = axis_h2c_tdata;

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    sq_bram_waddr <= {SQ_ADDR_WIDTH{1'h0}};
end else if(axis_h2c_tready & axis_h2c_tvalid) begin
    sq_bram_waddr <= sq_bram_waddr + 32;
end


// SQ Data Fetching FSM
//     loop fetching:
//     1. fetch all new sq data if having enough buffer space (empty slots)
//     2. fetch left sq data if having enough buffer space (< FIFO_EMPTY_THRESHOLD)
//        or FIFO_EMPTY_THRESHOLD empty slots
//     3. fetch by multiple times if sq_tail < sq_head

localparam
    SQ_IDLE  = 1'h0,
    SQ_FETCH = 1'h1;

reg  [ 0 : 0] sq_state;
reg  [15 : 0] sq_diff_tail_head;
//reg  [31 : 0] sq_left_bytes;
reg  [27 : 0] sq_dsc_len;
reg  [16 : 0] sq_head_tmp;

//assign sq_diff_tail_head = (sq_tail >= sq_head) ? (sq_tail - sq_head): (sq_size - sq_head); 
assign sq_diff_rd_dst = sq_bram_raddr - sq_bram_dst_addr - 'h40; // sum - 1

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    sq_state      <= SQ_IDLE;
    sq_dsc_len    <= 28'h0;
    sq_head_tmp   <= 17'h0;
//    sq_left_bytes <= 32'h0;   
end else begin
    case(sq_state)
        SQ_IDLE: begin
            if((sq_diff_tail_head > 0) && (sq_diff_tail_head <= (sq_diff_rd_dst >> 6))) begin // have enough buffer space for all sq data
                sq_state      <= SQ_FETCH;
                sq_dsc_len    <= {sq_diff_tail_head, 6'h0};
                sq_head_tmp   <= sq_head + sq_diff_tail_head;
//                sq_left_bytes <= 32'h0;
            end else if((sq_diff_tail_head > 0) && (sq_diff_rd_dst >= T_EMPTY_SLOT_BYTES)) begin // have at least T_EMPTY_SLOT_BYTES
                sq_state      <= SQ_FETCH;
                sq_dsc_len    <= T_EMPTY_SLOT_BYTES;
                sq_head_tmp   <= sq_head + (T_EMPTY_SLOT_BYTES >> 6);
//                sq_left_bytes <= sq_diff_tail_head - T_EMPTY_SLOT_BYTES;
            end
        end
        SQ_FETCH: begin
            if(h2c_dsc_byp_ready) begin
                sq_state <= SQ_IDLE;
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
end else if((sq_state == SQ_FETCH) && h2c_dsc_byp_ready) begin
    h2c_dsc_byp_load     <= 1'h1;
    h2c_dsc_byp_len      <= sq_dsc_len;
    h2c_dsc_byp_src_addr <= sq_base_addr + {sq_head, 6'h0};
    h2c_dsc_byp_dst_addr <= 64'h0;
    h2c_dsc_byp_ctl      <= 16'h10;
end else begin
    h2c_dsc_byp_load     <= 1'h0;
//    h2c_dsc_byp_len      <= 28'h0;
//    h2c_dsc_byp_src_addr <= 64'h0;
//    h2c_dsc_byp_dst_addr <= 64'h0;
//    h2c_dsc_byp_ctl      <= 16'h0;
end

//wire [16:0] sq_head_tmp;
//assign sq_head_tmp = sq_head + (sq_dsc_len >> 6);

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    sq_head <= 16'h0;
end else if((sq_state == SQ_FETCH) && h2c_dsc_byp_ready) begin
    sq_head <= (sq_head_tmp < sq_size)? sq_head_tmp : (sq_head_tmp - sq_size);
end


// sq_diff_tail_head = (sq_tail >= sq_head_new) ? (sq_tail - sq_head_new): (sq_size - sq_head_new);
// Case 1: sq_head_tmp >= sq_size
//     sq_diff_tail_head <= sq_tail + sq_size - sq_head_tmp
// Case 2: sq_head_tmp <= sq_tail
//     sq_diff_tail_head <= sq_tail - sq_head_tmp
// Case 3: sq_head_tmp > sq_tail
//     sq_diff_tail_head <= sq_size - sq_head_tmp

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    sq_diff_tail_head <= 16'h0;
end else if(sq_head_tmp >= sq_size) begin
    sq_diff_tail_head <= sq_tail + sq_size - sq_head_tmp;
end else if(sq_head_tmp <= sq_tail) begin
    sq_diff_tail_head <= sq_tail - sq_head_tmp;
end else begin
    sq_diff_tail_head <= sq_size - sq_head_tmp;
end

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    sq_bram_dst_addr <= 'h0;
end else if((sq_state == SQ_FETCH) && h2c_dsc_byp_ready) begin
    sq_bram_dst_addr <= sq_bram_dst_addr + sq_dsc_len;
end


// SQ BRAM READ PORTS

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    sq_bram_raddr <= 'h0;
end else if(bp_en) begin
    sq_bram_raddr <= bp_addr;
end




endmodule
