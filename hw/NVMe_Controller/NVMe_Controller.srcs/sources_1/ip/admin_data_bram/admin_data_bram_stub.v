// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Wed Nov  4 18:44:54 2020
// Host        : yhqiu running 64-bit CentOS Linux release 7.8.2003 (Core)
// Command     : write_verilog -force -mode synth_stub
//               /mnt/F/SSD/PJs_2019.2/NVMe_Controller/NVMe_Controller.srcs/sources_1/ip/admin_data_bram/admin_data_bram_stub.v
// Design      : admin_data_bram
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku040-ffva1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *)
module admin_data_bram(clka, ena, wea, addra, dina, douta, clkb, enb, web, addrb, 
  dinb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[31:0],addra[6:0],dina[255:0],douta[255:0],clkb,enb,web[15:0],addrb[7:0],dinb[127:0],doutb[127:0]" */;
  input clka;
  input ena;
  input [31:0]wea;
  input [6:0]addra;
  input [255:0]dina;
  output [255:0]douta;
  input clkb;
  input enb;
  input [15:0]web;
  input [7:0]addrb;
  input [127:0]dinb;
  output [127:0]doutb;
endmodule
