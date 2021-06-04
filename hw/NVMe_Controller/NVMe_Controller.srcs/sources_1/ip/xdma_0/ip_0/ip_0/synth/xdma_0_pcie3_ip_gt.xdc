#------------------------------------------------------------------------------
#  (c) Copyright 2013-2018 Xilinx, Inc. All rights reserved.
#
#  This file contains confidential and proprietary information
#  of Xilinx, Inc. and is protected under U.S. and
#  international copyright and other intellectual property
#  laws.
#
#  DISCLAIMER
#  This disclaimer is not a license and does not grant any
#  rights to the materials distributed herewith. Except as
#  otherwise provided in a valid license issued to you by
#  Xilinx, and to the maximum extent permitted by applicable
#  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
#  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
#  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
#  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
#  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
#  (2) Xilinx shall not be liable (whether in contract or tort,
#  including negligence, or under any other theory of
#  liability) for any loss or damage of any kind or nature
#  related to, arising under or in connection with these
#  materials, including for any direct, or any indirect,
#  special, incidental, or consequential loss or damage
#  (including loss of data, profits, goodwill, or any type of
#  loss or damage suffered as a result of any action brought
#  by a third party) even if such damage or loss was
#  reasonably foreseeable or Xilinx had been advised of the
#  possibility of the same.
#
#  CRITICAL APPLICATIONS
#  Xilinx products are not designed or intended to be fail-
#  safe, or for use in any application requiring fail-safe
#  performance, such as life-support or safety devices or
#  systems, Class III medical devices, nuclear facilities,
#  applications related to the deployment of airbags, or any
#  other applications that could lead to death, personal
#  injury, or severe property or environmental damage
#  (individually and collectively, "Critical
#  Applications"). Customer assumes the sole risk and
#  liability of any use of Xilinx products in Critical
#  Applications, subject only to applicable laws and
#  regulations governing limitations on product liability.
#
#  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
#  PART OF THIS FILE AT ALL TIMES.
#------------------------------------------------------------------------------


# UltraScale FPGAs Transceivers Wizard IP core-level XDC file
# ----------------------------------------------------------------------------------------------------------------------

# Commands for enabled transceiver GTHE3_CHANNEL_X0Y0
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X0Y0 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gthe3_channel_inst[0].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin AP1 [get_ports gthrxn_in[0]]
#set_property package_pin AP2 [get_ports gthrxp_in[0]]
#set_property package_pin AN3 [get_ports gthtxn_out[0]]
#set_property package_pin AN4 [get_ports gthtxp_out[0]]

# Commands for enabled transceiver GTHE3_CHANNEL_X0Y1
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X0Y1 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gthe3_channel_inst[1].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin AM1 [get_ports gthrxn_in[1]]
#set_property package_pin AM2 [get_ports gthrxp_in[1]]
#set_property package_pin AM5 [get_ports gthtxn_out[1]]
#set_property package_pin AM6 [get_ports gthtxp_out[1]]

# Commands for enabled transceiver GTHE3_CHANNEL_X0Y2
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X0Y2 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gthe3_channel_inst[2].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin AK1 [get_ports gthrxn_in[2]]
#set_property package_pin AK2 [get_ports gthrxp_in[2]]
#set_property package_pin AL3 [get_ports gthtxn_out[2]]
#set_property package_pin AL4 [get_ports gthtxp_out[2]]

# Commands for enabled transceiver GTHE3_CHANNEL_X0Y3
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X0Y3 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gthe3_channel_inst[3].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin AJ3 [get_ports gthrxn_in[3]]
#set_property package_pin AJ4 [get_ports gthrxp_in[3]]
#set_property package_pin AK5 [get_ports gthtxn_out[3]]
#set_property package_pin AK6 [get_ports gthtxp_out[3]]

# Commands for enabled transceiver GTHE3_CHANNEL_X0Y4
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X0Y4 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[1].*gen_gthe3_channel_inst[0].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin AH1 [get_ports gthrxn_in[4]]
#set_property package_pin AH2 [get_ports gthrxp_in[4]]
#set_property package_pin AH5 [get_ports gthtxn_out[4]]
#set_property package_pin AH6 [get_ports gthtxp_out[4]]

# Commands for enabled transceiver GTHE3_CHANNEL_X0Y5
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X0Y5 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[1].*gen_gthe3_channel_inst[1].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin AF1 [get_ports gthrxn_in[5]]
#set_property package_pin AF2 [get_ports gthrxp_in[5]]
#set_property package_pin AG3 [get_ports gthtxn_out[5]]
#set_property package_pin AG4 [get_ports gthtxp_out[5]]

# Commands for enabled transceiver GTHE3_CHANNEL_X0Y6
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X0Y6 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[1].*gen_gthe3_channel_inst[2].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin AD1 [get_ports gthrxn_in[6]]
#set_property package_pin AD2 [get_ports gthrxp_in[6]]
#set_property package_pin AE3 [get_ports gthtxn_out[6]]
#set_property package_pin AE4 [get_ports gthtxp_out[6]]

# Commands for enabled transceiver GTHE3_CHANNEL_X0Y7
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X0Y7 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[1].*gen_gthe3_channel_inst[3].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin AB1 [get_ports gthrxn_in[7]]
#set_property package_pin AB2 [get_ports gthrxp_in[7]]
#set_property package_pin AC3 [get_ports gthtxn_out[7]]
#set_property package_pin AC4 [get_ports gthtxp_out[7]]


# False path constraints
# ----------------------------------------------------------------------------------------------------------------------



