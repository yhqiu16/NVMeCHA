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
// File       : xdma_0_pcie3_ip_gt_common.v
// Version    : 4.4 
//-----------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
//  Design :  PCIe PHY Wrapper
//  Module :  GT Common
//--------------------------------------------------------------------------------------------------



`timescale 1ps / 1ps



//--------------------------------------------------------------------------------------------------
//  GT Common Module
//--------------------------------------------------------------------------------------------------
module xdma_0_pcie3_ip_gt_common #
(
    parameter         PHY_SIM_EN      = "FALSE", 
    parameter integer PHY_REFCLK_FREQ = 0,
    parameter         GT_QUAD_NUM     = 0       
)
(    
    //----------------------------------------------------------------------------------------------
    //  Clock Ports
    //----------------------------------------------------------------------------------------------
    input                               GTCOM_REFCLK,
    
    output                              GTCOM_QPLL1OUTCLK,
    output                              GTCOM_QPLL1OUTREFCLK,
    output                              GTCOM_QPLL1LOCK,
    
    //----------------------------------------------------------------------------------------------
    //  Reset Ports
    //----------------------------------------------------------------------------------------------
    input                               GTCOM_QPLL1PD,
    input                               GTCOM_QPLL1RESET,
            
    //----------------------------------------------------------------------------------------------
    //  Common Ports
    //----------------------------------------------------------------------------------------------
    input       [2:0]                   GTCOM_QPLLRATE,
    
    //----------------------------------------------------------------------------------------------
    //  DRP Ports
    //----------------------------------------------------------------------------------------------
    input                               GTCOM_DRPCLK,                                        
    input       [ 8:0]                  GTCOM_DRPADDR,                                       
    input                               GTCOM_DRPEN,                                             
    input                               GTCOM_DRPWE,     
    input       [15:0]                  GTCOM_DRPDI,                                      
                                                                
    output                              GTCOM_DRPRDY,    
    output      [15:0]                  GTCOM_DRPDO
);


    //----------------------------------------------------------------------------------------------
    //  Single vs. Mulit-lane Selection
    //----------------------------------------------------------------------------------------------
  //localparam [ 2:0] QPLLREFCLKSEL  = (GT_QUAD_NUM == 0) ? 3'd1 : (PHY_SIM_EN : 3'd1 : 3'd5);      // *** GTH 1.0 ***
    localparam [ 2:0] QPLLREFCLKSEL  = 3'd1;                                                        // Default
    

    //----------------------------------------------------------------------------------------------
    //  QPLL[0/1]_FBDIV - QPLL Feedback (N) Divider (Gen1 and Gen2)
    //----------------------------------------------------------------------------------------------
    localparam [ 7:0] QPLL_FBDIV = (PHY_REFCLK_FREQ == 2) ? 8'd40 : 
                                   (PHY_REFCLK_FREQ == 1) ? 8'd80 : 8'd100;
    
    
    
    //----------------------------------------------------------------------------------------------
    //  QPLL[1/0]_FBDIV_G3 - QPLL Feedback (N) Divider (Gen3)
    //----------------------------------------------------------------------------------------------    
    localparam [ 7:0] QPLL_FBDIV_G3 = (PHY_REFCLK_FREQ == 2) ? 8'd32 : 
                                      (PHY_REFCLK_FREQ == 1) ? 8'd64 : 8'd80;
    
    

//--------------------------------------------------------------------------------------------------
//  GTH Common
//--------------------------------------------------------------------------------------------------    
GTHE3_COMMON #
(   
    //---------------------------------------------------------------------------------------------- 
    //  Simulation Attributes
    //----------------------------------------------------------------------------------------------                                                    
    .SIM_RESET_SPEEDUP                  (PHY_SIM_EN),                                                                         
    .SIM_VERSION                        ("Ver_1"),                                                                          

    //----------------------------------------------------------------------------------------------               
    //  Clock Attributes
    //----------------------------------------------------------------------------------------------               
    .RXRECCLKOUT0_SEL                   ( 2'b00),
    .RXRECCLKOUT1_SEL                   ( 2'b00),                    

    //----------------------------------------------------------------------------------------------
    //  QPLL0 Attributes 
    //----------------------------------------------------------------------------------------------     
    .QPLL0_CFG0                         (16'b0011000000011100),                
    .QPLL0_CFG1                         (16'b0000000000011000),                 
    .QPLL0_CFG1_G3                      (16'b0000000000011000),                         
    .QPLL0_CFG2                         (16'b0000000001000000),                 // [6] : 1'b1 = select lower band VCO
    .QPLL0_CFG2_G3                      (16'b0000000001000000),                 // [6] : 1'b1 = select lower band VCO
    .QPLL0_CFG3                         (16'b0000000100100000),                 
    .QPLL0_CFG4                         (16'b0000000000001001),                 
    .QPLL0_CP                           (10'b1111111111),                       // Tune for PLL BW and peaking
    .QPLL0_CP_G3                        (10'b1111111111),                       // Tune for PLL BW and peaking
    .QPLL0_FBDIV                        (QPLL_FBDIV),
    .QPLL0_FBDIV_G3                     (QPLL_FBDIV_G3),
    .QPLL0_INIT_CFG0                    (16'b0000000000000000),
    .QPLL0_INIT_CFG1                    ( 8'b00000000),
    .QPLL0_LOCK_CFG                     (16'b0010010111101000),                 // [10] : 1'b1 = enable auto VCO selection
    .QPLL0_LOCK_CFG_G3                  (16'b0010010111101000),                 // [10] : 1'b1 = enable auto VCO selection
    .QPLL0_LPF                          (10'b0000010101),                       // Tune for PLL BW and peaking     
    .QPLL0_LPF_G3                       (10'b0000010101),                       // Tune for PLL BW and peaking
    .QPLL0_REFCLK_DIV                   (1),
    .QPLL0_SDM_CFG0                     (16'b0000000000000000),
    .QPLL0_SDM_CFG1                     (16'b0000000000000000),
    .QPLL0_SDM_CFG2                     (16'b0000000000000000),   
                     
    //---------------------------------------------------------------------------------------------- 
    //  QPLL1 Attributes               
    //----------------------------------------------------------------------------------------------    
    .QPLL1_CFG0                         (16'b0011000000011100),                 
    .QPLL1_CFG1                         (16'b0000000000011000),                 
    .QPLL1_CFG1_G3                      (16'b0000000000011000),                            
    .QPLL1_CFG2                         (16'b0000000001000000),                 // [6] : 1'b1 = select lower band VCO
    .QPLL1_CFG2_G3                      (16'b0000000001000000),                 // [6] : 1'b1 = select lower band VCO
    .QPLL1_CFG3                         (16'b0000000100100000),                 
    .QPLL1_CFG4                         (16'b0000000000000000),
    .QPLL1_CP                           (10'b1111111111),                       // Tune for PLL BW and peaking
    .QPLL1_CP_G3                        (10'b1111111111),                       // Tune for PLL BW and peaking
    .QPLL1_FBDIV                        (QPLL_FBDIV),
    .QPLL1_FBDIV_G3                     (QPLL_FBDIV_G3),
    .QPLL1_INIT_CFG0                    (16'b0000000000000000),
    .QPLL1_INIT_CFG1                    ( 8'b00000000),
    .QPLL1_LOCK_CFG                     (16'b0010010111101000),                 // [10] : 1'b1 = enable auto VCO selection, 16'b0010000111101000
    .QPLL1_LOCK_CFG_G3                  (16'b0010010111101000),                 // [10] : 1'b1 = enable auto VCO selection, 16'b0010000111101000
    .QPLL1_LPF                          (10'b0000010101),                       // Tune for PLL BW and peaking     
    .QPLL1_LPF_G3                       (10'b0000010101),                       // Tune for PLL BW and peaking
    .QPLL1_REFCLK_DIV                   (1),
    .QPLL1_SDM_CFG0                     (16'b0000000000000000),
    .QPLL1_SDM_CFG1                     (16'b0000000000000000),
    .QPLL1_SDM_CFG2                     (16'b0000000000000000),
       
    //----------------------------------------------------------------------------------------------
    //  Bias Attributes                                                          
    //----------------------------------------------------------------------------------------------
    .BIAS_CFG0                          (16'b0000000000000000),
    .BIAS_CFG1                          (16'b0000000000000000),
    .BIAS_CFG2                          (16'b0011000000000000),                 // Tune for PLL BW and peaking
    .BIAS_CFG3                          (16'b0000000001000000),                 
    .BIAS_CFG4                          (16'b0000000000000000),    
    .BIAS_CFG_RSVD                      (10'b0000000000),  
       
    //---------------------------------------------------------------------------------------------- 
    //  SDM0 Attributes                                                          
    //----------------------------------------------------------------------------------------------
    .SDM0DATA1_0                        (16'b0000000000000000),
    .SDM0DATA1_1                        ( 9'b000000000),
    .SDM0INITSEED0_0                    (16'b0000000000000000),
    .SDM0INITSEED0_1                    ( 9'b000000000),
    .SDM0_DATA_PIN_SEL                  ( 1'b0),
    .SDM0_WIDTH_PIN_SEL                 ( 1'b0),
    
    //---------------------------------------------------------------------------------------------- 
    //  SDM0 Attributes                                                          
    //----------------------------------------------------------------------------------------------     
    .SDM1DATA1_0                        (16'b0000000000000000),
    .SDM1DATA1_1                        ( 9'b000000000),
    .SDM1INITSEED0_0                    (16'b0000000000000000),
    .SDM1INITSEED0_1                    ( 9'b000000000),     
    .SDM1_DATA_PIN_SEL                  ( 1'b0),
    .SDM1_WIDTH_PIN_SEL                 ( 1'b0),                              
          
    //----------------------------------------------------------------------------------------------
    //  MISC Attributes                                                         
    //----------------------------------------------------------------------------------------------            
    .COMMON_CFG0                        (16'b0000000000000000),
    .COMMON_CFG1                        (16'b0000000000000000),
    .POR_CFG                            (16'b0000000000000100),                 //
    .RSVD_ATTR0                         (16'b0000000000000001),                 // [0] : 1'b1 = QPLL0 enable PCIe mode
    .RSVD_ATTR1                         (16'b0000000000000000),    
    .RSVD_ATTR2                         (16'b0000000000000001),                 // [0] : 1'b1 = QPLL1 enable PCIe mode
    .RSVD_ATTR3                         (16'b0000000000000000),
    .SARC_EN                            ( 1'b0),
    .SARC_SEL                           ( 1'b0)                                                                                 
)
gthe3_common_i 
(       
    //----------------------------------------------------------------------------------------------
    //  QPLL0 Clock Ports
    //----------------------------------------------------------------------------------------------
    .GTGREFCLK0                         ( 1'd0), 
    .GTREFCLK00                         ( 1'd0),
    .GTREFCLK10                         ( 1'd0),
    .GTNORTHREFCLK00                    ( 1'd0),
    .GTNORTHREFCLK10                    ( 1'd0),
    .GTSOUTHREFCLK00                    ( 1'd0),
    .GTSOUTHREFCLK10                    ( 1'd0),
   
    .RXRECCLK0_SEL                      (),
    .REFCLKOUTMONITOR0                  (),
    
    //----------------------------------------------------------------------------------------------
    //  QPLL1 Clock Ports
    //----------------------------------------------------------------------------------------------
    .GTGREFCLK1                         ( 1'd0),
    .GTREFCLK01                         (GTCOM_REFCLK),
    .GTREFCLK11                         ( 1'd0),
    .GTNORTHREFCLK01                    ( 1'd0),    
    .GTNORTHREFCLK11                    ( 1'd0),
    .GTSOUTHREFCLK01                    ( 1'd0),
    .GTSOUTHREFCLK11                    ( 1'd0),        
        
	.RXRECCLK1_SEL	                    (),
    .REFCLKOUTMONITOR1                  (),   
        
    //----------------------------------------------------------------------------------------------
    //  QPLL Ports
    //----------------------------------------------------------------------------------------------
    .QPLLRSVD1                          ( 8'd0),
    .QPLLRSVD2                          ({2'd0, GTCOM_QPLLRATE}),               // [2:0] : QPLL0 rate
    .QPLLRSVD3                          ({2'd0, GTCOM_QPLLRATE}),               // [2:0] : QPLL1 rate
    .QPLLRSVD4                          ( 8'd0),
    
    .QPLLDMONITOR0                      (),
    .QPLLDMONITOR1                      (),
    
    //----------------------------------------------------------------------------------------------
    //  QPLL0 Ports
    //----------------------------------------------------------------------------------------------
    .QPLL0CLKRSVD0                      ( 1'd0),
    .QPLL0CLKRSVD1                      ( 1'd0),
    .QPLL0LOCKDETCLK                    ( 1'd0),
    .QPLL0LOCKEN                        ( 1'd0),
    .QPLL0PD                            ( 1'd1),
    .QPLL0REFCLKSEL                     ( 3'd1),                                // selects GTREFCLK00                             
    .QPLL0RESET                         ( 1'd1),
       
    .QPLL0FBCLKLOST                     (),
    .QPLL0LOCK                          (),
    .QPLL0OUTCLK                        (),
    .QPLL0OUTREFCLK                     (),
    .QPLL0REFCLKLOST                    (),                                          
                                               
    //----------------------------------------------------------------------------------------------
    //  QPLL1 Ports
    //----------------------------------------------------------------------------------------------
    .QPLL1CLKRSVD0                      ( 1'd0),
    .QPLL1CLKRSVD1                      ( 1'd0),
    .QPLL1LOCKDETCLK                    ( 1'd0),
    .QPLL1LOCKEN                        ( 1'd1),
    .QPLL1PD                            (GTCOM_QPLL1PD),
    .QPLL1REFCLKSEL                     (QPLLREFCLKSEL),                        // 1'd1 = selects GTREFCLK01
    .QPLL1RESET                         (GTCOM_QPLL1RESET),      
     
    .QPLL1FBCLKLOST                     (),  
    .QPLL1LOCK                          (GTCOM_QPLL1LOCK),       
    .QPLL1OUTCLK                        (GTCOM_QPLL1OUTCLK),     
    .QPLL1OUTREFCLK                     (GTCOM_QPLL1OUTREFCLK),                       
    .QPLL1REFCLKLOST                    (),                                        
                                                                                                   
    //----------------------------------------------------------------------------------------------
    //  DRP Ports
    //----------------------------------------------------------------------------------------------
    .DRPCLK                             (GTCOM_DRPCLK),                                        
    .DRPADDR                            (GTCOM_DRPADDR),                                       
    .DRPEN                              (GTCOM_DRPEN),                                             
    .DRPWE                              (GTCOM_DRPWE),     
    .DRPDI                              (GTCOM_DRPDI),                                      
                                                                         
    .DRPRDY                             (GTCOM_DRPRDY),    
    .DRPDO                              (GTCOM_DRPDO),                                      
                                                                                              
    //----------------------------------------------------------------------------------------------
    //  Band Gap Ports
    //----------------------------------------------------------------------------------------------
    .BGBYPASSB                          ( 1'b1),                                
    .BGMONITORENB                       ( 1'b1),                                
    .BGPDB                              ( 1'b1),                                
    .BGRCALOVRDENB                      ( 1'b1),                                
    .BGRCALOVRD                         ( 5'b11111),                               
        
    //----------------------------------------------------------------------------------------------
    //  MISC Ports
    //----------------------------------------------------------------------------------------------
    .PMARSVD0                           ( 8'd0),            
    .PMARSVD1                           ( 8'd0),
    .RCALENB                            ( 1'd1),                            

    .PMARSVDOUT0                        (),
    .PMARSVDOUT1                        ()
);



endmodule

