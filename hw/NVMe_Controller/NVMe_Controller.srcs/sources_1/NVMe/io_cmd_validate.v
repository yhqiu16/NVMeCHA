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
// Create Date: 11/18/2020 08:05:05 PM
// Design Name: 
// Module Name: io_cmd_validate
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: validate the received IO Commands 
//              if valid, send to other modules for command processing
//              otherwise, generate CQ entry directly
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
// SQ Entry Format
// Dword 0   : [ 7 : 0]  OPC, Opcode
//             [ 9 : 8]  FUSE, fused operation
//             [15 : 14] PSDT, PRP or SGL for Data Transfer
//             [31 : 16] CID, Command ID            
// Dword 1   : [31 : 0]  NSID, Namespace Identifier
// Dword 2-3 : [63 : 0]  RESERVED
// Dword 4-5 : [63 : 0]  MPTR, metadata pointer
// Dword 6-9 :           DPTR, Data Pointer
//             [63 : 0]  PRP1, PRP Entry 1
//             [127:64]  PRP2, PRP Entry 2
//        or   [127:0]   SGL1, SGL Entry 1
// Dword 10-15:          Command Specific

// CQ Entry Format
// Dword 0   : [31 : 0]  command specific
// Dword 1   : [31 : 0]  reserved
// Dword 2   : [31 : 16] SQ ID
//             [15 : 0]  SQ Head Pointer
// Dword 3   : [31 : 17] status field
//             [16]      phase tag
//             [15 : 0]  CID, Command ID

`include "nvme_param.vh"

module io_cmd_validate(
    input                        clk,
    input                        rst_n,
    
    // SQ entry
    output                       o_req_ready,
    input                        i_req_valid,
    input      [511 : 0]         i_req_data, // SQ entry
    
    // valid SQ entry
    input                        i_val_req_ready,
    output reg                   o_val_req_valid,
    output reg [511 : 0]         o_val_req_data,
    
    // respond to CQ
    input                        i_res_ready,
    output reg                   o_res_valid,
    output reg [127 : 0]         o_res_data
 );
 
 
 localparam
    IDLE      = 2'h0,
    CHECK     = 2'h1,
    REQ_OUT   = 2'h2,
    RES_OUT   = 2'h3;
    
reg  [1:0] state;
reg        bypass_sqe; // directly generate CQ

reg  [2:0] sts_code_type;
reg  [7:0] sts_code;

wire [ 7:0] opc;
wire [ 1:0] psdt;
wire [63:0] prp1;
wire [63:0] prp2;

reg  [511:0] req_data_reg;
wire  [15:0] cid_dly;

assign opc  = i_req_data[7:0];
assign psdt = i_req_data[15:14];
//assign cid  = i_req_data[31:16];
assign prp1 = i_req_data[255:192];
assign prp2 = i_req_data[319:256];
 
assign o_req_ready = (state == IDLE);
 
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    state <= IDLE;
end else begin
    case(state)
        IDLE: begin
            if(i_req_valid) begin
                state <= CHECK;
            end
        end
        CHECK: begin
            if(bypass_sqe) begin
                state <= RES_OUT;
            end else begin
                state <= REQ_OUT;
            end
        end
        REQ_OUT: begin
            if(i_val_req_ready) begin
                state <= IDLE;
            end
        end
        RES_OUT: begin
            if(i_res_ready) begin
                state <= IDLE;
            end
        end
    endcase
end 



always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    req_data_reg <= 512'h0;
end else if(i_req_valid) begin
    req_data_reg <= i_req_data;
end

assign cid_dly  = i_req_data[31:16];

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    bypass_sqe    <= 1'h0;
    sts_code_type <= 3'h0;
    sts_code      <= 8'h0;
end else if(i_req_valid & (opc != `NVME_FLUSH) && (opc != `NVME_WRITE) && (opc != `NVME_READ)) begin // unsupported command
    bypass_sqe    <= 1'h1;
    sts_code_type <= 3'h0;
    sts_code      <= 8'h1;
end else if(i_req_valid & (opc == `NVME_FLUSH)) begin // complete successfully
    bypass_sqe    <= 1'h1;
    sts_code_type <= 3'h0;
    sts_code      <= 8'h0;
end else if(i_req_valid & (psdt != 2'h0)) begin // invalid field in command
    bypass_sqe    <= 1'h1;
    sts_code_type <= 3'h0;
    sts_code      <= 8'h2;
end else if(i_req_valid & ((prp1[1:0] | prp2[1:0]) != 2'h0)) begin // PRP Offset invalid
    bypass_sqe    <= 1'h1;
    sts_code_type <= 3'h0;
    sts_code      <= 8'h13; 
end else if(i_req_valid) begin
    bypass_sqe    <= 1'h0;
    sts_code_type <= 3'h0;
    sts_code      <= 8'h0;
end


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    o_res_valid <= 1'h0;
    o_res_data  <= 128'h0;
end else if((state == CHECK) & bypass_sqe) begin
    o_res_valid <= 1'h1;
    o_res_data  <= {4'h0, sts_code_type, sts_code, 1'h0, cid_dly, 96'h0};
end else if((state == RES_OUT) & i_res_ready) begin
    o_res_valid <= 1'h0;
//    o_res_data <= 128'h0;
end


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    o_val_req_valid <= 1'h0;
    o_val_req_data  <= 512'h0;
end else if((state == CHECK) & (~bypass_sqe)) begin
    o_val_req_valid <= 1'h1;
    o_val_req_data  <= req_data_reg;
end else if((state == REQ_OUT) & i_val_req_ready) begin
    o_val_req_valid <= 1'h0;
//    o_val_req_data  <= 512'h0;
end 


 
endmodule
