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
// File       : xdma_0_pcie3_ip_bram_16k.v
// Version    : 4.4 
//-----------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////

`timescale 1ps/1ps

module xdma_0_pcie3_ip_bram_16k 
#(
  parameter TCQ = 100
  ) (
  input  wire         clk_i,
  input  wire         reset_i,
  input  wire   [9:0] waddr0_i,
  input  wire   [9:0] waddr1_i,
  input  wire   [9:0] waddr2_i,
  input  wire   [9:0] waddr3_i,
  input  wire [127:0] wdata_i,
  input  wire  [15:0] wdip_i,
  input  wire   [7:0] wen_i,
  input  wire   [9:0] raddr0_i,
  input  wire   [9:0] raddr1_i,
  input  wire   [9:0] raddr2_i,
  input  wire   [9:0] raddr3_i,
  output wire [127:0] rdata_o,
  output wire  [15:0] rdop_o,
  input  wire   [7:0] ren_i
  );

  genvar              i;

  wire         [79:0] waddr;
  wire         [79:0] raddr;
  wire          [7:0] wen;
  wire          [7:0] ren;

  assign wen = {wen_i[7], wen_i[6], wen_i[5], wen_i[4], wen_i[3], wen_i[2], wen_i[1], wen_i[0]};
  assign ren = {ren_i[7], ren_i[6], ren_i[5], ren_i[4], ren_i[3], ren_i[2], ren_i[1], ren_i[0]};

  generate
      assign waddr = {waddr3_i, waddr3_i, waddr2_i, waddr2_i, waddr1_i, waddr1_i, waddr0_i, waddr0_i};
      assign raddr = {raddr3_i, raddr3_i, raddr2_i, raddr2_i, raddr1_i, raddr1_i, raddr0_i, raddr0_i};
      for (i = 0; i < 8; i = i + 1)
      begin : RAMB18E2
        RAMB18E2 #(
          .DOA_REG (1),
          .DOB_REG (1),
          .INIT_A (18'h00000),
          .INIT_B (18'h00000),
          .INIT_FILE ("NONE"),
          .READ_WIDTH_A (18),
          .READ_WIDTH_B (18),
          .RSTREG_PRIORITY_A ("REGCE"),
          .RSTREG_PRIORITY_B ("REGCE"),
          .SIM_COLLISION_CHECK ("ALL"),
          .SRVAL_A (18'h00000),
          .SRVAL_B (18'h00000),
        .WRITE_MODE_A ("READ_FIRST"),
        .WRITE_MODE_B ("READ_FIRST"),
          .WRITE_WIDTH_A (18),
          .WRITE_WIDTH_B (18))
        ramb18e2_inst (
          .ADDRENA (1'b1),
          .ADDRENB (1'b1),
          .CASDIMUXA (1'b0),
          .CASDIMUXB (1'b0),
          .CASDOMUXA (1'b0),
          .CASDOMUXB (1'b0),
          .CASDOMUXEN_A (1'b0),
          .CASDOMUXEN_B (1'b0),
          .CASOREGIMUXA (1'b0),
          .CASOREGIMUXB (1'b0),
          .CASOREGIMUXEN_A (1'b0),
          .CASOREGIMUXEN_B (1'b0),
          .SLEEP (1'b0),
          .CASDINA (16'b0),
          .CASDINB (16'b0),
          .CASDINPA(2'b0),
          .CASDINPB(2'b0),
          .CASDOUTA (),
          .CASDOUTB (),
          .CASDOUTPA (),
          .CASDOUTPB (),
          .CLKARDCLK (clk_i),
          .CLKBWRCLK (clk_i),
          //.ENARDEN (1'b1),
          .ENARDEN (wen[i]),
          .ENBWREN (ren[i]),
          .REGCEAREGCE (1'b0),
          .REGCEB (1'b1),
          .RSTRAMARSTRAM (1'b0),
          .RSTRAMB (1'b0),
          .RSTREGARSTREG (1'b0),
          .RSTREGB (1'b0),
          .ADDRARDADDR ({waddr[(10*i)+9:(10*i)+0], 4'b0}),
          .ADDRBWRADDR ({raddr[(10*i)+9:(10*i)+0], 4'b0}),
          .DINADIN (wdata_i[(16*i)+15:(16*i)+0]),
          .DINPADINP (wdip_i[(2*i)+1:(2*i)+0]),
          .DINBDIN ({16'b0}),
          .DINPBDINP (2'b0),
          .DOUTADOUT (),
          .DOUTBDOUT (rdata_o[(16*i)+15:(16*i)+0]),            
          .DOUTPADOUTP (),
          .DOUTPBDOUTP (rdop_o[(2*i)+1:(2*i)+0]),               
          //.WEA ({wen[i], wen[i]}),
          //.WEBWE ({1'b0, 1'b0, 1'b0, 1'b0})
          .WEA (2'b11),
          .WEBWE (4'b0000)
        );
      end
  endgenerate

endmodule
