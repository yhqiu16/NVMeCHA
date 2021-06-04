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
// Create Date: 2020/07/20 23:00:31
// Design Name: 
// Module Name: xdma_c2h_arbiter_two
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


module xdma_c2h_arbiter_two #(
    parameter DATA_WIDTH      = 256,
    parameter ARBITER_LOW_BIT = 12
)(
    input                       clk,
    input                       rst_n,
    
    input                       m_c2h_dsc_byp_ready,   
    output reg                  m_c2h_dsc_byp_load, 
    output reg [63 : 0]         m_c2h_dsc_byp_src_addr,   
    output reg [63 : 0]         m_c2h_dsc_byp_dst_addr,   
    output reg [27 : 0]         m_c2h_dsc_byp_len,   
    output reg [15 : 0]         m_c2h_dsc_byp_ctl, 
    
    input                       m_axis_c2h_tready,
    output                      m_axis_c2h_tvalid,
    output [DATA_WIDTH-1:0]     m_axis_c2h_tdata,
    output [DATA_WIDTH/8-1:0]   m_axis_c2h_tkeep,
    output                      m_axis_c2h_tlast, 
    
    output reg                  s_c2h_dsc_byp_ready_0,   
    input                       s_c2h_dsc_byp_load_0, 
    input [63 : 0]              s_c2h_dsc_byp_src_addr_0,   
    input [63 : 0]              s_c2h_dsc_byp_dst_addr_0,   
    input [27 : 0]              s_c2h_dsc_byp_len_0,   
    input [15 : 0]              s_c2h_dsc_byp_ctl_0, 
    
    output                      s_axis_c2h_tready_0,
    input                       s_axis_c2h_tvalid_0,
    input  [DATA_WIDTH-1:0]     s_axis_c2h_tdata_0,
    input  [DATA_WIDTH/8-1:0]   s_axis_c2h_tkeep_0,
    input                       s_axis_c2h_tlast_0, 
    
    output reg                  s_c2h_dsc_byp_ready_1,   
    input                       s_c2h_dsc_byp_load_1, 
    input [63 : 0]              s_c2h_dsc_byp_src_addr_1,   
    input [63 : 0]              s_c2h_dsc_byp_dst_addr_1,   
    input [27 : 0]              s_c2h_dsc_byp_len_1,   
    input [15 : 0]              s_c2h_dsc_byp_ctl_1, 
    
    output                      s_axis_c2h_tready_1,
    input                       s_axis_c2h_tvalid_1,
    input  [DATA_WIDTH-1:0]     s_axis_c2h_tdata_1,
    input  [DATA_WIDTH/8-1:0]   s_axis_c2h_tkeep_1,
    input                       s_axis_c2h_tlast_1  
);

wire s_decode_err_0;
wire s_decode_err_1;
wire axis_fifo_tdest;

localparam
    D_IDLE   = 3'h0,
    D_PICK   = 3'h1,
    D_CHECK  = 3'h2,
    DSC_WAIT = 3'h3,
    DSC_GEN  = 3'h4,
    D_WAIT   = 3'h5;

reg [2:0] d_state;
reg [1:0] d_picked; // picked one option
reg [1:0] d_pick_mask; // indicate which picking option is valid

wire t_axis_c2h_tvalid_0;
wire t_axis_c2h_tvalid_1;
wire t_axis_c2h_tready_0;
wire t_axis_c2h_tready_1;

reg s_eop_0;
reg s_eop_1;

wire                      axis_fifo_tready;
wire                      axis_fifo_tvalid;
wire [DATA_WIDTH-1:0]     axis_fifo_tdata;
wire [DATA_WIDTH/8-1:0]   axis_fifo_tkeep;
wire                      axis_fifo_tlast; 


localparam
    S_DSC_IDLE = 1'b0,
    S_DSC_WAIT = 1'b1;
    
reg          s_dsc_state_0;
reg          dsc_ready_0;
reg          dsc_valid_0;
reg  [ 91:0] dsc_cmd_0;

reg          s_dsc_state_1;
reg          dsc_ready_1;
reg          dsc_valid_1;
reg  [ 91:0] dsc_cmd_1;

reg  [ 91:0] dsc_cmd;


// Global FSM
// 1. Arbitrate multi-channel AXIS data first
// 2. Submit descriptor
// 3. Wait data transferred done
always@(posedge clk or negedge rst_n)    
if(~rst_n) begin 
    d_state <= D_IDLE;                                                                            
end else begin
    case(d_state)
        D_IDLE: begin
            if(s_axis_c2h_tvalid_0 | s_axis_c2h_tvalid_1) begin  // receiving AXIS data
                d_state <= D_PICK;
            end
        end
        D_PICK: begin  // pick one AXIS data
                d_state <= D_CHECK;
        end
        D_CHECK: begin  
            if(d_picked != 2'h2) // did pick one
                d_state <= DSC_WAIT;
            else // did not pick one
                d_state <= D_PICK;
        end
        DSC_WAIT: begin // wait descriptor comming
            if((dsc_valid_0 && (d_picked == 2'h0)) || (dsc_valid_1 && (d_picked == 2'h1))) begin
                d_state <= DSC_GEN;
            end
        end
        DSC_GEN: begin
            if(m_c2h_dsc_byp_ready) begin
                d_state <= D_WAIT;
            end
        end
        D_WAIT: begin  // wait one packet completed
            if(axis_fifo_tvalid & axis_fifo_tready & axis_fifo_tlast) begin
                d_state <= D_IDLE; 
            end
        end
    endcase
end


// picking in polling mode
always@(posedge clk or negedge rst_n)    
if(~rst_n) begin                                                                 
    d_picked <= 2'h2;
end else if((d_state == D_PICK) && s_axis_c2h_tvalid_0 && d_pick_mask[0])begin 
    d_picked <= 2'h0;
end else if((d_state == D_PICK) && s_axis_c2h_tvalid_1 && d_pick_mask[1])begin
    d_picked <= 2'h1;
end else if(d_state == D_PICK) begin
    d_picked <= 2'h2;
end


always@(posedge clk or negedge rst_n)    
if(~rst_n) begin                                                                 
    d_pick_mask <= 2'b01; 
end else if(d_state == D_CHECK) begin // polling mode
    d_pick_mask <= {d_pick_mask[0], d_pick_mask[1]}; 
end  

always@(posedge clk or negedge rst_n)    
if(~rst_n) begin                                                                 
    s_eop_0 <= 1'b1; 
end else if((d_state == D_WAIT) & (d_picked == 2'h0) & t_axis_c2h_tready_0 & s_axis_c2h_tvalid_0 & s_axis_c2h_tlast_0)begin 
    s_eop_0 <= 1'b0;  
end else if(d_state != D_WAIT) begin
    s_eop_0 <= 1'b1;
end


always@(posedge clk or negedge rst_n)    
if(~rst_n) begin                                                                 
    s_eop_1 <= 1'b1; 
end else if((d_state == D_WAIT) & (d_picked == 2'h1) & t_axis_c2h_tready_1 & s_axis_c2h_tvalid_1 & s_axis_c2h_tlast_1)begin 
    s_eop_1 <= 1'b0;  
end else if(d_state != D_WAIT) begin
    s_eop_1 <= 1'b1;
end


assign s_axis_c2h_tready_0 = t_axis_c2h_tready_0 & s_eop_0 & (d_state == D_WAIT) & (d_picked == 2'h0);
assign s_axis_c2h_tready_1 = t_axis_c2h_tready_1 & s_eop_1 & (d_state == D_WAIT) & (d_picked == 2'h1);
assign t_axis_c2h_tvalid_0 = s_axis_c2h_tvalid_0 & s_eop_0 & (d_state == D_WAIT) & (d_picked == 2'h0);
assign t_axis_c2h_tvalid_1 = s_axis_c2h_tvalid_1 & s_eop_1 & (d_state == D_WAIT) & (d_picked == 2'h1);



// *********** Submit C2H descriptors *******************
// the timing of XDMA dsc-bypass interface is not the traditional handshake protocol
// buffer the loaded dsc from slave interface, then wait for permission to write in FIFO
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    s_dsc_state_0  <= S_DSC_IDLE;
    dsc_cmd_0 <= 92'h0;
    dsc_valid_0 <= 1'b0;
    s_c2h_dsc_byp_ready_0 <= 1'b1;
end else begin
    case(s_dsc_state_0)
        S_DSC_IDLE: begin
            if(s_c2h_dsc_byp_load_0) begin
                s_dsc_state_0  <= S_DSC_WAIT;
                dsc_cmd_0 <= {s_c2h_dsc_byp_len_0, s_c2h_dsc_byp_dst_addr_0};  
                dsc_valid_0 <= 1'b1;
                s_c2h_dsc_byp_ready_0 <= 1'b0;                                 
            end
        end
        S_DSC_WAIT: begin
            if(dsc_ready_0) begin
                s_dsc_state_0  <= S_DSC_IDLE;
                dsc_valid_0 <= 1'b0;
                s_c2h_dsc_byp_ready_0 <= 1'b1;
            end
        end
    endcase
end


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    s_dsc_state_1  <= S_DSC_IDLE;
    dsc_cmd_1 <= 92'h0;
    dsc_valid_1 <= 1'b0;
    s_c2h_dsc_byp_ready_1 <= 1'b1;
end else begin
    case(s_dsc_state_1)
        S_DSC_IDLE: begin
            if(s_c2h_dsc_byp_load_1) begin
                s_dsc_state_1  <= S_DSC_WAIT;
                dsc_cmd_1 <= {s_c2h_dsc_byp_len_1, s_c2h_dsc_byp_dst_addr_1};  
                dsc_valid_1 <= 1'b1;
                s_c2h_dsc_byp_ready_1 <= 1'b0;                                 
            end
        end
        S_DSC_WAIT: begin
            if(dsc_ready_1) begin
                s_dsc_state_1  <= S_DSC_IDLE;
                dsc_valid_1 <= 1'b0;
                s_c2h_dsc_byp_ready_1 <= 1'b1;
            end
        end
    endcase
end



// DSC submiting arbiter
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    dsc_cmd     <= 92'h0;
    dsc_ready_0 <= 1'b0;
    dsc_ready_1 <= 1'b0;
end else if((d_state == DSC_WAIT) && dsc_valid_0 && (d_picked == 2'h0)) begin
    dsc_cmd     <= dsc_cmd_0;
    dsc_ready_0 <= 1'b1;
    dsc_ready_1 <= 1'b0;
end else if((d_state == DSC_WAIT) && dsc_valid_1 && (d_picked == 2'h1)) begin
    dsc_cmd     <= dsc_cmd_1;
    dsc_ready_0 <= 1'b0;
    dsc_ready_1 <= 1'b1;
end else begin
    //dsc_cmd     <= 92'h0;
    dsc_ready_0 <= 1'b0;
    dsc_ready_1 <= 1'b0;
end    




always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    m_c2h_dsc_byp_load     <= 1'h0;
    m_c2h_dsc_byp_len      <= 28'h0;
    m_c2h_dsc_byp_dst_addr <= 64'h0;
    m_c2h_dsc_byp_src_addr <= 64'h0;
    m_c2h_dsc_byp_ctl      <= 16'h0;
end else if((d_state == DSC_GEN) && m_c2h_dsc_byp_ready) begin
    m_c2h_dsc_byp_load     <= 1'h1;
    m_c2h_dsc_byp_len      <= dsc_cmd[91:64];
    m_c2h_dsc_byp_dst_addr <= dsc_cmd[63:0];
    m_c2h_dsc_byp_src_addr <= 64'h0;
    m_c2h_dsc_byp_ctl      <= 16'h10;
end else begin
    m_c2h_dsc_byp_load     <= 1'h0;
//    m_c2h_dsc_byp_len      <= 28'h0;
//    m_c2h_dsc_byp_dst_addr <= 64'h0;
//    m_c2h_dsc_byp_src_addr <= 64'h0;
//    m_c2h_dsc_byp_ctl      <= 16'h0;
end


axis_2s1m c2h_axis_2s1m (
  .ACLK                (clk                ),    // input wire ACLK  
  .ARESETN             (rst_n              ),    // input wire ARESETN  
  .S00_AXIS_ACLK       (clk                ),    // input wire S00_AXIS_ACLK  
  .S01_AXIS_ACLK       (clk                ),    // input wire S01_AXIS_ACLK  
  .S00_AXIS_ARESETN    (rst_n              ),    // input wire S00_AXIS_ARESETN  
  .S01_AXIS_ARESETN    (rst_n              ),    // input wire S01_AXIS_ARESETN  
  .S00_AXIS_TVALID     (t_axis_c2h_tvalid_0),    // input wire S00_AXIS_TVALID  
  .S01_AXIS_TVALID     (t_axis_c2h_tvalid_1),    // input wire S01_AXIS_TVALID   
  .S00_AXIS_TREADY     (t_axis_c2h_tready_0),    // output wire S00_AXIS_TREADY  
  .S01_AXIS_TREADY     (t_axis_c2h_tready_1),    // output wire S01_AXIS_TREADY   
  .S00_AXIS_TDATA      (s_axis_c2h_tdata_0 ),    // input wire [255 : 0] S00_AXIS_ 
  .S01_AXIS_TDATA      (s_axis_c2h_tdata_1 ),    // input wire [255 : 0] S01_AXIS_ 
  .S00_AXIS_TKEEP      (s_axis_c2h_tkeep_0 ),    // input wire [31 : 0] S00_AXIS_T 
  .S01_AXIS_TKEEP      (s_axis_c2h_tkeep_1 ),    // input wire [31 : 0] S01_AXIS_T 
  .S00_AXIS_TLAST      (s_axis_c2h_tlast_0 ),    // input wire S00_AXIS_TLAST  
  .S01_AXIS_TLAST      (s_axis_c2h_tlast_1 ),    // input wire S01_AXIS_TLAST  
  .S00_AXIS_TDEST      (1'h0               ),    // input wire [0 : 0] S00_AXIS_TD 
  .S01_AXIS_TDEST      (1'h1               ),    // input wire [0 : 0] S01_AXIS_TD 
  .M00_AXIS_ACLK       (clk                ),    // input wire M00_AXIS_ACLK  
  .M00_AXIS_ARESETN    (rst_n              ),    // input wire M00_AXIS_ARESETN  
  .M00_AXIS_TVALID     (axis_fifo_tvalid  ),    // output wire M00_AXIS_TVALID  
  .M00_AXIS_TREADY     (axis_fifo_tready  ),    // input wire M00_AXIS_TREADY  
  .M00_AXIS_TDATA      (axis_fifo_tdata   ),    // output wire [255 : 0] M00_AXIS 
  .M00_AXIS_TKEEP      (axis_fifo_tkeep   ),    // output wire [31 : 0] M00_AXIS_ 
  .M00_AXIS_TLAST      (axis_fifo_tlast   ),    // output wire M00_AXIS_TLAST  
  .M00_AXIS_TDEST      (axis_fifo_tdest   ),    // output wire [0 : 0] M00_AXIS_T 
  .S00_ARB_REQ_SUPPRESS(1'b0               ),    // input wire S00_ARB_REQ_SUPPRES  
  .S01_ARB_REQ_SUPPRESS(1'b0               ),    // input wire S01_ARB_REQ_SUPPRES   
  .S00_DECODE_ERR      (s_decode_err_0     ),    // output wire S00_DECODE_ERR  
  .S01_DECODE_ERR      (s_decode_err_1     )     // output wire S01_DECODE_ERR  
//  .M00_FIFO_DATA_COUNT (                   )    // output wire [31 : 0] M00_FIFO_DATA_COUNT
);


axis_c2h_arbiter_data_fifo axis_c2h_arbiter_data_fifo (
  .s_axis_aresetn(rst_n            ),    // input wire s_axis_aresetn
  .s_axis_aclk   (clk              ),    // input wire s_axis_aclk
  .s_axis_tvalid (axis_fifo_tvalid ),    // input wire s_axis_tvalid
  .s_axis_tready (axis_fifo_tready ),    // output wire s_axis_tready
  .s_axis_tdata  (axis_fifo_tdata  ),     // input wire [255 : 0] s_axis_tdata
  .s_axis_tkeep  (axis_fifo_tkeep  ),     // input wire [31 : 0] s_axis_tkeep
  .s_axis_tlast  (axis_fifo_tlast  ),     // input wire s_axis_tlast
  .m_axis_tvalid (m_axis_c2h_tvalid),     // output wire m_axis_tvalid
  .m_axis_tready (m_axis_c2h_tready),     // input wire m_axis_tready
  .m_axis_tdata  (m_axis_c2h_tdata ),      // output wire [255 : 0] m_axis_tdata
  .m_axis_tkeep  (m_axis_c2h_tkeep ),      // output wire [31 : 0] m_axis_tkeep
  .m_axis_tlast  (m_axis_c2h_tlast )      // output wire m_axis_tlast
);






endmodule
