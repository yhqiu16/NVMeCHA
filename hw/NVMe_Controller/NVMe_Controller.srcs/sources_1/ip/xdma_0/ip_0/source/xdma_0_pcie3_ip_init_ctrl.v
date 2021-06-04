//-----------------------------------------------------------------------------
//
// (c) Copyright 2012-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//-----------------------------------------------------------------------------
//
// Project    : Ultrascale FPGA Gen3 Integrated Block for PCI Express
// File       : xdma_0_pcie3_ip_init_ctrl.v
// Version    : 4.4 
//-----------------------------------------------------------------------------

`timescale 1ps/1ps

module xdma_0_pcie3_ip_init_ctrl 
 # (
  parameter         TCQ = 100,
  parameter         PL_UPSTREAM_FACING = "TRUE"
)(
  input  wire         clk_i,
  input  wire         phy_rdy_i,
  output wire         reset_n_o,
  output wire         pipe_reset_n_o,
  output wire         mgmt_reset_n_o,
  output wire         mgmt_sticky_reset_n_o,
  output wire   [2:0] state_o
  );

  localparam STATE_RESET = 3'b000;
  localparam STATE_MGMT_RESET_DEASSERT = 3'b001;
  localparam STATE_PHY_RDY = 3'b100;
  localparam STATE_RESET_DEASSERT = 3'b101;

  reg           [2:0] reg_state;
  reg           [2:0] reg_next_state;
(* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *)    reg           [1:0] reg_phy_rdy = 2'b00; 
  reg           [1:0] reg_cold_reset = 2'b11;
  reg                 reg_reset_n_o;
  reg                 reg_pipe_reset_n_o;
  reg                 reg_mgmt_reset_n_o;
  reg                 reg_mgmt_sticky_reset_n_o;
  reg           [1:0] reg_reset_timer;
  wire          [2:0] state_w;
  wire          [2:0] next_state_w;
  wire                phy_rdy;
  wire                cold_reset_n;
  wire          [1:0] reset_timer_w;
  
    
  // Generate PHY Ready

  always @(posedge clk_i)
  begin
    reg_phy_rdy[1:0] <= #TCQ {reg_phy_rdy[0], phy_rdy_i};
  end

  assign phy_rdy = reg_phy_rdy[1];
  
   // Generate Cold reset

  always @(posedge clk_i)
  begin
    if (!phy_rdy && reg_cold_reset[1] )
      reg_cold_reset[1:0] <= #TCQ 2'b11;
    else
      reg_cold_reset[1:0] <= #TCQ {reg_cold_reset[0], 1'b0};
  end

  assign cold_reset_n = !reg_cold_reset[1];
  
  // Reset Timer
  
  always @(posedge clk_i)
  begin
    if (!phy_rdy)
        reg_reset_timer <= #TCQ 2'b00;
    else if ((state_w == STATE_MGMT_RESET_DEASSERT) && (reset_timer_w != 2'b11))
        reg_reset_timer <= #TCQ reset_timer_w + 1'b1;
    else
        reg_reset_timer <= #TCQ reset_timer_w;    
  end
  
  
  // Reset SM
  
  always @(posedge clk_i or negedge cold_reset_n)
  begin
    if (!cold_reset_n)
      reg_state <= #TCQ STATE_RESET;
    else
      reg_state <= #TCQ reg_next_state;
  end
  
 generate // Resets for EP and DSPort 
 begin: generate_resets
   if( PL_UPSTREAM_FACING == "TRUE") // DUT is a EP
     begin 

        always @*
        begin
          reg_next_state = STATE_RESET;
          reg_mgmt_reset_n_o = 1'b1;
          reg_mgmt_sticky_reset_n_o = 1'b1;
          reg_reset_n_o = 1'b0;
          reg_pipe_reset_n_o = 1'b0;
          case (state_w)
            STATE_RESET:
            begin
              reg_mgmt_reset_n_o = 1'b0;
              reg_mgmt_sticky_reset_n_o = 1'b0;
              if (phy_rdy)
                reg_next_state = STATE_MGMT_RESET_DEASSERT;
              else
                reg_next_state = STATE_RESET;
            end
            STATE_MGMT_RESET_DEASSERT:
            begin
              if (reset_timer_w == 2'b11)
              reg_next_state = STATE_RESET_DEASSERT;
              else
              reg_next_state = STATE_MGMT_RESET_DEASSERT;
            end
            STATE_RESET_DEASSERT:
            begin
              reg_reset_n_o = 1'b1;
              reg_pipe_reset_n_o = 1'b1;
              if (!phy_rdy)
                reg_next_state = STATE_RESET;
              else
                reg_next_state = STATE_RESET_DEASSERT;
            end
        endcase
      end  //  always @*
  
  end else  begin // DUT is a DSPort 
      
      always @*
        begin
          reg_next_state = STATE_RESET;
          reg_mgmt_reset_n_o = 1'b1;
          reg_mgmt_sticky_reset_n_o = 1'b1;
          reg_reset_n_o = 1'b0;
          reg_pipe_reset_n_o = 1'b0;
          case (state_w)
            STATE_RESET:
            begin
              reg_mgmt_reset_n_o = 1'b0;
              reg_mgmt_sticky_reset_n_o = 1'b0;
              if (phy_rdy)
                reg_next_state = STATE_MGMT_RESET_DEASSERT;
              else
                reg_next_state = STATE_RESET;
            end
            STATE_MGMT_RESET_DEASSERT:
            begin
              if (reset_timer_w == 2'b11)
                reg_next_state = STATE_PHY_RDY;
              else
                reg_next_state = STATE_MGMT_RESET_DEASSERT;
            end
            STATE_PHY_RDY:
            begin
              if (phy_rdy)
                reg_next_state = STATE_RESET_DEASSERT;
              else
              	reg_next_state = STATE_PHY_RDY;
              end
            STATE_RESET_DEASSERT:
            begin
              reg_reset_n_o = 1'b1;
              reg_pipe_reset_n_o = 1'b1;
              if (!phy_rdy)
                reg_next_state = STATE_PHY_RDY;
              else
                reg_next_state = STATE_RESET_DEASSERT;
            end
        endcase
      end  //  always @*
  
   
     end // else // DUT is a Downstream port
 end // generate resets
 endgenerate

  assign state_w = reg_state;
  assign next_state_w = reg_next_state;
  assign reset_n_o = reg_reset_n_o;
  assign pipe_reset_n_o = reg_pipe_reset_n_o;
  assign mgmt_reset_n_o = reg_mgmt_reset_n_o;
  assign mgmt_sticky_reset_n_o = reg_mgmt_sticky_reset_n_o;
  assign state_o = reg_state;
  assign reset_timer_w = reg_reset_timer;

endmodule
