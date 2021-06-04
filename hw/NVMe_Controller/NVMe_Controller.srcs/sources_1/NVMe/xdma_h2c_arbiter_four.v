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
// Create Date: 06/16/2020 10:19:51 AM
// Design Name: 
// Module Name: xdma_h2c_arbiter_four
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


module xdma_h2c_arbiter_four#(
    parameter DATA_WIDTH      = 256,
    parameter ARBITER_LOW_BIT = 12
)(
    input                       clk,
    input                       rst_n,
    
   // output                      s_axis_decode_err,
    
    input                       m_h2c_dsc_byp_ready,   
    output reg                  m_h2c_dsc_byp_load, 
    output reg [63 : 0]         m_h2c_dsc_byp_src_addr,   
    output reg [63 : 0]         m_h2c_dsc_byp_dst_addr,   
    output reg [27 : 0]         m_h2c_dsc_byp_len,   
    output reg [15 : 0]         m_h2c_dsc_byp_ctl, 
    
    output                      s_axis_h2c_tready,
    input                       s_axis_h2c_tvalid,
    input  [DATA_WIDTH-1:0]     s_axis_h2c_tdata,
    input  [DATA_WIDTH/8-1:0]   s_axis_h2c_tkeep,
    input                       s_axis_h2c_tlast, 
    
    output reg                  s_h2c_dsc_byp_ready_0,   
    input                       s_h2c_dsc_byp_load_0, 
    input [63 : 0]              s_h2c_dsc_byp_src_addr_0,   
    input [63 : 0]              s_h2c_dsc_byp_dst_addr_0,   
    input [27 : 0]              s_h2c_dsc_byp_len_0,   
    input [15 : 0]              s_h2c_dsc_byp_ctl_0, 
    
    input                       m_axis_h2c_tready_0,
    output                      m_axis_h2c_tvalid_0,
    output [DATA_WIDTH-1:0]     m_axis_h2c_tdata_0,
    output [DATA_WIDTH/8-1:0]   m_axis_h2c_tkeep_0,
    output                      m_axis_h2c_tlast_0, 
    
    output reg                  s_h2c_dsc_byp_ready_1,   
    input                       s_h2c_dsc_byp_load_1, 
    input [63 : 0]              s_h2c_dsc_byp_src_addr_1,   
    input [63 : 0]              s_h2c_dsc_byp_dst_addr_1,   
    input [27 : 0]              s_h2c_dsc_byp_len_1,   
    input [15 : 0]              s_h2c_dsc_byp_ctl_1, 
    
    input                       m_axis_h2c_tready_1,
    output                      m_axis_h2c_tvalid_1,
    output [DATA_WIDTH-1:0]     m_axis_h2c_tdata_1,
    output [DATA_WIDTH/8-1:0]   m_axis_h2c_tkeep_1,
    output                      m_axis_h2c_tlast_1, 
    
    output reg                  s_h2c_dsc_byp_ready_2,   
    input                       s_h2c_dsc_byp_load_2, 
    input [63 : 0]              s_h2c_dsc_byp_src_addr_2,   
    input [63 : 0]              s_h2c_dsc_byp_dst_addr_2,   
    input [27 : 0]              s_h2c_dsc_byp_len_2,   
    input [15 : 0]              s_h2c_dsc_byp_ctl_2, 
    
    input                       m_axis_h2c_tready_2,
    output                      m_axis_h2c_tvalid_2,
    output [DATA_WIDTH-1:0]     m_axis_h2c_tdata_2,
    output [DATA_WIDTH/8-1:0]   m_axis_h2c_tkeep_2,
    output                      m_axis_h2c_tlast_2, 
    
    output reg                  s_h2c_dsc_byp_ready_3,   
    input                       s_h2c_dsc_byp_load_3, 
    input [63 : 0]              s_h2c_dsc_byp_src_addr_3,   
    input [63 : 0]              s_h2c_dsc_byp_dst_addr_3,   
    input [27 : 0]              s_h2c_dsc_byp_len_3,   
    input [15 : 0]              s_h2c_dsc_byp_ctl_3, 

    input                       m_axis_h2c_tready_3,
    output                      m_axis_h2c_tvalid_3,
    output  [DATA_WIDTH-1:0]    m_axis_h2c_tdata_3,
    output  [DATA_WIDTH/8-1:0]  m_axis_h2c_tkeep_3,
    output                      m_axis_h2c_tlast_3     
);

localparam
    S_DSC_IDLE = 1'b0,
    S_DSC_WAIT = 1'b1;
    
reg          s_dsc_state_0;
reg          dsc_ready_0;
wire         dsc_valid_0;
reg  [ 91:0] dsc_cmd_0;

reg          s_dsc_state_1;
reg          dsc_ready_1;
wire         dsc_valid_1;
reg  [ 91:0] dsc_cmd_1;

reg          s_dsc_state_2;
reg          dsc_ready_2;
wire         dsc_valid_2;
reg  [ 91:0] dsc_cmd_2;

reg          s_dsc_state_3;
reg          dsc_ready_3;
wire         dsc_valid_3;
reg  [ 91:0] dsc_cmd_3;

reg  [ 91:0] dsc_cmd;


localparam
    DSC_IDLE  = 2'h0,
    DSC_PICK  = 2'h1,
    DSC_CHECK = 2'h2,
    DSC_GEN   = 2'h3;
//    DSC_FIN   = 2'h2;
    
reg  [1 : 0] dsc_state;
reg  [2 : 0] dsc_picked; // picked one option
reg  [3 : 0] dsc_pick_mask; // indicate which picking option is valid

wire [1 : 0] dst_fifo_din;
wire         dst_fifo_wr_en;
wire         dst_fifo_rd_en;
wire [1 : 0] dst_fifo_dout;
wire         dst_fifo_full;
wire         dst_fifo_empty;
//wire         dst_fifo_prog_full;


// *********** Submit H2C descriptors *******************
// the timing of XDMA dsc-bypass interface is not the traditional handshake protocol
// buffer the loaded dsc from slave interface, then wait for permission to write in FIFO
assign dsc_valid_0 = ~s_h2c_dsc_byp_ready_0;

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    s_dsc_state_0  <= S_DSC_IDLE;
    dsc_cmd_0 <= 92'h0;
//    dsc_valid_0 <= 1'b0;
    s_h2c_dsc_byp_ready_0 <= 1'b1;
end else begin
    case(s_dsc_state_0)
        S_DSC_IDLE: begin
            if(s_h2c_dsc_byp_load_0) begin
                s_dsc_state_0  <= S_DSC_WAIT;
                dsc_cmd_0 <= {s_h2c_dsc_byp_len_0, s_h2c_dsc_byp_src_addr_0};  
//                dsc_valid_0 <= 1'b1;
                s_h2c_dsc_byp_ready_0 <= 1'b0;                                 
            end
        end
        S_DSC_WAIT: begin
            if(dsc_ready_0) begin
                s_dsc_state_0  <= S_DSC_IDLE;
//                dsc_valid_0 <= 1'b0;
                s_h2c_dsc_byp_ready_0 <= 1'b1;
            end
        end
    endcase
end


assign dsc_valid_1 = ~s_h2c_dsc_byp_ready_1;

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    s_dsc_state_1  <= S_DSC_IDLE;
    dsc_cmd_1 <= 92'h0;
//    dsc_valid_1 <= 1'b0;
    s_h2c_dsc_byp_ready_1 <= 1'b1;
end else begin
    case(s_dsc_state_1)
        S_DSC_IDLE: begin
            if(s_h2c_dsc_byp_load_1) begin
                s_dsc_state_1  <= S_DSC_WAIT;
                dsc_cmd_1 <= {s_h2c_dsc_byp_len_1, s_h2c_dsc_byp_src_addr_1};  
//                dsc_valid_1 <= 1'b1;
                s_h2c_dsc_byp_ready_1 <= 1'b0;                                 
            end
        end
        S_DSC_WAIT: begin
            if(dsc_ready_1) begin
                s_dsc_state_1  <= S_DSC_IDLE;
//                dsc_valid_1 <= 1'b0;
                s_h2c_dsc_byp_ready_1 <= 1'b1;
            end
        end
    endcase
end


assign dsc_valid_2 = ~s_h2c_dsc_byp_ready_2;

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    s_dsc_state_2  <= S_DSC_IDLE;
    dsc_cmd_2 <= 92'h0;
//    dsc_valid_2 <= 1'b0;
    s_h2c_dsc_byp_ready_2 <= 1'b1;
end else begin
    case(s_dsc_state_2)
        S_DSC_IDLE: begin
            if(s_h2c_dsc_byp_load_2) begin
                s_dsc_state_2  <= S_DSC_WAIT;
                dsc_cmd_2 <= {s_h2c_dsc_byp_len_2, s_h2c_dsc_byp_src_addr_2};  
//                dsc_valid_2 <= 1'b1;
                s_h2c_dsc_byp_ready_2 <= 1'b0;                                 
            end
        end
        S_DSC_WAIT: begin
            if(dsc_ready_2) begin
                s_dsc_state_2  <= S_DSC_IDLE;
//                dsc_valid_2 <= 1'b0;
                s_h2c_dsc_byp_ready_2 <= 1'b1;
            end
        end
    endcase
end


assign dsc_valid_3 = ~s_h2c_dsc_byp_ready_3;

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    s_dsc_state_3  <= S_DSC_IDLE;
    dsc_cmd_3 <= 92'h0;
//    dsc_valid_3 <= 1'b0;
    s_h2c_dsc_byp_ready_3 <= 1'b1;
end else begin
    case(s_dsc_state_3)
        S_DSC_IDLE: begin
            if(s_h2c_dsc_byp_load_3) begin
                s_dsc_state_3  <= S_DSC_WAIT;
                dsc_cmd_3 <= {s_h2c_dsc_byp_len_3, s_h2c_dsc_byp_src_addr_3};  
//                dsc_valid_3 <= 1'b1;
                s_h2c_dsc_byp_ready_3 <= 1'b0;                                 
            end
        end
        S_DSC_WAIT: begin
            if(dsc_ready_3) begin
                s_dsc_state_3  <= S_DSC_IDLE;
//                dsc_valid_3 <= 1'b0;
                s_h2c_dsc_byp_ready_3 <= 1'b1;
            end
        end
    endcase
end



// Descriptor submitting FSM
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    dsc_state <= DSC_IDLE;
end else begin
    case(dsc_state)
        DSC_IDLE: begin
            if(dsc_valid_0 | dsc_valid_1 | dsc_valid_2 | dsc_valid_3) begin
                dsc_state <= DSC_PICK;
            end
        end
        DSC_PICK: begin
            dsc_state <= DSC_CHECK;
        end
        DSC_CHECK: begin
            if(dsc_picked != 3'h4) // did pick one
                dsc_state <= DSC_GEN;
            else
                dsc_state <= DSC_PICK;
        end
        DSC_GEN: begin
            if(m_h2c_dsc_byp_ready & (~dst_fifo_full)) begin
                dsc_state <= DSC_IDLE;
            end
        end
    endcase
end



// picking in polling mode
always@(posedge clk or negedge rst_n)    
if(~rst_n) begin                                                                 
    dsc_picked <= 3'h4;
end else if((dsc_state == DSC_PICK) && dsc_valid_0 && dsc_pick_mask[0])begin 
    dsc_picked <= 3'h0;
end else if((dsc_state == DSC_PICK) && dsc_valid_1 && dsc_pick_mask[1])begin
    dsc_picked <= 3'h1;
end else if((dsc_state == DSC_PICK) && dsc_valid_2 && dsc_pick_mask[2])begin
    dsc_picked <= 3'h2;
end else if((dsc_state == DSC_PICK) && dsc_valid_3 && dsc_pick_mask[3])begin
    dsc_picked <= 3'h3;
end else if(dsc_state == DSC_PICK) begin
    dsc_picked <= 3'h4;
end


always@(posedge clk or negedge rst_n)    
if(~rst_n) begin                                                                 
    dsc_pick_mask <= 4'b0001; 
end else if(dsc_state == DSC_CHECK) begin // polling mode
    dsc_pick_mask <= {dsc_pick_mask[2:0], dsc_pick_mask[3]}; 
end  


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    dsc_cmd     <= 92'h0;
    dsc_ready_0 <= 1'b0;
    dsc_ready_1 <= 1'b0;
    dsc_ready_2 <= 1'b0;
    dsc_ready_3 <= 1'b0;
end else if((dsc_state == DSC_CHECK) && dsc_valid_0 && (dsc_picked == 3'h0)) begin
    dsc_cmd     <= dsc_cmd_0;
    dsc_ready_0 <= 1'b1;
    dsc_ready_1 <= 1'b0;
    dsc_ready_2 <= 1'b0;
    dsc_ready_3 <= 1'b0;
end else if((dsc_state == DSC_CHECK) && dsc_valid_1 && (dsc_picked == 3'h1)) begin
    dsc_cmd     <= dsc_cmd_1;
    dsc_ready_0 <= 1'b0;
    dsc_ready_1 <= 1'b1;
    dsc_ready_2 <= 1'b0;
    dsc_ready_3 <= 1'b0;
end else if((dsc_state == DSC_CHECK) && dsc_valid_2 && (dsc_picked == 3'h2)) begin
    dsc_cmd     <= dsc_cmd_2;
    dsc_ready_0 <= 1'b0;
    dsc_ready_1 <= 1'b0;
    dsc_ready_2 <= 1'b1;
    dsc_ready_3 <= 1'b0;
end else if((dsc_state == DSC_CHECK) && dsc_valid_3 && (dsc_picked == 3'h3)) begin
    dsc_cmd     <= dsc_cmd_3;
    dsc_ready_0 <= 1'b0;
    dsc_ready_1 <= 1'b0;
    dsc_ready_2 <= 1'b0;
    dsc_ready_3 <= 1'b1;
end else begin
    //dsc_cmd     <= 92'h0;
    dsc_ready_0 <= 1'b0;
    dsc_ready_1 <= 1'b0;
    dsc_ready_2 <= 1'b0;
    dsc_ready_3 <= 1'b0;
end    


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    m_h2c_dsc_byp_load     <= 1'h0;
    m_h2c_dsc_byp_len      <= 28'h0;
    m_h2c_dsc_byp_dst_addr <= 64'h0;
    m_h2c_dsc_byp_src_addr <= 64'h0;
    m_h2c_dsc_byp_ctl      <= 16'h0;
end else if((dsc_state == DSC_GEN) && m_h2c_dsc_byp_ready & (~dst_fifo_full)) begin
    m_h2c_dsc_byp_load     <= 1'h1;
    m_h2c_dsc_byp_len      <= dsc_cmd[91:64];
    m_h2c_dsc_byp_dst_addr <= 64'h0;
    m_h2c_dsc_byp_src_addr <= dsc_cmd[63:0];
    m_h2c_dsc_byp_ctl      <= 16'h10;
end else begin
    m_h2c_dsc_byp_load     <= 1'h0;
//    m_h2c_dsc_byp_len      <= 28'h0;
//    m_h2c_dsc_byp_dst_addr <= 64'h0;
//    m_h2c_dsc_byp_src_addr <= 64'h0;
//    m_h2c_dsc_byp_ctl      <= 16'h0;
end



assign dst_fifo_wr_en = (dsc_state == DSC_GEN) && m_h2c_dsc_byp_ready & (~dst_fifo_full);
assign dst_fifo_din = dsc_picked[1:0];


// buffer the destinations of DSC 
xdma_dst_fifo xdma_h2c_dst_fifo (
  .clk      (clk               ),    // input wire clk
  .rst      (~rst_n            ),    // input wire rst
  .din      (dst_fifo_din      ),    // input wire [1 : 0] din
  .wr_en    (dst_fifo_wr_en    ),    // input wire wr_en
  .rd_en    (dst_fifo_rd_en    ),    // input wire rd_en
  .dout     (dst_fifo_dout     ),    // output wire [1 : 0] dout
  .full     (dst_fifo_full     ),    // output wire full
  .empty    (dst_fifo_empty    )     // output wire empty
//  .prog_full(dst_fifo_prog_full)     // output wire prog_full
);


// ********************** dispatch H2C DATA according to the dst address *****
localparam
    D_IDLE = 1'h0,
    D_WAIT = 1'h1;

reg  [0:0] d_state;

wire [1:0] s_axis_h2c_tdest;
wire [1:0] m_axis_h2c_tdest_0;
wire [1:0] m_axis_h2c_tdest_1;
wire [1:0] m_axis_h2c_tdest_2;
wire [1:0] m_axis_h2c_tdest_3;
wire s_axis_decode_err;
wire t_axis_h2c_tvalid;
wire t_axis_h2c_tready;

assign dst_fifo_rd_en = (d_state == D_IDLE) & (~dst_fifo_empty);

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    d_state  <= D_IDLE;
end else begin
    case(d_state)
        D_IDLE: begin
            if(~dst_fifo_empty) begin
                d_state  <= D_WAIT;                               
            end
        end
        D_WAIT: begin
            if(t_axis_h2c_tready & s_axis_h2c_tvalid & s_axis_h2c_tlast) begin
                d_state  <= D_IDLE;
            end
        end
    endcase
end


assign s_axis_h2c_tdest = dst_fifo_dout;
assign s_axis_h2c_tready = t_axis_h2c_tready & (d_state == D_WAIT);
assign t_axis_h2c_tvalid = s_axis_h2c_tvalid & (d_state == D_WAIT);

axis_1s4m h2c_axis_1s4m (
  .ACLK            (clk                ),  // input wire ACLK            
  .ARESETN         (rst_n              ),  // input wire ARESETN      
  .S00_AXIS_ACLK   (clk                ),  // input wire S00_AXIS_ACLK
  .S00_AXIS_ARESETN(rst_n              ),  // input wire S00_AXIS_ARESETN 
  .S00_AXIS_TVALID (t_axis_h2c_tvalid  ),  // input wire S00_AXIS_TVALID   
  .S00_AXIS_TREADY (t_axis_h2c_tready  ),  // output wire S00_AXIS_TREADY   
  .S00_AXIS_TDATA  (s_axis_h2c_tdata   ),  // input wire [255 : 0] S00_AXIS_TDATA
  .S00_AXIS_TKEEP  (s_axis_h2c_tkeep   ),  // input wire [31 : 0] S00_AXIS_TKEEP
  .S00_AXIS_TLAST  (s_axis_h2c_tlast   ),  // input wire S00_AXIS_TLAST
  .S00_AXIS_TDEST  (s_axis_h2c_tdest   ),  // input wire [1 : 0] S00_AXIS_TDEST
  .M00_AXIS_ACLK   (clk                ),  // input wire M00_AXIS_ACLK
  .M01_AXIS_ACLK   (clk                ),  // input wire M01_AXIS_ACLK
  .M02_AXIS_ACLK   (clk                ),  // input wire M02_AXIS_ACLK
  .M03_AXIS_ACLK   (clk                ),  // input wire M03_AXIS_ACLK
  .M00_AXIS_ARESETN(rst_n              ),  // input wire M00_AXIS_ARESETN 
  .M01_AXIS_ARESETN(rst_n              ),  // input wire M01_AXIS_ARESETN 
  .M02_AXIS_ARESETN(rst_n              ),  // input wire M02_AXIS_ARESETN 
  .M03_AXIS_ARESETN(rst_n              ),  // input wire M03_AXIS_ARESETN 
  .M00_AXIS_TVALID (m_axis_h2c_tvalid_0),  // output wire M00_AXIS_TVALID
  .M01_AXIS_TVALID (m_axis_h2c_tvalid_1),  // output wire M01_AXIS_TVALID
  .M02_AXIS_TVALID (m_axis_h2c_tvalid_2),  // output wire M02_AXIS_TVALID
  .M03_AXIS_TVALID (m_axis_h2c_tvalid_3),  // output wire M03_AXIS_TVALID
  .M00_AXIS_TREADY (m_axis_h2c_tready_0),  // input wire M00_AXIS_TREADY
  .M01_AXIS_TREADY (m_axis_h2c_tready_1),  // input wire M01_AXIS_TREADY
  .M02_AXIS_TREADY (m_axis_h2c_tready_2),  // input wire M02_AXIS_TREADY
  .M03_AXIS_TREADY (m_axis_h2c_tready_3),  // input wire M03_AXIS_TREADY
  .M00_AXIS_TDATA  (m_axis_h2c_tdata_0 ),  // output wire [255 : 0] M00_AXIS_TDATA
  .M01_AXIS_TDATA  (m_axis_h2c_tdata_1 ),  // output wire [255 : 0] M01_AXIS_TDATA
  .M02_AXIS_TDATA  (m_axis_h2c_tdata_2 ),  // output wire [255 : 0] M02_AXIS_TDATA
  .M03_AXIS_TDATA  (m_axis_h2c_tdata_3 ),  // output wire [255 : 0] M03_AXIS_TDATA
  .M00_AXIS_TKEEP  (m_axis_h2c_tkeep_0 ),  // output wire [31 : 0] M00_AXIS_TKEEP
  .M01_AXIS_TKEEP  (m_axis_h2c_tkeep_1 ),  // output wire [31 : 0] M01_AXIS_TKEEP
  .M02_AXIS_TKEEP  (m_axis_h2c_tkeep_2 ),  // output wire [31 : 0] M02_AXIS_TKEEP
  .M03_AXIS_TKEEP  (m_axis_h2c_tkeep_3 ),  // output wire [31 : 0] M03_AXIS_TKEEP
  .M00_AXIS_TLAST  (m_axis_h2c_tlast_0 ),  // output wire M00_AXIS_TLAST
  .M01_AXIS_TLAST  (m_axis_h2c_tlast_1 ),  // output wire M01_AXIS_TLAST
  .M02_AXIS_TLAST  (m_axis_h2c_tlast_2 ),  // output wire M02_AXIS_TLAST
  .M03_AXIS_TLAST  (m_axis_h2c_tlast_3 ),  // output wire M03_AXIS_TLAST
  .M00_AXIS_TDEST  (m_axis_h2c_tdest_0 ),  // output wire [1 : 0] M00_AXIS_TDEST
  .M01_AXIS_TDEST  (m_axis_h2c_tdest_1 ),  // output wire [1 : 0] M01_AXIS_TDEST
  .M02_AXIS_TDEST  (m_axis_h2c_tdest_2 ),  // output wire [1 : 0] M02_AXIS_TDEST
  .M03_AXIS_TDEST  (m_axis_h2c_tdest_3 ),  // output wire [1 : 0] M03_AXIS_TDEST
  .S00_DECODE_ERR  (s_axis_decode_err  )   // output wire S00_DECODE_ERR
);



endmodule
