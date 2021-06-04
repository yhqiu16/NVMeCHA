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
// File       : xdma_0_pcie3_ip_phy_wrapper.v
// Version    : 4.4 
//-----------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
//  Design  :  UltraScale PCIe PHY Wrapper  
//  Module  :  PHY Wrapper Top
//--------------------------------------------------------------------------------------------------
//  *** REFERENCE DESIGN ****
//--------------------------------------------------------------------------------------------------
//  Version :  1.65
//--------------------------------------------------------------------------------------------------



//--------------------------------------------------------------------------------------------------
//  PHY Wrapper Design Hierarchy in Default Mode
//--------------------------------------------------------------------------------------------------
//  PHY Wrapper Top :
//      - Clock 
//      - Reset
//      - PHY Lane :
//          - TX Equalization (Gen3)
//          - RX Equalization (Gen3)
//          - GT Channel
//      - PHY Quad (one quad for every four lanes):
//          - GT Common 
//--------------------------------------------------------------------------------------------------



//--------------------------------------------------------------------------------------------------
//  PHY Wrapper Design Hierarchy in GT Wizard Mode
//--------------------------------------------------------------------------------------------------
//  PHY Wrapper Top :
//      - Clock 
//      - Reset
//      - PHY Lane :
//          - TX Equalization (Gen3)
//          - RX Equalization (Gen3)
//      - GT Wizard Top
//          - GT Wizard Core
//              - GT Channel (one channel for every lane)
//              - GT Common  (one quad for every four lanes)
//--------------------------------------------------------------------------------------------------



//--------------------------------------------------------------------------------------------------
//  PHY Wrapper Parameter Encoding
//--------------------------------------------------------------------------------------------------
//  PHY_SIM_EN        : "FALSE" = Normal
//                    : "TRUE"  = Simulation
//  PHY_LANE          : 1, 2, 4, 8
//  PHY_MAX_SPEED     : 1 = Gen1 Capable        
//                    : 2 = Gen2 Capable
//                    : 3 = Gen3 Capable 
//  PHY_ASYNC_EN      : "FALSE" = Sync Clocking
//                    : "TRUE"  = Async Clocking
//  PHY_REFCLK_FREQ   : 0 = 100 MHz 
//                    : 1 = 125 MHz
//                    : 2 = 250 MHz
//  PHY_CORECLK_FREQ  : 1 = 250.0 MHz
//                    : 2 = 500.0 MHz
//  PHY_USERCLK_FREQ  : 1 =  62.5 MHz
//                    : 2 = 125.0 MHz
//                    : 3 = 250.0 MHz
//                    : 4 = 500.0 MHz
//  PHY_GT_TXPRESET   : 0 to 10
//  PHY_LP_TXPRESET   : 0 to 10
//--------------------------------------------------------------------------------------------------



`timescale 1ps / 1ps



//--------------------------------------------------------------------------------------------------
//  PHY Wrapper Top
//--------------------------------------------------------------------------------------------------
module xdma_0_pcie3_ip_phy_wrapper #
(
    //--------------------------------------------------------------------------
    //  Parameters
    //--------------------------------------------------------------------------
    parameter PL_UPSTREAM_FACING = "TRUE",
    parameter integer SHARED_LOGIC     = 0,
    parameter         DIS_GT_WIZARD    = "FALSE",  
    parameter         PHY_SIM_EN       = "FALSE",   
    parameter integer PHY_LANE         = 1,   
    parameter integer PHY_MAX_SPEED    = 3,                    
    parameter         PHY_ASYNC_EN     = "FALSE",     
    parameter         PHY_REFCLK_FREQ  = 0,     
    parameter integer PHY_USERCLK_FREQ = 3,           
    parameter integer PHY_CORECLK_FREQ = 2,       
    parameter integer PHY_GT_TXPRESET  = 0,
    parameter integer PHY_LP_TXPRESET  = 4         
)                                                            
(                                         

    //--------------------------------------------------------------------------
    //  Clock & Reset Ports
    //--------------------------------------------------------------------------
    input                               PHY_REFCLK,          
    input                               PHY_GTREFCLK,     
    input                               PHY_RST_N,           
   
    output                              PHY_PCLK,  
    output                              PHY_CORECLK, 
    output                              PHY_USERCLK,                          
    output				mcap_clk,
  
    //--------------------------------------------------------------------------
    //  Serial Line Ports
    //--------------------------------------------------------------------------
    input       [PHY_LANE-1:0]          PHY_RXP,               
    input       [PHY_LANE-1:0]          PHY_RXN,               

    output      [PHY_LANE-1:0]          PHY_TXP,               
    output      [PHY_LANE-1:0]          PHY_TXN,   
 
    //--------------------------------------------------------------------------
    //  TX Data Ports 
    //--------------------------------------------------------------------------
    input       [(PHY_LANE*32)-1:0]     PHY_TXDATA,            
    input       [(PHY_LANE* 2)-1:0]     PHY_TXDATAK,    
    input       [PHY_LANE-1:0]          PHY_TXDATA_VALID,
    input       [PHY_LANE-1:0]          PHY_TXSTART_BLOCK,      
    input       [(PHY_LANE* 2)-1:0]     PHY_TXSYNC_HEADER,                    

    //--------------------------------------------------------------------------
    //  RX Data Ports 
    //--------------------------------------------------------------------------
    output      [(PHY_LANE*32)-1:0]     PHY_RXDATA,            
    output      [(PHY_LANE* 2)-1:0]     PHY_RXDATAK,       
    output      [PHY_LANE-1:0]          PHY_RXDATA_VALID,         
    output      [PHY_LANE-1:0]          PHY_RXSTART_BLOCK,        
    output      [(PHY_LANE* 2)-1:0]     PHY_RXSYNC_HEADER,        
    
    //--------------------------------------------------------------------------
    //  PHY Command Port
    //--------------------------------------------------------------------------
    input                               PHY_TXDETECTRX,        
    input       [PHY_LANE-1:0]          PHY_TXELECIDLE,        
    input       [PHY_LANE-1:0]          PHY_TXCOMPLIANCE,      
    input       [PHY_LANE-1:0]          PHY_RXPOLARITY,        
    input       [1:0]                   PHY_POWERDOWN,         
    
    //--------------------------------------------------------------------------   
    //  PHY Status Ports
    //-------------------------------------------------------------------------- 
    output      [PHY_LANE-1:0]          PHY_RXVALID,               
    output      [PHY_LANE-1:0]          PHY_PHYSTATUS,          
    output                              PHY_PHYSTATUS_RST,         
    output      [PHY_LANE-1:0]          PHY_RXELECIDLE,         
    output      [(PHY_LANE*3)-1:0]      PHY_RXSTATUS,                       
    
    //--------------------------------------------------------------------------
    //  TX Driver Ports
    //--------------------------------------------------------------------------
    input       [ 2:0]                  PHY_TXMARGIN,          
    input                               PHY_TXSWING,           
    input                               PHY_TXDEEMPH,    
    input                               PHY_RXCDRHOLD,    
    
    //--------------------------------------------------------------------------   
    //  TX Equalization Ports (Gen3)
    //--------------------------------------------------------------------------  
    input       [(PHY_LANE*2)-1:0]      PHY_TXEQ_CTRL,      
    input       [(PHY_LANE*4)-1:0]      PHY_TXEQ_PRESET,       
    input       [(PHY_LANE*6)-1:0]      PHY_TXEQ_COEFF,                                                            

    output      [ 5:0]                  PHY_TXEQ_FS,           
    output      [ 5:0]                  PHY_TXEQ_LF,           
    output      [(PHY_LANE*18)-1:0]     PHY_TXEQ_NEW_COEFF,        
    output      [PHY_LANE-1:0]          PHY_TXEQ_DONE,         

    //--------------------------------------------------------------------------
    //  RX Equalization Ports (Gen3)
    //--------------------------------------------------------------------------                                               
    input       [(PHY_LANE*2)-1:0]      PHY_RXEQ_CTRL,     
    input       [(PHY_LANE*3)-1:0]      PHY_RXEQ_PRESET,  
    input       [(PHY_LANE*4)-1:0]      PHY_RXEQ_TXPRESET,      
    input       [(PHY_LANE*6)-1:0]      PHY_RXEQ_LFFS,                                                         

    output      [PHY_LANE-1:0]          PHY_RXEQ_LFFS_SEL,    
    output      [(PHY_LANE*18)-1:0]     PHY_RXEQ_NEW_TXCOEFF,   
    output      [PHY_LANE-1:0]          PHY_RXEQ_ADAPT_DONE,     
    output      [PHY_LANE-1:0]          PHY_RXEQ_DONE,         
    
   //---------- Shared Logic Internal -------------------------
    output      [(PHY_LANE-1)>>2:0]     INT_QPLL1LOCK_OUT,
    output      [(PHY_LANE-1)>>2:0]     INT_QPLL1OUTREFCLK_OUT,
    output      [(PHY_LANE-1)>>2:0]     INT_QPLL1OUTCLK_OUT,
    //---------- External GT COMMON Ports ----------------------
    output      [(PHY_LANE-1)>>2:0]             EXT_QPLL1REFCLK,
    output      [(PHY_LANE-1)>>2:0]             EXT_QPLL1PD,
    output      [((((PHY_LANE-1)>>2)+1)*3)-1:0] EXT_QPLL1RATE,
    output      [(PHY_LANE-1)>>2:0]             EXT_QPLL1RESET,

    input       [(PHY_LANE-1)>>2:0]             EXT_QPLL1LOCK_OUT,
    input       [(PHY_LANE-1)>>2:0]             EXT_QPLL1OUTCLK_OUT,
    input       [(PHY_LANE-1)>>2:0]             EXT_QPLL1OUTREFCLK_OUT,
    //--------------------------------------------------------------------------   
    //  IBERT ports 
    //--------------------------------------------------------------------------                   
     input                                free_run_clock_in,
     input [(PHY_LANE * 5) -1:0]          ibert_txprecursor_in, 
     input [(PHY_LANE * 5) -1:0]          ibert_txpostcursor_in, 
     input [PHY_LANE-1:0]                 ibert_eyescanreset_in, 
     input [(PHY_LANE * 4) -1:0]          ibert_txdiffctrl_in, 
     input [PHY_LANE-1:0]                 ibert_rxlpmen_in, 
     input       [1:0]                    PHY_RATE,    

    output        [(PHY_LANE*5)-1:0]      txeq_precursor, 
    output        [(PHY_LANE*5)-1:0]      txeq_postcursor, 
    output        [PHY_LANE-1:0]          gt_pcierategen3,  
    //--------------------------------------------------------------------------
    //  GT Debug Ports
    //--------------------------------------------------------------------------
    output                                 GTW_DRPCLK,   
    input       [((PHY_LANE *  9)-1):0]    GTW_DRPADDR, 
    input       [((PHY_LANE *  1)-1):0]    GTW_DRPEN,    
    input       [((PHY_LANE *  1)-1):0]    GTW_DRPWE,    
    input       [((PHY_LANE * 16)-1):0]    GTW_DRPDI,   
                                            
    output      [((PHY_LANE *  1)-1):0]    GTW_DRPRDY,   
    output      [((PHY_LANE * 16)-1):0]    GTW_DRPDO,     
    //--------------------------------------------------------------------------
    //  Transceiver Debug And Status Ports
    //--------------------------------------------------------------------------
    input       [PHY_LANE-1:0]          GT_PCIEUSERRATEDONE,
    input       [(PHY_LANE*3)-1:0]      GT_LOOPBACK        ,             
    input       [PHY_LANE-1:0]          GT_TXPRBSFORCEERR  ,            
    input       [PHY_LANE-1:0]          GT_TXINHIBIT       ,            
    input       [PHY_LANE*4-1:0]        GT_TXPRBSSEL       ,            
    input       [PHY_LANE*4-1:0]        GT_RXPRBSSEL       ,          
    input       [PHY_LANE-1:0]          GT_RXPRBSCNTRESET  ,             

    output      [PHY_LANE-1:0]          GT_TXELECIDLE      ,             
    output      [PHY_LANE-1:0]          GT_TXRESETDONE     ,    
    output      [PHY_LANE-1:0]          GT_RXRESETDONE     ,        
    output      [PHY_LANE-1:0]          GT_RXPMARESETDONE  ,      
    output      [PHY_LANE-1:0]          GT_TXPHALIGNDONE   ,            
    output      [PHY_LANE-1:0]          GT_TXPHINITDONE    ,         
    output      [PHY_LANE-1:0]          GT_TXDLYSRESETDONE ,         
    output      [PHY_LANE-1:0]          GT_RXPHALIGNDONE   ,        
    output      [PHY_LANE-1:0]          GT_RXDLYSRESETDONE ,          
    output      [PHY_LANE-1:0]          GT_RXSYNCDONE      ,        
    output      [PHY_LANE-1:0]          GT_EYESCANDATAERROR,               
    output      [PHY_LANE-1:0]          GT_RXPRBSERR       ,           
    output      [PHY_LANE-1:0]          GT_RXCOMMADET      ,                   
    output      [PHY_LANE-1:0]          GT_PHYSTATUS       ,                   
    output      [PHY_LANE-1:0]          GT_RXVALID         ,              
    output      [PHY_LANE-1:0]          GT_RXCDRLOCK, 
    output      [PHY_LANE-1:0]          GT_PCIERATEIDLE,
    output      [PHY_LANE-1:0]          GT_PCIEUSERRATESTART,
    output      [PHY_LANE-1:0]          GT_GTPOWERGOOD,  
    output      [PHY_LANE-1:0]          GT_CPLLLOCK,          
    output      [PHY_LANE-1:0]          GT_RXOUTCLK, 
    output      [PHY_LANE-1:0]          GT_RXRECCLKOUT, 
    output      [PHY_LANE-1:0]          GT_RXLPMEN, 
    
    input       [PHY_LANE-1:0]          GT_DMONFIFORESET,
    input       [PHY_LANE-1:0]          GT_DMONITORCLK,
    output      [(PHY_LANE*17)-1:0]     GT_DMONITOROUT,           
    output      [(PHY_LANE-1)>>2:0]     GT_QPLL1LOCK,               
    output      [(PHY_LANE*3)-1:0]      GT_RXSTATUS,            
    output      [(PHY_LANE*3)-1:0]      GT_RXBUFSTATUS,            
    output      [8:0]                   GT_BUFGTDIV,                 
    output      [(PHY_LANE*2)-1:0]      TXEQ_CTRL,                  
    output      [(PHY_LANE*4)-1:0]      TXEQ_PRESET,                   
    output      [3:0]                   PHY_RST_FSM,                 
    output      [(PHY_LANE*3)-1:0]      PHY_TXEQ_FSM,                  
    output      [(PHY_LANE*3)-1:0]      PHY_RXEQ_FSM,                 
    output                              PHY_RST_IDLE,                 
    output                              PHY_RRST_N,
    output                              PHY_PRST_N,

    //--------------------------------------------------------------------------
    //  PCIe State
    //--------------------------------------------------------------------------
    input                               PHASE1,

    input       [5:0]                   cfg_ltssm_state
);

//--------------------------------------------------------------------------------------------------
//  Internal Signals
//--------------------------------------------------------------------------------------------------

    wire     [(PHY_LANE*4)-1:0]       DEBUG_OUT;
    //--------------------------------------------------------------------------
    //  Clock 
    //--------------------------------------------------------------------------
    wire                                pclk; 
    //--------------------------------------------------------------------------
    //  Reset
    //--------------------------------------------------------------------------
    wire                                rrst_n;
    wire                                prst_n;
    
    wire                                rst_cpllpd;
    wire                                rst_cpllreset;  
    wire                                rst_qpll1pd;  
    wire                                rst_qpll1reset;
    wire                                rst_progdivreset;
    wire                                rst_gtreset;
    wire                                rst_userrdy; 
    wire                                rst_txsync_start;
    wire                                rst_idle;

    //--------------------------------------------------------------------------
    //  TX Equalization (Gen3)
    //-------------------------------------------------------------------------- 
    wire        [(PHY_LANE*7)-1:0]      txeq_maincursor; 
    wire        [(PHY_LANE*18)-1:0]     txeq_new_coeff; 
    wire        [PHY_LANE-1:0]          txeq_done;  
    
    //--------------------------------------------------------------------------
    //  RX Equalization (Gen3)
    //-------------------------------------------------------------------------- 
    wire        [PHY_LANE-1:0]          rxeq_lffs_sel;   
    wire        [(PHY_LANE*18)-1:0]     rxeq_new_txcoeff;    
    wire        [PHY_LANE-1:0]          rxeq_adapt_done;     
    wire        [PHY_LANE-1:0]          rxeq_done;   
    
    //--------------------------------------------------------------------------
    //  GT Channel 
    //--------------------------------------------------------------------------
    wire        [(PHY_LANE*3)-1:0]      gt_bufgtce;    
    wire        [(PHY_LANE*3)-1:0]      gt_bufgtcemask;
    wire        [(PHY_LANE*3)-1:0]      gt_bufgtreset;
    wire        [(PHY_LANE*3)-1:0]      gt_bufgtrstmask;   
    wire        [(PHY_LANE*9)-1:0]      gt_bufgtdiv;
    wire        [PHY_LANE-1:0]          gt_txoutclk;
    wire        [PHY_LANE-1:0]          gt_rxoutclk;
    wire        [PHY_LANE-1:0]          gt_rxrecclkout;    

    wire        [PHY_LANE-1:0]          gt_gtpowergood;
    wire        [PHY_LANE-1:0]          gt_txprogdivresetdone;
    wire        [PHY_LANE-1:0]          gt_rxprogdivresetdone;
    wire        [PHY_LANE-1:0]          gt_txresetdone;
    wire        [PHY_LANE-1:0]          gt_rxresetdone;
    
    wire        [(PHY_LANE*3)-1:0]      gt_qpllrate;                            // Not use in GT Wizard mode
    
    wire        [PHY_LANE-1:0]          gt_phystatus;
    
    wire        [PHY_LANE-1:0]          gt_pcieuserphystatusrst;
    wire        [(PHY_LANE*2)-1:0]      gt_pcierateqpllpd;                 
    wire        [(PHY_LANE*2)-1:0]      gt_pcierateqpllreset;               
    wire        [PHY_LANE-1:0]          gt_pcierateidle;            
    wire        [PHY_LANE-1:0]          gt_pciesynctxsyncdone;                    
    wire        [PHY_LANE-1:0]          gt_pcieusergen3rdy; 
    wire        [PHY_LANE-1:0]          gt_pcieuserratestart;  
    
    wire        [PHY_LANE-1:0]          gt_txphaligndone;                       // Not use in GT Wizard mode                         
    wire        [PHY_LANE-1:0]          gt_txsyncout;                           // Not use in GT Wizard mode
    
    wire        [PHY_LANE-1:0]          gt_cplllock;     
    wire        [PHY_LANE-1:0]          gt_rxcdrlock;    
    wire        [PHY_LANE-1:0]          gt_rxratedone;

    wire        [PHY_LANE-1:0]          gt_rxlpmen;
    wire        [PHY_LANE-1:0]          rxlpmen_set;
    wire        [PHY_LANE-1:0]          gt_gtresetsel;
    wire        [PHY_LANE-1:0]          gt_rxdfelpmreset;
    reg         [PHY_LANE-1:0]          txpmaresetdone_deassert;
    
    wire        [PHY_LANE-1:0]          gt_txoutclkpcs_i;
    wire        [PHY_LANE-1:0]          gt_txoutclkpcs_bufg_i;
    
    wire       [(PHY_LANE*17)-1:0]     gt_dmonitorout_i;
    
    wire        [PHY_LANE-1:0]          gt_drprdy;
    wire        [(PHY_LANE*16)-1:0]     gt_drpdo;   

    //--------------------------------------------------------------------------
    //  GT Common
    //--------------------------------------------------------------------------
    wire        [   (PHY_LANE-1)>>2          :0]    qpll1pd;                    // Not used in GT Wizard mode
    wire        [   (PHY_LANE-1)>>2          :0]    qpll1reset;                 // Not used in GT Wizard mode
    
    wire        [   (PHY_LANE-1)>>2          :0]    gtcom_qpll1lock;
    wire        [   (PHY_LANE-1)>>2          :0]    gtcom_qpll1outclk;          // Not used in GT Wizard mode
    wire        [   (PHY_LANE-1)>>2          :0]    gtcom_qpll1outrefclk;       // Not used in GT Wizard mode

    //--------------------------------------------------------------------------
    //  Signals converted from per lane
    //--------------------------------------------------------------------------
    wire                                qpll1lock_all;                          // Not used in GT Wizard mode
    wire                                txsyncallin_all;                        // Not used in GT Wizard mode
    
    wire                                bufg_gt_ce;
    wire                                bufg_gt_clr;
    wire [2:0] clk_pclk_div   ;
    wire [2:0] clk_coreclk_div;
    wire [2:0] clk_userclk_div;
(* keep = "true" *) wire [2:0] PHY_TXOUTCLKSEL;

    wire        [PHY_LANE-1:0]          gt_rxratemode;
    wire        [PHY_LANE-1:0]          eyescanreset_i; 
    wire        [(PHY_LANE*2)-1:0]      rate_delayed;  
    
    wire        [PHY_LANE-1:0]          dummy;

    



assign clk_pclk_div    = gt_bufgtdiv[2:0];
assign clk_coreclk_div = gt_bufgtdiv[5:3];
assign clk_userclk_div = gt_bufgtdiv[8:6];

  // CE and CLR are 1 and 0 respectively until cpllreset is released.  
  assign bufg_gt_ce  = rrst_n? gt_bufgtce[0] : 1'b1;
  assign bufg_gt_clr = !rst_cpllreset? gt_bufgtreset[0] : 1'b0;
  assign PHY_TXOUTCLKSEL = rst_cpllreset? 3'h3 : 3'h5;

//--------------------------------------------------------------------------------------------------
//  PHY Clock 
//--------------------------------------------------------------------------------------------------
xdma_0_pcie3_ip_phy_clk phy_clk_i
(
    //--------------------------------------------------------------------------
    //  PCLK Ports
    //--------------------------------------------------------------------------
    .CLK_PCLK_CE                        (bufg_gt_ce),                        
    .CLK_PCLK_CEMASK                    (gt_bufgtcemask[0]), 
    .CLK_PCLK_CLR                       (bufg_gt_clr),                     
    .CLK_PCLK_MASK                      (gt_bufgtrstmask[0]),   
    .CLK_PCLK_DIV                       (clk_pclk_div),
    .CLK_PCLK_IN                        (gt_txoutclk[0]),     
    .CLK_PCLK                           (pclk),
    
    //--------------------------------------------------------------------------
    //  CORECLK Ports
    //--------------------------------------------------------------------------
    .CLK_CORECLK_CE                     (bufg_gt_ce),                       
    .CLK_CORECLK_CEMASK                 (rst_idle),            
    .CLK_CORECLK_CLR                    (bufg_gt_clr),                   
    .CLK_CORECLK_MASK                   (rst_idle),              
    .CLK_CORECLK_DIV                    (clk_coreclk_div),
    .CLK_CORECLK_IN                     (gt_txoutclk[0]),                       
    .CLK_CORECLK                        (PHY_CORECLK), 
    
    //--------------------------------------------------------------------------
    //  USERCLK Ports
    //--------------------------------------------------------------------------
    .CLK_USERCLK_CE                     (bufg_gt_ce),                       
    .CLK_USERCLK_CEMASK                 (rst_idle),
    .CLK_USERCLK_CLR                    (bufg_gt_clr),                    
    .CLK_USERCLK_MASK                   (rst_idle),
    .CLK_USERCLK_DIV                    (clk_userclk_div),
    .CLK_USERCLK_IN                     (gt_txoutclk[0]),  
    .CLK_USERCLK                        (PHY_USERCLK)
);

BUFG_GT bufg_mcap_clk (.CE (bufg_gt_ce), .CEMASK (1'd0), .CLR (bufg_gt_clr), .CLRMASK (1'd0), .DIV (3'd3), .I (gt_txoutclk[0]), .O (mcap_clk));

//--------------------------------------------------------------------------------------------------
//  PHY Reset
//--------------------------------------------------------------------------------------------------
xdma_0_pcie3_ip_phy_rst #
(
    .PHY_LANE                           (PHY_LANE),
    .PL_UPSTREAM_FACING                 (PL_UPSTREAM_FACING),
    .PHY_MAX_SPEED                      (PHY_MAX_SPEED)            
)
phy_rst_i
(
    //-------------------------------------------------------------------------- 
    //  Input Ports
    //--------------------------------------------------------------------------       
    .RST_REFCLK                         (PHY_REFCLK),   
    .RST_PCLK                           (pclk),                         
    .RST_N                              (PHY_RST_N),  
    .RST_GTPOWERGOOD                    (gt_gtpowergood),                
    .RST_QPLL0LOCK                      (1'b0),                
    .RST_QPLL1LOCK                      (gtcom_qpll1lock), 
    .RST_CPLLLOCK                       (gt_cplllock),
    .RST_TXPROGDIVRESETDONE             (gt_txprogdivresetdone),
    .RST_RXPROGDIVRESETDONE             (gt_rxprogdivresetdone),                             
    .RST_TXRESETDONE                    (gt_txresetdone), 
    .RST_RXRESETDONE                    (gt_rxresetdone), 
    .RST_TXSYNC_DONE                    (gt_pciesynctxsyncdone),     
    .RST_PHYSTATUS                      (gt_phystatus),                                             

    //-------------------------------------------------------------------------- 
    //  Output Ports
    //--------------------------------------------------------------------------   
    .phy_rst_fsm                        (PHY_RST_FSM),
    .RST_RRST_N                         (rrst_n),
    .RST_PRST_N                         (prst_n), 
    .RST_CPLLPD                         (rst_cpllpd),               
    .RST_CPLLRESET                      (rst_cpllreset),  
    .RST_QPLLPD                         (rst_qpll1pd),
    .RST_QPLLRESET                      (rst_qpll1reset),  
    .RST_TXPROGDIVRESET                 (rst_progdivreset),                              
    .RST_GTRESET                        (rst_gtreset),               
    .RST_USERRDY                        (rst_userrdy),   
    .RST_TXSYNC_START                   (rst_txsync_start),                                
    .RST_IDLE                           (rst_idle)                          
);
   


//--------------------------------------------------------------------------------------------------
//  Generate PHY Lane - Begin
//--------------------------------------------------------------------------------------------------
genvar i;   
    
generate for (i=0; i<PHY_LANE; i=i+1) 

    begin : phy_lane




    //----------------------------------------------------------------------------------------------
    //  PHY TX Equalization (Gen3)
    //----------------------------------------------------------------------------------------------
xdma_0_pcie3_ip_phy_txeq #
    (
        .PHY_GT_TXPRESET                (PHY_GT_TXPRESET)                
    )
    phy_txeq_i
    (
        //---------------------------------------------------------------------- 
        //  Input Ports
        //----------------------------------------------------------------------  
        .TXEQ_CLK                       (pclk),
        .TXEQ_RST_N                     (prst_n),    
        .TXEQ_CTRL                      (PHY_TXEQ_CTRL[(2*i)+1:(2*i)]), 
        .TXEQ_PRESET                    (PHY_TXEQ_PRESET[(4*i)+3:(4*i)]), 
        .TXEQ_COEFF                     (PHY_TXEQ_COEFF[(6*i)+5:(6*i)]),

        //---------------------------------------------------------------------- 
        //  Output Ports
        //----------------------------------------------------------------------   
        .phy_txeq_fsm                   (PHY_TXEQ_FSM[(3*i)+2:(3*i)]),
        .TXEQ_PRECURSOR                 (txeq_precursor[(5*i)+4:(5*i)]),        
        .TXEQ_MAINCURSOR                (txeq_maincursor[(7*i)+6:(7*i)]),       
        .TXEQ_POSTCURSOR                (txeq_postcursor[(5*i)+4:(5*i)]),       
        .TXEQ_NEW_COEFF                 (txeq_new_coeff[(18*i)+17:(18*i)]),          
        .TXEQ_DONE                      (txeq_done[i])      
    );                                                   



    //----------------------------------------------------------------------------------------------
    //  PHY RX Equalization (Gen3)
    //----------------------------------------------------------------------------------------------
xdma_0_pcie3_ip_phy_rxeq #
    (
        .PHY_SIM_EN                     (PHY_SIM_EN),
        .PHY_LP_TXPRESET                (PHY_LP_TXPRESET)                
    )
    phy_rxeq_i
    (
        //---------------------------------------------------------------------- 
        //  Input Ports
        //----------------------------------------------------------------------  
        .RXEQ_CLK                       (pclk),
        .RXEQ_RST_N                     (prst_n),    
        .RXEQ_CTRL                      (PHY_RXEQ_CTRL[(2*i)+1:(2*i)]), 
        .RXEQ_PRESET                    (PHY_RXEQ_PRESET[(3*i)+2:(3*i)]), 
        .RXEQ_TXPRESET                  (PHY_RXEQ_TXPRESET[(4*i)+3:(4*i)]),
        .RXEQ_TXCOEFF                   (PHY_TXEQ_COEFF[(6*i)+5:(6*i)]),
        .RXEQ_LFFS                      (PHY_RXEQ_LFFS[(6*i)+5:(6*i)]),

        //---------------------------------------------------------------------- 
        //  Output Ports
        //----------------------------------------------------------------------     
        .phy_rxeq_fsm                   (PHY_RXEQ_FSM[(3*i)+2:(3*i)]),
        .RXEQ_LFFS_SEL                  (rxeq_lffs_sel[i]),   
        .RXEQ_NEW_TXCOEFF               (rxeq_new_txcoeff[(18*i)+17:(18*i)]),    
        .RXEQ_ADAPT_DONE                (rxeq_adapt_done[i]),      
        .RXEQ_DONE                      (rxeq_done[i])      
    );

    assign rxlpmen_set[i] = 'd0;
    assign GT_RXLPMEN[i] = 'd0;



if (DIS_GT_WIZARD == "TRUE") begin : gt_channel_int

        //----------------------------------------------------------------------
        //  Use Default GT Wrapper   -   GT Channel  
        //----------------------------------------------------------------------
xdma_0_pcie3_ip_gt_channel #
        (
            .PHY_SIM_EN                     (PHY_SIM_EN),   
            .PHY_LANE                       (PHY_LANE),    
            .PHY_MAX_SPEED                  (PHY_MAX_SPEED),
            .PHY_ASYNC_EN                   (PHY_ASYNC_EN),
            .PHY_REFCLK_FREQ                (PHY_REFCLK_FREQ),       
            .PHY_USERCLK_FREQ               (PHY_USERCLK_FREQ),          
            .PHY_CORECLK_FREQ               (PHY_CORECLK_FREQ),
            .GT_LANE_NUM                    (i)                      
        )
        gt_channel_i
        (  
        
            //------------------------------------------------------------------
            //  Clock Ports
            //------------------------------------------------------------------
            .GT_GTREFCLK0                   (PHY_GTREFCLK),
            .GT_TXUSRCLK                    (pclk),
            .GT_RXUSRCLK                    (pclk), 
            .GT_TXUSRCLK2                   (pclk),
            .GT_RXUSRCLK2                   (pclk), 
            
            //------------------------------------------------------------------
            //  BUFG_GT Controller Ports                                               
            //------------------------------------------------------------------ 
            .GT_BUFGTCE                     (gt_bufgtce[(3*i)+2:(3*i)]),     
            .GT_BUFGTCEMASK                 (gt_bufgtcemask[(3*i)+2:(3*i)]), 
            .GT_BUFGTRESET                  (gt_bufgtreset[(3*i)+2:(3*i)]),
            .GT_BUFGTRSTMASK                (gt_bufgtrstmask[(3*i)+2:(3*i)]),   
            .GT_BUFGTDIV                    (gt_bufgtdiv[(9*i)+8:(9*i)]),
            .GT_TXOUTCLK                    (gt_txoutclk[i]),    
            .GT_RXOUTCLK                    (gt_rxoutclk[i]), 
            .GT_RXRECCLKOUT                 (gt_rxrecclkout[i]),
            
            //------------------------------------------------------------------
            //  Reset Ports
            //------------------------------------------------------------------
            .GT_CPLLPD                      (rst_cpllpd), 
            .GTHE3_TXOUTCLKSEL_OUT          (3'd5),
            .GT_CPLLRESET                   (rst_cpllreset),
            .GT_TXPROGDIVRESET              (rst_progdivreset),
            .GT_RXPROGDIVRESET              (rst_progdivreset),

            .GT_GTTXRESET                   (rst_gtreset),
            .GT_GTRXRESET                   (rst_gtreset), 
            .GT_TXUSERRDY                   (rst_userrdy),
            .GT_RXUSERRDY                   (rst_userrdy),              
                             
            .GT_GTPOWERGOOD                 (gt_gtpowergood[i]), 
            .GT_TXPROGDIVRESETDONE          (gt_txprogdivresetdone[i]),
            .GT_RXPROGDIVRESETDONE          (gt_rxprogdivresetdone[i]),                  
            .GT_TXRESETDONE                 (gt_txresetdone[i]),
            .GT_RXRESETDONE                 (gt_rxresetdone[i]),
            
            //------------------------------------------------------------------
            //  QPLL Ports
            //------------------------------------------------------------------
            .GT_QPLLCLK                     (gtcom_qpll1outclk[i>>2]),
            .GT_QPLLREFCLK                  (gtcom_qpll1outrefclk[i>>2]), 
            .GT_QPLLLOCK                    (qpll1lock_all),                    // From all lanes
            
            .GT_QPLLRATE                    (gt_qpllrate[(3*i)+2:(3*i)]),
            
            //------------------------------------------------------------------
            //  Serial Line Ports
            //------------------------------------------------------------------
            .GT_RXP                         (PHY_RXP[i]),
            .GT_RXN                         (PHY_RXN[i]),
            
            .GT_TXP                         (PHY_TXP[i]),
            .GT_TXN                         (PHY_TXN[i]),
            
            //------------------------------------------------------------------
            //  TX Data Ports
            //------------------------------------------------------------------
            .GT_TXDATA                      (PHY_TXDATA[(32*i)+31:(32*i)]),
            .GT_TXDATAK                     (PHY_TXDATAK[(2*i)+1:(2*i)]),
            .GT_TXDATA_VALID                (PHY_TXDATA_VALID[i]),
            .GT_TXSTART_BLOCK               (PHY_TXSTART_BLOCK[i]),
            .GT_TXSYNC_HEADER               (PHY_TXSYNC_HEADER[(2*i)+1:(2*i)]),
            
            //------------------------------------------------------------------
            //  RX Data Ports
            //------------------------------------------------------------------
            .GT_RXDATA                      (PHY_RXDATA[(32*i)+31:(32*i)]),
            .GT_RXDATAK                     (PHY_RXDATAK[(2*i)+1:(2*i)]),
            .GT_RXDATA_VALID                (PHY_RXDATA_VALID[i]),
            .GT_RXSTART_BLOCK               (PHY_RXSTART_BLOCK[i]),
            .GT_RXSYNC_HEADER               (PHY_RXSYNC_HEADER[(2*i)+1:(2*i)]),
            
            //------------------------------------------------------------------
            //  PHY Command Ports
            //------------------------------------------------------------------
            .GT_TXDETECTRX                  (PHY_TXDETECTRX),
            .GT_TXELECIDLE                  (PHY_TXELECIDLE[i]), 
            .GT_TXCOMPLIANCE                (PHY_TXCOMPLIANCE[i]),
            .GT_RXPOLARITY                  (PHY_RXPOLARITY[i]),
            .GT_POWERDOWN                   (PHY_POWERDOWN),
            .GT_RATE                        (PHY_RATE),       
                
            //------------------------------------------------------------------
            //  PHY Status Ports
            //------------------------------------------------------------------
            .GT_RXVALID                     (PHY_RXVALID[i]),
            .GT_PHYSTATUS                   (gt_phystatus[i]),
            .GT_RXELECIDLE                  (PHY_RXELECIDLE[i]),
            .GT_RXSTATUS                    (PHY_RXSTATUS[(3*i)+2:(3*i)]),
                
            //------------------------------------------------------------------
            //  TX Driver Ports
            //------------------------------------------------------------------
            .GT_TXMARGIN                    (PHY_TXMARGIN),
            .GT_TXSWING                     (PHY_TXSWING),
            .GT_TXDEEMPH                    (PHY_TXDEEMPH),  
            .GT_RXCDRHOLD                   (PHY_RXCDRHOLD),  
            
            //------------------------------------------------------------------
            //  TX Equalization Ports (Gen3) 
            //------------------------------------------------------------------
            .GT_TXPRECURSOR                 (txeq_precursor[(5*i)+4:(5*i)]),
            .GT_TXMAINCURSOR                (txeq_maincursor[(7*i)+6:(7*i)]),
            .GT_TXPOSTCURSOR                (txeq_postcursor[(5*i)+4:(5*i)]),
            
            //------------------------------------------------------------------
            //  PCIe PCS (Advance Feature)
            //------------------------------------------------------------------
            .GT_PCIERSTIDLE                 (rst_idle),        
            .GT_PCIERSTTXSYNCSTART          (rst_txsync_start), 
            .GT_PCIEEQRXEQADAPTDONE         (1'd0),                             // Not used
            .GT_PCIEUSERRATEDONE            (GT_PCIEUSERRATEDONE[i]),
        
            .GT_PCIEUSERPHYSTATUSRST        (gt_pcieuserphystatusrst[i]),    
            .GT_PCIERATEQPLLPD              (gt_pcierateqpllpd[(2*i)+1:(2*i)]),     
            .GT_PCIERATEQPLLRESET           (gt_pcierateqpllreset[(2*i)+1:(2*i)]), 
            .GT_PCIERATEIDLE                (gt_pcierateidle[i]),            
            .GT_PCIESYNCTXSYNCDONE          (gt_pciesynctxsyncdone[i]),  
            .GT_PCIERATEGEN3                (gt_pcierategen3[i]),    
            .GT_PCIEUSERGEN3RDY             (gt_pcieusergen3rdy[i]),  
            .GT_PCIEUSERRATESTART           (gt_pcieuserratestart[i]), 
            
            //------------------------------------------------------------------
            //  TX Sync Alignment Ports
            //------------------------------------------------------------------
            .GT_TXSYNCALLIN                 (txsyncallin_all),                  // From all lanes
            .GT_TXSYNCIN                    (gt_txsyncout[0]),                  // From Master Lane 0        
        
            .GT_TXPHALIGNDONE               (gt_txphaligndone[i]),            
            .GT_TXSYNCOUT                   (gt_txsyncout[i]),
            
            //--------------------------------------------------------------
            //  DRP Ports to/from CPLL_CAL module
            //--------------------------------------------------------------
            .GT_DRPCLK                      (PHY_REFCLK),
            .GT_DRPADDR                     (9'b000000000),
            .GT_DRPDI                       (16'h0000),
            .GT_DRPEN                       (1'b0),
            .GT_DRPWE                       (1'b0),
            .GT_DRPRDY                      ( ),
            .GT_DRPDO                       ( ),
             //-----------------------------------------------------------------
             //  Loopback and PRBS Ports
             //-----------------------------------------------------------------  
            .GT_LOOPBACK                    (GT_LOOPBACK[(3*i)+2:(3*i)]),
            .GT_PRBSSEL                     (GT_TXPRBSSEL[(4*i)+3:(4*i)]),
            .GT_TXPRBSFORCEERR              (GT_TXPRBSFORCEERR[i]),
            .GT_TXINHIBIT                   (GT_TXINHIBIT[i]),
            .GT_RXPRBSCNTRESET              (GT_RXPRBSCNTRESET[i]),                                           

            .GT_RXPMARESETDONE              (GT_RXPMARESETDONE[i]),
            .GT_RXPRBSERR                   (GT_RXPRBSERR[i]),                                              
            .GT_RXPRBSLOCKED                (),  

            .GT_RXPHALIGNDONE               (GT_RXPHALIGNDONE[i] ), 
            .GT_RXDLYSRESETDONE             (GT_RXDLYSRESETDONE[i] ),    
            .GT_TXDLYSRESETDONE             (GT_TXDLYSRESETDONE[i] ),    
            .GT_RXSYNCDONE                  (GT_RXSYNCDONE[i] ),
            .GT_EYESCANDATAERROR            (GT_EYESCANDATAERROR[i] ),
            .GT_DMONITOROUT                 (GT_DMONITOROUT[(17*i)+16:(17*i)] ),
            .GT_DMONFIFORESET               (GT_DMONFIFORESET[i]),
            .GT_DMONITORCLK                 (GT_DMONITORCLK[i]),
            .GT_TXPHINITDONE                (GT_TXPHINITDONE[i]),
            .GT_RXCOMMADET                  (GT_RXCOMMADET[i]),
            .GT_RXBUFSTATUS                 (GT_RXBUFSTATUS[(3*i)+2:(3*i)]),
            //------------------------------------------------------------------
            //  GT Status Ports
            //------------------------------------------------------------------                                              
            .GT_MASTER_CPLLLOCK             (gt_cplllock[0]),                   // From Master Lane 0 
            
            .GT_CPLLLOCK                    (gt_cplllock[i]),  
            .GT_RXCDRLOCK                   (gt_rxcdrlock[i])
        );
        
end // gt_channel_int

        
        //------------------------------------------------------------------------------------------
        //  PHY Quad - Generate one Quad for every four Lanes
        //------------------------------------------------------------------------------------------
        if ((i%4)==0) 
                       
            begin : phy_quad   
                 
            //------------------------------------------------------------------
            //  Generate QPLL Powerdown and Reset
            //------------------------------------------------------------------
            //  * QPLL reset and powerdown for Quad 1 driven by       Master Lane 0
            //  * QPLL reset and powerdown for Quad 2 driven by Local Master Lane 4
            //------------------------------------------------------------------        
            assign qpll1pd[i>>2]    = (i > 3) ? (rst_qpll1pd    || gt_pcierateqpllpd[i*2]) : 
                                                (rst_qpll1pd    || gt_pcierateqpllpd[0]);
                                             
            assign qpll1reset[i>>2] = (i > 3) ? (rst_qpll1reset || gt_pcierateqpllreset[i*2]) : 
                                                (rst_qpll1reset || gt_pcierateqpllreset[0]);                                 


if ((SHARED_LOGIC == 1) && (DIS_GT_WIZARD == "TRUE")) begin : gt_common_int
            //------------------------------------------------------------------
            //  GT Common Module                                                   
            //------------------------------------------------------------------
xdma_0_pcie3_ip_gt_common #
            (
                //--------------------------------------------------------------
                //  User Attributes
                //--------------------------------------------------------------
                .PHY_SIM_EN                 (PHY_SIM_EN),   
                .PHY_REFCLK_FREQ            (PHY_REFCLK_FREQ),       
                .GT_QUAD_NUM                (i>>2)                 
            )
            gt_common_i
            (    
                //--------------------------------------------------------------
                //  Clock Ports
                //--------------------------------------------------------------
                .GTCOM_REFCLK               (PHY_GTREFCLK),
                
                .GTCOM_QPLL1LOCK            (gtcom_qpll1lock[i>>2]),
                .GTCOM_QPLL1OUTCLK          (gtcom_qpll1outclk[i>>2]),
                .GTCOM_QPLL1OUTREFCLK       (gtcom_qpll1outrefclk[i>>2]),
                
                //--------------------------------------------------------------
                //  Reset Ports
                //--------------------------------------------------------------
                .GTCOM_QPLL1PD              (qpll1pd[i>>2]),         
                .GTCOM_QPLL1RESET           (qpll1reset[i>>2]),
                
                //--------------------------------------------------------------
                //  QPLL Ports
                //--------------------------------------------------------------    
              //.GTCOM_QPLLRATE             (gt_qpllrate[2:0]),                 // From Master Lane 0
                .GTCOM_QPLLRATE             ({1'd0, PHY_RATE}),                 // From RATE port
                
                //--------------------------------------------------------------
                //  DRP Ports
                //--------------------------------------------------------------
                .GTCOM_DRPCLK               (1'b0 ),          
                .GTCOM_DRPADDR              (9'b000000000 ),                       
                .GTCOM_DRPEN                (1'b0),       
                .GTCOM_DRPWE                (1'b0 ),
                .GTCOM_DRPDI                (16'h0000),                     
                                            
                .GTCOM_DRPRDY               ( ),
                .GTCOM_DRPDO                ( )
            );
              assign EXT_QPLL1REFCLK[i>>2]                     = 1'b0;
              assign EXT_QPLL1PD[i>>2]                         = 1'b0;
              assign EXT_QPLL1RATE[(3*(i>>2))+2:(3*(i>>2))]    = 3'b000;
              assign EXT_QPLL1RESET[i>>2]                      = 1'b0;              
              assign INT_QPLL1LOCK_OUT[i>>2]                = gtcom_qpll1lock[i>>2] ;
              assign INT_QPLL1OUTREFCLK_OUT[i>>2]           = gtcom_qpll1outrefclk[i>>2];
              assign INT_QPLL1OUTCLK_OUT[i>>2]              = gtcom_qpll1outclk[i>>2];
end // gt_common_int

if ((SHARED_LOGIC == 0) && (DIS_GT_WIZARD == "TRUE")) begin : sls_s0d1
              assign EXT_QPLL1REFCLK[i>>2]                  = PHY_GTREFCLK;
              assign EXT_QPLL1RATE[(3*(i>>2))+2:(3*(i>>2))] = {1'd0, PHY_RATE};
              assign EXT_QPLL1PD[i>>2]                      = qpll1pd[i>>2];
              assign EXT_QPLL1RESET[i>>2]                   = qpll1reset[i>>2];              
              assign gtcom_qpll1lock[i>>2]                  = EXT_QPLL1LOCK_OUT[i>>2];
              assign gtcom_qpll1outclk[i>>2]                = EXT_QPLL1OUTCLK_OUT[i>>2];
              assign gtcom_qpll1outrefclk[i>>2]             = EXT_QPLL1OUTREFCLK_OUT[i>>2];
              assign INT_QPLL1LOCK_OUT[i>>2]                = 1'b0;  
              assign INT_QPLL1OUTREFCLK_OUT[i>>2]           = 1'b0; 
              assign INT_QPLL1OUTCLK_OUT[i>>2]              = 1'b0; 
end // sls_s0d1

if ((SHARED_LOGIC == 1) && (DIS_GT_WIZARD == "FALSE")) begin : sls_s1d0
              assign EXT_QPLL1REFCLK[i>>2]                     = 1'b0;
              assign EXT_QPLL1PD[i>>2]                         = 1'b0;
              assign EXT_QPLL1RATE[(3*(i>>2))+2:(3*(i>>2))]    = 3'b000;
              assign EXT_QPLL1RESET[i>>2]                      = 1'b0;              
              assign INT_QPLL1LOCK_OUT      = gtcom_qpll1lock;
              assign INT_QPLL1OUTREFCLK_OUT = gtcom_qpll1outrefclk;
              assign INT_QPLL1OUTCLK_OUT    = gtcom_qpll1outclk;
end // sls_s1d0

if ((SHARED_LOGIC == 0) && (DIS_GT_WIZARD == "FALSE")) begin : sls_s0d00
              assign gtcom_qpll1lock[i>>2]                  = EXT_QPLL1LOCK_OUT[i>>2];
              assign gtcom_qpll1outclk[i>>2]                = EXT_QPLL1OUTCLK_OUT[i>>2];
              assign gtcom_qpll1outrefclk[i>>2]             = EXT_QPLL1OUTREFCLK_OUT[i>>2];            
end // sls_s0d00

end // phy_quad 


end // phy_lane
endgenerate 

  generate
if ((SHARED_LOGIC == 0) && (DIS_GT_WIZARD == "FALSE")) begin : sls_s0d01
              assign EXT_QPLL1REFCLK        = ({(((PHY_LANE)>>2)+1){PHY_GTREFCLK}});
              assign EXT_QPLL1RATE          = ({(((PHY_LANE)>>2)+1){1'd0, PHY_RATE}});
              assign EXT_QPLL1PD            = ({(((PHY_LANE)>>2)+1){qpll1pd}});
              assign EXT_QPLL1RESET         = ({(((PHY_LANE)>>2)+1){qpll1reset}});              
              assign INT_QPLL1LOCK_OUT      = 0;    
              assign INT_QPLL1OUTREFCLK_OUT = 0;  
              assign INT_QPLL1OUTCLK_OUT    = 0; 
end // sls_s0d01
  endgenerate
//--------------------------------------------------------------------------------------------------
//  Use GT Wizard 
//--------------------------------------------------------------------------------------------------
  generate
if (DIS_GT_WIZARD == "FALSE") begin : gt_wizard
assign gt_rxoutclk    = 0;
assign gt_rxrecclkout = 0;
        //----------------------------------------------------------------------
        //  GT Channel
        //----------------------------------------------------------------------
xdma_0_pcie3_ip_gtwizard_top #
        (
            .PHY_MAX_SPEED                  (PHY_MAX_SPEED),
            .PHY_LANE                       (PHY_LANE)                    
        )
        gtwizard_top_i
        (  
        
            //------------------------------------------------------------------
            //  Clock Ports *
            //------------------------------------------------------------------
            .GT_GTREFCLK0                   (PHY_GTREFCLK),                     
            .GT_TXUSRCLK                    ({PHY_LANE{pclk}}),
            .GT_RXUSRCLK                    ({PHY_LANE{pclk}}), 

            //------------------------------------------------------------------

            .GT_TXUSRCLK2                   ({PHY_LANE{pclk}}),
            .GT_RXUSRCLK2                   ({PHY_LANE{pclk}}), 
            
            //------------------------------------------------------------------
            //  BUFG_GT Controller Ports *                                               
            //------------------------------------------------------------------ 
            .GT_BUFGTCE                     (gt_bufgtce),     
            .GT_BUFGTCEMASK                 (gt_bufgtcemask), 
            .GT_BUFGTRESET                  (gt_bufgtreset),
            .GT_BUFGTRSTMASK                (gt_bufgtrstmask),   
            .GT_BUFGTDIV                    (gt_bufgtdiv),
            .GT_TXOUTCLK                    (gt_txoutclk),   
          //.GT_RXOUTCLK                    (gt_rxoutclk),
          //.GT_RXRECCLKOUT                 (gt_rxrecclkout), 
            
            //------------------------------------------------------------------  
            //  Reset Ports *                                                      
            //------------------------------------------------------------------  
            .GT_CPLLPD                      ({PHY_LANE{rst_cpllpd}}),              
            .GT_CPLLRESET                   ({PHY_LANE{rst_cpllreset}}),           
            .GT_TXPROGDIVRESET              ({PHY_LANE{rst_progdivreset}}),        
            .GT_RXPROGDIVRESET              ({PHY_LANE{rst_progdivreset}}),        
            .GT_GTTXRESET                   ({PHY_LANE{rst_gtreset}}),             
            .GT_GTRXRESET                   ({PHY_LANE{rst_gtreset}}),             
            .GT_TXUSERRDY                   ({PHY_LANE{rst_userrdy}}),             
            .GT_RXUSERRDY                   ({PHY_LANE{rst_userrdy}}),             
                                                                                  
            .GT_GTPOWERGOOD                 (gt_gtpowergood),                     
            .GT_TXPROGDIVRESETDONE          (gt_txprogdivresetdone),              
            .GT_RXPROGDIVRESETDONE          (gt_rxprogdivresetdone),              
            .GT_TXRESETDONE                 (gt_txresetdone),                     
            .GT_RXRESETDONE                 (gt_rxresetdone),                     
            
            //--------------------------------------------------------------
            //  Common QPLL Ports *
            //--------------------------------------------------------------
            .GTCOM_QPLL1PD                  (qpll1pd),         
            .GTCOM_QPLL1RESET               (qpll1reset),
            
            .GTCOM_QPLL1LOCK                (gtcom_qpll1lock),
            .GTCOM_QPLL1OUTCLK              (gtcom_qpll1outclk),
            .GTCOM_QPLL1OUTREFCLK           (gtcom_qpll1outrefclk),
            
            //--------------------------------------------------------------
            //  Common DRP Ports *
            //--------------------------------------------------------------
            .GTCOM_DRPCLK                   ( {(((PHY_LANE)>>3)+1){1'b0}} ),                                     
            .GTCOM_DRPADDR                  ( {(((PHY_LANE)>>3)+1){9'b000000000}} ),  
            .GTCOM_DRPEN                    ( {(((PHY_LANE)>>3)+1){1'b0}} ),     
            .GTCOM_DRPWE                    ( {(((PHY_LANE)>>3)+1){1'b0}} ),
            .GTCOM_DRPDI                    ( {(((PHY_LANE)>>3)+1){16'h0000}} ),
                                                                         
            .GTCOM_DRPRDY                   ( ),
            .GTCOM_DRPDO                    ( ),
            
            .GT_DRPCLK                      ({PHY_LANE{PHY_REFCLK}}),

            .GT_DRPADDR                     (GTW_DRPADDR ),
            .GT_DRPEN                       (GTW_DRPEN ),
            .GT_DRPWE                       (GTW_DRPWE ),
            .GT_DRPDI                       (GTW_DRPDI ),
            .GT_DRPRDY                      (GTW_DRPRDY ),
            .GT_DRPDO                       (GTW_DRPDO ),



            .GT_RATE                        ({PHY_LANE{PHY_RATE}}),
            .GT_EYESCANRESET                ( ibert_eyescanreset_in ),
            //--------------------------------------------------------------
            //  IBERT ports 
            //--------------------------------------------------------------
            .GT_TXPRECURSOR                 ( ibert_txprecursor_in ),  //(txeq_precursor),
            .GT_TXPOSTCURSOR                ( ibert_txpostcursor_in ), //(txeq_postcursor),
            .GT_TXDIFFCTRL                  ( ibert_txdiffctrl_in ),
            .GT_RXLPMEN                     ( ibert_rxlpmen_in ),
            .GT_PCIERATEGEN3                (gt_pcierategen3),    

            //------------------------------------------------------------------
            //  Serial Line Ports *
            //------------------------------------------------------------------
            .GT_RXP                         (PHY_RXP),
            .GT_RXN                         (PHY_RXN),
            
            .GT_TXP                         (PHY_TXP),
            .GT_TXN                         (PHY_TXN),
            
            //------------------------------------------------------------------
            //  TX Data Ports *
            //------------------------------------------------------------------
            .GT_TXDATA                      (PHY_TXDATA),
            .GT_TXDATAK                     (PHY_TXDATAK),
            .GT_TXDATA_VALID                (PHY_TXDATA_VALID),
            .GT_TXSTART_BLOCK               (PHY_TXSTART_BLOCK),
            .GT_TXSYNC_HEADER               (PHY_TXSYNC_HEADER),
            
            //------------------------------------------------------------------
            //  RX Data Ports *
            //------------------------------------------------------------------
            .GT_RXDATA                      (PHY_RXDATA),
            .GT_RXDATAK                     (PHY_RXDATAK),
            .GT_RXDATA_VALID                (PHY_RXDATA_VALID),
            .GT_RXSTART_BLOCK               (PHY_RXSTART_BLOCK),
            .GT_RXSYNC_HEADER               (PHY_RXSYNC_HEADER),
            
            //------------------------------------------------------------------
            //  PHY Command Ports *
            //------------------------------------------------------------------
            .GT_TXDETECTRX                  ({PHY_LANE{PHY_TXDETECTRX}}),
            .GT_TXELECIDLE                  (PHY_TXELECIDLE), 
            .GT_TXCOMPLIANCE                (PHY_TXCOMPLIANCE),
            .GT_RXPOLARITY                  (PHY_RXPOLARITY),
            .GT_POWERDOWN                   ({PHY_LANE{PHY_POWERDOWN}}),
                
            //------------------------------------------------------------------
            //  PHY Status Ports *
            //------------------------------------------------------------------
            .GT_RXVALID                     (PHY_RXVALID),
            .GT_PHYSTATUS                   (gt_phystatus),
            .GT_RXELECIDLE                  (PHY_RXELECIDLE),
            .GT_RXSTATUS                    (PHY_RXSTATUS),
                
            //------------------------------------------------------------------
            //  TX Driver Ports *
            //------------------------------------------------------------------
            .GT_TXMARGIN                    ({PHY_LANE{PHY_TXMARGIN}}),
            .GT_TXOUTCLKSEL                 ({PHY_LANE{PHY_TXOUTCLKSEL}}),
            .GT_TXSWING                     ({PHY_LANE{PHY_TXSWING}}),
            .GT_TXDEEMPH                    ({PHY_LANE{PHY_TXDEEMPH}}),  
            .GT_RXCDRHOLD                   ({PHY_LANE{PHY_RXCDRHOLD}}),  
            
            //------------------------------------------------------------------
            //  TX Equalization Ports (Gen3) *
            //------------------------------------------------------------------
            .GT_TXMAINCURSOR                (txeq_maincursor),
            
            //------------------------------------------------------------------
            //  PCIe PCS (Advance Feature) *
            //------------------------------------------------------------------
            .GT_PCIERSTIDLE                 ({PHY_LANE{rst_idle}}),        
            .GT_PCIERSTTXSYNCSTART          ({PHY_LANE{rst_txsync_start}}), 
            .GT_PCIEEQRXEQADAPTDONE         ({PHY_LANE{1'd0}}),                 // Not used
            .GT_PCIEUSERRATEDONE            (GT_PCIEUSERRATEDONE),
        
            .GT_PCIEUSERPHYSTATUSRST        (gt_pcieuserphystatusrst),    
            .GT_PCIERATEQPLLPD              (gt_pcierateqpllpd),     
            .GT_PCIERATEQPLLRESET           (gt_pcierateqpllreset), 
            .GT_PCIERATEIDLE                (gt_pcierateidle),            
            .GT_PCIESYNCTXSYNCDONE          (gt_pciesynctxsyncdone),  
            .GT_PCIEUSERGEN3RDY             (gt_pcieusergen3rdy),  
            .GT_PCIEUSERRATESTART           (gt_pcieuserratestart), 
            
            .GT_TXPHALIGNDONE               (gt_txphaligndone),            
             //-----------------------------------------------------------------
             //  Loopback and PRBS Ports *
             //-----------------------------------------------------------------  
            .GT_LOOPBACK                    (GT_LOOPBACK),                                        
            .GT_PRBSSEL                     (GT_TXPRBSSEL),
            .GT_TXPRBSFORCEERR              (GT_TXPRBSFORCEERR), 
            .GT_TXINHIBIT                   (GT_TXINHIBIT),
            .GT_RXPRBSCNTRESET              (GT_RXPRBSCNTRESET),                                                                                                      
            
            .GT_RXPMARESETDONE              (GT_RXPMARESETDONE),
            .GT_RXPRBSERR                   (GT_RXPRBSERR ),                                              
            .GT_RXPRBSLOCKED                ( ),  
        
            .GT_RXPHALIGNDONE               (GT_RXPHALIGNDONE ), 
            .GT_RXDLYSRESETDONE             (GT_RXDLYSRESETDONE ),    
            .GT_TXDLYSRESETDONE             (GT_TXDLYSRESETDONE ),    
            .GT_RXSYNCDONE                  (GT_RXSYNCDONE ),
            .GT_EYESCANDATAERROR            (GT_EYESCANDATAERROR ),
            .GT_DMONITOROUT                 (gt_dmonitorout_i ),
            .GT_DMONFIFORESET               (GT_DMONFIFORESET),
            .GT_DMONITORCLK                 (GT_DMONITORCLK),
            .GT_TXPHINITDONE                (GT_TXPHINITDONE),
            .GT_RXCOMMADET                  (GT_RXCOMMADET),
            .GT_RXBUFSTATUS                 (GT_RXBUFSTATUS),
            //------------------------------------------------------------------
            //  GT Status Ports *
            //------------------------------------------------------------------                                                   
            .GT_CPLLLOCK                    (gt_cplllock),  
            .GT_RXCDRLOCK                   (gt_rxcdrlock),
            .GT_RXRATEDONE                  (gt_rxratedone),
            .GT_RXRATEMODE                  ({PHY_LANE{1'd0}})
 
        );
end // gt_wizard
  endgenerate
//--------------------------------------------------------------------------------------------------
//  Convert per-lane signals to per-design 
//--------------------------------------------------------------------------------------------------
  generate
if (DIS_GT_WIZARD == "TRUE") begin : sls_d1
assign qpll1lock_all   = &gtcom_qpll1lock;
assign txsyncallin_all = &gt_txphaligndone;                            
end // sls_d1
  endgenerate


//--------------------------------------------------------------------------------------------------
//  PHY Wrapper Outputs
//--------------------------------------------------------------------------------------------------
assign PHY_PCLK          = pclk;
assign PHY_PHYSTATUS     = gt_phystatus;
assign PHY_PHYSTATUS_RST = !rst_idle;

//--------------------------------------------------------------------------------------------------
//  TX Equalization (Gen3) Outputs 
//--------------------------------------------------------------------------------------------------
assign PHY_TXEQ_FS        = 6'd40;                                             
assign PHY_TXEQ_LF        = 6'd12;                                             
assign PHY_TXEQ_NEW_COEFF = txeq_new_coeff;        
assign PHY_TXEQ_DONE      = txeq_done;                                                   
      
//--------------------------------------------------------------------------------------------------
//  RX Equalization (Gen3) Outputs
//--------------------------------------------------------------------------------------------------      
assign PHY_RXEQ_LFFS_SEL    = rxeq_lffs_sel;                                                  
assign PHY_RXEQ_NEW_TXCOEFF = rxeq_new_txcoeff;     
assign PHY_RXEQ_ADAPT_DONE  = rxeq_adapt_done;   
assign PHY_RXEQ_DONE        = rxeq_done;   

//--------------------------------------------------------------------------------------------------
//  Debug Outputs
//--------------------------------------------------------------------------------------------------  
assign GT_TXELECIDLE = PHY_TXELECIDLE; 
assign GT_TXRESETDONE = gt_txresetdone;                    
assign GT_RXRESETDONE = gt_rxresetdone;              
assign GT_TXPHALIGNDONE = gt_txphaligndone;          
assign GT_PHYSTATUS = gt_phystatus;
assign GT_RXVALID  = PHY_RXVALID;
assign GT_RXSTATUS = PHY_RXSTATUS;
assign GT_BUFGTDIV = gt_bufgtdiv;

assign GT_RXCDRLOCK   = gt_rxcdrlock; 
assign GT_PCIERATEIDLE  = gt_pcierateidle;
assign GT_PCIEUSERRATESTART  = gt_pcieuserratestart;
assign GT_GTPOWERGOOD = gt_gtpowergood;                
assign GT_CPLLLOCK   = gt_cplllock;   
assign GT_QPLL1LOCK  = gtcom_qpll1lock;
assign GT_RXOUTCLK    = gt_rxoutclk;
assign GT_RXRECCLKOUT = gt_rxrecclkout;

assign TXEQ_CTRL = PHY_TXEQ_CTRL;
assign TXEQ_PRESET = PHY_TXEQ_PRESET;
assign PHY_RST_IDLE    = rst_idle;
assign PHY_RRST_N      = rrst_n;   
assign PHY_PRST_N      = prst_n;                 
assign GTW_DRPCLK = PHY_REFCLK; //mcap_clk;

assign GT_DMONITOROUT = gt_dmonitorout_i;
//--------------------------------------------------------------------------------------------------  

endmodule
