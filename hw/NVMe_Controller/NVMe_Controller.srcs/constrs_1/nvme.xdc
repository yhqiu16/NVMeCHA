##-----------------------------------------------------------------------------
##
## (c) Copyright 2012-2012 Xilinx, Inc. All rights reserved.
##
## This file contains confidential and proprietary information
## of Xilinx, Inc. and is protected under U.S. and
## international copyright and other intellectual property
## laws.
##
## DISCLAIMER
## This disclaimer is not a license and does not grant any
## rights to the materials distributed herewith. Except as
## otherwise provided in a valid license issued to you by
## Xilinx, and to the maximum extent permitted by applicable
## law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
## WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
## AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
## BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
## INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
## (2) Xilinx shall not be liable (whether in contract or tort,
## including negligence, or under any other theory of
## liability) for any loss or damage of any kind or nature
## related to, arising under or in connection with these
## materials, including for any direct, or any indirect,
## special, incidental, or consequential loss or damage
## (including loss of data, profits, goodwill, or any type of
## loss or damage suffered as a result of any action brought
## by a third party) even if such damage or loss was
## reasonably foreseeable or Xilinx had been advised of the
## possibility of the same.
##
## CRITICAL APPLICATIONS
## Xilinx products are not designed or intended to be fail-
## safe, or for use in any application requiring fail-safe
## performance, such as life-support or safety devices or
## systems, Class III medical devices, nuclear facilities,
## applications related to the deployment of airbags, or any
## other applications that could lead to death, personal
## injury, or severe property or environmental damage
## (individually and collectively, "Critical
## Applications"). Customer assumes the sole risk and
## liability of any use of Xilinx products in Critical
## Applications, subject only to applicable laws and
## regulations governing limitations on product liability.
##
## THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
## PART OF THIS FILE AT ALL TIMES.
##
##-----------------------------------------------------------------------------
##
## Project    : The Xilinx PCI Express DMA
## File       : xilinx_pcie_xdma_ref_board.xdc
## Version    : $IpVersion
##-----------------------------------------------------------------------------
#
###############################################################################
# User Configuration
# Link Width   - x8
# Link Speed   - gen3
# Family       - kintexu
# Part         - xcku040
# Package      - ffva1156
# Speed grade  - -2
# PCIe Block   - X0Y0

###############################################################################
#
#########################################################################################################################
# User Constraints
#########################################################################################################################

###############################################################################
# User Time Names / User Time Groups / Time Specs
###############################################################################
create_clock -period 10.000 -name sys_clk [get_ports sys_clk_p]

set_false_path -from [get_ports sys_rst_n]

set_false_path -from [get_pins regfile/dma_soft_rstn_reg/C]
#set_false_path -through [get_pins xdma_0_i/inst/pcie3_ip_i/inst/pcie3_uscale_top_inst/pcie3_uscale_wrapper_inst/PCIE_3_1_inst/CFGMAX*]
#set_false_path -through [get_nets xdma_0_i/inst/cfg_max*]
###############################################################################
# User Physical Constraints
###############################################################################

###############################################################################
# Pinout and Related I/O Constraints
###############################################################################

# pcie reset
#set_property LOC PCIE_3_1_X0Y0 [get_cells xdma_0_i/inst/pcie3_ip_i/inst/xdma_0_pcie3_ip_pcie3_uscale_top_inst/pcie3_uscale_wrapper_inst/PCIE_3_1_inst]
set_property LOC PCIE_3_1_X0Y0 [get_cells xdma_0_i/inst/pcie3_ip_i/inst/pcie3_uscale_top_inst/pcie3_uscale_wrapper_inst/PCIE_3_1_inst]
set_property PACKAGE_PIN K22 [get_ports sys_rst_n]
set_property PULLUP true [get_ports sys_rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports sys_rst_n]


##### REFCLK_IBUF###########
set_property LOC GTHE3_COMMON_X0Y1 [get_cells refclk_ibuf]
##### LED's ###########
set_property PACKAGE_PIN AP8 [get_ports led_0]
# system reset
set_property PACKAGE_PIN H23 [get_ports led_1]
# user_reset
set_property PACKAGE_PIN P20 [get_ports led_2]
# user_link_up
set_property PACKAGE_PIN P21 [get_ports led_3]
## Clock Up/Heart Beat(HB)
#set_property PACKAGE_PIN N22 [get_ports led_4]
## Clock Up/Heart Beat(HB)
#set_property PACKAGE_PIN M22 [get_ports led_5]
## Clock Up/Heart Beat(HB)

set_property IOSTANDARD LVCMOS18 [get_ports led_0]
set_property IOSTANDARD LVCMOS18 [get_ports led_1]
set_property IOSTANDARD LVCMOS18 [get_ports led_2]
set_property IOSTANDARD LVCMOS18 [get_ports led_3]
#set_property IOSTANDARD LVCMOS18 [get_ports led_4]
#set_property IOSTANDARD LVCMOS18 [get_ports led_5]

####################################################################################
# Constraints from file : 'asyn_fifo_0_clocks.xdc'
####################################################################################

set_false_path -to [get_ports -filter NAME=~led_*]

#######################################################################
