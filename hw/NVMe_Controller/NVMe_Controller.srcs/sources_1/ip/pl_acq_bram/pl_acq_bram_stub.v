// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Wed Nov  4 16:54:23 2020
// Host        : yhqiu running 64-bit CentOS Linux release 7.8.2003 (Core)
// Command     : write_verilog -force -mode synth_stub -rename_top pl_acq_bram -prefix
//               pl_acq_bram_ pl_acq_bram_stub.v
// Design      : pl_acq_bram
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku040-ffva1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *)
module pl_acq_bram(clka, ena, wea, addra, dina, clkb, enb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[15:0],addra[2:0],dina[127:0],clkb,enb,addrb[2:0],doutb[127:0]" */;
  input clka;
  input ena;
  input [15:0]wea;
  input [2:0]addra;
  input [127:0]dina;
  input clkb;
  input enb;
  input [2:0]addrb;
  output [127:0]doutb;
endmodule
