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
// File       : xdma_0_pcie3_ip_rxcdrhold.v
// Version    : 4.4 
//-----------------------------------------------------------------------------
`timescale 1ps/1ps

module xdma_0_pcie3_ip_rxcdrhold 
(
  input   wire              pipe_clk,
  input   wire              user_clk,
  input   wire     [5:0]    cfg_ltssm_state,
  input   wire              pipe_rx0_elec_idle,
  output  wire              rxcdrhold_out
);


  reg rxcdrhold_req = 1'b0;
  reg phy_rxcdrhold = 1'b0;
  reg pipe_rx0_elec_idle_reg0 = 1'b0;
  reg pipe_rx0_elec_idle_reg1 = 1'b0;

  wire pipe_rxcdrhold_req;
  wire elec_idle_negedge;

  // If LTSSM state is Recovery.Speed, L1.Entry, L1.Idle or Loopback_Entry_slave 

  always @ (posedge user_clk) 
  begin
    if (cfg_ltssm_state == 6'h0C||cfg_ltssm_state == 6'h17||cfg_ltssm_state == 6'h18|| cfg_ltssm_state == 6'h24)      
          rxcdrhold_req <= 1'b1;
        else 
          rxcdrhold_req <= 1'b0;
    end
    
  // CDC to pipe_clock domain  
   
xdma_0_pcie3_ip_phy_sync #(.WIDTH (1),.STAGE (3)) sync_rxcdrhold_req (.CLK (pipe_clk), .D (rxcdrhold_req), .Q (pipe_rxcdrhold_req));

 // negedge detect rx_elec_idle

 always @ (posedge pipe_clk )
   begin
     pipe_rx0_elec_idle_reg0     <= pipe_rx0_elec_idle;
     pipe_rx0_elec_idle_reg1     <= pipe_rx0_elec_idle_reg0;
   end
 
 assign elec_idle_negedge = pipe_rx0_elec_idle_reg1 && ~pipe_rx0_elec_idle;


   always @ (posedge pipe_clk) 
    begin
      if (pipe_rxcdrhold_req && pipe_rx0_elec_idle ) begin
        phy_rxcdrhold  <= 1'b1;
      end 
      else if (elec_idle_negedge)begin
        phy_rxcdrhold  <= 1'b0;
      end
      else begin
        phy_rxcdrhold  <= phy_rxcdrhold;
      end
   end

assign rxcdrhold_out = phy_rxcdrhold;

endmodule
