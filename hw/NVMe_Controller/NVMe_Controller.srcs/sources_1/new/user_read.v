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
// Create Date: 10/13/2020 11:29:55 AM
// Design Name: 
// Module Name: user_read
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Response Entry Format
// Dword 0-1 : [63 : 0]  command specific
// Dword 2   : [15 : 0]  CID, Command ID

module user_read#(
    parameter DATA_WIDTH = 256
)(
    input                          clk,
    input                          rst_n,
    
    output                         o_req_ready,
    input                          i_req_valid,
    input      [23:0]              i_req_len, // transfer data length in bytes
    input      [15:0]              i_req_id,
    
    input                          i_res_ready,
    output reg                     o_res_valid,
    output reg [79:0]              o_res_data,
    
    input                          i_axis_ready,
    output reg                     o_axis_valid,
    output reg [DATA_WIDTH-1 : 0]  o_axis_data,
    output reg [15:0]              o_axis_id,
    output reg                     o_axis_last
);


localparam
    TRAN_SIZE = `DMA_TRAN_SIZE,
    DATA_BYTE = DATA_WIDTH >> 3;
    

localparam
    IDLE     = 2'd0,
    DATA     = 2'd1,
    DATA_FIN = 2'd2,
    RES      = 2'd3;

    
reg [ 1:0] state;
reg [23:0] g_rest_len; // global reset length
reg [23:0] rest_len;   // rest length of a axis transfer

assign o_req_ready = (state == IDLE);


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    state        <= IDLE;
    o_res_valid  <= 1'h0;
    o_res_data   <= 80'h0;
    rest_len     <= 24'h0;
    g_rest_len   <= 24'h0;
    o_axis_valid <= 1'b0;
    o_axis_data  <= {(DATA_WIDTH){1'b0}};
    o_axis_id    <= 16'h0;
    o_axis_last  <= 1'b0;
end else begin
    case(state) 
        IDLE: begin
            if(i_req_valid) begin
                state        <= DATA;
                o_axis_valid <= 1'b1;
                o_axis_id    <= i_req_id;
                o_axis_data[31:0]    <= 32'h0;  
                o_axis_data[63:32]   <= 32'h1; 
                o_axis_data[95:64]   <= 32'h2;
                o_axis_data[127:96]  <= 32'h3;
                o_axis_data[159:128] <= 32'h4; 
                o_axis_data[191:160] <= 32'h5;
                o_axis_data[223:192] <= 32'h6;
                o_axis_data[255:224] <= 32'h7;     
                rest_len   <= (i_req_len > TRAN_SIZE)? (TRAN_SIZE - DATA_BYTE) : (i_req_len - DATA_BYTE); 
                g_rest_len <= (i_req_len > TRAN_SIZE)? (i_req_len - TRAN_SIZE) : 0;
            end          
        end                
        
        DATA: begin
            if(i_axis_ready & o_axis_valid) begin
                o_axis_valid <= 1'b1;
                o_axis_data[31:0]    <= o_axis_data[31:0]    + 32'h8;  
                o_axis_data[63:32]   <= o_axis_data[63:32]   + 32'h8; 
                o_axis_data[95:64]   <= o_axis_data[95:64]   + 32'h8;
                o_axis_data[127:96]  <= o_axis_data[127:96]  + 32'h8;
                o_axis_data[159:128] <= o_axis_data[159:128] + 32'h8; 
                o_axis_data[191:160] <= o_axis_data[191:160] + 32'h8;
                o_axis_data[223:192] <= o_axis_data[223:192] + 32'h8;
                o_axis_data[255:224] <= o_axis_data[255:224] + 32'h8; 
                rest_len <= rest_len - DATA_BYTE;          
                if(rest_len <= DATA_BYTE) begin
                    state        <= DATA_FIN;
                    o_axis_last  <= 1'b1;
                end 
            end            
        end
        
        DATA_FIN: begin
            if(i_axis_ready & o_axis_valid & (g_rest_len == 0)) begin
                o_axis_valid <= 1'b0;
                o_axis_data  <= {(DATA_WIDTH){1'b0}};
                o_axis_last  <= 1'b0;   
                state        <= RES;
                o_res_valid  <= 1'h1;
    			o_res_data   <= {o_axis_id, 64'h0};
            end else if(i_axis_ready & o_axis_valid) begin
                o_axis_valid <= 1'b1;
                o_axis_data[31:0]    <= o_axis_data[31:0]    + 32'h8;  
                o_axis_data[63:32]   <= o_axis_data[63:32]   + 32'h8; 
                o_axis_data[95:64]   <= o_axis_data[95:64]   + 32'h8;
                o_axis_data[127:96]  <= o_axis_data[127:96]  + 32'h8;
                o_axis_data[159:128] <= o_axis_data[159:128] + 32'h8; 
                o_axis_data[191:160] <= o_axis_data[191:160] + 32'h8;
                o_axis_data[223:192] <= o_axis_data[223:192] + 32'h8;
                o_axis_data[255:224] <= o_axis_data[255:224] + 32'h8; 
                o_axis_last  <= 1'b0;   
                state        <= DATA;
                rest_len     <= (g_rest_len > TRAN_SIZE)? (TRAN_SIZE - DATA_BYTE) : (g_rest_len - DATA_BYTE); 
                g_rest_len   <= (g_rest_len > TRAN_SIZE)? (g_rest_len - TRAN_SIZE) : 0;
            end
        end

        RES: begin
            if(o_res_valid & i_res_ready) begin
                state       <= IDLE;
                o_res_valid <= 1'h0;
            end
        end        
    endcase
end






endmodule
