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
// File       : xdma_0_pcie3_ip_phy_clk.v
// Version    : 4.4 
//-----------------------------------------------------------------------------


//--------------------------------------------------------------------------------------------------
//  Design :  PCIe PHY Wrapper 
//  Module :  PHY Clock
//--------------------------------------------------------------------------------------------------



`timescale 1ps / 1ps



//--------------------------------------------------------------------------------------------------
//  Clock Module
//--------------------------------------------------------------------------------------------------
module xdma_0_pcie3_ip_phy_clk 
(
    //--------------------------------------------------------------------------
    //  PCLK Ports
    //--------------------------------------------------------------------------
    input                               CLK_PCLK_CE,
    input                               CLK_PCLK_CEMASK,
    input                               CLK_PCLK_CLR,
    input                               CLK_PCLK_MASK,
    input       [ 2:0]                  CLK_PCLK_DIV,
    input                               CLK_PCLK_IN,   
    output                              CLK_PCLK,
    
    //--------------------------------------------------------------------------
    //  CORECLK Ports
    //--------------------------------------------------------------------------
    input                               CLK_CORECLK_CE,
    input                               CLK_CORECLK_CEMASK,
    input                               CLK_CORECLK_CLR,
    input                               CLK_CORECLK_MASK,
    input       [ 2:0]                  CLK_CORECLK_DIV,
    input                               CLK_CORECLK_IN,
    output                              CLK_CORECLK,      
    
    //--------------------------------------------------------------------------
    //  USERCLK Ports
    //--------------------------------------------------------------------------
    input                               CLK_USERCLK_CE,
    input                               CLK_USERCLK_CEMASK,
    input                               CLK_USERCLK_CLR,
    input                               CLK_USERCLK_MASK,
    input       [ 2:0]                  CLK_USERCLK_DIV,
    input                               CLK_USERCLK_IN,  
    output                              CLK_USERCLK     
);



//--------------------------------------------------------------------------------------------------
//  BUFG_GT for PCLK
//--------------------------------------------------------------------------------------------------
BUFG_GT bufg_gt_pclk 
(
     //-------------------------------------------------------------------------
     //  Input Ports
     //-------------------------------------------------------------------------
    .CE                                 (CLK_PCLK_CE),
    .CEMASK                             (CLK_PCLK_CEMASK),
    .CLR                                (CLK_PCLK_CLR),
    .CLRMASK                            (CLK_PCLK_MASK),
    .DIV                                (CLK_PCLK_DIV),
    .I                                  (CLK_PCLK_IN),
    
     //-------------------------------------------------------------------------
     //  Output Ports
     //-------------------------------------------------------------------------
    .O                                  (CLK_PCLK)
);



//--------------------------------------------------------------------------------------------------
//  BUFG_GT for USERCLK
//--------------------------------------------------------------------------------------------------
BUFG_GT bufg_gt_userclk 
(
     //-------------------------------------------------------------------------
     //  Input Ports
     //-------------------------------------------------------------------------
    .CE                                 (CLK_USERCLK_CE),
    .CEMASK                             (CLK_USERCLK_CEMASK),
    .CLR                                (CLK_USERCLK_CLR),
    .CLRMASK                            (CLK_USERCLK_MASK),
    .DIV                                (CLK_USERCLK_DIV),
    .I                                  (CLK_USERCLK_IN),
    
     //-------------------------------------------------------------------------
     //  Output Ports
     //-------------------------------------------------------------------------
    .O                                  (CLK_USERCLK)
);



//--------------------------------------------------------------------------------------------------
//  BUFG_GT for CORECLK
//--------------------------------------------------------------------------------------------------
BUFG_GT bufg_gt_coreclk 
(
     //-------------------------------------------------------------------------
     //  Input Ports
     //-------------------------------------------------------------------------
    .CE                                 (CLK_CORECLK_CE),
    .CEMASK                             (CLK_CORECLK_CEMASK),
    .CLR                                (CLK_CORECLK_CLR),
    .CLRMASK                            (CLK_CORECLK_MASK),
    .DIV                                (CLK_CORECLK_DIV),
    .I                                  (CLK_CORECLK_IN),

     //-------------------------------------------------------------------------
     //  Output Ports
     //-------------------------------------------------------------------------
    .O                                  (CLK_CORECLK)
);



endmodule


