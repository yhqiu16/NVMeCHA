
################################################################################
# (c) Copyright 2012 - 2013 Xilinx, Inc. All rights reserved.
# 
# This file contains confidential and proprietary information
# of Xilinx, Inc. and is protected under U.S. and
# international copyright and other intellectual property
# laws.
# 
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# Xilinx, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# (2) Xilinx shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or Xilinx had been advised of the
# possibility of the same.
# 
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of Xilinx products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
# 
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.

################################################################################

# This XDC is used only for OOC mode of synthesis, implementation
# User should update the correct clock period before proceeding further
# This constraints file contains default clock frequencies to be used during 
# out-of-context flows such as OOC Synthesis and Hierarchical Designs. 
# For best results the frequencies should be modified# to match the target 
# frequencies. 
# This constraints file is not used in normal top-down synthesis (the default flow of Vivado)
################################################################################
#create_clock -name clock_name -period 10 [get_ports clock_name] 
################################################################################

#list of all the clock needed for AXI Quad SPI core

	create_clock -name all_clock -period 20 [get_ports {s_axi_aclk ext_spi_clk}] 
##			 set_property HD.CLK_SRC BUFGCTRL_X0Y0 [get_ports s_axi_aclk]

##			 set_property HD.CLK_SRC BUFGCTRL_X0Y1 [get_ports ext_spi_clk]


set_false_path -through [get_pins -of [get_cells -hier -filter name=~*U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.*_pntr_cdc_*inst/src_gray_ff_reg[*]] -filter {REF_PIN_NAME == C}] -to [get_pins -of [get_cells -hier -filter name=~*U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.*_pntr_cdc_*inst/dest_graysync_ff_reg[0][*]] -filter {REF_PIN_NAME == D}]
set_false_path -through [get_pins -of [get_cells -hier -filter name=~*U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.*_reg[*]] -filter {REF_PIN_NAME == C}] -to [get_pins -of [get_cells -hier -filter name=~*U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.*_reg[0][*]] -filter {REF_PIN_NAME == D}]
set_false_path -through [get_pins -of [get_cells -hier -filter name=~*U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.TX_FIFO_II/xpm_fifo_instance.xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.*_pntr_cdc_*inst/src_gray_ff_reg[*]] -filter {REF_PIN_NAME == C}] -to [get_pins -of [get_cells -hier -filter name=~*U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.TX_FIFO_II/xpm_fifo_instance.xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.*_pntr_cdc_*inst/dest_graysync_ff_reg[0][*]] -filter {REF_PIN_NAME == D}]
set_false_path -through [get_pins -of [get_cells -hier -filter name=~*U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/*] -filter {REF_PIN_NAME == C}] -to [get_pins -of [get_cells -hier -filter name=~*U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.*/*_CDC*] -filter {REF_PIN_NAME == D}]
set_false_path -through [get_pins -of [get_cells -hier -filter name=~*U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/SOFT_RESET_I/RESET_FLOPS[15].RST_FLOPS] -filter {REF_PIN_NAME == C}] -to [get_pins -of [get_cells -hier -filter name=~*U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/RESET_SYNC_AXI_SPI_CLK_INST/RESET_SYNC_AX2S_1] -filter {REF_PIN_NAME == D}]
set_false_path -through [get_pins -of [get_cells -hier -filter name=~*U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.AXI_LITE_IPIF_I/I_SLAVE_ATTACHMENT/rst_reg] -filter {REF_PIN_NAME ==C}] -to [get_pins -of [get_cells -hier -filter name=~*U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/RESET_SYNC_AXI_SPI_CLK_INST/RESET_SYNC_AX2S_1] -filter {REF_PIN_NAME == D}]
	

set_false_path -to [get_pins -of [get_cells -hier -filter name=~*U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.*/*_CDC] -filter {REF_PIN_NAME == D}]
	
	


	



################################################################################
