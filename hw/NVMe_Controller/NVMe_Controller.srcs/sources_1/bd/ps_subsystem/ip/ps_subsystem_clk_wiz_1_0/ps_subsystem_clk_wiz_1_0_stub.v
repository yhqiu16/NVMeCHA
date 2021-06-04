// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Mon Oct 19 17:02:57 2020
// Host        : yhqiu running 64-bit CentOS Linux release 7.8.2003 (Core)
// Command     : write_verilog -force -mode synth_stub
//               /mnt/F/SSD/PJs_2019.2/NVMe_Controller/NVMe_Controller.srcs/sources_1/bd/ps_subsystem/ip/ps_subsystem_clk_wiz_1_0/ps_subsystem_clk_wiz_1_0_stub.v
// Design      : ps_subsystem_clk_wiz_1_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku040-ffva1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module ps_subsystem_clk_wiz_1_0(clk_200M, reset, locked, clk_in1_p, clk_in1_n)
/* synthesis syn_black_box black_box_pad_pin="clk_200M,reset,locked,clk_in1_p,clk_in1_n" */;
  output clk_200M;
  input reset;
  output locked;
  input clk_in1_p;
  input clk_in1_n;
endmodule
