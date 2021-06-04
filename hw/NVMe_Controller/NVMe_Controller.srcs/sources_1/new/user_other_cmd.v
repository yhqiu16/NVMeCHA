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
// Create Date: 10/13/2020 03:17:28 PM
// Design Name: 
// Module Name: user_other_cmd
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


module user_other_cmd(
    input                          clk,
    input                          rst_n,

    output                         o_req_ready,
    input                          i_req_valid,
    input      [15:0]              i_req_id,
    
    input                          i_res_ready,
    output reg                     o_res_valid,
    output reg [79:0]              o_res_data
);


localparam
    IDLE     = 1'd0,
    RES      = 1'd1;

    
reg [ 0:0] state; 

assign o_req_ready = (state == IDLE);   


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    state        <= IDLE;
    o_res_valid  <= 1'h0;
    o_res_data   <= 80'h0;
end else begin
    case(state) 
        IDLE: begin
            if(i_req_valid) begin
                state <= RES;
                o_res_valid  <= 1'h1;    
                o_res_data   <= {i_req_id, 64'h0};
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
