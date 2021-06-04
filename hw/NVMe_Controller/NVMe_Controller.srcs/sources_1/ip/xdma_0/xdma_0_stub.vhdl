-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
-- Date        : Tue Dec 15 10:23:36 2020
-- Host        : yhqiu running 64-bit CentOS Linux release 7.8.2003 (Core)
-- Command     : write_vhdl -force -mode synth_stub -rename_top xdma_0 -prefix
--               xdma_0_ xdma_0_stub.vhdl
-- Design      : xdma_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xcku040-ffva1156-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xdma_0 is
  Port ( 
    sys_clk : in STD_LOGIC;
    sys_clk_gt : in STD_LOGIC;
    sys_rst_n : in STD_LOGIC;
    dma_bridge_resetn : in STD_LOGIC;
    user_lnk_up : out STD_LOGIC;
    pci_exp_txp : out STD_LOGIC_VECTOR ( 7 downto 0 );
    pci_exp_txn : out STD_LOGIC_VECTOR ( 7 downto 0 );
    pci_exp_rxp : in STD_LOGIC_VECTOR ( 7 downto 0 );
    pci_exp_rxn : in STD_LOGIC_VECTOR ( 7 downto 0 );
    axi_aclk : out STD_LOGIC;
    axi_aresetn : out STD_LOGIC;
    usr_irq_req : in STD_LOGIC_VECTOR ( 15 downto 0 );
    usr_irq_ack : out STD_LOGIC_VECTOR ( 15 downto 0 );
    msi_enable : out STD_LOGIC;
    msix_enable : out STD_LOGIC;
    msi_vector_width : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axil_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axil_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axil_awvalid : out STD_LOGIC;
    m_axil_awready : in STD_LOGIC;
    m_axil_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axil_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axil_wvalid : out STD_LOGIC;
    m_axil_wready : in STD_LOGIC;
    m_axil_bvalid : in STD_LOGIC;
    m_axil_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axil_bready : out STD_LOGIC;
    m_axil_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axil_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axil_arvalid : out STD_LOGIC;
    m_axil_arready : in STD_LOGIC;
    m_axil_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axil_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axil_rvalid : in STD_LOGIC;
    m_axil_rready : out STD_LOGIC;
    common_commands_in : in STD_LOGIC_VECTOR ( 25 downto 0 );
    pipe_rx_0_sigs : in STD_LOGIC_VECTOR ( 83 downto 0 );
    pipe_rx_1_sigs : in STD_LOGIC_VECTOR ( 83 downto 0 );
    pipe_rx_2_sigs : in STD_LOGIC_VECTOR ( 83 downto 0 );
    pipe_rx_3_sigs : in STD_LOGIC_VECTOR ( 83 downto 0 );
    pipe_rx_4_sigs : in STD_LOGIC_VECTOR ( 83 downto 0 );
    pipe_rx_5_sigs : in STD_LOGIC_VECTOR ( 83 downto 0 );
    pipe_rx_6_sigs : in STD_LOGIC_VECTOR ( 83 downto 0 );
    pipe_rx_7_sigs : in STD_LOGIC_VECTOR ( 83 downto 0 );
    common_commands_out : out STD_LOGIC_VECTOR ( 25 downto 0 );
    pipe_tx_0_sigs : out STD_LOGIC_VECTOR ( 83 downto 0 );
    pipe_tx_1_sigs : out STD_LOGIC_VECTOR ( 83 downto 0 );
    pipe_tx_2_sigs : out STD_LOGIC_VECTOR ( 83 downto 0 );
    pipe_tx_3_sigs : out STD_LOGIC_VECTOR ( 83 downto 0 );
    pipe_tx_4_sigs : out STD_LOGIC_VECTOR ( 83 downto 0 );
    pipe_tx_5_sigs : out STD_LOGIC_VECTOR ( 83 downto 0 );
    pipe_tx_6_sigs : out STD_LOGIC_VECTOR ( 83 downto 0 );
    pipe_tx_7_sigs : out STD_LOGIC_VECTOR ( 83 downto 0 );
    s_axis_c2h_tdata_0 : in STD_LOGIC_VECTOR ( 255 downto 0 );
    s_axis_c2h_tlast_0 : in STD_LOGIC;
    s_axis_c2h_tvalid_0 : in STD_LOGIC;
    s_axis_c2h_tready_0 : out STD_LOGIC;
    s_axis_c2h_tkeep_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_h2c_tdata_0 : out STD_LOGIC_VECTOR ( 255 downto 0 );
    m_axis_h2c_tlast_0 : out STD_LOGIC;
    m_axis_h2c_tvalid_0 : out STD_LOGIC;
    m_axis_h2c_tready_0 : in STD_LOGIC;
    m_axis_h2c_tkeep_0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axis_c2h_tdata_1 : in STD_LOGIC_VECTOR ( 255 downto 0 );
    s_axis_c2h_tlast_1 : in STD_LOGIC;
    s_axis_c2h_tvalid_1 : in STD_LOGIC;
    s_axis_c2h_tready_1 : out STD_LOGIC;
    s_axis_c2h_tkeep_1 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_h2c_tdata_1 : out STD_LOGIC_VECTOR ( 255 downto 0 );
    m_axis_h2c_tlast_1 : out STD_LOGIC;
    m_axis_h2c_tvalid_1 : out STD_LOGIC;
    m_axis_h2c_tready_1 : in STD_LOGIC;
    m_axis_h2c_tkeep_1 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axis_c2h_tdata_2 : in STD_LOGIC_VECTOR ( 255 downto 0 );
    s_axis_c2h_tlast_2 : in STD_LOGIC;
    s_axis_c2h_tvalid_2 : in STD_LOGIC;
    s_axis_c2h_tready_2 : out STD_LOGIC;
    s_axis_c2h_tkeep_2 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_h2c_tdata_2 : out STD_LOGIC_VECTOR ( 255 downto 0 );
    m_axis_h2c_tlast_2 : out STD_LOGIC;
    m_axis_h2c_tvalid_2 : out STD_LOGIC;
    m_axis_h2c_tready_2 : in STD_LOGIC;
    m_axis_h2c_tkeep_2 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axis_c2h_tdata_3 : in STD_LOGIC_VECTOR ( 255 downto 0 );
    s_axis_c2h_tlast_3 : in STD_LOGIC;
    s_axis_c2h_tvalid_3 : in STD_LOGIC;
    s_axis_c2h_tready_3 : out STD_LOGIC;
    s_axis_c2h_tkeep_3 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_h2c_tdata_3 : out STD_LOGIC_VECTOR ( 255 downto 0 );
    m_axis_h2c_tlast_3 : out STD_LOGIC;
    m_axis_h2c_tvalid_3 : out STD_LOGIC;
    m_axis_h2c_tready_3 : in STD_LOGIC;
    m_axis_h2c_tkeep_3 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axil_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axil_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axil_awvalid : in STD_LOGIC;
    s_axil_awready : out STD_LOGIC;
    s_axil_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axil_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axil_wvalid : in STD_LOGIC;
    s_axil_wready : out STD_LOGIC;
    s_axil_bvalid : out STD_LOGIC;
    s_axil_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axil_bready : in STD_LOGIC;
    s_axil_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axil_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axil_arvalid : in STD_LOGIC;
    s_axil_arready : out STD_LOGIC;
    s_axil_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axil_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axil_rvalid : out STD_LOGIC;
    s_axil_rready : in STD_LOGIC;
    c2h_dsc_byp_ready_0 : out STD_LOGIC;
    c2h_dsc_byp_src_addr_0 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    c2h_dsc_byp_dst_addr_0 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    c2h_dsc_byp_len_0 : in STD_LOGIC_VECTOR ( 27 downto 0 );
    c2h_dsc_byp_ctl_0 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    c2h_dsc_byp_load_0 : in STD_LOGIC;
    c2h_dsc_byp_ready_1 : out STD_LOGIC;
    c2h_dsc_byp_src_addr_1 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    c2h_dsc_byp_dst_addr_1 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    c2h_dsc_byp_len_1 : in STD_LOGIC_VECTOR ( 27 downto 0 );
    c2h_dsc_byp_ctl_1 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    c2h_dsc_byp_load_1 : in STD_LOGIC;
    c2h_dsc_byp_ready_2 : out STD_LOGIC;
    c2h_dsc_byp_src_addr_2 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    c2h_dsc_byp_dst_addr_2 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    c2h_dsc_byp_len_2 : in STD_LOGIC_VECTOR ( 27 downto 0 );
    c2h_dsc_byp_ctl_2 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    c2h_dsc_byp_load_2 : in STD_LOGIC;
    c2h_dsc_byp_ready_3 : out STD_LOGIC;
    c2h_dsc_byp_src_addr_3 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    c2h_dsc_byp_dst_addr_3 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    c2h_dsc_byp_len_3 : in STD_LOGIC_VECTOR ( 27 downto 0 );
    c2h_dsc_byp_ctl_3 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    c2h_dsc_byp_load_3 : in STD_LOGIC;
    h2c_dsc_byp_ready_0 : out STD_LOGIC;
    h2c_dsc_byp_src_addr_0 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    h2c_dsc_byp_dst_addr_0 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    h2c_dsc_byp_len_0 : in STD_LOGIC_VECTOR ( 27 downto 0 );
    h2c_dsc_byp_ctl_0 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    h2c_dsc_byp_load_0 : in STD_LOGIC;
    h2c_dsc_byp_ready_1 : out STD_LOGIC;
    h2c_dsc_byp_src_addr_1 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    h2c_dsc_byp_dst_addr_1 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    h2c_dsc_byp_len_1 : in STD_LOGIC_VECTOR ( 27 downto 0 );
    h2c_dsc_byp_ctl_1 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    h2c_dsc_byp_load_1 : in STD_LOGIC;
    h2c_dsc_byp_ready_2 : out STD_LOGIC;
    h2c_dsc_byp_src_addr_2 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    h2c_dsc_byp_dst_addr_2 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    h2c_dsc_byp_len_2 : in STD_LOGIC_VECTOR ( 27 downto 0 );
    h2c_dsc_byp_ctl_2 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    h2c_dsc_byp_load_2 : in STD_LOGIC;
    h2c_dsc_byp_ready_3 : out STD_LOGIC;
    h2c_dsc_byp_src_addr_3 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    h2c_dsc_byp_dst_addr_3 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    h2c_dsc_byp_len_3 : in STD_LOGIC_VECTOR ( 27 downto 0 );
    h2c_dsc_byp_ctl_3 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    h2c_dsc_byp_load_3 : in STD_LOGIC;
    int_qpll1lock_out : out STD_LOGIC_VECTOR ( 1 downto 0 );
    int_qpll1outrefclk_out : out STD_LOGIC_VECTOR ( 1 downto 0 );
    int_qpll1outclk_out : out STD_LOGIC_VECTOR ( 1 downto 0 )
  );

end xdma_0;

architecture stub of xdma_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "sys_clk,sys_clk_gt,sys_rst_n,dma_bridge_resetn,user_lnk_up,pci_exp_txp[7:0],pci_exp_txn[7:0],pci_exp_rxp[7:0],pci_exp_rxn[7:0],axi_aclk,axi_aresetn,usr_irq_req[15:0],usr_irq_ack[15:0],msi_enable,msix_enable,msi_vector_width[2:0],m_axil_awaddr[31:0],m_axil_awprot[2:0],m_axil_awvalid,m_axil_awready,m_axil_wdata[31:0],m_axil_wstrb[3:0],m_axil_wvalid,m_axil_wready,m_axil_bvalid,m_axil_bresp[1:0],m_axil_bready,m_axil_araddr[31:0],m_axil_arprot[2:0],m_axil_arvalid,m_axil_arready,m_axil_rdata[31:0],m_axil_rresp[1:0],m_axil_rvalid,m_axil_rready,common_commands_in[25:0],pipe_rx_0_sigs[83:0],pipe_rx_1_sigs[83:0],pipe_rx_2_sigs[83:0],pipe_rx_3_sigs[83:0],pipe_rx_4_sigs[83:0],pipe_rx_5_sigs[83:0],pipe_rx_6_sigs[83:0],pipe_rx_7_sigs[83:0],common_commands_out[25:0],pipe_tx_0_sigs[83:0],pipe_tx_1_sigs[83:0],pipe_tx_2_sigs[83:0],pipe_tx_3_sigs[83:0],pipe_tx_4_sigs[83:0],pipe_tx_5_sigs[83:0],pipe_tx_6_sigs[83:0],pipe_tx_7_sigs[83:0],s_axis_c2h_tdata_0[255:0],s_axis_c2h_tlast_0,s_axis_c2h_tvalid_0,s_axis_c2h_tready_0,s_axis_c2h_tkeep_0[31:0],m_axis_h2c_tdata_0[255:0],m_axis_h2c_tlast_0,m_axis_h2c_tvalid_0,m_axis_h2c_tready_0,m_axis_h2c_tkeep_0[31:0],s_axis_c2h_tdata_1[255:0],s_axis_c2h_tlast_1,s_axis_c2h_tvalid_1,s_axis_c2h_tready_1,s_axis_c2h_tkeep_1[31:0],m_axis_h2c_tdata_1[255:0],m_axis_h2c_tlast_1,m_axis_h2c_tvalid_1,m_axis_h2c_tready_1,m_axis_h2c_tkeep_1[31:0],s_axis_c2h_tdata_2[255:0],s_axis_c2h_tlast_2,s_axis_c2h_tvalid_2,s_axis_c2h_tready_2,s_axis_c2h_tkeep_2[31:0],m_axis_h2c_tdata_2[255:0],m_axis_h2c_tlast_2,m_axis_h2c_tvalid_2,m_axis_h2c_tready_2,m_axis_h2c_tkeep_2[31:0],s_axis_c2h_tdata_3[255:0],s_axis_c2h_tlast_3,s_axis_c2h_tvalid_3,s_axis_c2h_tready_3,s_axis_c2h_tkeep_3[31:0],m_axis_h2c_tdata_3[255:0],m_axis_h2c_tlast_3,m_axis_h2c_tvalid_3,m_axis_h2c_tready_3,m_axis_h2c_tkeep_3[31:0],s_axil_awaddr[31:0],s_axil_awprot[2:0],s_axil_awvalid,s_axil_awready,s_axil_wdata[31:0],s_axil_wstrb[3:0],s_axil_wvalid,s_axil_wready,s_axil_bvalid,s_axil_bresp[1:0],s_axil_bready,s_axil_araddr[31:0],s_axil_arprot[2:0],s_axil_arvalid,s_axil_arready,s_axil_rdata[31:0],s_axil_rresp[1:0],s_axil_rvalid,s_axil_rready,c2h_dsc_byp_ready_0,c2h_dsc_byp_src_addr_0[63:0],c2h_dsc_byp_dst_addr_0[63:0],c2h_dsc_byp_len_0[27:0],c2h_dsc_byp_ctl_0[15:0],c2h_dsc_byp_load_0,c2h_dsc_byp_ready_1,c2h_dsc_byp_src_addr_1[63:0],c2h_dsc_byp_dst_addr_1[63:0],c2h_dsc_byp_len_1[27:0],c2h_dsc_byp_ctl_1[15:0],c2h_dsc_byp_load_1,c2h_dsc_byp_ready_2,c2h_dsc_byp_src_addr_2[63:0],c2h_dsc_byp_dst_addr_2[63:0],c2h_dsc_byp_len_2[27:0],c2h_dsc_byp_ctl_2[15:0],c2h_dsc_byp_load_2,c2h_dsc_byp_ready_3,c2h_dsc_byp_src_addr_3[63:0],c2h_dsc_byp_dst_addr_3[63:0],c2h_dsc_byp_len_3[27:0],c2h_dsc_byp_ctl_3[15:0],c2h_dsc_byp_load_3,h2c_dsc_byp_ready_0,h2c_dsc_byp_src_addr_0[63:0],h2c_dsc_byp_dst_addr_0[63:0],h2c_dsc_byp_len_0[27:0],h2c_dsc_byp_ctl_0[15:0],h2c_dsc_byp_load_0,h2c_dsc_byp_ready_1,h2c_dsc_byp_src_addr_1[63:0],h2c_dsc_byp_dst_addr_1[63:0],h2c_dsc_byp_len_1[27:0],h2c_dsc_byp_ctl_1[15:0],h2c_dsc_byp_load_1,h2c_dsc_byp_ready_2,h2c_dsc_byp_src_addr_2[63:0],h2c_dsc_byp_dst_addr_2[63:0],h2c_dsc_byp_len_2[27:0],h2c_dsc_byp_ctl_2[15:0],h2c_dsc_byp_load_2,h2c_dsc_byp_ready_3,h2c_dsc_byp_src_addr_3[63:0],h2c_dsc_byp_dst_addr_3[63:0],h2c_dsc_byp_len_3[27:0],h2c_dsc_byp_ctl_3[15:0],h2c_dsc_byp_load_3,int_qpll1lock_out[1:0],int_qpll1outrefclk_out[1:0],int_qpll1outclk_out[1:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "xdma_0_core_top,Vivado 2019.2";
begin
end;
