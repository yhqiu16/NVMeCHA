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
// File       : xdma_0_pcie3_ip_gtwizard_top.v
// Version    : 4.4 
//-----------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
//  Design :  PCIe PHY Wrapper 
//  Module :  GT Wizard Top 
//--------------------------------------------------------------------------------------------------



`timescale 1ps / 1ps



//--------------------------------------------------------------------------------------------------
//  GT Wizard Top Module
//--------------------------------------------------------------------------------------------------
module xdma_0_pcie3_ip_gtwizard_top #
(
    parameter integer PHY_MAX_SPEED    = 3,
    parameter integer PHY_LANE = 1
)
(    


    //--------------------------------------------------------------------------
    //  Clock Ports
    //--------------------------------------------------------------------------
    input                               GT_GTREFCLK0,
    input       [PHY_LANE-1:0]          GT_TXUSRCLK,
    input       [PHY_LANE-1:0]          GT_RXUSRCLK,  
    input       [PHY_LANE-1:0]          GT_TXUSRCLK2, 
    input       [PHY_LANE-1:0]          GT_RXUSRCLK2,    
    //--------------------------------------------------------------------------   
    //  IBERT ports 
    //--------------------------------------------------------------------------                   
    input       [PHY_LANE-1:0]          GT_EYESCANRESET,
    input       [(PHY_LANE* 2)-1:0]     GT_RATE,  
    input       [(PHY_LANE* 4)-1:0]     GT_TXDIFFCTRL,
    input       [(PHY_LANE* 5)-1:0]     GT_TXPRECURSOR,  
    input       [(PHY_LANE* 5)-1:0]     GT_TXPOSTCURSOR,      
    input       [PHY_LANE-1:0]          GT_RXLPMEN,

    output      [PHY_LANE-1:0]          GT_PCIERATEGEN3,   
    //--------------------------------------------------------------------------                   
    //--------------------------------------------------------------------------   
    //  BUFG_GT Controller Ports                                                                        
    //--------------------------------------------------------------------------                   
    output      [(PHY_LANE* 3)-1:0]     GT_BUFGTCE,       
    output      [(PHY_LANE* 3)-1:0]     GT_BUFGTCEMASK, 
    output      [(PHY_LANE* 3)-1:0]     GT_BUFGTRESET,
    output      [(PHY_LANE* 3)-1:0]     GT_BUFGTRSTMASK,
    output      [(PHY_LANE* 9)-1:0]     GT_BUFGTDIV,   
    output      [PHY_LANE-1:0]          GT_TXOUTCLK,  
                
    //--------------------------------------------------------------------------
    //  Reset Ports
    //--------------------------------------------------------------------------
    input       [PHY_LANE-1:0]          GT_CPLLPD,    
    input       [PHY_LANE-1:0]          GT_CPLLRESET,
    input       [PHY_LANE-1:0]          GT_TXPROGDIVRESET,  
    input       [PHY_LANE-1:0]          GT_RXPROGDIVRESET,   
    input       [PHY_LANE-1:0]          GT_GTTXRESET,  
    input       [PHY_LANE-1:0]          GT_GTRXRESET,  
    input       [PHY_LANE-1:0]          GT_TXUSERRDY, 
    input       [PHY_LANE-1:0]          GT_RXUSERRDY, 
                                        
    output      [PHY_LANE-1:0]          GT_GTPOWERGOOD, 
    output      [PHY_LANE-1:0]          GT_TXPROGDIVRESETDONE,  
    output      [PHY_LANE-1:0]          GT_RXPROGDIVRESETDONE,    
    output      [PHY_LANE-1:0]          GT_TXRESETDONE,   
    output      [PHY_LANE-1:0]          GT_RXRESETDONE,                  
    
    output      [PHY_LANE-1:0]          GT_TXPHALIGNDONE,            
    output      [PHY_LANE-1:0]          GT_RXPMARESETDONE,            
    output      [PHY_LANE-1:0]          GT_TXPHINITDONE,
    output      [PHY_LANE-1:0]          GT_RXCOMMADET,


    //--------------------------------------------------------------------------
    //  Common QPLL Ports
    //--------------------------------------------------------------------------
    input       [(PHY_LANE-1)>>2:0]     GTCOM_QPLL1PD,     
    input       [(PHY_LANE-1)>>2:0]     GTCOM_QPLL1RESET,
    
    output      [(PHY_LANE-1)>>2:0]     GTCOM_QPLL1LOCK, 
    output      [(PHY_LANE-1)>>2:0]     GTCOM_QPLL1OUTCLK,
    output      [(PHY_LANE-1)>>2:0]     GTCOM_QPLL1OUTREFCLK, 
    
    //----------------------------------------------------------------------------------------------
    //  Common DRP Ports
    //----------------------------------------------------------------------------------------------
    input       [   (PHY_LANE-1)>>2          :0]    GTCOM_DRPCLK,
    input       [((((PHY_LANE-1)>>2)+1)* 9)-1:0]    GTCOM_DRPADDR,                                       
    input       [   (PHY_LANE-1)>>2          :0]    GTCOM_DRPEN,                                             
    input       [   (PHY_LANE-1)>>2          :0]    GTCOM_DRPWE,     
    input       [((((PHY_LANE-1)>>2)+1)*16)-1:0]    GTCOM_DRPDI,                                      
                                                                         
    output      [   (PHY_LANE-1)>>2          :0]    GTCOM_DRPRDY,    
    output      [((((PHY_LANE-1)>>2)+1)*16)-1:0]    GTCOM_DRPDO,         
    
   input       [((PHY_LANE *  1)-1):0]    GT_DRPCLK,   
   input       [((PHY_LANE *  9)-1):0]    GT_DRPADDR, 
   input       [((PHY_LANE *  1)-1):0]    GT_DRPEN,    
   input       [((PHY_LANE *  1)-1):0]    GT_DRPWE,    
   input       [((PHY_LANE * 16)-1):0]    GT_DRPDI,   
                                           
   output      [((PHY_LANE *  1)-1):0]    GT_DRPRDY,   
   output      [((PHY_LANE * 16)-1):0]    GT_DRPDO,     

    //--------------------------------------------------------------------------
    //  Serial Line Ports
    //--------------------------------------------------------------------------
    input       [PHY_LANE-1:0]          GT_RXN,  
    input       [PHY_LANE-1:0]          GT_RXP,  
    
    output      [PHY_LANE-1:0]          GT_TXP,  
    output      [PHY_LANE-1:0]          GT_TXN,  
    
    //--------------------------------------------------------------------------
    //  TX Data Ports 
    //--------------------------------------------------------------------------
    input       [(PHY_LANE*32)-1:0]     GT_TXDATA,    
    input       [(PHY_LANE* 2)-1:0]     GT_TXDATAK,  
    input       [PHY_LANE-1:0]          GT_TXDATA_VALID,  
    input       [PHY_LANE-1:0]          GT_TXSTART_BLOCK,      
    input       [(PHY_LANE* 2)-1:0]     GT_TXSYNC_HEADER,  
    
    //--------------------------------------------------------------------------
    //  RX Data Ports 
    //--------------------------------------------------------------------------
    output      [(PHY_LANE*32)-1:0]     GT_RXDATA,      
    output      [(PHY_LANE* 2)-1:0]     GT_RXDATAK,        
    output      [PHY_LANE-1:0]          GT_RXDATA_VALID,  
    output      [PHY_LANE-1:0]          GT_RXSTART_BLOCK,       
    output      [(PHY_LANE* 2)-1:0]     GT_RXSYNC_HEADER,     
    
    //--------------------------------------------------------------------------
    //  PHY Command Ports
    //--------------------------------------------------------------------------
    input       [PHY_LANE-1:0]          GT_TXDETECTRX,      
    input       [PHY_LANE-1:0]          GT_TXELECIDLE, 
    input       [PHY_LANE-1:0]          GT_TXCOMPLIANCE, 
    input       [PHY_LANE-1:0]          GT_RXPOLARITY,
    input       [(PHY_LANE* 2)-1:0]     GT_POWERDOWN,      
      
    //--------------------------------------------------------------------------
    //  PHY Status Ports
    //--------------------------------------------------------------------------
    output      [PHY_LANE-1:0]          GT_RXVALID, 
    output      [PHY_LANE-1:0]          GT_PHYSTATUS,
    output      [PHY_LANE-1:0]          GT_RXELECIDLE,
    output      [(PHY_LANE* 3)-1:0]     GT_RXSTATUS,
      
    //--------------------------------------------------------------------------
    //  TX Equalization Ports 
    //--------------------------------------------------------------------------
    input       [(PHY_LANE* 3)-1:0]     GT_TXMARGIN,  
    input       [(PHY_LANE* 3)-1:0]     GT_TXOUTCLKSEL, 
    input       [PHY_LANE-1:0]          GT_TXSWING,  
    input       [PHY_LANE-1:0]          GT_TXDEEMPH, 
    input       [PHY_LANE-1:0]          GT_RXCDRHOLD, 
    
    //--------------------------------------------------------------------------
    //  TX Equalization Ports (Gen3)
    //--------------------------------------------------------------------------
    input       [(PHY_LANE* 7)-1:0]     GT_TXMAINCURSOR,  
    
    //--------------------------------------------------------------------------
    //  PCIe PCS Ports
    //--------------------------------------------------------------------------
    input       [PHY_LANE-1:0]          GT_PCIERSTIDLE,        
    input       [PHY_LANE-1:0]          GT_PCIERSTTXSYNCSTART,  
    input       [PHY_LANE-1:0]          GT_PCIEEQRXEQADAPTDONE, 
    input       [PHY_LANE-1:0]          GT_PCIEUSERRATEDONE,    
             
    output      [PHY_LANE-1:0]          GT_PCIEUSERPHYSTATUSRST,  
    output      [(PHY_LANE* 2)-1:0]     GT_PCIERATEQPLLPD,              
    output      [(PHY_LANE* 2)-1:0]     GT_PCIERATEQPLLRESET,                
    output      [PHY_LANE-1:0]          GT_PCIERATEIDLE,          
    output      [PHY_LANE-1:0]          GT_PCIESYNCTXSYNCDONE,                      
    output      [PHY_LANE-1:0]          GT_PCIEUSERGEN3RDY, 
    output      [PHY_LANE-1:0]          GT_PCIEUSERRATESTART,  
   
    //--------------------------------------------------------------------------
    //  Loopback & PRBS Ports
    //--------------------------------------------------------------------------     
    input       [(PHY_LANE* 3)-1:0]     GT_LOOPBACK,                                                 
    input       [(PHY_LANE* 4)-1:0]     GT_PRBSSEL,  
    input       [PHY_LANE-1:0]          GT_TXPRBSFORCEERR,     
    input       [PHY_LANE-1:0]          GT_TXINHIBIT,     
    input       [PHY_LANE-1:0]          GT_RXPRBSCNTRESET,                                                                                                       

    output      [PHY_LANE-1:0]          GT_RXPRBSERR,                                              
    output      [PHY_LANE-1:0]          GT_RXPRBSLOCKED,  
      
    output      [PHY_LANE-1:0]          GT_RXPHALIGNDONE,  
    output      [PHY_LANE-1:0]          GT_RXDLYSRESETDONE,     
    output      [PHY_LANE-1:0]          GT_TXDLYSRESETDONE,     
    output      [PHY_LANE-1:0]          GT_RXSYNCDONE, 
    output      [PHY_LANE-1:0]          GT_EYESCANDATAERROR,
    output      [(PHY_LANE*17)-1:0]     GT_DMONITOROUT,
    input       [PHY_LANE-1:0]          GT_DMONITORCLK,
    input       [PHY_LANE-1:0]          GT_DMONFIFORESET,
    output      [(PHY_LANE*3)-1:0]      GT_RXBUFSTATUS,
    //--------------------------------------------------------------------------
    //  GT Status Ports
    //--------------------------------------------------------------------------                                                     
    output      [PHY_LANE-1:0]          GT_CPLLLOCK,       
    output      [PHY_LANE-1:0]          GT_RXCDRLOCK,                                                                 
    output      [PHY_LANE-1:0]          GT_RXRATEDONE,  
    input       [PHY_LANE-1:0]          GT_RXRATEMODE 
);

//
// Wire/Signals when GT Wizard is in the Core
//
    wire [(PHY_LANE* 3)-1:0]    bufgtce_out ;
    wire [(PHY_LANE* 3)-1:0]    bufgtcemask_out ;
    wire [(PHY_LANE* 9)-1:0]    bufgtdiv_out ;
    wire [(PHY_LANE* 3)-1:0]    bufgtreset_out ;
    wire [(PHY_LANE* 3)-1:0]    bufgtrstmask_out ;
    wire [PHY_LANE-1:0]         cplllock_out;  
    wire [PHY_LANE-1:0]         cpllpd_in;                                          
    wire [PHY_LANE-1:0]         cpllreset_in;                                          
    wire [PHY_LANE-1:0]         dmonfiforeset_in;
    wire [PHY_LANE-1:0]         dmonitorclk_in;
    wire [(PHY_LANE*17)-1:0]    dmonitorout_out;

    wire [(PHY_LANE* 1)-1:0]    drpclk_in;
    wire [(PHY_LANE* 9)-1:0]    drpaddr_in;
    wire [(PHY_LANE* 16)-1:0]   drpdi_in;
    wire [(PHY_LANE* 1)-1:0]    drpen_in;
    wire [(PHY_LANE* 1)-1:0]    drpwe_in;
    wire [(PHY_LANE* 16)-1:0]   drpdo_out;
    wire [(PHY_LANE* 1)-1:0]    drprdy_out;

    wire [PHY_LANE-1:0]         eyescandataerror_out;
    wire [PHY_LANE-1:0]         eyescanreset_in;

    wire [PHY_LANE-1:0]         gthrxn_in;                                          
    wire [PHY_LANE-1:0]         gthrxp_in;                                          
    wire [PHY_LANE-1:0]         gthtxn_out;
    wire [PHY_LANE-1:0]         gthtxp_out;

    wire [PHY_LANE-1:0]         gtpowergood_out;
    wire [PHY_LANE-1:0]         gtrefclk0_in;
    wire [PHY_LANE-1:0]         gtrxreset_in;                                          
    wire [PHY_LANE-1:0]         gttxreset_in;                                          
    wire                        gtwiz_reset_rx_done_in;                                                                                      
    wire                        gtwiz_reset_tx_done_in;                                                
    wire                        gtwiz_userclk_rx_active_in ;                                                
    wire                        gtwiz_userclk_tx_active_in ;                                                
    wire                        gtwiz_userclk_tx_reset_in;
    wire [(PHY_LANE* 3)-1:0]    loopback_in;                                               
    wire [PHY_LANE-1:0]         pcieeqrxeqadaptdone_in ;                                          
    wire [PHY_LANE-1:0]         pcierategen3_out;  
    wire [PHY_LANE-1:0]         pcierateidle_out;       
    wire [(PHY_LANE*2)-1:0]     pcierateqpllpd_out;              
    wire [(PHY_LANE*2)-1:0]     pcierateqpllreset_out;
    wire [PHY_LANE-1:0]         pcierstidle_in;                                          
    wire [PHY_LANE-1:0]         pciersttxsyncstart_in;                                          
    wire [PHY_LANE-1:0]         pciesynctxsyncdone_out;                      
    wire [PHY_LANE-1:0]         pcieusergen3rdy_out; 
    wire [PHY_LANE-1:0]         pcieuserphystatusrst_out;  
    wire [PHY_LANE-1:0]         pcieuserratedone_in;                                          
    wire [PHY_LANE-1:0]         pcieuserratestart_out;  
    wire [(PHY_LANE*16)-1:0]    pcsrsvdin_in;
    wire [(PHY_LANE*12)-1:0]    pcsrsvdout_out;
    wire [PHY_LANE-1:0]         phystatus_out;
    wire [PHY_LANE-1:0]         rx8b10ben_in;                                                          
    wire [PHY_LANE-1:0]         rxbufreset_in;                                                
    wire [(PHY_LANE*3)-1:0]     rxbufstatus_out;
    wire [PHY_LANE-1 : 0]       rxbyteisaligned_out; 
    wire [PHY_LANE-1 : 0]       rxbyterealign_out; 
    wire [PHY_LANE-1:0]         rxcdrhold_in;                                          
    wire [PHY_LANE-1:0]         rxcdrlock_out;                                                          
    wire [(PHY_LANE * 2)-1 : 0] rxclkcorcnt_out; 
    wire [PHY_LANE-1:0]         rxcommadet_out;
    wire [PHY_LANE-1:0]         rxcommadeten_in;
    wire [(PHY_LANE*16)-1:0]    rxctrl0_out;  
    wire [(PHY_LANE*16)-1:0]    rxctrl1_out;  
    wire [(PHY_LANE*8)-1:0]     rxctrl2_out;  
    wire [(PHY_LANE*8)-1:0]     rxctrl3_out;  
    wire [(PHY_LANE*128)-1:0]   rxdata_out;  

    wire [PHY_LANE-1 : 0] rxdfeagchold_in ;  
    wire [PHY_LANE-1 : 0] rxdfecfokhold_in; 
    wire [PHY_LANE-1 : 0] rxdfelfhold_in  ;   
    wire [PHY_LANE-1 : 0] rxdfekhhold_in  ;             
    wire [PHY_LANE-1 : 0] rxdfetap2hold_in;        
    wire [PHY_LANE-1 : 0] rxdfetap3hold_in;        
    wire [PHY_LANE-1 : 0] rxdfetap4hold_in;       
    wire [PHY_LANE-1 : 0] rxdfetap5hold_in;           
    wire [PHY_LANE-1 : 0] rxdfetap6hold_in;       
    wire [PHY_LANE-1 : 0] rxdfetap7hold_in;        
    wire [PHY_LANE-1 : 0] rxdfetap8hold_in;       
    wire [PHY_LANE-1 : 0] rxdfetap9hold_in;       
    wire [PHY_LANE-1 : 0] rxdfetap10hold_in;       
    wire [PHY_LANE-1 : 0] rxdfetap11hold_in;       
    wire [PHY_LANE-1 : 0] rxdfetap12hold_in;        
    wire [PHY_LANE-1 : 0] rxdfetap13hold_in;       
    wire [PHY_LANE-1 : 0] rxdfetap14hold_in;       
    wire [PHY_LANE-1 : 0] rxdfetap15hold_in;       
    wire [PHY_LANE-1 : 0] rxdfeuthold_in;             
    wire [PHY_LANE-1 : 0] rxdfevphold_in;             
    wire [PHY_LANE-1 : 0] rxoshold_in   ;                  
    wire [PHY_LANE-1 : 0] rxlpmgchold_in;              
    wire [PHY_LANE-1 : 0] rxlpmhfhold_in;            
    wire [PHY_LANE-1 : 0] rxlpmlfhold_in;              
    wire [PHY_LANE-1 : 0] rxlpmoshold_in;  

    wire [PHY_LANE-1:0]         rxdlysresetdone_out;     
    wire [PHY_LANE-1:0]         rxelecidle_out;
    wire [PHY_LANE-1:0]         rxlpmen_in;                                                            
    wire [PHY_LANE-1:0]         rxmcommaalignen_in;                                                    
    wire [PHY_LANE-1 : 0]       rxoutclk_out; 
    wire [PHY_LANE-1:0]         rxpcommaalignen_in;                                                    
    wire [(PHY_LANE* 2)-1:0]    rxpd_in;                                              
    wire [PHY_LANE-1:0]         rxphaligndone_out;
    wire [PHY_LANE-1:0]         rxpmaresetdone_out;           
    wire [PHY_LANE-1:0]         rxpolarity_in;                                          
    wire [PHY_LANE-1:0]         rxprbscntreset_in; 
    wire [PHY_LANE-1:0]         rxprbserr_out;                                        
    wire [PHY_LANE-1:0]         rxprbslocked_out;
    wire [(PHY_LANE* 4)-1:0]    rxprbssel_in;                                               
    wire [PHY_LANE-1:0]         rxprgdivresetdone_out;    
    wire [PHY_LANE-1:0]         rxprogdivreset_in;                                          
    wire [(PHY_LANE* 3)-1:0]    rxrate_in;
    wire [PHY_LANE-1:0]         rxratedone_out;
    wire [PHY_LANE-1:0]         rxratemode_in;
    wire [PHY_LANE-1:0]         rxresetdone_out;              
    wire [PHY_LANE-1:0]         rxslide_in;                                                
    wire [(PHY_LANE* 3)-1:0]    rxstatus_out;
    wire [PHY_LANE-1:0]         rxsyncdone_out;
    wire [PHY_LANE-1:0]         rxuserrdy_in;                                          
    wire [PHY_LANE-1:0]         rxusrclk2_in;                                          
    wire [PHY_LANE-1:0]         rxusrclk_in;                                          
    wire [PHY_LANE-1:0]         rxvalid_out;
    wire [PHY_LANE-1:0]         tx8b10ben_in;                                                          
    wire [(PHY_LANE*16)-1:0]    txctrl0_in;
    wire [(PHY_LANE*16)-1:0]    txctrl1_in;
    wire [(PHY_LANE* 8)-1:0]    txctrl2_in;
    wire [(PHY_LANE*128)-1:0]   txdata_in; 
    wire [PHY_LANE-1:0]         txdeemph_in;                                          
    wire [PHY_LANE-1:0]         txdetectrx_in;                                          
    wire [(PHY_LANE*4)-1:0]     txdiffctrl_in;
    wire [PHY_LANE-1:0]         txdlybypass_in;                                                
    wire [PHY_LANE-1:0]         txdlyen_in;                                                
    wire [PHY_LANE-1:0]         txdlyhold_in;                                                
    wire [PHY_LANE-1:0]         txdlyovrden_in;                                                
    wire [PHY_LANE-1:0]         txdlysreset_in;                                                
    wire [PHY_LANE-1:0]         txdlysresetdone_out;     
    wire [PHY_LANE-1:0]         txdlyupdown_in;                                                
    wire [PHY_LANE-1:0]         txelecidle_in;                                          
    wire [PHY_LANE-1:0]         txinhibit_in;                                          
    wire [(PHY_LANE* 7)-1:0]    txmaincursor_in;                                               
    wire [(PHY_LANE* 3)-1:0]    txmargin_in;                                              
    wire [PHY_LANE-1:0]         txoutclk_out;
    wire [(PHY_LANE* 3)-1:0]    txoutclksel_in;                                           
    wire [(PHY_LANE* 2)-1:0]    txpd_in;                                              
    wire [PHY_LANE-1:0]         txphalign_in;                                                
    wire [PHY_LANE-1:0]         txphaligndone_out;  
    wire [PHY_LANE-1:0]         txphalignen_in;                                                
    wire [PHY_LANE-1:0]         txphdlypd_in;                                                
    wire [PHY_LANE-1:0]         txphdlyreset_in;                                                
    wire [PHY_LANE-1:0]         txphdlytstclk_in ;                                                
    wire [PHY_LANE-1:0]         txphinit_in;                                                
    wire [PHY_LANE-1:0]         txphinitdone_out;
    wire [PHY_LANE-1:0]         txphovrden_in;                                                
    wire [PHY_LANE-1 : 0]       txpmaresetdone_out; 
    wire [(PHY_LANE* 5)-1:0]    txpostcursor_in;                                               
    wire [PHY_LANE-1:0]         txprbsforceerr_in;                                          
    wire [(PHY_LANE* 4)-1:0]    txprbssel_in;                                               
    wire [(PHY_LANE* 5)-1:0]    txprecursor_in;                                               
    wire [PHY_LANE-1:0]         txprgdivresetdone_out;  
    wire [PHY_LANE-1:0]         txprogdivreset_in;                                          
    wire [(PHY_LANE* 3)-1:0]    txrate_in;
    wire [PHY_LANE-1:0]         txresetdone_out;
    wire [PHY_LANE-1:0]         txswing_in;                                          
    wire [(PHY_LANE-1) : 0]     txsyncallin_in; 
    wire [PHY_LANE-1 : 0]       txsyncdone_out; 
    wire [(PHY_LANE-1) : 0]     txsyncin_in;   
    wire [PHY_LANE-1:0]         txsyncmode_in;
    wire [PHY_LANE-1:0]         txsyncout_out;  
    wire [PHY_LANE-1:0]         txuserrdy_in;                                          
    wire [PHY_LANE-1:0]         txusrclk2_in;                                          
    wire [PHY_LANE-1:0]         txusrclk_in;                                          

    wire [PHY_LANE-1 : 0]       qpll0clk_in; 
    wire [PHY_LANE-1 : 0]       qpll0refclk_in;

    wire [(PHY_LANE-1)>>2:0]    gtrefclk01_in;
    wire [(PHY_LANE-1)>>2:0]    qpll1pd_in;
    wire [(PHY_LANE-1)>>2:0]    qpll1reset_in;
    wire [((((PHY_LANE-1)>>2)+1)* 5)-1:0] qpllrsvd2_in;
    wire [((((PHY_LANE-1)>>2)+1)* 5)-1:0] qpllrsvd3_in;
    wire [(PHY_LANE-1)>>2:0]     qpll1lock_out;
    wire [(PHY_LANE-1)>>2:0]     qpll1outclk_out;
    wire [(PHY_LANE-1)>>2:0]     qpll1outrefclk_out;

//
//
    assign drpclk_in = GT_DRPCLK;
//
//

genvar m;                                                                                                      

generate for (m=0; m<PHY_LANE; m=m+1)                                                      
                                                                                                    
    begin : drp_sigs
                                 
    assign drpaddr_in[(9*m)+8:(9*m)] = GT_DRPADDR[(9 * ((PHY_LANE - 1) - m)) + 8 : (9 * ((PHY_LANE - 1) - m))];
    assign drpdi_in[(16*m)+15:(16*m)] = GT_DRPDI[(16 * ((PHY_LANE - 1) - m)) + 15 : (16 * ((PHY_LANE - 1) - m))];
    assign drpen_in[m] = GT_DRPEN[((PHY_LANE-1)-m)];
    assign drpwe_in[m] = GT_DRPWE[((PHY_LANE-1)-m)];
    assign GT_DRPDO[(16*m)+15:(16*m)] = drpdo_out[(16 * ((PHY_LANE - 1) - m)) + 15 : (16 * ((PHY_LANE - 1) - m))];
    assign GT_DRPRDY[m] = drprdy_out[((PHY_LANE-1)-m)];

    end
endgenerate

  //  assign drpaddr_in = {PHY_LANE{9'b0}};
  //  assign drpdi_in = {PHY_LANE{16'b0}};
  //  assign drpen_in = {PHY_LANE{1'b0}};
  //  assign drpwe_in = {PHY_LANE{1'b0}};
  //  assign GT_DRPDO = {PHY_LANE{16'b0}};
  //  assign GT_DRPRDY = {PHY_LANE{1'b0}};

    wire [(PHY_LANE* 18)-1:0] gtwiz_gthe3_cpll_cal_txoutclk_period_in;
    wire [(PHY_LANE* 18)-1:0] gtwiz_gthe3_cpll_cal_cnt_tol_in;
    wire [(PHY_LANE*  1)-1:0] gtwiz_gthe3_cpll_cal_bufg_ce_in;
    assign gtwiz_gthe3_cpll_cal_txoutclk_period_in = {PHY_LANE{18'd4000}}; 
    assign gtwiz_gthe3_cpll_cal_cnt_tol_in         = {PHY_LANE{18'd40}};    
    assign gtwiz_userclk_tx_reset_in               = bufgtreset_out[21];
    assign gtwiz_gthe3_cpll_cal_bufg_ce_in         = {PHY_LANE{bufgtce_out[21]}};

//-------------------------------------------------------------------------------------------------
//  Internal Signals
//-------------------------------------------------------------------------------------------------- 
    wire        [(PHY_LANE* 3)-1:0]     rate;
//--------------------------------------------------------------------------------------------------
//  Signals converted from per lane
//--------------------------------------------------------------------------------------------------
    wire                                qpll1lock_all;    
    wire                                txsyncallin_all;
//--------------------------------------------------------------------------------------------------
    wire        [((((PHY_LANE-1)>>2)+1)* 5)-1:0] qpllrsvd2_3;

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    assign qpll0clk_in = 0; 
    assign qpll0refclk_in = 0;
//    assign rxlpmen_in = GT_RXLPMEN; 

    assign qpll1lock_all   = &qpll1lock_out;
    assign txsyncallin_all = &txphaligndone_out;    
    
    assign gtwiz_userclk_tx_active_in = 1'd0;                                                
    assign gtwiz_userclk_rx_active_in = 1'd0;                                                
    assign gtwiz_reset_tx_done_in     = 1'd0;                                                
    assign gtwiz_reset_rx_done_in     = 1'd0;                                                                                      
    assign gtrefclk01_in         = ({(((PHY_LANE-1)>>2)+1){GT_GTREFCLK0}});                                                  
    assign gtrefclk0_in          = ({PHY_LANE{GT_GTREFCLK0}});                                                    
    assign rx8b10ben_in          = (~pcierategen3_out);                                                
    assign rxmcommaalignen_in    = (~pcierategen3_out);                                                
    assign rxpcommaalignen_in    = (~pcierategen3_out);                                                
    assign tx8b10ben_in          = (~pcierategen3_out);                                                
    assign rxbufreset_in         = ({PHY_LANE{1'd0}});                                                
    assign rxcommadeten_in       = ({PHY_LANE{1'd1}});     // Always 1'd1            
    assign rxslide_in            = ({PHY_LANE{1'd0}});                                                
    assign txdlybypass_in        = ({PHY_LANE{1'd0}});                                                
    assign txdlyen_in            = ({PHY_LANE{1'd0}});                                                
    assign txdlyhold_in          = ({PHY_LANE{1'd0}});                                                
    assign txdlyovrden_in        = ({PHY_LANE{1'd0}});                                                
    assign txdlysreset_in        = ({PHY_LANE{1'd0}});                                                
    assign txdlyupdown_in        = ({PHY_LANE{1'd0}});                                                
    assign txphalign_in          = ({PHY_LANE{1'd0}});                                                
    assign txphalignen_in        = ({PHY_LANE{1'd0}});                                                
    assign txphdlypd_in          = {1'b0, !txpmaresetdone_out[1], !txpmaresetdone_out[2], !txpmaresetdone_out[3], !txpmaresetdone_out[4], !txpmaresetdone_out[5], !txpmaresetdone_out[6], !txpmaresetdone_out[7] };
    assign rxlpmen_in            = {(GT_RATE[1:0]==2'b10)?GT_RXLPMEN[0]:1'b1,(GT_RATE[3:2]==2'b10)?GT_RXLPMEN[1]:1'b1,(GT_RATE[5:4]==2'b10)?GT_RXLPMEN[2]:1'b1,(GT_RATE[7:6]==2'b10)?GT_RXLPMEN[3]:1'b1,(GT_RATE[9:8]==2'b10)?GT_RXLPMEN[4]:1'b1,(GT_RATE[11:10]==2'b10)?GT_RXLPMEN[5]:1'b1,(GT_RATE[13:12]==2'b10)?GT_RXLPMEN[6]:1'b1,(GT_RATE[15:14]==2'b10)?GT_RXLPMEN[7]:1'b1};   // [STG - RXLPMEN based on rate now]
 
    assign txphdlyreset_in       = ({PHY_LANE{1'd0}});                                                
    assign txphdlytstclk_in      = ({PHY_LANE{1'd0}});                                                
    assign txphinit_in           = ({PHY_LANE{1'd0}});                                                
    assign txphovrden_in         = ({PHY_LANE{1'd0}});                                                
    assign txsyncallin_in        = ({PHY_LANE{txsyncallin_all}}); // From all lanes                         

    assign qpllrsvd2_in          = qpllrsvd2_3;
    assign qpllrsvd3_in          = qpllrsvd2_3;
    assign rxrate_in             = rate;
    assign txrate_in             = rate;
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 // dynamic GT instance call
   xdma_0_pcie3_ip_gt xdma_0_pcie3_ip_gt_i
  (
   .bufgtce_out(bufgtce_out),
   .bufgtcemask_out(bufgtcemask_out),
   .bufgtdiv_out(bufgtdiv_out),
   .bufgtreset_out(bufgtreset_out),
   .bufgtrstmask_out(bufgtrstmask_out),
   .cplllock_out(cplllock_out),
   .cpllpd_in(cpllpd_in),
   .cpllreset_in(cpllreset_in),
   .dmonfiforeset_in(dmonfiforeset_in),
   .dmonitorclk_in(dmonitorclk_in),
   .dmonitorout_out(dmonitorout_out),
   .drpaddr_in(drpaddr_in),
   .drpclk_in(drpclk_in),
   .drpdi_in(drpdi_in),
   .drpdo_out(drpdo_out),
   .drpen_in(drpen_in),
   .drprdy_out(drprdy_out),
   .drpwe_in(drpwe_in),
   .eyescandataerror_out(eyescandataerror_out),
   .eyescanreset_in(eyescanreset_in),
   .gthrxn_in(gthrxn_in),
   .gthrxp_in(gthrxp_in),
   .gthtxn_out(gthtxn_out),
   .gthtxp_out(gthtxp_out),
   .gtpowergood_out(gtpowergood_out),
   .gtrefclk01_in(gtrefclk01_in),
   .gtrefclk0_in(gtrefclk0_in),
   .gtrxreset_in(gtrxreset_in),
   .gttxreset_in(gttxreset_in),
   .gtwiz_reset_rx_done_in(gtwiz_reset_rx_done_in),
   .gtwiz_reset_tx_done_in(gtwiz_reset_tx_done_in),
   .gtwiz_userclk_rx_active_in(gtwiz_userclk_rx_active_in),
   .gtwiz_userclk_tx_active_in(gtwiz_userclk_tx_active_in),
   .loopback_in(loopback_in),
   .pcieeqrxeqadaptdone_in(pcieeqrxeqadaptdone_in),
   .pcierategen3_out(pcierategen3_out),
   .pcierateidle_out(pcierateidle_out),
   .pcierateqpllpd_out(pcierateqpllpd_out),
   .pcierateqpllreset_out(pcierateqpllreset_out),
   .pcierstidle_in(pcierstidle_in),
   .pciersttxsyncstart_in(pciersttxsyncstart_in),
   .pciesynctxsyncdone_out(pciesynctxsyncdone_out),
   .pcieusergen3rdy_out(pcieusergen3rdy_out),
   .pcieuserphystatusrst_out(pcieuserphystatusrst_out),
   .pcieuserratedone_in(pcieuserratedone_in),
   .pcieuserratestart_out(pcieuserratestart_out),
   .pcsrsvdin_in(pcsrsvdin_in),
   .pcsrsvdout_out(pcsrsvdout_out),
   .phystatus_out(phystatus_out),
   .qpll1lock_out(qpll1lock_out),
   .qpll1outclk_out(qpll1outclk_out),
   .qpll1outrefclk_out(qpll1outrefclk_out),
   .qpll1pd_in(qpll1pd_in),
   .qpll1reset_in(qpll1reset_in),
   .qpllrsvd2_in(qpllrsvd2_in),
   .qpllrsvd3_in(qpllrsvd3_in),
   .rx8b10ben_in(rx8b10ben_in),
   .rxbufreset_in(rxbufreset_in),
   .rxbufstatus_out(rxbufstatus_out),
   .rxbyteisaligned_out(rxbyteisaligned_out),
   .rxbyterealign_out(rxbyterealign_out),
   .rxcdrhold_in(rxcdrhold_in),
   .rxcdrlock_out(rxcdrlock_out),
   .rxclkcorcnt_out(rxclkcorcnt_out),
   .rxcommadet_out(rxcommadet_out),
   .rxcommadeten_in(rxcommadeten_in),
   .rxctrl0_out(rxctrl0_out),
   .rxctrl1_out(rxctrl1_out),
   .rxctrl2_out(rxctrl2_out),
   .rxctrl3_out(rxctrl3_out),
   .rxdata_out(rxdata_out),
   .rxdfeagchold_in(rxdfeagchold_in),
   .rxdfelfhold_in(rxdfelfhold_in),
   .rxdfetap10hold_in(rxdfetap10hold_in),
   .rxdfetap11hold_in(rxdfetap11hold_in),
   .rxdfetap12hold_in(rxdfetap12hold_in),
   .rxdfetap13hold_in(rxdfetap13hold_in),
   .rxdfetap14hold_in(rxdfetap14hold_in),
   .rxdfetap15hold_in(rxdfetap15hold_in),
   .rxdfetap2hold_in(rxdfetap2hold_in),
   .rxdfetap3hold_in(rxdfetap3hold_in),
   .rxdfetap4hold_in(rxdfetap4hold_in),
   .rxdfetap5hold_in(rxdfetap5hold_in),
   .rxdfetap6hold_in(rxdfetap6hold_in),
   .rxdfetap7hold_in(rxdfetap7hold_in),
   .rxdfetap8hold_in(rxdfetap8hold_in),
   .rxdfetap9hold_in(rxdfetap9hold_in),
   .rxdfeuthold_in(rxdfeuthold_in),
   .rxdfevphold_in(rxdfevphold_in),
   .rxdlysresetdone_out(rxdlysresetdone_out),
   .rxelecidle_out(rxelecidle_out),
   .rxlpmen_in(rxlpmen_in),
   .rxlpmgchold_in(rxlpmgchold_in),
   .rxlpmhfhold_in(rxlpmhfhold_in),
   .rxlpmlfhold_in(rxlpmlfhold_in),
   .rxlpmoshold_in(rxlpmoshold_in),
   .rxmcommaalignen_in(rxmcommaalignen_in),
   .rxoshold_in(rxoshold_in),
   .rxoutclk_out(rxoutclk_out),
   .rxpcommaalignen_in(rxpcommaalignen_in),
   .rxpd_in(rxpd_in),
   .rxphaligndone_out(rxphaligndone_out),
   .rxpmaresetdone_out(rxpmaresetdone_out),
   .rxpolarity_in(rxpolarity_in),
   .rxprbscntreset_in(rxprbscntreset_in),
   .rxprbserr_out(rxprbserr_out),
   .rxprbslocked_out(rxprbslocked_out),
   .rxprbssel_in(rxprbssel_in),
   .rxprgdivresetdone_out(rxprgdivresetdone_out),
   .rxprogdivreset_in(rxprogdivreset_in),
   .rxrate_in(rxrate_in),
   .rxratedone_out(rxratedone_out),
   .rxratemode_in(rxratemode_in),
   .rxresetdone_out(rxresetdone_out),
   .rxslide_in(rxslide_in),
   .rxstatus_out(rxstatus_out),
   .rxsyncdone_out(rxsyncdone_out),
   .rxuserrdy_in(rxuserrdy_in),
   .rxusrclk2_in(rxusrclk2_in),
   .rxusrclk_in(rxusrclk_in),
   .rxvalid_out(rxvalid_out),
   .tx8b10ben_in(tx8b10ben_in),
   .txctrl0_in(txctrl0_in),
   .txctrl1_in(txctrl1_in),
   .txctrl2_in(txctrl2_in),
   .txdata_in(txdata_in),
   .txdeemph_in(txdeemph_in),
   .txdetectrx_in(txdetectrx_in),
   .txdiffctrl_in(txdiffctrl_in),
   .txdlybypass_in(txdlybypass_in),
   .txdlyen_in(txdlyen_in),
   .txdlyhold_in(txdlyhold_in),
   .txdlyovrden_in(txdlyovrden_in),
   .txdlysreset_in(txdlysreset_in),
   .txdlysresetdone_out(txdlysresetdone_out),
   .txdlyupdown_in(txdlyupdown_in),
   .txelecidle_in(txelecidle_in),
   .txinhibit_in(txinhibit_in),
   .txmaincursor_in(txmaincursor_in),
   .txmargin_in(txmargin_in),
   .txoutclk_out(txoutclk_out),
   .txoutclksel_in(txoutclksel_in),
   .txpd_in(txpd_in),
   .txphalign_in(txphalign_in),
   .txphaligndone_out(txphaligndone_out),
   .txphalignen_in(txphalignen_in),
   .txphdlypd_in(txphdlypd_in),
   .txphdlyreset_in(txphdlyreset_in),
   .txphdlytstclk_in(txphdlytstclk_in),
   .txphinit_in(txphinit_in),
   .txphinitdone_out(txphinitdone_out),
   .txphovrden_in(txphovrden_in),
   .txpmaresetdone_out(txpmaresetdone_out),
   .txpostcursor_in(txpostcursor_in),
   .txprbsforceerr_in(txprbsforceerr_in),
   .txprbssel_in(txprbssel_in),
   .txprecursor_in(txprecursor_in),
   .txprgdivresetdone_out(txprgdivresetdone_out),
   .txprogdivreset_in(txprogdivreset_in),
   .txrate_in(txrate_in),
   .txresetdone_out(txresetdone_out),
   .txswing_in(txswing_in),
   .txsyncallin_in(txsyncallin_in),
   .txsyncdone_out(txsyncdone_out),
   .txsyncin_in(txsyncin_in),
   .txsyncmode_in(txsyncmode_in),
   .txsyncout_out(txsyncout_out),
   .txuserrdy_in(txuserrdy_in),
   .txusrclk2_in(txusrclk2_in),
   .txusrclk_in(txusrclk_in)
  );

//--------------------------------------------------------------------- Mapping ----------------------------------------------------------------------------------------------------------------------------------------------
    assign rate                   = {{1'd0,GT_RATE[1:0]},{1'd0,GT_RATE[3:2]},{1'd0,GT_RATE[5:4]},{1'd0,GT_RATE[7:6]},{1'd0,GT_RATE[9:8]},{1'd0,GT_RATE[11:10]},{1'd0,GT_RATE[13:12]},{1'd0,GT_RATE[15:14]}};
    assign txsyncmode_in          = 8'h80; // X0Y7 is the Master. So, txsyncmode_in[7] = 1'b1;
    assign txsyncin_in            = ({PHY_LANE{txsyncout_out[7]}}); // From Master Lane 0 - X0Y7                  
    assign pcsrsvdin_in           = {PHY_LANE{14'd0,cplllock_out[7],qpll1lock_all}};

    assign gthrxn_in              = {GT_RXN[0],GT_RXN[1],GT_RXN[2],GT_RXN[3],GT_RXN[4],GT_RXN[5],GT_RXN[6],GT_RXN[7]};
    assign gthrxp_in              = {GT_RXP[0],GT_RXP[1],GT_RXP[2],GT_RXP[3],GT_RXP[4],GT_RXP[5],GT_RXP[6],GT_RXP[7]};
    assign GT_TXN                 = {gthtxn_out[0],gthtxn_out[1],gthtxn_out[2],gthtxn_out[3],gthtxn_out[4],gthtxn_out[5],gthtxn_out[6],gthtxn_out[7]};                                      
    assign GT_TXP                 = {gthtxp_out[0],gthtxp_out[1],gthtxp_out[2],gthtxp_out[3],gthtxp_out[4],gthtxp_out[5],gthtxp_out[6],gthtxp_out[7]};                                      
    assign rxratemode_in          = {GT_RXRATEMODE[0],GT_RXRATEMODE[1],GT_RXRATEMODE[2],GT_RXRATEMODE[3],GT_RXRATEMODE[4],GT_RXRATEMODE[5],GT_RXRATEMODE[6],GT_RXRATEMODE[7]};
    assign cpllpd_in              = {GT_CPLLPD[0],GT_CPLLPD[1],GT_CPLLPD[2],GT_CPLLPD[3],GT_CPLLPD[4],GT_CPLLPD[5],GT_CPLLPD[6],GT_CPLLPD[7]};
    assign cpllreset_in           = {GT_CPLLRESET[0],GT_CPLLRESET[1],GT_CPLLRESET[2],GT_CPLLRESET[3],GT_CPLLRESET[4],GT_CPLLRESET[5],GT_CPLLRESET[6],GT_CPLLRESET[7]};
    assign eyescanreset_in        = {GT_EYESCANRESET[0],GT_EYESCANRESET[1],GT_EYESCANRESET[2],GT_EYESCANRESET[3],GT_EYESCANRESET[4],GT_EYESCANRESET[5],GT_EYESCANRESET[6],GT_EYESCANRESET[7]};
    assign txdiffctrl_in          = {GT_TXDIFFCTRL[3:0],GT_TXDIFFCTRL[7:4],GT_TXDIFFCTRL[11:8],GT_TXDIFFCTRL[15:12],GT_TXDIFFCTRL[19:16],GT_TXDIFFCTRL[23:20],GT_TXDIFFCTRL[27:24],GT_TXDIFFCTRL[31:28]};
    assign dmonitorclk_in         = {GT_DMONITORCLK[0],GT_DMONITORCLK[1],GT_DMONITORCLK[2],GT_DMONITORCLK[3],GT_DMONITORCLK[4],GT_DMONITORCLK[5],GT_DMONITORCLK[6],GT_DMONITORCLK[7]};
    assign dmonfiforeset_in       = {GT_DMONFIFORESET[0],GT_DMONFIFORESET[1],GT_DMONFIFORESET[2],GT_DMONFIFORESET[3],GT_DMONFIFORESET[4],GT_DMONFIFORESET[5],GT_DMONFIFORESET[6],GT_DMONFIFORESET[7]};
    assign txswing_in             = {GT_TXSWING[0],GT_TXSWING[1],GT_TXSWING[2],GT_TXSWING[3],GT_TXSWING[4],GT_TXSWING[5],GT_TXSWING[6],GT_TXSWING[7]};
    assign txusrclk_in            = {GT_TXUSRCLK[0],GT_TXUSRCLK[1],GT_TXUSRCLK[2],GT_TXUSRCLK[3],GT_TXUSRCLK[4],GT_TXUSRCLK[5],GT_TXUSRCLK[6],GT_TXUSRCLK[7]};
    assign rxusrclk_in            = {GT_RXUSRCLK[0],GT_RXUSRCLK[1],GT_RXUSRCLK[2],GT_RXUSRCLK[3],GT_RXUSRCLK[4],GT_RXUSRCLK[5],GT_RXUSRCLK[6],GT_RXUSRCLK[7]};
    assign txdeemph_in            = {GT_TXDEEMPH[0],GT_TXDEEMPH[1],GT_TXDEEMPH[2],GT_TXDEEMPH[3],GT_TXDEEMPH[4],GT_TXDEEMPH[5],GT_TXDEEMPH[6],GT_TXDEEMPH[7]};
    assign rxcdrhold_in           = {GT_RXCDRHOLD[0],GT_RXCDRHOLD[1],GT_RXCDRHOLD[2],GT_RXCDRHOLD[3],GT_RXCDRHOLD[4],GT_RXCDRHOLD[5],GT_RXCDRHOLD[6],GT_RXCDRHOLD[7]};
    assign txusrclk2_in           = {GT_TXUSRCLK2[0],GT_TXUSRCLK2[1],GT_TXUSRCLK2[2],GT_TXUSRCLK2[3],GT_TXUSRCLK2[4],GT_TXUSRCLK2[5],GT_TXUSRCLK2[6],GT_TXUSRCLK2[7]};
    assign rxusrclk2_in           = {GT_RXUSRCLK2[0],GT_RXUSRCLK2[1],GT_RXUSRCLK2[2],GT_RXUSRCLK2[3],GT_RXUSRCLK2[4],GT_RXUSRCLK2[5],GT_RXUSRCLK2[6],GT_RXUSRCLK2[7]};
    assign gttxreset_in           = {GT_GTTXRESET[0],GT_GTTXRESET[1],GT_GTTXRESET[2],GT_GTTXRESET[3],GT_GTTXRESET[4],GT_GTTXRESET[5],GT_GTTXRESET[6],GT_GTTXRESET[7]};
    assign gtrxreset_in           = {GT_GTRXRESET[0],GT_GTRXRESET[1],GT_GTRXRESET[2],GT_GTRXRESET[3],GT_GTRXRESET[4],GT_GTRXRESET[5],GT_GTRXRESET[6],GT_GTRXRESET[7]};
    assign txuserrdy_in           = {GT_TXUSERRDY[0],GT_TXUSERRDY[1],GT_TXUSERRDY[2],GT_TXUSERRDY[3],GT_TXUSERRDY[4],GT_TXUSERRDY[5],GT_TXUSERRDY[6],GT_TXUSERRDY[7]};
    assign rxuserrdy_in           = {GT_RXUSERRDY[0],GT_RXUSERRDY[1],GT_RXUSERRDY[2],GT_RXUSERRDY[3],GT_RXUSERRDY[4],GT_RXUSERRDY[5],GT_RXUSERRDY[6],GT_RXUSERRDY[7]};
    assign txdetectrx_in          = {GT_TXDETECTRX[0],GT_TXDETECTRX[1],GT_TXDETECTRX[2],GT_TXDETECTRX[3],GT_TXDETECTRX[4],GT_TXDETECTRX[5],GT_TXDETECTRX[6],GT_TXDETECTRX[7]};
    assign txelecidle_in          = {GT_TXELECIDLE[0],GT_TXELECIDLE[1],GT_TXELECIDLE[2],GT_TXELECIDLE[3],GT_TXELECIDLE[4],GT_TXELECIDLE[5],GT_TXELECIDLE[6],GT_TXELECIDLE[7]};
    assign rxpolarity_in          = {GT_RXPOLARITY[0],GT_RXPOLARITY[1],GT_RXPOLARITY[2],GT_RXPOLARITY[3],GT_RXPOLARITY[4],GT_RXPOLARITY[5],GT_RXPOLARITY[6],GT_RXPOLARITY[7]};
    assign txprogdivreset_in      = {GT_TXPROGDIVRESET[0],GT_TXPROGDIVRESET[1],GT_TXPROGDIVRESET[2],GT_TXPROGDIVRESET[3],GT_TXPROGDIVRESET[4],GT_TXPROGDIVRESET[5],GT_TXPROGDIVRESET[6],GT_TXPROGDIVRESET[7]};
    assign rxprogdivreset_in      = {GT_RXPROGDIVRESET[0],GT_RXPROGDIVRESET[1],GT_RXPROGDIVRESET[2],GT_RXPROGDIVRESET[3],GT_RXPROGDIVRESET[4],GT_RXPROGDIVRESET[5],GT_RXPROGDIVRESET[6],GT_RXPROGDIVRESET[7]};

    assign GT_TXOUTCLK            = {txoutclk_out[0],txoutclk_out[1],txoutclk_out[2],txoutclk_out[3],txoutclk_out[4],txoutclk_out[5],txoutclk_out[6],txoutclk_out[7]};                                      
    assign GT_RXCOMMADET          = {rxcommadet_out[0],rxcommadet_out[1],rxcommadet_out[2],rxcommadet_out[3],rxcommadet_out[4],rxcommadet_out[5],rxcommadet_out[6],rxcommadet_out[7]}          ;   
    assign GT_GTPOWERGOOD         = {gtpowergood_out[0],gtpowergood_out[1],gtpowergood_out[2],gtpowergood_out[3],gtpowergood_out[4],gtpowergood_out[5],gtpowergood_out[6],gtpowergood_out[7]}         ;                                      
    assign GT_TXRESETDONE         = {txresetdone_out[0],txresetdone_out[1],txresetdone_out[2],txresetdone_out[3],txresetdone_out[4],txresetdone_out[5],txresetdone_out[6],txresetdone_out[7]}         ;                                      
    assign GT_RXRESETDONE         = {rxresetdone_out[0],rxresetdone_out[1],rxresetdone_out[2],rxresetdone_out[3],rxresetdone_out[4],rxresetdone_out[5],rxresetdone_out[6],rxresetdone_out[7]}         ;                                      
    assign GT_TXPHINITDONE        = {txphinitdone_out[0],txphinitdone_out[1],txphinitdone_out[2],txphinitdone_out[3],txphinitdone_out[4],txphinitdone_out[5],txphinitdone_out[6],txphinitdone_out[7]}        ;    
    assign GT_TXPHALIGNDONE       = {txphaligndone_out[0],txphaligndone_out[1],txphaligndone_out[2],txphaligndone_out[3],txphaligndone_out[4],txphaligndone_out[5],txphaligndone_out[6],txphaligndone_out[7]};
    assign GT_RXPMARESETDONE      = {rxpmaresetdone_out[0],rxpmaresetdone_out[1],rxpmaresetdone_out[2],rxpmaresetdone_out[3],rxpmaresetdone_out[4],rxpmaresetdone_out[5],rxpmaresetdone_out[6],rxpmaresetdone_out[7]}      ; 
    assign GT_TXPROGDIVRESETDONE  = {txprgdivresetdone_out[0],txprgdivresetdone_out[1],txprgdivresetdone_out[2],txprgdivresetdone_out[3],txprgdivresetdone_out[4],txprgdivresetdone_out[5],txprgdivresetdone_out[6],txprgdivresetdone_out[7]}   ;                                      
    assign GT_RXPROGDIVRESETDONE  = {rxprgdivresetdone_out[0],rxprgdivresetdone_out[1],rxprgdivresetdone_out[2],rxprgdivresetdone_out[3],rxprgdivresetdone_out[4],rxprgdivresetdone_out[5],rxprgdivresetdone_out[6],rxprgdivresetdone_out[7]}   ;                                      

    assign GT_RXVALID             = {rxvalid_out[0],rxvalid_out[1],rxvalid_out[2],rxvalid_out[3],rxvalid_out[4],rxvalid_out[5],rxvalid_out[6],rxvalid_out[7]};
    assign GT_RXPRBSERR           = {rxprbserr_out[0],rxprbserr_out[1],rxprbserr_out[2],rxprbserr_out[3],rxprbserr_out[4],rxprbserr_out[5],rxprbserr_out[6],rxprbserr_out[7]};                                      
    assign GT_PHYSTATUS           = {phystatus_out[0],phystatus_out[1],phystatus_out[2],phystatus_out[3],phystatus_out[4],phystatus_out[5],phystatus_out[6],phystatus_out[7]};                                      
    assign GT_RXCDRLOCK           = {rxcdrlock_out[0],rxcdrlock_out[1],rxcdrlock_out[2],rxcdrlock_out[3],rxcdrlock_out[4],rxcdrlock_out[5],rxcdrlock_out[6],rxcdrlock_out[7]};                                                                                               
    assign pcierstidle_in         = {GT_PCIERSTIDLE[0],GT_PCIERSTIDLE[1],GT_PCIERSTIDLE[2],GT_PCIERSTIDLE[3],GT_PCIERSTIDLE[4],GT_PCIERSTIDLE[5],GT_PCIERSTIDLE[6],GT_PCIERSTIDLE[7]};
    assign GT_RXSYNCDONE          = {rxsyncdone_out[0],rxsyncdone_out[1],rxsyncdone_out[2],rxsyncdone_out[3],rxsyncdone_out[4],rxsyncdone_out[5],rxsyncdone_out[6],rxsyncdone_out[7]};           
    assign GT_RXELECIDLE          = {rxelecidle_out[0],rxelecidle_out[1],rxelecidle_out[2],rxelecidle_out[3],rxelecidle_out[4],rxelecidle_out[5],rxelecidle_out[6],rxelecidle_out[7]};                                      
    assign GT_PCIERATEIDLE        = {pcierateidle_out[0],pcierateidle_out[1],pcierateidle_out[2],pcierateidle_out[3],pcierateidle_out[4],pcierateidle_out[5],pcierateidle_out[6],pcierateidle_out[7]};                                      
    assign GT_RXPRBSLOCKED        = {rxprbslocked_out[0],rxprbslocked_out[1],rxprbslocked_out[2],rxprbslocked_out[3],rxprbslocked_out[4],rxprbslocked_out[5],rxprbslocked_out[6],rxprbslocked_out[7]};                                      
    assign GT_PCIERATEGEN3        = {pcierategen3_out[0],pcierategen3_out[1],pcierategen3_out[2],pcierategen3_out[3],pcierategen3_out[4],pcierategen3_out[5],pcierategen3_out[6],pcierategen3_out[7]};
    assign GT_RXPHALIGNDONE       = {rxphaligndone_out[0],rxphaligndone_out[1],rxphaligndone_out[2],rxphaligndone_out[3],rxphaligndone_out[4],rxphaligndone_out[5],rxphaligndone_out[6],rxphaligndone_out[7]};          
    assign txprbsforceerr_in      = {GT_TXPRBSFORCEERR[0],GT_TXPRBSFORCEERR[1],GT_TXPRBSFORCEERR[2],GT_TXPRBSFORCEERR[3],GT_TXPRBSFORCEERR[4],GT_TXPRBSFORCEERR[5],GT_TXPRBSFORCEERR[6],GT_TXPRBSFORCEERR[7]};
    assign txinhibit_in           = {GT_TXINHIBIT[0],GT_TXINHIBIT[1],GT_TXINHIBIT[2],GT_TXINHIBIT[3],GT_TXINHIBIT[4],GT_TXINHIBIT[5],GT_TXINHIBIT[6],GT_TXINHIBIT[7]};
    assign rxprbscntreset_in      = {GT_RXPRBSCNTRESET[0],GT_RXPRBSCNTRESET[1],GT_RXPRBSCNTRESET[2],GT_RXPRBSCNTRESET[3],GT_RXPRBSCNTRESET[4],GT_RXPRBSCNTRESET[5],GT_RXPRBSCNTRESET[6],GT_RXPRBSCNTRESET[7]};
    assign GT_RXDLYSRESETDONE     = {rxdlysresetdone_out[0],rxdlysresetdone_out[1],rxdlysresetdone_out[2],rxdlysresetdone_out[3],rxdlysresetdone_out[4],rxdlysresetdone_out[5],rxdlysresetdone_out[6],rxdlysresetdone_out[7]};           
    assign GT_TXDLYSRESETDONE     = {txdlysresetdone_out[0],txdlysresetdone_out[1],txdlysresetdone_out[2],txdlysresetdone_out[3],txdlysresetdone_out[4],txdlysresetdone_out[5],txdlysresetdone_out[6],txdlysresetdone_out[7]};  
    assign GT_PCIEUSERGEN3RDY     = {pcieusergen3rdy_out[0],pcieusergen3rdy_out[1],pcieusergen3rdy_out[2],pcieusergen3rdy_out[3],pcieusergen3rdy_out[4],pcieusergen3rdy_out[5],pcieusergen3rdy_out[6],pcieusergen3rdy_out[7]};                                      
    assign pcieuserratedone_in    = {GT_PCIEUSERRATEDONE[0],GT_PCIEUSERRATEDONE[1],GT_PCIEUSERRATEDONE[2],GT_PCIEUSERRATEDONE[3],GT_PCIEUSERRATEDONE[4],GT_PCIEUSERRATEDONE[5],GT_PCIEUSERRATEDONE[6],GT_PCIEUSERRATEDONE[7]};
    assign GT_EYESCANDATAERROR    = {eyescandataerror_out[0],eyescandataerror_out[1],eyescandataerror_out[2],eyescandataerror_out[3],eyescandataerror_out[4],eyescandataerror_out[5],eyescandataerror_out[6],eyescandataerror_out[7]};            
    assign GT_PCIEUSERRATESTART   = {pcieuserratestart_out[0],pcieuserratestart_out[1],pcieuserratestart_out[2],pcieuserratestart_out[3],pcieuserratestart_out[4],pcieuserratestart_out[5],pcieuserratestart_out[6],pcieuserratestart_out[7]};                                      
    assign pciersttxsyncstart_in  = {GT_PCIERSTTXSYNCSTART[0],GT_PCIERSTTXSYNCSTART[1],GT_PCIERSTTXSYNCSTART[2],GT_PCIERSTTXSYNCSTART[3],GT_PCIERSTTXSYNCSTART[4],GT_PCIERSTTXSYNCSTART[5],GT_PCIERSTTXSYNCSTART[6],GT_PCIERSTTXSYNCSTART[7]};
    assign GT_PCIESYNCTXSYNCDONE  = {pciesynctxsyncdone_out[0],pciesynctxsyncdone_out[1],pciesynctxsyncdone_out[2],pciesynctxsyncdone_out[3],pciesynctxsyncdone_out[4],pciesynctxsyncdone_out[5],pciesynctxsyncdone_out[6],pciesynctxsyncdone_out[7]};                                      
    assign pcieeqrxeqadaptdone_in = {GT_PCIEEQRXEQADAPTDONE[0],GT_PCIEEQRXEQADAPTDONE[1],GT_PCIEEQRXEQADAPTDONE[2],GT_PCIEEQRXEQADAPTDONE[3],GT_PCIEEQRXEQADAPTDONE[4],GT_PCIEEQRXEQADAPTDONE[5],GT_PCIEEQRXEQADAPTDONE[6],GT_PCIEEQRXEQADAPTDONE[7]};
    assign GT_PCIEUSERPHYSTATUSRST= {pcieuserphystatusrst_out[0],pcieuserphystatusrst_out[1],pcieuserphystatusrst_out[2],pcieuserphystatusrst_out[3],pcieuserphystatusrst_out[4],pcieuserphystatusrst_out[5],pcieuserphystatusrst_out[6],pcieuserphystatusrst_out[7]};                                      

    assign GT_BUFGTCE             = {bufgtce_out[2:0],bufgtce_out[5:3],bufgtce_out[8:6],bufgtce_out[11:9],bufgtce_out[14:12],bufgtce_out[17:15],bufgtce_out[20:18],bufgtce_out[23:21]};                                          
    assign loopback_in            = {GT_LOOPBACK[2:0],GT_LOOPBACK[5:3],GT_LOOPBACK[8:6],GT_LOOPBACK[11:9],GT_LOOPBACK[14:12],GT_LOOPBACK[17:15],GT_LOOPBACK[20:18],GT_LOOPBACK[23:21]};
    assign txmargin_in            = {GT_TXMARGIN[2:0],GT_TXMARGIN[5:3],GT_TXMARGIN[8:6],GT_TXMARGIN[11:9],GT_TXMARGIN[14:12],GT_TXMARGIN[17:15],GT_TXMARGIN[20:18],GT_TXMARGIN[23:21]};
    assign txoutclksel_in         = {GT_TXOUTCLKSEL[2:0],GT_TXOUTCLKSEL[5:3],GT_TXOUTCLKSEL[8:6],GT_TXOUTCLKSEL[11:9],GT_TXOUTCLKSEL[14:12],GT_TXOUTCLKSEL[17:15],GT_TXOUTCLKSEL[20:18],GT_TXOUTCLKSEL[23:21]};
    assign GT_RXSTATUS            = {rxstatus_out[2:0],rxstatus_out[5:3],rxstatus_out[8:6],rxstatus_out[11:9],rxstatus_out[14:12],rxstatus_out[17:15],rxstatus_out[20:18],rxstatus_out[23:21]};                                      
    assign GT_BUFGTRESET          = {bufgtreset_out[2:0],bufgtreset_out[5:3],bufgtreset_out[8:6],bufgtreset_out[11:9],bufgtreset_out[14:12],bufgtreset_out[17:15],bufgtreset_out[20:18],bufgtreset_out[23:21]};                                      
    assign GT_RXBUFSTATUS         = {rxbufstatus_out[2:0],rxbufstatus_out[5:3],rxbufstatus_out[8:6],rxbufstatus_out[11:9],rxbufstatus_out[14:12],rxbufstatus_out[17:15],rxbufstatus_out[20:18],rxbufstatus_out[23:21]};                                                    
    assign GT_BUFGTCEMASK         = {bufgtcemask_out[2:0],bufgtcemask_out[5:3],bufgtcemask_out[8:6],bufgtcemask_out[11:9],bufgtcemask_out[14:12],bufgtcemask_out[17:15],bufgtcemask_out[20:18],bufgtcemask_out[23:21]};                                      
    assign GT_BUFGTRSTMASK        = {bufgtrstmask_out[2:0],bufgtrstmask_out[5:3],bufgtrstmask_out[8:6],bufgtrstmask_out[11:9],bufgtrstmask_out[14:12],bufgtrstmask_out[17:15],bufgtrstmask_out[20:18],bufgtrstmask_out[23:21]};                                      

    assign rxpd_in                = {GT_POWERDOWN[1:0],GT_POWERDOWN[3:2],GT_POWERDOWN[5:4],GT_POWERDOWN[7:6],GT_POWERDOWN[9:8],GT_POWERDOWN[11:10],GT_POWERDOWN[13:12],GT_POWERDOWN[15:14]};
    assign txpd_in                = {GT_POWERDOWN[1:0],GT_POWERDOWN[3:2],GT_POWERDOWN[5:4],GT_POWERDOWN[7:6],GT_POWERDOWN[9:8],GT_POWERDOWN[11:10],GT_POWERDOWN[13:12],GT_POWERDOWN[15:14]};

    assign rxprbssel_in           = {GT_PRBSSEL[3:0],GT_PRBSSEL[7:4],GT_PRBSSEL[11:8],GT_PRBSSEL[15:12],GT_PRBSSEL[19:16],GT_PRBSSEL[23:20],GT_PRBSSEL[27:24],GT_PRBSSEL[31:28]};
    assign txprbssel_in           = {GT_PRBSSEL[3:0],GT_PRBSSEL[7:4],GT_PRBSSEL[11:8],GT_PRBSSEL[15:12],GT_PRBSSEL[19:16],GT_PRBSSEL[23:20],GT_PRBSSEL[27:24],GT_PRBSSEL[31:28]};
    assign txprecursor_in         = {GT_TXPRECURSOR[4:0],GT_TXPRECURSOR[9:5],GT_TXPRECURSOR[14:10],GT_TXPRECURSOR[19:15],GT_TXPRECURSOR[24:20],GT_TXPRECURSOR[29:25],GT_TXPRECURSOR[34:30],GT_TXPRECURSOR[39:35]};
    assign txpostcursor_in        = {GT_TXPOSTCURSOR[4:0],GT_TXPOSTCURSOR[9:5],GT_TXPOSTCURSOR[14:10],GT_TXPOSTCURSOR[19:15],GT_TXPOSTCURSOR[24:20],GT_TXPOSTCURSOR[29:25],GT_TXPOSTCURSOR[34:30],GT_TXPOSTCURSOR[39:35]};
    assign txmaincursor_in        = {GT_TXMAINCURSOR[6:0],GT_TXMAINCURSOR[13:7],GT_TXMAINCURSOR[20:14],GT_TXMAINCURSOR[27:21],GT_TXMAINCURSOR[34:28],GT_TXMAINCURSOR[41:35],GT_TXMAINCURSOR[48:42],GT_TXMAINCURSOR[55:49]};

    assign GT_BUFGTDIV            = {bufgtdiv_out[8:0],bufgtdiv_out[17:9],bufgtdiv_out[26:18],bufgtdiv_out[35:27],bufgtdiv_out[44:36],bufgtdiv_out[53:45],bufgtdiv_out[62:54],bufgtdiv_out[71:63]};                                      
    assign GT_DMONITOROUT         = {dmonitorout_out[16:0],dmonitorout_out[33:17],dmonitorout_out[50:34],dmonitorout_out[67:51],dmonitorout_out[84:68],dmonitorout_out[101:85],dmonitorout_out[118:102],dmonitorout_out[135:119]};     

    assign txdata_in[1023:896]  = {96'd0,GT_TXDATA[31:0]};        // Lane - 0 -to X0Y7                                
    assign txdata_in[895:768]   = {96'd0,GT_TXDATA[63:32]};                                        
    assign txdata_in[767:640]   = {96'd0,GT_TXDATA[95:64]};                                        
    assign txdata_in[639:512]   = {96'd0,GT_TXDATA[127:96]};                                        
    assign txdata_in[511:384]   = {96'd0,GT_TXDATA[159:128]};                                        
    assign txdata_in[383:256]   = {96'd0,GT_TXDATA[191:160]};                                        
    assign txdata_in[255:128]   = {96'd0,GT_TXDATA[223:192]};                                        
    assign txdata_in[127:0]     = {96'd0,GT_TXDATA[255:224]};                                        
                                                                             
    assign txctrl2_in[63:56]    = {6'd0,GT_TXDATAK[1:0]};        // Lane - 0 -to X0Y7
    assign txctrl2_in[55:48]    = {6'd0,GT_TXDATAK[3:2]};
    assign txctrl2_in[47:40]    = {6'd0,GT_TXDATAK[5:4]};
    assign txctrl2_in[39:32]    = {6'd0,GT_TXDATAK[7:6]};
    assign txctrl2_in[31:24]    = {6'd0,GT_TXDATAK[9:8]};
    assign txctrl2_in[23:16]    = {6'd0,GT_TXDATAK[11:10]};
    assign txctrl2_in[15:8]     = {6'd0,GT_TXDATAK[13:12]};
    assign txctrl2_in[7:0]      = {6'd0,GT_TXDATAK[15:14]};
   
    assign txctrl0_in[127:112]  = {10'd0,GT_TXSYNC_HEADER[1:0],GT_TXSTART_BLOCK[0],GT_TXDATA_VALID[0],2'd0};     // Lane - 0 -to X0Y7                                    
    assign txctrl0_in[111:96]   = {10'd0,GT_TXSYNC_HEADER[3:2],GT_TXSTART_BLOCK[1],GT_TXDATA_VALID[1],2'd0};                                      
    assign txctrl0_in[95:80]    = {10'd0,GT_TXSYNC_HEADER[5:4],GT_TXSTART_BLOCK[2],GT_TXDATA_VALID[2],2'd0};                                      
    assign txctrl0_in[79:64]    = {10'd0,GT_TXSYNC_HEADER[7:6],GT_TXSTART_BLOCK[3],GT_TXDATA_VALID[3],2'd0};                                      
    assign txctrl0_in[63:48]    = {10'd0,GT_TXSYNC_HEADER[9:8],GT_TXSTART_BLOCK[4],GT_TXDATA_VALID[4],2'd0};                                      
    assign txctrl0_in[47:32]    = {10'd0,GT_TXSYNC_HEADER[11:10],GT_TXSTART_BLOCK[5],GT_TXDATA_VALID[5],2'd0};                                      
    assign txctrl0_in[31:16]    = {10'd0,GT_TXSYNC_HEADER[13:12],GT_TXSTART_BLOCK[6],GT_TXDATA_VALID[6],2'd0};                                      
    assign txctrl0_in[15:0]     = {10'd0,GT_TXSYNC_HEADER[15:14],GT_TXSTART_BLOCK[7],GT_TXDATA_VALID[7],2'd0};                                      
    
    assign txctrl1_in[127:112]  = {15'd0,GT_TXCOMPLIANCE[0]};                  // Lane - 0 -to X0Y7                    
    assign txctrl1_in[111:96]   = {15'd0,GT_TXCOMPLIANCE[1]};                            
    assign txctrl1_in[95:80]    = {15'd0,GT_TXCOMPLIANCE[2]};                            
    assign txctrl1_in[79:64]    = {15'd0,GT_TXCOMPLIANCE[3]};                            
    assign txctrl1_in[63:48]    = {15'd0,GT_TXCOMPLIANCE[4]};                            
    assign txctrl1_in[47:32]    = {15'd0,GT_TXCOMPLIANCE[5]};                            
    assign txctrl1_in[31:16]    = {15'd0,GT_TXCOMPLIANCE[6]};                            
    assign txctrl1_in[15:0]     = {15'd0,GT_TXCOMPLIANCE[7]};                            
                                                                                          
    assign GT_RXDATA[255:224]  = rxdata_out[31:0];             
    assign GT_RXDATA[223:192]  = rxdata_out[159:128];  
    assign GT_RXDATA[191:160]  = rxdata_out[287:256];  
    assign GT_RXDATA[159:128]  = rxdata_out[415:384];  
    assign GT_RXDATA[127:96]   = rxdata_out[543:512];  
    assign GT_RXDATA[95:64]    = rxdata_out[671:640];  
    assign GT_RXDATA[63:32]    = rxdata_out[799:768];  
    assign GT_RXDATA[31:0]     = rxdata_out[927:896];    // Lane - 0 -to X0Y7 

    assign GT_RXDATAK[15:14]   = rxctrl0_out[1:0];           
    assign GT_RXDATAK[13:12]   = rxctrl0_out[17:16];
    assign GT_RXDATAK[11:10]   = rxctrl0_out[33:32];
    assign GT_RXDATAK[9:8]     = rxctrl0_out[49:48];
    assign GT_RXDATAK[7:6]     = rxctrl0_out[65:64];
    assign GT_RXDATAK[5:4]     = rxctrl0_out[81:80];
    assign GT_RXDATAK[3:2]     = rxctrl0_out[97:96];
    assign GT_RXDATAK[1:0]     = rxctrl0_out[113:112];  // Lane - 0 -to X0Y7 

    assign GT_RXDATA_VALID[7]  = rxctrl0_out[2];           
    assign GT_RXDATA_VALID[6]  = rxctrl0_out[18];
    assign GT_RXDATA_VALID[5]  = rxctrl0_out[34];
    assign GT_RXDATA_VALID[4]  = rxctrl0_out[50];
    assign GT_RXDATA_VALID[3]  = rxctrl0_out[66];
    assign GT_RXDATA_VALID[2]  = rxctrl0_out[82];
    assign GT_RXDATA_VALID[1]  = rxctrl0_out[98];
    assign GT_RXDATA_VALID[0]  = rxctrl0_out[114];   // Lane - 0 -to X0Y7 

    assign GT_RXSTART_BLOCK[7] = rxctrl0_out[3];             
    assign GT_RXSTART_BLOCK[6] = rxctrl0_out[19];
    assign GT_RXSTART_BLOCK[5] = rxctrl0_out[35];
    assign GT_RXSTART_BLOCK[4] = rxctrl0_out[51];
    assign GT_RXSTART_BLOCK[3] = rxctrl0_out[67];
    assign GT_RXSTART_BLOCK[2] = rxctrl0_out[83];
    assign GT_RXSTART_BLOCK[1] = rxctrl0_out[99];
    assign GT_RXSTART_BLOCK[0] = rxctrl0_out[115];  // Lane - 0 -to X0Y7 

    assign GT_RXSYNC_HEADER[15:14] = rxctrl0_out[5:4];           
    assign GT_RXSYNC_HEADER[13:12] = rxctrl0_out[21:20];
    assign GT_RXSYNC_HEADER[11:10] = rxctrl0_out[37:36];
    assign GT_RXSYNC_HEADER[9:8]   = rxctrl0_out[53:52];
    assign GT_RXSYNC_HEADER[7:6]   = rxctrl0_out[69:68];
    assign GT_RXSYNC_HEADER[5:4]   = rxctrl0_out[85:84];
    assign GT_RXSYNC_HEADER[3:2]   = rxctrl0_out[101:100];
    assign GT_RXSYNC_HEADER[1:0]   = rxctrl0_out[117:116]; // Lane - 0 -to X0Y7 

    //----------------------------------------------------------------------------------------------
    //  PHY Quad - Generate one Quad for every four Lanes
    //----------------------------------------------------------------------------------------------
    //  Generate QPLL Powerdown and Reset
    //----------------------------------------------------------------------
    //  * QPLL reset and powerdown for Quad 1 driven by       Master Lane 0
    //  * QPLL reset and powerdown for Quad 2 driven by Local Master Lane 4
    //----------------------------------------------------------------------        
    assign qpll1pd_in[0]    = (GTCOM_QPLL1PD[1]    || pcierateqpllpd_out[8]);     // Quad-X0Y0 - 1
    assign qpll1reset_in[0] = (GTCOM_QPLL1RESET[1] || pcierateqpllreset_out[8]);  // Quad-X0Y0 - 1
    assign qpll1pd_in[1]    = (GTCOM_QPLL1PD[0]    || pcierateqpllpd_out[0]);     // Quad-X0Y1 - 0
    assign qpll1reset_in[1] = (GTCOM_QPLL1RESET[0] || pcierateqpllreset_out[0]);  // Quad-X0Y1 - 0
             
    assign qpllrsvd2_3     = {{2'd0,1'd1, GT_RATE[1:0]},{2'd0,1'd1, GT_RATE[1:0]}};   // From [TX/RX]RATE port
    //----------------------------------------------------------------------        
    assign GT_CPLLLOCK          = {cplllock_out[0],cplllock_out[1],cplllock_out[2],cplllock_out[3],cplllock_out[4],cplllock_out[5],cplllock_out[6],cplllock_out[7]};
    assign GT_PCIERATEQPLLPD    = {pcierateqpllpd_out[1:0],pcierateqpllpd_out[3:2],pcierateqpllpd_out[5:4],pcierateqpllpd_out[7:6],pcierateqpllpd_out[9:8],pcierateqpllpd_out[11:10],pcierateqpllpd_out[13:12],pcierateqpllpd_out[15:14]};              
    assign GT_PCIERATEQPLLRESET = {pcierateqpllreset_out[1:0],pcierateqpllreset_out[3:2],pcierateqpllreset_out[5:4],pcierateqpllreset_out[7:6],pcierateqpllreset_out[9:8],pcierateqpllreset_out[11:10],pcierateqpllreset_out[13:12],pcierateqpllreset_out[15:14]};    

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    assign GTCOM_QPLL1LOCK      = qpll1lock_out;
    assign GTCOM_QPLL1OUTCLK    = qpll1outclk_out;
    assign GTCOM_QPLL1OUTREFCLK = qpll1outrefclk_out;
    assign GTCOM_DRPRDY = 0;    
    assign GTCOM_DRPDO  = 0;         

genvar k;                                                                                                      
generate for (k=0; k<PHY_LANE; k=k+1)                                                      
  begin : new_sigs
    assign GT_RXRATEDONE[k]     = rxratedone_out[((PHY_LANE-1)-k)];
  end
endgenerate

   assign rxdfeagchold_in = rxcdrhold_in;  
   assign rxdfecfokhold_in = rxcdrhold_in; 
   assign rxdfelfhold_in = rxcdrhold_in;   
   assign rxdfekhhold_in = rxcdrhold_in;             
   assign rxdfetap2hold_in = rxcdrhold_in;        
   assign rxdfetap3hold_in = rxcdrhold_in;        
   assign rxdfetap4hold_in = rxcdrhold_in;       
   assign rxdfetap5hold_in = rxcdrhold_in;           
   assign rxdfetap6hold_in = rxcdrhold_in;       
   assign rxdfetap7hold_in = rxcdrhold_in;        
   assign rxdfetap8hold_in = rxcdrhold_in;       
   assign rxdfetap9hold_in = rxcdrhold_in;       
   assign rxdfetap10hold_in = rxcdrhold_in;       
   assign rxdfetap11hold_in = rxcdrhold_in;       
   assign rxdfetap12hold_in = rxcdrhold_in;        
   assign rxdfetap13hold_in = rxcdrhold_in;       
   assign rxdfetap14hold_in = rxcdrhold_in;       
   assign rxdfetap15hold_in = rxcdrhold_in;       
   assign rxdfeuthold_in = rxcdrhold_in;             
   assign rxdfevphold_in = rxcdrhold_in;             
   assign rxoshold_in = rxcdrhold_in;                  
   assign rxlpmgchold_in = rxcdrhold_in;              
   assign rxlpmhfhold_in = rxcdrhold_in;            
   assign rxlpmlfhold_in = rxcdrhold_in;              
   assign rxlpmoshold_in = rxcdrhold_in;  

endmodule
