-- (c) Copyright 1995-2021 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:ip:xdma:4.1
-- IP Revision: 4

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT xdma_0
  PORT (
    sys_clk : IN STD_LOGIC;
    sys_clk_gt : IN STD_LOGIC;
    sys_rst_n : IN STD_LOGIC;
    dma_bridge_resetn : IN STD_LOGIC;
    user_lnk_up : OUT STD_LOGIC;
    pci_exp_txp : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    pci_exp_txn : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    pci_exp_rxp : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    pci_exp_rxn : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    axi_aclk : OUT STD_LOGIC;
    axi_aresetn : OUT STD_LOGIC;
    usr_irq_req : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    usr_irq_ack : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    msi_enable : OUT STD_LOGIC;
    msix_enable : OUT STD_LOGIC;
    msi_vector_width : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axil_awaddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axil_awprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axil_awvalid : OUT STD_LOGIC;
    m_axil_awready : IN STD_LOGIC;
    m_axil_wdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axil_wstrb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axil_wvalid : OUT STD_LOGIC;
    m_axil_wready : IN STD_LOGIC;
    m_axil_bvalid : IN STD_LOGIC;
    m_axil_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axil_bready : OUT STD_LOGIC;
    m_axil_araddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axil_arprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axil_arvalid : OUT STD_LOGIC;
    m_axil_arready : IN STD_LOGIC;
    m_axil_rdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axil_rresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axil_rvalid : IN STD_LOGIC;
    m_axil_rready : OUT STD_LOGIC;
    common_commands_in : IN STD_LOGIC_VECTOR(25 DOWNTO 0);
    pipe_rx_0_sigs : IN STD_LOGIC_VECTOR(83 DOWNTO 0);
    pipe_rx_1_sigs : IN STD_LOGIC_VECTOR(83 DOWNTO 0);
    pipe_rx_2_sigs : IN STD_LOGIC_VECTOR(83 DOWNTO 0);
    pipe_rx_3_sigs : IN STD_LOGIC_VECTOR(83 DOWNTO 0);
    pipe_rx_4_sigs : IN STD_LOGIC_VECTOR(83 DOWNTO 0);
    pipe_rx_5_sigs : IN STD_LOGIC_VECTOR(83 DOWNTO 0);
    pipe_rx_6_sigs : IN STD_LOGIC_VECTOR(83 DOWNTO 0);
    pipe_rx_7_sigs : IN STD_LOGIC_VECTOR(83 DOWNTO 0);
    common_commands_out : OUT STD_LOGIC_VECTOR(25 DOWNTO 0);
    pipe_tx_0_sigs : OUT STD_LOGIC_VECTOR(83 DOWNTO 0);
    pipe_tx_1_sigs : OUT STD_LOGIC_VECTOR(83 DOWNTO 0);
    pipe_tx_2_sigs : OUT STD_LOGIC_VECTOR(83 DOWNTO 0);
    pipe_tx_3_sigs : OUT STD_LOGIC_VECTOR(83 DOWNTO 0);
    pipe_tx_4_sigs : OUT STD_LOGIC_VECTOR(83 DOWNTO 0);
    pipe_tx_5_sigs : OUT STD_LOGIC_VECTOR(83 DOWNTO 0);
    pipe_tx_6_sigs : OUT STD_LOGIC_VECTOR(83 DOWNTO 0);
    pipe_tx_7_sigs : OUT STD_LOGIC_VECTOR(83 DOWNTO 0);
    s_axis_c2h_tdata_0 : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
    s_axis_c2h_tlast_0 : IN STD_LOGIC;
    s_axis_c2h_tvalid_0 : IN STD_LOGIC;
    s_axis_c2h_tready_0 : OUT STD_LOGIC;
    s_axis_c2h_tkeep_0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_h2c_tdata_0 : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
    m_axis_h2c_tlast_0 : OUT STD_LOGIC;
    m_axis_h2c_tvalid_0 : OUT STD_LOGIC;
    m_axis_h2c_tready_0 : IN STD_LOGIC;
    m_axis_h2c_tkeep_0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_c2h_tdata_1 : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
    s_axis_c2h_tlast_1 : IN STD_LOGIC;
    s_axis_c2h_tvalid_1 : IN STD_LOGIC;
    s_axis_c2h_tready_1 : OUT STD_LOGIC;
    s_axis_c2h_tkeep_1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_h2c_tdata_1 : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
    m_axis_h2c_tlast_1 : OUT STD_LOGIC;
    m_axis_h2c_tvalid_1 : OUT STD_LOGIC;
    m_axis_h2c_tready_1 : IN STD_LOGIC;
    m_axis_h2c_tkeep_1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_c2h_tdata_2 : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
    s_axis_c2h_tlast_2 : IN STD_LOGIC;
    s_axis_c2h_tvalid_2 : IN STD_LOGIC;
    s_axis_c2h_tready_2 : OUT STD_LOGIC;
    s_axis_c2h_tkeep_2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_h2c_tdata_2 : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
    m_axis_h2c_tlast_2 : OUT STD_LOGIC;
    m_axis_h2c_tvalid_2 : OUT STD_LOGIC;
    m_axis_h2c_tready_2 : IN STD_LOGIC;
    m_axis_h2c_tkeep_2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_c2h_tdata_3 : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
    s_axis_c2h_tlast_3 : IN STD_LOGIC;
    s_axis_c2h_tvalid_3 : IN STD_LOGIC;
    s_axis_c2h_tready_3 : OUT STD_LOGIC;
    s_axis_c2h_tkeep_3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_h2c_tdata_3 : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
    m_axis_h2c_tlast_3 : OUT STD_LOGIC;
    m_axis_h2c_tvalid_3 : OUT STD_LOGIC;
    m_axis_h2c_tready_3 : IN STD_LOGIC;
    m_axis_h2c_tkeep_3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axil_awaddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axil_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s_axil_awvalid : IN STD_LOGIC;
    s_axil_awready : OUT STD_LOGIC;
    s_axil_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axil_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axil_wvalid : IN STD_LOGIC;
    s_axil_wready : OUT STD_LOGIC;
    s_axil_bvalid : OUT STD_LOGIC;
    s_axil_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axil_bready : IN STD_LOGIC;
    s_axil_araddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axil_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s_axil_arvalid : IN STD_LOGIC;
    s_axil_arready : OUT STD_LOGIC;
    s_axil_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axil_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axil_rvalid : OUT STD_LOGIC;
    s_axil_rready : IN STD_LOGIC;
    c2h_dsc_byp_ready_0 : OUT STD_LOGIC;
    c2h_dsc_byp_src_addr_0 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    c2h_dsc_byp_dst_addr_0 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    c2h_dsc_byp_len_0 : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
    c2h_dsc_byp_ctl_0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    c2h_dsc_byp_load_0 : IN STD_LOGIC;
    c2h_dsc_byp_ready_1 : OUT STD_LOGIC;
    c2h_dsc_byp_src_addr_1 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    c2h_dsc_byp_dst_addr_1 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    c2h_dsc_byp_len_1 : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
    c2h_dsc_byp_ctl_1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    c2h_dsc_byp_load_1 : IN STD_LOGIC;
    c2h_dsc_byp_ready_2 : OUT STD_LOGIC;
    c2h_dsc_byp_src_addr_2 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    c2h_dsc_byp_dst_addr_2 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    c2h_dsc_byp_len_2 : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
    c2h_dsc_byp_ctl_2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    c2h_dsc_byp_load_2 : IN STD_LOGIC;
    c2h_dsc_byp_ready_3 : OUT STD_LOGIC;
    c2h_dsc_byp_src_addr_3 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    c2h_dsc_byp_dst_addr_3 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    c2h_dsc_byp_len_3 : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
    c2h_dsc_byp_ctl_3 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    c2h_dsc_byp_load_3 : IN STD_LOGIC;
    h2c_dsc_byp_ready_0 : OUT STD_LOGIC;
    h2c_dsc_byp_src_addr_0 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    h2c_dsc_byp_dst_addr_0 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    h2c_dsc_byp_len_0 : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
    h2c_dsc_byp_ctl_0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    h2c_dsc_byp_load_0 : IN STD_LOGIC;
    h2c_dsc_byp_ready_1 : OUT STD_LOGIC;
    h2c_dsc_byp_src_addr_1 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    h2c_dsc_byp_dst_addr_1 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    h2c_dsc_byp_len_1 : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
    h2c_dsc_byp_ctl_1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    h2c_dsc_byp_load_1 : IN STD_LOGIC;
    h2c_dsc_byp_ready_2 : OUT STD_LOGIC;
    h2c_dsc_byp_src_addr_2 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    h2c_dsc_byp_dst_addr_2 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    h2c_dsc_byp_len_2 : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
    h2c_dsc_byp_ctl_2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    h2c_dsc_byp_load_2 : IN STD_LOGIC;
    h2c_dsc_byp_ready_3 : OUT STD_LOGIC;
    h2c_dsc_byp_src_addr_3 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    h2c_dsc_byp_dst_addr_3 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    h2c_dsc_byp_len_3 : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
    h2c_dsc_byp_ctl_3 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    h2c_dsc_byp_load_3 : IN STD_LOGIC;
    int_qpll1lock_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    int_qpll1outrefclk_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    int_qpll1outclk_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : xdma_0
  PORT MAP (
    sys_clk => sys_clk,
    sys_clk_gt => sys_clk_gt,
    sys_rst_n => sys_rst_n,
    dma_bridge_resetn => dma_bridge_resetn,
    user_lnk_up => user_lnk_up,
    pci_exp_txp => pci_exp_txp,
    pci_exp_txn => pci_exp_txn,
    pci_exp_rxp => pci_exp_rxp,
    pci_exp_rxn => pci_exp_rxn,
    axi_aclk => axi_aclk,
    axi_aresetn => axi_aresetn,
    usr_irq_req => usr_irq_req,
    usr_irq_ack => usr_irq_ack,
    msi_enable => msi_enable,
    msix_enable => msix_enable,
    msi_vector_width => msi_vector_width,
    m_axil_awaddr => m_axil_awaddr,
    m_axil_awprot => m_axil_awprot,
    m_axil_awvalid => m_axil_awvalid,
    m_axil_awready => m_axil_awready,
    m_axil_wdata => m_axil_wdata,
    m_axil_wstrb => m_axil_wstrb,
    m_axil_wvalid => m_axil_wvalid,
    m_axil_wready => m_axil_wready,
    m_axil_bvalid => m_axil_bvalid,
    m_axil_bresp => m_axil_bresp,
    m_axil_bready => m_axil_bready,
    m_axil_araddr => m_axil_araddr,
    m_axil_arprot => m_axil_arprot,
    m_axil_arvalid => m_axil_arvalid,
    m_axil_arready => m_axil_arready,
    m_axil_rdata => m_axil_rdata,
    m_axil_rresp => m_axil_rresp,
    m_axil_rvalid => m_axil_rvalid,
    m_axil_rready => m_axil_rready,
    common_commands_in => common_commands_in,
    pipe_rx_0_sigs => pipe_rx_0_sigs,
    pipe_rx_1_sigs => pipe_rx_1_sigs,
    pipe_rx_2_sigs => pipe_rx_2_sigs,
    pipe_rx_3_sigs => pipe_rx_3_sigs,
    pipe_rx_4_sigs => pipe_rx_4_sigs,
    pipe_rx_5_sigs => pipe_rx_5_sigs,
    pipe_rx_6_sigs => pipe_rx_6_sigs,
    pipe_rx_7_sigs => pipe_rx_7_sigs,
    common_commands_out => common_commands_out,
    pipe_tx_0_sigs => pipe_tx_0_sigs,
    pipe_tx_1_sigs => pipe_tx_1_sigs,
    pipe_tx_2_sigs => pipe_tx_2_sigs,
    pipe_tx_3_sigs => pipe_tx_3_sigs,
    pipe_tx_4_sigs => pipe_tx_4_sigs,
    pipe_tx_5_sigs => pipe_tx_5_sigs,
    pipe_tx_6_sigs => pipe_tx_6_sigs,
    pipe_tx_7_sigs => pipe_tx_7_sigs,
    s_axis_c2h_tdata_0 => s_axis_c2h_tdata_0,
    s_axis_c2h_tlast_0 => s_axis_c2h_tlast_0,
    s_axis_c2h_tvalid_0 => s_axis_c2h_tvalid_0,
    s_axis_c2h_tready_0 => s_axis_c2h_tready_0,
    s_axis_c2h_tkeep_0 => s_axis_c2h_tkeep_0,
    m_axis_h2c_tdata_0 => m_axis_h2c_tdata_0,
    m_axis_h2c_tlast_0 => m_axis_h2c_tlast_0,
    m_axis_h2c_tvalid_0 => m_axis_h2c_tvalid_0,
    m_axis_h2c_tready_0 => m_axis_h2c_tready_0,
    m_axis_h2c_tkeep_0 => m_axis_h2c_tkeep_0,
    s_axis_c2h_tdata_1 => s_axis_c2h_tdata_1,
    s_axis_c2h_tlast_1 => s_axis_c2h_tlast_1,
    s_axis_c2h_tvalid_1 => s_axis_c2h_tvalid_1,
    s_axis_c2h_tready_1 => s_axis_c2h_tready_1,
    s_axis_c2h_tkeep_1 => s_axis_c2h_tkeep_1,
    m_axis_h2c_tdata_1 => m_axis_h2c_tdata_1,
    m_axis_h2c_tlast_1 => m_axis_h2c_tlast_1,
    m_axis_h2c_tvalid_1 => m_axis_h2c_tvalid_1,
    m_axis_h2c_tready_1 => m_axis_h2c_tready_1,
    m_axis_h2c_tkeep_1 => m_axis_h2c_tkeep_1,
    s_axis_c2h_tdata_2 => s_axis_c2h_tdata_2,
    s_axis_c2h_tlast_2 => s_axis_c2h_tlast_2,
    s_axis_c2h_tvalid_2 => s_axis_c2h_tvalid_2,
    s_axis_c2h_tready_2 => s_axis_c2h_tready_2,
    s_axis_c2h_tkeep_2 => s_axis_c2h_tkeep_2,
    m_axis_h2c_tdata_2 => m_axis_h2c_tdata_2,
    m_axis_h2c_tlast_2 => m_axis_h2c_tlast_2,
    m_axis_h2c_tvalid_2 => m_axis_h2c_tvalid_2,
    m_axis_h2c_tready_2 => m_axis_h2c_tready_2,
    m_axis_h2c_tkeep_2 => m_axis_h2c_tkeep_2,
    s_axis_c2h_tdata_3 => s_axis_c2h_tdata_3,
    s_axis_c2h_tlast_3 => s_axis_c2h_tlast_3,
    s_axis_c2h_tvalid_3 => s_axis_c2h_tvalid_3,
    s_axis_c2h_tready_3 => s_axis_c2h_tready_3,
    s_axis_c2h_tkeep_3 => s_axis_c2h_tkeep_3,
    m_axis_h2c_tdata_3 => m_axis_h2c_tdata_3,
    m_axis_h2c_tlast_3 => m_axis_h2c_tlast_3,
    m_axis_h2c_tvalid_3 => m_axis_h2c_tvalid_3,
    m_axis_h2c_tready_3 => m_axis_h2c_tready_3,
    m_axis_h2c_tkeep_3 => m_axis_h2c_tkeep_3,
    s_axil_awaddr => s_axil_awaddr,
    s_axil_awprot => s_axil_awprot,
    s_axil_awvalid => s_axil_awvalid,
    s_axil_awready => s_axil_awready,
    s_axil_wdata => s_axil_wdata,
    s_axil_wstrb => s_axil_wstrb,
    s_axil_wvalid => s_axil_wvalid,
    s_axil_wready => s_axil_wready,
    s_axil_bvalid => s_axil_bvalid,
    s_axil_bresp => s_axil_bresp,
    s_axil_bready => s_axil_bready,
    s_axil_araddr => s_axil_araddr,
    s_axil_arprot => s_axil_arprot,
    s_axil_arvalid => s_axil_arvalid,
    s_axil_arready => s_axil_arready,
    s_axil_rdata => s_axil_rdata,
    s_axil_rresp => s_axil_rresp,
    s_axil_rvalid => s_axil_rvalid,
    s_axil_rready => s_axil_rready,
    c2h_dsc_byp_ready_0 => c2h_dsc_byp_ready_0,
    c2h_dsc_byp_src_addr_0 => c2h_dsc_byp_src_addr_0,
    c2h_dsc_byp_dst_addr_0 => c2h_dsc_byp_dst_addr_0,
    c2h_dsc_byp_len_0 => c2h_dsc_byp_len_0,
    c2h_dsc_byp_ctl_0 => c2h_dsc_byp_ctl_0,
    c2h_dsc_byp_load_0 => c2h_dsc_byp_load_0,
    c2h_dsc_byp_ready_1 => c2h_dsc_byp_ready_1,
    c2h_dsc_byp_src_addr_1 => c2h_dsc_byp_src_addr_1,
    c2h_dsc_byp_dst_addr_1 => c2h_dsc_byp_dst_addr_1,
    c2h_dsc_byp_len_1 => c2h_dsc_byp_len_1,
    c2h_dsc_byp_ctl_1 => c2h_dsc_byp_ctl_1,
    c2h_dsc_byp_load_1 => c2h_dsc_byp_load_1,
    c2h_dsc_byp_ready_2 => c2h_dsc_byp_ready_2,
    c2h_dsc_byp_src_addr_2 => c2h_dsc_byp_src_addr_2,
    c2h_dsc_byp_dst_addr_2 => c2h_dsc_byp_dst_addr_2,
    c2h_dsc_byp_len_2 => c2h_dsc_byp_len_2,
    c2h_dsc_byp_ctl_2 => c2h_dsc_byp_ctl_2,
    c2h_dsc_byp_load_2 => c2h_dsc_byp_load_2,
    c2h_dsc_byp_ready_3 => c2h_dsc_byp_ready_3,
    c2h_dsc_byp_src_addr_3 => c2h_dsc_byp_src_addr_3,
    c2h_dsc_byp_dst_addr_3 => c2h_dsc_byp_dst_addr_3,
    c2h_dsc_byp_len_3 => c2h_dsc_byp_len_3,
    c2h_dsc_byp_ctl_3 => c2h_dsc_byp_ctl_3,
    c2h_dsc_byp_load_3 => c2h_dsc_byp_load_3,
    h2c_dsc_byp_ready_0 => h2c_dsc_byp_ready_0,
    h2c_dsc_byp_src_addr_0 => h2c_dsc_byp_src_addr_0,
    h2c_dsc_byp_dst_addr_0 => h2c_dsc_byp_dst_addr_0,
    h2c_dsc_byp_len_0 => h2c_dsc_byp_len_0,
    h2c_dsc_byp_ctl_0 => h2c_dsc_byp_ctl_0,
    h2c_dsc_byp_load_0 => h2c_dsc_byp_load_0,
    h2c_dsc_byp_ready_1 => h2c_dsc_byp_ready_1,
    h2c_dsc_byp_src_addr_1 => h2c_dsc_byp_src_addr_1,
    h2c_dsc_byp_dst_addr_1 => h2c_dsc_byp_dst_addr_1,
    h2c_dsc_byp_len_1 => h2c_dsc_byp_len_1,
    h2c_dsc_byp_ctl_1 => h2c_dsc_byp_ctl_1,
    h2c_dsc_byp_load_1 => h2c_dsc_byp_load_1,
    h2c_dsc_byp_ready_2 => h2c_dsc_byp_ready_2,
    h2c_dsc_byp_src_addr_2 => h2c_dsc_byp_src_addr_2,
    h2c_dsc_byp_dst_addr_2 => h2c_dsc_byp_dst_addr_2,
    h2c_dsc_byp_len_2 => h2c_dsc_byp_len_2,
    h2c_dsc_byp_ctl_2 => h2c_dsc_byp_ctl_2,
    h2c_dsc_byp_load_2 => h2c_dsc_byp_load_2,
    h2c_dsc_byp_ready_3 => h2c_dsc_byp_ready_3,
    h2c_dsc_byp_src_addr_3 => h2c_dsc_byp_src_addr_3,
    h2c_dsc_byp_dst_addr_3 => h2c_dsc_byp_dst_addr_3,
    h2c_dsc_byp_len_3 => h2c_dsc_byp_len_3,
    h2c_dsc_byp_ctl_3 => h2c_dsc_byp_ctl_3,
    h2c_dsc_byp_load_3 => h2c_dsc_byp_load_3,
    int_qpll1lock_out => int_qpll1lock_out,
    int_qpll1outrefclk_out => int_qpll1outrefclk_out,
    int_qpll1outclk_out => int_qpll1outclk_out
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

-- You must compile the wrapper file xdma_0.vhd when simulating
-- the core, xdma_0. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.

