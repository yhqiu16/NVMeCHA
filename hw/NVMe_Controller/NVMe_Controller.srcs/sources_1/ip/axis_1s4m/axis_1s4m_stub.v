// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Tue Oct 13 18:20:41 2020
// Host        : yhqiu running 64-bit CentOS Linux release 7.8.2003 (Core)
// Command     : write_verilog -force -mode synth_stub
//               /mnt/F/SSD/PJs_2019.2/NVMe_Controller/NVMe_Controller.srcs/sources_1/ip/axis_1s4m/axis_1s4m_stub.v
// Design      : axis_1s4m
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku040-ffva1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "axis_interconnect_v1_1_18_axis_interconnect_16x16_top,Vivado 2019.2" *)
module axis_1s4m(ACLK, ARESETN, S00_AXIS_ACLK, S00_AXIS_ARESETN, 
  S00_AXIS_TVALID, S00_AXIS_TREADY, S00_AXIS_TDATA, S00_AXIS_TKEEP, S00_AXIS_TLAST, 
  S00_AXIS_TDEST, M00_AXIS_ACLK, M01_AXIS_ACLK, M02_AXIS_ACLK, M03_AXIS_ACLK, 
  M00_AXIS_ARESETN, M01_AXIS_ARESETN, M02_AXIS_ARESETN, M03_AXIS_ARESETN, M00_AXIS_TVALID, 
  M01_AXIS_TVALID, M02_AXIS_TVALID, M03_AXIS_TVALID, M00_AXIS_TREADY, M01_AXIS_TREADY, 
  M02_AXIS_TREADY, M03_AXIS_TREADY, M00_AXIS_TDATA, M01_AXIS_TDATA, M02_AXIS_TDATA, 
  M03_AXIS_TDATA, M00_AXIS_TKEEP, M01_AXIS_TKEEP, M02_AXIS_TKEEP, M03_AXIS_TKEEP, 
  M00_AXIS_TLAST, M01_AXIS_TLAST, M02_AXIS_TLAST, M03_AXIS_TLAST, M00_AXIS_TDEST, 
  M01_AXIS_TDEST, M02_AXIS_TDEST, M03_AXIS_TDEST, S00_DECODE_ERR)
/* synthesis syn_black_box black_box_pad_pin="ACLK,ARESETN,S00_AXIS_ACLK,S00_AXIS_ARESETN,S00_AXIS_TVALID,S00_AXIS_TREADY,S00_AXIS_TDATA[255:0],S00_AXIS_TKEEP[31:0],S00_AXIS_TLAST,S00_AXIS_TDEST[1:0],M00_AXIS_ACLK,M01_AXIS_ACLK,M02_AXIS_ACLK,M03_AXIS_ACLK,M00_AXIS_ARESETN,M01_AXIS_ARESETN,M02_AXIS_ARESETN,M03_AXIS_ARESETN,M00_AXIS_TVALID,M01_AXIS_TVALID,M02_AXIS_TVALID,M03_AXIS_TVALID,M00_AXIS_TREADY,M01_AXIS_TREADY,M02_AXIS_TREADY,M03_AXIS_TREADY,M00_AXIS_TDATA[255:0],M01_AXIS_TDATA[255:0],M02_AXIS_TDATA[255:0],M03_AXIS_TDATA[255:0],M00_AXIS_TKEEP[31:0],M01_AXIS_TKEEP[31:0],M02_AXIS_TKEEP[31:0],M03_AXIS_TKEEP[31:0],M00_AXIS_TLAST,M01_AXIS_TLAST,M02_AXIS_TLAST,M03_AXIS_TLAST,M00_AXIS_TDEST[1:0],M01_AXIS_TDEST[1:0],M02_AXIS_TDEST[1:0],M03_AXIS_TDEST[1:0],S00_DECODE_ERR" */;
  input ACLK;
  input ARESETN;
  input S00_AXIS_ACLK;
  input S00_AXIS_ARESETN;
  input S00_AXIS_TVALID;
  output S00_AXIS_TREADY;
  input [255:0]S00_AXIS_TDATA;
  input [31:0]S00_AXIS_TKEEP;
  input S00_AXIS_TLAST;
  input [1:0]S00_AXIS_TDEST;
  input M00_AXIS_ACLK;
  input M01_AXIS_ACLK;
  input M02_AXIS_ACLK;
  input M03_AXIS_ACLK;
  input M00_AXIS_ARESETN;
  input M01_AXIS_ARESETN;
  input M02_AXIS_ARESETN;
  input M03_AXIS_ARESETN;
  output M00_AXIS_TVALID;
  output M01_AXIS_TVALID;
  output M02_AXIS_TVALID;
  output M03_AXIS_TVALID;
  input M00_AXIS_TREADY;
  input M01_AXIS_TREADY;
  input M02_AXIS_TREADY;
  input M03_AXIS_TREADY;
  output [255:0]M00_AXIS_TDATA;
  output [255:0]M01_AXIS_TDATA;
  output [255:0]M02_AXIS_TDATA;
  output [255:0]M03_AXIS_TDATA;
  output [31:0]M00_AXIS_TKEEP;
  output [31:0]M01_AXIS_TKEEP;
  output [31:0]M02_AXIS_TKEEP;
  output [31:0]M03_AXIS_TKEEP;
  output M00_AXIS_TLAST;
  output M01_AXIS_TLAST;
  output M02_AXIS_TLAST;
  output M03_AXIS_TLAST;
  output [1:0]M00_AXIS_TDEST;
  output [1:0]M01_AXIS_TDEST;
  output [1:0]M02_AXIS_TDEST;
  output [1:0]M03_AXIS_TDEST;
  output S00_DECODE_ERR;
endmodule
