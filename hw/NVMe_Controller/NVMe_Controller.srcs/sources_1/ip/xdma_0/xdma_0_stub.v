// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Tue Dec 15 10:23:36 2020
// Host        : yhqiu running 64-bit CentOS Linux release 7.8.2003 (Core)
// Command     : write_verilog -force -mode synth_stub -rename_top xdma_0 -prefix
//               xdma_0_ xdma_0_stub.v
// Design      : xdma_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku040-ffva1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "xdma_0_core_top,Vivado 2019.2" *)
module xdma_0(sys_clk, sys_clk_gt, sys_rst_n, 
  dma_bridge_resetn, user_lnk_up, pci_exp_txp, pci_exp_txn, pci_exp_rxp, pci_exp_rxn, axi_aclk, 
  axi_aresetn, usr_irq_req, usr_irq_ack, msi_enable, msix_enable, msi_vector_width, 
  m_axil_awaddr, m_axil_awprot, m_axil_awvalid, m_axil_awready, m_axil_wdata, m_axil_wstrb, 
  m_axil_wvalid, m_axil_wready, m_axil_bvalid, m_axil_bresp, m_axil_bready, m_axil_araddr, 
  m_axil_arprot, m_axil_arvalid, m_axil_arready, m_axil_rdata, m_axil_rresp, m_axil_rvalid, 
  m_axil_rready, common_commands_in, pipe_rx_0_sigs, pipe_rx_1_sigs, pipe_rx_2_sigs, 
  pipe_rx_3_sigs, pipe_rx_4_sigs, pipe_rx_5_sigs, pipe_rx_6_sigs, pipe_rx_7_sigs, 
  common_commands_out, pipe_tx_0_sigs, pipe_tx_1_sigs, pipe_tx_2_sigs, pipe_tx_3_sigs, 
  pipe_tx_4_sigs, pipe_tx_5_sigs, pipe_tx_6_sigs, pipe_tx_7_sigs, s_axis_c2h_tdata_0, 
  s_axis_c2h_tlast_0, s_axis_c2h_tvalid_0, s_axis_c2h_tready_0, s_axis_c2h_tkeep_0, 
  m_axis_h2c_tdata_0, m_axis_h2c_tlast_0, m_axis_h2c_tvalid_0, m_axis_h2c_tready_0, 
  m_axis_h2c_tkeep_0, s_axis_c2h_tdata_1, s_axis_c2h_tlast_1, s_axis_c2h_tvalid_1, 
  s_axis_c2h_tready_1, s_axis_c2h_tkeep_1, m_axis_h2c_tdata_1, m_axis_h2c_tlast_1, 
  m_axis_h2c_tvalid_1, m_axis_h2c_tready_1, m_axis_h2c_tkeep_1, s_axis_c2h_tdata_2, 
  s_axis_c2h_tlast_2, s_axis_c2h_tvalid_2, s_axis_c2h_tready_2, s_axis_c2h_tkeep_2, 
  m_axis_h2c_tdata_2, m_axis_h2c_tlast_2, m_axis_h2c_tvalid_2, m_axis_h2c_tready_2, 
  m_axis_h2c_tkeep_2, s_axis_c2h_tdata_3, s_axis_c2h_tlast_3, s_axis_c2h_tvalid_3, 
  s_axis_c2h_tready_3, s_axis_c2h_tkeep_3, m_axis_h2c_tdata_3, m_axis_h2c_tlast_3, 
  m_axis_h2c_tvalid_3, m_axis_h2c_tready_3, m_axis_h2c_tkeep_3, s_axil_awaddr, 
  s_axil_awprot, s_axil_awvalid, s_axil_awready, s_axil_wdata, s_axil_wstrb, s_axil_wvalid, 
  s_axil_wready, s_axil_bvalid, s_axil_bresp, s_axil_bready, s_axil_araddr, s_axil_arprot, 
  s_axil_arvalid, s_axil_arready, s_axil_rdata, s_axil_rresp, s_axil_rvalid, s_axil_rready, 
  c2h_dsc_byp_ready_0, c2h_dsc_byp_src_addr_0, c2h_dsc_byp_dst_addr_0, c2h_dsc_byp_len_0, 
  c2h_dsc_byp_ctl_0, c2h_dsc_byp_load_0, c2h_dsc_byp_ready_1, c2h_dsc_byp_src_addr_1, 
  c2h_dsc_byp_dst_addr_1, c2h_dsc_byp_len_1, c2h_dsc_byp_ctl_1, c2h_dsc_byp_load_1, 
  c2h_dsc_byp_ready_2, c2h_dsc_byp_src_addr_2, c2h_dsc_byp_dst_addr_2, c2h_dsc_byp_len_2, 
  c2h_dsc_byp_ctl_2, c2h_dsc_byp_load_2, c2h_dsc_byp_ready_3, c2h_dsc_byp_src_addr_3, 
  c2h_dsc_byp_dst_addr_3, c2h_dsc_byp_len_3, c2h_dsc_byp_ctl_3, c2h_dsc_byp_load_3, 
  h2c_dsc_byp_ready_0, h2c_dsc_byp_src_addr_0, h2c_dsc_byp_dst_addr_0, h2c_dsc_byp_len_0, 
  h2c_dsc_byp_ctl_0, h2c_dsc_byp_load_0, h2c_dsc_byp_ready_1, h2c_dsc_byp_src_addr_1, 
  h2c_dsc_byp_dst_addr_1, h2c_dsc_byp_len_1, h2c_dsc_byp_ctl_1, h2c_dsc_byp_load_1, 
  h2c_dsc_byp_ready_2, h2c_dsc_byp_src_addr_2, h2c_dsc_byp_dst_addr_2, h2c_dsc_byp_len_2, 
  h2c_dsc_byp_ctl_2, h2c_dsc_byp_load_2, h2c_dsc_byp_ready_3, h2c_dsc_byp_src_addr_3, 
  h2c_dsc_byp_dst_addr_3, h2c_dsc_byp_len_3, h2c_dsc_byp_ctl_3, h2c_dsc_byp_load_3, 
  int_qpll1lock_out, int_qpll1outrefclk_out, int_qpll1outclk_out)
/* synthesis syn_black_box black_box_pad_pin="sys_clk,sys_clk_gt,sys_rst_n,dma_bridge_resetn,user_lnk_up,pci_exp_txp[7:0],pci_exp_txn[7:0],pci_exp_rxp[7:0],pci_exp_rxn[7:0],axi_aclk,axi_aresetn,usr_irq_req[15:0],usr_irq_ack[15:0],msi_enable,msix_enable,msi_vector_width[2:0],m_axil_awaddr[31:0],m_axil_awprot[2:0],m_axil_awvalid,m_axil_awready,m_axil_wdata[31:0],m_axil_wstrb[3:0],m_axil_wvalid,m_axil_wready,m_axil_bvalid,m_axil_bresp[1:0],m_axil_bready,m_axil_araddr[31:0],m_axil_arprot[2:0],m_axil_arvalid,m_axil_arready,m_axil_rdata[31:0],m_axil_rresp[1:0],m_axil_rvalid,m_axil_rready,common_commands_in[25:0],pipe_rx_0_sigs[83:0],pipe_rx_1_sigs[83:0],pipe_rx_2_sigs[83:0],pipe_rx_3_sigs[83:0],pipe_rx_4_sigs[83:0],pipe_rx_5_sigs[83:0],pipe_rx_6_sigs[83:0],pipe_rx_7_sigs[83:0],common_commands_out[25:0],pipe_tx_0_sigs[83:0],pipe_tx_1_sigs[83:0],pipe_tx_2_sigs[83:0],pipe_tx_3_sigs[83:0],pipe_tx_4_sigs[83:0],pipe_tx_5_sigs[83:0],pipe_tx_6_sigs[83:0],pipe_tx_7_sigs[83:0],s_axis_c2h_tdata_0[255:0],s_axis_c2h_tlast_0,s_axis_c2h_tvalid_0,s_axis_c2h_tready_0,s_axis_c2h_tkeep_0[31:0],m_axis_h2c_tdata_0[255:0],m_axis_h2c_tlast_0,m_axis_h2c_tvalid_0,m_axis_h2c_tready_0,m_axis_h2c_tkeep_0[31:0],s_axis_c2h_tdata_1[255:0],s_axis_c2h_tlast_1,s_axis_c2h_tvalid_1,s_axis_c2h_tready_1,s_axis_c2h_tkeep_1[31:0],m_axis_h2c_tdata_1[255:0],m_axis_h2c_tlast_1,m_axis_h2c_tvalid_1,m_axis_h2c_tready_1,m_axis_h2c_tkeep_1[31:0],s_axis_c2h_tdata_2[255:0],s_axis_c2h_tlast_2,s_axis_c2h_tvalid_2,s_axis_c2h_tready_2,s_axis_c2h_tkeep_2[31:0],m_axis_h2c_tdata_2[255:0],m_axis_h2c_tlast_2,m_axis_h2c_tvalid_2,m_axis_h2c_tready_2,m_axis_h2c_tkeep_2[31:0],s_axis_c2h_tdata_3[255:0],s_axis_c2h_tlast_3,s_axis_c2h_tvalid_3,s_axis_c2h_tready_3,s_axis_c2h_tkeep_3[31:0],m_axis_h2c_tdata_3[255:0],m_axis_h2c_tlast_3,m_axis_h2c_tvalid_3,m_axis_h2c_tready_3,m_axis_h2c_tkeep_3[31:0],s_axil_awaddr[31:0],s_axil_awprot[2:0],s_axil_awvalid,s_axil_awready,s_axil_wdata[31:0],s_axil_wstrb[3:0],s_axil_wvalid,s_axil_wready,s_axil_bvalid,s_axil_bresp[1:0],s_axil_bready,s_axil_araddr[31:0],s_axil_arprot[2:0],s_axil_arvalid,s_axil_arready,s_axil_rdata[31:0],s_axil_rresp[1:0],s_axil_rvalid,s_axil_rready,c2h_dsc_byp_ready_0,c2h_dsc_byp_src_addr_0[63:0],c2h_dsc_byp_dst_addr_0[63:0],c2h_dsc_byp_len_0[27:0],c2h_dsc_byp_ctl_0[15:0],c2h_dsc_byp_load_0,c2h_dsc_byp_ready_1,c2h_dsc_byp_src_addr_1[63:0],c2h_dsc_byp_dst_addr_1[63:0],c2h_dsc_byp_len_1[27:0],c2h_dsc_byp_ctl_1[15:0],c2h_dsc_byp_load_1,c2h_dsc_byp_ready_2,c2h_dsc_byp_src_addr_2[63:0],c2h_dsc_byp_dst_addr_2[63:0],c2h_dsc_byp_len_2[27:0],c2h_dsc_byp_ctl_2[15:0],c2h_dsc_byp_load_2,c2h_dsc_byp_ready_3,c2h_dsc_byp_src_addr_3[63:0],c2h_dsc_byp_dst_addr_3[63:0],c2h_dsc_byp_len_3[27:0],c2h_dsc_byp_ctl_3[15:0],c2h_dsc_byp_load_3,h2c_dsc_byp_ready_0,h2c_dsc_byp_src_addr_0[63:0],h2c_dsc_byp_dst_addr_0[63:0],h2c_dsc_byp_len_0[27:0],h2c_dsc_byp_ctl_0[15:0],h2c_dsc_byp_load_0,h2c_dsc_byp_ready_1,h2c_dsc_byp_src_addr_1[63:0],h2c_dsc_byp_dst_addr_1[63:0],h2c_dsc_byp_len_1[27:0],h2c_dsc_byp_ctl_1[15:0],h2c_dsc_byp_load_1,h2c_dsc_byp_ready_2,h2c_dsc_byp_src_addr_2[63:0],h2c_dsc_byp_dst_addr_2[63:0],h2c_dsc_byp_len_2[27:0],h2c_dsc_byp_ctl_2[15:0],h2c_dsc_byp_load_2,h2c_dsc_byp_ready_3,h2c_dsc_byp_src_addr_3[63:0],h2c_dsc_byp_dst_addr_3[63:0],h2c_dsc_byp_len_3[27:0],h2c_dsc_byp_ctl_3[15:0],h2c_dsc_byp_load_3,int_qpll1lock_out[1:0],int_qpll1outrefclk_out[1:0],int_qpll1outclk_out[1:0]" */;
  input sys_clk;
  input sys_clk_gt;
  input sys_rst_n;
  input dma_bridge_resetn;
  output user_lnk_up;
  output [7:0]pci_exp_txp;
  output [7:0]pci_exp_txn;
  input [7:0]pci_exp_rxp;
  input [7:0]pci_exp_rxn;
  output axi_aclk;
  output axi_aresetn;
  input [15:0]usr_irq_req;
  output [15:0]usr_irq_ack;
  output msi_enable;
  output msix_enable;
  output [2:0]msi_vector_width;
  output [31:0]m_axil_awaddr;
  output [2:0]m_axil_awprot;
  output m_axil_awvalid;
  input m_axil_awready;
  output [31:0]m_axil_wdata;
  output [3:0]m_axil_wstrb;
  output m_axil_wvalid;
  input m_axil_wready;
  input m_axil_bvalid;
  input [1:0]m_axil_bresp;
  output m_axil_bready;
  output [31:0]m_axil_araddr;
  output [2:0]m_axil_arprot;
  output m_axil_arvalid;
  input m_axil_arready;
  input [31:0]m_axil_rdata;
  input [1:0]m_axil_rresp;
  input m_axil_rvalid;
  output m_axil_rready;
  input [25:0]common_commands_in;
  input [83:0]pipe_rx_0_sigs;
  input [83:0]pipe_rx_1_sigs;
  input [83:0]pipe_rx_2_sigs;
  input [83:0]pipe_rx_3_sigs;
  input [83:0]pipe_rx_4_sigs;
  input [83:0]pipe_rx_5_sigs;
  input [83:0]pipe_rx_6_sigs;
  input [83:0]pipe_rx_7_sigs;
  output [25:0]common_commands_out;
  output [83:0]pipe_tx_0_sigs;
  output [83:0]pipe_tx_1_sigs;
  output [83:0]pipe_tx_2_sigs;
  output [83:0]pipe_tx_3_sigs;
  output [83:0]pipe_tx_4_sigs;
  output [83:0]pipe_tx_5_sigs;
  output [83:0]pipe_tx_6_sigs;
  output [83:0]pipe_tx_7_sigs;
  input [255:0]s_axis_c2h_tdata_0;
  input s_axis_c2h_tlast_0;
  input s_axis_c2h_tvalid_0;
  output s_axis_c2h_tready_0;
  input [31:0]s_axis_c2h_tkeep_0;
  output [255:0]m_axis_h2c_tdata_0;
  output m_axis_h2c_tlast_0;
  output m_axis_h2c_tvalid_0;
  input m_axis_h2c_tready_0;
  output [31:0]m_axis_h2c_tkeep_0;
  input [255:0]s_axis_c2h_tdata_1;
  input s_axis_c2h_tlast_1;
  input s_axis_c2h_tvalid_1;
  output s_axis_c2h_tready_1;
  input [31:0]s_axis_c2h_tkeep_1;
  output [255:0]m_axis_h2c_tdata_1;
  output m_axis_h2c_tlast_1;
  output m_axis_h2c_tvalid_1;
  input m_axis_h2c_tready_1;
  output [31:0]m_axis_h2c_tkeep_1;
  input [255:0]s_axis_c2h_tdata_2;
  input s_axis_c2h_tlast_2;
  input s_axis_c2h_tvalid_2;
  output s_axis_c2h_tready_2;
  input [31:0]s_axis_c2h_tkeep_2;
  output [255:0]m_axis_h2c_tdata_2;
  output m_axis_h2c_tlast_2;
  output m_axis_h2c_tvalid_2;
  input m_axis_h2c_tready_2;
  output [31:0]m_axis_h2c_tkeep_2;
  input [255:0]s_axis_c2h_tdata_3;
  input s_axis_c2h_tlast_3;
  input s_axis_c2h_tvalid_3;
  output s_axis_c2h_tready_3;
  input [31:0]s_axis_c2h_tkeep_3;
  output [255:0]m_axis_h2c_tdata_3;
  output m_axis_h2c_tlast_3;
  output m_axis_h2c_tvalid_3;
  input m_axis_h2c_tready_3;
  output [31:0]m_axis_h2c_tkeep_3;
  input [31:0]s_axil_awaddr;
  input [2:0]s_axil_awprot;
  input s_axil_awvalid;
  output s_axil_awready;
  input [31:0]s_axil_wdata;
  input [3:0]s_axil_wstrb;
  input s_axil_wvalid;
  output s_axil_wready;
  output s_axil_bvalid;
  output [1:0]s_axil_bresp;
  input s_axil_bready;
  input [31:0]s_axil_araddr;
  input [2:0]s_axil_arprot;
  input s_axil_arvalid;
  output s_axil_arready;
  output [31:0]s_axil_rdata;
  output [1:0]s_axil_rresp;
  output s_axil_rvalid;
  input s_axil_rready;
  output c2h_dsc_byp_ready_0;
  input [63:0]c2h_dsc_byp_src_addr_0;
  input [63:0]c2h_dsc_byp_dst_addr_0;
  input [27:0]c2h_dsc_byp_len_0;
  input [15:0]c2h_dsc_byp_ctl_0;
  input c2h_dsc_byp_load_0;
  output c2h_dsc_byp_ready_1;
  input [63:0]c2h_dsc_byp_src_addr_1;
  input [63:0]c2h_dsc_byp_dst_addr_1;
  input [27:0]c2h_dsc_byp_len_1;
  input [15:0]c2h_dsc_byp_ctl_1;
  input c2h_dsc_byp_load_1;
  output c2h_dsc_byp_ready_2;
  input [63:0]c2h_dsc_byp_src_addr_2;
  input [63:0]c2h_dsc_byp_dst_addr_2;
  input [27:0]c2h_dsc_byp_len_2;
  input [15:0]c2h_dsc_byp_ctl_2;
  input c2h_dsc_byp_load_2;
  output c2h_dsc_byp_ready_3;
  input [63:0]c2h_dsc_byp_src_addr_3;
  input [63:0]c2h_dsc_byp_dst_addr_3;
  input [27:0]c2h_dsc_byp_len_3;
  input [15:0]c2h_dsc_byp_ctl_3;
  input c2h_dsc_byp_load_3;
  output h2c_dsc_byp_ready_0;
  input [63:0]h2c_dsc_byp_src_addr_0;
  input [63:0]h2c_dsc_byp_dst_addr_0;
  input [27:0]h2c_dsc_byp_len_0;
  input [15:0]h2c_dsc_byp_ctl_0;
  input h2c_dsc_byp_load_0;
  output h2c_dsc_byp_ready_1;
  input [63:0]h2c_dsc_byp_src_addr_1;
  input [63:0]h2c_dsc_byp_dst_addr_1;
  input [27:0]h2c_dsc_byp_len_1;
  input [15:0]h2c_dsc_byp_ctl_1;
  input h2c_dsc_byp_load_1;
  output h2c_dsc_byp_ready_2;
  input [63:0]h2c_dsc_byp_src_addr_2;
  input [63:0]h2c_dsc_byp_dst_addr_2;
  input [27:0]h2c_dsc_byp_len_2;
  input [15:0]h2c_dsc_byp_ctl_2;
  input h2c_dsc_byp_load_2;
  output h2c_dsc_byp_ready_3;
  input [63:0]h2c_dsc_byp_src_addr_3;
  input [63:0]h2c_dsc_byp_dst_addr_3;
  input [27:0]h2c_dsc_byp_len_3;
  input [15:0]h2c_dsc_byp_ctl_3;
  input h2c_dsc_byp_load_3;
  output [1:0]int_qpll1lock_out;
  output [1:0]int_qpll1outrefclk_out;
  output [1:0]int_qpll1outclk_out;
endmodule
