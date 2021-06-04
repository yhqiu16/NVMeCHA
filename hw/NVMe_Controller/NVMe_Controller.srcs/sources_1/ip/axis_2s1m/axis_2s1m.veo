// (c) Copyright 1995-2020 Xilinx, Inc. All rights reserved.
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
// DO NOT MODIFY THIS FILE.

// IP VLNV: xilinx.com:ip:axis_interconnect:1.1
// IP Revision: 18

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
axis_2s1m your_instance_name (
  .ACLK(ACLK),                                  // input wire ACLK
  .ARESETN(ARESETN),                            // input wire ARESETN
  .S00_AXIS_ACLK(S00_AXIS_ACLK),                // input wire S00_AXIS_ACLK
  .S01_AXIS_ACLK(S01_AXIS_ACLK),                // input wire S01_AXIS_ACLK
  .S00_AXIS_ARESETN(S00_AXIS_ARESETN),          // input wire S00_AXIS_ARESETN
  .S01_AXIS_ARESETN(S01_AXIS_ARESETN),          // input wire S01_AXIS_ARESETN
  .S00_AXIS_TVALID(S00_AXIS_TVALID),            // input wire S00_AXIS_TVALID
  .S01_AXIS_TVALID(S01_AXIS_TVALID),            // input wire S01_AXIS_TVALID
  .S00_AXIS_TREADY(S00_AXIS_TREADY),            // output wire S00_AXIS_TREADY
  .S01_AXIS_TREADY(S01_AXIS_TREADY),            // output wire S01_AXIS_TREADY
  .S00_AXIS_TDATA(S00_AXIS_TDATA),              // input wire [255 : 0] S00_AXIS_TDATA
  .S01_AXIS_TDATA(S01_AXIS_TDATA),              // input wire [255 : 0] S01_AXIS_TDATA
  .S00_AXIS_TKEEP(S00_AXIS_TKEEP),              // input wire [31 : 0] S00_AXIS_TKEEP
  .S01_AXIS_TKEEP(S01_AXIS_TKEEP),              // input wire [31 : 0] S01_AXIS_TKEEP
  .S00_AXIS_TLAST(S00_AXIS_TLAST),              // input wire S00_AXIS_TLAST
  .S01_AXIS_TLAST(S01_AXIS_TLAST),              // input wire S01_AXIS_TLAST
  .S00_AXIS_TDEST(S00_AXIS_TDEST),              // input wire [0 : 0] S00_AXIS_TDEST
  .S01_AXIS_TDEST(S01_AXIS_TDEST),              // input wire [0 : 0] S01_AXIS_TDEST
  .M00_AXIS_ACLK(M00_AXIS_ACLK),                // input wire M00_AXIS_ACLK
  .M00_AXIS_ARESETN(M00_AXIS_ARESETN),          // input wire M00_AXIS_ARESETN
  .M00_AXIS_TVALID(M00_AXIS_TVALID),            // output wire M00_AXIS_TVALID
  .M00_AXIS_TREADY(M00_AXIS_TREADY),            // input wire M00_AXIS_TREADY
  .M00_AXIS_TDATA(M00_AXIS_TDATA),              // output wire [255 : 0] M00_AXIS_TDATA
  .M00_AXIS_TKEEP(M00_AXIS_TKEEP),              // output wire [31 : 0] M00_AXIS_TKEEP
  .M00_AXIS_TLAST(M00_AXIS_TLAST),              // output wire M00_AXIS_TLAST
  .M00_AXIS_TDEST(M00_AXIS_TDEST),              // output wire [0 : 0] M00_AXIS_TDEST
  .S00_ARB_REQ_SUPPRESS(S00_ARB_REQ_SUPPRESS),  // input wire S00_ARB_REQ_SUPPRESS
  .S01_ARB_REQ_SUPPRESS(S01_ARB_REQ_SUPPRESS),  // input wire S01_ARB_REQ_SUPPRESS
  .S00_DECODE_ERR(S00_DECODE_ERR),              // output wire S00_DECODE_ERR
  .S01_DECODE_ERR(S01_DECODE_ERR)              // output wire S01_DECODE_ERR
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

// You must compile the wrapper file axis_2s1m.v when simulating
// the core, axis_2s1m. When compiling the wrapper file, be sure to
// reference the Verilog simulation library.

