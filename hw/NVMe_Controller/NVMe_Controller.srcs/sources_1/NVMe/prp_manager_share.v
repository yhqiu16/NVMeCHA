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
// Create Date: 11/18/2020 04:50:40 PM
// Design Name: 
// Module Name: prp_manager_share
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Shared PRP Manager among Read/Write Operation
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "nvme_param.vh"

module prp_manager_share#(
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
    // output for Read OPC
    input                        i_rd_ready,
    output reg                   o_rd_valid,
    output reg [63:0]            o_rd_host_addr, // data addr in host memory
    output reg [31:0]            o_rd_data_len,  // transfer length of data
    output reg [15:0]            o_rd_cid,       // command id
//    output reg [ 3:0]            o_rd_type,      // cmd type
    output reg                   o_rd_last,      // last command in a group
    // output for Write OPC
    input                        i_wr_ready,
    output reg                   o_wr_valid,
    output reg [63:0]            o_wr_host_addr, // data addr in host memory
    output reg [31:0]            o_wr_data_len,  // transfer length of data
    output reg [15:0]            o_wr_cid,       // command id
    output reg                   o_wr_last,      // last command in a group
    // H2C DMA descriptor
    input                        h2c_dsc_byp_ready,   
    output                       h2c_dsc_byp_load, 
    output     [63 : 0]          h2c_dsc_byp_src_addr,   
    output     [63 : 0]          h2c_dsc_byp_dst_addr,   
    output     [27 : 0]          h2c_dsc_byp_len,   
    output     [15 : 0]          h2c_dsc_byp_ctl,
    
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
    LEN       = 3'h2,
    ADDR      = 3'h3,
    WAIT      = 3'h4,
    CHECK     = 3'h5;
    
reg  [ 2:0] state;
reg  [ 2:0] last_state;


wire         prp_fifo_ren;
wire [ 63:0] prp_fifo_rdata;
wire         prp_fifo_empty;

reg  [  7:0] opc;
reg  [ 15:0] cid;
reg  [ 15:0] left_num;
reg  [ 31:0] start_len;
reg  [ 31:0] last_len;

prp_manager prp_manager(
    .clk                  (clk                 ),
    .rst_n                (rst_n               ),
    .o_req_ready          (o_req_ready         ),
    .i_req_valid          (i_req_valid         ),
    .i_req_opc            (i_req_opc           ),
    .i_req_cid            (i_req_cid           ),
    .i_req_dptr           (i_req_dptr          ),
    .i_req_nlb            (i_req_nlb           ),
    .mps_width            (mps_width           ),
    .lbads_width          (lbads_width         ),
    .prp_fifo_ren         (prp_fifo_ren        ),
    .prp_fifo_rdata       (prp_fifo_rdata      ),
    .prp_fifo_empty       (prp_fifo_empty      ),
    .h2c_dsc_byp_ready    (h2c_dsc_byp_ready   ),
    .h2c_dsc_byp_load     (h2c_dsc_byp_load    ),
    .h2c_dsc_byp_src_addr (h2c_dsc_byp_src_addr),
    .h2c_dsc_byp_dst_addr (h2c_dsc_byp_dst_addr),
    .h2c_dsc_byp_len      (h2c_dsc_byp_len     ),
    .h2c_dsc_byp_ctl      (h2c_dsc_byp_ctl     ),
    .axis_h2c_tready      (axis_h2c_tready     ),
    .axis_h2c_tvalid      (axis_h2c_tvalid     ),
    .axis_h2c_tdata       (axis_h2c_tdata      ),
    .axis_h2c_tkeep       (axis_h2c_tkeep      ),
    .axis_h2c_tlast       (axis_h2c_tlast      )
);


assign prp_fifo_ren = (~prp_fifo_empty) & ((state == IDLE) || (state == HEADER) || (state == LEN) || ((state == CHECK) & (left_num > 16'h0)));

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    state    <= IDLE;
    left_num <= 16'h0;
    opc      <= 8'h0;
end else begin
    case(state)
        IDLE: begin
            if(~prp_fifo_empty) begin
                state <= HEADER;
            end     
        end
        HEADER: begin
            if(~prp_fifo_empty) begin
                state    <= LEN; 
                left_num <= prp_fifo_rdata[15:0];
                opc      <= prp_fifo_rdata[39:32];
            end
        end
        LEN: begin
            if(~prp_fifo_empty) begin
                state <= ADDR; 
            end
        end
        ADDR: begin
                state    <= WAIT; 
                left_num <= left_num - 16'h1;
        end
        WAIT: begin
            if(((opc == `NVME_WRITE) && (i_wr_ready & o_wr_valid)) ||
               ((opc == `NVME_READ) && (i_rd_ready & o_rd_valid))) begin
                state <= CHECK;
            end     
        end
        CHECK: begin
            if(left_num == 16'h0) begin
                state <= IDLE;
            end else if(~prp_fifo_empty) begin
                state <= ADDR;
            end    
        end
    endcase
end


always@(posedge clk) last_state <= state;

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    cid <= 16'h0;
end else if(state == HEADER) begin
    cid <= prp_fifo_rdata[31:16];
end


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    start_len <= 32'h0;
    last_len  <= 32'h0;
end else if(state == LEN) begin
    start_len <= prp_fifo_rdata[31:0];
    last_len  <= prp_fifo_rdata[63:32];
end


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    o_wr_valid     <= 1'h0;
    o_wr_host_addr <= 64'h0;
    o_wr_cid       <= 16'h0;
    o_wr_last      <= 1'h0;
end else if((state == ADDR) && (opc == `NVME_WRITE))begin
    o_wr_valid     <= 1'h1;
    o_wr_host_addr <= prp_fifo_rdata[63:0];
    o_wr_cid       <= cid;
    o_wr_last      <= (left_num == 16'h1)? 1'h1 : 1'h0;
end else if((state == WAIT) && (i_wr_ready & o_wr_valid)) begin
    o_wr_valid     <= 1'h0;
//    o_wr_host_addr <= prp_fifo_rdata[63:0];
//    o_wr_cid       <= cid;
end


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    o_wr_data_len <= 32'h0;
end else if((state == ADDR) && (opc == `NVME_WRITE) && (last_state == LEN))begin
    o_wr_data_len <= start_len;
end else if((state == ADDR) && (opc == `NVME_WRITE) && (left_num == 16'h1))begin
    o_wr_data_len <= last_len;
end else if((state == ADDR) && (opc == `NVME_WRITE))begin
    o_wr_data_len <= 1 << mps_width;
//end else if((state == WAIT) && i_wr_ready) begin
//    o_wr_data_len <= 32'h0;
end



always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    o_rd_valid     <= 1'h0;
    o_rd_host_addr <= 64'h0;
    o_rd_cid       <= 16'h0;
    o_rd_last      <= 1'h0;
end else if((state == ADDR) && (opc == `NVME_READ))begin
    o_rd_valid     <= 1'h1;
    o_rd_host_addr <= prp_fifo_rdata[63:0];
    o_rd_cid       <= cid;
    o_rd_last      <= (left_num == 16'h1)? 1'h1 : 1'h0;
end else if((state == WAIT) && (i_rd_ready & o_rd_valid)) begin
    o_rd_valid     <= 1'h0;
//    o_rd_host_addr <= prp_fifo_rdata[63:0];
//    o_rd_cid       <= cid;
end


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    o_rd_data_len <= 32'h0;
end else if((state == ADDR) && (opc == `NVME_READ) && (last_state == LEN))begin
    o_rd_data_len <= start_len;
end else if((state == ADDR) && (opc == `NVME_READ) && (left_num == 16'h1))begin
    o_rd_data_len <= last_len;
end else if((state == ADDR) && (opc == `NVME_READ))begin
    o_rd_data_len <= 1 << mps_width;
//end else if((state == WAIT) && i_rd_ready) begin
//    o_rd_data_len <= 32'h0;
end


endmodule
