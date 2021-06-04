`timescale 1ns / 1ps
/**
* NVMeCHA: NVMe Controller featuring Hardware Acceleration
* Copyright (C) 2021 State Key Laboratory of ASIC and System, Fudan University
* Contributed by Yunhui Qiu
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

//////////////////////////////////////////////////////////////////////////////////
// Company:  State Key Laboratory of ASIC and System, Fudan University
// Engineer: Yunhui Qiu
// 
// Create Date: 10/11/2020 
// Design Name: 
// Module Name: nvme_top
// Project Name: NVMe Controller
// Target Devices: 
// Tool Versions: 
// Description: Top module
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define NVME_ADMIN_USE_PS        // NVMe Admin Controller implemented by PL+PS
//`define SIMULATION             // PCIe Vendor ID change
//`define NVME_ADMIN_ONLY          // Only have NVMe Admin Command Controller
//`define NVME_IO_ONE              // one IO controller
//`define NVME_IO_SIXTEEN
`define NVME_IO_EIGHT
`include "nvme_param.vh"

module nvme_top#
  (
   parameter PL_LINK_CAP_MAX_LINK_WIDTH          = 8,            // 1- X1; 2 - X2; 4 - X4; 8 - X8
   parameter PL_SIM_FAST_LINK_TRAINING           = "FALSE",      // Simulation Speedup
   parameter PL_LINK_CAP_MAX_LINK_SPEED          = 4,             // 1- GEN1; 2 - GEN2; 4 - GEN3
   parameter C_DATA_WIDTH                        = 256 ,
   parameter EXT_PIPE_SIM                        = "FALSE",      // This Parameter has effect on selecting Enable External PIPE Interface in GUI.
   parameter C_ROOT_PORT                         = "FALSE",      // PCIe block is in root port mode
   parameter C_DEVICE_NUMBER                     = 0            // Device number for Root Port configurations only
   )
   (
    output [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0] pci_exp_txp,
    output [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0] pci_exp_txn,
    input [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  pci_exp_rxp,
    input [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  pci_exp_rxn,


    // synthesis translate_off
    input   [25:0]                common_commands_in,
    input   [83:0]                pipe_rx_0_sigs,
    input   [83:0]                pipe_rx_1_sigs,
    input   [83:0]                pipe_rx_2_sigs,
    input   [83:0]                pipe_rx_3_sigs,
    input   [83:0]                pipe_rx_4_sigs,
    input   [83:0]                pipe_rx_5_sigs,
    input   [83:0]                pipe_rx_6_sigs,
    input   [83:0]                pipe_rx_7_sigs,
    output  [25:0]                common_commands_out,
    output  [83:0]                pipe_tx_0_sigs,
    output  [83:0]                pipe_tx_1_sigs,
    output  [83:0]                pipe_tx_2_sigs,
    output  [83:0]                pipe_tx_3_sigs,
    output  [83:0]                pipe_tx_4_sigs,
    output  [83:0]                pipe_tx_5_sigs,
    output  [83:0]                pipe_tx_6_sigs,
    output  [83:0]                pipe_tx_7_sigs,
    // synthesis translate_on   
`ifdef NVME_ADMIN_USE_PS    
    input                         ps_clk_clk_n,
    input                         ps_clk_clk_p,
    input                         reset,
    // UART Ports
    input                         UART_0_rxd,
    output                        UART_0_txd,
`endif

    output                        led_0,
    output                        led_1,
    output                        led_2,
    output                        led_3,
    input                         sys_clk_p,
    input                         sys_clk_n,
    input                         sys_rst_n
 );

   //-----------------------------------------------------------------------------------------------------------------------

   
   // Local Parameters derived from user selection
   localparam integer 				   USER_CLK_FREQ         = ((PL_LINK_CAP_MAX_LINK_SPEED == 3'h4) ? 5 : 4);
//   localparam TCQ = 1;
   localparam C_S_AXI_ID_WIDTH = 4; 
   localparam C_M_AXI_ID_WIDTH = 4; 
   localparam C_S_AXI_DATA_WIDTH = C_DATA_WIDTH;
   localparam C_M_AXI_DATA_WIDTH = C_DATA_WIDTH;
   localparam C_S_AXI_ADDR_WIDTH = 64;
   localparam C_M_AXI_ADDR_WIDTH = 64;
   localparam C_NUM_USR_IRQ	 = 16;
   
`ifdef NVME_IO_EIGHT
   localparam NUM_IOCQ_IRQ	 = 8;
`elsif NVME_IO_SIXTEEN
    localparam NUM_IOCQ_IRQ	 = 16;
`else
    localparam NUM_IOCQ_IRQ	 = 1;
`endif

   
  //----------------------------------------------------------------------------------------------------------------//
  //    System(SYS) Interface                                                                                       //
  //----------------------------------------------------------------------------------------------------------------//

   wire                                    sys_clk;
   wire                                    sys_rst_n_c;
   wire                                    dma_soft_rstn; // DMA soft resetn
   // User Clock LED Heartbeat
   reg [25:0]                              user_clk_heartbeat;
//   reg [((2*C_NUM_USR_IRQ)-1):0]           usr_irq_function_number=0;
   wire [C_NUM_USR_IRQ-1:0]                xdma_irq_req;
   wire [C_NUM_USR_IRQ-1:0]                xdma_irq_ack;
   wire                                    msix_enable;
   wire [2:0]                              msi_vector_width;
   wire                                    msi_enable;

   wire [31:0]                             irq_mask; // Not used for MSI-X Interrupt
   wire [NUM_IOCQ_IRQ-1:0]                 usr_irq_enable;  
//   wire [NUM_IOCQ_IRQ-1:0]                 usr_irq_req;
//   wire [NUM_IOCQ_IRQ-1:0]                 usr_irq_ack;

   wire 					               user_lnk_up;
   
   //  // Wires for Avery HOT/WARM and COLD RESET
   //   wire                        avy_sys_rst_n_c;
   //   wire                        avy_cfg_hot_reset_out;
   //   reg                            avy_sys_rst_n_g;
   //   reg                            avy_cfg_hot_reset_out_g;
   //   assign avy_sys_rst_n_c = avy_sys_rst_n_g;
   //   assign avy_cfg_hot_reset_out = avy_cfg_hot_reset_out_g;
   //   initial begin 
   //      avy_sys_rst_n_g = 1;
   //      avy_cfg_hot_reset_out_g =0;
   //   end
   
   //----------------------------------------------------------------------------------------------------------------//
   //  AXI Interface                                                                                                 //
   //----------------------------------------------------------------------------------------------------------------//
   
   wire 					   user_clk;
   wire 					   user_resetn;
   wire                        xdma_user_resetn;
   


////////////////// AXI-LITE ///////////////////////////
   //-- AXI Master Write Address Channel
    wire [31:0]  m_axil_awaddr;
    wire [ 2:0]  m_axil_awprot;
    wire 	     m_axil_awvalid;
    wire 	     m_axil_awready;

    //-- AXI Master Write Data Channel
    wire [31:0]  m_axil_wdata;
    wire [ 3:0]  m_axil_wstrb;
    wire 	     m_axil_wvalid;
    wire 	     m_axil_wready;
    //-- AXI Master Write Response Channel
    wire 	     m_axil_bvalid;
    wire 	     m_axil_bready;
    wire [ 1:0]  m_axil_bresp;
    //-- AXI Master Read Address Channel
    wire [31:0]  m_axil_araddr;
    wire [ 2:0]  m_axil_arprot;
    wire 	     m_axil_arvalid;
    wire 	     m_axil_arready;
    //-- AXI Master Read Data Channel
    wire [31:0]  m_axil_rdata;
    wire [ 1:0]  m_axil_rresp;
    wire 	     m_axil_rvalid;
    wire 	     m_axil_rready;
    
    // AXI-Lite Slave
    wire [31 : 0] s_axil_awaddr;
    wire [ 2 : 0] s_axil_awprot;
    wire          s_axil_awvalid;
    wire          s_axil_awready;
    wire [31 : 0] s_axil_wdata;
    wire [ 3 : 0] s_axil_wstrb;
    wire          s_axil_wvalid;
    wire          s_axil_wready;
    wire          s_axil_bvalid;
    wire [ 1 : 0] s_axil_bresp;
    wire          s_axil_bready;
    wire [31 : 0] s_axil_araddr;
    wire [ 2 : 0] s_axil_arprot;
    wire          s_axil_arvalid;
    wire          s_axil_arready;
    wire [31 : 0] s_axil_rdata;
    wire [ 1 : 0] s_axil_rresp;
    wire          s_axil_rvalid;
    wire          s_axil_rready;

   
   // AXI ST interface to user, H2C Channel
    wire [C_DATA_WIDTH-1:0]     m_axis_h2c_tdata_0;
    wire                        m_axis_h2c_tlast_0;
    wire                        m_axis_h2c_tvalid_0;
    wire                        m_axis_h2c_tready_0;
//    wire [C_DATA_WIDTH/8-1:0]   m_axis_h2c_tuser_0;
    wire [C_DATA_WIDTH/8-1:0]   m_axis_h2c_tkeep_0;

    wire [C_DATA_WIDTH-1:0]     m_axis_h2c_tdata_1;
    wire                        m_axis_h2c_tlast_1;
    wire                        m_axis_h2c_tvalid_1;
    wire                        m_axis_h2c_tready_1;
//    wire [C_DATA_WIDTH/8-1:0]   m_axis_h2c_tuser_1;
    wire [C_DATA_WIDTH/8-1:0]   m_axis_h2c_tkeep_1;
    
    wire [C_DATA_WIDTH-1:0]     m_axis_h2c_tdata_2;
    wire                        m_axis_h2c_tlast_2;
    wire                        m_axis_h2c_tvalid_2;
    wire                        m_axis_h2c_tready_2;
//    wire [C_DATA_WIDTH/8-1:0]   m_axis_h2c_tuser_2;
    wire [C_DATA_WIDTH/8-1:0]   m_axis_h2c_tkeep_2;
    
    wire [C_DATA_WIDTH-1:0]     m_axis_h2c_tdata_3;
    wire                        m_axis_h2c_tlast_3;
    wire                        m_axis_h2c_tvalid_3;
    wire                        m_axis_h2c_tready_3;
//    wire [C_DATA_WIDTH/8-1:0]   m_axis_h2c_tuser_3;
    wire [C_DATA_WIDTH/8-1:0]   m_axis_h2c_tkeep_3;
    
    
   // AXI ST interface to user, C2H Channel
    wire [C_DATA_WIDTH-1:0]     m_axis_c2h_tdata_0;
    wire                        m_axis_c2h_tlast_0;
    wire                        m_axis_c2h_tvalid_0;
    wire                        m_axis_c2h_tready_0;
//    wire [C_DATA_WIDTH/8-1:0]   m_axis_c2h_tuser_0;
    wire [C_DATA_WIDTH/8-1:0]   m_axis_c2h_tkeep_0;

    wire [C_DATA_WIDTH-1:0]     m_axis_c2h_tdata_1;
    wire                        m_axis_c2h_tlast_1;
    wire                        m_axis_c2h_tvalid_1;
    wire                        m_axis_c2h_tready_1;
//    wire [C_DATA_WIDTH/8-1:0]   m_axis_c2h_tuser_1;
    wire [C_DATA_WIDTH/8-1:0]   m_axis_c2h_tkeep_1;

    wire [C_DATA_WIDTH-1:0]     m_axis_c2h_tdata_2;
    wire                        m_axis_c2h_tlast_2;
    wire                        m_axis_c2h_tvalid_2;
    wire                        m_axis_c2h_tready_2;
//    wire [C_DATA_WIDTH/8-1:0]   m_axis_c2h_tuser_2;
    wire [C_DATA_WIDTH/8-1:0]   m_axis_c2h_tkeep_2;
    
    wire [C_DATA_WIDTH-1:0]     m_axis_c2h_tdata_3;
    wire                        m_axis_c2h_tlast_3;
    wire                        m_axis_c2h_tvalid_3;
    wire                        m_axis_c2h_tready_3;
//    wire [C_DATA_WIDTH/8-1:0]   m_axis_c2h_tuser_3;
    wire [C_DATA_WIDTH/8-1:0]   m_axis_c2h_tkeep_3;

   
   
    wire          c2h_dsc_byp_ready_0;   
    wire [63 : 0] c2h_dsc_byp_src_addr_0;   
    wire [63 : 0] c2h_dsc_byp_dst_addr_0;   
    wire [27 : 0] c2h_dsc_byp_len_0;   
    wire [15 : 0] c2h_dsc_byp_ctl_0;   
    wire          c2h_dsc_byp_load_0;   
     
    wire          h2c_dsc_byp_ready_0;   
    wire [63 : 0] h2c_dsc_byp_src_addr_0;   
    wire [63 : 0] h2c_dsc_byp_dst_addr_0;   
    wire [27 : 0] h2c_dsc_byp_len_0;   
    wire [15 : 0] h2c_dsc_byp_ctl_0;   
    wire          h2c_dsc_byp_load_0;   
    
    wire          c2h_dsc_byp_ready_1;   
    wire [63 : 0] c2h_dsc_byp_src_addr_1;   
    wire [63 : 0] c2h_dsc_byp_dst_addr_1;   
    wire [27 : 0] c2h_dsc_byp_len_1;   
    wire [15 : 0] c2h_dsc_byp_ctl_1;   
    wire          c2h_dsc_byp_load_1;  
    
    wire          h2c_dsc_byp_ready_1;   
    wire [63 : 0] h2c_dsc_byp_src_addr_1;   
    wire [63 : 0] h2c_dsc_byp_dst_addr_1;   
    wire [27 : 0] h2c_dsc_byp_len_1;   
    wire [15 : 0] h2c_dsc_byp_ctl_1;   
    wire          h2c_dsc_byp_load_1;   
      
    wire          c2h_dsc_byp_ready_2;   
    wire [63 : 0] c2h_dsc_byp_src_addr_2;   
    wire [63 : 0] c2h_dsc_byp_dst_addr_2;   
    wire [27 : 0] c2h_dsc_byp_len_2;   
    wire [15 : 0] c2h_dsc_byp_ctl_2;   
    wire          c2h_dsc_byp_load_2;   
     
    wire          h2c_dsc_byp_ready_2;   
    wire [63 : 0] h2c_dsc_byp_src_addr_2;   
    wire [63 : 0] h2c_dsc_byp_dst_addr_2;   
    wire [27 : 0] h2c_dsc_byp_len_2;   
    wire [15 : 0] h2c_dsc_byp_ctl_2;   
    wire          h2c_dsc_byp_load_2;   
    
    wire          c2h_dsc_byp_ready_3;   
    wire [63 : 0] c2h_dsc_byp_src_addr_3;   
    wire [63 : 0] c2h_dsc_byp_dst_addr_3;   
    wire [27 : 0] c2h_dsc_byp_len_3;   
    wire [15 : 0] c2h_dsc_byp_ctl_3;   
    wire          c2h_dsc_byp_load_3;   
     
    wire          h2c_dsc_byp_ready_3;   
    wire [63 : 0] h2c_dsc_byp_src_addr_3;   
    wire [63 : 0] h2c_dsc_byp_dst_addr_3;   
    wire [27 : 0] h2c_dsc_byp_len_3;   
    wire [15 : 0] h2c_dsc_byp_ctl_3;   
    wire          h2c_dsc_byp_load_3; 

`ifndef NVME_IO_ONE   
    wire                       a_c2h_dsc_byp_ready_0;   
    wire                       a_c2h_dsc_byp_load_0; 
    wire [63 : 0]              a_c2h_dsc_byp_src_addr_0;   
    wire [63 : 0]              a_c2h_dsc_byp_dst_addr_0;   
    wire [27 : 0]              a_c2h_dsc_byp_len_0;   
    wire [15 : 0]              a_c2h_dsc_byp_ctl_0; 
   
    wire                       a_axis_c2h_tready_0;
    wire                       a_axis_c2h_tvalid_0;
    wire [C_DATA_WIDTH-1:0]    a_axis_c2h_tdata_0;
    wire [C_DATA_WIDTH/8-1:0]  a_axis_c2h_tkeep_0;
    wire                       a_axis_c2h_tlast_0; 

    wire                       a_h2c_dsc_byp_ready_0;   
    wire                       a_h2c_dsc_byp_load_0; 
    wire [63 : 0]              a_h2c_dsc_byp_src_addr_0;   
    wire [63 : 0]              a_h2c_dsc_byp_dst_addr_0;   
    wire [27 : 0]              a_h2c_dsc_byp_len_0;   
    wire [15 : 0]              a_h2c_dsc_byp_ctl_0; 
   
    wire                       a_axis_h2c_tready_0;
    wire                       a_axis_h2c_tvalid_0;
    wire [C_DATA_WIDTH-1:0]    a_axis_h2c_tdata_0;
    wire [C_DATA_WIDTH/8-1:0]  a_axis_h2c_tkeep_0;
    wire                       a_axis_h2c_tlast_0;       
    
    wire                       q_c2h_dsc_byp_ready_1;   
    wire                       q_c2h_dsc_byp_load_1; 
    wire [63 : 0]              q_c2h_dsc_byp_src_addr_1;   
    wire [63 : 0]              q_c2h_dsc_byp_dst_addr_1;   
    wire [27 : 0]              q_c2h_dsc_byp_len_1;   
    wire [15 : 0]              q_c2h_dsc_byp_ctl_1;    
    wire                       q_axis_c2h_tready_1;
    wire                       q_axis_c2h_tvalid_1;
    wire [C_DATA_WIDTH-1:0]    q_axis_c2h_tdata_1;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_c2h_tkeep_1;
    wire                       q_axis_c2h_tlast_1;    
        
    wire                       q_h2c_dsc_byp_ready_1;   
    wire                       q_h2c_dsc_byp_load_1; 
    wire [63 : 0]              q_h2c_dsc_byp_src_addr_1;   
    wire [63 : 0]              q_h2c_dsc_byp_dst_addr_1;   
    wire [27 : 0]              q_h2c_dsc_byp_len_1;   
    wire [15 : 0]              q_h2c_dsc_byp_ctl_1;    
    wire                       q_axis_h2c_tready_1;
    wire                       q_axis_h2c_tvalid_1;
    wire [C_DATA_WIDTH-1:0]    q_axis_h2c_tdata_1;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_h2c_tkeep_1;
    wire                       q_axis_h2c_tlast_1; 

    wire                       d_c2h_dsc_byp_ready_1;   
    wire                       d_c2h_dsc_byp_load_1; 
    wire [63 : 0]              d_c2h_dsc_byp_src_addr_1;   
    wire [63 : 0]              d_c2h_dsc_byp_dst_addr_1;   
    wire [27 : 0]              d_c2h_dsc_byp_len_1;   
    wire [15 : 0]              d_c2h_dsc_byp_ctl_1;    
    wire                       d_axis_c2h_tready_1;
    wire                       d_axis_c2h_tvalid_1;
    wire [C_DATA_WIDTH-1:0]    d_axis_c2h_tdata_1;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_c2h_tkeep_1;
    wire                       d_axis_c2h_tlast_1;    
        
    wire                       d_h2c_dsc_byp_ready_1;   
    wire                       d_h2c_dsc_byp_load_1; 
    wire [63 : 0]              d_h2c_dsc_byp_src_addr_1;   
    wire [63 : 0]              d_h2c_dsc_byp_dst_addr_1;   
    wire [27 : 0]              d_h2c_dsc_byp_len_1;   
    wire [15 : 0]              d_h2c_dsc_byp_ctl_1;    
    wire                       d_axis_h2c_tready_1;
    wire                       d_axis_h2c_tvalid_1;
    wire [C_DATA_WIDTH-1:0]    d_axis_h2c_tdata_1;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_h2c_tkeep_1;
    wire                       d_axis_h2c_tlast_1; 
    wire                       q_c2h_dsc_byp_ready_2;   
    wire                       q_c2h_dsc_byp_load_2; 
    wire [63 : 0]              q_c2h_dsc_byp_src_addr_2;   
    wire [63 : 0]              q_c2h_dsc_byp_dst_addr_2;   
    wire [27 : 0]              q_c2h_dsc_byp_len_2;   
    wire [15 : 0]              q_c2h_dsc_byp_ctl_2;    
    wire                       q_axis_c2h_tready_2;
    wire                       q_axis_c2h_tvalid_2;
    wire [C_DATA_WIDTH-1:0]    q_axis_c2h_tdata_2;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_c2h_tkeep_2;
    wire                       q_axis_c2h_tlast_2;    
        
    wire                       q_h2c_dsc_byp_ready_2;   
    wire                       q_h2c_dsc_byp_load_2; 
    wire [63 : 0]              q_h2c_dsc_byp_src_addr_2;   
    wire [63 : 0]              q_h2c_dsc_byp_dst_addr_2;   
    wire [27 : 0]              q_h2c_dsc_byp_len_2;   
    wire [15 : 0]              q_h2c_dsc_byp_ctl_2;    
    wire                       q_axis_h2c_tready_2;
    wire                       q_axis_h2c_tvalid_2;
    wire [C_DATA_WIDTH-1:0]    q_axis_h2c_tdata_2;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_h2c_tkeep_2;
    wire                       q_axis_h2c_tlast_2; 

    wire                       d_c2h_dsc_byp_ready_2;   
    wire                       d_c2h_dsc_byp_load_2; 
    wire [63 : 0]              d_c2h_dsc_byp_src_addr_2;   
    wire [63 : 0]              d_c2h_dsc_byp_dst_addr_2;   
    wire [27 : 0]              d_c2h_dsc_byp_len_2;   
    wire [15 : 0]              d_c2h_dsc_byp_ctl_2;    
    wire                       d_axis_c2h_tready_2;
    wire                       d_axis_c2h_tvalid_2;
    wire [C_DATA_WIDTH-1:0]    d_axis_c2h_tdata_2;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_c2h_tkeep_2;
    wire                       d_axis_c2h_tlast_2;    
        
    wire                       d_h2c_dsc_byp_ready_2;   
    wire                       d_h2c_dsc_byp_load_2; 
    wire [63 : 0]              d_h2c_dsc_byp_src_addr_2;   
    wire [63 : 0]              d_h2c_dsc_byp_dst_addr_2;   
    wire [27 : 0]              d_h2c_dsc_byp_len_2;   
    wire [15 : 0]              d_h2c_dsc_byp_ctl_2;    
    wire                       d_axis_h2c_tready_2;
    wire                       d_axis_h2c_tvalid_2;
    wire [C_DATA_WIDTH-1:0]    d_axis_h2c_tdata_2;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_h2c_tkeep_2;
    wire                       d_axis_h2c_tlast_2; 
    wire                       q_c2h_dsc_byp_ready_3;   
    wire                       q_c2h_dsc_byp_load_3; 
    wire [63 : 0]              q_c2h_dsc_byp_src_addr_3;   
    wire [63 : 0]              q_c2h_dsc_byp_dst_addr_3;   
    wire [27 : 0]              q_c2h_dsc_byp_len_3;   
    wire [15 : 0]              q_c2h_dsc_byp_ctl_3;    
    wire                       q_axis_c2h_tready_3;
    wire                       q_axis_c2h_tvalid_3;
    wire [C_DATA_WIDTH-1:0]    q_axis_c2h_tdata_3;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_c2h_tkeep_3;
    wire                       q_axis_c2h_tlast_3;    
        
    wire                       q_h2c_dsc_byp_ready_3;   
    wire                       q_h2c_dsc_byp_load_3; 
    wire [63 : 0]              q_h2c_dsc_byp_src_addr_3;   
    wire [63 : 0]              q_h2c_dsc_byp_dst_addr_3;   
    wire [27 : 0]              q_h2c_dsc_byp_len_3;   
    wire [15 : 0]              q_h2c_dsc_byp_ctl_3;    
    wire                       q_axis_h2c_tready_3;
    wire                       q_axis_h2c_tvalid_3;
    wire [C_DATA_WIDTH-1:0]    q_axis_h2c_tdata_3;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_h2c_tkeep_3;
    wire                       q_axis_h2c_tlast_3; 

    wire                       d_c2h_dsc_byp_ready_3;   
    wire                       d_c2h_dsc_byp_load_3; 
    wire [63 : 0]              d_c2h_dsc_byp_src_addr_3;   
    wire [63 : 0]              d_c2h_dsc_byp_dst_addr_3;   
    wire [27 : 0]              d_c2h_dsc_byp_len_3;   
    wire [15 : 0]              d_c2h_dsc_byp_ctl_3;    
    wire                       d_axis_c2h_tready_3;
    wire                       d_axis_c2h_tvalid_3;
    wire [C_DATA_WIDTH-1:0]    d_axis_c2h_tdata_3;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_c2h_tkeep_3;
    wire                       d_axis_c2h_tlast_3;    
        
    wire                       d_h2c_dsc_byp_ready_3;   
    wire                       d_h2c_dsc_byp_load_3; 
    wire [63 : 0]              d_h2c_dsc_byp_src_addr_3;   
    wire [63 : 0]              d_h2c_dsc_byp_dst_addr_3;   
    wire [27 : 0]              d_h2c_dsc_byp_len_3;   
    wire [15 : 0]              d_h2c_dsc_byp_ctl_3;    
    wire                       d_axis_h2c_tready_3;
    wire                       d_axis_h2c_tvalid_3;
    wire [C_DATA_WIDTH-1:0]    d_axis_h2c_tdata_3;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_h2c_tkeep_3;
    wire                       d_axis_h2c_tlast_3; 
    wire                       q_c2h_dsc_byp_ready_4;   
    wire                       q_c2h_dsc_byp_load_4; 
    wire [63 : 0]              q_c2h_dsc_byp_src_addr_4;   
    wire [63 : 0]              q_c2h_dsc_byp_dst_addr_4;   
    wire [27 : 0]              q_c2h_dsc_byp_len_4;   
    wire [15 : 0]              q_c2h_dsc_byp_ctl_4;    
    wire                       q_axis_c2h_tready_4;
    wire                       q_axis_c2h_tvalid_4;
    wire [C_DATA_WIDTH-1:0]    q_axis_c2h_tdata_4;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_c2h_tkeep_4;
    wire                       q_axis_c2h_tlast_4;    
        
    wire                       q_h2c_dsc_byp_ready_4;   
    wire                       q_h2c_dsc_byp_load_4; 
    wire [63 : 0]              q_h2c_dsc_byp_src_addr_4;   
    wire [63 : 0]              q_h2c_dsc_byp_dst_addr_4;   
    wire [27 : 0]              q_h2c_dsc_byp_len_4;   
    wire [15 : 0]              q_h2c_dsc_byp_ctl_4;    
    wire                       q_axis_h2c_tready_4;
    wire                       q_axis_h2c_tvalid_4;
    wire [C_DATA_WIDTH-1:0]    q_axis_h2c_tdata_4;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_h2c_tkeep_4;
    wire                       q_axis_h2c_tlast_4; 

    wire                       d_c2h_dsc_byp_ready_4;   
    wire                       d_c2h_dsc_byp_load_4; 
    wire [63 : 0]              d_c2h_dsc_byp_src_addr_4;   
    wire [63 : 0]              d_c2h_dsc_byp_dst_addr_4;   
    wire [27 : 0]              d_c2h_dsc_byp_len_4;   
    wire [15 : 0]              d_c2h_dsc_byp_ctl_4;    
    wire                       d_axis_c2h_tready_4;
    wire                       d_axis_c2h_tvalid_4;
    wire [C_DATA_WIDTH-1:0]    d_axis_c2h_tdata_4;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_c2h_tkeep_4;
    wire                       d_axis_c2h_tlast_4;    
        
    wire                       d_h2c_dsc_byp_ready_4;   
    wire                       d_h2c_dsc_byp_load_4; 
    wire [63 : 0]              d_h2c_dsc_byp_src_addr_4;   
    wire [63 : 0]              d_h2c_dsc_byp_dst_addr_4;   
    wire [27 : 0]              d_h2c_dsc_byp_len_4;   
    wire [15 : 0]              d_h2c_dsc_byp_ctl_4;    
    wire                       d_axis_h2c_tready_4;
    wire                       d_axis_h2c_tvalid_4;
    wire [C_DATA_WIDTH-1:0]    d_axis_h2c_tdata_4;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_h2c_tkeep_4;
    wire                       d_axis_h2c_tlast_4; 
    wire                       q_c2h_dsc_byp_ready_5;   
    wire                       q_c2h_dsc_byp_load_5; 
    wire [63 : 0]              q_c2h_dsc_byp_src_addr_5;   
    wire [63 : 0]              q_c2h_dsc_byp_dst_addr_5;   
    wire [27 : 0]              q_c2h_dsc_byp_len_5;   
    wire [15 : 0]              q_c2h_dsc_byp_ctl_5;    
    wire                       q_axis_c2h_tready_5;
    wire                       q_axis_c2h_tvalid_5;
    wire [C_DATA_WIDTH-1:0]    q_axis_c2h_tdata_5;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_c2h_tkeep_5;
    wire                       q_axis_c2h_tlast_5;    
        
    wire                       q_h2c_dsc_byp_ready_5;   
    wire                       q_h2c_dsc_byp_load_5; 
    wire [63 : 0]              q_h2c_dsc_byp_src_addr_5;   
    wire [63 : 0]              q_h2c_dsc_byp_dst_addr_5;   
    wire [27 : 0]              q_h2c_dsc_byp_len_5;   
    wire [15 : 0]              q_h2c_dsc_byp_ctl_5;    
    wire                       q_axis_h2c_tready_5;
    wire                       q_axis_h2c_tvalid_5;
    wire [C_DATA_WIDTH-1:0]    q_axis_h2c_tdata_5;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_h2c_tkeep_5;
    wire                       q_axis_h2c_tlast_5; 

    wire                       d_c2h_dsc_byp_ready_5;   
    wire                       d_c2h_dsc_byp_load_5; 
    wire [63 : 0]              d_c2h_dsc_byp_src_addr_5;   
    wire [63 : 0]              d_c2h_dsc_byp_dst_addr_5;   
    wire [27 : 0]              d_c2h_dsc_byp_len_5;   
    wire [15 : 0]              d_c2h_dsc_byp_ctl_5;    
    wire                       d_axis_c2h_tready_5;
    wire                       d_axis_c2h_tvalid_5;
    wire [C_DATA_WIDTH-1:0]    d_axis_c2h_tdata_5;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_c2h_tkeep_5;
    wire                       d_axis_c2h_tlast_5;    
        
    wire                       d_h2c_dsc_byp_ready_5;   
    wire                       d_h2c_dsc_byp_load_5; 
    wire [63 : 0]              d_h2c_dsc_byp_src_addr_5;   
    wire [63 : 0]              d_h2c_dsc_byp_dst_addr_5;   
    wire [27 : 0]              d_h2c_dsc_byp_len_5;   
    wire [15 : 0]              d_h2c_dsc_byp_ctl_5;    
    wire                       d_axis_h2c_tready_5;
    wire                       d_axis_h2c_tvalid_5;
    wire [C_DATA_WIDTH-1:0]    d_axis_h2c_tdata_5;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_h2c_tkeep_5;
    wire                       d_axis_h2c_tlast_5; 
    wire                       q_c2h_dsc_byp_ready_6;   
    wire                       q_c2h_dsc_byp_load_6; 
    wire [63 : 0]              q_c2h_dsc_byp_src_addr_6;   
    wire [63 : 0]              q_c2h_dsc_byp_dst_addr_6;   
    wire [27 : 0]              q_c2h_dsc_byp_len_6;   
    wire [15 : 0]              q_c2h_dsc_byp_ctl_6;    
    wire                       q_axis_c2h_tready_6;
    wire                       q_axis_c2h_tvalid_6;
    wire [C_DATA_WIDTH-1:0]    q_axis_c2h_tdata_6;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_c2h_tkeep_6;
    wire                       q_axis_c2h_tlast_6;    
        
    wire                       q_h2c_dsc_byp_ready_6;   
    wire                       q_h2c_dsc_byp_load_6; 
    wire [63 : 0]              q_h2c_dsc_byp_src_addr_6;   
    wire [63 : 0]              q_h2c_dsc_byp_dst_addr_6;   
    wire [27 : 0]              q_h2c_dsc_byp_len_6;   
    wire [15 : 0]              q_h2c_dsc_byp_ctl_6;    
    wire                       q_axis_h2c_tready_6;
    wire                       q_axis_h2c_tvalid_6;
    wire [C_DATA_WIDTH-1:0]    q_axis_h2c_tdata_6;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_h2c_tkeep_6;
    wire                       q_axis_h2c_tlast_6; 

    wire                       d_c2h_dsc_byp_ready_6;   
    wire                       d_c2h_dsc_byp_load_6; 
    wire [63 : 0]              d_c2h_dsc_byp_src_addr_6;   
    wire [63 : 0]              d_c2h_dsc_byp_dst_addr_6;   
    wire [27 : 0]              d_c2h_dsc_byp_len_6;   
    wire [15 : 0]              d_c2h_dsc_byp_ctl_6;    
    wire                       d_axis_c2h_tready_6;
    wire                       d_axis_c2h_tvalid_6;
    wire [C_DATA_WIDTH-1:0]    d_axis_c2h_tdata_6;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_c2h_tkeep_6;
    wire                       d_axis_c2h_tlast_6;    
        
    wire                       d_h2c_dsc_byp_ready_6;   
    wire                       d_h2c_dsc_byp_load_6; 
    wire [63 : 0]              d_h2c_dsc_byp_src_addr_6;   
    wire [63 : 0]              d_h2c_dsc_byp_dst_addr_6;   
    wire [27 : 0]              d_h2c_dsc_byp_len_6;   
    wire [15 : 0]              d_h2c_dsc_byp_ctl_6;    
    wire                       d_axis_h2c_tready_6;
    wire                       d_axis_h2c_tvalid_6;
    wire [C_DATA_WIDTH-1:0]    d_axis_h2c_tdata_6;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_h2c_tkeep_6;
    wire                       d_axis_h2c_tlast_6; 
    wire                       q_c2h_dsc_byp_ready_7;   
    wire                       q_c2h_dsc_byp_load_7; 
    wire [63 : 0]              q_c2h_dsc_byp_src_addr_7;   
    wire [63 : 0]              q_c2h_dsc_byp_dst_addr_7;   
    wire [27 : 0]              q_c2h_dsc_byp_len_7;   
    wire [15 : 0]              q_c2h_dsc_byp_ctl_7;    
    wire                       q_axis_c2h_tready_7;
    wire                       q_axis_c2h_tvalid_7;
    wire [C_DATA_WIDTH-1:0]    q_axis_c2h_tdata_7;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_c2h_tkeep_7;
    wire                       q_axis_c2h_tlast_7;    
        
    wire                       q_h2c_dsc_byp_ready_7;   
    wire                       q_h2c_dsc_byp_load_7; 
    wire [63 : 0]              q_h2c_dsc_byp_src_addr_7;   
    wire [63 : 0]              q_h2c_dsc_byp_dst_addr_7;   
    wire [27 : 0]              q_h2c_dsc_byp_len_7;   
    wire [15 : 0]              q_h2c_dsc_byp_ctl_7;    
    wire                       q_axis_h2c_tready_7;
    wire                       q_axis_h2c_tvalid_7;
    wire [C_DATA_WIDTH-1:0]    q_axis_h2c_tdata_7;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_h2c_tkeep_7;
    wire                       q_axis_h2c_tlast_7; 

    wire                       d_c2h_dsc_byp_ready_7;   
    wire                       d_c2h_dsc_byp_load_7; 
    wire [63 : 0]              d_c2h_dsc_byp_src_addr_7;   
    wire [63 : 0]              d_c2h_dsc_byp_dst_addr_7;   
    wire [27 : 0]              d_c2h_dsc_byp_len_7;   
    wire [15 : 0]              d_c2h_dsc_byp_ctl_7;    
    wire                       d_axis_c2h_tready_7;
    wire                       d_axis_c2h_tvalid_7;
    wire [C_DATA_WIDTH-1:0]    d_axis_c2h_tdata_7;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_c2h_tkeep_7;
    wire                       d_axis_c2h_tlast_7;    
        
    wire                       d_h2c_dsc_byp_ready_7;   
    wire                       d_h2c_dsc_byp_load_7; 
    wire [63 : 0]              d_h2c_dsc_byp_src_addr_7;   
    wire [63 : 0]              d_h2c_dsc_byp_dst_addr_7;   
    wire [27 : 0]              d_h2c_dsc_byp_len_7;   
    wire [15 : 0]              d_h2c_dsc_byp_ctl_7;    
    wire                       d_axis_h2c_tready_7;
    wire                       d_axis_h2c_tvalid_7;
    wire [C_DATA_WIDTH-1:0]    d_axis_h2c_tdata_7;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_h2c_tkeep_7;
    wire                       d_axis_h2c_tlast_7; 
    wire                       q_c2h_dsc_byp_ready_8;   
    wire                       q_c2h_dsc_byp_load_8; 
    wire [63 : 0]              q_c2h_dsc_byp_src_addr_8;   
    wire [63 : 0]              q_c2h_dsc_byp_dst_addr_8;   
    wire [27 : 0]              q_c2h_dsc_byp_len_8;   
    wire [15 : 0]              q_c2h_dsc_byp_ctl_8;    
    wire                       q_axis_c2h_tready_8;
    wire                       q_axis_c2h_tvalid_8;
    wire [C_DATA_WIDTH-1:0]    q_axis_c2h_tdata_8;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_c2h_tkeep_8;
    wire                       q_axis_c2h_tlast_8;    
        
    wire                       q_h2c_dsc_byp_ready_8;   
    wire                       q_h2c_dsc_byp_load_8; 
    wire [63 : 0]              q_h2c_dsc_byp_src_addr_8;   
    wire [63 : 0]              q_h2c_dsc_byp_dst_addr_8;   
    wire [27 : 0]              q_h2c_dsc_byp_len_8;   
    wire [15 : 0]              q_h2c_dsc_byp_ctl_8;    
    wire                       q_axis_h2c_tready_8;
    wire                       q_axis_h2c_tvalid_8;
    wire [C_DATA_WIDTH-1:0]    q_axis_h2c_tdata_8;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_h2c_tkeep_8;
    wire                       q_axis_h2c_tlast_8; 

    wire                       d_c2h_dsc_byp_ready_8;   
    wire                       d_c2h_dsc_byp_load_8; 
    wire [63 : 0]              d_c2h_dsc_byp_src_addr_8;   
    wire [63 : 0]              d_c2h_dsc_byp_dst_addr_8;   
    wire [27 : 0]              d_c2h_dsc_byp_len_8;   
    wire [15 : 0]              d_c2h_dsc_byp_ctl_8;    
    wire                       d_axis_c2h_tready_8;
    wire                       d_axis_c2h_tvalid_8;
    wire [C_DATA_WIDTH-1:0]    d_axis_c2h_tdata_8;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_c2h_tkeep_8;
    wire                       d_axis_c2h_tlast_8;    
        
    wire                       d_h2c_dsc_byp_ready_8;   
    wire                       d_h2c_dsc_byp_load_8; 
    wire [63 : 0]              d_h2c_dsc_byp_src_addr_8;   
    wire [63 : 0]              d_h2c_dsc_byp_dst_addr_8;   
    wire [27 : 0]              d_h2c_dsc_byp_len_8;   
    wire [15 : 0]              d_h2c_dsc_byp_ctl_8;    
    wire                       d_axis_h2c_tready_8;
    wire                       d_axis_h2c_tvalid_8;
    wire [C_DATA_WIDTH-1:0]    d_axis_h2c_tdata_8;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_h2c_tkeep_8;
    wire                       d_axis_h2c_tlast_8; 
  `ifdef NVME_IO_SIXTEEN
    wire                       q_c2h_dsc_byp_ready_9;   
    wire                       q_c2h_dsc_byp_load_9; 
    wire [63 : 0]              q_c2h_dsc_byp_src_addr_9;   
    wire [63 : 0]              q_c2h_dsc_byp_dst_addr_9;   
    wire [27 : 0]              q_c2h_dsc_byp_len_9;   
    wire [15 : 0]              q_c2h_dsc_byp_ctl_9;    
    wire                       q_axis_c2h_tready_9;
    wire                       q_axis_c2h_tvalid_9;
    wire [C_DATA_WIDTH-1:0]    q_axis_c2h_tdata_9;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_c2h_tkeep_9;
    wire                       q_axis_c2h_tlast_9;    
        
    wire                       q_h2c_dsc_byp_ready_9;   
    wire                       q_h2c_dsc_byp_load_9; 
    wire [63 : 0]              q_h2c_dsc_byp_src_addr_9;   
    wire [63 : 0]              q_h2c_dsc_byp_dst_addr_9;   
    wire [27 : 0]              q_h2c_dsc_byp_len_9;   
    wire [15 : 0]              q_h2c_dsc_byp_ctl_9;    
    wire                       q_axis_h2c_tready_9;
    wire                       q_axis_h2c_tvalid_9;
    wire [C_DATA_WIDTH-1:0]    q_axis_h2c_tdata_9;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_h2c_tkeep_9;
    wire                       q_axis_h2c_tlast_9; 

    wire                       d_c2h_dsc_byp_ready_9;   
    wire                       d_c2h_dsc_byp_load_9; 
    wire [63 : 0]              d_c2h_dsc_byp_src_addr_9;   
    wire [63 : 0]              d_c2h_dsc_byp_dst_addr_9;   
    wire [27 : 0]              d_c2h_dsc_byp_len_9;   
    wire [15 : 0]              d_c2h_dsc_byp_ctl_9;    
    wire                       d_axis_c2h_tready_9;
    wire                       d_axis_c2h_tvalid_9;
    wire [C_DATA_WIDTH-1:0]    d_axis_c2h_tdata_9;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_c2h_tkeep_9;
    wire                       d_axis_c2h_tlast_9;    
        
    wire                       d_h2c_dsc_byp_ready_9;   
    wire                       d_h2c_dsc_byp_load_9; 
    wire [63 : 0]              d_h2c_dsc_byp_src_addr_9;   
    wire [63 : 0]              d_h2c_dsc_byp_dst_addr_9;   
    wire [27 : 0]              d_h2c_dsc_byp_len_9;   
    wire [15 : 0]              d_h2c_dsc_byp_ctl_9;    
    wire                       d_axis_h2c_tready_9;
    wire                       d_axis_h2c_tvalid_9;
    wire [C_DATA_WIDTH-1:0]    d_axis_h2c_tdata_9;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_h2c_tkeep_9;
    wire                       d_axis_h2c_tlast_9; 
    wire                       q_c2h_dsc_byp_ready_10;   
    wire                       q_c2h_dsc_byp_load_10; 
    wire [63 : 0]              q_c2h_dsc_byp_src_addr_10;   
    wire [63 : 0]              q_c2h_dsc_byp_dst_addr_10;   
    wire [27 : 0]              q_c2h_dsc_byp_len_10;   
    wire [15 : 0]              q_c2h_dsc_byp_ctl_10;    
    wire                       q_axis_c2h_tready_10;
    wire                       q_axis_c2h_tvalid_10;
    wire [C_DATA_WIDTH-1:0]    q_axis_c2h_tdata_10;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_c2h_tkeep_10;
    wire                       q_axis_c2h_tlast_10;    
        
    wire                       q_h2c_dsc_byp_ready_10;   
    wire                       q_h2c_dsc_byp_load_10; 
    wire [63 : 0]              q_h2c_dsc_byp_src_addr_10;   
    wire [63 : 0]              q_h2c_dsc_byp_dst_addr_10;   
    wire [27 : 0]              q_h2c_dsc_byp_len_10;   
    wire [15 : 0]              q_h2c_dsc_byp_ctl_10;    
    wire                       q_axis_h2c_tready_10;
    wire                       q_axis_h2c_tvalid_10;
    wire [C_DATA_WIDTH-1:0]    q_axis_h2c_tdata_10;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_h2c_tkeep_10;
    wire                       q_axis_h2c_tlast_10; 

    wire                       d_c2h_dsc_byp_ready_10;   
    wire                       d_c2h_dsc_byp_load_10; 
    wire [63 : 0]              d_c2h_dsc_byp_src_addr_10;   
    wire [63 : 0]              d_c2h_dsc_byp_dst_addr_10;   
    wire [27 : 0]              d_c2h_dsc_byp_len_10;   
    wire [15 : 0]              d_c2h_dsc_byp_ctl_10;    
    wire                       d_axis_c2h_tready_10;
    wire                       d_axis_c2h_tvalid_10;
    wire [C_DATA_WIDTH-1:0]    d_axis_c2h_tdata_10;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_c2h_tkeep_10;
    wire                       d_axis_c2h_tlast_10;    
        
    wire                       d_h2c_dsc_byp_ready_10;   
    wire                       d_h2c_dsc_byp_load_10; 
    wire [63 : 0]              d_h2c_dsc_byp_src_addr_10;   
    wire [63 : 0]              d_h2c_dsc_byp_dst_addr_10;   
    wire [27 : 0]              d_h2c_dsc_byp_len_10;   
    wire [15 : 0]              d_h2c_dsc_byp_ctl_10;    
    wire                       d_axis_h2c_tready_10;
    wire                       d_axis_h2c_tvalid_10;
    wire [C_DATA_WIDTH-1:0]    d_axis_h2c_tdata_10;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_h2c_tkeep_10;
    wire                       d_axis_h2c_tlast_10; 
    wire                       q_c2h_dsc_byp_ready_11;   
    wire                       q_c2h_dsc_byp_load_11; 
    wire [63 : 0]              q_c2h_dsc_byp_src_addr_11;   
    wire [63 : 0]              q_c2h_dsc_byp_dst_addr_11;   
    wire [27 : 0]              q_c2h_dsc_byp_len_11;   
    wire [15 : 0]              q_c2h_dsc_byp_ctl_11;    
    wire                       q_axis_c2h_tready_11;
    wire                       q_axis_c2h_tvalid_11;
    wire [C_DATA_WIDTH-1:0]    q_axis_c2h_tdata_11;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_c2h_tkeep_11;
    wire                       q_axis_c2h_tlast_11;    
        
    wire                       q_h2c_dsc_byp_ready_11;   
    wire                       q_h2c_dsc_byp_load_11; 
    wire [63 : 0]              q_h2c_dsc_byp_src_addr_11;   
    wire [63 : 0]              q_h2c_dsc_byp_dst_addr_11;   
    wire [27 : 0]              q_h2c_dsc_byp_len_11;   
    wire [15 : 0]              q_h2c_dsc_byp_ctl_11;    
    wire                       q_axis_h2c_tready_11;
    wire                       q_axis_h2c_tvalid_11;
    wire [C_DATA_WIDTH-1:0]    q_axis_h2c_tdata_11;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_h2c_tkeep_11;
    wire                       q_axis_h2c_tlast_11; 

    wire                       d_c2h_dsc_byp_ready_11;   
    wire                       d_c2h_dsc_byp_load_11; 
    wire [63 : 0]              d_c2h_dsc_byp_src_addr_11;   
    wire [63 : 0]              d_c2h_dsc_byp_dst_addr_11;   
    wire [27 : 0]              d_c2h_dsc_byp_len_11;   
    wire [15 : 0]              d_c2h_dsc_byp_ctl_11;    
    wire                       d_axis_c2h_tready_11;
    wire                       d_axis_c2h_tvalid_11;
    wire [C_DATA_WIDTH-1:0]    d_axis_c2h_tdata_11;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_c2h_tkeep_11;
    wire                       d_axis_c2h_tlast_11;    
        
    wire                       d_h2c_dsc_byp_ready_11;   
    wire                       d_h2c_dsc_byp_load_11; 
    wire [63 : 0]              d_h2c_dsc_byp_src_addr_11;   
    wire [63 : 0]              d_h2c_dsc_byp_dst_addr_11;   
    wire [27 : 0]              d_h2c_dsc_byp_len_11;   
    wire [15 : 0]              d_h2c_dsc_byp_ctl_11;    
    wire                       d_axis_h2c_tready_11;
    wire                       d_axis_h2c_tvalid_11;
    wire [C_DATA_WIDTH-1:0]    d_axis_h2c_tdata_11;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_h2c_tkeep_11;
    wire                       d_axis_h2c_tlast_11; 
    wire                       q_c2h_dsc_byp_ready_12;   
    wire                       q_c2h_dsc_byp_load_12; 
    wire [63 : 0]              q_c2h_dsc_byp_src_addr_12;   
    wire [63 : 0]              q_c2h_dsc_byp_dst_addr_12;   
    wire [27 : 0]              q_c2h_dsc_byp_len_12;   
    wire [15 : 0]              q_c2h_dsc_byp_ctl_12;    
    wire                       q_axis_c2h_tready_12;
    wire                       q_axis_c2h_tvalid_12;
    wire [C_DATA_WIDTH-1:0]    q_axis_c2h_tdata_12;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_c2h_tkeep_12;
    wire                       q_axis_c2h_tlast_12;    
        
    wire                       q_h2c_dsc_byp_ready_12;   
    wire                       q_h2c_dsc_byp_load_12; 
    wire [63 : 0]              q_h2c_dsc_byp_src_addr_12;   
    wire [63 : 0]              q_h2c_dsc_byp_dst_addr_12;   
    wire [27 : 0]              q_h2c_dsc_byp_len_12;   
    wire [15 : 0]              q_h2c_dsc_byp_ctl_12;    
    wire                       q_axis_h2c_tready_12;
    wire                       q_axis_h2c_tvalid_12;
    wire [C_DATA_WIDTH-1:0]    q_axis_h2c_tdata_12;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_h2c_tkeep_12;
    wire                       q_axis_h2c_tlast_12; 

    wire                       d_c2h_dsc_byp_ready_12;   
    wire                       d_c2h_dsc_byp_load_12; 
    wire [63 : 0]              d_c2h_dsc_byp_src_addr_12;   
    wire [63 : 0]              d_c2h_dsc_byp_dst_addr_12;   
    wire [27 : 0]              d_c2h_dsc_byp_len_12;   
    wire [15 : 0]              d_c2h_dsc_byp_ctl_12;    
    wire                       d_axis_c2h_tready_12;
    wire                       d_axis_c2h_tvalid_12;
    wire [C_DATA_WIDTH-1:0]    d_axis_c2h_tdata_12;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_c2h_tkeep_12;
    wire                       d_axis_c2h_tlast_12;    
        
    wire                       d_h2c_dsc_byp_ready_12;   
    wire                       d_h2c_dsc_byp_load_12; 
    wire [63 : 0]              d_h2c_dsc_byp_src_addr_12;   
    wire [63 : 0]              d_h2c_dsc_byp_dst_addr_12;   
    wire [27 : 0]              d_h2c_dsc_byp_len_12;   
    wire [15 : 0]              d_h2c_dsc_byp_ctl_12;    
    wire                       d_axis_h2c_tready_12;
    wire                       d_axis_h2c_tvalid_12;
    wire [C_DATA_WIDTH-1:0]    d_axis_h2c_tdata_12;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_h2c_tkeep_12;
    wire                       d_axis_h2c_tlast_12; 
    wire                       q_c2h_dsc_byp_ready_13;   
    wire                       q_c2h_dsc_byp_load_13; 
    wire [63 : 0]              q_c2h_dsc_byp_src_addr_13;   
    wire [63 : 0]              q_c2h_dsc_byp_dst_addr_13;   
    wire [27 : 0]              q_c2h_dsc_byp_len_13;   
    wire [15 : 0]              q_c2h_dsc_byp_ctl_13;    
    wire                       q_axis_c2h_tready_13;
    wire                       q_axis_c2h_tvalid_13;
    wire [C_DATA_WIDTH-1:0]    q_axis_c2h_tdata_13;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_c2h_tkeep_13;
    wire                       q_axis_c2h_tlast_13;    
        
    wire                       q_h2c_dsc_byp_ready_13;   
    wire                       q_h2c_dsc_byp_load_13; 
    wire [63 : 0]              q_h2c_dsc_byp_src_addr_13;   
    wire [63 : 0]              q_h2c_dsc_byp_dst_addr_13;   
    wire [27 : 0]              q_h2c_dsc_byp_len_13;   
    wire [15 : 0]              q_h2c_dsc_byp_ctl_13;    
    wire                       q_axis_h2c_tready_13;
    wire                       q_axis_h2c_tvalid_13;
    wire [C_DATA_WIDTH-1:0]    q_axis_h2c_tdata_13;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_h2c_tkeep_13;
    wire                       q_axis_h2c_tlast_13; 

    wire                       d_c2h_dsc_byp_ready_13;   
    wire                       d_c2h_dsc_byp_load_13; 
    wire [63 : 0]              d_c2h_dsc_byp_src_addr_13;   
    wire [63 : 0]              d_c2h_dsc_byp_dst_addr_13;   
    wire [27 : 0]              d_c2h_dsc_byp_len_13;   
    wire [15 : 0]              d_c2h_dsc_byp_ctl_13;    
    wire                       d_axis_c2h_tready_13;
    wire                       d_axis_c2h_tvalid_13;
    wire [C_DATA_WIDTH-1:0]    d_axis_c2h_tdata_13;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_c2h_tkeep_13;
    wire                       d_axis_c2h_tlast_13;    
        
    wire                       d_h2c_dsc_byp_ready_13;   
    wire                       d_h2c_dsc_byp_load_13; 
    wire [63 : 0]              d_h2c_dsc_byp_src_addr_13;   
    wire [63 : 0]              d_h2c_dsc_byp_dst_addr_13;   
    wire [27 : 0]              d_h2c_dsc_byp_len_13;   
    wire [15 : 0]              d_h2c_dsc_byp_ctl_13;    
    wire                       d_axis_h2c_tready_13;
    wire                       d_axis_h2c_tvalid_13;
    wire [C_DATA_WIDTH-1:0]    d_axis_h2c_tdata_13;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_h2c_tkeep_13;
    wire                       d_axis_h2c_tlast_13; 
    wire                       q_c2h_dsc_byp_ready_14;   
    wire                       q_c2h_dsc_byp_load_14; 
    wire [63 : 0]              q_c2h_dsc_byp_src_addr_14;   
    wire [63 : 0]              q_c2h_dsc_byp_dst_addr_14;   
    wire [27 : 0]              q_c2h_dsc_byp_len_14;   
    wire [15 : 0]              q_c2h_dsc_byp_ctl_14;    
    wire                       q_axis_c2h_tready_14;
    wire                       q_axis_c2h_tvalid_14;
    wire [C_DATA_WIDTH-1:0]    q_axis_c2h_tdata_14;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_c2h_tkeep_14;
    wire                       q_axis_c2h_tlast_14;    
        
    wire                       q_h2c_dsc_byp_ready_14;   
    wire                       q_h2c_dsc_byp_load_14; 
    wire [63 : 0]              q_h2c_dsc_byp_src_addr_14;   
    wire [63 : 0]              q_h2c_dsc_byp_dst_addr_14;   
    wire [27 : 0]              q_h2c_dsc_byp_len_14;   
    wire [15 : 0]              q_h2c_dsc_byp_ctl_14;    
    wire                       q_axis_h2c_tready_14;
    wire                       q_axis_h2c_tvalid_14;
    wire [C_DATA_WIDTH-1:0]    q_axis_h2c_tdata_14;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_h2c_tkeep_14;
    wire                       q_axis_h2c_tlast_14; 

    wire                       d_c2h_dsc_byp_ready_14;   
    wire                       d_c2h_dsc_byp_load_14; 
    wire [63 : 0]              d_c2h_dsc_byp_src_addr_14;   
    wire [63 : 0]              d_c2h_dsc_byp_dst_addr_14;   
    wire [27 : 0]              d_c2h_dsc_byp_len_14;   
    wire [15 : 0]              d_c2h_dsc_byp_ctl_14;    
    wire                       d_axis_c2h_tready_14;
    wire                       d_axis_c2h_tvalid_14;
    wire [C_DATA_WIDTH-1:0]    d_axis_c2h_tdata_14;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_c2h_tkeep_14;
    wire                       d_axis_c2h_tlast_14;    
        
    wire                       d_h2c_dsc_byp_ready_14;   
    wire                       d_h2c_dsc_byp_load_14; 
    wire [63 : 0]              d_h2c_dsc_byp_src_addr_14;   
    wire [63 : 0]              d_h2c_dsc_byp_dst_addr_14;   
    wire [27 : 0]              d_h2c_dsc_byp_len_14;   
    wire [15 : 0]              d_h2c_dsc_byp_ctl_14;    
    wire                       d_axis_h2c_tready_14;
    wire                       d_axis_h2c_tvalid_14;
    wire [C_DATA_WIDTH-1:0]    d_axis_h2c_tdata_14;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_h2c_tkeep_14;
    wire                       d_axis_h2c_tlast_14; 
    wire                       q_c2h_dsc_byp_ready_15;   
    wire                       q_c2h_dsc_byp_load_15; 
    wire [63 : 0]              q_c2h_dsc_byp_src_addr_15;   
    wire [63 : 0]              q_c2h_dsc_byp_dst_addr_15;   
    wire [27 : 0]              q_c2h_dsc_byp_len_15;   
    wire [15 : 0]              q_c2h_dsc_byp_ctl_15;    
    wire                       q_axis_c2h_tready_15;
    wire                       q_axis_c2h_tvalid_15;
    wire [C_DATA_WIDTH-1:0]    q_axis_c2h_tdata_15;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_c2h_tkeep_15;
    wire                       q_axis_c2h_tlast_15;    
        
    wire                       q_h2c_dsc_byp_ready_15;   
    wire                       q_h2c_dsc_byp_load_15; 
    wire [63 : 0]              q_h2c_dsc_byp_src_addr_15;   
    wire [63 : 0]              q_h2c_dsc_byp_dst_addr_15;   
    wire [27 : 0]              q_h2c_dsc_byp_len_15;   
    wire [15 : 0]              q_h2c_dsc_byp_ctl_15;    
    wire                       q_axis_h2c_tready_15;
    wire                       q_axis_h2c_tvalid_15;
    wire [C_DATA_WIDTH-1:0]    q_axis_h2c_tdata_15;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_h2c_tkeep_15;
    wire                       q_axis_h2c_tlast_15; 

    wire                       d_c2h_dsc_byp_ready_15;   
    wire                       d_c2h_dsc_byp_load_15; 
    wire [63 : 0]              d_c2h_dsc_byp_src_addr_15;   
    wire [63 : 0]              d_c2h_dsc_byp_dst_addr_15;   
    wire [27 : 0]              d_c2h_dsc_byp_len_15;   
    wire [15 : 0]              d_c2h_dsc_byp_ctl_15;    
    wire                       d_axis_c2h_tready_15;
    wire                       d_axis_c2h_tvalid_15;
    wire [C_DATA_WIDTH-1:0]    d_axis_c2h_tdata_15;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_c2h_tkeep_15;
    wire                       d_axis_c2h_tlast_15;    
        
    wire                       d_h2c_dsc_byp_ready_15;   
    wire                       d_h2c_dsc_byp_load_15; 
    wire [63 : 0]              d_h2c_dsc_byp_src_addr_15;   
    wire [63 : 0]              d_h2c_dsc_byp_dst_addr_15;   
    wire [27 : 0]              d_h2c_dsc_byp_len_15;   
    wire [15 : 0]              d_h2c_dsc_byp_ctl_15;    
    wire                       d_axis_h2c_tready_15;
    wire                       d_axis_h2c_tvalid_15;
    wire [C_DATA_WIDTH-1:0]    d_axis_h2c_tdata_15;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_h2c_tkeep_15;
    wire                       d_axis_h2c_tlast_15; 
    wire                       q_c2h_dsc_byp_ready_16;   
    wire                       q_c2h_dsc_byp_load_16; 
    wire [63 : 0]              q_c2h_dsc_byp_src_addr_16;   
    wire [63 : 0]              q_c2h_dsc_byp_dst_addr_16;   
    wire [27 : 0]              q_c2h_dsc_byp_len_16;   
    wire [15 : 0]              q_c2h_dsc_byp_ctl_16;    
    wire                       q_axis_c2h_tready_16;
    wire                       q_axis_c2h_tvalid_16;
    wire [C_DATA_WIDTH-1:0]    q_axis_c2h_tdata_16;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_c2h_tkeep_16;
    wire                       q_axis_c2h_tlast_16;    
        
    wire                       q_h2c_dsc_byp_ready_16;   
    wire                       q_h2c_dsc_byp_load_16; 
    wire [63 : 0]              q_h2c_dsc_byp_src_addr_16;   
    wire [63 : 0]              q_h2c_dsc_byp_dst_addr_16;   
    wire [27 : 0]              q_h2c_dsc_byp_len_16;   
    wire [15 : 0]              q_h2c_dsc_byp_ctl_16;    
    wire                       q_axis_h2c_tready_16;
    wire                       q_axis_h2c_tvalid_16;
    wire [C_DATA_WIDTH-1:0]    q_axis_h2c_tdata_16;
    wire [C_DATA_WIDTH/8-1:0]  q_axis_h2c_tkeep_16;
    wire                       q_axis_h2c_tlast_16; 

    wire                       d_c2h_dsc_byp_ready_16;   
    wire                       d_c2h_dsc_byp_load_16; 
    wire [63 : 0]              d_c2h_dsc_byp_src_addr_16;   
    wire [63 : 0]              d_c2h_dsc_byp_dst_addr_16;   
    wire [27 : 0]              d_c2h_dsc_byp_len_16;   
    wire [15 : 0]              d_c2h_dsc_byp_ctl_16;    
    wire                       d_axis_c2h_tready_16;
    wire                       d_axis_c2h_tvalid_16;
    wire [C_DATA_WIDTH-1:0]    d_axis_c2h_tdata_16;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_c2h_tkeep_16;
    wire                       d_axis_c2h_tlast_16;    
        
    wire                       d_h2c_dsc_byp_ready_16;   
    wire                       d_h2c_dsc_byp_load_16; 
    wire [63 : 0]              d_h2c_dsc_byp_src_addr_16;   
    wire [63 : 0]              d_h2c_dsc_byp_dst_addr_16;   
    wire [27 : 0]              d_h2c_dsc_byp_len_16;   
    wire [15 : 0]              d_h2c_dsc_byp_ctl_16;    
    wire                       d_axis_h2c_tready_16;
    wire                       d_axis_h2c_tvalid_16;
    wire [C_DATA_WIDTH-1:0]    d_axis_h2c_tdata_16;
    wire [C_DATA_WIDTH/8-1:0]  d_axis_h2c_tkeep_16;
    wire                       d_axis_h2c_tlast_16;   
  `endif  
`endif    
//    wire [7:0]    c2h_sts_0;
//    wire [7:0]    c2h_sts_1;
//    wire [7:0]    c2h_sts_2;
//    wire [7:0]    c2h_sts_3;
                 
//    wire [7:0]    h2c_sts_0;
//    wire [7:0]    h2c_sts_1;
//    wire [7:0]    h2c_sts_2;
//    wire [7:0]    h2c_sts_3;
        
    wire [3:0]    leds;
    
    wire [7:0]                   mps_width; // host memory page size bitwidth
    wire [7:0]                   lbads_width; // LBA data size bitwidth
    
    wire                         acq_irq_enable;
    wire                         acq_irq_req;   
    wire                         acq_irq_ack;   
    wire                         nvme_reg_cc_en;
    wire                         nvme_reg_csts_rdy;   
//    reg                          pl_csts_rdy;
    wire                         ps_csts_rdy;
    wire [1:0]                   nvme_reg_cc_shn;
    wire [1:0]                   nvme_reg_csts_shst;
//    reg  [1:0]                   pl_csts_shst;
    wire [1:0]                   ps_csts_shst;
    wire                         nvme_cc_reset;
    // NVMe I/O sq & cq reset
    wire [31:0]                  sq_reset;
    wire [31:0]                  cq_reset;
    // NVMe IO CQ Interruput enable
    wire [31:0]                  iocq_irq_enable;
    wire [NUM_IOCQ_IRQ-1:0]      irq_enable;
    wire [NUM_IOCQ_IRQ-1:0]      irq_req;
    wire [NUM_IOCQ_IRQ-1:0]      irq_ack;
    wire [63:0]                  sq_base_addr_0;
    wire [15:0]                  sq_size_0;
    wire [15:0]                  sq_tail_0;
    wire [63:0]                  cq_base_addr_0;
    wire [15:0]                  cq_size_0;
    wire [15:0]                  cq_head_0;
    wire [63:0]                  sq_base_addr_1;
    wire [15:0]                  sq_size_1;
    wire [15:0]                  sq_id_1;
    wire [15:0]                  sq_tail_1;
    wire [63:0]                  cq_base_addr_1;
    wire [15:0]                  cq_size_1;
    wire [15:0]                  cq_id_1;
    wire [15:0]                  cq_head_1;
    wire [63:0]                  sq_base_addr_2;
    wire [15:0]                  sq_size_2;
    wire [15:0]                  sq_id_2;
    wire [15:0]                  sq_tail_2;
    wire [63:0]                  cq_base_addr_2;
    wire [15:0]                  cq_size_2;
    wire [15:0]                  cq_id_2;
    wire [15:0]                  cq_head_2;
    wire [63:0]                  sq_base_addr_3;
    wire [15:0]                  sq_size_3;
    wire [15:0]                  sq_id_3;
    wire [15:0]                  sq_tail_3;
    wire [63:0]                  cq_base_addr_3;
    wire [15:0]                  cq_size_3;
    wire [15:0]                  cq_id_3;
    wire [15:0]                  cq_head_3;
    wire [63:0]                  sq_base_addr_4;
    wire [15:0]                  sq_size_4;
    wire [15:0]                  sq_id_4;
    wire [15:0]                  sq_tail_4;
    wire [63:0]                  cq_base_addr_4;
    wire [15:0]                  cq_size_4;
    wire [15:0]                  cq_id_4;
    wire [15:0]                  cq_head_4;
    wire [63:0]                  sq_base_addr_5;
    wire [15:0]                  sq_size_5;
    wire [15:0]                  sq_id_5;
    wire [15:0]                  sq_tail_5;
    wire [63:0]                  cq_base_addr_5;
    wire [15:0]                  cq_size_5;
    wire [15:0]                  cq_id_5;
    wire [15:0]                  cq_head_5;
    wire [63:0]                  sq_base_addr_6;
    wire [15:0]                  sq_size_6;
    wire [15:0]                  sq_id_6;
    wire [15:0]                  sq_tail_6;
    wire [63:0]                  cq_base_addr_6;
    wire [15:0]                  cq_size_6;
    wire [15:0]                  cq_id_6;
    wire [15:0]                  cq_head_6;
    wire [63:0]                  sq_base_addr_7;
    wire [15:0]                  sq_size_7;
    wire [15:0]                  sq_id_7;
    wire [15:0]                  sq_tail_7;
    wire [63:0]                  cq_base_addr_7;
    wire [15:0]                  cq_size_7;
    wire [15:0]                  cq_id_7;
    wire [15:0]                  cq_head_7;
    wire [63:0]                  sq_base_addr_8;
    wire [15:0]                  sq_size_8;
    wire [15:0]                  sq_id_8;
    wire [15:0]                  sq_tail_8;
    wire [63:0]                  cq_base_addr_8;
    wire [15:0]                  cq_size_8;
    wire [15:0]                  cq_id_8;
    wire [15:0]                  cq_head_8;
    wire [63:0]                  sq_base_addr_9;
    wire [15:0]                  sq_size_9;
    wire [15:0]                  sq_id_9;
    wire [15:0]                  sq_tail_9;
    wire [63:0]                  cq_base_addr_9;
    wire [15:0]                  cq_size_9;
    wire [15:0]                  cq_id_9;
    wire [15:0]                  cq_head_9;
    wire [63:0]                  sq_base_addr_10;
    wire [15:0]                  sq_size_10;
    wire [15:0]                  sq_id_10;
    wire [15:0]                  sq_tail_10;
    wire [63:0]                  cq_base_addr_10;
    wire [15:0]                  cq_size_10;
    wire [15:0]                  cq_id_10;
    wire [15:0]                  cq_head_10;
    wire [63:0]                  sq_base_addr_11;
    wire [15:0]                  sq_size_11;
    wire [15:0]                  sq_id_11;
    wire [15:0]                  sq_tail_11;
    wire [63:0]                  cq_base_addr_11;
    wire [15:0]                  cq_size_11;
    wire [15:0]                  cq_id_11;
    wire [15:0]                  cq_head_11;
    wire [63:0]                  sq_base_addr_12;
    wire [15:0]                  sq_size_12;
    wire [15:0]                  sq_id_12;
    wire [15:0]                  sq_tail_12;
    wire [63:0]                  cq_base_addr_12;
    wire [15:0]                  cq_size_12;
    wire [15:0]                  cq_id_12;
    wire [15:0]                  cq_head_12;
    wire [63:0]                  sq_base_addr_13;
    wire [15:0]                  sq_size_13;
    wire [15:0]                  sq_id_13;
    wire [15:0]                  sq_tail_13;
    wire [63:0]                  cq_base_addr_13;
    wire [15:0]                  cq_size_13;
    wire [15:0]                  cq_id_13;
    wire [15:0]                  cq_head_13;
    wire [63:0]                  sq_base_addr_14;
    wire [15:0]                  sq_size_14;
    wire [15:0]                  sq_id_14;
    wire [15:0]                  sq_tail_14;
    wire [63:0]                  cq_base_addr_14;
    wire [15:0]                  cq_size_14;
    wire [15:0]                  cq_id_14;
    wire [15:0]                  cq_head_14;
    wire [63:0]                  sq_base_addr_15;
    wire [15:0]                  sq_size_15;
    wire [15:0]                  sq_id_15;
    wire [15:0]                  sq_tail_15;
    wire [63:0]                  cq_base_addr_15;
    wire [15:0]                  cq_size_15;
    wire [15:0]                  cq_id_15;
    wire [15:0]                  cq_head_15;
    wire [63:0]                  sq_base_addr_16;
    wire [15:0]                  sq_size_16;
    wire [15:0]                  sq_id_16;
    wire [15:0]                  sq_tail_16;
    wire [63:0]                  cq_base_addr_16;
    wire [15:0]                  cq_size_16;
    wire [15:0]                  cq_id_16;
    wire [15:0]                  cq_head_16;

     

  // Ref clock buffer
  IBUFDS_GTE3 # (.REFCLK_HROW_CK_SEL(2'b00)) refclk_ibuf (.O(sys_clk_gt), .ODIV2(sys_clk), .I(sys_clk_p), .CEB(1'b0), .IB(sys_clk_n));
  // Reset buffer
  IBUF   sys_reset_n_ibuf (.O(sys_rst_n_c), .I(sys_rst_n));
  
  // The sys_rst_n input is active low based on the core configuration
  wire sys_resetn;
  assign sys_resetn = sys_rst_n_c;

//  // Create a Clock Heartbeat
  always @(posedge user_clk) begin
    if(!sys_resetn) begin
      user_clk_heartbeat <= 26'd0;
    end else begin
      user_clk_heartbeat <= user_clk_heartbeat + 1'b1;
    end
  end


  // LED 0 pysically resides in the reconfiguable area for Tandem with 
  // Field Updates designs so the OBUF must included in this hierarchy.
  OBUF led_0_obuf (.O(leds[0]), .I(sys_resetn));
  // LEDs 1-3 physically reside in the stage1 region for Tandem with Field 
  // Updates designs so the OBUF must be instantiated at the top-level.
  assign leds[1] = user_resetn;
  assign leds[2] = user_lnk_up;
  assign leds[3] = user_clk_heartbeat[25];

  // LED 0 pysically resides in the reconfiguable area for Tandem with 
  // Field Updates designs so the OBUF must included in the app hierarchy.
  assign led_0 = leds[0];
  // LEDs 1-3 physically reside in the stage1 region for Tandem with Field 
  // Updates designs so the OBUF must be instantiated at the top-level and
  // added to the stage1 region
  OBUF led_1_obuf (.O(led_1), .I(leds[1]));
  OBUF led_2_obuf (.O(led_2), .I(leds[2]));
  OBUF led_3_obuf (.O(led_3), .I(leds[3]));

     
  wire  [25:0]  common_commands_in_i;
  wire  [83:0]  pipe_rx_0_sigs_i;
  wire  [83:0]  pipe_rx_1_sigs_i;
  wire  [83:0]  pipe_rx_2_sigs_i;
  wire  [83:0]  pipe_rx_3_sigs_i;
  wire  [83:0]  pipe_rx_4_sigs_i;
  wire  [83:0]  pipe_rx_5_sigs_i;
  wire  [83:0]  pipe_rx_6_sigs_i;
  wire  [83:0]  pipe_rx_7_sigs_i;
  wire  [25:0]  common_commands_out_i;
  wire  [83:0]  pipe_tx_0_sigs_i;
  wire  [83:0]  pipe_tx_1_sigs_i;
  wire  [83:0]  pipe_tx_2_sigs_i;
  wire  [83:0]  pipe_tx_3_sigs_i;
  wire  [83:0]  pipe_tx_4_sigs_i;
  wire  [83:0]  pipe_tx_5_sigs_i;
  wire  [83:0]  pipe_tx_6_sigs_i;
  wire  [83:0]  pipe_tx_7_sigs_i;

// synthesis translate_off
generate if (EXT_PIPE_SIM == "TRUE") 
begin
  assign common_commands_in_i = common_commands_in;  
  assign pipe_rx_0_sigs_i     = pipe_rx_0_sigs;   
  assign pipe_rx_1_sigs_i     = pipe_rx_1_sigs;   
  assign pipe_rx_2_sigs_i     = pipe_rx_2_sigs;   
  assign pipe_rx_3_sigs_i     = pipe_rx_3_sigs;   
  assign pipe_rx_4_sigs_i     = pipe_rx_4_sigs;   
  assign pipe_rx_5_sigs_i     = pipe_rx_5_sigs;   
  assign pipe_rx_6_sigs_i     = pipe_rx_6_sigs;   
  assign pipe_rx_7_sigs_i     = pipe_rx_7_sigs;   
  assign common_commands_out  = common_commands_out_i; 
  assign pipe_tx_0_sigs       = pipe_tx_0_sigs_i;      
  assign pipe_tx_1_sigs       = pipe_tx_1_sigs_i;      
  assign pipe_tx_2_sigs       = pipe_tx_2_sigs_i;      
  assign pipe_tx_3_sigs       = pipe_tx_3_sigs_i;      
  assign pipe_tx_4_sigs       = pipe_tx_4_sigs_i;      
  assign pipe_tx_5_sigs       = pipe_tx_5_sigs_i;      
  assign pipe_tx_6_sigs       = pipe_tx_6_sigs_i;      
  assign pipe_tx_7_sigs       = pipe_tx_7_sigs_i;      
 end
endgenerate
// synthesis translate_on   
  
generate if (EXT_PIPE_SIM == "FALSE") 
begin
  assign common_commands_in_i = 26'h0;  
  assign pipe_rx_0_sigs_i     = 84'h0;
  assign pipe_rx_1_sigs_i     = 84'h0;
  assign pipe_rx_2_sigs_i     = 84'h0;
  assign pipe_rx_3_sigs_i     = 84'h0;
  assign pipe_rx_4_sigs_i     = 84'h0;
  assign pipe_rx_5_sigs_i     = 84'h0;
  assign pipe_rx_6_sigs_i     = 84'h0;
  assign pipe_rx_7_sigs_i     = 84'h0;
 end
endgenerate



  // Core Top Level Wrapper
  xdma_0 xdma_0_i 
     (
      //---------------------------------------------------------------------------------------//
      //  PCI Express (pci_exp) Interface                                                      //
      //---------------------------------------------------------------------------------------//
      .sys_rst_n       ( sys_rst_n_c ),
      .sys_clk         ( sys_clk     ),
      .sys_clk_gt      ( sys_clk_gt  ),                        
      // soft reset     
      .dma_bridge_resetn(dma_soft_rstn),            // input wire dma_bridge_resetn
      
      // Tx
      .pci_exp_txn     ( pci_exp_txn ),
      .pci_exp_txp     ( pci_exp_txp ),
      
      // Rx
      .pci_exp_rxn     ( pci_exp_rxn ),
      .pci_exp_rxp     ( pci_exp_rxp ),
      
      // shared clock
      .int_qpll1lock_out     (),            // output wire [1 : 0] int_qpll1lock_out
      .int_qpll1outrefclk_out(),            // output wire [1 : 0] int_qpll1outrefclk_out
      .int_qpll1outclk_out   (),            // output wire [1 : 0] int_qpll1outclk_out

//      // PCIe-ID interfaces
//  `ifdef SIMULATION    
//      .cfg_vend_id          (16'h10EE      ),    // input wire [15 : 0] cfg_vend_id
//      .cfg_dev_id_pf0       (16'h8038      ),    // input wire [15 : 0] cfg_dev_id_pf0
//      .cfg_rev_id_pf0       (8'h00         ),    // input wire [7 : 0] cfg_rev_id_pf0
//      .cfg_subsys_vend_id   (16'h10EE      ),    // input wire [15 : 0] cfg_subsys_vend_id
//      .cfg_subsys_id_pf0    (16'h0007      ),    // input wire [15 : 0] cfg_subsys_id_pf0
//  `else
//      .cfg_vend_id          (16'h144D      ),    // input wire [15 : 0] cfg_vend_id
//      .cfg_dev_id_pf0       (16'hA822      ),    // input wire [15 : 0] cfg_dev_id_pf0
//      .cfg_rev_id_pf0       (8'h00         ),    // input wire [7 : 0] cfg_rev_id_pf0
//      .cfg_subsys_vend_id   (16'h1028      ),    // input wire [15 : 0] cfg_subsys_vend_id
//      .cfg_subsys_id_pf0    (16'h1FDF      ),    // input wire [15 : 0] cfg_subsys_id_pf0
//  `endif
  
      // AXI streaming ports
      .s_axis_c2h_tdata_0   (m_axis_c2h_tdata_0 ),
      .s_axis_c2h_tlast_0   (m_axis_c2h_tlast_0 ),
      .s_axis_c2h_tvalid_0  (m_axis_c2h_tvalid_0),
      .s_axis_c2h_tready_0  (m_axis_c2h_tready_0),
      .s_axis_c2h_tkeep_0   (m_axis_c2h_tkeep_0 ),
      .s_axis_c2h_tdata_1   (m_axis_c2h_tdata_1 ),
      .s_axis_c2h_tlast_1   (m_axis_c2h_tlast_1 ),
      .s_axis_c2h_tvalid_1  (m_axis_c2h_tvalid_1),
      .s_axis_c2h_tready_1  (m_axis_c2h_tready_1),
      .s_axis_c2h_tkeep_1   (m_axis_c2h_tkeep_1 ),
      .s_axis_c2h_tdata_2   (m_axis_c2h_tdata_2 ),
      .s_axis_c2h_tlast_2   (m_axis_c2h_tlast_2 ),
      .s_axis_c2h_tvalid_2  (m_axis_c2h_tvalid_2),
      .s_axis_c2h_tready_2  (m_axis_c2h_tready_2),
      .s_axis_c2h_tkeep_2   (m_axis_c2h_tkeep_2 ),
      .s_axis_c2h_tdata_3   (m_axis_c2h_tdata_3 ),
      .s_axis_c2h_tlast_3   (m_axis_c2h_tlast_3 ),
      .s_axis_c2h_tvalid_3  (m_axis_c2h_tvalid_3),
      .s_axis_c2h_tready_3  (m_axis_c2h_tready_3),
      .s_axis_c2h_tkeep_3   (m_axis_c2h_tkeep_3 ),
      .m_axis_h2c_tdata_0   (m_axis_h2c_tdata_0 ),
      .m_axis_h2c_tlast_0   (m_axis_h2c_tlast_0 ),
      .m_axis_h2c_tvalid_0  (m_axis_h2c_tvalid_0),
      .m_axis_h2c_tready_0  (m_axis_h2c_tready_0),
      .m_axis_h2c_tkeep_0   (m_axis_h2c_tkeep_0 ),
      .m_axis_h2c_tdata_1   (m_axis_h2c_tdata_1 ),
      .m_axis_h2c_tlast_1   (m_axis_h2c_tlast_1 ),
      .m_axis_h2c_tvalid_1  (m_axis_h2c_tvalid_1),
      .m_axis_h2c_tready_1  (m_axis_h2c_tready_1),
      .m_axis_h2c_tkeep_1   (m_axis_h2c_tkeep_1 ),
      .m_axis_h2c_tdata_2   (m_axis_h2c_tdata_2 ),
      .m_axis_h2c_tlast_2   (m_axis_h2c_tlast_2 ),
      .m_axis_h2c_tvalid_2  (m_axis_h2c_tvalid_2),
      .m_axis_h2c_tready_2  (m_axis_h2c_tready_2),
      .m_axis_h2c_tkeep_2   (m_axis_h2c_tkeep_2 ),
      .m_axis_h2c_tdata_3   (m_axis_h2c_tdata_3 ),
      .m_axis_h2c_tlast_3   (m_axis_h2c_tlast_3 ),
      .m_axis_h2c_tvalid_3  (m_axis_h2c_tvalid_3),
      .m_axis_h2c_tready_3  (m_axis_h2c_tready_3),
      .m_axis_h2c_tkeep_3   (m_axis_h2c_tkeep_3 ),
      
      // AXI-LITE Matser interface   
      .m_axil_awaddr        (m_axil_awaddr ),
      .m_axil_awprot        (m_axil_awprot ),
      .m_axil_awvalid       (m_axil_awvalid),
      .m_axil_awready       (m_axil_awready),
      .m_axil_wdata         (m_axil_wdata  ),
      .m_axil_wstrb         (m_axil_wstrb  ),
      .m_axil_wvalid        (m_axil_wvalid ),
      .m_axil_wready        (m_axil_wready ),
      .m_axil_bvalid        (m_axil_bvalid ),
      .m_axil_bresp         (m_axil_bresp  ),
      .m_axil_bready        (m_axil_bready ),
      .m_axil_araddr        (m_axil_araddr ),
      .m_axil_arprot        (m_axil_arprot ),
      .m_axil_arvalid       (m_axil_arvalid),
      .m_axil_arready       (m_axil_arready),
      .m_axil_rdata         (m_axil_rdata  ),
      .m_axil_rresp         (m_axil_rresp  ),
      .m_axil_rvalid        (m_axil_rvalid ),
      .m_axil_rready        (m_axil_rready ),

      // Descriptor Bypass
      .c2h_dsc_byp_ready_0    (c2h_dsc_byp_ready_0   ),
      .c2h_dsc_byp_src_addr_0 (c2h_dsc_byp_src_addr_0),
      .c2h_dsc_byp_dst_addr_0 (c2h_dsc_byp_dst_addr_0),
      .c2h_dsc_byp_len_0      (c2h_dsc_byp_len_0     ),
      .c2h_dsc_byp_ctl_0      (c2h_dsc_byp_ctl_0     ),
      .c2h_dsc_byp_load_0     (c2h_dsc_byp_load_0    ),
      
      .c2h_dsc_byp_ready_1    (c2h_dsc_byp_ready_1   ),
      .c2h_dsc_byp_src_addr_1 (c2h_dsc_byp_src_addr_1),
      .c2h_dsc_byp_dst_addr_1 (c2h_dsc_byp_dst_addr_1),
      .c2h_dsc_byp_len_1      (c2h_dsc_byp_len_1     ),
      .c2h_dsc_byp_ctl_1      (c2h_dsc_byp_ctl_1     ),
      .c2h_dsc_byp_load_1     (c2h_dsc_byp_load_1    ),  
      
      .c2h_dsc_byp_ready_2    (c2h_dsc_byp_ready_2   ),
      .c2h_dsc_byp_src_addr_2 (c2h_dsc_byp_src_addr_2),
      .c2h_dsc_byp_dst_addr_2 (c2h_dsc_byp_dst_addr_2),
      .c2h_dsc_byp_len_2      (c2h_dsc_byp_len_2     ),
      .c2h_dsc_byp_ctl_2      (c2h_dsc_byp_ctl_2     ),
      .c2h_dsc_byp_load_2     (c2h_dsc_byp_load_2    ),
      
      .c2h_dsc_byp_ready_3    (c2h_dsc_byp_ready_3   ),
      .c2h_dsc_byp_src_addr_3 (c2h_dsc_byp_src_addr_3),
      .c2h_dsc_byp_dst_addr_3 (c2h_dsc_byp_dst_addr_3),
      .c2h_dsc_byp_len_3      (c2h_dsc_byp_len_3     ),
      .c2h_dsc_byp_ctl_3      (c2h_dsc_byp_ctl_3     ),
      .c2h_dsc_byp_load_3     (c2h_dsc_byp_load_3    ),
      
      
      .h2c_dsc_byp_ready_0    (h2c_dsc_byp_ready_0   ),
      .h2c_dsc_byp_src_addr_0 (h2c_dsc_byp_src_addr_0),
      .h2c_dsc_byp_dst_addr_0 (h2c_dsc_byp_dst_addr_0),
      .h2c_dsc_byp_len_0      (h2c_dsc_byp_len_0     ),
      .h2c_dsc_byp_ctl_0      (h2c_dsc_byp_ctl_0     ),
      .h2c_dsc_byp_load_0     (h2c_dsc_byp_load_0    ),
      
      .h2c_dsc_byp_ready_1    (h2c_dsc_byp_ready_1   ),
      .h2c_dsc_byp_src_addr_1 (h2c_dsc_byp_src_addr_1),
      .h2c_dsc_byp_dst_addr_1 (h2c_dsc_byp_dst_addr_1),
      .h2c_dsc_byp_len_1      (h2c_dsc_byp_len_1     ),
      .h2c_dsc_byp_ctl_1      (h2c_dsc_byp_ctl_1     ),
      .h2c_dsc_byp_load_1     (h2c_dsc_byp_load_1    ), 
      
      .h2c_dsc_byp_ready_2    (h2c_dsc_byp_ready_2   ),
      .h2c_dsc_byp_src_addr_2 (h2c_dsc_byp_src_addr_2),
      .h2c_dsc_byp_dst_addr_2 (h2c_dsc_byp_dst_addr_2),
      .h2c_dsc_byp_len_2      (h2c_dsc_byp_len_2     ),
      .h2c_dsc_byp_ctl_2      (h2c_dsc_byp_ctl_2     ),
      .h2c_dsc_byp_load_2     (h2c_dsc_byp_load_2    ),

      .h2c_dsc_byp_ready_3    (h2c_dsc_byp_ready_3   ),
      .h2c_dsc_byp_src_addr_3 (h2c_dsc_byp_src_addr_3),
      .h2c_dsc_byp_dst_addr_3 (h2c_dsc_byp_dst_addr_3),
      .h2c_dsc_byp_len_3      (h2c_dsc_byp_len_3     ),
      .h2c_dsc_byp_ctl_3      (h2c_dsc_byp_ctl_3     ),
      .h2c_dsc_byp_load_3     (h2c_dsc_byp_load_3    ),
      
      // AXI-Lite Slave Interfaces
      .s_axil_awaddr          ({16'h0, s_axil_awaddr[15:0]}),   // input wire [31 : 0] s_axil_awaddr
      .s_axil_awprot          (s_axil_awprot               ),   // input wire [2 : 0] s_axil_awprot
      .s_axil_awvalid         (s_axil_awvalid              ),   // input wire s_axil_awvalid
      .s_axil_awready         (s_axil_awready              ),   // output wire s_axil_awready
      .s_axil_wdata           (s_axil_wdata                ),   // input wire [31 : 0] s_axil_wdata
      .s_axil_wstrb           (s_axil_wstrb                ),   // input wire [3 : 0] s_axil_wstrb
      .s_axil_wvalid          (s_axil_wvalid               ),   // input wire s_axil_wvalid
      .s_axil_wready          (s_axil_wready               ),   // output wire s_axil_wready
      .s_axil_bvalid          (s_axil_bvalid               ),   // output wire s_axil_bvalid
      .s_axil_bresp           (s_axil_bresp                ),   // output wire [1 : 0] s_axil_bresp
      .s_axil_bready          (s_axil_bready               ),   // input wire s_axil_bready
      .s_axil_araddr          ({16'h0, s_axil_araddr[15:0]}),   // input wire [31 : 0] s_axil_araddr
      .s_axil_arprot          (s_axil_arprot               ),   // input wire [2 : 0] s_axil_arprot
      .s_axil_arvalid         (s_axil_arvalid              ),   // input wire s_axil_arvalid
      .s_axil_arready         (s_axil_arready              ),   // output wire s_axil_arready
      .s_axil_rdata           (s_axil_rdata                ),   // output wire [31 : 0] s_axil_rdata
      .s_axil_rresp           (s_axil_rresp                ),   // output wire [1 : 0] s_axil_rresp
      .s_axil_rvalid          (s_axil_rvalid               ),   // output wire s_axil_rvalid
      .s_axil_rready          (s_axil_rready               ),   // input wire s_axil_rready

      .msix_enable            (msix_enable          ),    
      .msi_enable             (msi_enable           ),              // output wire msi_enable
      .msi_vector_width       (msi_vector_width     ),              // output wire [2 : 0] msi_vector_width                    
      .usr_irq_req            (xdma_irq_req         ),
      .usr_irq_ack            (xdma_irq_ack         ),

      .common_commands_in     (common_commands_in_i ),
      .pipe_rx_0_sigs         (pipe_rx_0_sigs_i     ),
      .pipe_rx_1_sigs         (pipe_rx_1_sigs_i     ),
      .pipe_rx_2_sigs         (pipe_rx_2_sigs_i     ),
      .pipe_rx_3_sigs         (pipe_rx_3_sigs_i     ),
      .pipe_rx_4_sigs         (pipe_rx_4_sigs_i     ),
      .pipe_rx_5_sigs         (pipe_rx_5_sigs_i     ),
      .pipe_rx_6_sigs         (pipe_rx_6_sigs_i     ),
      .pipe_rx_7_sigs         (pipe_rx_7_sigs_i     ),
      .common_commands_out    (common_commands_out_i),
      .pipe_tx_0_sigs         (pipe_tx_0_sigs_i     ),
      .pipe_tx_1_sigs         (pipe_tx_1_sigs_i     ),
      .pipe_tx_2_sigs         (pipe_tx_2_sigs_i     ),
      .pipe_tx_3_sigs         (pipe_tx_3_sigs_i     ),
      .pipe_tx_4_sigs         (pipe_tx_4_sigs_i     ),
      .pipe_tx_5_sigs         (pipe_tx_5_sigs_i     ),
      .pipe_tx_6_sigs         (pipe_tx_6_sigs_i     ),
      .pipe_tx_7_sigs         (pipe_tx_7_sigs_i     ),


      //-- AXI Global
      .axi_aclk               ( user_clk         ),
      .axi_aresetn            ( xdma_user_resetn ),
      .user_lnk_up            ( user_lnk_up      )
);


interrupt_ctrl#(
    .IRQ_NUM (NUM_IOCQ_IRQ+1)  
) interrupt_ctrl(
    .clk              (user_clk        ),                    
    .rst_n            (user_resetn     ),                         
    .msix_enable      (msix_enable     ),                            
    .msi_enable       (msi_enable      ),                           
    .msi_vector_width (msi_vector_width),    
//    .cq_head_0        (cq_head_0       ),        
//    .cq_head_1        (cq_head_1       ),        
//    .cq_head_2        (cq_head_2       ),        
//    .cq_head_3        (cq_head_3       ),        
//    .cq_head_4        (cq_head_4       ),        
//    .cq_head_5        (cq_head_5       ),        
//    .cq_head_6        (cq_head_6       ),        
//    .cq_head_7        (cq_head_7       ),        
//    .cq_head_8        (cq_head_8       ),        
//    .cq_head_9        (cq_head_9       ),        
//    .cq_head_10       (cq_head_10      ),         
//    .cq_head_11       (cq_head_11      ),         
//    .cq_head_12       (cq_head_12      ),         
//    .cq_head_13       (cq_head_13      ),         
//    .cq_head_14       (cq_head_14      ),         
//    .cq_head_15       (cq_head_15      ),         
//    .cq_head_16       (cq_head_16      ),                                      
    .irq_mask         (irq_mask[NUM_IOCQ_IRQ:0]    ),                          
    .xdma_irq_req     (xdma_irq_req[NUM_IOCQ_IRQ:0]),                             
    .xdma_irq_ack     (xdma_irq_ack[NUM_IOCQ_IRQ:0]),                               
    .usr_irq_enable   ({usr_irq_enable,acq_irq_enable}),                                 
    .usr_irq_req      ({irq_req,acq_irq_req}),                            
    .usr_irq_ack      ({irq_ack,acq_irq_ack})                            
);

//irq_share irq_share(
//    .clk            (user_clk                 ),     
//    .rst_n          (user_resetn              ),        
//    .irq_req        ({irq_req[0], acq_irq_req}),         
//    .irq_ack        ({irq_ack[0], acq_irq_ack}),            
//    .shared_irq_req (usr_irq_req[0]           ),                
//    .shared_irq_ack (usr_irq_ack[0]           )    
//); 

//assign acq_irq_enable = usr_irq_enable[0];
assign irq_enable = usr_irq_enable & iocq_irq_enable[NUM_IOCQ_IRQ-1:0];
//assign usr_irq_req[C_NUM_USR_IRQ-1:1] = irq_req[C_NUM_USR_IRQ-1:1];
//assign irq_ack[C_NUM_USR_IRQ-1:1] = usr_irq_ack[C_NUM_USR_IRQ-1:1];
assign xdma_irq_req[C_NUM_USR_IRQ-1:NUM_IOCQ_IRQ+1] = 0;

`ifdef NVME_ADMIN_ONLY
    assign irq_req[NUM_IOCQ_IRQ-1:0] = 0;
`endif


regfile regfile(
    .aclk              (user_clk           ),
    .areset            (~xdma_user_resetn  ),
    .aclk_en           (1'b1               ),
    .axil_awready      (m_axil_awready     ),
    .axil_awvalid      (m_axil_awvalid     ),
    .axil_awaddr       (m_axil_awaddr[15:0]),
    .axil_wready       (m_axil_wready      ),
    .axil_wvalid       (m_axil_wvalid      ),
    .axil_wdata        (m_axil_wdata       ),
    .axil_wstrb        (m_axil_wstrb       ),
    .axil_bready       (m_axil_bready      ),
    .axil_bvalid       (m_axil_bvalid      ),
    .axil_bresp        (m_axil_bresp       ),
    .axil_arready      (m_axil_arready     ),
    .axil_arvalid      (m_axil_arvalid     ),
    .axil_araddr       (m_axil_araddr[15:0]),
    .axil_rready       (m_axil_rready      ),
    .axil_rvalid       (m_axil_rvalid      ),
    .axil_rdata        (m_axil_rdata       ),
    .axil_rresp        (m_axil_rresp       ),
    .dma_soft_rstn     (dma_soft_rstn      ),
    .nvme_reg_cc_en    (nvme_reg_cc_en     ),
    .nvme_reg_csts_rdy (nvme_reg_csts_rdy  ),
    .nvme_reg_cc_shn   (nvme_reg_cc_shn    ),
    .nvme_reg_csts_shst(nvme_reg_csts_shst ),
    .nvme_cc_reset     (~user_resetn       ),
    .mps_width         (mps_width          ),
    .irq_mask          (irq_mask           ),
    .o_sq_base_addr_0  (sq_base_addr_0     ),
    .o_sq_size_0       (sq_size_0          ),
    .o_sq_tail_0       (sq_tail_0          ),
    .o_cq_base_addr_0  (cq_base_addr_0     ),
    .o_cq_size_0       (cq_size_0          ),
    .o_cq_head_0       (cq_head_0          ),
    .o_sq_tail_1       (sq_tail_1          ),
    .o_cq_head_1       (cq_head_1          ),
    .o_sq_tail_2       (sq_tail_2          ),
    .o_cq_head_2       (cq_head_2          ),
    .o_sq_tail_3       (sq_tail_3          ),
    .o_cq_head_3       (cq_head_3          ),
    .o_sq_tail_4       (sq_tail_4          ),
    .o_cq_head_4       (cq_head_4          ),
    .o_sq_tail_5       (sq_tail_5          ),
    .o_cq_head_5       (cq_head_5          ),
    .o_sq_tail_6       (sq_tail_6          ),
    .o_cq_head_6       (cq_head_6          ),
    .o_sq_tail_7       (sq_tail_7          ),
    .o_cq_head_7       (cq_head_7          ),
    .o_sq_tail_8       (sq_tail_8          ),
    .o_cq_head_8       (cq_head_8          ),
    .o_sq_tail_9       (sq_tail_9          ),
    .o_cq_head_9       (cq_head_9          ),
    .o_sq_tail_10      (sq_tail_10         ),
    .o_cq_head_10      (cq_head_10         ),
    .o_sq_tail_11      (sq_tail_11         ),
    .o_cq_head_11      (cq_head_11         ),
    .o_sq_tail_12      (sq_tail_12         ),
    .o_cq_head_12      (cq_head_12         ),
    .o_sq_tail_13      (sq_tail_13         ),
    .o_cq_head_13      (cq_head_13         ),
    .o_sq_tail_14      (sq_tail_14         ),
    .o_cq_head_14      (cq_head_14         ),
    .o_sq_tail_15      (sq_tail_15         ),
    .o_cq_head_15      (cq_head_15         ),
    .o_sq_tail_16      (sq_tail_16         ),
    .o_cq_head_16      (cq_head_16         )
);

nvme_config nvme_config(
    .clk               (user_clk         ), 
    .nvme_reg_cc_en    (nvme_reg_cc_en   ), 
    .pl_reset          (nvme_cc_reset    ), 
//    .pl_rdy            (pl_csts_rdy      ), 
    .ps_rdy            (ps_csts_rdy      ),//(ps_csts_rdy      ), 
    .nvme_reg_csts_rdy (nvme_reg_csts_rdy),
    .nvme_reg_cc_shn   (nvme_reg_cc_shn  ),
//    .pl_shst           (pl_csts_shst     ),
    .ps_shst           (ps_csts_shst     ),
    .nvme_reg_csts_shst(nvme_reg_csts_shst)  
);


proc_sys_reset_1 global_reset_0 (
  .slowest_sync_clk    (user_clk          ),          // input wire slowest_sync_clk
  .ext_reset_in        (~xdma_user_resetn ),                  // input wire ext_reset_in
  .aux_reset_in        (nvme_cc_reset     ),                  // input wire aux_reset_in
  .mb_debug_sys_rst    (1'b0              ),          // input wire mb_debug_sys_rst
  .dcm_locked          (1'b1              ),                      // input wire dcm_locked
  .mb_reset            (                  ),                          // output wire mb_reset
  .bus_struct_reset    (                  ),          // output wire [0 : 0] bus_struct_reset
  .peripheral_reset    (                  ),          // output wire [0 : 0] peripheral_reset
  .interconnect_aresetn(                  ),     // output wire [0 : 0] interconnect_aresetn
  .peripheral_aresetn  (user_resetn       )      // output wire [0 : 0] peripheral_aresetn
);


//always @(posedge user_clk) begin
//  if(!user_resetn) begin
//    pl_csts_rdy <= 1'h0;
//    pl_csts_shst <= 2'h0;
//  end else begin
//    pl_csts_rdy <= 1'h1;
//    pl_csts_shst <= 2'h2;
//  end
//end



`ifndef NVME_ADMIN_USE_PS
//    assign ps_csts_rdy = pl_csts_rdy;
    assign ps_csts_rdy = 1'b1;
`endif


`ifdef NVME_IO_SIXTEEN
// 4 C2H/H2C DMA Channels are divided into two groups
// alternately dispatch 16 i/o interfaces to the two groups
  xdma_if_arbiter_top xdma_if_arbiter_top(
    .clk                       (user_clk                 ),          
    .rst_n                     (user_resetn              ),       
    .c2h_dsc_byp_ready_0       (c2h_dsc_byp_ready_0      ),                
    .c2h_dsc_byp_load_0        (c2h_dsc_byp_load_0       ),             
    .c2h_dsc_byp_src_addr_0    (c2h_dsc_byp_src_addr_0   ),                   
    .c2h_dsc_byp_dst_addr_0    (c2h_dsc_byp_dst_addr_0   ),                   
    .c2h_dsc_byp_len_0         (c2h_dsc_byp_len_0        ),              
    .c2h_dsc_byp_ctl_0         (c2h_dsc_byp_ctl_0        ),              
    .h2c_dsc_byp_ready_0       (h2c_dsc_byp_ready_0      ),                
    .h2c_dsc_byp_load_0        (h2c_dsc_byp_load_0       ),             
    .h2c_dsc_byp_src_addr_0    (h2c_dsc_byp_src_addr_0   ),                   
    .h2c_dsc_byp_dst_addr_0    (h2c_dsc_byp_dst_addr_0   ),                   
    .h2c_dsc_byp_len_0         (h2c_dsc_byp_len_0        ),              
    .h2c_dsc_byp_ctl_0         (h2c_dsc_byp_ctl_0        ),             
    .c2h_dsc_byp_ready_1       (c2h_dsc_byp_ready_1      ),                
    .c2h_dsc_byp_load_1        (c2h_dsc_byp_load_1       ),             
    .c2h_dsc_byp_src_addr_1    (c2h_dsc_byp_src_addr_1   ),                   
    .c2h_dsc_byp_dst_addr_1    (c2h_dsc_byp_dst_addr_1   ),                   
    .c2h_dsc_byp_len_1         (c2h_dsc_byp_len_1        ),              
    .c2h_dsc_byp_ctl_1         (c2h_dsc_byp_ctl_1        ),              
    .h2c_dsc_byp_ready_1       (h2c_dsc_byp_ready_1      ),                
    .h2c_dsc_byp_load_1        (h2c_dsc_byp_load_1       ),             
    .h2c_dsc_byp_src_addr_1    (h2c_dsc_byp_src_addr_1   ),                   
    .h2c_dsc_byp_dst_addr_1    (h2c_dsc_byp_dst_addr_1   ),                   
    .h2c_dsc_byp_len_1         (h2c_dsc_byp_len_1        ),              
    .h2c_dsc_byp_ctl_1         (h2c_dsc_byp_ctl_1        ),            
    .c2h_dsc_byp_ready_2       (c2h_dsc_byp_ready_2      ),                
    .c2h_dsc_byp_load_2        (c2h_dsc_byp_load_2       ),             
    .c2h_dsc_byp_src_addr_2    (c2h_dsc_byp_src_addr_2   ),                   
    .c2h_dsc_byp_dst_addr_2    (c2h_dsc_byp_dst_addr_2   ),                   
    .c2h_dsc_byp_len_2         (c2h_dsc_byp_len_2        ),              
    .c2h_dsc_byp_ctl_2         (c2h_dsc_byp_ctl_2        ),              
    .h2c_dsc_byp_ready_2       (h2c_dsc_byp_ready_2      ),                
    .h2c_dsc_byp_load_2        (h2c_dsc_byp_load_2       ),             
    .h2c_dsc_byp_src_addr_2    (h2c_dsc_byp_src_addr_2   ),                   
    .h2c_dsc_byp_dst_addr_2    (h2c_dsc_byp_dst_addr_2   ),                   
    .h2c_dsc_byp_len_2         (h2c_dsc_byp_len_2        ),              
    .h2c_dsc_byp_ctl_2         (h2c_dsc_byp_ctl_2        ),             
    .c2h_dsc_byp_ready_3       (c2h_dsc_byp_ready_3      ),                
    .c2h_dsc_byp_load_3        (c2h_dsc_byp_load_3       ),             
    .c2h_dsc_byp_src_addr_3    (c2h_dsc_byp_src_addr_3   ),                   
    .c2h_dsc_byp_dst_addr_3    (c2h_dsc_byp_dst_addr_3   ),                   
    .c2h_dsc_byp_len_3         (c2h_dsc_byp_len_3        ),              
    .c2h_dsc_byp_ctl_3         (c2h_dsc_byp_ctl_3        ),              
    .h2c_dsc_byp_ready_3       (h2c_dsc_byp_ready_3      ),                
    .h2c_dsc_byp_load_3        (h2c_dsc_byp_load_3       ),             
    .h2c_dsc_byp_src_addr_3    (h2c_dsc_byp_src_addr_3   ),                   
    .h2c_dsc_byp_dst_addr_3    (h2c_dsc_byp_dst_addr_3   ),                   
    .h2c_dsc_byp_len_3         (h2c_dsc_byp_len_3        ),              
    .h2c_dsc_byp_ctl_3         (h2c_dsc_byp_ctl_3        ),              
    .axis_h2c_tready_0         (m_axis_h2c_tready_0      ),           
    .axis_h2c_tvalid_0         (m_axis_h2c_tvalid_0      ),           
    .axis_h2c_tdata_0          (m_axis_h2c_tdata_0       ),          
    .axis_h2c_tkeep_0          (m_axis_h2c_tkeep_0       ),          
    .axis_h2c_tlast_0          (m_axis_h2c_tlast_0       ),                   
    .axis_c2h_tready_0         (m_axis_c2h_tready_0      ),           
    .axis_c2h_tvalid_0         (m_axis_c2h_tvalid_0      ),           
    .axis_c2h_tdata_0          (m_axis_c2h_tdata_0       ),          
    .axis_c2h_tkeep_0          (m_axis_c2h_tkeep_0       ),          
    .axis_c2h_tlast_0          (m_axis_c2h_tlast_0       ),          
    .axis_h2c_tready_1         (m_axis_h2c_tready_1      ),           
    .axis_h2c_tvalid_1         (m_axis_h2c_tvalid_1      ),           
    .axis_h2c_tdata_1          (m_axis_h2c_tdata_1       ),          
    .axis_h2c_tkeep_1          (m_axis_h2c_tkeep_1       ),          
    .axis_h2c_tlast_1          (m_axis_h2c_tlast_1       ),                   
    .axis_c2h_tready_1         (m_axis_c2h_tready_1      ),           
    .axis_c2h_tvalid_1         (m_axis_c2h_tvalid_1      ),           
    .axis_c2h_tdata_1          (m_axis_c2h_tdata_1       ),          
    .axis_c2h_tkeep_1          (m_axis_c2h_tkeep_1       ),          
    .axis_c2h_tlast_1          (m_axis_c2h_tlast_1       ),          
    .axis_h2c_tready_2         (m_axis_h2c_tready_2      ),           
    .axis_h2c_tvalid_2         (m_axis_h2c_tvalid_2      ),           
    .axis_h2c_tdata_2          (m_axis_h2c_tdata_2       ),          
    .axis_h2c_tkeep_2          (m_axis_h2c_tkeep_2       ),          
    .axis_h2c_tlast_2          (m_axis_h2c_tlast_2       ),                   
    .axis_c2h_tready_2         (m_axis_c2h_tready_2      ),           
    .axis_c2h_tvalid_2         (m_axis_c2h_tvalid_2      ),           
    .axis_c2h_tdata_2          (m_axis_c2h_tdata_2       ),          
    .axis_c2h_tkeep_2          (m_axis_c2h_tkeep_2       ),          
    .axis_c2h_tlast_2          (m_axis_c2h_tlast_2       ),          
    .axis_h2c_tready_3         (m_axis_h2c_tready_3      ),           
    .axis_h2c_tvalid_3         (m_axis_h2c_tvalid_3      ),           
    .axis_h2c_tdata_3          (m_axis_h2c_tdata_3       ),          
    .axis_h2c_tkeep_3          (m_axis_h2c_tkeep_3       ),          
    .axis_h2c_tlast_3          (m_axis_h2c_tlast_3       ),                   
    .axis_c2h_tready_3         (m_axis_c2h_tready_3      ),           
    .axis_c2h_tvalid_3         (m_axis_c2h_tvalid_3      ),           
    .axis_c2h_tdata_3          (m_axis_c2h_tdata_3       ),          
    .axis_c2h_tkeep_3          (m_axis_c2h_tkeep_3       ),          
    .axis_c2h_tlast_3          (m_axis_c2h_tlast_3       ),          
    .a_h2c_dsc_byp_ready_0     (a_h2c_dsc_byp_ready_0    ),                  
    .a_h2c_dsc_byp_load_0      (a_h2c_dsc_byp_load_0     ),               
    .a_h2c_dsc_byp_src_addr_0  (a_h2c_dsc_byp_src_addr_0 ),                     
    .a_h2c_dsc_byp_dst_addr_0  (a_h2c_dsc_byp_dst_addr_0 ),                     
    .a_h2c_dsc_byp_len_0       (a_h2c_dsc_byp_len_0      ),                
    .a_h2c_dsc_byp_ctl_0       (a_h2c_dsc_byp_ctl_0      ),              
    .a_c2h_dsc_byp_ready_0     (a_c2h_dsc_byp_ready_0    ),                  
    .a_c2h_dsc_byp_load_0      (a_c2h_dsc_byp_load_0     ),               
    .a_c2h_dsc_byp_src_addr_0  (a_c2h_dsc_byp_src_addr_0 ),                     
    .a_c2h_dsc_byp_dst_addr_0  (a_c2h_dsc_byp_dst_addr_0 ),                     
    .a_c2h_dsc_byp_len_0       (a_c2h_dsc_byp_len_0      ),                
    .a_c2h_dsc_byp_ctl_0       (a_c2h_dsc_byp_ctl_0      ),              
    .a_axis_h2c_tready_0       (a_axis_h2c_tready_0      ),             
    .a_axis_h2c_tvalid_0       (a_axis_h2c_tvalid_0      ),             
    .a_axis_h2c_tdata_0        (a_axis_h2c_tdata_0       ),            
    .a_axis_h2c_tkeep_0        (a_axis_h2c_tkeep_0       ),            
    .a_axis_h2c_tlast_0        (a_axis_h2c_tlast_0       ),             
    .a_axis_c2h_tready_0       (a_axis_c2h_tready_0      ),             
    .a_axis_c2h_tvalid_0       (a_axis_c2h_tvalid_0      ),             
    .a_axis_c2h_tdata_0        (a_axis_c2h_tdata_0       ),            
    .a_axis_c2h_tkeep_0        (a_axis_c2h_tkeep_0       ),            
    .a_axis_c2h_tlast_0        (a_axis_c2h_tlast_0       ),             
    .q_h2c_dsc_byp_ready_1     (q_h2c_dsc_byp_ready_1    ),                  
    .q_h2c_dsc_byp_load_1      (q_h2c_dsc_byp_load_1     ),               
    .q_h2c_dsc_byp_src_addr_1  (q_h2c_dsc_byp_src_addr_1 ),                     
    .q_h2c_dsc_byp_dst_addr_1  (q_h2c_dsc_byp_dst_addr_1 ),                     
    .q_h2c_dsc_byp_len_1       (q_h2c_dsc_byp_len_1      ),                
    .q_h2c_dsc_byp_ctl_1       (q_h2c_dsc_byp_ctl_1      ),              
    .q_c2h_dsc_byp_ready_1     (q_c2h_dsc_byp_ready_1    ),                  
    .q_c2h_dsc_byp_load_1      (q_c2h_dsc_byp_load_1     ),               
    .q_c2h_dsc_byp_src_addr_1  (q_c2h_dsc_byp_src_addr_1 ),                     
    .q_c2h_dsc_byp_dst_addr_1  (q_c2h_dsc_byp_dst_addr_1 ),                     
    .q_c2h_dsc_byp_len_1       (q_c2h_dsc_byp_len_1      ),                
    .q_c2h_dsc_byp_ctl_1       (q_c2h_dsc_byp_ctl_1      ),              
    .q_axis_h2c_tready_1       (q_axis_h2c_tready_1      ),             
    .q_axis_h2c_tvalid_1       (q_axis_h2c_tvalid_1      ),             
    .q_axis_h2c_tdata_1        (q_axis_h2c_tdata_1       ),            
    .q_axis_h2c_tkeep_1        (q_axis_h2c_tkeep_1       ),            
    .q_axis_h2c_tlast_1        (q_axis_h2c_tlast_1       ),             
    .q_axis_c2h_tready_1       (q_axis_c2h_tready_1      ),             
    .q_axis_c2h_tvalid_1       (q_axis_c2h_tvalid_1      ),             
    .q_axis_c2h_tdata_1        (q_axis_c2h_tdata_1       ),            
    .q_axis_c2h_tkeep_1        (q_axis_c2h_tkeep_1       ),            
    .q_axis_c2h_tlast_1        (q_axis_c2h_tlast_1       ),             
    .q_h2c_dsc_byp_ready_2     (q_h2c_dsc_byp_ready_3    ),                  
    .q_h2c_dsc_byp_load_2      (q_h2c_dsc_byp_load_3     ),               
    .q_h2c_dsc_byp_src_addr_2  (q_h2c_dsc_byp_src_addr_3 ),                     
    .q_h2c_dsc_byp_dst_addr_2  (q_h2c_dsc_byp_dst_addr_3 ),                     
    .q_h2c_dsc_byp_len_2       (q_h2c_dsc_byp_len_3      ),                
    .q_h2c_dsc_byp_ctl_2       (q_h2c_dsc_byp_ctl_3      ),              
    .q_c2h_dsc_byp_ready_2     (q_c2h_dsc_byp_ready_3    ),                  
    .q_c2h_dsc_byp_load_2      (q_c2h_dsc_byp_load_3     ),               
    .q_c2h_dsc_byp_src_addr_2  (q_c2h_dsc_byp_src_addr_3 ),                     
    .q_c2h_dsc_byp_dst_addr_2  (q_c2h_dsc_byp_dst_addr_3 ),                     
    .q_c2h_dsc_byp_len_2       (q_c2h_dsc_byp_len_3      ),                
    .q_c2h_dsc_byp_ctl_2       (q_c2h_dsc_byp_ctl_3      ),              
    .q_axis_h2c_tready_2       (q_axis_h2c_tready_3      ),             
    .q_axis_h2c_tvalid_2       (q_axis_h2c_tvalid_3      ),             
    .q_axis_h2c_tdata_2        (q_axis_h2c_tdata_3       ),            
    .q_axis_h2c_tkeep_2        (q_axis_h2c_tkeep_3       ),            
    .q_axis_h2c_tlast_2        (q_axis_h2c_tlast_3       ),             
    .q_axis_c2h_tready_2       (q_axis_c2h_tready_3      ),             
    .q_axis_c2h_tvalid_2       (q_axis_c2h_tvalid_3      ),             
    .q_axis_c2h_tdata_2        (q_axis_c2h_tdata_3       ),            
    .q_axis_c2h_tkeep_2        (q_axis_c2h_tkeep_3       ),            
    .q_axis_c2h_tlast_2        (q_axis_c2h_tlast_3       ),             
    .q_h2c_dsc_byp_ready_3     (q_h2c_dsc_byp_ready_5    ),                  
    .q_h2c_dsc_byp_load_3      (q_h2c_dsc_byp_load_5     ),               
    .q_h2c_dsc_byp_src_addr_3  (q_h2c_dsc_byp_src_addr_5 ),                     
    .q_h2c_dsc_byp_dst_addr_3  (q_h2c_dsc_byp_dst_addr_5 ),                     
    .q_h2c_dsc_byp_len_3       (q_h2c_dsc_byp_len_5      ),                
    .q_h2c_dsc_byp_ctl_3       (q_h2c_dsc_byp_ctl_5      ),              
    .q_c2h_dsc_byp_ready_3     (q_c2h_dsc_byp_ready_5    ),                  
    .q_c2h_dsc_byp_load_3      (q_c2h_dsc_byp_load_5     ),               
    .q_c2h_dsc_byp_src_addr_3  (q_c2h_dsc_byp_src_addr_5 ),                     
    .q_c2h_dsc_byp_dst_addr_3  (q_c2h_dsc_byp_dst_addr_5 ),                     
    .q_c2h_dsc_byp_len_3       (q_c2h_dsc_byp_len_5      ),                
    .q_c2h_dsc_byp_ctl_3       (q_c2h_dsc_byp_ctl_5      ),              
    .q_axis_h2c_tready_3       (q_axis_h2c_tready_5      ),             
    .q_axis_h2c_tvalid_3       (q_axis_h2c_tvalid_5      ),             
    .q_axis_h2c_tdata_3        (q_axis_h2c_tdata_5       ),            
    .q_axis_h2c_tkeep_3        (q_axis_h2c_tkeep_5       ),            
    .q_axis_h2c_tlast_3        (q_axis_h2c_tlast_5       ),             
    .q_axis_c2h_tready_3       (q_axis_c2h_tready_5      ),             
    .q_axis_c2h_tvalid_3       (q_axis_c2h_tvalid_5      ),             
    .q_axis_c2h_tdata_3        (q_axis_c2h_tdata_5       ),            
    .q_axis_c2h_tkeep_3        (q_axis_c2h_tkeep_5       ),            
    .q_axis_c2h_tlast_3        (q_axis_c2h_tlast_5       ),             
    .q_h2c_dsc_byp_ready_4     (q_h2c_dsc_byp_ready_7    ),                  
    .q_h2c_dsc_byp_load_4      (q_h2c_dsc_byp_load_7     ),               
    .q_h2c_dsc_byp_src_addr_4  (q_h2c_dsc_byp_src_addr_7 ),                     
    .q_h2c_dsc_byp_dst_addr_4  (q_h2c_dsc_byp_dst_addr_7 ),                     
    .q_h2c_dsc_byp_len_4       (q_h2c_dsc_byp_len_7      ),                
    .q_h2c_dsc_byp_ctl_4       (q_h2c_dsc_byp_ctl_7      ),              
    .q_c2h_dsc_byp_ready_4     (q_c2h_dsc_byp_ready_7    ),                  
    .q_c2h_dsc_byp_load_4      (q_c2h_dsc_byp_load_7     ),               
    .q_c2h_dsc_byp_src_addr_4  (q_c2h_dsc_byp_src_addr_7 ),                     
    .q_c2h_dsc_byp_dst_addr_4  (q_c2h_dsc_byp_dst_addr_7 ),                     
    .q_c2h_dsc_byp_len_4       (q_c2h_dsc_byp_len_7      ),                
    .q_c2h_dsc_byp_ctl_4       (q_c2h_dsc_byp_ctl_7      ),              
    .q_axis_h2c_tready_4       (q_axis_h2c_tready_7      ),             
    .q_axis_h2c_tvalid_4       (q_axis_h2c_tvalid_7      ),             
    .q_axis_h2c_tdata_4        (q_axis_h2c_tdata_7       ),            
    .q_axis_h2c_tkeep_4        (q_axis_h2c_tkeep_7       ),            
    .q_axis_h2c_tlast_4        (q_axis_h2c_tlast_7       ),             
    .q_axis_c2h_tready_4       (q_axis_c2h_tready_7      ),             
    .q_axis_c2h_tvalid_4       (q_axis_c2h_tvalid_7      ),             
    .q_axis_c2h_tdata_4        (q_axis_c2h_tdata_7       ),            
    .q_axis_c2h_tkeep_4        (q_axis_c2h_tkeep_7       ),            
    .q_axis_c2h_tlast_4        (q_axis_c2h_tlast_7       ),             
    .q_h2c_dsc_byp_ready_5     (q_h2c_dsc_byp_ready_9    ),                  
    .q_h2c_dsc_byp_load_5      (q_h2c_dsc_byp_load_9     ),               
    .q_h2c_dsc_byp_src_addr_5  (q_h2c_dsc_byp_src_addr_9 ),                     
    .q_h2c_dsc_byp_dst_addr_5  (q_h2c_dsc_byp_dst_addr_9 ),                     
    .q_h2c_dsc_byp_len_5       (q_h2c_dsc_byp_len_9      ),                
    .q_h2c_dsc_byp_ctl_5       (q_h2c_dsc_byp_ctl_9      ),              
    .q_c2h_dsc_byp_ready_5     (q_c2h_dsc_byp_ready_9    ),                  
    .q_c2h_dsc_byp_load_5      (q_c2h_dsc_byp_load_9     ),               
    .q_c2h_dsc_byp_src_addr_5  (q_c2h_dsc_byp_src_addr_9 ),                     
    .q_c2h_dsc_byp_dst_addr_5  (q_c2h_dsc_byp_dst_addr_9 ),                     
    .q_c2h_dsc_byp_len_5       (q_c2h_dsc_byp_len_9      ),                
    .q_c2h_dsc_byp_ctl_5       (q_c2h_dsc_byp_ctl_9      ),              
    .q_axis_h2c_tready_5       (q_axis_h2c_tready_9      ),             
    .q_axis_h2c_tvalid_5       (q_axis_h2c_tvalid_9      ),             
    .q_axis_h2c_tdata_5        (q_axis_h2c_tdata_9       ),            
    .q_axis_h2c_tkeep_5        (q_axis_h2c_tkeep_9       ),            
    .q_axis_h2c_tlast_5        (q_axis_h2c_tlast_9       ),             
    .q_axis_c2h_tready_5       (q_axis_c2h_tready_9      ),             
    .q_axis_c2h_tvalid_5       (q_axis_c2h_tvalid_9      ),             
    .q_axis_c2h_tdata_5        (q_axis_c2h_tdata_9       ),            
    .q_axis_c2h_tkeep_5        (q_axis_c2h_tkeep_9       ),            
    .q_axis_c2h_tlast_5        (q_axis_c2h_tlast_9       ),             
    .q_h2c_dsc_byp_ready_6     (q_h2c_dsc_byp_ready_11   ),                  
    .q_h2c_dsc_byp_load_6      (q_h2c_dsc_byp_load_11    ),               
    .q_h2c_dsc_byp_src_addr_6  (q_h2c_dsc_byp_src_addr_11),                     
    .q_h2c_dsc_byp_dst_addr_6  (q_h2c_dsc_byp_dst_addr_11),                     
    .q_h2c_dsc_byp_len_6       (q_h2c_dsc_byp_len_11     ),                
    .q_h2c_dsc_byp_ctl_6       (q_h2c_dsc_byp_ctl_11     ),              
    .q_c2h_dsc_byp_ready_6     (q_c2h_dsc_byp_ready_11   ),                  
    .q_c2h_dsc_byp_load_6      (q_c2h_dsc_byp_load_11    ),               
    .q_c2h_dsc_byp_src_addr_6  (q_c2h_dsc_byp_src_addr_11),                     
    .q_c2h_dsc_byp_dst_addr_6  (q_c2h_dsc_byp_dst_addr_11),                     
    .q_c2h_dsc_byp_len_6       (q_c2h_dsc_byp_len_11     ),                
    .q_c2h_dsc_byp_ctl_6       (q_c2h_dsc_byp_ctl_11     ),              
    .q_axis_h2c_tready_6       (q_axis_h2c_tready_11     ),             
    .q_axis_h2c_tvalid_6       (q_axis_h2c_tvalid_11     ),             
    .q_axis_h2c_tdata_6        (q_axis_h2c_tdata_11      ),            
    .q_axis_h2c_tkeep_6        (q_axis_h2c_tkeep_11      ),            
    .q_axis_h2c_tlast_6        (q_axis_h2c_tlast_11      ),             
    .q_axis_c2h_tready_6       (q_axis_c2h_tready_11     ),             
    .q_axis_c2h_tvalid_6       (q_axis_c2h_tvalid_11     ),             
    .q_axis_c2h_tdata_6        (q_axis_c2h_tdata_11      ),            
    .q_axis_c2h_tkeep_6        (q_axis_c2h_tkeep_11      ),            
    .q_axis_c2h_tlast_6        (q_axis_c2h_tlast_11      ),             
    .q_h2c_dsc_byp_ready_7     (q_h2c_dsc_byp_ready_13   ),                  
    .q_h2c_dsc_byp_load_7      (q_h2c_dsc_byp_load_13    ),               
    .q_h2c_dsc_byp_src_addr_7  (q_h2c_dsc_byp_src_addr_13),                     
    .q_h2c_dsc_byp_dst_addr_7  (q_h2c_dsc_byp_dst_addr_13),                     
    .q_h2c_dsc_byp_len_7       (q_h2c_dsc_byp_len_13     ),                
    .q_h2c_dsc_byp_ctl_7       (q_h2c_dsc_byp_ctl_13     ),              
    .q_c2h_dsc_byp_ready_7     (q_c2h_dsc_byp_ready_13   ),                  
    .q_c2h_dsc_byp_load_7      (q_c2h_dsc_byp_load_13    ),               
    .q_c2h_dsc_byp_src_addr_7  (q_c2h_dsc_byp_src_addr_13),                     
    .q_c2h_dsc_byp_dst_addr_7  (q_c2h_dsc_byp_dst_addr_13),                     
    .q_c2h_dsc_byp_len_7       (q_c2h_dsc_byp_len_13     ),                
    .q_c2h_dsc_byp_ctl_7       (q_c2h_dsc_byp_ctl_13     ),              
    .q_axis_h2c_tready_7       (q_axis_h2c_tready_13     ),             
    .q_axis_h2c_tvalid_7       (q_axis_h2c_tvalid_13     ),             
    .q_axis_h2c_tdata_7        (q_axis_h2c_tdata_13      ),            
    .q_axis_h2c_tkeep_7        (q_axis_h2c_tkeep_13      ),            
    .q_axis_h2c_tlast_7        (q_axis_h2c_tlast_13      ),             
    .q_axis_c2h_tready_7       (q_axis_c2h_tready_13     ),             
    .q_axis_c2h_tvalid_7       (q_axis_c2h_tvalid_13     ),             
    .q_axis_c2h_tdata_7        (q_axis_c2h_tdata_13      ),            
    .q_axis_c2h_tkeep_7        (q_axis_c2h_tkeep_13      ),            
    .q_axis_c2h_tlast_7        (q_axis_c2h_tlast_13      ),             
    .q_h2c_dsc_byp_ready_8     (q_h2c_dsc_byp_ready_15   ),                  
    .q_h2c_dsc_byp_load_8      (q_h2c_dsc_byp_load_15    ),               
    .q_h2c_dsc_byp_src_addr_8  (q_h2c_dsc_byp_src_addr_15),                     
    .q_h2c_dsc_byp_dst_addr_8  (q_h2c_dsc_byp_dst_addr_15),                     
    .q_h2c_dsc_byp_len_8       (q_h2c_dsc_byp_len_15     ),                
    .q_h2c_dsc_byp_ctl_8       (q_h2c_dsc_byp_ctl_15     ),              
    .q_c2h_dsc_byp_ready_8     (q_c2h_dsc_byp_ready_15   ),                  
    .q_c2h_dsc_byp_load_8      (q_c2h_dsc_byp_load_15    ),               
    .q_c2h_dsc_byp_src_addr_8  (q_c2h_dsc_byp_src_addr_15),                     
    .q_c2h_dsc_byp_dst_addr_8  (q_c2h_dsc_byp_dst_addr_15),                     
    .q_c2h_dsc_byp_len_8       (q_c2h_dsc_byp_len_15     ),                
    .q_c2h_dsc_byp_ctl_8       (q_c2h_dsc_byp_ctl_15     ),              
    .q_axis_h2c_tready_8       (q_axis_h2c_tready_15     ),             
    .q_axis_h2c_tvalid_8       (q_axis_h2c_tvalid_15     ),             
    .q_axis_h2c_tdata_8        (q_axis_h2c_tdata_15      ),            
    .q_axis_h2c_tkeep_8        (q_axis_h2c_tkeep_15      ),            
    .q_axis_h2c_tlast_8        (q_axis_h2c_tlast_15      ),             
    .q_axis_c2h_tready_8       (q_axis_c2h_tready_15     ),             
    .q_axis_c2h_tvalid_8       (q_axis_c2h_tvalid_15     ),             
    .q_axis_c2h_tdata_8        (q_axis_c2h_tdata_15      ),            
    .q_axis_c2h_tkeep_8        (q_axis_c2h_tkeep_15      ),            
    .q_axis_c2h_tlast_8        (q_axis_c2h_tlast_15      ),             
    .q_h2c_dsc_byp_ready_9     (q_h2c_dsc_byp_ready_2    ),                  
    .q_h2c_dsc_byp_load_9      (q_h2c_dsc_byp_load_2     ),               
    .q_h2c_dsc_byp_src_addr_9  (q_h2c_dsc_byp_src_addr_2 ),                     
    .q_h2c_dsc_byp_dst_addr_9  (q_h2c_dsc_byp_dst_addr_2 ),                     
    .q_h2c_dsc_byp_len_9       (q_h2c_dsc_byp_len_2      ),                
    .q_h2c_dsc_byp_ctl_9       (q_h2c_dsc_byp_ctl_2      ),              
    .q_c2h_dsc_byp_ready_9     (q_c2h_dsc_byp_ready_2    ),                  
    .q_c2h_dsc_byp_load_9      (q_c2h_dsc_byp_load_2     ),               
    .q_c2h_dsc_byp_src_addr_9  (q_c2h_dsc_byp_src_addr_2 ),                     
    .q_c2h_dsc_byp_dst_addr_9  (q_c2h_dsc_byp_dst_addr_2 ),                     
    .q_c2h_dsc_byp_len_9       (q_c2h_dsc_byp_len_2      ),                
    .q_c2h_dsc_byp_ctl_9       (q_c2h_dsc_byp_ctl_2      ),              
    .q_axis_h2c_tready_9       (q_axis_h2c_tready_2      ),             
    .q_axis_h2c_tvalid_9       (q_axis_h2c_tvalid_2      ),             
    .q_axis_h2c_tdata_9        (q_axis_h2c_tdata_2       ),            
    .q_axis_h2c_tkeep_9        (q_axis_h2c_tkeep_2       ),            
    .q_axis_h2c_tlast_9        (q_axis_h2c_tlast_2       ),             
    .q_axis_c2h_tready_9       (q_axis_c2h_tready_2      ),             
    .q_axis_c2h_tvalid_9       (q_axis_c2h_tvalid_2      ),             
    .q_axis_c2h_tdata_9        (q_axis_c2h_tdata_2       ),            
    .q_axis_c2h_tkeep_9        (q_axis_c2h_tkeep_2       ),            
    .q_axis_c2h_tlast_9        (q_axis_c2h_tlast_2       ),             
    .q_h2c_dsc_byp_ready_10    (q_h2c_dsc_byp_ready_4    ),                   
    .q_h2c_dsc_byp_load_10     (q_h2c_dsc_byp_load_4     ),                
    .q_h2c_dsc_byp_src_addr_10 (q_h2c_dsc_byp_src_addr_4 ),                      
    .q_h2c_dsc_byp_dst_addr_10 (q_h2c_dsc_byp_dst_addr_4 ),                      
    .q_h2c_dsc_byp_len_10      (q_h2c_dsc_byp_len_4      ),                 
    .q_h2c_dsc_byp_ctl_10      (q_h2c_dsc_byp_ctl_4      ),               
    .q_c2h_dsc_byp_ready_10    (q_c2h_dsc_byp_ready_4    ),                   
    .q_c2h_dsc_byp_load_10     (q_c2h_dsc_byp_load_4     ),                
    .q_c2h_dsc_byp_src_addr_10 (q_c2h_dsc_byp_src_addr_4 ),                      
    .q_c2h_dsc_byp_dst_addr_10 (q_c2h_dsc_byp_dst_addr_4 ),                      
    .q_c2h_dsc_byp_len_10      (q_c2h_dsc_byp_len_4      ),                 
    .q_c2h_dsc_byp_ctl_10      (q_c2h_dsc_byp_ctl_4      ),               
    .q_axis_h2c_tready_10      (q_axis_h2c_tready_4      ),              
    .q_axis_h2c_tvalid_10      (q_axis_h2c_tvalid_4      ),              
    .q_axis_h2c_tdata_10       (q_axis_h2c_tdata_4       ),             
    .q_axis_h2c_tkeep_10       (q_axis_h2c_tkeep_4       ),             
    .q_axis_h2c_tlast_10       (q_axis_h2c_tlast_4       ),              
    .q_axis_c2h_tready_10      (q_axis_c2h_tready_4      ),              
    .q_axis_c2h_tvalid_10      (q_axis_c2h_tvalid_4      ),              
    .q_axis_c2h_tdata_10       (q_axis_c2h_tdata_4       ),             
    .q_axis_c2h_tkeep_10       (q_axis_c2h_tkeep_4       ),             
    .q_axis_c2h_tlast_10       (q_axis_c2h_tlast_4       ),              
    .q_h2c_dsc_byp_ready_11    (q_h2c_dsc_byp_ready_6    ),                   
    .q_h2c_dsc_byp_load_11     (q_h2c_dsc_byp_load_6     ),                
    .q_h2c_dsc_byp_src_addr_11 (q_h2c_dsc_byp_src_addr_6 ),                      
    .q_h2c_dsc_byp_dst_addr_11 (q_h2c_dsc_byp_dst_addr_6 ),                      
    .q_h2c_dsc_byp_len_11      (q_h2c_dsc_byp_len_6      ),                 
    .q_h2c_dsc_byp_ctl_11      (q_h2c_dsc_byp_ctl_6      ),               
    .q_c2h_dsc_byp_ready_11    (q_c2h_dsc_byp_ready_6    ),                   
    .q_c2h_dsc_byp_load_11     (q_c2h_dsc_byp_load_6     ),                
    .q_c2h_dsc_byp_src_addr_11 (q_c2h_dsc_byp_src_addr_6 ),                      
    .q_c2h_dsc_byp_dst_addr_11 (q_c2h_dsc_byp_dst_addr_6 ),                      
    .q_c2h_dsc_byp_len_11      (q_c2h_dsc_byp_len_6      ),                 
    .q_c2h_dsc_byp_ctl_11      (q_c2h_dsc_byp_ctl_6      ),               
    .q_axis_h2c_tready_11      (q_axis_h2c_tready_6      ),              
    .q_axis_h2c_tvalid_11      (q_axis_h2c_tvalid_6      ),              
    .q_axis_h2c_tdata_11       (q_axis_h2c_tdata_6       ),             
    .q_axis_h2c_tkeep_11       (q_axis_h2c_tkeep_6       ),             
    .q_axis_h2c_tlast_11       (q_axis_h2c_tlast_6       ),              
    .q_axis_c2h_tready_11      (q_axis_c2h_tready_6      ),              
    .q_axis_c2h_tvalid_11      (q_axis_c2h_tvalid_6      ),              
    .q_axis_c2h_tdata_11       (q_axis_c2h_tdata_6       ),             
    .q_axis_c2h_tkeep_11       (q_axis_c2h_tkeep_6       ),             
    .q_axis_c2h_tlast_11       (q_axis_c2h_tlast_6       ),              
    .q_h2c_dsc_byp_ready_12    (q_h2c_dsc_byp_ready_8    ),                   
    .q_h2c_dsc_byp_load_12     (q_h2c_dsc_byp_load_8     ),                
    .q_h2c_dsc_byp_src_addr_12 (q_h2c_dsc_byp_src_addr_8 ),                      
    .q_h2c_dsc_byp_dst_addr_12 (q_h2c_dsc_byp_dst_addr_8 ),                      
    .q_h2c_dsc_byp_len_12      (q_h2c_dsc_byp_len_8      ),                 
    .q_h2c_dsc_byp_ctl_12      (q_h2c_dsc_byp_ctl_8      ),               
    .q_c2h_dsc_byp_ready_12    (q_c2h_dsc_byp_ready_8    ),                   
    .q_c2h_dsc_byp_load_12     (q_c2h_dsc_byp_load_8     ),                
    .q_c2h_dsc_byp_src_addr_12 (q_c2h_dsc_byp_src_addr_8 ),                      
    .q_c2h_dsc_byp_dst_addr_12 (q_c2h_dsc_byp_dst_addr_8 ),                      
    .q_c2h_dsc_byp_len_12      (q_c2h_dsc_byp_len_8      ),                 
    .q_c2h_dsc_byp_ctl_12      (q_c2h_dsc_byp_ctl_8      ),               
    .q_axis_h2c_tready_12      (q_axis_h2c_tready_8      ),              
    .q_axis_h2c_tvalid_12      (q_axis_h2c_tvalid_8      ),              
    .q_axis_h2c_tdata_12       (q_axis_h2c_tdata_8       ),             
    .q_axis_h2c_tkeep_12       (q_axis_h2c_tkeep_8       ),             
    .q_axis_h2c_tlast_12       (q_axis_h2c_tlast_8       ),              
    .q_axis_c2h_tready_12      (q_axis_c2h_tready_8      ),              
    .q_axis_c2h_tvalid_12      (q_axis_c2h_tvalid_8      ),              
    .q_axis_c2h_tdata_12       (q_axis_c2h_tdata_8       ),             
    .q_axis_c2h_tkeep_12       (q_axis_c2h_tkeep_8       ),             
    .q_axis_c2h_tlast_12       (q_axis_c2h_tlast_8       ),              
    .q_h2c_dsc_byp_ready_13    (q_h2c_dsc_byp_ready_10   ),                   
    .q_h2c_dsc_byp_load_13     (q_h2c_dsc_byp_load_10    ),                
    .q_h2c_dsc_byp_src_addr_13 (q_h2c_dsc_byp_src_addr_10),                      
    .q_h2c_dsc_byp_dst_addr_13 (q_h2c_dsc_byp_dst_addr_10),                      
    .q_h2c_dsc_byp_len_13      (q_h2c_dsc_byp_len_10     ),                 
    .q_h2c_dsc_byp_ctl_13      (q_h2c_dsc_byp_ctl_10     ),               
    .q_c2h_dsc_byp_ready_13    (q_c2h_dsc_byp_ready_10   ),                   
    .q_c2h_dsc_byp_load_13     (q_c2h_dsc_byp_load_10    ),                
    .q_c2h_dsc_byp_src_addr_13 (q_c2h_dsc_byp_src_addr_10),                      
    .q_c2h_dsc_byp_dst_addr_13 (q_c2h_dsc_byp_dst_addr_10),                      
    .q_c2h_dsc_byp_len_13      (q_c2h_dsc_byp_len_10     ),                 
    .q_c2h_dsc_byp_ctl_13      (q_c2h_dsc_byp_ctl_10     ),               
    .q_axis_h2c_tready_13      (q_axis_h2c_tready_10     ),              
    .q_axis_h2c_tvalid_13      (q_axis_h2c_tvalid_10     ),              
    .q_axis_h2c_tdata_13       (q_axis_h2c_tdata_10      ),             
    .q_axis_h2c_tkeep_13       (q_axis_h2c_tkeep_10      ),             
    .q_axis_h2c_tlast_13       (q_axis_h2c_tlast_10      ),              
    .q_axis_c2h_tready_13      (q_axis_c2h_tready_10     ),              
    .q_axis_c2h_tvalid_13      (q_axis_c2h_tvalid_10     ),              
    .q_axis_c2h_tdata_13       (q_axis_c2h_tdata_10      ),             
    .q_axis_c2h_tkeep_13       (q_axis_c2h_tkeep_10      ),             
    .q_axis_c2h_tlast_13       (q_axis_c2h_tlast_10      ),              
    .q_h2c_dsc_byp_ready_14    (q_h2c_dsc_byp_ready_12   ),                   
    .q_h2c_dsc_byp_load_14     (q_h2c_dsc_byp_load_12    ),                
    .q_h2c_dsc_byp_src_addr_14 (q_h2c_dsc_byp_src_addr_12),                      
    .q_h2c_dsc_byp_dst_addr_14 (q_h2c_dsc_byp_dst_addr_12),                      
    .q_h2c_dsc_byp_len_14      (q_h2c_dsc_byp_len_12     ),                 
    .q_h2c_dsc_byp_ctl_14      (q_h2c_dsc_byp_ctl_12     ),               
    .q_c2h_dsc_byp_ready_14    (q_c2h_dsc_byp_ready_12   ),                   
    .q_c2h_dsc_byp_load_14     (q_c2h_dsc_byp_load_12    ),                
    .q_c2h_dsc_byp_src_addr_14 (q_c2h_dsc_byp_src_addr_12),                      
    .q_c2h_dsc_byp_dst_addr_14 (q_c2h_dsc_byp_dst_addr_12),                      
    .q_c2h_dsc_byp_len_14      (q_c2h_dsc_byp_len_12     ),                 
    .q_c2h_dsc_byp_ctl_14      (q_c2h_dsc_byp_ctl_12     ),               
    .q_axis_h2c_tready_14      (q_axis_h2c_tready_12     ),              
    .q_axis_h2c_tvalid_14      (q_axis_h2c_tvalid_12     ),              
    .q_axis_h2c_tdata_14       (q_axis_h2c_tdata_12      ),             
    .q_axis_h2c_tkeep_14       (q_axis_h2c_tkeep_12      ),             
    .q_axis_h2c_tlast_14       (q_axis_h2c_tlast_12      ),              
    .q_axis_c2h_tready_14      (q_axis_c2h_tready_12     ),              
    .q_axis_c2h_tvalid_14      (q_axis_c2h_tvalid_12     ),              
    .q_axis_c2h_tdata_14       (q_axis_c2h_tdata_12      ),             
    .q_axis_c2h_tkeep_14       (q_axis_c2h_tkeep_12      ),             
    .q_axis_c2h_tlast_14       (q_axis_c2h_tlast_12      ),              
    .q_h2c_dsc_byp_ready_15    (q_h2c_dsc_byp_ready_14   ),                   
    .q_h2c_dsc_byp_load_15     (q_h2c_dsc_byp_load_14    ),                
    .q_h2c_dsc_byp_src_addr_15 (q_h2c_dsc_byp_src_addr_14),                      
    .q_h2c_dsc_byp_dst_addr_15 (q_h2c_dsc_byp_dst_addr_14),                      
    .q_h2c_dsc_byp_len_15      (q_h2c_dsc_byp_len_14     ),                 
    .q_h2c_dsc_byp_ctl_15      (q_h2c_dsc_byp_ctl_14     ),               
    .q_c2h_dsc_byp_ready_15    (q_c2h_dsc_byp_ready_14   ),                   
    .q_c2h_dsc_byp_load_15     (q_c2h_dsc_byp_load_14    ),                
    .q_c2h_dsc_byp_src_addr_15 (q_c2h_dsc_byp_src_addr_14),                      
    .q_c2h_dsc_byp_dst_addr_15 (q_c2h_dsc_byp_dst_addr_14),                      
    .q_c2h_dsc_byp_len_15      (q_c2h_dsc_byp_len_14     ),                 
    .q_c2h_dsc_byp_ctl_15      (q_c2h_dsc_byp_ctl_14     ),               
    .q_axis_h2c_tready_15      (q_axis_h2c_tready_14     ),              
    .q_axis_h2c_tvalid_15      (q_axis_h2c_tvalid_14     ),              
    .q_axis_h2c_tdata_15       (q_axis_h2c_tdata_14      ),             
    .q_axis_h2c_tkeep_15       (q_axis_h2c_tkeep_14      ),             
    .q_axis_h2c_tlast_15       (q_axis_h2c_tlast_14      ),              
    .q_axis_c2h_tready_15      (q_axis_c2h_tready_14     ),              
    .q_axis_c2h_tvalid_15      (q_axis_c2h_tvalid_14     ),              
    .q_axis_c2h_tdata_15       (q_axis_c2h_tdata_14      ),             
    .q_axis_c2h_tkeep_15       (q_axis_c2h_tkeep_14      ),             
    .q_axis_c2h_tlast_15       (q_axis_c2h_tlast_14      ),              
    .q_h2c_dsc_byp_ready_16    (q_h2c_dsc_byp_ready_16   ),                   
    .q_h2c_dsc_byp_load_16     (q_h2c_dsc_byp_load_16    ),                
    .q_h2c_dsc_byp_src_addr_16 (q_h2c_dsc_byp_src_addr_16),                      
    .q_h2c_dsc_byp_dst_addr_16 (q_h2c_dsc_byp_dst_addr_16),                      
    .q_h2c_dsc_byp_len_16      (q_h2c_dsc_byp_len_16     ),                 
    .q_h2c_dsc_byp_ctl_16      (q_h2c_dsc_byp_ctl_16     ),               
    .q_c2h_dsc_byp_ready_16    (q_c2h_dsc_byp_ready_16   ),                   
    .q_c2h_dsc_byp_load_16     (q_c2h_dsc_byp_load_16    ),                
    .q_c2h_dsc_byp_src_addr_16 (q_c2h_dsc_byp_src_addr_16),                      
    .q_c2h_dsc_byp_dst_addr_16 (q_c2h_dsc_byp_dst_addr_16),                      
    .q_c2h_dsc_byp_len_16      (q_c2h_dsc_byp_len_16     ),                 
    .q_c2h_dsc_byp_ctl_16      (q_c2h_dsc_byp_ctl_16     ),               
    .q_axis_h2c_tready_16      (q_axis_h2c_tready_16     ),              
    .q_axis_h2c_tvalid_16      (q_axis_h2c_tvalid_16     ),              
    .q_axis_h2c_tdata_16       (q_axis_h2c_tdata_16      ),             
    .q_axis_h2c_tkeep_16       (q_axis_h2c_tkeep_16      ),             
    .q_axis_h2c_tlast_16       (q_axis_h2c_tlast_16      ),              
    .q_axis_c2h_tready_16      (q_axis_c2h_tready_16     ),              
    .q_axis_c2h_tvalid_16      (q_axis_c2h_tvalid_16     ),              
    .q_axis_c2h_tdata_16       (q_axis_c2h_tdata_16      ),             
    .q_axis_c2h_tkeep_16       (q_axis_c2h_tkeep_16      ),             
    .q_axis_c2h_tlast_16       (q_axis_c2h_tlast_16      ),                              
    .d_h2c_dsc_byp_ready_1     (d_h2c_dsc_byp_ready_1    ),                  
    .d_h2c_dsc_byp_load_1      (d_h2c_dsc_byp_load_1     ),               
    .d_h2c_dsc_byp_src_addr_1  (d_h2c_dsc_byp_src_addr_1 ),                     
    .d_h2c_dsc_byp_dst_addr_1  (d_h2c_dsc_byp_dst_addr_1 ),                     
    .d_h2c_dsc_byp_len_1       (d_h2c_dsc_byp_len_1      ),                
    .d_h2c_dsc_byp_ctl_1       (d_h2c_dsc_byp_ctl_1      ),              
    .d_c2h_dsc_byp_ready_1     (d_c2h_dsc_byp_ready_1    ),                  
    .d_c2h_dsc_byp_load_1      (d_c2h_dsc_byp_load_1     ),               
    .d_c2h_dsc_byp_src_addr_1  (d_c2h_dsc_byp_src_addr_1 ),                     
    .d_c2h_dsc_byp_dst_addr_1  (d_c2h_dsc_byp_dst_addr_1 ),                     
    .d_c2h_dsc_byp_len_1       (d_c2h_dsc_byp_len_1      ),                
    .d_c2h_dsc_byp_ctl_1       (d_c2h_dsc_byp_ctl_1      ),              
    .d_axis_h2c_tready_1       (d_axis_h2c_tready_1      ),             
    .d_axis_h2c_tvalid_1       (d_axis_h2c_tvalid_1      ),             
    .d_axis_h2c_tdata_1        (d_axis_h2c_tdata_1       ),            
    .d_axis_h2c_tkeep_1        (d_axis_h2c_tkeep_1       ),            
    .d_axis_h2c_tlast_1        (d_axis_h2c_tlast_1       ),             
    .d_axis_c2h_tready_1       (d_axis_c2h_tready_1      ),             
    .d_axis_c2h_tvalid_1       (d_axis_c2h_tvalid_1      ),             
    .d_axis_c2h_tdata_1        (d_axis_c2h_tdata_1       ),            
    .d_axis_c2h_tkeep_1        (d_axis_c2h_tkeep_1       ),            
    .d_axis_c2h_tlast_1        (d_axis_c2h_tlast_1       ),             
    .d_h2c_dsc_byp_ready_2     (d_h2c_dsc_byp_ready_3    ),                  
    .d_h2c_dsc_byp_load_2      (d_h2c_dsc_byp_load_3     ),               
    .d_h2c_dsc_byp_src_addr_2  (d_h2c_dsc_byp_src_addr_3 ),                     
    .d_h2c_dsc_byp_dst_addr_2  (d_h2c_dsc_byp_dst_addr_3 ),                     
    .d_h2c_dsc_byp_len_2       (d_h2c_dsc_byp_len_3      ),                
    .d_h2c_dsc_byp_ctl_2       (d_h2c_dsc_byp_ctl_3      ),              
    .d_c2h_dsc_byp_ready_2     (d_c2h_dsc_byp_ready_3    ),                  
    .d_c2h_dsc_byp_load_2      (d_c2h_dsc_byp_load_3     ),               
    .d_c2h_dsc_byp_src_addr_2  (d_c2h_dsc_byp_src_addr_3 ),                     
    .d_c2h_dsc_byp_dst_addr_2  (d_c2h_dsc_byp_dst_addr_3 ),                     
    .d_c2h_dsc_byp_len_2       (d_c2h_dsc_byp_len_3      ),                
    .d_c2h_dsc_byp_ctl_2       (d_c2h_dsc_byp_ctl_3      ),              
    .d_axis_h2c_tready_2       (d_axis_h2c_tready_3      ),             
    .d_axis_h2c_tvalid_2       (d_axis_h2c_tvalid_3      ),             
    .d_axis_h2c_tdata_2        (d_axis_h2c_tdata_3       ),            
    .d_axis_h2c_tkeep_2        (d_axis_h2c_tkeep_3       ),            
    .d_axis_h2c_tlast_2        (d_axis_h2c_tlast_3       ),             
    .d_axis_c2h_tready_2       (d_axis_c2h_tready_3      ),             
    .d_axis_c2h_tvalid_2       (d_axis_c2h_tvalid_3      ),             
    .d_axis_c2h_tdata_2        (d_axis_c2h_tdata_3       ),            
    .d_axis_c2h_tkeep_2        (d_axis_c2h_tkeep_3       ),            
    .d_axis_c2h_tlast_2        (d_axis_c2h_tlast_3       ),             
    .d_h2c_dsc_byp_ready_3     (d_h2c_dsc_byp_ready_5    ),                  
    .d_h2c_dsc_byp_load_3      (d_h2c_dsc_byp_load_5     ),               
    .d_h2c_dsc_byp_src_addr_3  (d_h2c_dsc_byp_src_addr_5 ),                     
    .d_h2c_dsc_byp_dst_addr_3  (d_h2c_dsc_byp_dst_addr_5 ),                     
    .d_h2c_dsc_byp_len_3       (d_h2c_dsc_byp_len_5      ),                
    .d_h2c_dsc_byp_ctl_3       (d_h2c_dsc_byp_ctl_5      ),              
    .d_c2h_dsc_byp_ready_3     (d_c2h_dsc_byp_ready_5    ),                  
    .d_c2h_dsc_byp_load_3      (d_c2h_dsc_byp_load_5     ),               
    .d_c2h_dsc_byp_src_addr_3  (d_c2h_dsc_byp_src_addr_5 ),                     
    .d_c2h_dsc_byp_dst_addr_3  (d_c2h_dsc_byp_dst_addr_5 ),                     
    .d_c2h_dsc_byp_len_3       (d_c2h_dsc_byp_len_5      ),                
    .d_c2h_dsc_byp_ctl_3       (d_c2h_dsc_byp_ctl_5      ),              
    .d_axis_h2c_tready_3       (d_axis_h2c_tready_5      ),             
    .d_axis_h2c_tvalid_3       (d_axis_h2c_tvalid_5      ),             
    .d_axis_h2c_tdata_3        (d_axis_h2c_tdata_5       ),            
    .d_axis_h2c_tkeep_3        (d_axis_h2c_tkeep_5       ),            
    .d_axis_h2c_tlast_3        (d_axis_h2c_tlast_5       ),             
    .d_axis_c2h_tready_3       (d_axis_c2h_tready_5      ),             
    .d_axis_c2h_tvalid_3       (d_axis_c2h_tvalid_5      ),             
    .d_axis_c2h_tdata_3        (d_axis_c2h_tdata_5       ),            
    .d_axis_c2h_tkeep_3        (d_axis_c2h_tkeep_5       ),            
    .d_axis_c2h_tlast_3        (d_axis_c2h_tlast_5       ),             
    .d_h2c_dsc_byp_ready_4     (d_h2c_dsc_byp_ready_7    ),                  
    .d_h2c_dsc_byp_load_4      (d_h2c_dsc_byp_load_7     ),               
    .d_h2c_dsc_byp_src_addr_4  (d_h2c_dsc_byp_src_addr_7 ),                     
    .d_h2c_dsc_byp_dst_addr_4  (d_h2c_dsc_byp_dst_addr_7 ),                     
    .d_h2c_dsc_byp_len_4       (d_h2c_dsc_byp_len_7      ),                
    .d_h2c_dsc_byp_ctl_4       (d_h2c_dsc_byp_ctl_7      ),              
    .d_c2h_dsc_byp_ready_4     (d_c2h_dsc_byp_ready_7    ),                  
    .d_c2h_dsc_byp_load_4      (d_c2h_dsc_byp_load_7     ),               
    .d_c2h_dsc_byp_src_addr_4  (d_c2h_dsc_byp_src_addr_7 ),                     
    .d_c2h_dsc_byp_dst_addr_4  (d_c2h_dsc_byp_dst_addr_7 ),                     
    .d_c2h_dsc_byp_len_4       (d_c2h_dsc_byp_len_7      ),                
    .d_c2h_dsc_byp_ctl_4       (d_c2h_dsc_byp_ctl_7      ),              
    .d_axis_h2c_tready_4       (d_axis_h2c_tready_7      ),             
    .d_axis_h2c_tvalid_4       (d_axis_h2c_tvalid_7      ),             
    .d_axis_h2c_tdata_4        (d_axis_h2c_tdata_7       ),            
    .d_axis_h2c_tkeep_4        (d_axis_h2c_tkeep_7       ),            
    .d_axis_h2c_tlast_4        (d_axis_h2c_tlast_7       ),             
    .d_axis_c2h_tready_4       (d_axis_c2h_tready_7      ),             
    .d_axis_c2h_tvalid_4       (d_axis_c2h_tvalid_7      ),             
    .d_axis_c2h_tdata_4        (d_axis_c2h_tdata_7       ),            
    .d_axis_c2h_tkeep_4        (d_axis_c2h_tkeep_7       ),            
    .d_axis_c2h_tlast_4        (d_axis_c2h_tlast_7       ),             
    .d_h2c_dsc_byp_ready_5     (d_h2c_dsc_byp_ready_9    ),                  
    .d_h2c_dsc_byp_load_5      (d_h2c_dsc_byp_load_9     ),               
    .d_h2c_dsc_byp_src_addr_5  (d_h2c_dsc_byp_src_addr_9 ),                     
    .d_h2c_dsc_byp_dst_addr_5  (d_h2c_dsc_byp_dst_addr_9 ),                     
    .d_h2c_dsc_byp_len_5       (d_h2c_dsc_byp_len_9      ),                
    .d_h2c_dsc_byp_ctl_5       (d_h2c_dsc_byp_ctl_9      ),              
    .d_c2h_dsc_byp_ready_5     (d_c2h_dsc_byp_ready_9    ),                  
    .d_c2h_dsc_byp_load_5      (d_c2h_dsc_byp_load_9     ),               
    .d_c2h_dsc_byp_src_addr_5  (d_c2h_dsc_byp_src_addr_9 ),                     
    .d_c2h_dsc_byp_dst_addr_5  (d_c2h_dsc_byp_dst_addr_9 ),                     
    .d_c2h_dsc_byp_len_5       (d_c2h_dsc_byp_len_9      ),                
    .d_c2h_dsc_byp_ctl_5       (d_c2h_dsc_byp_ctl_9      ),              
    .d_axis_h2c_tready_5       (d_axis_h2c_tready_9      ),             
    .d_axis_h2c_tvalid_5       (d_axis_h2c_tvalid_9      ),             
    .d_axis_h2c_tdata_5        (d_axis_h2c_tdata_9       ),            
    .d_axis_h2c_tkeep_5        (d_axis_h2c_tkeep_9       ),            
    .d_axis_h2c_tlast_5        (d_axis_h2c_tlast_9       ),             
    .d_axis_c2h_tready_5       (d_axis_c2h_tready_9      ),             
    .d_axis_c2h_tvalid_5       (d_axis_c2h_tvalid_9      ),             
    .d_axis_c2h_tdata_5        (d_axis_c2h_tdata_9       ),            
    .d_axis_c2h_tkeep_5        (d_axis_c2h_tkeep_9       ),            
    .d_axis_c2h_tlast_5        (d_axis_c2h_tlast_9       ),             
    .d_h2c_dsc_byp_ready_6     (d_h2c_dsc_byp_ready_11   ),                  
    .d_h2c_dsc_byp_load_6      (d_h2c_dsc_byp_load_11    ),               
    .d_h2c_dsc_byp_src_addr_6  (d_h2c_dsc_byp_src_addr_11),                     
    .d_h2c_dsc_byp_dst_addr_6  (d_h2c_dsc_byp_dst_addr_11),                     
    .d_h2c_dsc_byp_len_6       (d_h2c_dsc_byp_len_11     ),                
    .d_h2c_dsc_byp_ctl_6       (d_h2c_dsc_byp_ctl_11     ),              
    .d_c2h_dsc_byp_ready_6     (d_c2h_dsc_byp_ready_11   ),                  
    .d_c2h_dsc_byp_load_6      (d_c2h_dsc_byp_load_11    ),               
    .d_c2h_dsc_byp_src_addr_6  (d_c2h_dsc_byp_src_addr_11),                     
    .d_c2h_dsc_byp_dst_addr_6  (d_c2h_dsc_byp_dst_addr_11),                     
    .d_c2h_dsc_byp_len_6       (d_c2h_dsc_byp_len_11     ),                
    .d_c2h_dsc_byp_ctl_6       (d_c2h_dsc_byp_ctl_11     ),              
    .d_axis_h2c_tready_6       (d_axis_h2c_tready_11     ),             
    .d_axis_h2c_tvalid_6       (d_axis_h2c_tvalid_11     ),             
    .d_axis_h2c_tdata_6        (d_axis_h2c_tdata_11      ),            
    .d_axis_h2c_tkeep_6        (d_axis_h2c_tkeep_11      ),            
    .d_axis_h2c_tlast_6        (d_axis_h2c_tlast_11      ),             
    .d_axis_c2h_tready_6       (d_axis_c2h_tready_11     ),             
    .d_axis_c2h_tvalid_6       (d_axis_c2h_tvalid_11     ),             
    .d_axis_c2h_tdata_6        (d_axis_c2h_tdata_11      ),            
    .d_axis_c2h_tkeep_6        (d_axis_c2h_tkeep_11      ),            
    .d_axis_c2h_tlast_6        (d_axis_c2h_tlast_11      ),             
    .d_h2c_dsc_byp_ready_7     (d_h2c_dsc_byp_ready_13   ),                  
    .d_h2c_dsc_byp_load_7      (d_h2c_dsc_byp_load_13    ),               
    .d_h2c_dsc_byp_src_addr_7  (d_h2c_dsc_byp_src_addr_13),                     
    .d_h2c_dsc_byp_dst_addr_7  (d_h2c_dsc_byp_dst_addr_13),                     
    .d_h2c_dsc_byp_len_7       (d_h2c_dsc_byp_len_13     ),                
    .d_h2c_dsc_byp_ctl_7       (d_h2c_dsc_byp_ctl_13     ),              
    .d_c2h_dsc_byp_ready_7     (d_c2h_dsc_byp_ready_13   ),                  
    .d_c2h_dsc_byp_load_7      (d_c2h_dsc_byp_load_13    ),               
    .d_c2h_dsc_byp_src_addr_7  (d_c2h_dsc_byp_src_addr_13),                     
    .d_c2h_dsc_byp_dst_addr_7  (d_c2h_dsc_byp_dst_addr_13),                     
    .d_c2h_dsc_byp_len_7       (d_c2h_dsc_byp_len_13     ),                
    .d_c2h_dsc_byp_ctl_7       (d_c2h_dsc_byp_ctl_13     ),              
    .d_axis_h2c_tready_7       (d_axis_h2c_tready_13     ),             
    .d_axis_h2c_tvalid_7       (d_axis_h2c_tvalid_13     ),             
    .d_axis_h2c_tdata_7        (d_axis_h2c_tdata_13      ),            
    .d_axis_h2c_tkeep_7        (d_axis_h2c_tkeep_13      ),            
    .d_axis_h2c_tlast_7        (d_axis_h2c_tlast_13      ),             
    .d_axis_c2h_tready_7       (d_axis_c2h_tready_13     ),             
    .d_axis_c2h_tvalid_7       (d_axis_c2h_tvalid_13     ),             
    .d_axis_c2h_tdata_7        (d_axis_c2h_tdata_13      ),            
    .d_axis_c2h_tkeep_7        (d_axis_c2h_tkeep_13      ),            
    .d_axis_c2h_tlast_7        (d_axis_c2h_tlast_13      ),             
    .d_h2c_dsc_byp_ready_8     (d_h2c_dsc_byp_ready_15   ),                  
    .d_h2c_dsc_byp_load_8      (d_h2c_dsc_byp_load_15    ),               
    .d_h2c_dsc_byp_src_addr_8  (d_h2c_dsc_byp_src_addr_15),                     
    .d_h2c_dsc_byp_dst_addr_8  (d_h2c_dsc_byp_dst_addr_15),                     
    .d_h2c_dsc_byp_len_8       (d_h2c_dsc_byp_len_15     ),                
    .d_h2c_dsc_byp_ctl_8       (d_h2c_dsc_byp_ctl_15     ),              
    .d_c2h_dsc_byp_ready_8     (d_c2h_dsc_byp_ready_15   ),                  
    .d_c2h_dsc_byp_load_8      (d_c2h_dsc_byp_load_15    ),               
    .d_c2h_dsc_byp_src_addr_8  (d_c2h_dsc_byp_src_addr_15),                     
    .d_c2h_dsc_byp_dst_addr_8  (d_c2h_dsc_byp_dst_addr_15),                     
    .d_c2h_dsc_byp_len_8       (d_c2h_dsc_byp_len_15     ),                
    .d_c2h_dsc_byp_ctl_8       (d_c2h_dsc_byp_ctl_15     ),              
    .d_axis_h2c_tready_8       (d_axis_h2c_tready_15     ),             
    .d_axis_h2c_tvalid_8       (d_axis_h2c_tvalid_15     ),             
    .d_axis_h2c_tdata_8        (d_axis_h2c_tdata_15      ),            
    .d_axis_h2c_tkeep_8        (d_axis_h2c_tkeep_15      ),            
    .d_axis_h2c_tlast_8        (d_axis_h2c_tlast_15      ),             
    .d_axis_c2h_tready_8       (d_axis_c2h_tready_15     ),             
    .d_axis_c2h_tvalid_8       (d_axis_c2h_tvalid_15     ),             
    .d_axis_c2h_tdata_8        (d_axis_c2h_tdata_15      ),            
    .d_axis_c2h_tkeep_8        (d_axis_c2h_tkeep_15      ),            
    .d_axis_c2h_tlast_8        (d_axis_c2h_tlast_15      ),             
    .d_h2c_dsc_byp_ready_9     (d_h2c_dsc_byp_ready_2    ),                  
    .d_h2c_dsc_byp_load_9      (d_h2c_dsc_byp_load_2     ),               
    .d_h2c_dsc_byp_src_addr_9  (d_h2c_dsc_byp_src_addr_2 ),                     
    .d_h2c_dsc_byp_dst_addr_9  (d_h2c_dsc_byp_dst_addr_2 ),                     
    .d_h2c_dsc_byp_len_9       (d_h2c_dsc_byp_len_2      ),                
    .d_h2c_dsc_byp_ctl_9       (d_h2c_dsc_byp_ctl_2      ),              
    .d_c2h_dsc_byp_ready_9     (d_c2h_dsc_byp_ready_2    ),                  
    .d_c2h_dsc_byp_load_9      (d_c2h_dsc_byp_load_2     ),               
    .d_c2h_dsc_byp_src_addr_9  (d_c2h_dsc_byp_src_addr_2 ),                     
    .d_c2h_dsc_byp_dst_addr_9  (d_c2h_dsc_byp_dst_addr_2 ),                     
    .d_c2h_dsc_byp_len_9       (d_c2h_dsc_byp_len_2      ),                
    .d_c2h_dsc_byp_ctl_9       (d_c2h_dsc_byp_ctl_2      ),              
    .d_axis_h2c_tready_9       (d_axis_h2c_tready_2      ),             
    .d_axis_h2c_tvalid_9       (d_axis_h2c_tvalid_2      ),             
    .d_axis_h2c_tdata_9        (d_axis_h2c_tdata_2       ),            
    .d_axis_h2c_tkeep_9        (d_axis_h2c_tkeep_2       ),            
    .d_axis_h2c_tlast_9        (d_axis_h2c_tlast_2       ),             
    .d_axis_c2h_tready_9       (d_axis_c2h_tready_2      ),             
    .d_axis_c2h_tvalid_9       (d_axis_c2h_tvalid_2      ),             
    .d_axis_c2h_tdata_9        (d_axis_c2h_tdata_2       ),            
    .d_axis_c2h_tkeep_9        (d_axis_c2h_tkeep_2       ),            
    .d_axis_c2h_tlast_9        (d_axis_c2h_tlast_2       ),             
    .d_h2c_dsc_byp_ready_10    (d_h2c_dsc_byp_ready_4    ),                   
    .d_h2c_dsc_byp_load_10     (d_h2c_dsc_byp_load_4     ),                
    .d_h2c_dsc_byp_src_addr_10 (d_h2c_dsc_byp_src_addr_4 ),                      
    .d_h2c_dsc_byp_dst_addr_10 (d_h2c_dsc_byp_dst_addr_4 ),                      
    .d_h2c_dsc_byp_len_10      (d_h2c_dsc_byp_len_4      ),                 
    .d_h2c_dsc_byp_ctl_10      (d_h2c_dsc_byp_ctl_4      ),               
    .d_c2h_dsc_byp_ready_10    (d_c2h_dsc_byp_ready_4    ),                   
    .d_c2h_dsc_byp_load_10     (d_c2h_dsc_byp_load_4     ),                
    .d_c2h_dsc_byp_src_addr_10 (d_c2h_dsc_byp_src_addr_4 ),                      
    .d_c2h_dsc_byp_dst_addr_10 (d_c2h_dsc_byp_dst_addr_4 ),                      
    .d_c2h_dsc_byp_len_10      (d_c2h_dsc_byp_len_4      ),                 
    .d_c2h_dsc_byp_ctl_10      (d_c2h_dsc_byp_ctl_4      ),               
    .d_axis_h2c_tready_10      (d_axis_h2c_tready_4      ),              
    .d_axis_h2c_tvalid_10      (d_axis_h2c_tvalid_4      ),              
    .d_axis_h2c_tdata_10       (d_axis_h2c_tdata_4       ),             
    .d_axis_h2c_tkeep_10       (d_axis_h2c_tkeep_4       ),             
    .d_axis_h2c_tlast_10       (d_axis_h2c_tlast_4       ),              
    .d_axis_c2h_tready_10      (d_axis_c2h_tready_4      ),              
    .d_axis_c2h_tvalid_10      (d_axis_c2h_tvalid_4      ),              
    .d_axis_c2h_tdata_10       (d_axis_c2h_tdata_4       ),             
    .d_axis_c2h_tkeep_10       (d_axis_c2h_tkeep_4       ),             
    .d_axis_c2h_tlast_10       (d_axis_c2h_tlast_4       ),              
    .d_h2c_dsc_byp_ready_11    (d_h2c_dsc_byp_ready_6    ),                   
    .d_h2c_dsc_byp_load_11     (d_h2c_dsc_byp_load_6     ),                
    .d_h2c_dsc_byp_src_addr_11 (d_h2c_dsc_byp_src_addr_6 ),                      
    .d_h2c_dsc_byp_dst_addr_11 (d_h2c_dsc_byp_dst_addr_6 ),                      
    .d_h2c_dsc_byp_len_11      (d_h2c_dsc_byp_len_6      ),                 
    .d_h2c_dsc_byp_ctl_11      (d_h2c_dsc_byp_ctl_6      ),               
    .d_c2h_dsc_byp_ready_11    (d_c2h_dsc_byp_ready_6    ),                   
    .d_c2h_dsc_byp_load_11     (d_c2h_dsc_byp_load_6     ),                
    .d_c2h_dsc_byp_src_addr_11 (d_c2h_dsc_byp_src_addr_6 ),                      
    .d_c2h_dsc_byp_dst_addr_11 (d_c2h_dsc_byp_dst_addr_6 ),                      
    .d_c2h_dsc_byp_len_11      (d_c2h_dsc_byp_len_6      ),                 
    .d_c2h_dsc_byp_ctl_11      (d_c2h_dsc_byp_ctl_6      ),               
    .d_axis_h2c_tready_11      (d_axis_h2c_tready_6      ),              
    .d_axis_h2c_tvalid_11      (d_axis_h2c_tvalid_6      ),              
    .d_axis_h2c_tdata_11       (d_axis_h2c_tdata_6       ),             
    .d_axis_h2c_tkeep_11       (d_axis_h2c_tkeep_6       ),             
    .d_axis_h2c_tlast_11       (d_axis_h2c_tlast_6       ),              
    .d_axis_c2h_tready_11      (d_axis_c2h_tready_6      ),              
    .d_axis_c2h_tvalid_11      (d_axis_c2h_tvalid_6      ),              
    .d_axis_c2h_tdata_11       (d_axis_c2h_tdata_6       ),             
    .d_axis_c2h_tkeep_11       (d_axis_c2h_tkeep_6       ),             
    .d_axis_c2h_tlast_11       (d_axis_c2h_tlast_6       ),              
    .d_h2c_dsc_byp_ready_12    (d_h2c_dsc_byp_ready_8    ),                   
    .d_h2c_dsc_byp_load_12     (d_h2c_dsc_byp_load_8     ),                
    .d_h2c_dsc_byp_src_addr_12 (d_h2c_dsc_byp_src_addr_8 ),                      
    .d_h2c_dsc_byp_dst_addr_12 (d_h2c_dsc_byp_dst_addr_8 ),                      
    .d_h2c_dsc_byp_len_12      (d_h2c_dsc_byp_len_8      ),                 
    .d_h2c_dsc_byp_ctl_12      (d_h2c_dsc_byp_ctl_8      ),               
    .d_c2h_dsc_byp_ready_12    (d_c2h_dsc_byp_ready_8    ),                   
    .d_c2h_dsc_byp_load_12     (d_c2h_dsc_byp_load_8     ),                
    .d_c2h_dsc_byp_src_addr_12 (d_c2h_dsc_byp_src_addr_8 ),                      
    .d_c2h_dsc_byp_dst_addr_12 (d_c2h_dsc_byp_dst_addr_8 ),                      
    .d_c2h_dsc_byp_len_12      (d_c2h_dsc_byp_len_8      ),                 
    .d_c2h_dsc_byp_ctl_12      (d_c2h_dsc_byp_ctl_8      ),               
    .d_axis_h2c_tready_12      (d_axis_h2c_tready_8      ),              
    .d_axis_h2c_tvalid_12      (d_axis_h2c_tvalid_8      ),              
    .d_axis_h2c_tdata_12       (d_axis_h2c_tdata_8       ),             
    .d_axis_h2c_tkeep_12       (d_axis_h2c_tkeep_8       ),             
    .d_axis_h2c_tlast_12       (d_axis_h2c_tlast_8       ),              
    .d_axis_c2h_tready_12      (d_axis_c2h_tready_8      ),              
    .d_axis_c2h_tvalid_12      (d_axis_c2h_tvalid_8      ),              
    .d_axis_c2h_tdata_12       (d_axis_c2h_tdata_8       ),             
    .d_axis_c2h_tkeep_12       (d_axis_c2h_tkeep_8       ),             
    .d_axis_c2h_tlast_12       (d_axis_c2h_tlast_8       ),              
    .d_h2c_dsc_byp_ready_13    (d_h2c_dsc_byp_ready_10   ),                   
    .d_h2c_dsc_byp_load_13     (d_h2c_dsc_byp_load_10    ),                
    .d_h2c_dsc_byp_src_addr_13 (d_h2c_dsc_byp_src_addr_10),                      
    .d_h2c_dsc_byp_dst_addr_13 (d_h2c_dsc_byp_dst_addr_10),                      
    .d_h2c_dsc_byp_len_13      (d_h2c_dsc_byp_len_10     ),                 
    .d_h2c_dsc_byp_ctl_13      (d_h2c_dsc_byp_ctl_10     ),               
    .d_c2h_dsc_byp_ready_13    (d_c2h_dsc_byp_ready_10   ),                   
    .d_c2h_dsc_byp_load_13     (d_c2h_dsc_byp_load_10    ),                
    .d_c2h_dsc_byp_src_addr_13 (d_c2h_dsc_byp_src_addr_10),                      
    .d_c2h_dsc_byp_dst_addr_13 (d_c2h_dsc_byp_dst_addr_10),                      
    .d_c2h_dsc_byp_len_13      (d_c2h_dsc_byp_len_10     ),                 
    .d_c2h_dsc_byp_ctl_13      (d_c2h_dsc_byp_ctl_10     ),               
    .d_axis_h2c_tready_13      (d_axis_h2c_tready_10     ),              
    .d_axis_h2c_tvalid_13      (d_axis_h2c_tvalid_10     ),              
    .d_axis_h2c_tdata_13       (d_axis_h2c_tdata_10      ),             
    .d_axis_h2c_tkeep_13       (d_axis_h2c_tkeep_10      ),             
    .d_axis_h2c_tlast_13       (d_axis_h2c_tlast_10      ),              
    .d_axis_c2h_tready_13      (d_axis_c2h_tready_10     ),              
    .d_axis_c2h_tvalid_13      (d_axis_c2h_tvalid_10     ),              
    .d_axis_c2h_tdata_13       (d_axis_c2h_tdata_10      ),             
    .d_axis_c2h_tkeep_13       (d_axis_c2h_tkeep_10      ),             
    .d_axis_c2h_tlast_13       (d_axis_c2h_tlast_10      ),              
    .d_h2c_dsc_byp_ready_14    (d_h2c_dsc_byp_ready_12   ),                   
    .d_h2c_dsc_byp_load_14     (d_h2c_dsc_byp_load_12    ),                
    .d_h2c_dsc_byp_src_addr_14 (d_h2c_dsc_byp_src_addr_12),                      
    .d_h2c_dsc_byp_dst_addr_14 (d_h2c_dsc_byp_dst_addr_12),                      
    .d_h2c_dsc_byp_len_14      (d_h2c_dsc_byp_len_12     ),                 
    .d_h2c_dsc_byp_ctl_14      (d_h2c_dsc_byp_ctl_12     ),               
    .d_c2h_dsc_byp_ready_14    (d_c2h_dsc_byp_ready_12   ),                   
    .d_c2h_dsc_byp_load_14     (d_c2h_dsc_byp_load_12    ),                
    .d_c2h_dsc_byp_src_addr_14 (d_c2h_dsc_byp_src_addr_12),                      
    .d_c2h_dsc_byp_dst_addr_14 (d_c2h_dsc_byp_dst_addr_12),                      
    .d_c2h_dsc_byp_len_14      (d_c2h_dsc_byp_len_12     ),                 
    .d_c2h_dsc_byp_ctl_14      (d_c2h_dsc_byp_ctl_12     ),               
    .d_axis_h2c_tready_14      (d_axis_h2c_tready_12     ),              
    .d_axis_h2c_tvalid_14      (d_axis_h2c_tvalid_12     ),              
    .d_axis_h2c_tdata_14       (d_axis_h2c_tdata_12      ),             
    .d_axis_h2c_tkeep_14       (d_axis_h2c_tkeep_12      ),             
    .d_axis_h2c_tlast_14       (d_axis_h2c_tlast_12      ),              
    .d_axis_c2h_tready_14      (d_axis_c2h_tready_12     ),              
    .d_axis_c2h_tvalid_14      (d_axis_c2h_tvalid_12     ),              
    .d_axis_c2h_tdata_14       (d_axis_c2h_tdata_12      ),             
    .d_axis_c2h_tkeep_14       (d_axis_c2h_tkeep_12      ),             
    .d_axis_c2h_tlast_14       (d_axis_c2h_tlast_12      ),              
    .d_h2c_dsc_byp_ready_15    (d_h2c_dsc_byp_ready_14   ),                   
    .d_h2c_dsc_byp_load_15     (d_h2c_dsc_byp_load_14    ),                
    .d_h2c_dsc_byp_src_addr_15 (d_h2c_dsc_byp_src_addr_14),                      
    .d_h2c_dsc_byp_dst_addr_15 (d_h2c_dsc_byp_dst_addr_14),                      
    .d_h2c_dsc_byp_len_15      (d_h2c_dsc_byp_len_14     ),                 
    .d_h2c_dsc_byp_ctl_15      (d_h2c_dsc_byp_ctl_14     ),               
    .d_c2h_dsc_byp_ready_15    (d_c2h_dsc_byp_ready_14   ),                   
    .d_c2h_dsc_byp_load_15     (d_c2h_dsc_byp_load_14    ),                
    .d_c2h_dsc_byp_src_addr_15 (d_c2h_dsc_byp_src_addr_14),                      
    .d_c2h_dsc_byp_dst_addr_15 (d_c2h_dsc_byp_dst_addr_14),                      
    .d_c2h_dsc_byp_len_15      (d_c2h_dsc_byp_len_14     ),                 
    .d_c2h_dsc_byp_ctl_15      (d_c2h_dsc_byp_ctl_14     ),               
    .d_axis_h2c_tready_15      (d_axis_h2c_tready_14     ),              
    .d_axis_h2c_tvalid_15      (d_axis_h2c_tvalid_14     ),              
    .d_axis_h2c_tdata_15       (d_axis_h2c_tdata_14      ),             
    .d_axis_h2c_tkeep_15       (d_axis_h2c_tkeep_14      ),             
    .d_axis_h2c_tlast_15       (d_axis_h2c_tlast_14      ),              
    .d_axis_c2h_tready_15      (d_axis_c2h_tready_14     ),              
    .d_axis_c2h_tvalid_15      (d_axis_c2h_tvalid_14     ),              
    .d_axis_c2h_tdata_15       (d_axis_c2h_tdata_14      ),             
    .d_axis_c2h_tkeep_15       (d_axis_c2h_tkeep_14      ),             
    .d_axis_c2h_tlast_15       (d_axis_c2h_tlast_14      ),              
    .d_h2c_dsc_byp_ready_16    (d_h2c_dsc_byp_ready_16   ),                   
    .d_h2c_dsc_byp_load_16     (d_h2c_dsc_byp_load_16    ),                
    .d_h2c_dsc_byp_src_addr_16 (d_h2c_dsc_byp_src_addr_16),                      
    .d_h2c_dsc_byp_dst_addr_16 (d_h2c_dsc_byp_dst_addr_16),                      
    .d_h2c_dsc_byp_len_16      (d_h2c_dsc_byp_len_16     ),                 
    .d_h2c_dsc_byp_ctl_16      (d_h2c_dsc_byp_ctl_16     ),               
    .d_c2h_dsc_byp_ready_16    (d_c2h_dsc_byp_ready_16   ),                   
    .d_c2h_dsc_byp_load_16     (d_c2h_dsc_byp_load_16    ),                
    .d_c2h_dsc_byp_src_addr_16 (d_c2h_dsc_byp_src_addr_16),                      
    .d_c2h_dsc_byp_dst_addr_16 (d_c2h_dsc_byp_dst_addr_16),                      
    .d_c2h_dsc_byp_len_16      (d_c2h_dsc_byp_len_16     ),                 
    .d_c2h_dsc_byp_ctl_16      (d_c2h_dsc_byp_ctl_16     ),               
    .d_axis_h2c_tready_16      (d_axis_h2c_tready_16     ),              
    .d_axis_h2c_tvalid_16      (d_axis_h2c_tvalid_16     ),              
    .d_axis_h2c_tdata_16       (d_axis_h2c_tdata_16      ),             
    .d_axis_h2c_tkeep_16       (d_axis_h2c_tkeep_16      ),             
    .d_axis_h2c_tlast_16       (d_axis_h2c_tlast_16      ),              
    .d_axis_c2h_tready_16      (d_axis_c2h_tready_16     ),              
    .d_axis_c2h_tvalid_16      (d_axis_c2h_tvalid_16     ),              
    .d_axis_c2h_tdata_16       (d_axis_c2h_tdata_16      ),             
    .d_axis_c2h_tkeep_16       (d_axis_c2h_tkeep_16      ),             
    .d_axis_c2h_tlast_16       (d_axis_c2h_tlast_16      )             
  );

`elsif NVME_IO_EIGHT
// Queue i/o interfaces 0,1,3,5,7: channel 0
// Queue i/o interfaces   2,4,6,8: channel 1
// Data i/o interfaces    1,3,5,7: channel 2
// Data i/o interfaces    2,4,6,8: channel 3
  xdma_if_arbiter_top_9 xdma_if_arbiter_top(
    .clk                       (user_clk                 ),          
    .rst_n                     (user_resetn              ),       
    .c2h_dsc_byp_ready_0       (c2h_dsc_byp_ready_0      ),                
    .c2h_dsc_byp_load_0        (c2h_dsc_byp_load_0       ),             
    .c2h_dsc_byp_src_addr_0    (c2h_dsc_byp_src_addr_0   ),                   
    .c2h_dsc_byp_dst_addr_0    (c2h_dsc_byp_dst_addr_0   ),                   
    .c2h_dsc_byp_len_0         (c2h_dsc_byp_len_0        ),              
    .c2h_dsc_byp_ctl_0         (c2h_dsc_byp_ctl_0        ),              
    .h2c_dsc_byp_ready_0       (h2c_dsc_byp_ready_0      ),                
    .h2c_dsc_byp_load_0        (h2c_dsc_byp_load_0       ),             
    .h2c_dsc_byp_src_addr_0    (h2c_dsc_byp_src_addr_0   ),                   
    .h2c_dsc_byp_dst_addr_0    (h2c_dsc_byp_dst_addr_0   ),                   
    .h2c_dsc_byp_len_0         (h2c_dsc_byp_len_0        ),              
    .h2c_dsc_byp_ctl_0         (h2c_dsc_byp_ctl_0        ),             
    .c2h_dsc_byp_ready_1       (c2h_dsc_byp_ready_1      ),                
    .c2h_dsc_byp_load_1        (c2h_dsc_byp_load_1       ),             
    .c2h_dsc_byp_src_addr_1    (c2h_dsc_byp_src_addr_1   ),                   
    .c2h_dsc_byp_dst_addr_1    (c2h_dsc_byp_dst_addr_1   ),                   
    .c2h_dsc_byp_len_1         (c2h_dsc_byp_len_1        ),              
    .c2h_dsc_byp_ctl_1         (c2h_dsc_byp_ctl_1        ),              
    .h2c_dsc_byp_ready_1       (h2c_dsc_byp_ready_1      ),                
    .h2c_dsc_byp_load_1        (h2c_dsc_byp_load_1       ),             
    .h2c_dsc_byp_src_addr_1    (h2c_dsc_byp_src_addr_1   ),                   
    .h2c_dsc_byp_dst_addr_1    (h2c_dsc_byp_dst_addr_1   ),                   
    .h2c_dsc_byp_len_1         (h2c_dsc_byp_len_1        ),              
    .h2c_dsc_byp_ctl_1         (h2c_dsc_byp_ctl_1        ),            
    .c2h_dsc_byp_ready_2       (c2h_dsc_byp_ready_2      ),                
    .c2h_dsc_byp_load_2        (c2h_dsc_byp_load_2       ),             
    .c2h_dsc_byp_src_addr_2    (c2h_dsc_byp_src_addr_2   ),                   
    .c2h_dsc_byp_dst_addr_2    (c2h_dsc_byp_dst_addr_2   ),                   
    .c2h_dsc_byp_len_2         (c2h_dsc_byp_len_2        ),              
    .c2h_dsc_byp_ctl_2         (c2h_dsc_byp_ctl_2        ),              
    .h2c_dsc_byp_ready_2       (h2c_dsc_byp_ready_2      ),                
    .h2c_dsc_byp_load_2        (h2c_dsc_byp_load_2       ),             
    .h2c_dsc_byp_src_addr_2    (h2c_dsc_byp_src_addr_2   ),                   
    .h2c_dsc_byp_dst_addr_2    (h2c_dsc_byp_dst_addr_2   ),                   
    .h2c_dsc_byp_len_2         (h2c_dsc_byp_len_2        ),              
    .h2c_dsc_byp_ctl_2         (h2c_dsc_byp_ctl_2        ),             
    .c2h_dsc_byp_ready_3       (c2h_dsc_byp_ready_3      ),                
    .c2h_dsc_byp_load_3        (c2h_dsc_byp_load_3       ),             
    .c2h_dsc_byp_src_addr_3    (c2h_dsc_byp_src_addr_3   ),                   
    .c2h_dsc_byp_dst_addr_3    (c2h_dsc_byp_dst_addr_3   ),                   
    .c2h_dsc_byp_len_3         (c2h_dsc_byp_len_3        ),              
    .c2h_dsc_byp_ctl_3         (c2h_dsc_byp_ctl_3        ),              
    .h2c_dsc_byp_ready_3       (h2c_dsc_byp_ready_3      ),                
    .h2c_dsc_byp_load_3        (h2c_dsc_byp_load_3       ),             
    .h2c_dsc_byp_src_addr_3    (h2c_dsc_byp_src_addr_3   ),                   
    .h2c_dsc_byp_dst_addr_3    (h2c_dsc_byp_dst_addr_3   ),                   
    .h2c_dsc_byp_len_3         (h2c_dsc_byp_len_3        ),              
    .h2c_dsc_byp_ctl_3         (h2c_dsc_byp_ctl_3        ),              
    .axis_h2c_tready_0         (m_axis_h2c_tready_0      ),           
    .axis_h2c_tvalid_0         (m_axis_h2c_tvalid_0      ),           
    .axis_h2c_tdata_0          (m_axis_h2c_tdata_0       ),          
    .axis_h2c_tkeep_0          (m_axis_h2c_tkeep_0       ),          
    .axis_h2c_tlast_0          (m_axis_h2c_tlast_0       ),                   
    .axis_c2h_tready_0         (m_axis_c2h_tready_0      ),           
    .axis_c2h_tvalid_0         (m_axis_c2h_tvalid_0      ),           
    .axis_c2h_tdata_0          (m_axis_c2h_tdata_0       ),          
    .axis_c2h_tkeep_0          (m_axis_c2h_tkeep_0       ),          
    .axis_c2h_tlast_0          (m_axis_c2h_tlast_0       ),          
    .axis_h2c_tready_1         (m_axis_h2c_tready_1      ),           
    .axis_h2c_tvalid_1         (m_axis_h2c_tvalid_1      ),           
    .axis_h2c_tdata_1          (m_axis_h2c_tdata_1       ),          
    .axis_h2c_tkeep_1          (m_axis_h2c_tkeep_1       ),          
    .axis_h2c_tlast_1          (m_axis_h2c_tlast_1       ),                   
    .axis_c2h_tready_1         (m_axis_c2h_tready_1      ),           
    .axis_c2h_tvalid_1         (m_axis_c2h_tvalid_1      ),           
    .axis_c2h_tdata_1          (m_axis_c2h_tdata_1       ),          
    .axis_c2h_tkeep_1          (m_axis_c2h_tkeep_1       ),          
    .axis_c2h_tlast_1          (m_axis_c2h_tlast_1       ),          
    .axis_h2c_tready_2         (m_axis_h2c_tready_2      ),           
    .axis_h2c_tvalid_2         (m_axis_h2c_tvalid_2      ),           
    .axis_h2c_tdata_2          (m_axis_h2c_tdata_2       ),          
    .axis_h2c_tkeep_2          (m_axis_h2c_tkeep_2       ),          
    .axis_h2c_tlast_2          (m_axis_h2c_tlast_2       ),                   
    .axis_c2h_tready_2         (m_axis_c2h_tready_2      ),           
    .axis_c2h_tvalid_2         (m_axis_c2h_tvalid_2      ),           
    .axis_c2h_tdata_2          (m_axis_c2h_tdata_2       ),          
    .axis_c2h_tkeep_2          (m_axis_c2h_tkeep_2       ),          
    .axis_c2h_tlast_2          (m_axis_c2h_tlast_2       ),          
    .axis_h2c_tready_3         (m_axis_h2c_tready_3      ),           
    .axis_h2c_tvalid_3         (m_axis_h2c_tvalid_3      ),           
    .axis_h2c_tdata_3          (m_axis_h2c_tdata_3       ),          
    .axis_h2c_tkeep_3          (m_axis_h2c_tkeep_3       ),          
    .axis_h2c_tlast_3          (m_axis_h2c_tlast_3       ),                   
    .axis_c2h_tready_3         (m_axis_c2h_tready_3      ),           
    .axis_c2h_tvalid_3         (m_axis_c2h_tvalid_3      ),           
    .axis_c2h_tdata_3          (m_axis_c2h_tdata_3       ),          
    .axis_c2h_tkeep_3          (m_axis_c2h_tkeep_3       ),          
    .axis_c2h_tlast_3          (m_axis_c2h_tlast_3       ),          
    .a_h2c_dsc_byp_ready_0     (a_h2c_dsc_byp_ready_0    ),                  
    .a_h2c_dsc_byp_load_0      (a_h2c_dsc_byp_load_0     ),               
    .a_h2c_dsc_byp_src_addr_0  (a_h2c_dsc_byp_src_addr_0 ),                     
    .a_h2c_dsc_byp_dst_addr_0  (a_h2c_dsc_byp_dst_addr_0 ),                     
    .a_h2c_dsc_byp_len_0       (a_h2c_dsc_byp_len_0      ),                
    .a_h2c_dsc_byp_ctl_0       (a_h2c_dsc_byp_ctl_0      ),              
    .a_c2h_dsc_byp_ready_0     (a_c2h_dsc_byp_ready_0    ),                  
    .a_c2h_dsc_byp_load_0      (a_c2h_dsc_byp_load_0     ),               
    .a_c2h_dsc_byp_src_addr_0  (a_c2h_dsc_byp_src_addr_0 ),                     
    .a_c2h_dsc_byp_dst_addr_0  (a_c2h_dsc_byp_dst_addr_0 ),                     
    .a_c2h_dsc_byp_len_0       (a_c2h_dsc_byp_len_0      ),                
    .a_c2h_dsc_byp_ctl_0       (a_c2h_dsc_byp_ctl_0      ),              
    .a_axis_h2c_tready_0       (a_axis_h2c_tready_0      ),             
    .a_axis_h2c_tvalid_0       (a_axis_h2c_tvalid_0      ),             
    .a_axis_h2c_tdata_0        (a_axis_h2c_tdata_0       ),            
    .a_axis_h2c_tkeep_0        (a_axis_h2c_tkeep_0       ),            
    .a_axis_h2c_tlast_0        (a_axis_h2c_tlast_0       ),             
    .a_axis_c2h_tready_0       (a_axis_c2h_tready_0      ),             
    .a_axis_c2h_tvalid_0       (a_axis_c2h_tvalid_0      ),             
    .a_axis_c2h_tdata_0        (a_axis_c2h_tdata_0       ),            
    .a_axis_c2h_tkeep_0        (a_axis_c2h_tkeep_0       ),            
    .a_axis_c2h_tlast_0        (a_axis_c2h_tlast_0       ),             
    .q_h2c_dsc_byp_ready_1     (q_h2c_dsc_byp_ready_1    ),                  
    .q_h2c_dsc_byp_load_1      (q_h2c_dsc_byp_load_1     ),               
    .q_h2c_dsc_byp_src_addr_1  (q_h2c_dsc_byp_src_addr_1 ),                     
    .q_h2c_dsc_byp_dst_addr_1  (q_h2c_dsc_byp_dst_addr_1 ),                     
    .q_h2c_dsc_byp_len_1       (q_h2c_dsc_byp_len_1      ),                
    .q_h2c_dsc_byp_ctl_1       (q_h2c_dsc_byp_ctl_1      ),              
    .q_c2h_dsc_byp_ready_1     (q_c2h_dsc_byp_ready_1    ),                  
    .q_c2h_dsc_byp_load_1      (q_c2h_dsc_byp_load_1     ),               
    .q_c2h_dsc_byp_src_addr_1  (q_c2h_dsc_byp_src_addr_1 ),                     
    .q_c2h_dsc_byp_dst_addr_1  (q_c2h_dsc_byp_dst_addr_1 ),                     
    .q_c2h_dsc_byp_len_1       (q_c2h_dsc_byp_len_1      ),                
    .q_c2h_dsc_byp_ctl_1       (q_c2h_dsc_byp_ctl_1      ),              
    .q_axis_h2c_tready_1       (q_axis_h2c_tready_1      ),             
    .q_axis_h2c_tvalid_1       (q_axis_h2c_tvalid_1      ),             
    .q_axis_h2c_tdata_1        (q_axis_h2c_tdata_1       ),            
    .q_axis_h2c_tkeep_1        (q_axis_h2c_tkeep_1       ),            
    .q_axis_h2c_tlast_1        (q_axis_h2c_tlast_1       ),             
    .q_axis_c2h_tready_1       (q_axis_c2h_tready_1      ),             
    .q_axis_c2h_tvalid_1       (q_axis_c2h_tvalid_1      ),             
    .q_axis_c2h_tdata_1        (q_axis_c2h_tdata_1       ),            
    .q_axis_c2h_tkeep_1        (q_axis_c2h_tkeep_1       ),            
    .q_axis_c2h_tlast_1        (q_axis_c2h_tlast_1       ),             
    .q_h2c_dsc_byp_ready_2     (q_h2c_dsc_byp_ready_3    ),                  
    .q_h2c_dsc_byp_load_2      (q_h2c_dsc_byp_load_3     ),               
    .q_h2c_dsc_byp_src_addr_2  (q_h2c_dsc_byp_src_addr_3 ),                     
    .q_h2c_dsc_byp_dst_addr_2  (q_h2c_dsc_byp_dst_addr_3 ),                     
    .q_h2c_dsc_byp_len_2       (q_h2c_dsc_byp_len_3      ),                
    .q_h2c_dsc_byp_ctl_2       (q_h2c_dsc_byp_ctl_3      ),              
    .q_c2h_dsc_byp_ready_2     (q_c2h_dsc_byp_ready_3    ),                  
    .q_c2h_dsc_byp_load_2      (q_c2h_dsc_byp_load_3     ),               
    .q_c2h_dsc_byp_src_addr_2  (q_c2h_dsc_byp_src_addr_3 ),                     
    .q_c2h_dsc_byp_dst_addr_2  (q_c2h_dsc_byp_dst_addr_3 ),                     
    .q_c2h_dsc_byp_len_2       (q_c2h_dsc_byp_len_3      ),                
    .q_c2h_dsc_byp_ctl_2       (q_c2h_dsc_byp_ctl_3      ),              
    .q_axis_h2c_tready_2       (q_axis_h2c_tready_3      ),             
    .q_axis_h2c_tvalid_2       (q_axis_h2c_tvalid_3      ),             
    .q_axis_h2c_tdata_2        (q_axis_h2c_tdata_3       ),            
    .q_axis_h2c_tkeep_2        (q_axis_h2c_tkeep_3       ),            
    .q_axis_h2c_tlast_2        (q_axis_h2c_tlast_3       ),             
    .q_axis_c2h_tready_2       (q_axis_c2h_tready_3      ),             
    .q_axis_c2h_tvalid_2       (q_axis_c2h_tvalid_3      ),             
    .q_axis_c2h_tdata_2        (q_axis_c2h_tdata_3       ),            
    .q_axis_c2h_tkeep_2        (q_axis_c2h_tkeep_3       ),            
    .q_axis_c2h_tlast_2        (q_axis_c2h_tlast_3       ),             
    .q_h2c_dsc_byp_ready_3     (q_h2c_dsc_byp_ready_5    ),                  
    .q_h2c_dsc_byp_load_3      (q_h2c_dsc_byp_load_5     ),               
    .q_h2c_dsc_byp_src_addr_3  (q_h2c_dsc_byp_src_addr_5 ),                     
    .q_h2c_dsc_byp_dst_addr_3  (q_h2c_dsc_byp_dst_addr_5 ),                     
    .q_h2c_dsc_byp_len_3       (q_h2c_dsc_byp_len_5      ),                
    .q_h2c_dsc_byp_ctl_3       (q_h2c_dsc_byp_ctl_5      ),              
    .q_c2h_dsc_byp_ready_3     (q_c2h_dsc_byp_ready_5    ),                  
    .q_c2h_dsc_byp_load_3      (q_c2h_dsc_byp_load_5     ),               
    .q_c2h_dsc_byp_src_addr_3  (q_c2h_dsc_byp_src_addr_5 ),                     
    .q_c2h_dsc_byp_dst_addr_3  (q_c2h_dsc_byp_dst_addr_5 ),                     
    .q_c2h_dsc_byp_len_3       (q_c2h_dsc_byp_len_5      ),                
    .q_c2h_dsc_byp_ctl_3       (q_c2h_dsc_byp_ctl_5      ),              
    .q_axis_h2c_tready_3       (q_axis_h2c_tready_5      ),             
    .q_axis_h2c_tvalid_3       (q_axis_h2c_tvalid_5      ),             
    .q_axis_h2c_tdata_3        (q_axis_h2c_tdata_5       ),            
    .q_axis_h2c_tkeep_3        (q_axis_h2c_tkeep_5       ),            
    .q_axis_h2c_tlast_3        (q_axis_h2c_tlast_5       ),             
    .q_axis_c2h_tready_3       (q_axis_c2h_tready_5      ),             
    .q_axis_c2h_tvalid_3       (q_axis_c2h_tvalid_5      ),             
    .q_axis_c2h_tdata_3        (q_axis_c2h_tdata_5       ),            
    .q_axis_c2h_tkeep_3        (q_axis_c2h_tkeep_5       ),            
    .q_axis_c2h_tlast_3        (q_axis_c2h_tlast_5       ),             
    .q_h2c_dsc_byp_ready_4     (q_h2c_dsc_byp_ready_7    ),                  
    .q_h2c_dsc_byp_load_4      (q_h2c_dsc_byp_load_7     ),               
    .q_h2c_dsc_byp_src_addr_4  (q_h2c_dsc_byp_src_addr_7 ),                     
    .q_h2c_dsc_byp_dst_addr_4  (q_h2c_dsc_byp_dst_addr_7 ),                     
    .q_h2c_dsc_byp_len_4       (q_h2c_dsc_byp_len_7      ),                
    .q_h2c_dsc_byp_ctl_4       (q_h2c_dsc_byp_ctl_7      ),              
    .q_c2h_dsc_byp_ready_4     (q_c2h_dsc_byp_ready_7    ),                  
    .q_c2h_dsc_byp_load_4      (q_c2h_dsc_byp_load_7     ),               
    .q_c2h_dsc_byp_src_addr_4  (q_c2h_dsc_byp_src_addr_7 ),                     
    .q_c2h_dsc_byp_dst_addr_4  (q_c2h_dsc_byp_dst_addr_7 ),                     
    .q_c2h_dsc_byp_len_4       (q_c2h_dsc_byp_len_7      ),                
    .q_c2h_dsc_byp_ctl_4       (q_c2h_dsc_byp_ctl_7      ),              
    .q_axis_h2c_tready_4       (q_axis_h2c_tready_7      ),             
    .q_axis_h2c_tvalid_4       (q_axis_h2c_tvalid_7      ),             
    .q_axis_h2c_tdata_4        (q_axis_h2c_tdata_7       ),            
    .q_axis_h2c_tkeep_4        (q_axis_h2c_tkeep_7       ),            
    .q_axis_h2c_tlast_4        (q_axis_h2c_tlast_7       ),             
    .q_axis_c2h_tready_4       (q_axis_c2h_tready_7      ),             
    .q_axis_c2h_tvalid_4       (q_axis_c2h_tvalid_7      ),             
    .q_axis_c2h_tdata_4        (q_axis_c2h_tdata_7       ),            
    .q_axis_c2h_tkeep_4        (q_axis_c2h_tkeep_7       ),            
    .q_axis_c2h_tlast_4        (q_axis_c2h_tlast_7       ),                       
    .q_h2c_dsc_byp_ready_5     (q_h2c_dsc_byp_ready_2    ),                  
    .q_h2c_dsc_byp_load_5      (q_h2c_dsc_byp_load_2     ),               
    .q_h2c_dsc_byp_src_addr_5  (q_h2c_dsc_byp_src_addr_2 ),                     
    .q_h2c_dsc_byp_dst_addr_5  (q_h2c_dsc_byp_dst_addr_2 ),                     
    .q_h2c_dsc_byp_len_5       (q_h2c_dsc_byp_len_2      ),                
    .q_h2c_dsc_byp_ctl_5       (q_h2c_dsc_byp_ctl_2      ),              
    .q_c2h_dsc_byp_ready_5     (q_c2h_dsc_byp_ready_2    ),                  
    .q_c2h_dsc_byp_load_5      (q_c2h_dsc_byp_load_2     ),               
    .q_c2h_dsc_byp_src_addr_5  (q_c2h_dsc_byp_src_addr_2 ),                     
    .q_c2h_dsc_byp_dst_addr_5  (q_c2h_dsc_byp_dst_addr_2 ),                     
    .q_c2h_dsc_byp_len_5       (q_c2h_dsc_byp_len_2      ),                
    .q_c2h_dsc_byp_ctl_5       (q_c2h_dsc_byp_ctl_2      ),              
    .q_axis_h2c_tready_5       (q_axis_h2c_tready_2      ),             
    .q_axis_h2c_tvalid_5       (q_axis_h2c_tvalid_2      ),             
    .q_axis_h2c_tdata_5        (q_axis_h2c_tdata_2       ),            
    .q_axis_h2c_tkeep_5        (q_axis_h2c_tkeep_2       ),            
    .q_axis_h2c_tlast_5        (q_axis_h2c_tlast_2       ),             
    .q_axis_c2h_tready_5       (q_axis_c2h_tready_2      ),             
    .q_axis_c2h_tvalid_5       (q_axis_c2h_tvalid_2      ),             
    .q_axis_c2h_tdata_5        (q_axis_c2h_tdata_2       ),            
    .q_axis_c2h_tkeep_5        (q_axis_c2h_tkeep_2       ),            
    .q_axis_c2h_tlast_5        (q_axis_c2h_tlast_2       ),             
    .q_h2c_dsc_byp_ready_6     (q_h2c_dsc_byp_ready_4    ),                  
    .q_h2c_dsc_byp_load_6      (q_h2c_dsc_byp_load_4     ),               
    .q_h2c_dsc_byp_src_addr_6  (q_h2c_dsc_byp_src_addr_4 ),                     
    .q_h2c_dsc_byp_dst_addr_6  (q_h2c_dsc_byp_dst_addr_4 ),                     
    .q_h2c_dsc_byp_len_6       (q_h2c_dsc_byp_len_4      ),                
    .q_h2c_dsc_byp_ctl_6       (q_h2c_dsc_byp_ctl_4      ),              
    .q_c2h_dsc_byp_ready_6     (q_c2h_dsc_byp_ready_4    ),                  
    .q_c2h_dsc_byp_load_6      (q_c2h_dsc_byp_load_4     ),               
    .q_c2h_dsc_byp_src_addr_6  (q_c2h_dsc_byp_src_addr_4 ),                     
    .q_c2h_dsc_byp_dst_addr_6  (q_c2h_dsc_byp_dst_addr_4 ),                     
    .q_c2h_dsc_byp_len_6       (q_c2h_dsc_byp_len_4      ),                
    .q_c2h_dsc_byp_ctl_6       (q_c2h_dsc_byp_ctl_4      ),              
    .q_axis_h2c_tready_6       (q_axis_h2c_tready_4      ),             
    .q_axis_h2c_tvalid_6       (q_axis_h2c_tvalid_4      ),             
    .q_axis_h2c_tdata_6        (q_axis_h2c_tdata_4       ),            
    .q_axis_h2c_tkeep_6        (q_axis_h2c_tkeep_4       ),            
    .q_axis_h2c_tlast_6        (q_axis_h2c_tlast_4       ),             
    .q_axis_c2h_tready_6       (q_axis_c2h_tready_4      ),             
    .q_axis_c2h_tvalid_6       (q_axis_c2h_tvalid_4      ),             
    .q_axis_c2h_tdata_6        (q_axis_c2h_tdata_4       ),            
    .q_axis_c2h_tkeep_6        (q_axis_c2h_tkeep_4       ),            
    .q_axis_c2h_tlast_6        (q_axis_c2h_tlast_4       ),             
    .q_h2c_dsc_byp_ready_7     (q_h2c_dsc_byp_ready_6    ),                  
    .q_h2c_dsc_byp_load_7      (q_h2c_dsc_byp_load_6     ),               
    .q_h2c_dsc_byp_src_addr_7  (q_h2c_dsc_byp_src_addr_6 ),                     
    .q_h2c_dsc_byp_dst_addr_7  (q_h2c_dsc_byp_dst_addr_6 ),                     
    .q_h2c_dsc_byp_len_7       (q_h2c_dsc_byp_len_6      ),                
    .q_h2c_dsc_byp_ctl_7       (q_h2c_dsc_byp_ctl_6      ),              
    .q_c2h_dsc_byp_ready_7     (q_c2h_dsc_byp_ready_6    ),                  
    .q_c2h_dsc_byp_load_7      (q_c2h_dsc_byp_load_6     ),               
    .q_c2h_dsc_byp_src_addr_7  (q_c2h_dsc_byp_src_addr_6 ),                     
    .q_c2h_dsc_byp_dst_addr_7  (q_c2h_dsc_byp_dst_addr_6 ),                     
    .q_c2h_dsc_byp_len_7       (q_c2h_dsc_byp_len_6      ),                
    .q_c2h_dsc_byp_ctl_7       (q_c2h_dsc_byp_ctl_6      ),              
    .q_axis_h2c_tready_7       (q_axis_h2c_tready_6      ),             
    .q_axis_h2c_tvalid_7       (q_axis_h2c_tvalid_6      ),             
    .q_axis_h2c_tdata_7        (q_axis_h2c_tdata_6       ),            
    .q_axis_h2c_tkeep_7        (q_axis_h2c_tkeep_6       ),            
    .q_axis_h2c_tlast_7        (q_axis_h2c_tlast_6       ),             
    .q_axis_c2h_tready_7       (q_axis_c2h_tready_6      ),             
    .q_axis_c2h_tvalid_7       (q_axis_c2h_tvalid_6      ),             
    .q_axis_c2h_tdata_7        (q_axis_c2h_tdata_6       ),            
    .q_axis_c2h_tkeep_7        (q_axis_c2h_tkeep_6       ),            
    .q_axis_c2h_tlast_7        (q_axis_c2h_tlast_6       ),             
    .q_h2c_dsc_byp_ready_8     (q_h2c_dsc_byp_ready_8    ),                  
    .q_h2c_dsc_byp_load_8      (q_h2c_dsc_byp_load_8     ),               
    .q_h2c_dsc_byp_src_addr_8  (q_h2c_dsc_byp_src_addr_8 ),                     
    .q_h2c_dsc_byp_dst_addr_8  (q_h2c_dsc_byp_dst_addr_8 ),                     
    .q_h2c_dsc_byp_len_8       (q_h2c_dsc_byp_len_8      ),                
    .q_h2c_dsc_byp_ctl_8       (q_h2c_dsc_byp_ctl_8      ),              
    .q_c2h_dsc_byp_ready_8     (q_c2h_dsc_byp_ready_8    ),                  
    .q_c2h_dsc_byp_load_8      (q_c2h_dsc_byp_load_8     ),               
    .q_c2h_dsc_byp_src_addr_8  (q_c2h_dsc_byp_src_addr_8 ),                     
    .q_c2h_dsc_byp_dst_addr_8  (q_c2h_dsc_byp_dst_addr_8 ),                     
    .q_c2h_dsc_byp_len_8       (q_c2h_dsc_byp_len_8      ),                
    .q_c2h_dsc_byp_ctl_8       (q_c2h_dsc_byp_ctl_8      ),              
    .q_axis_h2c_tready_8       (q_axis_h2c_tready_8      ),             
    .q_axis_h2c_tvalid_8       (q_axis_h2c_tvalid_8      ),             
    .q_axis_h2c_tdata_8        (q_axis_h2c_tdata_8       ),            
    .q_axis_h2c_tkeep_8        (q_axis_h2c_tkeep_8       ),            
    .q_axis_h2c_tlast_8        (q_axis_h2c_tlast_8       ),             
    .q_axis_c2h_tready_8       (q_axis_c2h_tready_8      ),             
    .q_axis_c2h_tvalid_8       (q_axis_c2h_tvalid_8      ),             
    .q_axis_c2h_tdata_8        (q_axis_c2h_tdata_8       ),            
    .q_axis_c2h_tkeep_8        (q_axis_c2h_tkeep_8       ),            
    .q_axis_c2h_tlast_8        (q_axis_c2h_tlast_8       ),                                          
    .d_h2c_dsc_byp_ready_1     (d_h2c_dsc_byp_ready_1    ),                  
    .d_h2c_dsc_byp_load_1      (d_h2c_dsc_byp_load_1     ),               
    .d_h2c_dsc_byp_src_addr_1  (d_h2c_dsc_byp_src_addr_1 ),                     
    .d_h2c_dsc_byp_dst_addr_1  (d_h2c_dsc_byp_dst_addr_1 ),                     
    .d_h2c_dsc_byp_len_1       (d_h2c_dsc_byp_len_1      ),                
    .d_h2c_dsc_byp_ctl_1       (d_h2c_dsc_byp_ctl_1      ),              
    .d_c2h_dsc_byp_ready_1     (d_c2h_dsc_byp_ready_1    ),                  
    .d_c2h_dsc_byp_load_1      (d_c2h_dsc_byp_load_1     ),               
    .d_c2h_dsc_byp_src_addr_1  (d_c2h_dsc_byp_src_addr_1 ),                     
    .d_c2h_dsc_byp_dst_addr_1  (d_c2h_dsc_byp_dst_addr_1 ),                     
    .d_c2h_dsc_byp_len_1       (d_c2h_dsc_byp_len_1      ),                
    .d_c2h_dsc_byp_ctl_1       (d_c2h_dsc_byp_ctl_1      ),              
    .d_axis_h2c_tready_1       (d_axis_h2c_tready_1      ),             
    .d_axis_h2c_tvalid_1       (d_axis_h2c_tvalid_1      ),             
    .d_axis_h2c_tdata_1        (d_axis_h2c_tdata_1       ),            
    .d_axis_h2c_tkeep_1        (d_axis_h2c_tkeep_1       ),            
    .d_axis_h2c_tlast_1        (d_axis_h2c_tlast_1       ),             
    .d_axis_c2h_tready_1       (d_axis_c2h_tready_1      ),             
    .d_axis_c2h_tvalid_1       (d_axis_c2h_tvalid_1      ),             
    .d_axis_c2h_tdata_1        (d_axis_c2h_tdata_1       ),            
    .d_axis_c2h_tkeep_1        (d_axis_c2h_tkeep_1       ),            
    .d_axis_c2h_tlast_1        (d_axis_c2h_tlast_1       ),             
    .d_h2c_dsc_byp_ready_2     (d_h2c_dsc_byp_ready_3    ),                  
    .d_h2c_dsc_byp_load_2      (d_h2c_dsc_byp_load_3     ),               
    .d_h2c_dsc_byp_src_addr_2  (d_h2c_dsc_byp_src_addr_3 ),                     
    .d_h2c_dsc_byp_dst_addr_2  (d_h2c_dsc_byp_dst_addr_3 ),                     
    .d_h2c_dsc_byp_len_2       (d_h2c_dsc_byp_len_3      ),                
    .d_h2c_dsc_byp_ctl_2       (d_h2c_dsc_byp_ctl_3      ),              
    .d_c2h_dsc_byp_ready_2     (d_c2h_dsc_byp_ready_3    ),                  
    .d_c2h_dsc_byp_load_2      (d_c2h_dsc_byp_load_3     ),               
    .d_c2h_dsc_byp_src_addr_2  (d_c2h_dsc_byp_src_addr_3 ),                     
    .d_c2h_dsc_byp_dst_addr_2  (d_c2h_dsc_byp_dst_addr_3 ),                     
    .d_c2h_dsc_byp_len_2       (d_c2h_dsc_byp_len_3      ),                
    .d_c2h_dsc_byp_ctl_2       (d_c2h_dsc_byp_ctl_3      ),              
    .d_axis_h2c_tready_2       (d_axis_h2c_tready_3      ),             
    .d_axis_h2c_tvalid_2       (d_axis_h2c_tvalid_3      ),             
    .d_axis_h2c_tdata_2        (d_axis_h2c_tdata_3       ),            
    .d_axis_h2c_tkeep_2        (d_axis_h2c_tkeep_3       ),            
    .d_axis_h2c_tlast_2        (d_axis_h2c_tlast_3       ),             
    .d_axis_c2h_tready_2       (d_axis_c2h_tready_3      ),             
    .d_axis_c2h_tvalid_2       (d_axis_c2h_tvalid_3      ),             
    .d_axis_c2h_tdata_2        (d_axis_c2h_tdata_3       ),            
    .d_axis_c2h_tkeep_2        (d_axis_c2h_tkeep_3       ),            
    .d_axis_c2h_tlast_2        (d_axis_c2h_tlast_3       ),             
    .d_h2c_dsc_byp_ready_3     (d_h2c_dsc_byp_ready_5    ),                  
    .d_h2c_dsc_byp_load_3      (d_h2c_dsc_byp_load_5     ),               
    .d_h2c_dsc_byp_src_addr_3  (d_h2c_dsc_byp_src_addr_5 ),                     
    .d_h2c_dsc_byp_dst_addr_3  (d_h2c_dsc_byp_dst_addr_5 ),                     
    .d_h2c_dsc_byp_len_3       (d_h2c_dsc_byp_len_5      ),                
    .d_h2c_dsc_byp_ctl_3       (d_h2c_dsc_byp_ctl_5      ),              
    .d_c2h_dsc_byp_ready_3     (d_c2h_dsc_byp_ready_5    ),                  
    .d_c2h_dsc_byp_load_3      (d_c2h_dsc_byp_load_5     ),               
    .d_c2h_dsc_byp_src_addr_3  (d_c2h_dsc_byp_src_addr_5 ),                     
    .d_c2h_dsc_byp_dst_addr_3  (d_c2h_dsc_byp_dst_addr_5 ),                     
    .d_c2h_dsc_byp_len_3       (d_c2h_dsc_byp_len_5      ),                
    .d_c2h_dsc_byp_ctl_3       (d_c2h_dsc_byp_ctl_5      ),              
    .d_axis_h2c_tready_3       (d_axis_h2c_tready_5      ),             
    .d_axis_h2c_tvalid_3       (d_axis_h2c_tvalid_5      ),             
    .d_axis_h2c_tdata_3        (d_axis_h2c_tdata_5       ),            
    .d_axis_h2c_tkeep_3        (d_axis_h2c_tkeep_5       ),            
    .d_axis_h2c_tlast_3        (d_axis_h2c_tlast_5       ),             
    .d_axis_c2h_tready_3       (d_axis_c2h_tready_5      ),             
    .d_axis_c2h_tvalid_3       (d_axis_c2h_tvalid_5      ),             
    .d_axis_c2h_tdata_3        (d_axis_c2h_tdata_5       ),            
    .d_axis_c2h_tkeep_3        (d_axis_c2h_tkeep_5       ),            
    .d_axis_c2h_tlast_3        (d_axis_c2h_tlast_5       ),             
    .d_h2c_dsc_byp_ready_4     (d_h2c_dsc_byp_ready_7    ),                  
    .d_h2c_dsc_byp_load_4      (d_h2c_dsc_byp_load_7     ),               
    .d_h2c_dsc_byp_src_addr_4  (d_h2c_dsc_byp_src_addr_7 ),                     
    .d_h2c_dsc_byp_dst_addr_4  (d_h2c_dsc_byp_dst_addr_7 ),                     
    .d_h2c_dsc_byp_len_4       (d_h2c_dsc_byp_len_7      ),                
    .d_h2c_dsc_byp_ctl_4       (d_h2c_dsc_byp_ctl_7      ),              
    .d_c2h_dsc_byp_ready_4     (d_c2h_dsc_byp_ready_7    ),                  
    .d_c2h_dsc_byp_load_4      (d_c2h_dsc_byp_load_7     ),               
    .d_c2h_dsc_byp_src_addr_4  (d_c2h_dsc_byp_src_addr_7 ),                     
    .d_c2h_dsc_byp_dst_addr_4  (d_c2h_dsc_byp_dst_addr_7 ),                     
    .d_c2h_dsc_byp_len_4       (d_c2h_dsc_byp_len_7      ),                
    .d_c2h_dsc_byp_ctl_4       (d_c2h_dsc_byp_ctl_7      ),              
    .d_axis_h2c_tready_4       (d_axis_h2c_tready_7      ),             
    .d_axis_h2c_tvalid_4       (d_axis_h2c_tvalid_7      ),             
    .d_axis_h2c_tdata_4        (d_axis_h2c_tdata_7       ),            
    .d_axis_h2c_tkeep_4        (d_axis_h2c_tkeep_7       ),            
    .d_axis_h2c_tlast_4        (d_axis_h2c_tlast_7       ),             
    .d_axis_c2h_tready_4       (d_axis_c2h_tready_7      ),             
    .d_axis_c2h_tvalid_4       (d_axis_c2h_tvalid_7      ),             
    .d_axis_c2h_tdata_4        (d_axis_c2h_tdata_7       ),            
    .d_axis_c2h_tkeep_4        (d_axis_c2h_tkeep_7       ),            
    .d_axis_c2h_tlast_4        (d_axis_c2h_tlast_7       ),                       
    .d_h2c_dsc_byp_ready_5     (d_h2c_dsc_byp_ready_2    ),                  
    .d_h2c_dsc_byp_load_5      (d_h2c_dsc_byp_load_2     ),               
    .d_h2c_dsc_byp_src_addr_5  (d_h2c_dsc_byp_src_addr_2 ),                     
    .d_h2c_dsc_byp_dst_addr_5  (d_h2c_dsc_byp_dst_addr_2 ),                     
    .d_h2c_dsc_byp_len_5       (d_h2c_dsc_byp_len_2      ),                
    .d_h2c_dsc_byp_ctl_5       (d_h2c_dsc_byp_ctl_2      ),              
    .d_c2h_dsc_byp_ready_5     (d_c2h_dsc_byp_ready_2    ),                  
    .d_c2h_dsc_byp_load_5      (d_c2h_dsc_byp_load_2     ),               
    .d_c2h_dsc_byp_src_addr_5  (d_c2h_dsc_byp_src_addr_2 ),                     
    .d_c2h_dsc_byp_dst_addr_5  (d_c2h_dsc_byp_dst_addr_2 ),                     
    .d_c2h_dsc_byp_len_5       (d_c2h_dsc_byp_len_2      ),                
    .d_c2h_dsc_byp_ctl_5       (d_c2h_dsc_byp_ctl_2      ),              
    .d_axis_h2c_tready_5       (d_axis_h2c_tready_2      ),             
    .d_axis_h2c_tvalid_5       (d_axis_h2c_tvalid_2      ),             
    .d_axis_h2c_tdata_5        (d_axis_h2c_tdata_2       ),            
    .d_axis_h2c_tkeep_5        (d_axis_h2c_tkeep_2       ),            
    .d_axis_h2c_tlast_5        (d_axis_h2c_tlast_2       ),             
    .d_axis_c2h_tready_5       (d_axis_c2h_tready_2      ),             
    .d_axis_c2h_tvalid_5       (d_axis_c2h_tvalid_2      ),             
    .d_axis_c2h_tdata_5        (d_axis_c2h_tdata_2       ),            
    .d_axis_c2h_tkeep_5        (d_axis_c2h_tkeep_2       ),            
    .d_axis_c2h_tlast_5        (d_axis_c2h_tlast_2       ),             
    .d_h2c_dsc_byp_ready_6     (d_h2c_dsc_byp_ready_4    ),                  
    .d_h2c_dsc_byp_load_6      (d_h2c_dsc_byp_load_4     ),               
    .d_h2c_dsc_byp_src_addr_6  (d_h2c_dsc_byp_src_addr_4 ),                     
    .d_h2c_dsc_byp_dst_addr_6  (d_h2c_dsc_byp_dst_addr_4 ),                     
    .d_h2c_dsc_byp_len_6       (d_h2c_dsc_byp_len_4      ),                
    .d_h2c_dsc_byp_ctl_6       (d_h2c_dsc_byp_ctl_4      ),              
    .d_c2h_dsc_byp_ready_6     (d_c2h_dsc_byp_ready_4    ),                  
    .d_c2h_dsc_byp_load_6      (d_c2h_dsc_byp_load_4     ),               
    .d_c2h_dsc_byp_src_addr_6  (d_c2h_dsc_byp_src_addr_4 ),                     
    .d_c2h_dsc_byp_dst_addr_6  (d_c2h_dsc_byp_dst_addr_4 ),                     
    .d_c2h_dsc_byp_len_6       (d_c2h_dsc_byp_len_4      ),                
    .d_c2h_dsc_byp_ctl_6       (d_c2h_dsc_byp_ctl_4      ),              
    .d_axis_h2c_tready_6       (d_axis_h2c_tready_4      ),             
    .d_axis_h2c_tvalid_6       (d_axis_h2c_tvalid_4      ),             
    .d_axis_h2c_tdata_6        (d_axis_h2c_tdata_4       ),            
    .d_axis_h2c_tkeep_6        (d_axis_h2c_tkeep_4       ),            
    .d_axis_h2c_tlast_6        (d_axis_h2c_tlast_4       ),             
    .d_axis_c2h_tready_6       (d_axis_c2h_tready_4      ),             
    .d_axis_c2h_tvalid_6       (d_axis_c2h_tvalid_4      ),             
    .d_axis_c2h_tdata_6        (d_axis_c2h_tdata_4       ),            
    .d_axis_c2h_tkeep_6        (d_axis_c2h_tkeep_4       ),            
    .d_axis_c2h_tlast_6        (d_axis_c2h_tlast_4       ),             
    .d_h2c_dsc_byp_ready_7     (d_h2c_dsc_byp_ready_6    ),                  
    .d_h2c_dsc_byp_load_7      (d_h2c_dsc_byp_load_6     ),               
    .d_h2c_dsc_byp_src_addr_7  (d_h2c_dsc_byp_src_addr_6 ),                     
    .d_h2c_dsc_byp_dst_addr_7  (d_h2c_dsc_byp_dst_addr_6 ),                     
    .d_h2c_dsc_byp_len_7       (d_h2c_dsc_byp_len_6      ),                
    .d_h2c_dsc_byp_ctl_7       (d_h2c_dsc_byp_ctl_6      ),              
    .d_c2h_dsc_byp_ready_7     (d_c2h_dsc_byp_ready_6    ),                  
    .d_c2h_dsc_byp_load_7      (d_c2h_dsc_byp_load_6     ),               
    .d_c2h_dsc_byp_src_addr_7  (d_c2h_dsc_byp_src_addr_6 ),                     
    .d_c2h_dsc_byp_dst_addr_7  (d_c2h_dsc_byp_dst_addr_6 ),                     
    .d_c2h_dsc_byp_len_7       (d_c2h_dsc_byp_len_6      ),                
    .d_c2h_dsc_byp_ctl_7       (d_c2h_dsc_byp_ctl_6      ),              
    .d_axis_h2c_tready_7       (d_axis_h2c_tready_6      ),             
    .d_axis_h2c_tvalid_7       (d_axis_h2c_tvalid_6      ),             
    .d_axis_h2c_tdata_7        (d_axis_h2c_tdata_6       ),            
    .d_axis_h2c_tkeep_7        (d_axis_h2c_tkeep_6       ),            
    .d_axis_h2c_tlast_7        (d_axis_h2c_tlast_6       ),             
    .d_axis_c2h_tready_7       (d_axis_c2h_tready_6      ),             
    .d_axis_c2h_tvalid_7       (d_axis_c2h_tvalid_6      ),             
    .d_axis_c2h_tdata_7        (d_axis_c2h_tdata_6       ),            
    .d_axis_c2h_tkeep_7        (d_axis_c2h_tkeep_6       ),            
    .d_axis_c2h_tlast_7        (d_axis_c2h_tlast_6       ),             
    .d_h2c_dsc_byp_ready_8     (d_h2c_dsc_byp_ready_8    ),                  
    .d_h2c_dsc_byp_load_8      (d_h2c_dsc_byp_load_8     ),               
    .d_h2c_dsc_byp_src_addr_8  (d_h2c_dsc_byp_src_addr_8 ),                     
    .d_h2c_dsc_byp_dst_addr_8  (d_h2c_dsc_byp_dst_addr_8 ),                     
    .d_h2c_dsc_byp_len_8       (d_h2c_dsc_byp_len_8      ),                
    .d_h2c_dsc_byp_ctl_8       (d_h2c_dsc_byp_ctl_8      ),              
    .d_c2h_dsc_byp_ready_8     (d_c2h_dsc_byp_ready_8    ),                  
    .d_c2h_dsc_byp_load_8      (d_c2h_dsc_byp_load_8     ),               
    .d_c2h_dsc_byp_src_addr_8  (d_c2h_dsc_byp_src_addr_8 ),                     
    .d_c2h_dsc_byp_dst_addr_8  (d_c2h_dsc_byp_dst_addr_8 ),                     
    .d_c2h_dsc_byp_len_8       (d_c2h_dsc_byp_len_8      ),                
    .d_c2h_dsc_byp_ctl_8       (d_c2h_dsc_byp_ctl_8      ),              
    .d_axis_h2c_tready_8       (d_axis_h2c_tready_8      ),             
    .d_axis_h2c_tvalid_8       (d_axis_h2c_tvalid_8      ),             
    .d_axis_h2c_tdata_8        (d_axis_h2c_tdata_8       ),            
    .d_axis_h2c_tkeep_8        (d_axis_h2c_tkeep_8       ),            
    .d_axis_h2c_tlast_8        (d_axis_h2c_tlast_8       ),             
    .d_axis_c2h_tready_8       (d_axis_c2h_tready_8      ),             
    .d_axis_c2h_tvalid_8       (d_axis_c2h_tvalid_8      ),             
    .d_axis_c2h_tdata_8        (d_axis_c2h_tdata_8       ),            
    .d_axis_c2h_tkeep_8        (d_axis_c2h_tkeep_8       ),            
    .d_axis_c2h_tlast_8        (d_axis_c2h_tlast_8       )                     
  );

`elsif NVME_IO_ONE
    assign c2h_dsc_byp_load_3     = 'h0;
    assign c2h_dsc_byp_src_addr_3 = 'h0;
    assign c2h_dsc_byp_dst_addr_3 = 'h0;
    assign c2h_dsc_byp_len_3      = 'h0;
    assign c2h_dsc_byp_ctl_3      = 'h0;
    assign h2c_dsc_byp_load_3     = 'h0;
    assign h2c_dsc_byp_src_addr_3 = 'h0;
    assign h2c_dsc_byp_dst_addr_3 = 'h0;
    assign h2c_dsc_byp_len_3      = 'h0;
    assign h2c_dsc_byp_ctl_3      = 'h0;
    assign m_axis_h2c_tready_3    = 'h0;
    assign m_axis_c2h_tvalid_3    = 'h0;
    assign m_axis_c2h_tdata_3     = 'h0;
    assign m_axis_c2h_tkeep_3     = 'h0;
    assign m_axis_c2h_tlast_3     = 'h0; 

`else
    assign c2h_dsc_byp_load_1     = 'h0;
    assign c2h_dsc_byp_src_addr_1 = 'h0;
    assign c2h_dsc_byp_dst_addr_1 = 'h0;
    assign c2h_dsc_byp_len_1      = 'h0;
    assign c2h_dsc_byp_ctl_1      = 'h0;
    assign h2c_dsc_byp_load_1     = 'h0;
    assign h2c_dsc_byp_src_addr_1 = 'h0;
    assign h2c_dsc_byp_dst_addr_1 = 'h0;
    assign h2c_dsc_byp_len_1      = 'h0;
    assign h2c_dsc_byp_ctl_1      = 'h0;
    assign m_axis_h2c_tready_1    = 'h0;
    assign m_axis_c2h_tvalid_1    = 'h0;
    assign m_axis_c2h_tdata_1     = 'h0;
    assign m_axis_c2h_tkeep_1     = 'h0;
    assign m_axis_c2h_tlast_1     = 'h0; 
    assign c2h_dsc_byp_load_2     = 'h0;
    assign c2h_dsc_byp_src_addr_2 = 'h0;
    assign c2h_dsc_byp_dst_addr_2 = 'h0;
    assign c2h_dsc_byp_len_2      = 'h0;
    assign c2h_dsc_byp_ctl_2      = 'h0;
    assign h2c_dsc_byp_load_2     = 'h0;
    assign h2c_dsc_byp_src_addr_2 = 'h0;
    assign h2c_dsc_byp_dst_addr_2 = 'h0;
    assign h2c_dsc_byp_len_2      = 'h0;
    assign h2c_dsc_byp_ctl_2      = 'h0;
    assign m_axis_h2c_tready_2    = 'h0;
    assign m_axis_c2h_tvalid_2    = 'h0;
    assign m_axis_c2h_tdata_2     = 'h0;
    assign m_axis_c2h_tkeep_2     = 'h0;
    assign m_axis_c2h_tlast_2     = 'h0; 
    assign c2h_dsc_byp_load_3     = 'h0;
    assign c2h_dsc_byp_src_addr_3 = 'h0;
    assign c2h_dsc_byp_dst_addr_3 = 'h0;
    assign c2h_dsc_byp_len_3      = 'h0;
    assign c2h_dsc_byp_ctl_3      = 'h0;
    assign h2c_dsc_byp_load_3     = 'h0;
    assign h2c_dsc_byp_src_addr_3 = 'h0;
    assign h2c_dsc_byp_dst_addr_3 = 'h0;
    assign h2c_dsc_byp_len_3      = 'h0;
    assign h2c_dsc_byp_ctl_3      = 'h0;
    assign m_axis_h2c_tready_3    = 'h0;
    assign m_axis_c2h_tvalid_3    = 'h0;
    assign m_axis_c2h_tdata_3     = 'h0;
    assign m_axis_c2h_tkeep_3     = 'h0;
    assign m_axis_c2h_tlast_3     = 'h0; 
`endif


`ifdef NVME_ADMIN_USE_PS
  nvme_admin_controller nvme_admin_controller(
    .ps_clk_clk_n           (ps_clk_clk_n           ),
    .ps_clk_clk_p           (ps_clk_clk_p           ),
    .ps_reset               (reset                  ), 
    .sys_rstn               (xdma_user_resetn       ),
    .UART_0_rxd             (UART_0_rxd             ),
    .UART_0_txd             (UART_0_txd             ),  
    .nvme_reg_cc_en         (nvme_reg_cc_en         ),  
    .ps_csts_rdy            (ps_csts_rdy            ),  
    .nvme_reg_cc_shn        (nvme_reg_cc_shn        ),
    .ps_csts_shst           (ps_csts_shst           ),
`else
  nvme_admin_controller_pl nvme_admin_controller(
`endif
    .clk                    (user_clk               ),    
    .rst_n                  (user_resetn            ),   
    .sq_base_addr           (sq_base_addr_0         ),             
    .sq_size                (sq_size_0              ),        
    .sq_tail                (sq_tail_0[15:0]        ),        
    .cq_base_addr           (cq_base_addr_0         ),             
    .cq_size                (cq_size_0              ),        
    .cq_head                (cq_head_0[15:0]        ),   
`ifndef NVME_IO_ONE     
    .c2h_dsc_byp_ready      (a_c2h_dsc_byp_ready_0   ),                       
    .c2h_dsc_byp_load       (a_c2h_dsc_byp_load_0    ),                    
    .c2h_dsc_byp_src_addr   (a_c2h_dsc_byp_src_addr_0),                          
    .c2h_dsc_byp_dst_addr   (a_c2h_dsc_byp_dst_addr_0),                          
    .c2h_dsc_byp_len        (a_c2h_dsc_byp_len_0     ),                     
    .c2h_dsc_byp_ctl        (a_c2h_dsc_byp_ctl_0     ),                     
    .h2c_dsc_byp_ready      (a_h2c_dsc_byp_ready_0   ),                       
    .h2c_dsc_byp_load       (a_h2c_dsc_byp_load_0    ),                    
    .h2c_dsc_byp_src_addr   (a_h2c_dsc_byp_src_addr_0),                          
    .h2c_dsc_byp_dst_addr   (a_h2c_dsc_byp_dst_addr_0),                          
    .h2c_dsc_byp_len        (a_h2c_dsc_byp_len_0     ),                     
    .h2c_dsc_byp_ctl        (a_h2c_dsc_byp_ctl_0     ),                                       
    .axis_h2c_tready        (a_axis_h2c_tready_0     ),                  
    .axis_h2c_tvalid        (a_axis_h2c_tvalid_0     ),                  
    .axis_h2c_tdata         (a_axis_h2c_tdata_0      ),                 
    .axis_h2c_tkeep         (a_axis_h2c_tkeep_0      ),                 
    .axis_h2c_tlast         (a_axis_h2c_tlast_0      ),                          
    .axis_c2h_tready        (a_axis_c2h_tready_0     ),                  
    .axis_c2h_tvalid        (a_axis_c2h_tvalid_0     ),                  
    .axis_c2h_tdata         (a_axis_c2h_tdata_0      ),                 
    .axis_c2h_tkeep         (a_axis_c2h_tkeep_0      ),                 
    .axis_c2h_tlast         (a_axis_c2h_tlast_0      ), 
`else
    .c2h_dsc_byp_ready      (c2h_dsc_byp_ready_0     ),                       
    .c2h_dsc_byp_load       (c2h_dsc_byp_load_0      ),                    
    .c2h_dsc_byp_src_addr   (c2h_dsc_byp_src_addr_0  ),                          
    .c2h_dsc_byp_dst_addr   (c2h_dsc_byp_dst_addr_0  ),                          
    .c2h_dsc_byp_len        (c2h_dsc_byp_len_0       ),                     
    .c2h_dsc_byp_ctl        (c2h_dsc_byp_ctl_0       ),                     
    .h2c_dsc_byp_ready      (h2c_dsc_byp_ready_0     ),                       
    .h2c_dsc_byp_load       (h2c_dsc_byp_load_0      ),                    
    .h2c_dsc_byp_src_addr   (h2c_dsc_byp_src_addr_0  ),                          
    .h2c_dsc_byp_dst_addr   (h2c_dsc_byp_dst_addr_0  ),                          
    .h2c_dsc_byp_len        (h2c_dsc_byp_len_0       ),                     
    .h2c_dsc_byp_ctl        (h2c_dsc_byp_ctl_0       ),                                       
    .axis_h2c_tready        (m_axis_h2c_tready_0     ),                 
    .axis_h2c_tvalid        (m_axis_h2c_tvalid_0     ),                  
    .axis_h2c_tdata         (m_axis_h2c_tdata_0      ),                 
    .axis_h2c_tkeep         (m_axis_h2c_tkeep_0      ),                 
    .axis_h2c_tlast         (m_axis_h2c_tlast_0      ),                          
    .axis_c2h_tready        (m_axis_c2h_tready_0     ),                  
    .axis_c2h_tvalid        (m_axis_c2h_tvalid_0     ),                  
    .axis_c2h_tdata         (m_axis_c2h_tdata_0      ),                 
    .axis_c2h_tkeep         (m_axis_c2h_tkeep_0      ),                 
    .axis_c2h_tlast         (m_axis_c2h_tlast_0      ), 
`endif
    .m0_axi_araddr          (s_axil_araddr           ),          
    .m0_axi_arprot          (s_axil_arprot           ),          
    .m0_axi_arready         (s_axil_arready          ),           
    .m0_axi_arvalid         (s_axil_arvalid          ),           
    .m0_axi_awaddr          (s_axil_awaddr           ),          
    .m0_axi_awprot          (s_axil_awprot           ),          
    .m0_axi_awready         (s_axil_awready          ),           
    .m0_axi_awvalid         (s_axil_awvalid          ),           
    .m0_axi_bready          (s_axil_bready           ),          
    .m0_axi_bresp           (s_axil_bresp            ),         
    .m0_axi_bvalid          (s_axil_bvalid           ),          
    .m0_axi_rdata           (s_axil_rdata            ),         
    .m0_axi_rready          (s_axil_rready           ),          
    .m0_axi_rresp           (s_axil_rresp            ),         
    .m0_axi_rvalid          (s_axil_rvalid           ),          
    .m0_axi_wdata           (s_axil_wdata            ),         
    .m0_axi_wready          (s_axil_wready           ),          
    .m0_axi_wstrb           (s_axil_wstrb            ),         
    .m0_axi_wvalid          (s_axil_wvalid           ),
    .usr_irq_enable         (acq_irq_enable          ),     
    .usr_irq_req            (acq_irq_req             ),     
    .usr_irq_ack            (acq_irq_ack             ),                                 
    .sq_reset               (sq_reset                ),
    .cq_reset               (cq_reset                ),
    .iocq_irq_enable        (iocq_irq_enable         ),
    .sq_base_addr_1         (sq_base_addr_1          ),
    .sq_size_1              (sq_size_1               ),
    .sq_id_1                (sq_id_1                 ),
    .cq_base_addr_1         (cq_base_addr_1          ),
    .cq_size_1              (cq_size_1               ),
    .cq_id_1                (cq_id_1                 ),
    .sq_base_addr_2         (sq_base_addr_2          ),
    .sq_size_2              (sq_size_2               ),
    .sq_id_2                (sq_id_2                 ),
    .cq_base_addr_2         (cq_base_addr_2          ),
    .cq_size_2              (cq_size_2               ),
    .cq_id_2                (cq_id_2                 ),
    .sq_base_addr_3         (sq_base_addr_3          ),
    .sq_size_3              (sq_size_3               ),
    .sq_id_3                (sq_id_3                 ),
    .cq_base_addr_3         (cq_base_addr_3          ),
    .cq_size_3              (cq_size_3               ),
    .cq_id_3                (cq_id_3                 ),
    .sq_base_addr_4         (sq_base_addr_4          ),
    .sq_size_4              (sq_size_4               ),
    .sq_id_4                (sq_id_4                 ),
    .cq_base_addr_4         (cq_base_addr_4          ),
    .cq_size_4              (cq_size_4               ),
    .cq_id_4                (cq_id_4                 ),
    .sq_base_addr_5         (sq_base_addr_5          ),
    .sq_size_5              (sq_size_5               ),
    .sq_id_5                (sq_id_5                 ),
    .cq_base_addr_5         (cq_base_addr_5          ),
    .cq_size_5              (cq_size_5               ),
    .cq_id_5                (cq_id_5                 ),
    .sq_base_addr_6         (sq_base_addr_6          ),
    .sq_size_6              (sq_size_6               ),
    .sq_id_6                (sq_id_6                 ),
    .cq_base_addr_6         (cq_base_addr_6          ),
    .cq_size_6              (cq_size_6               ),
    .cq_id_6                (cq_id_6                 ),
    .sq_base_addr_7         (sq_base_addr_7          ),
    .sq_size_7              (sq_size_7               ),
    .sq_id_7                (sq_id_7                 ),
    .cq_base_addr_7         (cq_base_addr_7          ),
    .cq_size_7              (cq_size_7               ),
    .cq_id_7                (cq_id_7                 ),
    .sq_base_addr_8         (sq_base_addr_8          ),
    .sq_size_8              (sq_size_8               ),
    .sq_id_8                (sq_id_8                 ),
    .cq_base_addr_8         (cq_base_addr_8          ),
    .cq_size_8              (cq_size_8               ),
    .cq_id_8                (cq_id_8                 ),
    .sq_base_addr_9         (sq_base_addr_9          ),
    .sq_size_9              (sq_size_9               ),
    .sq_id_9                (sq_id_9                 ),
    .cq_base_addr_9         (cq_base_addr_9          ),
    .cq_size_9              (cq_size_9               ),
    .cq_id_9                (cq_id_9                 ),
    .sq_base_addr_10        (sq_base_addr_10         ),
    .sq_size_10             (sq_size_10              ),
    .sq_id_10               (sq_id_10                ),
    .cq_base_addr_10        (cq_base_addr_10         ),
    .cq_size_10             (cq_size_10              ),
    .cq_id_10               (cq_id_10                ),
    .sq_base_addr_11        (sq_base_addr_11         ),
    .sq_size_11             (sq_size_11              ),
    .sq_id_11               (sq_id_11                ),
    .cq_base_addr_11        (cq_base_addr_11         ),
    .cq_size_11             (cq_size_11              ),
    .cq_id_11               (cq_id_11                ),
    .sq_base_addr_12        (sq_base_addr_12         ),
    .sq_size_12             (sq_size_12              ),
    .sq_id_12               (sq_id_12                ),
    .cq_base_addr_12        (cq_base_addr_12         ),
    .cq_size_12             (cq_size_12              ),
    .cq_id_12               (cq_id_12                ),
    .sq_base_addr_13        (sq_base_addr_13         ),
    .sq_size_13             (sq_size_13              ),
    .sq_id_13               (sq_id_13                ),
    .cq_base_addr_13        (cq_base_addr_13         ),
    .cq_size_13             (cq_size_13              ),
    .cq_id_13               (cq_id_13                ),
    .sq_base_addr_14        (sq_base_addr_14         ),
    .sq_size_14             (sq_size_14              ),
    .sq_id_14               (sq_id_14                ),
    .cq_base_addr_14        (cq_base_addr_14         ),
    .cq_size_14             (cq_size_14              ),
    .cq_id_14               (cq_id_14                ),
    .sq_base_addr_15        (sq_base_addr_15         ),
    .sq_size_15             (sq_size_15              ),
    .sq_id_15               (sq_id_15                ),
    .cq_base_addr_15        (cq_base_addr_15         ),
    .cq_size_15             (cq_size_15              ),
    .cq_id_15               (cq_id_15                ),
    .sq_base_addr_16        (sq_base_addr_16         ),
    .sq_size_16             (sq_size_16              ),
    .sq_id_16               (sq_id_16                ),
    .cq_base_addr_16        (cq_base_addr_16         ),
    .cq_size_16             (cq_size_16              ),
    .cq_id_16               (cq_id_16                )                                             
);



assign lbads_width = `LBADS_WIDTH;


`ifdef NVME_IO_ONE
nvme_io_ctl_top nvme_io_ctl_top_1(
    .clk                   (user_clk                ), 
    .rst_n                 (user_resetn             ), 
    .sq_id                 (sq_id_1                 ), 
    .sq_base_addr          (sq_base_addr_1          ),  
    .sq_size               (sq_size_1               ),  
    .sq_tail               (sq_tail_1[15:0]         ),  
    .cq_base_addr          (cq_base_addr_1          ),  
    .cq_size               (cq_size_1               ),  
    .cq_head               (cq_head_1[15:0]         ),  
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ),
    .q_c2h_dsc_byp_ready   (c2h_dsc_byp_ready_1   ),
    .q_c2h_dsc_byp_load    (c2h_dsc_byp_load_1    ),
    .q_c2h_dsc_byp_src_addr(c2h_dsc_byp_src_addr_1),
    .q_c2h_dsc_byp_dst_addr(c2h_dsc_byp_dst_addr_1),
    .q_c2h_dsc_byp_len     (c2h_dsc_byp_len_1     ),
    .q_c2h_dsc_byp_ctl     (c2h_dsc_byp_ctl_1     ),
    .q_h2c_dsc_byp_ready   (h2c_dsc_byp_ready_1   ),
    .q_h2c_dsc_byp_load    (h2c_dsc_byp_load_1    ),
    .q_h2c_dsc_byp_src_addr(h2c_dsc_byp_src_addr_1),
    .q_h2c_dsc_byp_dst_addr(h2c_dsc_byp_dst_addr_1),
    .q_h2c_dsc_byp_len     (h2c_dsc_byp_len_1     ),
    .q_h2c_dsc_byp_ctl     (h2c_dsc_byp_ctl_1     ),
    .d_c2h_dsc_byp_ready   (c2h_dsc_byp_ready_2   ),
    .d_c2h_dsc_byp_load    (c2h_dsc_byp_load_2    ),
    .d_c2h_dsc_byp_src_addr(c2h_dsc_byp_src_addr_2),
    .d_c2h_dsc_byp_dst_addr(c2h_dsc_byp_dst_addr_2),
    .d_c2h_dsc_byp_len     (c2h_dsc_byp_len_2     ),
    .d_c2h_dsc_byp_ctl     (c2h_dsc_byp_ctl_2     ),
    .d_h2c_dsc_byp_ready   (h2c_dsc_byp_ready_2   ),
    .d_h2c_dsc_byp_load    (h2c_dsc_byp_load_2    ),
    .d_h2c_dsc_byp_src_addr(h2c_dsc_byp_src_addr_2),
    .d_h2c_dsc_byp_dst_addr(h2c_dsc_byp_dst_addr_2),
    .d_h2c_dsc_byp_len     (h2c_dsc_byp_len_2     ),
    .d_h2c_dsc_byp_ctl     (h2c_dsc_byp_ctl_2     ),
    .q_axis_h2c_tready     (m_axis_h2c_tready_1     ),
    .q_axis_h2c_tvalid     (m_axis_h2c_tvalid_1     ),
    .q_axis_h2c_tdata      (m_axis_h2c_tdata_1      ),
    .q_axis_h2c_tkeep      (m_axis_h2c_tkeep_1      ),
    .q_axis_h2c_tlast      (m_axis_h2c_tlast_1      ),
    .q_axis_c2h_tready     (m_axis_c2h_tready_1     ),
    .q_axis_c2h_tvalid     (m_axis_c2h_tvalid_1     ),
    .q_axis_c2h_tdata      (m_axis_c2h_tdata_1      ),
    .q_axis_c2h_tkeep      (m_axis_c2h_tkeep_1      ),
    .q_axis_c2h_tlast      (m_axis_c2h_tlast_1      ),
    .d_axis_h2c_tready     (m_axis_h2c_tready_2     ),
    .d_axis_h2c_tvalid     (m_axis_h2c_tvalid_2     ),
    .d_axis_h2c_tdata      (m_axis_h2c_tdata_2      ),
    .d_axis_h2c_tkeep      (m_axis_h2c_tkeep_2      ),
    .d_axis_h2c_tlast      (m_axis_h2c_tlast_2      ),
    .d_axis_c2h_tready     (m_axis_c2h_tready_2     ),
    .d_axis_c2h_tvalid     (m_axis_c2h_tvalid_2     ),
    .d_axis_c2h_tdata      (m_axis_c2h_tdata_2      ),
    .d_axis_c2h_tkeep      (m_axis_c2h_tkeep_2      ),
    .d_axis_c2h_tlast      (m_axis_c2h_tlast_2      ),
    .usr_irq_enable        (irq_enable[0]           ),
    .usr_irq_req           (irq_req[0]              ),
    .usr_irq_ack           (irq_ack[0]              ) 
);

`else
nvme_io_ctl_top nvme_io_ctl_top_1(
    .clk                   (user_clk                ), 
    .rst_n                 (user_resetn             ), 
    .sq_id                 (sq_id_1                 ), 
    .sq_base_addr          (sq_base_addr_1          ),  
    .sq_size               (sq_size_1               ),  
    .sq_tail               (sq_tail_1[15:0]         ),  
    .cq_base_addr          (cq_base_addr_1          ),  
    .cq_size               (cq_size_1               ),  
    .cq_head               (cq_head_1[15:0]         ), 
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ), 
    .q_c2h_dsc_byp_ready   (q_c2h_dsc_byp_ready_1   ),
    .q_c2h_dsc_byp_load    (q_c2h_dsc_byp_load_1    ),
    .q_c2h_dsc_byp_src_addr(q_c2h_dsc_byp_src_addr_1),
    .q_c2h_dsc_byp_dst_addr(q_c2h_dsc_byp_dst_addr_1),
    .q_c2h_dsc_byp_len     (q_c2h_dsc_byp_len_1     ),
    .q_c2h_dsc_byp_ctl     (q_c2h_dsc_byp_ctl_1     ),
    .q_h2c_dsc_byp_ready   (q_h2c_dsc_byp_ready_1   ),
    .q_h2c_dsc_byp_load    (q_h2c_dsc_byp_load_1    ),
    .q_h2c_dsc_byp_src_addr(q_h2c_dsc_byp_src_addr_1),
    .q_h2c_dsc_byp_dst_addr(q_h2c_dsc_byp_dst_addr_1),
    .q_h2c_dsc_byp_len     (q_h2c_dsc_byp_len_1     ),
    .q_h2c_dsc_byp_ctl     (q_h2c_dsc_byp_ctl_1     ),
    .d_c2h_dsc_byp_ready   (d_c2h_dsc_byp_ready_1   ),
    .d_c2h_dsc_byp_load    (d_c2h_dsc_byp_load_1    ),
    .d_c2h_dsc_byp_src_addr(d_c2h_dsc_byp_src_addr_1),
    .d_c2h_dsc_byp_dst_addr(d_c2h_dsc_byp_dst_addr_1),
    .d_c2h_dsc_byp_len     (d_c2h_dsc_byp_len_1     ),
    .d_c2h_dsc_byp_ctl     (d_c2h_dsc_byp_ctl_1     ),
    .d_h2c_dsc_byp_ready   (d_h2c_dsc_byp_ready_1   ),
    .d_h2c_dsc_byp_load    (d_h2c_dsc_byp_load_1    ),
    .d_h2c_dsc_byp_src_addr(d_h2c_dsc_byp_src_addr_1),
    .d_h2c_dsc_byp_dst_addr(d_h2c_dsc_byp_dst_addr_1),
    .d_h2c_dsc_byp_len     (d_h2c_dsc_byp_len_1     ),
    .d_h2c_dsc_byp_ctl     (d_h2c_dsc_byp_ctl_1     ),
    .q_axis_h2c_tready     (q_axis_h2c_tready_1     ),
    .q_axis_h2c_tvalid     (q_axis_h2c_tvalid_1     ),
    .q_axis_h2c_tdata      (q_axis_h2c_tdata_1      ),
    .q_axis_h2c_tkeep      (q_axis_h2c_tkeep_1      ),
    .q_axis_h2c_tlast      (q_axis_h2c_tlast_1      ),
    .q_axis_c2h_tready     (q_axis_c2h_tready_1     ),
    .q_axis_c2h_tvalid     (q_axis_c2h_tvalid_1     ),
    .q_axis_c2h_tdata      (q_axis_c2h_tdata_1      ),
    .q_axis_c2h_tkeep      (q_axis_c2h_tkeep_1      ),
    .q_axis_c2h_tlast      (q_axis_c2h_tlast_1      ),
    .d_axis_h2c_tready     (d_axis_h2c_tready_1     ),
    .d_axis_h2c_tvalid     (d_axis_h2c_tvalid_1     ),
    .d_axis_h2c_tdata      (d_axis_h2c_tdata_1      ),
    .d_axis_h2c_tkeep      (d_axis_h2c_tkeep_1      ),
    .d_axis_h2c_tlast      (d_axis_h2c_tlast_1      ),
    .d_axis_c2h_tready     (d_axis_c2h_tready_1     ),
    .d_axis_c2h_tvalid     (d_axis_c2h_tvalid_1     ),
    .d_axis_c2h_tdata      (d_axis_c2h_tdata_1      ),
    .d_axis_c2h_tkeep      (d_axis_c2h_tkeep_1      ),
    .d_axis_c2h_tlast      (d_axis_c2h_tlast_1      ),
    .usr_irq_enable        (irq_enable[0]           ),
    .usr_irq_req           (irq_req[0]              ),
    .usr_irq_ack           (irq_ack[0]              ) 
);


nvme_io_ctl_top nvme_io_ctl_top_2(
    .clk                   (user_clk                ), 
    .rst_n                 (user_resetn             ), 
    .sq_id                 (sq_id_2                 ), 
    .sq_base_addr          (sq_base_addr_2          ),  
    .sq_size               (sq_size_2               ),  
    .sq_tail               (sq_tail_2[15:0]         ),  
    .cq_base_addr          (cq_base_addr_2          ),  
    .cq_size               (cq_size_2               ),  
    .cq_head               (cq_head_2[15:0]         ),  
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ),
    .q_c2h_dsc_byp_ready   (q_c2h_dsc_byp_ready_2   ),
    .q_c2h_dsc_byp_load    (q_c2h_dsc_byp_load_2    ),
    .q_c2h_dsc_byp_src_addr(q_c2h_dsc_byp_src_addr_2),
    .q_c2h_dsc_byp_dst_addr(q_c2h_dsc_byp_dst_addr_2),
    .q_c2h_dsc_byp_len     (q_c2h_dsc_byp_len_2     ),
    .q_c2h_dsc_byp_ctl     (q_c2h_dsc_byp_ctl_2     ),
    .q_h2c_dsc_byp_ready   (q_h2c_dsc_byp_ready_2   ),
    .q_h2c_dsc_byp_load    (q_h2c_dsc_byp_load_2    ),
    .q_h2c_dsc_byp_src_addr(q_h2c_dsc_byp_src_addr_2),
    .q_h2c_dsc_byp_dst_addr(q_h2c_dsc_byp_dst_addr_2),
    .q_h2c_dsc_byp_len     (q_h2c_dsc_byp_len_2     ),
    .q_h2c_dsc_byp_ctl     (q_h2c_dsc_byp_ctl_2     ),
    .d_c2h_dsc_byp_ready   (d_c2h_dsc_byp_ready_2   ),
    .d_c2h_dsc_byp_load    (d_c2h_dsc_byp_load_2    ),
    .d_c2h_dsc_byp_src_addr(d_c2h_dsc_byp_src_addr_2),
    .d_c2h_dsc_byp_dst_addr(d_c2h_dsc_byp_dst_addr_2),
    .d_c2h_dsc_byp_len     (d_c2h_dsc_byp_len_2     ),
    .d_c2h_dsc_byp_ctl     (d_c2h_dsc_byp_ctl_2     ),
    .d_h2c_dsc_byp_ready   (d_h2c_dsc_byp_ready_2   ),
    .d_h2c_dsc_byp_load    (d_h2c_dsc_byp_load_2    ),
    .d_h2c_dsc_byp_src_addr(d_h2c_dsc_byp_src_addr_2),
    .d_h2c_dsc_byp_dst_addr(d_h2c_dsc_byp_dst_addr_2),
    .d_h2c_dsc_byp_len     (d_h2c_dsc_byp_len_2     ),
    .d_h2c_dsc_byp_ctl     (d_h2c_dsc_byp_ctl_2     ),
    .q_axis_h2c_tready     (q_axis_h2c_tready_2     ),
    .q_axis_h2c_tvalid     (q_axis_h2c_tvalid_2     ),
    .q_axis_h2c_tdata      (q_axis_h2c_tdata_2      ),
    .q_axis_h2c_tkeep      (q_axis_h2c_tkeep_2      ),
    .q_axis_h2c_tlast      (q_axis_h2c_tlast_2      ),
    .q_axis_c2h_tready     (q_axis_c2h_tready_2     ),
    .q_axis_c2h_tvalid     (q_axis_c2h_tvalid_2     ),
    .q_axis_c2h_tdata      (q_axis_c2h_tdata_2      ),
    .q_axis_c2h_tkeep      (q_axis_c2h_tkeep_2      ),
    .q_axis_c2h_tlast      (q_axis_c2h_tlast_2      ),
    .d_axis_h2c_tready     (d_axis_h2c_tready_2     ),
    .d_axis_h2c_tvalid     (d_axis_h2c_tvalid_2     ),
    .d_axis_h2c_tdata      (d_axis_h2c_tdata_2      ),
    .d_axis_h2c_tkeep      (d_axis_h2c_tkeep_2      ),
    .d_axis_h2c_tlast      (d_axis_h2c_tlast_2      ),
    .d_axis_c2h_tready     (d_axis_c2h_tready_2     ),
    .d_axis_c2h_tvalid     (d_axis_c2h_tvalid_2     ),
    .d_axis_c2h_tdata      (d_axis_c2h_tdata_2      ),
    .d_axis_c2h_tkeep      (d_axis_c2h_tkeep_2      ),
    .d_axis_c2h_tlast      (d_axis_c2h_tlast_2      ),
    .usr_irq_enable        (irq_enable[1]           ),
    .usr_irq_req           (irq_req[1]              ),
    .usr_irq_ack           (irq_ack[1]              ) 
);


nvme_io_ctl_top nvme_io_ctl_top_3(
    .clk                   (user_clk                ), 
    .rst_n                 (user_resetn             ), 
    .sq_id                 (sq_id_3                 ), 
    .sq_base_addr          (sq_base_addr_3          ),  
    .sq_size               (sq_size_3               ),  
    .sq_tail               (sq_tail_3[15:0]         ),  
    .cq_base_addr          (cq_base_addr_3          ),  
    .cq_size               (cq_size_3               ),  
    .cq_head               (cq_head_3[15:0]         ),  
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ),
    .q_c2h_dsc_byp_ready   (q_c2h_dsc_byp_ready_3   ),
    .q_c2h_dsc_byp_load    (q_c2h_dsc_byp_load_3    ),
    .q_c2h_dsc_byp_src_addr(q_c2h_dsc_byp_src_addr_3),
    .q_c2h_dsc_byp_dst_addr(q_c2h_dsc_byp_dst_addr_3),
    .q_c2h_dsc_byp_len     (q_c2h_dsc_byp_len_3     ),
    .q_c2h_dsc_byp_ctl     (q_c2h_dsc_byp_ctl_3     ),
    .q_h2c_dsc_byp_ready   (q_h2c_dsc_byp_ready_3   ),
    .q_h2c_dsc_byp_load    (q_h2c_dsc_byp_load_3    ),
    .q_h2c_dsc_byp_src_addr(q_h2c_dsc_byp_src_addr_3),
    .q_h2c_dsc_byp_dst_addr(q_h2c_dsc_byp_dst_addr_3),
    .q_h2c_dsc_byp_len     (q_h2c_dsc_byp_len_3     ),
    .q_h2c_dsc_byp_ctl     (q_h2c_dsc_byp_ctl_3     ),
    .d_c2h_dsc_byp_ready   (d_c2h_dsc_byp_ready_3   ),
    .d_c2h_dsc_byp_load    (d_c2h_dsc_byp_load_3    ),
    .d_c2h_dsc_byp_src_addr(d_c2h_dsc_byp_src_addr_3),
    .d_c2h_dsc_byp_dst_addr(d_c2h_dsc_byp_dst_addr_3),
    .d_c2h_dsc_byp_len     (d_c2h_dsc_byp_len_3     ),
    .d_c2h_dsc_byp_ctl     (d_c2h_dsc_byp_ctl_3     ),
    .d_h2c_dsc_byp_ready   (d_h2c_dsc_byp_ready_3   ),
    .d_h2c_dsc_byp_load    (d_h2c_dsc_byp_load_3    ),
    .d_h2c_dsc_byp_src_addr(d_h2c_dsc_byp_src_addr_3),
    .d_h2c_dsc_byp_dst_addr(d_h2c_dsc_byp_dst_addr_3),
    .d_h2c_dsc_byp_len     (d_h2c_dsc_byp_len_3     ),
    .d_h2c_dsc_byp_ctl     (d_h2c_dsc_byp_ctl_3     ),
    .q_axis_h2c_tready     (q_axis_h2c_tready_3     ),
    .q_axis_h2c_tvalid     (q_axis_h2c_tvalid_3     ),
    .q_axis_h2c_tdata      (q_axis_h2c_tdata_3      ),
    .q_axis_h2c_tkeep      (q_axis_h2c_tkeep_3      ),
    .q_axis_h2c_tlast      (q_axis_h2c_tlast_3      ),
    .q_axis_c2h_tready     (q_axis_c2h_tready_3     ),
    .q_axis_c2h_tvalid     (q_axis_c2h_tvalid_3     ),
    .q_axis_c2h_tdata      (q_axis_c2h_tdata_3      ),
    .q_axis_c2h_tkeep      (q_axis_c2h_tkeep_3      ),
    .q_axis_c2h_tlast      (q_axis_c2h_tlast_3      ),
    .d_axis_h2c_tready     (d_axis_h2c_tready_3     ),
    .d_axis_h2c_tvalid     (d_axis_h2c_tvalid_3     ),
    .d_axis_h2c_tdata      (d_axis_h2c_tdata_3      ),
    .d_axis_h2c_tkeep      (d_axis_h2c_tkeep_3      ),
    .d_axis_h2c_tlast      (d_axis_h2c_tlast_3      ),
    .d_axis_c2h_tready     (d_axis_c2h_tready_3     ),
    .d_axis_c2h_tvalid     (d_axis_c2h_tvalid_3     ),
    .d_axis_c2h_tdata      (d_axis_c2h_tdata_3      ),
    .d_axis_c2h_tkeep      (d_axis_c2h_tkeep_3      ),
    .d_axis_c2h_tlast      (d_axis_c2h_tlast_3      ),
    .usr_irq_enable        (irq_enable[2]           ),
    .usr_irq_req           (irq_req[2]              ),
    .usr_irq_ack           (irq_ack[2]              ) 
);


nvme_io_ctl_top nvme_io_ctl_top_4(
    .clk                   (user_clk                ), 
    .rst_n                 (user_resetn             ), 
    .sq_id                 (sq_id_4                 ), 
    .sq_base_addr          (sq_base_addr_4          ),  
    .sq_size               (sq_size_4               ),  
    .sq_tail               (sq_tail_4[15:0]         ),  
    .cq_base_addr          (cq_base_addr_4          ),  
    .cq_size               (cq_size_4               ),  
    .cq_head               (cq_head_4[15:0]         ),  
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ),
    .q_c2h_dsc_byp_ready   (q_c2h_dsc_byp_ready_4   ),
    .q_c2h_dsc_byp_load    (q_c2h_dsc_byp_load_4    ),
    .q_c2h_dsc_byp_src_addr(q_c2h_dsc_byp_src_addr_4),
    .q_c2h_dsc_byp_dst_addr(q_c2h_dsc_byp_dst_addr_4),
    .q_c2h_dsc_byp_len     (q_c2h_dsc_byp_len_4     ),
    .q_c2h_dsc_byp_ctl     (q_c2h_dsc_byp_ctl_4     ),
    .q_h2c_dsc_byp_ready   (q_h2c_dsc_byp_ready_4   ),
    .q_h2c_dsc_byp_load    (q_h2c_dsc_byp_load_4    ),
    .q_h2c_dsc_byp_src_addr(q_h2c_dsc_byp_src_addr_4),
    .q_h2c_dsc_byp_dst_addr(q_h2c_dsc_byp_dst_addr_4),
    .q_h2c_dsc_byp_len     (q_h2c_dsc_byp_len_4     ),
    .q_h2c_dsc_byp_ctl     (q_h2c_dsc_byp_ctl_4     ),
    .d_c2h_dsc_byp_ready   (d_c2h_dsc_byp_ready_4   ),
    .d_c2h_dsc_byp_load    (d_c2h_dsc_byp_load_4    ),
    .d_c2h_dsc_byp_src_addr(d_c2h_dsc_byp_src_addr_4),
    .d_c2h_dsc_byp_dst_addr(d_c2h_dsc_byp_dst_addr_4),
    .d_c2h_dsc_byp_len     (d_c2h_dsc_byp_len_4     ),
    .d_c2h_dsc_byp_ctl     (d_c2h_dsc_byp_ctl_4     ),
    .d_h2c_dsc_byp_ready   (d_h2c_dsc_byp_ready_4   ),
    .d_h2c_dsc_byp_load    (d_h2c_dsc_byp_load_4    ),
    .d_h2c_dsc_byp_src_addr(d_h2c_dsc_byp_src_addr_4),
    .d_h2c_dsc_byp_dst_addr(d_h2c_dsc_byp_dst_addr_4),
    .d_h2c_dsc_byp_len     (d_h2c_dsc_byp_len_4     ),
    .d_h2c_dsc_byp_ctl     (d_h2c_dsc_byp_ctl_4     ),
    .q_axis_h2c_tready     (q_axis_h2c_tready_4     ),
    .q_axis_h2c_tvalid     (q_axis_h2c_tvalid_4     ),
    .q_axis_h2c_tdata      (q_axis_h2c_tdata_4      ),
    .q_axis_h2c_tkeep      (q_axis_h2c_tkeep_4      ),
    .q_axis_h2c_tlast      (q_axis_h2c_tlast_4      ),
    .q_axis_c2h_tready     (q_axis_c2h_tready_4     ),
    .q_axis_c2h_tvalid     (q_axis_c2h_tvalid_4     ),
    .q_axis_c2h_tdata      (q_axis_c2h_tdata_4      ),
    .q_axis_c2h_tkeep      (q_axis_c2h_tkeep_4      ),
    .q_axis_c2h_tlast      (q_axis_c2h_tlast_4      ),
    .d_axis_h2c_tready     (d_axis_h2c_tready_4     ),
    .d_axis_h2c_tvalid     (d_axis_h2c_tvalid_4     ),
    .d_axis_h2c_tdata      (d_axis_h2c_tdata_4      ),
    .d_axis_h2c_tkeep      (d_axis_h2c_tkeep_4      ),
    .d_axis_h2c_tlast      (d_axis_h2c_tlast_4      ),
    .d_axis_c2h_tready     (d_axis_c2h_tready_4     ),
    .d_axis_c2h_tvalid     (d_axis_c2h_tvalid_4     ),
    .d_axis_c2h_tdata      (d_axis_c2h_tdata_4      ),
    .d_axis_c2h_tkeep      (d_axis_c2h_tkeep_4      ),
    .d_axis_c2h_tlast      (d_axis_c2h_tlast_4      ),
    .usr_irq_enable        (irq_enable[3]           ),
    .usr_irq_req           (irq_req[3]              ),
    .usr_irq_ack           (irq_ack[3]              ) 
);


nvme_io_ctl_top nvme_io_ctl_top_5(
    .clk                   (user_clk                ), 
    .rst_n                 (user_resetn             ), 
    .sq_id                 (sq_id_5                 ), 
    .sq_base_addr          (sq_base_addr_5          ),  
    .sq_size               (sq_size_5               ),  
    .sq_tail               (sq_tail_5[15:0]         ),  
    .cq_base_addr          (cq_base_addr_5          ),  
    .cq_size               (cq_size_5               ),  
    .cq_head               (cq_head_5[15:0]         ),  
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ),
    .q_c2h_dsc_byp_ready   (q_c2h_dsc_byp_ready_5   ),
    .q_c2h_dsc_byp_load    (q_c2h_dsc_byp_load_5    ),
    .q_c2h_dsc_byp_src_addr(q_c2h_dsc_byp_src_addr_5),
    .q_c2h_dsc_byp_dst_addr(q_c2h_dsc_byp_dst_addr_5),
    .q_c2h_dsc_byp_len     (q_c2h_dsc_byp_len_5     ),
    .q_c2h_dsc_byp_ctl     (q_c2h_dsc_byp_ctl_5     ),
    .q_h2c_dsc_byp_ready   (q_h2c_dsc_byp_ready_5   ),
    .q_h2c_dsc_byp_load    (q_h2c_dsc_byp_load_5    ),
    .q_h2c_dsc_byp_src_addr(q_h2c_dsc_byp_src_addr_5),
    .q_h2c_dsc_byp_dst_addr(q_h2c_dsc_byp_dst_addr_5),
    .q_h2c_dsc_byp_len     (q_h2c_dsc_byp_len_5     ),
    .q_h2c_dsc_byp_ctl     (q_h2c_dsc_byp_ctl_5     ),
    .d_c2h_dsc_byp_ready   (d_c2h_dsc_byp_ready_5   ),
    .d_c2h_dsc_byp_load    (d_c2h_dsc_byp_load_5    ),
    .d_c2h_dsc_byp_src_addr(d_c2h_dsc_byp_src_addr_5),
    .d_c2h_dsc_byp_dst_addr(d_c2h_dsc_byp_dst_addr_5),
    .d_c2h_dsc_byp_len     (d_c2h_dsc_byp_len_5     ),
    .d_c2h_dsc_byp_ctl     (d_c2h_dsc_byp_ctl_5     ),
    .d_h2c_dsc_byp_ready   (d_h2c_dsc_byp_ready_5   ),
    .d_h2c_dsc_byp_load    (d_h2c_dsc_byp_load_5    ),
    .d_h2c_dsc_byp_src_addr(d_h2c_dsc_byp_src_addr_5),
    .d_h2c_dsc_byp_dst_addr(d_h2c_dsc_byp_dst_addr_5),
    .d_h2c_dsc_byp_len     (d_h2c_dsc_byp_len_5     ),
    .d_h2c_dsc_byp_ctl     (d_h2c_dsc_byp_ctl_5     ),
    .q_axis_h2c_tready     (q_axis_h2c_tready_5     ),
    .q_axis_h2c_tvalid     (q_axis_h2c_tvalid_5     ),
    .q_axis_h2c_tdata      (q_axis_h2c_tdata_5      ),
    .q_axis_h2c_tkeep      (q_axis_h2c_tkeep_5      ),
    .q_axis_h2c_tlast      (q_axis_h2c_tlast_5      ),
    .q_axis_c2h_tready     (q_axis_c2h_tready_5     ),
    .q_axis_c2h_tvalid     (q_axis_c2h_tvalid_5     ),
    .q_axis_c2h_tdata      (q_axis_c2h_tdata_5      ),
    .q_axis_c2h_tkeep      (q_axis_c2h_tkeep_5      ),
    .q_axis_c2h_tlast      (q_axis_c2h_tlast_5      ),
    .d_axis_h2c_tready     (d_axis_h2c_tready_5     ),
    .d_axis_h2c_tvalid     (d_axis_h2c_tvalid_5     ),
    .d_axis_h2c_tdata      (d_axis_h2c_tdata_5      ),
    .d_axis_h2c_tkeep      (d_axis_h2c_tkeep_5      ),
    .d_axis_h2c_tlast      (d_axis_h2c_tlast_5      ),
    .d_axis_c2h_tready     (d_axis_c2h_tready_5     ),
    .d_axis_c2h_tvalid     (d_axis_c2h_tvalid_5     ),
    .d_axis_c2h_tdata      (d_axis_c2h_tdata_5      ),
    .d_axis_c2h_tkeep      (d_axis_c2h_tkeep_5      ),
    .d_axis_c2h_tlast      (d_axis_c2h_tlast_5      ),
    .usr_irq_enable        (irq_enable[4]           ),
    .usr_irq_req           (irq_req[4]              ),
    .usr_irq_ack           (irq_ack[4]              ) 
);


nvme_io_ctl_top nvme_io_ctl_top_6(
    .clk                   (user_clk                ), 
    .rst_n                 (user_resetn             ), 
    .sq_id                 (sq_id_6                 ), 
    .sq_base_addr          (sq_base_addr_6          ),  
    .sq_size               (sq_size_6               ),  
    .sq_tail               (sq_tail_6[15:0]         ),  
    .cq_base_addr          (cq_base_addr_6          ),  
    .cq_size               (cq_size_6               ),  
    .cq_head               (cq_head_6[15:0]         ),  
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ),
    .q_c2h_dsc_byp_ready   (q_c2h_dsc_byp_ready_6   ),
    .q_c2h_dsc_byp_load    (q_c2h_dsc_byp_load_6    ),
    .q_c2h_dsc_byp_src_addr(q_c2h_dsc_byp_src_addr_6),
    .q_c2h_dsc_byp_dst_addr(q_c2h_dsc_byp_dst_addr_6),
    .q_c2h_dsc_byp_len     (q_c2h_dsc_byp_len_6     ),
    .q_c2h_dsc_byp_ctl     (q_c2h_dsc_byp_ctl_6     ),
    .q_h2c_dsc_byp_ready   (q_h2c_dsc_byp_ready_6   ),
    .q_h2c_dsc_byp_load    (q_h2c_dsc_byp_load_6    ),
    .q_h2c_dsc_byp_src_addr(q_h2c_dsc_byp_src_addr_6),
    .q_h2c_dsc_byp_dst_addr(q_h2c_dsc_byp_dst_addr_6),
    .q_h2c_dsc_byp_len     (q_h2c_dsc_byp_len_6     ),
    .q_h2c_dsc_byp_ctl     (q_h2c_dsc_byp_ctl_6     ),
    .d_c2h_dsc_byp_ready   (d_c2h_dsc_byp_ready_6   ),
    .d_c2h_dsc_byp_load    (d_c2h_dsc_byp_load_6    ),
    .d_c2h_dsc_byp_src_addr(d_c2h_dsc_byp_src_addr_6),
    .d_c2h_dsc_byp_dst_addr(d_c2h_dsc_byp_dst_addr_6),
    .d_c2h_dsc_byp_len     (d_c2h_dsc_byp_len_6     ),
    .d_c2h_dsc_byp_ctl     (d_c2h_dsc_byp_ctl_6     ),
    .d_h2c_dsc_byp_ready   (d_h2c_dsc_byp_ready_6   ),
    .d_h2c_dsc_byp_load    (d_h2c_dsc_byp_load_6    ),
    .d_h2c_dsc_byp_src_addr(d_h2c_dsc_byp_src_addr_6),
    .d_h2c_dsc_byp_dst_addr(d_h2c_dsc_byp_dst_addr_6),
    .d_h2c_dsc_byp_len     (d_h2c_dsc_byp_len_6     ),
    .d_h2c_dsc_byp_ctl     (d_h2c_dsc_byp_ctl_6     ),
    .q_axis_h2c_tready     (q_axis_h2c_tready_6     ),
    .q_axis_h2c_tvalid     (q_axis_h2c_tvalid_6     ),
    .q_axis_h2c_tdata      (q_axis_h2c_tdata_6      ),
    .q_axis_h2c_tkeep      (q_axis_h2c_tkeep_6      ),
    .q_axis_h2c_tlast      (q_axis_h2c_tlast_6      ),
    .q_axis_c2h_tready     (q_axis_c2h_tready_6     ),
    .q_axis_c2h_tvalid     (q_axis_c2h_tvalid_6     ),
    .q_axis_c2h_tdata      (q_axis_c2h_tdata_6      ),
    .q_axis_c2h_tkeep      (q_axis_c2h_tkeep_6      ),
    .q_axis_c2h_tlast      (q_axis_c2h_tlast_6      ),
    .d_axis_h2c_tready     (d_axis_h2c_tready_6     ),
    .d_axis_h2c_tvalid     (d_axis_h2c_tvalid_6     ),
    .d_axis_h2c_tdata      (d_axis_h2c_tdata_6      ),
    .d_axis_h2c_tkeep      (d_axis_h2c_tkeep_6      ),
    .d_axis_h2c_tlast      (d_axis_h2c_tlast_6      ),
    .d_axis_c2h_tready     (d_axis_c2h_tready_6     ),
    .d_axis_c2h_tvalid     (d_axis_c2h_tvalid_6     ),
    .d_axis_c2h_tdata      (d_axis_c2h_tdata_6      ),
    .d_axis_c2h_tkeep      (d_axis_c2h_tkeep_6      ),
    .d_axis_c2h_tlast      (d_axis_c2h_tlast_6      ),
    .usr_irq_enable        (irq_enable[5]           ),
    .usr_irq_req           (irq_req[5]              ),
    .usr_irq_ack           (irq_ack[5]              ) 
);


nvme_io_ctl_top nvme_io_ctl_top_7(
    .clk                   (user_clk                ), 
    .rst_n                 (user_resetn             ), 
    .sq_id                 (sq_id_7                 ), 
    .sq_base_addr          (sq_base_addr_7          ),  
    .sq_size               (sq_size_7               ),  
    .sq_tail               (sq_tail_7[15:0]         ),  
    .cq_base_addr          (cq_base_addr_7          ),  
    .cq_size               (cq_size_7               ),  
    .cq_head               (cq_head_7[15:0]         ), 
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ), 
    .q_c2h_dsc_byp_ready   (q_c2h_dsc_byp_ready_7   ),
    .q_c2h_dsc_byp_load    (q_c2h_dsc_byp_load_7    ),
    .q_c2h_dsc_byp_src_addr(q_c2h_dsc_byp_src_addr_7),
    .q_c2h_dsc_byp_dst_addr(q_c2h_dsc_byp_dst_addr_7),
    .q_c2h_dsc_byp_len     (q_c2h_dsc_byp_len_7     ),
    .q_c2h_dsc_byp_ctl     (q_c2h_dsc_byp_ctl_7     ),
    .q_h2c_dsc_byp_ready   (q_h2c_dsc_byp_ready_7   ),
    .q_h2c_dsc_byp_load    (q_h2c_dsc_byp_load_7    ),
    .q_h2c_dsc_byp_src_addr(q_h2c_dsc_byp_src_addr_7),
    .q_h2c_dsc_byp_dst_addr(q_h2c_dsc_byp_dst_addr_7),
    .q_h2c_dsc_byp_len     (q_h2c_dsc_byp_len_7     ),
    .q_h2c_dsc_byp_ctl     (q_h2c_dsc_byp_ctl_7     ),
    .d_c2h_dsc_byp_ready   (d_c2h_dsc_byp_ready_7   ),
    .d_c2h_dsc_byp_load    (d_c2h_dsc_byp_load_7    ),
    .d_c2h_dsc_byp_src_addr(d_c2h_dsc_byp_src_addr_7),
    .d_c2h_dsc_byp_dst_addr(d_c2h_dsc_byp_dst_addr_7),
    .d_c2h_dsc_byp_len     (d_c2h_dsc_byp_len_7     ),
    .d_c2h_dsc_byp_ctl     (d_c2h_dsc_byp_ctl_7     ),
    .d_h2c_dsc_byp_ready   (d_h2c_dsc_byp_ready_7   ),
    .d_h2c_dsc_byp_load    (d_h2c_dsc_byp_load_7    ),
    .d_h2c_dsc_byp_src_addr(d_h2c_dsc_byp_src_addr_7),
    .d_h2c_dsc_byp_dst_addr(d_h2c_dsc_byp_dst_addr_7),
    .d_h2c_dsc_byp_len     (d_h2c_dsc_byp_len_7     ),
    .d_h2c_dsc_byp_ctl     (d_h2c_dsc_byp_ctl_7     ),
    .q_axis_h2c_tready     (q_axis_h2c_tready_7     ),
    .q_axis_h2c_tvalid     (q_axis_h2c_tvalid_7     ),
    .q_axis_h2c_tdata      (q_axis_h2c_tdata_7      ),
    .q_axis_h2c_tkeep      (q_axis_h2c_tkeep_7      ),
    .q_axis_h2c_tlast      (q_axis_h2c_tlast_7      ),
    .q_axis_c2h_tready     (q_axis_c2h_tready_7     ),
    .q_axis_c2h_tvalid     (q_axis_c2h_tvalid_7     ),
    .q_axis_c2h_tdata      (q_axis_c2h_tdata_7      ),
    .q_axis_c2h_tkeep      (q_axis_c2h_tkeep_7      ),
    .q_axis_c2h_tlast      (q_axis_c2h_tlast_7      ),
    .d_axis_h2c_tready     (d_axis_h2c_tready_7     ),
    .d_axis_h2c_tvalid     (d_axis_h2c_tvalid_7     ),
    .d_axis_h2c_tdata      (d_axis_h2c_tdata_7      ),
    .d_axis_h2c_tkeep      (d_axis_h2c_tkeep_7      ),
    .d_axis_h2c_tlast      (d_axis_h2c_tlast_7      ),
    .d_axis_c2h_tready     (d_axis_c2h_tready_7     ),
    .d_axis_c2h_tvalid     (d_axis_c2h_tvalid_7     ),
    .d_axis_c2h_tdata      (d_axis_c2h_tdata_7      ),
    .d_axis_c2h_tkeep      (d_axis_c2h_tkeep_7      ),
    .d_axis_c2h_tlast      (d_axis_c2h_tlast_7      ),
    .usr_irq_enable        (irq_enable[6]           ),
    .usr_irq_req           (irq_req[6]              ),
    .usr_irq_ack           (irq_ack[6]              ) 
);


nvme_io_ctl_top nvme_io_ctl_top_8(
    .clk                   (user_clk                ), 
    .rst_n                 (user_resetn             ), 
    .sq_id                 (sq_id_8                 ), 
    .sq_base_addr          (sq_base_addr_8          ),  
    .sq_size               (sq_size_8               ),  
    .sq_tail               (sq_tail_8[15:0]         ),  
    .cq_base_addr          (cq_base_addr_8          ),  
    .cq_size               (cq_size_8               ),  
    .cq_head               (cq_head_8[15:0]         ),  
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ),
    .q_c2h_dsc_byp_ready   (q_c2h_dsc_byp_ready_8   ),
    .q_c2h_dsc_byp_load    (q_c2h_dsc_byp_load_8    ),
    .q_c2h_dsc_byp_src_addr(q_c2h_dsc_byp_src_addr_8),
    .q_c2h_dsc_byp_dst_addr(q_c2h_dsc_byp_dst_addr_8),
    .q_c2h_dsc_byp_len     (q_c2h_dsc_byp_len_8     ),
    .q_c2h_dsc_byp_ctl     (q_c2h_dsc_byp_ctl_8     ),
    .q_h2c_dsc_byp_ready   (q_h2c_dsc_byp_ready_8   ),
    .q_h2c_dsc_byp_load    (q_h2c_dsc_byp_load_8    ),
    .q_h2c_dsc_byp_src_addr(q_h2c_dsc_byp_src_addr_8),
    .q_h2c_dsc_byp_dst_addr(q_h2c_dsc_byp_dst_addr_8),
    .q_h2c_dsc_byp_len     (q_h2c_dsc_byp_len_8     ),
    .q_h2c_dsc_byp_ctl     (q_h2c_dsc_byp_ctl_8     ),
    .d_c2h_dsc_byp_ready   (d_c2h_dsc_byp_ready_8   ),
    .d_c2h_dsc_byp_load    (d_c2h_dsc_byp_load_8    ),
    .d_c2h_dsc_byp_src_addr(d_c2h_dsc_byp_src_addr_8),
    .d_c2h_dsc_byp_dst_addr(d_c2h_dsc_byp_dst_addr_8),
    .d_c2h_dsc_byp_len     (d_c2h_dsc_byp_len_8     ),
    .d_c2h_dsc_byp_ctl     (d_c2h_dsc_byp_ctl_8     ),
    .d_h2c_dsc_byp_ready   (d_h2c_dsc_byp_ready_8   ),
    .d_h2c_dsc_byp_load    (d_h2c_dsc_byp_load_8    ),
    .d_h2c_dsc_byp_src_addr(d_h2c_dsc_byp_src_addr_8),
    .d_h2c_dsc_byp_dst_addr(d_h2c_dsc_byp_dst_addr_8),
    .d_h2c_dsc_byp_len     (d_h2c_dsc_byp_len_8     ),
    .d_h2c_dsc_byp_ctl     (d_h2c_dsc_byp_ctl_8     ),
    .q_axis_h2c_tready     (q_axis_h2c_tready_8     ),
    .q_axis_h2c_tvalid     (q_axis_h2c_tvalid_8     ),
    .q_axis_h2c_tdata      (q_axis_h2c_tdata_8      ),
    .q_axis_h2c_tkeep      (q_axis_h2c_tkeep_8      ),
    .q_axis_h2c_tlast      (q_axis_h2c_tlast_8      ),
    .q_axis_c2h_tready     (q_axis_c2h_tready_8     ),
    .q_axis_c2h_tvalid     (q_axis_c2h_tvalid_8     ),
    .q_axis_c2h_tdata      (q_axis_c2h_tdata_8      ),
    .q_axis_c2h_tkeep      (q_axis_c2h_tkeep_8      ),
    .q_axis_c2h_tlast      (q_axis_c2h_tlast_8      ),
    .d_axis_h2c_tready     (d_axis_h2c_tready_8     ),
    .d_axis_h2c_tvalid     (d_axis_h2c_tvalid_8     ),
    .d_axis_h2c_tdata      (d_axis_h2c_tdata_8      ),
    .d_axis_h2c_tkeep      (d_axis_h2c_tkeep_8      ),
    .d_axis_h2c_tlast      (d_axis_h2c_tlast_8      ),
    .d_axis_c2h_tready     (d_axis_c2h_tready_8     ),
    .d_axis_c2h_tvalid     (d_axis_c2h_tvalid_8     ),
    .d_axis_c2h_tdata      (d_axis_c2h_tdata_8      ),
    .d_axis_c2h_tkeep      (d_axis_c2h_tkeep_8      ),
    .d_axis_c2h_tlast      (d_axis_c2h_tlast_8      ),
    .usr_irq_enable        (irq_enable[7]           ),
    .usr_irq_req           (irq_req[7]              ),
    .usr_irq_ack           (irq_ack[7]              ) 
);

`ifdef NVME_IO_SIXTEEN
nvme_io_ctl_top nvme_io_ctl_top_9(
    .clk                   (user_clk                ), 
    .rst_n                 (user_resetn             ), 
    .sq_id                 (sq_id_9                 ), 
    .sq_base_addr          (sq_base_addr_9          ),  
    .sq_size               (sq_size_9               ),  
    .sq_tail               (sq_tail_9[15:0]         ),  
    .cq_base_addr          (cq_base_addr_9          ),  
    .cq_size               (cq_size_9               ),  
    .cq_head               (cq_head_9[15:0]         ),  
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ),
    .q_c2h_dsc_byp_ready   (q_c2h_dsc_byp_ready_9   ),
    .q_c2h_dsc_byp_load    (q_c2h_dsc_byp_load_9    ),
    .q_c2h_dsc_byp_src_addr(q_c2h_dsc_byp_src_addr_9),
    .q_c2h_dsc_byp_dst_addr(q_c2h_dsc_byp_dst_addr_9),
    .q_c2h_dsc_byp_len     (q_c2h_dsc_byp_len_9     ),
    .q_c2h_dsc_byp_ctl     (q_c2h_dsc_byp_ctl_9     ),
    .q_h2c_dsc_byp_ready   (q_h2c_dsc_byp_ready_9   ),
    .q_h2c_dsc_byp_load    (q_h2c_dsc_byp_load_9    ),
    .q_h2c_dsc_byp_src_addr(q_h2c_dsc_byp_src_addr_9),
    .q_h2c_dsc_byp_dst_addr(q_h2c_dsc_byp_dst_addr_9),
    .q_h2c_dsc_byp_len     (q_h2c_dsc_byp_len_9     ),
    .q_h2c_dsc_byp_ctl     (q_h2c_dsc_byp_ctl_9     ),
    .d_c2h_dsc_byp_ready   (d_c2h_dsc_byp_ready_9   ),
    .d_c2h_dsc_byp_load    (d_c2h_dsc_byp_load_9    ),
    .d_c2h_dsc_byp_src_addr(d_c2h_dsc_byp_src_addr_9),
    .d_c2h_dsc_byp_dst_addr(d_c2h_dsc_byp_dst_addr_9),
    .d_c2h_dsc_byp_len     (d_c2h_dsc_byp_len_9     ),
    .d_c2h_dsc_byp_ctl     (d_c2h_dsc_byp_ctl_9     ),
    .d_h2c_dsc_byp_ready   (d_h2c_dsc_byp_ready_9   ),
    .d_h2c_dsc_byp_load    (d_h2c_dsc_byp_load_9    ),
    .d_h2c_dsc_byp_src_addr(d_h2c_dsc_byp_src_addr_9),
    .d_h2c_dsc_byp_dst_addr(d_h2c_dsc_byp_dst_addr_9),
    .d_h2c_dsc_byp_len     (d_h2c_dsc_byp_len_9     ),
    .d_h2c_dsc_byp_ctl     (d_h2c_dsc_byp_ctl_9     ),
    .q_axis_h2c_tready     (q_axis_h2c_tready_9     ),
    .q_axis_h2c_tvalid     (q_axis_h2c_tvalid_9     ),
    .q_axis_h2c_tdata      (q_axis_h2c_tdata_9      ),
    .q_axis_h2c_tkeep      (q_axis_h2c_tkeep_9      ),
    .q_axis_h2c_tlast      (q_axis_h2c_tlast_9      ),
    .q_axis_c2h_tready     (q_axis_c2h_tready_9     ),
    .q_axis_c2h_tvalid     (q_axis_c2h_tvalid_9     ),
    .q_axis_c2h_tdata      (q_axis_c2h_tdata_9      ),
    .q_axis_c2h_tkeep      (q_axis_c2h_tkeep_9      ),
    .q_axis_c2h_tlast      (q_axis_c2h_tlast_9      ),
    .d_axis_h2c_tready     (d_axis_h2c_tready_9     ),
    .d_axis_h2c_tvalid     (d_axis_h2c_tvalid_9     ),
    .d_axis_h2c_tdata      (d_axis_h2c_tdata_9      ),
    .d_axis_h2c_tkeep      (d_axis_h2c_tkeep_9      ),
    .d_axis_h2c_tlast      (d_axis_h2c_tlast_9      ),
    .d_axis_c2h_tready     (d_axis_c2h_tready_9     ),
    .d_axis_c2h_tvalid     (d_axis_c2h_tvalid_9     ),
    .d_axis_c2h_tdata      (d_axis_c2h_tdata_9      ),
    .d_axis_c2h_tkeep      (d_axis_c2h_tkeep_9      ),
    .d_axis_c2h_tlast      (d_axis_c2h_tlast_9      ),
    .usr_irq_enable        (irq_enable[8]           ),
    .usr_irq_req           (irq_req[8]              ),
    .usr_irq_ack           (irq_ack[8]              ) 
);


nvme_io_ctl_top nvme_io_ctl_top_10(
    .clk                   (user_clk                ), 
    .rst_n                 (user_resetn             ), 
    .sq_id                 (sq_id_10                 ), 
    .sq_base_addr          (sq_base_addr_10          ),  
    .sq_size               (sq_size_10               ),  
    .sq_tail               (sq_tail_10[15:0]         ),  
    .cq_base_addr          (cq_base_addr_10          ),  
    .cq_size               (cq_size_10               ),  
    .cq_head               (cq_head_10[15:0]         ), 
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ), 
    .q_c2h_dsc_byp_ready   (q_c2h_dsc_byp_ready_10   ),
    .q_c2h_dsc_byp_load    (q_c2h_dsc_byp_load_10    ),
    .q_c2h_dsc_byp_src_addr(q_c2h_dsc_byp_src_addr_10),
    .q_c2h_dsc_byp_dst_addr(q_c2h_dsc_byp_dst_addr_10),
    .q_c2h_dsc_byp_len     (q_c2h_dsc_byp_len_10     ),
    .q_c2h_dsc_byp_ctl     (q_c2h_dsc_byp_ctl_10     ),
    .q_h2c_dsc_byp_ready   (q_h2c_dsc_byp_ready_10   ),
    .q_h2c_dsc_byp_load    (q_h2c_dsc_byp_load_10    ),
    .q_h2c_dsc_byp_src_addr(q_h2c_dsc_byp_src_addr_10),
    .q_h2c_dsc_byp_dst_addr(q_h2c_dsc_byp_dst_addr_10),
    .q_h2c_dsc_byp_len     (q_h2c_dsc_byp_len_10     ),
    .q_h2c_dsc_byp_ctl     (q_h2c_dsc_byp_ctl_10     ),
    .d_c2h_dsc_byp_ready   (d_c2h_dsc_byp_ready_10   ),
    .d_c2h_dsc_byp_load    (d_c2h_dsc_byp_load_10    ),
    .d_c2h_dsc_byp_src_addr(d_c2h_dsc_byp_src_addr_10),
    .d_c2h_dsc_byp_dst_addr(d_c2h_dsc_byp_dst_addr_10),
    .d_c2h_dsc_byp_len     (d_c2h_dsc_byp_len_10     ),
    .d_c2h_dsc_byp_ctl     (d_c2h_dsc_byp_ctl_10     ),
    .d_h2c_dsc_byp_ready   (d_h2c_dsc_byp_ready_10   ),
    .d_h2c_dsc_byp_load    (d_h2c_dsc_byp_load_10    ),
    .d_h2c_dsc_byp_src_addr(d_h2c_dsc_byp_src_addr_10),
    .d_h2c_dsc_byp_dst_addr(d_h2c_dsc_byp_dst_addr_10),
    .d_h2c_dsc_byp_len     (d_h2c_dsc_byp_len_10     ),
    .d_h2c_dsc_byp_ctl     (d_h2c_dsc_byp_ctl_10     ),
    .q_axis_h2c_tready     (q_axis_h2c_tready_10     ),
    .q_axis_h2c_tvalid     (q_axis_h2c_tvalid_10     ),
    .q_axis_h2c_tdata      (q_axis_h2c_tdata_10      ),
    .q_axis_h2c_tkeep      (q_axis_h2c_tkeep_10      ),
    .q_axis_h2c_tlast      (q_axis_h2c_tlast_10      ),
    .q_axis_c2h_tready     (q_axis_c2h_tready_10     ),
    .q_axis_c2h_tvalid     (q_axis_c2h_tvalid_10     ),
    .q_axis_c2h_tdata      (q_axis_c2h_tdata_10      ),
    .q_axis_c2h_tkeep      (q_axis_c2h_tkeep_10      ),
    .q_axis_c2h_tlast      (q_axis_c2h_tlast_10      ),
    .d_axis_h2c_tready     (d_axis_h2c_tready_10     ),
    .d_axis_h2c_tvalid     (d_axis_h2c_tvalid_10     ),
    .d_axis_h2c_tdata      (d_axis_h2c_tdata_10      ),
    .d_axis_h2c_tkeep      (d_axis_h2c_tkeep_10      ),
    .d_axis_h2c_tlast      (d_axis_h2c_tlast_10      ),
    .d_axis_c2h_tready     (d_axis_c2h_tready_10     ),
    .d_axis_c2h_tvalid     (d_axis_c2h_tvalid_10     ),
    .d_axis_c2h_tdata      (d_axis_c2h_tdata_10      ),
    .d_axis_c2h_tkeep      (d_axis_c2h_tkeep_10      ),
    .d_axis_c2h_tlast      (d_axis_c2h_tlast_10      ),
    .usr_irq_enable        (irq_enable[9]           ),
    .usr_irq_req           (irq_req[9]              ),
    .usr_irq_ack           (irq_ack[9]              ) 
);


nvme_io_ctl_top nvme_io_ctl_top_11(
    .clk                   (user_clk                ), 
    .rst_n                 (user_resetn             ), 
    .sq_id                 (sq_id_11                 ), 
    .sq_base_addr          (sq_base_addr_11          ),  
    .sq_size               (sq_size_11               ),  
    .sq_tail               (sq_tail_11[15:0]         ),  
    .cq_base_addr          (cq_base_addr_11          ),  
    .cq_size               (cq_size_11               ),  
    .cq_head               (cq_head_11[15:0]         ),  
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ),
    .q_c2h_dsc_byp_ready   (q_c2h_dsc_byp_ready_11   ),
    .q_c2h_dsc_byp_load    (q_c2h_dsc_byp_load_11    ),
    .q_c2h_dsc_byp_src_addr(q_c2h_dsc_byp_src_addr_11),
    .q_c2h_dsc_byp_dst_addr(q_c2h_dsc_byp_dst_addr_11),
    .q_c2h_dsc_byp_len     (q_c2h_dsc_byp_len_11     ),
    .q_c2h_dsc_byp_ctl     (q_c2h_dsc_byp_ctl_11     ),
    .q_h2c_dsc_byp_ready   (q_h2c_dsc_byp_ready_11   ),
    .q_h2c_dsc_byp_load    (q_h2c_dsc_byp_load_11    ),
    .q_h2c_dsc_byp_src_addr(q_h2c_dsc_byp_src_addr_11),
    .q_h2c_dsc_byp_dst_addr(q_h2c_dsc_byp_dst_addr_11),
    .q_h2c_dsc_byp_len     (q_h2c_dsc_byp_len_11     ),
    .q_h2c_dsc_byp_ctl     (q_h2c_dsc_byp_ctl_11     ),
    .d_c2h_dsc_byp_ready   (d_c2h_dsc_byp_ready_11   ),
    .d_c2h_dsc_byp_load    (d_c2h_dsc_byp_load_11    ),
    .d_c2h_dsc_byp_src_addr(d_c2h_dsc_byp_src_addr_11),
    .d_c2h_dsc_byp_dst_addr(d_c2h_dsc_byp_dst_addr_11),
    .d_c2h_dsc_byp_len     (d_c2h_dsc_byp_len_11     ),
    .d_c2h_dsc_byp_ctl     (d_c2h_dsc_byp_ctl_11     ),
    .d_h2c_dsc_byp_ready   (d_h2c_dsc_byp_ready_11   ),
    .d_h2c_dsc_byp_load    (d_h2c_dsc_byp_load_11    ),
    .d_h2c_dsc_byp_src_addr(d_h2c_dsc_byp_src_addr_11),
    .d_h2c_dsc_byp_dst_addr(d_h2c_dsc_byp_dst_addr_11),
    .d_h2c_dsc_byp_len     (d_h2c_dsc_byp_len_11     ),
    .d_h2c_dsc_byp_ctl     (d_h2c_dsc_byp_ctl_11     ),
    .q_axis_h2c_tready     (q_axis_h2c_tready_11     ),
    .q_axis_h2c_tvalid     (q_axis_h2c_tvalid_11     ),
    .q_axis_h2c_tdata      (q_axis_h2c_tdata_11      ),
    .q_axis_h2c_tkeep      (q_axis_h2c_tkeep_11      ),
    .q_axis_h2c_tlast      (q_axis_h2c_tlast_11      ),
    .q_axis_c2h_tready     (q_axis_c2h_tready_11     ),
    .q_axis_c2h_tvalid     (q_axis_c2h_tvalid_11     ),
    .q_axis_c2h_tdata      (q_axis_c2h_tdata_11      ),
    .q_axis_c2h_tkeep      (q_axis_c2h_tkeep_11      ),
    .q_axis_c2h_tlast      (q_axis_c2h_tlast_11      ),
    .d_axis_h2c_tready     (d_axis_h2c_tready_11     ),
    .d_axis_h2c_tvalid     (d_axis_h2c_tvalid_11     ),
    .d_axis_h2c_tdata      (d_axis_h2c_tdata_11      ),
    .d_axis_h2c_tkeep      (d_axis_h2c_tkeep_11      ),
    .d_axis_h2c_tlast      (d_axis_h2c_tlast_11      ),
    .d_axis_c2h_tready     (d_axis_c2h_tready_11     ),
    .d_axis_c2h_tvalid     (d_axis_c2h_tvalid_11     ),
    .d_axis_c2h_tdata      (d_axis_c2h_tdata_11      ),
    .d_axis_c2h_tkeep      (d_axis_c2h_tkeep_11      ),
    .d_axis_c2h_tlast      (d_axis_c2h_tlast_11      ),
    .usr_irq_enable        (irq_enable[10]           ),
    .usr_irq_req           (irq_req[10]              ),
    .usr_irq_ack           (irq_ack[10]              ) 
);


nvme_io_ctl_top nvme_io_ctl_top_12(
    .clk                   (user_clk                ), 
    .rst_n                 (user_resetn             ), 
    .sq_id                 (sq_id_12                 ), 
    .sq_base_addr          (sq_base_addr_12          ),  
    .sq_size               (sq_size_12               ),  
    .sq_tail               (sq_tail_12[15:0]         ),  
    .cq_base_addr          (cq_base_addr_12          ),  
    .cq_size               (cq_size_12               ),  
    .cq_head               (cq_head_12[15:0]         ),  
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ),
    .q_c2h_dsc_byp_ready   (q_c2h_dsc_byp_ready_12   ),
    .q_c2h_dsc_byp_load    (q_c2h_dsc_byp_load_12    ),
    .q_c2h_dsc_byp_src_addr(q_c2h_dsc_byp_src_addr_12),
    .q_c2h_dsc_byp_dst_addr(q_c2h_dsc_byp_dst_addr_12),
    .q_c2h_dsc_byp_len     (q_c2h_dsc_byp_len_12     ),
    .q_c2h_dsc_byp_ctl     (q_c2h_dsc_byp_ctl_12     ),
    .q_h2c_dsc_byp_ready   (q_h2c_dsc_byp_ready_12   ),
    .q_h2c_dsc_byp_load    (q_h2c_dsc_byp_load_12    ),
    .q_h2c_dsc_byp_src_addr(q_h2c_dsc_byp_src_addr_12),
    .q_h2c_dsc_byp_dst_addr(q_h2c_dsc_byp_dst_addr_12),
    .q_h2c_dsc_byp_len     (q_h2c_dsc_byp_len_12     ),
    .q_h2c_dsc_byp_ctl     (q_h2c_dsc_byp_ctl_12     ),
    .d_c2h_dsc_byp_ready   (d_c2h_dsc_byp_ready_12   ),
    .d_c2h_dsc_byp_load    (d_c2h_dsc_byp_load_12    ),
    .d_c2h_dsc_byp_src_addr(d_c2h_dsc_byp_src_addr_12),
    .d_c2h_dsc_byp_dst_addr(d_c2h_dsc_byp_dst_addr_12),
    .d_c2h_dsc_byp_len     (d_c2h_dsc_byp_len_12     ),
    .d_c2h_dsc_byp_ctl     (d_c2h_dsc_byp_ctl_12     ),
    .d_h2c_dsc_byp_ready   (d_h2c_dsc_byp_ready_12   ),
    .d_h2c_dsc_byp_load    (d_h2c_dsc_byp_load_12    ),
    .d_h2c_dsc_byp_src_addr(d_h2c_dsc_byp_src_addr_12),
    .d_h2c_dsc_byp_dst_addr(d_h2c_dsc_byp_dst_addr_12),
    .d_h2c_dsc_byp_len     (d_h2c_dsc_byp_len_12     ),
    .d_h2c_dsc_byp_ctl     (d_h2c_dsc_byp_ctl_12     ),
    .q_axis_h2c_tready     (q_axis_h2c_tready_12     ),
    .q_axis_h2c_tvalid     (q_axis_h2c_tvalid_12     ),
    .q_axis_h2c_tdata      (q_axis_h2c_tdata_12      ),
    .q_axis_h2c_tkeep      (q_axis_h2c_tkeep_12      ),
    .q_axis_h2c_tlast      (q_axis_h2c_tlast_12      ),
    .q_axis_c2h_tready     (q_axis_c2h_tready_12     ),
    .q_axis_c2h_tvalid     (q_axis_c2h_tvalid_12     ),
    .q_axis_c2h_tdata      (q_axis_c2h_tdata_12      ),
    .q_axis_c2h_tkeep      (q_axis_c2h_tkeep_12      ),
    .q_axis_c2h_tlast      (q_axis_c2h_tlast_12      ),
    .d_axis_h2c_tready     (d_axis_h2c_tready_12     ),
    .d_axis_h2c_tvalid     (d_axis_h2c_tvalid_12     ),
    .d_axis_h2c_tdata      (d_axis_h2c_tdata_12      ),
    .d_axis_h2c_tkeep      (d_axis_h2c_tkeep_12      ),
    .d_axis_h2c_tlast      (d_axis_h2c_tlast_12      ),
    .d_axis_c2h_tready     (d_axis_c2h_tready_12     ),
    .d_axis_c2h_tvalid     (d_axis_c2h_tvalid_12     ),
    .d_axis_c2h_tdata      (d_axis_c2h_tdata_12      ),
    .d_axis_c2h_tkeep      (d_axis_c2h_tkeep_12      ),
    .d_axis_c2h_tlast      (d_axis_c2h_tlast_12      ),
    .usr_irq_enable        (irq_enable[11]           ),
    .usr_irq_req           (irq_req[11]              ),
    .usr_irq_ack           (irq_ack[11]              ) 
);


nvme_io_ctl_top nvme_io_ctl_top_13(
    .clk                   (user_clk                ), 
    .rst_n                 (user_resetn             ), 
    .sq_id                 (sq_id_13                 ), 
    .sq_base_addr          (sq_base_addr_13          ),  
    .sq_size               (sq_size_13               ),  
    .sq_tail               (sq_tail_13[15:0]         ),  
    .cq_base_addr          (cq_base_addr_13          ),  
    .cq_size               (cq_size_13               ),  
    .cq_head               (cq_head_13[15:0]         ),  
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ),
    .q_c2h_dsc_byp_ready   (q_c2h_dsc_byp_ready_13   ),
    .q_c2h_dsc_byp_load    (q_c2h_dsc_byp_load_13    ),
    .q_c2h_dsc_byp_src_addr(q_c2h_dsc_byp_src_addr_13),
    .q_c2h_dsc_byp_dst_addr(q_c2h_dsc_byp_dst_addr_13),
    .q_c2h_dsc_byp_len     (q_c2h_dsc_byp_len_13     ),
    .q_c2h_dsc_byp_ctl     (q_c2h_dsc_byp_ctl_13     ),
    .q_h2c_dsc_byp_ready   (q_h2c_dsc_byp_ready_13   ),
    .q_h2c_dsc_byp_load    (q_h2c_dsc_byp_load_13    ),
    .q_h2c_dsc_byp_src_addr(q_h2c_dsc_byp_src_addr_13),
    .q_h2c_dsc_byp_dst_addr(q_h2c_dsc_byp_dst_addr_13),
    .q_h2c_dsc_byp_len     (q_h2c_dsc_byp_len_13     ),
    .q_h2c_dsc_byp_ctl     (q_h2c_dsc_byp_ctl_13     ),
    .d_c2h_dsc_byp_ready   (d_c2h_dsc_byp_ready_13   ),
    .d_c2h_dsc_byp_load    (d_c2h_dsc_byp_load_13    ),
    .d_c2h_dsc_byp_src_addr(d_c2h_dsc_byp_src_addr_13),
    .d_c2h_dsc_byp_dst_addr(d_c2h_dsc_byp_dst_addr_13),
    .d_c2h_dsc_byp_len     (d_c2h_dsc_byp_len_13     ),
    .d_c2h_dsc_byp_ctl     (d_c2h_dsc_byp_ctl_13     ),
    .d_h2c_dsc_byp_ready   (d_h2c_dsc_byp_ready_13   ),
    .d_h2c_dsc_byp_load    (d_h2c_dsc_byp_load_13    ),
    .d_h2c_dsc_byp_src_addr(d_h2c_dsc_byp_src_addr_13),
    .d_h2c_dsc_byp_dst_addr(d_h2c_dsc_byp_dst_addr_13),
    .d_h2c_dsc_byp_len     (d_h2c_dsc_byp_len_13     ),
    .d_h2c_dsc_byp_ctl     (d_h2c_dsc_byp_ctl_13     ),
    .q_axis_h2c_tready     (q_axis_h2c_tready_13     ),
    .q_axis_h2c_tvalid     (q_axis_h2c_tvalid_13     ),
    .q_axis_h2c_tdata      (q_axis_h2c_tdata_13      ),
    .q_axis_h2c_tkeep      (q_axis_h2c_tkeep_13      ),
    .q_axis_h2c_tlast      (q_axis_h2c_tlast_13      ),
    .q_axis_c2h_tready     (q_axis_c2h_tready_13     ),
    .q_axis_c2h_tvalid     (q_axis_c2h_tvalid_13     ),
    .q_axis_c2h_tdata      (q_axis_c2h_tdata_13      ),
    .q_axis_c2h_tkeep      (q_axis_c2h_tkeep_13      ),
    .q_axis_c2h_tlast      (q_axis_c2h_tlast_13      ),
    .d_axis_h2c_tready     (d_axis_h2c_tready_13     ),
    .d_axis_h2c_tvalid     (d_axis_h2c_tvalid_13     ),
    .d_axis_h2c_tdata      (d_axis_h2c_tdata_13      ),
    .d_axis_h2c_tkeep      (d_axis_h2c_tkeep_13      ),
    .d_axis_h2c_tlast      (d_axis_h2c_tlast_13      ),
    .d_axis_c2h_tready     (d_axis_c2h_tready_13     ),
    .d_axis_c2h_tvalid     (d_axis_c2h_tvalid_13     ),
    .d_axis_c2h_tdata      (d_axis_c2h_tdata_13      ),
    .d_axis_c2h_tkeep      (d_axis_c2h_tkeep_13      ),
    .d_axis_c2h_tlast      (d_axis_c2h_tlast_13      ),
    .usr_irq_enable        (irq_enable[12]           ),
    .usr_irq_req           (irq_req[12]              ),
    .usr_irq_ack           (irq_ack[12]              ) 
);


nvme_io_ctl_top nvme_io_ctl_top_14(
    .clk                   (user_clk                ), 
    .rst_n                 (user_resetn             ), 
    .sq_id                 (sq_id_14                 ), 
    .sq_base_addr          (sq_base_addr_14          ),  
    .sq_size               (sq_size_14               ),  
    .sq_tail               (sq_tail_14[15:0]         ),  
    .cq_base_addr          (cq_base_addr_14          ),  
    .cq_size               (cq_size_14               ),  
    .cq_head               (cq_head_14[15:0]         ), 
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ), 
    .q_c2h_dsc_byp_ready   (q_c2h_dsc_byp_ready_14   ),
    .q_c2h_dsc_byp_load    (q_c2h_dsc_byp_load_14    ),
    .q_c2h_dsc_byp_src_addr(q_c2h_dsc_byp_src_addr_14),
    .q_c2h_dsc_byp_dst_addr(q_c2h_dsc_byp_dst_addr_14),
    .q_c2h_dsc_byp_len     (q_c2h_dsc_byp_len_14     ),
    .q_c2h_dsc_byp_ctl     (q_c2h_dsc_byp_ctl_14     ),
    .q_h2c_dsc_byp_ready   (q_h2c_dsc_byp_ready_14   ),
    .q_h2c_dsc_byp_load    (q_h2c_dsc_byp_load_14    ),
    .q_h2c_dsc_byp_src_addr(q_h2c_dsc_byp_src_addr_14),
    .q_h2c_dsc_byp_dst_addr(q_h2c_dsc_byp_dst_addr_14),
    .q_h2c_dsc_byp_len     (q_h2c_dsc_byp_len_14     ),
    .q_h2c_dsc_byp_ctl     (q_h2c_dsc_byp_ctl_14     ),
    .d_c2h_dsc_byp_ready   (d_c2h_dsc_byp_ready_14   ),
    .d_c2h_dsc_byp_load    (d_c2h_dsc_byp_load_14    ),
    .d_c2h_dsc_byp_src_addr(d_c2h_dsc_byp_src_addr_14),
    .d_c2h_dsc_byp_dst_addr(d_c2h_dsc_byp_dst_addr_14),
    .d_c2h_dsc_byp_len     (d_c2h_dsc_byp_len_14     ),
    .d_c2h_dsc_byp_ctl     (d_c2h_dsc_byp_ctl_14     ),
    .d_h2c_dsc_byp_ready   (d_h2c_dsc_byp_ready_14   ),
    .d_h2c_dsc_byp_load    (d_h2c_dsc_byp_load_14    ),
    .d_h2c_dsc_byp_src_addr(d_h2c_dsc_byp_src_addr_14),
    .d_h2c_dsc_byp_dst_addr(d_h2c_dsc_byp_dst_addr_14),
    .d_h2c_dsc_byp_len     (d_h2c_dsc_byp_len_14     ),
    .d_h2c_dsc_byp_ctl     (d_h2c_dsc_byp_ctl_14     ),
    .q_axis_h2c_tready     (q_axis_h2c_tready_14     ),
    .q_axis_h2c_tvalid     (q_axis_h2c_tvalid_14     ),
    .q_axis_h2c_tdata      (q_axis_h2c_tdata_14      ),
    .q_axis_h2c_tkeep      (q_axis_h2c_tkeep_14      ),
    .q_axis_h2c_tlast      (q_axis_h2c_tlast_14      ),
    .q_axis_c2h_tready     (q_axis_c2h_tready_14     ),
    .q_axis_c2h_tvalid     (q_axis_c2h_tvalid_14     ),
    .q_axis_c2h_tdata      (q_axis_c2h_tdata_14      ),
    .q_axis_c2h_tkeep      (q_axis_c2h_tkeep_14      ),
    .q_axis_c2h_tlast      (q_axis_c2h_tlast_14      ),
    .d_axis_h2c_tready     (d_axis_h2c_tready_14     ),
    .d_axis_h2c_tvalid     (d_axis_h2c_tvalid_14     ),
    .d_axis_h2c_tdata      (d_axis_h2c_tdata_14      ),
    .d_axis_h2c_tkeep      (d_axis_h2c_tkeep_14      ),
    .d_axis_h2c_tlast      (d_axis_h2c_tlast_14      ),
    .d_axis_c2h_tready     (d_axis_c2h_tready_14     ),
    .d_axis_c2h_tvalid     (d_axis_c2h_tvalid_14     ),
    .d_axis_c2h_tdata      (d_axis_c2h_tdata_14      ),
    .d_axis_c2h_tkeep      (d_axis_c2h_tkeep_14      ),
    .d_axis_c2h_tlast      (d_axis_c2h_tlast_14      ),
    .usr_irq_enable        (irq_enable[13]           ),
    .usr_irq_req           (irq_req[13]              ),
    .usr_irq_ack           (irq_ack[13]              ) 
);


nvme_io_ctl_top nvme_io_ctl_top_15(
    .clk                   (user_clk                ), 
    .rst_n                 (user_resetn             ), 
    .sq_id                 (sq_id_15                 ), 
    .sq_base_addr          (sq_base_addr_15          ),  
    .sq_size               (sq_size_15               ),  
    .sq_tail               (sq_tail_15[15:0]         ),  
    .cq_base_addr          (cq_base_addr_15          ),  
    .cq_size               (cq_size_15               ),  
    .cq_head               (cq_head_15[15:0]         ), 
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ), 
    .q_c2h_dsc_byp_ready   (q_c2h_dsc_byp_ready_15   ),
    .q_c2h_dsc_byp_load    (q_c2h_dsc_byp_load_15    ),
    .q_c2h_dsc_byp_src_addr(q_c2h_dsc_byp_src_addr_15),
    .q_c2h_dsc_byp_dst_addr(q_c2h_dsc_byp_dst_addr_15),
    .q_c2h_dsc_byp_len     (q_c2h_dsc_byp_len_15     ),
    .q_c2h_dsc_byp_ctl     (q_c2h_dsc_byp_ctl_15     ),
    .q_h2c_dsc_byp_ready   (q_h2c_dsc_byp_ready_15   ),
    .q_h2c_dsc_byp_load    (q_h2c_dsc_byp_load_15    ),
    .q_h2c_dsc_byp_src_addr(q_h2c_dsc_byp_src_addr_15),
    .q_h2c_dsc_byp_dst_addr(q_h2c_dsc_byp_dst_addr_15),
    .q_h2c_dsc_byp_len     (q_h2c_dsc_byp_len_15     ),
    .q_h2c_dsc_byp_ctl     (q_h2c_dsc_byp_ctl_15     ),
    .d_c2h_dsc_byp_ready   (d_c2h_dsc_byp_ready_15   ),
    .d_c2h_dsc_byp_load    (d_c2h_dsc_byp_load_15    ),
    .d_c2h_dsc_byp_src_addr(d_c2h_dsc_byp_src_addr_15),
    .d_c2h_dsc_byp_dst_addr(d_c2h_dsc_byp_dst_addr_15),
    .d_c2h_dsc_byp_len     (d_c2h_dsc_byp_len_15     ),
    .d_c2h_dsc_byp_ctl     (d_c2h_dsc_byp_ctl_15     ),
    .d_h2c_dsc_byp_ready   (d_h2c_dsc_byp_ready_15   ),
    .d_h2c_dsc_byp_load    (d_h2c_dsc_byp_load_15    ),
    .d_h2c_dsc_byp_src_addr(d_h2c_dsc_byp_src_addr_15),
    .d_h2c_dsc_byp_dst_addr(d_h2c_dsc_byp_dst_addr_15),
    .d_h2c_dsc_byp_len     (d_h2c_dsc_byp_len_15     ),
    .d_h2c_dsc_byp_ctl     (d_h2c_dsc_byp_ctl_15     ),
    .q_axis_h2c_tready     (q_axis_h2c_tready_15     ),
    .q_axis_h2c_tvalid     (q_axis_h2c_tvalid_15     ),
    .q_axis_h2c_tdata      (q_axis_h2c_tdata_15      ),
    .q_axis_h2c_tkeep      (q_axis_h2c_tkeep_15      ),
    .q_axis_h2c_tlast      (q_axis_h2c_tlast_15      ),
    .q_axis_c2h_tready     (q_axis_c2h_tready_15     ),
    .q_axis_c2h_tvalid     (q_axis_c2h_tvalid_15     ),
    .q_axis_c2h_tdata      (q_axis_c2h_tdata_15      ),
    .q_axis_c2h_tkeep      (q_axis_c2h_tkeep_15      ),
    .q_axis_c2h_tlast      (q_axis_c2h_tlast_15      ),
    .d_axis_h2c_tready     (d_axis_h2c_tready_15     ),
    .d_axis_h2c_tvalid     (d_axis_h2c_tvalid_15     ),
    .d_axis_h2c_tdata      (d_axis_h2c_tdata_15      ),
    .d_axis_h2c_tkeep      (d_axis_h2c_tkeep_15      ),
    .d_axis_h2c_tlast      (d_axis_h2c_tlast_15      ),
    .d_axis_c2h_tready     (d_axis_c2h_tready_15     ),
    .d_axis_c2h_tvalid     (d_axis_c2h_tvalid_15     ),
    .d_axis_c2h_tdata      (d_axis_c2h_tdata_15      ),
    .d_axis_c2h_tkeep      (d_axis_c2h_tkeep_15      ),
    .d_axis_c2h_tlast      (d_axis_c2h_tlast_15      ),
    .usr_irq_enable        (irq_enable[14]           ),
    .usr_irq_req           (irq_req[14]              ),
    .usr_irq_ack           (irq_ack[14]              ) 
);


nvme_io_ctl_top nvme_io_ctl_top_16(
    .clk                   (user_clk                ), 
    .rst_n                 (user_resetn             ), 
    .sq_id                 (sq_id_16                 ), 
    .sq_base_addr          (sq_base_addr_16          ),  
    .sq_size               (sq_size_16               ),  
    .sq_tail               (sq_tail_16[15:0]         ),  
    .cq_base_addr          (cq_base_addr_16          ),  
    .cq_size               (cq_size_16               ),  
    .cq_head               (cq_head_16[15:0]         ),  
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ),
    .q_c2h_dsc_byp_ready   (q_c2h_dsc_byp_ready_16   ),
    .q_c2h_dsc_byp_load    (q_c2h_dsc_byp_load_16    ),
    .q_c2h_dsc_byp_src_addr(q_c2h_dsc_byp_src_addr_16),
    .q_c2h_dsc_byp_dst_addr(q_c2h_dsc_byp_dst_addr_16),
    .q_c2h_dsc_byp_len     (q_c2h_dsc_byp_len_16     ),
    .q_c2h_dsc_byp_ctl     (q_c2h_dsc_byp_ctl_16     ),
    .q_h2c_dsc_byp_ready   (q_h2c_dsc_byp_ready_16   ),
    .q_h2c_dsc_byp_load    (q_h2c_dsc_byp_load_16    ),
    .q_h2c_dsc_byp_src_addr(q_h2c_dsc_byp_src_addr_16),
    .q_h2c_dsc_byp_dst_addr(q_h2c_dsc_byp_dst_addr_16),
    .q_h2c_dsc_byp_len     (q_h2c_dsc_byp_len_16     ),
    .q_h2c_dsc_byp_ctl     (q_h2c_dsc_byp_ctl_16     ),
    .d_c2h_dsc_byp_ready   (d_c2h_dsc_byp_ready_16   ),
    .d_c2h_dsc_byp_load    (d_c2h_dsc_byp_load_16    ),
    .d_c2h_dsc_byp_src_addr(d_c2h_dsc_byp_src_addr_16),
    .d_c2h_dsc_byp_dst_addr(d_c2h_dsc_byp_dst_addr_16),
    .d_c2h_dsc_byp_len     (d_c2h_dsc_byp_len_16     ),
    .d_c2h_dsc_byp_ctl     (d_c2h_dsc_byp_ctl_16     ),
    .d_h2c_dsc_byp_ready   (d_h2c_dsc_byp_ready_16   ),
    .d_h2c_dsc_byp_load    (d_h2c_dsc_byp_load_16    ),
    .d_h2c_dsc_byp_src_addr(d_h2c_dsc_byp_src_addr_16),
    .d_h2c_dsc_byp_dst_addr(d_h2c_dsc_byp_dst_addr_16),
    .d_h2c_dsc_byp_len     (d_h2c_dsc_byp_len_16     ),
    .d_h2c_dsc_byp_ctl     (d_h2c_dsc_byp_ctl_16     ),
    .q_axis_h2c_tready     (q_axis_h2c_tready_16     ),
    .q_axis_h2c_tvalid     (q_axis_h2c_tvalid_16     ),
    .q_axis_h2c_tdata      (q_axis_h2c_tdata_16      ),
    .q_axis_h2c_tkeep      (q_axis_h2c_tkeep_16      ),
    .q_axis_h2c_tlast      (q_axis_h2c_tlast_16      ),
    .q_axis_c2h_tready     (q_axis_c2h_tready_16     ),
    .q_axis_c2h_tvalid     (q_axis_c2h_tvalid_16     ),
    .q_axis_c2h_tdata      (q_axis_c2h_tdata_16      ),
    .q_axis_c2h_tkeep      (q_axis_c2h_tkeep_16      ),
    .q_axis_c2h_tlast      (q_axis_c2h_tlast_16      ),
    .d_axis_h2c_tready     (d_axis_h2c_tready_16     ),
    .d_axis_h2c_tvalid     (d_axis_h2c_tvalid_16     ),
    .d_axis_h2c_tdata      (d_axis_h2c_tdata_16      ),
    .d_axis_h2c_tkeep      (d_axis_h2c_tkeep_16      ),
    .d_axis_h2c_tlast      (d_axis_h2c_tlast_16      ),
    .d_axis_c2h_tready     (d_axis_c2h_tready_16     ),
    .d_axis_c2h_tvalid     (d_axis_c2h_tvalid_16     ),
    .d_axis_c2h_tdata      (d_axis_c2h_tdata_16      ),
    .d_axis_c2h_tkeep      (d_axis_c2h_tkeep_16      ),
    .d_axis_c2h_tlast      (d_axis_c2h_tlast_16      ),
    .usr_irq_enable        (irq_enable[15]           ),
    .usr_irq_req           (irq_req[15]              ),
    .usr_irq_ack           (irq_ack[15]              ) 
);
`endif
`endif



endmodule
