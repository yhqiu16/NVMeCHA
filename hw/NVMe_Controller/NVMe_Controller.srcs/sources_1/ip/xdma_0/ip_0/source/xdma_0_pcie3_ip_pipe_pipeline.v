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
// File       : xdma_0_pcie3_ip_pipe_pipeline.v
// Version    : 4.4 
//-----------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////

`timescale 1ps/1ps

module xdma_0_pcie3_ip_pipe_pipeline 
 #(
  parameter TCQ = 100,
  parameter PIPE_PIPELINE_STAGES = 0,
  parameter PL_LINK_CAP_MAX_LINK_WIDTH = 8
  ) (
  input  wire         pipe_tx_rcvr_det_i,
  input  wire         pipe_tx_reset_i,
  input  wire   [1:0] pipe_tx_rate_i,
  input  wire         pipe_tx_deemph_i,
  input  wire   [2:0] pipe_tx_margin_i,
  input  wire         pipe_tx_swing_i,
  input  wire   [5:0] pipe_tx_eqfs_i,
  input  wire   [5:0] pipe_tx_eqlf_i,
  output wire         pipe_tx_rcvr_det_o,
  output wire         pipe_tx_reset_o,
  output wire   [1:0] pipe_tx_rate_o,
  output wire         pipe_tx_deemph_o,
  output wire   [2:0] pipe_tx_margin_o,
  output wire         pipe_tx_swing_o,
  output wire   [5:0] pipe_tx_eqfs_o,
  output wire   [5:0] pipe_tx_eqlf_o,
  output wire   [1:0] pipe_rx0_char_is_k_o,
  output wire  [31:0] pipe_rx0_data_o,
  output wire         pipe_rx0_valid_o,
  output wire         pipe_rx0_data_valid_o,
  output wire   [2:0] pipe_rx0_status_o,
  output wire         pipe_rx0_phy_status_o,
  output wire         pipe_rx0_elec_idle_o,
  output wire         pipe_rx0_eqdone_o,
  output wire         pipe_rx0_eqlpadaptdone_o,
  output wire         pipe_rx0_eqlplffssel_o,
  output wire  [17:0] pipe_rx0_eqlpnewtxcoefforpreset_o,
  output wire         pipe_rx0_startblock_o,
  output wire   [1:0] pipe_rx0_syncheader_o,
  input  wire         pipe_rx0_polarity_i,
  input  wire   [1:0] pipe_rx0_eqcontrol_i,
  input  wire   [5:0] pipe_rx0_eqlplffs_i,
  input  wire   [3:0] pipe_rx0_eqlptxpreset_i,
  input  wire   [2:0] pipe_rx0_eqpreset_i,
  output wire  [17:0] pipe_tx0_eqcoeff_o,
  output wire         pipe_tx0_eqdone_o,
  input  wire         pipe_tx0_compliance_i,
  input  wire   [1:0] pipe_tx0_char_is_k_i,
  input  wire  [31:0] pipe_tx0_data_i,
  input  wire         pipe_tx0_elec_idle_i,
  input  wire   [1:0] pipe_tx0_powerdown_i,
  input  wire         pipe_tx0_datavalid_i,
  input  wire         pipe_tx0_startblock_i,
  input  wire   [1:0] pipe_tx0_syncheader_i,
  input  wire   [1:0] pipe_tx0_eqcontrol_i,
  input  wire   [5:0] pipe_tx0_eqdeemph_i,
  input  wire   [3:0] pipe_tx0_eqpreset_i,
  input  wire   [1:0] pipe_rx0_char_is_k_i,
  input  wire  [31:0] pipe_rx0_data_i,
  input  wire         pipe_rx0_valid_i,
  input  wire         pipe_rx0_data_valid_i,
  input  wire   [2:0] pipe_rx0_status_i,
  input  wire         pipe_rx0_phy_status_i,
  input  wire         pipe_rx0_elec_idle_i,
  input  wire         pipe_rx0_eqdone_i,
  input  wire         pipe_rx0_eqlpadaptdone_i,
  input  wire         pipe_rx0_eqlplffssel_i,
  input  wire  [17:0] pipe_rx0_eqlpnewtxcoefforpreset_i,
  input  wire         pipe_rx0_startblock_i,
  input  wire   [1:0] pipe_rx0_syncheader_i,
  output wire         pipe_rx0_polarity_o,
  output wire   [1:0] pipe_rx0_eqcontrol_o,
  output wire   [5:0] pipe_rx0_eqlplffs_o,
  output wire   [3:0] pipe_rx0_eqlptxpreset_o,
  output wire   [2:0] pipe_rx0_eqpreset_o,
  input  wire  [17:0] pipe_tx0_eqcoeff_i,
  input  wire         pipe_tx0_eqdone_i,
  output wire         pipe_tx0_compliance_o,
  output wire   [1:0] pipe_tx0_char_is_k_o,
  output wire  [31:0] pipe_tx0_data_o,
  output wire         pipe_tx0_elec_idle_o,
  output wire   [1:0] pipe_tx0_powerdown_o,
  output wire         pipe_tx0_datavalid_o,
  output wire         pipe_tx0_startblock_o,
  output wire   [1:0] pipe_tx0_syncheader_o,
  output wire   [1:0] pipe_tx0_eqcontrol_o,
  output wire   [5:0] pipe_tx0_eqdeemph_o,
  output wire   [3:0] pipe_tx0_eqpreset_o,
  output wire   [1:0] pipe_rx1_char_is_k_o,
  output wire  [31:0] pipe_rx1_data_o,
  output wire         pipe_rx1_valid_o,
  output wire         pipe_rx1_data_valid_o,
  output wire   [2:0] pipe_rx1_status_o,
  output wire         pipe_rx1_phy_status_o,
  output wire         pipe_rx1_elec_idle_o,
  output wire         pipe_rx1_eqdone_o,
  output wire         pipe_rx1_eqlpadaptdone_o,
  output wire         pipe_rx1_eqlplffssel_o,
  output wire  [17:0] pipe_rx1_eqlpnewtxcoefforpreset_o,
  output wire         pipe_rx1_startblock_o,
  output wire   [1:0] pipe_rx1_syncheader_o,
  input  wire         pipe_rx1_polarity_i,
  input  wire   [1:0] pipe_rx1_eqcontrol_i,
  input  wire   [5:0] pipe_rx1_eqlplffs_i,
  input  wire   [3:0] pipe_rx1_eqlptxpreset_i,
  input  wire   [2:0] pipe_rx1_eqpreset_i,
  output wire  [17:0] pipe_tx1_eqcoeff_o,
  output wire         pipe_tx1_eqdone_o,
  input  wire         pipe_tx1_compliance_i,
  input  wire   [1:0] pipe_tx1_char_is_k_i,
  input  wire  [31:0] pipe_tx1_data_i,
  input  wire         pipe_tx1_elec_idle_i,
  input  wire   [1:0] pipe_tx1_powerdown_i,
  input  wire         pipe_tx1_datavalid_i,
  input  wire         pipe_tx1_startblock_i,
  input  wire   [1:0] pipe_tx1_syncheader_i,
  input  wire   [1:0] pipe_tx1_eqcontrol_i,
  input  wire   [5:0] pipe_tx1_eqdeemph_i,
  input  wire   [3:0] pipe_tx1_eqpreset_i,
  input  wire   [1:0] pipe_rx1_char_is_k_i,
  input  wire  [31:0] pipe_rx1_data_i,
  input  wire         pipe_rx1_valid_i,
  input  wire         pipe_rx1_data_valid_i,
  input  wire   [2:0] pipe_rx1_status_i,
  input  wire         pipe_rx1_phy_status_i,
  input  wire         pipe_rx1_elec_idle_i,
  input  wire         pipe_rx1_eqdone_i,
  input  wire         pipe_rx1_eqlpadaptdone_i,
  input  wire         pipe_rx1_eqlplffssel_i,
  input  wire  [17:0] pipe_rx1_eqlpnewtxcoefforpreset_i,
  input  wire         pipe_rx1_startblock_i,
  input  wire   [1:0] pipe_rx1_syncheader_i,
  output wire         pipe_rx1_polarity_o,
  output wire   [1:0] pipe_rx1_eqcontrol_o,
  output wire   [5:0] pipe_rx1_eqlplffs_o,
  output wire   [3:0] pipe_rx1_eqlptxpreset_o,
  output wire   [2:0] pipe_rx1_eqpreset_o,
  input  wire  [17:0] pipe_tx1_eqcoeff_i,
  input  wire         pipe_tx1_eqdone_i,
  output wire         pipe_tx1_compliance_o,
  output wire   [1:0] pipe_tx1_char_is_k_o,
  output wire  [31:0] pipe_tx1_data_o,
  output wire         pipe_tx1_elec_idle_o,
  output wire   [1:0] pipe_tx1_powerdown_o,
  output wire         pipe_tx1_datavalid_o,
  output wire         pipe_tx1_startblock_o,
  output wire   [1:0] pipe_tx1_syncheader_o,
  output wire   [1:0] pipe_tx1_eqcontrol_o,
  output wire   [5:0] pipe_tx1_eqdeemph_o,
  output wire   [3:0] pipe_tx1_eqpreset_o,
  output wire   [1:0] pipe_rx2_char_is_k_o,
  output wire  [31:0] pipe_rx2_data_o,
  output wire         pipe_rx2_valid_o,
  output wire         pipe_rx2_data_valid_o,
  output wire   [2:0] pipe_rx2_status_o,
  output wire         pipe_rx2_phy_status_o,
  output wire         pipe_rx2_elec_idle_o,
  output wire         pipe_rx2_eqdone_o,
  output wire         pipe_rx2_eqlpadaptdone_o,
  output wire         pipe_rx2_eqlplffssel_o,
  output wire  [17:0] pipe_rx2_eqlpnewtxcoefforpreset_o,
  output wire         pipe_rx2_startblock_o,
  output wire   [1:0] pipe_rx2_syncheader_o,
  input  wire         pipe_rx2_polarity_i,
  input  wire   [1:0] pipe_rx2_eqcontrol_i,
  input  wire   [5:0] pipe_rx2_eqlplffs_i,
  input  wire   [3:0] pipe_rx2_eqlptxpreset_i,
  input  wire   [2:0] pipe_rx2_eqpreset_i,
  output wire  [17:0] pipe_tx2_eqcoeff_o,
  output wire         pipe_tx2_eqdone_o,
  input  wire         pipe_tx2_compliance_i,
  input  wire   [1:0] pipe_tx2_char_is_k_i,
  input  wire  [31:0] pipe_tx2_data_i,
  input  wire         pipe_tx2_elec_idle_i,
  input  wire   [1:0] pipe_tx2_powerdown_i,
  input  wire         pipe_tx2_datavalid_i,
  input  wire         pipe_tx2_startblock_i,
  input  wire   [1:0] pipe_tx2_syncheader_i,
  input  wire   [1:0] pipe_tx2_eqcontrol_i,
  input  wire   [5:0] pipe_tx2_eqdeemph_i,
  input  wire   [3:0] pipe_tx2_eqpreset_i,
  input  wire   [1:0] pipe_rx2_char_is_k_i,
  input  wire  [31:0] pipe_rx2_data_i,
  input  wire         pipe_rx2_valid_i,
  input  wire         pipe_rx2_data_valid_i,
  input  wire   [2:0] pipe_rx2_status_i,
  input  wire         pipe_rx2_phy_status_i,
  input  wire         pipe_rx2_elec_idle_i,
  input  wire         pipe_rx2_eqdone_i,
  input  wire         pipe_rx2_eqlpadaptdone_i,
  input  wire         pipe_rx2_eqlplffssel_i,
  input  wire  [17:0] pipe_rx2_eqlpnewtxcoefforpreset_i,
  input  wire         pipe_rx2_startblock_i,
  input  wire   [1:0] pipe_rx2_syncheader_i,
  output wire         pipe_rx2_polarity_o,
  output wire   [1:0] pipe_rx2_eqcontrol_o,
  output wire   [5:0] pipe_rx2_eqlplffs_o,
  output wire   [3:0] pipe_rx2_eqlptxpreset_o,
  output wire   [2:0] pipe_rx2_eqpreset_o,
  input  wire  [17:0] pipe_tx2_eqcoeff_i,
  input  wire         pipe_tx2_eqdone_i,
  output wire         pipe_tx2_compliance_o,
  output wire   [1:0] pipe_tx2_char_is_k_o,
  output wire  [31:0] pipe_tx2_data_o,
  output wire         pipe_tx2_elec_idle_o,
  output wire   [1:0] pipe_tx2_powerdown_o,
  output wire         pipe_tx2_datavalid_o,
  output wire         pipe_tx2_startblock_o,
  output wire   [1:0] pipe_tx2_syncheader_o,
  output wire   [1:0] pipe_tx2_eqcontrol_o,
  output wire   [5:0] pipe_tx2_eqdeemph_o,
  output wire   [3:0] pipe_tx2_eqpreset_o,
  output wire   [1:0] pipe_rx3_char_is_k_o,
  output wire  [31:0] pipe_rx3_data_o,
  output wire         pipe_rx3_valid_o,
  output wire         pipe_rx3_data_valid_o,
  output wire   [2:0] pipe_rx3_status_o,
  output wire         pipe_rx3_phy_status_o,
  output wire         pipe_rx3_elec_idle_o,
  output wire         pipe_rx3_eqdone_o,
  output wire         pipe_rx3_eqlpadaptdone_o,
  output wire         pipe_rx3_eqlplffssel_o,
  output wire  [17:0] pipe_rx3_eqlpnewtxcoefforpreset_o,
  output wire         pipe_rx3_startblock_o,
  output wire   [1:0] pipe_rx3_syncheader_o,
  input  wire         pipe_rx3_polarity_i,
  input  wire   [1:0] pipe_rx3_eqcontrol_i,
  input  wire   [5:0] pipe_rx3_eqlplffs_i,
  input  wire   [3:0] pipe_rx3_eqlptxpreset_i,
  input  wire   [2:0] pipe_rx3_eqpreset_i,
  output wire  [17:0] pipe_tx3_eqcoeff_o,
  output wire         pipe_tx3_eqdone_o,
  input  wire         pipe_tx3_compliance_i,
  input  wire   [1:0] pipe_tx3_char_is_k_i,
  input  wire  [31:0] pipe_tx3_data_i,
  input  wire         pipe_tx3_elec_idle_i,
  input  wire   [1:0] pipe_tx3_powerdown_i,
  input  wire         pipe_tx3_datavalid_i,
  input  wire         pipe_tx3_startblock_i,
  input  wire   [1:0] pipe_tx3_syncheader_i,
  input  wire   [1:0] pipe_tx3_eqcontrol_i,
  input  wire   [5:0] pipe_tx3_eqdeemph_i,
  input  wire   [3:0] pipe_tx3_eqpreset_i,
  input  wire   [1:0] pipe_rx3_char_is_k_i,
  input  wire  [31:0] pipe_rx3_data_i,
  input  wire         pipe_rx3_valid_i,
  input  wire         pipe_rx3_data_valid_i,
  input  wire   [2:0] pipe_rx3_status_i,
  input  wire         pipe_rx3_phy_status_i,
  input  wire         pipe_rx3_elec_idle_i,
  input  wire         pipe_rx3_eqdone_i,
  input  wire         pipe_rx3_eqlpadaptdone_i,
  input  wire         pipe_rx3_eqlplffssel_i,
  input  wire  [17:0] pipe_rx3_eqlpnewtxcoefforpreset_i,
  input  wire         pipe_rx3_startblock_i,
  input  wire   [1:0] pipe_rx3_syncheader_i,
  output wire         pipe_rx3_polarity_o,
  output wire   [1:0] pipe_rx3_eqcontrol_o,
  output wire   [5:0] pipe_rx3_eqlplffs_o,
  output wire   [3:0] pipe_rx3_eqlptxpreset_o,
  output wire   [2:0] pipe_rx3_eqpreset_o,
  input  wire  [17:0] pipe_tx3_eqcoeff_i,
  input  wire         pipe_tx3_eqdone_i,
  output wire         pipe_tx3_compliance_o,
  output wire   [1:0] pipe_tx3_char_is_k_o,
  output wire  [31:0] pipe_tx3_data_o,
  output wire         pipe_tx3_elec_idle_o,
  output wire   [1:0] pipe_tx3_powerdown_o,
  output wire         pipe_tx3_datavalid_o,
  output wire         pipe_tx3_startblock_o,
  output wire   [1:0] pipe_tx3_syncheader_o,
  output wire   [1:0] pipe_tx3_eqcontrol_o,
  output wire   [5:0] pipe_tx3_eqdeemph_o,
  output wire   [3:0] pipe_tx3_eqpreset_o,
  output wire   [1:0] pipe_rx4_char_is_k_o,
  output wire  [31:0] pipe_rx4_data_o,
  output wire         pipe_rx4_valid_o,
  output wire         pipe_rx4_data_valid_o,
  output wire   [2:0] pipe_rx4_status_o,
  output wire         pipe_rx4_phy_status_o,
  output wire         pipe_rx4_elec_idle_o,
  output wire         pipe_rx4_eqdone_o,
  output wire         pipe_rx4_eqlpadaptdone_o,
  output wire         pipe_rx4_eqlplffssel_o,
  output wire  [17:0] pipe_rx4_eqlpnewtxcoefforpreset_o,
  output wire         pipe_rx4_startblock_o,
  output wire   [1:0] pipe_rx4_syncheader_o,
  input  wire         pipe_rx4_polarity_i,
  input  wire   [1:0] pipe_rx4_eqcontrol_i,
  input  wire   [5:0] pipe_rx4_eqlplffs_i,
  input  wire   [3:0] pipe_rx4_eqlptxpreset_i,
  input  wire   [2:0] pipe_rx4_eqpreset_i,
  output wire  [17:0] pipe_tx4_eqcoeff_o,
  output wire         pipe_tx4_eqdone_o,
  input  wire         pipe_tx4_compliance_i,
  input  wire   [1:0] pipe_tx4_char_is_k_i,
  input  wire  [31:0] pipe_tx4_data_i,
  input  wire         pipe_tx4_elec_idle_i,
  input  wire   [1:0] pipe_tx4_powerdown_i,
  input  wire         pipe_tx4_datavalid_i,
  input  wire         pipe_tx4_startblock_i,
  input  wire   [1:0] pipe_tx4_syncheader_i,
  input  wire   [1:0] pipe_tx4_eqcontrol_i,
  input  wire   [5:0] pipe_tx4_eqdeemph_i,
  input  wire   [3:0] pipe_tx4_eqpreset_i,
  input  wire   [1:0] pipe_rx4_char_is_k_i,
  input  wire  [31:0] pipe_rx4_data_i,
  input  wire         pipe_rx4_valid_i,
  input  wire         pipe_rx4_data_valid_i,
  input  wire   [2:0] pipe_rx4_status_i,
  input  wire         pipe_rx4_phy_status_i,
  input  wire         pipe_rx4_elec_idle_i,
  input  wire         pipe_rx4_eqdone_i,
  input  wire         pipe_rx4_eqlpadaptdone_i,
  input  wire         pipe_rx4_eqlplffssel_i,
  input  wire  [17:0] pipe_rx4_eqlpnewtxcoefforpreset_i,
  input  wire         pipe_rx4_startblock_i,
  input  wire   [1:0] pipe_rx4_syncheader_i,
  output wire         pipe_rx4_polarity_o,
  output wire   [1:0] pipe_rx4_eqcontrol_o,
  output wire   [5:0] pipe_rx4_eqlplffs_o,
  output wire   [3:0] pipe_rx4_eqlptxpreset_o,
  output wire   [2:0] pipe_rx4_eqpreset_o,
  input  wire  [17:0] pipe_tx4_eqcoeff_i,
  input  wire         pipe_tx4_eqdone_i,
  output wire         pipe_tx4_compliance_o,
  output wire   [1:0] pipe_tx4_char_is_k_o,
  output wire  [31:0] pipe_tx4_data_o,
  output wire         pipe_tx4_elec_idle_o,
  output wire   [1:0] pipe_tx4_powerdown_o,
  output wire         pipe_tx4_datavalid_o,
  output wire         pipe_tx4_startblock_o,
  output wire   [1:0] pipe_tx4_syncheader_o,
  output wire   [1:0] pipe_tx4_eqcontrol_o,
  output wire   [5:0] pipe_tx4_eqdeemph_o,
  output wire   [3:0] pipe_tx4_eqpreset_o,
  output wire   [1:0] pipe_rx5_char_is_k_o,
  output wire  [31:0] pipe_rx5_data_o,
  output wire         pipe_rx5_valid_o,
  output wire         pipe_rx5_data_valid_o,
  output wire   [2:0] pipe_rx5_status_o,
  output wire         pipe_rx5_phy_status_o,
  output wire         pipe_rx5_elec_idle_o,
  output wire         pipe_rx5_eqdone_o,
  output wire         pipe_rx5_eqlpadaptdone_o,
  output wire         pipe_rx5_eqlplffssel_o,
  output wire  [17:0] pipe_rx5_eqlpnewtxcoefforpreset_o,
  output wire         pipe_rx5_startblock_o,
  output wire   [1:0] pipe_rx5_syncheader_o,
  input  wire         pipe_rx5_polarity_i,
  input  wire   [1:0] pipe_rx5_eqcontrol_i,
  input  wire   [5:0] pipe_rx5_eqlplffs_i,
  input  wire   [3:0] pipe_rx5_eqlptxpreset_i,
  input  wire   [2:0] pipe_rx5_eqpreset_i,
  output wire  [17:0] pipe_tx5_eqcoeff_o,
  output wire         pipe_tx5_eqdone_o,
  input  wire         pipe_tx5_compliance_i,
  input  wire   [1:0] pipe_tx5_char_is_k_i,
  input  wire  [31:0] pipe_tx5_data_i,
  input  wire         pipe_tx5_elec_idle_i,
  input  wire   [1:0] pipe_tx5_powerdown_i,
  input  wire         pipe_tx5_datavalid_i,
  input  wire         pipe_tx5_startblock_i,
  input  wire   [1:0] pipe_tx5_syncheader_i,
  input  wire   [1:0] pipe_tx5_eqcontrol_i,
  input  wire   [5:0] pipe_tx5_eqdeemph_i,
  input  wire   [3:0] pipe_tx5_eqpreset_i,
  input  wire   [1:0] pipe_rx5_char_is_k_i,
  input  wire  [31:0] pipe_rx5_data_i,
  input  wire         pipe_rx5_valid_i,
  input  wire         pipe_rx5_data_valid_i,
  input  wire   [2:0] pipe_rx5_status_i,
  input  wire         pipe_rx5_phy_status_i,
  input  wire         pipe_rx5_elec_idle_i,
  input  wire         pipe_rx5_eqdone_i,
  input  wire         pipe_rx5_eqlpadaptdone_i,
  input  wire         pipe_rx5_eqlplffssel_i,
  input  wire  [17:0] pipe_rx5_eqlpnewtxcoefforpreset_i,
  input  wire         pipe_rx5_startblock_i,
  input  wire   [1:0] pipe_rx5_syncheader_i,
  output wire         pipe_rx5_polarity_o,
  output wire   [1:0] pipe_rx5_eqcontrol_o,
  output wire   [5:0] pipe_rx5_eqlplffs_o,
  output wire   [3:0] pipe_rx5_eqlptxpreset_o,
  output wire   [2:0] pipe_rx5_eqpreset_o,
  input  wire  [17:0] pipe_tx5_eqcoeff_i,
  input  wire         pipe_tx5_eqdone_i,
  output wire         pipe_tx5_compliance_o,
  output wire   [1:0] pipe_tx5_char_is_k_o,
  output wire  [31:0] pipe_tx5_data_o,
  output wire         pipe_tx5_elec_idle_o,
  output wire   [1:0] pipe_tx5_powerdown_o,
  output wire         pipe_tx5_datavalid_o,
  output wire         pipe_tx5_startblock_o,
  output wire   [1:0] pipe_tx5_syncheader_o,
  output wire   [1:0] pipe_tx5_eqcontrol_o,
  output wire   [5:0] pipe_tx5_eqdeemph_o,
  output wire   [3:0] pipe_tx5_eqpreset_o,
  output wire   [1:0] pipe_rx6_char_is_k_o,
  output wire  [31:0] pipe_rx6_data_o,
  output wire         pipe_rx6_valid_o,
  output wire         pipe_rx6_data_valid_o,
  output wire   [2:0] pipe_rx6_status_o,
  output wire         pipe_rx6_phy_status_o,
  output wire         pipe_rx6_elec_idle_o,
  output wire         pipe_rx6_eqdone_o,
  output wire         pipe_rx6_eqlpadaptdone_o,
  output wire         pipe_rx6_eqlplffssel_o,
  output wire  [17:0] pipe_rx6_eqlpnewtxcoefforpreset_o,
  output wire         pipe_rx6_startblock_o,
  output wire   [1:0] pipe_rx6_syncheader_o,
  input  wire         pipe_rx6_polarity_i,
  input  wire   [1:0] pipe_rx6_eqcontrol_i,
  input  wire   [5:0] pipe_rx6_eqlplffs_i,
  input  wire   [3:0] pipe_rx6_eqlptxpreset_i,
  input  wire   [2:0] pipe_rx6_eqpreset_i,
  output wire  [17:0] pipe_tx6_eqcoeff_o,
  output wire         pipe_tx6_eqdone_o,
  input  wire         pipe_tx6_compliance_i,
  input  wire   [1:0] pipe_tx6_char_is_k_i,
  input  wire  [31:0] pipe_tx6_data_i,
  input  wire         pipe_tx6_elec_idle_i,
  input  wire   [1:0] pipe_tx6_powerdown_i,
  input  wire         pipe_tx6_datavalid_i,
  input  wire         pipe_tx6_startblock_i,
  input  wire   [1:0] pipe_tx6_syncheader_i,
  input  wire   [1:0] pipe_tx6_eqcontrol_i,
  input  wire   [5:0] pipe_tx6_eqdeemph_i,
  input  wire   [3:0] pipe_tx6_eqpreset_i,
  input  wire   [1:0] pipe_rx6_char_is_k_i,
  input  wire  [31:0] pipe_rx6_data_i,
  input  wire         pipe_rx6_valid_i,
  input  wire         pipe_rx6_data_valid_i,
  input  wire   [2:0] pipe_rx6_status_i,
  input  wire         pipe_rx6_phy_status_i,
  input  wire         pipe_rx6_elec_idle_i,
  input  wire         pipe_rx6_eqdone_i,
  input  wire         pipe_rx6_eqlpadaptdone_i,
  input  wire         pipe_rx6_eqlplffssel_i,
  input  wire  [17:0] pipe_rx6_eqlpnewtxcoefforpreset_i,
  input  wire         pipe_rx6_startblock_i,
  input  wire   [1:0] pipe_rx6_syncheader_i,
  output wire         pipe_rx6_polarity_o,
  output wire   [1:0] pipe_rx6_eqcontrol_o,
  output wire   [5:0] pipe_rx6_eqlplffs_o,
  output wire   [3:0] pipe_rx6_eqlptxpreset_o,
  output wire   [2:0] pipe_rx6_eqpreset_o,
  input  wire  [17:0] pipe_tx6_eqcoeff_i,
  input  wire         pipe_tx6_eqdone_i,
  output wire         pipe_tx6_compliance_o,
  output wire   [1:0] pipe_tx6_char_is_k_o,
  output wire  [31:0] pipe_tx6_data_o,
  output wire         pipe_tx6_elec_idle_o,
  output wire   [1:0] pipe_tx6_powerdown_o,
  output wire         pipe_tx6_datavalid_o,
  output wire         pipe_tx6_startblock_o,
  output wire   [1:0] pipe_tx6_syncheader_o,
  output wire   [1:0] pipe_tx6_eqcontrol_o,
  output wire   [5:0] pipe_tx6_eqdeemph_o,
  output wire   [3:0] pipe_tx6_eqpreset_o,
  output wire   [1:0] pipe_rx7_char_is_k_o,
  output wire  [31:0] pipe_rx7_data_o,
  output wire         pipe_rx7_valid_o,
  output wire         pipe_rx7_data_valid_o,
  output wire   [2:0] pipe_rx7_status_o,
  output wire         pipe_rx7_phy_status_o,
  output wire         pipe_rx7_elec_idle_o,
  output wire         pipe_rx7_eqdone_o,
  output wire         pipe_rx7_eqlpadaptdone_o,
  output wire         pipe_rx7_eqlplffssel_o,
  output wire  [17:0] pipe_rx7_eqlpnewtxcoefforpreset_o,
  output wire         pipe_rx7_startblock_o,
  output wire   [1:0] pipe_rx7_syncheader_o,
  input  wire         pipe_rx7_polarity_i,
  input  wire   [1:0] pipe_rx7_eqcontrol_i,
  input  wire   [5:0] pipe_rx7_eqlplffs_i,
  input  wire   [3:0] pipe_rx7_eqlptxpreset_i,
  input  wire   [2:0] pipe_rx7_eqpreset_i,
  output wire  [17:0] pipe_tx7_eqcoeff_o,
  output wire         pipe_tx7_eqdone_o,
  input  wire         pipe_tx7_compliance_i,
  input  wire   [1:0] pipe_tx7_char_is_k_i,
  input  wire  [31:0] pipe_tx7_data_i,
  input  wire         pipe_tx7_elec_idle_i,
  input  wire   [1:0] pipe_tx7_powerdown_i,
  input  wire         pipe_tx7_datavalid_i,
  input  wire         pipe_tx7_startblock_i,
  input  wire   [1:0] pipe_tx7_syncheader_i,
  input  wire   [1:0] pipe_tx7_eqcontrol_i,
  input  wire   [5:0] pipe_tx7_eqdeemph_i,
  input  wire   [3:0] pipe_tx7_eqpreset_i,
  input  wire   [1:0] pipe_rx7_char_is_k_i,
  input  wire  [31:0] pipe_rx7_data_i,
  input  wire         pipe_rx7_valid_i,
  input  wire         pipe_rx7_data_valid_i,
  input  wire   [2:0] pipe_rx7_status_i,
  input  wire         pipe_rx7_phy_status_i,
  input  wire         pipe_rx7_elec_idle_i,
  input  wire         pipe_rx7_eqdone_i,
  input  wire         pipe_rx7_eqlpadaptdone_i,
  input  wire         pipe_rx7_eqlplffssel_i,
  input  wire  [17:0] pipe_rx7_eqlpnewtxcoefforpreset_i,
  input  wire         pipe_rx7_startblock_i,
  input  wire   [1:0] pipe_rx7_syncheader_i,
  output wire         pipe_rx7_polarity_o,
  output wire   [1:0] pipe_rx7_eqcontrol_o,
  output wire   [5:0] pipe_rx7_eqlplffs_o,
  output wire   [3:0] pipe_rx7_eqlptxpreset_o,
  output wire   [2:0] pipe_rx7_eqpreset_o,
  input  wire  [17:0] pipe_tx7_eqcoeff_i,
  input  wire         pipe_tx7_eqdone_i,
  output wire         pipe_tx7_compliance_o,
  output wire   [1:0] pipe_tx7_char_is_k_o,
  output wire  [31:0] pipe_tx7_data_o,
  output wire         pipe_tx7_elec_idle_o,
  output wire   [1:0] pipe_tx7_powerdown_o,
  output wire         pipe_tx7_datavalid_o,
  output wire         pipe_tx7_startblock_o,
  output wire   [1:0] pipe_tx7_syncheader_o,
  output wire   [1:0] pipe_tx7_eqcontrol_o,
  output wire   [5:0] pipe_tx7_eqdeemph_o,
  output wire   [3:0] pipe_tx7_eqpreset_o,
  input  wire         pipe_clk,
  input  wire         rst_n
  );

  generate
    xdma_0_pcie3_ip_pipe_misc 
  #(
      .TCQ (TCQ),
      .PIPE_PIPELINE_STAGES (PIPE_PIPELINE_STAGES))
    pipe_misc_inst (
      .pipe_tx_rcvr_det_i (pipe_tx_rcvr_det_i),
      .pipe_tx_reset_i (pipe_tx_reset_i),
      .pipe_tx_rate_i (pipe_tx_rate_i),
      .pipe_tx_deemph_i (pipe_tx_deemph_i),
      .pipe_tx_margin_i (pipe_tx_margin_i),
      .pipe_tx_swing_i (pipe_tx_swing_i),
      .pipe_tx_eqfs_i (pipe_tx_eqfs_i),
      .pipe_tx_eqlf_i (pipe_tx_eqlf_i),
      .pipe_tx_rcvr_det_o (pipe_tx_rcvr_det_o),
      .pipe_tx_reset_o (pipe_tx_reset_o),
      .pipe_tx_rate_o (pipe_tx_rate_o),
      .pipe_tx_deemph_o (pipe_tx_deemph_o),
      .pipe_tx_margin_o (pipe_tx_margin_o),
      .pipe_tx_swing_o (pipe_tx_swing_o),
      .pipe_tx_eqfs_o (pipe_tx_eqfs_o),
      .pipe_tx_eqlf_o (pipe_tx_eqlf_o),
      .pipe_clk (pipe_clk),
      .rst_n (rst_n)
    );
    xdma_0_pcie3_ip_pipe_lane 
   #(
      .TCQ (TCQ),
      .PIPE_PIPELINE_STAGES (PIPE_PIPELINE_STAGES))
    pipe_lane_0_inst (
      .pipe_rx_char_is_k_o (pipe_rx0_char_is_k_o),
      .pipe_rx_data_o (pipe_rx0_data_o),
      .pipe_rx_valid_o (pipe_rx0_valid_o),
      .pipe_rx_data_valid_o (pipe_rx0_data_valid_o),
      .pipe_rx_status_o (pipe_rx0_status_o),
      .pipe_rx_phy_status_o (pipe_rx0_phy_status_o),
      .pipe_rx_elec_idle_o (pipe_rx0_elec_idle_o),
      .pipe_rx_eqdone_o (pipe_rx0_eqdone_o),
      .pipe_rx_eqlpadaptdone_o (pipe_rx0_eqlpadaptdone_o),
      .pipe_rx_eqlplffssel_o (pipe_rx0_eqlplffssel_o),
      .pipe_rx_eqlpnewtxcoefforpreset_o (pipe_rx0_eqlpnewtxcoefforpreset_o),
      .pipe_rx_startblock_o (pipe_rx0_startblock_o),
      .pipe_rx_syncheader_o (pipe_rx0_syncheader_o),
      .pipe_rx_polarity_i (pipe_rx0_polarity_i),
      .pipe_rx_eqcontrol_i (pipe_rx0_eqcontrol_i),
      .pipe_rx_eqlplffs_i (pipe_rx0_eqlplffs_i),
      .pipe_rx_eqlptxpreset_i (pipe_rx0_eqlptxpreset_i),
      .pipe_rx_eqpreset_i (pipe_rx0_eqpreset_i),
      .pipe_tx_eqcoeff_o (pipe_tx0_eqcoeff_o),
      .pipe_tx_eqdone_o (pipe_tx0_eqdone_o),
      .pipe_tx_compliance_i (pipe_tx0_compliance_i),
      .pipe_tx_char_is_k_i (pipe_tx0_char_is_k_i),
      .pipe_tx_data_i (pipe_tx0_data_i),
      .pipe_tx_elec_idle_i (pipe_tx0_elec_idle_i),
      .pipe_tx_powerdown_i (pipe_tx0_powerdown_i),
      .pipe_tx_datavalid_i (pipe_tx0_datavalid_i),
      .pipe_tx_startblock_i (pipe_tx0_startblock_i),
      .pipe_tx_syncheader_i (pipe_tx0_syncheader_i),
      .pipe_tx_eqcontrol_i (pipe_tx0_eqcontrol_i),
      .pipe_tx_eqdeemph_i (pipe_tx0_eqdeemph_i),
      .pipe_tx_eqpreset_i (pipe_tx0_eqpreset_i),
      .pipe_rx_char_is_k_i (pipe_rx0_char_is_k_i),
      .pipe_rx_data_i (pipe_rx0_data_i),
      .pipe_rx_valid_i (pipe_rx0_valid_i),
      .pipe_rx_data_valid_i (pipe_rx0_data_valid_i),
      .pipe_rx_status_i (pipe_rx0_status_i),
      .pipe_rx_phy_status_i (pipe_rx0_phy_status_i),
      .pipe_rx_elec_idle_i (pipe_rx0_elec_idle_i),
      .pipe_rx_eqdone_i (pipe_rx0_eqdone_i),
      .pipe_rx_eqlpadaptdone_i (pipe_rx0_eqlpadaptdone_i),
      .pipe_rx_eqlplffssel_i (pipe_rx0_eqlplffssel_i),
      .pipe_rx_eqlpnewtxcoefforpreset_i (pipe_rx0_eqlpnewtxcoefforpreset_i),
      .pipe_rx_startblock_i (pipe_rx0_startblock_i),
      .pipe_rx_syncheader_i (pipe_rx0_syncheader_i),
      .pipe_rx_polarity_o (pipe_rx0_polarity_o),
      .pipe_rx_eqcontrol_o (pipe_rx0_eqcontrol_o),
      .pipe_rx_eqlplffs_o (pipe_rx0_eqlplffs_o),
      .pipe_rx_eqlptxpreset_o (pipe_rx0_eqlptxpreset_o),
      .pipe_rx_eqpreset_o (pipe_rx0_eqpreset_o),
      .pipe_tx_eqcoeff_i (pipe_tx0_eqcoeff_i),
      .pipe_tx_eqdone_i (pipe_tx0_eqdone_i),
      .pipe_tx_compliance_o (pipe_tx0_compliance_o),
      .pipe_tx_char_is_k_o (pipe_tx0_char_is_k_o),
      .pipe_tx_data_o (pipe_tx0_data_o),
      .pipe_tx_elec_idle_o (pipe_tx0_elec_idle_o),
      .pipe_tx_powerdown_o (pipe_tx0_powerdown_o),
      .pipe_tx_datavalid_o (pipe_tx0_datavalid_o),
      .pipe_tx_startblock_o (pipe_tx0_startblock_o),
      .pipe_tx_syncheader_o (pipe_tx0_syncheader_o),
      .pipe_tx_eqcontrol_o (pipe_tx0_eqcontrol_o),
      .pipe_tx_eqdeemph_o (pipe_tx0_eqdeemph_o),
      .pipe_tx_eqpreset_o (pipe_tx0_eqpreset_o),
      .pipe_clk (pipe_clk),
      .rst_n (rst_n)
    );
    if (PL_LINK_CAP_MAX_LINK_WIDTH >= 2)
    begin : pipe_2_lane
      xdma_0_pcie3_ip_pipe_lane 
    #(
        .TCQ (TCQ),
        .PIPE_PIPELINE_STAGES (PIPE_PIPELINE_STAGES))
      pipe_lane_1_inst (
        .pipe_rx_char_is_k_o (pipe_rx1_char_is_k_o),
        .pipe_rx_data_o (pipe_rx1_data_o),
        .pipe_rx_valid_o (pipe_rx1_valid_o),
        .pipe_rx_data_valid_o (pipe_rx1_data_valid_o),
        .pipe_rx_status_o (pipe_rx1_status_o),
        .pipe_rx_phy_status_o (pipe_rx1_phy_status_o),
        .pipe_rx_elec_idle_o (pipe_rx1_elec_idle_o),
        .pipe_rx_eqdone_o (pipe_rx1_eqdone_o),
        .pipe_rx_eqlpadaptdone_o (pipe_rx1_eqlpadaptdone_o),
        .pipe_rx_eqlplffssel_o (pipe_rx1_eqlplffssel_o),
        .pipe_rx_eqlpnewtxcoefforpreset_o (pipe_rx1_eqlpnewtxcoefforpreset_o),
        .pipe_rx_startblock_o (pipe_rx1_startblock_o),
        .pipe_rx_syncheader_o (pipe_rx1_syncheader_o),
        .pipe_rx_polarity_i (pipe_rx1_polarity_i),
        .pipe_rx_eqcontrol_i (pipe_rx1_eqcontrol_i),
        .pipe_rx_eqlplffs_i (pipe_rx1_eqlplffs_i),
        .pipe_rx_eqlptxpreset_i (pipe_rx1_eqlptxpreset_i),
        .pipe_rx_eqpreset_i (pipe_rx1_eqpreset_i),
        .pipe_tx_eqcoeff_o (pipe_tx1_eqcoeff_o),
        .pipe_tx_eqdone_o (pipe_tx1_eqdone_o),
        .pipe_tx_compliance_i (pipe_tx1_compliance_i),
        .pipe_tx_char_is_k_i (pipe_tx1_char_is_k_i),
        .pipe_tx_data_i (pipe_tx1_data_i),
        .pipe_tx_elec_idle_i (pipe_tx1_elec_idle_i),
        .pipe_tx_powerdown_i (pipe_tx1_powerdown_i),
        .pipe_tx_datavalid_i (pipe_tx1_datavalid_i),
        .pipe_tx_startblock_i (pipe_tx1_startblock_i),
        .pipe_tx_syncheader_i (pipe_tx1_syncheader_i),
        .pipe_tx_eqcontrol_i (pipe_tx1_eqcontrol_i),
        .pipe_tx_eqdeemph_i (pipe_tx1_eqdeemph_i),
        .pipe_tx_eqpreset_i (pipe_tx1_eqpreset_i),
        .pipe_rx_char_is_k_i (pipe_rx1_char_is_k_i),
        .pipe_rx_data_i (pipe_rx1_data_i),
        .pipe_rx_valid_i (pipe_rx1_valid_i),
        .pipe_rx_data_valid_i (pipe_rx1_data_valid_i),
        .pipe_rx_status_i (pipe_rx1_status_i),
        .pipe_rx_phy_status_i (pipe_rx1_phy_status_i),
        .pipe_rx_elec_idle_i (pipe_rx1_elec_idle_i),
        .pipe_rx_eqdone_i (pipe_rx1_eqdone_i),
        .pipe_rx_eqlpadaptdone_i (pipe_rx1_eqlpadaptdone_i),
        .pipe_rx_eqlplffssel_i (pipe_rx1_eqlplffssel_i),
        .pipe_rx_eqlpnewtxcoefforpreset_i (pipe_rx1_eqlpnewtxcoefforpreset_i),
        .pipe_rx_startblock_i (pipe_rx1_startblock_i),
        .pipe_rx_syncheader_i (pipe_rx1_syncheader_i),
        .pipe_rx_polarity_o (pipe_rx1_polarity_o),
        .pipe_rx_eqcontrol_o (pipe_rx1_eqcontrol_o),
        .pipe_rx_eqlplffs_o (pipe_rx1_eqlplffs_o),
        .pipe_rx_eqlptxpreset_o (pipe_rx1_eqlptxpreset_o),
        .pipe_rx_eqpreset_o (pipe_rx1_eqpreset_o),
        .pipe_tx_eqcoeff_i (pipe_tx1_eqcoeff_i),
        .pipe_tx_eqdone_i (pipe_tx1_eqdone_i),
        .pipe_tx_compliance_o (pipe_tx1_compliance_o),
        .pipe_tx_char_is_k_o (pipe_tx1_char_is_k_o),
        .pipe_tx_data_o (pipe_tx1_data_o),
        .pipe_tx_elec_idle_o (pipe_tx1_elec_idle_o),
        .pipe_tx_powerdown_o (pipe_tx1_powerdown_o),
        .pipe_tx_datavalid_o (pipe_tx1_datavalid_o),
        .pipe_tx_startblock_o (pipe_tx1_startblock_o),
        .pipe_tx_syncheader_o (pipe_tx1_syncheader_o),
        .pipe_tx_eqcontrol_o (pipe_tx1_eqcontrol_o),
        .pipe_tx_eqdeemph_o (pipe_tx1_eqdeemph_o),
        .pipe_tx_eqpreset_o (pipe_tx1_eqpreset_o),
        .pipe_clk (pipe_clk),
        .rst_n (rst_n)
      );
    end
    else
    begin
      assign pipe_rx1_char_is_k_o = 2'b00;
      assign pipe_rx1_data_o = 32'h00000000;
      assign pipe_rx1_valid_o = 1'b0;
      assign pipe_rx1_data_valid_o = 1'b0;
      assign pipe_rx1_status_o = 2'b00;
      assign pipe_rx1_phy_status_o = 1'b0;
      assign pipe_rx1_elec_idle_o = 1'b1;
      assign pipe_rx1_eqdone_o = 1'b0;
      assign pipe_rx1_eqlpadaptdone_o = 1'b0;
      assign pipe_rx1_eqlplffssel_o = 1'b0;
      assign pipe_rx1_eqlpnewtxcoefforpreset_o = 17'b00000000000000000;
      assign pipe_rx1_startblock_o = 1'b0;
      assign pipe_rx1_syncheader_o = 2'b00;
      assign pipe_tx1_eqcoeff_o = 17'b00000000000000000;
      assign pipe_tx1_eqdone_o = 1'b0;
      assign pipe_rx1_polarity_o = 1'b0;
      assign pipe_rx1_eqcontrol_o = 2'b00;
      assign pipe_rx1_eqlplffs_o = 6'b000000;
      assign pipe_rx1_eqlptxpreset_o = 4'h0;
      assign pipe_rx1_eqpreset_o = 3'b000;
      assign pipe_tx1_compliance_o = 1'b0;
      assign pipe_tx1_char_is_k_o = 2'b00;
      assign pipe_tx1_data_o = 32'h00000000;
      assign pipe_tx1_elec_idle_o = 1'b1;
      assign pipe_tx1_powerdown_o = 2'b00;
      assign pipe_tx1_datavalid_o = 1'b0;
      assign pipe_tx1_startblock_o = 1'b0;
      assign pipe_tx1_syncheader_o = 2'b00;
      assign pipe_tx1_eqcontrol_o = 2'b00;
      assign pipe_tx1_eqdeemph_o = 6'b000000;
      assign pipe_tx1_eqpreset_o = 4'h0;
    end
    if (PL_LINK_CAP_MAX_LINK_WIDTH >= 4)
    begin : pipe_4_lane
      xdma_0_pcie3_ip_pipe_lane 
    #(
        .TCQ (TCQ),
        .PIPE_PIPELINE_STAGES (PIPE_PIPELINE_STAGES))
      pipe_lane_2_inst (
        .pipe_rx_char_is_k_o (pipe_rx2_char_is_k_o),
        .pipe_rx_data_o (pipe_rx2_data_o),
        .pipe_rx_valid_o (pipe_rx2_valid_o),
        .pipe_rx_data_valid_o (pipe_rx2_data_valid_o),
        .pipe_rx_status_o (pipe_rx2_status_o),
        .pipe_rx_phy_status_o (pipe_rx2_phy_status_o),
        .pipe_rx_elec_idle_o (pipe_rx2_elec_idle_o),
        .pipe_rx_eqdone_o (pipe_rx2_eqdone_o),
        .pipe_rx_eqlpadaptdone_o (pipe_rx2_eqlpadaptdone_o),
        .pipe_rx_eqlplffssel_o (pipe_rx2_eqlplffssel_o),
        .pipe_rx_eqlpnewtxcoefforpreset_o (pipe_rx2_eqlpnewtxcoefforpreset_o),
        .pipe_rx_startblock_o (pipe_rx2_startblock_o),
        .pipe_rx_syncheader_o (pipe_rx2_syncheader_o),
        .pipe_rx_polarity_i (pipe_rx2_polarity_i),
        .pipe_rx_eqcontrol_i (pipe_rx2_eqcontrol_i),
        .pipe_rx_eqlplffs_i (pipe_rx2_eqlplffs_i),
        .pipe_rx_eqlptxpreset_i (pipe_rx2_eqlptxpreset_i),
        .pipe_rx_eqpreset_i (pipe_rx2_eqpreset_i),
        .pipe_tx_eqcoeff_o (pipe_tx2_eqcoeff_o),
        .pipe_tx_eqdone_o (pipe_tx2_eqdone_o),
        .pipe_tx_compliance_i (pipe_tx2_compliance_i),
        .pipe_tx_char_is_k_i (pipe_tx2_char_is_k_i),
        .pipe_tx_data_i (pipe_tx2_data_i),
        .pipe_tx_elec_idle_i (pipe_tx2_elec_idle_i),
        .pipe_tx_powerdown_i (pipe_tx2_powerdown_i),
        .pipe_tx_datavalid_i (pipe_tx2_datavalid_i),
        .pipe_tx_startblock_i (pipe_tx2_startblock_i),
        .pipe_tx_syncheader_i (pipe_tx2_syncheader_i),
        .pipe_tx_eqcontrol_i (pipe_tx2_eqcontrol_i),
        .pipe_tx_eqdeemph_i (pipe_tx2_eqdeemph_i),
        .pipe_tx_eqpreset_i (pipe_tx2_eqpreset_i),
        .pipe_rx_char_is_k_i (pipe_rx2_char_is_k_i),
        .pipe_rx_data_i (pipe_rx2_data_i),
        .pipe_rx_valid_i (pipe_rx2_valid_i),
        .pipe_rx_data_valid_i (pipe_rx2_data_valid_i),
        .pipe_rx_status_i (pipe_rx2_status_i),
        .pipe_rx_phy_status_i (pipe_rx2_phy_status_i),
        .pipe_rx_elec_idle_i (pipe_rx2_elec_idle_i),
        .pipe_rx_eqdone_i (pipe_rx2_eqdone_i),
        .pipe_rx_eqlpadaptdone_i (pipe_rx2_eqlpadaptdone_i),
        .pipe_rx_eqlplffssel_i (pipe_rx2_eqlplffssel_i),
        .pipe_rx_eqlpnewtxcoefforpreset_i (pipe_rx2_eqlpnewtxcoefforpreset_i),
        .pipe_rx_startblock_i (pipe_rx2_startblock_i),
        .pipe_rx_syncheader_i (pipe_rx2_syncheader_i),
        .pipe_rx_polarity_o (pipe_rx2_polarity_o),
        .pipe_rx_eqcontrol_o (pipe_rx2_eqcontrol_o),
        .pipe_rx_eqlplffs_o (pipe_rx2_eqlplffs_o),
        .pipe_rx_eqlptxpreset_o (pipe_rx2_eqlptxpreset_o),
        .pipe_rx_eqpreset_o (pipe_rx2_eqpreset_o),
        .pipe_tx_eqcoeff_i (pipe_tx2_eqcoeff_i),
        .pipe_tx_eqdone_i (pipe_tx2_eqdone_i),
        .pipe_tx_compliance_o (pipe_tx2_compliance_o),
        .pipe_tx_char_is_k_o (pipe_tx2_char_is_k_o),
        .pipe_tx_data_o (pipe_tx2_data_o),
        .pipe_tx_elec_idle_o (pipe_tx2_elec_idle_o),
        .pipe_tx_powerdown_o (pipe_tx2_powerdown_o),
        .pipe_tx_datavalid_o (pipe_tx2_datavalid_o),
        .pipe_tx_startblock_o (pipe_tx2_startblock_o),
        .pipe_tx_syncheader_o (pipe_tx2_syncheader_o),
        .pipe_tx_eqcontrol_o (pipe_tx2_eqcontrol_o),
        .pipe_tx_eqdeemph_o (pipe_tx2_eqdeemph_o),
        .pipe_tx_eqpreset_o (pipe_tx2_eqpreset_o),
        .pipe_clk (pipe_clk),
        .rst_n (rst_n)
      );
      xdma_0_pcie3_ip_pipe_lane 
     #(
        .TCQ (TCQ),
        .PIPE_PIPELINE_STAGES (PIPE_PIPELINE_STAGES))
      pipe_lane_3_inst (
        .pipe_rx_char_is_k_o (pipe_rx3_char_is_k_o),
        .pipe_rx_data_o (pipe_rx3_data_o),
        .pipe_rx_valid_o (pipe_rx3_valid_o),
        .pipe_rx_data_valid_o (pipe_rx3_data_valid_o),
        .pipe_rx_status_o (pipe_rx3_status_o),
        .pipe_rx_phy_status_o (pipe_rx3_phy_status_o),
        .pipe_rx_elec_idle_o (pipe_rx3_elec_idle_o),
        .pipe_rx_eqdone_o (pipe_rx3_eqdone_o),
        .pipe_rx_eqlpadaptdone_o (pipe_rx3_eqlpadaptdone_o),
        .pipe_rx_eqlplffssel_o (pipe_rx3_eqlplffssel_o),
        .pipe_rx_eqlpnewtxcoefforpreset_o (pipe_rx3_eqlpnewtxcoefforpreset_o),
        .pipe_rx_startblock_o (pipe_rx3_startblock_o),
        .pipe_rx_syncheader_o (pipe_rx3_syncheader_o),
        .pipe_rx_polarity_i (pipe_rx3_polarity_i),
        .pipe_rx_eqcontrol_i (pipe_rx3_eqcontrol_i),
        .pipe_rx_eqlplffs_i (pipe_rx3_eqlplffs_i),
        .pipe_rx_eqlptxpreset_i (pipe_rx3_eqlptxpreset_i),
        .pipe_rx_eqpreset_i (pipe_rx3_eqpreset_i),
        .pipe_tx_eqcoeff_o (pipe_tx3_eqcoeff_o),
        .pipe_tx_eqdone_o (pipe_tx3_eqdone_o),
        .pipe_tx_compliance_i (pipe_tx3_compliance_i),
        .pipe_tx_char_is_k_i (pipe_tx3_char_is_k_i),
        .pipe_tx_data_i (pipe_tx3_data_i),
        .pipe_tx_elec_idle_i (pipe_tx3_elec_idle_i),
        .pipe_tx_powerdown_i (pipe_tx3_powerdown_i),
        .pipe_tx_datavalid_i (pipe_tx3_datavalid_i),
        .pipe_tx_startblock_i (pipe_tx3_startblock_i),
        .pipe_tx_syncheader_i (pipe_tx3_syncheader_i),
        .pipe_tx_eqcontrol_i (pipe_tx3_eqcontrol_i),
        .pipe_tx_eqdeemph_i (pipe_tx3_eqdeemph_i),
        .pipe_tx_eqpreset_i (pipe_tx3_eqpreset_i),
        .pipe_rx_char_is_k_i (pipe_rx3_char_is_k_i),
        .pipe_rx_data_i (pipe_rx3_data_i),
        .pipe_rx_valid_i (pipe_rx3_valid_i),
        .pipe_rx_data_valid_i (pipe_rx3_data_valid_i),
        .pipe_rx_status_i (pipe_rx3_status_i),
        .pipe_rx_phy_status_i (pipe_rx3_phy_status_i),
        .pipe_rx_elec_idle_i (pipe_rx3_elec_idle_i),
        .pipe_rx_eqdone_i (pipe_rx3_eqdone_i),
        .pipe_rx_eqlpadaptdone_i (pipe_rx3_eqlpadaptdone_i),
        .pipe_rx_eqlplffssel_i (pipe_rx3_eqlplffssel_i),
        .pipe_rx_eqlpnewtxcoefforpreset_i (pipe_rx3_eqlpnewtxcoefforpreset_i),
        .pipe_rx_startblock_i (pipe_rx3_startblock_i),
        .pipe_rx_syncheader_i (pipe_rx3_syncheader_i),
        .pipe_rx_polarity_o (pipe_rx3_polarity_o),
        .pipe_rx_eqcontrol_o (pipe_rx3_eqcontrol_o),
        .pipe_rx_eqlplffs_o (pipe_rx3_eqlplffs_o),
        .pipe_rx_eqlptxpreset_o (pipe_rx3_eqlptxpreset_o),
        .pipe_rx_eqpreset_o (pipe_rx3_eqpreset_o),
        .pipe_tx_eqcoeff_i (pipe_tx3_eqcoeff_i),
        .pipe_tx_eqdone_i (pipe_tx3_eqdone_i),
        .pipe_tx_compliance_o (pipe_tx3_compliance_o),
        .pipe_tx_char_is_k_o (pipe_tx3_char_is_k_o),
        .pipe_tx_data_o (pipe_tx3_data_o),
        .pipe_tx_elec_idle_o (pipe_tx3_elec_idle_o),
        .pipe_tx_powerdown_o (pipe_tx3_powerdown_o),
        .pipe_tx_datavalid_o (pipe_tx3_datavalid_o),
        .pipe_tx_startblock_o (pipe_tx3_startblock_o),
        .pipe_tx_syncheader_o (pipe_tx3_syncheader_o),
        .pipe_tx_eqcontrol_o (pipe_tx3_eqcontrol_o),
        .pipe_tx_eqdeemph_o (pipe_tx3_eqdeemph_o),
        .pipe_tx_eqpreset_o (pipe_tx3_eqpreset_o),
        .pipe_clk (pipe_clk),
        .rst_n (rst_n)
      );
    end
    else
    begin
      assign pipe_rx2_char_is_k_o = 2'b00;
      assign pipe_rx2_data_o = 32'h00000000;
      assign pipe_rx2_valid_o = 1'b0;
      assign pipe_rx2_data_valid_o = 1'b0;
      assign pipe_rx2_status_o = 2'b00;
      assign pipe_rx2_phy_status_o = 1'b0;
      assign pipe_rx2_elec_idle_o = 1'b1;
      assign pipe_rx2_eqdone_o = 1'b0;
      assign pipe_rx2_eqlpadaptdone_o = 1'b0;
      assign pipe_rx2_eqlplffssel_o = 1'b0;
      assign pipe_rx2_eqlpnewtxcoefforpreset_o = 17'b00000000000000000;
      assign pipe_rx2_startblock_o = 1'b0;
      assign pipe_rx2_syncheader_o = 2'b00;
      assign pipe_tx2_eqcoeff_o = 17'b00000000000000000;
      assign pipe_tx2_eqdone_o = 1'b0;
      assign pipe_rx2_polarity_o = 1'b0;
      assign pipe_rx2_eqcontrol_o = 2'b00;
      assign pipe_rx2_eqlplffs_o = 6'b000000;
      assign pipe_rx2_eqlptxpreset_o = 4'h0;
      assign pipe_rx2_eqpreset_o = 3'b000;
      assign pipe_tx2_compliance_o = 1'b0;
      assign pipe_tx2_char_is_k_o = 2'b00;
      assign pipe_tx2_data_o = 32'h00000000;
      assign pipe_tx2_elec_idle_o = 1'b1;
      assign pipe_tx2_powerdown_o = 2'b00;
      assign pipe_tx2_datavalid_o = 1'b0;
      assign pipe_tx2_startblock_o = 1'b0;
      assign pipe_tx2_syncheader_o = 2'b00;
      assign pipe_tx2_eqcontrol_o = 2'b00;
      assign pipe_tx2_eqdeemph_o = 6'b000000;
      assign pipe_tx2_eqpreset_o = 4'h0;
      assign pipe_rx3_char_is_k_o = 2'b00;
      assign pipe_rx3_data_o = 32'h00000000;
      assign pipe_rx3_valid_o = 1'b0;
      assign pipe_rx3_data_valid_o = 1'b0;
      assign pipe_rx3_status_o = 2'b00;
      assign pipe_rx3_phy_status_o = 1'b0;
      assign pipe_rx3_elec_idle_o = 1'b1;
      assign pipe_rx3_eqdone_o = 1'b0;
      assign pipe_rx3_eqlpadaptdone_o = 1'b0;
      assign pipe_rx3_eqlplffssel_o = 1'b0;
      assign pipe_rx3_eqlpnewtxcoefforpreset_o = 17'b00000000000000000;
      assign pipe_rx3_startblock_o = 1'b0;
      assign pipe_rx3_syncheader_o = 2'b00;
      assign pipe_tx3_eqcoeff_o = 17'b00000000000000000;
      assign pipe_tx3_eqdone_o = 1'b0;
      assign pipe_rx3_polarity_o = 1'b0;
      assign pipe_rx3_eqcontrol_o = 2'b00;
      assign pipe_rx3_eqlplffs_o = 6'b000000;
      assign pipe_rx3_eqlptxpreset_o = 4'h0;
      assign pipe_rx3_eqpreset_o = 3'b000;
      assign pipe_tx3_compliance_o = 1'b0;
      assign pipe_tx3_char_is_k_o = 2'b00;
      assign pipe_tx3_data_o = 32'h00000000;
      assign pipe_tx3_elec_idle_o = 1'b1;
      assign pipe_tx3_powerdown_o = 2'b00;
      assign pipe_tx3_datavalid_o = 1'b0;
      assign pipe_tx3_startblock_o = 1'b0;
      assign pipe_tx3_syncheader_o = 2'b00;
      assign pipe_tx3_eqcontrol_o = 2'b00;
      assign pipe_tx3_eqdeemph_o = 6'b000000;
      assign pipe_tx3_eqpreset_o = 4'h0;
    end
    if (PL_LINK_CAP_MAX_LINK_WIDTH >= 8)
    begin : pipe_8_lane
      xdma_0_pcie3_ip_pipe_lane 
    #(
        .TCQ (TCQ),
        .PIPE_PIPELINE_STAGES (PIPE_PIPELINE_STAGES))
      pipe_lane_4_inst (
        .pipe_rx_char_is_k_o (pipe_rx4_char_is_k_o),
        .pipe_rx_data_o (pipe_rx4_data_o),
        .pipe_rx_valid_o (pipe_rx4_valid_o),
        .pipe_rx_data_valid_o (pipe_rx4_data_valid_o),
        .pipe_rx_status_o (pipe_rx4_status_o),
        .pipe_rx_phy_status_o (pipe_rx4_phy_status_o),
        .pipe_rx_elec_idle_o (pipe_rx4_elec_idle_o),
        .pipe_rx_eqdone_o (pipe_rx4_eqdone_o),
        .pipe_rx_eqlpadaptdone_o (pipe_rx4_eqlpadaptdone_o),
        .pipe_rx_eqlplffssel_o (pipe_rx4_eqlplffssel_o),
        .pipe_rx_eqlpnewtxcoefforpreset_o (pipe_rx4_eqlpnewtxcoefforpreset_o),
        .pipe_rx_startblock_o (pipe_rx4_startblock_o),
        .pipe_rx_syncheader_o (pipe_rx4_syncheader_o),
        .pipe_rx_polarity_i (pipe_rx4_polarity_i),
        .pipe_rx_eqcontrol_i (pipe_rx4_eqcontrol_i),
        .pipe_rx_eqlplffs_i (pipe_rx4_eqlplffs_i),
        .pipe_rx_eqlptxpreset_i (pipe_rx4_eqlptxpreset_i),
        .pipe_rx_eqpreset_i (pipe_rx4_eqpreset_i),
        .pipe_tx_eqcoeff_o (pipe_tx4_eqcoeff_o),
        .pipe_tx_eqdone_o (pipe_tx4_eqdone_o),
        .pipe_tx_compliance_i (pipe_tx4_compliance_i),
        .pipe_tx_char_is_k_i (pipe_tx4_char_is_k_i),
        .pipe_tx_data_i (pipe_tx4_data_i),
        .pipe_tx_elec_idle_i (pipe_tx4_elec_idle_i),
        .pipe_tx_powerdown_i (pipe_tx4_powerdown_i),
        .pipe_tx_datavalid_i (pipe_tx4_datavalid_i),
        .pipe_tx_startblock_i (pipe_tx4_startblock_i),
        .pipe_tx_syncheader_i (pipe_tx4_syncheader_i),
        .pipe_tx_eqcontrol_i (pipe_tx4_eqcontrol_i),
        .pipe_tx_eqdeemph_i (pipe_tx4_eqdeemph_i),
        .pipe_tx_eqpreset_i (pipe_tx4_eqpreset_i),
        .pipe_rx_char_is_k_i (pipe_rx4_char_is_k_i),
        .pipe_rx_data_i (pipe_rx4_data_i),
        .pipe_rx_valid_i (pipe_rx4_valid_i),
        .pipe_rx_data_valid_i (pipe_rx4_data_valid_i),
        .pipe_rx_status_i (pipe_rx4_status_i),
        .pipe_rx_phy_status_i (pipe_rx4_phy_status_i),
        .pipe_rx_elec_idle_i (pipe_rx4_elec_idle_i),
        .pipe_rx_eqdone_i (pipe_rx4_eqdone_i),
        .pipe_rx_eqlpadaptdone_i (pipe_rx4_eqlpadaptdone_i),
        .pipe_rx_eqlplffssel_i (pipe_rx4_eqlplffssel_i),
        .pipe_rx_eqlpnewtxcoefforpreset_i (pipe_rx4_eqlpnewtxcoefforpreset_i),
        .pipe_rx_startblock_i (pipe_rx4_startblock_i),
        .pipe_rx_syncheader_i (pipe_rx4_syncheader_i),
        .pipe_rx_polarity_o (pipe_rx4_polarity_o),
        .pipe_rx_eqcontrol_o (pipe_rx4_eqcontrol_o),
        .pipe_rx_eqlplffs_o (pipe_rx4_eqlplffs_o),
        .pipe_rx_eqlptxpreset_o (pipe_rx4_eqlptxpreset_o),
        .pipe_rx_eqpreset_o (pipe_rx4_eqpreset_o),
        .pipe_tx_eqcoeff_i (pipe_tx4_eqcoeff_i),
        .pipe_tx_eqdone_i (pipe_tx4_eqdone_i),
        .pipe_tx_compliance_o (pipe_tx4_compliance_o),
        .pipe_tx_char_is_k_o (pipe_tx4_char_is_k_o),
        .pipe_tx_data_o (pipe_tx4_data_o),
        .pipe_tx_elec_idle_o (pipe_tx4_elec_idle_o),
        .pipe_tx_powerdown_o (pipe_tx4_powerdown_o),
        .pipe_tx_datavalid_o (pipe_tx4_datavalid_o),
        .pipe_tx_startblock_o (pipe_tx4_startblock_o),
        .pipe_tx_syncheader_o (pipe_tx4_syncheader_o),
        .pipe_tx_eqcontrol_o (pipe_tx4_eqcontrol_o),
        .pipe_tx_eqdeemph_o (pipe_tx4_eqdeemph_o),
        .pipe_tx_eqpreset_o (pipe_tx4_eqpreset_o),
        .pipe_clk (pipe_clk),
        .rst_n (rst_n)
      );
      xdma_0_pcie3_ip_pipe_lane 
     #(
        .TCQ (TCQ),
        .PIPE_PIPELINE_STAGES (PIPE_PIPELINE_STAGES))
      pipe_lane_5_inst (
        .pipe_rx_char_is_k_o (pipe_rx5_char_is_k_o),
        .pipe_rx_data_o (pipe_rx5_data_o),
        .pipe_rx_valid_o (pipe_rx5_valid_o),
        .pipe_rx_data_valid_o (pipe_rx5_data_valid_o),
        .pipe_rx_status_o (pipe_rx5_status_o),
        .pipe_rx_phy_status_o (pipe_rx5_phy_status_o),
        .pipe_rx_elec_idle_o (pipe_rx5_elec_idle_o),
        .pipe_rx_eqdone_o (pipe_rx5_eqdone_o),
        .pipe_rx_eqlpadaptdone_o (pipe_rx5_eqlpadaptdone_o),
        .pipe_rx_eqlplffssel_o (pipe_rx5_eqlplffssel_o),
        .pipe_rx_eqlpnewtxcoefforpreset_o (pipe_rx5_eqlpnewtxcoefforpreset_o),
        .pipe_rx_startblock_o (pipe_rx5_startblock_o),
        .pipe_rx_syncheader_o (pipe_rx5_syncheader_o),
        .pipe_rx_polarity_i (pipe_rx5_polarity_i),
        .pipe_rx_eqcontrol_i (pipe_rx5_eqcontrol_i),
        .pipe_rx_eqlplffs_i (pipe_rx5_eqlplffs_i),
        .pipe_rx_eqlptxpreset_i (pipe_rx5_eqlptxpreset_i),
        .pipe_rx_eqpreset_i (pipe_rx5_eqpreset_i),
        .pipe_tx_eqcoeff_o (pipe_tx5_eqcoeff_o),
        .pipe_tx_eqdone_o (pipe_tx5_eqdone_o),
        .pipe_tx_compliance_i (pipe_tx5_compliance_i),
        .pipe_tx_char_is_k_i (pipe_tx5_char_is_k_i),
        .pipe_tx_data_i (pipe_tx5_data_i),
        .pipe_tx_elec_idle_i (pipe_tx5_elec_idle_i),
        .pipe_tx_powerdown_i (pipe_tx5_powerdown_i),
        .pipe_tx_datavalid_i (pipe_tx5_datavalid_i),
        .pipe_tx_startblock_i (pipe_tx5_startblock_i),
        .pipe_tx_syncheader_i (pipe_tx5_syncheader_i),
        .pipe_tx_eqcontrol_i (pipe_tx5_eqcontrol_i),
        .pipe_tx_eqdeemph_i (pipe_tx5_eqdeemph_i),
        .pipe_tx_eqpreset_i (pipe_tx5_eqpreset_i),
        .pipe_rx_char_is_k_i (pipe_rx5_char_is_k_i),
        .pipe_rx_data_i (pipe_rx5_data_i),
        .pipe_rx_valid_i (pipe_rx5_valid_i),
        .pipe_rx_data_valid_i (pipe_rx5_data_valid_i),
        .pipe_rx_status_i (pipe_rx5_status_i),
        .pipe_rx_phy_status_i (pipe_rx5_phy_status_i),
        .pipe_rx_elec_idle_i (pipe_rx5_elec_idle_i),
        .pipe_rx_eqdone_i (pipe_rx5_eqdone_i),
        .pipe_rx_eqlpadaptdone_i (pipe_rx5_eqlpadaptdone_i),
        .pipe_rx_eqlplffssel_i (pipe_rx5_eqlplffssel_i),
        .pipe_rx_eqlpnewtxcoefforpreset_i (pipe_rx5_eqlpnewtxcoefforpreset_i),
        .pipe_rx_startblock_i (pipe_rx5_startblock_i),
        .pipe_rx_syncheader_i (pipe_rx5_syncheader_i),
        .pipe_rx_polarity_o (pipe_rx5_polarity_o),
        .pipe_rx_eqcontrol_o (pipe_rx5_eqcontrol_o),
        .pipe_rx_eqlplffs_o (pipe_rx5_eqlplffs_o),
        .pipe_rx_eqlptxpreset_o (pipe_rx5_eqlptxpreset_o),
        .pipe_rx_eqpreset_o (pipe_rx5_eqpreset_o),
        .pipe_tx_eqcoeff_i (pipe_tx5_eqcoeff_i),
        .pipe_tx_eqdone_i (pipe_tx5_eqdone_i),
        .pipe_tx_compliance_o (pipe_tx5_compliance_o),
        .pipe_tx_char_is_k_o (pipe_tx5_char_is_k_o),
        .pipe_tx_data_o (pipe_tx5_data_o),
        .pipe_tx_elec_idle_o (pipe_tx5_elec_idle_o),
        .pipe_tx_powerdown_o (pipe_tx5_powerdown_o),
        .pipe_tx_datavalid_o (pipe_tx5_datavalid_o),
        .pipe_tx_startblock_o (pipe_tx5_startblock_o),
        .pipe_tx_syncheader_o (pipe_tx5_syncheader_o),
        .pipe_tx_eqcontrol_o (pipe_tx5_eqcontrol_o),
        .pipe_tx_eqdeemph_o (pipe_tx5_eqdeemph_o),
        .pipe_tx_eqpreset_o (pipe_tx5_eqpreset_o),
        .pipe_clk (pipe_clk),
        .rst_n (rst_n)
      );
      xdma_0_pcie3_ip_pipe_lane 
     #(
        .TCQ (TCQ),
        .PIPE_PIPELINE_STAGES (PIPE_PIPELINE_STAGES))
      pipe_lane_6_inst (
        .pipe_rx_char_is_k_o (pipe_rx6_char_is_k_o),
        .pipe_rx_data_o (pipe_rx6_data_o),
        .pipe_rx_valid_o (pipe_rx6_valid_o),
        .pipe_rx_data_valid_o (pipe_rx6_data_valid_o),
        .pipe_rx_status_o (pipe_rx6_status_o),
        .pipe_rx_phy_status_o (pipe_rx6_phy_status_o),
        .pipe_rx_elec_idle_o (pipe_rx6_elec_idle_o),
        .pipe_rx_eqdone_o (pipe_rx6_eqdone_o),
        .pipe_rx_eqlpadaptdone_o (pipe_rx6_eqlpadaptdone_o),
        .pipe_rx_eqlplffssel_o (pipe_rx6_eqlplffssel_o),
        .pipe_rx_eqlpnewtxcoefforpreset_o (pipe_rx6_eqlpnewtxcoefforpreset_o),
        .pipe_rx_startblock_o (pipe_rx6_startblock_o),
        .pipe_rx_syncheader_o (pipe_rx6_syncheader_o),
        .pipe_rx_polarity_i (pipe_rx6_polarity_i),
        .pipe_rx_eqcontrol_i (pipe_rx6_eqcontrol_i),
        .pipe_rx_eqlplffs_i (pipe_rx6_eqlplffs_i),
        .pipe_rx_eqlptxpreset_i (pipe_rx6_eqlptxpreset_i),
        .pipe_rx_eqpreset_i (pipe_rx6_eqpreset_i),
        .pipe_tx_eqcoeff_o (pipe_tx6_eqcoeff_o),
        .pipe_tx_eqdone_o (pipe_tx6_eqdone_o),
        .pipe_tx_compliance_i (pipe_tx6_compliance_i),
        .pipe_tx_char_is_k_i (pipe_tx6_char_is_k_i),
        .pipe_tx_data_i (pipe_tx6_data_i),
        .pipe_tx_elec_idle_i (pipe_tx6_elec_idle_i),
        .pipe_tx_powerdown_i (pipe_tx6_powerdown_i),
        .pipe_tx_datavalid_i (pipe_tx6_datavalid_i),
        .pipe_tx_startblock_i (pipe_tx6_startblock_i),
        .pipe_tx_syncheader_i (pipe_tx6_syncheader_i),
        .pipe_tx_eqcontrol_i (pipe_tx6_eqcontrol_i),
        .pipe_tx_eqdeemph_i (pipe_tx6_eqdeemph_i),
        .pipe_tx_eqpreset_i (pipe_tx6_eqpreset_i),
        .pipe_rx_char_is_k_i (pipe_rx6_char_is_k_i),
        .pipe_rx_data_i (pipe_rx6_data_i),
        .pipe_rx_valid_i (pipe_rx6_valid_i),
        .pipe_rx_data_valid_i (pipe_rx6_data_valid_i),
        .pipe_rx_status_i (pipe_rx6_status_i),
        .pipe_rx_phy_status_i (pipe_rx6_phy_status_i),
        .pipe_rx_elec_idle_i (pipe_rx6_elec_idle_i),
        .pipe_rx_eqdone_i (pipe_rx6_eqdone_i),
        .pipe_rx_eqlpadaptdone_i (pipe_rx6_eqlpadaptdone_i),
        .pipe_rx_eqlplffssel_i (pipe_rx6_eqlplffssel_i),
        .pipe_rx_eqlpnewtxcoefforpreset_i (pipe_rx6_eqlpnewtxcoefforpreset_i),
        .pipe_rx_startblock_i (pipe_rx6_startblock_i),
        .pipe_rx_syncheader_i (pipe_rx6_syncheader_i),
        .pipe_rx_polarity_o (pipe_rx6_polarity_o),
        .pipe_rx_eqcontrol_o (pipe_rx6_eqcontrol_o),
        .pipe_rx_eqlplffs_o (pipe_rx6_eqlplffs_o),
        .pipe_rx_eqlptxpreset_o (pipe_rx6_eqlptxpreset_o),
        .pipe_rx_eqpreset_o (pipe_rx6_eqpreset_o),
        .pipe_tx_eqcoeff_i (pipe_tx6_eqcoeff_i),
        .pipe_tx_eqdone_i (pipe_tx6_eqdone_i),
        .pipe_tx_compliance_o (pipe_tx6_compliance_o),
        .pipe_tx_char_is_k_o (pipe_tx6_char_is_k_o),
        .pipe_tx_data_o (pipe_tx6_data_o),
        .pipe_tx_elec_idle_o (pipe_tx6_elec_idle_o),
        .pipe_tx_powerdown_o (pipe_tx6_powerdown_o),
        .pipe_tx_datavalid_o (pipe_tx6_datavalid_o),
        .pipe_tx_startblock_o (pipe_tx6_startblock_o),
        .pipe_tx_syncheader_o (pipe_tx6_syncheader_o),
        .pipe_tx_eqcontrol_o (pipe_tx6_eqcontrol_o),
        .pipe_tx_eqdeemph_o (pipe_tx6_eqdeemph_o),
        .pipe_tx_eqpreset_o (pipe_tx6_eqpreset_o),
        .pipe_clk (pipe_clk),
        .rst_n (rst_n)
      );
      xdma_0_pcie3_ip_pipe_lane 
     #(
        .TCQ (TCQ),
        .PIPE_PIPELINE_STAGES (PIPE_PIPELINE_STAGES))
      pipe_lane_7_inst (
        .pipe_rx_char_is_k_o (pipe_rx7_char_is_k_o),
        .pipe_rx_data_o (pipe_rx7_data_o),
        .pipe_rx_valid_o (pipe_rx7_valid_o),
        .pipe_rx_data_valid_o (pipe_rx7_data_valid_o),
        .pipe_rx_status_o (pipe_rx7_status_o),
        .pipe_rx_phy_status_o (pipe_rx7_phy_status_o),
        .pipe_rx_elec_idle_o (pipe_rx7_elec_idle_o),
        .pipe_rx_eqdone_o (pipe_rx7_eqdone_o),
        .pipe_rx_eqlpadaptdone_o (pipe_rx7_eqlpadaptdone_o),
        .pipe_rx_eqlplffssel_o (pipe_rx7_eqlplffssel_o),
        .pipe_rx_eqlpnewtxcoefforpreset_o (pipe_rx7_eqlpnewtxcoefforpreset_o),
        .pipe_rx_startblock_o (pipe_rx7_startblock_o),
        .pipe_rx_syncheader_o (pipe_rx7_syncheader_o),
        .pipe_rx_polarity_i (pipe_rx7_polarity_i),
        .pipe_rx_eqcontrol_i (pipe_rx7_eqcontrol_i),
        .pipe_rx_eqlplffs_i (pipe_rx7_eqlplffs_i),
        .pipe_rx_eqlptxpreset_i (pipe_rx7_eqlptxpreset_i),
        .pipe_rx_eqpreset_i (pipe_rx7_eqpreset_i),
        .pipe_tx_eqcoeff_o (pipe_tx7_eqcoeff_o),
        .pipe_tx_eqdone_o (pipe_tx7_eqdone_o),
        .pipe_tx_compliance_i (pipe_tx7_compliance_i),
        .pipe_tx_char_is_k_i (pipe_tx7_char_is_k_i),
        .pipe_tx_data_i (pipe_tx7_data_i),
        .pipe_tx_elec_idle_i (pipe_tx7_elec_idle_i),
        .pipe_tx_powerdown_i (pipe_tx7_powerdown_i),
        .pipe_tx_datavalid_i (pipe_tx7_datavalid_i),
        .pipe_tx_startblock_i (pipe_tx7_startblock_i),
        .pipe_tx_syncheader_i (pipe_tx7_syncheader_i),
        .pipe_tx_eqcontrol_i (pipe_tx7_eqcontrol_i),
        .pipe_tx_eqdeemph_i (pipe_tx7_eqdeemph_i),
        .pipe_tx_eqpreset_i (pipe_tx7_eqpreset_i),
        .pipe_rx_char_is_k_i (pipe_rx7_char_is_k_i),
        .pipe_rx_data_i (pipe_rx7_data_i),
        .pipe_rx_valid_i (pipe_rx7_valid_i),
        .pipe_rx_data_valid_i (pipe_rx7_data_valid_i),
        .pipe_rx_status_i (pipe_rx7_status_i),
        .pipe_rx_phy_status_i (pipe_rx7_phy_status_i),
        .pipe_rx_elec_idle_i (pipe_rx7_elec_idle_i),
        .pipe_rx_eqdone_i (pipe_rx7_eqdone_i),
        .pipe_rx_eqlpadaptdone_i (pipe_rx7_eqlpadaptdone_i),
        .pipe_rx_eqlplffssel_i (pipe_rx7_eqlplffssel_i),
        .pipe_rx_eqlpnewtxcoefforpreset_i (pipe_rx7_eqlpnewtxcoefforpreset_i),
        .pipe_rx_startblock_i (pipe_rx7_startblock_i),
        .pipe_rx_syncheader_i (pipe_rx7_syncheader_i),
        .pipe_rx_polarity_o (pipe_rx7_polarity_o),
        .pipe_rx_eqcontrol_o (pipe_rx7_eqcontrol_o),
        .pipe_rx_eqlplffs_o (pipe_rx7_eqlplffs_o),
        .pipe_rx_eqlptxpreset_o (pipe_rx7_eqlptxpreset_o),
        .pipe_rx_eqpreset_o (pipe_rx7_eqpreset_o),
        .pipe_tx_eqcoeff_i (pipe_tx7_eqcoeff_i),
        .pipe_tx_eqdone_i (pipe_tx7_eqdone_i),
        .pipe_tx_compliance_o (pipe_tx7_compliance_o),
        .pipe_tx_char_is_k_o (pipe_tx7_char_is_k_o),
        .pipe_tx_data_o (pipe_tx7_data_o),
        .pipe_tx_elec_idle_o (pipe_tx7_elec_idle_o),
        .pipe_tx_powerdown_o (pipe_tx7_powerdown_o),
        .pipe_tx_datavalid_o (pipe_tx7_datavalid_o),
        .pipe_tx_startblock_o (pipe_tx7_startblock_o),
        .pipe_tx_syncheader_o (pipe_tx7_syncheader_o),
        .pipe_tx_eqcontrol_o (pipe_tx7_eqcontrol_o),
        .pipe_tx_eqdeemph_o (pipe_tx7_eqdeemph_o),
        .pipe_tx_eqpreset_o (pipe_tx7_eqpreset_o),
        .pipe_clk (pipe_clk),
        .rst_n (rst_n)
      );
    end
    else
    begin
      assign pipe_rx4_char_is_k_o = 2'b00;
      assign pipe_rx4_data_o = 32'h00000000;
      assign pipe_rx4_valid_o = 1'b0;
      assign pipe_rx4_data_valid_o = 1'b0;
      assign pipe_rx4_status_o = 2'b00;
      assign pipe_rx4_phy_status_o = 1'b0;
      assign pipe_rx4_elec_idle_o = 1'b1;
      assign pipe_rx4_eqdone_o = 1'b0;
      assign pipe_rx4_eqlpadaptdone_o = 1'b0;
      assign pipe_rx4_eqlplffssel_o = 1'b0;
      assign pipe_rx4_eqlpnewtxcoefforpreset_o = 17'b00000000000000000;
      assign pipe_rx4_startblock_o = 1'b0;
      assign pipe_rx4_syncheader_o = 2'b00;
      assign pipe_tx4_eqcoeff_o = 17'b00000000000000000;
      assign pipe_tx4_eqdone_o = 1'b0;
      assign pipe_rx4_polarity_o = 1'b0;
      assign pipe_rx4_eqcontrol_o = 2'b00;
      assign pipe_rx4_eqlplffs_o = 6'b000000;
      assign pipe_rx4_eqlptxpreset_o = 4'h0;
      assign pipe_rx4_eqpreset_o = 3'b000;
      assign pipe_tx4_compliance_o = 1'b0;
      assign pipe_tx4_char_is_k_o = 2'b00;
      assign pipe_tx4_data_o = 32'h00000000;
      assign pipe_tx4_elec_idle_o = 1'b1;
      assign pipe_tx4_powerdown_o = 2'b00;
      assign pipe_tx4_datavalid_o = 1'b0;
      assign pipe_tx4_startblock_o = 1'b0;
      assign pipe_tx4_syncheader_o = 2'b00;
      assign pipe_tx4_eqcontrol_o = 2'b00;
      assign pipe_tx4_eqdeemph_o = 6'b000000;
      assign pipe_tx4_eqpreset_o = 4'h0;
      assign pipe_rx5_char_is_k_o = 2'b00;
      assign pipe_rx5_data_o = 32'h00000000;
      assign pipe_rx5_valid_o = 1'b0;
      assign pipe_rx5_data_valid_o = 1'b0;
      assign pipe_rx5_status_o = 2'b00;
      assign pipe_rx5_phy_status_o = 1'b0;
      assign pipe_rx5_elec_idle_o = 1'b1;
      assign pipe_rx5_eqdone_o = 1'b0;
      assign pipe_rx5_eqlpadaptdone_o = 1'b0;
      assign pipe_rx5_eqlplffssel_o = 1'b0;
      assign pipe_rx5_eqlpnewtxcoefforpreset_o = 17'b00000000000000000;
      assign pipe_rx5_startblock_o = 1'b0;
      assign pipe_rx5_syncheader_o = 2'b00;
      assign pipe_tx5_eqcoeff_o = 17'b00000000000000000;
      assign pipe_tx5_eqdone_o = 1'b0;
      assign pipe_rx5_polarity_o = 1'b0;
      assign pipe_rx5_eqcontrol_o = 2'b00;
      assign pipe_rx5_eqlplffs_o = 6'b000000;
      assign pipe_rx5_eqlptxpreset_o = 4'h0;
      assign pipe_rx5_eqpreset_o = 3'b000;
      assign pipe_tx5_compliance_o = 1'b0;
      assign pipe_tx5_char_is_k_o = 2'b00;
      assign pipe_tx5_data_o = 32'h00000000;
      assign pipe_tx5_elec_idle_o = 1'b1;
      assign pipe_tx5_powerdown_o = 2'b00;
      assign pipe_tx5_datavalid_o = 1'b0;
      assign pipe_tx5_startblock_o = 1'b0;
      assign pipe_tx5_syncheader_o = 2'b00;
      assign pipe_tx5_eqcontrol_o = 2'b00;
      assign pipe_tx5_eqdeemph_o = 6'b000000;
      assign pipe_tx5_eqpreset_o = 4'h0;
      assign pipe_rx6_char_is_k_o = 2'b00;
      assign pipe_rx6_data_o = 32'h00000000;
      assign pipe_rx6_valid_o = 1'b0;
      assign pipe_rx6_data_valid_o = 1'b0;
      assign pipe_rx6_status_o = 2'b00;
      assign pipe_rx6_phy_status_o = 1'b0;
      assign pipe_rx6_elec_idle_o = 1'b1;
      assign pipe_rx6_eqdone_o = 1'b0;
      assign pipe_rx6_eqlpadaptdone_o = 1'b0;
      assign pipe_rx6_eqlplffssel_o = 1'b0;
      assign pipe_rx6_eqlpnewtxcoefforpreset_o = 17'b00000000000000000;
      assign pipe_rx6_startblock_o = 1'b0;
      assign pipe_rx6_syncheader_o = 2'b00;
      assign pipe_tx6_eqcoeff_o = 17'b00000000000000000;
      assign pipe_tx6_eqdone_o = 1'b0;
      assign pipe_rx6_polarity_o = 1'b0;
      assign pipe_rx6_eqcontrol_o = 2'b00;
      assign pipe_rx6_eqlplffs_o = 6'b000000;
      assign pipe_rx6_eqlptxpreset_o = 4'h0;
      assign pipe_rx6_eqpreset_o = 3'b000;
      assign pipe_tx6_compliance_o = 1'b0;
      assign pipe_tx6_char_is_k_o = 2'b00;
      assign pipe_tx6_data_o = 32'h00000000;
      assign pipe_tx6_elec_idle_o = 1'b1;
      assign pipe_tx6_powerdown_o = 2'b00;
      assign pipe_tx6_datavalid_o = 1'b0;
      assign pipe_tx6_startblock_o = 1'b0;
      assign pipe_tx6_syncheader_o = 2'b00;
      assign pipe_tx6_eqcontrol_o = 2'b00;
      assign pipe_tx6_eqdeemph_o = 6'b000000;
      assign pipe_tx6_eqpreset_o = 4'h0;
      assign pipe_rx7_char_is_k_o = 2'b00;
      assign pipe_rx7_data_o = 32'h00000000;
      assign pipe_rx7_valid_o = 1'b0;
      assign pipe_rx7_data_valid_o = 1'b0;
      assign pipe_rx7_status_o = 2'b00;
      assign pipe_rx7_phy_status_o = 1'b0;
      assign pipe_rx7_elec_idle_o = 1'b1;
      assign pipe_rx7_eqdone_o = 1'b0;
      assign pipe_rx7_eqlpadaptdone_o = 1'b0;
      assign pipe_rx7_eqlplffssel_o = 1'b0;
      assign pipe_rx7_eqlpnewtxcoefforpreset_o = 17'b00000000000000000;
      assign pipe_rx7_startblock_o = 1'b0;
      assign pipe_rx7_syncheader_o = 2'b00;
      assign pipe_tx7_eqcoeff_o = 17'b00000000000000000;
      assign pipe_tx7_eqdone_o = 1'b0;
      assign pipe_rx7_polarity_o = 1'b0;
      assign pipe_rx7_eqcontrol_o = 2'b00;
      assign pipe_rx7_eqlplffs_o = 6'b000000;
      assign pipe_rx7_eqlptxpreset_o = 4'h0;
      assign pipe_rx7_eqpreset_o = 3'b000;
      assign pipe_tx7_compliance_o = 1'b0;
      assign pipe_tx7_char_is_k_o = 2'b00;
      assign pipe_tx7_data_o = 32'h00000000;
      assign pipe_tx7_elec_idle_o = 1'b1;
      assign pipe_tx7_powerdown_o = 2'b00;
      assign pipe_tx7_datavalid_o = 1'b0;
      assign pipe_tx7_startblock_o = 1'b0;
      assign pipe_tx7_syncheader_o = 2'b00;
      assign pipe_tx7_eqcontrol_o = 2'b00;
      assign pipe_tx7_eqdeemph_o = 6'b000000;
      assign pipe_tx7_eqpreset_o = 4'h0;
    end
  endgenerate

endmodule
