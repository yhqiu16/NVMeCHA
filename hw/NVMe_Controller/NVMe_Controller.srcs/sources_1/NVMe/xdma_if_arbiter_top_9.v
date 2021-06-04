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
// Create Date: 10/12/2020
// Design Name: 
// Module Name: xdma_if_arbiter_top_9
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module xdma_if_arbiter_top_9#(
    parameter DATA_WIDTH      = 256,
    parameter ARBITER_LOW_BIT = 12
)(
    input                       clk,
    input                       rst_n,
    
    // C2H DMA descriptor for CQ
    input                        c2h_dsc_byp_ready_0,   
    output                       c2h_dsc_byp_load_0, 
    output [63 : 0]              c2h_dsc_byp_src_addr_0,   
    output [63 : 0]              c2h_dsc_byp_dst_addr_0,   
    output [27 : 0]              c2h_dsc_byp_len_0,   
    output [15 : 0]              c2h_dsc_byp_ctl_0,   
    // H2C DMA descriptor for SQ 
    input                        h2c_dsc_byp_ready_0,   
    output                       h2c_dsc_byp_load_0, 
    output [63 : 0]              h2c_dsc_byp_src_addr_0,   
    output [63 : 0]              h2c_dsc_byp_dst_addr_0,   
    output [27 : 0]              h2c_dsc_byp_len_0,   
    output [15 : 0]              h2c_dsc_byp_ctl_0,  
    
    // C2H DMA descriptor for reading data
    input                        c2h_dsc_byp_ready_1,   
    output                       c2h_dsc_byp_load_1, 
    output [63 : 0]              c2h_dsc_byp_src_addr_1,   
    output [63 : 0]              c2h_dsc_byp_dst_addr_1,   
    output [27 : 0]              c2h_dsc_byp_len_1,   
    output [15 : 0]              c2h_dsc_byp_ctl_1,   
    // H2C DMA descriptor for programming data
    input                        h2c_dsc_byp_ready_1,   
    output                       h2c_dsc_byp_load_1, 
    output [63 : 0]              h2c_dsc_byp_src_addr_1,   
    output [63 : 0]              h2c_dsc_byp_dst_addr_1,   
    output [27 : 0]              h2c_dsc_byp_len_1,   
    output [15 : 0]              h2c_dsc_byp_ctl_1, 

    // C2H DMA descriptor for CQ
    input                        c2h_dsc_byp_ready_2,   
    output                       c2h_dsc_byp_load_2, 
    output [63 : 0]              c2h_dsc_byp_src_addr_2,   
    output [63 : 0]              c2h_dsc_byp_dst_addr_2,   
    output [27 : 0]              c2h_dsc_byp_len_2,   
    output [15 : 0]              c2h_dsc_byp_ctl_2,   
    // H2C DMA descriptor for SQ 
    input                        h2c_dsc_byp_ready_2,   
    output                       h2c_dsc_byp_load_2, 
    output [63 : 0]              h2c_dsc_byp_src_addr_2,   
    output [63 : 0]              h2c_dsc_byp_dst_addr_2,   
    output [27 : 0]              h2c_dsc_byp_len_2,   
    output [15 : 0]              h2c_dsc_byp_ctl_2,  
    
    // C2H DMA descriptor for reading data
    input                        c2h_dsc_byp_ready_3,   
    output                       c2h_dsc_byp_load_3, 
    output [63 : 0]              c2h_dsc_byp_src_addr_3,   
    output [63 : 0]              c2h_dsc_byp_dst_addr_3,   
    output [27 : 0]              c2h_dsc_byp_len_3,   
    output [15 : 0]              c2h_dsc_byp_ctl_3,   
    // H2C DMA descriptor for programming data
    input                        h2c_dsc_byp_ready_3,   
    output                       h2c_dsc_byp_load_3, 
    output [63 : 0]              h2c_dsc_byp_src_addr_3,   
    output [63 : 0]              h2c_dsc_byp_dst_addr_3,   
    output [27 : 0]              h2c_dsc_byp_len_3,   
    output [15 : 0]              h2c_dsc_byp_ctl_3,   
    
    // AXI ST interface to fetch cmd submission data
    output                       axis_h2c_tready_0,
    input                        axis_h2c_tvalid_0,
    input  [DATA_WIDTH-1:0]      axis_h2c_tdata_0,
    input  [DATA_WIDTH/8-1:0]    axis_h2c_tkeep_0,
    input                        axis_h2c_tlast_0,         
    // AXI ST interface to submit cmd completion data
    input                        axis_c2h_tready_0,
    output                       axis_c2h_tvalid_0,
    output [DATA_WIDTH-1:0]      axis_c2h_tdata_0,
    output [DATA_WIDTH/8-1:0]    axis_c2h_tkeep_0,
    output                       axis_c2h_tlast_0,
    
    // AXI ST interface to fetch programming data
    output                       axis_h2c_tready_1,
    input                        axis_h2c_tvalid_1,
    input  [DATA_WIDTH-1:0]      axis_h2c_tdata_1,
    input  [DATA_WIDTH/8-1:0]    axis_h2c_tkeep_1,
    input                        axis_h2c_tlast_1,         
    // AXI ST interface to submit reading data
    input                        axis_c2h_tready_1,
    output                       axis_c2h_tvalid_1,
    output [DATA_WIDTH-1:0]      axis_c2h_tdata_1,
    output [DATA_WIDTH/8-1:0]    axis_c2h_tkeep_1,
    output                       axis_c2h_tlast_1,

    // AXI ST interface to fetch cmd submission data
    output                       axis_h2c_tready_2,
    input                        axis_h2c_tvalid_2,
    input  [DATA_WIDTH-1:0]      axis_h2c_tdata_2,
    input  [DATA_WIDTH/8-1:0]    axis_h2c_tkeep_2,
    input                        axis_h2c_tlast_2,         
    // AXI ST interface to submit cmd completion data
    input                        axis_c2h_tready_2,
    output                       axis_c2h_tvalid_2,
    output [DATA_WIDTH-1:0]      axis_c2h_tdata_2,
    output [DATA_WIDTH/8-1:0]    axis_c2h_tkeep_2,
    output                       axis_c2h_tlast_2,
    
    // AXI ST interface to fetch programming data
    output                       axis_h2c_tready_3,
    input                        axis_h2c_tvalid_3,
    input  [DATA_WIDTH-1:0]      axis_h2c_tdata_3,
    input  [DATA_WIDTH/8-1:0]    axis_h2c_tkeep_3,
    input                        axis_h2c_tlast_3,         
    // AXI ST interface to submit reading data
    input                        axis_c2h_tready_3,
    output                       axis_c2h_tvalid_3,
    output [DATA_WIDTH-1:0]      axis_c2h_tdata_3,
    output [DATA_WIDTH/8-1:0]    axis_c2h_tkeep_3,
    output                       axis_c2h_tlast_3,

    // NVMe Controller side interfaces for SQ&CQ entries transfer
    output                      a_h2c_dsc_byp_ready_0,   
    input                       a_h2c_dsc_byp_load_0, 
    input [63 : 0]              a_h2c_dsc_byp_src_addr_0,   
    input [63 : 0]              a_h2c_dsc_byp_dst_addr_0,   
    input [27 : 0]              a_h2c_dsc_byp_len_0,   
    input [15 : 0]              a_h2c_dsc_byp_ctl_0, 
    output                      a_c2h_dsc_byp_ready_0,   
    input                       a_c2h_dsc_byp_load_0, 
    input [63 : 0]              a_c2h_dsc_byp_src_addr_0,   
    input [63 : 0]              a_c2h_dsc_byp_dst_addr_0,   
    input [27 : 0]              a_c2h_dsc_byp_len_0,   
    input [15 : 0]              a_c2h_dsc_byp_ctl_0, 
    input                       a_axis_h2c_tready_0,
    output                      a_axis_h2c_tvalid_0,
    output [DATA_WIDTH-1:0]     a_axis_h2c_tdata_0,
    output [DATA_WIDTH/8-1:0]   a_axis_h2c_tkeep_0,
    output                      a_axis_h2c_tlast_0, 
    output                      a_axis_c2h_tready_0,
    input                       a_axis_c2h_tvalid_0,
    input  [DATA_WIDTH-1:0]     a_axis_c2h_tdata_0,
    input  [DATA_WIDTH/8-1:0]   a_axis_c2h_tkeep_0,
    input                       a_axis_c2h_tlast_0, 
    output                      q_h2c_dsc_byp_ready_1,   
    input                       q_h2c_dsc_byp_load_1, 
    input [63 : 0]              q_h2c_dsc_byp_src_addr_1,   
    input [63 : 0]              q_h2c_dsc_byp_dst_addr_1,   
    input [27 : 0]              q_h2c_dsc_byp_len_1,   
    input [15 : 0]              q_h2c_dsc_byp_ctl_1, 
    output                      q_c2h_dsc_byp_ready_1,   
    input                       q_c2h_dsc_byp_load_1, 
    input [63 : 0]              q_c2h_dsc_byp_src_addr_1,   
    input [63 : 0]              q_c2h_dsc_byp_dst_addr_1,   
    input [27 : 0]              q_c2h_dsc_byp_len_1,   
    input [15 : 0]              q_c2h_dsc_byp_ctl_1, 
    input                       q_axis_h2c_tready_1,
    output                      q_axis_h2c_tvalid_1,
    output [DATA_WIDTH-1:0]     q_axis_h2c_tdata_1,
    output [DATA_WIDTH/8-1:0]   q_axis_h2c_tkeep_1,
    output                      q_axis_h2c_tlast_1, 
    output                      q_axis_c2h_tready_1,
    input                       q_axis_c2h_tvalid_1,
    input  [DATA_WIDTH-1:0]     q_axis_c2h_tdata_1,
    input  [DATA_WIDTH/8-1:0]   q_axis_c2h_tkeep_1,
    input                       q_axis_c2h_tlast_1, 
    output                      q_h2c_dsc_byp_ready_2,   
    input                       q_h2c_dsc_byp_load_2, 
    input [63 : 0]              q_h2c_dsc_byp_src_addr_2,   
    input [63 : 0]              q_h2c_dsc_byp_dst_addr_2,   
    input [27 : 0]              q_h2c_dsc_byp_len_2,   
    input [15 : 0]              q_h2c_dsc_byp_ctl_2, 
    output                      q_c2h_dsc_byp_ready_2,   
    input                       q_c2h_dsc_byp_load_2, 
    input [63 : 0]              q_c2h_dsc_byp_src_addr_2,   
    input [63 : 0]              q_c2h_dsc_byp_dst_addr_2,   
    input [27 : 0]              q_c2h_dsc_byp_len_2,   
    input [15 : 0]              q_c2h_dsc_byp_ctl_2, 
    input                       q_axis_h2c_tready_2,
    output                      q_axis_h2c_tvalid_2,
    output [DATA_WIDTH-1:0]     q_axis_h2c_tdata_2,
    output [DATA_WIDTH/8-1:0]   q_axis_h2c_tkeep_2,
    output                      q_axis_h2c_tlast_2, 
    output                      q_axis_c2h_tready_2,
    input                       q_axis_c2h_tvalid_2,
    input  [DATA_WIDTH-1:0]     q_axis_c2h_tdata_2,
    input  [DATA_WIDTH/8-1:0]   q_axis_c2h_tkeep_2,
    input                       q_axis_c2h_tlast_2, 
    output                      q_h2c_dsc_byp_ready_3,   
    input                       q_h2c_dsc_byp_load_3, 
    input [63 : 0]              q_h2c_dsc_byp_src_addr_3,   
    input [63 : 0]              q_h2c_dsc_byp_dst_addr_3,   
    input [27 : 0]              q_h2c_dsc_byp_len_3,   
    input [15 : 0]              q_h2c_dsc_byp_ctl_3, 
    output                      q_c2h_dsc_byp_ready_3,   
    input                       q_c2h_dsc_byp_load_3, 
    input [63 : 0]              q_c2h_dsc_byp_src_addr_3,   
    input [63 : 0]              q_c2h_dsc_byp_dst_addr_3,   
    input [27 : 0]              q_c2h_dsc_byp_len_3,   
    input [15 : 0]              q_c2h_dsc_byp_ctl_3, 
    input                       q_axis_h2c_tready_3,
    output                      q_axis_h2c_tvalid_3,
    output [DATA_WIDTH-1:0]     q_axis_h2c_tdata_3,
    output [DATA_WIDTH/8-1:0]   q_axis_h2c_tkeep_3,
    output                      q_axis_h2c_tlast_3, 
    output                      q_axis_c2h_tready_3,
    input                       q_axis_c2h_tvalid_3,
    input  [DATA_WIDTH-1:0]     q_axis_c2h_tdata_3,
    input  [DATA_WIDTH/8-1:0]   q_axis_c2h_tkeep_3,
    input                       q_axis_c2h_tlast_3, 
    output                      q_h2c_dsc_byp_ready_4,   
    input                       q_h2c_dsc_byp_load_4, 
    input [63 : 0]              q_h2c_dsc_byp_src_addr_4,   
    input [63 : 0]              q_h2c_dsc_byp_dst_addr_4,   
    input [27 : 0]              q_h2c_dsc_byp_len_4,   
    input [15 : 0]              q_h2c_dsc_byp_ctl_4, 
    output                      q_c2h_dsc_byp_ready_4,   
    input                       q_c2h_dsc_byp_load_4, 
    input [63 : 0]              q_c2h_dsc_byp_src_addr_4,   
    input [63 : 0]              q_c2h_dsc_byp_dst_addr_4,   
    input [27 : 0]              q_c2h_dsc_byp_len_4,   
    input [15 : 0]              q_c2h_dsc_byp_ctl_4, 
    input                       q_axis_h2c_tready_4,
    output                      q_axis_h2c_tvalid_4,
    output [DATA_WIDTH-1:0]     q_axis_h2c_tdata_4,
    output [DATA_WIDTH/8-1:0]   q_axis_h2c_tkeep_4,
    output                      q_axis_h2c_tlast_4, 
    output                      q_axis_c2h_tready_4,
    input                       q_axis_c2h_tvalid_4,
    input  [DATA_WIDTH-1:0]     q_axis_c2h_tdata_4,
    input  [DATA_WIDTH/8-1:0]   q_axis_c2h_tkeep_4,
    input                       q_axis_c2h_tlast_4, 
    output                      q_h2c_dsc_byp_ready_5,   
    input                       q_h2c_dsc_byp_load_5, 
    input [63 : 0]              q_h2c_dsc_byp_src_addr_5,   
    input [63 : 0]              q_h2c_dsc_byp_dst_addr_5,   
    input [27 : 0]              q_h2c_dsc_byp_len_5,   
    input [15 : 0]              q_h2c_dsc_byp_ctl_5, 
    output                      q_c2h_dsc_byp_ready_5,   
    input                       q_c2h_dsc_byp_load_5, 
    input [63 : 0]              q_c2h_dsc_byp_src_addr_5,   
    input [63 : 0]              q_c2h_dsc_byp_dst_addr_5,   
    input [27 : 0]              q_c2h_dsc_byp_len_5,   
    input [15 : 0]              q_c2h_dsc_byp_ctl_5, 
    input                       q_axis_h2c_tready_5,
    output                      q_axis_h2c_tvalid_5,
    output [DATA_WIDTH-1:0]     q_axis_h2c_tdata_5,
    output [DATA_WIDTH/8-1:0]   q_axis_h2c_tkeep_5,
    output                      q_axis_h2c_tlast_5, 
    output                      q_axis_c2h_tready_5,
    input                       q_axis_c2h_tvalid_5,
    input  [DATA_WIDTH-1:0]     q_axis_c2h_tdata_5,
    input  [DATA_WIDTH/8-1:0]   q_axis_c2h_tkeep_5,
    input                       q_axis_c2h_tlast_5, 
    output                      q_h2c_dsc_byp_ready_6,   
    input                       q_h2c_dsc_byp_load_6, 
    input [63 : 0]              q_h2c_dsc_byp_src_addr_6,   
    input [63 : 0]              q_h2c_dsc_byp_dst_addr_6,   
    input [27 : 0]              q_h2c_dsc_byp_len_6,   
    input [15 : 0]              q_h2c_dsc_byp_ctl_6, 
    output                      q_c2h_dsc_byp_ready_6,   
    input                       q_c2h_dsc_byp_load_6, 
    input [63 : 0]              q_c2h_dsc_byp_src_addr_6,   
    input [63 : 0]              q_c2h_dsc_byp_dst_addr_6,   
    input [27 : 0]              q_c2h_dsc_byp_len_6,   
    input [15 : 0]              q_c2h_dsc_byp_ctl_6, 
    input                       q_axis_h2c_tready_6,
    output                      q_axis_h2c_tvalid_6,
    output [DATA_WIDTH-1:0]     q_axis_h2c_tdata_6,
    output [DATA_WIDTH/8-1:0]   q_axis_h2c_tkeep_6,
    output                      q_axis_h2c_tlast_6, 
    output                      q_axis_c2h_tready_6,
    input                       q_axis_c2h_tvalid_6,
    input  [DATA_WIDTH-1:0]     q_axis_c2h_tdata_6,
    input  [DATA_WIDTH/8-1:0]   q_axis_c2h_tkeep_6,
    input                       q_axis_c2h_tlast_6, 
    output                      q_h2c_dsc_byp_ready_7,   
    input                       q_h2c_dsc_byp_load_7, 
    input [63 : 0]              q_h2c_dsc_byp_src_addr_7,   
    input [63 : 0]              q_h2c_dsc_byp_dst_addr_7,   
    input [27 : 0]              q_h2c_dsc_byp_len_7,   
    input [15 : 0]              q_h2c_dsc_byp_ctl_7, 
    output                      q_c2h_dsc_byp_ready_7,   
    input                       q_c2h_dsc_byp_load_7, 
    input [63 : 0]              q_c2h_dsc_byp_src_addr_7,   
    input [63 : 0]              q_c2h_dsc_byp_dst_addr_7,   
    input [27 : 0]              q_c2h_dsc_byp_len_7,   
    input [15 : 0]              q_c2h_dsc_byp_ctl_7, 
    input                       q_axis_h2c_tready_7,
    output                      q_axis_h2c_tvalid_7,
    output [DATA_WIDTH-1:0]     q_axis_h2c_tdata_7,
    output [DATA_WIDTH/8-1:0]   q_axis_h2c_tkeep_7,
    output                      q_axis_h2c_tlast_7, 
    output                      q_axis_c2h_tready_7,
    input                       q_axis_c2h_tvalid_7,
    input  [DATA_WIDTH-1:0]     q_axis_c2h_tdata_7,
    input  [DATA_WIDTH/8-1:0]   q_axis_c2h_tkeep_7,
    input                       q_axis_c2h_tlast_7, 
    output                      q_h2c_dsc_byp_ready_8,   
    input                       q_h2c_dsc_byp_load_8, 
    input [63 : 0]              q_h2c_dsc_byp_src_addr_8,   
    input [63 : 0]              q_h2c_dsc_byp_dst_addr_8,   
    input [27 : 0]              q_h2c_dsc_byp_len_8,   
    input [15 : 0]              q_h2c_dsc_byp_ctl_8, 
    output                      q_c2h_dsc_byp_ready_8,   
    input                       q_c2h_dsc_byp_load_8, 
    input [63 : 0]              q_c2h_dsc_byp_src_addr_8,   
    input [63 : 0]              q_c2h_dsc_byp_dst_addr_8,   
    input [27 : 0]              q_c2h_dsc_byp_len_8,   
    input [15 : 0]              q_c2h_dsc_byp_ctl_8, 
    input                       q_axis_h2c_tready_8,
    output                      q_axis_h2c_tvalid_8,
    output [DATA_WIDTH-1:0]     q_axis_h2c_tdata_8,
    output [DATA_WIDTH/8-1:0]   q_axis_h2c_tkeep_8,
    output                      q_axis_h2c_tlast_8, 
    output                      q_axis_c2h_tready_8,
    input                       q_axis_c2h_tvalid_8,
    input  [DATA_WIDTH-1:0]     q_axis_c2h_tdata_8,
    input  [DATA_WIDTH/8-1:0]   q_axis_c2h_tkeep_8,
    input                       q_axis_c2h_tlast_8, 

    // NVMe Controller side interfaces for data transfer
    output                      d_h2c_dsc_byp_ready_1,   
    input                       d_h2c_dsc_byp_load_1, 
    input [63 : 0]              d_h2c_dsc_byp_src_addr_1,   
    input [63 : 0]              d_h2c_dsc_byp_dst_addr_1,   
    input [27 : 0]              d_h2c_dsc_byp_len_1,   
    input [15 : 0]              d_h2c_dsc_byp_ctl_1, 
    output                      d_c2h_dsc_byp_ready_1,   
    input                       d_c2h_dsc_byp_load_1, 
    input [63 : 0]              d_c2h_dsc_byp_src_addr_1,   
    input [63 : 0]              d_c2h_dsc_byp_dst_addr_1,   
    input [27 : 0]              d_c2h_dsc_byp_len_1,   
    input [15 : 0]              d_c2h_dsc_byp_ctl_1, 
    input                       d_axis_h2c_tready_1,
    output                      d_axis_h2c_tvalid_1,
    output [DATA_WIDTH-1:0]     d_axis_h2c_tdata_1,
    output [DATA_WIDTH/8-1:0]   d_axis_h2c_tkeep_1,
    output                      d_axis_h2c_tlast_1, 
    output                      d_axis_c2h_tready_1,
    input                       d_axis_c2h_tvalid_1,
    input  [DATA_WIDTH-1:0]     d_axis_c2h_tdata_1,
    input  [DATA_WIDTH/8-1:0]   d_axis_c2h_tkeep_1,
    input                       d_axis_c2h_tlast_1, 
    output                      d_h2c_dsc_byp_ready_2,   
    input                       d_h2c_dsc_byp_load_2, 
    input [63 : 0]              d_h2c_dsc_byp_src_addr_2,   
    input [63 : 0]              d_h2c_dsc_byp_dst_addr_2,   
    input [27 : 0]              d_h2c_dsc_byp_len_2,   
    input [15 : 0]              d_h2c_dsc_byp_ctl_2, 
    output                      d_c2h_dsc_byp_ready_2,   
    input                       d_c2h_dsc_byp_load_2, 
    input [63 : 0]              d_c2h_dsc_byp_src_addr_2,   
    input [63 : 0]              d_c2h_dsc_byp_dst_addr_2,   
    input [27 : 0]              d_c2h_dsc_byp_len_2,   
    input [15 : 0]              d_c2h_dsc_byp_ctl_2, 
    input                       d_axis_h2c_tready_2,
    output                      d_axis_h2c_tvalid_2,
    output [DATA_WIDTH-1:0]     d_axis_h2c_tdata_2,
    output [DATA_WIDTH/8-1:0]   d_axis_h2c_tkeep_2,
    output                      d_axis_h2c_tlast_2, 
    output                      d_axis_c2h_tready_2,
    input                       d_axis_c2h_tvalid_2,
    input  [DATA_WIDTH-1:0]     d_axis_c2h_tdata_2,
    input  [DATA_WIDTH/8-1:0]   d_axis_c2h_tkeep_2,
    input                       d_axis_c2h_tlast_2, 
    output                      d_h2c_dsc_byp_ready_3,   
    input                       d_h2c_dsc_byp_load_3, 
    input [63 : 0]              d_h2c_dsc_byp_src_addr_3,   
    input [63 : 0]              d_h2c_dsc_byp_dst_addr_3,   
    input [27 : 0]              d_h2c_dsc_byp_len_3,   
    input [15 : 0]              d_h2c_dsc_byp_ctl_3, 
    output                      d_c2h_dsc_byp_ready_3,   
    input                       d_c2h_dsc_byp_load_3, 
    input [63 : 0]              d_c2h_dsc_byp_src_addr_3,   
    input [63 : 0]              d_c2h_dsc_byp_dst_addr_3,   
    input [27 : 0]              d_c2h_dsc_byp_len_3,   
    input [15 : 0]              d_c2h_dsc_byp_ctl_3, 
    input                       d_axis_h2c_tready_3,
    output                      d_axis_h2c_tvalid_3,
    output [DATA_WIDTH-1:0]     d_axis_h2c_tdata_3,
    output [DATA_WIDTH/8-1:0]   d_axis_h2c_tkeep_3,
    output                      d_axis_h2c_tlast_3, 
    output                      d_axis_c2h_tready_3,
    input                       d_axis_c2h_tvalid_3,
    input  [DATA_WIDTH-1:0]     d_axis_c2h_tdata_3,
    input  [DATA_WIDTH/8-1:0]   d_axis_c2h_tkeep_3,
    input                       d_axis_c2h_tlast_3, 
    output                      d_h2c_dsc_byp_ready_4,   
    input                       d_h2c_dsc_byp_load_4, 
    input [63 : 0]              d_h2c_dsc_byp_src_addr_4,   
    input [63 : 0]              d_h2c_dsc_byp_dst_addr_4,   
    input [27 : 0]              d_h2c_dsc_byp_len_4,   
    input [15 : 0]              d_h2c_dsc_byp_ctl_4, 
    output                      d_c2h_dsc_byp_ready_4,   
    input                       d_c2h_dsc_byp_load_4, 
    input [63 : 0]              d_c2h_dsc_byp_src_addr_4,   
    input [63 : 0]              d_c2h_dsc_byp_dst_addr_4,   
    input [27 : 0]              d_c2h_dsc_byp_len_4,   
    input [15 : 0]              d_c2h_dsc_byp_ctl_4, 
    input                       d_axis_h2c_tready_4,
    output                      d_axis_h2c_tvalid_4,
    output [DATA_WIDTH-1:0]     d_axis_h2c_tdata_4,
    output [DATA_WIDTH/8-1:0]   d_axis_h2c_tkeep_4,
    output                      d_axis_h2c_tlast_4, 
    output                      d_axis_c2h_tready_4,
    input                       d_axis_c2h_tvalid_4,
    input  [DATA_WIDTH-1:0]     d_axis_c2h_tdata_4,
    input  [DATA_WIDTH/8-1:0]   d_axis_c2h_tkeep_4,
    input                       d_axis_c2h_tlast_4, 
    output                      d_h2c_dsc_byp_ready_5,   
    input                       d_h2c_dsc_byp_load_5, 
    input [63 : 0]              d_h2c_dsc_byp_src_addr_5,   
    input [63 : 0]              d_h2c_dsc_byp_dst_addr_5,   
    input [27 : 0]              d_h2c_dsc_byp_len_5,   
    input [15 : 0]              d_h2c_dsc_byp_ctl_5, 
    output                      d_c2h_dsc_byp_ready_5,   
    input                       d_c2h_dsc_byp_load_5, 
    input [63 : 0]              d_c2h_dsc_byp_src_addr_5,   
    input [63 : 0]              d_c2h_dsc_byp_dst_addr_5,   
    input [27 : 0]              d_c2h_dsc_byp_len_5,   
    input [15 : 0]              d_c2h_dsc_byp_ctl_5, 
    input                       d_axis_h2c_tready_5,
    output                      d_axis_h2c_tvalid_5,
    output [DATA_WIDTH-1:0]     d_axis_h2c_tdata_5,
    output [DATA_WIDTH/8-1:0]   d_axis_h2c_tkeep_5,
    output                      d_axis_h2c_tlast_5, 
    output                      d_axis_c2h_tready_5,
    input                       d_axis_c2h_tvalid_5,
    input  [DATA_WIDTH-1:0]     d_axis_c2h_tdata_5,
    input  [DATA_WIDTH/8-1:0]   d_axis_c2h_tkeep_5,
    input                       d_axis_c2h_tlast_5, 
    output                      d_h2c_dsc_byp_ready_6,   
    input                       d_h2c_dsc_byp_load_6, 
    input [63 : 0]              d_h2c_dsc_byp_src_addr_6,   
    input [63 : 0]              d_h2c_dsc_byp_dst_addr_6,   
    input [27 : 0]              d_h2c_dsc_byp_len_6,   
    input [15 : 0]              d_h2c_dsc_byp_ctl_6, 
    output                      d_c2h_dsc_byp_ready_6,   
    input                       d_c2h_dsc_byp_load_6, 
    input [63 : 0]              d_c2h_dsc_byp_src_addr_6,   
    input [63 : 0]              d_c2h_dsc_byp_dst_addr_6,   
    input [27 : 0]              d_c2h_dsc_byp_len_6,   
    input [15 : 0]              d_c2h_dsc_byp_ctl_6, 
    input                       d_axis_h2c_tready_6,
    output                      d_axis_h2c_tvalid_6,
    output [DATA_WIDTH-1:0]     d_axis_h2c_tdata_6,
    output [DATA_WIDTH/8-1:0]   d_axis_h2c_tkeep_6,
    output                      d_axis_h2c_tlast_6, 
    output                      d_axis_c2h_tready_6,
    input                       d_axis_c2h_tvalid_6,
    input  [DATA_WIDTH-1:0]     d_axis_c2h_tdata_6,
    input  [DATA_WIDTH/8-1:0]   d_axis_c2h_tkeep_6,
    input                       d_axis_c2h_tlast_6, 
    output                      d_h2c_dsc_byp_ready_7,   
    input                       d_h2c_dsc_byp_load_7, 
    input [63 : 0]              d_h2c_dsc_byp_src_addr_7,   
    input [63 : 0]              d_h2c_dsc_byp_dst_addr_7,   
    input [27 : 0]              d_h2c_dsc_byp_len_7,   
    input [15 : 0]              d_h2c_dsc_byp_ctl_7, 
    output                      d_c2h_dsc_byp_ready_7,   
    input                       d_c2h_dsc_byp_load_7, 
    input [63 : 0]              d_c2h_dsc_byp_src_addr_7,   
    input [63 : 0]              d_c2h_dsc_byp_dst_addr_7,   
    input [27 : 0]              d_c2h_dsc_byp_len_7,   
    input [15 : 0]              d_c2h_dsc_byp_ctl_7, 
    input                       d_axis_h2c_tready_7,
    output                      d_axis_h2c_tvalid_7,
    output [DATA_WIDTH-1:0]     d_axis_h2c_tdata_7,
    output [DATA_WIDTH/8-1:0]   d_axis_h2c_tkeep_7,
    output                      d_axis_h2c_tlast_7, 
    output                      d_axis_c2h_tready_7,
    input                       d_axis_c2h_tvalid_7,
    input  [DATA_WIDTH-1:0]     d_axis_c2h_tdata_7,
    input  [DATA_WIDTH/8-1:0]   d_axis_c2h_tkeep_7,
    input                       d_axis_c2h_tlast_7, 
    output                      d_h2c_dsc_byp_ready_8,   
    input                       d_h2c_dsc_byp_load_8, 
    input [63 : 0]              d_h2c_dsc_byp_src_addr_8,   
    input [63 : 0]              d_h2c_dsc_byp_dst_addr_8,   
    input [27 : 0]              d_h2c_dsc_byp_len_8,   
    input [15 : 0]              d_h2c_dsc_byp_ctl_8, 
    output                      d_c2h_dsc_byp_ready_8,   
    input                       d_c2h_dsc_byp_load_8, 
    input [63 : 0]              d_c2h_dsc_byp_src_addr_8,   
    input [63 : 0]              d_c2h_dsc_byp_dst_addr_8,   
    input [27 : 0]              d_c2h_dsc_byp_len_8,   
    input [15 : 0]              d_c2h_dsc_byp_ctl_8, 
    input                       d_axis_h2c_tready_8,
    output                      d_axis_h2c_tvalid_8,
    output [DATA_WIDTH-1:0]     d_axis_h2c_tdata_8,
    output [DATA_WIDTH/8-1:0]   d_axis_h2c_tkeep_8,
    output                      d_axis_h2c_tlast_8, 
    output                      d_axis_c2h_tready_8,
    input                       d_axis_c2h_tvalid_8,
    input  [DATA_WIDTH-1:0]     d_axis_c2h_tdata_8,
    input  [DATA_WIDTH/8-1:0]   d_axis_c2h_tkeep_8,
    input                       d_axis_c2h_tlast_8
);


wire                       t_h2c_dsc_byp_ready;   
wire                       t_h2c_dsc_byp_load; 
wire [63 : 0]              t_h2c_dsc_byp_src_addr;   
wire [63 : 0]              t_h2c_dsc_byp_dst_addr;   
wire [27 : 0]              t_h2c_dsc_byp_len;   
wire [15 : 0]              t_h2c_dsc_byp_ctl; 

wire                       t_axis_h2c_tready;
wire                       t_axis_h2c_tvalid;
wire [  DATA_WIDTH-1:0]    t_axis_h2c_tdata;
wire [  DATA_WIDTH/8-1:0]  t_axis_h2c_tkeep;
wire                       t_axis_h2c_tlast; 

wire                       t_c2h_dsc_byp_ready;   
wire                       t_c2h_dsc_byp_load; 
wire [63 : 0]              t_c2h_dsc_byp_src_addr;   
wire [63 : 0]              t_c2h_dsc_byp_dst_addr;   
wire [27 : 0]              t_c2h_dsc_byp_len;   
wire [15 : 0]              t_c2h_dsc_byp_ctl; 

wire                       t_axis_c2h_tready;
wire                       t_axis_c2h_tvalid;
wire [  DATA_WIDTH-1:0]    t_axis_c2h_tdata;
wire [  DATA_WIDTH/8-1:0]  t_axis_c2h_tkeep;
wire                       t_axis_c2h_tlast; 



xdma_h2c_arbiter_two #(
    .ARBITER_LOW_BIT (12)
) xdma_h2c_arbiter_que_0_1(
    .clk                      (clk                     ),      
    .rst_n                    (rst_n                   ),        
    
    .m_h2c_dsc_byp_ready      (h2c_dsc_byp_ready_0     ),                         
    .m_h2c_dsc_byp_load       (h2c_dsc_byp_load_0      ),                      
    .m_h2c_dsc_byp_src_addr   (h2c_dsc_byp_src_addr_0  ),                            
    .m_h2c_dsc_byp_dst_addr   (h2c_dsc_byp_dst_addr_0  ),                            
    .m_h2c_dsc_byp_len        (h2c_dsc_byp_len_0       ),                       
    .m_h2c_dsc_byp_ctl        (h2c_dsc_byp_ctl_0       ),                     
    
    .s_axis_h2c_tready        (axis_h2c_tready_0       ),                    
    .s_axis_h2c_tvalid        (axis_h2c_tvalid_0       ),                    
    .s_axis_h2c_tdata         (axis_h2c_tdata_0        ),                   
    .s_axis_h2c_tkeep         (axis_h2c_tkeep_0        ),                   
    .s_axis_h2c_tlast         (axis_h2c_tlast_0        ),                    
    
    .s_h2c_dsc_byp_ready_0    (t_h2c_dsc_byp_ready     ),                           
    .s_h2c_dsc_byp_load_0     (t_h2c_dsc_byp_load      ),                        
    .s_h2c_dsc_byp_src_addr_0 (t_h2c_dsc_byp_src_addr  ),                              
    .s_h2c_dsc_byp_dst_addr_0 (64'h0000                ),                             
    .s_h2c_dsc_byp_len_0      (t_h2c_dsc_byp_len       ),                         
    .s_h2c_dsc_byp_ctl_0      (t_h2c_dsc_byp_ctl       ),                       
      
    .m_axis_h2c_tready_0      (t_axis_h2c_tready       ),                      
    .m_axis_h2c_tvalid_0      (t_axis_h2c_tvalid       ),                      
    .m_axis_h2c_tdata_0       (t_axis_h2c_tdata        ),                     
    .m_axis_h2c_tkeep_0       (t_axis_h2c_tkeep        ),                     
    .m_axis_h2c_tlast_0       (t_axis_h2c_tlast        ),                      
    
    .s_h2c_dsc_byp_ready_1    (a_h2c_dsc_byp_ready_0   ),                           
    .s_h2c_dsc_byp_load_1     (a_h2c_dsc_byp_load_0    ),                        
    .s_h2c_dsc_byp_src_addr_1 (a_h2c_dsc_byp_src_addr_0),                              
    .s_h2c_dsc_byp_dst_addr_1 (64'h1000                ),                              
    .s_h2c_dsc_byp_len_1      (a_h2c_dsc_byp_len_0     ),                         
    .s_h2c_dsc_byp_ctl_1      (a_h2c_dsc_byp_ctl_0     ),                       
    
    .m_axis_h2c_tready_1      (a_axis_h2c_tready_0     ),                      
    .m_axis_h2c_tvalid_1      (a_axis_h2c_tvalid_0     ),                      
    .m_axis_h2c_tdata_1       (a_axis_h2c_tdata_0      ),                     
    .m_axis_h2c_tkeep_1       (a_axis_h2c_tkeep_0      ),                     
    .m_axis_h2c_tlast_1       (a_axis_h2c_tlast_0      )                        
);


xdma_c2h_arbiter_two #(
    .ARBITER_LOW_BIT (12)
) xdma_c2h_arbiter_que_0_1(
    .clk                      (clk                     ),      
    .rst_n                    (rst_n                   ),        
    
    .m_c2h_dsc_byp_ready      (c2h_dsc_byp_ready_0     ),                         
    .m_c2h_dsc_byp_load       (c2h_dsc_byp_load_0      ),                      
    .m_c2h_dsc_byp_src_addr   (c2h_dsc_byp_src_addr_0  ),                            
    .m_c2h_dsc_byp_dst_addr   (c2h_dsc_byp_dst_addr_0  ),                            
    .m_c2h_dsc_byp_len        (c2h_dsc_byp_len_0       ),                       
    .m_c2h_dsc_byp_ctl        (c2h_dsc_byp_ctl_0       ),                     
    
    .m_axis_c2h_tready        (axis_c2h_tready_0       ),                    
    .m_axis_c2h_tvalid        (axis_c2h_tvalid_0       ),                    
    .m_axis_c2h_tdata         (axis_c2h_tdata_0        ),                   
    .m_axis_c2h_tkeep         (axis_c2h_tkeep_0        ),                   
    .m_axis_c2h_tlast         (axis_c2h_tlast_0        ),                    
    
    .s_c2h_dsc_byp_ready_0    (t_c2h_dsc_byp_ready     ),                           
    .s_c2h_dsc_byp_load_0     (t_c2h_dsc_byp_load      ),                        
    .s_c2h_dsc_byp_src_addr_0 (64'h0000                ),                              
    .s_c2h_dsc_byp_dst_addr_0 (t_c2h_dsc_byp_dst_addr  ),                             
    .s_c2h_dsc_byp_len_0      (t_c2h_dsc_byp_len       ),                         
    .s_c2h_dsc_byp_ctl_0      (t_c2h_dsc_byp_ctl       ),                       
      
    .s_axis_c2h_tready_0      (t_axis_c2h_tready       ),                      
    .s_axis_c2h_tvalid_0      (t_axis_c2h_tvalid       ),                      
    .s_axis_c2h_tdata_0       (t_axis_c2h_tdata        ),                     
    .s_axis_c2h_tkeep_0       (t_axis_c2h_tkeep        ),                     
    .s_axis_c2h_tlast_0       (t_axis_c2h_tlast        ),                      
    
    .s_c2h_dsc_byp_ready_1    (a_c2h_dsc_byp_ready_0   ),                           
    .s_c2h_dsc_byp_load_1     (a_c2h_dsc_byp_load_0    ),                        
    .s_c2h_dsc_byp_src_addr_1 (64'h1000                ),                              
    .s_c2h_dsc_byp_dst_addr_1 (a_c2h_dsc_byp_dst_addr_0),                              
    .s_c2h_dsc_byp_len_1      (a_c2h_dsc_byp_len_0     ),                         
    .s_c2h_dsc_byp_ctl_1      (a_c2h_dsc_byp_ctl_0     ),                       
    
    .s_axis_c2h_tready_1      (a_axis_c2h_tready_0     ),                      
    .s_axis_c2h_tvalid_1      (a_axis_c2h_tvalid_0     ),                      
    .s_axis_c2h_tdata_1       (a_axis_c2h_tdata_0      ),                     
    .s_axis_c2h_tkeep_1       (a_axis_c2h_tkeep_0      ),                     
    .s_axis_c2h_tlast_1       (a_axis_c2h_tlast_0      )
);



xdma_h2c_arbiter_four#(
    .ARBITER_LOW_BIT (12)
) xdma_h2c_arbiter_que_1_4(
    .clk                      (clk                     ),      
    .rst_n                    (rst_n                   ),        
    
    .m_h2c_dsc_byp_ready      (t_h2c_dsc_byp_ready     ),                         
    .m_h2c_dsc_byp_load       (t_h2c_dsc_byp_load      ),                      
    .m_h2c_dsc_byp_src_addr   (t_h2c_dsc_byp_src_addr  ),                            
    .m_h2c_dsc_byp_dst_addr   (t_h2c_dsc_byp_dst_addr  ),                            
    .m_h2c_dsc_byp_len        (t_h2c_dsc_byp_len       ),                       
    .m_h2c_dsc_byp_ctl        (t_h2c_dsc_byp_ctl       ),                     
    
    .s_axis_h2c_tready        (t_axis_h2c_tready       ),                    
    .s_axis_h2c_tvalid        (t_axis_h2c_tvalid       ),                    
    .s_axis_h2c_tdata         (t_axis_h2c_tdata        ),                   
    .s_axis_h2c_tkeep         (t_axis_h2c_tkeep        ),                   
    .s_axis_h2c_tlast         (t_axis_h2c_tlast        ),                    
    
    .s_h2c_dsc_byp_ready_0    (q_h2c_dsc_byp_ready_1   ),                           
    .s_h2c_dsc_byp_load_0     (q_h2c_dsc_byp_load_1    ),                        
    .s_h2c_dsc_byp_src_addr_0 (q_h2c_dsc_byp_src_addr_1),                              
    .s_h2c_dsc_byp_dst_addr_0 (64'h0000                ),                             
    .s_h2c_dsc_byp_len_0      (q_h2c_dsc_byp_len_1     ),                         
    .s_h2c_dsc_byp_ctl_0      (q_h2c_dsc_byp_ctl_1     ),                       
    
    .m_axis_h2c_tready_0      (q_axis_h2c_tready_1     ),                      
    .m_axis_h2c_tvalid_0      (q_axis_h2c_tvalid_1     ),                      
    .m_axis_h2c_tdata_0       (q_axis_h2c_tdata_1      ),                     
    .m_axis_h2c_tkeep_0       (q_axis_h2c_tkeep_1      ),                     
    .m_axis_h2c_tlast_0       (q_axis_h2c_tlast_1      ),                      
    
    .s_h2c_dsc_byp_ready_1    (q_h2c_dsc_byp_ready_2   ),                           
    .s_h2c_dsc_byp_load_1     (q_h2c_dsc_byp_load_2    ),                        
    .s_h2c_dsc_byp_src_addr_1 (q_h2c_dsc_byp_src_addr_2),                              
    .s_h2c_dsc_byp_dst_addr_1 (64'h1000                ),                              
    .s_h2c_dsc_byp_len_1      (q_h2c_dsc_byp_len_2     ),                         
    .s_h2c_dsc_byp_ctl_1      (q_h2c_dsc_byp_ctl_2     ),                       
    
    .m_axis_h2c_tready_1      (q_axis_h2c_tready_2     ),                      
    .m_axis_h2c_tvalid_1      (q_axis_h2c_tvalid_2     ),                      
    .m_axis_h2c_tdata_1       (q_axis_h2c_tdata_2      ),                     
    .m_axis_h2c_tkeep_1       (q_axis_h2c_tkeep_2      ),                     
    .m_axis_h2c_tlast_1       (q_axis_h2c_tlast_2      ),                      
    
    .s_h2c_dsc_byp_ready_2    (q_h2c_dsc_byp_ready_3   ),                           
    .s_h2c_dsc_byp_load_2     (q_h2c_dsc_byp_load_3    ),                        
    .s_h2c_dsc_byp_src_addr_2 (q_h2c_dsc_byp_src_addr_3),                              
    .s_h2c_dsc_byp_dst_addr_2 (64'h2000                ),                              
    .s_h2c_dsc_byp_len_2      (q_h2c_dsc_byp_len_3     ),                         
    .s_h2c_dsc_byp_ctl_2      (q_h2c_dsc_byp_ctl_3     ),                       
    
    .m_axis_h2c_tready_2      (q_axis_h2c_tready_3     ),                      
    .m_axis_h2c_tvalid_2      (q_axis_h2c_tvalid_3     ),                      
    .m_axis_h2c_tdata_2       (q_axis_h2c_tdata_3      ),                     
    .m_axis_h2c_tkeep_2       (q_axis_h2c_tkeep_3      ),                     
    .m_axis_h2c_tlast_2       (q_axis_h2c_tlast_3      ),                      
    
    .s_h2c_dsc_byp_ready_3    (q_h2c_dsc_byp_ready_4   ),                           
    .s_h2c_dsc_byp_load_3     (q_h2c_dsc_byp_load_4    ),                        
    .s_h2c_dsc_byp_src_addr_3 (q_h2c_dsc_byp_src_addr_4),                              
    .s_h2c_dsc_byp_dst_addr_3 (64'h3000                ),                              
    .s_h2c_dsc_byp_len_3      (q_h2c_dsc_byp_len_4     ),                         
    .s_h2c_dsc_byp_ctl_3      (q_h2c_dsc_byp_ctl_4     ),                       

    .m_axis_h2c_tready_3      (q_axis_h2c_tready_4     ),                      
    .m_axis_h2c_tvalid_3      (q_axis_h2c_tvalid_4     ),                      
    .m_axis_h2c_tdata_3       (q_axis_h2c_tdata_4      ),                     
    .m_axis_h2c_tkeep_3       (q_axis_h2c_tkeep_4      ),                     
    .m_axis_h2c_tlast_3       (q_axis_h2c_tlast_4      )                          
);


xdma_c2h_arbiter_four#(
    .ARBITER_LOW_BIT (12)
) xdma_c2h_arbiter_que_1_4(
    .clk                      (clk                     ),      
    .rst_n                    (rst_n                   ),        
    
    .m_c2h_dsc_byp_ready      (t_c2h_dsc_byp_ready     ),                         
    .m_c2h_dsc_byp_load       (t_c2h_dsc_byp_load      ),                      
    .m_c2h_dsc_byp_src_addr   (t_c2h_dsc_byp_src_addr  ),                            
    .m_c2h_dsc_byp_dst_addr   (t_c2h_dsc_byp_dst_addr  ),                            
    .m_c2h_dsc_byp_len        (t_c2h_dsc_byp_len       ),                       
    .m_c2h_dsc_byp_ctl        (t_c2h_dsc_byp_ctl       ),  
                      
    .m_axis_c2h_tready        (t_axis_c2h_tready       ),                    
    .m_axis_c2h_tvalid        (t_axis_c2h_tvalid       ),                    
    .m_axis_c2h_tdata         (t_axis_c2h_tdata        ),                   
    .m_axis_c2h_tkeep         (t_axis_c2h_tkeep        ),                   
    .m_axis_c2h_tlast         (t_axis_c2h_tlast        ),                    
    
    .s_c2h_dsc_byp_ready_0    (q_c2h_dsc_byp_ready_1   ),                           
    .s_c2h_dsc_byp_load_0     (q_c2h_dsc_byp_load_1    ),                        
    .s_c2h_dsc_byp_src_addr_0 (64'h0000                ),                              
    .s_c2h_dsc_byp_dst_addr_0 (q_c2h_dsc_byp_dst_addr_1),                             
    .s_c2h_dsc_byp_len_0      (q_c2h_dsc_byp_len_1     ),                         
    .s_c2h_dsc_byp_ctl_0      (q_c2h_dsc_byp_ctl_1     ),                       
    
    .s_axis_c2h_tready_0      (q_axis_c2h_tready_1     ),                      
    .s_axis_c2h_tvalid_0      (q_axis_c2h_tvalid_1     ),                      
    .s_axis_c2h_tdata_0       (q_axis_c2h_tdata_1      ),                     
    .s_axis_c2h_tkeep_0       (q_axis_c2h_tkeep_1      ),                     
    .s_axis_c2h_tlast_0       (q_axis_c2h_tlast_1      ),                      
    
    .s_c2h_dsc_byp_ready_1    (q_c2h_dsc_byp_ready_2   ),                           
    .s_c2h_dsc_byp_load_1     (q_c2h_dsc_byp_load_2    ),                        
    .s_c2h_dsc_byp_src_addr_1 (64'h1000                ),                              
    .s_c2h_dsc_byp_dst_addr_1 (q_c2h_dsc_byp_dst_addr_2),                              
    .s_c2h_dsc_byp_len_1      (q_c2h_dsc_byp_len_2     ),                         
    .s_c2h_dsc_byp_ctl_1      (q_c2h_dsc_byp_ctl_2     ),                       
    
    .s_axis_c2h_tready_1      (q_axis_c2h_tready_2     ),                      
    .s_axis_c2h_tvalid_1      (q_axis_c2h_tvalid_2     ),                      
    .s_axis_c2h_tdata_1       (q_axis_c2h_tdata_2      ),                     
    .s_axis_c2h_tkeep_1       (q_axis_c2h_tkeep_2      ),                     
    .s_axis_c2h_tlast_1       (q_axis_c2h_tlast_2      ),                      
    
    .s_c2h_dsc_byp_ready_2    (q_c2h_dsc_byp_ready_3   ),                           
    .s_c2h_dsc_byp_load_2     (q_c2h_dsc_byp_load_3    ),                        
    .s_c2h_dsc_byp_src_addr_2 (64'h2000                ),                              
    .s_c2h_dsc_byp_dst_addr_2 (q_c2h_dsc_byp_dst_addr_3),                              
    .s_c2h_dsc_byp_len_2      (q_c2h_dsc_byp_len_3     ),                         
    .s_c2h_dsc_byp_ctl_2      (q_c2h_dsc_byp_ctl_3     ),                       
    
    .s_axis_c2h_tready_2      (q_axis_c2h_tready_3     ),                      
    .s_axis_c2h_tvalid_2      (q_axis_c2h_tvalid_3     ),                      
    .s_axis_c2h_tdata_2       (q_axis_c2h_tdata_3      ),                     
    .s_axis_c2h_tkeep_2       (q_axis_c2h_tkeep_3      ),                     
    .s_axis_c2h_tlast_2       (q_axis_c2h_tlast_3      ),                      
    
    .s_c2h_dsc_byp_ready_3    (q_c2h_dsc_byp_ready_4   ),                           
    .s_c2h_dsc_byp_load_3     (q_c2h_dsc_byp_load_4    ),                        
    .s_c2h_dsc_byp_src_addr_3 (64'h3000                ),                              
    .s_c2h_dsc_byp_dst_addr_3 (q_c2h_dsc_byp_dst_addr_4),                              
    .s_c2h_dsc_byp_len_3      (q_c2h_dsc_byp_len_4     ),                         
    .s_c2h_dsc_byp_ctl_3      (q_c2h_dsc_byp_ctl_4     ),                       

    .s_axis_c2h_tready_3      (q_axis_c2h_tready_4     ),                      
    .s_axis_c2h_tvalid_3      (q_axis_c2h_tvalid_4     ),                      
    .s_axis_c2h_tdata_3       (q_axis_c2h_tdata_4      ),                     
    .s_axis_c2h_tkeep_3       (q_axis_c2h_tkeep_4      ),                     
    .s_axis_c2h_tlast_3       (q_axis_c2h_tlast_4      )                          
);



xdma_h2c_arbiter_four#(
    .ARBITER_LOW_BIT (12)
) xdma_h2c_arbiter_que_5_8(
    .clk                      (clk                     ),      
    .rst_n                    (rst_n                   ),        
    
    .m_h2c_dsc_byp_ready      (h2c_dsc_byp_ready_1     ),                         
    .m_h2c_dsc_byp_load       (h2c_dsc_byp_load_1      ),                      
    .m_h2c_dsc_byp_src_addr   (h2c_dsc_byp_src_addr_1  ),                            
    .m_h2c_dsc_byp_dst_addr   (h2c_dsc_byp_dst_addr_1  ),                            
    .m_h2c_dsc_byp_len        (h2c_dsc_byp_len_1       ),                       
    .m_h2c_dsc_byp_ctl        (h2c_dsc_byp_ctl_1       ),                     
    
    .s_axis_h2c_tready        (axis_h2c_tready_1       ),                    
    .s_axis_h2c_tvalid        (axis_h2c_tvalid_1       ),                    
    .s_axis_h2c_tdata         (axis_h2c_tdata_1        ),                   
    .s_axis_h2c_tkeep         (axis_h2c_tkeep_1        ),                   
    .s_axis_h2c_tlast         (axis_h2c_tlast_1        ),                    
    
    .s_h2c_dsc_byp_ready_0    (q_h2c_dsc_byp_ready_5   ),                           
    .s_h2c_dsc_byp_load_0     (q_h2c_dsc_byp_load_5    ),                        
    .s_h2c_dsc_byp_src_addr_0 (q_h2c_dsc_byp_src_addr_5),                              
    .s_h2c_dsc_byp_dst_addr_0 (64'h0000                ),                             
    .s_h2c_dsc_byp_len_0      (q_h2c_dsc_byp_len_5     ),                         
    .s_h2c_dsc_byp_ctl_0      (q_h2c_dsc_byp_ctl_5     ),                       
    
    .m_axis_h2c_tready_0      (q_axis_h2c_tready_5     ),                      
    .m_axis_h2c_tvalid_0      (q_axis_h2c_tvalid_5     ),                      
    .m_axis_h2c_tdata_0       (q_axis_h2c_tdata_5      ),                     
    .m_axis_h2c_tkeep_0       (q_axis_h2c_tkeep_5      ),                     
    .m_axis_h2c_tlast_0       (q_axis_h2c_tlast_5      ),                      
    
    .s_h2c_dsc_byp_ready_1    (q_h2c_dsc_byp_ready_6   ),                           
    .s_h2c_dsc_byp_load_1     (q_h2c_dsc_byp_load_6    ),                        
    .s_h2c_dsc_byp_src_addr_1 (q_h2c_dsc_byp_src_addr_6),                              
    .s_h2c_dsc_byp_dst_addr_1 (64'h1000                ),                              
    .s_h2c_dsc_byp_len_1      (q_h2c_dsc_byp_len_6     ),                         
    .s_h2c_dsc_byp_ctl_1      (q_h2c_dsc_byp_ctl_6     ),                       
    
    .m_axis_h2c_tready_1      (q_axis_h2c_tready_6     ),                      
    .m_axis_h2c_tvalid_1      (q_axis_h2c_tvalid_6     ),                      
    .m_axis_h2c_tdata_1       (q_axis_h2c_tdata_6      ),                     
    .m_axis_h2c_tkeep_1       (q_axis_h2c_tkeep_6      ),                     
    .m_axis_h2c_tlast_1       (q_axis_h2c_tlast_6      ),                      
    
    .s_h2c_dsc_byp_ready_2    (q_h2c_dsc_byp_ready_7   ),                           
    .s_h2c_dsc_byp_load_2     (q_h2c_dsc_byp_load_7    ),                        
    .s_h2c_dsc_byp_src_addr_2 (q_h2c_dsc_byp_src_addr_7),                              
    .s_h2c_dsc_byp_dst_addr_2 (64'h2000                ),                              
    .s_h2c_dsc_byp_len_2      (q_h2c_dsc_byp_len_7     ),                         
    .s_h2c_dsc_byp_ctl_2      (q_h2c_dsc_byp_ctl_7     ),                       
    
    .m_axis_h2c_tready_2      (q_axis_h2c_tready_7     ),                      
    .m_axis_h2c_tvalid_2      (q_axis_h2c_tvalid_7     ),                      
    .m_axis_h2c_tdata_2       (q_axis_h2c_tdata_7      ),                     
    .m_axis_h2c_tkeep_2       (q_axis_h2c_tkeep_7      ),                     
    .m_axis_h2c_tlast_2       (q_axis_h2c_tlast_7      ),                      
    
    .s_h2c_dsc_byp_ready_3    (q_h2c_dsc_byp_ready_8   ),                           
    .s_h2c_dsc_byp_load_3     (q_h2c_dsc_byp_load_8    ),                        
    .s_h2c_dsc_byp_src_addr_3 (q_h2c_dsc_byp_src_addr_8),                              
    .s_h2c_dsc_byp_dst_addr_3 (64'h3000                ),                              
    .s_h2c_dsc_byp_len_3      (q_h2c_dsc_byp_len_8     ),                         
    .s_h2c_dsc_byp_ctl_3      (q_h2c_dsc_byp_ctl_8     ),                       

    .m_axis_h2c_tready_3      (q_axis_h2c_tready_8     ),                      
    .m_axis_h2c_tvalid_3      (q_axis_h2c_tvalid_8     ),                      
    .m_axis_h2c_tdata_3       (q_axis_h2c_tdata_8      ),                     
    .m_axis_h2c_tkeep_3       (q_axis_h2c_tkeep_8      ),                     
    .m_axis_h2c_tlast_3       (q_axis_h2c_tlast_8      )                          
);


xdma_c2h_arbiter_four#(
    .ARBITER_LOW_BIT (12)
) xdma_c2h_arbiter_que_5_8(
    .clk                      (clk                     ),      
    .rst_n                    (rst_n                   ),        
    
    .m_c2h_dsc_byp_ready      (c2h_dsc_byp_ready_1     ),                         
    .m_c2h_dsc_byp_load       (c2h_dsc_byp_load_1      ),                      
    .m_c2h_dsc_byp_src_addr   (c2h_dsc_byp_src_addr_1  ),                            
    .m_c2h_dsc_byp_dst_addr   (c2h_dsc_byp_dst_addr_1  ),                            
    .m_c2h_dsc_byp_len        (c2h_dsc_byp_len_1       ),                       
    .m_c2h_dsc_byp_ctl        (c2h_dsc_byp_ctl_1       ),  
                      
    .m_axis_c2h_tready        (axis_c2h_tready_1       ),                    
    .m_axis_c2h_tvalid        (axis_c2h_tvalid_1       ),                    
    .m_axis_c2h_tdata         (axis_c2h_tdata_1        ),                   
    .m_axis_c2h_tkeep         (axis_c2h_tkeep_1        ),                   
    .m_axis_c2h_tlast         (axis_c2h_tlast_1        ),                    
    
    .s_c2h_dsc_byp_ready_0    (q_c2h_dsc_byp_ready_5   ),                           
    .s_c2h_dsc_byp_load_0     (q_c2h_dsc_byp_load_5    ),                        
    .s_c2h_dsc_byp_src_addr_0 (64'h0000                ),                              
    .s_c2h_dsc_byp_dst_addr_0 (q_c2h_dsc_byp_dst_addr_5),                             
    .s_c2h_dsc_byp_len_0      (q_c2h_dsc_byp_len_5     ),                         
    .s_c2h_dsc_byp_ctl_0      (q_c2h_dsc_byp_ctl_5     ),                       
    
    .s_axis_c2h_tready_0      (q_axis_c2h_tready_5     ),                      
    .s_axis_c2h_tvalid_0      (q_axis_c2h_tvalid_5     ),                      
    .s_axis_c2h_tdata_0       (q_axis_c2h_tdata_5      ),                     
    .s_axis_c2h_tkeep_0       (q_axis_c2h_tkeep_5      ),                     
    .s_axis_c2h_tlast_0       (q_axis_c2h_tlast_5      ),                      
    
    .s_c2h_dsc_byp_ready_1    (q_c2h_dsc_byp_ready_6   ),                           
    .s_c2h_dsc_byp_load_1     (q_c2h_dsc_byp_load_6    ),                        
    .s_c2h_dsc_byp_src_addr_1 (64'h1000                ),                              
    .s_c2h_dsc_byp_dst_addr_1 (q_c2h_dsc_byp_dst_addr_6),                              
    .s_c2h_dsc_byp_len_1      (q_c2h_dsc_byp_len_6     ),                         
    .s_c2h_dsc_byp_ctl_1      (q_c2h_dsc_byp_ctl_6     ),                       
    
    .s_axis_c2h_tready_1      (q_axis_c2h_tready_6     ),                      
    .s_axis_c2h_tvalid_1      (q_axis_c2h_tvalid_6     ),                      
    .s_axis_c2h_tdata_1       (q_axis_c2h_tdata_6      ),                     
    .s_axis_c2h_tkeep_1       (q_axis_c2h_tkeep_6      ),                     
    .s_axis_c2h_tlast_1       (q_axis_c2h_tlast_6      ),                      
    
    .s_c2h_dsc_byp_ready_2    (q_c2h_dsc_byp_ready_7   ),                           
    .s_c2h_dsc_byp_load_2     (q_c2h_dsc_byp_load_7    ),                        
    .s_c2h_dsc_byp_src_addr_2 (64'h2000                ),                              
    .s_c2h_dsc_byp_dst_addr_2 (q_c2h_dsc_byp_dst_addr_7),                              
    .s_c2h_dsc_byp_len_2      (q_c2h_dsc_byp_len_7     ),                         
    .s_c2h_dsc_byp_ctl_2      (q_c2h_dsc_byp_ctl_7     ),                       
    
    .s_axis_c2h_tready_2      (q_axis_c2h_tready_7     ),                      
    .s_axis_c2h_tvalid_2      (q_axis_c2h_tvalid_7     ),                      
    .s_axis_c2h_tdata_2       (q_axis_c2h_tdata_7      ),                     
    .s_axis_c2h_tkeep_2       (q_axis_c2h_tkeep_7      ),                     
    .s_axis_c2h_tlast_2       (q_axis_c2h_tlast_7      ),                      
    
    .s_c2h_dsc_byp_ready_3    (q_c2h_dsc_byp_ready_8   ),                           
    .s_c2h_dsc_byp_load_3     (q_c2h_dsc_byp_load_8    ),                        
    .s_c2h_dsc_byp_src_addr_3 (64'h3000                ),                              
    .s_c2h_dsc_byp_dst_addr_3 (q_c2h_dsc_byp_dst_addr_8),                              
    .s_c2h_dsc_byp_len_3      (q_c2h_dsc_byp_len_8     ),                         
    .s_c2h_dsc_byp_ctl_3      (q_c2h_dsc_byp_ctl_8     ),                       

    .s_axis_c2h_tready_3      (q_axis_c2h_tready_8     ),                      
    .s_axis_c2h_tvalid_3      (q_axis_c2h_tvalid_8     ),                      
    .s_axis_c2h_tdata_3       (q_axis_c2h_tdata_8      ),                     
    .s_axis_c2h_tkeep_3       (q_axis_c2h_tkeep_8      ),                     
    .s_axis_c2h_tlast_3       (q_axis_c2h_tlast_8      )                          
);



xdma_h2c_arbiter_four#(
    .ARBITER_LOW_BIT (12)
) xdma_h2c_arbiter_data_1_4(
    .clk                      (clk                     ),      
    .rst_n                    (rst_n                   ),        
    
    .m_h2c_dsc_byp_ready      (h2c_dsc_byp_ready_2     ),                         
    .m_h2c_dsc_byp_load       (h2c_dsc_byp_load_2      ),                      
    .m_h2c_dsc_byp_src_addr   (h2c_dsc_byp_src_addr_2  ),                            
    .m_h2c_dsc_byp_dst_addr   (h2c_dsc_byp_dst_addr_2  ),                            
    .m_h2c_dsc_byp_len        (h2c_dsc_byp_len_2       ),                       
    .m_h2c_dsc_byp_ctl        (h2c_dsc_byp_ctl_2       ),                     
    
    .s_axis_h2c_tready        (axis_h2c_tready_2       ),                    
    .s_axis_h2c_tvalid        (axis_h2c_tvalid_2       ),                    
    .s_axis_h2c_tdata         (axis_h2c_tdata_2        ),                   
    .s_axis_h2c_tkeep         (axis_h2c_tkeep_2        ),                   
    .s_axis_h2c_tlast         (axis_h2c_tlast_2        ),                    
    
    .s_h2c_dsc_byp_ready_0    (d_h2c_dsc_byp_ready_1   ),                           
    .s_h2c_dsc_byp_load_0     (d_h2c_dsc_byp_load_1    ),                        
    .s_h2c_dsc_byp_src_addr_0 (d_h2c_dsc_byp_src_addr_1),                              
    .s_h2c_dsc_byp_dst_addr_0 (64'h0000                ),                             
    .s_h2c_dsc_byp_len_0      (d_h2c_dsc_byp_len_1     ),                         
    .s_h2c_dsc_byp_ctl_0      (d_h2c_dsc_byp_ctl_1     ),                       
    
    .m_axis_h2c_tready_0      (d_axis_h2c_tready_1     ),                      
    .m_axis_h2c_tvalid_0      (d_axis_h2c_tvalid_1     ),                      
    .m_axis_h2c_tdata_0       (d_axis_h2c_tdata_1      ),                     
    .m_axis_h2c_tkeep_0       (d_axis_h2c_tkeep_1      ),                     
    .m_axis_h2c_tlast_0       (d_axis_h2c_tlast_1      ),                      
    
    .s_h2c_dsc_byp_ready_1    (d_h2c_dsc_byp_ready_2   ),                           
    .s_h2c_dsc_byp_load_1     (d_h2c_dsc_byp_load_2    ),                        
    .s_h2c_dsc_byp_src_addr_1 (d_h2c_dsc_byp_src_addr_2),                              
    .s_h2c_dsc_byp_dst_addr_1 (64'h1000                ),                              
    .s_h2c_dsc_byp_len_1      (d_h2c_dsc_byp_len_2     ),                         
    .s_h2c_dsc_byp_ctl_1      (d_h2c_dsc_byp_ctl_2     ),                       
    
    .m_axis_h2c_tready_1      (d_axis_h2c_tready_2     ),                      
    .m_axis_h2c_tvalid_1      (d_axis_h2c_tvalid_2     ),                      
    .m_axis_h2c_tdata_1       (d_axis_h2c_tdata_2      ),                     
    .m_axis_h2c_tkeep_1       (d_axis_h2c_tkeep_2      ),                     
    .m_axis_h2c_tlast_1       (d_axis_h2c_tlast_2      ),                      
    
    .s_h2c_dsc_byp_ready_2    (d_h2c_dsc_byp_ready_3   ),                           
    .s_h2c_dsc_byp_load_2     (d_h2c_dsc_byp_load_3    ),                        
    .s_h2c_dsc_byp_src_addr_2 (d_h2c_dsc_byp_src_addr_3),                              
    .s_h2c_dsc_byp_dst_addr_2 (64'h2000                ),                              
    .s_h2c_dsc_byp_len_2      (d_h2c_dsc_byp_len_3     ),                         
    .s_h2c_dsc_byp_ctl_2      (d_h2c_dsc_byp_ctl_3     ),                       
    
    .m_axis_h2c_tready_2      (d_axis_h2c_tready_3     ),                      
    .m_axis_h2c_tvalid_2      (d_axis_h2c_tvalid_3     ),                      
    .m_axis_h2c_tdata_2       (d_axis_h2c_tdata_3      ),                     
    .m_axis_h2c_tkeep_2       (d_axis_h2c_tkeep_3      ),                     
    .m_axis_h2c_tlast_2       (d_axis_h2c_tlast_3      ),                      
    
    .s_h2c_dsc_byp_ready_3    (d_h2c_dsc_byp_ready_4   ),                           
    .s_h2c_dsc_byp_load_3     (d_h2c_dsc_byp_load_4    ),                        
    .s_h2c_dsc_byp_src_addr_3 (d_h2c_dsc_byp_src_addr_4),                              
    .s_h2c_dsc_byp_dst_addr_3 (64'h3000                ),                              
    .s_h2c_dsc_byp_len_3      (d_h2c_dsc_byp_len_4     ),                         
    .s_h2c_dsc_byp_ctl_3      (d_h2c_dsc_byp_ctl_4     ),                       

    .m_axis_h2c_tready_3      (d_axis_h2c_tready_4     ),                      
    .m_axis_h2c_tvalid_3      (d_axis_h2c_tvalid_4     ),                      
    .m_axis_h2c_tdata_3       (d_axis_h2c_tdata_4      ),                     
    .m_axis_h2c_tkeep_3       (d_axis_h2c_tkeep_4      ),                     
    .m_axis_h2c_tlast_3       (d_axis_h2c_tlast_4      )                          
);


xdma_c2h_arbiter_four#(
    .ARBITER_LOW_BIT (12)
) xdma_c2h_arbiter_data_1_4(
    .clk                      (clk                     ),      
    .rst_n                    (rst_n                   ),        
    
    .m_c2h_dsc_byp_ready      (c2h_dsc_byp_ready_2     ),                         
    .m_c2h_dsc_byp_load       (c2h_dsc_byp_load_2      ),                      
    .m_c2h_dsc_byp_src_addr   (c2h_dsc_byp_src_addr_2  ),                            
    .m_c2h_dsc_byp_dst_addr   (c2h_dsc_byp_dst_addr_2  ),                            
    .m_c2h_dsc_byp_len        (c2h_dsc_byp_len_2       ),                       
    .m_c2h_dsc_byp_ctl        (c2h_dsc_byp_ctl_2       ),  
                      
    .m_axis_c2h_tready        (axis_c2h_tready_2       ),                    
    .m_axis_c2h_tvalid        (axis_c2h_tvalid_2       ),                    
    .m_axis_c2h_tdata         (axis_c2h_tdata_2        ),                   
    .m_axis_c2h_tkeep         (axis_c2h_tkeep_2        ),                   
    .m_axis_c2h_tlast         (axis_c2h_tlast_2        ),                    
    
    .s_c2h_dsc_byp_ready_0    (d_c2h_dsc_byp_ready_1   ),                           
    .s_c2h_dsc_byp_load_0     (d_c2h_dsc_byp_load_1    ),                        
    .s_c2h_dsc_byp_src_addr_0 (64'h0000                ),                              
    .s_c2h_dsc_byp_dst_addr_0 (d_c2h_dsc_byp_dst_addr_1),                             
    .s_c2h_dsc_byp_len_0      (d_c2h_dsc_byp_len_1     ),                         
    .s_c2h_dsc_byp_ctl_0      (d_c2h_dsc_byp_ctl_1     ),                       
    
    .s_axis_c2h_tready_0      (d_axis_c2h_tready_1     ),                      
    .s_axis_c2h_tvalid_0      (d_axis_c2h_tvalid_1     ),                      
    .s_axis_c2h_tdata_0       (d_axis_c2h_tdata_1      ),                     
    .s_axis_c2h_tkeep_0       (d_axis_c2h_tkeep_1      ),                     
    .s_axis_c2h_tlast_0       (d_axis_c2h_tlast_1      ),                      
    
    .s_c2h_dsc_byp_ready_1    (d_c2h_dsc_byp_ready_2   ),                           
    .s_c2h_dsc_byp_load_1     (d_c2h_dsc_byp_load_2    ),                        
    .s_c2h_dsc_byp_src_addr_1 (64'h1000                ),                              
    .s_c2h_dsc_byp_dst_addr_1 (d_c2h_dsc_byp_dst_addr_2),                              
    .s_c2h_dsc_byp_len_1      (d_c2h_dsc_byp_len_2     ),                         
    .s_c2h_dsc_byp_ctl_1      (d_c2h_dsc_byp_ctl_2     ),                       
    
    .s_axis_c2h_tready_1      (d_axis_c2h_tready_2     ),                      
    .s_axis_c2h_tvalid_1      (d_axis_c2h_tvalid_2     ),                      
    .s_axis_c2h_tdata_1       (d_axis_c2h_tdata_2      ),                     
    .s_axis_c2h_tkeep_1       (d_axis_c2h_tkeep_2      ),                     
    .s_axis_c2h_tlast_1       (d_axis_c2h_tlast_2      ),                      
    
    .s_c2h_dsc_byp_ready_2    (d_c2h_dsc_byp_ready_3   ),                           
    .s_c2h_dsc_byp_load_2     (d_c2h_dsc_byp_load_3    ),                        
    .s_c2h_dsc_byp_src_addr_2 (64'h2000                ),                              
    .s_c2h_dsc_byp_dst_addr_2 (d_c2h_dsc_byp_dst_addr_3),                              
    .s_c2h_dsc_byp_len_2      (d_c2h_dsc_byp_len_3     ),                         
    .s_c2h_dsc_byp_ctl_2      (d_c2h_dsc_byp_ctl_3     ),                       
    
    .s_axis_c2h_tready_2      (d_axis_c2h_tready_3     ),                      
    .s_axis_c2h_tvalid_2      (d_axis_c2h_tvalid_3     ),                      
    .s_axis_c2h_tdata_2       (d_axis_c2h_tdata_3      ),                     
    .s_axis_c2h_tkeep_2       (d_axis_c2h_tkeep_3      ),                     
    .s_axis_c2h_tlast_2       (d_axis_c2h_tlast_3      ),                      
    
    .s_c2h_dsc_byp_ready_3    (d_c2h_dsc_byp_ready_4   ),                           
    .s_c2h_dsc_byp_load_3     (d_c2h_dsc_byp_load_4    ),                        
    .s_c2h_dsc_byp_src_addr_3 (64'h3000                ),                              
    .s_c2h_dsc_byp_dst_addr_3 (d_c2h_dsc_byp_dst_addr_4),                              
    .s_c2h_dsc_byp_len_3      (d_c2h_dsc_byp_len_4     ),                         
    .s_c2h_dsc_byp_ctl_3      (d_c2h_dsc_byp_ctl_4     ),                       

    .s_axis_c2h_tready_3      (d_axis_c2h_tready_4     ),                      
    .s_axis_c2h_tvalid_3      (d_axis_c2h_tvalid_4     ),                      
    .s_axis_c2h_tdata_3       (d_axis_c2h_tdata_4      ),                     
    .s_axis_c2h_tkeep_3       (d_axis_c2h_tkeep_4      ),                     
    .s_axis_c2h_tlast_3       (d_axis_c2h_tlast_4      )                          
);



xdma_h2c_arbiter_four#(
    .ARBITER_LOW_BIT (12)
) xdma_h2c_arbiter_data_5_8(
    .clk                      (clk                     ),      
    .rst_n                    (rst_n                   ),        
    
    .m_h2c_dsc_byp_ready      (h2c_dsc_byp_ready_3     ),                         
    .m_h2c_dsc_byp_load       (h2c_dsc_byp_load_3      ),                      
    .m_h2c_dsc_byp_src_addr   (h2c_dsc_byp_src_addr_3  ),                            
    .m_h2c_dsc_byp_dst_addr   (h2c_dsc_byp_dst_addr_3  ),                            
    .m_h2c_dsc_byp_len        (h2c_dsc_byp_len_3       ),                       
    .m_h2c_dsc_byp_ctl        (h2c_dsc_byp_ctl_3       ),                     
    
    .s_axis_h2c_tready        (axis_h2c_tready_3       ),                    
    .s_axis_h2c_tvalid        (axis_h2c_tvalid_3       ),                    
    .s_axis_h2c_tdata         (axis_h2c_tdata_3        ),                   
    .s_axis_h2c_tkeep         (axis_h2c_tkeep_3        ),                   
    .s_axis_h2c_tlast         (axis_h2c_tlast_3        ),                    
    
    .s_h2c_dsc_byp_ready_0    (d_h2c_dsc_byp_ready_5   ),                           
    .s_h2c_dsc_byp_load_0     (d_h2c_dsc_byp_load_5    ),                        
    .s_h2c_dsc_byp_src_addr_0 (d_h2c_dsc_byp_src_addr_5),                              
    .s_h2c_dsc_byp_dst_addr_0 (64'h0000                ),                             
    .s_h2c_dsc_byp_len_0      (d_h2c_dsc_byp_len_5     ),                         
    .s_h2c_dsc_byp_ctl_0      (d_h2c_dsc_byp_ctl_5     ),                       
    
    .m_axis_h2c_tready_0      (d_axis_h2c_tready_5     ),                      
    .m_axis_h2c_tvalid_0      (d_axis_h2c_tvalid_5     ),                      
    .m_axis_h2c_tdata_0       (d_axis_h2c_tdata_5      ),                     
    .m_axis_h2c_tkeep_0       (d_axis_h2c_tkeep_5      ),                     
    .m_axis_h2c_tlast_0       (d_axis_h2c_tlast_5      ),                      
    
    .s_h2c_dsc_byp_ready_1    (d_h2c_dsc_byp_ready_6   ),                           
    .s_h2c_dsc_byp_load_1     (d_h2c_dsc_byp_load_6    ),                        
    .s_h2c_dsc_byp_src_addr_1 (d_h2c_dsc_byp_src_addr_6),                              
    .s_h2c_dsc_byp_dst_addr_1 (64'h1000                ),                              
    .s_h2c_dsc_byp_len_1      (d_h2c_dsc_byp_len_6     ),                         
    .s_h2c_dsc_byp_ctl_1      (d_h2c_dsc_byp_ctl_6     ),                       
    
    .m_axis_h2c_tready_1      (d_axis_h2c_tready_6     ),                      
    .m_axis_h2c_tvalid_1      (d_axis_h2c_tvalid_6     ),                      
    .m_axis_h2c_tdata_1       (d_axis_h2c_tdata_6      ),                     
    .m_axis_h2c_tkeep_1       (d_axis_h2c_tkeep_6      ),                     
    .m_axis_h2c_tlast_1       (d_axis_h2c_tlast_6      ),                      
    
    .s_h2c_dsc_byp_ready_2    (d_h2c_dsc_byp_ready_7   ),                           
    .s_h2c_dsc_byp_load_2     (d_h2c_dsc_byp_load_7    ),                        
    .s_h2c_dsc_byp_src_addr_2 (d_h2c_dsc_byp_src_addr_7),                              
    .s_h2c_dsc_byp_dst_addr_2 (64'h2000                ),                              
    .s_h2c_dsc_byp_len_2      (d_h2c_dsc_byp_len_7     ),                         
    .s_h2c_dsc_byp_ctl_2      (d_h2c_dsc_byp_ctl_7     ),                       
    
    .m_axis_h2c_tready_2      (d_axis_h2c_tready_7     ),                      
    .m_axis_h2c_tvalid_2      (d_axis_h2c_tvalid_7     ),                      
    .m_axis_h2c_tdata_2       (d_axis_h2c_tdata_7      ),                     
    .m_axis_h2c_tkeep_2       (d_axis_h2c_tkeep_7      ),                     
    .m_axis_h2c_tlast_2       (d_axis_h2c_tlast_7      ),                      
    
    .s_h2c_dsc_byp_ready_3    (d_h2c_dsc_byp_ready_8   ),                           
    .s_h2c_dsc_byp_load_3     (d_h2c_dsc_byp_load_8    ),                        
    .s_h2c_dsc_byp_src_addr_3 (d_h2c_dsc_byp_src_addr_8),                              
    .s_h2c_dsc_byp_dst_addr_3 (64'h3000                ),                              
    .s_h2c_dsc_byp_len_3      (d_h2c_dsc_byp_len_8     ),                         
    .s_h2c_dsc_byp_ctl_3      (d_h2c_dsc_byp_ctl_8     ),                       

    .m_axis_h2c_tready_3      (d_axis_h2c_tready_8     ),                      
    .m_axis_h2c_tvalid_3      (d_axis_h2c_tvalid_8     ),                      
    .m_axis_h2c_tdata_3       (d_axis_h2c_tdata_8      ),                     
    .m_axis_h2c_tkeep_3       (d_axis_h2c_tkeep_8      ),                     
    .m_axis_h2c_tlast_3       (d_axis_h2c_tlast_8      )                          
);


xdma_c2h_arbiter_four#(
    .ARBITER_LOW_BIT (12)
) xdma_c2h_arbiter_data_5_8(
    .clk                      (clk                     ),      
    .rst_n                    (rst_n                   ),        
    
    .m_c2h_dsc_byp_ready      (c2h_dsc_byp_ready_3     ),                         
    .m_c2h_dsc_byp_load       (c2h_dsc_byp_load_3      ),                      
    .m_c2h_dsc_byp_src_addr   (c2h_dsc_byp_src_addr_3  ),                            
    .m_c2h_dsc_byp_dst_addr   (c2h_dsc_byp_dst_addr_3  ),                            
    .m_c2h_dsc_byp_len        (c2h_dsc_byp_len_3       ),                       
    .m_c2h_dsc_byp_ctl        (c2h_dsc_byp_ctl_3       ),  
                      
    .m_axis_c2h_tready        (axis_c2h_tready_3       ),                    
    .m_axis_c2h_tvalid        (axis_c2h_tvalid_3       ),                    
    .m_axis_c2h_tdata         (axis_c2h_tdata_3        ),                   
    .m_axis_c2h_tkeep         (axis_c2h_tkeep_3        ),                   
    .m_axis_c2h_tlast         (axis_c2h_tlast_3        ),                    
    
    .s_c2h_dsc_byp_ready_0    (d_c2h_dsc_byp_ready_5   ),                           
    .s_c2h_dsc_byp_load_0     (d_c2h_dsc_byp_load_5    ),                        
    .s_c2h_dsc_byp_src_addr_0 (64'h0000                ),                              
    .s_c2h_dsc_byp_dst_addr_0 (d_c2h_dsc_byp_dst_addr_5),                             
    .s_c2h_dsc_byp_len_0      (d_c2h_dsc_byp_len_5     ),                         
    .s_c2h_dsc_byp_ctl_0      (d_c2h_dsc_byp_ctl_5     ),                       
    
    .s_axis_c2h_tready_0      (d_axis_c2h_tready_5     ),                      
    .s_axis_c2h_tvalid_0      (d_axis_c2h_tvalid_5     ),                      
    .s_axis_c2h_tdata_0       (d_axis_c2h_tdata_5      ),                     
    .s_axis_c2h_tkeep_0       (d_axis_c2h_tkeep_5      ),                     
    .s_axis_c2h_tlast_0       (d_axis_c2h_tlast_5      ),                      
    
    .s_c2h_dsc_byp_ready_1    (d_c2h_dsc_byp_ready_6   ),                           
    .s_c2h_dsc_byp_load_1     (d_c2h_dsc_byp_load_6    ),                        
    .s_c2h_dsc_byp_src_addr_1 (64'h1000                ),                              
    .s_c2h_dsc_byp_dst_addr_1 (d_c2h_dsc_byp_dst_addr_6),                              
    .s_c2h_dsc_byp_len_1      (d_c2h_dsc_byp_len_6     ),                         
    .s_c2h_dsc_byp_ctl_1      (d_c2h_dsc_byp_ctl_6     ),                       
    
    .s_axis_c2h_tready_1      (d_axis_c2h_tready_6     ),                      
    .s_axis_c2h_tvalid_1      (d_axis_c2h_tvalid_6     ),                      
    .s_axis_c2h_tdata_1       (d_axis_c2h_tdata_6      ),                     
    .s_axis_c2h_tkeep_1       (d_axis_c2h_tkeep_6      ),                     
    .s_axis_c2h_tlast_1       (d_axis_c2h_tlast_6      ),                      
    
    .s_c2h_dsc_byp_ready_2    (d_c2h_dsc_byp_ready_7   ),                           
    .s_c2h_dsc_byp_load_2     (d_c2h_dsc_byp_load_7    ),                        
    .s_c2h_dsc_byp_src_addr_2 (64'h2000                ),                              
    .s_c2h_dsc_byp_dst_addr_2 (d_c2h_dsc_byp_dst_addr_7),                              
    .s_c2h_dsc_byp_len_2      (d_c2h_dsc_byp_len_7     ),                         
    .s_c2h_dsc_byp_ctl_2      (d_c2h_dsc_byp_ctl_7     ),                       
    
    .s_axis_c2h_tready_2      (d_axis_c2h_tready_7     ),                      
    .s_axis_c2h_tvalid_2      (d_axis_c2h_tvalid_7     ),                      
    .s_axis_c2h_tdata_2       (d_axis_c2h_tdata_7      ),                     
    .s_axis_c2h_tkeep_2       (d_axis_c2h_tkeep_7      ),                     
    .s_axis_c2h_tlast_2       (d_axis_c2h_tlast_7      ),                      
    
    .s_c2h_dsc_byp_ready_3    (d_c2h_dsc_byp_ready_8   ),                           
    .s_c2h_dsc_byp_load_3     (d_c2h_dsc_byp_load_8    ),                        
    .s_c2h_dsc_byp_src_addr_3 (64'h3000                ),                              
    .s_c2h_dsc_byp_dst_addr_3 (d_c2h_dsc_byp_dst_addr_8),                              
    .s_c2h_dsc_byp_len_3      (d_c2h_dsc_byp_len_8     ),                         
    .s_c2h_dsc_byp_ctl_3      (d_c2h_dsc_byp_ctl_8     ),                       

    .s_axis_c2h_tready_3      (d_axis_c2h_tready_8     ),                      
    .s_axis_c2h_tvalid_3      (d_axis_c2h_tvalid_8     ),                      
    .s_axis_c2h_tdata_3       (d_axis_c2h_tdata_8      ),                     
    .s_axis_c2h_tkeep_3       (d_axis_c2h_tkeep_8      ),                     
    .s_axis_c2h_tlast_3       (d_axis_c2h_tlast_8      )                          
);





endmodule
