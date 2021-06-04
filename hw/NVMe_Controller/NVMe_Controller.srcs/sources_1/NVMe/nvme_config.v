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
// Create Date: 10/26/2020 02:01:01 PM
// Design Name: 
// Module Name: nvme_config
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: NVMe Controller Configuration
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module nvme_config(
    input            clk,
    input            nvme_reg_cc_en,    
//    input            pl_rdy,
    input            ps_rdy,
    output reg       nvme_reg_csts_rdy,
    output reg       pl_reset,
    input      [1:0] nvme_reg_cc_shn,
//    input      [1:0] pl_shst,
    input      [1:0] ps_shst,
    output reg [1:0] nvme_reg_csts_shst
);


localparam
    DISABLE = 3'h0,
    DIS2EN  = 3'h1,
    ENABLE  = 3'h2,
    EN2DIS  = 3'h3,
    SHN     = 3'h4,
    SHNRESET= 3'h5,
    SHST    = 3'h6,
    MAX_CNT_NUM = 16'h200;

reg  [2:0] state = DISABLE;
reg [15:0] cnt;


always@(posedge clk)
begin
    case(state)
        DISABLE: begin
            cnt      <= 16'h0;
            pl_reset <= 1'h0;
            nvme_reg_csts_rdy  <= 1'h0;
            nvme_reg_csts_shst <= 2'h0;
            if(nvme_reg_cc_en) begin
                state <= DIS2EN;
            end else begin
                state <= DISABLE;
            end
        end
        DIS2EN: begin
//            if(pl_rdy & ps_rdy) begin
            if(ps_rdy) begin
                nvme_reg_csts_rdy <= 1'h1;
                state <= ENABLE;
            end
        end
        ENABLE: begin
            if(~nvme_reg_cc_en) begin
                pl_reset <= 1'h1;
                state <= EN2DIS;
            end else if(nvme_reg_cc_shn != 2'h0) begin
                state <= SHN;
                nvme_reg_csts_shst <= 2'h1;
            end
        end
        SHN: begin
//            if((pl_shst == 2'h2) && (ps_shst == 2'h2)) begin
            if(ps_shst == 2'h2) begin
                state <= SHNRESET;
                nvme_reg_csts_shst <= 2'h2;
                pl_reset <= 1'h1;
                cnt      <= 16'h0;
            end
        end
        SHNRESET: begin
            if(cnt >= MAX_CNT_NUM) begin
                state <= SHST;
                cnt   <= 16'h0;
            end else begin
                state <= SHNRESET;
                cnt   <= cnt + 16'h1;
            end
        end
        SHST: begin
            pl_reset <= 1'h0;
            if(~nvme_reg_cc_en) begin
//                pl_reset <= 1'h1;
                state <= EN2DIS;
                nvme_reg_csts_shst <= 2'h0;
            end
        end
        EN2DIS: begin
//            if(~(pl_rdy | ps_rdy)) begin
            if(~ps_rdy) begin
                pl_reset <= 1'h0;
                nvme_reg_csts_rdy <= 1'h0;
                state <= DISABLE;
            end
        end
    endcase
end





endmodule
