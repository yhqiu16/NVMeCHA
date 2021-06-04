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
// File       : xdma_0_pcie3_ip_pcie3_uscale_core_top.v
// Version    : 4.4 
//-----------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////

`timescale 1ps/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module xdma_0_pcie3_ip_pcie3_uscale_core_top 
#(
  parameter  PL_LINK_CAP_MAX_LINK_SPEED = 3'h4,
  parameter  PL_LINK_CAP_MAX_LINK_WIDTH = 4'h8,
  parameter  USER_CLK_FREQ = 3,
  parameter  CORE_CLK_FREQ = 2,
  parameter  PLL_TYPE = 0,
  parameter  integer PF0_LINK_CAP_ASPM_SUPPORT = 0,
  parameter  C_DATA_WIDTH = 256,
  parameter  REF_CLK_FREQ = 0,
  parameter  PCIE_LINK_SPEED = 3,
  parameter  KEEP_WIDTH = 8,
  parameter  ARI_CAP_ENABLE = "FALSE",
  parameter  PF0_ARI_CAP_NEXT_FUNC = 8'h00,
  parameter  AXISTEN_IF_CC_ALIGNMENT_MODE = "FALSE",
  parameter  AXISTEN_IF_CQ_ALIGNMENT_MODE = "FALSE",
  parameter  AXISTEN_IF_RC_ALIGNMENT_MODE = "FALSE",
  parameter  AXISTEN_IF_RC_STRADDLE = "FALSE",
  parameter  AXISTEN_IF_RQ_ALIGNMENT_MODE = "FALSE",
  parameter  AXISTEN_IF_ENABLE_MSG_ROUTE = 18'h2FFFF,
  parameter  AXISTEN_IF_ENABLE_RX_MSG_INTFC = "FALSE",
  parameter  PF0_AER_CAP_ECRC_CHECK_CAPABLE = "FALSE",
  parameter  PF0_AER_CAP_ECRC_GEN_CAPABLE = "FALSE",
  parameter  PF0_AER_CAP_NEXTPTR = 12'h000,
  parameter  PF0_ARI_CAP_NEXTPTR = 12'h000,
  parameter  VF0_ARI_CAP_NEXTPTR = 12'h000,
  parameter  VF1_ARI_CAP_NEXTPTR = 12'h000,
  parameter  VF2_ARI_CAP_NEXTPTR = 12'h000,
  parameter  VF3_ARI_CAP_NEXTPTR = 12'h000,
  parameter  VF4_ARI_CAP_NEXTPTR = 12'h000,
  parameter  VF5_ARI_CAP_NEXTPTR = 12'h000,
  parameter  PF0_BAR0_APERTURE_SIZE = 5'h03,
  parameter  PF0_BAR0_CONTROL = 3'h4,
  parameter  PF0_BAR1_APERTURE_SIZE = 5'h00,
  parameter  PF0_BAR1_CONTROL = 3'h0,
  parameter  PF0_BAR2_APERTURE_SIZE = 5'h03,
  parameter  PF0_BAR2_CONTROL = 3'h4,
  parameter  PF0_BAR3_APERTURE_SIZE = 5'h03,
  parameter  PF0_BAR3_CONTROL = 3'h0,
  parameter  PF0_BAR4_APERTURE_SIZE = 5'h03,
  parameter  PF0_BAR4_CONTROL = 3'h4,
  parameter  PF0_BAR5_APERTURE_SIZE = 5'h03,
  parameter  PF0_BAR5_CONTROL = 3'h0,
  parameter  PF0_CAPABILITY_POINTER = 8'h50,
  parameter  PF0_CLASS_CODE = 24'h000000,
  parameter  PF0_VENDOR_ID = 16'h0000,
  parameter  PF0_DEVICE_ID = 16'h0000,
  parameter  PF0_DEV_CAP2_128B_CAS_ATOMIC_COMPLETER_SUPPORT = "TRUE",
  parameter  PF0_DEV_CAP2_32B_ATOMIC_COMPLETER_SUPPORT = "TRUE",
  parameter  PF0_DEV_CAP2_64B_ATOMIC_COMPLETER_SUPPORT = "TRUE",
  parameter  PF0_DEV_CAP2_LTR_SUPPORT = "TRUE",
  parameter  PF0_DEV_CAP2_OBFF_SUPPORT = 2'h0,
  parameter  PF0_DEV_CAP2_TPH_COMPLETER_SUPPORT = "FALSE",
  parameter  PF0_DEV_CAP_EXT_TAG_SUPPORTED = "TRUE",
  parameter  PF0_DEV_CAP_FUNCTION_LEVEL_RESET_CAPABLE = "TRUE",
  parameter  PF0_DEV_CAP_MAX_PAYLOAD_SIZE = 3'h3,
  parameter  PF0_DPA_CAP_NEXTPTR = 12'h000,
  parameter  PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION0 = 8'h00,
  parameter  PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION1 = 8'h00,
  parameter  PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION2 = 8'h00,
  parameter  PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION3 = 8'h00,
  parameter  PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION4 = 8'h00,
  parameter  PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION5 = 8'h00,
  parameter  PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION6 = 8'h00,
  parameter  PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION7 = 8'h00,
  parameter  PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION0 = 8'h00,
  parameter  PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION1 = 8'h00,
  parameter  PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION2 = 8'h00,
  parameter  PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION3 = 8'h00,
  parameter  PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION4 = 8'h00,
  parameter  PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION5 = 8'h00,
  parameter  PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION6 = 8'h00,
  parameter  PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION7 = 8'h00,
  parameter  PF0_DSN_CAP_NEXTPTR = 12'h10c,
  parameter  PF0_EXPANSION_ROM_APERTURE_SIZE = 5'h03,
  parameter  PF0_EXPANSION_ROM_ENABLE = "FALSE",
  parameter  PF0_INTERRUPT_PIN = 3'h1,
  parameter  PF0_LINK_STATUS_SLOT_CLOCK_CONFIG = "TRUE",
  parameter  PF0_LTR_CAP_NEXTPTR = 12'h000,
  parameter  PF0_MSIX_CAP_NEXTPTR = 8'h00,
  parameter  integer PF0_MSIX_CAP_PBA_BIR = 0,
  parameter  PF0_MSIX_CAP_PBA_OFFSET = 29'h00000050,
  parameter  integer PF0_MSIX_CAP_TABLE_BIR = 0,
  parameter  PF0_MSIX_CAP_TABLE_OFFSET = 29'h00000040,
  parameter  PF0_MSIX_CAP_TABLE_SIZE = 11'h000,
  parameter  integer PF0_MSI_CAP_MULTIMSGCAP = 0,
  parameter  PF0_MSI_CAP_NEXTPTR = 8'h00,
  parameter  PF0_PB_CAP_NEXTPTR = 12'h000,
  parameter  PF0_PM_CAP_NEXTPTR = 8'h00,
  parameter  PF0_PM_CAP_PMESUPPORT_D0 = "TRUE",
  parameter  PF0_PM_CAP_PMESUPPORT_D1 = "TRUE",
  parameter  PF0_PM_CAP_PMESUPPORT_D3HOT = "TRUE",
  parameter  PF0_PM_CAP_SUPP_D1_STATE = "TRUE",
  parameter  PF0_RBAR_CAP_ENABLE = "FALSE",
  parameter  PF0_RBAR_CAP_NEXTPTR = 12'h000,
  parameter  PF0_RBAR_CAP_SIZE0 = 20'h00000,
  parameter  PF0_RBAR_CAP_SIZE1 = 20'h00000,
  parameter  PF0_RBAR_CAP_SIZE2 = 20'h00000,
  parameter  PF1_RBAR_CAP_SIZE0 = 20'h00000,
  parameter  PF1_RBAR_CAP_SIZE1 = 20'h00000,
  parameter  PF1_RBAR_CAP_SIZE2 = 20'h00000,
  parameter  PF0_REVISION_ID = 8'h00,
  parameter  PF0_SRIOV_BAR0_APERTURE_SIZE = 5'h03,
  parameter  PF0_SRIOV_BAR0_CONTROL = 3'h4,
  parameter  PF0_SRIOV_BAR1_APERTURE_SIZE = 5'h00,
  parameter  PF0_SRIOV_BAR1_CONTROL = 3'h0,
  parameter  PF0_SRIOV_BAR2_APERTURE_SIZE = 5'h03,
  parameter  PF0_SRIOV_BAR2_CONTROL = 3'h4,
  parameter  PF0_SRIOV_BAR3_APERTURE_SIZE = 5'h03,
  parameter  PF0_SRIOV_BAR3_CONTROL = 3'h0,
  parameter  PF0_SRIOV_BAR4_APERTURE_SIZE = 5'h03,
  parameter  PF0_SRIOV_BAR4_CONTROL = 3'h4,
  parameter  PF0_SRIOV_BAR5_APERTURE_SIZE = 5'h03,
  parameter  PF0_SRIOV_BAR5_CONTROL = 3'h0,
  parameter  PF0_SRIOV_CAP_INITIAL_VF = 16'h0000,
  parameter  PF0_SRIOV_CAP_NEXTPTR = 12'h000,
  parameter  PF0_SRIOV_CAP_TOTAL_VF = 16'h0000,
  parameter  PF0_SRIOV_CAP_VER = 4'h1,
  parameter  PF0_SRIOV_FIRST_VF_OFFSET = 16'h0000,
  parameter  PF0_SRIOV_FUNC_DEP_LINK = 16'h0000,
  parameter  PF0_SRIOV_SUPPORTED_PAGE_SIZE = 32'h00000000,
  parameter  PF0_SRIOV_VF_DEVICE_ID = 16'h0000,
  parameter  PF0_SUBSYSTEM_VENDOR_ID = 16'h0000,
  parameter  PF0_SUBSYSTEM_ID = 16'h0000,
  parameter  PF0_TPHR_CAP_ENABLE = "FALSE",
  parameter  PF0_TPHR_CAP_NEXTPTR = 12'h000,
  parameter  VF0_TPHR_CAP_NEXTPTR = 12'h000,
  parameter  VF1_TPHR_CAP_NEXTPTR = 12'h000,
  parameter  VF2_TPHR_CAP_NEXTPTR = 12'h000,
  parameter  VF3_TPHR_CAP_NEXTPTR = 12'h000,
  parameter  VF4_TPHR_CAP_NEXTPTR = 12'h000,
  parameter  VF5_TPHR_CAP_NEXTPTR = 12'h000,
  parameter  PF0_TPHR_CAP_ST_MODE_SEL = 3'h0,
  parameter  PF0_TPHR_CAP_ST_TABLE_LOC = 2'h0,
  parameter  PF0_TPHR_CAP_ST_TABLE_SIZE = 11'h000,
  parameter  PF0_TPHR_CAP_VER = 4'h1,
  parameter  PF1_TPHR_CAP_ST_MODE_SEL = 3'h0,
  parameter  PF1_TPHR_CAP_ST_TABLE_LOC = 2'h0,
  parameter  PF1_TPHR_CAP_ST_TABLE_SIZE = 11'h000,
  parameter  PF1_TPHR_CAP_VER = 4'h1,
  parameter  VF0_TPHR_CAP_ST_MODE_SEL = 3'h0,
  parameter  VF0_TPHR_CAP_ST_TABLE_LOC = 2'h0,
  parameter  VF0_TPHR_CAP_ST_TABLE_SIZE = 11'h000,
  parameter  VF0_TPHR_CAP_VER = 4'h1,
  parameter  VF1_TPHR_CAP_ST_MODE_SEL = 3'h0,
  parameter  VF1_TPHR_CAP_ST_TABLE_LOC = 2'h0,
  parameter  VF1_TPHR_CAP_ST_TABLE_SIZE = 11'h000,
  parameter  VF1_TPHR_CAP_VER = 4'h1,
  parameter  VF2_TPHR_CAP_ST_MODE_SEL = 3'h0,
  parameter  VF2_TPHR_CAP_ST_TABLE_LOC = 2'h0,
  parameter  VF2_TPHR_CAP_ST_TABLE_SIZE = 11'h000,
  parameter  VF2_TPHR_CAP_VER = 4'h1,
  parameter  VF3_TPHR_CAP_ST_MODE_SEL = 3'h0,
  parameter  VF3_TPHR_CAP_ST_TABLE_LOC = 2'h0,
  parameter  VF3_TPHR_CAP_ST_TABLE_SIZE = 11'h000,
  parameter  VF3_TPHR_CAP_VER = 4'h1,
  parameter  VF4_TPHR_CAP_ST_MODE_SEL = 3'h0,
  parameter  VF4_TPHR_CAP_ST_TABLE_LOC = 2'h0,
  parameter  VF4_TPHR_CAP_ST_TABLE_SIZE = 11'h000,
  parameter  VF4_TPHR_CAP_VER = 4'h1,
  parameter  VF5_TPHR_CAP_ST_MODE_SEL = 3'h0,
  parameter  VF5_TPHR_CAP_ST_TABLE_LOC = 2'h0,
  parameter  VF5_TPHR_CAP_ST_TABLE_SIZE = 11'h000,
  parameter  VF5_TPHR_CAP_VER = 4'h1,
  parameter  PF0_TPHR_CAP_DEV_SPECIFIC_MODE = "TRUE",
  parameter  PF0_TPHR_CAP_INT_VEC_MODE = "TRUE",
  parameter  PF1_TPHR_CAP_DEV_SPECIFIC_MODE = "TRUE",
  parameter  PF1_TPHR_CAP_INT_VEC_MODE = "TRUE",
  parameter  VF0_TPHR_CAP_DEV_SPECIFIC_MODE = "TRUE",
  parameter  VF0_TPHR_CAP_INT_VEC_MODE = "TRUE",
  parameter  VF1_TPHR_CAP_DEV_SPECIFIC_MODE = "TRUE",
  parameter  VF1_TPHR_CAP_INT_VEC_MODE = "TRUE",
  parameter  VF2_TPHR_CAP_DEV_SPECIFIC_MODE = "TRUE",
  parameter  VF2_TPHR_CAP_INT_VEC_MODE = "TRUE",
  parameter  VF3_TPHR_CAP_DEV_SPECIFIC_MODE = "TRUE",
  parameter  VF3_TPHR_CAP_INT_VEC_MODE = "TRUE",
  parameter  VF4_TPHR_CAP_DEV_SPECIFIC_MODE = "TRUE",
  parameter  VF4_TPHR_CAP_INT_VEC_MODE = "TRUE",
  parameter  VF5_TPHR_CAP_DEV_SPECIFIC_MODE = "TRUE",
  parameter  VF5_TPHR_CAP_INT_VEC_MODE = "TRUE",
  parameter  PF0_SECONDARY_PCIE_CAP_NEXTPTR = 12'h000,
  parameter  MCAP_CAP_NEXTPTR = 12'h000,
  parameter  PF0_VC_CAP_NEXTPTR = 12'h000,
  parameter  SPARE_WORD1 = 32'h00000000,
  parameter  PF1_AER_CAP_ECRC_CHECK_CAPABLE = "FALSE",
  parameter  PF1_AER_CAP_ECRC_GEN_CAPABLE = "FALSE",
  parameter  PF1_AER_CAP_NEXTPTR = 12'h000,
  parameter  PF1_ARI_CAP_NEXTPTR = 12'h000,
  parameter  PF1_BAR0_APERTURE_SIZE = 6'h03,
  parameter  PF1_BAR0_CONTROL = 3'h4,
  parameter  PF1_BAR1_APERTURE_SIZE = 6'h00,
  parameter  PF1_BAR1_CONTROL = 3'h0,
  parameter  PF1_BAR2_APERTURE_SIZE = 5'h03,
  parameter  PF1_BAR2_CONTROL = 3'h4,
  parameter  PF1_BAR3_APERTURE_SIZE = 5'h03,
  parameter  PF1_BAR3_CONTROL = 3'h0,
  parameter  PF1_BAR4_APERTURE_SIZE = 5'h03,
  parameter  PF1_BAR4_CONTROL = 3'h4,
  parameter  PF1_BAR5_APERTURE_SIZE = 5'h03,
  parameter  PF1_BAR5_CONTROL = 3'h0,
  parameter  PF1_CAPABILITY_POINTER = 8'h50,
  parameter  PF1_CLASS_CODE = 24'h000000,
  parameter  PF1_DEVICE_ID = 16'h0000,
  parameter  PF1_DEV_CAP_MAX_PAYLOAD_SIZE = 3'h3,
  parameter  PF1_DPA_CAP_NEXTPTR = 12'h000,
  parameter  PF1_DSN_CAP_NEXTPTR = 12'h10c,
  parameter  PF1_EXPANSION_ROM_APERTURE_SIZE = 5'h03,
  parameter  PF1_EXPANSION_ROM_ENABLE = "FALSE",
  parameter  PF1_INTERRUPT_PIN = 3'h1,
  parameter  PF1_MSIX_CAP_NEXTPTR = 8'h00,
  parameter  integer PF1_MSIX_CAP_PBA_BIR = 0,
  parameter  PF1_MSIX_CAP_PBA_OFFSET = 29'h00000050,
  parameter  integer PF1_MSIX_CAP_TABLE_BIR = 0,
  parameter  PF1_MSIX_CAP_TABLE_OFFSET = 29'h00000040,
  parameter  PF1_MSIX_CAP_TABLE_SIZE = 11'h000,
  parameter  integer PF1_MSI_CAP_MULTIMSGCAP = 0,
  parameter  PF1_MSI_CAP_NEXTPTR = 8'h00,
  parameter  PF1_PB_CAP_NEXTPTR = 12'h000,
  parameter  PF1_PM_CAP_NEXTPTR = 8'h00,
  parameter  PF1_RBAR_CAP_ENABLE = "FALSE",
  parameter  PF1_RBAR_CAP_NEXTPTR = 12'h000,
  parameter  PF1_REVISION_ID = 8'h00,
  parameter  PF1_SRIOV_BAR0_APERTURE_SIZE = 5'h03,
  parameter  PF1_SRIOV_BAR0_CONTROL = 3'h4,
  parameter  PF1_SRIOV_BAR1_APERTURE_SIZE = 5'h00,
  parameter  PF1_SRIOV_BAR1_CONTROL = 3'h0,
  parameter  PF1_SRIOV_BAR2_APERTURE_SIZE = 5'h03,
  parameter  PF1_SRIOV_BAR2_CONTROL = 3'h4,
  parameter  PF1_SRIOV_BAR3_APERTURE_SIZE = 5'h03,
  parameter  PF1_SRIOV_BAR3_CONTROL = 3'h0,
  parameter  PF1_SRIOV_BAR4_APERTURE_SIZE = 5'h03,
  parameter  PF1_SRIOV_BAR4_CONTROL = 3'h4,
  parameter  PF1_SRIOV_BAR5_APERTURE_SIZE = 5'h03,
  parameter  PF1_SRIOV_BAR5_CONTROL = 3'h0,
  parameter  PF1_SRIOV_CAP_INITIAL_VF = 16'h0000,
  parameter  PF1_SRIOV_CAP_NEXTPTR = 12'h000,
  parameter  PF1_SRIOV_CAP_TOTAL_VF = 16'h0000,
  parameter  PF1_SRIOV_CAP_VER = 4'h1,
  parameter  PF1_SRIOV_FIRST_VF_OFFSET = 16'h0000,
  parameter  PF1_SRIOV_FUNC_DEP_LINK = 16'h0000,
  parameter  PF1_SRIOV_SUPPORTED_PAGE_SIZE = 32'h00000000,
  parameter  PF1_SRIOV_VF_DEVICE_ID = 16'h0000,
  parameter  PF1_SUBSYSTEM_ID = 16'h0000,
  parameter  PF1_TPHR_CAP_ENABLE = "FALSE",
  parameter  PF1_TPHR_CAP_NEXTPTR = 12'h000,
  parameter  PL_UPSTREAM_FACING = "TRUE",
  parameter  en_msi_per_vec_masking = "FALSE",
  parameter  SRIOV_CAP_ENABLE = "FALSE",
  parameter  TL_CREDITS_CD = 12'h3e0,
  parameter  TL_CREDITS_CH = 8'h20,
  parameter  TL_CREDITS_NPD = 12'h028,
  parameter  TL_CREDITS_NPH = 8'h20,
  parameter  TL_CREDITS_PD = 12'h198,
  parameter  TL_CREDITS_PH = 8'h20,
  parameter  TL_EXTENDED_CFG_EXTEND_INTERFACE_ENABLE = "FALSE",
  parameter  ACS_EXT_CAP_ENABLE = "FALSE",
  parameter  ACS_CAP_NEXTPTR = 12'h000,
  parameter  TL_LEGACY_MODE_ENABLE = "FALSE",
  parameter  TL_PF_ENABLE_REG = 2'h0,
  parameter  VF0_CAPABILITY_POINTER = 8'h50,
  parameter  integer VF0_MSIX_CAP_PBA_BIR = 0,
  parameter  VF0_MSIX_CAP_PBA_OFFSET = 29'h00000050,
  parameter  integer VF0_MSIX_CAP_TABLE_BIR = 0,
  parameter  VF0_MSIX_CAP_TABLE_OFFSET = 29'h00000040,
  parameter  VF0_MSIX_CAP_TABLE_SIZE = 11'h000,
  parameter  integer VF0_MSI_CAP_MULTIMSGCAP = 0,
  parameter  VF0_PM_CAP_NEXTPTR = 8'h00,
  parameter  integer VF1_MSIX_CAP_PBA_BIR = 0,
  parameter  VF1_MSIX_CAP_PBA_OFFSET = 29'h00000050,
  parameter  integer VF1_MSIX_CAP_TABLE_BIR = 0,
  parameter  VF1_MSIX_CAP_TABLE_OFFSET = 29'h00000040,
  parameter  VF1_MSIX_CAP_TABLE_SIZE = 11'h000,
  parameter  integer VF1_MSI_CAP_MULTIMSGCAP = 0,
  parameter  VF1_PM_CAP_NEXTPTR = 8'h00,
  parameter  integer VF2_MSIX_CAP_PBA_BIR = 0,
  parameter  VF2_MSIX_CAP_PBA_OFFSET = 29'h00000050,
  parameter  integer VF2_MSIX_CAP_TABLE_BIR = 0,
  parameter  VF2_MSIX_CAP_TABLE_OFFSET = 29'h00000040,
  parameter  VF2_MSIX_CAP_TABLE_SIZE = 11'h000,
  parameter  integer VF2_MSI_CAP_MULTIMSGCAP = 0,
  parameter  VF2_PM_CAP_NEXTPTR = 8'h00,
  parameter  integer VF3_MSIX_CAP_PBA_BIR = 0,
  parameter  VF3_MSIX_CAP_PBA_OFFSET = 29'h00000050,
  parameter  integer VF3_MSIX_CAP_TABLE_BIR = 0,
  parameter  VF3_MSIX_CAP_TABLE_OFFSET = 29'h00000040,
  parameter  VF3_MSIX_CAP_TABLE_SIZE = 11'h000,
  parameter  integer VF3_MSI_CAP_MULTIMSGCAP = 0,
  parameter  VF3_PM_CAP_NEXTPTR = 8'h00,
  parameter  integer VF4_MSIX_CAP_PBA_BIR = 0,
  parameter  VF4_MSIX_CAP_PBA_OFFSET = 29'h00000050,
  parameter  integer VF4_MSIX_CAP_TABLE_BIR = 0,
  parameter  VF4_MSIX_CAP_TABLE_OFFSET = 29'h00000040,
  parameter  VF4_MSIX_CAP_TABLE_SIZE = 11'h000,
  parameter  integer VF4_MSI_CAP_MULTIMSGCAP = 0,
  parameter  VF4_PM_CAP_NEXTPTR = 8'h00,
  parameter  integer VF5_MSIX_CAP_PBA_BIR = 0,
  parameter  VF5_MSIX_CAP_PBA_OFFSET = 29'h00000050,
  parameter  integer VF5_MSIX_CAP_TABLE_BIR = 0,
  parameter  VF5_MSIX_CAP_TABLE_OFFSET = 29'h00000040,
  parameter  VF5_MSIX_CAP_TABLE_SIZE = 11'h000,
  parameter  integer VF5_MSI_CAP_MULTIMSGCAP = 0,
  parameter  VF5_PM_CAP_NEXTPTR = 8'h00,
  parameter  COMPLETION_SPACE = "16KB",
  parameter  gen_x0y0_xdc = 1,
  parameter  gen_x0y1_xdc = 0, 
  parameter  gen_x0y2_xdc = 0,
  parameter  gen_x0y3_xdc = 0,
  parameter  gen_x0y4_xdc = 0,
  parameter  gen_x0y5_xdc = 0,
  parameter  xlnx_ref_board = 0,
  parameter  pcie_blk_locn = 0,
  parameter  PIPE_SIM = "FALSE",      // This Parameter has no effect in RTL. Instead use the below parameter (EXT_PIPE_SIM), defined below and is controlled from board.v(simulation).
  parameter  AXISTEN_IF_ENABLE_CLIENT_TAG = "FALSE",
  parameter  PCIE_USE_MODE = "2.1" ,
  parameter  PCIE_FAST_CONFIG = "NONE", 
  parameter  EXT_STARTUP_PRIMITIVE = "FALSE",
  parameter  PL_INTERFACE = "FALSE",
  parameter  PCIE_CONFIGURATION = "FALSE",
  parameter  CFG_STATUS_IF = "FALSE",
  parameter  GT_TX_PD = "FALSE",
  parameter  TX_FC_IF = "FALSE",
  parameter  CFG_EXT_IF = "FALSE",
  parameter  CFG_FC_IF = "FALSE",
  parameter  PER_FUNC_STATUS_IF = "FALSE",
  parameter  CFG_MGMT_IF = "FALSE",
  parameter  RCV_MSG_IF = "FALSE",
  parameter  CFG_TX_MSG_IF = "FALSE",
  parameter  CFG_CTL_IF = "FALSE",
  parameter  MSI_EN = "TRUE",
  parameter  MSIX_EN = "FALSE",
  parameter  PCIE3_DRP = "TRUE",
  parameter  DIS_GT_WIZARD = "TRUE",
  parameter  TRANSCEIVER_CTRL_STATUS_PORTS = "FALSE",
  parameter  integer SHARED_LOGIC = 1,
  parameter  DEDICATE_PERST = "TRUE",
  parameter  SYS_RESET_POLARITY = 1'b0, 
  parameter  MCAP_ENABLEMENT = "NONE",
  parameter  integer PHY_LP_TXPRESET = 4,
  parameter  EXT_CH_GT_DRP      = "FALSE",  
  parameter  EN_GT_SELECTION = "FALSE",
  parameter  SELECT_QUAD = "Quad_1",
  parameter  silicon_revision = "GES",
  parameter  DEV_PORT_TYPE = 0,
  parameter  RX_DETECT = 0,
  parameter  ENABLE_IBERT="FALSE",
  parameter  DBG_DESCRAMBLE_EN = "TRUE",
  parameter  ENABLE_JTAG_DBG="FALSE",
  parameter  AXISTEN_IF_CC_PARITY_CHK = "FALSE",
  parameter  AXISTEN_IF_RQ_PARITY_CHK = "FALSE",
  parameter  ENABLE_AUTO_RXEQ="FALSE",
  parameter  GTWIZ_IN_CORE=1,
  parameter  INS_LOSS_PROFILE="Add-in_Card",
  parameter  PM_ENABLE_L23_ENTRY = "FALSE",
  parameter  MULT_PF_DES      = "FALSE",  
  parameter  BMD_PIO_MODE="FALSE",
  parameter  ENABLE_GT_V1_5 = "FALSE",
  parameter  EXT_XVC_VSEC_ENABLE = "FALSE",
  parameter PIPE_PIPELINE_STAGES = 1,
  parameter MCAP_CONFIGURE_OVERRIDE = "FALSE",
  parameter MCAP_ENABLE = "FALSE",
  parameter MCAP_EOS_DESIGN_SWITCH = "FALSE",
  parameter [31:0] MCAP_FPGA_BITSTREAM_VERSION = 32'h00000000,
  parameter MCAP_GATE_IO_ENABLE_DESIGN_SWITCH = "FALSE",
  parameter MCAP_GATE_MEM_ENABLE_DESIGN_SWITCH = "FALSE",
  parameter MCAP_INPUT_GATE_DESIGN_SWITCH = "FALSE",
  parameter MCAP_INTERRUPT_ON_MCAP_ERROR = "FALSE",
  parameter MCAP_INTERRUPT_ON_MCAP_EOS = "FALSE",
  parameter DEBUG_CFG_LOCAL_MGMT_REG_ACCESS_OVERRIDE = "FALSE",
  parameter DEBUG_PL_DISABLE_EI_INFER_IN_L0 = "FALSE",
  parameter DEBUG_TL_DISABLE_RX_TLP_ORDER_CHECKS = "FALSE",
  parameter [7:0] DNSTREAM_LINK_NUM = 8'h00,
  parameter [8:0] LL_ACK_TIMEOUT = 9'h000,
  parameter LL_ACK_TIMEOUT_EN = "FALSE",
  parameter integer LL_ACK_TIMEOUT_FUNC = 0,
  parameter [15:0] LL_CPL_FC_UPDATE_TIMER = 16'h0000,
  parameter LL_CPL_FC_UPDATE_TIMER_OVERRIDE = "FALSE",
  parameter [15:0] LL_FC_UPDATE_TIMER = 16'h0000,
  parameter LL_FC_UPDATE_TIMER_OVERRIDE = "FALSE",
  parameter [15:0] LL_NP_FC_UPDATE_TIMER = 16'h0000,
  parameter LL_NP_FC_UPDATE_TIMER_OVERRIDE = "FALSE",
  parameter [15:0] LL_P_FC_UPDATE_TIMER = 16'h0000,
  parameter LL_P_FC_UPDATE_TIMER_OVERRIDE = "FALSE",
  parameter [8:0] LL_REPLAY_TIMEOUT = 9'h000,
  parameter LL_REPLAY_TIMEOUT_EN = "FALSE",
  parameter integer LL_REPLAY_TIMEOUT_FUNC = 0,
  parameter [9:0] LTR_TX_MESSAGE_MINIMUM_INTERVAL = 10'h0fa,
  parameter LTR_TX_MESSAGE_ON_FUNC_POWER_STATE_CHANGE = "FALSE",
  parameter LTR_TX_MESSAGE_ON_LTR_ENABLE = "FALSE",
  parameter [15:0] MCAP_VSEC_ID = 16'h0001,
  parameter [11:0] MCAP_VSEC_LEN = 12'h02c,
  parameter [3:0] MCAP_VSEC_REV = 4'h0,
  parameter [3:0] PF0_ARI_CAP_VER = 4'h1,
  parameter [7:0] PF0_BIST_REGISTER = 8'h00,
  parameter integer PF0_DEV_CAP_ENDPOINT_L0S_LATENCY = 0,
  parameter integer PF0_DEV_CAP_ENDPOINT_L1_LATENCY = 0,
  parameter PF0_DEV_CAP2_ARI_FORWARD_ENABLE = "FALSE",
  parameter PF0_DEV_CAP2_CPL_TIMEOUT_DISABLE = "TRUE",
  parameter [4:0] PF0_DPA_CAP_SUB_STATE_CONTROL = 5'h00,
  parameter PF0_DPA_CAP_SUB_STATE_CONTROL_EN = "TRUE",
  parameter [3:0] PF0_DPA_CAP_VER = 4'h1,
  parameter [7:0] PF0_INTERRUPT_LINE = 8'h00,
  parameter integer PF0_LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN1 = 7,
  parameter integer PF0_LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN2 = 7,
  parameter integer PF0_LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN3 = 7,
  parameter integer PF0_LINK_CAP_L0S_EXIT_LATENCY_GEN1 = 7,
  parameter integer PF0_LINK_CAP_L0S_EXIT_LATENCY_GEN2 = 7,
  parameter integer PF0_LINK_CAP_L0S_EXIT_LATENCY_GEN3 = 7,
  parameter integer PF0_LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN1 = 7,
  parameter integer PF0_LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN2 = 7,
  parameter integer PF0_LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN3 = 7,
  parameter integer PF0_LINK_CAP_L1_EXIT_LATENCY_GEN1 = 7,
  parameter integer PF0_LINK_CAP_L1_EXIT_LATENCY_GEN2 = 7,
  parameter integer PF0_LINK_CAP_L1_EXIT_LATENCY_GEN3 = 7,
  parameter [9:0] PF0_LTR_CAP_MAX_NOSNOOP_LAT = 10'h000,
  parameter [9:0] PF0_LTR_CAP_MAX_SNOOP_LAT = 10'h000,
  parameter [3:0] PF0_LTR_CAP_VER = 4'h1,
  parameter PF0_MSI_CAP_PERVECMASKCAP = "FALSE",
  parameter [31:0] PF0_PB_CAP_DATA_REG_D0 = 32'h00000000,
  parameter [31:0] PF0_PB_CAP_DATA_REG_D0_SUSTAINED = 32'h00000000,
  parameter [31:0] PF0_PB_CAP_DATA_REG_D1 = 32'h00000000,
  parameter [31:0] PF0_PB_CAP_DATA_REG_D3HOT = 32'h00000000,
  parameter PF0_PB_CAP_SYSTEM_ALLOCATED = "FALSE",
  parameter [3:0] PF0_PB_CAP_VER = 4'h1,
  parameter [7:0] PF0_PM_CAP_ID = 8'h01,
  parameter [2:0] PF0_PM_CAP_VER_ID = 3'h3,
  parameter PF0_PM_CSR_NOSOFTRESET = "TRUE",
  parameter [3:0] PF0_RBAR_CAP_VER = 4'h1,
  parameter [2:0] PF0_RBAR_CONTROL_INDEX0 = 3'h0,
  parameter [2:0] PF0_RBAR_CONTROL_INDEX1 = 3'h0,
  parameter [2:0] PF0_RBAR_CONTROL_INDEX2 = 3'h0,
  parameter [4:0] PF0_RBAR_CONTROL_SIZE0 = 5'h00,
  parameter [4:0] PF0_RBAR_CONTROL_SIZE1 = 5'h00,
  parameter [4:0] PF0_RBAR_CONTROL_SIZE2 = 5'h00,
  parameter [2:0] PF0_RBAR_NUM = 3'h1,
  parameter PF0_VC_CAP_ENABLE = "FALSE",
  parameter [3:0] PF0_VC_CAP_VER = 4'h1,
  parameter [7:0] PF1_ARI_CAP_NEXT_FUNC = 8'h00,
  parameter [7:0] PF1_BIST_REGISTER = 8'h00,
  parameter [4:0] PF1_DPA_CAP_SUB_STATE_CONTROL = 5'h00,
  parameter PF1_DPA_CAP_SUB_STATE_CONTROL_EN = "TRUE",
  parameter [3:0] PF1_DPA_CAP_VER = 4'h1,
  parameter [7:0] PF1_INTERRUPT_LINE = 8'h00,
  parameter PF1_MSI_CAP_PERVECMASKCAP = "FALSE",
  parameter [31:0] PF1_PB_CAP_DATA_REG_D0 = 32'h00000000,
  parameter [31:0] PF1_PB_CAP_DATA_REG_D0_SUSTAINED = 32'h00000000,
  parameter [31:0] PF1_PB_CAP_DATA_REG_D1 = 32'h00000000,
  parameter [31:0] PF1_PB_CAP_DATA_REG_D3HOT = 32'h00000000,
  parameter PF1_PB_CAP_SYSTEM_ALLOCATED = "FALSE",
  parameter [3:0] PF1_PB_CAP_VER = 4'h1,
  parameter [7:0] PF1_PM_CAP_ID = 8'h01,
  parameter [2:0] PF1_PM_CAP_VER_ID = 3'h3,
  parameter [3:0] PF1_RBAR_CAP_VER = 4'h1,
  parameter [2:0] PF1_RBAR_CONTROL_INDEX0 = 3'h0,
  parameter [2:0] PF1_RBAR_CONTROL_INDEX1 = 3'h0,
  parameter [2:0] PF1_RBAR_CONTROL_INDEX2 = 3'h0,
  parameter [4:0] PF1_RBAR_CONTROL_SIZE0 = 5'h00,
  parameter [4:0] PF1_RBAR_CONTROL_SIZE1 = 5'h00,
  parameter [4:0] PF1_RBAR_CONTROL_SIZE2 = 5'h00,
  parameter [2:0] PF1_RBAR_NUM = 3'h1,
  parameter PF2_AER_CAP_ECRC_CHECK_CAPABLE = "FALSE",
  parameter PF2_AER_CAP_ECRC_GEN_CAPABLE = "FALSE",
  parameter [11:0] PF2_AER_CAP_NEXTPTR = 12'h000,
  parameter [7:0] PF2_ARI_CAP_NEXT_FUNC = 8'h00,
  parameter [11:0] PF2_ARI_CAP_NEXTPTR = 12'h000,
  parameter [5:0] PF2_BAR0_APERTURE_SIZE = 6'h03,
  parameter [2:0] PF2_BAR0_CONTROL = 3'h4,
  parameter [5:0] PF2_BAR1_APERTURE_SIZE = 6'h00,
  parameter [2:0] PF2_BAR1_CONTROL = 3'h0,
  parameter [4:0] PF2_BAR2_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF2_BAR2_CONTROL = 3'h4,
  parameter [4:0] PF2_BAR3_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF2_BAR3_CONTROL = 3'h0,
  parameter [4:0] PF2_BAR4_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF2_BAR4_CONTROL = 3'h4,
  parameter [4:0] PF2_BAR5_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF2_BAR5_CONTROL = 3'h0,
  parameter [7:0] PF2_BIST_REGISTER = 8'h00,
  parameter [7:0] PF2_CAPABILITY_POINTER = 8'h50,
  parameter [23:0] PF2_CLASS_CODE = 24'h000000,
  parameter [2:0] PF2_DEV_CAP_MAX_PAYLOAD_SIZE = 3'h3,
  parameter [15:0] PF2_DEVICE_ID = 16'h0000,
  parameter [11:0] PF2_DPA_CAP_NEXTPTR = 12'h000,
  parameter [4:0] PF2_DPA_CAP_SUB_STATE_CONTROL = 5'h00,
  parameter PF2_DPA_CAP_SUB_STATE_CONTROL_EN = "TRUE",
  parameter [7:0] PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION0 = 8'h00,
  parameter [7:0] PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION1 = 8'h00,
  parameter [7:0] PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION2 = 8'h00,
  parameter [7:0] PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION3 = 8'h00,
  parameter [7:0] PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION4 = 8'h00,
  parameter [7:0] PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION5 = 8'h00,
  parameter [7:0] PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION6 = 8'h00,
  parameter [7:0] PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION7 = 8'h00,
  parameter [3:0] PF2_DPA_CAP_VER = 4'h1,
  parameter [11:0] PF2_DSN_CAP_NEXTPTR = 12'h10c,
  parameter [4:0] PF2_EXPANSION_ROM_APERTURE_SIZE = 5'h03,
  parameter PF2_EXPANSION_ROM_ENABLE = "FALSE",
  parameter [7:0] PF2_INTERRUPT_LINE = 8'h00,
  parameter [2:0] PF2_INTERRUPT_PIN = 3'h1,
  parameter integer PF2_MSI_CAP_MULTIMSGCAP = 0,
  parameter [7:0] PF2_MSI_CAP_NEXTPTR = 8'h00,
  parameter PF2_MSI_CAP_PERVECMASKCAP = "FALSE",
  parameter [7:0] PF2_MSIX_CAP_NEXTPTR = 8'h00,
  parameter integer PF2_MSIX_CAP_PBA_BIR = 0,
  parameter [28:0] PF2_MSIX_CAP_PBA_OFFSET = 29'h00000050,
  parameter integer PF2_MSIX_CAP_TABLE_BIR = 0,
  parameter [28:0] PF2_MSIX_CAP_TABLE_OFFSET = 29'h00000040,
  parameter [10:0] PF2_MSIX_CAP_TABLE_SIZE = 11'h000,
  parameter [31:0] PF2_PB_CAP_DATA_REG_D0 = 32'h00000000,
  parameter [31:0] PF2_PB_CAP_DATA_REG_D0_SUSTAINED = 32'h00000000,
  parameter [31:0] PF2_PB_CAP_DATA_REG_D1 = 32'h00000000,
  parameter [31:0] PF2_PB_CAP_DATA_REG_D3HOT = 32'h00000000,
  parameter [11:0] PF2_PB_CAP_NEXTPTR = 12'h000,
  parameter PF2_PB_CAP_SYSTEM_ALLOCATED = "FALSE",
  parameter [3:0] PF2_PB_CAP_VER = 4'h1,
  parameter [7:0] PF2_PM_CAP_ID = 8'h01,
  parameter [7:0] PF2_PM_CAP_NEXTPTR = 8'h00,
  parameter [2:0] PF2_PM_CAP_VER_ID = 3'h3,
  parameter PF2_RBAR_CAP_ENABLE = "FALSE",
  parameter [11:0] PF2_RBAR_CAP_NEXTPTR = 12'h000,
  parameter [19:0] PF2_RBAR_CAP_SIZE0 = 20'h00000,
  parameter [19:0] PF2_RBAR_CAP_SIZE1 = 20'h00000,
  parameter [19:0] PF2_RBAR_CAP_SIZE2 = 20'h00000,
  parameter [3:0] PF2_RBAR_CAP_VER = 4'h1,
  parameter [2:0] PF2_RBAR_CONTROL_INDEX0 = 3'h0,
  parameter [2:0] PF2_RBAR_CONTROL_INDEX1 = 3'h0,
  parameter [2:0] PF2_RBAR_CONTROL_INDEX2 = 3'h0,
  parameter [4:0] PF2_RBAR_CONTROL_SIZE0 = 5'h00,
  parameter [4:0] PF2_RBAR_CONTROL_SIZE1 = 5'h00,
  parameter [4:0] PF2_RBAR_CONTROL_SIZE2 = 5'h00,
  parameter [2:0] PF2_RBAR_NUM = 3'h1,
  parameter [7:0] PF2_REVISION_ID = 8'h00,
  parameter [4:0] PF2_SRIOV_BAR0_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF2_SRIOV_BAR0_CONTROL = 3'h4,
  parameter [4:0] PF2_SRIOV_BAR1_APERTURE_SIZE = 5'h00,
  parameter [2:0] PF2_SRIOV_BAR1_CONTROL = 3'h0,
  parameter [4:0] PF2_SRIOV_BAR2_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF2_SRIOV_BAR2_CONTROL = 3'h4,
  parameter [4:0] PF2_SRIOV_BAR3_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF2_SRIOV_BAR3_CONTROL = 3'h0,
  parameter [4:0] PF2_SRIOV_BAR4_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF2_SRIOV_BAR4_CONTROL = 3'h4,
  parameter [4:0] PF2_SRIOV_BAR5_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF2_SRIOV_BAR5_CONTROL = 3'h0,
  parameter [15:0] PF2_SRIOV_CAP_INITIAL_VF = 16'h0000,
  parameter [11:0] PF2_SRIOV_CAP_NEXTPTR = 12'h000,
  parameter [15:0] PF2_SRIOV_CAP_TOTAL_VF = 16'h0000,
  parameter [3:0] PF2_SRIOV_CAP_VER = 4'h1,
  parameter [15:0] PF2_SRIOV_FIRST_VF_OFFSET = 16'h0000,
  parameter [15:0] PF2_SRIOV_FUNC_DEP_LINK = 16'h0000,
  parameter [31:0] PF2_SRIOV_SUPPORTED_PAGE_SIZE = 32'h00000000,
  parameter [15:0] PF2_SRIOV_VF_DEVICE_ID = 16'h0000,
  parameter [15:0] PF2_SUBSYSTEM_ID = 16'h0000,
  parameter PF2_TPHR_CAP_DEV_SPECIFIC_MODE = "TRUE",
  parameter PF2_TPHR_CAP_ENABLE = "FALSE",
  parameter PF2_TPHR_CAP_INT_VEC_MODE = "TRUE",
  parameter [11:0] PF2_TPHR_CAP_NEXTPTR = 12'h000,
  parameter [2:0] PF2_TPHR_CAP_ST_MODE_SEL = 3'h0,
  parameter [1:0] PF2_TPHR_CAP_ST_TABLE_LOC = 2'h0,
  parameter [10:0] PF2_TPHR_CAP_ST_TABLE_SIZE = 11'h000,
  parameter [3:0] PF2_TPHR_CAP_VER = 4'h1,
  parameter PF3_AER_CAP_ECRC_CHECK_CAPABLE = "FALSE",
  parameter PF3_AER_CAP_ECRC_GEN_CAPABLE = "FALSE",
  parameter [11:0] PF3_AER_CAP_NEXTPTR = 12'h000,
  parameter [7:0] PF3_ARI_CAP_NEXT_FUNC = 8'h00,
  parameter [11:0] PF3_ARI_CAP_NEXTPTR = 12'h000,
  parameter [5:0] PF3_BAR0_APERTURE_SIZE = 6'h03,
  parameter [2:0] PF3_BAR0_CONTROL = 3'h4,
  parameter [5:0] PF3_BAR1_APERTURE_SIZE = 6'h00,
  parameter [2:0] PF3_BAR1_CONTROL = 3'h0,
  parameter [4:0] PF3_BAR2_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF3_BAR2_CONTROL = 3'h4,
  parameter [4:0] PF3_BAR3_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF3_BAR3_CONTROL = 3'h0,
  parameter [4:0] PF3_BAR4_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF3_BAR4_CONTROL = 3'h4,
  parameter [4:0] PF3_BAR5_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF3_BAR5_CONTROL = 3'h0,
  parameter [7:0] PF3_BIST_REGISTER = 8'h00,
  parameter [7:0] PF3_CAPABILITY_POINTER = 8'h50,
  parameter [23:0] PF3_CLASS_CODE = 24'h000000,
  parameter [2:0] PF3_DEV_CAP_MAX_PAYLOAD_SIZE = 3'h3,
  parameter [15:0] PF3_DEVICE_ID = 16'h0000,
  parameter [11:0] PF3_DPA_CAP_NEXTPTR = 12'h000,
  parameter [4:0] PF3_DPA_CAP_SUB_STATE_CONTROL = 5'h00,
  parameter PF3_DPA_CAP_SUB_STATE_CONTROL_EN = "TRUE",
  parameter [7:0] PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION0 = 8'h00,
  parameter [7:0] PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION1 = 8'h00,
  parameter [7:0] PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION2 = 8'h00,
  parameter [7:0] PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION3 = 8'h00,
  parameter [7:0] PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION4 = 8'h00,
  parameter [7:0] PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION5 = 8'h00,
  parameter [7:0] PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION6 = 8'h00,
  parameter [7:0] PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION7 = 8'h00,
  parameter [3:0] PF3_DPA_CAP_VER = 4'h1,
  parameter [11:0] PF3_DSN_CAP_NEXTPTR = 12'h10c,
  parameter [4:0] PF3_EXPANSION_ROM_APERTURE_SIZE = 5'h03,
  parameter PF3_EXPANSION_ROM_ENABLE = "FALSE",
  parameter [7:0] PF3_INTERRUPT_LINE = 8'h00,
  parameter [2:0] PF3_INTERRUPT_PIN = 3'h1,
  parameter integer PF3_MSI_CAP_MULTIMSGCAP = 0,
  parameter [7:0] PF3_MSI_CAP_NEXTPTR = 8'h00,
  parameter PF3_MSI_CAP_PERVECMASKCAP = "FALSE",
  parameter [7:0] PF3_MSIX_CAP_NEXTPTR = 8'h00,
  parameter integer PF3_MSIX_CAP_PBA_BIR = 0,
  parameter [28:0] PF3_MSIX_CAP_PBA_OFFSET = 29'h00000050,
  parameter integer PF3_MSIX_CAP_TABLE_BIR = 0,
  parameter [28:0] PF3_MSIX_CAP_TABLE_OFFSET = 29'h00000040,
  parameter [10:0] PF3_MSIX_CAP_TABLE_SIZE = 11'h000,
  parameter [31:0] PF3_PB_CAP_DATA_REG_D0 = 32'h00000000,
  parameter [31:0] PF3_PB_CAP_DATA_REG_D0_SUSTAINED = 32'h00000000,
  parameter [31:0] PF3_PB_CAP_DATA_REG_D1 = 32'h00000000,
  parameter [31:0] PF3_PB_CAP_DATA_REG_D3HOT = 32'h00000000,
  parameter [11:0] PF3_PB_CAP_NEXTPTR = 12'h000,
  parameter PF3_PB_CAP_SYSTEM_ALLOCATED = "FALSE",
  parameter [3:0] PF3_PB_CAP_VER = 4'h1,
  parameter [7:0] PF3_PM_CAP_ID = 8'h01,
  parameter [7:0] PF3_PM_CAP_NEXTPTR = 8'h00,
  parameter [2:0] PF3_PM_CAP_VER_ID = 3'h3,
  parameter PF3_RBAR_CAP_ENABLE = "FALSE",
  parameter [11:0] PF3_RBAR_CAP_NEXTPTR = 12'h000,
  parameter [19:0] PF3_RBAR_CAP_SIZE0 = 20'h00000,
  parameter [19:0] PF3_RBAR_CAP_SIZE1 = 20'h00000,
  parameter [19:0] PF3_RBAR_CAP_SIZE2 = 20'h00000,
  parameter [3:0] PF3_RBAR_CAP_VER = 4'h1,
  parameter [2:0] PF3_RBAR_CONTROL_INDEX0 = 3'h0,
  parameter [2:0] PF3_RBAR_CONTROL_INDEX1 = 3'h0,
  parameter [2:0] PF3_RBAR_CONTROL_INDEX2 = 3'h0,
  parameter [4:0] PF3_RBAR_CONTROL_SIZE0 = 5'h00,
  parameter [4:0] PF3_RBAR_CONTROL_SIZE1 = 5'h00,
  parameter [4:0] PF3_RBAR_CONTROL_SIZE2 = 5'h00,
  parameter [2:0] PF3_RBAR_NUM = 3'h1,
  parameter [7:0] PF3_REVISION_ID = 8'h00,
  parameter [4:0] PF3_SRIOV_BAR0_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF3_SRIOV_BAR0_CONTROL = 3'h4,
  parameter [4:0] PF3_SRIOV_BAR1_APERTURE_SIZE = 5'h00,
  parameter [2:0] PF3_SRIOV_BAR1_CONTROL = 3'h0,
  parameter [4:0] PF3_SRIOV_BAR2_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF3_SRIOV_BAR2_CONTROL = 3'h4,
  parameter [4:0] PF3_SRIOV_BAR3_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF3_SRIOV_BAR3_CONTROL = 3'h0,
  parameter [4:0] PF3_SRIOV_BAR4_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF3_SRIOV_BAR4_CONTROL = 3'h4,
  parameter [4:0] PF3_SRIOV_BAR5_APERTURE_SIZE = 5'h03,
  parameter [2:0] PF3_SRIOV_BAR5_CONTROL = 3'h0,
  parameter [15:0] PF3_SRIOV_CAP_INITIAL_VF = 16'h0000,
  parameter [11:0] PF3_SRIOV_CAP_NEXTPTR = 12'h000,
  parameter [15:0] PF3_SRIOV_CAP_TOTAL_VF = 16'h0000,
  parameter [3:0] PF3_SRIOV_CAP_VER = 4'h1,
  parameter [15:0] PF3_SRIOV_FIRST_VF_OFFSET = 16'h0000,
  parameter [15:0] PF3_SRIOV_FUNC_DEP_LINK = 16'h0000,
  parameter [31:0] PF3_SRIOV_SUPPORTED_PAGE_SIZE = 32'h00000000,
  parameter [15:0] PF3_SRIOV_VF_DEVICE_ID = 16'h0000,
  parameter [15:0] PF3_SUBSYSTEM_ID = 16'h0000,
  parameter PF3_TPHR_CAP_DEV_SPECIFIC_MODE = "TRUE",
  parameter PF3_TPHR_CAP_ENABLE = "FALSE",
  parameter PF3_TPHR_CAP_INT_VEC_MODE = "TRUE",
  parameter [11:0] PF3_TPHR_CAP_NEXTPTR = 12'h000,
  parameter [2:0] PF3_TPHR_CAP_ST_MODE_SEL = 3'h0,
  parameter [1:0] PF3_TPHR_CAP_ST_TABLE_LOC = 2'h0,
  parameter [10:0] PF3_TPHR_CAP_ST_TABLE_SIZE = 11'h000,
  parameter [3:0] PF3_TPHR_CAP_VER = 4'h1,
  parameter PL_DISABLE_AUTO_EQ_SPEED_CHANGE_TO_GEN3 = "FALSE",
  parameter PL_DISABLE_AUTO_SPEED_CHANGE_TO_GEN2 = "FALSE",
  parameter PL_DISABLE_EI_INFER_IN_L0 = "FALSE",
  parameter PL_DISABLE_GEN3_DC_BALANCE = "FALSE",
  parameter PL_DISABLE_GEN3_LFSR_UPDATE_ON_SKP = "TRUE",
  parameter PL_DISABLE_RETRAIN_ON_FRAMING_ERROR = "FALSE",
  parameter PL_DISABLE_SCRAMBLING = "FALSE",
  parameter PL_DISABLE_SYNC_HEADER_FRAMING_ERROR = "FALSE",
  parameter PL_DISABLE_UPCONFIG_CAPABLE = "FALSE",
  parameter PL_EQ_ADAPT_DISABLE_COEFF_CHECK = "FALSE",
  parameter PL_EQ_ADAPT_DISABLE_PRESET_CHECK = "FALSE",
  parameter [4:0] PL_EQ_ADAPT_ITER_COUNT = 5'h02,
  parameter [1:0] PL_EQ_ADAPT_REJECT_RETRY_COUNT = 2'h1,
  parameter PL_EQ_BYPASS_PHASE23 = "FALSE",
  parameter [2:0] PL_EQ_DEFAULT_GEN3_RX_PRESET_HINT = 3'h3,
  parameter [3:0] PL_EQ_DEFAULT_GEN3_TX_PRESET = 4'h4,
  parameter PL_EQ_PHASE01_RX_ADAPT = "FALSE",
  parameter PL_EQ_SHORT_ADAPT_PHASE = "FALSE",
  parameter [15:0] PL_LANE0_EQ_CONTROL = 16'h3400,
  parameter [15:0] PL_LANE1_EQ_CONTROL = 16'h3400,
  parameter [15:0] PL_LANE2_EQ_CONTROL = 16'h3400,
  parameter [15:0] PL_LANE3_EQ_CONTROL = 16'h3400,
  parameter [15:0] PL_LANE4_EQ_CONTROL = 16'h3400,
  parameter [15:0] PL_LANE5_EQ_CONTROL = 16'h3400,
  parameter [15:0] PL_LANE6_EQ_CONTROL = 16'h3400,
  parameter [15:0] PL_LANE7_EQ_CONTROL = 16'h3400,
  parameter integer PL_N_FTS_COMCLK_GEN1 = 255,
  parameter integer PL_N_FTS_COMCLK_GEN2 = 255,
  parameter integer PL_N_FTS_COMCLK_GEN3 = 255,
  parameter integer PL_N_FTS_GEN1 = 255,
  parameter integer PL_N_FTS_GEN2 = 255,
  parameter integer PL_N_FTS_GEN3 = 255,
  parameter PL_REPORT_ALL_PHY_ERRORS = "TRUE",
  parameter PL_SIM_FAST_LINK_TRAINING = "TRUE",
  parameter [15:0] PM_ASPML0S_TIMEOUT = 16'h05dc,
  parameter [19:0] PM_ASPML1_ENTRY_DELAY = 20'h01D4C,
  parameter PM_ENABLE_SLOT_POWER_CAPTURE = "TRUE",
  parameter [31:0] PM_L1_REENTRY_DELAY = 32'h000061A8,
  parameter [19:0] PM_PME_SERVICE_TIMEOUT_DELAY = 20'h186a0,
  parameter [15:0] PM_PME_TURNOFF_ACK_DELAY = 16'h0064,
  parameter SIM_JTAG_IDCODE = 32'h00000000,
  parameter SIM_VERSION = "1.0",
  parameter integer SPARE_BIT0 = 0,
  parameter integer SPARE_BIT1 = 0,
  parameter integer SPARE_BIT2 = 0,
  parameter integer SPARE_BIT3 = 0,
  parameter integer SPARE_BIT4 = 0,
  parameter integer SPARE_BIT5 = 0,
  parameter integer SPARE_BIT6 = 0,
  parameter integer SPARE_BIT7 = 0,
  parameter integer SPARE_BIT8 = 0,
  parameter [7:0] SPARE_BYTE0 = 8'h00,
  parameter [7:0] SPARE_BYTE1 = 8'h00,
  parameter [7:0] SPARE_BYTE2 = 8'h00,
  parameter [7:0] SPARE_BYTE3 = 8'h00,
  parameter [31:0] SPARE_WORD0 = 32'h00000000,
  parameter [31:0] SPARE_WORD2 = 32'h00000000,
  parameter [31:0] SPARE_WORD3 = 32'h00000000,
  parameter [23:0] TL_COMPL_TIMEOUT_REG0 = 24'hbebc20,
  parameter [27:0] TL_COMPL_TIMEOUT_REG1 = 28'h2faf080,
  parameter TL_ENABLE_MESSAGE_RID_CHECK_ENABLE = "TRUE",
  parameter TL_LEGACY_CFG_EXTEND_INTERFACE_ENABLE = "FALSE",
  parameter TL_TX_MUX_STRICT_PRIORITY = "TRUE",
  parameter TWO_LAYER_MODE_DLCMSM_ENABLE = "TRUE",
  parameter TWO_LAYER_MODE_ENABLE = "FALSE",
  parameter TWO_LAYER_MODE_WIDTH_256 = "TRUE",
  parameter [7:0] VF0_PM_CAP_ID = 8'h01,
  parameter [2:0] VF0_PM_CAP_VER_ID = 3'h3,
  parameter VF0_TPHR_CAP_ENABLE = "FALSE",
  parameter [7:0] VF1_PM_CAP_ID = 8'h01,
  parameter [2:0] VF1_PM_CAP_VER_ID = 3'h3,
  parameter VF1_TPHR_CAP_ENABLE = "FALSE",
  parameter [7:0] VF2_PM_CAP_ID = 8'h01,
  parameter [2:0] VF2_PM_CAP_VER_ID = 3'h3,
  parameter VF2_TPHR_CAP_ENABLE = "FALSE",
  parameter [7:0] VF3_PM_CAP_ID = 8'h01,
  parameter [2:0] VF3_PM_CAP_VER_ID = 3'h3,
  parameter VF3_TPHR_CAP_ENABLE = "FALSE",
  parameter [7:0] VF4_PM_CAP_ID = 8'h01,
  parameter [2:0] VF4_PM_CAP_VER_ID = 3'h3,
  parameter VF4_TPHR_CAP_ENABLE = "FALSE",
  parameter [7:0] VF5_PM_CAP_ID = 8'h01,
  parameter [2:0] VF5_PM_CAP_VER_ID = 3'h3,
  parameter VF5_TPHR_CAP_ENABLE = "FALSE",
  parameter [11:0] VF6_ARI_CAP_NEXTPTR = 12'h000,
  parameter integer VF6_MSI_CAP_MULTIMSGCAP = 0,
  parameter integer VF6_MSIX_CAP_PBA_BIR = 0,
  parameter [28:0] VF6_MSIX_CAP_PBA_OFFSET = 29'h00000050,
  parameter integer VF6_MSIX_CAP_TABLE_BIR = 0,
  parameter [28:0] VF6_MSIX_CAP_TABLE_OFFSET = 29'h00000040,
  parameter [10:0] VF6_MSIX_CAP_TABLE_SIZE = 11'h000,
  parameter [7:0] VF6_PM_CAP_ID = 8'h01,
  parameter [7:0] VF6_PM_CAP_NEXTPTR = 8'h00,
  parameter [2:0] VF6_PM_CAP_VER_ID = 3'h3,
  parameter VF6_TPHR_CAP_DEV_SPECIFIC_MODE = "TRUE",
  parameter VF6_TPHR_CAP_ENABLE = "FALSE",
  parameter VF6_TPHR_CAP_INT_VEC_MODE = "TRUE",
  parameter [11:0] VF6_TPHR_CAP_NEXTPTR = 12'h000,
  parameter [2:0] VF6_TPHR_CAP_ST_MODE_SEL = 3'h0,
  parameter [1:0] VF6_TPHR_CAP_ST_TABLE_LOC = 2'h0,
  parameter [10:0] VF6_TPHR_CAP_ST_TABLE_SIZE = 11'h000,
  parameter [3:0] VF6_TPHR_CAP_VER = 4'h1,
  parameter [11:0] VF7_ARI_CAP_NEXTPTR = 12'h000,
  parameter integer VF7_MSI_CAP_MULTIMSGCAP = 0,
  parameter integer VF7_MSIX_CAP_PBA_BIR = 0,
  parameter [28:0] VF7_MSIX_CAP_PBA_OFFSET = 29'h00000050,
  parameter integer VF7_MSIX_CAP_TABLE_BIR = 0,
  parameter [28:0] VF7_MSIX_CAP_TABLE_OFFSET = 29'h00000040,
  parameter [10:0] VF7_MSIX_CAP_TABLE_SIZE = 11'h000,
  parameter [7:0] VF7_PM_CAP_ID = 8'h01,
  parameter [7:0] VF7_PM_CAP_NEXTPTR = 8'h00,
  parameter [2:0] VF7_PM_CAP_VER_ID = 3'h3,
  parameter VF7_TPHR_CAP_DEV_SPECIFIC_MODE = "TRUE",
  parameter VF7_TPHR_CAP_ENABLE = "FALSE",
  parameter VF7_TPHR_CAP_INT_VEC_MODE = "TRUE",
  parameter [11:0] VF7_TPHR_CAP_NEXTPTR = 12'h000,
  parameter [2:0] VF7_TPHR_CAP_ST_MODE_SEL = 3'h0,
  parameter [1:0] VF7_TPHR_CAP_ST_TABLE_LOC = 2'h0,
  parameter [10:0] VF7_TPHR_CAP_ST_TABLE_SIZE = 11'h000,
  parameter [3:0] VF7_TPHR_CAP_VER = 4'h1,
  parameter EXT_PIPE_SIM = "FALSE",  // This Parameter has effect on running PIPE simulation by dis-connecting GTs and synthesis by connecting GTs.
  parameter PCIE_EXT_CLK = "FALSE",
  parameter PCIE_TXBUF_EN = "FALSE",
  parameter PCIE_GT_DEVICE = "GTH",
  parameter PCIE_CHAN_BOND = 0,
  parameter PCIE_CHAN_BOND_EN = "FALSE",
  parameter PCIE_LPM_DFE = "LPM",
  parameter TCQ = 100,
  parameter NO_DECODE_LOGIC  = "FALSE",
  parameter INTERFACE_SPEED  = "500MHZ", 
  parameter integer GT_DRP_CLK_SRC = 1,
    parameter integer FREE_RUN_FREQ = 1
  ) (
  output wire [(PL_LINK_CAP_MAX_LINK_WIDTH-1):0] pci_exp_txn,
  output wire [(PL_LINK_CAP_MAX_LINK_WIDTH-1):0] pci_exp_txp,
  input  wire [(PL_LINK_CAP_MAX_LINK_WIDTH-1):0] pci_exp_rxn,
  input  wire [(PL_LINK_CAP_MAX_LINK_WIDTH-1):0] pci_exp_rxp,
  output wire         user_clk,
  output reg          user_reset,
  output reg          user_lnk_up,
  input         [2:0] gt_tx_powerdown,
  input  wire [C_DATA_WIDTH-1:0] s_axis_rq_tdata,
  input  wire [KEEP_WIDTH-1:0] s_axis_rq_tkeep,
  input  wire         s_axis_rq_tlast,
  output wire   [3:0] s_axis_rq_tready,
  input  wire  [59:0] s_axis_rq_tuser,
  input  wire         s_axis_rq_tvalid,
  output wire [C_DATA_WIDTH-1:0] m_axis_rc_tdata,
  output wire [KEEP_WIDTH-1:0] m_axis_rc_tkeep,
  output wire         m_axis_rc_tlast,
  input  wire         m_axis_rc_tready,
  output wire  [74:0] m_axis_rc_tuser,
  output wire         m_axis_rc_tvalid,
  output wire [C_DATA_WIDTH-1:0] m_axis_cq_tdata,
  output wire [KEEP_WIDTH-1:0] m_axis_cq_tkeep,
  output wire         m_axis_cq_tlast,
  input  wire         m_axis_cq_tready,
  output wire  [84:0] m_axis_cq_tuser,
  output wire         m_axis_cq_tvalid,
  input  wire [C_DATA_WIDTH-1:0] s_axis_cc_tdata,
  input  wire [KEEP_WIDTH-1:0] s_axis_cc_tkeep,
  input  wire         s_axis_cc_tlast,
  output wire   [3:0] s_axis_cc_tready,
  input  wire  [32:0] s_axis_cc_tuser,
  input  wire         s_axis_cc_tvalid,
  output wire   [3:0] pcie_rq_seq_num,
  output wire         pcie_rq_seq_num_vld,
  output wire   [5:0] pcie_rq_tag,
  output wire   [1:0] pcie_rq_tag_av,
  output wire         pcie_rq_tag_vld,
  output wire   [1:0] pcie_tfc_nph_av,
  output wire   [1:0] pcie_tfc_npd_av,
  input  wire         pcie_cq_np_req,
  output wire   [5:0] pcie_cq_np_req_count,
  output wire         cfg_phy_link_down,
  output wire   [1:0] cfg_phy_link_status,
  output wire   [3:0] cfg_negotiated_width,
  output wire   [2:0] cfg_current_speed,
  output wire   [2:0] cfg_max_payload,
  output wire   [2:0] cfg_max_read_req,
  output wire  [15:0] cfg_function_status,
  output wire  [11:0] cfg_function_power_state,
  output wire  [15:0] cfg_vf_status,
  output wire  [23:0] cfg_vf_power_state,
  output wire   [1:0] cfg_link_power_state,
  input  wire  [18:0] cfg_mgmt_addr,
  input  wire         cfg_mgmt_write,
  input  wire  [31:0] cfg_mgmt_write_data,
  input  wire   [3:0] cfg_mgmt_byte_enable,
  input  wire         cfg_mgmt_read,
  output wire  [31:0] cfg_mgmt_read_data,
  output wire         cfg_mgmt_read_write_done,
  input  wire         cfg_mgmt_type1_cfg_reg_access,
  output wire         cfg_err_cor_out,
  output wire         cfg_err_nonfatal_out,
  output wire         cfg_err_fatal_out,
  output wire         cfg_local_error,
  output wire         cfg_ltr_enable,
  output wire   [5:0] cfg_ltssm_state,
  output wire   [3:0] cfg_rcb_status,
  output wire   [3:0] cfg_dpa_substate_change,
  output wire   [1:0] cfg_obff_enable,
  output wire         cfg_pl_status_change,
  output wire   [3:0] cfg_tph_requester_enable,
  output wire  [11:0] cfg_tph_st_mode,
  output wire   [7:0] cfg_vf_tph_requester_enable,
  output wire  [23:0] cfg_vf_tph_st_mode,
  output wire         cfg_msg_received,
  output wire   [7:0] cfg_msg_received_data,
  output wire   [4:0] cfg_msg_received_type,
  input  wire         cfg_msg_transmit,
  input  wire   [2:0] cfg_msg_transmit_type,
  input  wire  [31:0] cfg_msg_transmit_data,
  output wire         cfg_msg_transmit_done,
  output wire   [7:0] cfg_fc_ph,
  output wire  [11:0] cfg_fc_pd,
  output wire   [7:0] cfg_fc_nph,
  output wire  [11:0] cfg_fc_npd,
  output wire   [7:0] cfg_fc_cplh,
  output wire  [11:0] cfg_fc_cpld,
  input  wire   [2:0] cfg_fc_sel,
  input  wire   [2:0] cfg_per_func_status_control,
  output wire  [15:0] cfg_per_func_status_data,
  input  wire   [3:0] cfg_per_function_number,
  input  wire         cfg_per_function_output_request,
  output wire         cfg_per_function_update_done,
  input  wire  [63:0] cfg_dsn,
  input  wire         cfg_power_state_change_ack,
  output wire         cfg_power_state_change_interrupt,
  input  wire         cfg_err_cor_in,
  input  wire         cfg_err_uncor_in,
  output wire   [3:0] cfg_flr_in_process,
  input  wire   [3:0] cfg_flr_done,
  output wire   [7:0] cfg_vf_flr_in_process,
  input  wire   [7:0] cfg_vf_flr_done,
  input  wire         cfg_link_training_enable,
  output wire         cfg_ext_read_received,
  output wire         cfg_ext_write_received,
  output wire   [9:0] cfg_ext_register_number,
  output wire   [7:0] cfg_ext_function_number,
  output wire  [31:0] cfg_ext_write_data,
  output wire   [3:0] cfg_ext_write_byte_enable,
  input  wire  [31:0] cfg_ext_read_data,
  input  wire         cfg_ext_read_data_valid,
  input  wire   [3:0] cfg_interrupt_int,
  input  wire   [3:0] cfg_interrupt_pending,
  output wire         cfg_interrupt_sent,
  output wire   [3:0] cfg_interrupt_msi_enable,
  output wire   [7:0] cfg_interrupt_msi_vf_enable,
  output wire  [11:0] cfg_interrupt_msi_mmenable,
  output wire         cfg_interrupt_msi_mask_update,
  output wire  [31:0] cfg_interrupt_msi_data,
  input  wire   [3:0] cfg_interrupt_msi_select,
  input  wire  [31:0] cfg_interrupt_msi_int,
  input  wire  [31:0] cfg_interrupt_msi_pending_status,
  input  wire         cfg_interrupt_msi_pending_status_data_enable,
  input  wire   [3:0] cfg_interrupt_msi_pending_status_function_num,
  output wire         cfg_interrupt_msi_sent,
  output wire         cfg_interrupt_msi_fail,
  output wire   [3:0] cfg_interrupt_msix_enable,
  output wire   [3:0] cfg_interrupt_msix_mask,
  output wire   [7:0] cfg_interrupt_msix_vf_enable,
  output wire   [7:0] cfg_interrupt_msix_vf_mask,
  input  wire  [31:0] cfg_interrupt_msix_data,
  input  wire  [63:0] cfg_interrupt_msix_address,
  input  wire         cfg_interrupt_msix_int,
  output wire         cfg_interrupt_msix_sent,
  output wire         cfg_interrupt_msix_fail,
  input  wire   [2:0] cfg_interrupt_msi_attr,
  input  wire         cfg_interrupt_msi_tph_present,
  input  wire   [1:0] cfg_interrupt_msi_tph_type,
  input  wire   [8:0] cfg_interrupt_msi_tph_st_tag,
  input  wire   [3:0] cfg_interrupt_msi_function_number,
  output wire         cfg_hot_reset_out,
  input  wire         cfg_config_space_enable,
  input  wire         cfg_req_pm_transition_l23_ready,
  input  wire         cfg_hot_reset_in,
  input  wire   [7:0] cfg_ds_port_number,
  input  wire   [7:0] cfg_ds_bus_number,
  input  wire   [4:0] cfg_ds_device_number,
  input  wire   [2:0] cfg_ds_function_number,
  input  wire  [15:0] cfg_subsys_vend_id,
  output wire         drp_rdy,
  output wire  [15:0] drp_do,
  input  wire         drp_clk,
  input  wire         drp_en,
  input  wire         drp_we,
  input  wire   [9:0] drp_addr,
  input  wire  [15:0] drp_di,
  input  wire   [4:0] user_tph_stt_address,
  input  wire   [3:0] user_tph_function_num,
  output wire  [31:0] user_tph_stt_read_data,
  output wire         user_tph_stt_read_data_valid,
  input  wire         user_tph_stt_read_enable,
  input  wire         sys_clk,
  input  wire         sys_clk_gt,
  input  wire         sys_reset,
//---- PIPE Ports to Core Top Level for PIPE Mode Simulation with 3rd Party IP/BFM/Xilinx BFM ------------------------
  input  wire  [25:0] common_commands_in,
  input  wire [83:0]  pipe_rx_0_sigs,
  input  wire [83:0]  pipe_rx_1_sigs,
  input  wire [83:0]  pipe_rx_2_sigs,
  input  wire [83:0]  pipe_rx_3_sigs,
  input  wire [83:0]  pipe_rx_4_sigs,
  input  wire [83:0]  pipe_rx_5_sigs,
  input  wire [83:0]  pipe_rx_6_sigs,
  input  wire [83:0]  pipe_rx_7_sigs,
                      
  output wire [25:0]  common_commands_out,
  output wire [83:0]  pipe_tx_0_sigs,
  output wire [83:0]  pipe_tx_1_sigs,
  output wire [83:0]  pipe_tx_2_sigs,
  output wire [83:0]  pipe_tx_3_sigs,
  output wire [83:0]  pipe_tx_4_sigs,
  output wire [83:0]  pipe_tx_5_sigs,
  output wire [83:0]  pipe_tx_6_sigs,
  output wire [83:0]  pipe_tx_7_sigs,

   //---------- Shared Logic Internal -------------------------
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2):0] int_qpll1lock_out,   
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2):0] int_qpll1outrefclk_out,
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2):0] int_qpll1outclk_out,
    //---------- External GT COMMON Ports ----------------------
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2):0] ext_qpll1refclk,
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2):0] ext_qpll1pd,
  output wire [((((PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2)+1)*3)-1:0] ext_qpll1rate,
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2):0] ext_qpll1reset,

  input wire  [((PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2):0] ext_qpll1lock_out,
  input wire  [((PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2):0] ext_qpll1outclk_out,
  input wire  [((PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2):0] ext_qpll1outrefclk_out,
  //--------------------------------------------------------------------------
  //  GT Debug Ports
  //--------------------------------------------------------------------------
  output wire                                           ext_ch_gt_drpclk,
  input  wire [((PL_LINK_CAP_MAX_LINK_WIDTH *  9)-1):0] ext_ch_gt_drpaddr,
  input  wire [((PL_LINK_CAP_MAX_LINK_WIDTH *  1)-1):0] ext_ch_gt_drpen,
  input  wire [((PL_LINK_CAP_MAX_LINK_WIDTH *  1)-1):0] ext_ch_gt_drpwe,
  input  wire [((PL_LINK_CAP_MAX_LINK_WIDTH * 16)-1):0] ext_ch_gt_drpdi,
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH *  1)-1):0] ext_ch_gt_drprdy,
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH * 16)-1):0] ext_ch_gt_drpdo,
 //--------------------------------------------------------------------------
 //  Transceiver Debug And Status Ports
 //--------------------------------------------------------------------------
  input wire  [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_pcieuserratedone ,
  input wire  [((PL_LINK_CAP_MAX_LINK_WIDTH*3)-1):0] gt_loopback         ,
  input wire  [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_txprbsforceerr   ,
  input wire  [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_txinhibit        ,
  input wire  [((PL_LINK_CAP_MAX_LINK_WIDTH*4)-1):0] gt_txprbssel        ,
  input wire  [((PL_LINK_CAP_MAX_LINK_WIDTH*4)-1):0] gt_rxprbssel        ,
  input wire  [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_rxprbscntreset   ,

  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_txelecidle       ,             
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_txresetdone      ,    
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_rxresetdone      ,        
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_rxpmaresetdone   ,      
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_txphaligndone    ,            
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_txphinitdone     ,         
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_txdlysresetdone  ,         
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_rxphaligndone    ,        
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_rxdlysresetdone  ,          
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_rxsyncdone       ,        
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_eyescandataerror ,               
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_rxprbserr        ,           
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*17)-1):0] gt_dmonitorout     ,             
  input wire  [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_dmonfiforeset    ,
  input wire  [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_dmonitorclk      ,
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_rxcommadet       ,                   
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_phystatus        ,                   
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_rxvalid          ,              
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_rxcdrlock        ,         
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_pcierateidle     ,
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_pcieuserratestart,
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_gtpowergood      ,  
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_cplllock         ,              
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_rxoutclk         , 
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_rxrecclkout      ,
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2):0] gt_qpll1lock       ,            
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*3)-1):0] gt_rxstatus         ,            
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*3)-1):0] gt_rxbufstatus      ,            
  output wire [8:0]                                  gt_bufgtdiv         ,                 
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*2)-1):0] phy_txeq_ctrl       ,                  
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*4)-1):0] phy_txeq_preset     ,                   
  output wire [3:0]                                  phy_rst_fsm         ,                 
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*3)-1):0] phy_txeq_fsm        ,                  
  output wire [((PL_LINK_CAP_MAX_LINK_WIDTH*3)-1):0] phy_rxeq_fsm        ,                 
  output wire                                        phy_rst_idle        ,                              
  output wire                                        phy_rrst_n          ,
  output wire                                        phy_prst_n          ,
  input  wire                                       free_run_clock       ,
 //--------------------------------------------------------------------------
 //  GT WIZARD IP is not in the PCIe core
 //--------------------------------------------------------------------------
 input [(PL_LINK_CAP_MAX_LINK_WIDTH* 3)-1:0]    bufgtce_out ,
 input [(PL_LINK_CAP_MAX_LINK_WIDTH* 3)-1:0]    bufgtcemask_out ,
 input [(PL_LINK_CAP_MAX_LINK_WIDTH* 9)-1:0]    bufgtdiv_out ,
 input [(PL_LINK_CAP_MAX_LINK_WIDTH* 3)-1:0]    bufgtreset_out ,
 input [(PL_LINK_CAP_MAX_LINK_WIDTH* 3)-1:0]    bufgtrstmask_out ,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         cplllock_out,  
 input [(PL_LINK_CAP_MAX_LINK_WIDTH*17)-1:0]    dmonitorout_out,
 input [(PL_LINK_CAP_MAX_LINK_WIDTH* 16)-1:0]   drpdo_out,
 input [(PL_LINK_CAP_MAX_LINK_WIDTH* 1)-1:0]    drprdy_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         eyescandataerror_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         gthtxn_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         gthtxp_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         gtpowergood_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         pcierategen3_out,  
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         pcierateidle_out,       
 input [(PL_LINK_CAP_MAX_LINK_WIDTH*2)-1:0]     pcierateqpllpd_out,              
 input [(PL_LINK_CAP_MAX_LINK_WIDTH*2)-1:0]     pcierateqpllreset_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         pciesynctxsyncdone_out,                      
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         pcieusergen3rdy_out, 
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         pcieuserphystatusrst_out,  
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         pcieuserratestart_out,  
 input [(PL_LINK_CAP_MAX_LINK_WIDTH*12)-1:0]    pcsrsvdout_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         phystatus_out,
 input [(PL_LINK_CAP_MAX_LINK_WIDTH*3)-1:0]     rxbufstatus_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0]       rxbyteisaligned_out, 
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0]       rxbyterealign_out, 
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxcdrlock_out,                                                          
 input [(PL_LINK_CAP_MAX_LINK_WIDTH * 2)-1 : 0] rxclkcorcnt_out, 
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxcommadet_out,
 input [(PL_LINK_CAP_MAX_LINK_WIDTH*16)-1:0]    rxctrl0_out,  
 input [(PL_LINK_CAP_MAX_LINK_WIDTH*16)-1:0]    rxctrl1_out,  
 input [(PL_LINK_CAP_MAX_LINK_WIDTH*8)-1:0]     rxctrl2_out,  
 input [(PL_LINK_CAP_MAX_LINK_WIDTH*8)-1:0]     rxctrl3_out,  
 input [(PL_LINK_CAP_MAX_LINK_WIDTH*128)-1:0]   rxdata_out,  

    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfeagchold_in ,  
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfecfokhold_in, 
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfelfhold_in  ,   
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfekhhold_in  ,             
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfetap2hold_in,        
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfetap3hold_in,        
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfetap4hold_in,       
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfetap5hold_in,           
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfetap6hold_in,       
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfetap7hold_in,        
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfetap8hold_in,       
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfetap9hold_in,       
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfetap10hold_in,       
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfetap11hold_in,       
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfetap12hold_in,        
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfetap13hold_in,       
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfetap14hold_in,       
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfetap15hold_in,       
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfeuthold_in,             
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxdfevphold_in,             
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxoshold_in   ,                  
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxlpmgchold_in,              
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxlpmhfhold_in,            
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxlpmlfhold_in,              
    output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0] rxlpmoshold_in,  

 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxdlysresetdone_out,     
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxelecidle_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0]       rxoutclk_out, 
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxphaligndone_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxpmaresetdone_out,           
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxprbserr_out,                                        
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxprbslocked_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxprgdivresetdone_out,    
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxratedone_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxresetdone_out,              
 input [(PL_LINK_CAP_MAX_LINK_WIDTH* 3)-1:0]    rxstatus_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxsyncdone_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxvalid_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txdlysresetdone_out,     
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txoutclk_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txphaligndone_out,  
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txphinitdone_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0]       txpmaresetdone_out, 
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txprgdivresetdone_out,  
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txresetdone_out,
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txsyncout_out,  
 input [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0]       txsyncdone_out, 

 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         cpllpd_in,                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         cpllreset_in,                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         dmonfiforeset_in,
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         dmonitorclk_in,
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         drpclk_in,
 output [(PL_LINK_CAP_MAX_LINK_WIDTH* 9)-1:0]    drpaddr_in,
 output [(PL_LINK_CAP_MAX_LINK_WIDTH* 16)-1:0]   drpdi_in,
 output [(PL_LINK_CAP_MAX_LINK_WIDTH* 1)-1:0]    drpen_in,
 output [(PL_LINK_CAP_MAX_LINK_WIDTH* 1)-1:0]    drpwe_in,
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         eyescanreset_in,
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         gthrxn_in,                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         gthrxp_in,                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         gtrefclk0_in,
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         gtrxreset_in,                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         gttxreset_in,                                          
 output                        gtwiz_reset_rx_done_in,                                                                                      
 output                        gtwiz_reset_tx_done_in,                                                
 output                        gtwiz_userclk_rx_active_in ,                                                
 output                        gtwiz_userclk_tx_active_in ,                                                
 output                        gtwiz_userclk_tx_reset_in,
 output [(PL_LINK_CAP_MAX_LINK_WIDTH* 3)-1:0]    loopback_in,                                               
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         pcieeqrxeqadaptdone_in ,                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         pcierstidle_in,                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         pciersttxsyncstart_in,                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         pcieuserratedone_in,                                          
 output [(PL_LINK_CAP_MAX_LINK_WIDTH*16)-1:0]    pcsrsvdin_in,
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rx8b10ben_in,                                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxbufreset_in,                                                
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxcdrhold_in,                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxcommadeten_in,
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxlpmen_in,                                                            
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxmcommaalignen_in,                                                    
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxpcommaalignen_in,                                                    
 output [(PL_LINK_CAP_MAX_LINK_WIDTH* 2)-1:0]    rxpd_in,                                              
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxpolarity_in,                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxprbscntreset_in, 
 output [(PL_LINK_CAP_MAX_LINK_WIDTH* 4)-1:0]    rxprbssel_in,                                               
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxprogdivreset_in,                                          
 output [(PL_LINK_CAP_MAX_LINK_WIDTH* 3)-1:0]    rxrate_in,
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxratemode_in,
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxslide_in,                                                
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxuserrdy_in,                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxusrclk2_in,                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         rxusrclk_in,                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         tx8b10ben_in,                                                          
 output [(PL_LINK_CAP_MAX_LINK_WIDTH*16)-1:0]    txctrl0_in,
 output [(PL_LINK_CAP_MAX_LINK_WIDTH*16)-1:0]    txctrl1_in,
 output [(PL_LINK_CAP_MAX_LINK_WIDTH* 8)-1:0]    txctrl2_in,
 output [(PL_LINK_CAP_MAX_LINK_WIDTH*128)-1:0]   txdata_in, 
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txdeemph_in,                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txdetectrx_in,                                          
 output [(PL_LINK_CAP_MAX_LINK_WIDTH*4)-1:0]     txdiffctrl_in,
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txdlybypass_in,                                                
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txdlyen_in,                                                
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txdlyhold_in,                                                
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txdlyovrden_in,                                                
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txdlysreset_in,                                                
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txdlyupdown_in,                                                
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txelecidle_in,                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txinhibit_in,                                          
 output [(PL_LINK_CAP_MAX_LINK_WIDTH* 7)-1:0]    txmaincursor_in,                                               
 output [(PL_LINK_CAP_MAX_LINK_WIDTH* 3)-1:0]    txmargin_in,                                              
 output [(PL_LINK_CAP_MAX_LINK_WIDTH* 3)-1:0]    txoutclksel_in,                                           
 output [(PL_LINK_CAP_MAX_LINK_WIDTH* 2)-1:0]    txpd_in,                                              
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txphalign_in,                                                
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txphalignen_in,                                                
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txphdlypd_in,                                                
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txphdlyreset_in,                                                
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txphdlytstclk_in ,                                                
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txphinit_in,                                                
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txphovrden_in,                                                
 output [(PL_LINK_CAP_MAX_LINK_WIDTH* 5)-1:0]    txpostcursor_in,                                               
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txprbsforceerr_in,                                          
 output [(PL_LINK_CAP_MAX_LINK_WIDTH* 4)-1:0]    txprbssel_in,                                               
 output [(PL_LINK_CAP_MAX_LINK_WIDTH* 5)-1:0]    txprecursor_in,                                               
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txprogdivreset_in,                                          
 output [(PL_LINK_CAP_MAX_LINK_WIDTH* 3)-1:0]    txrate_in,
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txswing_in,                                          
 output [(PL_LINK_CAP_MAX_LINK_WIDTH-1) : 0]     txsyncallin_in, 
 output [(PL_LINK_CAP_MAX_LINK_WIDTH-1) : 0]     txsyncin_in,   
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txsyncmode_in,
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txuserrdy_in,                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txusrclk2_in,                                          
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]         txusrclk_in,                                          

 output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0]       qpll0clk_in, 
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0]       qpll0refclk_in,
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0]       qpll1clk_in, 
 output [PL_LINK_CAP_MAX_LINK_WIDTH-1 : 0]       qpll1refclk_in,

 output [(PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2:0]    gtrefclk01_in,
 output [(PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2:0]    qpll1pd_in,
 output [(PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2:0]    qpll1reset_in,
 output [((((PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2)+1)* 5)-1:0] qpllrsvd2_in,
 output [((((PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2)+1)* 5)-1:0] qpllrsvd3_in,
 input [(PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2:0]     qpll1lock_out,
 input [(PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2:0]     qpll1outclk_out,
 input [(PL_LINK_CAP_MAX_LINK_WIDTH-1)>>2:0]     qpll1outrefclk_out,

 //--------------------------------------------------------------------------
 //  
 //--------------------------------------------------------------------------
  input  wire   [1:0] conf_req_type,
  input  wire   [3:0] conf_req_reg_num,
  input  wire  [31:0] conf_req_data,
  input  wire         conf_req_valid,
  output wire         conf_req_ready,
  output wire  [31:0] conf_resp_rdata,
  output wire         conf_resp_valid,
  output wire         mcap_design_switch,
  input  wire         mcap_eos_in,
  // These inputs and outputs may be use when the startup block is generated internal to the PCI Express Core.
  output wire         startup_cfgclk,     // 1-bit output: Configuration main clock output
  output wire         startup_cfgmclk,    // 1-bit output: Configuration internal oscillator clock output
  output wire   [3:0] startup_di,
  output wire         startup_eos,        // 1-bit output: Active high output signal indicating the End Of Startup
  output wire         startup_preq,       // 1-bit output: PROGRAM request to fabric output
  input  wire   [3:0] startup_do,
  input  wire   [3:0] startup_dts,
  input  wire         startup_fcsbo,
  input  wire         startup_fcsbts,
  input  wire         startup_gsr,        // 1-bit input: Global Set/Reset input (GSR cannot be used for the port name)
  input  wire         startup_gts,        // 1-bit input: Global 3-state input (GTS cannot be used for the port name)
  input  wire         startup_keyclearb,  // 1-bit input: Clear AES Decrypter Key input from Battery-Backed RAM (BBRAM)
  input  wire         startup_pack,       // 1-bit input: PROGRAM acknowledge input
  input  wire         startup_usrcclko,   // 1-bit input: User CCLK input
  input  wire         startup_usrcclkts,  // 1-bit input: User CCLK 3-state enable input
  input  wire         startup_usrdoneo,   // 1-bit input: User DONE pin output control
  input  wire         startup_usrdonets,  // 1-bit input: User DONE 3-state enable output
  output wire         cap_req,
  input  wire         cap_gnt,
  input  wire         cap_rel,
  input  wire         pl_eq_reset_eieos_count,
  input  wire         pl_gen2_upstream_prefer_deemph,
  output wire         pl_eq_in_progress,
  output wire   [1:0] pl_eq_phase,
  input  wire         pcie_perstn1_in, 
  output wire         pcie_perstn0_out,
  output wire         pcie_perstn1_out,
  output wire         phy_rdy_out
  );
  localparam  [1:0]  AXISTEN_IF_WIDTH           = ((C_DATA_WIDTH == 256) ? 2'b10: ((C_DATA_WIDTH == 128) ? 2'b01 : 2'b00));
  localparam  [1:0]  CRM_USER_CLK_FREQ          = ((USER_CLK_FREQ == 3) ? 2'b10: ((USER_CLK_FREQ == 2) ? 2'b01 : 2'b00));

  localparam        CRM_CORE_CLK_FREQ_500      = ((PL_LINK_CAP_MAX_LINK_SPEED == 3'h4) ? "TRUE" : "FALSE");


  wire [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]        gt_rxlpmen;
  wire [(PL_LINK_CAP_MAX_LINK_WIDTH*5)-1:0]  txeq_precursor_o; 
  wire [(PL_LINK_CAP_MAX_LINK_WIDTH*5)-1:0]  txeq_postcursor_o; 
  wire [PL_LINK_CAP_MAX_LINK_WIDTH-1:0]      gt_pcierategen3_o;  
  wire [1:0]                                 pipe_tx_rate_o;
  reg [(PL_LINK_CAP_MAX_LINK_WIDTH-1):0] rxlpmen_i;

  wire                                        pipe_clk;            
  wire                                        sys_clk_bufg;        

  wire                rec_clk;
  wire                mcap_clk;
  wire                core_clk;
  wire                gt_txoutclk;
  wire                sys_rst_n;
  wire                sys_reset_pt;
  wire                mgmt_reset_n;
  wire                phy_rdy;
  wire                phy_rdy_phystatus;
  wire                pipe_tx0_reset;
  wire                pipe_tx0_deemph;
  wire                pipe_tx0_rcvr_det;
  wire          [2:0] pipe_tx0_margin;
  wire                pipe_tx0_swing;
  wire          [5:0] pipe_tx_eqfs;
  wire          [5:0] pipe_tx_eqlf;
  wire                pipe_rx0_polarity;
  wire                pipe_rx1_polarity;
  wire                pipe_rx2_polarity;
  wire                pipe_rx3_polarity;
  wire                pipe_rx4_polarity;
  wire                pipe_rx5_polarity;
  wire                pipe_rx6_polarity;
  wire                pipe_rx7_polarity;
  wire                pipe_tx0_compliance;
  wire                pipe_tx1_compliance;
  wire                pipe_tx2_compliance;
  wire                pipe_tx3_compliance;
  wire                pipe_tx4_compliance;
  wire                pipe_tx5_compliance;
  wire                pipe_tx6_compliance;
  wire                pipe_tx7_compliance;
  wire                pipe_tx0_data_valid;
  wire                pipe_tx1_data_valid;
  wire                pipe_tx2_data_valid;
  wire                pipe_tx3_data_valid;
  wire                pipe_tx4_data_valid;
  wire                pipe_tx5_data_valid;
  wire                pipe_tx6_data_valid;
  wire                pipe_tx7_data_valid;
  wire                pipe_tx0_elec_idle;
  wire                pipe_tx1_elec_idle;
  wire                pipe_tx2_elec_idle;
  wire                pipe_tx3_elec_idle;
  wire                pipe_tx4_elec_idle;
  wire                pipe_tx5_elec_idle;
  wire                pipe_tx6_elec_idle;
  wire                pipe_tx7_elec_idle;
  wire                pipe_tx0_start_block;
  wire                pipe_tx1_start_block;
  wire                pipe_tx2_start_block;
  wire                pipe_tx3_start_block;
  wire                pipe_tx4_start_block;
  wire                pipe_tx5_start_block;
  wire                pipe_tx6_start_block;
  wire                pipe_tx7_start_block;
  wire          [1:0] pipe_rx0_eqcontrol;
  wire          [1:0] pipe_rx1_eqcontrol;
  wire          [1:0] pipe_rx2_eqcontrol;
  wire          [1:0] pipe_rx3_eqcontrol;
  wire          [1:0] pipe_rx4_eqcontrol;
  wire          [1:0] pipe_rx5_eqcontrol;
  wire          [1:0] pipe_rx6_eqcontrol;
  wire          [1:0] pipe_rx7_eqcontrol;
  wire          [1:0] pipe_tx0_char_is_k;
  wire          [1:0] pipe_tx1_char_is_k;
  wire          [1:0] pipe_tx2_char_is_k;
  wire          [1:0] pipe_tx3_char_is_k;
  wire          [1:0] pipe_tx4_char_is_k;
  wire          [1:0] pipe_tx5_char_is_k;
  wire          [1:0] pipe_tx6_char_is_k;
  wire          [1:0] pipe_tx7_char_is_k;
  wire          [1:0] pipe_tx0_eqcontrol;
  wire          [1:0] pipe_tx1_eqcontrol;
  wire          [1:0] pipe_tx2_eqcontrol;
  wire          [1:0] pipe_tx3_eqcontrol;
  wire          [1:0] pipe_tx4_eqcontrol;
  wire          [1:0] pipe_tx5_eqcontrol;
  wire          [1:0] pipe_tx6_eqcontrol;
  wire          [1:0] pipe_tx7_eqcontrol;
  wire          [1:0] pipe_tx0_powerdown;
  wire          [1:0] pipe_tx1_powerdown;
  wire          [1:0] pipe_tx2_powerdown;
  wire          [1:0] pipe_tx3_powerdown;
  wire          [1:0] pipe_tx4_powerdown;
  wire          [1:0] pipe_tx5_powerdown;
  wire          [1:0] pipe_tx6_powerdown;
  wire          [1:0] pipe_tx7_powerdown;
  wire          [1:0] pipe_tx0_syncheader;
  wire          [1:0] pipe_tx1_syncheader;
  wire          [1:0] pipe_tx2_syncheader;
  wire          [1:0] pipe_tx3_syncheader;
  wire          [1:0] pipe_tx4_syncheader;
  wire          [1:0] pipe_tx5_syncheader;
  wire          [1:0] pipe_tx6_syncheader;
  wire          [1:0] pipe_tx7_syncheader;
  wire          [2:0] pipe_rx0_eqpreset;
  wire          [2:0] pipe_rx1_eqpreset;
  wire          [2:0] pipe_rx2_eqpreset;
  wire          [2:0] pipe_rx3_eqpreset;
  wire          [2:0] pipe_rx4_eqpreset;
  wire          [2:0] pipe_rx5_eqpreset;
  wire          [2:0] pipe_rx6_eqpreset;
  wire          [2:0] pipe_rx7_eqpreset;
  wire         [31:0] pipe_tx0_data;
  wire         [31:0] pipe_tx1_data;
  wire         [31:0] pipe_tx2_data;
  wire         [31:0] pipe_tx3_data;
  wire         [31:0] pipe_tx4_data;
  wire         [31:0] pipe_tx5_data;
  wire         [31:0] pipe_tx6_data;
  wire         [31:0] pipe_tx7_data;  
  wire          [3:0] pipe_rx0_eq_txpreset;
  wire          [3:0] pipe_rx1_eq_txpreset;
  wire          [3:0] pipe_rx2_eq_txpreset;
  wire          [3:0] pipe_rx3_eq_txpreset;
  wire          [3:0] pipe_rx4_eq_txpreset;
  wire          [3:0] pipe_rx5_eq_txpreset;
  wire          [3:0] pipe_rx6_eq_txpreset;
  wire          [3:0] pipe_rx7_eq_txpreset;
  wire          [3:0] pipe_tx0_eqpreset;
  wire          [3:0] pipe_tx1_eqpreset;
  wire          [3:0] pipe_tx2_eqpreset;
  wire          [3:0] pipe_tx3_eqpreset;
  wire          [3:0] pipe_tx4_eqpreset;
  wire          [3:0] pipe_tx5_eqpreset;
  wire          [3:0] pipe_tx6_eqpreset;
  wire          [3:0] pipe_tx7_eqpreset;
  wire          [5:0] pipe_rx0_eq_lffs;
  wire          [5:0] pipe_rx1_eq_lffs;
  wire          [5:0] pipe_rx2_eq_lffs;
  wire          [5:0] pipe_rx3_eq_lffs;
  wire          [5:0] pipe_rx4_eq_lffs;
  wire          [5:0] pipe_rx5_eq_lffs;
  wire          [5:0] pipe_rx6_eq_lffs;
  wire          [5:0] pipe_rx7_eq_lffs;
  wire          [5:0] pipe_tx0_eqdeemph;
  wire          [5:0] pipe_tx1_eqdeemph;
  wire          [5:0] pipe_tx2_eqdeemph;
  wire          [5:0] pipe_tx3_eqdeemph;
  wire          [5:0] pipe_tx4_eqdeemph;
  wire          [5:0] pipe_tx5_eqdeemph;
  wire          [5:0] pipe_tx6_eqdeemph;
  wire          [5:0] pipe_tx7_eqdeemph;
  wire          pipe_rx0_eqdone;
  wire          pipe_rx1_eqdone;
  wire          pipe_rx2_eqdone;
  wire          pipe_rx3_eqdone;
  wire          pipe_rx4_eqdone;
  wire          pipe_rx5_eqdone;
  wire          pipe_rx6_eqdone;
  wire          pipe_rx7_eqdone;
  wire         pipe_rx0_eq_adapt_done;
  wire         pipe_rx1_eq_adapt_done;
  wire         pipe_rx2_eq_adapt_done;
  wire         pipe_rx3_eq_adapt_done;
  wire         pipe_rx4_eq_adapt_done;
  wire         pipe_rx5_eq_adapt_done;
  wire         pipe_rx6_eq_adapt_done;
  wire         pipe_rx7_eq_adapt_done;
  wire         pipe_rx0_eq_lffs_sel;
  wire         pipe_rx1_eq_lffs_sel;
  wire         pipe_rx2_eq_lffs_sel;
  wire         pipe_rx3_eq_lffs_sel;
  wire         pipe_rx4_eq_lffs_sel;
  wire         pipe_rx5_eq_lffs_sel;
  wire         pipe_rx6_eq_lffs_sel;
  wire         pipe_rx7_eq_lffs_sel;
  wire         pipe_rx0_phy_status;
  wire         pipe_rx1_phy_status;
  wire         pipe_rx2_phy_status;
  wire         pipe_rx3_phy_status;
  wire         pipe_rx4_phy_status;
  wire         pipe_rx5_phy_status;
  wire         pipe_rx6_phy_status;
  wire         pipe_rx7_phy_status;
  wire         pipe_rx0_valid;
  wire         pipe_rx1_valid;
  wire         pipe_rx2_valid;
  wire         pipe_rx3_valid;
  wire         pipe_rx4_valid;
  wire         pipe_rx5_valid;
  wire         pipe_rx6_valid;
  wire         pipe_rx7_valid;
  wire         pipe_tx0_eqdone;
  wire         pipe_tx1_eqdone;
  wire         pipe_tx2_eqdone;
  wire         pipe_tx3_eqdone;
  wire         pipe_tx4_eqdone;
  wire         pipe_tx5_eqdone;
  wire         pipe_tx6_eqdone;
  wire         pipe_tx7_eqdone;
  wire         [17:0] pipe_rx0_eq_new_txcoeff;
  wire         [17:0] pipe_rx1_eq_new_txcoeff;
  wire         [17:0] pipe_rx2_eq_new_txcoeff;
  wire         [17:0] pipe_rx3_eq_new_txcoeff;
  wire         [17:0] pipe_rx4_eq_new_txcoeff;
  wire         [17:0] pipe_rx5_eq_new_txcoeff;
  wire         [17:0] pipe_rx6_eq_new_txcoeff;
  wire         [17:0] pipe_rx7_eq_new_txcoeff;
  wire         [17:0] pipe_tx0_eqcoeff;
  wire         [17:0] pipe_tx1_eqcoeff;
  wire         [17:0] pipe_tx2_eqcoeff;
  wire         [17:0] pipe_tx3_eqcoeff;
  wire         [17:0] pipe_tx4_eqcoeff;
  wire         [17:0] pipe_tx5_eqcoeff;
  wire         [17:0] pipe_tx6_eqcoeff;
  wire         [17:0] pipe_tx7_eqcoeff;
  wire          [1:0] pipe_rx0_char_is_k;
  wire          [1:0] pipe_rx1_char_is_k;
  wire          [1:0] pipe_rx2_char_is_k;
  wire          [1:0] pipe_rx3_char_is_k;
  wire          [1:0] pipe_rx4_char_is_k;
  wire          [1:0] pipe_rx5_char_is_k;
  wire          [1:0] pipe_rx6_char_is_k;
  wire          [1:0] pipe_rx7_char_is_k;
  wire         [2:0] pipe_rx0_status;
  wire         [2:0] pipe_rx1_status;
  wire         [2:0] pipe_rx2_status;
  wire         [2:0] pipe_rx3_status;
  wire         [2:0] pipe_rx4_status;
  wire         [2:0] pipe_rx5_status;
  wire         [2:0] pipe_rx6_status;
  wire         [2:0] pipe_rx7_status;
  wire         [31:0] pipe_rx0_data;
  wire         [31:0] pipe_rx1_data;
  wire         [31:0] pipe_rx2_data;
  wire         [31:0] pipe_rx3_data;
  wire         [31:0] pipe_rx4_data;
  wire         [31:0] pipe_rx5_data;
  wire         [31:0] pipe_rx6_data;
  wire         [31:0] pipe_rx7_data;
  wire         pipe_rx0_data_valid;  
  wire         pipe_rx1_data_valid;  
  wire         pipe_rx2_data_valid;  
  wire         pipe_rx3_data_valid;  
  wire         pipe_rx4_data_valid;  
  wire         pipe_rx5_data_valid;  
  wire         pipe_rx6_data_valid;  
  wire         pipe_rx7_data_valid;  
  wire         pipe_rx0_elec_idle;
  wire         pipe_rx1_elec_idle;
  wire         pipe_rx2_elec_idle;
  wire         pipe_rx3_elec_idle;
  wire         pipe_rx4_elec_idle;
  wire         pipe_rx5_elec_idle;
  wire         pipe_rx6_elec_idle;
  wire         pipe_rx7_elec_idle;
  wire         pipe_rx0_start_block;
  wire         pipe_rx1_start_block;
  wire         pipe_rx2_start_block;
  wire         pipe_rx3_start_block;
  wire         pipe_rx4_start_block;
  wire         pipe_rx5_start_block;
  wire         pipe_rx6_start_block;
  wire         pipe_rx7_start_block;
  wire         [1:0] pipe_rx0_syncheader;
  wire         [1:0] pipe_rx1_syncheader;
  wire         [1:0] pipe_rx2_syncheader;
  wire         [1:0] pipe_rx3_syncheader;
  wire         [1:0] pipe_rx4_syncheader;
  wire         [1:0] pipe_rx5_syncheader;
  wire         [1:0] pipe_rx6_syncheader;
  wire         [1:0] pipe_rx7_syncheader;
  wire                sys_or_hot_rst;
  wire                user_lnk_up_int;
  wire                user_lnk_up_cdc_o;
  wire                mcap_pcie_request;
  wire                mcap_external_request;
  wire         [15:0] cfg_dev_id_mux;
  wire          [7:0] cfg_rev_id_mux;
  wire         [15:0] cfg_subsys_id_mux;
  wire         [15:0] cfg_subsys_vend_id_mux;
  wire         [15:0] cfg_vend_id_mux;
  wire                cfg_config_space_enable_mux;
  wire                cfg_link_training_enable_mux;
  wire                cfg_interrupt_msix_int_mux;
  wire                conf_req_valid_mux;
  wire                drp_en_mux;
  wire [((PL_LINK_CAP_MAX_LINK_WIDTH*3)-1):0] gt_loopback_mux;
  wire [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] gt_pcieuserratedone_mux;
  wire [((PL_LINK_CAP_MAX_LINK_WIDTH*4)-1):0] gt_rxprbssel_mux;
  wire [((PL_LINK_CAP_MAX_LINK_WIDTH*4)-1):0] gt_txprbssel_mux;
  wire                pl_eq_reset_eieos_count_mux;
  wire                pl_gen2_upstream_prefer_deemph_mux;
  wire                cfg_err_cor_in_mux;
  wire                cfg_err_uncor_in_mux;
  wire                cfg_hot_reset_in_mux;
  wire          [3:0] cfg_flr_done_mux;
  wire          [3:0] cfg_interrupt_int_mux;
  wire         [31:0] cfg_interrupt_msi_int_mux;
  wire                cfg_interrupt_msi_pending_status_data_enable_mux;
  wire                cfg_mgmt_write_mux;
  wire                cfg_msg_transmit_mux;
  wire                cfg_power_state_change_ack_mux;
  wire                cfg_req_pm_transition_l23_ready_mux;
  wire          [7:0] cfg_vf_flr_done_mux;
  wire [((PL_LINK_CAP_MAX_LINK_WIDTH *  1)-1):0] ext_ch_gt_drpen_mux;
  wire                pcie_cq_np_req_mux;
  wire         [21:0] m_axis_rc_tready_mux;
  wire         [21:0] m_axis_cq_tready_mux;
  wire                s_axis_rq_tvalid_mux;
  wire                s_axis_cc_tvalid_mux;
  wire                m_axis_rc_tvalid_wire;
  wire                m_axis_cq_tvalid_wire;
  wire          [3:0] s_axis_rq_tready_wire;
  wire          [3:0] s_axis_cc_tready_wire;
  wire                conf_req_ready_wire;
  wire                conf_mcap_design_switch_o;
  wire                conf_mcap_design_switch;
  wire [5:0] np_req_wait;
  wire                user_reset_int;
  wire                user_reset_cdc_o;

  wire         [31:0] acs_cfg_ext_read_data;
  wire                acs_cfg_ext_read_data_valid;
  wire         [31:0] cfg_ext_read_data_int;
  wire                cfg_ext_read_data_valid_int;

  wire [15:0]  cfg_vend_id        = PF0_VENDOR_ID;
  wire [15:0]  cfg_dev_id         = PF0_DEVICE_ID;
  wire [7:0]   cfg_rev_id         = PF0_REVISION_ID;
//  wire [15:0]  cfg_subsys_vend_id = PF0_SUBSYSTEM_VENDOR_ID;
  wire [15:0]  cfg_subsys_id      = PF0_SUBSYSTEM_ID;

   wire [1:0]     pipe_tx_rate_i;

  reg  phase1 = 1'b0; 

  assign sys_rst_n = sys_reset_pt;
  assign pcie_perstn0_out = sys_reset_pt;
  assign sys_or_hot_rst = ~sys_rst_n || cfg_hot_reset_out;
  assign user_lnk_up_int = (cfg_phy_link_status == 2'b11 && sys_rst_n) ? 1'b1 : 1'b0;
 
  wire sync_sc_ce;
  wire sync_sc_clr; 
//  BUFG_GT bufg_gt_sysclk (.CE (1'd1), .CEMASK (1'd0), .CLR (1'd0), .CLRMASK (1'd0), .DIV (3'd0), .I (sys_clk), .O (sys_clk_bufg));
  BUFG_GT bufg_gt_sysclk (.CE (sync_sc_ce), .CEMASK (1'd0), .CLR (sync_sc_clr), .CLRMASK (1'd0), .DIV (3'd0), .I (sys_clk), .O (sys_clk_bufg));
  BUFG_GT_SYNC sync_sys_clk (.CESYNC(sync_sc_ce), .CLRSYNC(sync_sc_clr), .CE(1'b1), .CLK(sys_clk), .CLR(1'b0));

  // CDC for the user_lnk_up output
  // this will deassert asynchronously with sys_rst_n and assert synchronously
  xpm_cdc_async_rst #(
    .DEST_SYNC_FF          (2),
    .RST_ACTIVE_HIGH       (0)
  ) user_lnk_up_cdc (
    .src_arst              (user_lnk_up_int),
    .dest_arst             (user_lnk_up_cdc_o),
    .dest_clk              (user_clk)
  );
  // Additional reset register that can be replicated by the tools to facilitate timing closure
  always @(posedge user_clk or negedge user_lnk_up_int) begin
    if(!user_lnk_up_int) begin
      user_lnk_up <= #TCQ 1'b0;
    end else begin
      user_lnk_up <= #TCQ user_lnk_up_cdc_o;
    end
  end

  // CDC for the user_reset output
  // this will assert asynchronously with sys_rst_n and deassert synchronously
  assign user_reset_int = sys_or_hot_rst || cfg_phy_link_down || !cfg_phy_link_status[1];
  xpm_cdc_async_rst #(
    .DEST_SYNC_FF          (2),
    .RST_ACTIVE_HIGH       (1)
  ) user_reset_cdc (
    .src_arst              (user_reset_int),
    .dest_arst             (user_reset_cdc_o),
    .dest_clk              (user_clk)
  );
  // Additional reset register that can be replicated by the tools to facilitate timing closure
  always @(posedge user_clk or posedge user_reset_int) begin
    if(user_reset_int) begin
     user_reset <= #TCQ 1'b1;
    end else begin
      user_reset <= #TCQ user_reset_cdc_o;
    end
  end


  assign cap_req = mcap_pcie_request;
  assign mcap_external_request = (~cap_gnt) | cap_rel;
  assign conf_mcap_design_switch = conf_mcap_design_switch_o;


initial begin
  $printtimescale;
  $display("Ref Clk Freq: %0d \t User Clk Freq: %0d \t PCIE Link Speed: %0d", REF_CLK_FREQ, USER_CLK_FREQ, PCIE_LINK_SPEED);
end



generate if (EXT_PIPE_SIM == "TRUE") 
begin

  /////////////// phy_rdy, rcvr det , seepd_change & gt_powerdown /////////////////////////////
  
  reg [31:0] phy_rdy_reg = 32'b0;
  reg [31:0] rcvr_det_reg     = 32'b0;
  reg [15:0] pipe_rate_reg    = 16'b0;
  reg [7:0]  gt_powerdown_reg = {4{2'b10}};
  
  wire      rcvr_det;
  wire      speed_change;
  wire      gt_powerdown;
    
  always @ (posedge pipe_clk)
  begin
   phy_rdy_reg      <= {phy_rdy_reg[30:0], sys_rst_n};
   rcvr_det_reg     <= {rcvr_det_reg[30:0], pipe_tx0_rcvr_det};
   pipe_rate_reg    <= {pipe_rate_reg[15:0], common_commands_out[2:1]};
   gt_powerdown_reg <= {gt_powerdown_reg[5:0],pipe_tx_0_sigs[41:40]};
  end 
  
  assign phy_rdy      =  phy_rdy_reg[31];
  assign rcvr_det     = ~rcvr_det_reg[30] && rcvr_det_reg[29];
  assign speed_change = (pipe_rate_reg[15:14] != pipe_rate_reg[13:12])? 1'b1 : 1'b0;
  assign gt_powerdown = (gt_powerdown_reg[7:6] != gt_powerdown_reg[5:4])? 1'b1 : 1'b0;
  
  
  
  //////// generate Rx status and Phy status ////////////// 
  
  wire [2:0] rx_status;
  wire       phy_status;
  
  assign  rx_status  = (pipe_tx0_rcvr_det && rcvr_det) ? 3'b011 : 3'b0;
  assign  phy_status = (pipe_tx0_rcvr_det && rcvr_det) || speed_change || gt_powerdown ;

   
  //////// generate clocks for pipe mode //////////////
 
  wire clk_500;
  wire clk_250;
  wire clk_125;
  wire clk_62_5;
 
  xdma_0_pcie3_ip_sys_clk_gen_ps 	#(.offset(7000),.halfcycle(1000)) clk_gen_500  (.sys_clk(clk_500));
  xdma_0_pcie3_ip_sys_clk_gen_ps 	#(.offset(6000),.halfcycle(2000)) clk_gen_250  (.sys_clk(clk_250));
  xdma_0_pcie3_ip_sys_clk_gen_ps 	#(.offset(4000),.halfcycle(4000)) clk_gen_125  (.sys_clk(clk_125));
  xdma_0_pcie3_ip_sys_clk_gen_ps 	#(.offset(0000),.halfcycle(8000)) clk_gen_62_5 (.sys_clk(clk_62_5));
 
  assign mcap_clk = (USER_CLK_FREQ == 3) ? clk_125 : user_clk;
  assign pipe_clk = (common_commands_out[2:1] == 2'b0)? clk_125 : clk_250;
  assign core_clk = (CRM_CORE_CLK_FREQ_500 == "TRUE") ? clk_500 : clk_250 ;
  assign user_clk = (USER_CLK_FREQ == 3) ? clk_250: ((USER_CLK_FREQ == 2) ? clk_125 : clk_62_5);
 
 /////////////////////// PCIE core Instance - PIPE Mode////////////////////////////

  xdma_0_pcie3_ip_pcie3_uscale_top 
 #(
    .TCQ (TCQ),
    .NO_DECODE_LOGIC (NO_DECODE_LOGIC),
    .INTERFACE_SPEED (INTERFACE_SPEED),
    .COMPLETION_SPACE (COMPLETION_SPACE),
    .KEEP_WIDTH (KEEP_WIDTH),
    .C_DATA_WIDTH (C_DATA_WIDTH),
    .PIPE_PIPELINE_STAGES (PIPE_PIPELINE_STAGES),
    .ARI_CAP_ENABLE (ARI_CAP_ENABLE),
    .AXISTEN_IF_CC_ALIGNMENT_MODE (AXISTEN_IF_CC_ALIGNMENT_MODE),
    .AXISTEN_IF_CC_PARITY_CHK (AXISTEN_IF_CC_PARITY_CHK),
    .AXISTEN_IF_CQ_ALIGNMENT_MODE (AXISTEN_IF_CQ_ALIGNMENT_MODE),
    .AXISTEN_IF_ENABLE_CLIENT_TAG (AXISTEN_IF_ENABLE_CLIENT_TAG),
    .AXISTEN_IF_ENABLE_MSG_ROUTE (AXISTEN_IF_ENABLE_MSG_ROUTE),
    .AXISTEN_IF_ENABLE_RX_MSG_INTFC (AXISTEN_IF_ENABLE_RX_MSG_INTFC),
    .AXISTEN_IF_RC_ALIGNMENT_MODE (AXISTEN_IF_RC_ALIGNMENT_MODE),
    .AXISTEN_IF_RC_STRADDLE (AXISTEN_IF_RC_STRADDLE),
    .AXISTEN_IF_RQ_ALIGNMENT_MODE (AXISTEN_IF_RQ_ALIGNMENT_MODE),
    .AXISTEN_IF_RQ_PARITY_CHK (AXISTEN_IF_RQ_PARITY_CHK),
    .AXISTEN_IF_WIDTH (AXISTEN_IF_WIDTH),
    .CRM_CORE_CLK_FREQ_500 (CRM_CORE_CLK_FREQ_500),
    .CRM_USER_CLK_FREQ (CRM_USER_CLK_FREQ),
    .DEBUG_CFG_LOCAL_MGMT_REG_ACCESS_OVERRIDE (DEBUG_CFG_LOCAL_MGMT_REG_ACCESS_OVERRIDE),
    .DEBUG_PL_DISABLE_EI_INFER_IN_L0 (DEBUG_PL_DISABLE_EI_INFER_IN_L0),
    .DEBUG_TL_DISABLE_RX_TLP_ORDER_CHECKS (DEBUG_TL_DISABLE_RX_TLP_ORDER_CHECKS),
    .DNSTREAM_LINK_NUM (DNSTREAM_LINK_NUM),
    .LL_ACK_TIMEOUT (LL_ACK_TIMEOUT),
    .LL_ACK_TIMEOUT_EN (LL_ACK_TIMEOUT_EN),
    .LL_ACK_TIMEOUT_FUNC (LL_ACK_TIMEOUT_FUNC),
    .LL_CPL_FC_UPDATE_TIMER (LL_CPL_FC_UPDATE_TIMER),
    .LL_CPL_FC_UPDATE_TIMER_OVERRIDE (LL_CPL_FC_UPDATE_TIMER_OVERRIDE),
    .LL_FC_UPDATE_TIMER (LL_FC_UPDATE_TIMER),
    .LL_FC_UPDATE_TIMER_OVERRIDE (LL_FC_UPDATE_TIMER_OVERRIDE),
    .LL_NP_FC_UPDATE_TIMER (LL_NP_FC_UPDATE_TIMER),
    .LL_NP_FC_UPDATE_TIMER_OVERRIDE (LL_NP_FC_UPDATE_TIMER_OVERRIDE),
    .LL_P_FC_UPDATE_TIMER (LL_P_FC_UPDATE_TIMER),
    .LL_P_FC_UPDATE_TIMER_OVERRIDE (LL_P_FC_UPDATE_TIMER_OVERRIDE),
    .LL_REPLAY_TIMEOUT (LL_REPLAY_TIMEOUT),
    .LL_REPLAY_TIMEOUT_EN (LL_REPLAY_TIMEOUT_EN),
    .LL_REPLAY_TIMEOUT_FUNC (LL_REPLAY_TIMEOUT_FUNC),
    .LTR_TX_MESSAGE_MINIMUM_INTERVAL (LTR_TX_MESSAGE_MINIMUM_INTERVAL),
    .LTR_TX_MESSAGE_ON_FUNC_POWER_STATE_CHANGE (LTR_TX_MESSAGE_ON_FUNC_POWER_STATE_CHANGE),
    .LTR_TX_MESSAGE_ON_LTR_ENABLE (LTR_TX_MESSAGE_ON_LTR_ENABLE),
    .MCAP_CAP_NEXTPTR (MCAP_CAP_NEXTPTR),
    .MCAP_CONFIGURE_OVERRIDE (MCAP_CONFIGURE_OVERRIDE),
    .MCAP_ENABLE (MCAP_ENABLE),
    .MCAP_EOS_DESIGN_SWITCH (MCAP_EOS_DESIGN_SWITCH),
    .MCAP_FPGA_BITSTREAM_VERSION (MCAP_FPGA_BITSTREAM_VERSION),
    .MCAP_GATE_IO_ENABLE_DESIGN_SWITCH (MCAP_GATE_IO_ENABLE_DESIGN_SWITCH),
    .MCAP_GATE_MEM_ENABLE_DESIGN_SWITCH (MCAP_GATE_MEM_ENABLE_DESIGN_SWITCH),
    .MCAP_INPUT_GATE_DESIGN_SWITCH (MCAP_INPUT_GATE_DESIGN_SWITCH),
    .MCAP_INTERRUPT_ON_MCAP_EOS (MCAP_INTERRUPT_ON_MCAP_EOS),
    .MCAP_INTERRUPT_ON_MCAP_ERROR (MCAP_INTERRUPT_ON_MCAP_ERROR),
    .MCAP_VSEC_ID (MCAP_VSEC_ID),
    .MCAP_VSEC_LEN (MCAP_VSEC_LEN),
    .MCAP_VSEC_REV (MCAP_VSEC_REV),
    .PF0_AER_CAP_ECRC_CHECK_CAPABLE (PF0_AER_CAP_ECRC_CHECK_CAPABLE),
    .PF0_AER_CAP_ECRC_GEN_CAPABLE (PF0_AER_CAP_ECRC_GEN_CAPABLE),
    .PF0_AER_CAP_NEXTPTR (PF0_AER_CAP_NEXTPTR),
    .PF0_ARI_CAP_NEXT_FUNC (PF0_ARI_CAP_NEXT_FUNC),
    .PF0_ARI_CAP_NEXTPTR (PF0_ARI_CAP_NEXTPTR),
    .PF0_ARI_CAP_VER (PF0_ARI_CAP_VER),
    .PF0_BAR0_APERTURE_SIZE (PF0_BAR0_APERTURE_SIZE),
    .PF0_BAR0_CONTROL (PF0_BAR0_CONTROL),
    .PF0_BAR1_APERTURE_SIZE (PF0_BAR1_APERTURE_SIZE),
    .PF0_BAR1_CONTROL (PF0_BAR1_CONTROL),
    .PF0_BAR2_APERTURE_SIZE (PF0_BAR2_APERTURE_SIZE),
    .PF0_BAR2_CONTROL (PF0_BAR2_CONTROL),
    .PF0_BAR3_APERTURE_SIZE (PF0_BAR3_APERTURE_SIZE),
    .PF0_BAR3_CONTROL (PF0_BAR3_CONTROL),
    .PF0_BAR4_APERTURE_SIZE (PF0_BAR4_APERTURE_SIZE),
    .PF0_BAR4_CONTROL (PF0_BAR4_CONTROL),
    .PF0_BAR5_APERTURE_SIZE (PF0_BAR5_APERTURE_SIZE),
    .PF0_BAR5_CONTROL (PF0_BAR5_CONTROL),
    .PF0_BIST_REGISTER (PF0_BIST_REGISTER),
    .PF0_CAPABILITY_POINTER (PF0_CAPABILITY_POINTER),
    .PF0_CLASS_CODE (PF0_CLASS_CODE),
    .PF0_DEV_CAP_ENDPOINT_L0S_LATENCY (PF0_DEV_CAP_ENDPOINT_L0S_LATENCY),
    .PF0_DEV_CAP_ENDPOINT_L1_LATENCY (PF0_DEV_CAP_ENDPOINT_L1_LATENCY),
    .PF0_DEV_CAP_EXT_TAG_SUPPORTED (PF0_DEV_CAP_EXT_TAG_SUPPORTED),
    .PF0_DEV_CAP_FUNCTION_LEVEL_RESET_CAPABLE (PF0_DEV_CAP_FUNCTION_LEVEL_RESET_CAPABLE),
    .PF0_DEV_CAP_MAX_PAYLOAD_SIZE (PF0_DEV_CAP_MAX_PAYLOAD_SIZE),
    .PF0_DEV_CAP2_ARI_FORWARD_ENABLE (PF0_DEV_CAP2_ARI_FORWARD_ENABLE),
    .PF0_DEV_CAP2_CPL_TIMEOUT_DISABLE (PF0_DEV_CAP2_CPL_TIMEOUT_DISABLE),
    .PF0_DEV_CAP2_LTR_SUPPORT (PF0_DEV_CAP2_LTR_SUPPORT),
    .PF0_DEV_CAP2_OBFF_SUPPORT (PF0_DEV_CAP2_OBFF_SUPPORT),
    .PF0_DEV_CAP2_TPH_COMPLETER_SUPPORT (PF0_DEV_CAP2_TPH_COMPLETER_SUPPORT),
    .PF0_DEV_CAP2_32B_ATOMIC_COMPLETER_SUPPORT (PF0_DEV_CAP2_32B_ATOMIC_COMPLETER_SUPPORT),
    .PF0_DEV_CAP2_64B_ATOMIC_COMPLETER_SUPPORT (PF0_DEV_CAP2_64B_ATOMIC_COMPLETER_SUPPORT),
    .PF0_DEV_CAP2_128B_CAS_ATOMIC_COMPLETER_SUPPORT (PF0_DEV_CAP2_128B_CAS_ATOMIC_COMPLETER_SUPPORT),
    .PF0_DEVICE_ID (PF0_DEVICE_ID),
    .PF0_DPA_CAP_NEXTPTR (PF0_DPA_CAP_NEXTPTR),
    .PF0_DPA_CAP_SUB_STATE_CONTROL (PF0_DPA_CAP_SUB_STATE_CONTROL),
    .PF0_DPA_CAP_SUB_STATE_CONTROL_EN (PF0_DPA_CAP_SUB_STATE_CONTROL_EN),
    .PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION0 (PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION0),
    .PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION1 (PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION1),
    .PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION2 (PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION2),
    .PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION3 (PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION3),
    .PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION4 (PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION4),
    .PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION5 (PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION5),
    .PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION6 (PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION6),
    .PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION7 (PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION7),
    .PF0_DPA_CAP_VER (PF0_DPA_CAP_VER),
    .PF0_DSN_CAP_NEXTPTR (PF0_DSN_CAP_NEXTPTR),
    .PF0_EXPANSION_ROM_APERTURE_SIZE (PF0_EXPANSION_ROM_APERTURE_SIZE),
    .PF0_EXPANSION_ROM_ENABLE (PF0_EXPANSION_ROM_ENABLE),
    .PF0_INTERRUPT_LINE (PF0_INTERRUPT_LINE),
    .PF0_INTERRUPT_PIN (PF0_INTERRUPT_PIN),
    .PF0_LINK_CAP_ASPM_SUPPORT (PF0_LINK_CAP_ASPM_SUPPORT),
    .PF0_LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN1 (PF0_LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN1),
    .PF0_LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN2 (PF0_LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN2),
    .PF0_LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN3 (PF0_LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN3),
    .PF0_LINK_CAP_L0S_EXIT_LATENCY_GEN1 (PF0_LINK_CAP_L0S_EXIT_LATENCY_GEN1),
    .PF0_LINK_CAP_L0S_EXIT_LATENCY_GEN2 (PF0_LINK_CAP_L0S_EXIT_LATENCY_GEN2),
    .PF0_LINK_CAP_L0S_EXIT_LATENCY_GEN3 (PF0_LINK_CAP_L0S_EXIT_LATENCY_GEN3),
    .PF0_LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN1 (PF0_LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN1),
    .PF0_LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN2 (PF0_LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN2),
    .PF0_LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN3 (PF0_LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN3),
    .PF0_LINK_CAP_L1_EXIT_LATENCY_GEN1 (PF0_LINK_CAP_L1_EXIT_LATENCY_GEN1),
    .PF0_LINK_CAP_L1_EXIT_LATENCY_GEN2 (PF0_LINK_CAP_L1_EXIT_LATENCY_GEN2),
    .PF0_LINK_CAP_L1_EXIT_LATENCY_GEN3 (PF0_LINK_CAP_L1_EXIT_LATENCY_GEN3),
    .PF0_LINK_STATUS_SLOT_CLOCK_CONFIG (PF0_LINK_STATUS_SLOT_CLOCK_CONFIG),
    .PF0_LTR_CAP_MAX_NOSNOOP_LAT (PF0_LTR_CAP_MAX_NOSNOOP_LAT),
    .PF0_LTR_CAP_MAX_SNOOP_LAT (PF0_LTR_CAP_MAX_SNOOP_LAT),
    .PF0_LTR_CAP_NEXTPTR (PF0_LTR_CAP_NEXTPTR),
    .PF0_LTR_CAP_VER (PF0_LTR_CAP_VER),
    .PF0_MSI_CAP_MULTIMSGCAP (PF0_MSI_CAP_MULTIMSGCAP),
    .PF0_MSI_CAP_NEXTPTR (PF0_MSI_CAP_NEXTPTR),
    .PF0_MSI_CAP_PERVECMASKCAP (PF0_MSI_CAP_PERVECMASKCAP),
    .PF0_MSIX_CAP_NEXTPTR (PF0_MSIX_CAP_NEXTPTR),
    .PF0_MSIX_CAP_PBA_BIR (PF0_MSIX_CAP_PBA_BIR),
    .PF0_MSIX_CAP_PBA_OFFSET ({3'b000,PF0_MSIX_CAP_PBA_OFFSET[28:3]}),
    .PF0_MSIX_CAP_TABLE_BIR (PF0_MSIX_CAP_TABLE_BIR),
    .PF0_MSIX_CAP_TABLE_OFFSET ({3'b000,PF0_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .PF0_MSIX_CAP_TABLE_SIZE (PF0_MSIX_CAP_TABLE_SIZE),
    .PF0_PB_CAP_DATA_REG_D0 (PF0_PB_CAP_DATA_REG_D0),
    .PF0_PB_CAP_DATA_REG_D0_SUSTAINED (PF0_PB_CAP_DATA_REG_D0_SUSTAINED),
    .PF0_PB_CAP_DATA_REG_D1 (PF0_PB_CAP_DATA_REG_D1),
    .PF0_PB_CAP_DATA_REG_D3HOT (PF0_PB_CAP_DATA_REG_D3HOT),
    .PF0_PB_CAP_NEXTPTR (PF0_PB_CAP_NEXTPTR),
    .PF0_PB_CAP_SYSTEM_ALLOCATED (PF0_PB_CAP_SYSTEM_ALLOCATED),
    .PF0_PB_CAP_VER (PF0_PB_CAP_VER),
    .PF0_PM_CAP_ID (PF0_PM_CAP_ID),
    .PF0_PM_CAP_NEXTPTR (PF0_PM_CAP_NEXTPTR),
    .PF0_PM_CAP_PMESUPPORT_D0 (PF0_PM_CAP_PMESUPPORT_D0),
    .PF0_PM_CAP_PMESUPPORT_D1 (PF0_PM_CAP_PMESUPPORT_D1),
    .PF0_PM_CAP_PMESUPPORT_D3HOT (PF0_PM_CAP_PMESUPPORT_D3HOT),
    .PF0_PM_CAP_SUPP_D1_STATE (PF0_PM_CAP_SUPP_D1_STATE),
    .PF0_PM_CAP_VER_ID (PF0_PM_CAP_VER_ID),
    .PF0_PM_CSR_NOSOFTRESET (PF0_PM_CSR_NOSOFTRESET),
    .PF0_RBAR_CAP_ENABLE (PF0_RBAR_CAP_ENABLE),
    .PF0_RBAR_CAP_NEXTPTR (PF0_RBAR_CAP_NEXTPTR),
    .PF0_RBAR_CAP_SIZE0 (PF0_RBAR_CAP_SIZE0),
    .PF0_RBAR_CAP_SIZE1 (PF0_RBAR_CAP_SIZE1),
    .PF0_RBAR_CAP_SIZE2 (PF0_RBAR_CAP_SIZE2),
    .PF0_RBAR_CAP_VER (PF0_RBAR_CAP_VER),
    .PF0_RBAR_CONTROL_INDEX0 (PF0_RBAR_CONTROL_INDEX0),
    .PF0_RBAR_CONTROL_INDEX1 (PF0_RBAR_CONTROL_INDEX1),
    .PF0_RBAR_CONTROL_INDEX2 (PF0_RBAR_CONTROL_INDEX2),
    .PF0_RBAR_CONTROL_SIZE0 (PF0_RBAR_CONTROL_SIZE0),
    .PF0_RBAR_CONTROL_SIZE1 (PF0_RBAR_CONTROL_SIZE1),
    .PF0_RBAR_CONTROL_SIZE2 (PF0_RBAR_CONTROL_SIZE2),
    .PF0_RBAR_NUM (PF0_RBAR_NUM),
    .PF0_REVISION_ID (PF0_REVISION_ID),
    .PF0_SECONDARY_PCIE_CAP_NEXTPTR (PF0_SECONDARY_PCIE_CAP_NEXTPTR),
    .PF0_SRIOV_BAR0_APERTURE_SIZE (PF0_SRIOV_BAR0_APERTURE_SIZE),
    .PF0_SRIOV_BAR0_CONTROL (PF0_SRIOV_BAR0_CONTROL),
    .PF0_SRIOV_BAR1_APERTURE_SIZE (PF0_SRIOV_BAR1_APERTURE_SIZE),
    .PF0_SRIOV_BAR1_CONTROL (PF0_SRIOV_BAR1_CONTROL),
    .PF0_SRIOV_BAR2_APERTURE_SIZE (PF0_SRIOV_BAR2_APERTURE_SIZE),
    .PF0_SRIOV_BAR2_CONTROL (PF0_SRIOV_BAR2_CONTROL),
    .PF0_SRIOV_BAR3_APERTURE_SIZE (PF0_SRIOV_BAR3_APERTURE_SIZE),
    .PF0_SRIOV_BAR3_CONTROL (PF0_SRIOV_BAR3_CONTROL),
    .PF0_SRIOV_BAR4_APERTURE_SIZE (PF0_SRIOV_BAR4_APERTURE_SIZE),
    .PF0_SRIOV_BAR4_CONTROL (PF0_SRIOV_BAR4_CONTROL),
    .PF0_SRIOV_BAR5_APERTURE_SIZE (PF0_SRIOV_BAR5_APERTURE_SIZE),
    .PF0_SRIOV_BAR5_CONTROL (PF0_SRIOV_BAR5_CONTROL),
    .PF0_SRIOV_CAP_INITIAL_VF (PF0_SRIOV_CAP_INITIAL_VF),
    .PF0_SRIOV_CAP_NEXTPTR (PF0_SRIOV_CAP_NEXTPTR),
    .PF0_SRIOV_CAP_TOTAL_VF (PF0_SRIOV_CAP_TOTAL_VF),
    .PF0_SRIOV_CAP_VER (PF0_SRIOV_CAP_VER),
    .PF0_SRIOV_FIRST_VF_OFFSET (PF0_SRIOV_FIRST_VF_OFFSET),
    .PF0_SRIOV_FUNC_DEP_LINK (PF0_SRIOV_FUNC_DEP_LINK),
    .PF0_SRIOV_SUPPORTED_PAGE_SIZE (PF0_SRIOV_SUPPORTED_PAGE_SIZE),
    .PF0_SRIOV_VF_DEVICE_ID (PF0_SRIOV_VF_DEVICE_ID),
    .PF0_SUBSYSTEM_ID (PF0_SUBSYSTEM_ID),
    .PF0_TPHR_CAP_DEV_SPECIFIC_MODE (PF0_TPHR_CAP_DEV_SPECIFIC_MODE),
    .PF0_TPHR_CAP_ENABLE (PF0_TPHR_CAP_ENABLE),
    .PF0_TPHR_CAP_INT_VEC_MODE (PF0_TPHR_CAP_INT_VEC_MODE),
    .PF0_TPHR_CAP_NEXTPTR (PF0_TPHR_CAP_NEXTPTR),
    .PF0_TPHR_CAP_ST_MODE_SEL (PF0_TPHR_CAP_ST_MODE_SEL),
    .PF0_TPHR_CAP_ST_TABLE_LOC (PF0_TPHR_CAP_ST_TABLE_LOC),
    .PF0_TPHR_CAP_ST_TABLE_SIZE (PF0_TPHR_CAP_ST_TABLE_SIZE),
    .PF0_TPHR_CAP_VER (PF0_TPHR_CAP_VER),
    .PF0_VC_CAP_ENABLE (PF0_VC_CAP_ENABLE),
    .PF0_VC_CAP_NEXTPTR (PF0_VC_CAP_NEXTPTR),
    .PF0_VC_CAP_VER (PF0_VC_CAP_VER),
    .PF1_AER_CAP_ECRC_CHECK_CAPABLE (PF1_AER_CAP_ECRC_CHECK_CAPABLE),
    .PF1_AER_CAP_ECRC_GEN_CAPABLE (PF1_AER_CAP_ECRC_GEN_CAPABLE),
    .PF1_AER_CAP_NEXTPTR (PF1_AER_CAP_NEXTPTR),
    .PF1_ARI_CAP_NEXT_FUNC (PF1_ARI_CAP_NEXT_FUNC),
    .PF1_ARI_CAP_NEXTPTR (PF1_ARI_CAP_NEXTPTR),
    .PF1_BAR0_APERTURE_SIZE (PF1_BAR0_APERTURE_SIZE),
    .PF1_BAR0_CONTROL (PF1_BAR0_CONTROL),
    .PF1_BAR1_APERTURE_SIZE (PF1_BAR1_APERTURE_SIZE),
    .PF1_BAR1_CONTROL (PF1_BAR1_CONTROL),
    .PF1_BAR2_APERTURE_SIZE (PF1_BAR2_APERTURE_SIZE),
    .PF1_BAR2_CONTROL (PF1_BAR2_CONTROL),
    .PF1_BAR3_APERTURE_SIZE (PF1_BAR3_APERTURE_SIZE),
    .PF1_BAR3_CONTROL (PF1_BAR3_CONTROL),
    .PF1_BAR4_APERTURE_SIZE (PF1_BAR4_APERTURE_SIZE),
    .PF1_BAR4_CONTROL (PF1_BAR4_CONTROL),
    .PF1_BAR5_APERTURE_SIZE (PF1_BAR5_APERTURE_SIZE),
    .PF1_BAR5_CONTROL (PF1_BAR5_CONTROL),
    .PF1_BIST_REGISTER (PF1_BIST_REGISTER),
    .PF1_CAPABILITY_POINTER (PF1_CAPABILITY_POINTER),
    .PF1_CLASS_CODE (PF1_CLASS_CODE),
    .PF1_DEV_CAP_MAX_PAYLOAD_SIZE (PF1_DEV_CAP_MAX_PAYLOAD_SIZE),
    .PF1_DEVICE_ID (PF1_DEVICE_ID),
    .PF1_DPA_CAP_NEXTPTR (PF1_DPA_CAP_NEXTPTR),
    .PF1_DPA_CAP_SUB_STATE_CONTROL (PF1_DPA_CAP_SUB_STATE_CONTROL),
    .PF1_DPA_CAP_SUB_STATE_CONTROL_EN (PF1_DPA_CAP_SUB_STATE_CONTROL_EN),
    .PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION0 (PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION0),
    .PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION1 (PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION1),
    .PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION2 (PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION2),
    .PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION3 (PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION3),
    .PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION4 (PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION4),
    .PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION5 (PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION5),
    .PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION6 (PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION6),
    .PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION7 (PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION7),
    .PF1_DPA_CAP_VER (PF1_DPA_CAP_VER),
    .PF1_DSN_CAP_NEXTPTR (PF1_DSN_CAP_NEXTPTR),
    .PF1_EXPANSION_ROM_APERTURE_SIZE (PF1_EXPANSION_ROM_APERTURE_SIZE),
    .PF1_EXPANSION_ROM_ENABLE (PF1_EXPANSION_ROM_ENABLE),
    .PF1_INTERRUPT_LINE (PF1_INTERRUPT_LINE),
    .PF1_INTERRUPT_PIN (PF1_INTERRUPT_PIN),
    .PF1_MSI_CAP_MULTIMSGCAP (PF1_MSI_CAP_MULTIMSGCAP),
    .PF1_MSI_CAP_NEXTPTR (PF1_MSI_CAP_NEXTPTR),
    .PF1_MSI_CAP_PERVECMASKCAP (PF1_MSI_CAP_PERVECMASKCAP),
    .PF1_MSIX_CAP_NEXTPTR (PF1_MSIX_CAP_NEXTPTR),
    .PF1_MSIX_CAP_PBA_BIR (PF1_MSIX_CAP_PBA_BIR),
    .PF1_MSIX_CAP_PBA_OFFSET ({3'b000,PF1_MSIX_CAP_PBA_OFFSET[28:3]}),
    .PF1_MSIX_CAP_TABLE_BIR (PF1_MSIX_CAP_TABLE_BIR),
    .PF1_MSIX_CAP_TABLE_OFFSET ({3'b000,PF1_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .PF1_MSIX_CAP_TABLE_SIZE (PF1_MSIX_CAP_TABLE_SIZE),
    .PF1_PB_CAP_DATA_REG_D0 (PF1_PB_CAP_DATA_REG_D0),
    .PF1_PB_CAP_DATA_REG_D0_SUSTAINED (PF1_PB_CAP_DATA_REG_D0_SUSTAINED),
    .PF1_PB_CAP_DATA_REG_D1 (PF1_PB_CAP_DATA_REG_D1),
    .PF1_PB_CAP_DATA_REG_D3HOT (PF1_PB_CAP_DATA_REG_D3HOT),
    .PF1_PB_CAP_NEXTPTR (PF1_PB_CAP_NEXTPTR),
    .PF1_PB_CAP_SYSTEM_ALLOCATED (PF1_PB_CAP_SYSTEM_ALLOCATED),
    .PF1_PB_CAP_VER (PF1_PB_CAP_VER),
    .PF1_PM_CAP_ID (PF1_PM_CAP_ID),
    .PF1_PM_CAP_NEXTPTR (PF1_PM_CAP_NEXTPTR),
    .PF1_PM_CAP_VER_ID (PF1_PM_CAP_VER_ID),
    .PF1_RBAR_CAP_ENABLE (PF1_RBAR_CAP_ENABLE),
    .PF1_RBAR_CAP_NEXTPTR (PF1_RBAR_CAP_NEXTPTR),
    .PF1_RBAR_CAP_SIZE0 (PF1_RBAR_CAP_SIZE0),
    .PF1_RBAR_CAP_SIZE1 (PF1_RBAR_CAP_SIZE1),
    .PF1_RBAR_CAP_SIZE2 (PF1_RBAR_CAP_SIZE2),
    .PF1_RBAR_CAP_VER (PF1_RBAR_CAP_VER),
    .PF1_RBAR_CONTROL_INDEX0 (PF1_RBAR_CONTROL_INDEX0),
    .PF1_RBAR_CONTROL_INDEX1 (PF1_RBAR_CONTROL_INDEX1),
    .PF1_RBAR_CONTROL_INDEX2 (PF1_RBAR_CONTROL_INDEX2),
    .PF1_RBAR_CONTROL_SIZE0 (PF1_RBAR_CONTROL_SIZE0),
    .PF1_RBAR_CONTROL_SIZE1 (PF1_RBAR_CONTROL_SIZE1),
    .PF1_RBAR_CONTROL_SIZE2 (PF1_RBAR_CONTROL_SIZE2),
    .PF1_RBAR_NUM (PF1_RBAR_NUM),
    .PF1_REVISION_ID (PF1_REVISION_ID),
    .PF1_SRIOV_BAR0_APERTURE_SIZE (PF1_SRIOV_BAR0_APERTURE_SIZE),
    .PF1_SRIOV_BAR0_CONTROL (PF1_SRIOV_BAR0_CONTROL),
    .PF1_SRIOV_BAR1_APERTURE_SIZE (PF1_SRIOV_BAR1_APERTURE_SIZE),
    .PF1_SRIOV_BAR1_CONTROL (PF1_SRIOV_BAR1_CONTROL),
    .PF1_SRIOV_BAR2_APERTURE_SIZE (PF1_SRIOV_BAR2_APERTURE_SIZE),
    .PF1_SRIOV_BAR2_CONTROL (PF1_SRIOV_BAR2_CONTROL),
    .PF1_SRIOV_BAR3_APERTURE_SIZE (PF1_SRIOV_BAR3_APERTURE_SIZE),
    .PF1_SRIOV_BAR3_CONTROL (PF1_SRIOV_BAR3_CONTROL),
    .PF1_SRIOV_BAR4_APERTURE_SIZE (PF1_SRIOV_BAR4_APERTURE_SIZE),
    .PF1_SRIOV_BAR4_CONTROL (PF1_SRIOV_BAR4_CONTROL),
    .PF1_SRIOV_BAR5_APERTURE_SIZE (PF1_SRIOV_BAR5_APERTURE_SIZE),
    .PF1_SRIOV_BAR5_CONTROL (PF1_SRIOV_BAR5_CONTROL),
    .PF1_SRIOV_CAP_INITIAL_VF (PF1_SRIOV_CAP_INITIAL_VF),
    .PF1_SRIOV_CAP_NEXTPTR (PF1_SRIOV_CAP_NEXTPTR),
    .PF1_SRIOV_CAP_TOTAL_VF (PF1_SRIOV_CAP_TOTAL_VF),
    .PF1_SRIOV_CAP_VER (PF1_SRIOV_CAP_VER),
    .PF1_SRIOV_FIRST_VF_OFFSET (PF1_SRIOV_FIRST_VF_OFFSET),
    .PF1_SRIOV_FUNC_DEP_LINK (PF1_SRIOV_FUNC_DEP_LINK),
    .PF1_SRIOV_SUPPORTED_PAGE_SIZE (PF1_SRIOV_SUPPORTED_PAGE_SIZE),
    .PF1_SRIOV_VF_DEVICE_ID (PF1_SRIOV_VF_DEVICE_ID),
    .PF1_SUBSYSTEM_ID (PF1_SUBSYSTEM_ID),
    .PF1_TPHR_CAP_DEV_SPECIFIC_MODE (PF1_TPHR_CAP_DEV_SPECIFIC_MODE),
    .PF1_TPHR_CAP_ENABLE (PF1_TPHR_CAP_ENABLE),
    .PF1_TPHR_CAP_INT_VEC_MODE (PF1_TPHR_CAP_INT_VEC_MODE),
    .PF1_TPHR_CAP_NEXTPTR (PF1_TPHR_CAP_NEXTPTR),
    .PF1_TPHR_CAP_ST_MODE_SEL (PF1_TPHR_CAP_ST_MODE_SEL),
    .PF1_TPHR_CAP_ST_TABLE_LOC (PF1_TPHR_CAP_ST_TABLE_LOC),
    .PF1_TPHR_CAP_ST_TABLE_SIZE (PF1_TPHR_CAP_ST_TABLE_SIZE),
    .PF1_TPHR_CAP_VER (PF1_TPHR_CAP_VER),
    .PF2_AER_CAP_ECRC_CHECK_CAPABLE (PF2_AER_CAP_ECRC_CHECK_CAPABLE),
    .PF2_AER_CAP_ECRC_GEN_CAPABLE (PF2_AER_CAP_ECRC_GEN_CAPABLE),
    .PF2_AER_CAP_NEXTPTR (PF2_AER_CAP_NEXTPTR),
    .PF2_ARI_CAP_NEXT_FUNC (PF2_ARI_CAP_NEXT_FUNC),
    .PF2_ARI_CAP_NEXTPTR (PF2_ARI_CAP_NEXTPTR),
    .PF2_BAR0_APERTURE_SIZE (PF2_BAR0_APERTURE_SIZE),
    .PF2_BAR0_CONTROL (PF2_BAR0_CONTROL),
    .PF2_BAR1_APERTURE_SIZE (PF2_BAR1_APERTURE_SIZE),
    .PF2_BAR1_CONTROL (PF2_BAR1_CONTROL),
    .PF2_BAR2_APERTURE_SIZE (PF2_BAR2_APERTURE_SIZE),
    .PF2_BAR2_CONTROL (PF2_BAR2_CONTROL),
    .PF2_BAR3_APERTURE_SIZE (PF2_BAR3_APERTURE_SIZE),
    .PF2_BAR3_CONTROL (PF2_BAR3_CONTROL),
    .PF2_BAR4_APERTURE_SIZE (PF2_BAR4_APERTURE_SIZE),
    .PF2_BAR4_CONTROL (PF2_BAR4_CONTROL),
    .PF2_BAR5_APERTURE_SIZE (PF2_BAR5_APERTURE_SIZE),
    .PF2_BAR5_CONTROL (PF2_BAR5_CONTROL),
    .PF2_BIST_REGISTER (PF2_BIST_REGISTER),
    .PF2_CAPABILITY_POINTER (PF2_CAPABILITY_POINTER),
    .PF2_CLASS_CODE (PF2_CLASS_CODE),
    .PF2_DEV_CAP_MAX_PAYLOAD_SIZE (PF2_DEV_CAP_MAX_PAYLOAD_SIZE),
    .PF2_DEVICE_ID (PF2_DEVICE_ID),
    .PF2_DPA_CAP_NEXTPTR (PF2_DPA_CAP_NEXTPTR),
    .PF2_DPA_CAP_SUB_STATE_CONTROL (PF2_DPA_CAP_SUB_STATE_CONTROL),
    .PF2_DPA_CAP_SUB_STATE_CONTROL_EN (PF2_DPA_CAP_SUB_STATE_CONTROL_EN),
    .PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION0 (PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION0),
    .PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION1 (PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION1),
    .PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION2 (PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION2),
    .PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION3 (PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION3),
    .PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION4 (PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION4),
    .PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION5 (PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION5),
    .PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION6 (PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION6),
    .PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION7 (PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION7),
    .PF2_DPA_CAP_VER (PF2_DPA_CAP_VER),
    .PF2_DSN_CAP_NEXTPTR (PF2_DSN_CAP_NEXTPTR),
    .PF2_EXPANSION_ROM_APERTURE_SIZE (PF2_EXPANSION_ROM_APERTURE_SIZE),
    .PF2_EXPANSION_ROM_ENABLE (PF2_EXPANSION_ROM_ENABLE),
    .PF2_INTERRUPT_LINE (PF2_INTERRUPT_LINE),
    .PF2_INTERRUPT_PIN (PF2_INTERRUPT_PIN),
    .PF2_MSI_CAP_MULTIMSGCAP (PF2_MSI_CAP_MULTIMSGCAP),
    .PF2_MSI_CAP_NEXTPTR (PF2_MSI_CAP_NEXTPTR),
    .PF2_MSI_CAP_PERVECMASKCAP (PF2_MSI_CAP_PERVECMASKCAP),
    .PF2_MSIX_CAP_NEXTPTR (PF2_MSIX_CAP_NEXTPTR),
    .PF2_MSIX_CAP_PBA_BIR (PF2_MSIX_CAP_PBA_BIR),
    .PF2_MSIX_CAP_PBA_OFFSET ({3'b000,PF2_MSIX_CAP_PBA_OFFSET[28:3]}),
    .PF2_MSIX_CAP_TABLE_BIR (PF2_MSIX_CAP_TABLE_BIR),
    .PF2_MSIX_CAP_TABLE_OFFSET ({3'b000,PF2_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .PF2_MSIX_CAP_TABLE_SIZE (PF2_MSIX_CAP_TABLE_SIZE),
    .PF2_PB_CAP_DATA_REG_D0 (PF2_PB_CAP_DATA_REG_D0),
    .PF2_PB_CAP_DATA_REG_D0_SUSTAINED (PF2_PB_CAP_DATA_REG_D0_SUSTAINED),
    .PF2_PB_CAP_DATA_REG_D1 (PF2_PB_CAP_DATA_REG_D1),
    .PF2_PB_CAP_DATA_REG_D3HOT (PF2_PB_CAP_DATA_REG_D3HOT),
    .PF2_PB_CAP_NEXTPTR (PF2_PB_CAP_NEXTPTR),
    .PF2_PB_CAP_SYSTEM_ALLOCATED (PF2_PB_CAP_SYSTEM_ALLOCATED),
    .PF2_PB_CAP_VER (PF2_PB_CAP_VER),
    .PF2_PM_CAP_ID (PF2_PM_CAP_ID),
    .PF2_PM_CAP_NEXTPTR (PF2_PM_CAP_NEXTPTR),
    .PF2_PM_CAP_VER_ID (PF2_PM_CAP_VER_ID),
    .PF2_RBAR_CAP_ENABLE (PF2_RBAR_CAP_ENABLE),
    .PF2_RBAR_CAP_NEXTPTR (PF2_RBAR_CAP_NEXTPTR),
    .PF2_RBAR_CAP_SIZE0 (PF2_RBAR_CAP_SIZE0),
    .PF2_RBAR_CAP_SIZE1 (PF2_RBAR_CAP_SIZE1),
    .PF2_RBAR_CAP_SIZE2 (PF2_RBAR_CAP_SIZE2),
    .PF2_RBAR_CAP_VER (PF2_RBAR_CAP_VER),
    .PF2_RBAR_CONTROL_INDEX0 (PF2_RBAR_CONTROL_INDEX0),
    .PF2_RBAR_CONTROL_INDEX1 (PF2_RBAR_CONTROL_INDEX1),
    .PF2_RBAR_CONTROL_INDEX2 (PF2_RBAR_CONTROL_INDEX2),
    .PF2_RBAR_CONTROL_SIZE0 (PF2_RBAR_CONTROL_SIZE0),
    .PF2_RBAR_CONTROL_SIZE1 (PF2_RBAR_CONTROL_SIZE1),
    .PF2_RBAR_CONTROL_SIZE2 (PF2_RBAR_CONTROL_SIZE2),
    .PF2_RBAR_NUM (PF2_RBAR_NUM),
    .PF2_REVISION_ID (PF2_REVISION_ID),
    .PF2_SRIOV_BAR0_APERTURE_SIZE (PF2_SRIOV_BAR0_APERTURE_SIZE),
    .PF2_SRIOV_BAR0_CONTROL (PF2_SRIOV_BAR0_CONTROL),
    .PF2_SRIOV_BAR1_APERTURE_SIZE (PF2_SRIOV_BAR1_APERTURE_SIZE),
    .PF2_SRIOV_BAR1_CONTROL (PF2_SRIOV_BAR1_CONTROL),
    .PF2_SRIOV_BAR2_APERTURE_SIZE (PF2_SRIOV_BAR2_APERTURE_SIZE),
    .PF2_SRIOV_BAR2_CONTROL (PF2_SRIOV_BAR2_CONTROL),
    .PF2_SRIOV_BAR3_APERTURE_SIZE (PF2_SRIOV_BAR3_APERTURE_SIZE),
    .PF2_SRIOV_BAR3_CONTROL (PF2_SRIOV_BAR3_CONTROL),
    .PF2_SRIOV_BAR4_APERTURE_SIZE (PF2_SRIOV_BAR4_APERTURE_SIZE),
    .PF2_SRIOV_BAR4_CONTROL (PF2_SRIOV_BAR4_CONTROL),
    .PF2_SRIOV_BAR5_APERTURE_SIZE (PF2_SRIOV_BAR5_APERTURE_SIZE),
    .PF2_SRIOV_BAR5_CONTROL (PF2_SRIOV_BAR5_CONTROL),
    .PF2_SRIOV_CAP_INITIAL_VF (PF2_SRIOV_CAP_INITIAL_VF),
    .PF2_SRIOV_CAP_NEXTPTR (PF2_SRIOV_CAP_NEXTPTR),
    .PF2_SRIOV_CAP_TOTAL_VF (PF2_SRIOV_CAP_TOTAL_VF),
    .PF2_SRIOV_CAP_VER (PF2_SRIOV_CAP_VER),
    .PF2_SRIOV_FIRST_VF_OFFSET (PF2_SRIOV_FIRST_VF_OFFSET),
    .PF2_SRIOV_FUNC_DEP_LINK (PF2_SRIOV_FUNC_DEP_LINK),
    .PF2_SRIOV_SUPPORTED_PAGE_SIZE (PF2_SRIOV_SUPPORTED_PAGE_SIZE),
    .PF2_SRIOV_VF_DEVICE_ID (PF2_SRIOV_VF_DEVICE_ID),
    .PF2_SUBSYSTEM_ID (PF2_SUBSYSTEM_ID),
    .PF2_TPHR_CAP_DEV_SPECIFIC_MODE (PF2_TPHR_CAP_DEV_SPECIFIC_MODE),
    .PF2_TPHR_CAP_ENABLE (PF2_TPHR_CAP_ENABLE),
    .PF2_TPHR_CAP_INT_VEC_MODE (PF2_TPHR_CAP_INT_VEC_MODE),
    .PF2_TPHR_CAP_NEXTPTR (PF2_TPHR_CAP_NEXTPTR),
    .PF2_TPHR_CAP_ST_MODE_SEL (PF2_TPHR_CAP_ST_MODE_SEL),
    .PF2_TPHR_CAP_ST_TABLE_LOC (PF2_TPHR_CAP_ST_TABLE_LOC),
    .PF2_TPHR_CAP_ST_TABLE_SIZE (PF2_TPHR_CAP_ST_TABLE_SIZE),
    .PF2_TPHR_CAP_VER (PF2_TPHR_CAP_VER),
    .PF3_AER_CAP_ECRC_CHECK_CAPABLE (PF3_AER_CAP_ECRC_CHECK_CAPABLE),
    .PF3_AER_CAP_ECRC_GEN_CAPABLE (PF3_AER_CAP_ECRC_GEN_CAPABLE),
    .PF3_AER_CAP_NEXTPTR (PF3_AER_CAP_NEXTPTR),
    .PF3_ARI_CAP_NEXT_FUNC (PF3_ARI_CAP_NEXT_FUNC),
    .PF3_ARI_CAP_NEXTPTR (PF3_ARI_CAP_NEXTPTR),
    .PF3_BAR0_APERTURE_SIZE (PF3_BAR0_APERTURE_SIZE),
    .PF3_BAR0_CONTROL (PF3_BAR0_CONTROL),
    .PF3_BAR1_APERTURE_SIZE (PF3_BAR1_APERTURE_SIZE),
    .PF3_BAR1_CONTROL (PF3_BAR1_CONTROL),
    .PF3_BAR2_APERTURE_SIZE (PF3_BAR2_APERTURE_SIZE),
    .PF3_BAR2_CONTROL (PF3_BAR2_CONTROL),
    .PF3_BAR3_APERTURE_SIZE (PF3_BAR3_APERTURE_SIZE),
    .PF3_BAR3_CONTROL (PF3_BAR3_CONTROL),
    .PF3_BAR4_APERTURE_SIZE (PF3_BAR4_APERTURE_SIZE),
    .PF3_BAR4_CONTROL (PF3_BAR4_CONTROL),
    .PF3_BAR5_APERTURE_SIZE (PF3_BAR5_APERTURE_SIZE),
    .PF3_BAR5_CONTROL (PF3_BAR5_CONTROL),
    .PF3_BIST_REGISTER (PF3_BIST_REGISTER),
    .PF3_CAPABILITY_POINTER (PF3_CAPABILITY_POINTER),
    .PF3_CLASS_CODE (PF3_CLASS_CODE),
    .PF3_DEV_CAP_MAX_PAYLOAD_SIZE (PF3_DEV_CAP_MAX_PAYLOAD_SIZE),
    .PF3_DEVICE_ID (PF3_DEVICE_ID),
    .PF3_DPA_CAP_NEXTPTR (PF3_DPA_CAP_NEXTPTR),
    .PF3_DPA_CAP_SUB_STATE_CONTROL (PF3_DPA_CAP_SUB_STATE_CONTROL),
    .PF3_DPA_CAP_SUB_STATE_CONTROL_EN (PF3_DPA_CAP_SUB_STATE_CONTROL_EN),
    .PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION0 (PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION0),
    .PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION1 (PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION1),
    .PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION2 (PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION2),
    .PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION3 (PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION3),
    .PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION4 (PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION4),
    .PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION5 (PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION5),
    .PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION6 (PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION6),
    .PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION7 (PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION7),
    .PF3_DPA_CAP_VER (PF3_DPA_CAP_VER),
    .PF3_DSN_CAP_NEXTPTR (PF3_DSN_CAP_NEXTPTR),
    .PF3_EXPANSION_ROM_APERTURE_SIZE (PF3_EXPANSION_ROM_APERTURE_SIZE),
    .PF3_EXPANSION_ROM_ENABLE (PF3_EXPANSION_ROM_ENABLE),
    .PF3_INTERRUPT_LINE (PF3_INTERRUPT_LINE),
    .PF3_INTERRUPT_PIN (PF3_INTERRUPT_PIN),
    .PF3_MSI_CAP_MULTIMSGCAP (PF3_MSI_CAP_MULTIMSGCAP),
    .PF3_MSI_CAP_NEXTPTR (PF3_MSI_CAP_NEXTPTR),
    .PF3_MSI_CAP_PERVECMASKCAP (PF3_MSI_CAP_PERVECMASKCAP),
    .PF3_MSIX_CAP_NEXTPTR (PF3_MSIX_CAP_NEXTPTR),
    .PF3_MSIX_CAP_PBA_BIR (PF3_MSIX_CAP_PBA_BIR),
    .PF3_MSIX_CAP_PBA_OFFSET ({3'b000,PF3_MSIX_CAP_PBA_OFFSET[28:3]}),
    .PF3_MSIX_CAP_TABLE_BIR (PF3_MSIX_CAP_TABLE_BIR),
    .PF3_MSIX_CAP_TABLE_OFFSET ({3'b000,PF3_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .PF3_MSIX_CAP_TABLE_SIZE (PF3_MSIX_CAP_TABLE_SIZE),
    .PF3_PB_CAP_DATA_REG_D0 (PF3_PB_CAP_DATA_REG_D0),
    .PF3_PB_CAP_DATA_REG_D0_SUSTAINED (PF3_PB_CAP_DATA_REG_D0_SUSTAINED),
    .PF3_PB_CAP_DATA_REG_D1 (PF3_PB_CAP_DATA_REG_D1),
    .PF3_PB_CAP_DATA_REG_D3HOT (PF3_PB_CAP_DATA_REG_D3HOT),
    .PF3_PB_CAP_NEXTPTR (PF3_PB_CAP_NEXTPTR),
    .PF3_PB_CAP_SYSTEM_ALLOCATED (PF3_PB_CAP_SYSTEM_ALLOCATED),
    .PF3_PB_CAP_VER (PF3_PB_CAP_VER),
    .PF3_PM_CAP_ID (PF3_PM_CAP_ID),
    .PF3_PM_CAP_NEXTPTR (PF3_PM_CAP_NEXTPTR),
    .PF3_PM_CAP_VER_ID (PF3_PM_CAP_VER_ID),
    .PF3_RBAR_CAP_ENABLE (PF3_RBAR_CAP_ENABLE),
    .PF3_RBAR_CAP_NEXTPTR (PF3_RBAR_CAP_NEXTPTR),
    .PF3_RBAR_CAP_SIZE0 (PF3_RBAR_CAP_SIZE0),
    .PF3_RBAR_CAP_SIZE1 (PF3_RBAR_CAP_SIZE1),
    .PF3_RBAR_CAP_SIZE2 (PF3_RBAR_CAP_SIZE2),
    .PF3_RBAR_CAP_VER (PF3_RBAR_CAP_VER),
    .PF3_RBAR_CONTROL_INDEX0 (PF3_RBAR_CONTROL_INDEX0),
    .PF3_RBAR_CONTROL_INDEX1 (PF3_RBAR_CONTROL_INDEX1),
    .PF3_RBAR_CONTROL_INDEX2 (PF3_RBAR_CONTROL_INDEX2),
    .PF3_RBAR_CONTROL_SIZE0 (PF3_RBAR_CONTROL_SIZE0),
    .PF3_RBAR_CONTROL_SIZE1 (PF3_RBAR_CONTROL_SIZE1),
    .PF3_RBAR_CONTROL_SIZE2 (PF3_RBAR_CONTROL_SIZE2),
    .PF3_RBAR_NUM (PF3_RBAR_NUM),
    .PF3_REVISION_ID (PF3_REVISION_ID),
    .PF3_SRIOV_BAR0_APERTURE_SIZE (PF3_SRIOV_BAR0_APERTURE_SIZE),
    .PF3_SRIOV_BAR0_CONTROL (PF3_SRIOV_BAR0_CONTROL),
    .PF3_SRIOV_BAR1_APERTURE_SIZE (PF3_SRIOV_BAR1_APERTURE_SIZE),
    .PF3_SRIOV_BAR1_CONTROL (PF3_SRIOV_BAR1_CONTROL),
    .PF3_SRIOV_BAR2_APERTURE_SIZE (PF3_SRIOV_BAR2_APERTURE_SIZE),
    .PF3_SRIOV_BAR2_CONTROL (PF3_SRIOV_BAR2_CONTROL),
    .PF3_SRIOV_BAR3_APERTURE_SIZE (PF3_SRIOV_BAR3_APERTURE_SIZE),
    .PF3_SRIOV_BAR3_CONTROL (PF3_SRIOV_BAR3_CONTROL),
    .PF3_SRIOV_BAR4_APERTURE_SIZE (PF3_SRIOV_BAR4_APERTURE_SIZE),
    .PF3_SRIOV_BAR4_CONTROL (PF3_SRIOV_BAR4_CONTROL),
    .PF3_SRIOV_BAR5_APERTURE_SIZE (PF3_SRIOV_BAR5_APERTURE_SIZE),
    .PF3_SRIOV_BAR5_CONTROL (PF3_SRIOV_BAR5_CONTROL),
    .PF3_SRIOV_CAP_INITIAL_VF (PF3_SRIOV_CAP_INITIAL_VF),
    .PF3_SRIOV_CAP_NEXTPTR (PF3_SRIOV_CAP_NEXTPTR),
    .PF3_SRIOV_CAP_TOTAL_VF (PF3_SRIOV_CAP_TOTAL_VF),
    .PF3_SRIOV_CAP_VER (PF3_SRIOV_CAP_VER),
    .PF3_SRIOV_FIRST_VF_OFFSET (PF3_SRIOV_FIRST_VF_OFFSET),
    .PF3_SRIOV_FUNC_DEP_LINK (PF3_SRIOV_FUNC_DEP_LINK),
    .PF3_SRIOV_SUPPORTED_PAGE_SIZE (PF3_SRIOV_SUPPORTED_PAGE_SIZE),
    .PF3_SRIOV_VF_DEVICE_ID (PF3_SRIOV_VF_DEVICE_ID),
    .PF3_SUBSYSTEM_ID (PF3_SUBSYSTEM_ID),
    .PF3_TPHR_CAP_DEV_SPECIFIC_MODE (PF3_TPHR_CAP_DEV_SPECIFIC_MODE),
    .PF3_TPHR_CAP_ENABLE (PF3_TPHR_CAP_ENABLE),
    .PF3_TPHR_CAP_INT_VEC_MODE (PF3_TPHR_CAP_INT_VEC_MODE),
    .PF3_TPHR_CAP_NEXTPTR (PF3_TPHR_CAP_NEXTPTR),
    .PF3_TPHR_CAP_ST_MODE_SEL (PF3_TPHR_CAP_ST_MODE_SEL),
    .PF3_TPHR_CAP_ST_TABLE_LOC (PF3_TPHR_CAP_ST_TABLE_LOC),
    .PF3_TPHR_CAP_ST_TABLE_SIZE (PF3_TPHR_CAP_ST_TABLE_SIZE),
    .PF3_TPHR_CAP_VER (PF3_TPHR_CAP_VER),
    .PL_DISABLE_AUTO_EQ_SPEED_CHANGE_TO_GEN3 (PL_DISABLE_AUTO_EQ_SPEED_CHANGE_TO_GEN3),
    .PL_DISABLE_AUTO_SPEED_CHANGE_TO_GEN2 (PL_DISABLE_AUTO_SPEED_CHANGE_TO_GEN2),
    .PL_DISABLE_EI_INFER_IN_L0 (PL_DISABLE_EI_INFER_IN_L0),
    .PL_DISABLE_GEN3_DC_BALANCE (PL_DISABLE_GEN3_DC_BALANCE),
    .PL_DISABLE_GEN3_LFSR_UPDATE_ON_SKP (PL_DISABLE_GEN3_LFSR_UPDATE_ON_SKP),
    .PL_DISABLE_RETRAIN_ON_FRAMING_ERROR (PL_DISABLE_RETRAIN_ON_FRAMING_ERROR),
    .PL_DISABLE_SCRAMBLING (PL_DISABLE_SCRAMBLING),
    .PL_DISABLE_SYNC_HEADER_FRAMING_ERROR (PL_DISABLE_SYNC_HEADER_FRAMING_ERROR),
    .PL_DISABLE_UPCONFIG_CAPABLE (PL_DISABLE_UPCONFIG_CAPABLE),
    .PL_EQ_ADAPT_DISABLE_COEFF_CHECK (PL_EQ_ADAPT_DISABLE_COEFF_CHECK),
    .PL_EQ_ADAPT_DISABLE_PRESET_CHECK (PL_EQ_ADAPT_DISABLE_PRESET_CHECK),
    .PL_EQ_ADAPT_ITER_COUNT (PL_EQ_ADAPT_ITER_COUNT),
    .PL_EQ_ADAPT_REJECT_RETRY_COUNT (PL_EQ_ADAPT_REJECT_RETRY_COUNT),
    .PL_EQ_BYPASS_PHASE23 (PL_EQ_BYPASS_PHASE23),
    .PL_EQ_DEFAULT_GEN3_RX_PRESET_HINT (PL_EQ_DEFAULT_GEN3_RX_PRESET_HINT),
    .PL_EQ_DEFAULT_GEN3_TX_PRESET (PL_EQ_DEFAULT_GEN3_TX_PRESET),
    .PL_EQ_PHASE01_RX_ADAPT (PL_EQ_PHASE01_RX_ADAPT),
    .PL_EQ_SHORT_ADAPT_PHASE (PL_EQ_SHORT_ADAPT_PHASE),
    .PL_LANE0_EQ_CONTROL (PL_LANE0_EQ_CONTROL),
    .PL_LANE1_EQ_CONTROL (PL_LANE1_EQ_CONTROL),
    .PL_LANE2_EQ_CONTROL (PL_LANE2_EQ_CONTROL),
    .PL_LANE3_EQ_CONTROL (PL_LANE3_EQ_CONTROL),
    .PL_LANE4_EQ_CONTROL (PL_LANE4_EQ_CONTROL),
    .PL_LANE5_EQ_CONTROL (PL_LANE5_EQ_CONTROL),
    .PL_LANE6_EQ_CONTROL (PL_LANE6_EQ_CONTROL),
    .PL_LANE7_EQ_CONTROL (PL_LANE7_EQ_CONTROL),
    .PL_LINK_CAP_MAX_LINK_SPEED (PL_LINK_CAP_MAX_LINK_SPEED),
    .PL_LINK_CAP_MAX_LINK_WIDTH (PL_LINK_CAP_MAX_LINK_WIDTH),
    .PL_N_FTS_COMCLK_GEN1 (PL_N_FTS_COMCLK_GEN1),
    .PL_N_FTS_COMCLK_GEN2 (PL_N_FTS_COMCLK_GEN2),
    .PL_N_FTS_COMCLK_GEN3 (PL_N_FTS_COMCLK_GEN3),
    .PL_N_FTS_GEN1 (PL_N_FTS_GEN1),
    .PL_N_FTS_GEN2 (PL_N_FTS_GEN2),
    .PL_N_FTS_GEN3 (PL_N_FTS_GEN3),
    .PL_REPORT_ALL_PHY_ERRORS (PL_REPORT_ALL_PHY_ERRORS),
  // synthesis translate_off
    .PL_SIM_FAST_LINK_TRAINING (PL_SIM_FAST_LINK_TRAINING),
  // synthesis translate_on
    .PL_UPSTREAM_FACING (PL_UPSTREAM_FACING),
    .PM_ASPML0S_TIMEOUT (PM_ASPML0S_TIMEOUT),
    .PM_ASPML1_ENTRY_DELAY (PM_ASPML1_ENTRY_DELAY),
    .PM_ENABLE_L23_ENTRY (PM_ENABLE_L23_ENTRY),
    .PM_ENABLE_SLOT_POWER_CAPTURE (PM_ENABLE_SLOT_POWER_CAPTURE),
    .PM_L1_REENTRY_DELAY (PM_L1_REENTRY_DELAY),
    .PM_PME_SERVICE_TIMEOUT_DELAY (PM_PME_SERVICE_TIMEOUT_DELAY),
    .PM_PME_TURNOFF_ACK_DELAY (PM_PME_TURNOFF_ACK_DELAY),
    .SIM_JTAG_IDCODE (SIM_JTAG_IDCODE),
    .SIM_VERSION (SIM_VERSION),
    .SPARE_BIT0 (SPARE_BIT0),
    .SPARE_BIT1 (SPARE_BIT1),
    .SPARE_BIT2 (SPARE_BIT2),
    .SPARE_BIT3 (SPARE_BIT3),
    .SPARE_BIT4 (SPARE_BIT4),
    .SPARE_BIT5 (SPARE_BIT5),
    .SPARE_BIT6 (SPARE_BIT6),
    .SPARE_BIT7 (SPARE_BIT7),
    .SPARE_BIT8 (SPARE_BIT8),
    .SPARE_BYTE0 (SPARE_BYTE0),
    .SPARE_BYTE1 (SPARE_BYTE1),
    .SPARE_BYTE2 (SPARE_BYTE2),
    .SPARE_BYTE3 (SPARE_BYTE3),
    .SPARE_WORD0 (SPARE_WORD0),
    .SPARE_WORD1 (SPARE_WORD1),
    .SPARE_WORD2 (SPARE_WORD2),
    .SPARE_WORD3 (SPARE_WORD3),
    .SRIOV_CAP_ENABLE (SRIOV_CAP_ENABLE),
    .TL_COMPL_TIMEOUT_REG0 (TL_COMPL_TIMEOUT_REG0),
    .TL_COMPL_TIMEOUT_REG1 (TL_COMPL_TIMEOUT_REG1),
    .TL_CREDITS_CD (TL_CREDITS_CD),
    .TL_CREDITS_CH (TL_CREDITS_CH),
    .TL_CREDITS_NPD (TL_CREDITS_NPD),
    .TL_CREDITS_NPH (TL_CREDITS_NPH),
    .TL_CREDITS_PD (TL_CREDITS_PD),
    .TL_CREDITS_PH (TL_CREDITS_PH),
    .TL_ENABLE_MESSAGE_RID_CHECK_ENABLE (TL_ENABLE_MESSAGE_RID_CHECK_ENABLE),
    .TL_EXTENDED_CFG_EXTEND_INTERFACE_ENABLE (TL_EXTENDED_CFG_EXTEND_INTERFACE_ENABLE),
    .TL_LEGACY_CFG_EXTEND_INTERFACE_ENABLE (TL_LEGACY_CFG_EXTEND_INTERFACE_ENABLE),
    .TL_LEGACY_MODE_ENABLE (TL_LEGACY_MODE_ENABLE),
    .TL_PF_ENABLE_REG (TL_PF_ENABLE_REG),
    .TL_TX_MUX_STRICT_PRIORITY (TL_TX_MUX_STRICT_PRIORITY),
    .TWO_LAYER_MODE_DLCMSM_ENABLE (TWO_LAYER_MODE_DLCMSM_ENABLE),
    .TWO_LAYER_MODE_ENABLE (TWO_LAYER_MODE_ENABLE),
    .TWO_LAYER_MODE_WIDTH_256 (TWO_LAYER_MODE_WIDTH_256),
    .VF0_ARI_CAP_NEXTPTR (VF0_ARI_CAP_NEXTPTR),
    .VF0_CAPABILITY_POINTER (VF0_CAPABILITY_POINTER),
    .VF0_MSI_CAP_MULTIMSGCAP (VF0_MSI_CAP_MULTIMSGCAP),
    .VF0_MSIX_CAP_PBA_BIR (VF0_MSIX_CAP_PBA_BIR),
    .VF0_MSIX_CAP_PBA_OFFSET ({3'b000,VF0_MSIX_CAP_PBA_OFFSET[28:3]}),
    .VF0_MSIX_CAP_TABLE_BIR (VF0_MSIX_CAP_TABLE_BIR),
    .VF0_MSIX_CAP_TABLE_OFFSET ({3'b000,VF0_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .VF0_MSIX_CAP_TABLE_SIZE (VF0_MSIX_CAP_TABLE_SIZE),
    .VF0_PM_CAP_ID (VF0_PM_CAP_ID),
    .VF0_PM_CAP_NEXTPTR (VF0_PM_CAP_NEXTPTR),
    .VF0_PM_CAP_VER_ID (VF0_PM_CAP_VER_ID),
    .VF0_TPHR_CAP_DEV_SPECIFIC_MODE (VF0_TPHR_CAP_DEV_SPECIFIC_MODE),
    .VF0_TPHR_CAP_ENABLE (VF0_TPHR_CAP_ENABLE),
    .VF0_TPHR_CAP_INT_VEC_MODE (VF0_TPHR_CAP_INT_VEC_MODE),
    .VF0_TPHR_CAP_NEXTPTR (VF0_TPHR_CAP_NEXTPTR),
    .VF0_TPHR_CAP_ST_MODE_SEL (VF0_TPHR_CAP_ST_MODE_SEL),
    .VF0_TPHR_CAP_ST_TABLE_LOC (VF0_TPHR_CAP_ST_TABLE_LOC),
    .VF0_TPHR_CAP_ST_TABLE_SIZE (VF0_TPHR_CAP_ST_TABLE_SIZE),
    .VF0_TPHR_CAP_VER (VF0_TPHR_CAP_VER),
    .VF1_ARI_CAP_NEXTPTR (VF1_ARI_CAP_NEXTPTR),
    .VF1_MSI_CAP_MULTIMSGCAP (VF1_MSI_CAP_MULTIMSGCAP),
    .VF1_MSIX_CAP_PBA_BIR (VF1_MSIX_CAP_PBA_BIR),
    .VF1_MSIX_CAP_PBA_OFFSET ({3'b000,VF1_MSIX_CAP_PBA_OFFSET[28:3]}),
    .VF1_MSIX_CAP_TABLE_BIR (VF1_MSIX_CAP_TABLE_BIR),
    .VF1_MSIX_CAP_TABLE_OFFSET ({3'b000,VF1_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .VF1_MSIX_CAP_TABLE_SIZE (VF1_MSIX_CAP_TABLE_SIZE),
    .VF1_PM_CAP_ID (VF1_PM_CAP_ID),
    .VF1_PM_CAP_NEXTPTR (VF1_PM_CAP_NEXTPTR),
    .VF1_PM_CAP_VER_ID (VF1_PM_CAP_VER_ID),
    .VF1_TPHR_CAP_DEV_SPECIFIC_MODE (VF1_TPHR_CAP_DEV_SPECIFIC_MODE),
    .VF1_TPHR_CAP_ENABLE (VF1_TPHR_CAP_ENABLE),
    .VF1_TPHR_CAP_INT_VEC_MODE (VF1_TPHR_CAP_INT_VEC_MODE),
    .VF1_TPHR_CAP_NEXTPTR (VF1_TPHR_CAP_NEXTPTR),
    .VF1_TPHR_CAP_ST_MODE_SEL (VF1_TPHR_CAP_ST_MODE_SEL),
    .VF1_TPHR_CAP_ST_TABLE_LOC (VF1_TPHR_CAP_ST_TABLE_LOC),
    .VF1_TPHR_CAP_ST_TABLE_SIZE (VF1_TPHR_CAP_ST_TABLE_SIZE),
    .VF1_TPHR_CAP_VER (VF1_TPHR_CAP_VER),
    .VF2_ARI_CAP_NEXTPTR (VF2_ARI_CAP_NEXTPTR),
    .VF2_MSI_CAP_MULTIMSGCAP (VF2_MSI_CAP_MULTIMSGCAP),
    .VF2_MSIX_CAP_PBA_BIR (VF2_MSIX_CAP_PBA_BIR),
    .VF2_MSIX_CAP_PBA_OFFSET ({3'b000,VF2_MSIX_CAP_PBA_OFFSET[28:3]}),
    .VF2_MSIX_CAP_TABLE_BIR (VF2_MSIX_CAP_TABLE_BIR),
    .VF2_MSIX_CAP_TABLE_OFFSET ({3'b000,VF2_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .VF2_MSIX_CAP_TABLE_SIZE (VF2_MSIX_CAP_TABLE_SIZE),
    .VF2_PM_CAP_ID (VF2_PM_CAP_ID),
    .VF2_PM_CAP_NEXTPTR (VF2_PM_CAP_NEXTPTR),
    .VF2_PM_CAP_VER_ID (VF2_PM_CAP_VER_ID),
    .VF2_TPHR_CAP_DEV_SPECIFIC_MODE (VF2_TPHR_CAP_DEV_SPECIFIC_MODE),
    .VF2_TPHR_CAP_ENABLE (VF2_TPHR_CAP_ENABLE),
    .VF2_TPHR_CAP_INT_VEC_MODE (VF2_TPHR_CAP_INT_VEC_MODE),
    .VF2_TPHR_CAP_NEXTPTR (VF2_TPHR_CAP_NEXTPTR),
    .VF2_TPHR_CAP_ST_MODE_SEL (VF2_TPHR_CAP_ST_MODE_SEL),
    .VF2_TPHR_CAP_ST_TABLE_LOC (VF2_TPHR_CAP_ST_TABLE_LOC),
    .VF2_TPHR_CAP_ST_TABLE_SIZE (VF2_TPHR_CAP_ST_TABLE_SIZE),
    .VF2_TPHR_CAP_VER (VF2_TPHR_CAP_VER),
    .VF3_ARI_CAP_NEXTPTR (VF3_ARI_CAP_NEXTPTR),
    .VF3_MSI_CAP_MULTIMSGCAP (VF3_MSI_CAP_MULTIMSGCAP),
    .VF3_MSIX_CAP_PBA_BIR (VF3_MSIX_CAP_PBA_BIR),
    .VF3_MSIX_CAP_PBA_OFFSET ({3'b000,VF3_MSIX_CAP_PBA_OFFSET[28:3]}),
    .VF3_MSIX_CAP_TABLE_BIR (VF3_MSIX_CAP_TABLE_BIR),
    .VF3_MSIX_CAP_TABLE_OFFSET ({3'b000,VF3_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .VF3_MSIX_CAP_TABLE_SIZE (VF3_MSIX_CAP_TABLE_SIZE),
    .VF3_PM_CAP_ID (VF3_PM_CAP_ID),
    .VF3_PM_CAP_NEXTPTR (VF3_PM_CAP_NEXTPTR),
    .VF3_PM_CAP_VER_ID (VF3_PM_CAP_VER_ID),
    .VF3_TPHR_CAP_DEV_SPECIFIC_MODE (VF3_TPHR_CAP_DEV_SPECIFIC_MODE),
    .VF3_TPHR_CAP_ENABLE (VF3_TPHR_CAP_ENABLE),
    .VF3_TPHR_CAP_INT_VEC_MODE (VF3_TPHR_CAP_INT_VEC_MODE),
    .VF3_TPHR_CAP_NEXTPTR (VF3_TPHR_CAP_NEXTPTR),
    .VF3_TPHR_CAP_ST_MODE_SEL (VF3_TPHR_CAP_ST_MODE_SEL),
    .VF3_TPHR_CAP_ST_TABLE_LOC (VF3_TPHR_CAP_ST_TABLE_LOC),
    .VF3_TPHR_CAP_ST_TABLE_SIZE (VF3_TPHR_CAP_ST_TABLE_SIZE),
    .VF3_TPHR_CAP_VER (VF3_TPHR_CAP_VER),
    .VF4_ARI_CAP_NEXTPTR (VF4_ARI_CAP_NEXTPTR),
    .VF4_MSI_CAP_MULTIMSGCAP (VF4_MSI_CAP_MULTIMSGCAP),
    .VF4_MSIX_CAP_PBA_BIR (VF4_MSIX_CAP_PBA_BIR),
    .VF4_MSIX_CAP_PBA_OFFSET ({3'b000,VF4_MSIX_CAP_PBA_OFFSET[28:3]}),
    .VF4_MSIX_CAP_TABLE_BIR (VF4_MSIX_CAP_TABLE_BIR),
    .VF4_MSIX_CAP_TABLE_OFFSET ({3'b000,VF4_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .VF4_MSIX_CAP_TABLE_SIZE (VF4_MSIX_CAP_TABLE_SIZE),
    .VF4_PM_CAP_ID (VF4_PM_CAP_ID),
    .VF4_PM_CAP_NEXTPTR (VF4_PM_CAP_NEXTPTR),
    .VF4_PM_CAP_VER_ID (VF4_PM_CAP_VER_ID),
    .VF4_TPHR_CAP_DEV_SPECIFIC_MODE (VF4_TPHR_CAP_DEV_SPECIFIC_MODE),
    .VF4_TPHR_CAP_ENABLE (VF4_TPHR_CAP_ENABLE),
    .VF4_TPHR_CAP_INT_VEC_MODE (VF4_TPHR_CAP_INT_VEC_MODE),
    .VF4_TPHR_CAP_NEXTPTR (VF4_TPHR_CAP_NEXTPTR),
    .VF4_TPHR_CAP_ST_MODE_SEL (VF4_TPHR_CAP_ST_MODE_SEL),
    .VF4_TPHR_CAP_ST_TABLE_LOC (VF4_TPHR_CAP_ST_TABLE_LOC),
    .VF4_TPHR_CAP_ST_TABLE_SIZE (VF4_TPHR_CAP_ST_TABLE_SIZE),
    .VF4_TPHR_CAP_VER (VF4_TPHR_CAP_VER),
    .VF5_ARI_CAP_NEXTPTR (VF5_ARI_CAP_NEXTPTR),
    .VF5_MSI_CAP_MULTIMSGCAP (VF5_MSI_CAP_MULTIMSGCAP),
    .VF5_MSIX_CAP_PBA_BIR (VF5_MSIX_CAP_PBA_BIR),
    .VF5_MSIX_CAP_PBA_OFFSET ({3'b000,VF5_MSIX_CAP_PBA_OFFSET[28:3]}),
    .VF5_MSIX_CAP_TABLE_BIR (VF5_MSIX_CAP_TABLE_BIR),
    .VF5_MSIX_CAP_TABLE_OFFSET ({3'b000,VF5_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .VF5_MSIX_CAP_TABLE_SIZE (VF5_MSIX_CAP_TABLE_SIZE),
    .VF5_PM_CAP_ID (VF5_PM_CAP_ID),
    .VF5_PM_CAP_NEXTPTR (VF5_PM_CAP_NEXTPTR),
    .VF5_PM_CAP_VER_ID (VF5_PM_CAP_VER_ID),
    .VF5_TPHR_CAP_DEV_SPECIFIC_MODE (VF5_TPHR_CAP_DEV_SPECIFIC_MODE),
    .VF5_TPHR_CAP_ENABLE (VF5_TPHR_CAP_ENABLE),
    .VF5_TPHR_CAP_INT_VEC_MODE (VF5_TPHR_CAP_INT_VEC_MODE),
    .VF5_TPHR_CAP_NEXTPTR (VF5_TPHR_CAP_NEXTPTR),
    .VF5_TPHR_CAP_ST_MODE_SEL (VF5_TPHR_CAP_ST_MODE_SEL),
    .VF5_TPHR_CAP_ST_TABLE_LOC (VF5_TPHR_CAP_ST_TABLE_LOC),
    .VF5_TPHR_CAP_ST_TABLE_SIZE (VF5_TPHR_CAP_ST_TABLE_SIZE),
    .VF5_TPHR_CAP_VER (VF5_TPHR_CAP_VER),
    .VF6_ARI_CAP_NEXTPTR (VF6_ARI_CAP_NEXTPTR),
    .VF6_MSI_CAP_MULTIMSGCAP (VF6_MSI_CAP_MULTIMSGCAP),
    .VF6_MSIX_CAP_PBA_BIR (VF6_MSIX_CAP_PBA_BIR),
    .VF6_MSIX_CAP_PBA_OFFSET ({3'b000,VF6_MSIX_CAP_PBA_OFFSET[28:3]}),
    .VF6_MSIX_CAP_TABLE_BIR (VF6_MSIX_CAP_TABLE_BIR),
    .VF6_MSIX_CAP_TABLE_OFFSET ({3'b000,VF6_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .VF6_MSIX_CAP_TABLE_SIZE (VF6_MSIX_CAP_TABLE_SIZE),
    .VF6_PM_CAP_ID (VF6_PM_CAP_ID),
    .VF6_PM_CAP_NEXTPTR (VF6_PM_CAP_NEXTPTR),
    .VF6_PM_CAP_VER_ID (VF6_PM_CAP_VER_ID),
    .VF6_TPHR_CAP_DEV_SPECIFIC_MODE (VF6_TPHR_CAP_DEV_SPECIFIC_MODE),
    .VF6_TPHR_CAP_ENABLE (VF6_TPHR_CAP_ENABLE),
    .VF6_TPHR_CAP_INT_VEC_MODE (VF6_TPHR_CAP_INT_VEC_MODE),
    .VF6_TPHR_CAP_NEXTPTR (VF6_TPHR_CAP_NEXTPTR),
    .VF6_TPHR_CAP_ST_MODE_SEL (VF6_TPHR_CAP_ST_MODE_SEL),
    .VF6_TPHR_CAP_ST_TABLE_LOC (VF6_TPHR_CAP_ST_TABLE_LOC),
    .VF6_TPHR_CAP_ST_TABLE_SIZE (VF6_TPHR_CAP_ST_TABLE_SIZE),
    .VF6_TPHR_CAP_VER (VF6_TPHR_CAP_VER),
    .VF7_ARI_CAP_NEXTPTR (VF7_ARI_CAP_NEXTPTR),
    .VF7_MSI_CAP_MULTIMSGCAP (VF7_MSI_CAP_MULTIMSGCAP),
    .VF7_MSIX_CAP_PBA_BIR (VF7_MSIX_CAP_PBA_BIR),
    .VF7_MSIX_CAP_PBA_OFFSET ({3'b000,VF7_MSIX_CAP_PBA_OFFSET[28:3]}),
    .VF7_MSIX_CAP_TABLE_BIR (VF7_MSIX_CAP_TABLE_BIR),
    .VF7_MSIX_CAP_TABLE_OFFSET ({3'b000,VF7_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .VF7_MSIX_CAP_TABLE_SIZE (VF7_MSIX_CAP_TABLE_SIZE),
    .VF7_PM_CAP_ID (VF7_PM_CAP_ID),
    .VF7_PM_CAP_NEXTPTR (VF7_PM_CAP_NEXTPTR),
    .VF7_PM_CAP_VER_ID (VF7_PM_CAP_VER_ID),
    .VF7_TPHR_CAP_DEV_SPECIFIC_MODE (VF7_TPHR_CAP_DEV_SPECIFIC_MODE),
    .VF7_TPHR_CAP_ENABLE (VF7_TPHR_CAP_ENABLE),
    .VF7_TPHR_CAP_INT_VEC_MODE (VF7_TPHR_CAP_INT_VEC_MODE),
    .VF7_TPHR_CAP_NEXTPTR (VF7_TPHR_CAP_NEXTPTR),
    .VF7_TPHR_CAP_ST_MODE_SEL (VF7_TPHR_CAP_ST_MODE_SEL),
    .VF7_TPHR_CAP_ST_TABLE_LOC (VF7_TPHR_CAP_ST_TABLE_LOC),
    .VF7_TPHR_CAP_ST_TABLE_SIZE (VF7_TPHR_CAP_ST_TABLE_SIZE),
    .VF7_TPHR_CAP_VER (VF7_TPHR_CAP_VER))
  pcie3_uscale_top_inst (
    .s_axis_rq_tdata (s_axis_rq_tdata),
    .s_axis_rq_tkeep (s_axis_rq_tkeep),
    .s_axis_rq_tlast (s_axis_rq_tlast),
    .s_axis_rq_tready (s_axis_rq_tready_wire),
    .s_axis_rq_tuser (s_axis_rq_tuser),
    .s_axis_rq_tvalid (s_axis_rq_tvalid_mux),
    .m_axis_rc_tdata (m_axis_rc_tdata),
    .m_axis_rc_tkeep (m_axis_rc_tkeep),
    .m_axis_rc_tlast (m_axis_rc_tlast),
    .m_axis_rc_tready (m_axis_rc_tready_mux),
    .m_axis_rc_tuser (m_axis_rc_tuser),
    .m_axis_rc_tvalid (m_axis_rc_tvalid_wire),
    .m_axis_cq_tdata (m_axis_cq_tdata),
    .m_axis_cq_tkeep (m_axis_cq_tkeep),
    .m_axis_cq_tlast (m_axis_cq_tlast),
    .m_axis_cq_tready (m_axis_cq_tready_mux),
    .m_axis_cq_tuser (m_axis_cq_tuser),
    .m_axis_cq_tvalid (m_axis_cq_tvalid_wire),
    .s_axis_cc_tdata (s_axis_cc_tdata),
    .s_axis_cc_tkeep (s_axis_cc_tkeep),
    .s_axis_cc_tlast (s_axis_cc_tlast),
    .s_axis_cc_tready (s_axis_cc_tready_wire),
    .s_axis_cc_tuser (s_axis_cc_tuser),
    .s_axis_cc_tvalid (s_axis_cc_tvalid_mux),
    .pcie_rq_seq_num (pcie_rq_seq_num),
    .pcie_rq_seq_num_vld (pcie_rq_seq_num_vld),
    .pcie_rq_tag (pcie_rq_tag),
    .pcie_rq_tag_av (pcie_rq_tag_av),
    .pcie_rq_tag_vld (pcie_rq_tag_vld),
    .pcie_tfc_npd_av (pcie_tfc_npd_av),
    .pcie_tfc_nph_av (pcie_tfc_nph_av),
    .pcie_cq_np_req (pcie_cq_np_req_mux),
    .pcie_cq_np_req_count (pcie_cq_np_req_count),
    .mgmt_reset_n(mgmt_reset_n),
    .cfg_mgmt_addr (cfg_mgmt_addr),
    .cfg_mgmt_byte_enable (cfg_mgmt_byte_enable),
    .cfg_mgmt_read (cfg_mgmt_read),
    .cfg_mgmt_read_data (cfg_mgmt_read_data),
    .cfg_mgmt_read_write_done (cfg_mgmt_read_write_done),
    .cfg_mgmt_type1_cfg_reg_access (cfg_mgmt_type1_cfg_reg_access),
    .cfg_mgmt_write (cfg_mgmt_write_mux),
    .cfg_mgmt_write_data (cfg_mgmt_write_data),
    .cfg_phy_link_down (cfg_phy_link_down),
    .cfg_phy_link_status (cfg_phy_link_status),
    .cfg_negotiated_width (cfg_negotiated_width),
    .cfg_current_speed (cfg_current_speed),
    .cfg_max_payload (cfg_max_payload),
    .cfg_max_read_req (cfg_max_read_req),
    .cfg_function_status (cfg_function_status),
    .cfg_function_power_state (cfg_function_power_state),
    .cfg_vf_status (cfg_vf_status),
    .cfg_vf_power_state (cfg_vf_power_state),
    .cfg_link_power_state (cfg_link_power_state),
    .cfg_err_cor_out (cfg_err_cor_out),
    .cfg_err_nonfatal_out (cfg_err_nonfatal_out),
    .cfg_err_fatal_out (cfg_err_fatal_out),
    .cfg_local_error (cfg_local_error),
    .cfg_ltr_enable (cfg_ltr_enable),
    .cfg_ltssm_state (cfg_ltssm_state),
    .cfg_rcb_status (cfg_rcb_status),
    .cfg_dpa_substate_change (cfg_dpa_substate_change),
    .cfg_obff_enable (cfg_obff_enable),
    .cfg_pl_status_change (cfg_pl_status_change),
    .cfg_tph_requester_enable (cfg_tph_requester_enable),
    .cfg_tph_st_mode (cfg_tph_st_mode),
    .cfg_vf_tph_requester_enable (cfg_vf_tph_requester_enable),
    .cfg_vf_tph_st_mode (cfg_vf_tph_st_mode),
    .cfg_msg_received (cfg_msg_received),
    .cfg_msg_received_data (cfg_msg_received_data),
    .cfg_msg_received_type (cfg_msg_received_type),
    .cfg_msg_transmit (cfg_msg_transmit_mux),
    .cfg_msg_transmit_type (cfg_msg_transmit_type),
    .cfg_msg_transmit_data (cfg_msg_transmit_data),
    .cfg_msg_transmit_done (cfg_msg_transmit_done),
    .cfg_fc_ph (cfg_fc_ph),
    .cfg_fc_pd (cfg_fc_pd),
    .cfg_fc_nph (cfg_fc_nph),
    .cfg_fc_npd (cfg_fc_npd),
    .cfg_fc_cplh (cfg_fc_cplh),
    .cfg_fc_cpld (cfg_fc_cpld),
    .cfg_fc_sel (cfg_fc_sel),
    .cfg_per_func_status_control (cfg_per_func_status_control),
    .cfg_per_func_status_data (cfg_per_func_status_data),
    .cfg_per_function_number (cfg_per_function_number),
    .cfg_per_function_output_request (cfg_per_function_output_request),
    .cfg_per_function_update_done (cfg_per_function_update_done),
    .cfg_power_state_change_ack (cfg_power_state_change_ack_mux),
    .cfg_power_state_change_interrupt (cfg_power_state_change_interrupt),
    .cfg_err_cor_in (cfg_err_cor_in_mux),
    .cfg_err_uncor_in (cfg_err_uncor_in_mux),
    .cfg_flr_in_process (cfg_flr_in_process),
    .cfg_flr_done (cfg_flr_done_mux),
    .cfg_vf_flr_in_process (cfg_vf_flr_in_process),
    .cfg_vf_flr_done (cfg_vf_flr_done_mux),
    .cfg_link_training_enable (cfg_link_training_enable_mux),
    .cfg_interrupt_int (cfg_interrupt_int_mux),
    .cfg_interrupt_pending (cfg_interrupt_pending),
    .cfg_interrupt_sent (cfg_interrupt_sent),
    .cfg_interrupt_msi_enable (cfg_interrupt_msi_enable),
    .cfg_interrupt_msi_vf_enable (cfg_interrupt_msi_vf_enable),
    .cfg_interrupt_msi_mmenable (cfg_interrupt_msi_mmenable),
    .cfg_interrupt_msi_mask_update (cfg_interrupt_msi_mask_update),
    .cfg_interrupt_msi_data (cfg_interrupt_msi_data),
    .cfg_interrupt_msi_select (cfg_interrupt_msi_select),
    .cfg_interrupt_msi_int (cfg_interrupt_msi_int_mux),
    .cfg_interrupt_msi_pending_status (cfg_interrupt_msi_pending_status),
    .cfg_interrupt_msi_pending_status_data_enable (cfg_interrupt_msi_pending_status_data_enable_mux),
    .cfg_interrupt_msi_pending_status_function_num (cfg_interrupt_msi_pending_status_function_num),
    .cfg_interrupt_msi_sent (cfg_interrupt_msi_sent),
    .cfg_interrupt_msi_fail (cfg_interrupt_msi_fail),
    .cfg_interrupt_msix_enable (cfg_interrupt_msix_enable),
    .cfg_interrupt_msix_mask (cfg_interrupt_msix_mask),
    .cfg_interrupt_msix_vf_enable (cfg_interrupt_msix_vf_enable),
    .cfg_interrupt_msix_vf_mask (cfg_interrupt_msix_vf_mask),
    .cfg_interrupt_msix_data (cfg_interrupt_msix_data),
    .cfg_interrupt_msix_address (cfg_interrupt_msix_address),
    .cfg_interrupt_msix_int (cfg_interrupt_msix_int_mux),
    .cfg_interrupt_msix_sent (cfg_interrupt_msix_sent),
    .cfg_interrupt_msix_fail (cfg_interrupt_msix_fail),
    .cfg_interrupt_msi_attr (cfg_interrupt_msi_attr),
    .cfg_interrupt_msi_tph_present (cfg_interrupt_msi_tph_present),
    .cfg_interrupt_msi_tph_type (cfg_interrupt_msi_tph_type),
    .cfg_interrupt_msi_tph_st_tag (cfg_interrupt_msi_tph_st_tag),
    .cfg_interrupt_msi_function_number (cfg_interrupt_msi_function_number),
    .cfg_ext_read_received (cfg_ext_read_received),
    .cfg_ext_write_received (cfg_ext_write_received),
    .cfg_ext_register_number (cfg_ext_register_number),
    .cfg_ext_function_number (cfg_ext_function_number),
    .cfg_ext_write_data (cfg_ext_write_data),
    .cfg_ext_write_byte_enable (cfg_ext_write_byte_enable),
    .cfg_ext_read_data (cfg_ext_read_data_int),
    .cfg_ext_read_data_valid (cfg_ext_read_data_valid_int),
    .cfg_dev_id (cfg_dev_id_mux),
    .cfg_vend_id (cfg_vend_id),
    .cfg_rev_id (cfg_rev_id),
    .cfg_subsys_id (cfg_subsys_id),
    .cfg_subsys_vend_id (cfg_subsys_vend_id),
    .cfg_ds_port_number (cfg_ds_port_number),
    .cfg_hot_reset_out (cfg_hot_reset_out),
    .cfg_config_space_enable (cfg_config_space_enable_mux),
    .cfg_req_pm_transition_l23_ready (cfg_req_pm_transition_l23_ready_mux),
    .cfg_hot_reset_in (cfg_hot_reset_in_mux),
    .cfg_ds_bus_number (cfg_ds_bus_number),
    .cfg_ds_device_number (cfg_ds_device_number),
    .cfg_ds_function_number (cfg_ds_function_number),
    .cfg_dsn (cfg_dsn),
    .drp_rdy (drp_rdy),
    .drp_do (drp_do),
    .drp_clk( drp_clk),
    .drp_en (drp_en_mux),
    .drp_we (drp_we),
    .drp_addr (drp_addr[9:0]),
    .drp_di (drp_di),
    .user_tph_stt_address (user_tph_stt_address),
    .user_tph_function_num (user_tph_function_num),
    .user_tph_stt_read_data (user_tph_stt_read_data),
    .user_tph_stt_read_data_valid (user_tph_stt_read_data_valid),
    .user_tph_stt_read_enable (user_tph_stt_read_enable),
    .conf_req_type (conf_req_type),
    .conf_req_reg_num (conf_req_reg_num),
    .conf_req_data (conf_req_data),
    .conf_req_valid (conf_req_valid_mux),
    .conf_mcap_request_by_conf (mcap_external_request),
    .conf_req_ready (conf_req_ready_wire),
    .conf_resp_rdata (conf_resp_rdata),
    .conf_resp_valid (conf_resp_valid),
    .conf_mcap_design_switch (mcap_design_switch),
    .conf_mcap_eos (),
    .conf_mcap_in_use_by_pcie (mcap_pcie_request),
    .dbg_mcap_cs_b (),
    .dbg_mcap_data (),
    .dbg_mcap_eos (),
    .dbg_mcap_errror (),
    .dbg_mcap_mode (),
    .dbg_mcap_rdata_valid (),
    .dbg_mcap_rdwr_b (),
    .dbg_mcap_reset (),
    .pl_eq_in_progress (pl_eq_in_progress),
    .pl_eq_phase (pl_eq_phase),
    .pcie_perstn0_in (sys_reset),
    .pcie_perstn0_out (sys_reset_pt),
    .pcie_perstn1_in (pcie_perstn1_in),
    .pcie_perstn1_out (pcie_perstn1_out),
    .pl_eq_reset_eieos_count (pl_eq_reset_eieos_count_mux),
    .pl_gen2_upstream_prefer_deemph (pl_gen2_upstream_prefer_deemph_mux),

  // Pipe Interface
  //-----------------------------
  // PIPE common_commands_in[25:0] BUS Signals
  //-----------------------------
    .pipe_clk                                           ( pipe_clk ),  
    .core_clk                                           ( core_clk ),  
    .user_clk                                           ( user_clk ),  
    .mcap_clk                                           ( mcap_clk ),  
    .phy_rdy                                            ( phy_rdy  ),  
    .pipe_tx_eqfs_gt                                    ( 6'd40    ),  
    .pipe_tx_eqlf_gt                                    ( 6'd12    ),  

  //-----------------------------
  // PIPE common_commands_out[25:0] BUS Signals
  //-----------------------------
    .pipe_tx0_rcvr_det_gt                               ( pipe_tx0_rcvr_det        ), 
    .pipe_tx0_rate_gt                                   ( common_commands_out[2:1] ), 
    .pipe_tx0_deemph_gt                                 ( common_commands_out[9]   ), 
    .pipe_tx0_margin_gt                                 ( common_commands_out[6:4] ), 
    .pipe_tx0_swing_gt                                  ( common_commands_out[7]   ), 
    .pipe_tx0_reset_gt                                  ( common_commands_out[8]   ), 

  //-----------------------------
  // PIPE TX BUS Signals[83:0]
  //-----------------------------

  // pipe_tx_0_sigs[83:0]
  .pipe_tx0_data_gt                                     ( pipe_tx_0_sigs[31: 0] ),     
  .pipe_tx0_char_is_k_gt                                ( pipe_tx_0_sigs[33:32] ),     
  .pipe_tx0_elec_idle_gt                                ( pipe_tx_0_sigs[34]    ),     
  .pipe_tx0_data_valid_gt                               ( pipe_tx_0_sigs[35]    ),     
  .pipe_tx0_start_block_gt                              ( pipe_tx_0_sigs[36]    ),     
  .pipe_tx0_syncheader_gt                               ( pipe_tx_0_sigs[38:37] ),     
  .pipe_rx0_polarity_gt                                 ( pipe_tx_0_sigs[39]    ),     
  .pipe_tx0_powerdown_gt                                ( pipe_tx_0_sigs[41:40] ),     
  .pipe_tx0_eqcontrol_gt                                ( pipe_tx0_eqcontrol    ),     
  .pipe_tx0_eqpreset_gt                                 ( ),     
  .pipe_tx0_eqdeemph_gt                                 ( ),     
  .pipe_rx0_eqcontrol_gt                                ( pipe_rx0_eqcontrol    ),     
  .pipe_rx0_eqpreset_gt                                 ( ),     
  .pipe_rx0_eqlp_lffs_gt                                ( ),     
  .pipe_rx0_eqlp_txpreset_gt                            ( ),   
  .pipe_tx0_compliance_gt                               ( ),   

  // pipe_tx_1_sigs[69:0]
  .pipe_tx1_data_gt                                     ( pipe_tx_1_sigs[31: 0] ),   
  .pipe_tx1_char_is_k_gt                                ( pipe_tx_1_sigs[33:32] ),   
  .pipe_tx1_elec_idle_gt                                ( pipe_tx_1_sigs[34]    ),   
  .pipe_tx1_data_valid_gt                               ( pipe_tx_1_sigs[35]    ),   
  .pipe_tx1_start_block_gt                              ( pipe_tx_1_sigs[36]    ),   
  .pipe_tx1_syncheader_gt                               ( pipe_tx_1_sigs[38:37] ),   
  .pipe_rx1_polarity_gt                                 ( pipe_tx_1_sigs[39]    ),   
  .pipe_tx1_powerdown_gt                                ( pipe_tx_1_sigs[41:40] ),   
  .pipe_tx1_eqcontrol_gt                                ( pipe_tx1_eqcontrol    ),   
  .pipe_tx1_eqpreset_gt                                 (  ),   
  .pipe_tx1_eqdeemph_gt                                 (  ),   
  .pipe_rx1_eqcontrol_gt                                ( pipe_rx1_eqcontrol    ),   
  .pipe_rx1_eqpreset_gt                                 (  ),   
  .pipe_rx1_eqlp_lffs_gt                                (  ),   
  .pipe_rx1_eqlp_txpreset_gt                            (  ),   
  .pipe_tx1_compliance_gt                               (  ),   

  // pipe_tx_2_sigs[69:0]
  .pipe_tx2_data_gt                                     ( pipe_tx_2_sigs[31: 0] ),   
  .pipe_tx2_char_is_k_gt                                ( pipe_tx_2_sigs[33:32] ),   
  .pipe_tx2_elec_idle_gt                                ( pipe_tx_2_sigs[34]    ),   
  .pipe_tx2_data_valid_gt                               ( pipe_tx_2_sigs[35]    ),   
  .pipe_tx2_start_block_gt                              ( pipe_tx_2_sigs[36]    ),   
  .pipe_tx2_syncheader_gt                               ( pipe_tx_2_sigs[38:37] ),   
  .pipe_rx2_polarity_gt                                 ( pipe_tx_2_sigs[39]    ),   
  .pipe_tx2_powerdown_gt                                ( pipe_tx_2_sigs[41:40] ),   
  .pipe_tx2_eqcontrol_gt                                ( pipe_tx2_eqcontrol    ),   
  .pipe_tx2_eqpreset_gt                                 (  ),   
  .pipe_tx2_eqdeemph_gt                                 (  ),   
  .pipe_rx2_eqcontrol_gt                                ( pipe_rx2_eqcontrol    ),   
  .pipe_rx2_eqpreset_gt                                 (  ),   
  .pipe_rx2_eqlp_lffs_gt                                (  ),   
  .pipe_rx2_eqlp_txpreset_gt                            (  ),   
  .pipe_tx2_compliance_gt                               (  ),   

  // pipe_tx_3_sigs[69:0]
  .pipe_tx3_data_gt                                     ( pipe_tx_3_sigs[31: 0] ),   
  .pipe_tx3_char_is_k_gt                                ( pipe_tx_3_sigs[33:32] ),   
  .pipe_tx3_elec_idle_gt                                ( pipe_tx_3_sigs[34]    ),   
  .pipe_tx3_data_valid_gt                               ( pipe_tx_3_sigs[35]    ),   
  .pipe_tx3_start_block_gt                              ( pipe_tx_3_sigs[36]    ),   
  .pipe_tx3_syncheader_gt                               ( pipe_tx_3_sigs[38:37] ),   
  .pipe_rx3_polarity_gt                                 ( pipe_tx_3_sigs[39]    ),   
  .pipe_tx3_powerdown_gt                                ( pipe_tx_3_sigs[41:40] ),   
  .pipe_tx3_eqcontrol_gt                                ( pipe_tx3_eqcontrol    ),   
  .pipe_tx3_eqpreset_gt                                 (  ),    
  .pipe_tx3_eqdeemph_gt                                 (  ),    
  .pipe_rx3_eqcontrol_gt                                ( pipe_rx3_eqcontrol    ),    
  .pipe_rx3_eqpreset_gt                                 (  ),   
  .pipe_rx3_eqlp_lffs_gt                                (  ),   
  .pipe_rx3_eqlp_txpreset_gt                            (  ),   
  .pipe_tx3_compliance_gt                               (  ),   

  // pipe_tx_4_sigs[69:0]
  .pipe_tx4_data_gt                                     ( pipe_tx_4_sigs[31: 0] ),   
  .pipe_tx4_char_is_k_gt                                ( pipe_tx_4_sigs[33:32] ),   
  .pipe_tx4_elec_idle_gt                                ( pipe_tx_4_sigs[34]    ),   
  .pipe_tx4_data_valid_gt                               ( pipe_tx_4_sigs[35]    ),   
  .pipe_tx4_start_block_gt                              ( pipe_tx_4_sigs[36]    ),   
  .pipe_tx4_syncheader_gt                               ( pipe_tx_4_sigs[38:37] ),   
  .pipe_rx4_polarity_gt                                 ( pipe_tx_4_sigs[39]    ),   
  .pipe_tx4_powerdown_gt                                ( pipe_tx_4_sigs[41:40] ),   
  .pipe_tx4_eqcontrol_gt                                ( pipe_tx4_eqcontrol    ),    
  .pipe_tx4_eqpreset_gt                                 (  ),   
  .pipe_tx4_eqdeemph_gt                                 (  ),   
  .pipe_rx4_eqcontrol_gt                                ( pipe_rx4_eqcontrol    ),    
  .pipe_rx4_eqpreset_gt                                 (  ),    
  .pipe_rx4_eqlp_lffs_gt                                (  ),    
  .pipe_rx4_eqlp_txpreset_gt                            (  ),    
  .pipe_tx4_compliance_gt                               (  ),   

  // pipe_tx_5_sigs[69:0]
  .pipe_tx5_data_gt                                     ( pipe_tx_5_sigs[31: 0] ),   
  .pipe_tx5_char_is_k_gt                                ( pipe_tx_5_sigs[33:32] ),   
  .pipe_tx5_elec_idle_gt                                ( pipe_tx_5_sigs[34]    ),   
  .pipe_tx5_data_valid_gt                               ( pipe_tx_5_sigs[35]    ),   
  .pipe_tx5_start_block_gt                              ( pipe_tx_5_sigs[36]    ),   
  .pipe_tx5_syncheader_gt                               ( pipe_tx_5_sigs[38:37] ),   
  .pipe_rx5_polarity_gt                                 ( pipe_tx_5_sigs[39]    ),   
  .pipe_tx5_powerdown_gt                                ( pipe_tx_5_sigs[41:40] ),   
  .pipe_tx5_eqcontrol_gt                                ( pipe_tx5_eqcontrol    ),   
  .pipe_tx5_eqpreset_gt                                 (  ),   
  .pipe_tx5_eqdeemph_gt                                 (  ),   
  .pipe_rx5_eqcontrol_gt                                ( pipe_rx5_eqcontrol    ),   
  .pipe_rx5_eqpreset_gt                                 (  ),   
  .pipe_rx5_eqlp_lffs_gt                                (  ),   
  .pipe_rx5_eqlp_txpreset_gt                            (  ),   
  .pipe_tx5_compliance_gt                               (  ),   

  // pipe_tx_6_sigs[69:0]
  .pipe_tx6_data_gt                                     ( pipe_tx_6_sigs[31: 0] ),   
  .pipe_tx6_char_is_k_gt                                ( pipe_tx_6_sigs[33:32] ),   
  .pipe_tx6_elec_idle_gt                                ( pipe_tx_6_sigs[34]    ),   
  .pipe_tx6_data_valid_gt                               ( pipe_tx_6_sigs[35]    ),   
  .pipe_tx6_start_block_gt                              ( pipe_tx_6_sigs[36]    ),   
  .pipe_tx6_syncheader_gt                               ( pipe_tx_6_sigs[38:37] ),   
  .pipe_rx6_polarity_gt                                 ( pipe_tx_6_sigs[39]    ),   
  .pipe_tx6_powerdown_gt                                ( pipe_tx_6_sigs[41:40] ),   
  .pipe_tx6_eqcontrol_gt                                ( pipe_tx6_eqcontrol    ),   
  .pipe_tx6_eqpreset_gt                                 (  ),   
  .pipe_tx6_eqdeemph_gt                                 (  ),   
  .pipe_rx6_eqcontrol_gt                                ( pipe_rx6_eqcontrol    ),   
  .pipe_rx6_eqpreset_gt                                 (  ),   
  .pipe_rx6_eqlp_lffs_gt                                (  ),   
  .pipe_rx6_eqlp_txpreset_gt                            (  ),   
  .pipe_tx6_compliance_gt                               (  ),   

  // pipe_tx_7_sigs[69:0]
  .pipe_tx7_data_gt                                     ( pipe_tx_7_sigs[31: 0] ),   
  .pipe_tx7_char_is_k_gt                                ( pipe_tx_7_sigs[33:32] ),   
  .pipe_tx7_elec_idle_gt                                ( pipe_tx_7_sigs[34]    ),   
  .pipe_tx7_data_valid_gt                               ( pipe_tx_7_sigs[35]    ),   
  .pipe_tx7_start_block_gt                              ( pipe_tx_7_sigs[36]    ),   
  .pipe_tx7_syncheader_gt                               ( pipe_tx_7_sigs[38:37] ),   
  .pipe_rx7_polarity_gt                                 ( pipe_tx_7_sigs[39]    ),   
  .pipe_tx7_powerdown_gt                                ( pipe_tx_7_sigs[41:40] ),   
  .pipe_tx7_eqcontrol_gt                                ( pipe_tx7_eqcontrol    ),   
  .pipe_tx7_eqpreset_gt                                 (  ),   
  .pipe_tx7_eqdeemph_gt                                 (  ),   
  .pipe_rx7_eqcontrol_gt                                ( pipe_rx7_eqcontrol    ),   
  .pipe_rx7_eqpreset_gt                                 (  ),   
  .pipe_rx7_eqlp_lffs_gt                                (  ),   
  .pipe_rx7_eqlp_txpreset_gt                            (  ),   
  .pipe_tx7_compliance_gt                               (  ),   

  //-----------------------------
  // PIPE RX BUS Signals[83:0]
  //-----------------------------

  // pipe_rx_0_sigs[83:0]
  .pipe_rx0_data_gt                                     ( pipe_rx_0_sigs[31: 0] ),   
  .pipe_rx0_char_is_k_gt                                ( pipe_rx_0_sigs[33:32] ),   
  .pipe_rx0_data_valid_gt                               ( pipe_rx_0_sigs[35]    ),   
  .pipe_rx0_elec_idle_gt                                ( pipe_rx_0_sigs[34]    ),   
  .pipe_rx0_start_block_gt                              ( pipe_rx_0_sigs[36]    ),   
  .pipe_rx0_syncheader_gt                               ( pipe_rx_0_sigs[38:37] ),   
  .pipe_rx0_status_gt                                   ( rx_status ),   
  .pipe_rx0_valid_gt                                    ( ~pipe_rx_0_sigs[34]    ),   
  .pipe_rx0_phy_status_gt                               ( phy_status    ),   
  .pipe_tx0_eqdone_gt                                   ( pipe_tx0_eqdone       ),   
  .pipe_tx0_eqcoeff_gt                                  ( 18'h00904             ),   
  .pipe_rx0_eqlp_new_txcoef_forpreset_gt                ( 18'h05                ),   
  .pipe_rx0_eqlp_lffs_sel_gt                            ( 1'b0                  ),   
  .pipe_rx0_eqlp_adaptdone_gt                           ( 1'b0                  ),   
  .pipe_rx0_eqdone_gt                                   ( pipe_rx0_eqdone       ),   

  // pipe_rx_1_sigs[83:0]
  .pipe_rx1_data_gt                                     ( pipe_rx_1_sigs[31: 0] ),   
  .pipe_rx1_char_is_k_gt                                ( pipe_rx_1_sigs[33:32] ),   
  .pipe_rx1_data_valid_gt                               ( pipe_rx_1_sigs[35]    ),   
  .pipe_rx1_elec_idle_gt                                ( pipe_rx_1_sigs[34]    ),   
  .pipe_rx1_start_block_gt                              ( pipe_rx_1_sigs[36]    ),   
  .pipe_rx1_syncheader_gt                               ( pipe_rx_1_sigs[38:37] ),   
  .pipe_rx1_status_gt                                   ( (PL_LINK_CAP_MAX_LINK_WIDTH >= 2 )? rx_status : 3'b0 ),   
  .pipe_rx1_valid_gt                                    ( ~pipe_rx_1_sigs[34]    ),   
  .pipe_rx1_phy_status_gt                               ( (PL_LINK_CAP_MAX_LINK_WIDTH >= 2 )? phy_status : 1'b0 ),   
  .pipe_tx1_eqdone_gt                                   ( pipe_tx1_eqdone       ),   
  .pipe_tx1_eqcoeff_gt                                  ( 18'h00904             ),   
  .pipe_rx1_eqlp_new_txcoef_forpreset_gt                ( 18'h05                ),   
  .pipe_rx1_eqlp_lffs_sel_gt                            ( 1'b0                  ),   
  .pipe_rx1_eqlp_adaptdone_gt                           ( 1'b0                  ),   
  .pipe_rx1_eqdone_gt                                   ( pipe_rx1_eqdone       ),    

  // pipe_rx_2_sigs[83:0]
  .pipe_rx2_data_gt                                     ( pipe_rx_2_sigs[31: 0] ),   
  .pipe_rx2_char_is_k_gt                                ( pipe_rx_2_sigs[33:32] ),   
  .pipe_rx2_data_valid_gt                               ( pipe_rx_2_sigs[35]    ),   
  .pipe_rx2_elec_idle_gt                                ( pipe_rx_2_sigs[34]    ),   
  .pipe_rx2_start_block_gt                              ( pipe_rx_2_sigs[36]    ),   
  .pipe_rx2_syncheader_gt                               ( pipe_rx_2_sigs[38:37] ),   
  .pipe_rx2_status_gt                                   ( (PL_LINK_CAP_MAX_LINK_WIDTH >= 4 )? rx_status : 3'b0 ),   
  .pipe_rx2_valid_gt                                    ( ~pipe_rx_2_sigs[34]    ),   
  .pipe_rx2_phy_status_gt                               ( (PL_LINK_CAP_MAX_LINK_WIDTH >= 4 )? phy_status : 1'b0 ),   
  .pipe_tx2_eqdone_gt                                   ( pipe_tx2_eqdone       ),   
  .pipe_tx2_eqcoeff_gt                                  ( 18'h00904             ),   
  .pipe_rx2_eqlp_new_txcoef_forpreset_gt                ( 18'h05                ),   
  .pipe_rx2_eqlp_lffs_sel_gt                            ( 1'b0                  ),   
  .pipe_rx2_eqlp_adaptdone_gt                           ( 1'b0                  ),   
  .pipe_rx2_eqdone_gt                                   ( pipe_rx2_eqdone       ),   

  // pipe_rx_3_sigs[83:0]
  .pipe_rx3_data_gt                                     ( pipe_rx_3_sigs[31: 0] ),   
  .pipe_rx3_char_is_k_gt                                ( pipe_rx_3_sigs[33:32] ),   
  .pipe_rx3_data_valid_gt                               ( pipe_rx_3_sigs[35]    ),   
  .pipe_rx3_elec_idle_gt                                ( pipe_rx_3_sigs[34]    ),   
  .pipe_rx3_start_block_gt                              ( pipe_rx_3_sigs[36]    ),   
  .pipe_rx3_syncheader_gt                               ( pipe_rx_3_sigs[38:37] ),   
  .pipe_rx3_status_gt                                   ( (PL_LINK_CAP_MAX_LINK_WIDTH >= 4 )? rx_status : 3'b0 ),   
  .pipe_rx3_valid_gt                                    ( ~pipe_rx_3_sigs[34]    ),   
  .pipe_rx3_phy_status_gt                               ((PL_LINK_CAP_MAX_LINK_WIDTH >= 4 )? phy_status : 1'b0 ),   
  .pipe_tx3_eqdone_gt                                   ( pipe_tx3_eqdone       ),   
  .pipe_tx3_eqcoeff_gt                                  ( 18'h00904             ),   
  .pipe_rx3_eqlp_new_txcoef_forpreset_gt                ( 18'h05                ),   
  .pipe_rx3_eqlp_lffs_sel_gt                            ( 1'b0                  ),   
  .pipe_rx3_eqlp_adaptdone_gt                           ( 1'b0                  ),   
  .pipe_rx3_eqdone_gt                                   ( pipe_rx3_eqdone       ), 

  // pipe_rx_4_sigs[83:0]
  .pipe_rx4_data_gt                                     ( pipe_rx_4_sigs[31: 0] ),   
  .pipe_rx4_char_is_k_gt                                ( pipe_rx_4_sigs[33:32] ),   
  .pipe_rx4_data_valid_gt                               ( pipe_rx_4_sigs[35]    ),   
  .pipe_rx4_elec_idle_gt                                ( pipe_rx_4_sigs[34]    ),   
  .pipe_rx4_start_block_gt                              ( pipe_rx_4_sigs[36]    ),   
  .pipe_rx4_syncheader_gt                               ( pipe_rx_4_sigs[38:37] ),   
  .pipe_rx4_status_gt                                   ( (PL_LINK_CAP_MAX_LINK_WIDTH == 8 )? rx_status : 3'b0 ),   
  .pipe_rx4_valid_gt                                    ( ~pipe_rx_4_sigs[34]    ),   
  .pipe_rx4_phy_status_gt                               ((PL_LINK_CAP_MAX_LINK_WIDTH == 8 )? phy_status : 1'b0 ),   
  .pipe_tx4_eqdone_gt                                   ( pipe_tx4_eqdone       ),   
  .pipe_tx4_eqcoeff_gt                                  ( 18'h00904             ),   
  .pipe_rx4_eqlp_new_txcoef_forpreset_gt                ( 18'h05                ),   
  .pipe_rx4_eqlp_lffs_sel_gt                            ( 1'b0                  ),   
  .pipe_rx4_eqlp_adaptdone_gt                           ( 1'b0                  ),   
  .pipe_rx4_eqdone_gt                                   ( pipe_rx4_eqdone       ),   

  // pipe_rx_5_sigs[83:0]
  .pipe_rx5_data_gt                                     ( pipe_rx_5_sigs[31: 0] ),   
  .pipe_rx5_char_is_k_gt                                ( pipe_rx_5_sigs[33:32] ),   
  .pipe_rx5_data_valid_gt                               ( pipe_rx_5_sigs[35]    ),   
  .pipe_rx5_elec_idle_gt                                ( pipe_rx_5_sigs[34]    ),   
  .pipe_rx5_start_block_gt                              ( pipe_rx_5_sigs[36]    ),   
  .pipe_rx5_syncheader_gt                               ( pipe_rx_5_sigs[38:37] ),   
  .pipe_rx5_status_gt                                   ( (PL_LINK_CAP_MAX_LINK_WIDTH == 8 )? rx_status : 3'b0  ),   
  .pipe_rx5_valid_gt                                    ( ~pipe_rx_5_sigs[34]    ),   
  .pipe_rx5_phy_status_gt                               ((PL_LINK_CAP_MAX_LINK_WIDTH == 8 )? phy_status : 1'b0 ),   
  .pipe_tx5_eqdone_gt                                   ( pipe_tx5_eqdone       ),   
  .pipe_tx5_eqcoeff_gt                                  ( 18'h00904             ),   
  .pipe_rx5_eqlp_new_txcoef_forpreset_gt                ( 18'h05                ),   
  .pipe_rx5_eqlp_lffs_sel_gt                            ( 1'b0                  ),   
  .pipe_rx5_eqlp_adaptdone_gt                           ( 1'b0                  ),   
  .pipe_rx5_eqdone_gt                                   ( pipe_rx5_eqdone       ),    

  // pipe_rx_6_sigs[83:0]
  .pipe_rx6_data_gt                                     ( pipe_rx_6_sigs[31: 0] ),   
  .pipe_rx6_char_is_k_gt                                ( pipe_rx_6_sigs[33:32] ),   
  .pipe_rx6_data_valid_gt                               ( pipe_rx_6_sigs[35]    ),   
  .pipe_rx6_elec_idle_gt                                ( pipe_rx_6_sigs[34]    ),   
  .pipe_rx6_start_block_gt                              ( pipe_rx_6_sigs[36]    ),   
  .pipe_rx6_syncheader_gt                               ( pipe_rx_6_sigs[38:37] ),   
  .pipe_rx6_status_gt                                   ( (PL_LINK_CAP_MAX_LINK_WIDTH == 8 )? rx_status : 3'b0  ),   
  .pipe_rx6_valid_gt                                    ( ~pipe_rx_6_sigs[34]    ),   
  .pipe_rx6_phy_status_gt                               ((PL_LINK_CAP_MAX_LINK_WIDTH == 8 )? phy_status : 1'b0 ),   
  .pipe_tx6_eqdone_gt                                   ( pipe_tx6_eqdone       ),   
  .pipe_tx6_eqcoeff_gt                                  ( 18'h00904             ),   
  .pipe_rx6_eqlp_new_txcoef_forpreset_gt                ( 18'h05                ),   
  .pipe_rx6_eqlp_lffs_sel_gt                            ( 1'b0                  ),   
  .pipe_rx6_eqlp_adaptdone_gt                           ( 1'b0                  ),   
  .pipe_rx6_eqdone_gt                                   ( pipe_rx6_eqdone       ),    

  // pipe_rx_7_sigs[83:0]
  .pipe_rx7_data_gt                                     ( pipe_rx_7_sigs[31: 0] ),   
  .pipe_rx7_char_is_k_gt                                ( pipe_rx_7_sigs[33:32] ),   
  .pipe_rx7_data_valid_gt                               ( pipe_rx_7_sigs[35]    ),   
  .pipe_rx7_elec_idle_gt                                ( pipe_rx_7_sigs[34]    ),   
  .pipe_rx7_start_block_gt                              ( pipe_rx_7_sigs[36]    ),   
  .pipe_rx7_syncheader_gt                               ( pipe_rx_7_sigs[38:37] ),   
  .pipe_rx7_status_gt                                   ( (PL_LINK_CAP_MAX_LINK_WIDTH == 8 )? rx_status : 3'b0  ),   
  .pipe_rx7_valid_gt                                    ( ~pipe_rx_7_sigs[34]    ),   
  .pipe_rx7_phy_status_gt                               ((PL_LINK_CAP_MAX_LINK_WIDTH == 8 )? phy_status : 1'b0 ),   
  .pipe_tx7_eqdone_gt                                   ( pipe_tx7_eqdone       ),   
  .pipe_tx7_eqcoeff_gt                                  ( 18'h00904             ),   
  .pipe_rx7_eqlp_new_txcoef_forpreset_gt                ( 18'h05                ),   
  .pipe_rx7_eqlp_lffs_sel_gt                            ( 1'b0                  ),   
  .pipe_rx7_eqlp_adaptdone_gt                           ( 1'b0                  ),   
  .pipe_rx7_eqdone_gt                                   ( pipe_rx7_eqdone       )    
  );
 
  reg [3:0] pipe_rx0_eqcontrol_reg = 4'b0;
  reg [3:0] pipe_rx1_eqcontrol_reg = 4'b0;
  reg [3:0] pipe_rx2_eqcontrol_reg = 4'b0;
  reg [3:0] pipe_rx3_eqcontrol_reg = 4'b0;
  reg [3:0] pipe_rx4_eqcontrol_reg = 4'b0;
  reg [3:0] pipe_rx5_eqcontrol_reg = 4'b0;
  reg [3:0] pipe_rx6_eqcontrol_reg = 4'b0;
  reg [3:0] pipe_rx7_eqcontrol_reg = 4'b0;
  reg [3:0] pipe_tx0_eqcontrol_reg = 4'b0;
  reg [3:0] pipe_tx1_eqcontrol_reg = 4'b0;
  reg [3:0] pipe_tx2_eqcontrol_reg = 4'b0;
  reg [3:0] pipe_tx3_eqcontrol_reg = 4'b0;
  reg [3:0] pipe_tx4_eqcontrol_reg = 4'b0;
  reg [3:0] pipe_tx5_eqcontrol_reg = 4'b0;
  reg [3:0] pipe_tx6_eqcontrol_reg = 4'b0;
  reg [3:0] pipe_tx7_eqcontrol_reg = 4'b0;
  
  always @ (posedge pipe_clk)
  begin
   pipe_rx0_eqcontrol_reg     <= {pipe_rx0_eqcontrol_reg[1:0], pipe_rx0_eqcontrol};
   pipe_rx1_eqcontrol_reg     <= {pipe_rx1_eqcontrol_reg[1:0], pipe_rx1_eqcontrol};
   pipe_rx2_eqcontrol_reg     <= {pipe_rx2_eqcontrol_reg[1:0], pipe_rx2_eqcontrol};
   pipe_rx3_eqcontrol_reg     <= {pipe_rx3_eqcontrol_reg[1:0], pipe_rx3_eqcontrol};
   pipe_rx4_eqcontrol_reg     <= {pipe_rx4_eqcontrol_reg[1:0], pipe_rx4_eqcontrol};
   pipe_rx5_eqcontrol_reg     <= {pipe_rx5_eqcontrol_reg[1:0], pipe_rx5_eqcontrol};
   pipe_rx6_eqcontrol_reg     <= {pipe_rx6_eqcontrol_reg[1:0], pipe_rx6_eqcontrol};
   pipe_rx7_eqcontrol_reg     <= {pipe_rx7_eqcontrol_reg[1:0], pipe_rx7_eqcontrol};
   pipe_tx0_eqcontrol_reg     <= {pipe_tx0_eqcontrol_reg[1:0], pipe_tx0_eqcontrol};
   pipe_tx1_eqcontrol_reg     <= {pipe_tx1_eqcontrol_reg[1:0], pipe_tx1_eqcontrol};
   pipe_tx2_eqcontrol_reg     <= {pipe_tx2_eqcontrol_reg[1:0], pipe_tx2_eqcontrol};
   pipe_tx3_eqcontrol_reg     <= {pipe_tx3_eqcontrol_reg[1:0], pipe_tx3_eqcontrol};
   pipe_tx4_eqcontrol_reg     <= {pipe_tx4_eqcontrol_reg[1:0], pipe_tx4_eqcontrol};
   pipe_tx5_eqcontrol_reg     <= {pipe_tx5_eqcontrol_reg[1:0], pipe_tx5_eqcontrol};
   pipe_tx6_eqcontrol_reg     <= {pipe_tx6_eqcontrol_reg[1:0], pipe_tx6_eqcontrol};
   pipe_tx7_eqcontrol_reg     <= {pipe_tx7_eqcontrol_reg[1:0], pipe_tx7_eqcontrol};
  end
  
  // generate rx*_eqdone
  assign pipe_rx0_eqdone = (pipe_rx0_eqcontrol_reg[3:2] != pipe_rx0_eqcontrol)? 1'b1 : 1'b0;
  assign pipe_rx1_eqdone = (pipe_rx1_eqcontrol_reg[3:2] != pipe_rx1_eqcontrol)? 1'b1 : 1'b0;
  assign pipe_rx2_eqdone = (pipe_rx2_eqcontrol_reg[3:2] != pipe_rx2_eqcontrol)? 1'b1 : 1'b0;
  assign pipe_rx3_eqdone = (pipe_rx3_eqcontrol_reg[3:2] != pipe_rx3_eqcontrol)? 1'b1 : 1'b0;
  assign pipe_rx4_eqdone = (pipe_rx4_eqcontrol_reg[3:2] != pipe_rx4_eqcontrol)? 1'b1 : 1'b0;
  assign pipe_rx5_eqdone = (pipe_rx5_eqcontrol_reg[3:2] != pipe_rx5_eqcontrol)? 1'b1 : 1'b0;
  assign pipe_rx6_eqdone = (pipe_rx6_eqcontrol_reg[3:2] != pipe_rx6_eqcontrol)? 1'b1 : 1'b0;
  assign pipe_rx7_eqdone = (pipe_rx7_eqcontrol_reg[3:2] != pipe_rx7_eqcontrol)? 1'b1 : 1'b0; 
  // generate tx*_eqdone
  assign pipe_tx0_eqdone = (pipe_tx0_eqcontrol_reg[3:2] != pipe_tx0_eqcontrol)? 1'b1 : 1'b0;
  assign pipe_tx1_eqdone = (pipe_tx1_eqcontrol_reg[3:2] != pipe_tx1_eqcontrol)? 1'b1 : 1'b0;
  assign pipe_tx2_eqdone = (pipe_tx2_eqcontrol_reg[3:2] != pipe_tx2_eqcontrol)? 1'b1 : 1'b0;
  assign pipe_tx3_eqdone = (pipe_tx3_eqcontrol_reg[3:2] != pipe_tx3_eqcontrol)? 1'b1 : 1'b0;
  assign pipe_tx4_eqdone = (pipe_tx4_eqcontrol_reg[3:2] != pipe_tx4_eqcontrol)? 1'b1 : 1'b0;
  assign pipe_tx5_eqdone = (pipe_tx5_eqcontrol_reg[3:2] != pipe_tx5_eqcontrol)? 1'b1 : 1'b0;
  assign pipe_tx6_eqdone = (pipe_tx6_eqcontrol_reg[3:2] != pipe_tx6_eqcontrol)? 1'b1 : 1'b0;
  assign pipe_tx7_eqdone = (pipe_tx7_eqcontrol_reg[3:2] != pipe_tx7_eqcontrol)? 1'b1 : 1'b0; 
  
 
 // Pipe mode tie-offs
 assign  common_commands_out[0]     = pipe_clk;
 assign  common_commands_out[3]     = pipe_tx0_rcvr_det; 
 assign  common_commands_out[25:10] = 16'b0;
 assign  pipe_tx_0_sigs[83:42]      = 42'b0;
 assign  pipe_tx_1_sigs[83:42]      = 42'b0;
 assign  pipe_tx_2_sigs[83:42]      = 42'b0;
 assign  pipe_tx_3_sigs[83:42]      = 42'b0;
 assign  pipe_tx_4_sigs[83:42]      = 42'b0;
 assign  pipe_tx_5_sigs[83:42]      = 42'b0;
 assign  pipe_tx_6_sigs[83:42]      = 42'b0;
 assign  pipe_tx_7_sigs[83:42]      = 42'b0;

 end
endgenerate

  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*32)-1):0] pipe_txdata;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*2)-1):0] pipe_tx_char_is_k;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] pipe_tx_data_valid;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] pipe_tx_start_block;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*2)-1):0] pipe_tx_syncheader;

  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*32)-1):0] pipe_rx_data;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*2)-1):0] pipe_rx_char_is_k;

  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] pipe_tx_elec_idle;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] pipe_tx_compliance;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] pipe_rx_polarity;

  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*2)-1):0] pipe_tx_eqcontrol;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*4)-1):0] pipe_tx_eqpreset;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*6)-1):0] pipe_tx_eqdeemph;

  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] pipe_rx_eqdone;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] pipe_rx_eq_adapt_done;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] pipe_rx_phy_status;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] pipe_rx_eq_lffs_sel;

  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*2)-1):0] pipe_rx_eqcontrol;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*3)-1):0] pipe_rx_eqpreset;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*6)-1):0] pipe_rx_eq_lffs;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*4)-1):0] pipe_rx_eq_txpreset;

  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*18)-1):0] pipe_rx_eq_new_txcoeff;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*18)-1):0] pipe_tx_eqcoeff;
  
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*3)-1):0] pipe_rx_status;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] pipe_rx_data_valid;    
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] pipe_rx_elec_idle;  
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] pipe_rx_start_block;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*2)-1):0] pipe_rx_syncheader;

  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] pipe_tx_eqdone;
  wire         [((PL_LINK_CAP_MAX_LINK_WIDTH*1)-1):0] pipe_rx_valid;

//----------------------------------------RXCDR HOLD---------------------------------------------------//
wire phy_rxcdrhold;

xdma_0_pcie3_ip_rxcdrhold rxcdrhold_i
(
    .pipe_clk                          (pipe_clk),
    .user_clk                          (user_clk),
    .cfg_ltssm_state                   (cfg_ltssm_state),
    .pipe_rx0_elec_idle                (pipe_rx0_elec_idle),
    .rxcdrhold_out                     (phy_rxcdrhold)
);

generate if (EXT_PIPE_SIM == "FALSE") 
begin


xdma_0_pcie3_ip_phy_wrapper #
(
    //--------------------------------------------------------------------------
    //  Parameters
    //--------------------------------------------------------------------------
    .PL_UPSTREAM_FACING (PL_UPSTREAM_FACING),
    .SHARED_LOGIC     ( SHARED_LOGIC ),
    .DIS_GT_WIZARD    ( DIS_GT_WIZARD ),
    // synthesis translate_off
    .PHY_SIM_EN       ( "TRUE" ),  
    // synthesis translate_on   
    .PHY_LANE         ( PL_LINK_CAP_MAX_LINK_WIDTH ),   
    .PHY_MAX_SPEED    ( PCIE_LINK_SPEED ),                       
    .PHY_REFCLK_FREQ  ( REF_CLK_FREQ ),           
    .PHY_USERCLK_FREQ ( USER_CLK_FREQ ),           
    .PHY_CORECLK_FREQ ( ((CRM_CORE_CLK_FREQ_500 == "TRUE") ? 2 : 1)  ),
    .PHY_LP_TXPRESET  ( PHY_LP_TXPRESET )                      
)                                                            
 gt_top_i 
(                                         

    //--------------------------------------------------------------------------
    //  Clock & Reset Ports
    //--------------------------------------------------------------------------
    .PHY_REFCLK                        ( sys_clk_bufg ),               
    .PHY_GTREFCLK                      ( sys_clk_gt ),               
    .PHY_RST_N                         ( sys_rst_n ),           
   
    .PHY_PCLK                          ( pipe_clk ),  
    .PHY_CORECLK                       ( core_clk ), 
    .PHY_USERCLK                       ( user_clk ),                          
    .mcap_clk			       ( mcap_clk ),

    .free_run_clock_in      (free_run_clock),
    .ibert_txprecursor_in   (txeq_precursor_o), 
    .ibert_txpostcursor_in  (txeq_postcursor_o), 
    .ibert_eyescanreset_in  ({PL_LINK_CAP_MAX_LINK_WIDTH{1'b0}}), 
    .ibert_rxlpmen_in       (~gt_pcierategen3_o), 
    .ibert_txdiffctrl_in    ({PL_LINK_CAP_MAX_LINK_WIDTH{4'b1100}}),

    .txeq_precursor         (txeq_precursor_o), 
    .txeq_postcursor        (txeq_postcursor_o), 
    .gt_pcierategen3        (gt_pcierategen3_o), 
    //--------------------------------------------------------------------------
    //  Serial Line Ports
    //--------------------------------------------------------------------------
    .PHY_RXP                           ( pci_exp_rxp ),               
    .PHY_RXN                           ( pci_exp_rxn ),               
                                             
    .PHY_TXP                           ( pci_exp_txp ),               
    .PHY_TXN                           ( pci_exp_txn ),   
                                                                       
    //--------------------------------------------------------------------------
    //  TX Data Ports 
    //--------------------------------------------------------------------------
    .PHY_TXDATA                        ( pipe_txdata ),            
    .PHY_TXDATAK                       ( pipe_tx_char_is_k ),                
    .PHY_TXDATA_VALID                  ( pipe_tx_data_valid ),                
    .PHY_TXSTART_BLOCK                 ( pipe_tx_start_block ),                      
    .PHY_TXSYNC_HEADER                 ( pipe_tx_syncheader ),                                          

    //--------------------------------------------------------------------------
    //  RX Data Ports 
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    .PHY_RXDATA                        ( pipe_rx_data ),            
    .PHY_RXDATAK                       ( pipe_rx_char_is_k ),                
    .PHY_RXDATA_VALID                  ( pipe_rx_data_valid ),                
    .PHY_RXSTART_BLOCK                 ( pipe_rx_start_block ),                      
    .PHY_RXSYNC_HEADER                 ( pipe_rx_syncheader ),                                          

    
    //--------------------------------------------------------------------------
    //  PHY Command Port
    //--------------------------------------------------------------------------
    .PHY_TXDETECTRX                    ( pipe_tx0_rcvr_det ),        
    .PHY_TXELECIDLE                    ( pipe_tx_elec_idle ),                    
    .PHY_TXCOMPLIANCE                  ( pipe_tx_compliance ),                          
    .PHY_RXPOLARITY                    ( pipe_rx_polarity),           
    .PHY_POWERDOWN                     ( pipe_tx0_powerdown ),                          
    .PHY_RATE                          ( pipe_tx_rate_i ),              
    
    //--------------------------------------------------------------------------   
    //  PHY Status Ports
    //-------------------------------------------------------------------------- 
    .PHY_RXVALID                       ( pipe_rx_valid ),            
    .PHY_PHYSTATUS                     ( pipe_rx_phy_status ),            
    .PHY_PHYSTATUS_RST                 ( phy_rdy_phystatus ),          
    .PHY_RXELECIDLE                    ( pipe_rx_elec_idle ),      
    .PHY_RXSTATUS                      ( pipe_rx_status ),                                            
    
    //--------------------------------------------------------------------------   
    //  TX Equalization Ports for Gen3
    //--------------------------------------------------------------------------  
    .PHY_TXEQ_CTRL                     ( pipe_tx_eqcontrol ),
    .PHY_TXEQ_PRESET                   ( pipe_tx_eqpreset  ),
    .PHY_TXEQ_COEFF                    ( pipe_tx_eqdeemph ),
                                                            
    .PHY_TXEQ_FS                       ( pipe_tx_eqfs ),           
    .PHY_TXEQ_LF                       ( pipe_tx_eqlf ),           
    .PHY_TXEQ_NEW_COEFF                ( pipe_tx_eqcoeff ),
    .PHY_TXEQ_DONE                     ( pipe_tx_eqdone ),
                                                                 
    //--------------------------------------------------------------------------
    //  RX Equalization Ports for Gen3
    //--------------------------------------------------------------------------                                               
    .PHY_RXEQ_CTRL                     ( pipe_rx_eqcontrol  ), 
    .PHY_RXEQ_PRESET                   ( pipe_rx_eqpreset ), 
    .PHY_RXEQ_LFFS                     ( pipe_rx_eq_lffs  ),         
    .PHY_RXEQ_TXPRESET                 ( pipe_rx_eq_txpreset  ),
	
	  .PHY_RXEQ_LFFS_SEL                 ( pipe_rx_eq_lffs_sel ),      
    .PHY_RXEQ_NEW_TXCOEFF              ( pipe_rx_eq_new_txcoeff ),   
    .PHY_RXEQ_DONE                     ( pipe_rx_eqdone ),         
    .PHY_RXEQ_ADAPT_DONE               ( pipe_rx_eq_adapt_done ),         
    
   //---------- Shared Logic Internal -------------------------
    .INT_QPLL1LOCK_OUT                 ( int_qpll1lock_out ),   
    .INT_QPLL1OUTREFCLK_OUT            ( int_qpll1outrefclk_out ),
    .INT_QPLL1OUTCLK_OUT               ( int_qpll1outclk_out ),
    //---------- External GT COMMON Ports ----------------------
    .EXT_QPLL1REFCLK                   ( ext_qpll1refclk ),
    .EXT_QPLL1PD                       ( ext_qpll1pd ),
    .EXT_QPLL1RATE                     ( ext_qpll1rate ),
    .EXT_QPLL1RESET                    ( ext_qpll1reset ),

    .EXT_QPLL1LOCK_OUT                 ( ext_qpll1lock_out ),
    .EXT_QPLL1OUTCLK_OUT               ( ext_qpll1outclk_out ),
    .EXT_QPLL1OUTREFCLK_OUT            ( ext_qpll1outrefclk_out ),
    //--------------------------------------------------------------------------
    //  GT Debug Ports
    //--------------------------------------------------------------------------
    .GTW_DRPCLK                        ( ext_ch_gt_drpclk ),
    .GTW_DRPADDR                       ( ext_ch_gt_drpaddr ),  
    .GTW_DRPEN                         ( ext_ch_gt_drpen_mux ),                
    .GTW_DRPWE                         ( ext_ch_gt_drpwe ),                
    .GTW_DRPDI                         ( ext_ch_gt_drpdi ), 
    .GTW_DRPRDY                        ( ext_ch_gt_drprdy ),               
    .GTW_DRPDO                         ( ext_ch_gt_drpdo ), 
    //------------------------------------------------------------------
    .GT_PCIEUSERRATEDONE              (gt_pcieuserratedone_mux ),
    .GT_LOOPBACK                      (gt_loopback_mux     ),            
    .GT_TXPRBSFORCEERR                (gt_txprbsforceerr   ),           
    .GT_TXINHIBIT                     (gt_txinhibit        ),
    .GT_TXPRBSSEL                     (gt_txprbssel_mux    ),           
    .GT_RXPRBSSEL                     (gt_rxprbssel_mux    ),         
    .GT_RXPRBSCNTRESET                (gt_rxprbscntreset   ),            
    .GT_RXCDRLOCK                     (gt_rxcdrlock        ),
    .GT_PCIERATEIDLE                  (gt_pcierateidle     ),
    .GT_PCIEUSERRATESTART             (gt_pcieuserratestart),
    .GT_GTPOWERGOOD                   (gt_gtpowergood      ),
    .GT_RXOUTCLK                      (gt_rxoutclk         ),
    .GT_RXRECCLKOUT                   (gt_rxrecclkout      ),
    .GT_TXRESETDONE                   (gt_txresetdone      ),
    .GT_RXPMARESETDONE                (gt_rxpmaresetdone   ),
    .GT_RXRESETDONE                   (gt_rxresetdone      ),
    .GT_RXBUFSTATUS                   (gt_rxbufstatus      ),
    .GT_TXPHALIGNDONE                 (gt_txphaligndone    ),
    .GT_TXPHINITDONE                  (gt_txphinitdone     ),
    .GT_TXDLYSRESETDONE               (gt_txdlysresetdone  ),
    .GT_RXPHALIGNDONE                 (gt_rxphaligndone    ),
    .GT_RXDLYSRESETDONE               (gt_rxdlysresetdone  ),
    .GT_RXSYNCDONE                    (gt_rxsyncdone       ),
    .GT_CPLLLOCK                      (gt_cplllock         ),
    .GT_QPLL1LOCK                     (gt_qpll1lock        ),
    .GT_EYESCANDATAERROR              (gt_eyescandataerror ),
    .GT_RXPRBSERR                     (gt_rxprbserr        ),
    .GT_DMONFIFORESET                 (gt_dmonfiforeset    ),
    .GT_DMONITORCLK                   ({PL_LINK_CAP_MAX_LINK_WIDTH{sys_clk_bufg}}),
    .GT_DMONITOROUT                   (gt_dmonitorout      ),
    .GT_RXCOMMADET                    (gt_rxcommadet       ),  
    .GT_RXSTATUS                      (gt_rxstatus         ),
    .GT_TXELECIDLE                    (gt_txelecidle       ),
    .GT_PHYSTATUS                     (gt_phystatus        ),  
    .GT_RXVALID                       (gt_rxvalid          ),
    .GT_BUFGTDIV                      (gt_bufgtdiv         ),
    .GT_RXLPMEN                       (gt_rxlpmen          ),
    .PHY_RRST_N                       (phy_rrst_n          ),
    .PHY_PRST_N                       (phy_prst_n          ),
    .TXEQ_CTRL                        (phy_txeq_ctrl       ), 
    .TXEQ_PRESET                      (phy_txeq_preset     ),  
    .PHY_RST_FSM                      (phy_rst_fsm         ),
    .PHY_TXEQ_FSM                     (phy_txeq_fsm        ), 
    .PHY_RXEQ_FSM                     (phy_rxeq_fsm        ),
    .PHY_RST_IDLE                     (phy_rst_idle        ),            
    //--------------------------------------------------------------------------
    //  TX Driver Ports
    //--------------------------------------------------------------------------
    .PHY_TXMARGIN                      ( pipe_tx0_margin ),          
    .PHY_TXSWING                       ( pipe_tx0_swing  ),           
    .PHY_RXCDRHOLD                     ( phy_rxcdrhold),    
    .PHY_TXDEEMPH                      ( pipe_tx0_deemph ),

    //--------------------------------------------------------------------------
    //  PCIe State
    //--------------------------------------------------------------------------
    .PHASE1                            (phase1),
    .cfg_ltssm_state                   ( cfg_ltssm_state )
    
);

  xdma_0_pcie3_ip_pcie3_uscale_top 
 #(
    .TCQ (TCQ),
    .NO_DECODE_LOGIC (NO_DECODE_LOGIC),
    .INTERFACE_SPEED (INTERFACE_SPEED),
    .COMPLETION_SPACE (COMPLETION_SPACE),
    .KEEP_WIDTH (KEEP_WIDTH),
    .C_DATA_WIDTH (C_DATA_WIDTH),
    .PIPE_PIPELINE_STAGES (PIPE_PIPELINE_STAGES),
    .ARI_CAP_ENABLE (ARI_CAP_ENABLE),
    .AXISTEN_IF_CC_ALIGNMENT_MODE (AXISTEN_IF_CC_ALIGNMENT_MODE),
    .AXISTEN_IF_CC_PARITY_CHK (AXISTEN_IF_CC_PARITY_CHK),
    .AXISTEN_IF_CQ_ALIGNMENT_MODE (AXISTEN_IF_CQ_ALIGNMENT_MODE),
    .AXISTEN_IF_ENABLE_CLIENT_TAG (AXISTEN_IF_ENABLE_CLIENT_TAG),
    .AXISTEN_IF_ENABLE_MSG_ROUTE (AXISTEN_IF_ENABLE_MSG_ROUTE),
    .AXISTEN_IF_ENABLE_RX_MSG_INTFC (AXISTEN_IF_ENABLE_RX_MSG_INTFC),
    .AXISTEN_IF_RC_ALIGNMENT_MODE (AXISTEN_IF_RC_ALIGNMENT_MODE),
    .AXISTEN_IF_RC_STRADDLE (AXISTEN_IF_RC_STRADDLE),
    .AXISTEN_IF_RQ_ALIGNMENT_MODE (AXISTEN_IF_RQ_ALIGNMENT_MODE),
    .AXISTEN_IF_RQ_PARITY_CHK (AXISTEN_IF_RQ_PARITY_CHK),
    .AXISTEN_IF_WIDTH (AXISTEN_IF_WIDTH),
    .CRM_CORE_CLK_FREQ_500 (CRM_CORE_CLK_FREQ_500),
    .CRM_USER_CLK_FREQ (CRM_USER_CLK_FREQ),
    .DEBUG_CFG_LOCAL_MGMT_REG_ACCESS_OVERRIDE (DEBUG_CFG_LOCAL_MGMT_REG_ACCESS_OVERRIDE),
    .DEBUG_PL_DISABLE_EI_INFER_IN_L0 (DEBUG_PL_DISABLE_EI_INFER_IN_L0),
    .DEBUG_TL_DISABLE_RX_TLP_ORDER_CHECKS (DEBUG_TL_DISABLE_RX_TLP_ORDER_CHECKS),
    .DNSTREAM_LINK_NUM (DNSTREAM_LINK_NUM),
    .LL_ACK_TIMEOUT (LL_ACK_TIMEOUT),
    .LL_ACK_TIMEOUT_EN (LL_ACK_TIMEOUT_EN),
    .LL_ACK_TIMEOUT_FUNC (LL_ACK_TIMEOUT_FUNC),
    .LL_CPL_FC_UPDATE_TIMER (LL_CPL_FC_UPDATE_TIMER),
    .LL_CPL_FC_UPDATE_TIMER_OVERRIDE (LL_CPL_FC_UPDATE_TIMER_OVERRIDE),
    .LL_FC_UPDATE_TIMER (LL_FC_UPDATE_TIMER),
    .LL_FC_UPDATE_TIMER_OVERRIDE (LL_FC_UPDATE_TIMER_OVERRIDE),
    .LL_NP_FC_UPDATE_TIMER (LL_NP_FC_UPDATE_TIMER),
    .LL_NP_FC_UPDATE_TIMER_OVERRIDE (LL_NP_FC_UPDATE_TIMER_OVERRIDE),
    .LL_P_FC_UPDATE_TIMER (LL_P_FC_UPDATE_TIMER),
    .LL_P_FC_UPDATE_TIMER_OVERRIDE (LL_P_FC_UPDATE_TIMER_OVERRIDE),
    .LL_REPLAY_TIMEOUT (LL_REPLAY_TIMEOUT),
    .LL_REPLAY_TIMEOUT_EN (LL_REPLAY_TIMEOUT_EN),
    .LL_REPLAY_TIMEOUT_FUNC (LL_REPLAY_TIMEOUT_FUNC),
    .LTR_TX_MESSAGE_MINIMUM_INTERVAL (LTR_TX_MESSAGE_MINIMUM_INTERVAL),
    .LTR_TX_MESSAGE_ON_FUNC_POWER_STATE_CHANGE (LTR_TX_MESSAGE_ON_FUNC_POWER_STATE_CHANGE),
    .LTR_TX_MESSAGE_ON_LTR_ENABLE (LTR_TX_MESSAGE_ON_LTR_ENABLE),
    .MCAP_CAP_NEXTPTR (MCAP_CAP_NEXTPTR),
    .MCAP_CONFIGURE_OVERRIDE (MCAP_CONFIGURE_OVERRIDE),
    .MCAP_ENABLE (MCAP_ENABLE),
    .MCAP_EOS_DESIGN_SWITCH (MCAP_EOS_DESIGN_SWITCH),
    .MCAP_FPGA_BITSTREAM_VERSION (MCAP_FPGA_BITSTREAM_VERSION),
    .MCAP_GATE_IO_ENABLE_DESIGN_SWITCH (MCAP_GATE_IO_ENABLE_DESIGN_SWITCH),
    .MCAP_GATE_MEM_ENABLE_DESIGN_SWITCH (MCAP_GATE_MEM_ENABLE_DESIGN_SWITCH),
    .MCAP_INPUT_GATE_DESIGN_SWITCH (MCAP_INPUT_GATE_DESIGN_SWITCH),
    .MCAP_INTERRUPT_ON_MCAP_EOS (MCAP_INTERRUPT_ON_MCAP_EOS),
    .MCAP_INTERRUPT_ON_MCAP_ERROR (MCAP_INTERRUPT_ON_MCAP_ERROR),
    .MCAP_VSEC_ID (MCAP_VSEC_ID),
    .MCAP_VSEC_LEN (MCAP_VSEC_LEN),
    .MCAP_VSEC_REV (MCAP_VSEC_REV),
    .PF0_AER_CAP_ECRC_CHECK_CAPABLE (PF0_AER_CAP_ECRC_CHECK_CAPABLE),
    .PF0_AER_CAP_ECRC_GEN_CAPABLE (PF0_AER_CAP_ECRC_GEN_CAPABLE),
    .PF0_AER_CAP_NEXTPTR (PF0_AER_CAP_NEXTPTR),
    .PF0_ARI_CAP_NEXT_FUNC (PF0_ARI_CAP_NEXT_FUNC),
    .PF0_ARI_CAP_NEXTPTR (PF0_ARI_CAP_NEXTPTR),
    .PF0_ARI_CAP_VER (PF0_ARI_CAP_VER),
    .PF0_BAR0_APERTURE_SIZE (PF0_BAR0_APERTURE_SIZE),
    .PF0_BAR0_CONTROL (PF0_BAR0_CONTROL),
    .PF0_BAR1_APERTURE_SIZE (PF0_BAR1_APERTURE_SIZE),
    .PF0_BAR1_CONTROL (PF0_BAR1_CONTROL),
    .PF0_BAR2_APERTURE_SIZE (PF0_BAR2_APERTURE_SIZE),
    .PF0_BAR2_CONTROL (PF0_BAR2_CONTROL),
    .PF0_BAR3_APERTURE_SIZE (PF0_BAR3_APERTURE_SIZE),
    .PF0_BAR3_CONTROL (PF0_BAR3_CONTROL),
    .PF0_BAR4_APERTURE_SIZE (PF0_BAR4_APERTURE_SIZE),
    .PF0_BAR4_CONTROL (PF0_BAR4_CONTROL),
    .PF0_BAR5_APERTURE_SIZE (PF0_BAR5_APERTURE_SIZE),
    .PF0_BAR5_CONTROL (PF0_BAR5_CONTROL),
    .PF0_BIST_REGISTER (PF0_BIST_REGISTER),
    .PF0_CAPABILITY_POINTER (PF0_CAPABILITY_POINTER),
    .PF0_CLASS_CODE (PF0_CLASS_CODE),
    .PF0_DEV_CAP_ENDPOINT_L0S_LATENCY (PF0_DEV_CAP_ENDPOINT_L0S_LATENCY),
    .PF0_DEV_CAP_ENDPOINT_L1_LATENCY (PF0_DEV_CAP_ENDPOINT_L1_LATENCY),
    .PF0_DEV_CAP_EXT_TAG_SUPPORTED (PF0_DEV_CAP_EXT_TAG_SUPPORTED),
    .PF0_DEV_CAP_FUNCTION_LEVEL_RESET_CAPABLE (PF0_DEV_CAP_FUNCTION_LEVEL_RESET_CAPABLE),
    .PF0_DEV_CAP_MAX_PAYLOAD_SIZE (PF0_DEV_CAP_MAX_PAYLOAD_SIZE),
    .PF0_DEV_CAP2_ARI_FORWARD_ENABLE (PF0_DEV_CAP2_ARI_FORWARD_ENABLE),
    .PF0_DEV_CAP2_CPL_TIMEOUT_DISABLE (PF0_DEV_CAP2_CPL_TIMEOUT_DISABLE),
    .PF0_DEV_CAP2_LTR_SUPPORT (PF0_DEV_CAP2_LTR_SUPPORT),
    .PF0_DEV_CAP2_OBFF_SUPPORT (PF0_DEV_CAP2_OBFF_SUPPORT),
    .PF0_DEV_CAP2_TPH_COMPLETER_SUPPORT (PF0_DEV_CAP2_TPH_COMPLETER_SUPPORT),
    .PF0_DEV_CAP2_32B_ATOMIC_COMPLETER_SUPPORT (PF0_DEV_CAP2_32B_ATOMIC_COMPLETER_SUPPORT),
    .PF0_DEV_CAP2_64B_ATOMIC_COMPLETER_SUPPORT (PF0_DEV_CAP2_64B_ATOMIC_COMPLETER_SUPPORT),
    .PF0_DEV_CAP2_128B_CAS_ATOMIC_COMPLETER_SUPPORT (PF0_DEV_CAP2_128B_CAS_ATOMIC_COMPLETER_SUPPORT),
    .PF0_DEVICE_ID (PF0_DEVICE_ID),
    .PF0_DPA_CAP_NEXTPTR (PF0_DPA_CAP_NEXTPTR),
    .PF0_DPA_CAP_SUB_STATE_CONTROL (PF0_DPA_CAP_SUB_STATE_CONTROL),
    .PF0_DPA_CAP_SUB_STATE_CONTROL_EN (PF0_DPA_CAP_SUB_STATE_CONTROL_EN),
    .PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION0 (PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION0),
    .PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION1 (PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION1),
    .PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION2 (PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION2),
    .PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION3 (PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION3),
    .PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION4 (PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION4),
    .PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION5 (PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION5),
    .PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION6 (PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION6),
    .PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION7 (PF0_DPA_CAP_SUB_STATE_POWER_ALLOCATION7),
    .PF0_DPA_CAP_VER (PF0_DPA_CAP_VER),
    .PF0_DSN_CAP_NEXTPTR (PF0_DSN_CAP_NEXTPTR),
    .PF0_EXPANSION_ROM_APERTURE_SIZE (PF0_EXPANSION_ROM_APERTURE_SIZE),
    .PF0_EXPANSION_ROM_ENABLE (PF0_EXPANSION_ROM_ENABLE),
    .PF0_INTERRUPT_LINE (PF0_INTERRUPT_LINE),
    .PF0_INTERRUPT_PIN (PF0_INTERRUPT_PIN),
    .PF0_LINK_CAP_ASPM_SUPPORT (PF0_LINK_CAP_ASPM_SUPPORT),
    .PF0_LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN1 (PF0_LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN1),
    .PF0_LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN2 (PF0_LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN2),
    .PF0_LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN3 (PF0_LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN3),
    .PF0_LINK_CAP_L0S_EXIT_LATENCY_GEN1 (PF0_LINK_CAP_L0S_EXIT_LATENCY_GEN1),
    .PF0_LINK_CAP_L0S_EXIT_LATENCY_GEN2 (PF0_LINK_CAP_L0S_EXIT_LATENCY_GEN2),
    .PF0_LINK_CAP_L0S_EXIT_LATENCY_GEN3 (PF0_LINK_CAP_L0S_EXIT_LATENCY_GEN3),
    .PF0_LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN1 (PF0_LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN1),
    .PF0_LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN2 (PF0_LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN2),
    .PF0_LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN3 (PF0_LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN3),
    .PF0_LINK_CAP_L1_EXIT_LATENCY_GEN1 (PF0_LINK_CAP_L1_EXIT_LATENCY_GEN1),
    .PF0_LINK_CAP_L1_EXIT_LATENCY_GEN2 (PF0_LINK_CAP_L1_EXIT_LATENCY_GEN2),
    .PF0_LINK_CAP_L1_EXIT_LATENCY_GEN3 (PF0_LINK_CAP_L1_EXIT_LATENCY_GEN3),
    .PF0_LINK_STATUS_SLOT_CLOCK_CONFIG (PF0_LINK_STATUS_SLOT_CLOCK_CONFIG),
    .PF0_LTR_CAP_MAX_NOSNOOP_LAT (PF0_LTR_CAP_MAX_NOSNOOP_LAT),
    .PF0_LTR_CAP_MAX_SNOOP_LAT (PF0_LTR_CAP_MAX_SNOOP_LAT),
    .PF0_LTR_CAP_NEXTPTR (PF0_LTR_CAP_NEXTPTR),
    .PF0_LTR_CAP_VER (PF0_LTR_CAP_VER),
    .PF0_MSI_CAP_MULTIMSGCAP (PF0_MSI_CAP_MULTIMSGCAP),
    .PF0_MSI_CAP_NEXTPTR (PF0_MSI_CAP_NEXTPTR),
    .PF0_MSI_CAP_PERVECMASKCAP (PF0_MSI_CAP_PERVECMASKCAP),
    .PF0_MSIX_CAP_NEXTPTR (PF0_MSIX_CAP_NEXTPTR),
    .PF0_MSIX_CAP_PBA_BIR (PF0_MSIX_CAP_PBA_BIR),
    .PF0_MSIX_CAP_PBA_OFFSET ({3'b000,PF0_MSIX_CAP_PBA_OFFSET[28:3]}),
    .PF0_MSIX_CAP_TABLE_BIR (PF0_MSIX_CAP_TABLE_BIR),
    .PF0_MSIX_CAP_TABLE_OFFSET ({3'b000,PF0_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .PF0_MSIX_CAP_TABLE_SIZE (PF0_MSIX_CAP_TABLE_SIZE),
    .PF0_PB_CAP_DATA_REG_D0 (PF0_PB_CAP_DATA_REG_D0),
    .PF0_PB_CAP_DATA_REG_D0_SUSTAINED (PF0_PB_CAP_DATA_REG_D0_SUSTAINED),
    .PF0_PB_CAP_DATA_REG_D1 (PF0_PB_CAP_DATA_REG_D1),
    .PF0_PB_CAP_DATA_REG_D3HOT (PF0_PB_CAP_DATA_REG_D3HOT),
    .PF0_PB_CAP_NEXTPTR (PF0_PB_CAP_NEXTPTR),
    .PF0_PB_CAP_SYSTEM_ALLOCATED (PF0_PB_CAP_SYSTEM_ALLOCATED),
    .PF0_PB_CAP_VER (PF0_PB_CAP_VER),
    .PF0_PM_CAP_ID (PF0_PM_CAP_ID),
    .PF0_PM_CAP_NEXTPTR (PF0_PM_CAP_NEXTPTR),
    .PF0_PM_CAP_PMESUPPORT_D0 (PF0_PM_CAP_PMESUPPORT_D0),
    .PF0_PM_CAP_PMESUPPORT_D1 (PF0_PM_CAP_PMESUPPORT_D1),
    .PF0_PM_CAP_PMESUPPORT_D3HOT (PF0_PM_CAP_PMESUPPORT_D3HOT),
    .PF0_PM_CAP_SUPP_D1_STATE (PF0_PM_CAP_SUPP_D1_STATE),
    .PF0_PM_CAP_VER_ID (PF0_PM_CAP_VER_ID),
    .PF0_PM_CSR_NOSOFTRESET (PF0_PM_CSR_NOSOFTRESET),
    .PF0_RBAR_CAP_ENABLE (PF0_RBAR_CAP_ENABLE),
    .PF0_RBAR_CAP_NEXTPTR (PF0_RBAR_CAP_NEXTPTR),
    .PF0_RBAR_CAP_SIZE0 (PF0_RBAR_CAP_SIZE0),
    .PF0_RBAR_CAP_SIZE1 (PF0_RBAR_CAP_SIZE1),
    .PF0_RBAR_CAP_SIZE2 (PF0_RBAR_CAP_SIZE2),
    .PF0_RBAR_CAP_VER (PF0_RBAR_CAP_VER),
    .PF0_RBAR_CONTROL_INDEX0 (PF0_RBAR_CONTROL_INDEX0),
    .PF0_RBAR_CONTROL_INDEX1 (PF0_RBAR_CONTROL_INDEX1),
    .PF0_RBAR_CONTROL_INDEX2 (PF0_RBAR_CONTROL_INDEX2),
    .PF0_RBAR_CONTROL_SIZE0 (PF0_RBAR_CONTROL_SIZE0),
    .PF0_RBAR_CONTROL_SIZE1 (PF0_RBAR_CONTROL_SIZE1),
    .PF0_RBAR_CONTROL_SIZE2 (PF0_RBAR_CONTROL_SIZE2),
    .PF0_RBAR_NUM (PF0_RBAR_NUM),
    .PF0_REVISION_ID (PF0_REVISION_ID),
    .PF0_SECONDARY_PCIE_CAP_NEXTPTR (PF0_SECONDARY_PCIE_CAP_NEXTPTR),
    .PF0_SRIOV_BAR0_APERTURE_SIZE (PF0_SRIOV_BAR0_APERTURE_SIZE),
    .PF0_SRIOV_BAR0_CONTROL (PF0_SRIOV_BAR0_CONTROL),
    .PF0_SRIOV_BAR1_APERTURE_SIZE (PF0_SRIOV_BAR1_APERTURE_SIZE),
    .PF0_SRIOV_BAR1_CONTROL (PF0_SRIOV_BAR1_CONTROL),
    .PF0_SRIOV_BAR2_APERTURE_SIZE (PF0_SRIOV_BAR2_APERTURE_SIZE),
    .PF0_SRIOV_BAR2_CONTROL (PF0_SRIOV_BAR2_CONTROL),
    .PF0_SRIOV_BAR3_APERTURE_SIZE (PF0_SRIOV_BAR3_APERTURE_SIZE),
    .PF0_SRIOV_BAR3_CONTROL (PF0_SRIOV_BAR3_CONTROL),
    .PF0_SRIOV_BAR4_APERTURE_SIZE (PF0_SRIOV_BAR4_APERTURE_SIZE),
    .PF0_SRIOV_BAR4_CONTROL (PF0_SRIOV_BAR4_CONTROL),
    .PF0_SRIOV_BAR5_APERTURE_SIZE (PF0_SRIOV_BAR5_APERTURE_SIZE),
    .PF0_SRIOV_BAR5_CONTROL (PF0_SRIOV_BAR5_CONTROL),
    .PF0_SRIOV_CAP_INITIAL_VF (PF0_SRIOV_CAP_INITIAL_VF),
    .PF0_SRIOV_CAP_NEXTPTR (PF0_SRIOV_CAP_NEXTPTR),
    .PF0_SRIOV_CAP_TOTAL_VF (PF0_SRIOV_CAP_TOTAL_VF),
    .PF0_SRIOV_CAP_VER (PF0_SRIOV_CAP_VER),
    .PF0_SRIOV_FIRST_VF_OFFSET (PF0_SRIOV_FIRST_VF_OFFSET),
    .PF0_SRIOV_FUNC_DEP_LINK (PF0_SRIOV_FUNC_DEP_LINK),
    .PF0_SRIOV_SUPPORTED_PAGE_SIZE (PF0_SRIOV_SUPPORTED_PAGE_SIZE),
    .PF0_SRIOV_VF_DEVICE_ID (PF0_SRIOV_VF_DEVICE_ID),
    .PF0_SUBSYSTEM_ID (PF0_SUBSYSTEM_ID),
    .PF0_TPHR_CAP_DEV_SPECIFIC_MODE (PF0_TPHR_CAP_DEV_SPECIFIC_MODE),
    .PF0_TPHR_CAP_ENABLE (PF0_TPHR_CAP_ENABLE),
    .PF0_TPHR_CAP_INT_VEC_MODE (PF0_TPHR_CAP_INT_VEC_MODE),
    .PF0_TPHR_CAP_NEXTPTR (PF0_TPHR_CAP_NEXTPTR),
    .PF0_TPHR_CAP_ST_MODE_SEL (PF0_TPHR_CAP_ST_MODE_SEL),
    .PF0_TPHR_CAP_ST_TABLE_LOC (PF0_TPHR_CAP_ST_TABLE_LOC),
    .PF0_TPHR_CAP_ST_TABLE_SIZE (PF0_TPHR_CAP_ST_TABLE_SIZE),
    .PF0_TPHR_CAP_VER (PF0_TPHR_CAP_VER),
    .PF0_VC_CAP_ENABLE (PF0_VC_CAP_ENABLE),
    .PF0_VC_CAP_NEXTPTR (PF0_VC_CAP_NEXTPTR),
    .PF0_VC_CAP_VER (PF0_VC_CAP_VER),
    .PF1_AER_CAP_ECRC_CHECK_CAPABLE (PF1_AER_CAP_ECRC_CHECK_CAPABLE),
    .PF1_AER_CAP_ECRC_GEN_CAPABLE (PF1_AER_CAP_ECRC_GEN_CAPABLE),
    .PF1_AER_CAP_NEXTPTR (PF1_AER_CAP_NEXTPTR),
    .PF1_ARI_CAP_NEXT_FUNC (PF1_ARI_CAP_NEXT_FUNC),
    .PF1_ARI_CAP_NEXTPTR (PF1_ARI_CAP_NEXTPTR),
    .PF1_BAR0_APERTURE_SIZE (PF1_BAR0_APERTURE_SIZE),
    .PF1_BAR0_CONTROL (PF1_BAR0_CONTROL),
    .PF1_BAR1_APERTURE_SIZE (PF1_BAR1_APERTURE_SIZE),
    .PF1_BAR1_CONTROL (PF1_BAR1_CONTROL),
    .PF1_BAR2_APERTURE_SIZE (PF1_BAR2_APERTURE_SIZE),
    .PF1_BAR2_CONTROL (PF1_BAR2_CONTROL),
    .PF1_BAR3_APERTURE_SIZE (PF1_BAR3_APERTURE_SIZE),
    .PF1_BAR3_CONTROL (PF1_BAR3_CONTROL),
    .PF1_BAR4_APERTURE_SIZE (PF1_BAR4_APERTURE_SIZE),
    .PF1_BAR4_CONTROL (PF1_BAR4_CONTROL),
    .PF1_BAR5_APERTURE_SIZE (PF1_BAR5_APERTURE_SIZE),
    .PF1_BAR5_CONTROL (PF1_BAR5_CONTROL),
    .PF1_BIST_REGISTER (PF1_BIST_REGISTER),
    .PF1_CAPABILITY_POINTER (PF1_CAPABILITY_POINTER),
    .PF1_CLASS_CODE (PF1_CLASS_CODE),
    .PF1_DEV_CAP_MAX_PAYLOAD_SIZE (PF1_DEV_CAP_MAX_PAYLOAD_SIZE),
    .PF1_DEVICE_ID (PF1_DEVICE_ID),
    .PF1_DPA_CAP_NEXTPTR (PF1_DPA_CAP_NEXTPTR),
    .PF1_DPA_CAP_SUB_STATE_CONTROL (PF1_DPA_CAP_SUB_STATE_CONTROL),
    .PF1_DPA_CAP_SUB_STATE_CONTROL_EN (PF1_DPA_CAP_SUB_STATE_CONTROL_EN),
    .PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION0 (PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION0),
    .PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION1 (PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION1),
    .PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION2 (PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION2),
    .PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION3 (PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION3),
    .PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION4 (PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION4),
    .PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION5 (PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION5),
    .PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION6 (PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION6),
    .PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION7 (PF1_DPA_CAP_SUB_STATE_POWER_ALLOCATION7),
    .PF1_DPA_CAP_VER (PF1_DPA_CAP_VER),
    .PF1_DSN_CAP_NEXTPTR (PF1_DSN_CAP_NEXTPTR),
    .PF1_EXPANSION_ROM_APERTURE_SIZE (PF1_EXPANSION_ROM_APERTURE_SIZE),
    .PF1_EXPANSION_ROM_ENABLE (PF1_EXPANSION_ROM_ENABLE),
    .PF1_INTERRUPT_LINE (PF1_INTERRUPT_LINE),
    .PF1_INTERRUPT_PIN (PF1_INTERRUPT_PIN),
    .PF1_MSI_CAP_MULTIMSGCAP (PF1_MSI_CAP_MULTIMSGCAP),
    .PF1_MSI_CAP_NEXTPTR (PF1_MSI_CAP_NEXTPTR),
    .PF1_MSI_CAP_PERVECMASKCAP (PF1_MSI_CAP_PERVECMASKCAP),
    .PF1_MSIX_CAP_NEXTPTR (PF1_MSIX_CAP_NEXTPTR),
    .PF1_MSIX_CAP_PBA_BIR (PF1_MSIX_CAP_PBA_BIR),
    .PF1_MSIX_CAP_PBA_OFFSET ({3'b000,PF1_MSIX_CAP_PBA_OFFSET[28:3]}),
    .PF1_MSIX_CAP_TABLE_BIR (PF1_MSIX_CAP_TABLE_BIR),
    .PF1_MSIX_CAP_TABLE_OFFSET ({3'b000,PF1_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .PF1_MSIX_CAP_TABLE_SIZE (PF1_MSIX_CAP_TABLE_SIZE),
    .PF1_PB_CAP_DATA_REG_D0 (PF1_PB_CAP_DATA_REG_D0),
    .PF1_PB_CAP_DATA_REG_D0_SUSTAINED (PF1_PB_CAP_DATA_REG_D0_SUSTAINED),
    .PF1_PB_CAP_DATA_REG_D1 (PF1_PB_CAP_DATA_REG_D1),
    .PF1_PB_CAP_DATA_REG_D3HOT (PF1_PB_CAP_DATA_REG_D3HOT),
    .PF1_PB_CAP_NEXTPTR (PF1_PB_CAP_NEXTPTR),
    .PF1_PB_CAP_SYSTEM_ALLOCATED (PF1_PB_CAP_SYSTEM_ALLOCATED),
    .PF1_PB_CAP_VER (PF1_PB_CAP_VER),
    .PF1_PM_CAP_ID (PF1_PM_CAP_ID),
    .PF1_PM_CAP_NEXTPTR (PF1_PM_CAP_NEXTPTR),
    .PF1_PM_CAP_VER_ID (PF1_PM_CAP_VER_ID),
    .PF1_RBAR_CAP_ENABLE (PF1_RBAR_CAP_ENABLE),
    .PF1_RBAR_CAP_NEXTPTR (PF1_RBAR_CAP_NEXTPTR),
    .PF1_RBAR_CAP_SIZE0 (PF1_RBAR_CAP_SIZE0),
    .PF1_RBAR_CAP_SIZE1 (PF1_RBAR_CAP_SIZE1),
    .PF1_RBAR_CAP_SIZE2 (PF1_RBAR_CAP_SIZE2),
    .PF1_RBAR_CAP_VER (PF1_RBAR_CAP_VER),
    .PF1_RBAR_CONTROL_INDEX0 (PF1_RBAR_CONTROL_INDEX0),
    .PF1_RBAR_CONTROL_INDEX1 (PF1_RBAR_CONTROL_INDEX1),
    .PF1_RBAR_CONTROL_INDEX2 (PF1_RBAR_CONTROL_INDEX2),
    .PF1_RBAR_CONTROL_SIZE0 (PF1_RBAR_CONTROL_SIZE0),
    .PF1_RBAR_CONTROL_SIZE1 (PF1_RBAR_CONTROL_SIZE1),
    .PF1_RBAR_CONTROL_SIZE2 (PF1_RBAR_CONTROL_SIZE2),
    .PF1_RBAR_NUM (PF1_RBAR_NUM),
    .PF1_REVISION_ID (PF1_REVISION_ID),
    .PF1_SRIOV_BAR0_APERTURE_SIZE (PF1_SRIOV_BAR0_APERTURE_SIZE),
    .PF1_SRIOV_BAR0_CONTROL (PF1_SRIOV_BAR0_CONTROL),
    .PF1_SRIOV_BAR1_APERTURE_SIZE (PF1_SRIOV_BAR1_APERTURE_SIZE),
    .PF1_SRIOV_BAR1_CONTROL (PF1_SRIOV_BAR1_CONTROL),
    .PF1_SRIOV_BAR2_APERTURE_SIZE (PF1_SRIOV_BAR2_APERTURE_SIZE),
    .PF1_SRIOV_BAR2_CONTROL (PF1_SRIOV_BAR2_CONTROL),
    .PF1_SRIOV_BAR3_APERTURE_SIZE (PF1_SRIOV_BAR3_APERTURE_SIZE),
    .PF1_SRIOV_BAR3_CONTROL (PF1_SRIOV_BAR3_CONTROL),
    .PF1_SRIOV_BAR4_APERTURE_SIZE (PF1_SRIOV_BAR4_APERTURE_SIZE),
    .PF1_SRIOV_BAR4_CONTROL (PF1_SRIOV_BAR4_CONTROL),
    .PF1_SRIOV_BAR5_APERTURE_SIZE (PF1_SRIOV_BAR5_APERTURE_SIZE),
    .PF1_SRIOV_BAR5_CONTROL (PF1_SRIOV_BAR5_CONTROL),
    .PF1_SRIOV_CAP_INITIAL_VF (PF1_SRIOV_CAP_INITIAL_VF),
    .PF1_SRIOV_CAP_NEXTPTR (PF1_SRIOV_CAP_NEXTPTR),
    .PF1_SRIOV_CAP_TOTAL_VF (PF1_SRIOV_CAP_TOTAL_VF),
    .PF1_SRIOV_CAP_VER (PF1_SRIOV_CAP_VER),
    .PF1_SRIOV_FIRST_VF_OFFSET (PF1_SRIOV_FIRST_VF_OFFSET),
    .PF1_SRIOV_FUNC_DEP_LINK (PF1_SRIOV_FUNC_DEP_LINK),
    .PF1_SRIOV_SUPPORTED_PAGE_SIZE (PF1_SRIOV_SUPPORTED_PAGE_SIZE),
    .PF1_SRIOV_VF_DEVICE_ID (PF1_SRIOV_VF_DEVICE_ID),
    .PF1_SUBSYSTEM_ID (PF1_SUBSYSTEM_ID),
    .PF1_TPHR_CAP_DEV_SPECIFIC_MODE (PF1_TPHR_CAP_DEV_SPECIFIC_MODE),
    .PF1_TPHR_CAP_ENABLE (PF1_TPHR_CAP_ENABLE),
    .PF1_TPHR_CAP_INT_VEC_MODE (PF1_TPHR_CAP_INT_VEC_MODE),
    .PF1_TPHR_CAP_NEXTPTR (PF1_TPHR_CAP_NEXTPTR),
    .PF1_TPHR_CAP_ST_MODE_SEL (PF1_TPHR_CAP_ST_MODE_SEL),
    .PF1_TPHR_CAP_ST_TABLE_LOC (PF1_TPHR_CAP_ST_TABLE_LOC),
    .PF1_TPHR_CAP_ST_TABLE_SIZE (PF1_TPHR_CAP_ST_TABLE_SIZE),
    .PF1_TPHR_CAP_VER (PF1_TPHR_CAP_VER),
    .PF2_AER_CAP_ECRC_CHECK_CAPABLE (PF2_AER_CAP_ECRC_CHECK_CAPABLE),
    .PF2_AER_CAP_ECRC_GEN_CAPABLE (PF2_AER_CAP_ECRC_GEN_CAPABLE),
    .PF2_AER_CAP_NEXTPTR (PF2_AER_CAP_NEXTPTR),
    .PF2_ARI_CAP_NEXT_FUNC (PF2_ARI_CAP_NEXT_FUNC),
    .PF2_ARI_CAP_NEXTPTR (PF2_ARI_CAP_NEXTPTR),
    .PF2_BAR0_APERTURE_SIZE (PF2_BAR0_APERTURE_SIZE),
    .PF2_BAR0_CONTROL (PF2_BAR0_CONTROL),
    .PF2_BAR1_APERTURE_SIZE (PF2_BAR1_APERTURE_SIZE),
    .PF2_BAR1_CONTROL (PF2_BAR1_CONTROL),
    .PF2_BAR2_APERTURE_SIZE (PF2_BAR2_APERTURE_SIZE),
    .PF2_BAR2_CONTROL (PF2_BAR2_CONTROL),
    .PF2_BAR3_APERTURE_SIZE (PF2_BAR3_APERTURE_SIZE),
    .PF2_BAR3_CONTROL (PF2_BAR3_CONTROL),
    .PF2_BAR4_APERTURE_SIZE (PF2_BAR4_APERTURE_SIZE),
    .PF2_BAR4_CONTROL (PF2_BAR4_CONTROL),
    .PF2_BAR5_APERTURE_SIZE (PF2_BAR5_APERTURE_SIZE),
    .PF2_BAR5_CONTROL (PF2_BAR5_CONTROL),
    .PF2_BIST_REGISTER (PF2_BIST_REGISTER),
    .PF2_CAPABILITY_POINTER (PF2_CAPABILITY_POINTER),
    .PF2_CLASS_CODE (PF2_CLASS_CODE),
    .PF2_DEV_CAP_MAX_PAYLOAD_SIZE (PF2_DEV_CAP_MAX_PAYLOAD_SIZE),
    .PF2_DEVICE_ID (PF2_DEVICE_ID),
    .PF2_DPA_CAP_NEXTPTR (PF2_DPA_CAP_NEXTPTR),
    .PF2_DPA_CAP_SUB_STATE_CONTROL (PF2_DPA_CAP_SUB_STATE_CONTROL),
    .PF2_DPA_CAP_SUB_STATE_CONTROL_EN (PF2_DPA_CAP_SUB_STATE_CONTROL_EN),
    .PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION0 (PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION0),
    .PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION1 (PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION1),
    .PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION2 (PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION2),
    .PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION3 (PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION3),
    .PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION4 (PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION4),
    .PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION5 (PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION5),
    .PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION6 (PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION6),
    .PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION7 (PF2_DPA_CAP_SUB_STATE_POWER_ALLOCATION7),
    .PF2_DPA_CAP_VER (PF2_DPA_CAP_VER),
    .PF2_DSN_CAP_NEXTPTR (PF2_DSN_CAP_NEXTPTR),
    .PF2_EXPANSION_ROM_APERTURE_SIZE (PF2_EXPANSION_ROM_APERTURE_SIZE),
    .PF2_EXPANSION_ROM_ENABLE (PF2_EXPANSION_ROM_ENABLE),
    .PF2_INTERRUPT_LINE (PF2_INTERRUPT_LINE),
    .PF2_INTERRUPT_PIN (PF2_INTERRUPT_PIN),
    .PF2_MSI_CAP_MULTIMSGCAP (PF2_MSI_CAP_MULTIMSGCAP),
    .PF2_MSI_CAP_NEXTPTR (PF2_MSI_CAP_NEXTPTR),
    .PF2_MSI_CAP_PERVECMASKCAP (PF2_MSI_CAP_PERVECMASKCAP),
    .PF2_MSIX_CAP_NEXTPTR (PF2_MSIX_CAP_NEXTPTR),
    .PF2_MSIX_CAP_PBA_BIR (PF2_MSIX_CAP_PBA_BIR),
    .PF2_MSIX_CAP_PBA_OFFSET ({3'b000,PF2_MSIX_CAP_PBA_OFFSET[28:3]}),
    .PF2_MSIX_CAP_TABLE_BIR (PF2_MSIX_CAP_TABLE_BIR),
    .PF2_MSIX_CAP_TABLE_OFFSET ({3'b000,PF2_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .PF2_MSIX_CAP_TABLE_SIZE (PF2_MSIX_CAP_TABLE_SIZE),
    .PF2_PB_CAP_DATA_REG_D0 (PF2_PB_CAP_DATA_REG_D0),
    .PF2_PB_CAP_DATA_REG_D0_SUSTAINED (PF2_PB_CAP_DATA_REG_D0_SUSTAINED),
    .PF2_PB_CAP_DATA_REG_D1 (PF2_PB_CAP_DATA_REG_D1),
    .PF2_PB_CAP_DATA_REG_D3HOT (PF2_PB_CAP_DATA_REG_D3HOT),
    .PF2_PB_CAP_NEXTPTR (PF2_PB_CAP_NEXTPTR),
    .PF2_PB_CAP_SYSTEM_ALLOCATED (PF2_PB_CAP_SYSTEM_ALLOCATED),
    .PF2_PB_CAP_VER (PF2_PB_CAP_VER),
    .PF2_PM_CAP_ID (PF2_PM_CAP_ID),
    .PF2_PM_CAP_NEXTPTR (PF2_PM_CAP_NEXTPTR),
    .PF2_PM_CAP_VER_ID (PF2_PM_CAP_VER_ID),
    .PF2_RBAR_CAP_ENABLE (PF2_RBAR_CAP_ENABLE),
    .PF2_RBAR_CAP_NEXTPTR (PF2_RBAR_CAP_NEXTPTR),
    .PF2_RBAR_CAP_SIZE0 (PF2_RBAR_CAP_SIZE0),
    .PF2_RBAR_CAP_SIZE1 (PF2_RBAR_CAP_SIZE1),
    .PF2_RBAR_CAP_SIZE2 (PF2_RBAR_CAP_SIZE2),
    .PF2_RBAR_CAP_VER (PF2_RBAR_CAP_VER),
    .PF2_RBAR_CONTROL_INDEX0 (PF2_RBAR_CONTROL_INDEX0),
    .PF2_RBAR_CONTROL_INDEX1 (PF2_RBAR_CONTROL_INDEX1),
    .PF2_RBAR_CONTROL_INDEX2 (PF2_RBAR_CONTROL_INDEX2),
    .PF2_RBAR_CONTROL_SIZE0 (PF2_RBAR_CONTROL_SIZE0),
    .PF2_RBAR_CONTROL_SIZE1 (PF2_RBAR_CONTROL_SIZE1),
    .PF2_RBAR_CONTROL_SIZE2 (PF2_RBAR_CONTROL_SIZE2),
    .PF2_RBAR_NUM (PF2_RBAR_NUM),
    .PF2_REVISION_ID (PF2_REVISION_ID),
    .PF2_SRIOV_BAR0_APERTURE_SIZE (PF2_SRIOV_BAR0_APERTURE_SIZE),
    .PF2_SRIOV_BAR0_CONTROL (PF2_SRIOV_BAR0_CONTROL),
    .PF2_SRIOV_BAR1_APERTURE_SIZE (PF2_SRIOV_BAR1_APERTURE_SIZE),
    .PF2_SRIOV_BAR1_CONTROL (PF2_SRIOV_BAR1_CONTROL),
    .PF2_SRIOV_BAR2_APERTURE_SIZE (PF2_SRIOV_BAR2_APERTURE_SIZE),
    .PF2_SRIOV_BAR2_CONTROL (PF2_SRIOV_BAR2_CONTROL),
    .PF2_SRIOV_BAR3_APERTURE_SIZE (PF2_SRIOV_BAR3_APERTURE_SIZE),
    .PF2_SRIOV_BAR3_CONTROL (PF2_SRIOV_BAR3_CONTROL),
    .PF2_SRIOV_BAR4_APERTURE_SIZE (PF2_SRIOV_BAR4_APERTURE_SIZE),
    .PF2_SRIOV_BAR4_CONTROL (PF2_SRIOV_BAR4_CONTROL),
    .PF2_SRIOV_BAR5_APERTURE_SIZE (PF2_SRIOV_BAR5_APERTURE_SIZE),
    .PF2_SRIOV_BAR5_CONTROL (PF2_SRIOV_BAR5_CONTROL),
    .PF2_SRIOV_CAP_INITIAL_VF (PF2_SRIOV_CAP_INITIAL_VF),
    .PF2_SRIOV_CAP_NEXTPTR (PF2_SRIOV_CAP_NEXTPTR),
    .PF2_SRIOV_CAP_TOTAL_VF (PF2_SRIOV_CAP_TOTAL_VF),
    .PF2_SRIOV_CAP_VER (PF2_SRIOV_CAP_VER),
    .PF2_SRIOV_FIRST_VF_OFFSET (PF2_SRIOV_FIRST_VF_OFFSET),
    .PF2_SRIOV_FUNC_DEP_LINK (PF2_SRIOV_FUNC_DEP_LINK),
    .PF2_SRIOV_SUPPORTED_PAGE_SIZE (PF2_SRIOV_SUPPORTED_PAGE_SIZE),
    .PF2_SRIOV_VF_DEVICE_ID (PF2_SRIOV_VF_DEVICE_ID),
    .PF2_SUBSYSTEM_ID (PF2_SUBSYSTEM_ID),
    .PF2_TPHR_CAP_DEV_SPECIFIC_MODE (PF2_TPHR_CAP_DEV_SPECIFIC_MODE),
    .PF2_TPHR_CAP_ENABLE (PF2_TPHR_CAP_ENABLE),
    .PF2_TPHR_CAP_INT_VEC_MODE (PF2_TPHR_CAP_INT_VEC_MODE),
    .PF2_TPHR_CAP_NEXTPTR (PF2_TPHR_CAP_NEXTPTR),
    .PF2_TPHR_CAP_ST_MODE_SEL (PF2_TPHR_CAP_ST_MODE_SEL),
    .PF2_TPHR_CAP_ST_TABLE_LOC (PF2_TPHR_CAP_ST_TABLE_LOC),
    .PF2_TPHR_CAP_ST_TABLE_SIZE (PF2_TPHR_CAP_ST_TABLE_SIZE),
    .PF2_TPHR_CAP_VER (PF2_TPHR_CAP_VER),
    .PF3_AER_CAP_ECRC_CHECK_CAPABLE (PF3_AER_CAP_ECRC_CHECK_CAPABLE),
    .PF3_AER_CAP_ECRC_GEN_CAPABLE (PF3_AER_CAP_ECRC_GEN_CAPABLE),
    .PF3_AER_CAP_NEXTPTR (PF3_AER_CAP_NEXTPTR),
    .PF3_ARI_CAP_NEXT_FUNC (PF3_ARI_CAP_NEXT_FUNC),
    .PF3_ARI_CAP_NEXTPTR (PF3_ARI_CAP_NEXTPTR),
    .PF3_BAR0_APERTURE_SIZE (PF3_BAR0_APERTURE_SIZE),
    .PF3_BAR0_CONTROL (PF3_BAR0_CONTROL),
    .PF3_BAR1_APERTURE_SIZE (PF3_BAR1_APERTURE_SIZE),
    .PF3_BAR1_CONTROL (PF3_BAR1_CONTROL),
    .PF3_BAR2_APERTURE_SIZE (PF3_BAR2_APERTURE_SIZE),
    .PF3_BAR2_CONTROL (PF3_BAR2_CONTROL),
    .PF3_BAR3_APERTURE_SIZE (PF3_BAR3_APERTURE_SIZE),
    .PF3_BAR3_CONTROL (PF3_BAR3_CONTROL),
    .PF3_BAR4_APERTURE_SIZE (PF3_BAR4_APERTURE_SIZE),
    .PF3_BAR4_CONTROL (PF3_BAR4_CONTROL),
    .PF3_BAR5_APERTURE_SIZE (PF3_BAR5_APERTURE_SIZE),
    .PF3_BAR5_CONTROL (PF3_BAR5_CONTROL),
    .PF3_BIST_REGISTER (PF3_BIST_REGISTER),
    .PF3_CAPABILITY_POINTER (PF3_CAPABILITY_POINTER),
    .PF3_CLASS_CODE (PF3_CLASS_CODE),
    .PF3_DEV_CAP_MAX_PAYLOAD_SIZE (PF3_DEV_CAP_MAX_PAYLOAD_SIZE),
    .PF3_DEVICE_ID (PF3_DEVICE_ID),
    .PF3_DPA_CAP_NEXTPTR (PF3_DPA_CAP_NEXTPTR),
    .PF3_DPA_CAP_SUB_STATE_CONTROL (PF3_DPA_CAP_SUB_STATE_CONTROL),
    .PF3_DPA_CAP_SUB_STATE_CONTROL_EN (PF3_DPA_CAP_SUB_STATE_CONTROL_EN),
    .PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION0 (PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION0),
    .PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION1 (PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION1),
    .PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION2 (PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION2),
    .PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION3 (PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION3),
    .PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION4 (PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION4),
    .PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION5 (PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION5),
    .PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION6 (PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION6),
    .PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION7 (PF3_DPA_CAP_SUB_STATE_POWER_ALLOCATION7),
    .PF3_DPA_CAP_VER (PF3_DPA_CAP_VER),
    .PF3_DSN_CAP_NEXTPTR (PF3_DSN_CAP_NEXTPTR),
    .PF3_EXPANSION_ROM_APERTURE_SIZE (PF3_EXPANSION_ROM_APERTURE_SIZE),
    .PF3_EXPANSION_ROM_ENABLE (PF3_EXPANSION_ROM_ENABLE),
    .PF3_INTERRUPT_LINE (PF3_INTERRUPT_LINE),
    .PF3_INTERRUPT_PIN (PF3_INTERRUPT_PIN),
    .PF3_MSI_CAP_MULTIMSGCAP (PF3_MSI_CAP_MULTIMSGCAP),
    .PF3_MSI_CAP_NEXTPTR (PF3_MSI_CAP_NEXTPTR),
    .PF3_MSI_CAP_PERVECMASKCAP (PF3_MSI_CAP_PERVECMASKCAP),
    .PF3_MSIX_CAP_NEXTPTR (PF3_MSIX_CAP_NEXTPTR),
    .PF3_MSIX_CAP_PBA_BIR (PF3_MSIX_CAP_PBA_BIR),
    .PF3_MSIX_CAP_PBA_OFFSET ({3'b000,PF3_MSIX_CAP_PBA_OFFSET[28:3]}),
    .PF3_MSIX_CAP_TABLE_BIR (PF3_MSIX_CAP_TABLE_BIR),
    .PF3_MSIX_CAP_TABLE_OFFSET ({3'b000,PF3_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .PF3_MSIX_CAP_TABLE_SIZE (PF3_MSIX_CAP_TABLE_SIZE),
    .PF3_PB_CAP_DATA_REG_D0 (PF3_PB_CAP_DATA_REG_D0),
    .PF3_PB_CAP_DATA_REG_D0_SUSTAINED (PF3_PB_CAP_DATA_REG_D0_SUSTAINED),
    .PF3_PB_CAP_DATA_REG_D1 (PF3_PB_CAP_DATA_REG_D1),
    .PF3_PB_CAP_DATA_REG_D3HOT (PF3_PB_CAP_DATA_REG_D3HOT),
    .PF3_PB_CAP_NEXTPTR (PF3_PB_CAP_NEXTPTR),
    .PF3_PB_CAP_SYSTEM_ALLOCATED (PF3_PB_CAP_SYSTEM_ALLOCATED),
    .PF3_PB_CAP_VER (PF3_PB_CAP_VER),
    .PF3_PM_CAP_ID (PF3_PM_CAP_ID),
    .PF3_PM_CAP_NEXTPTR (PF3_PM_CAP_NEXTPTR),
    .PF3_PM_CAP_VER_ID (PF3_PM_CAP_VER_ID),
    .PF3_RBAR_CAP_ENABLE (PF3_RBAR_CAP_ENABLE),
    .PF3_RBAR_CAP_NEXTPTR (PF3_RBAR_CAP_NEXTPTR),
    .PF3_RBAR_CAP_SIZE0 (PF3_RBAR_CAP_SIZE0),
    .PF3_RBAR_CAP_SIZE1 (PF3_RBAR_CAP_SIZE1),
    .PF3_RBAR_CAP_SIZE2 (PF3_RBAR_CAP_SIZE2),
    .PF3_RBAR_CAP_VER (PF3_RBAR_CAP_VER),
    .PF3_RBAR_CONTROL_INDEX0 (PF3_RBAR_CONTROL_INDEX0),
    .PF3_RBAR_CONTROL_INDEX1 (PF3_RBAR_CONTROL_INDEX1),
    .PF3_RBAR_CONTROL_INDEX2 (PF3_RBAR_CONTROL_INDEX2),
    .PF3_RBAR_CONTROL_SIZE0 (PF3_RBAR_CONTROL_SIZE0),
    .PF3_RBAR_CONTROL_SIZE1 (PF3_RBAR_CONTROL_SIZE1),
    .PF3_RBAR_CONTROL_SIZE2 (PF3_RBAR_CONTROL_SIZE2),
    .PF3_RBAR_NUM (PF3_RBAR_NUM),
    .PF3_REVISION_ID (PF3_REVISION_ID),
    .PF3_SRIOV_BAR0_APERTURE_SIZE (PF3_SRIOV_BAR0_APERTURE_SIZE),
    .PF3_SRIOV_BAR0_CONTROL (PF3_SRIOV_BAR0_CONTROL),
    .PF3_SRIOV_BAR1_APERTURE_SIZE (PF3_SRIOV_BAR1_APERTURE_SIZE),
    .PF3_SRIOV_BAR1_CONTROL (PF3_SRIOV_BAR1_CONTROL),
    .PF3_SRIOV_BAR2_APERTURE_SIZE (PF3_SRIOV_BAR2_APERTURE_SIZE),
    .PF3_SRIOV_BAR2_CONTROL (PF3_SRIOV_BAR2_CONTROL),
    .PF3_SRIOV_BAR3_APERTURE_SIZE (PF3_SRIOV_BAR3_APERTURE_SIZE),
    .PF3_SRIOV_BAR3_CONTROL (PF3_SRIOV_BAR3_CONTROL),
    .PF3_SRIOV_BAR4_APERTURE_SIZE (PF3_SRIOV_BAR4_APERTURE_SIZE),
    .PF3_SRIOV_BAR4_CONTROL (PF3_SRIOV_BAR4_CONTROL),
    .PF3_SRIOV_BAR5_APERTURE_SIZE (PF3_SRIOV_BAR5_APERTURE_SIZE),
    .PF3_SRIOV_BAR5_CONTROL (PF3_SRIOV_BAR5_CONTROL),
    .PF3_SRIOV_CAP_INITIAL_VF (PF3_SRIOV_CAP_INITIAL_VF),
    .PF3_SRIOV_CAP_NEXTPTR (PF3_SRIOV_CAP_NEXTPTR),
    .PF3_SRIOV_CAP_TOTAL_VF (PF3_SRIOV_CAP_TOTAL_VF),
    .PF3_SRIOV_CAP_VER (PF3_SRIOV_CAP_VER),
    .PF3_SRIOV_FIRST_VF_OFFSET (PF3_SRIOV_FIRST_VF_OFFSET),
    .PF3_SRIOV_FUNC_DEP_LINK (PF3_SRIOV_FUNC_DEP_LINK),
    .PF3_SRIOV_SUPPORTED_PAGE_SIZE (PF3_SRIOV_SUPPORTED_PAGE_SIZE),
    .PF3_SRIOV_VF_DEVICE_ID (PF3_SRIOV_VF_DEVICE_ID),
    .PF3_SUBSYSTEM_ID (PF3_SUBSYSTEM_ID),
    .PF3_TPHR_CAP_DEV_SPECIFIC_MODE (PF3_TPHR_CAP_DEV_SPECIFIC_MODE),
    .PF3_TPHR_CAP_ENABLE (PF3_TPHR_CAP_ENABLE),
    .PF3_TPHR_CAP_INT_VEC_MODE (PF3_TPHR_CAP_INT_VEC_MODE),
    .PF3_TPHR_CAP_NEXTPTR (PF3_TPHR_CAP_NEXTPTR),
    .PF3_TPHR_CAP_ST_MODE_SEL (PF3_TPHR_CAP_ST_MODE_SEL),
    .PF3_TPHR_CAP_ST_TABLE_LOC (PF3_TPHR_CAP_ST_TABLE_LOC),
    .PF3_TPHR_CAP_ST_TABLE_SIZE (PF3_TPHR_CAP_ST_TABLE_SIZE),
    .PF3_TPHR_CAP_VER (PF3_TPHR_CAP_VER),
    .PL_DISABLE_AUTO_EQ_SPEED_CHANGE_TO_GEN3 (PL_DISABLE_AUTO_EQ_SPEED_CHANGE_TO_GEN3),
    .PL_DISABLE_AUTO_SPEED_CHANGE_TO_GEN2 (PL_DISABLE_AUTO_SPEED_CHANGE_TO_GEN2),
    .PL_DISABLE_EI_INFER_IN_L0 (PL_DISABLE_EI_INFER_IN_L0),
    .PL_DISABLE_GEN3_DC_BALANCE (PL_DISABLE_GEN3_DC_BALANCE),
    .PL_DISABLE_GEN3_LFSR_UPDATE_ON_SKP (PL_DISABLE_GEN3_LFSR_UPDATE_ON_SKP),
    .PL_DISABLE_RETRAIN_ON_FRAMING_ERROR (PL_DISABLE_RETRAIN_ON_FRAMING_ERROR),
    .PL_DISABLE_SCRAMBLING (PL_DISABLE_SCRAMBLING),
    .PL_DISABLE_SYNC_HEADER_FRAMING_ERROR (PL_DISABLE_SYNC_HEADER_FRAMING_ERROR),
    .PL_DISABLE_UPCONFIG_CAPABLE (PL_DISABLE_UPCONFIG_CAPABLE),
    .PL_EQ_ADAPT_DISABLE_COEFF_CHECK (PL_EQ_ADAPT_DISABLE_COEFF_CHECK),
    .PL_EQ_ADAPT_DISABLE_PRESET_CHECK (PL_EQ_ADAPT_DISABLE_PRESET_CHECK),
    .PL_EQ_ADAPT_ITER_COUNT (PL_EQ_ADAPT_ITER_COUNT),
    .PL_EQ_ADAPT_REJECT_RETRY_COUNT (PL_EQ_ADAPT_REJECT_RETRY_COUNT),
    .PL_EQ_BYPASS_PHASE23 (PL_EQ_BYPASS_PHASE23),
    .PL_EQ_DEFAULT_GEN3_RX_PRESET_HINT (PL_EQ_DEFAULT_GEN3_RX_PRESET_HINT),
    .PL_EQ_DEFAULT_GEN3_TX_PRESET (PL_EQ_DEFAULT_GEN3_TX_PRESET),
    .PL_EQ_PHASE01_RX_ADAPT (PL_EQ_PHASE01_RX_ADAPT),
    .PL_EQ_SHORT_ADAPT_PHASE (PL_EQ_SHORT_ADAPT_PHASE),
    .PL_LANE0_EQ_CONTROL (PL_LANE0_EQ_CONTROL),
    .PL_LANE1_EQ_CONTROL (PL_LANE1_EQ_CONTROL),
    .PL_LANE2_EQ_CONTROL (PL_LANE2_EQ_CONTROL),
    .PL_LANE3_EQ_CONTROL (PL_LANE3_EQ_CONTROL),
    .PL_LANE4_EQ_CONTROL (PL_LANE4_EQ_CONTROL),
    .PL_LANE5_EQ_CONTROL (PL_LANE5_EQ_CONTROL),
    .PL_LANE6_EQ_CONTROL (PL_LANE6_EQ_CONTROL),
    .PL_LANE7_EQ_CONTROL (PL_LANE7_EQ_CONTROL),
    .PL_LINK_CAP_MAX_LINK_SPEED (PL_LINK_CAP_MAX_LINK_SPEED),
    .PL_LINK_CAP_MAX_LINK_WIDTH (PL_LINK_CAP_MAX_LINK_WIDTH),
    .PL_N_FTS_COMCLK_GEN1 (PL_N_FTS_COMCLK_GEN1),
    .PL_N_FTS_COMCLK_GEN2 (PL_N_FTS_COMCLK_GEN2),
    .PL_N_FTS_COMCLK_GEN3 (PL_N_FTS_COMCLK_GEN3),
    .PL_N_FTS_GEN1 (PL_N_FTS_GEN1),
    .PL_N_FTS_GEN2 (PL_N_FTS_GEN2),
    .PL_N_FTS_GEN3 (PL_N_FTS_GEN3),
    .PL_REPORT_ALL_PHY_ERRORS (PL_REPORT_ALL_PHY_ERRORS),
  // synthesis translate_off
    .PL_SIM_FAST_LINK_TRAINING (PL_SIM_FAST_LINK_TRAINING),
  // synthesis translate_on
    .PL_UPSTREAM_FACING (PL_UPSTREAM_FACING),
    .PM_ASPML0S_TIMEOUT (PM_ASPML0S_TIMEOUT),
    .PM_ASPML1_ENTRY_DELAY (PM_ASPML1_ENTRY_DELAY),
    .PM_ENABLE_L23_ENTRY (PM_ENABLE_L23_ENTRY),
    .PM_ENABLE_SLOT_POWER_CAPTURE (PM_ENABLE_SLOT_POWER_CAPTURE),
    .PM_L1_REENTRY_DELAY (PM_L1_REENTRY_DELAY),
    .PM_PME_SERVICE_TIMEOUT_DELAY (PM_PME_SERVICE_TIMEOUT_DELAY),
    .PM_PME_TURNOFF_ACK_DELAY (PM_PME_TURNOFF_ACK_DELAY),
    .SIM_JTAG_IDCODE (SIM_JTAG_IDCODE),
    .SIM_VERSION (SIM_VERSION),
    .SPARE_BIT0 (SPARE_BIT0),
    .SPARE_BIT1 (SPARE_BIT1),
    .SPARE_BIT2 (SPARE_BIT2),
    .SPARE_BIT3 (SPARE_BIT3),
    .SPARE_BIT4 (SPARE_BIT4),
    .SPARE_BIT5 (SPARE_BIT5),
    .SPARE_BIT6 (SPARE_BIT6),
    .SPARE_BIT7 (SPARE_BIT7),
    .SPARE_BIT8 (SPARE_BIT8),
    .SPARE_BYTE0 (SPARE_BYTE0),
    .SPARE_BYTE1 (SPARE_BYTE1),
    .SPARE_BYTE2 (SPARE_BYTE2),
    .SPARE_BYTE3 (SPARE_BYTE3),
    .SPARE_WORD0 (SPARE_WORD0),
    .SPARE_WORD1 (SPARE_WORD1),
    .SPARE_WORD2 (SPARE_WORD2),
    .SPARE_WORD3 (SPARE_WORD3),
    .SRIOV_CAP_ENABLE (SRIOV_CAP_ENABLE),
    .TL_COMPL_TIMEOUT_REG0 (TL_COMPL_TIMEOUT_REG0),
    .TL_COMPL_TIMEOUT_REG1 (TL_COMPL_TIMEOUT_REG1),
    .TL_CREDITS_CD (TL_CREDITS_CD),
    .TL_CREDITS_CH (TL_CREDITS_CH),
    .TL_CREDITS_NPD (TL_CREDITS_NPD),
    .TL_CREDITS_NPH (TL_CREDITS_NPH),
    .TL_CREDITS_PD (TL_CREDITS_PD),
    .TL_CREDITS_PH (TL_CREDITS_PH),
    .TL_ENABLE_MESSAGE_RID_CHECK_ENABLE (TL_ENABLE_MESSAGE_RID_CHECK_ENABLE),
    .TL_EXTENDED_CFG_EXTEND_INTERFACE_ENABLE (TL_EXTENDED_CFG_EXTEND_INTERFACE_ENABLE),
    .TL_LEGACY_CFG_EXTEND_INTERFACE_ENABLE (TL_LEGACY_CFG_EXTEND_INTERFACE_ENABLE),
    .TL_LEGACY_MODE_ENABLE (TL_LEGACY_MODE_ENABLE),
    .TL_PF_ENABLE_REG (TL_PF_ENABLE_REG),
    .TL_TX_MUX_STRICT_PRIORITY (TL_TX_MUX_STRICT_PRIORITY),
    .TWO_LAYER_MODE_DLCMSM_ENABLE (TWO_LAYER_MODE_DLCMSM_ENABLE),
    .TWO_LAYER_MODE_ENABLE (TWO_LAYER_MODE_ENABLE),
    .TWO_LAYER_MODE_WIDTH_256 (TWO_LAYER_MODE_WIDTH_256),
    .VF0_ARI_CAP_NEXTPTR (VF0_ARI_CAP_NEXTPTR),
    .VF0_CAPABILITY_POINTER (VF0_CAPABILITY_POINTER),
    .VF0_MSI_CAP_MULTIMSGCAP (VF0_MSI_CAP_MULTIMSGCAP),
    .VF0_MSIX_CAP_PBA_BIR (VF0_MSIX_CAP_PBA_BIR),
    .VF0_MSIX_CAP_PBA_OFFSET ({3'b000,VF0_MSIX_CAP_PBA_OFFSET[28:3]}),
    .VF0_MSIX_CAP_TABLE_BIR (VF0_MSIX_CAP_TABLE_BIR),
    .VF0_MSIX_CAP_TABLE_OFFSET ({3'b000,VF0_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .VF0_MSIX_CAP_TABLE_SIZE (VF0_MSIX_CAP_TABLE_SIZE),
    .VF0_PM_CAP_ID (VF0_PM_CAP_ID),
    .VF0_PM_CAP_NEXTPTR (VF0_PM_CAP_NEXTPTR),
    .VF0_PM_CAP_VER_ID (VF0_PM_CAP_VER_ID),
    .VF0_TPHR_CAP_DEV_SPECIFIC_MODE (VF0_TPHR_CAP_DEV_SPECIFIC_MODE),
    .VF0_TPHR_CAP_ENABLE (VF0_TPHR_CAP_ENABLE),
    .VF0_TPHR_CAP_INT_VEC_MODE (VF0_TPHR_CAP_INT_VEC_MODE),
    .VF0_TPHR_CAP_NEXTPTR (VF0_TPHR_CAP_NEXTPTR),
    .VF0_TPHR_CAP_ST_MODE_SEL (VF0_TPHR_CAP_ST_MODE_SEL),
    .VF0_TPHR_CAP_ST_TABLE_LOC (VF0_TPHR_CAP_ST_TABLE_LOC),
    .VF0_TPHR_CAP_ST_TABLE_SIZE (VF0_TPHR_CAP_ST_TABLE_SIZE),
    .VF0_TPHR_CAP_VER (VF0_TPHR_CAP_VER),
    .VF1_ARI_CAP_NEXTPTR (VF1_ARI_CAP_NEXTPTR),
    .VF1_MSI_CAP_MULTIMSGCAP (VF1_MSI_CAP_MULTIMSGCAP),
    .VF1_MSIX_CAP_PBA_BIR (VF1_MSIX_CAP_PBA_BIR),
    .VF1_MSIX_CAP_PBA_OFFSET ({3'b000,VF1_MSIX_CAP_PBA_OFFSET[28:3]}),
    .VF1_MSIX_CAP_TABLE_BIR (VF1_MSIX_CAP_TABLE_BIR),
    .VF1_MSIX_CAP_TABLE_OFFSET ({3'b000,VF1_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .VF1_MSIX_CAP_TABLE_SIZE (VF1_MSIX_CAP_TABLE_SIZE),
    .VF1_PM_CAP_ID (VF1_PM_CAP_ID),
    .VF1_PM_CAP_NEXTPTR (VF1_PM_CAP_NEXTPTR),
    .VF1_PM_CAP_VER_ID (VF1_PM_CAP_VER_ID),
    .VF1_TPHR_CAP_DEV_SPECIFIC_MODE (VF1_TPHR_CAP_DEV_SPECIFIC_MODE),
    .VF1_TPHR_CAP_ENABLE (VF1_TPHR_CAP_ENABLE),
    .VF1_TPHR_CAP_INT_VEC_MODE (VF1_TPHR_CAP_INT_VEC_MODE),
    .VF1_TPHR_CAP_NEXTPTR (VF1_TPHR_CAP_NEXTPTR),
    .VF1_TPHR_CAP_ST_MODE_SEL (VF1_TPHR_CAP_ST_MODE_SEL),
    .VF1_TPHR_CAP_ST_TABLE_LOC (VF1_TPHR_CAP_ST_TABLE_LOC),
    .VF1_TPHR_CAP_ST_TABLE_SIZE (VF1_TPHR_CAP_ST_TABLE_SIZE),
    .VF1_TPHR_CAP_VER (VF1_TPHR_CAP_VER),
    .VF2_ARI_CAP_NEXTPTR (VF2_ARI_CAP_NEXTPTR),
    .VF2_MSI_CAP_MULTIMSGCAP (VF2_MSI_CAP_MULTIMSGCAP),
    .VF2_MSIX_CAP_PBA_BIR (VF2_MSIX_CAP_PBA_BIR),
    .VF2_MSIX_CAP_PBA_OFFSET ({3'b000,VF2_MSIX_CAP_PBA_OFFSET[28:3]}),
    .VF2_MSIX_CAP_TABLE_BIR (VF2_MSIX_CAP_TABLE_BIR),
    .VF2_MSIX_CAP_TABLE_OFFSET ({3'b000,VF2_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .VF2_MSIX_CAP_TABLE_SIZE (VF2_MSIX_CAP_TABLE_SIZE),
    .VF2_PM_CAP_ID (VF2_PM_CAP_ID),
    .VF2_PM_CAP_NEXTPTR (VF2_PM_CAP_NEXTPTR),
    .VF2_PM_CAP_VER_ID (VF2_PM_CAP_VER_ID),
    .VF2_TPHR_CAP_DEV_SPECIFIC_MODE (VF2_TPHR_CAP_DEV_SPECIFIC_MODE),
    .VF2_TPHR_CAP_ENABLE (VF2_TPHR_CAP_ENABLE),
    .VF2_TPHR_CAP_INT_VEC_MODE (VF2_TPHR_CAP_INT_VEC_MODE),
    .VF2_TPHR_CAP_NEXTPTR (VF2_TPHR_CAP_NEXTPTR),
    .VF2_TPHR_CAP_ST_MODE_SEL (VF2_TPHR_CAP_ST_MODE_SEL),
    .VF2_TPHR_CAP_ST_TABLE_LOC (VF2_TPHR_CAP_ST_TABLE_LOC),
    .VF2_TPHR_CAP_ST_TABLE_SIZE (VF2_TPHR_CAP_ST_TABLE_SIZE),
    .VF2_TPHR_CAP_VER (VF2_TPHR_CAP_VER),
    .VF3_ARI_CAP_NEXTPTR (VF3_ARI_CAP_NEXTPTR),
    .VF3_MSI_CAP_MULTIMSGCAP (VF3_MSI_CAP_MULTIMSGCAP),
    .VF3_MSIX_CAP_PBA_BIR (VF3_MSIX_CAP_PBA_BIR),
    .VF3_MSIX_CAP_PBA_OFFSET ({3'b000,VF3_MSIX_CAP_PBA_OFFSET[28:3]}),
    .VF3_MSIX_CAP_TABLE_BIR (VF3_MSIX_CAP_TABLE_BIR),
    .VF3_MSIX_CAP_TABLE_OFFSET ({3'b000,VF3_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .VF3_MSIX_CAP_TABLE_SIZE (VF3_MSIX_CAP_TABLE_SIZE),
    .VF3_PM_CAP_ID (VF3_PM_CAP_ID),
    .VF3_PM_CAP_NEXTPTR (VF3_PM_CAP_NEXTPTR),
    .VF3_PM_CAP_VER_ID (VF3_PM_CAP_VER_ID),
    .VF3_TPHR_CAP_DEV_SPECIFIC_MODE (VF3_TPHR_CAP_DEV_SPECIFIC_MODE),
    .VF3_TPHR_CAP_ENABLE (VF3_TPHR_CAP_ENABLE),
    .VF3_TPHR_CAP_INT_VEC_MODE (VF3_TPHR_CAP_INT_VEC_MODE),
    .VF3_TPHR_CAP_NEXTPTR (VF3_TPHR_CAP_NEXTPTR),
    .VF3_TPHR_CAP_ST_MODE_SEL (VF3_TPHR_CAP_ST_MODE_SEL),
    .VF3_TPHR_CAP_ST_TABLE_LOC (VF3_TPHR_CAP_ST_TABLE_LOC),
    .VF3_TPHR_CAP_ST_TABLE_SIZE (VF3_TPHR_CAP_ST_TABLE_SIZE),
    .VF3_TPHR_CAP_VER (VF3_TPHR_CAP_VER),
    .VF4_ARI_CAP_NEXTPTR (VF4_ARI_CAP_NEXTPTR),
    .VF4_MSI_CAP_MULTIMSGCAP (VF4_MSI_CAP_MULTIMSGCAP),
    .VF4_MSIX_CAP_PBA_BIR (VF4_MSIX_CAP_PBA_BIR),
    .VF4_MSIX_CAP_PBA_OFFSET ({3'b000,VF4_MSIX_CAP_PBA_OFFSET[28:3]}),
    .VF4_MSIX_CAP_TABLE_BIR (VF4_MSIX_CAP_TABLE_BIR),
    .VF4_MSIX_CAP_TABLE_OFFSET ({3'b000,VF4_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .VF4_MSIX_CAP_TABLE_SIZE (VF4_MSIX_CAP_TABLE_SIZE),
    .VF4_PM_CAP_ID (VF4_PM_CAP_ID),
    .VF4_PM_CAP_NEXTPTR (VF4_PM_CAP_NEXTPTR),
    .VF4_PM_CAP_VER_ID (VF4_PM_CAP_VER_ID),
    .VF4_TPHR_CAP_DEV_SPECIFIC_MODE (VF4_TPHR_CAP_DEV_SPECIFIC_MODE),
    .VF4_TPHR_CAP_ENABLE (VF4_TPHR_CAP_ENABLE),
    .VF4_TPHR_CAP_INT_VEC_MODE (VF4_TPHR_CAP_INT_VEC_MODE),
    .VF4_TPHR_CAP_NEXTPTR (VF4_TPHR_CAP_NEXTPTR),
    .VF4_TPHR_CAP_ST_MODE_SEL (VF4_TPHR_CAP_ST_MODE_SEL),
    .VF4_TPHR_CAP_ST_TABLE_LOC (VF4_TPHR_CAP_ST_TABLE_LOC),
    .VF4_TPHR_CAP_ST_TABLE_SIZE (VF4_TPHR_CAP_ST_TABLE_SIZE),
    .VF4_TPHR_CAP_VER (VF4_TPHR_CAP_VER),
    .VF5_ARI_CAP_NEXTPTR (VF5_ARI_CAP_NEXTPTR),
    .VF5_MSI_CAP_MULTIMSGCAP (VF5_MSI_CAP_MULTIMSGCAP),
    .VF5_MSIX_CAP_PBA_BIR (VF5_MSIX_CAP_PBA_BIR),
    .VF5_MSIX_CAP_PBA_OFFSET ({3'b000,VF5_MSIX_CAP_PBA_OFFSET[28:3]}),
    .VF5_MSIX_CAP_TABLE_BIR (VF5_MSIX_CAP_TABLE_BIR),
    .VF5_MSIX_CAP_TABLE_OFFSET ({3'b000,VF5_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .VF5_MSIX_CAP_TABLE_SIZE (VF5_MSIX_CAP_TABLE_SIZE),
    .VF5_PM_CAP_ID (VF5_PM_CAP_ID),
    .VF5_PM_CAP_NEXTPTR (VF5_PM_CAP_NEXTPTR),
    .VF5_PM_CAP_VER_ID (VF5_PM_CAP_VER_ID),
    .VF5_TPHR_CAP_DEV_SPECIFIC_MODE (VF5_TPHR_CAP_DEV_SPECIFIC_MODE),
    .VF5_TPHR_CAP_ENABLE (VF5_TPHR_CAP_ENABLE),
    .VF5_TPHR_CAP_INT_VEC_MODE (VF5_TPHR_CAP_INT_VEC_MODE),
    .VF5_TPHR_CAP_NEXTPTR (VF5_TPHR_CAP_NEXTPTR),
    .VF5_TPHR_CAP_ST_MODE_SEL (VF5_TPHR_CAP_ST_MODE_SEL),
    .VF5_TPHR_CAP_ST_TABLE_LOC (VF5_TPHR_CAP_ST_TABLE_LOC),
    .VF5_TPHR_CAP_ST_TABLE_SIZE (VF5_TPHR_CAP_ST_TABLE_SIZE),
    .VF5_TPHR_CAP_VER (VF5_TPHR_CAP_VER),
    .VF6_ARI_CAP_NEXTPTR (VF6_ARI_CAP_NEXTPTR),
    .VF6_MSI_CAP_MULTIMSGCAP (VF6_MSI_CAP_MULTIMSGCAP),
    .VF6_MSIX_CAP_PBA_BIR (VF6_MSIX_CAP_PBA_BIR),
    .VF6_MSIX_CAP_PBA_OFFSET ({3'b000,VF6_MSIX_CAP_PBA_OFFSET[28:3]}),
    .VF6_MSIX_CAP_TABLE_BIR (VF6_MSIX_CAP_TABLE_BIR),
    .VF6_MSIX_CAP_TABLE_OFFSET ({3'b000,VF6_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .VF6_MSIX_CAP_TABLE_SIZE (VF6_MSIX_CAP_TABLE_SIZE),
    .VF6_PM_CAP_ID (VF6_PM_CAP_ID),
    .VF6_PM_CAP_NEXTPTR (VF6_PM_CAP_NEXTPTR),
    .VF6_PM_CAP_VER_ID (VF6_PM_CAP_VER_ID),
    .VF6_TPHR_CAP_DEV_SPECIFIC_MODE (VF6_TPHR_CAP_DEV_SPECIFIC_MODE),
    .VF6_TPHR_CAP_ENABLE (VF6_TPHR_CAP_ENABLE),
    .VF6_TPHR_CAP_INT_VEC_MODE (VF6_TPHR_CAP_INT_VEC_MODE),
    .VF6_TPHR_CAP_NEXTPTR (VF6_TPHR_CAP_NEXTPTR),
    .VF6_TPHR_CAP_ST_MODE_SEL (VF6_TPHR_CAP_ST_MODE_SEL),
    .VF6_TPHR_CAP_ST_TABLE_LOC (VF6_TPHR_CAP_ST_TABLE_LOC),
    .VF6_TPHR_CAP_ST_TABLE_SIZE (VF6_TPHR_CAP_ST_TABLE_SIZE),
    .VF6_TPHR_CAP_VER (VF6_TPHR_CAP_VER),
    .VF7_ARI_CAP_NEXTPTR (VF7_ARI_CAP_NEXTPTR),
    .VF7_MSI_CAP_MULTIMSGCAP (VF7_MSI_CAP_MULTIMSGCAP),
    .VF7_MSIX_CAP_PBA_BIR (VF7_MSIX_CAP_PBA_BIR),
    .VF7_MSIX_CAP_PBA_OFFSET ({3'b000,VF7_MSIX_CAP_PBA_OFFSET[28:3]}),
    .VF7_MSIX_CAP_TABLE_BIR (VF7_MSIX_CAP_TABLE_BIR),
    .VF7_MSIX_CAP_TABLE_OFFSET ({3'b000,VF7_MSIX_CAP_TABLE_OFFSET[28:3]}),
    .VF7_MSIX_CAP_TABLE_SIZE (VF7_MSIX_CAP_TABLE_SIZE),
    .VF7_PM_CAP_ID (VF7_PM_CAP_ID),
    .VF7_PM_CAP_NEXTPTR (VF7_PM_CAP_NEXTPTR),
    .VF7_PM_CAP_VER_ID (VF7_PM_CAP_VER_ID),
    .VF7_TPHR_CAP_DEV_SPECIFIC_MODE (VF7_TPHR_CAP_DEV_SPECIFIC_MODE),
    .VF7_TPHR_CAP_ENABLE (VF7_TPHR_CAP_ENABLE),
    .VF7_TPHR_CAP_INT_VEC_MODE (VF7_TPHR_CAP_INT_VEC_MODE),
    .VF7_TPHR_CAP_NEXTPTR (VF7_TPHR_CAP_NEXTPTR),
    .VF7_TPHR_CAP_ST_MODE_SEL (VF7_TPHR_CAP_ST_MODE_SEL),
    .VF7_TPHR_CAP_ST_TABLE_LOC (VF7_TPHR_CAP_ST_TABLE_LOC),
    .VF7_TPHR_CAP_ST_TABLE_SIZE (VF7_TPHR_CAP_ST_TABLE_SIZE),
    .VF7_TPHR_CAP_VER (VF7_TPHR_CAP_VER))
  pcie3_uscale_top_inst (
    .s_axis_rq_tdata (s_axis_rq_tdata),
    .s_axis_rq_tkeep (s_axis_rq_tkeep),
    .s_axis_rq_tlast (s_axis_rq_tlast),
    .s_axis_rq_tready (s_axis_rq_tready_wire),
    .s_axis_rq_tuser (s_axis_rq_tuser),
    .s_axis_rq_tvalid (s_axis_rq_tvalid_mux),
    .m_axis_rc_tdata (m_axis_rc_tdata),
    .m_axis_rc_tkeep (m_axis_rc_tkeep),
    .m_axis_rc_tlast (m_axis_rc_tlast),
    .m_axis_rc_tready (m_axis_rc_tready_mux),
    .m_axis_rc_tuser (m_axis_rc_tuser),
    .m_axis_rc_tvalid (m_axis_rc_tvalid_wire),
    .m_axis_cq_tdata (m_axis_cq_tdata),
    .m_axis_cq_tkeep (m_axis_cq_tkeep),
    .m_axis_cq_tlast (m_axis_cq_tlast),
    .m_axis_cq_tready (m_axis_cq_tready_mux),
    .m_axis_cq_tuser (m_axis_cq_tuser),
    .m_axis_cq_tvalid (m_axis_cq_tvalid_wire),
    .s_axis_cc_tdata (s_axis_cc_tdata),
    .s_axis_cc_tkeep (s_axis_cc_tkeep),
    .s_axis_cc_tlast (s_axis_cc_tlast),
    .s_axis_cc_tready (s_axis_cc_tready_wire),
    .s_axis_cc_tuser (s_axis_cc_tuser),
    .s_axis_cc_tvalid (s_axis_cc_tvalid_mux),
    .pcie_rq_seq_num (pcie_rq_seq_num),
    .pcie_rq_seq_num_vld (pcie_rq_seq_num_vld),
    .pcie_rq_tag (pcie_rq_tag),
    .pcie_rq_tag_av (pcie_rq_tag_av),
    .pcie_rq_tag_vld (pcie_rq_tag_vld),
    .pcie_tfc_npd_av (pcie_tfc_npd_av),
    .pcie_tfc_nph_av (pcie_tfc_nph_av),
    .pcie_cq_np_req (pcie_cq_np_req_mux),
    .pcie_cq_np_req_count (pcie_cq_np_req_count),
    .cfg_mgmt_addr (cfg_mgmt_addr),
    .cfg_mgmt_byte_enable (cfg_mgmt_byte_enable),
    .cfg_mgmt_read (cfg_mgmt_read),
    .cfg_mgmt_read_data (cfg_mgmt_read_data),
    .cfg_mgmt_read_write_done (cfg_mgmt_read_write_done),
    .cfg_mgmt_type1_cfg_reg_access (cfg_mgmt_type1_cfg_reg_access),
    .cfg_mgmt_write (cfg_mgmt_write_mux),
    .cfg_mgmt_write_data (cfg_mgmt_write_data),
    .cfg_phy_link_down (cfg_phy_link_down),
    .cfg_phy_link_status (cfg_phy_link_status),
    .cfg_negotiated_width (cfg_negotiated_width),
    .cfg_current_speed (cfg_current_speed),
    .cfg_max_payload (cfg_max_payload),
    .cfg_max_read_req (cfg_max_read_req),
    .cfg_function_status (cfg_function_status),
    .cfg_function_power_state (cfg_function_power_state),
    .cfg_vf_status (cfg_vf_status),
    .cfg_vf_power_state (cfg_vf_power_state),
    .cfg_link_power_state (cfg_link_power_state),
    .cfg_err_cor_out (cfg_err_cor_out),
    .cfg_err_nonfatal_out (cfg_err_nonfatal_out),
    .cfg_err_fatal_out (cfg_err_fatal_out),
    .cfg_local_error (cfg_local_error),
    .cfg_ltr_enable (cfg_ltr_enable),
    .cfg_ltssm_state (cfg_ltssm_state),
    .cfg_rcb_status (cfg_rcb_status),
    .cfg_dpa_substate_change (cfg_dpa_substate_change),
    .cfg_obff_enable (cfg_obff_enable),
    .cfg_pl_status_change (cfg_pl_status_change),
    .cfg_tph_requester_enable (cfg_tph_requester_enable),
    .cfg_tph_st_mode (cfg_tph_st_mode),
    .cfg_vf_tph_requester_enable (cfg_vf_tph_requester_enable),
    .cfg_vf_tph_st_mode (cfg_vf_tph_st_mode),
    .cfg_msg_received (cfg_msg_received),
    .cfg_msg_received_data (cfg_msg_received_data),
    .cfg_msg_received_type (cfg_msg_received_type),
    .cfg_msg_transmit (cfg_msg_transmit_mux),
    .cfg_msg_transmit_type (cfg_msg_transmit_type),
    .cfg_msg_transmit_data (cfg_msg_transmit_data),
    .cfg_msg_transmit_done (cfg_msg_transmit_done),
    .cfg_fc_ph (cfg_fc_ph),
    .cfg_fc_pd (cfg_fc_pd),
    .cfg_fc_nph (cfg_fc_nph),
    .cfg_fc_npd (cfg_fc_npd),
    .cfg_fc_cplh (cfg_fc_cplh),
    .cfg_fc_cpld (cfg_fc_cpld),
    .cfg_fc_sel (cfg_fc_sel),
    .cfg_per_func_status_control (cfg_per_func_status_control),
    .cfg_per_func_status_data (cfg_per_func_status_data),
    .cfg_per_function_number (cfg_per_function_number),
    .cfg_per_function_output_request (cfg_per_function_output_request),
    .cfg_per_function_update_done (cfg_per_function_update_done),
    .cfg_power_state_change_ack (cfg_power_state_change_ack_mux),
    .cfg_power_state_change_interrupt (cfg_power_state_change_interrupt),
    .cfg_err_cor_in (cfg_err_cor_in_mux),
    .cfg_err_uncor_in (cfg_err_uncor_in_mux),
    .cfg_flr_in_process (cfg_flr_in_process),
    .cfg_flr_done (cfg_flr_done_mux),
    .cfg_vf_flr_in_process (cfg_vf_flr_in_process),
    .cfg_vf_flr_done (cfg_vf_flr_done_mux),
    .cfg_link_training_enable (cfg_link_training_enable_mux),
    .cfg_interrupt_int (cfg_interrupt_int_mux),
    .cfg_interrupt_pending (cfg_interrupt_pending),
    .cfg_interrupt_sent (cfg_interrupt_sent),
    .cfg_interrupt_msi_enable (cfg_interrupt_msi_enable),
    .cfg_interrupt_msi_vf_enable (cfg_interrupt_msi_vf_enable),
    .cfg_interrupt_msi_mmenable (cfg_interrupt_msi_mmenable),
    .cfg_interrupt_msi_mask_update (cfg_interrupt_msi_mask_update),
    .cfg_interrupt_msi_data (cfg_interrupt_msi_data),
    .cfg_interrupt_msi_select (cfg_interrupt_msi_select),
    .cfg_interrupt_msi_int (cfg_interrupt_msi_int_mux),
    .cfg_interrupt_msi_pending_status (cfg_interrupt_msi_pending_status),
    .cfg_interrupt_msi_pending_status_data_enable (cfg_interrupt_msi_pending_status_data_enable_mux),
    .cfg_interrupt_msi_pending_status_function_num (cfg_interrupt_msi_pending_status_function_num),
    .cfg_interrupt_msi_sent (cfg_interrupt_msi_sent),
    .cfg_interrupt_msi_fail (cfg_interrupt_msi_fail),
    .cfg_interrupt_msix_enable (cfg_interrupt_msix_enable),
    .cfg_interrupt_msix_mask (cfg_interrupt_msix_mask),
    .cfg_interrupt_msix_vf_enable (cfg_interrupt_msix_vf_enable),
    .cfg_interrupt_msix_vf_mask (cfg_interrupt_msix_vf_mask),
    .cfg_interrupt_msix_data (cfg_interrupt_msix_data),
    .cfg_interrupt_msix_address (cfg_interrupt_msix_address),
    .cfg_interrupt_msix_int (cfg_interrupt_msix_int_mux),
    .cfg_interrupt_msix_sent (cfg_interrupt_msix_sent),
    .cfg_interrupt_msix_fail (cfg_interrupt_msix_fail),
    .cfg_interrupt_msi_attr (cfg_interrupt_msi_attr),
    .cfg_interrupt_msi_tph_present (cfg_interrupt_msi_tph_present),
    .cfg_interrupt_msi_tph_type (cfg_interrupt_msi_tph_type),
    .cfg_interrupt_msi_tph_st_tag (cfg_interrupt_msi_tph_st_tag),
    .cfg_interrupt_msi_function_number (cfg_interrupt_msi_function_number),
    .cfg_ext_read_received (cfg_ext_read_received),
    .cfg_ext_write_received (cfg_ext_write_received),
    .cfg_ext_register_number (cfg_ext_register_number),
    .cfg_ext_function_number (cfg_ext_function_number),
    .cfg_ext_write_data (cfg_ext_write_data),
    .cfg_ext_write_byte_enable (cfg_ext_write_byte_enable),
    .cfg_ext_read_data (cfg_ext_read_data_int),
    .cfg_ext_read_data_valid (cfg_ext_read_data_valid_int),
    .cfg_dev_id (cfg_dev_id_mux),
    .cfg_vend_id (cfg_vend_id),
    .cfg_rev_id (cfg_rev_id),
    .cfg_subsys_id (cfg_subsys_id),
    .cfg_subsys_vend_id (cfg_subsys_vend_id),
    .cfg_ds_port_number (cfg_ds_port_number),
    .cfg_hot_reset_out (cfg_hot_reset_out),
    .cfg_config_space_enable (cfg_config_space_enable_mux),
    .cfg_req_pm_transition_l23_ready (cfg_req_pm_transition_l23_ready_mux),
    .cfg_hot_reset_in (cfg_hot_reset_in_mux),
    .cfg_ds_bus_number (cfg_ds_bus_number),
    .cfg_ds_device_number (cfg_ds_device_number),
    .cfg_ds_function_number (cfg_ds_function_number),
    .cfg_dsn (cfg_dsn),
    .drp_rdy (drp_rdy),
    .drp_do (drp_do),
    .drp_clk( drp_clk),
    .drp_en (drp_en_mux),
    .drp_we (drp_we),
    .drp_addr (drp_addr[9:0]),
    .drp_di (drp_di),
    .user_tph_stt_address (user_tph_stt_address),
    .user_tph_function_num (user_tph_function_num),
    .user_tph_stt_read_data (user_tph_stt_read_data),
    .user_tph_stt_read_data_valid (user_tph_stt_read_data_valid),
    .user_tph_stt_read_enable (user_tph_stt_read_enable),
    .conf_req_type (conf_req_type),
    .conf_req_reg_num (conf_req_reg_num),
    .conf_req_data (conf_req_data),
    .conf_req_valid (conf_req_valid_mux),
    .conf_mcap_request_by_conf (mcap_external_request),
    .conf_req_ready (conf_req_ready_wire),
    .conf_resp_rdata (conf_resp_rdata),
    .conf_resp_valid (conf_resp_valid),
    .conf_mcap_design_switch (mcap_design_switch),
    .conf_mcap_eos (),
    .conf_mcap_in_use_by_pcie (mcap_pcie_request),
    .pl_eq_in_progress (pl_eq_in_progress),
    .dbg_mcap_cs_b (),
    .dbg_mcap_data (),
    .dbg_mcap_eos (),
    .dbg_mcap_errror (),
    .dbg_mcap_mode (),
    .dbg_mcap_rdata_valid (),
    .dbg_mcap_rdwr_b (),
    .dbg_mcap_reset (),
    .pl_eq_phase (pl_eq_phase),
    .pcie_perstn0_in (sys_reset),
    .pcie_perstn0_out (sys_reset_pt),
    .pcie_perstn1_in (pcie_perstn1_in),
    .pcie_perstn1_out (pcie_perstn1_out),
    .pl_eq_reset_eieos_count (pl_eq_reset_eieos_count_mux),
    .pl_gen2_upstream_prefer_deemph (pl_gen2_upstream_prefer_deemph_mux),

    .pipe_clk (pipe_clk),
    .core_clk (core_clk),
    .user_clk (user_clk),
    .mcap_clk (mcap_clk),
    .mgmt_reset_n(mgmt_reset_n),
    .phy_rdy (phy_rdy),
    .pipe_tx_eqfs_gt (pipe_tx_eqfs), 
    .pipe_tx_eqlf_gt (pipe_tx_eqlf), 
    .pipe_tx0_rcvr_det_gt (pipe_tx0_rcvr_det), 
    .pipe_tx0_rate_gt (pipe_tx_rate_o), 
    .pipe_tx0_deemph_gt (pipe_tx0_deemph), 
    .pipe_tx0_margin_gt (pipe_tx0_margin), 
    .pipe_tx0_swing_gt (pipe_tx0_swing), 
    .pipe_tx0_reset_gt (pipe_tx0_reset), 
    .pipe_tx0_compliance_gt (pipe_tx0_compliance),
    .pipe_tx1_compliance_gt (pipe_tx1_compliance),
    .pipe_tx2_compliance_gt (pipe_tx2_compliance),
    .pipe_tx3_compliance_gt (pipe_tx3_compliance),
    .pipe_tx4_compliance_gt (pipe_tx4_compliance),
    .pipe_tx5_compliance_gt (pipe_tx5_compliance),
    .pipe_tx6_compliance_gt (pipe_tx6_compliance),
    .pipe_tx7_compliance_gt (pipe_tx7_compliance),
    .pipe_tx0_data_valid_gt (pipe_tx0_data_valid),
    .pipe_tx1_data_valid_gt (pipe_tx1_data_valid),
    .pipe_tx2_data_valid_gt (pipe_tx2_data_valid),
    .pipe_tx3_data_valid_gt (pipe_tx3_data_valid),
    .pipe_tx4_data_valid_gt (pipe_tx4_data_valid),
    .pipe_tx5_data_valid_gt (pipe_tx5_data_valid),
    .pipe_tx6_data_valid_gt (pipe_tx6_data_valid),
    .pipe_tx7_data_valid_gt (pipe_tx7_data_valid),
    .pipe_tx0_elec_idle_gt (pipe_tx0_elec_idle),
    .pipe_tx1_elec_idle_gt (pipe_tx1_elec_idle),
    .pipe_tx2_elec_idle_gt (pipe_tx2_elec_idle),
    .pipe_tx3_elec_idle_gt (pipe_tx3_elec_idle),
    .pipe_tx4_elec_idle_gt (pipe_tx4_elec_idle),
    .pipe_tx5_elec_idle_gt (pipe_tx5_elec_idle),
    .pipe_tx6_elec_idle_gt (pipe_tx6_elec_idle),
    .pipe_tx7_elec_idle_gt (pipe_tx7_elec_idle),
    .pipe_tx0_start_block_gt (pipe_tx0_start_block),
    .pipe_tx1_start_block_gt (pipe_tx1_start_block),
    .pipe_tx2_start_block_gt (pipe_tx2_start_block),
    .pipe_tx3_start_block_gt (pipe_tx3_start_block),
    .pipe_tx4_start_block_gt (pipe_tx4_start_block),
    .pipe_tx5_start_block_gt (pipe_tx5_start_block),
    .pipe_tx6_start_block_gt (pipe_tx6_start_block),
    .pipe_tx7_start_block_gt (pipe_tx7_start_block),
    .pipe_rx0_polarity_gt (pipe_rx0_polarity),
    .pipe_rx1_polarity_gt (pipe_rx1_polarity),
    .pipe_rx2_polarity_gt (pipe_rx2_polarity),
    .pipe_rx3_polarity_gt (pipe_rx3_polarity),
    .pipe_rx4_polarity_gt (pipe_rx4_polarity),
    .pipe_rx5_polarity_gt (pipe_rx5_polarity),
    .pipe_rx6_polarity_gt (pipe_rx6_polarity),
    .pipe_rx7_polarity_gt (pipe_rx7_polarity),
    .pipe_rx0_eqcontrol_gt (pipe_rx0_eqcontrol),
    .pipe_rx1_eqcontrol_gt (pipe_rx1_eqcontrol),
    .pipe_rx2_eqcontrol_gt (pipe_rx2_eqcontrol),
    .pipe_rx3_eqcontrol_gt (pipe_rx3_eqcontrol),
    .pipe_rx4_eqcontrol_gt (pipe_rx4_eqcontrol),
    .pipe_rx5_eqcontrol_gt (pipe_rx5_eqcontrol),
    .pipe_rx6_eqcontrol_gt (pipe_rx6_eqcontrol),
    .pipe_rx7_eqcontrol_gt (pipe_rx7_eqcontrol),
    .pipe_tx0_char_is_k_gt (pipe_tx0_char_is_k),
    .pipe_tx1_char_is_k_gt (pipe_tx1_char_is_k),
    .pipe_tx2_char_is_k_gt (pipe_tx2_char_is_k),
    .pipe_tx3_char_is_k_gt (pipe_tx3_char_is_k),
    .pipe_tx4_char_is_k_gt (pipe_tx4_char_is_k),
    .pipe_tx5_char_is_k_gt (pipe_tx5_char_is_k),
    .pipe_tx6_char_is_k_gt (pipe_tx6_char_is_k),
    .pipe_tx7_char_is_k_gt (pipe_tx7_char_is_k),
    .pipe_tx0_eqcontrol_gt (pipe_tx0_eqcontrol),
    .pipe_tx1_eqcontrol_gt (pipe_tx1_eqcontrol),
    .pipe_tx2_eqcontrol_gt (pipe_tx2_eqcontrol),
    .pipe_tx3_eqcontrol_gt (pipe_tx3_eqcontrol),
    .pipe_tx4_eqcontrol_gt (pipe_tx4_eqcontrol),
    .pipe_tx5_eqcontrol_gt (pipe_tx5_eqcontrol),
    .pipe_tx6_eqcontrol_gt (pipe_tx6_eqcontrol),
    .pipe_tx7_eqcontrol_gt (pipe_tx7_eqcontrol),
    .pipe_tx0_powerdown_gt (pipe_tx0_powerdown),
    .pipe_tx1_powerdown_gt (pipe_tx1_powerdown),
    .pipe_tx2_powerdown_gt (pipe_tx2_powerdown),
    .pipe_tx3_powerdown_gt (pipe_tx3_powerdown),
    .pipe_tx4_powerdown_gt (pipe_tx4_powerdown),
    .pipe_tx5_powerdown_gt (pipe_tx5_powerdown),
    .pipe_tx6_powerdown_gt (pipe_tx6_powerdown),
    .pipe_tx7_powerdown_gt (pipe_tx7_powerdown),
    .pipe_tx0_syncheader_gt (pipe_tx0_syncheader),
    .pipe_tx1_syncheader_gt (pipe_tx1_syncheader),
    .pipe_tx2_syncheader_gt (pipe_tx2_syncheader),
    .pipe_tx3_syncheader_gt (pipe_tx3_syncheader),
    .pipe_tx4_syncheader_gt (pipe_tx4_syncheader),
    .pipe_tx5_syncheader_gt (pipe_tx5_syncheader),
    .pipe_tx6_syncheader_gt (pipe_tx6_syncheader),
    .pipe_tx7_syncheader_gt (pipe_tx7_syncheader),
    .pipe_rx0_eqpreset_gt (pipe_rx0_eqpreset),
    .pipe_rx1_eqpreset_gt (pipe_rx1_eqpreset),
    .pipe_rx2_eqpreset_gt (pipe_rx2_eqpreset),
    .pipe_rx3_eqpreset_gt (pipe_rx3_eqpreset),
    .pipe_rx4_eqpreset_gt (pipe_rx4_eqpreset),
    .pipe_rx5_eqpreset_gt (pipe_rx5_eqpreset),
    .pipe_rx6_eqpreset_gt (pipe_rx6_eqpreset),
    .pipe_rx7_eqpreset_gt (pipe_rx7_eqpreset),
    .pipe_tx0_data_gt (pipe_tx0_data),
    .pipe_tx1_data_gt (pipe_tx1_data),
    .pipe_tx2_data_gt (pipe_tx2_data),
    .pipe_tx3_data_gt (pipe_tx3_data),
    .pipe_tx4_data_gt (pipe_tx4_data),
    .pipe_tx5_data_gt (pipe_tx5_data),
    .pipe_tx6_data_gt (pipe_tx6_data),
    .pipe_tx7_data_gt (pipe_tx7_data),
    .pipe_rx0_eqlp_txpreset_gt (pipe_rx0_eq_txpreset),
    .pipe_rx1_eqlp_txpreset_gt (pipe_rx1_eq_txpreset),
    .pipe_rx2_eqlp_txpreset_gt (pipe_rx2_eq_txpreset),
    .pipe_rx3_eqlp_txpreset_gt (pipe_rx3_eq_txpreset),
    .pipe_rx4_eqlp_txpreset_gt (pipe_rx4_eq_txpreset),
    .pipe_rx5_eqlp_txpreset_gt (pipe_rx5_eq_txpreset),
    .pipe_rx6_eqlp_txpreset_gt (pipe_rx6_eq_txpreset),
    .pipe_rx7_eqlp_txpreset_gt (pipe_rx7_eq_txpreset),
    .pipe_tx0_eqpreset_gt (pipe_tx0_eqpreset),
    .pipe_tx1_eqpreset_gt (pipe_tx1_eqpreset),
    .pipe_tx2_eqpreset_gt (pipe_tx2_eqpreset),
    .pipe_tx3_eqpreset_gt (pipe_tx3_eqpreset),
    .pipe_tx4_eqpreset_gt (pipe_tx4_eqpreset),
    .pipe_tx5_eqpreset_gt (pipe_tx5_eqpreset),
    .pipe_tx6_eqpreset_gt (pipe_tx6_eqpreset),
    .pipe_tx7_eqpreset_gt (pipe_tx7_eqpreset),
    .pipe_rx0_eqlp_lffs_gt (pipe_rx0_eq_lffs),
    .pipe_rx1_eqlp_lffs_gt (pipe_rx1_eq_lffs),
    .pipe_rx2_eqlp_lffs_gt (pipe_rx2_eq_lffs),
    .pipe_rx3_eqlp_lffs_gt (pipe_rx3_eq_lffs),
    .pipe_rx4_eqlp_lffs_gt (pipe_rx4_eq_lffs),
    .pipe_rx5_eqlp_lffs_gt (pipe_rx5_eq_lffs),
    .pipe_rx6_eqlp_lffs_gt (pipe_rx6_eq_lffs),
    .pipe_rx7_eqlp_lffs_gt (pipe_rx7_eq_lffs),
    .pipe_tx0_eqdeemph_gt (pipe_tx0_eqdeemph),
    .pipe_tx1_eqdeemph_gt (pipe_tx1_eqdeemph),
    .pipe_tx2_eqdeemph_gt (pipe_tx2_eqdeemph),
    .pipe_tx3_eqdeemph_gt (pipe_tx3_eqdeemph),
    .pipe_tx4_eqdeemph_gt (pipe_tx4_eqdeemph),
    .pipe_tx5_eqdeemph_gt (pipe_tx5_eqdeemph),
    .pipe_tx6_eqdeemph_gt (pipe_tx6_eqdeemph),
    .pipe_tx7_eqdeemph_gt (pipe_tx7_eqdeemph),
    .pipe_rx0_data_valid_gt (pipe_rx0_data_valid),
    .pipe_rx1_data_valid_gt (pipe_rx1_data_valid),
    .pipe_rx2_data_valid_gt (pipe_rx2_data_valid),
    .pipe_rx3_data_valid_gt (pipe_rx3_data_valid),
    .pipe_rx4_data_valid_gt (pipe_rx4_data_valid),
    .pipe_rx5_data_valid_gt (pipe_rx5_data_valid),
    .pipe_rx6_data_valid_gt (pipe_rx6_data_valid),
    .pipe_rx7_data_valid_gt (pipe_rx7_data_valid),
    .pipe_rx0_elec_idle_gt (pipe_rx0_elec_idle),
    .pipe_rx1_elec_idle_gt (pipe_rx1_elec_idle),
    .pipe_rx2_elec_idle_gt (pipe_rx2_elec_idle),
    .pipe_rx3_elec_idle_gt (pipe_rx3_elec_idle),
    .pipe_rx4_elec_idle_gt (pipe_rx4_elec_idle),
    .pipe_rx5_elec_idle_gt (pipe_rx5_elec_idle),
    .pipe_rx6_elec_idle_gt (pipe_rx6_elec_idle),
    .pipe_rx7_elec_idle_gt (pipe_rx7_elec_idle),
    .pipe_rx0_eqdone_gt (pipe_rx0_eqdone),
    .pipe_rx1_eqdone_gt (pipe_rx1_eqdone),
    .pipe_rx2_eqdone_gt (pipe_rx2_eqdone),
    .pipe_rx3_eqdone_gt (pipe_rx3_eqdone),
    .pipe_rx4_eqdone_gt (pipe_rx4_eqdone),
    .pipe_rx5_eqdone_gt (pipe_rx5_eqdone),
    .pipe_rx6_eqdone_gt (pipe_rx6_eqdone),
    .pipe_rx7_eqdone_gt (pipe_rx7_eqdone),
    .pipe_rx0_eqlp_adaptdone_gt (pipe_rx0_eq_adapt_done),
    .pipe_rx1_eqlp_adaptdone_gt (pipe_rx1_eq_adapt_done),
    .pipe_rx2_eqlp_adaptdone_gt (pipe_rx2_eq_adapt_done),
    .pipe_rx3_eqlp_adaptdone_gt (pipe_rx3_eq_adapt_done),
    .pipe_rx4_eqlp_adaptdone_gt (pipe_rx4_eq_adapt_done),
    .pipe_rx5_eqlp_adaptdone_gt (pipe_rx5_eq_adapt_done),
    .pipe_rx6_eqlp_adaptdone_gt (pipe_rx6_eq_adapt_done),
    .pipe_rx7_eqlp_adaptdone_gt (pipe_rx7_eq_adapt_done),
    .pipe_rx0_eqlp_lffs_sel_gt (pipe_rx0_eq_lffs_sel),
    .pipe_rx1_eqlp_lffs_sel_gt (pipe_rx1_eq_lffs_sel),
    .pipe_rx2_eqlp_lffs_sel_gt (pipe_rx2_eq_lffs_sel),
    .pipe_rx3_eqlp_lffs_sel_gt (pipe_rx3_eq_lffs_sel),
    .pipe_rx4_eqlp_lffs_sel_gt (pipe_rx4_eq_lffs_sel),
    .pipe_rx5_eqlp_lffs_sel_gt (pipe_rx5_eq_lffs_sel),
    .pipe_rx6_eqlp_lffs_sel_gt (pipe_rx6_eq_lffs_sel),
    .pipe_rx7_eqlp_lffs_sel_gt (pipe_rx7_eq_lffs_sel),
    .pipe_rx0_phy_status_gt (pipe_rx0_phy_status),
    .pipe_rx1_phy_status_gt (pipe_rx1_phy_status),
    .pipe_rx2_phy_status_gt (pipe_rx2_phy_status),
    .pipe_rx3_phy_status_gt (pipe_rx3_phy_status),
    .pipe_rx4_phy_status_gt (pipe_rx4_phy_status),
    .pipe_rx5_phy_status_gt (pipe_rx5_phy_status),
    .pipe_rx6_phy_status_gt (pipe_rx6_phy_status),
    .pipe_rx7_phy_status_gt (pipe_rx7_phy_status),
    .pipe_rx0_start_block_gt (pipe_rx0_start_block),
    .pipe_rx1_start_block_gt (pipe_rx1_start_block),
    .pipe_rx2_start_block_gt (pipe_rx2_start_block),
    .pipe_rx3_start_block_gt (pipe_rx3_start_block),
    .pipe_rx4_start_block_gt (pipe_rx4_start_block),
    .pipe_rx5_start_block_gt (pipe_rx5_start_block),
    .pipe_rx6_start_block_gt (pipe_rx6_start_block),
    .pipe_rx7_start_block_gt (pipe_rx7_start_block),
    .pipe_rx0_valid_gt (pipe_rx0_valid),
    .pipe_rx1_valid_gt (pipe_rx1_valid),
    .pipe_rx2_valid_gt (pipe_rx2_valid),
    .pipe_rx3_valid_gt (pipe_rx3_valid),
    .pipe_rx4_valid_gt (pipe_rx4_valid),
    .pipe_rx5_valid_gt (pipe_rx5_valid),
    .pipe_rx6_valid_gt (pipe_rx6_valid),
    .pipe_rx7_valid_gt (pipe_rx7_valid),
    .pipe_tx0_eqdone_gt (pipe_tx0_eqdone),
    .pipe_tx1_eqdone_gt (pipe_tx1_eqdone),
    .pipe_tx2_eqdone_gt (pipe_tx2_eqdone),
    .pipe_tx3_eqdone_gt (pipe_tx3_eqdone),
    .pipe_tx4_eqdone_gt (pipe_tx4_eqdone),
    .pipe_tx5_eqdone_gt (pipe_tx5_eqdone),
    .pipe_tx6_eqdone_gt (pipe_tx6_eqdone),
    .pipe_tx7_eqdone_gt (pipe_tx7_eqdone),
    .pipe_rx0_eqlp_new_txcoef_forpreset_gt (pipe_rx0_eq_new_txcoeff),
    .pipe_rx1_eqlp_new_txcoef_forpreset_gt (pipe_rx1_eq_new_txcoeff),
    .pipe_rx2_eqlp_new_txcoef_forpreset_gt (pipe_rx2_eq_new_txcoeff),
    .pipe_rx3_eqlp_new_txcoef_forpreset_gt (pipe_rx3_eq_new_txcoeff),
    .pipe_rx4_eqlp_new_txcoef_forpreset_gt (pipe_rx4_eq_new_txcoeff),
    .pipe_rx5_eqlp_new_txcoef_forpreset_gt (pipe_rx5_eq_new_txcoeff),
    .pipe_rx6_eqlp_new_txcoef_forpreset_gt (pipe_rx6_eq_new_txcoeff),
    .pipe_rx7_eqlp_new_txcoef_forpreset_gt (pipe_rx7_eq_new_txcoeff),
    .pipe_tx0_eqcoeff_gt (pipe_tx0_eqcoeff),
    .pipe_tx1_eqcoeff_gt (pipe_tx1_eqcoeff),
    .pipe_tx2_eqcoeff_gt (pipe_tx2_eqcoeff),
    .pipe_tx3_eqcoeff_gt (pipe_tx3_eqcoeff),
    .pipe_tx4_eqcoeff_gt (pipe_tx4_eqcoeff),
    .pipe_tx5_eqcoeff_gt (pipe_tx5_eqcoeff),
    .pipe_tx6_eqcoeff_gt (pipe_tx6_eqcoeff),
    .pipe_tx7_eqcoeff_gt (pipe_tx7_eqcoeff),
    .pipe_rx0_char_is_k_gt (pipe_rx0_char_is_k),
    .pipe_rx1_char_is_k_gt (pipe_rx1_char_is_k),
    .pipe_rx2_char_is_k_gt (pipe_rx2_char_is_k),
    .pipe_rx3_char_is_k_gt (pipe_rx3_char_is_k),
    .pipe_rx4_char_is_k_gt (pipe_rx4_char_is_k),
    .pipe_rx5_char_is_k_gt (pipe_rx5_char_is_k),
    .pipe_rx6_char_is_k_gt (pipe_rx6_char_is_k),
    .pipe_rx7_char_is_k_gt (pipe_rx7_char_is_k),
    .pipe_rx0_syncheader_gt (pipe_rx0_syncheader),
    .pipe_rx1_syncheader_gt (pipe_rx1_syncheader),
    .pipe_rx2_syncheader_gt (pipe_rx2_syncheader),
    .pipe_rx3_syncheader_gt (pipe_rx3_syncheader),
    .pipe_rx4_syncheader_gt (pipe_rx4_syncheader),
    .pipe_rx5_syncheader_gt (pipe_rx5_syncheader),
    .pipe_rx6_syncheader_gt (pipe_rx6_syncheader),
    .pipe_rx7_syncheader_gt (pipe_rx7_syncheader),
    .pipe_rx0_status_gt (pipe_rx0_status),
    .pipe_rx1_status_gt (pipe_rx1_status),
    .pipe_rx2_status_gt (pipe_rx2_status),
    .pipe_rx3_status_gt (pipe_rx3_status),
    .pipe_rx4_status_gt (pipe_rx4_status),
    .pipe_rx5_status_gt (pipe_rx5_status),
    .pipe_rx6_status_gt (pipe_rx6_status),
    .pipe_rx7_status_gt (pipe_rx7_status),
    .pipe_rx0_data_gt (pipe_rx0_data),
    .pipe_rx1_data_gt (pipe_rx1_data),
    .pipe_rx2_data_gt (pipe_rx2_data),
    .pipe_rx3_data_gt (pipe_rx3_data),
    .pipe_rx4_data_gt (pipe_rx4_data),
    .pipe_rx5_data_gt (pipe_rx5_data),
    .pipe_rx6_data_gt (pipe_rx6_data),
    .pipe_rx7_data_gt (pipe_rx7_data)
  );

 assign  common_commands_out = 26'd0;
 assign  pipe_tx_0_sigs = 84'd0; 
 assign  pipe_tx_1_sigs = 84'd0;
 assign  pipe_tx_2_sigs = 84'd0;
 assign  pipe_tx_3_sigs = 84'd0;
 assign  pipe_tx_4_sigs = 84'd0;
 assign  pipe_tx_5_sigs = 84'd0;
 assign  pipe_tx_6_sigs = 84'd0;
 assign  pipe_tx_7_sigs = 84'd0;
 assign  phy_rdy = ~phy_rdy_phystatus;
end
endgenerate


generate if (EXT_PIPE_SIM == "FALSE" && PL_LINK_CAP_MAX_LINK_WIDTH == 8) 
begin
 assign pipe_txdata = {pipe_tx7_data, pipe_tx6_data, pipe_tx5_data, pipe_tx4_data, pipe_tx3_data, pipe_tx2_data, pipe_tx1_data, pipe_tx0_data};
 assign pipe_tx_char_is_k = {pipe_tx7_char_is_k, pipe_tx6_char_is_k, pipe_tx5_char_is_k, pipe_tx4_char_is_k, pipe_tx3_char_is_k, pipe_tx2_char_is_k, pipe_tx1_char_is_k, pipe_tx0_char_is_k};
 assign pipe_tx_data_valid = {pipe_tx7_data_valid, pipe_tx6_data_valid, pipe_tx5_data_valid, pipe_tx4_data_valid, pipe_tx3_data_valid, pipe_tx2_data_valid, pipe_tx1_data_valid, pipe_tx0_data_valid};
 assign pipe_tx_start_block = {pipe_tx7_start_block, pipe_tx6_start_block, pipe_tx5_start_block, pipe_tx4_start_block, pipe_tx3_start_block, pipe_tx2_start_block, pipe_tx1_start_block, pipe_tx0_start_block};
 assign pipe_tx_syncheader = {pipe_tx7_syncheader, pipe_tx6_syncheader, pipe_tx5_syncheader, pipe_tx4_syncheader, pipe_tx3_syncheader, pipe_tx2_syncheader, pipe_tx1_syncheader, pipe_tx0_syncheader};
 
 assign pipe_rx7_data = {pipe_rx_data[255:224]};
 assign pipe_rx6_data = {pipe_rx_data[223:192]};
 assign pipe_rx5_data = {pipe_rx_data[191:160]};
 assign pipe_rx4_data = {pipe_rx_data[159:128]};
 assign pipe_rx3_data = {pipe_rx_data[127:96]};
 assign pipe_rx2_data = {pipe_rx_data[95:64]};
 assign pipe_rx1_data = {pipe_rx_data[63:32]};
 assign pipe_rx0_data = {pipe_rx_data[31:0]};
 
 assign pipe_rx7_char_is_k = {pipe_rx_char_is_k[15:14]};
 assign pipe_rx6_char_is_k = {pipe_rx_char_is_k[13:12]};
 assign pipe_rx5_char_is_k = {pipe_rx_char_is_k[11:10]};
 assign pipe_rx4_char_is_k = {pipe_rx_char_is_k[9:8]};
 assign pipe_rx3_char_is_k = {pipe_rx_char_is_k[7:6]};
 assign pipe_rx2_char_is_k = {pipe_rx_char_is_k[5:4]};
 assign pipe_rx1_char_is_k = {pipe_rx_char_is_k[3:2]};
 assign pipe_rx0_char_is_k = {pipe_rx_char_is_k[1:0]};

 assign pipe_rx7_eq_new_txcoeff = {pipe_rx_eq_new_txcoeff[143:126]};
 assign pipe_rx6_eq_new_txcoeff = {pipe_rx_eq_new_txcoeff[125:108]};
 assign pipe_rx5_eq_new_txcoeff = {pipe_rx_eq_new_txcoeff[107:90]};
 assign pipe_rx4_eq_new_txcoeff = {pipe_rx_eq_new_txcoeff[89:72]};
 assign pipe_rx3_eq_new_txcoeff = {pipe_rx_eq_new_txcoeff[71:54]};
 assign pipe_rx2_eq_new_txcoeff = {pipe_rx_eq_new_txcoeff[53:36]};
 assign pipe_rx1_eq_new_txcoeff = {pipe_rx_eq_new_txcoeff[35:18]};
 assign pipe_rx0_eq_new_txcoeff = {pipe_rx_eq_new_txcoeff[17:0]}; 

 assign pipe_tx7_eqcoeff = {pipe_tx_eqcoeff[143:126]};
 assign pipe_tx6_eqcoeff = {pipe_tx_eqcoeff[125:108]};
 assign pipe_tx5_eqcoeff = {pipe_tx_eqcoeff[107:90]};
 assign pipe_tx4_eqcoeff = {pipe_tx_eqcoeff[89:72]};
 assign pipe_tx3_eqcoeff = {pipe_tx_eqcoeff[71:54]};
 assign pipe_tx2_eqcoeff = {pipe_tx_eqcoeff[53:36]};
 assign pipe_tx1_eqcoeff = {pipe_tx_eqcoeff[35:18]};
 assign pipe_tx0_eqcoeff = {pipe_tx_eqcoeff[17:0]}; 
 
 assign pipe_rx7_status = {pipe_rx_status[23:21]};
 assign pipe_rx6_status = {pipe_rx_status[20:18]};
 assign pipe_rx5_status = {pipe_rx_status[17:15]};
 assign pipe_rx4_status = {pipe_rx_status[14:12]};
 assign pipe_rx3_status = {pipe_rx_status[11:9]};
 assign pipe_rx2_status = {pipe_rx_status[8:6]};
 assign pipe_rx1_status = {pipe_rx_status[5:3]};
 assign pipe_rx0_status = {pipe_rx_status[2:0]};
 
 assign pipe_rx7_syncheader = {pipe_rx_syncheader[15:14]};
 assign pipe_rx6_syncheader = {pipe_rx_syncheader[13:12]};
 assign pipe_rx5_syncheader = {pipe_rx_syncheader[11:10]};
 assign pipe_rx4_syncheader = {pipe_rx_syncheader[9:8]};
 assign pipe_rx3_syncheader = {pipe_rx_syncheader[7:6]};
 assign pipe_rx2_syncheader = {pipe_rx_syncheader[5:4]};
 assign pipe_rx1_syncheader = {pipe_rx_syncheader[3:2]};
 assign pipe_rx0_syncheader = {pipe_rx_syncheader[1:0]};
 
 assign pipe_rx7_data_valid = {pipe_rx_data_valid[7]};
 assign pipe_rx6_data_valid = {pipe_rx_data_valid[6]};
 assign pipe_rx5_data_valid = {pipe_rx_data_valid[5]};
 assign pipe_rx4_data_valid = {pipe_rx_data_valid[4]};
 assign pipe_rx3_data_valid = {pipe_rx_data_valid[3]};
 assign pipe_rx2_data_valid = {pipe_rx_data_valid[2]};
 assign pipe_rx1_data_valid = {pipe_rx_data_valid[1]};
 assign pipe_rx0_data_valid = {pipe_rx_data_valid[0]};
 
 assign pipe_rx7_elec_idle = {pipe_rx_elec_idle[7]};
 assign pipe_rx6_elec_idle = {pipe_rx_elec_idle[6]};
 assign pipe_rx5_elec_idle = {pipe_rx_elec_idle[5]};
 assign pipe_rx4_elec_idle = {pipe_rx_elec_idle[4]};
 assign pipe_rx3_elec_idle = {pipe_rx_elec_idle[3]};
 assign pipe_rx2_elec_idle = {pipe_rx_elec_idle[2]};
 assign pipe_rx1_elec_idle = {pipe_rx_elec_idle[1]};
 assign pipe_rx0_elec_idle = {pipe_rx_elec_idle[0]};
 
 assign pipe_rx7_start_block = {pipe_rx_start_block[7]};
 assign pipe_rx6_start_block = {pipe_rx_start_block[6]};
 assign pipe_rx5_start_block = {pipe_rx_start_block[5]};
 assign pipe_rx4_start_block = {pipe_rx_start_block[4]};
 assign pipe_rx3_start_block = {pipe_rx_start_block[3]};
 assign pipe_rx2_start_block = {pipe_rx_start_block[2]};
 assign pipe_rx1_start_block = {pipe_rx_start_block[1]}; 
 assign pipe_rx0_start_block = {pipe_rx_start_block[0]};

 assign pipe_tx7_eqdone = {pipe_tx_eqdone[7]};
 assign pipe_tx6_eqdone = {pipe_tx_eqdone[6]};
 assign pipe_tx5_eqdone = {pipe_tx_eqdone[5]};
 assign pipe_tx4_eqdone = {pipe_tx_eqdone[4]};
 assign pipe_tx3_eqdone = {pipe_tx_eqdone[3]};
 assign pipe_tx2_eqdone = {pipe_tx_eqdone[2]};
 assign pipe_tx1_eqdone = {pipe_tx_eqdone[1]};
 assign pipe_tx0_eqdone = {pipe_tx_eqdone[0]};
 
 assign pipe_rx7_valid = {pipe_rx_valid[7]};
 assign pipe_rx6_valid = {pipe_rx_valid[6]};
 assign pipe_rx5_valid = {pipe_rx_valid[5]};
 assign pipe_rx4_valid = {pipe_rx_valid[4]};
 assign pipe_rx3_valid = {pipe_rx_valid[3]};
 assign pipe_rx2_valid = {pipe_rx_valid[2]};
 assign pipe_rx1_valid = {pipe_rx_valid[1]};
 assign pipe_rx0_valid = {pipe_rx_valid[0]};
 
 assign pipe_tx_elec_idle = {pipe_tx7_elec_idle, pipe_tx6_elec_idle, pipe_tx5_elec_idle, pipe_tx4_elec_idle, pipe_tx3_elec_idle, pipe_tx2_elec_idle, pipe_tx1_elec_idle, pipe_tx0_elec_idle};
 assign pipe_tx_compliance = {pipe_tx7_compliance, pipe_tx6_compliance, pipe_tx5_compliance, pipe_tx4_compliance, pipe_tx3_compliance, pipe_tx2_compliance, pipe_tx1_compliance, pipe_tx0_compliance};
 assign pipe_rx_polarity = {pipe_rx7_polarity, pipe_rx6_polarity, pipe_rx5_polarity, pipe_rx4_polarity, pipe_rx3_polarity, pipe_rx2_polarity, pipe_rx1_polarity, pipe_rx0_polarity};
 
 assign pipe_tx_eqcontrol = {pipe_tx7_eqcontrol, pipe_tx6_eqcontrol, pipe_tx5_eqcontrol, pipe_tx4_eqcontrol, pipe_tx3_eqcontrol, pipe_tx2_eqcontrol, pipe_tx1_eqcontrol, pipe_tx0_eqcontrol};
 assign pipe_tx_eqpreset = {pipe_tx7_eqpreset, pipe_tx6_eqpreset, pipe_tx5_eqpreset, pipe_tx4_eqpreset, pipe_tx3_eqpreset, pipe_tx2_eqpreset, pipe_tx1_eqpreset, pipe_tx0_eqpreset};
 assign pipe_tx_eqdeemph = {pipe_tx7_eqdeemph, pipe_tx6_eqdeemph, pipe_tx5_eqdeemph, pipe_tx4_eqdeemph, pipe_tx3_eqdeemph, pipe_tx2_eqdeemph, pipe_tx1_eqdeemph, pipe_tx0_eqdeemph};
 
 assign pipe_rx7_eqdone = {pipe_rx_eqdone[7]};
 assign pipe_rx6_eqdone = {pipe_rx_eqdone[6]};
 assign pipe_rx5_eqdone = {pipe_rx_eqdone[5]};
 assign pipe_rx4_eqdone = {pipe_rx_eqdone[4]};
 assign pipe_rx3_eqdone = {pipe_rx_eqdone[3]};
 assign pipe_rx2_eqdone = {pipe_rx_eqdone[2]};
 assign pipe_rx1_eqdone = {pipe_rx_eqdone[1]};
 assign pipe_rx0_eqdone = {pipe_rx_eqdone[0]};
 
 assign pipe_rx7_eq_adapt_done = {pipe_rx_eq_adapt_done[7]};
 assign pipe_rx6_eq_adapt_done = {pipe_rx_eq_adapt_done[6]};
 assign pipe_rx5_eq_adapt_done = {pipe_rx_eq_adapt_done[5]};
 assign pipe_rx4_eq_adapt_done = {pipe_rx_eq_adapt_done[4]};
 assign pipe_rx3_eq_adapt_done = {pipe_rx_eq_adapt_done[3]};
 assign pipe_rx2_eq_adapt_done = {pipe_rx_eq_adapt_done[2]};
 assign pipe_rx1_eq_adapt_done = {pipe_rx_eq_adapt_done[1]};
 assign pipe_rx0_eq_adapt_done = {pipe_rx_eq_adapt_done[0]};
 
 assign pipe_rx7_phy_status = {pipe_rx_phy_status[7]};
 assign pipe_rx6_phy_status = {pipe_rx_phy_status[6]};
 assign pipe_rx5_phy_status = {pipe_rx_phy_status[5]};
 assign pipe_rx4_phy_status = {pipe_rx_phy_status[4]};
 assign pipe_rx3_phy_status = {pipe_rx_phy_status[3]};
 assign pipe_rx2_phy_status = {pipe_rx_phy_status[2]};
 assign pipe_rx1_phy_status = {pipe_rx_phy_status[1]};
 assign pipe_rx0_phy_status = {pipe_rx_phy_status[0]};
 
 assign pipe_rx7_eq_lffs_sel = {pipe_rx_eq_lffs_sel[7]};
 assign pipe_rx6_eq_lffs_sel = {pipe_rx_eq_lffs_sel[6]};
 assign pipe_rx5_eq_lffs_sel = {pipe_rx_eq_lffs_sel[5]};
 assign pipe_rx4_eq_lffs_sel = {pipe_rx_eq_lffs_sel[4]};
 assign pipe_rx3_eq_lffs_sel = {pipe_rx_eq_lffs_sel[3]};
 assign pipe_rx2_eq_lffs_sel = {pipe_rx_eq_lffs_sel[2]};
 assign pipe_rx1_eq_lffs_sel = {pipe_rx_eq_lffs_sel[1]};
 assign pipe_rx0_eq_lffs_sel = {pipe_rx_eq_lffs_sel[0]};
 
 assign pipe_rx_eqcontrol = {pipe_rx7_eqcontrol, pipe_rx6_eqcontrol, pipe_rx5_eqcontrol, pipe_rx4_eqcontrol, pipe_rx3_eqcontrol, pipe_rx2_eqcontrol, pipe_rx1_eqcontrol, pipe_rx0_eqcontrol};
 assign pipe_rx_eqpreset = {pipe_rx7_eqpreset, pipe_rx6_eqpreset, pipe_rx5_eqpreset, pipe_rx4_eqpreset, pipe_rx3_eqpreset, pipe_rx2_eqpreset, pipe_rx1_eqpreset, pipe_rx0_eqpreset};
 assign pipe_rx_eq_lffs = {pipe_rx7_eq_lffs, pipe_rx6_eq_lffs, pipe_rx5_eq_lffs, pipe_rx4_eq_lffs, pipe_rx3_eq_lffs, pipe_rx2_eq_lffs, pipe_rx1_eq_lffs, pipe_rx0_eq_lffs};
 assign pipe_rx_eq_txpreset = {pipe_rx7_eq_txpreset, pipe_rx6_eq_txpreset, pipe_rx5_eq_txpreset, pipe_rx4_eq_txpreset, pipe_rx3_eq_txpreset, pipe_rx2_eq_txpreset, pipe_rx1_eq_txpreset, pipe_rx0_eq_txpreset};

end
else if (EXT_PIPE_SIM == "FALSE" && PL_LINK_CAP_MAX_LINK_WIDTH == 4)
begin
 assign pipe_txdata = { pipe_tx3_data, pipe_tx2_data, pipe_tx1_data, pipe_tx0_data};
 assign pipe_tx_char_is_k = {pipe_tx3_char_is_k, pipe_tx2_char_is_k, pipe_tx1_char_is_k, pipe_tx0_char_is_k};
 assign pipe_tx_data_valid = {pipe_tx3_data_valid, pipe_tx2_data_valid, pipe_tx1_data_valid, pipe_tx0_data_valid};
 assign pipe_tx_start_block = {pipe_tx3_start_block, pipe_tx2_start_block, pipe_tx1_start_block, pipe_tx0_start_block};
 assign pipe_tx_syncheader = {pipe_tx3_syncheader, pipe_tx2_syncheader, pipe_tx1_syncheader, pipe_tx0_syncheader};
 
 assign pipe_rx7_data = 32'b0;
 assign pipe_rx6_data = 32'b0;
 assign pipe_rx5_data = 32'b0;
 assign pipe_rx4_data = 32'b0;
 assign pipe_rx3_data = {pipe_rx_data[127:96]};
 assign pipe_rx2_data = {pipe_rx_data[95:64]};
 assign pipe_rx1_data = {pipe_rx_data[63:32]};
 assign pipe_rx0_data = {pipe_rx_data[31:0]};

 assign pipe_rx7_char_is_k = 2'b0;
 assign pipe_rx6_char_is_k = 2'b0;
 assign pipe_rx5_char_is_k = 2'b0;
 assign pipe_rx4_char_is_k = 2'b0;
 assign pipe_rx3_char_is_k = {pipe_rx_char_is_k[7:6]};
 assign pipe_rx2_char_is_k = {pipe_rx_char_is_k[5:4]};
 assign pipe_rx1_char_is_k = {pipe_rx_char_is_k[3:2]};
 assign pipe_rx0_char_is_k = {pipe_rx_char_is_k[1:0]};
 
 assign pipe_rx7_eq_new_txcoeff = 18'b0;
 assign pipe_rx6_eq_new_txcoeff = 18'b0;
 assign pipe_rx5_eq_new_txcoeff = 18'b0;
 assign pipe_rx4_eq_new_txcoeff = 18'b0;  
 assign pipe_rx3_eq_new_txcoeff = {pipe_rx_eq_new_txcoeff[71:54]};
 assign pipe_rx2_eq_new_txcoeff = {pipe_rx_eq_new_txcoeff[53:36]};
 assign pipe_rx1_eq_new_txcoeff = {pipe_rx_eq_new_txcoeff[35:18]};
 assign pipe_rx0_eq_new_txcoeff = {pipe_rx_eq_new_txcoeff[17:0]};

 assign pipe_tx7_eqcoeff = 18'b0;
 assign pipe_tx6_eqcoeff = 18'b0;
 assign pipe_tx5_eqcoeff = 18'b0;
 assign pipe_tx4_eqcoeff = 18'b0;
 assign pipe_tx3_eqcoeff = {pipe_tx_eqcoeff[71:54]};
 assign pipe_tx2_eqcoeff = {pipe_tx_eqcoeff[53:36]};
 assign pipe_tx1_eqcoeff = {pipe_tx_eqcoeff[35:18]};
 assign pipe_tx0_eqcoeff = {pipe_tx_eqcoeff[17:0]}; 

 assign pipe_rx7_status = 3'b0;
 assign pipe_rx6_status = 3'b0;
 assign pipe_rx5_status = 3'b0;
 assign pipe_rx4_status = 3'b0; 
 assign pipe_rx3_status = {pipe_rx_status[11:9]};
 assign pipe_rx2_status = {pipe_rx_status[8:6]};
 assign pipe_rx1_status = {pipe_rx_status[5:3]};
 assign pipe_rx0_status = {pipe_rx_status[2:0]};

 assign pipe_rx7_data_valid = 1'b0;  
 assign pipe_rx6_data_valid = 1'b0;  
 assign pipe_rx5_data_valid = 1'b0;  
 assign pipe_rx4_data_valid = 1'b0;
 assign pipe_rx3_data_valid = {pipe_rx_data_valid[3]};
 assign pipe_rx2_data_valid = {pipe_rx_data_valid[2]};
 assign pipe_rx1_data_valid = {pipe_rx_data_valid[1]};
 assign pipe_rx0_data_valid = {pipe_rx_data_valid[0]}; 

 assign pipe_rx7_elec_idle = 1'b0; 
 assign pipe_rx6_elec_idle = 1'b0; 
 assign pipe_rx5_elec_idle = 1'b0; 
 assign pipe_rx4_elec_idle = 1'b0; 
 assign pipe_rx3_elec_idle = {pipe_rx_elec_idle[3]};
 assign pipe_rx2_elec_idle = {pipe_rx_elec_idle[2]};
 assign pipe_rx1_elec_idle = {pipe_rx_elec_idle[1]};
 assign pipe_rx0_elec_idle = {pipe_rx_elec_idle[0]}; 

 assign pipe_rx7_start_block = 1'b0;  
 assign pipe_rx6_start_block = 1'b0;  
 assign pipe_rx5_start_block = 1'b0;  
 assign pipe_rx4_start_block = 1'b0;  
 assign pipe_rx3_start_block = {pipe_rx_start_block[3]};
 assign pipe_rx2_start_block = {pipe_rx_start_block[2]};
 assign pipe_rx1_start_block = {pipe_rx_start_block[1]}; 
 assign pipe_rx0_start_block = {pipe_rx_start_block[0]};  

 assign pipe_rx7_syncheader = 2'b0;
 assign pipe_rx6_syncheader = 2'b0;
 assign pipe_rx5_syncheader = 2'b0;
 assign pipe_rx4_syncheader = 2'b0;
 assign pipe_rx3_syncheader = {pipe_rx_syncheader[7:6]};
 assign pipe_rx2_syncheader = {pipe_rx_syncheader[5:4]};
 assign pipe_rx1_syncheader = {pipe_rx_syncheader[3:2]};
 assign pipe_rx0_syncheader = {pipe_rx_syncheader[1:0]};
 
 assign pipe_tx7_eqdone = 1'b0;
 assign pipe_tx6_eqdone = 1'b0;
 assign pipe_tx5_eqdone = 1'b0;
 assign pipe_tx4_eqdone = 1'b0;
 assign pipe_tx3_eqdone = {pipe_tx_eqdone[3]};
 assign pipe_tx2_eqdone = {pipe_tx_eqdone[2]};
 assign pipe_tx1_eqdone = {pipe_tx_eqdone[1]};
 assign pipe_tx0_eqdone = {pipe_tx_eqdone[0]};

 assign pipe_rx7_valid = 1'b0; 
 assign pipe_rx6_valid = 1'b0; 
 assign pipe_rx5_valid = 1'b0; 
 assign pipe_rx4_valid = 1'b0; 
 assign pipe_rx3_valid = {pipe_rx_valid[3]};
 assign pipe_rx2_valid = {pipe_rx_valid[2]};
 assign pipe_rx1_valid = {pipe_rx_valid[1]};
 assign pipe_rx0_valid = {pipe_rx_valid[0]};
 
 assign pipe_tx_elec_idle = {pipe_tx3_elec_idle, pipe_tx2_elec_idle, pipe_tx1_elec_idle, pipe_tx0_elec_idle};
 assign pipe_tx_compliance = {pipe_tx3_compliance, pipe_tx2_compliance, pipe_tx1_compliance, pipe_tx0_compliance};
 assign pipe_rx_polarity = {pipe_rx3_polarity, pipe_rx2_polarity, pipe_rx1_polarity, pipe_rx0_polarity};
 
 assign pipe_tx_eqcontrol = {pipe_tx3_eqcontrol, pipe_tx2_eqcontrol, pipe_tx1_eqcontrol, pipe_tx0_eqcontrol};
 assign pipe_tx_eqpreset = {pipe_tx3_eqpreset, pipe_tx2_eqpreset, pipe_tx1_eqpreset, pipe_tx0_eqpreset};
 assign pipe_tx_eqdeemph = {pipe_tx3_eqdeemph, pipe_tx2_eqdeemph, pipe_tx1_eqdeemph, pipe_tx0_eqdeemph};

 assign pipe_rx7_eqdone = 1'b0;
 assign pipe_rx6_eqdone = 1'b0;
 assign pipe_rx5_eqdone = 1'b0;
 assign pipe_rx4_eqdone = 1'b0;
 assign pipe_rx3_eqdone = {pipe_rx_eqdone[3]};
 assign pipe_rx2_eqdone = {pipe_rx_eqdone[2]};
 assign pipe_rx1_eqdone = {pipe_rx_eqdone[1]};
 assign pipe_rx0_eqdone = {pipe_rx_eqdone[0]};

 assign pipe_rx7_eq_adapt_done = 1'b0; 
 assign pipe_rx6_eq_adapt_done = 1'b0; 
 assign pipe_rx5_eq_adapt_done = 1'b0; 
 assign pipe_rx4_eq_adapt_done = 1'b0;  
 assign pipe_rx3_eq_adapt_done = {pipe_rx_eq_adapt_done[3]};
 assign pipe_rx2_eq_adapt_done = {pipe_rx_eq_adapt_done[2]};
 assign pipe_rx1_eq_adapt_done = {pipe_rx_eq_adapt_done[1]};
 assign pipe_rx0_eq_adapt_done = {pipe_rx_eq_adapt_done[0]}; 

 assign pipe_rx7_phy_status = 1'b0;
 assign pipe_rx6_phy_status = 1'b0;
 assign pipe_rx5_phy_status = 1'b0;
 assign pipe_rx4_phy_status = 1'b0; 
 assign pipe_rx3_phy_status = {pipe_rx_phy_status[3]};
 assign pipe_rx2_phy_status = {pipe_rx_phy_status[2]};
 assign pipe_rx1_phy_status = {pipe_rx_phy_status[1]};
 assign pipe_rx0_phy_status = {pipe_rx_phy_status[0]};

 assign pipe_rx7_eq_lffs_sel = 1'b0;
 assign pipe_rx6_eq_lffs_sel = 1'b0;
 assign pipe_rx5_eq_lffs_sel = 1'b0;
 assign pipe_rx4_eq_lffs_sel = 1'b0; 
 assign pipe_rx3_eq_lffs_sel = {pipe_rx_eq_lffs_sel[3]};
 assign pipe_rx2_eq_lffs_sel = {pipe_rx_eq_lffs_sel[2]};
 assign pipe_rx1_eq_lffs_sel = {pipe_rx_eq_lffs_sel[1]};
 assign pipe_rx0_eq_lffs_sel = {pipe_rx_eq_lffs_sel[0]};
 
 assign pipe_rx_eqcontrol = {pipe_rx3_eqcontrol, pipe_rx2_eqcontrol, pipe_rx1_eqcontrol, pipe_rx0_eqcontrol};
 assign pipe_rx_eqpreset = {pipe_rx3_eqpreset, pipe_rx2_eqpreset, pipe_rx1_eqpreset, pipe_rx0_eqpreset};
 assign pipe_rx_eq_lffs = {pipe_rx3_eq_lffs, pipe_rx2_eq_lffs, pipe_rx1_eq_lffs, pipe_rx0_eq_lffs};
 assign pipe_rx_eq_txpreset = {pipe_rx3_eq_txpreset, pipe_rx2_eq_txpreset, pipe_rx1_eq_txpreset, pipe_rx0_eq_txpreset};

end
else if (EXT_PIPE_SIM == "FALSE" && PL_LINK_CAP_MAX_LINK_WIDTH == 2)
begin
 assign pipe_txdata = {pipe_tx1_data, pipe_tx0_data};
 assign pipe_tx_char_is_k = {pipe_tx1_char_is_k, pipe_tx0_char_is_k};
 assign pipe_tx_data_valid = {pipe_tx1_data_valid, pipe_tx0_data_valid};
 assign pipe_tx_start_block = {pipe_tx1_start_block, pipe_tx0_start_block};
 assign pipe_tx_syncheader = {pipe_tx1_syncheader, pipe_tx0_syncheader};
 
 assign pipe_rx7_data = 32'b0;
 assign pipe_rx6_data = 32'b0;
 assign pipe_rx5_data = 32'b0;
 assign pipe_rx4_data = 32'b0;
 assign pipe_rx3_data = 32'b0;
 assign pipe_rx2_data = 32'b0;
 assign pipe_rx1_data = {pipe_rx_data[63:32]};
 assign pipe_rx0_data = {pipe_rx_data[31:0]};

 assign pipe_rx7_char_is_k = 2'b0;
 assign pipe_rx6_char_is_k = 2'b0;
 assign pipe_rx5_char_is_k = 2'b0;
 assign pipe_rx4_char_is_k = 2'b0;
 assign pipe_rx3_char_is_k = 2'b0;
 assign pipe_rx2_char_is_k = 2'b0; 
 assign pipe_rx1_char_is_k = {pipe_rx_char_is_k[3:2]};
 assign pipe_rx0_char_is_k = {pipe_rx_char_is_k[1:0]};
 
 assign pipe_rx7_eq_new_txcoeff = 18'b0;
 assign pipe_rx6_eq_new_txcoeff = 18'b0;
 assign pipe_rx5_eq_new_txcoeff = 18'b0;
 assign pipe_rx4_eq_new_txcoeff = 18'b0; 
 assign pipe_rx3_eq_new_txcoeff = 18'b0;  
 assign pipe_rx2_eq_new_txcoeff = 18'b0;  
 assign pipe_rx1_eq_new_txcoeff = {pipe_rx_eq_new_txcoeff[35:18]};
 assign pipe_rx0_eq_new_txcoeff = {pipe_rx_eq_new_txcoeff[17:0]}; 

 assign pipe_tx7_eqcoeff = 18'b0;
 assign pipe_tx6_eqcoeff = 18'b0;
 assign pipe_tx5_eqcoeff = 18'b0;
 assign pipe_tx4_eqcoeff = 18'b0; 
 assign pipe_tx3_eqcoeff = 18'b0; 
 assign pipe_tx2_eqcoeff = 18'b0; 
 assign pipe_tx1_eqcoeff = {pipe_tx_eqcoeff[35:18]};
 assign pipe_tx0_eqcoeff = {pipe_tx_eqcoeff[17:0]}; 

 assign pipe_rx7_status = 3'b0;
 assign pipe_rx6_status = 3'b0;
 assign pipe_rx5_status = 3'b0;
 assign pipe_rx4_status = 3'b0;
 assign pipe_rx3_status = 3'b0;
 assign pipe_rx2_status = 3'b0; 
 assign pipe_rx1_status = {pipe_rx_status[5:3]};
 assign pipe_rx0_status = {pipe_rx_status[2:0]};
 
 assign pipe_rx7_data_valid = 1'b0;  
 assign pipe_rx6_data_valid = 1'b0;  
 assign pipe_rx5_data_valid = 1'b0;  
 assign pipe_rx4_data_valid = 1'b0;  
 assign pipe_rx3_data_valid = 1'b0;  
 assign pipe_rx2_data_valid = 1'b0; 
 assign pipe_rx1_data_valid = {pipe_rx_data_valid[1]};
 assign pipe_rx0_data_valid = {pipe_rx_data_valid[0]};  

 assign pipe_rx7_elec_idle = 1'b0; 
 assign pipe_rx6_elec_idle = 1'b0; 
 assign pipe_rx5_elec_idle = 1'b0; 
 assign pipe_rx4_elec_idle = 1'b0; 
 assign pipe_rx3_elec_idle = 1'b0; 
 assign pipe_rx2_elec_idle = 1'b0;  
 assign pipe_rx1_elec_idle = {pipe_rx_elec_idle[1]};
 assign pipe_rx0_elec_idle = {pipe_rx_elec_idle[0]};  

 assign pipe_rx7_start_block = 1'b0;  
 assign pipe_rx6_start_block = 1'b0;  
 assign pipe_rx5_start_block = 1'b0;  
 assign pipe_rx4_start_block = 1'b0;  
 assign pipe_rx3_start_block = 1'b0;  
 assign pipe_rx2_start_block = 1'b0; 
 assign pipe_rx1_start_block = {pipe_rx_start_block[1]}; 
 assign pipe_rx0_start_block = {pipe_rx_start_block[0]};  

 assign pipe_rx7_syncheader = 2'b0;
 assign pipe_rx6_syncheader = 2'b0;
 assign pipe_rx5_syncheader = 2'b0;
 assign pipe_rx4_syncheader = 2'b0;
 assign pipe_rx3_syncheader = 2'b0;
 assign pipe_rx2_syncheader = 2'b0;
 assign pipe_rx1_syncheader = {pipe_rx_syncheader[3:2]};
 assign pipe_rx0_syncheader = {pipe_rx_syncheader[1:0]};
 
 assign pipe_tx7_eqdone = 1'b0;
 assign pipe_tx6_eqdone = 1'b0;
 assign pipe_tx5_eqdone = 1'b0;
 assign pipe_tx4_eqdone = 1'b0; 
 assign pipe_tx3_eqdone = 1'b0; 
 assign pipe_tx2_eqdone = 1'b0; 
 assign pipe_tx1_eqdone = {pipe_tx_eqdone[1]};
 assign pipe_tx0_eqdone = {pipe_tx_eqdone[0]};

 assign pipe_rx7_valid = 1'b0; 
 assign pipe_rx6_valid = 1'b0; 
 assign pipe_rx5_valid = 1'b0; 
 assign pipe_rx4_valid = 1'b0; 
 assign pipe_rx3_valid = 1'b0; 
 assign pipe_rx2_valid = 1'b0; 
 assign pipe_rx1_valid = {pipe_rx_valid[1]};
 assign pipe_rx0_valid = {pipe_rx_valid[0]}; 
 
 assign pipe_tx_elec_idle = {pipe_tx1_elec_idle, pipe_tx0_elec_idle};
 assign pipe_tx_compliance = {pipe_tx1_compliance, pipe_tx0_compliance};
 assign pipe_rx_polarity = {pipe_rx1_polarity, pipe_rx0_polarity};
 
 assign pipe_tx_eqcontrol = {pipe_tx1_eqcontrol, pipe_tx0_eqcontrol};
 assign pipe_tx_eqpreset = {pipe_tx1_eqpreset, pipe_tx0_eqpreset};
 assign pipe_tx_eqdeemph = { pipe_tx1_eqdeemph, pipe_tx0_eqdeemph};

 assign pipe_rx7_eqdone = 1'b0;
 assign pipe_rx6_eqdone = 1'b0;
 assign pipe_rx5_eqdone = 1'b0;
 assign pipe_rx4_eqdone = 1'b0;
 assign pipe_rx3_eqdone = 1'b0;
 assign pipe_rx2_eqdone = 1'b0;
 assign pipe_rx1_eqdone = {pipe_rx_eqdone[1]};
 assign pipe_rx0_eqdone = {pipe_rx_eqdone[0]};

 assign pipe_rx7_eq_adapt_done = 1'b0; 
 assign pipe_rx6_eq_adapt_done = 1'b0; 
 assign pipe_rx5_eq_adapt_done = 1'b0; 
 assign pipe_rx4_eq_adapt_done = 1'b0; 
 assign pipe_rx3_eq_adapt_done = 1'b0; 
 assign pipe_rx2_eq_adapt_done = 1'b0;  
 assign pipe_rx1_eq_adapt_done = {pipe_rx_eq_adapt_done[1]};
 assign pipe_rx0_eq_adapt_done = {pipe_rx_eq_adapt_done[0]}; 

 assign pipe_rx7_phy_status = 1'b0;
 assign pipe_rx6_phy_status = 1'b0;
 assign pipe_rx5_phy_status = 1'b0;
 assign pipe_rx4_phy_status = 1'b0;
 assign pipe_rx3_phy_status = 1'b0;
 assign pipe_rx2_phy_status = 1'b0; 
 assign pipe_rx1_phy_status = {pipe_rx_phy_status[1]};
 assign pipe_rx0_phy_status = {pipe_rx_phy_status[0]};

 assign pipe_rx7_eq_lffs_sel = 1'b0;
 assign pipe_rx6_eq_lffs_sel = 1'b0;
 assign pipe_rx5_eq_lffs_sel = 1'b0;
 assign pipe_rx4_eq_lffs_sel = 1'b0;
 assign pipe_rx3_eq_lffs_sel = 1'b0;
 assign pipe_rx2_eq_lffs_sel = 1'b0; 
 assign pipe_rx1_eq_lffs_sel = {pipe_rx_eq_lffs_sel[1]};
 assign pipe_rx0_eq_lffs_sel = {pipe_rx_eq_lffs_sel[0]};
 
 assign pipe_rx_eqcontrol = {pipe_rx1_eqcontrol, pipe_rx0_eqcontrol};
 assign pipe_rx_eqpreset = {pipe_rx1_eqpreset, pipe_rx0_eqpreset};
 assign pipe_rx_eq_lffs = {pipe_rx1_eq_lffs, pipe_rx0_eq_lffs};
 assign pipe_rx_eq_txpreset = {pipe_rx1_eq_txpreset, pipe_rx0_eq_txpreset}; 

 end
 else if (EXT_PIPE_SIM == "FALSE" && PL_LINK_CAP_MAX_LINK_WIDTH == 1)
 begin
 assign pipe_txdata = {pipe_tx0_data};
 assign pipe_tx_char_is_k = {pipe_tx0_char_is_k};
 assign pipe_tx_data_valid = {pipe_tx0_data_valid};
 assign pipe_tx_start_block = {pipe_tx0_start_block};
 assign pipe_tx_syncheader = {pipe_tx0_syncheader};
 
 assign pipe_rx7_data = 32'b0;
 assign pipe_rx6_data = 32'b0;
 assign pipe_rx5_data = 32'b0;
 assign pipe_rx4_data = 32'b0;
 assign pipe_rx3_data = 32'b0;
 assign pipe_rx2_data = 32'b0;
 assign pipe_rx1_data = 32'b0;
 assign pipe_rx0_data = {pipe_rx_data[31:0]};
 
 assign pipe_rx7_char_is_k = 2'b0;
 assign pipe_rx6_char_is_k = 2'b0;
 assign pipe_rx5_char_is_k = 2'b0;
 assign pipe_rx4_char_is_k = 2'b0;
 assign pipe_rx3_char_is_k = 2'b0;
 assign pipe_rx2_char_is_k = 2'b0;
 assign pipe_rx1_char_is_k = 2'b0;
 assign pipe_rx0_char_is_k = {pipe_rx_char_is_k[1:0]};
 
 assign pipe_rx7_eq_new_txcoeff = 18'b0;
 assign pipe_rx6_eq_new_txcoeff = 18'b0;
 assign pipe_rx5_eq_new_txcoeff = 18'b0;
 assign pipe_rx4_eq_new_txcoeff = 18'b0; 
 assign pipe_rx3_eq_new_txcoeff = 18'b0; 
 assign pipe_rx2_eq_new_txcoeff = 18'b0;  
 assign pipe_rx1_eq_new_txcoeff = 18'b0;  
 assign pipe_rx0_eq_new_txcoeff = {pipe_rx_eq_new_txcoeff[17:0]};  

 assign pipe_tx7_eqcoeff = 18'b0;
 assign pipe_tx6_eqcoeff = 18'b0;
 assign pipe_tx5_eqcoeff = 18'b0;
 assign pipe_tx4_eqcoeff = 18'b0; 
 assign pipe_tx3_eqcoeff = 18'b0; 
 assign pipe_tx2_eqcoeff = 18'b0;  
 assign pipe_tx1_eqcoeff = 18'b0;  
 assign pipe_tx0_eqcoeff = {pipe_tx_eqcoeff[17:0]}; 
 
 assign pipe_rx7_status = 3'b0;
 assign pipe_rx6_status = 3'b0;
 assign pipe_rx5_status = 3'b0;
 assign pipe_rx4_status = 3'b0;
 assign pipe_rx3_status = 3'b0;
 assign pipe_rx2_status = 3'b0;
 assign pipe_rx1_status = 3'b0;
 assign pipe_rx0_status = {pipe_rx_status[2:0]};
 
 assign pipe_rx7_data_valid = 1'b0;  
 assign pipe_rx6_data_valid = 1'b0;  
 assign pipe_rx5_data_valid = 1'b0;  
 assign pipe_rx4_data_valid = 1'b0;  
 assign pipe_rx3_data_valid = 1'b0;  
 assign pipe_rx2_data_valid = 1'b0;  
 assign pipe_rx1_data_valid = 1'b0;  
 assign pipe_rx0_data_valid = {pipe_rx_data_valid[0]};  
 
 assign pipe_rx7_elec_idle = 1'b0; 
 assign pipe_rx6_elec_idle = 1'b0; 
 assign pipe_rx5_elec_idle = 1'b0; 
 assign pipe_rx4_elec_idle = 1'b0; 
 assign pipe_rx3_elec_idle = 1'b0; 
 assign pipe_rx2_elec_idle = 1'b0; 
 assign pipe_rx1_elec_idle = 1'b0; 
 assign pipe_rx0_elec_idle = {pipe_rx_elec_idle[0]}; 
 
 assign pipe_rx7_start_block = 1'b0;  
 assign pipe_rx6_start_block = 1'b0;  
 assign pipe_rx5_start_block = 1'b0;  
 assign pipe_rx4_start_block = 1'b0;  
 assign pipe_rx3_start_block = 1'b0;  
 assign pipe_rx2_start_block = 1'b0;  
 assign pipe_rx1_start_block = 1'b0;  
 assign pipe_rx0_start_block = {pipe_rx_start_block[0]};  
 
 assign pipe_rx7_syncheader = 2'b0;
 assign pipe_rx6_syncheader = 2'b0;
 assign pipe_rx5_syncheader = 2'b0;
 assign pipe_rx4_syncheader = 2'b0;
 assign pipe_rx3_syncheader = 2'b0;
 assign pipe_rx2_syncheader = 2'b0;
 assign pipe_rx1_syncheader = 2'b0;
 assign pipe_rx0_syncheader = {pipe_rx_syncheader[1:0]};
 
 assign pipe_tx7_eqdone = 1'b0;
 assign pipe_tx6_eqdone = 1'b0;
 assign pipe_tx5_eqdone = 1'b0;
 assign pipe_tx4_eqdone = 1'b0; 
 assign pipe_tx3_eqdone = 1'b0; 
 assign pipe_tx2_eqdone = 1'b0;  
 assign pipe_tx1_eqdone = 1'b0;  
 assign pipe_tx0_eqdone = {pipe_tx_eqdone[0]};
 
 assign pipe_rx7_valid = 1'b0; 
 assign pipe_rx6_valid = 1'b0; 
 assign pipe_rx5_valid = 1'b0; 
 assign pipe_rx4_valid = 1'b0; 
 assign pipe_rx3_valid = 1'b0; 
 assign pipe_rx2_valid = 1'b0; 
 assign pipe_rx1_valid = 1'b0; 
 assign pipe_rx0_valid = {pipe_rx_valid[0]}; 
 
 assign pipe_tx_elec_idle = {pipe_tx0_elec_idle};
 assign pipe_tx_compliance = {pipe_tx0_compliance};
 assign pipe_rx_polarity = {pipe_rx0_polarity};
 
 assign pipe_tx_eqcontrol = {pipe_tx0_eqcontrol};
 assign pipe_tx_eqpreset = {pipe_tx0_eqpreset};
 assign pipe_tx_eqdeemph = {pipe_tx0_eqdeemph};

 assign pipe_rx7_eqdone = 1'b0;
 assign pipe_rx6_eqdone = 1'b0;
 assign pipe_rx5_eqdone = 1'b0;
 assign pipe_rx4_eqdone = 1'b0;
 assign pipe_rx3_eqdone = 1'b0;
 assign pipe_rx2_eqdone = 1'b0;
 assign pipe_rx1_eqdone = 1'b0;
 assign pipe_rx0_eqdone = {pipe_rx_eqdone[0]};
 
 assign pipe_rx7_eq_adapt_done = 1'b0; 
 assign pipe_rx6_eq_adapt_done = 1'b0; 
 assign pipe_rx5_eq_adapt_done = 1'b0; 
 assign pipe_rx4_eq_adapt_done = 1'b0; 
 assign pipe_rx3_eq_adapt_done = 1'b0; 
 assign pipe_rx2_eq_adapt_done = 1'b0; 
 assign pipe_rx1_eq_adapt_done = 1'b0; 
 assign pipe_rx0_eq_adapt_done = {pipe_rx_eq_adapt_done[0]}; 
 
 assign pipe_rx7_phy_status = 1'b0;
 assign pipe_rx6_phy_status = 1'b0;
 assign pipe_rx5_phy_status = 1'b0;
 assign pipe_rx4_phy_status = 1'b0;
 assign pipe_rx3_phy_status = 1'b0;
 assign pipe_rx2_phy_status = 1'b0;
 assign pipe_rx1_phy_status = 1'b0;
 assign pipe_rx0_phy_status = {pipe_rx_phy_status[0]};
 
 assign pipe_rx7_eq_lffs_sel = 1'b0;
 assign pipe_rx6_eq_lffs_sel = 1'b0;
 assign pipe_rx5_eq_lffs_sel = 1'b0;
 assign pipe_rx4_eq_lffs_sel = 1'b0;
 assign pipe_rx3_eq_lffs_sel = 1'b0;
 assign pipe_rx2_eq_lffs_sel = 1'b0;
 assign pipe_rx1_eq_lffs_sel = 1'b0;
 assign pipe_rx0_eq_lffs_sel = {pipe_rx_eq_lffs_sel[0]};
 
 assign pipe_rx_eqcontrol = {pipe_rx0_eqcontrol};
 assign pipe_rx_eqpreset = {pipe_rx0_eqpreset};
 assign pipe_rx_eq_lffs = {pipe_rx0_eq_lffs};
 assign pipe_rx_eq_txpreset = {pipe_rx0_eq_txpreset};
 end
 endgenerate

  // Tie-off unused signals
  assign conf_mcap_design_switch_o = 1'b1;
  assign np_req_wait = 6'b000000;
  assign startup_eos = 1'b0;
  assign startup_cfgclk = 1'b0;
  assign startup_cfgmclk = 1'b0;
  assign startup_di = 4'b0000;
  assign startup_preq = 1'b0;
  // Mux critical inputs so they remain constant during bitstream loading.
  // This is important for Tandem and PR configurations. For all other 
  // configurations the mux logic will be optimized and removed.
  assign cfg_dev_id_mux =               conf_mcap_design_switch ? cfg_dev_id : PF0_DEVICE_ID;
  assign cfg_rev_id_mux =               conf_mcap_design_switch ? cfg_rev_id : PF0_REVISION_ID;
  assign cfg_subsys_id_mux =            conf_mcap_design_switch ? cfg_subsys_id : PF0_SUBSYSTEM_ID;
  assign cfg_subsys_vend_id_mux =       conf_mcap_design_switch ? cfg_subsys_vend_id : PF0_SUBSYSTEM_VENDOR_ID;
  assign cfg_vend_id_mux =              conf_mcap_design_switch ? cfg_vend_id : PF0_VENDOR_ID;
  assign cfg_config_space_enable_mux =  conf_mcap_design_switch ? cfg_config_space_enable : 1'b1;
  assign cfg_link_training_enable_mux = conf_mcap_design_switch ? cfg_link_training_enable : 1'b1;
  assign cfg_interrupt_msix_int_mux =   conf_mcap_design_switch ? cfg_interrupt_msix_int : 1'b0;
  assign conf_req_valid_mux =           conf_mcap_design_switch ? conf_req_valid : 1'b0;
  assign drp_en_mux =                   conf_mcap_design_switch ? drp_en : 1'b0;
  assign gt_loopback_mux =              conf_mcap_design_switch ? gt_loopback : {(PL_LINK_CAP_MAX_LINK_WIDTH*3){1'b0}};
  assign gt_pcieuserratedone_mux =      conf_mcap_design_switch ? gt_pcieuserratedone : {(PL_LINK_CAP_MAX_LINK_WIDTH*1){1'b0}};
  assign gt_rxprbssel_mux =             conf_mcap_design_switch ? gt_rxprbssel : {(PL_LINK_CAP_MAX_LINK_WIDTH*4){1'b0}};
  assign gt_txprbssel_mux =             conf_mcap_design_switch ? gt_txprbssel : {(PL_LINK_CAP_MAX_LINK_WIDTH*4){1'b0}};
  assign pl_eq_reset_eieos_count_mux =  conf_mcap_design_switch ? pl_eq_reset_eieos_count : 1'b0;
  assign pl_gen2_upstream_prefer_deemph_mux = conf_mcap_design_switch ? pl_gen2_upstream_prefer_deemph : 1'b0;
  assign cfg_err_cor_in_mux =           conf_mcap_design_switch ? cfg_err_cor_in : 1'b0;
  assign cfg_err_uncor_in_mux =         conf_mcap_design_switch ? cfg_err_uncor_in : 1'b0;
  assign cfg_hot_reset_in_mux =         conf_mcap_design_switch ? cfg_hot_reset_in : 1'b0;
  assign cfg_flr_done_mux =             conf_mcap_design_switch ? cfg_flr_done : 4'hf;
  assign cfg_interrupt_int_mux =        conf_mcap_design_switch ? cfg_interrupt_int : 4'h0;
  assign cfg_interrupt_msi_int_mux =    conf_mcap_design_switch ? cfg_interrupt_msi_int : 32'h00000000;
  assign cfg_interrupt_msi_pending_status_data_enable_mux = conf_mcap_design_switch ? cfg_interrupt_msi_pending_status_data_enable : 1'b0;
  assign cfg_mgmt_write_mux =           conf_mcap_design_switch ? cfg_mgmt_write : 1'b0;
  assign cfg_msg_transmit_mux =         conf_mcap_design_switch ? cfg_msg_transmit : 1'b0;
  assign cfg_power_state_change_ack_mux = conf_mcap_design_switch ? cfg_power_state_change_ack : 1'b1;
  assign cfg_req_pm_transition_l23_ready_mux = conf_mcap_design_switch ? cfg_req_pm_transition_l23_ready : 1'b0;
  assign cfg_vf_flr_done_mux =          conf_mcap_design_switch ? cfg_vf_flr_done : 1'b1;
  assign ext_ch_gt_drpen_mux =          conf_mcap_design_switch ? ext_ch_gt_drpen : {(PL_LINK_CAP_MAX_LINK_WIDTH * 1){1'b0}};
  assign pcie_cq_np_req_mux =           conf_mcap_design_switch ? pcie_cq_np_req : np_req_wait[5];
  assign m_axis_rc_tready_mux =         conf_mcap_design_switch ? {22{m_axis_rc_tready}} : 22'h000000;
  assign m_axis_cq_tready_mux =         conf_mcap_design_switch ? {22{m_axis_cq_tready}} : 22'h000000;
  assign s_axis_rq_tvalid_mux =         conf_mcap_design_switch ? s_axis_rq_tvalid : 1'b0;
  assign s_axis_cc_tvalid_mux =         conf_mcap_design_switch ? s_axis_cc_tvalid : 1'b0;
 
  // Mux critical output so they remain constant during bitstream loading.
  // This is important for Tandem and PR configurations. For all other 
  // configurations the mux logic will be optimized and removed.
  assign m_axis_rc_tvalid = conf_mcap_design_switch ? m_axis_rc_tvalid_wire : 1'b0;
  assign m_axis_cq_tvalid = conf_mcap_design_switch ? m_axis_cq_tvalid_wire : 1'b0;
  assign s_axis_rq_tready = conf_mcap_design_switch ? s_axis_rq_tready_wire : 4'b0;
  assign s_axis_cc_tready = conf_mcap_design_switch ? s_axis_cc_tready_wire : 4'b0;
  assign conf_req_ready = conf_mcap_design_switch ? conf_req_ready_wire :1'b0;

//////////////////////////////////////////////STORE_LTSSM//////////////////////////////////////////////////

  (* mark_debug *) wire store_ltssm;
  reg   [5:0] ltssm_reg0 = 6'b0;
  reg   [5:0] ltssm_reg1 = 6'b0;
  reg   [5:0] ltssm_reg2 = 6'b0; 

  always@ (posedge user_clk)
  begin
    ltssm_reg0          <= cfg_ltssm_state;
    ltssm_reg1          <= ltssm_reg0;
    ltssm_reg2          <= ltssm_reg1;
    phase1              <= (ltssm_reg2 == 6'h29) ? 1'b1 : 1'b0;
  end

  assign store_ltssm     = (ltssm_reg2 != cfg_ltssm_state) ? 1'b1 : 1'b0; 

//
///////////////////////////////////////////////////////////////////////////////////////////////////////////
  //assign phase1 = (cfg_ltssm_state == 6'h29) ? 1'b1 : 1'b0;
///////////////////////////////////////////////////////////////////////////////////////////////////////////

  (* mark_debug *) reg [5:0] cfg_ltssm_state_reg0 = 6'b000000;
  always @ (posedge user_clk)
    begin
      cfg_ltssm_state_reg0 <= cfg_ltssm_state;
   end  
//
//

  localparam   MAX_WATCHDOG_CNT          = 20'h4FFFF;
  localparam   GEN_VALID_AT_WATCHDOG_CNT = 20'h40000; // timeout count rounded to nearest 2^n

  reg   [19:0] read_rcvd_watchDog_cnt = MAX_WATCHDOG_CNT;
  reg          cfg_ext_read_data_valid_dummy = 'h0;
  reg          cfg_ext_read_received_d1 = 'h0;
  wire         is_reg_num_cfg_ext_space;
  assign       is_reg_num_cfg_ext_space = (cfg_ext_register_number >= 'h10  && cfg_ext_register_number <= 'h1F) || 
                                          (cfg_ext_register_number >= 'h100 && cfg_ext_register_number <= 'h3FF);

  assign acs_cfg_ext_read_data = 32'b0;
  assign acs_cfg_ext_read_data_valid = 1'b0;

  // Mux Control for the two PCIe Extended Capabilities. Only one outstanding transaction is
  // aloud at a time. So a simple select mux on the cfg_ext_read_data is sufficient.
  assign cfg_ext_read_data_valid_int = acs_cfg_ext_read_data_valid | cfg_ext_read_data_valid | cfg_ext_read_data_valid_dummy;
  assign cfg_ext_read_data_int       = acs_cfg_ext_read_data_valid ? acs_cfg_ext_read_data : cfg_ext_read_data; 

  always @(posedge user_clk)
  begin
    if((cfg_ext_read_received && ~cfg_ext_read_received_d1) && (is_reg_num_cfg_ext_space)) // detecting the posedge of read_received
      read_rcvd_watchDog_cnt <= 'd0;
    else if (acs_cfg_ext_read_data_valid | cfg_ext_read_data_valid )
      read_rcvd_watchDog_cnt <= MAX_WATCHDOG_CNT;
    else if (read_rcvd_watchDog_cnt >= MAX_WATCHDOG_CNT)
      read_rcvd_watchDog_cnt <= read_rcvd_watchDog_cnt;
    else
      read_rcvd_watchDog_cnt <= read_rcvd_watchDog_cnt + 1'b1;

    cfg_ext_read_data_valid_dummy <= (read_rcvd_watchDog_cnt == GEN_VALID_AT_WATCHDOG_CNT) ? 1'b1 : 1'b0;
    cfg_ext_read_received_d1      <= cfg_ext_read_received;

  end
 



  
  assign pipe_tx_rate_i = pipe_tx_rate_o;
 
 assign phy_rdy_out = phy_rdy;
///////////////////////////////////////////////////////////////////////////////////////////////////////////
endmodule
