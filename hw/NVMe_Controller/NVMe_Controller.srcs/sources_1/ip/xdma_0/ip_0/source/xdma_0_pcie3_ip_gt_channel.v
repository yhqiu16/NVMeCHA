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
// File       : xdma_0_pcie3_ip_gt_channel.v
// Version    : 4.4 
//-----------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
//  Design :  PCIe PHY Wrapper 
//  Module :  GT Channel
//--------------------------------------------------------------------------------------------------



`timescale 1ps / 1ps



//--------------------------------------------------------------------------------------------------
//  GT Channel Module
//--------------------------------------------------------------------------------------------------
module xdma_0_pcie3_ip_gt_channel #
(
    parameter         PHY_SIM_EN       = "FALSE", 
    parameter integer PHY_LANE         = 1,
    parameter integer PHY_MAX_SPEED    = 3,
    parameter         PHY_ASYNC_EN     = "FALSE",     
    parameter         PHY_REFCLK_FREQ  = 0,         
    parameter integer PHY_USERCLK_FREQ = 4,           
    parameter integer PHY_CORECLK_FREQ = 2,
    parameter         GT_LANE_NUM      = 0
)
(    
    //--------------------------------------------------------------------------
    //  Clock Ports
    //--------------------------------------------------------------------------
    input                               GT_GTREFCLK0,
    input                               GT_TXUSRCLK,
    input                               GT_RXUSRCLK,
    input                               GT_TXUSRCLK2,
    input                               GT_RXUSRCLK2,    

    input  [2:0]                        GTHE3_TXOUTCLKSEL_OUT,
    //--------------------------------------------------------------------------   
    //  BUFG_GT Controller Ports                                                                        
    //--------------------------------------------------------------------------                   
    output      [ 2:0]                  GT_BUFGTCE,       
    output      [ 2:0]                  GT_BUFGTCEMASK, 
    output      [ 2:0]                  GT_BUFGTRESET,
    output      [ 2:0]                  GT_BUFGTRSTMASK,
    output      [ 8:0]                  GT_BUFGTDIV,   
    output                              GT_TXOUTCLK, 
    output                              GT_RXOUTCLK,
    output                              GT_RXRECCLKOUT,
    output                              GT_RXPMARESETDONE,            
    //--------------------------------------------------------------------------
    //  Reset Ports
    //--------------------------------------------------------------------------
    input                               GT_CPLLPD,
    input                               GT_CPLLRESET,
    input                               GT_TXPROGDIVRESET,
    input                               GT_RXPROGDIVRESET,
    input                               GT_GTTXRESET,
    input                               GT_GTRXRESET,
    input                               GT_TXUSERRDY,
    input                               GT_RXUSERRDY,
                                        
    output                              GT_GTPOWERGOOD,
    output                              GT_TXPROGDIVRESETDONE,
    output                              GT_RXPROGDIVRESETDONE,
    output                              GT_TXRESETDONE,
    output                              GT_RXRESETDONE,                  
    output                              GT_RXCOMMADET, 
    //--------------------------------------------------------------------------
    //  QPLL Ports
    //--------------------------------------------------------------------------
    input                               GT_QPLLCLK,
    input                               GT_QPLLREFCLK,
    input                               GT_QPLLLOCK,
    
    output      [2:0]                   GT_QPLLRATE,
    
    //--------------------------------------------------------------------------
    //  Serial Line Ports
    //--------------------------------------------------------------------------
    input                               GT_RXN,
    input                               GT_RXP,
    
    output                              GT_TXP,
    output                              GT_TXN,
    
    //--------------------------------------------------------------------------
    //  TX Data Ports 
    //--------------------------------------------------------------------------
    input       [31:0]                  GT_TXDATA,
    input       [ 1:0]                  GT_TXDATAK,   
    input                               GT_TXDATA_VALID,
    input                               GT_TXSTART_BLOCK,      
    input       [ 1:0]                  GT_TXSYNC_HEADER,  
    
    //--------------------------------------------------------------------------
    //  RX Data Ports 
    //--------------------------------------------------------------------------
    output      [31:0]                  GT_RXDATA,
    output      [ 1:0]                  GT_RXDATAK,
    output                              GT_RXDATA_VALID,
    output                              GT_RXSTART_BLOCK,      
    output      [ 1:0]                  GT_RXSYNC_HEADER,     
    
    //--------------------------------------------------------------------------
    //  PHY Command Ports
    //--------------------------------------------------------------------------
    input                               GT_TXDETECTRX,
    input                               GT_TXELECIDLE,
    input                               GT_TXCOMPLIANCE,
    input                               GT_RXPOLARITY,
    input       [ 1:0]                  GT_POWERDOWN,
    input       [ 1:0]                  GT_RATE,
    input                               GT_RXCDRHOLD,                                                                 
      
    //--------------------------------------------------------------------------
    //  PHY Status Ports
    //--------------------------------------------------------------------------
    output                              GT_RXVALID,
    output                              GT_PHYSTATUS,
    output                              GT_RXELECIDLE,
    output      [ 2:0]                  GT_RXSTATUS,
    output                              GT_TXPHINITDONE,  
    //--------------------------------------------------------------------------
    //  TX Equalization Ports 
    //--------------------------------------------------------------------------
    input       [ 2:0]                  GT_TXMARGIN,
    input                               GT_TXSWING,
    input                               GT_TXDEEMPH,
    
    //--------------------------------------------------------------------------
    //  TX Equalization Ports (Gen3)
    //--------------------------------------------------------------------------
    input       [ 4:0]                  GT_TXPRECURSOR,
    input       [ 6:0]                  GT_TXMAINCURSOR,
    input       [ 4:0]                  GT_TXPOSTCURSOR,      
    
    //--------------------------------------------------------------------------
    //  PCIe PCS Ports
    //--------------------------------------------------------------------------
    input                               GT_PCIERSTIDLE,        
    input                               GT_PCIERSTTXSYNCSTART, 
    input                               GT_PCIEEQRXEQADAPTDONE,
    input                               GT_PCIEUSERRATEDONE,
             
    output                              GT_PCIEUSERPHYSTATUSRST,    
    output      [ 1:0]                  GT_PCIERATEQPLLPD,                  
    output      [ 1:0]                  GT_PCIERATEQPLLRESET,                
    output                              GT_PCIERATEIDLE,            
    output                              GT_PCIESYNCTXSYNCDONE,                      
    output                              GT_PCIERATEGEN3,    
    output                              GT_PCIEUSERGEN3RDY, 
    output                              GT_PCIEUSERRATESTART,  
                                                          
    //--------------------------------------------------------------------------
    //  TX Sync (Phase/Delay) Alignment Ports
    //--------------------------------------------------------------------------                                                      
    input                               GT_TXSYNCALLIN,
    input                               GT_TXSYNCIN,                                        
                
    output                              GT_TXPHALIGNDONE,            
    output                              GT_TXSYNCOUT,
   
    //--------------------------------------------------------------------------
    //  2527 GT DRP interface
    //--------------------------------------------------------------------------     
    input                               GT_DRPCLK,
    input      [ 8:0]                   GT_DRPADDR,
    input                               GT_DRPEN,
    input                               GT_DRPWE,
    input      [15:0]                   GT_DRPDI,
                                            
    output                              GT_DRPRDY,
    output     [15:0]                   GT_DRPDO,
    //--------------------------------------------------------------------------
    //  Loopback & PRBS Ports
    //--------------------------------------------------------------------------     
    input                               GT_TXINHIBIT,
    input       [ 2:0]                  GT_LOOPBACK,                                              
    input       [ 3:0]                  GT_PRBSSEL,
    input                               GT_TXPRBSFORCEERR, 
    input                               GT_RXPRBSCNTRESET,                                                                                                      

    output                              GT_RXPRBSERR,                                              
    output                              GT_RXPRBSLOCKED,  
      
    output                              GT_RXPHALIGNDONE,  
    output                              GT_RXDLYSRESETDONE,     
    output                              GT_TXDLYSRESETDONE,     
    output                              GT_RXSYNCDONE, 
    output                              GT_EYESCANDATAERROR,
    input                               GT_DMONFIFORESET,
    input                               GT_DMONITORCLK,
    output      [16:0]                  GT_DMONITOROUT,
    output      [ 2:0]                  GT_RXBUFSTATUS,
    //--------------------------------------------------------------------------
    //  GT Status Ports
    //--------------------------------------------------------------------------   
    input                               GT_MASTER_CPLLLOCK,
                                                                                                                      
    output                              GT_CPLLLOCK,
    output                              GT_RXCDRLOCK                                                                 
);

//-------------------------------------------------------------------------------------------------
//  Internal Signals
//-------------------------------------------------------------------------------------------------- 
    wire        [127:0]                 txdata;
    wire        [ 15:0]                 txctrl0;
    wire        [ 15:0]                 txctrl1;
    wire        [  7:0]                 txctrl2;
    
    wire        [127:0]                 rxdata;
    wire        [ 15:0]                 rxctrl0;
    
    wire                                pcierategen3;
    wire        [ 11:0]                 pcsrsvdout;
 
 
 
    //----------------------------------------------------------------------------------------------
    //  Single vs. Mulit-lane Selection
    //----------------------------------------------------------------------------------------------
    localparam [ 0:0] MULTI_LANE     = (PHY_LANE    == 1) ? 1'b0 : 1'b1;
    localparam [ 0:0] MASTER_LANE    = (GT_LANE_NUM == 0) ? 1'b1 : 1'b0;
  //localparam [ 0:0] LOCAL_MASTER   = (GT_LANE_NUM == 4) ? 1'b1 : 1'b0;                            // Default
    localparam [ 0:0] LOCAL_MASTER   = 1'b1;                                                        // 
    localparam [ 2:0] CPLLREFCLKSEL  = 3'd1;                                                        // Default       
  //localparam [ 2:0] CPLLREFCLKSEL  = (GT_LANE_NUM < 4) ? 3'd1 : (PHY_SIM_EN : 3'd1 : 3'd5);       // *** GTH 1.0 ***                                          



    //----------------------------------------------------------------------------------------------
    //  CPLL_FBDIV - CPLL Feedback (N1) Divider
    //----------------------------------------------------------------------------------------------
    localparam CPLL_FBDIV_45 = (PHY_MAX_SPEED < 3) ? 5 : 4;
    
    
    
    //----------------------------------------------------------------------------------------------
    //  CPLL_FBDIV - CPLL Feedback (N2) Divider
    //----------------------------------------------------------------------------------------------
    localparam CPLL_FBDIV = (PHY_REFCLK_FREQ == 2) ?  2 : 
                            (PHY_REFCLK_FREQ == 1) ?  4 : 5;
    
    
    
    //----------------------------------------------------------------------------------------------
    // [TX/RX]OUT_DIV - Output Clock Divider for Gen1
    //----------------------------------------------------------------------------------------------
    localparam OUT_DIV = (PHY_MAX_SPEED < 3) ? 2 : 4;  
    
    
    
    //----------------------------------------------------------------------------------------------
    //  [TX/RX]_CLK25_DIV - Clock Divider for 25 MHz
    //----------------------------------------------------------------------------------------------
    localparam CLK25_DIV = (PHY_REFCLK_FREQ == 2) ? 10 : 
                           (PHY_REFCLK_FREQ == 1) ?  5 : 4;
                   
                   
                       
    //----------------------------------------------------------------------------------------------
    //  [TX/RX]_PROGDIV_CFG - Programmable Divider Configuration
    //----------------------------------------------------------------------------------------------
    localparam PROGDIV_CFG = (PHY_MAX_SPEED < 3) ? 10.0 : (PHY_CORECLK_FREQ == 1) ? 8.0 : 4.0;
    
                       
    
    //----------------------------------------------------------------------------------------------
    //  [TX/RX]PLLCLKSEL - PLL Clock Select   
    //                                                    
    //    2'b00 = CPLL                                                                          
    //    2'b01 = Reserved                                                                          
    //    2'b11 = QPLL0                                                                         
    //    2'b10 = QPLL1                                                                           
    //----------------------------------------------------------------------------------------------
    localparam [ 1:0] PLLCLKSEL = (PHY_MAX_SPEED < 3) ? 2'b00 : 2'b10;                             
              
                                           
    //----------------------------------------------------------------------------------------------
    //  [TX/RX]SYSCLKSEL - System Clock Select   
    //                                                    
    //    2'b00 = CPLL                                                                          
    //    2'b01 = Reserved                                                                          
    //    2'b10 = QPLL0                                                                         
    //    2'b11 = QPLL1                                                                           
    //----------------------------------------------------------------------------------------------                 
    localparam [ 1:0] SYSCLKSEL = (PHY_MAX_SPEED < 3) ? 2'b00 : 2'b11;                     
                                           
                                                                                                    
    //----------------------------------------------------------------------------------------------
    //  PLL_SEL_MODE_GEN[12/3] - PLL Select Mode for Gen1/Gen2
    //
    //    [0] : 1'b0 = QPLL0 : 1'b1 = QPLL1 (bit [0] is don't care when bit [1] = 1'b0)
    //    [1] : 1'b0 = CPLL  : 1'b1 = QPLL0 or QPLL1 
    //----------------------------------------------------------------------------------------------
    localparam [ 1:0] PLL_SEL_MODE_GEN12 = (PHY_MAX_SPEED < 3) ? 2'b00 : 2'b11;                  
    localparam [ 1:0] PLL_SEL_MODE_GEN3  = 2'b11;   
    
    
                           
    //----------------------------------------------------------------------------------------------
    //  PCIE_[TX/RX]PMA_CFG - PCIe PMA Configuration    
    //                                         
    //    [   15] : Reserved                                                        
    //    [14:13] : [TX/RX]_INT_DATAWIDTH_G4                                                                    
    //    [12: 9] : [TX/RX]_DATA_WIDTH_G4                                                     
    //    [ 8: 6] : [TX/RX]OUTCLK_DIV_G2                                                        
    //    [ 5: 3] : [TX/RX]OUTCLK_DIV_G3                                                        
    //    [ 2: 0] : [TX/RX]OUTCLK_DIV_G4                                                          
    //----------------------------------------------------------------------------------------------                                                      
    localparam [ 1:0] INT_DATAWIDTH_G4 = 2'd0;
    localparam [ 3:0] DATA_WIDTH_G4    = 4'd0;
    localparam [ 2:0] OUT_DIV_G2       = (PHY_MAX_SPEED < 3) ? 3'd0 : 3'd1;                                                                                                                                                     
    localparam [ 2:0] OUT_DIV_G3       = 3'd0;                                                                                                                                                                    
    localparam [ 2:0] OUT_DIV_G4       = 3'd0;                                                              

    localparam [15:0] PCIE_PMA_CFG = {1'd0,      
                                     INT_DATAWIDTH_G4,                                    
                                     DATA_WIDTH_G4,                                                             
                                     OUT_DIV_G2,                                                 
                                     OUT_DIV_G3,                                                                                              
                                     OUT_DIV_G4};         
    
    
    
    //----------------------------------------------------------------------------------------------
    //  PCIE_BUFG_DIV_CTRL - PCIe BUFG_GT Divider Control
    //
    //    [   15] : BUFG_GT_FSM_CLK
    //    [14:12] : PCLK_DIV_G1
    //    [11:10] : PCLK_DIV_G2  
    //    [ 9: 8] : PCLK_DIV_G3 
    //    [ 7: 6] : PCLK_DIV_G4
    //    [ 5: 3] : USERCLK_DIV
    //    [ 2: 0] : CORECLK_DIV
    //----------------------------------------------------------------------------------------------  
    localparam [ 0:0] BUFG_GT_FSM_CLK = 1'd0;                                                       // 1'b0 = REFCLK : 1'b1 = PROGDIVCLK

    localparam [ 2:0] PCLK_DIV_G1 = (PHY_MAX_SPEED < 3) ? 3'd1 : 3'd3;                              // 125 MHz
    localparam [ 1:0] PCLK_DIV_G2 = (PHY_MAX_SPEED < 3) ? 2'd0 : 2'd1;                              // 250 MHz
    localparam [ 1:0] PCLK_DIV_G3 = (PHY_MAX_SPEED < 3) ? 2'd0 : 2'd1;                              // 250 MHz                             
    localparam [ 1:0] PCLK_DIV_G4 = 2'd0;                                                           // 500 MHz
  
    localparam [ 2:0] USERCLK_DIV_G12 = (PHY_USERCLK_FREQ == 3) ? 3'd0 :                            // 250.0 MHz
                                        (PHY_USERCLK_FREQ == 2) ? 3'd1 :                            // 125.0 MHz
                                        (PHY_USERCLK_FREQ == 1) ? 3'd3 : 3'd0;                      //  62.5 MHz
  
    localparam [ 2:0] USERCLK_DIV_G3 = (PHY_USERCLK_FREQ == 4) ? 3'd0 :                             // 500.0 MHz
                                       (PHY_USERCLK_FREQ == 3) ? 3'd1 :                             // 250.0 MHz
                                       (PHY_USERCLK_FREQ == 2) ? 3'd3 :                             // 125.0 MHz
                                       (PHY_USERCLK_FREQ == 1) ? 3'd7 : 3'd0;                       //  62.5 MHz

    localparam [ 2:0] USERCLK_DIV = (PHY_MAX_SPEED < 3) ? USERCLK_DIV_G12 : USERCLK_DIV_G3;
    
    localparam [ 2:0] CORECLK_DIV_G12 = 3'd0;                                                       // 250.0 MHz
 
    localparam [ 2:0] CORECLK_DIV_G3 = (PHY_CORECLK_FREQ == 2) ? 3'd0 :                             // 500.0 MHz
                                       (PHY_CORECLK_FREQ == 1) ? 3'd1 : 3'd0;                       // 250.0 MHz
                                       
    localparam [ 2:0] CORECLK_DIV = (PHY_MAX_SPEED < 3) ? CORECLK_DIV_G12 : CORECLK_DIV_G3;
            
    localparam [15:0] PCIE_BUFG_DIV_CTRL = {BUFG_GT_FSM_CLK,                    
                                            PCLK_DIV_G1, 
                                            PCLK_DIV_G2,  
                                            PCLK_DIV_G3,                                                            
                                            PCLK_DIV_G4,
                                            USERCLK_DIV,
                                            CORECLK_DIV};
                                     
     
                    
    //----------------------------------------------------------------------------------------------
    //  PCIE_TXPCS_CFG_GEN3 - PCIe TX PCS Configuration
    //                                             
    //    [15:14] : Reserved                                                        
    //    [13:12] : TX_DRIVE_MODE_G3                                                                    
    //    [   11] : ASYNC_EN   
    //    [   10] : TX_XCLK_SEL_G3                                                   
    //    [    9] : TXBUF_EN_G3                                                          
    //    [ 8: 7] : TX_INT_DATAWIDTH_G3
    //    [ 6: 3] : TX_DATA_WIDTH_G3
    //    [    2] : TX_SYNC_MODE
    //    [    1] : DRP_EXT_CTRL                                                         
    //    [    0] : Reserved                                                         
    //----------------------------------------------------------------------------------------------                                                      
    localparam [ 1:0] TX_DRIVE_MODE_G3    = 2'd2;                                      // "PIPEGEN3"
    localparam [ 0:0] ASYNC_EN            = (PHY_ASYNC_EN == "TRUE") ? 1'd1 : 1'd0;    // 1'b0 = Async : 1'b1 = Sync
    localparam [ 0:0] TX_XCLK_SEL_G3      = 1'd1;                                      // "TXUSER"                                                                                                                                                     
    localparam [ 0:0] TXBUF_EN_G3         = 1'd0;                                      // "FALSE"                                                                                                                                        
    localparam [ 1:0] TX_INT_DATAWIDTH_G3 = 2'd1;                                      // 4 byte
    localparam [ 3:0] TX_DATA_WIDTH_G3    = 4'd4;                                      // 32-bit 
    localparam [ 0:0] TX_SYNC_MODE        = 1'd1;                                      // Auto 
    localparam [ 0:0] DRP_EXT_CTRL        = 1'd0;                                      // Disable 
    
    localparam [15:0] PCIE_TXPCS_CFG_GEN3 = {2'd0,
                                             TX_DRIVE_MODE_G3,
                                             ASYNC_EN,
                                             TX_XCLK_SEL_G3,
                                             TXBUF_EN_G3,
                                             TX_INT_DATAWIDTH_G3,
                                             TX_DATA_WIDTH_G3,
                                             TX_SYNC_MODE,
                                             DRP_EXT_CTRL,
                                             1'd0};
    
    
    
    //----------------------------------------------------------------------------------------------
    //  PCIE_RXPCS_CFG_GEN3 - PCIe RX PCS Configuration  
    //                                                                                                  
    //    [   15] : RX_DFE_LPM_HOLD_DURING_EIDLE_G3 for Gen3                                                                     
    //    [   14] : RXCDR_PH_RESET_ON_EIDLE_G3  
    //    [   13] : RXCDR_FR_RESET_ON_EIDLE_G3                                             
    //    [   12] : RXCDR_HOLD_DURING_EIDLE_G3                                                      
    //    [   11] : CLK_CORRECT_USE_G3
    //    [   10] : RX_XCLK_SEL_G3
    //    [    9] : RXBUF_EN_G3
    //    [ 8: 7] : RX_INT_DATA_WIDTH_G3
    //    [ 6: 3] : RX_DATA_WIDTH_G3
    //    [    2] : RX_SYNC_MODE                                                        
    //    [    1] : RATE_FSM_CLK  
    //    [    0] : Reserved                                                  
    //----------------------------------------------------------------------------------------------                                                      
    localparam [ 0:0] RX_DFE_LPM_HOLD_DURING_EIDLE_G3 = 1'd0;                          // 
    localparam [ 0:0] RXCDR_PH_RESET_ON_EIDLE_G3      = 1'd0;                          // 
    localparam [ 0:0] RXCDR_FR_RESET_ON_EIDLE_G3      = 1'd0;                          //                                                                                                                                             
    localparam [ 0:0] RXCDR_HOLD_DURING_EIDLE_G3      = 1'd0;                          //      
    localparam [ 0:0] CLK_CORRECT_USE_G3              = 1'd0;                          // "FALSE"          
    localparam [ 0:0] RX_XCLK_SEL_G3                  = 1'd0;                          // RXDES                                                                                 
    localparam [ 0:0] RXBUF_EN_G3                     = 1'd1;                          // "TRUE"
    localparam [ 1:0] RX_INT_DATA_WIDTH_G3            = 2'd1;                          // 4 byte  
    localparam [ 3:0] RX_DATA_WIDTH_G3                = 4'd4;                          // 32-bit  
    localparam [ 0:0] RX_SYNC_MODE                    = 1'd1;                          // Auto
    localparam [ 0:0] RATE_FSM_CLK                    = 1'd0;                          // 1'b0 = REFCLK : 1'b1 = PCLK
    
    localparam [15:0] PCIE_RXPCS_CFG_GEN3 = {RX_DFE_LPM_HOLD_DURING_EIDLE_G3,
                                             RXCDR_PH_RESET_ON_EIDLE_G3,
                                             RXCDR_FR_RESET_ON_EIDLE_G3,
                                             RXCDR_HOLD_DURING_EIDLE_G3,
                                             CLK_CORRECT_USE_G3,
                                             RX_XCLK_SEL_G3,
                                             RXBUF_EN_G3,
                                             RX_INT_DATA_WIDTH_G3,
                                             RX_DATA_WIDTH_G3,
                                             RX_SYNC_MODE,
                                             RATE_FSM_CLK,
                                             1'd0};



//--------------------------------------------------------------------------------------------------
//  GTH Channel
//--------------------------------------------------------------------------------------------------
GTHE3_CHANNEL #
(  
    //----------------------------------------------------------------------------------------------
    //  Simulation Attributes
    //----------------------------------------------------------------------------------------------
    .SIM_RECEIVER_DETECT_PASS           ("TRUE"),
    .SIM_RESET_SPEEDUP                  ("TRUE"),
    .SIM_TX_EIDLE_DRIVE_LEVEL           ( 1'b0),
    .SIM_VERSION                        ("Ver_1"),                                                                          
   
    //----------------------------------------------------------------------------------------------     
    //  Clock Attributes
    //----------------------------------------------------------------------------------------------                                                                                                                       
    .TX_PROGCLK_SEL                     ("CPLL"),                               // PCIe
    .TX_PROGDIV_CFG                     (PROGDIV_CFG),                      
    .RX_PROGDIV_CFG                     (PROGDIV_CFG),                         
    .TX_CLK25_DIV                       (CLK25_DIV),                                                    
    .RX_CLK25_DIV                       (CLK25_DIV),                                                    
    .TX_CLKMUX_EN                       ( 1'b1),                                                
    .RX_CLKMUX_EN                       ( 1'b1),                                                
    .TX_XCLK_SEL                        ("TXUSR"),                                              
    .RX_XCLK_SEL                        ("RXDES"),   
    .TXOUT_DIV                          (OUT_DIV), 
    .RXOUT_DIV                          (OUT_DIV), 
    .LOCAL_MASTER                       (LOCAL_MASTER),   
    .RX_CLK_SLIP_OVRD                   ( 5'b00000),  
    .RXPMACLK_SEL                       ("DATA"),                                                                                                                            
    .USE_PCS_CLK_PHASE_SEL              ( 1'b0),                                                 
               
    //----------------------------------------------------------------------------------------------
    //  CPLL Attributes
    //---------------------------------------------------------------------------------------------- 
    .CPLL_FBDIV                         (CPLL_FBDIV),  
    .CPLL_FBDIV_45                      (CPLL_FBDIV_45),         
    .CPLL_REFCLK_DIV                    (1),                
    .CPLL_CFG0                          (16'b0110001111111000),                            
    .CPLL_CFG1                          (16'b1010010010101100),                                   
    .CPLL_CFG2                          (16'b1111000000000100),      
    .CPLL_CFG3                          ( 6'b000000),  
    .CPLL_INIT_CFG0                     (16'b0000000000011110),       
    .CPLL_INIT_CFG1                     ( 8'b00000000),            
    .CPLL_LOCK_CFG                      (16'b0000000111101000),                 // [0] : 1'b0   
                                                                              
    //----------------------------------------------------------------------------------------------
    //  Reset Attributes
    //----------------------------------------------------------------------------------------------    
  //.A_TXPROGDIVRESET                   ( 1'b0), 
  //.A_RXPROGDIVRESET                   ( 1'b0),
    .TX_DIVRESET_TIME                   ( 5'b00001),                              
    .RX_DIVRESET_TIME                   ( 5'b00001),  
  //.RXBUFRESET_TIME                    ( 5'b00001), 
    .RXCDRFREQRESET_TIME                ( 5'b00001),  
    .RXCDRPHRESET_TIME                  ( 5'b00001),    
    .RXDFELPMRESET_TIME                 ( 7'b0001111), 
  //.RXISCANRESET_TIME                  ( 5'b00001),
  //.RXOSCALRESET_TIME                  ( 5'b00011),         
  //.TXPCSRESET_TIME                    ( 5'b00001),                
  //.RXPCSRESET_TIME                    ( 5'b00001),                                                   
  //.TXPMARESET_TIME                    ( 5'b00001),                                                   
  //.RXPMARESET_TIME                    ( 5'b00001),                                                
  //.RESET_POWERSAVE_DISABLE            ( 1'b0),                                                      
               
    //----------------------------------------------------------------------------------------------
    //  PCIe Attributes
    //----------------------------------------------------------------------------------------------
    .PCIE_BUFG_DIV_CTRL                 (PCIE_BUFG_DIV_CTRL),                   // 16'b0011010100000000  
    .PCIE_RXPCS_CFG_GEN3                (PCIE_RXPCS_CFG_GEN3),                  // 16'b0000001010100100
    .PCIE_RXPMA_CFG                     (PCIE_PMA_CFG),                         // 16'b0000000001000000
    .PCIE_TXPCS_CFG_GEN3                (PCIE_TXPCS_CFG_GEN3),                  // 16'b0010010010100000        
    .PCIE_TXPMA_CFG                     (PCIE_PMA_CFG),                         // 16'b0000000001000000
    .PCS_PCIE_EN                        ("TRUE"),  
    .PLL_SEL_MODE_GEN12                 (PLL_SEL_MODE_GEN12),                   // 2'b10        
    .PLL_SEL_MODE_GEN3                  (PLL_SEL_MODE_GEN3),                    // 2'b10

    //---------------------------------------------------------------------------------------------- 
    //  Data Width Attributes
    //----------------------------------------------------------------------------------------------                          
    .TX_DATA_WIDTH                      (20),                                                                                                                                         
    .RX_DATA_WIDTH                      (20),  
    .TX_INT_DATAWIDTH                   ( 0),                                                                
    .RX_INT_DATAWIDTH                   ( 0),   
    .TX_FABINT_USRCLK_FLOP              ( 1'b0), 
    .RX_FABINT_USRCLK_FLOP              ( 1'b0),                                                    
              
    //----------------------------------------------------------------------------------------------
    //  Analog Front End Attributes
    //----------------------------------------------------------------------------------------------
    .RX_AFE_CM_EN                       ( 1'b0),
    .RX_BIAS_CFG0                       (16'b0000101010110100),
    .RX_CM_BUF_CFG                      ( 4'b1010),
    .RX_CM_BUF_PD                       ( 1'b0),                                           
    .RX_CM_SEL                          ( 2'b11),                                                        
    .RX_CM_TRIM                         ( 4'b1010),    
    .RX_TUNE_AFE_OS                     ( 2'b10),
    .TERM_RCAL_CFG                      (15'b100001000010000),                                     
    .TERM_RCAL_OVRD                     ( 3'b000),         
    .TX_QPI_STATUS_EN                   ( 1'b0),           
                                                                                                    
    //----------------------------------------------------------------------------------------------  
    //  Receiver Detection Attributes
    //----------------------------------------------------------------------------------------------                                      
    .TX_RXDETECT_CFG                    (14'h0032),                             // ***                            
    .TX_RXDETECT_REF                    ( 3'b100),                                  
    
    //----------------------------------------------------------------------------------------------  
    //  TX Electrical Idle Attributes
    //----------------------------------------------------------------------------------------------   
    .TX_EIDLE_ASSERT_DELAY              ( 3'b100),                              // PCIe option              
    .TX_EIDLE_DEASSERT_DELAY            ( 3'b011),                              // PCIe option
    .TX_IDLE_DATA_ZERO                  ( 1'b0),                                // PCIe option             
 
    //----------------------------------------------------------------------------------------------  
    //  RX OOB Attributes
    //----------------------------------------------------------------------------------------------   
    .OOB_PWRUP                          ( 1'b1),                                // PCIe option
    .OOBDIVCTL                          ( 2'b10),                               // PCIe option (div 4)                  
    .RX_SIG_VALID_DLY                   ( 4),                                   // PCIe optimized
    .RXOOB_CFG                          ( 9'b000000110),                          
    .RXOOB_CLK_CFG                      ("PMA"),      
    
    //----------------------------------------------------------------------------------------------  
    //  RX Electrical Idle Attributes
    //----------------------------------------------------------------------------------------------                                                   
    .RX_DFE_LPM_HOLD_DURING_EIDLE       ( 1'b0),                                
    .RXBUF_EIDLE_HI_CNT                 ( 4'b0100),                             // PCIe optimized
    .RXBUF_EIDLE_LO_CNT                 ( 4'b0000),
    .RXBUF_RESET_ON_EIDLE               ("TRUE"),
    .RXCDR_FR_RESET_ON_EIDLE            ( 1'b0),
    .RXCDR_PH_RESET_ON_EIDLE            ( 1'b0),
    .RXCDR_HOLD_DURING_EIDLE            ( 1'b1),                                // PCIe option
    .RXELECIDLE_CFG                     ("Sigcfg_1"),                           // PCIe option 
 
    //----------------------------------------------------------------------------------------------  
    //  Power Down Attributes
    //----------------------------------------------------------------------------------------------   
    .PD_TRANS_TIME_FROM_P2              (12'b000000111100),                                                     
    .PD_TRANS_TIME_NONE_P2              ( 8'b00011001),                                                      
    .PD_TRANS_TIME_TO_P2                ( 8'b01100100),   
    .TX_PMA_POWER_SAVE                  ( 1'b0),   
    .RX_PMA_POWER_SAVE                  ( 1'b0),                               
  
    //----------------------------------------------------------------------------------------------  
    //  Rate Change Attributes
    //---------------------------------------------------------------------------------------------- 
    .RATE_SW_USE_DRP                    ( 1'b0),                                // PCIe 
    .TRANS_TIME_RATE                    ( 8'b00001110),             
    .TXBUF_RESET_ON_RATE_CHANGE         ("TRUE"),                               // PCIe 
    .RXBUF_RESET_ON_RATE_CHANGE         ("TRUE"),                               // PCIe

    //----------------------------------------------------------------------------------------------
    //  TX Driver Attributes
    //----------------------------------------------------------------------------------------------                                   
    .TX_DEEMPH0                         ( 6'b010100),                           // -6.0 dB                           
    .TX_DEEMPH1                         ( 6'b001101),                           // -3.5 dB 
    .TX_DRIVE_MODE                      ("PIPE"),                               // PCIe Gen1/Gen2 
    .TX_LOOPBACK_DRIVE_HIZ              ("FALSE"),                   
    .TX_MARGIN_FULL_0                   ( 7'b1001111),                          // ~1200 mV
    .TX_MARGIN_FULL_1                   ( 7'b1001110),                          // ~1100 mV
    .TX_MARGIN_FULL_2                   ( 7'b1001100),                          // ~1000 mV
    .TX_MARGIN_FULL_3                   ( 7'b1001010),                          // ~ 900 mV
    .TX_MARGIN_FULL_4                   ( 7'b1001000),                          // ~ 800 mV
    .TX_MARGIN_LOW_0                    ( 7'b1000110),                          // ~ 700 mV            
    .TX_MARGIN_LOW_1                    ( 7'b1000101),                          // ~ 600 mV           
    .TX_MARGIN_LOW_2                    ( 7'b1000011),                          // ~ 500 mV          
    .TX_MARGIN_LOW_3                    ( 7'b1000010),                          // ~ 400 mV           
    .TX_MARGIN_LOW_4                    ( 7'b1000000),                          // ~ 300 mV
    .TX_MAINCURSOR_SEL                  ( 1'b0),   
    .TXDRVBIAS_N                        ( 4'b1010),                                                                         
    .TXDRVBIAS_P                        ( 4'b1111),                             // GTH 1.0       
   
    //----------------------------------------------------------------------------------------------    
    //  Comma Align & Detect Attributes
    //----------------------------------------------------------------------------------------------       
    .ALIGN_COMMA_DOUBLE                 ("FALSE"),                                                  
    .ALIGN_COMMA_ENABLE                 (10'b1111111111),                                           
    .ALIGN_COMMA_WORD                   ( 1),                                                       
    .ALIGN_MCOMMA_DET                   ("TRUE"),                                                   
    .ALIGN_MCOMMA_VALUE                 (10'b1010000011),                                           
    .ALIGN_PCOMMA_DET                   ("TRUE"),                                                   
    .ALIGN_PCOMMA_VALUE                 (10'b0101111100),                                           
    .DEC_MCOMMA_DETECT                  ("TRUE"),                                                      
    .DEC_PCOMMA_DETECT                  ("TRUE"),                                                      
    .DEC_VALID_COMMA_ONLY               ("FALSE"),                                                     
    .SHOW_REALIGN_COMMA                 ("FALSE"),       
   
    //----------------------------------------------------------------------------------------------   
    //  8B/10B Attributes                                                                             
    //----------------------------------------------------------------------------------------------                   
    .RX_DISPERR_SEQ_MATCH               ("TRUE"),        
   
    //----------------------------------------------------------------------------------------------  
    //  TX Buffer Attributes
    //----------------------------------------------------------------------------------------------                      
    .TXBUF_EN                           ("FALSE"),        
    .TXFIFO_ADDR_CFG                    ("LOW"),                                                                                      
 
    //----------------------------------------------------------------------------------------------
    //  RX Buffer Attributes                                                                        
    //----------------------------------------------------------------------------------------------     
    .RXBUF_ADDR_MODE                    ("FULL"),                               //
    .RXBUF_EN                           ("TRUE"),
    .RXBUF_RESET_ON_CB_CHANGE           ("TRUE"),
    .RXBUF_RESET_ON_COMMAALIGN          ("FALSE"),
    .RXBUF_THRESH_OVFLW                 (0),                                    // not used when RXBUF_THRESH_OVRD = "FALSE"
    .RXBUF_THRESH_OVRD                  ("FALSE"),                              //
    .RXBUF_THRESH_UNDFLW                (0),   
    .RX_BUFFER_CFG                      (6'b000000),
    .RX_DEFER_RESET_BUF_EN              ("TRUE"), 
   
    //----------------------------------------------------------------------------------------------   
    //  RX Buffer Attributes (Gen3)                                                                                       
    //----------------------------------------------------------------------------------------------   
    .PCI3_AUTO_REALIGN                  ("OVR_1K_BLK"),                         //  
    .PCI3_PIPE_RX_ELECIDLE              ( 1'b0),                                
    .PCI3_RX_ASYNC_EBUF_BYPASS          ( 2'b00),                               
    .PCI3_RX_ELECIDLE_EI2_ENABLE        ( 1'b0),                                
    .PCI3_RX_ELECIDLE_H2L_COUNT         ( 6'b000000),                           
    .PCI3_RX_ELECIDLE_H2L_DISABLE       ( 3'b000),                              
    .PCI3_RX_ELECIDLE_HI_COUNT          ( 6'b000000),                           
    .PCI3_RX_ELECIDLE_LP4_DISABLE       ( 1'b0),                                
    .PCI3_RX_FIFO_DISABLE               ( 1'b0),                                
       
    //---------------------------------------------------------------------------------------------- 
    //  Clock Correction Attributes
    //----------------------------------------------------------------------------------------------             
    .CLK_COR_KEEP_IDLE                  ("TRUE"),
    .CLK_COR_MAX_LAT                    (13),                                   // optimized for no channel bonding with clock correction
    .CLK_COR_MIN_LAT                    (11),                                   // optimized for no channel bonding with clock correction
    .CLK_COR_PRECEDENCE                 ("TRUE"),
    .CLK_COR_REPEAT_WAIT                (0),
    .CLK_COR_SEQ_LEN                    (1),
    .CLK_COR_SEQ_1_ENABLE               (4'b1111),
    .CLK_COR_SEQ_1_1                    (10'b0100011100),
    .CLK_COR_SEQ_1_2                    (10'b0000000000),
    .CLK_COR_SEQ_1_3                    (10'b0000000000),
    .CLK_COR_SEQ_1_4                    (10'b0000000000),
    .CLK_COR_SEQ_2_ENABLE               (4'b1111),
    .CLK_COR_SEQ_2_USE                  ("FALSE"),
    .CLK_COR_SEQ_2_1                    (10'b0000000000),
    .CLK_COR_SEQ_2_2                    (10'b0000000000),
    .CLK_COR_SEQ_2_3                    (10'b0000000000),
    .CLK_COR_SEQ_2_4                    (10'b0000000000),
    .CLK_CORRECT_USE                    ("TRUE"),                
       
    //---------------------------------------------------------------------------------------------- 
    //  FTS Deskew Attributes                                                                            
    //----------------------------------------------------------------------------------------------                                         
    .FTS_DESKEW_SEQ_ENABLE              ( 4'b1111),                                        
    .FTS_LANE_DESKEW_CFG                ( 4'b1111),                                          
    .FTS_LANE_DESKEW_EN                 ("TRUE"),           
       
    //---------------------------------------------------------------------------------------------- 
    //  Channel Bonding Attributes (Disabled)
    //----------------------------------------------------------------------------------------------          
    .CBCC_DATA_SOURCE_SEL               ("DECODED"),  
    .CHAN_BOND_KEEP_ALIGN               ("FALSE"),
    .CHAN_BOND_MAX_SKEW                 (1),
    .CHAN_BOND_SEQ_LEN                  (1),
    .CHAN_BOND_SEQ_1_ENABLE             (4'b1111),
    .CHAN_BOND_SEQ_1_1                  (10'b0000000000),
    .CHAN_BOND_SEQ_1_2                  (10'b0000000000),
    .CHAN_BOND_SEQ_1_3                  (10'b0000000000),
    .CHAN_BOND_SEQ_1_4                  (10'b0000000000),
    .CHAN_BOND_SEQ_2_ENABLE             (4'b1111),
    .CHAN_BOND_SEQ_2_USE                ("FALSE"),
    .CHAN_BOND_SEQ_2_1                  (10'b0000000000),
    .CHAN_BOND_SEQ_2_2                  (10'b0000000000),
    .CHAN_BOND_SEQ_2_3                  (10'b0000000000),
    .CHAN_BOND_SEQ_2_4                  (10'b0000000000),                                                                                
  
    //----------------------------------------------------------------------------------------------            
    //  TX Sync (Phase & Delay) Alignment Attributes                                                                              
    //----------------------------------------------------------------------------------------------     
    .TXDLY_CFG                          (16'b0000000000011111),    
    .TXDLY_LCFG                         (16'b0000000000110000),    
    .TXPHDLY_CFG0                       (16'b0010000000100000),
    .TXPHDLY_CFG1                       (16'b0000000000000001),
    .TXPH_CFG                           (16'b0000100110000000),  
    .TXPH_MONITOR_SEL                   ( 5'b00000),
                                                                                         
    //----------------------------------------------------------------------------------------------            
    //  TX Auto Sync (Phase & Delay) Alignment Attributes                                                                               
    //----------------------------------------------------------------------------------------------                
    .TXSYNC_MULTILANE                   (MULTI_LANE),                                                                                                              
    .TXSYNC_OVRD                        (1'b0),                                 // 1'b0 = auto : 1'b1 = manual                                                                
    .TXSYNC_SKIP_DA                     (1'b0),                     
                                                                                                    
    //----------------------------------------------------------------------------------------------            
    //  RX Sync (Phase & Delay) Alignment Attributes                                                                               
    //----------------------------------------------------------------------------------------------    
  //.RXPHBEACON_CFG                     (16'h0000),
  //.RXPHDLY_CFG                        (16'h2020),
  //.RXPHSAMP_CFG                       (16'h2100),
  //.RXPHSLIP_CFG                       (16'h6622),    
  //.RXPH_MONITOR_SEL                   (5'b00000),
  //.RXDLY_CFG                          (16'h001F),
  //.RXDLY_LCFG                         (16'h0030),   
           
    //----------------------------------------------------------------------------------------------            
    //  RX Auto Sync (Phase & Delay) Alignment Attributes                                                                                 
    //----------------------------------------------------------------------------------------------                
  //.RXSYNC_MULTILANE                   (1'b0),                                                                                                              
  //.RXSYNC_OVRD                        (1'b0),                                 // 1'b0 = auto : 1'b1 = manual                                                                
  //.RXSYNC_SKIP_DA                     (1'b0),                   
  
    //----------------------------------------------------------------------------------------------  
    //  Gearbox Attributes                                                                   
    //---------------------------------------------------------------------------------------------- 
  //.GEARBOX_MODE                       ( 5'b00000), 
  //.TX_SAMPLE_PERIOD                   ( 3'b101),
  //.RX_SAMPLE_PERIOD                   ( 3'b101),
  //.TXGEARBOX_EN                       ("FALSE"),
  //.RXGEARBOX_EN                       ("FALSE"),    
  //.TXGBOX_FIFO_INIT_RD_ADDR           ( 4),
  //.RXGBOX_FIFO_INIT_RD_ADDR           ( 4),
  //.RXSLIDE_AUTO_WAIT                  ( 7),                                                         
    .RXSLIDE_MODE                       ("PMA"),                                // required for Gen3         

    //----------------------------------------------------------------------------------------------
    //  PCS Attributes
    //----------------------------------------------------------------------------------------------
    .PCS_RSVD0                          (16'b0000000000000000),
    .PCS_RSVD1                          ( 3'b000),
  
    //----------------------------------------------------------------------------------------------  
    //  PMA Attributes
    //----------------------------------------------------------------------------------------------      
    .PMA_RSV1                           (16'b0001000000000000),                                                        
      
    //----------------------------------------------------------------------------------------------
    //  CFOK Attributes                                                                 
    //----------------------------------------------------------------------------------------------              
    .RXCFOK_CFG0                        (16'b0100000000000000), 
    .RXCFOK_CFG1                        (16'b0000000001100101),                 
    .RXCFOK_CFG2                        (16'b0000000000001110),                 

    //----------------------------------------------------------------------------------------------    
    //  RX LPM Attributes
    //----------------------------------------------------------------------------------------------        
    .RXLPM_CFG                          (16'b0000000000000000),    
    .RXLPM_GC_CFG                       (16'b0000000000000000),
    .RXLPM_KH_CFG0                      (16'b0000000000000000),
    .RXLPM_KH_CFG1                      (16'b0000000000000010),
    .RXLPM_OS_CFG0                      (16'b1000000000000000),
    .RXLPM_OS_CFG1                      (16'b0000000000000010),
 
    //----------------------------------------------------------------------------------------------    
    //  RX DFE Attributes
    //---------------------------------------------------------------------------------------------- 
    .DFE_D_X_REL_POS                    ( 1'b0),   
    .DFE_VCM_COMP_EN                    ( 1'b0),        
    .RXDFELPM_KL_CFG0                   (16'b0000000000000000),                 //    
    .RXDFELPM_KL_CFG1                   ((PHY_MAX_SPEED < 3) ? 16'b0000000000110010 : 16'b0000000000000010),    
    .RXDFELPM_KL_CFG2                   (16'b0000000000000000),                
    .RXDFE_CFG0                         (16'b0000101000000000),
    .RXDFE_CFG1                         (16'b0000000000000000),
    .RXDFE_GC_CFG0                      (16'b0000000000000000),                 // ***
    .RXDFE_GC_CFG1                      ((PHY_MAX_SPEED < 3) ? 16'b0111100001110000 : 16'b0111100001100000),
    .RXDFE_GC_CFG2                      ((PHY_MAX_SPEED < 3) ? 16'b0000000001000000 : 16'b0000000000000000),
    .RXDFE_H2_CFG0                      (16'b0000000000000000),
    .RXDFE_H2_CFG1                      (16'b0000000000000000),
    .RXDFE_H3_CFG0                      (16'b0100000000000000),
    .RXDFE_H3_CFG1                      (16'b0000000000000000),
    .RXDFE_H4_CFG0                      (16'b0010000000000000),
    .RXDFE_H4_CFG1                      (16'b0000000000000011),
    .RXDFE_H5_CFG0                      (16'b0010000000000000),
    .RXDFE_H5_CFG1                      (16'b0000000000000011),
    .RXDFE_H6_CFG0                      (16'b0010000000000000),
    .RXDFE_H6_CFG1                      (16'b0000000000000000),
    .RXDFE_H7_CFG0                      (16'b0010000000000000),
    .RXDFE_H7_CFG1                      (16'b0000000000000000),
    .RXDFE_H8_CFG0                      (16'b0010000000000000),
    .RXDFE_H8_CFG1                      (16'b0000000000000000),
    .RXDFE_H9_CFG0                      (16'b0010000000000000),
    .RXDFE_H9_CFG1                      (16'b0000000000000000),
    .RXDFE_HA_CFG0                      (16'b0010000000000000),
    .RXDFE_HA_CFG1                      (16'b0000000000000000),
    .RXDFE_HB_CFG0                      (16'b0010000000000000),
    .RXDFE_HB_CFG1                      (16'b0000000000000000),
    .RXDFE_HC_CFG0                      (16'b0000000000000000),
    .RXDFE_HC_CFG1                      (16'b0000000000000000),
    .RXDFE_HD_CFG0                      (16'b0000000000000000),
    .RXDFE_HD_CFG1                      (16'b0000000000000000),
    .RXDFE_HE_CFG0                      (16'b0000000000000000),
    .RXDFE_HE_CFG1                      (16'b0000000000000000),
    .RXDFE_HF_CFG0                      (16'b0000000000000000),
    .RXDFE_HF_CFG1                      (16'b0000000000000000),
    .RXDFE_OS_CFG0                      (16'b1000000000000000),
    .RXDFE_OS_CFG1                      (16'b0000000000000000),
    .RXDFE_UT_CFG0                      (16'b1000000000000000),
    .RXDFE_UT_CFG1                      (16'b0000000000000011),
    .RXDFE_VP_CFG0                      (16'b1010101000000000),
    .RXDFE_VP_CFG1                      (16'b0000000000110011),
    .RX_DFELPM_CFG0                     ( 4'b0110),
    .RX_DFELPM_CFG1                     ( 1'b1),                                                               
    .RX_DFELPM_KLKH_AGC_STUP_EN         ( 1'b1), 
    .RX_DFE_AGC_CFG0                    ((PHY_MAX_SPEED < 3) ? 2'b00  : 2'b10 ),                               
    .RX_DFE_AGC_CFG1                    ((PHY_MAX_SPEED < 3) ? 3'b000 : 3'b100),  
    .RX_DFE_KL_LPM_KH_CFG0              ( 2'b01),
    .RX_DFE_KL_LPM_KH_CFG1              ((PHY_MAX_SPEED < 3) ? 3'b000 : 3'b100),
    .RX_DFE_KL_LPM_KL_CFG0              ( 2'b01),
    .RX_DFE_KL_LPM_KL_CFG1              ((PHY_MAX_SPEED < 3) ? 3'b000 : 3'b100),   
    .RX_CTLE3_LPF                       ( 8'b00000001),                                                                       
          
    //----------------------------------------------------------------------------------------------  
    //  TX PI attributes
    //----------------------------------------------------------------------------------------------
    .TXPI_CFG0                          ( 2'b00),
    .TXPI_CFG1                          ( 2'b00),
    .TXPI_CFG2                          ( 2'b00),
    .TXPI_CFG3                          ( 1'b1),
    .TXPI_CFG4                          ((PHY_MAX_SPEED < 3) ? 1'b1   : 1'b0  ),
    .TXPI_CFG5                          ((PHY_MAX_SPEED < 3) ? 3'b011 : 3'b000),
    .TXPI_GRAY_SEL                      ( 1'b0),
    .TXPI_INVSTROBE_SEL                 ( 1'b0),
    .TXPI_LPM                           ( 1'b0),
    .TXPI_PPMCLK_SEL                    ("TXUSRCLK2"),
    .TXPI_PPM_CFG                       ( 8'b00000000),
    .TXPI_SYNFREQ_PPM                   ( 3'b000),
    .TXPI_VREFSEL                       ( 1'b0),    
    
    //----------------------------------------------------------------------------------------------  
    //  RX PI Attributes
    //----------------------------------------------------------------------------------------------    
    .RXPI_CFG0                          ( 2'b00),
    .RXPI_CFG1                          ( 2'b00),
    .RXPI_CFG2                          ( 2'b00),
    .RXPI_CFG3                          ( 2'b00),
    .RXPI_CFG4                          ( 1'b1),
    .RXPI_CFG5                          ((PHY_MAX_SPEED < 3) ? 1'b1   : 1'b0  ),
    .RXPI_CFG6                          ((PHY_MAX_SPEED < 3) ? 3'b011 : 3'b000),
    .RXPI_LPM                           ( 1'b0),
    .RXPI_VREFSEL                       ( 1'b0),              

    //----------------------------------------------------------------------------------------------
    //  RX CDR Attributes
    //----------------------------------------------------------------------------------------------    
    .CDR_SWAP_MODE_EN                   ( 1'b0),                 
    .RXCDR_CFG0                         (16'b0000000000000000),
    .RXCDR_CFG0_GEN3                    (16'b0000000000000000),                 
    .RXCDR_CFG1                         (16'b0000000000000000),                
    .RXCDR_CFG1_GEN3                    (16'b0000000010000000),                
  //.RXCDR_CFG2                         (16'b0000011111010100),                 // PCIe Gen1/Gen2
  //.RXCDR_CFG2                         (16'b0000011111010110),                 // PCIe Gen1/Gen2
    .RXCDR_CFG2                         ((PHY_MAX_SPEED < 3) ? 16'b0000011101100110 : 16'b0000011101010110),                 // PCIe Gen1/Gen2
                 
  //.RXCDR_CFG2_GEN3                    (16'b0000011111100111),                 // 1 - 07E7 - P - Default
  //.RXCDR_CFG2_GEN3                    (16'b0000011111110111),                 // 2 - 07F7 - P - GT Wizard Week 1
  //.RXCDR_CFG2_GEN3                    (16'b0000011111110101),                 // 3 - 07F5 - F - Generic 8G JTOL
  //.RXCDR_CFG2_GEN3                    (16'b0000011111100100),                 // 4 - 07E4 - F - GT Wizard Week 2
    .RXCDR_CFG2_GEN3                    (16'b0000011111100110),                 // 5 - 07E6 - P - GT Wizard Week 2 Modified
  //.RXCDR_CFG2_GEN3                    (16'b0000011111010101),                 // 6 - 07D5 - F - Gen3 JTOL
  //.RXCDR_CFG2_GEN3                    (16'b0000011111010110),                 // 7 - 07D6 - F - Gen3 JTOL Modified
  //.RXCDR_CFG2_GEN3                    (16'b0000011101100110),                 // 8 - 0766 - F - 2014.1 Feb 3
    
    .RXCDR_CFG3                         (16'b0000000000000000),
    .RXCDR_CFG3_GEN3                    (16'b0000000000000000),
    .RXCDR_CFG4                         (16'b0000000000000000),
    .RXCDR_CFG4_GEN3                    (16'b0000000000000000),
    .RXCDR_CFG5                         (16'b0000000000000000),
    .RXCDR_CFG5_GEN3                    (16'b0000000000000000),
    .RXCDR_LOCK_CFG0                    (16'b0100010010000000),
    .RXCDR_LOCK_CFG1                    (16'b0101111111111111),
    .RXCDR_LOCK_CFG2                    (16'b0111011111000011),                 
    .RX_WIDEMODE_CDR                    (1'b0),                              

    //---------------------------------------------------------------------------------------------- 
    //  Eye Scan Attributes
    //----------------------------------------------------------------------------------------------
    .ES_CLK_PHASE_SEL                   (1'b0),                           
    .ES_CONTROL                         (6'b000000),                      
    .ES_ERRDET_EN                       ("FALSE"),                        
    .ES_EYE_SCAN_EN                     ("FALSE"),                        
    .ES_HORZ_OFFSET                     (12'b000000000000),               
    .ES_PMA_CFG                         (10'b0000000000),                 
    .ES_PRESCALE                        (5'b00000),                       
    .ES_QUALIFIER0                      (16'b0000000000000000),           
    .ES_QUALIFIER1                      (16'b0000000000000000),           
    .ES_QUALIFIER2                      (16'b0000000000000000),           
    .ES_QUALIFIER3                      (16'b0000000000000000),           
    .ES_QUALIFIER4                      (16'b0000000000000000),           
    .ES_QUAL_MASK0                      (16'b0000000000000000),           
    .ES_QUAL_MASK1                      (16'b0000000000000000),           
    .ES_QUAL_MASK2                      (16'b0000000000000000),           
    .ES_QUAL_MASK3                      (16'b0000000000000000),           
    .ES_QUAL_MASK4                      (16'b0000000000000000),           
    .ES_SDATA_MASK0                     (16'b0000000000000000),           
    .ES_SDATA_MASK1                     (16'b0000000000000000),           
    .ES_SDATA_MASK2                     (16'b0000000000000000),           
    .ES_SDATA_MASK3                     (16'b0000000000000000),           
    .ES_SDATA_MASK4                     (16'b0000000000000000),           
    .EYE_SCAN_SWAP_EN                   ( 1'b0),
    .RX_EYESCAN_VS_CODE                 ( 7'b0000000),
    .RX_EYESCAN_VS_NEG_DIR              ( 1'b0),
    .RX_EYESCAN_VS_RANGE                ( 2'b00),
    .RX_EYESCAN_VS_UT_SIGN              ( 1'b0),                        
  
    //----------------------------------------------------------------------------------------------
    //  Loopback & PRBS Attributes
    //----------------------------------------------------------------------------------------------
    .RXPRBS_ERR_LOOPBACK                ( 1'b0),     
    .RXPRBS_LINKACQ_CNT                 (15),                                                   
                                                                                                    
    //----------------------------------------------------------------------------------------------   
    //  Digital Monitor Attribute
    //----------------------------------------------------------------------------------------------                     
    .DMONITOR_CFG0                      (10'b0000000000),                                                  
    .DMONITOR_CFG1                      ( 8'b00000000),                                                   
                                                      
    //----------------------------------------------------------------------------------------------   
    //  AC JTAG Attributes
    //----------------------------------------------------------------------------------------------                     
    .ACJTAG_DEBUG_MODE                  ( 1'b0),                                                        
    .ACJTAG_MODE                        ( 1'b0),                                                        
    .ACJTAG_RESET                       ( 1'b0),      
    
    //---------------------------------------------------------------------------------------------- 
    //  SATA Attributes
    //---------------------------------------------------------------------------------------------- 
    .SAS_MAX_COM                        (64),
    .SAS_MIN_COM                        (36),
    .SATA_BURST_SEQ_LEN                 (4'b1111),
    .SATA_BURST_VAL                     (3'b100),
    .SATA_CPLL_CFG                      ("VCO_3000MHZ"),
    .SATA_EIDLE_VAL                     (3'b100),
    .SATA_MAX_BURST                     ( 8),
    .SATA_MAX_INIT                      (21),
    .SATA_MAX_WAKE                      ( 7),
    .SATA_MIN_BURST                     ( 4),
    .SATA_MIN_INIT                      (12),
    .SATA_MIN_WAKE                      ( 4),  
  
    //----------------------------------------------------------------------------------------------
    //  Summer Attributes
    //----------------------------------------------------------------------------------------------
    .RX_SUM_DFETAPREP_EN                ( 1'b0),
    .RX_SUM_IREF_TUNE                   ((PHY_MAX_SPEED < 3) ? 4'b1100 : 4'b0000),
    .RX_SUM_RES_CTRL                    ((PHY_MAX_SPEED < 3) ? 2'b11   : 2'b00  ),
    .RX_SUM_VCMTUNE                     ( 4'b0000),
    .RX_SUM_VCM_OVWR                    ( 1'b0),
    .RX_SUM_VREF_TUNE                   ( 3'b000),

    //----------------------------------------------------------------------------------------------
    //  MISC Attributes
    //----------------------------------------------------------------------------------------------                 
    .A_RXOSCALRESET                     ( 1'b0),   
    .ADAPT_CFG0                         (16'b1111100000000000),
    .ADAPT_CFG1                         (16'b0000000000000000),                             
    .DDI_CTRL                           ( 2'b00),
    .DDI_REALIGN_WAIT                   (15),
    .EVODD_PHI_CFG                      (11'b00000000000),     
    .GM_BIAS_SELECT                     ( 1'b0),     
    .PROCESS_PAR                        ( 3'b010), 
    .RX_CAPFF_SARC_ENB                  ( 1'b0),    
    .RX_DDI_SEL                         ( 6'b000000),  
    .RX_EN_HI_LR                        ( 1'b0),
    .TAPDLY_SET_TX                      ( 2'b00),
    .TEMPERATUR_PAR                     ( 4'b0010),
    .TST_RSV0                           ( 8'b00000000),                                                        
    .TST_RSV1                           ( 8'b00000000),
    .TX_DCD_CFG                         ( 6'b000010),
    .TX_DCD_EN                          ( 1'b0),
    .TX_EML_PHI_TUNE                    ( 1'b0),
    .TX_MODE_SEL                        ( 3'b000),
    .TX_PMADATA_OPT                     ( 1'b0),
    .TX_SARC_LPBK_ENB                   ( 1'b0),
    .WB_MODE                            ( 2'b00)                                                                         
)                                                                                                   
gthe3_channel_i                                                                                     
(                                                                                                                                                                                                   
    //----------------------------------------------------------------------------------------------
    //  Clock Ports
    //----------------------------------------------------------------------------------------------
    .GTGREFCLK                          ( 1'd0),                                                     
    .GTREFCLK0                          (GT_GTREFCLK0),                                            
    .GTREFCLK1                          ( 1'd0),                                                    
    .GTNORTHREFCLK0                     ( 1'd0),                                                    
    .GTNORTHREFCLK1                     ( 1'd0),                                                    
    .GTSOUTHREFCLK0                     ( 1'd0),                                                    
    .GTSOUTHREFCLK1                     ( 1'd0),                                             
    .TXUSRCLK                           (GT_TXUSRCLK),                                              
    .RXUSRCLK                           (GT_RXUSRCLK),                                              
    .TXUSRCLK2                          (GT_TXUSRCLK2),                                             
    .RXUSRCLK2                          (GT_RXUSRCLK2),  
    .TXPLLCLKSEL                        (PLLCLKSEL),            
    .RXPLLCLKSEL                        (PLLCLKSEL),                                                    
    .TXSYSCLKSEL                        (SYSCLKSEL),                                             
    .RXSYSCLKSEL                        (SYSCLKSEL),                             
    .TXOUTCLKSEL                        ( GTHE3_TXOUTCLKSEL_OUT), //3'd5        // select TXPROGDIVCLK
    .RXOUTCLKSEL                        ( 3'd2),                                // select RXOUTCLKPMA      
    .CLKRSVD0                           ( 1'd0),          
    .CLKRSVD1                           ( 1'd0),                                                 
                                                                                                   
    .TXOUTCLK                           (GT_TXOUTCLK),                                             
    .RXOUTCLK                           (GT_RXOUTCLK),                                                        
    .TXOUTCLKFABRIC                     (),                                                        
    .RXOUTCLKFABRIC                     (),                                                        
    .TXOUTCLKPCS                        (),                                                        
    .RXOUTCLKPCS                        (),  
    .RXRECCLKOUT                        (GT_RXRECCLKOUT),                                                    
    .GTREFCLKMONITOR                    (),                                                    
    
    //----------------------------------------------------------------------------------------------
    //  BUFG_GT Controller Ports
    //----------------------------------------------------------------------------------------------
    .BUFGTCE                            (GT_BUFGTCE),      
    .BUFGTCEMASK                        (GT_BUFGTCEMASK), 
    .BUFGTRSTMASK                       (GT_BUFGTRSTMASK),
    .BUFGTRESET                         (GT_BUFGTRESET), 
    .BUFGTDIV                           (GT_BUFGTDIV),        
    
    //----------------------------------------------------------------------------------------------
    //  CPLL Ports
    //----------------------------------------------------------------------------------------------
    .CPLLLOCKDETCLK                     ( 1'd0),                              
    .CPLLLOCKEN                         ( 1'd1),    
    .CPLLPD                             (GT_CPLLPD),    
    .CPLLREFCLKSEL                      (CPLLREFCLKSEL),                        // 3'd1 = select GTREFCLK0         
    .CPLLRESET                          (GT_CPLLRESET),                               
  
    .CPLLFBCLKLOST                      (),     
    .CPLLLOCK                           (GT_CPLLLOCK),                                            
    .CPLLREFCLKLOST                     (),                                                                                                         
             
    //----------------------------------------------------------------------------------------------
    //  QPLL Ports                                                                                   
    //----------------------------------------------------------------------------------------------
    .QPLL0CLK                           ( 1'b0),  
    .QPLL0REFCLK                        ( 1'b0),         
    .QPLL1CLK                           (GT_QPLLCLK),  
    .QPLL1REFCLK                        (GT_QPLLREFCLK),           
    
    //----------------------------------------------------------------------------------------------
    //  Reset Ports
    //----------------------------------------------------------------------------------------------                                                                                                                             
    .GTTXRESET                          (GT_GTTXRESET),                                             
    .GTRXRESET                          (GT_GTRXRESET),  
    .TXPROGDIVRESET                     (GT_TXPROGDIVRESET),                       
    .RXPROGDIVRESET                     (GT_RXPROGDIVRESET),                                                                            
    .TXPMARESET                         ( 1'd0),                                            
    .RXPMARESET                         ( 1'd0),                                            
    .TXPCSRESET                         ( 1'd0),   
    .RXPCSRESET                         ( 1'd0),   
    .TXUSERRDY                          (GT_TXUSERRDY),                                             
    .RXUSERRDY                          (GT_RXUSERRDY),   
    .CFGRESET                           ( 1'd0),                                                    
    .GTRESETSEL                         ( 1'd0),  
    .RESETOVRD                          ( 1'd0),  
    .RSTCLKENTX                         ( 1'd0),   
    .RXOOBRESET                         ( 1'd0),                                              
                                           
    .GTPOWERGOOD                        (GT_GTPOWERGOOD), 
    .TXPRGDIVRESETDONE                  (GT_TXPROGDIVRESETDONE),
    .RXPRGDIVRESETDONE                  (GT_RXPROGDIVRESETDONE),        
    .RXPMARESETDONE                     (GT_RXPMARESETDONE),                                                
    .TXPMARESETDONE                     (),                                                          
    .TXRESETDONE                        (GT_TXRESETDONE),                                           
    .RXRESETDONE                        (GT_RXRESETDONE),  
    .RXCDRPHDONE                        (),
    .RESETEXCEPTION                     (),

    //----------------------------------------------------------------------------------------------
    //  PCIe Ports
    //----------------------------------------------------------------------------------------------
    .PCIERSTIDLE                        (GT_PCIERSTIDLE),        
    .PCIERSTTXSYNCSTART                 (GT_PCIERSTTXSYNCSTART), 
    .PCIEEQRXEQADAPTDONE                (GT_PCIEEQRXEQADAPTDONE),
    .PCIEUSERRATEDONE                   (GT_PCIEUSERRATEDONE),
             
    .PCIEUSERPHYSTATUSRST               (GT_PCIEUSERPHYSTATUSRST),    
    .PCIERATEQPLLPD                     (GT_PCIERATEQPLLPD),                    
    .PCIERATEQPLLRESET                  (GT_PCIERATEQPLLRESET),                 
    .PCIERATEIDLE                       (GT_PCIERATEIDLE),            
    .PCIESYNCTXSYNCDONE                 (GT_PCIESYNCTXSYNCDONE),                          
    .PCIERATEGEN3                       (pcierategen3),    
    .PCIEUSERGEN3RDY                    (GT_PCIEUSERGEN3RDY),   
    .PCIEUSERRATESTART                  (GT_PCIEUSERRATESTART),    
           
    //----------------------------------------------------------------------------------------------
    //  Serial Line Ports
    //----------------------------------------------------------------------------------------------
    .GTHRXP                             (GT_RXP),                                                   
    .GTHRXN                             (GT_RXN),   
   
    .GTHTXP                             (GT_TXP),                                                 
    .GTHTXN                             (GT_TXN),   

    //----------------------------------------------------------------------------------------------
    //  TX Data Ports
    //----------------------------------------------------------------------------------------------
    .TXDATA                             (txdata),                                     
    .TXCTRL0                            (txctrl0),
    .TXCTRL1                            (txctrl1),  
    .TXCTRL2                            (txctrl2),
    .TXDATAEXTENDRSVD                   ( 8'd0),                                

    //----------------------------------------------------------------------------------------------
    //  RX Data Ports
    //----------------------------------------------------------------------------------------------
    .RXDATA                             (rxdata),                                                    
    .RXCTRL0                            (rxctrl0),   
    .RXCTRL1                            (), 
    .RXCTRL2                            (),
    .RXCTRL3                            (), 
    .RXDATAEXTENDRSVD                   (),                                     
 
    //----------------------------------------------------------------------------------------------
    //  PHY Command Ports
    //----------------------------------------------------------------------------------------------
    .TXDETECTRX                         (GT_TXDETECTRX),                                            
    .TXELECIDLE                         (GT_TXELECIDLE),                                      
    .TXPDELECIDLEMODE                   ( 1'd0),                                                                                 
    .RXELECIDLEMODE                     ( 2'd0),                                // PCIe
    .SIGVALIDCLK                        ( 1'd0),                                                                                    
    .TXPOLARITY                         ( 1'd0),                                              
    .RXPOLARITY                         (GT_RXPOLARITY),                                
    .TXPD                               (GT_POWERDOWN),                                           
    .RXPD                               (GT_POWERDOWN),                                           
    .TXRATE                             ({1'd0, GT_RATE}),                                                
    .RXRATE                             ({1'd0, GT_RATE}),                                                
    .TXRATEMODE                         ( 1'd0),                                                    
    .RXRATEMODE                         ( 1'd0),                                                    
 
    //----------------------------------------------------------------------------------------------
    //  PHY Status Ports
    //----------------------------------------------------------------------------------------------
    .RXVALID                            (GT_RXVALID),                                              
    .PHYSTATUS                          (GT_PHYSTATUS),                                            
    .RXELECIDLE                         (GT_RXELECIDLE),                                           
    .RXSTATUS                           (GT_RXSTATUS),                                             
    .TXRATEDONE                         (),                                           
    .RXRATEDONE                         (),                  
 
    //----------------------------------------------------------------------------------------------
    //  TX Driver Ports
    //----------------------------------------------------------------------------------------------
    .TXMARGIN                           (GT_TXMARGIN),                                           
    .TXSWING                            (GT_TXSWING),                                            
    .TXDEEMPH                           (GT_TXDEEMPH),                                           
    .TXBUFDIFFCTRL                      ( 3'b000),                             
    .TXDIFFCTRL                         ( 4'b1100),                         // ***
    .TXDIFFPD                           ( 1'd0),            
    .TXINHIBIT                          (GT_TXINHIBIT),  // 1'd0                                                  

    //----------------------------------------------------------------------------------------------
    //  TX Driver Ports (Gen3)
    //----------------------------------------------------------------------------------------------
    .TXPRECURSOR                        (GT_TXPRECURSOR),                                          
    .TXMAINCURSOR                       (GT_TXMAINCURSOR),                                         
    .TXPOSTCURSOR                       (GT_TXPOSTCURSOR),                                         
    .TXPRECURSORINV                     (1'd0),                                                    
    .TXPOSTCURSORINV                    (1'd0),                                             

    //----------------------------------------------------------------------------------------------
    //  PCS Ports
    //---------------------------------------------------------------------------------------------- 
    .PCSRSVDIN                          ({14'd0, GT_MASTER_CPLLLOCK, GT_QPLLLOCK}),                                        
    .PCSRSVDIN2                         ( 5'd0),                                                  

    .PCSRSVDOUT                         (pcsrsvdout),     

    //----------------------------------------------------------------------------------------------
    //  PMA Ports                                                                             
    //----------------------------------------------------------------------------------------------
    .PMARSVDIN                          ( 5'd0),                                                    

    //----------------------------------------------------------------------------------------------
    //  TX QPI Ports
    //----------------------------------------------------------------------------------------------
    .TXQPIBIASEN                        ( 1'd0),                                                    
    .TXQPISTRONGPDOWN                   ( 1'd0),                                                    
    .TXQPIWEAKPUP                       ( 1'd0),   
                                                                                                    
    .TXQPISENP                          (),                                                         
    .TXQPISENN                          (),   
    
    //----------------------------------------------------------------------------------------------
    //  RX QPI Ports
    //----------------------------------------------------------------------------------------------    
    .RXQPIEN                            ( 1'd0), 
                   
    .RXQPISENP                          (),                                                         
    .RXQPISENN                          (),  
    
    //----------------------------------------------------------------------------------------------
    //  RX Monitor Ports
    //----------------------------------------------------------------------------------------------
    .RXMONITORSEL                       (2'd0), 
    .RXMONITOROUT                       (),                                                                                                                                                                                                            
                                                                 
    //----------------------------------------------------------------------------------------------
    //  Comma Detect & Align Ports
    //----------------------------------------------------------------------------------------------
    .RXCOMMADETEN                       ( 1'd1),                  
    .RXMCOMMAALIGNEN                    (!pcierategen3),          
    .RXPCOMMAALIGNEN                    (!pcierategen3),          
                                                                                 
    .RXCOMMADET                         (GT_RXCOMMADET),                                            
    .RXBYTEISALIGNED                    (),                                        
    .RXBYTEREALIGN                      (),                                                                                                                 
                                                                                                    
    //----------------------------------------------------------------------------------------------
    // 8B10B Ports
    //----------------------------------------------------------------------------------------------
    .TX8B10BBYPASS                      ( 8'd0),                                                  
    .TX8B10BEN                          (!pcierategen3),                            
    .RX8B10BEN                          (!pcierategen3),                            
           
    //----------------------------------------------------------------------------------------------
    //  TX Buffer Ports
    //----------------------------------------------------------------------------------------------
    .TXBUFSTATUS                        (),                                                        
                                                                                                    
    //----------------------------------------------------------------------------------------------
    //  RX Buffer Ports
    //----------------------------------------------------------------------------------------------
    .RXBUFRESET                         ( 1'd0),                                          
    .RXBUFSTATUS                        (GT_RXBUFSTATUS),                
                      
    //----------------------------------------------------------------------------------------------
    //  Clock Correction Ports
    //----------------------------------------------------------------------------------------------
    .RXCLKCORCNT                        (),                            
                    
    //----------------------------------------------------------------------------------------------
    //  Channel Bonding Ports (disable)
    //----------------------------------------------------------------------------------------------
    .RXCHBONDEN                         ( 1'd0),                                         
    .RXCHBONDI                          ( 5'd0),                                         
    .RXCHBONDLEVEL                      ( 3'd0),                                         
    .RXCHBONDMASTER                     ( 1'd0),                                         
    .RXCHBONDSLAVE                      ( 1'd0),                                         
                                                                                    
    .RXCHANBONDSEQ                      (),                                         
    .RXCHANISALIGNED                    (),                                         
    .RXCHANREALIGN                      (),                                         
    .RXCHBONDO                          (),                                                                                                                                                                       
 
    //----------------------------------------------------------------------------------------------
    //  TX Phase Alignment Ports
    //----------------------------------------------------------------------------------------------
    .TXPHALIGN                          ( 1'd0),
    .TXPHALIGNEN                        ( 1'd0),
    .TXPHDLYPD                          ( 1'd0),
    .TXPHDLYRESET                       ( 1'd0),
    .TXPHDLYTSTCLK                      ( 1'd0),
    .TXPHINIT                           ( 1'd0),
    .TXPHOVRDEN                         ( 1'd0),
   
    .TXPHALIGNDONE                      (GT_TXPHALIGNDONE),
    .TXPHINITDONE                       (GT_TXPHINITDONE),
   
    //----------------------------------------------------------------------------------------------
    //  TX Delay Alignment Ports
    //----------------------------------------------------------------------------------------------
    .TXDLYBYPASS                        ( 1'd0),
    .TXDLYEN                            ( 1'd0),
    .TXDLYHOLD                          ( 1'd0),
    .TXDLYOVRDEN                        ( 1'd0),
    .TXDLYSRESET                        ( 1'd0),
    .TXDLYUPDOWN                        ( 1'd0),
       
    .TXDLYSRESETDONE                    (GT_TXDLYSRESETDONE),       
          
    //----------------------------------------------------------------------------------------------
    //  TX Auto Sync Alignment Ports 
    //----------------------------------------------------------------------------------------------
    .TXSYNCALLIN                        (GT_TXSYNCALLIN),
    .TXSYNCIN                           (GT_TXSYNCIN),
    .TXSYNCMODE                         (MASTER_LANE),                                         
                
    .TXSYNCDONE                         (),
    .TXSYNCOUT                          (GT_TXSYNCOUT),

    //----------------------------------------------------------------------------------------------
    //  RX Phase Alignment Ports 
    //----------------------------------------------------------------------------------------------
    .RXPHALIGN                          ( 1'd0),
    .RXPHALIGNEN                        ( 1'd0),
    .RXPHDLYPD                          ( 1'd0),
    .RXPHDLYRESET                       ( 1'd0),
    .RXPHOVRDEN                         ( 1'd0),
   
    .RXPHALIGNDONE                      (GT_RXPHALIGNDONE),
    .RXPHALIGNERR                       (),
       
    //----------------------------------------------------------------------------------------------
    //  RX Delay Alignment Ports
    //----------------------------------------------------------------------------------------------
    .RXDLYBYPASS                        ( 1'd1),
    .RXDLYEN                            ( 1'd0),
    .RXDLYOVRDEN                        ( 1'd0),
    .RXDLYSRESET                        ( 1'd0),
   
    .RXDLYSRESETDONE                    (GT_RXDLYSRESETDONE),                                           
        
    //----------------------------------------------------------------------------------------------
    //  RX Auto Sync Alignment Ports 
    //----------------------------------------------------------------------------------------------
    .RXSYNCALLIN                        ( 1'd0),
    .RXSYNCIN                           ( 1'd0),
    .RXSYNCMODE                         ( 1'd0),                                                    
                                                                                                    
    .RXSYNCDONE                         (GT_RXSYNCDONE),                                                
    .RXSYNCOUT                          (),    
       
    //----------------------------------------------------------------------------------------------
    //  Gearbox Ports 
    //----------------------------------------------------------------------------------------------
    .TXHEADER                           ( 6'd0), 
    .TXLATCLK                           ( 1'd0),                                                    
    .TXSEQUENCE                         ( 7'd0),                                                    
    .RXGEARBOXSLIP                      ( 1'd0),  
    .RXLATCLK                           ( 1'd0),  
    .RXSLIDE                            ( 1'd0),                                                    
                                                                                                    
    .RXDATAVALID                        (),                 
    .RXHEADER                           (),                                                         
    .RXHEADERVALID                      (), 
    .RXSLIDERDY                         (),                                                         
    .RXSTARTOFSEQ                       (),                             
                   
    //----------------------------------------------------------------------------------------------
    //  RX Slip Ports 
    //----------------------------------------------------------------------------------------------
    .RXSLIPOUTCLK                       ( 1'd0),
    .RXSLIPPMA                          ( 1'd0),   
                                                                   
    .RXSLIPDONE                         (),     
    .RXSLIPOUTCLKRDY                    (),
    .RXSLIPPMARDY                       (),             
       
    //----------------------------------------------------------------------------------------------
    //  RX LPM Ports 
    //----------------------------------------------------------------------------------------------
    .RXLPMEN                            (!pcierategen3),    
    .RXLPMGCHOLD                        ( 1'b0),            
    .RXLPMGCOVRDEN                      ( 1'b0),
    .RXLPMHFHOLD                        ( 1'b0),            
    .RXLPMHFOVRDEN                      ( 1'b0),
    .RXLPMLFHOLD                        ( 1'b0),         
    .RXLPMLFKLOVRDEN                    ( 1'b0), 
    .RXLPMOSHOLD                        ( 1'b0),            
    .RXLPMOSOVRDEN                      ( 1'b0),
                                                                                                    
    //----------------------------------------------------------------------------------------------
    //  RX DFE Ports
    //----------------------------------------------------------------------------------------------
    .RXDFEAGCCTRL                       ( 2'b01),                               // ***
    .RXDFEAGCHOLD                       ( 1'b0),            
    .RXDFEAGCOVRDEN                     ( 1'b0),
    .RXDFELFHOLD                        ( 1'b0),          
    .RXDFELFOVRDEN                      ( 1'b0),
    .RXDFELPMRESET                      ( 1'b0),
    .RXDFETAP2HOLD                      ( 1'b0),
    .RXDFETAP2OVRDEN                    ( 1'b0),
    .RXDFETAP3HOLD                      ( 1'b0),
    .RXDFETAP3OVRDEN                    ( 1'b0),
    .RXDFETAP4HOLD                      ( 1'b0),
    .RXDFETAP4OVRDEN                    ( 1'b0),
    .RXDFETAP5HOLD                      ( 1'b0),
    .RXDFETAP5OVRDEN                    ( 1'b0),
    .RXDFETAP6HOLD                      ( 1'b0),
    .RXDFETAP6OVRDEN                    ( 1'b0),
    .RXDFETAP7HOLD                      ( 1'b0),
    .RXDFETAP7OVRDEN                    ( 1'b0),
    .RXDFETAP8HOLD                      ( 1'b0),
    .RXDFETAP8OVRDEN                    ( 1'b0),
    .RXDFETAP9HOLD                      ( 1'b0),
    .RXDFETAP9OVRDEN                    ( 1'b0),
    .RXDFETAP10HOLD                     ( 1'b0),
    .RXDFETAP10OVRDEN                   ( 1'b0),
    .RXDFETAP11HOLD                     ( 1'b0),
    .RXDFETAP11OVRDEN                   ( 1'b0),
    .RXDFETAP12HOLD                     ( 1'b0),
    .RXDFETAP12OVRDEN                   ( 1'b0),
    .RXDFETAP13HOLD                     ( 1'b0),
    .RXDFETAP13OVRDEN                   ( 1'b0),
    .RXDFETAP14HOLD                     ( 1'b0),
    .RXDFETAP14OVRDEN                   ( 1'b0),
    .RXDFETAP15HOLD                     ( 1'b0),
    .RXDFETAP15OVRDEN                   ( 1'b0),
    .RXDFEUTHOLD                        ( 1'b0),
    .RXDFEUTOVRDEN                      ( 1'b0),
    .RXDFEVPHOLD                        ( 1'b0),
    .RXDFEVPOVRDEN                      ( 1'b0),
    .RXDFEVSEN                          ( 1'b0),
    .RXDFEXYDEN                         ( 1'b1),                                //                                                                    
    
    //----------------------------------------------------------------------------------------------
    //  TX PI Ports
    //----------------------------------------------------------------------------------------------
    .TXPIPPMEN                          ( 1'd0),
    .TXPIPPMOVRDEN                      ( 1'd0),
    .TXPIPPMPD                          ( 1'd0),
    .TXPIPPMSEL                         ( 1'd0),
    .TXPIPPMSTEPSIZE                    ( 5'd0),
    .TXPISOPD                           ( 1'd0),   
    
    //----------------------------------------------------------------------------------------------
    //  RX CDR Ports
    //----------------------------------------------------------------------------------------------
    .RXCDRFREQRESET                     ( 1'd0),
    .RXCDRHOLD                          (GT_RXCDRHOLD),
    .RXCDROVRDEN                        ( 1'd0),
    .RXCDRRESET                         ( 1'd0),
    .RXCDRRESETRSV                      ( 1'd0),
    
    .RXCDRLOCK                          (GT_RXCDRLOCK),     
       
    //----------------------------------------------------------------------------------------------
    //  Eye Scan Ports
    //----------------------------------------------------------------------------------------------
    .EYESCANMODE                        ( 1'd0),                                             
    .EYESCANRESET                       ( 1'd0),                                             
    .EYESCANTRIGGER                     ( 1'd0),                                             
                                                                                            
    .EYESCANDATAERROR                   (GT_EYESCANDATAERROR),           
       
    //----------------------------------------------------------------------------------------------
    //  RX OS Ports
    //----------------------------------------------------------------------------------------------
    .RXOSCALRESET                       ( 1'b0),
    .RXOSHOLD                           ( 1'b0),
    .RXOSINTCFG                         ( 4'b1101),                              // ***                                                  
    .RXOSINTEN                          ( 1'b1),                                
    .RXOSINTHOLD                        ( 1'b0),
    .RXOSINTOVRDEN                      ( 1'b0),
    .RXOSINTSTROBE                      ( 1'b0),
    .RXOSINTTESTOVRDEN                  ( 1'b0),
    .RXOSOVRDEN                         ( 1'b0),    
 
    .RXOSINTDONE                        (),                                                         
    .RXOSINTSTARTED                     (),                                                         
    .RXOSINTSTROBEDONE                  (),                                                         
    .RXOSINTSTROBESTARTED               (),         
           
    //----------------------------------------------------------------------------------------------
    //  DRP Ports
    //----------------------------------------------------------------------------------------------
    .DRPCLK                             (GT_DRPCLK ),
    .DRPADDR                            (GT_DRPADDR),
    .DRPEN                              (GT_DRPEN  ),
    .DRPWE                              (GT_DRPWE  ),
    .DRPDI                              (GT_DRPDI  ),
                                            
    .DRPRDY                             (GT_DRPRDY ),
    .DRPDO                              (GT_DRPDO  ),
    //----------------------------------------------------------------------------------------------
    //  Loopback & PRBS Ports
    //----------------------------------------------------------------------------------------------
    .LOOPBACK                           (GT_LOOPBACK), 
    .TXPRBSSEL                          (GT_PRBSSEL),                                                    
    .RXPRBSSEL                          (GT_PRBSSEL),  
    .TXPRBSFORCEERR                     (GT_TXPRBSFORCEERR),  
    .RXPRBSCNTRESET                     (GT_RXPRBSCNTRESET),                                                                                                      

    .RXPRBSERR                          (GT_RXPRBSERR),                                                
    .RXPRBSLOCKED                       (GT_RXPRBSLOCKED),       

    //----------------------------------------------------------------------------------------------
    //  Digital Monitor Ports                                                                             
    //----------------------------------------------------------------------------------------------
    .DMONFIFORESET                      (GT_DMONFIFORESET),                                                    
    .DMONITORCLK                        (GT_DMONITORCLK),                                                    
    
    .DMONITOROUT                        (GT_DMONITOROUT),                
      
   //----------------------------------------------------------------------------------------------
    //  SATA Ports 
    //----------------------------------------------------------------------------------------------
    .TXCOMINIT                          ( 1'd0),                                                    
    .TXCOMSAS                           ( 1'd0),                                                    
    .TXCOMWAKE                          ( 1'd0),                                                    

    .TXCOMFINISH                        (),                                                         
    .RXCOMINITDET                       (),                                                         
    .RXCOMSASDET                        (),                                                         
    .RXCOMWAKEDET                       (),        

    //----------------------------------------------------------------------------------------------
    //  EVO Ports
    //----------------------------------------------------------------------------------------------
    .EVODDPHICALDONE                    ( 1'd0), 
    .EVODDPHICALSTART                   ( 1'd0),
    .EVODDPHIDRDEN                      ( 1'd0),   
    .EVODDPHIDWREN                      ( 1'd0),   
    .EVODDPHIXRDEN                      ( 1'd0),   
    .EVODDPHIXWREN                      ( 1'd0),                                                   

    //----------------------------------------------------------------------------------------------
    //  MISC Ports
    //----------------------------------------------------------------------------------------------
    .GTRSVD                             (16'd0),
    .LPBKRXTXSEREN                      ( 1'd0),
    .LPBKTXRXSEREN                      ( 1'd0),
    .TSTIN                              (20'h00000),                                                // ***                          
                                                                                                    
    .PINRSRVDAS                         ()                                      
);
  
    
    
//--------------------------------------------------------------------------------------------------
//  Input Port Remapping
//--------------------------------------------------------------------------------------------------    
assign txdata[ 31: 0] = GT_TXDATA;
assign txdata[127:32] = 96'd0;

assign txctrl0[ 1:0] = 2'd0;
assign txctrl0[   2] = GT_TXDATA_VALID;
assign txctrl0[   3] = GT_TXSTART_BLOCK;
assign txctrl0[ 5:4] = GT_TXSYNC_HEADER;
assign txctrl0[15:6] = 10'd0;

assign txctrl1[   0] = GT_TXCOMPLIANCE;
assign txctrl1[15:1] = 15'd0;

assign txctrl2[ 1:0] = GT_TXDATAK;
assign txctrl2[ 7:2] = 6'd0;



//--------------------------------------------------------------------------------------------------
//  GT Channel Outputs
//--------------------------------------------------------------------------------------------------
assign GT_RXDATA             = rxdata[31:0];

assign GT_RXDATAK            = rxctrl0[1:0];
assign GT_RXDATA_VALID       = rxctrl0[2];
assign GT_RXSTART_BLOCK      = rxctrl0[3];
assign GT_RXSYNC_HEADER      = rxctrl0[5:4];

assign GT_PCIERATEGEN3       = pcierategen3;
assign GT_QPLLRATE           = pcsrsvdout[2:0];



endmodule
