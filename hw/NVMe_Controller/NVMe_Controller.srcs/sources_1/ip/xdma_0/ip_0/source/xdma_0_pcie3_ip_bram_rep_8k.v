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
// File       : xdma_0_pcie3_ip_bram_rep_8k.v
// Version    : 4.4 
//-----------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////

`timescale 1ps/1ps

module xdma_0_pcie3_ip_bram_rep_8k
#(
  parameter TCQ = 100
  ) (
  input  wire         clk_i,
  input  wire         reset_i,
  input  wire   [8:0] addr_i,
  input  wire [127:0] wdata_i,
  input  wire  [15:0] wdip_i,
  input  wire   [1:0] wen_i,
  input  wire   [1:0] rden_i,
  output wire [127:0] rdata_o,
  output wire  [15:0] rdop_o
  );

  genvar              i;

  wire          [1:0] wen = {wen_i[1], wen_i[0]};
  wire          [1:0] rden = {rden_i[1], rden_i[0]};

  generate
    for (i = 0; i < 2; i = i + 1)
    begin : RAMB36E2
      RAMB36E2 #(
        .DOA_REG (1),
        .DOB_REG (1),
        .EN_ECC_READ ("FALSE"),
        .EN_ECC_WRITE ("FALSE"),
        .INIT_A (36'h000000000),
        .INIT_B (36'h000000000),
        .INIT_FILE ("NONE"),
        .READ_WIDTH_A (36),
        .READ_WIDTH_B (36),
        .RSTREG_PRIORITY_A ("REGCE"),
        .RSTREG_PRIORITY_B ("REGCE"),
        .SIM_COLLISION_CHECK ("ALL"),
        .SRVAL_A (36'h000000000),
        .SRVAL_B (36'h000000000),
        .WRITE_MODE_A ("READ_FIRST"),
        .WRITE_MODE_B ("READ_FIRST"),
        .WRITE_WIDTH_A (36),
        .WRITE_WIDTH_B (36))
      ramb36e2_inst (
        .ADDRENA (1'b1),
        .ADDRENB (1'b1),
        .CASDIMUXA (1'b0),
        .CASDIMUXB (1'b0),
        .CASDOMUXA (1'b0),
        .CASDOMUXB (1'b0),
        .CASDOMUXEN_A (1'b0),
        .CASDOMUXEN_B (1'b0),
        .CASINDBITERR (1'b0),
        .CASINSBITERR (1'b0),
        .CASOREGIMUXA (1'b0),
        .CASOREGIMUXB (1'b0),
        .CASOREGIMUXEN_A (1'b0),
        .CASOREGIMUXEN_B (1'b0),
        .ECCPIPECE (1'b0),
        .SLEEP (1'b0),
        .CASDINA (32'b0),
        .CASDINB (32'b0),
        .CASDINPA(4'b0),
        .CASDINPB(4'b0),
        .CASDOUTA (),
        .CASDOUTB (),
        .CASDOUTPA (),
        .CASDOUTPB (),
	.CASOUTDBITERR (),
	.CASOUTSBITERR (),
        .CLKARDCLK (clk_i),
        .CLKBWRCLK (clk_i),
        .DBITERR (),
        .ENARDEN (1'b1),
        .ENBWREN (1'b1),
        .INJECTDBITERR (1'b0),
        .INJECTSBITERR (1'b0),
        .REGCEAREGCE (1'b1),
        .REGCEB (1'b1),
        .RSTRAMARSTRAM (1'b0),
        .RSTRAMB (1'b0),
        .RSTREGARSTREG (1'b0),
        .RSTREGB (1'b0),
        .SBITERR (),
        .ADDRARDADDR ({addr_i[8:0], 6'b0}),
        .ADDRBWRADDR ({addr_i[8:0], 1'b1, 5'b0}),
        .DINADIN (wdata_i[(2*32*i)+31:(2*32*i)+0]),
        .DINBDIN (wdata_i[(2*32*i)+63:(2*32*i)+32]),
        .DINPADINP (wdip_i[(2*4*i)+3:(2*4*i)+0]),
        .DINPBDINP (wdip_i[(2*4*i)+7:(2*4*i)+4]),
        .DOUTADOUT (rdata_o[(2*32*i)+31:(2*32*i)+0]),
        .DOUTBDOUT (rdata_o[(2*32*i)+63:(2*32*i)+32]),
        .DOUTPADOUTP (rdop_o[(2*4*i)+3:(2*4*i)+0]),
        .DOUTPBDOUTP (rdop_o[(2*4*i)+7:(2*4*i)+4]),
        .ECCPARITY (),
        .RDADDRECC (),
        .WEA ({4{wen[i]}}),
        .WEBWE ({4'b0, {4{wen[i]}}})
      );
    end
  endgenerate

endmodule
