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
// Create Date: 12/14/2020 03:01:16 PM
// Design Name: 
// Module Name: interrupt_ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: interrupt controller
//              control interrupt according to different interrupt types
//              MSI-X, MSI, Legacy
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module interrupt_ctrl#(
    parameter IRQ_NUM = 16  // 
)(
    input                    clk,
    input                    rst_n,   
    input                    msix_enable,
    input                    msi_enable,
    input      [2:0]         msi_vector_width,
//    input      [15:0]        cq_head_0,
//    input      [15:0]        cq_head_1,
//    input      [15:0]        cq_head_2,
//    input      [15:0]        cq_head_3,
//    input      [15:0]        cq_head_4,
//    input      [15:0]        cq_head_5,
//    input      [15:0]        cq_head_6,
//    input      [15:0]        cq_head_7,
//    input      [15:0]        cq_head_8,
//    input      [15:0]        cq_head_9,
//    input      [15:0]        cq_head_10,
//    input      [15:0]        cq_head_11,
//    input      [15:0]        cq_head_12,
//    input      [15:0]        cq_head_13,
//    input      [15:0]        cq_head_14,
//    input      [15:0]        cq_head_15,
//    input      [15:0]        cq_head_16,
    input      [IRQ_NUM-1:0] irq_mask, // not MSI-X
    output reg [IRQ_NUM-1:0] xdma_irq_req,
    input      [IRQ_NUM-1:0] xdma_irq_ack,  
    output reg [IRQ_NUM-1:0] usr_irq_enable,  
    input      [IRQ_NUM-1:0] usr_irq_req,
    output reg [IRQ_NUM-1:0] usr_irq_ack
);

//wire [15:0] cq_head [15:0];
//reg  [15:0] cq_head_old [15:0];

//assign cq_head[0]  = cq_head_0;
//assign cq_head[1]  = cq_head_1;
//assign cq_head[2]  = cq_head_2;
//assign cq_head[3]  = cq_head_3;
//assign cq_head[4]  = cq_head_4;
//assign cq_head[5]  = cq_head_5;
//assign cq_head[6]  = cq_head_6;
//assign cq_head[7]  = cq_head_7;
//assign cq_head[8]  = cq_head_8;
//assign cq_head[9]  = cq_head_9;
//assign cq_head[10] = cq_head_10;
//assign cq_head[11] = cq_head_11;
//assign cq_head[12] = cq_head_12;
//assign cq_head[13] = cq_head_13;
//assign cq_head[14] = cq_head_14;
//assign cq_head[15] = cq_head_15;

localparam
    IDLE   = 3'h0,    
    ACK    = 3'h1,
    CLEAR  = 3'h2,
//    FIN    = 2'h3,
    MASK   = 3'h3,
    UNMASK = 3'h4;
    
reg  [2:0] state [IRQ_NUM-1:0];   
//reg  [7:0] cnt [IRQ_NUM-1:0];  
//reg        flag_acq;

always@(posedge clk)
if(~rst_n) begin
    usr_irq_enable <= {IRQ_NUM{1'b0}};
end else if(msix_enable) begin 
    usr_irq_enable <= {IRQ_NUM{1'b1}};
end else if(msi_enable) begin // MSI
    usr_irq_enable <= ~irq_mask;
end else begin
    usr_irq_enable <= {IRQ_NUM{1'b0}};
end


genvar i;
generate for(i = 0; i < IRQ_NUM; i = i + 1) begin: irq_gen
    always@(posedge clk)
    if(~rst_n) begin
        state[i]        <= IDLE;
        xdma_irq_req[i] <= 1'b0;
        usr_irq_ack[i]  <= 1'b0; 
//        cq_head_old[i]  <= 16'h0;
//        cnt[i]          <= 8'h0;
    end else begin
        case(state[i])
            IDLE: begin
                usr_irq_ack[i]  <= 1'b0;
//                cnt[i]          <= 8'h0;
                if((msix_enable | msi_enable) & usr_irq_req[i]) begin
                    state[i]        <= ACK;
                    xdma_irq_req[i] <= 1'b1;                         
                end
            end
            ACK: begin
                if(xdma_irq_ack[i] & msix_enable) begin
                    state[i]        <= CLEAR;  
                    xdma_irq_req[i] <= 1'b0;
                    usr_irq_ack[i]  <= 1'b1;     
//                    cq_head_old[i]  <= cq_head[i]; 
                end else if(xdma_irq_ack[i] & msi_enable) begin
                    state[i]        <= MASK;  
                    xdma_irq_req[i] <= 1'b1;
                    usr_irq_ack[i]  <= 1'b0;      
                end 
            end           
            CLEAR: begin
                    state[i]        <= IDLE;
                    usr_irq_ack[i]  <= 1'b0; 
//                if(cnt[i] < 8'h20) begin
//                    cnt[i]          <= cnt[i] + 8'h1;
//                    state[i]        <= CLEAR; 
//                end else begin
//                    cnt[i]          <= 8'h0;
//                    state[i]        <= FIN; 
//                    xdma_irq_req[i] <= 1'b0;
//                    usr_irq_ack[i]  <= 1'b1; 
//                end
            end
            MASK: begin
                if(irq_mask[i]) begin
                    state[i]        <= UNMASK;
                    xdma_irq_req[i] <= 1'b0;
                    usr_irq_ack[i]  <= 1'b1;            
                end
            end 
            UNMASK: begin
                usr_irq_ack[i]  <= 1'b0; 
                if(~irq_mask[i]) begin
                    state[i]        <= IDLE;
                end
            end
//            FIN: begin
//                    usr_irq_ack[i]  <= 1'b0; 
//                    if(cq_head_old[i] != cq_head[i])  begin // CQ Head Doorbell updated
//                        state[i]    <= IDLE;
//                    end 
//            end
        endcase
    end
end
endgenerate

//always@(posedge clk or negedge rst_n)
//if(~rst_n) begin
//    usr_irq_enable <= {IRQ_NUM{1'b0}};
//end else begin 
//    usr_irq_enable <= {IRQ_NUM{1'b1}};
//end

//genvar i;
//generate for(i = 0; i < IRQ_NUM; i = i + 1) begin: irq_gen
//    always@(posedge clk)
//    if(~rst_n) begin
//        state[i]        <= IDLE;
//        xdma_irq_req[i] <= 1'b0;
//        usr_irq_ack[i]  <= 1'b0; 
//    end else begin
//        case(state[i])
//            IDLE: begin
//                if((msix_enable | msi_enable) & usr_irq_req[i]) begin
//                    state[i]        <= ACK;
//                    xdma_irq_req[i] <= 1'b1;
//                    usr_irq_ack[i]  <= 1'b0;
////                end else if(msi_enable & usr_irq_req[i]) begin
////                    state[i]        <= MASK;
////                    xdma_irq_req[i] <= 1'b1;
////                    usr_irq_ack[i]  <= 1'b0;
//                end
//            end
//            ACK: begin
//                if(xdma_irq_ack[i] & msix_enable) begin
//                    state[i]        <= FIN;  
//                    xdma_irq_req[i] <= 1'b0;
//                    usr_irq_ack[i]  <= 1'b1;       
//                end else if(xdma_irq_ack[i] & msi_enable) begin
//                    state[i]        <= MASK;  
//                    xdma_irq_req[i] <= 1'b0;
//                    usr_irq_ack[i]  <= 1'b0;       
//                end 
//            end
//            FIN: begin
//                    state[i]        <= IDLE;
//                    usr_irq_ack[i]  <= 1'b0; 
//            end
//            MASK: begin
//                if(irq_mask[i]) begin
//                    state[i]        <= UNMASK;
//                    xdma_irq_req[i] <= 1'b0;
//                    usr_irq_ack[i]  <= 1'b1;            
//                end
//            end 
//            UNMASK: begin
//                usr_irq_ack[i]  <= 1'b0; 
//                if(~irq_mask[i]) begin
//                    state[i]        <= IDLE;
//                end
//            end
//        endcase
//    end

//end
//endgenerate





endmodule
