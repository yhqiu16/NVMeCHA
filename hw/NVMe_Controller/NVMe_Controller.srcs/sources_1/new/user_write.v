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
// Create Date: 10/13/2020 11:30:19 AM
// Design Name: 
// Module Name: user_write
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


module user_write#(
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
 
    output     [23:0]              o_data_avail,
    output                         o_axis_ready,
    input                          i_axis_valid,
    input  [DATA_WIDTH-1 : 0]      i_axis_data,
    input                          i_axis_last
);
    

localparam
    TRAN_SIZE = `DMA_TRAN_SIZE,
    DATA_BYTE = DATA_WIDTH >> 3;
    

localparam
    IDLE     = 2'd0,
    DATA     = 2'd1,
    RES      = 2'd2;

    
reg [ 1:0] state;
reg [23:0] data_cnt; 
reg [23:0] req_len_r;
reg [15:0] req_id_r;

assign o_req_ready = (state == IDLE);   
assign o_data_avail = 24'h4000; 


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    state        <= IDLE;
    o_res_valid  <= 1'h0;
    o_res_data   <= 80'h0;
    req_len_r    <= 24'h0;
    req_id_r     <= 16'h0;
end else begin
    case(state) 
        IDLE: begin
            if(i_req_valid) begin
                state     <= DATA;
                req_len_r <= i_req_len;
                req_id_r  <= i_req_id;
            end          
        end                
        
        DATA: begin
            if(data_cnt + DATA_BYTE >= req_len_r) begin
                state        <= RES;     
                o_res_valid  <= 1'h1;    
                o_res_data   <= {req_id_r, 64'h0};
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
    

assign o_axis_ready = (state == DATA); 

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    data_cnt <= 24'h0;
end else if(state == RES) begin
    data_cnt <= 24'h0;
end else if(o_axis_ready & i_axis_valid) begin
    data_cnt <= data_cnt + DATA_BYTE;
end


// use a buffer to retain axis data
user_write_buf user_write_buf (
  .clka (clk                        ),  // input wire clka
  .ena  (1'b1                       ),  // input wire ena
  .wea  (o_axis_ready & i_axis_valid),  // input wire [0 : 0] wea
  .addra(1'b0                       ),  // input wire [0 : 0] addra
  .dina ({i_axis_last, i_axis_data} ),  // input wire [256 : 0] dina
  .douta(                           )   // output wire [256 : 0] douta
);
    
    
endmodule
