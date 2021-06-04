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
// File       : xdma_0_pcie3_ip_bram.v
// Version    : 4.4 
//-----------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////

`timescale 1ps/1ps

module xdma_0_pcie3_ip_bram 
#(
  parameter TCQ = 100,
  parameter COMPLETION_SPACE = "16KB"
  ) (
  input  wire         clk_i,
  input  wire         reset_i,
  input  wire   [8:0] mi_rep_addr_i,
  input  wire [127:0] mi_rep_wdata_i,
  input  wire  [15:0] mi_rep_wdip_i,
  input  wire         mi_rep_wen0_i,
  input  wire         mi_rep_wen1_i,
  output wire [127:0] mi_rep_rdata_o,
  output wire  [15:0] mi_rep_rdop_o,
  input  wire         mi_rep_rden0_i,
  input  wire         mi_rep_rden1_i,
  input  wire   [8:0] mi_req_waddr0_i,
  input  wire   [8:0] mi_req_waddr1_i,
  input  wire [127:0] mi_req_wdata_i,
  input  wire  [15:0] mi_req_wdip_i,
  input  wire         mi_req_wen0_i,
  input  wire         mi_req_wen1_i,
  input  wire         mi_req_wen2_i,
  input  wire         mi_req_wen3_i,
  input  wire   [8:0] mi_req_raddr0_i,
  input  wire   [8:0] mi_req_raddr1_i,
  output wire [127:0] mi_req_rdata_o,
  output wire  [15:0] mi_req_rdop_o,
  input  wire         mi_req_ren0_i,
  input  wire         mi_req_ren1_i,
  input  wire         mi_req_ren2_i,
  input  wire         mi_req_ren3_i,
  input  wire   [9:0] mi_cpl_waddr0_i,
  input  wire   [9:0] mi_cpl_waddr1_i,
  input  wire   [9:0] mi_cpl_waddr2_i,
  input  wire   [9:0] mi_cpl_waddr3_i,
  input  wire [127:0] mi_cpl_wdata_i,
  input  wire  [15:0] mi_cpl_wdip_i,
  input  wire         mi_cpl_wen0_i,
  input  wire         mi_cpl_wen1_i,
  input  wire         mi_cpl_wen2_i,
  input  wire         mi_cpl_wen3_i,
  input  wire         mi_cpl_wen4_i,
  input  wire         mi_cpl_wen5_i,
  input  wire         mi_cpl_wen6_i,
  input  wire         mi_cpl_wen7_i,
  input  wire   [9:0] mi_cpl_raddr0_i,
  input  wire   [9:0] mi_cpl_raddr1_i,
  input  wire   [9:0] mi_cpl_raddr2_i,
  input  wire   [9:0] mi_cpl_raddr3_i,
  output wire [127:0] mi_cpl_rdata_o,
  output wire  [15:0] mi_cpl_rdop_o,
  input  wire         mi_cpl_ren0_i,
  input  wire         mi_cpl_ren1_i,
  input  wire         mi_cpl_ren2_i,
  input  wire         mi_cpl_ren3_i,
  input  wire         mi_cpl_ren4_i,
  input  wire         mi_cpl_ren5_i,
  input  wire         mi_cpl_ren6_i,
  input  wire         mi_cpl_ren7_i
  );

  xdma_0_pcie3_ip_bram_rep
 #(
    .TCQ (TCQ))
  bram_rep_inst (
    .clk_i (clk_i),
    .reset_i (reset_i),
    .addr_i (mi_rep_addr_i[8:0]),
    .wdata_i (mi_rep_wdata_i[127:0]),
    .wdip_i (mi_rep_wdip_i[15:0]),
    .wen0_i (mi_rep_wen0_i),
    .wen1_i (mi_rep_wen1_i),
    .rdata_o (mi_rep_rdata_o[127:0]),
    .rdop_o (mi_rep_rdop_o[15:0]),
    .rden0_i (mi_rep_rden0_i),
    .rden1_i (mi_rep_rden1_i)
  );

  xdma_0_pcie3_ip_bram_req 
 #(
    .TCQ (TCQ))
  bram_req_inst (
    .clk_i (clk_i),
    .reset_i (reset_i),
    .waddr0_i (mi_req_waddr0_i[8:0]),
    .waddr1_i (mi_req_waddr1_i[8:0]),
    .wdata_i (mi_req_wdata_i[127:0]),
    .wdip_i (mi_req_wdip_i[15:0]),
    .wen0_i (mi_req_wen0_i),
    .wen1_i (mi_req_wen1_i),
    .wen2_i (mi_req_wen2_i),
    .wen3_i (mi_req_wen3_i),
    .raddr0_i (mi_req_raddr0_i[8:0]),
    .raddr1_i (mi_req_raddr1_i[8:0]),
    .rdata_o (mi_req_rdata_o[127:0]),
    .rdop_o (mi_req_rdop_o[15:0]),
    .ren0_i (mi_req_ren0_i),
    .ren1_i (mi_req_ren1_i),
    .ren2_i (mi_req_ren2_i),
    .ren3_i (mi_req_ren3_i)
  );

  xdma_0_pcie3_ip_bram_cpl 
 #(
    .TCQ (TCQ),
    .COMPLETION_SPACE (COMPLETION_SPACE))
  bram_cpl_inst (
    .clk_i (clk_i),
    .reset_i (reset_i),
    .waddr0_i (mi_cpl_waddr0_i[9:0]),
    .waddr1_i (mi_cpl_waddr1_i[9:0]),
    .waddr2_i (mi_cpl_waddr2_i[9:0]),
    .waddr3_i (mi_cpl_waddr3_i[9:0]),
    .wdata_i (mi_cpl_wdata_i[127:0]),
    .wdip_i (mi_cpl_wdip_i[15:0]),
    .wen0_i (mi_cpl_wen0_i),
    .wen1_i (mi_cpl_wen1_i),
    .wen2_i (mi_cpl_wen2_i),
    .wen3_i (mi_cpl_wen3_i),
    .wen4_i (mi_cpl_wen4_i),
    .wen5_i (mi_cpl_wen5_i),
    .wen6_i (mi_cpl_wen6_i),
    .wen7_i (mi_cpl_wen7_i),
    .raddr0_i (mi_cpl_raddr0_i[9:0]),
    .raddr1_i (mi_cpl_raddr1_i[9:0]),
    .raddr2_i (mi_cpl_raddr2_i[9:0]),
    .raddr3_i (mi_cpl_raddr3_i[9:0]),
    .rdata_o (mi_cpl_rdata_o[127:0]),
    .rdop_o (mi_cpl_rdop_o[15:0]),
    .ren0_i (mi_cpl_ren0_i),
    .ren1_i (mi_cpl_ren1_i),
    .ren2_i (mi_cpl_ren2_i),
    .ren3_i (mi_cpl_ren3_i),
    .ren4_i (mi_cpl_ren4_i),
    .ren5_i (mi_cpl_ren5_i),
    .ren6_i (mi_cpl_ren6_i),
    .ren7_i (mi_cpl_ren7_i)
  );

endmodule
