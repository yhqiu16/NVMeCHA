// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Tue Oct 13 18:20:41 2020
// Host        : yhqiu running 64-bit CentOS Linux release 7.8.2003 (Core)
// Command     : write_verilog -force -mode funcsim
//               /mnt/F/SSD/PJs_2019.2/NVMe_Controller/NVMe_Controller.srcs/sources_1/ip/nvme_data_cmd_fifo/nvme_data_cmd_fifo_sim_netlist.v
// Design      : nvme_data_cmd_fifo
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcku040-ffva1156-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "nvme_data_cmd_fifo,fifo_generator_v13_2_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_5,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module nvme_data_cmd_fifo
   (clk,
    rst,
    din,
    wr_en,
    rd_en,
    dout,
    full,
    empty,
    prog_full);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 core_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME core_clk, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *) input clk;
  input rst;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *) input [127:0]din;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *) input wr_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_EN" *) input rd_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [127:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;
  output prog_full;

  wire clk;
  wire [127:0]din;
  wire [127:0]dout;
  wire empty;
  wire full;
  wire prog_full;
  wire rd_en;
  wire rst;
  wire wr_en;
  wire NLW_U0_almost_empty_UNCONNECTED;
  wire NLW_U0_almost_full_UNCONNECTED;
  wire NLW_U0_axi_ar_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_overflow_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_full_UNCONNECTED;
  wire NLW_U0_axi_ar_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_underflow_UNCONNECTED;
  wire NLW_U0_axi_aw_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_overflow_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_full_UNCONNECTED;
  wire NLW_U0_axi_aw_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_underflow_UNCONNECTED;
  wire NLW_U0_axi_b_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_overflow_UNCONNECTED;
  wire NLW_U0_axi_b_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_b_prog_full_UNCONNECTED;
  wire NLW_U0_axi_b_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_underflow_UNCONNECTED;
  wire NLW_U0_axi_r_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_overflow_UNCONNECTED;
  wire NLW_U0_axi_r_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_r_prog_full_UNCONNECTED;
  wire NLW_U0_axi_r_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_underflow_UNCONNECTED;
  wire NLW_U0_axi_w_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_overflow_UNCONNECTED;
  wire NLW_U0_axi_w_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_w_prog_full_UNCONNECTED;
  wire NLW_U0_axi_w_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_underflow_UNCONNECTED;
  wire NLW_U0_axis_dbiterr_UNCONNECTED;
  wire NLW_U0_axis_overflow_UNCONNECTED;
  wire NLW_U0_axis_prog_empty_UNCONNECTED;
  wire NLW_U0_axis_prog_full_UNCONNECTED;
  wire NLW_U0_axis_sbiterr_UNCONNECTED;
  wire NLW_U0_axis_underflow_UNCONNECTED;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_m_axi_arvalid_UNCONNECTED;
  wire NLW_U0_m_axi_awvalid_UNCONNECTED;
  wire NLW_U0_m_axi_bready_UNCONNECTED;
  wire NLW_U0_m_axi_rready_UNCONNECTED;
  wire NLW_U0_m_axi_wlast_UNCONNECTED;
  wire NLW_U0_m_axi_wvalid_UNCONNECTED;
  wire NLW_U0_m_axis_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_tvalid_UNCONNECTED;
  wire NLW_U0_overflow_UNCONNECTED;
  wire NLW_U0_prog_empty_UNCONNECTED;
  wire NLW_U0_rd_rst_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_s_axis_tready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire NLW_U0_underflow_UNCONNECTED;
  wire NLW_U0_valid_UNCONNECTED;
  wire NLW_U0_wr_ack_UNCONNECTED;
  wire NLW_U0_wr_rst_busy_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_data_count_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_araddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_arburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_arlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_aruser_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_awaddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_awburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_awlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awuser_UNCONNECTED;
  wire [63:0]NLW_U0_m_axi_wdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_wstrb_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wuser_UNCONNECTED;
  wire [7:0]NLW_U0_m_axis_tdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tdest_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tid_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tkeep_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tstrb_UNCONNECTED;
  wire [3:0]NLW_U0_m_axis_tuser_UNCONNECTED;
  wire [4:0]NLW_U0_rd_data_count_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_buser_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_ruser_UNCONNECTED;
  wire [4:0]NLW_U0_wr_data_count_UNCONNECTED;

  (* C_ADD_NGC_CONSTRAINT = "0" *) 
  (* C_APPLICATION_TYPE_AXIS = "0" *) 
  (* C_APPLICATION_TYPE_RACH = "0" *) 
  (* C_APPLICATION_TYPE_RDCH = "0" *) 
  (* C_APPLICATION_TYPE_WACH = "0" *) 
  (* C_APPLICATION_TYPE_WDCH = "0" *) 
  (* C_APPLICATION_TYPE_WRCH = "0" *) 
  (* C_AXIS_TDATA_WIDTH = "8" *) 
  (* C_AXIS_TDEST_WIDTH = "1" *) 
  (* C_AXIS_TID_WIDTH = "1" *) 
  (* C_AXIS_TKEEP_WIDTH = "1" *) 
  (* C_AXIS_TSTRB_WIDTH = "1" *) 
  (* C_AXIS_TUSER_WIDTH = "4" *) 
  (* C_AXIS_TYPE = "0" *) 
  (* C_AXI_ADDR_WIDTH = "32" *) 
  (* C_AXI_ARUSER_WIDTH = "1" *) 
  (* C_AXI_AWUSER_WIDTH = "1" *) 
  (* C_AXI_BUSER_WIDTH = "1" *) 
  (* C_AXI_DATA_WIDTH = "64" *) 
  (* C_AXI_ID_WIDTH = "1" *) 
  (* C_AXI_LEN_WIDTH = "8" *) 
  (* C_AXI_LOCK_WIDTH = "1" *) 
  (* C_AXI_RUSER_WIDTH = "1" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_AXI_WUSER_WIDTH = "1" *) 
  (* C_COMMON_CLOCK = "1" *) 
  (* C_COUNT_TYPE = "0" *) 
  (* C_DATA_COUNT_WIDTH = "5" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "128" *) 
  (* C_DIN_WIDTH_AXIS = "1" *) 
  (* C_DIN_WIDTH_RACH = "32" *) 
  (* C_DIN_WIDTH_RDCH = "64" *) 
  (* C_DIN_WIDTH_WACH = "1" *) 
  (* C_DIN_WIDTH_WDCH = "64" *) 
  (* C_DIN_WIDTH_WRCH = "2" *) 
  (* C_DOUT_RST_VAL = "0" *) 
  (* C_DOUT_WIDTH = "128" *) 
  (* C_ENABLE_RLOCS = "0" *) 
  (* C_ENABLE_RST_SYNC = "1" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_ERROR_INJECTION_TYPE = "0" *) 
  (* C_ERROR_INJECTION_TYPE_AXIS = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
  (* C_FAMILY = "kintexu" *) 
  (* C_FULL_FLAGS_RST_VAL = "1" *) 
  (* C_HAS_ALMOST_EMPTY = "0" *) 
  (* C_HAS_ALMOST_FULL = "0" *) 
  (* C_HAS_AXIS_TDATA = "1" *) 
  (* C_HAS_AXIS_TDEST = "0" *) 
  (* C_HAS_AXIS_TID = "0" *) 
  (* C_HAS_AXIS_TKEEP = "0" *) 
  (* C_HAS_AXIS_TLAST = "0" *) 
  (* C_HAS_AXIS_TREADY = "1" *) 
  (* C_HAS_AXIS_TSTRB = "0" *) 
  (* C_HAS_AXIS_TUSER = "1" *) 
  (* C_HAS_AXI_ARUSER = "0" *) 
  (* C_HAS_AXI_AWUSER = "0" *) 
  (* C_HAS_AXI_BUSER = "0" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_AXI_RD_CHANNEL = "1" *) 
  (* C_HAS_AXI_RUSER = "0" *) 
  (* C_HAS_AXI_WR_CHANNEL = "1" *) 
  (* C_HAS_AXI_WUSER = "0" *) 
  (* C_HAS_BACKUP = "0" *) 
  (* C_HAS_DATA_COUNT = "0" *) 
  (* C_HAS_DATA_COUNTS_AXIS = "0" *) 
  (* C_HAS_DATA_COUNTS_RACH = "0" *) 
  (* C_HAS_DATA_COUNTS_RDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WACH = "0" *) 
  (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WRCH = "0" *) 
  (* C_HAS_INT_CLK = "0" *) 
  (* C_HAS_MASTER_CE = "0" *) 
  (* C_HAS_MEMINIT_FILE = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
  (* C_HAS_PROG_FLAGS_RACH = "0" *) 
  (* C_HAS_PROG_FLAGS_RDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WACH = "0" *) 
  (* C_HAS_PROG_FLAGS_WDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WRCH = "0" *) 
  (* C_HAS_RD_DATA_COUNT = "0" *) 
  (* C_HAS_RD_RST = "0" *) 
  (* C_HAS_RST = "1" *) 
  (* C_HAS_SLAVE_CE = "0" *) 
  (* C_HAS_SRST = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_VALID = "0" *) 
  (* C_HAS_WR_ACK = "0" *) 
  (* C_HAS_WR_DATA_COUNT = "0" *) 
  (* C_HAS_WR_RST = "0" *) 
  (* C_IMPLEMENTATION_TYPE = "1" *) 
  (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WRCH = "1" *) 
  (* C_INIT_WR_PNTR_VAL = "0" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_MEMORY_TYPE = "3" *) 
  (* C_MIF_FILE_NAME = "BlankString" *) 
  (* C_MSGON_VAL = "1" *) 
  (* C_OPTIMIZATION_MODE = "0" *) 
  (* C_OVERFLOW_LOW = "0" *) 
  (* C_POWER_SAVING_MODE = "0" *) 
  (* C_PRELOAD_LATENCY = "1" *) 
  (* C_PRELOAD_REGS = "0" *) 
  (* C_PRIM_FIFO_TYPE = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_RDCH = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_WACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WDCH = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "2" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "3" *) 
  (* C_PROG_EMPTY_TYPE = "0" *) 
  (* C_PROG_EMPTY_TYPE_AXIS = "0" *) 
  (* C_PROG_EMPTY_TYPE_RACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "28" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "27" *) 
  (* C_PROG_FULL_TYPE = "1" *) 
  (* C_PROG_FULL_TYPE_AXIS = "0" *) 
  (* C_PROG_FULL_TYPE_RACH = "0" *) 
  (* C_PROG_FULL_TYPE_RDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WACH = "0" *) 
  (* C_PROG_FULL_TYPE_WDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WRCH = "0" *) 
  (* C_RACH_TYPE = "0" *) 
  (* C_RDCH_TYPE = "0" *) 
  (* C_RD_DATA_COUNT_WIDTH = "5" *) 
  (* C_RD_DEPTH = "32" *) 
  (* C_RD_FREQ = "1" *) 
  (* C_RD_PNTR_WIDTH = "5" *) 
  (* C_REG_SLICE_MODE_AXIS = "0" *) 
  (* C_REG_SLICE_MODE_RACH = "0" *) 
  (* C_REG_SLICE_MODE_RDCH = "0" *) 
  (* C_REG_SLICE_MODE_WACH = "0" *) 
  (* C_REG_SLICE_MODE_WDCH = "0" *) 
  (* C_REG_SLICE_MODE_WRCH = "0" *) 
  (* C_SELECT_XPM = "0" *) 
  (* C_SYNCHRONIZER_STAGE = "2" *) 
  (* C_UNDERFLOW_LOW = "0" *) 
  (* C_USE_COMMON_OVERFLOW = "0" *) 
  (* C_USE_COMMON_UNDERFLOW = "0" *) 
  (* C_USE_DEFAULT_SETTINGS = "0" *) 
  (* C_USE_DOUT_RST = "1" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_ECC_AXIS = "0" *) 
  (* C_USE_ECC_RACH = "0" *) 
  (* C_USE_ECC_RDCH = "0" *) 
  (* C_USE_ECC_WACH = "0" *) 
  (* C_USE_ECC_WDCH = "0" *) 
  (* C_USE_ECC_WRCH = "0" *) 
  (* C_USE_EMBEDDED_REG = "0" *) 
  (* C_USE_FIFO16_FLAGS = "0" *) 
  (* C_USE_FWFT_DATA_COUNT = "0" *) 
  (* C_USE_PIPELINE_REG = "0" *) 
  (* C_VALID_LOW = "0" *) 
  (* C_WACH_TYPE = "0" *) 
  (* C_WDCH_TYPE = "0" *) 
  (* C_WRCH_TYPE = "0" *) 
  (* C_WR_ACK_LOW = "0" *) 
  (* C_WR_DATA_COUNT_WIDTH = "5" *) 
  (* C_WR_DEPTH = "32" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "1024" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "1024" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "1" *) 
  (* C_WR_PNTR_WIDTH = "5" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  nvme_data_cmd_fifo_fifo_generator_v13_2_5 U0
       (.almost_empty(NLW_U0_almost_empty_UNCONNECTED),
        .almost_full(NLW_U0_almost_full_UNCONNECTED),
        .axi_ar_data_count(NLW_U0_axi_ar_data_count_UNCONNECTED[4:0]),
        .axi_ar_dbiterr(NLW_U0_axi_ar_dbiterr_UNCONNECTED),
        .axi_ar_injectdbiterr(1'b0),
        .axi_ar_injectsbiterr(1'b0),
        .axi_ar_overflow(NLW_U0_axi_ar_overflow_UNCONNECTED),
        .axi_ar_prog_empty(NLW_U0_axi_ar_prog_empty_UNCONNECTED),
        .axi_ar_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_prog_full(NLW_U0_axi_ar_prog_full_UNCONNECTED),
        .axi_ar_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_rd_data_count(NLW_U0_axi_ar_rd_data_count_UNCONNECTED[4:0]),
        .axi_ar_sbiterr(NLW_U0_axi_ar_sbiterr_UNCONNECTED),
        .axi_ar_underflow(NLW_U0_axi_ar_underflow_UNCONNECTED),
        .axi_ar_wr_data_count(NLW_U0_axi_ar_wr_data_count_UNCONNECTED[4:0]),
        .axi_aw_data_count(NLW_U0_axi_aw_data_count_UNCONNECTED[4:0]),
        .axi_aw_dbiterr(NLW_U0_axi_aw_dbiterr_UNCONNECTED),
        .axi_aw_injectdbiterr(1'b0),
        .axi_aw_injectsbiterr(1'b0),
        .axi_aw_overflow(NLW_U0_axi_aw_overflow_UNCONNECTED),
        .axi_aw_prog_empty(NLW_U0_axi_aw_prog_empty_UNCONNECTED),
        .axi_aw_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_prog_full(NLW_U0_axi_aw_prog_full_UNCONNECTED),
        .axi_aw_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_rd_data_count(NLW_U0_axi_aw_rd_data_count_UNCONNECTED[4:0]),
        .axi_aw_sbiterr(NLW_U0_axi_aw_sbiterr_UNCONNECTED),
        .axi_aw_underflow(NLW_U0_axi_aw_underflow_UNCONNECTED),
        .axi_aw_wr_data_count(NLW_U0_axi_aw_wr_data_count_UNCONNECTED[4:0]),
        .axi_b_data_count(NLW_U0_axi_b_data_count_UNCONNECTED[4:0]),
        .axi_b_dbiterr(NLW_U0_axi_b_dbiterr_UNCONNECTED),
        .axi_b_injectdbiterr(1'b0),
        .axi_b_injectsbiterr(1'b0),
        .axi_b_overflow(NLW_U0_axi_b_overflow_UNCONNECTED),
        .axi_b_prog_empty(NLW_U0_axi_b_prog_empty_UNCONNECTED),
        .axi_b_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_prog_full(NLW_U0_axi_b_prog_full_UNCONNECTED),
        .axi_b_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_rd_data_count(NLW_U0_axi_b_rd_data_count_UNCONNECTED[4:0]),
        .axi_b_sbiterr(NLW_U0_axi_b_sbiterr_UNCONNECTED),
        .axi_b_underflow(NLW_U0_axi_b_underflow_UNCONNECTED),
        .axi_b_wr_data_count(NLW_U0_axi_b_wr_data_count_UNCONNECTED[4:0]),
        .axi_r_data_count(NLW_U0_axi_r_data_count_UNCONNECTED[10:0]),
        .axi_r_dbiterr(NLW_U0_axi_r_dbiterr_UNCONNECTED),
        .axi_r_injectdbiterr(1'b0),
        .axi_r_injectsbiterr(1'b0),
        .axi_r_overflow(NLW_U0_axi_r_overflow_UNCONNECTED),
        .axi_r_prog_empty(NLW_U0_axi_r_prog_empty_UNCONNECTED),
        .axi_r_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_prog_full(NLW_U0_axi_r_prog_full_UNCONNECTED),
        .axi_r_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_rd_data_count(NLW_U0_axi_r_rd_data_count_UNCONNECTED[10:0]),
        .axi_r_sbiterr(NLW_U0_axi_r_sbiterr_UNCONNECTED),
        .axi_r_underflow(NLW_U0_axi_r_underflow_UNCONNECTED),
        .axi_r_wr_data_count(NLW_U0_axi_r_wr_data_count_UNCONNECTED[10:0]),
        .axi_w_data_count(NLW_U0_axi_w_data_count_UNCONNECTED[10:0]),
        .axi_w_dbiterr(NLW_U0_axi_w_dbiterr_UNCONNECTED),
        .axi_w_injectdbiterr(1'b0),
        .axi_w_injectsbiterr(1'b0),
        .axi_w_overflow(NLW_U0_axi_w_overflow_UNCONNECTED),
        .axi_w_prog_empty(NLW_U0_axi_w_prog_empty_UNCONNECTED),
        .axi_w_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_prog_full(NLW_U0_axi_w_prog_full_UNCONNECTED),
        .axi_w_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_rd_data_count(NLW_U0_axi_w_rd_data_count_UNCONNECTED[10:0]),
        .axi_w_sbiterr(NLW_U0_axi_w_sbiterr_UNCONNECTED),
        .axi_w_underflow(NLW_U0_axi_w_underflow_UNCONNECTED),
        .axi_w_wr_data_count(NLW_U0_axi_w_wr_data_count_UNCONNECTED[10:0]),
        .axis_data_count(NLW_U0_axis_data_count_UNCONNECTED[10:0]),
        .axis_dbiterr(NLW_U0_axis_dbiterr_UNCONNECTED),
        .axis_injectdbiterr(1'b0),
        .axis_injectsbiterr(1'b0),
        .axis_overflow(NLW_U0_axis_overflow_UNCONNECTED),
        .axis_prog_empty(NLW_U0_axis_prog_empty_UNCONNECTED),
        .axis_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_prog_full(NLW_U0_axis_prog_full_UNCONNECTED),
        .axis_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_rd_data_count(NLW_U0_axis_rd_data_count_UNCONNECTED[10:0]),
        .axis_sbiterr(NLW_U0_axis_sbiterr_UNCONNECTED),
        .axis_underflow(NLW_U0_axis_underflow_UNCONNECTED),
        .axis_wr_data_count(NLW_U0_axis_wr_data_count_UNCONNECTED[10:0]),
        .backup(1'b0),
        .backup_marker(1'b0),
        .clk(clk),
        .data_count(NLW_U0_data_count_UNCONNECTED[4:0]),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .int_clk(1'b0),
        .m_aclk(1'b0),
        .m_aclk_en(1'b0),
        .m_axi_araddr(NLW_U0_m_axi_araddr_UNCONNECTED[31:0]),
        .m_axi_arburst(NLW_U0_m_axi_arburst_UNCONNECTED[1:0]),
        .m_axi_arcache(NLW_U0_m_axi_arcache_UNCONNECTED[3:0]),
        .m_axi_arid(NLW_U0_m_axi_arid_UNCONNECTED[0]),
        .m_axi_arlen(NLW_U0_m_axi_arlen_UNCONNECTED[7:0]),
        .m_axi_arlock(NLW_U0_m_axi_arlock_UNCONNECTED[0]),
        .m_axi_arprot(NLW_U0_m_axi_arprot_UNCONNECTED[2:0]),
        .m_axi_arqos(NLW_U0_m_axi_arqos_UNCONNECTED[3:0]),
        .m_axi_arready(1'b0),
        .m_axi_arregion(NLW_U0_m_axi_arregion_UNCONNECTED[3:0]),
        .m_axi_arsize(NLW_U0_m_axi_arsize_UNCONNECTED[2:0]),
        .m_axi_aruser(NLW_U0_m_axi_aruser_UNCONNECTED[0]),
        .m_axi_arvalid(NLW_U0_m_axi_arvalid_UNCONNECTED),
        .m_axi_awaddr(NLW_U0_m_axi_awaddr_UNCONNECTED[31:0]),
        .m_axi_awburst(NLW_U0_m_axi_awburst_UNCONNECTED[1:0]),
        .m_axi_awcache(NLW_U0_m_axi_awcache_UNCONNECTED[3:0]),
        .m_axi_awid(NLW_U0_m_axi_awid_UNCONNECTED[0]),
        .m_axi_awlen(NLW_U0_m_axi_awlen_UNCONNECTED[7:0]),
        .m_axi_awlock(NLW_U0_m_axi_awlock_UNCONNECTED[0]),
        .m_axi_awprot(NLW_U0_m_axi_awprot_UNCONNECTED[2:0]),
        .m_axi_awqos(NLW_U0_m_axi_awqos_UNCONNECTED[3:0]),
        .m_axi_awready(1'b0),
        .m_axi_awregion(NLW_U0_m_axi_awregion_UNCONNECTED[3:0]),
        .m_axi_awsize(NLW_U0_m_axi_awsize_UNCONNECTED[2:0]),
        .m_axi_awuser(NLW_U0_m_axi_awuser_UNCONNECTED[0]),
        .m_axi_awvalid(NLW_U0_m_axi_awvalid_UNCONNECTED),
        .m_axi_bid(1'b0),
        .m_axi_bready(NLW_U0_m_axi_bready_UNCONNECTED),
        .m_axi_bresp({1'b0,1'b0}),
        .m_axi_buser(1'b0),
        .m_axi_bvalid(1'b0),
        .m_axi_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_rid(1'b0),
        .m_axi_rlast(1'b0),
        .m_axi_rready(NLW_U0_m_axi_rready_UNCONNECTED),
        .m_axi_rresp({1'b0,1'b0}),
        .m_axi_ruser(1'b0),
        .m_axi_rvalid(1'b0),
        .m_axi_wdata(NLW_U0_m_axi_wdata_UNCONNECTED[63:0]),
        .m_axi_wid(NLW_U0_m_axi_wid_UNCONNECTED[0]),
        .m_axi_wlast(NLW_U0_m_axi_wlast_UNCONNECTED),
        .m_axi_wready(1'b0),
        .m_axi_wstrb(NLW_U0_m_axi_wstrb_UNCONNECTED[7:0]),
        .m_axi_wuser(NLW_U0_m_axi_wuser_UNCONNECTED[0]),
        .m_axi_wvalid(NLW_U0_m_axi_wvalid_UNCONNECTED),
        .m_axis_tdata(NLW_U0_m_axis_tdata_UNCONNECTED[7:0]),
        .m_axis_tdest(NLW_U0_m_axis_tdest_UNCONNECTED[0]),
        .m_axis_tid(NLW_U0_m_axis_tid_UNCONNECTED[0]),
        .m_axis_tkeep(NLW_U0_m_axis_tkeep_UNCONNECTED[0]),
        .m_axis_tlast(NLW_U0_m_axis_tlast_UNCONNECTED),
        .m_axis_tready(1'b0),
        .m_axis_tstrb(NLW_U0_m_axis_tstrb_UNCONNECTED[0]),
        .m_axis_tuser(NLW_U0_m_axis_tuser_UNCONNECTED[3:0]),
        .m_axis_tvalid(NLW_U0_m_axis_tvalid_UNCONNECTED),
        .overflow(NLW_U0_overflow_UNCONNECTED),
        .prog_empty(NLW_U0_prog_empty_UNCONNECTED),
        .prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full(prog_full),
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rd_clk(1'b0),
        .rd_data_count(NLW_U0_rd_data_count_UNCONNECTED[4:0]),
        .rd_en(rd_en),
        .rd_rst(1'b0),
        .rd_rst_busy(NLW_U0_rd_rst_busy_UNCONNECTED),
        .rst(rst),
        .s_aclk(1'b0),
        .s_aclk_en(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arid(1'b0),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlock(1'b0),
        .s_axi_arprot({1'b0,1'b0,1'b0}),
        .s_axi_arqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_aruser(1'b0),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awid(1'b0),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlock(1'b0),
        .s_axi_awprot({1'b0,1'b0,1'b0}),
        .s_axi_awqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awuser(1'b0),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_buser(NLW_U0_s_axi_buser_UNCONNECTED[0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_ruser(NLW_U0_s_axi_ruser_UNCONNECTED[0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wid(1'b0),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wuser(1'b0),
        .s_axi_wvalid(1'b0),
        .s_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tdest(1'b0),
        .s_axis_tid(1'b0),
        .s_axis_tkeep(1'b0),
        .s_axis_tlast(1'b0),
        .s_axis_tready(NLW_U0_s_axis_tready_UNCONNECTED),
        .s_axis_tstrb(1'b0),
        .s_axis_tuser({1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .sleep(1'b0),
        .srst(1'b0),
        .underflow(NLW_U0_underflow_UNCONNECTED),
        .valid(NLW_U0_valid_UNCONNECTED),
        .wr_ack(NLW_U0_wr_ack_UNCONNECTED),
        .wr_clk(1'b0),
        .wr_data_count(NLW_U0_wr_data_count_UNCONNECTED[4:0]),
        .wr_en(wr_en),
        .wr_rst(1'b0),
        .wr_rst_busy(NLW_U0_wr_rst_busy_UNCONNECTED));
endmodule

(* DEF_VAL = "1'b0" *) (* DEST_SYNC_FF = "2" *) (* INIT_SYNC_FF = "0" *) 
(* INV_DEF_VAL = "1'b1" *) (* ORIG_REF_NAME = "xpm_cdc_async_rst" *) (* RST_ACTIVE_HIGH = "1" *) 
(* VERSION = "0" *) (* XPM_MODULE = "TRUE" *) (* xpm_cdc = "ASYNC_RST" *) 
module nvme_data_cmd_fifo_xpm_cdc_async_rst
   (src_arst,
    dest_clk,
    dest_arst);
  input src_arst;
  input dest_clk;
  output dest_arst;

  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "ASYNC_RST" *) wire [1:0]arststages_ff;
  wire dest_clk;
  wire src_arst;

  assign dest_arst = arststages_ff[1];
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDPE #(
    .INIT(1'b0)) 
    \arststages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(src_arst),
        .Q(arststages_ff[0]));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDPE #(
    .INIT(1'b0)) 
    \arststages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(arststages_ff[0]),
        .PRE(src_arst),
        .Q(arststages_ff[1]));
endmodule

(* ORIG_REF_NAME = "fifo_generator_ramfifo" *) 
module nvme_data_cmd_fifo_fifo_generator_ramfifo
   (full,
    empty,
    wr_rst_busy,
    dout,
    prog_full,
    rst,
    clk,
    din,
    wr_en,
    rd_en);
  output full;
  output empty;
  output wr_rst_busy;
  output [127:0]dout;
  output prog_full;
  input rst;
  input clk;
  input [127:0]din;
  input wr_en;
  input rd_en;

  wire clk;
  wire [4:4]\crd/count_reg ;
  wire [127:0]din;
  wire [127:0]dout;
  wire empty;
  wire full;
  wire prog_full;
  wire ram_rd_en;
  wire ram_wr_en;
  wire rd_en;
  wire [3:0]rd_pntr;
  wire rst;
  wire rst_full_ff_i;
  wire rst_full_gen_i;
  wire rstblk_n_3;
  wire wr_en;
  wire wr_rst_busy;

  nvme_data_cmd_fifo_logic_sshft \gntv_or_sync_fifo.gl1.lsshft 
       (.AR(rstblk_n_3),
        .Q({\crd/count_reg ,rd_pntr}),
        .clk(clk),
        .empty(empty),
        .full(full),
        .out(rst_full_ff_i),
        .prog_full(prog_full),
        .ram_full_i_reg(rst_full_gen_i),
        .ram_rd_en(ram_rd_en),
        .ram_wr_en(ram_wr_en),
        .rd_en(rd_en),
        .wr_en(wr_en));
  nvme_data_cmd_fifo_memory \gntv_or_sync_fifo.mem 
       (.AR(rstblk_n_3),
        .E(ram_rd_en),
        .Q({\crd/count_reg ,rd_pntr}),
        .clk(clk),
        .din(din),
        .dout(dout),
        .ram_wr_en(ram_wr_en));
  nvme_data_cmd_fifo_reset_blk_ramfifo rstblk
       (.AR(rstblk_n_3),
        .clk(clk),
        .\grstd1.grst_full.grst_f.rst_d3_reg_0 (rst_full_gen_i),
        .out(rst_full_ff_i),
        .rst(rst),
        .wr_rst_busy(wr_rst_busy));
endmodule

(* ORIG_REF_NAME = "fifo_generator_top" *) 
module nvme_data_cmd_fifo_fifo_generator_top
   (full,
    empty,
    wr_rst_busy,
    dout,
    prog_full,
    rst,
    clk,
    din,
    wr_en,
    rd_en);
  output full;
  output empty;
  output wr_rst_busy;
  output [127:0]dout;
  output prog_full;
  input rst;
  input clk;
  input [127:0]din;
  input wr_en;
  input rd_en;

  wire clk;
  wire [127:0]din;
  wire [127:0]dout;
  wire empty;
  wire full;
  wire prog_full;
  wire rd_en;
  wire rst;
  wire wr_en;
  wire wr_rst_busy;

  nvme_data_cmd_fifo_fifo_generator_ramfifo \grf.rf 
       (.clk(clk),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .prog_full(prog_full),
        .rd_en(rd_en),
        .rst(rst),
        .wr_en(wr_en),
        .wr_rst_busy(wr_rst_busy));
endmodule

(* C_ADD_NGC_CONSTRAINT = "0" *) (* C_APPLICATION_TYPE_AXIS = "0" *) (* C_APPLICATION_TYPE_RACH = "0" *) 
(* C_APPLICATION_TYPE_RDCH = "0" *) (* C_APPLICATION_TYPE_WACH = "0" *) (* C_APPLICATION_TYPE_WDCH = "0" *) 
(* C_APPLICATION_TYPE_WRCH = "0" *) (* C_AXIS_TDATA_WIDTH = "8" *) (* C_AXIS_TDEST_WIDTH = "1" *) 
(* C_AXIS_TID_WIDTH = "1" *) (* C_AXIS_TKEEP_WIDTH = "1" *) (* C_AXIS_TSTRB_WIDTH = "1" *) 
(* C_AXIS_TUSER_WIDTH = "4" *) (* C_AXIS_TYPE = "0" *) (* C_AXI_ADDR_WIDTH = "32" *) 
(* C_AXI_ARUSER_WIDTH = "1" *) (* C_AXI_AWUSER_WIDTH = "1" *) (* C_AXI_BUSER_WIDTH = "1" *) 
(* C_AXI_DATA_WIDTH = "64" *) (* C_AXI_ID_WIDTH = "1" *) (* C_AXI_LEN_WIDTH = "8" *) 
(* C_AXI_LOCK_WIDTH = "1" *) (* C_AXI_RUSER_WIDTH = "1" *) (* C_AXI_TYPE = "1" *) 
(* C_AXI_WUSER_WIDTH = "1" *) (* C_COMMON_CLOCK = "1" *) (* C_COUNT_TYPE = "0" *) 
(* C_DATA_COUNT_WIDTH = "5" *) (* C_DEFAULT_VALUE = "BlankString" *) (* C_DIN_WIDTH = "128" *) 
(* C_DIN_WIDTH_AXIS = "1" *) (* C_DIN_WIDTH_RACH = "32" *) (* C_DIN_WIDTH_RDCH = "64" *) 
(* C_DIN_WIDTH_WACH = "1" *) (* C_DIN_WIDTH_WDCH = "64" *) (* C_DIN_WIDTH_WRCH = "2" *) 
(* C_DOUT_RST_VAL = "0" *) (* C_DOUT_WIDTH = "128" *) (* C_ENABLE_RLOCS = "0" *) 
(* C_ENABLE_RST_SYNC = "1" *) (* C_EN_SAFETY_CKT = "0" *) (* C_ERROR_INJECTION_TYPE = "0" *) 
(* C_ERROR_INJECTION_TYPE_AXIS = "0" *) (* C_ERROR_INJECTION_TYPE_RACH = "0" *) (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
(* C_ERROR_INJECTION_TYPE_WACH = "0" *) (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
(* C_FAMILY = "kintexu" *) (* C_FULL_FLAGS_RST_VAL = "1" *) (* C_HAS_ALMOST_EMPTY = "0" *) 
(* C_HAS_ALMOST_FULL = "0" *) (* C_HAS_AXIS_TDATA = "1" *) (* C_HAS_AXIS_TDEST = "0" *) 
(* C_HAS_AXIS_TID = "0" *) (* C_HAS_AXIS_TKEEP = "0" *) (* C_HAS_AXIS_TLAST = "0" *) 
(* C_HAS_AXIS_TREADY = "1" *) (* C_HAS_AXIS_TSTRB = "0" *) (* C_HAS_AXIS_TUSER = "1" *) 
(* C_HAS_AXI_ARUSER = "0" *) (* C_HAS_AXI_AWUSER = "0" *) (* C_HAS_AXI_BUSER = "0" *) 
(* C_HAS_AXI_ID = "0" *) (* C_HAS_AXI_RD_CHANNEL = "1" *) (* C_HAS_AXI_RUSER = "0" *) 
(* C_HAS_AXI_WR_CHANNEL = "1" *) (* C_HAS_AXI_WUSER = "0" *) (* C_HAS_BACKUP = "0" *) 
(* C_HAS_DATA_COUNT = "0" *) (* C_HAS_DATA_COUNTS_AXIS = "0" *) (* C_HAS_DATA_COUNTS_RACH = "0" *) 
(* C_HAS_DATA_COUNTS_RDCH = "0" *) (* C_HAS_DATA_COUNTS_WACH = "0" *) (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
(* C_HAS_DATA_COUNTS_WRCH = "0" *) (* C_HAS_INT_CLK = "0" *) (* C_HAS_MASTER_CE = "0" *) 
(* C_HAS_MEMINIT_FILE = "0" *) (* C_HAS_OVERFLOW = "0" *) (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
(* C_HAS_PROG_FLAGS_RACH = "0" *) (* C_HAS_PROG_FLAGS_RDCH = "0" *) (* C_HAS_PROG_FLAGS_WACH = "0" *) 
(* C_HAS_PROG_FLAGS_WDCH = "0" *) (* C_HAS_PROG_FLAGS_WRCH = "0" *) (* C_HAS_RD_DATA_COUNT = "0" *) 
(* C_HAS_RD_RST = "0" *) (* C_HAS_RST = "1" *) (* C_HAS_SLAVE_CE = "0" *) 
(* C_HAS_SRST = "0" *) (* C_HAS_UNDERFLOW = "0" *) (* C_HAS_VALID = "0" *) 
(* C_HAS_WR_ACK = "0" *) (* C_HAS_WR_DATA_COUNT = "0" *) (* C_HAS_WR_RST = "0" *) 
(* C_IMPLEMENTATION_TYPE = "1" *) (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
(* C_IMPLEMENTATION_TYPE_RDCH = "1" *) (* C_IMPLEMENTATION_TYPE_WACH = "1" *) (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
(* C_IMPLEMENTATION_TYPE_WRCH = "1" *) (* C_INIT_WR_PNTR_VAL = "0" *) (* C_INTERFACE_TYPE = "0" *) 
(* C_MEMORY_TYPE = "3" *) (* C_MIF_FILE_NAME = "BlankString" *) (* C_MSGON_VAL = "1" *) 
(* C_OPTIMIZATION_MODE = "0" *) (* C_OVERFLOW_LOW = "0" *) (* C_POWER_SAVING_MODE = "0" *) 
(* C_PRELOAD_LATENCY = "1" *) (* C_PRELOAD_REGS = "0" *) (* C_PRIM_FIFO_TYPE = "512x72" *) 
(* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) (* C_PRIM_FIFO_TYPE_RDCH = "512x72" *) 
(* C_PRIM_FIFO_TYPE_WACH = "512x36" *) (* C_PRIM_FIFO_TYPE_WDCH = "512x72" *) (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
(* C_PROG_EMPTY_THRESH_ASSERT_VAL = "2" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
(* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
(* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "3" *) (* C_PROG_EMPTY_TYPE = "0" *) 
(* C_PROG_EMPTY_TYPE_AXIS = "0" *) (* C_PROG_EMPTY_TYPE_RACH = "0" *) (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
(* C_PROG_EMPTY_TYPE_WACH = "0" *) (* C_PROG_EMPTY_TYPE_WDCH = "0" *) (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
(* C_PROG_FULL_THRESH_ASSERT_VAL = "28" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
(* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
(* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) (* C_PROG_FULL_THRESH_NEGATE_VAL = "27" *) (* C_PROG_FULL_TYPE = "1" *) 
(* C_PROG_FULL_TYPE_AXIS = "0" *) (* C_PROG_FULL_TYPE_RACH = "0" *) (* C_PROG_FULL_TYPE_RDCH = "0" *) 
(* C_PROG_FULL_TYPE_WACH = "0" *) (* C_PROG_FULL_TYPE_WDCH = "0" *) (* C_PROG_FULL_TYPE_WRCH = "0" *) 
(* C_RACH_TYPE = "0" *) (* C_RDCH_TYPE = "0" *) (* C_RD_DATA_COUNT_WIDTH = "5" *) 
(* C_RD_DEPTH = "32" *) (* C_RD_FREQ = "1" *) (* C_RD_PNTR_WIDTH = "5" *) 
(* C_REG_SLICE_MODE_AXIS = "0" *) (* C_REG_SLICE_MODE_RACH = "0" *) (* C_REG_SLICE_MODE_RDCH = "0" *) 
(* C_REG_SLICE_MODE_WACH = "0" *) (* C_REG_SLICE_MODE_WDCH = "0" *) (* C_REG_SLICE_MODE_WRCH = "0" *) 
(* C_SELECT_XPM = "0" *) (* C_SYNCHRONIZER_STAGE = "2" *) (* C_UNDERFLOW_LOW = "0" *) 
(* C_USE_COMMON_OVERFLOW = "0" *) (* C_USE_COMMON_UNDERFLOW = "0" *) (* C_USE_DEFAULT_SETTINGS = "0" *) 
(* C_USE_DOUT_RST = "1" *) (* C_USE_ECC = "0" *) (* C_USE_ECC_AXIS = "0" *) 
(* C_USE_ECC_RACH = "0" *) (* C_USE_ECC_RDCH = "0" *) (* C_USE_ECC_WACH = "0" *) 
(* C_USE_ECC_WDCH = "0" *) (* C_USE_ECC_WRCH = "0" *) (* C_USE_EMBEDDED_REG = "0" *) 
(* C_USE_FIFO16_FLAGS = "0" *) (* C_USE_FWFT_DATA_COUNT = "0" *) (* C_USE_PIPELINE_REG = "0" *) 
(* C_VALID_LOW = "0" *) (* C_WACH_TYPE = "0" *) (* C_WDCH_TYPE = "0" *) 
(* C_WRCH_TYPE = "0" *) (* C_WR_ACK_LOW = "0" *) (* C_WR_DATA_COUNT_WIDTH = "5" *) 
(* C_WR_DEPTH = "32" *) (* C_WR_DEPTH_AXIS = "1024" *) (* C_WR_DEPTH_RACH = "16" *) 
(* C_WR_DEPTH_RDCH = "1024" *) (* C_WR_DEPTH_WACH = "16" *) (* C_WR_DEPTH_WDCH = "1024" *) 
(* C_WR_DEPTH_WRCH = "16" *) (* C_WR_FREQ = "1" *) (* C_WR_PNTR_WIDTH = "5" *) 
(* C_WR_PNTR_WIDTH_AXIS = "10" *) (* C_WR_PNTR_WIDTH_RACH = "4" *) (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
(* C_WR_PNTR_WIDTH_WACH = "4" *) (* C_WR_PNTR_WIDTH_WDCH = "10" *) (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
(* C_WR_RESPONSE_LATENCY = "1" *) (* ORIG_REF_NAME = "fifo_generator_v13_2_5" *) 
module nvme_data_cmd_fifo_fifo_generator_v13_2_5
   (backup,
    backup_marker,
    clk,
    rst,
    srst,
    wr_clk,
    wr_rst,
    rd_clk,
    rd_rst,
    din,
    wr_en,
    rd_en,
    prog_empty_thresh,
    prog_empty_thresh_assert,
    prog_empty_thresh_negate,
    prog_full_thresh,
    prog_full_thresh_assert,
    prog_full_thresh_negate,
    int_clk,
    injectdbiterr,
    injectsbiterr,
    sleep,
    dout,
    full,
    almost_full,
    wr_ack,
    overflow,
    empty,
    almost_empty,
    valid,
    underflow,
    data_count,
    rd_data_count,
    wr_data_count,
    prog_full,
    prog_empty,
    sbiterr,
    dbiterr,
    wr_rst_busy,
    rd_rst_busy,
    m_aclk,
    s_aclk,
    s_aresetn,
    m_aclk_en,
    s_aclk_en,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awlock,
    s_axi_awcache,
    s_axi_awprot,
    s_axi_awqos,
    s_axi_awregion,
    s_axi_awuser,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wid,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wuser,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_buser,
    s_axi_bvalid,
    s_axi_bready,
    m_axi_awid,
    m_axi_awaddr,
    m_axi_awlen,
    m_axi_awsize,
    m_axi_awburst,
    m_axi_awlock,
    m_axi_awcache,
    m_axi_awprot,
    m_axi_awqos,
    m_axi_awregion,
    m_axi_awuser,
    m_axi_awvalid,
    m_axi_awready,
    m_axi_wid,
    m_axi_wdata,
    m_axi_wstrb,
    m_axi_wlast,
    m_axi_wuser,
    m_axi_wvalid,
    m_axi_wready,
    m_axi_bid,
    m_axi_bresp,
    m_axi_buser,
    m_axi_bvalid,
    m_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arlock,
    s_axi_arcache,
    s_axi_arprot,
    s_axi_arqos,
    s_axi_arregion,
    s_axi_aruser,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_ruser,
    s_axi_rvalid,
    s_axi_rready,
    m_axi_arid,
    m_axi_araddr,
    m_axi_arlen,
    m_axi_arsize,
    m_axi_arburst,
    m_axi_arlock,
    m_axi_arcache,
    m_axi_arprot,
    m_axi_arqos,
    m_axi_arregion,
    m_axi_aruser,
    m_axi_arvalid,
    m_axi_arready,
    m_axi_rid,
    m_axi_rdata,
    m_axi_rresp,
    m_axi_rlast,
    m_axi_ruser,
    m_axi_rvalid,
    m_axi_rready,
    s_axis_tvalid,
    s_axis_tready,
    s_axis_tdata,
    s_axis_tstrb,
    s_axis_tkeep,
    s_axis_tlast,
    s_axis_tid,
    s_axis_tdest,
    s_axis_tuser,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tdata,
    m_axis_tstrb,
    m_axis_tkeep,
    m_axis_tlast,
    m_axis_tid,
    m_axis_tdest,
    m_axis_tuser,
    axi_aw_injectsbiterr,
    axi_aw_injectdbiterr,
    axi_aw_prog_full_thresh,
    axi_aw_prog_empty_thresh,
    axi_aw_data_count,
    axi_aw_wr_data_count,
    axi_aw_rd_data_count,
    axi_aw_sbiterr,
    axi_aw_dbiterr,
    axi_aw_overflow,
    axi_aw_underflow,
    axi_aw_prog_full,
    axi_aw_prog_empty,
    axi_w_injectsbiterr,
    axi_w_injectdbiterr,
    axi_w_prog_full_thresh,
    axi_w_prog_empty_thresh,
    axi_w_data_count,
    axi_w_wr_data_count,
    axi_w_rd_data_count,
    axi_w_sbiterr,
    axi_w_dbiterr,
    axi_w_overflow,
    axi_w_underflow,
    axi_w_prog_full,
    axi_w_prog_empty,
    axi_b_injectsbiterr,
    axi_b_injectdbiterr,
    axi_b_prog_full_thresh,
    axi_b_prog_empty_thresh,
    axi_b_data_count,
    axi_b_wr_data_count,
    axi_b_rd_data_count,
    axi_b_sbiterr,
    axi_b_dbiterr,
    axi_b_overflow,
    axi_b_underflow,
    axi_b_prog_full,
    axi_b_prog_empty,
    axi_ar_injectsbiterr,
    axi_ar_injectdbiterr,
    axi_ar_prog_full_thresh,
    axi_ar_prog_empty_thresh,
    axi_ar_data_count,
    axi_ar_wr_data_count,
    axi_ar_rd_data_count,
    axi_ar_sbiterr,
    axi_ar_dbiterr,
    axi_ar_overflow,
    axi_ar_underflow,
    axi_ar_prog_full,
    axi_ar_prog_empty,
    axi_r_injectsbiterr,
    axi_r_injectdbiterr,
    axi_r_prog_full_thresh,
    axi_r_prog_empty_thresh,
    axi_r_data_count,
    axi_r_wr_data_count,
    axi_r_rd_data_count,
    axi_r_sbiterr,
    axi_r_dbiterr,
    axi_r_overflow,
    axi_r_underflow,
    axi_r_prog_full,
    axi_r_prog_empty,
    axis_injectsbiterr,
    axis_injectdbiterr,
    axis_prog_full_thresh,
    axis_prog_empty_thresh,
    axis_data_count,
    axis_wr_data_count,
    axis_rd_data_count,
    axis_sbiterr,
    axis_dbiterr,
    axis_overflow,
    axis_underflow,
    axis_prog_full,
    axis_prog_empty);
  input backup;
  input backup_marker;
  input clk;
  input rst;
  input srst;
  input wr_clk;
  input wr_rst;
  input rd_clk;
  input rd_rst;
  input [127:0]din;
  input wr_en;
  input rd_en;
  input [4:0]prog_empty_thresh;
  input [4:0]prog_empty_thresh_assert;
  input [4:0]prog_empty_thresh_negate;
  input [4:0]prog_full_thresh;
  input [4:0]prog_full_thresh_assert;
  input [4:0]prog_full_thresh_negate;
  input int_clk;
  input injectdbiterr;
  input injectsbiterr;
  input sleep;
  output [127:0]dout;
  output full;
  output almost_full;
  output wr_ack;
  output overflow;
  output empty;
  output almost_empty;
  output valid;
  output underflow;
  output [4:0]data_count;
  output [4:0]rd_data_count;
  output [4:0]wr_data_count;
  output prog_full;
  output prog_empty;
  output sbiterr;
  output dbiterr;
  output wr_rst_busy;
  output rd_rst_busy;
  input m_aclk;
  input s_aclk;
  input s_aresetn;
  input m_aclk_en;
  input s_aclk_en;
  input [0:0]s_axi_awid;
  input [31:0]s_axi_awaddr;
  input [7:0]s_axi_awlen;
  input [2:0]s_axi_awsize;
  input [1:0]s_axi_awburst;
  input [0:0]s_axi_awlock;
  input [3:0]s_axi_awcache;
  input [2:0]s_axi_awprot;
  input [3:0]s_axi_awqos;
  input [3:0]s_axi_awregion;
  input [0:0]s_axi_awuser;
  input s_axi_awvalid;
  output s_axi_awready;
  input [0:0]s_axi_wid;
  input [63:0]s_axi_wdata;
  input [7:0]s_axi_wstrb;
  input s_axi_wlast;
  input [0:0]s_axi_wuser;
  input s_axi_wvalid;
  output s_axi_wready;
  output [0:0]s_axi_bid;
  output [1:0]s_axi_bresp;
  output [0:0]s_axi_buser;
  output s_axi_bvalid;
  input s_axi_bready;
  output [0:0]m_axi_awid;
  output [31:0]m_axi_awaddr;
  output [7:0]m_axi_awlen;
  output [2:0]m_axi_awsize;
  output [1:0]m_axi_awburst;
  output [0:0]m_axi_awlock;
  output [3:0]m_axi_awcache;
  output [2:0]m_axi_awprot;
  output [3:0]m_axi_awqos;
  output [3:0]m_axi_awregion;
  output [0:0]m_axi_awuser;
  output m_axi_awvalid;
  input m_axi_awready;
  output [0:0]m_axi_wid;
  output [63:0]m_axi_wdata;
  output [7:0]m_axi_wstrb;
  output m_axi_wlast;
  output [0:0]m_axi_wuser;
  output m_axi_wvalid;
  input m_axi_wready;
  input [0:0]m_axi_bid;
  input [1:0]m_axi_bresp;
  input [0:0]m_axi_buser;
  input m_axi_bvalid;
  output m_axi_bready;
  input [0:0]s_axi_arid;
  input [31:0]s_axi_araddr;
  input [7:0]s_axi_arlen;
  input [2:0]s_axi_arsize;
  input [1:0]s_axi_arburst;
  input [0:0]s_axi_arlock;
  input [3:0]s_axi_arcache;
  input [2:0]s_axi_arprot;
  input [3:0]s_axi_arqos;
  input [3:0]s_axi_arregion;
  input [0:0]s_axi_aruser;
  input s_axi_arvalid;
  output s_axi_arready;
  output [0:0]s_axi_rid;
  output [63:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rlast;
  output [0:0]s_axi_ruser;
  output s_axi_rvalid;
  input s_axi_rready;
  output [0:0]m_axi_arid;
  output [31:0]m_axi_araddr;
  output [7:0]m_axi_arlen;
  output [2:0]m_axi_arsize;
  output [1:0]m_axi_arburst;
  output [0:0]m_axi_arlock;
  output [3:0]m_axi_arcache;
  output [2:0]m_axi_arprot;
  output [3:0]m_axi_arqos;
  output [3:0]m_axi_arregion;
  output [0:0]m_axi_aruser;
  output m_axi_arvalid;
  input m_axi_arready;
  input [0:0]m_axi_rid;
  input [63:0]m_axi_rdata;
  input [1:0]m_axi_rresp;
  input m_axi_rlast;
  input [0:0]m_axi_ruser;
  input m_axi_rvalid;
  output m_axi_rready;
  input s_axis_tvalid;
  output s_axis_tready;
  input [7:0]s_axis_tdata;
  input [0:0]s_axis_tstrb;
  input [0:0]s_axis_tkeep;
  input s_axis_tlast;
  input [0:0]s_axis_tid;
  input [0:0]s_axis_tdest;
  input [3:0]s_axis_tuser;
  output m_axis_tvalid;
  input m_axis_tready;
  output [7:0]m_axis_tdata;
  output [0:0]m_axis_tstrb;
  output [0:0]m_axis_tkeep;
  output m_axis_tlast;
  output [0:0]m_axis_tid;
  output [0:0]m_axis_tdest;
  output [3:0]m_axis_tuser;
  input axi_aw_injectsbiterr;
  input axi_aw_injectdbiterr;
  input [3:0]axi_aw_prog_full_thresh;
  input [3:0]axi_aw_prog_empty_thresh;
  output [4:0]axi_aw_data_count;
  output [4:0]axi_aw_wr_data_count;
  output [4:0]axi_aw_rd_data_count;
  output axi_aw_sbiterr;
  output axi_aw_dbiterr;
  output axi_aw_overflow;
  output axi_aw_underflow;
  output axi_aw_prog_full;
  output axi_aw_prog_empty;
  input axi_w_injectsbiterr;
  input axi_w_injectdbiterr;
  input [9:0]axi_w_prog_full_thresh;
  input [9:0]axi_w_prog_empty_thresh;
  output [10:0]axi_w_data_count;
  output [10:0]axi_w_wr_data_count;
  output [10:0]axi_w_rd_data_count;
  output axi_w_sbiterr;
  output axi_w_dbiterr;
  output axi_w_overflow;
  output axi_w_underflow;
  output axi_w_prog_full;
  output axi_w_prog_empty;
  input axi_b_injectsbiterr;
  input axi_b_injectdbiterr;
  input [3:0]axi_b_prog_full_thresh;
  input [3:0]axi_b_prog_empty_thresh;
  output [4:0]axi_b_data_count;
  output [4:0]axi_b_wr_data_count;
  output [4:0]axi_b_rd_data_count;
  output axi_b_sbiterr;
  output axi_b_dbiterr;
  output axi_b_overflow;
  output axi_b_underflow;
  output axi_b_prog_full;
  output axi_b_prog_empty;
  input axi_ar_injectsbiterr;
  input axi_ar_injectdbiterr;
  input [3:0]axi_ar_prog_full_thresh;
  input [3:0]axi_ar_prog_empty_thresh;
  output [4:0]axi_ar_data_count;
  output [4:0]axi_ar_wr_data_count;
  output [4:0]axi_ar_rd_data_count;
  output axi_ar_sbiterr;
  output axi_ar_dbiterr;
  output axi_ar_overflow;
  output axi_ar_underflow;
  output axi_ar_prog_full;
  output axi_ar_prog_empty;
  input axi_r_injectsbiterr;
  input axi_r_injectdbiterr;
  input [9:0]axi_r_prog_full_thresh;
  input [9:0]axi_r_prog_empty_thresh;
  output [10:0]axi_r_data_count;
  output [10:0]axi_r_wr_data_count;
  output [10:0]axi_r_rd_data_count;
  output axi_r_sbiterr;
  output axi_r_dbiterr;
  output axi_r_overflow;
  output axi_r_underflow;
  output axi_r_prog_full;
  output axi_r_prog_empty;
  input axis_injectsbiterr;
  input axis_injectdbiterr;
  input [9:0]axis_prog_full_thresh;
  input [9:0]axis_prog_empty_thresh;
  output [10:0]axis_data_count;
  output [10:0]axis_wr_data_count;
  output [10:0]axis_rd_data_count;
  output axis_sbiterr;
  output axis_dbiterr;
  output axis_overflow;
  output axis_underflow;
  output axis_prog_full;
  output axis_prog_empty;

  wire \<const0> ;
  wire \<const1> ;
  wire clk;
  wire [127:0]din;
  wire [127:0]dout;
  wire empty;
  wire full;
  wire prog_full;
  wire rd_en;
  wire rst;
  wire wr_en;
  wire wr_rst_busy;

  assign almost_empty = \<const0> ;
  assign almost_full = \<const0> ;
  assign axi_ar_data_count[4] = \<const0> ;
  assign axi_ar_data_count[3] = \<const0> ;
  assign axi_ar_data_count[2] = \<const0> ;
  assign axi_ar_data_count[1] = \<const0> ;
  assign axi_ar_data_count[0] = \<const0> ;
  assign axi_ar_dbiterr = \<const0> ;
  assign axi_ar_overflow = \<const0> ;
  assign axi_ar_prog_empty = \<const1> ;
  assign axi_ar_prog_full = \<const0> ;
  assign axi_ar_rd_data_count[4] = \<const0> ;
  assign axi_ar_rd_data_count[3] = \<const0> ;
  assign axi_ar_rd_data_count[2] = \<const0> ;
  assign axi_ar_rd_data_count[1] = \<const0> ;
  assign axi_ar_rd_data_count[0] = \<const0> ;
  assign axi_ar_sbiterr = \<const0> ;
  assign axi_ar_underflow = \<const0> ;
  assign axi_ar_wr_data_count[4] = \<const0> ;
  assign axi_ar_wr_data_count[3] = \<const0> ;
  assign axi_ar_wr_data_count[2] = \<const0> ;
  assign axi_ar_wr_data_count[1] = \<const0> ;
  assign axi_ar_wr_data_count[0] = \<const0> ;
  assign axi_aw_data_count[4] = \<const0> ;
  assign axi_aw_data_count[3] = \<const0> ;
  assign axi_aw_data_count[2] = \<const0> ;
  assign axi_aw_data_count[1] = \<const0> ;
  assign axi_aw_data_count[0] = \<const0> ;
  assign axi_aw_dbiterr = \<const0> ;
  assign axi_aw_overflow = \<const0> ;
  assign axi_aw_prog_empty = \<const1> ;
  assign axi_aw_prog_full = \<const0> ;
  assign axi_aw_rd_data_count[4] = \<const0> ;
  assign axi_aw_rd_data_count[3] = \<const0> ;
  assign axi_aw_rd_data_count[2] = \<const0> ;
  assign axi_aw_rd_data_count[1] = \<const0> ;
  assign axi_aw_rd_data_count[0] = \<const0> ;
  assign axi_aw_sbiterr = \<const0> ;
  assign axi_aw_underflow = \<const0> ;
  assign axi_aw_wr_data_count[4] = \<const0> ;
  assign axi_aw_wr_data_count[3] = \<const0> ;
  assign axi_aw_wr_data_count[2] = \<const0> ;
  assign axi_aw_wr_data_count[1] = \<const0> ;
  assign axi_aw_wr_data_count[0] = \<const0> ;
  assign axi_b_data_count[4] = \<const0> ;
  assign axi_b_data_count[3] = \<const0> ;
  assign axi_b_data_count[2] = \<const0> ;
  assign axi_b_data_count[1] = \<const0> ;
  assign axi_b_data_count[0] = \<const0> ;
  assign axi_b_dbiterr = \<const0> ;
  assign axi_b_overflow = \<const0> ;
  assign axi_b_prog_empty = \<const1> ;
  assign axi_b_prog_full = \<const0> ;
  assign axi_b_rd_data_count[4] = \<const0> ;
  assign axi_b_rd_data_count[3] = \<const0> ;
  assign axi_b_rd_data_count[2] = \<const0> ;
  assign axi_b_rd_data_count[1] = \<const0> ;
  assign axi_b_rd_data_count[0] = \<const0> ;
  assign axi_b_sbiterr = \<const0> ;
  assign axi_b_underflow = \<const0> ;
  assign axi_b_wr_data_count[4] = \<const0> ;
  assign axi_b_wr_data_count[3] = \<const0> ;
  assign axi_b_wr_data_count[2] = \<const0> ;
  assign axi_b_wr_data_count[1] = \<const0> ;
  assign axi_b_wr_data_count[0] = \<const0> ;
  assign axi_r_data_count[10] = \<const0> ;
  assign axi_r_data_count[9] = \<const0> ;
  assign axi_r_data_count[8] = \<const0> ;
  assign axi_r_data_count[7] = \<const0> ;
  assign axi_r_data_count[6] = \<const0> ;
  assign axi_r_data_count[5] = \<const0> ;
  assign axi_r_data_count[4] = \<const0> ;
  assign axi_r_data_count[3] = \<const0> ;
  assign axi_r_data_count[2] = \<const0> ;
  assign axi_r_data_count[1] = \<const0> ;
  assign axi_r_data_count[0] = \<const0> ;
  assign axi_r_dbiterr = \<const0> ;
  assign axi_r_overflow = \<const0> ;
  assign axi_r_prog_empty = \<const1> ;
  assign axi_r_prog_full = \<const0> ;
  assign axi_r_rd_data_count[10] = \<const0> ;
  assign axi_r_rd_data_count[9] = \<const0> ;
  assign axi_r_rd_data_count[8] = \<const0> ;
  assign axi_r_rd_data_count[7] = \<const0> ;
  assign axi_r_rd_data_count[6] = \<const0> ;
  assign axi_r_rd_data_count[5] = \<const0> ;
  assign axi_r_rd_data_count[4] = \<const0> ;
  assign axi_r_rd_data_count[3] = \<const0> ;
  assign axi_r_rd_data_count[2] = \<const0> ;
  assign axi_r_rd_data_count[1] = \<const0> ;
  assign axi_r_rd_data_count[0] = \<const0> ;
  assign axi_r_sbiterr = \<const0> ;
  assign axi_r_underflow = \<const0> ;
  assign axi_r_wr_data_count[10] = \<const0> ;
  assign axi_r_wr_data_count[9] = \<const0> ;
  assign axi_r_wr_data_count[8] = \<const0> ;
  assign axi_r_wr_data_count[7] = \<const0> ;
  assign axi_r_wr_data_count[6] = \<const0> ;
  assign axi_r_wr_data_count[5] = \<const0> ;
  assign axi_r_wr_data_count[4] = \<const0> ;
  assign axi_r_wr_data_count[3] = \<const0> ;
  assign axi_r_wr_data_count[2] = \<const0> ;
  assign axi_r_wr_data_count[1] = \<const0> ;
  assign axi_r_wr_data_count[0] = \<const0> ;
  assign axi_w_data_count[10] = \<const0> ;
  assign axi_w_data_count[9] = \<const0> ;
  assign axi_w_data_count[8] = \<const0> ;
  assign axi_w_data_count[7] = \<const0> ;
  assign axi_w_data_count[6] = \<const0> ;
  assign axi_w_data_count[5] = \<const0> ;
  assign axi_w_data_count[4] = \<const0> ;
  assign axi_w_data_count[3] = \<const0> ;
  assign axi_w_data_count[2] = \<const0> ;
  assign axi_w_data_count[1] = \<const0> ;
  assign axi_w_data_count[0] = \<const0> ;
  assign axi_w_dbiterr = \<const0> ;
  assign axi_w_overflow = \<const0> ;
  assign axi_w_prog_empty = \<const1> ;
  assign axi_w_prog_full = \<const0> ;
  assign axi_w_rd_data_count[10] = \<const0> ;
  assign axi_w_rd_data_count[9] = \<const0> ;
  assign axi_w_rd_data_count[8] = \<const0> ;
  assign axi_w_rd_data_count[7] = \<const0> ;
  assign axi_w_rd_data_count[6] = \<const0> ;
  assign axi_w_rd_data_count[5] = \<const0> ;
  assign axi_w_rd_data_count[4] = \<const0> ;
  assign axi_w_rd_data_count[3] = \<const0> ;
  assign axi_w_rd_data_count[2] = \<const0> ;
  assign axi_w_rd_data_count[1] = \<const0> ;
  assign axi_w_rd_data_count[0] = \<const0> ;
  assign axi_w_sbiterr = \<const0> ;
  assign axi_w_underflow = \<const0> ;
  assign axi_w_wr_data_count[10] = \<const0> ;
  assign axi_w_wr_data_count[9] = \<const0> ;
  assign axi_w_wr_data_count[8] = \<const0> ;
  assign axi_w_wr_data_count[7] = \<const0> ;
  assign axi_w_wr_data_count[6] = \<const0> ;
  assign axi_w_wr_data_count[5] = \<const0> ;
  assign axi_w_wr_data_count[4] = \<const0> ;
  assign axi_w_wr_data_count[3] = \<const0> ;
  assign axi_w_wr_data_count[2] = \<const0> ;
  assign axi_w_wr_data_count[1] = \<const0> ;
  assign axi_w_wr_data_count[0] = \<const0> ;
  assign axis_data_count[10] = \<const0> ;
  assign axis_data_count[9] = \<const0> ;
  assign axis_data_count[8] = \<const0> ;
  assign axis_data_count[7] = \<const0> ;
  assign axis_data_count[6] = \<const0> ;
  assign axis_data_count[5] = \<const0> ;
  assign axis_data_count[4] = \<const0> ;
  assign axis_data_count[3] = \<const0> ;
  assign axis_data_count[2] = \<const0> ;
  assign axis_data_count[1] = \<const0> ;
  assign axis_data_count[0] = \<const0> ;
  assign axis_dbiterr = \<const0> ;
  assign axis_overflow = \<const0> ;
  assign axis_prog_empty = \<const1> ;
  assign axis_prog_full = \<const0> ;
  assign axis_rd_data_count[10] = \<const0> ;
  assign axis_rd_data_count[9] = \<const0> ;
  assign axis_rd_data_count[8] = \<const0> ;
  assign axis_rd_data_count[7] = \<const0> ;
  assign axis_rd_data_count[6] = \<const0> ;
  assign axis_rd_data_count[5] = \<const0> ;
  assign axis_rd_data_count[4] = \<const0> ;
  assign axis_rd_data_count[3] = \<const0> ;
  assign axis_rd_data_count[2] = \<const0> ;
  assign axis_rd_data_count[1] = \<const0> ;
  assign axis_rd_data_count[0] = \<const0> ;
  assign axis_sbiterr = \<const0> ;
  assign axis_underflow = \<const0> ;
  assign axis_wr_data_count[10] = \<const0> ;
  assign axis_wr_data_count[9] = \<const0> ;
  assign axis_wr_data_count[8] = \<const0> ;
  assign axis_wr_data_count[7] = \<const0> ;
  assign axis_wr_data_count[6] = \<const0> ;
  assign axis_wr_data_count[5] = \<const0> ;
  assign axis_wr_data_count[4] = \<const0> ;
  assign axis_wr_data_count[3] = \<const0> ;
  assign axis_wr_data_count[2] = \<const0> ;
  assign axis_wr_data_count[1] = \<const0> ;
  assign axis_wr_data_count[0] = \<const0> ;
  assign data_count[4] = \<const0> ;
  assign data_count[3] = \<const0> ;
  assign data_count[2] = \<const0> ;
  assign data_count[1] = \<const0> ;
  assign data_count[0] = \<const0> ;
  assign dbiterr = \<const0> ;
  assign m_axi_araddr[31] = \<const0> ;
  assign m_axi_araddr[30] = \<const0> ;
  assign m_axi_araddr[29] = \<const0> ;
  assign m_axi_araddr[28] = \<const0> ;
  assign m_axi_araddr[27] = \<const0> ;
  assign m_axi_araddr[26] = \<const0> ;
  assign m_axi_araddr[25] = \<const0> ;
  assign m_axi_araddr[24] = \<const0> ;
  assign m_axi_araddr[23] = \<const0> ;
  assign m_axi_araddr[22] = \<const0> ;
  assign m_axi_araddr[21] = \<const0> ;
  assign m_axi_araddr[20] = \<const0> ;
  assign m_axi_araddr[19] = \<const0> ;
  assign m_axi_araddr[18] = \<const0> ;
  assign m_axi_araddr[17] = \<const0> ;
  assign m_axi_araddr[16] = \<const0> ;
  assign m_axi_araddr[15] = \<const0> ;
  assign m_axi_araddr[14] = \<const0> ;
  assign m_axi_araddr[13] = \<const0> ;
  assign m_axi_araddr[12] = \<const0> ;
  assign m_axi_araddr[11] = \<const0> ;
  assign m_axi_araddr[10] = \<const0> ;
  assign m_axi_araddr[9] = \<const0> ;
  assign m_axi_araddr[8] = \<const0> ;
  assign m_axi_araddr[7] = \<const0> ;
  assign m_axi_araddr[6] = \<const0> ;
  assign m_axi_araddr[5] = \<const0> ;
  assign m_axi_araddr[4] = \<const0> ;
  assign m_axi_araddr[3] = \<const0> ;
  assign m_axi_araddr[2] = \<const0> ;
  assign m_axi_araddr[1] = \<const0> ;
  assign m_axi_araddr[0] = \<const0> ;
  assign m_axi_arburst[1] = \<const0> ;
  assign m_axi_arburst[0] = \<const0> ;
  assign m_axi_arcache[3] = \<const0> ;
  assign m_axi_arcache[2] = \<const0> ;
  assign m_axi_arcache[1] = \<const0> ;
  assign m_axi_arcache[0] = \<const0> ;
  assign m_axi_arid[0] = \<const0> ;
  assign m_axi_arlen[7] = \<const0> ;
  assign m_axi_arlen[6] = \<const0> ;
  assign m_axi_arlen[5] = \<const0> ;
  assign m_axi_arlen[4] = \<const0> ;
  assign m_axi_arlen[3] = \<const0> ;
  assign m_axi_arlen[2] = \<const0> ;
  assign m_axi_arlen[1] = \<const0> ;
  assign m_axi_arlen[0] = \<const0> ;
  assign m_axi_arlock[0] = \<const0> ;
  assign m_axi_arprot[2] = \<const0> ;
  assign m_axi_arprot[1] = \<const0> ;
  assign m_axi_arprot[0] = \<const0> ;
  assign m_axi_arqos[3] = \<const0> ;
  assign m_axi_arqos[2] = \<const0> ;
  assign m_axi_arqos[1] = \<const0> ;
  assign m_axi_arqos[0] = \<const0> ;
  assign m_axi_arregion[3] = \<const0> ;
  assign m_axi_arregion[2] = \<const0> ;
  assign m_axi_arregion[1] = \<const0> ;
  assign m_axi_arregion[0] = \<const0> ;
  assign m_axi_arsize[2] = \<const0> ;
  assign m_axi_arsize[1] = \<const0> ;
  assign m_axi_arsize[0] = \<const0> ;
  assign m_axi_aruser[0] = \<const0> ;
  assign m_axi_arvalid = \<const0> ;
  assign m_axi_awaddr[31] = \<const0> ;
  assign m_axi_awaddr[30] = \<const0> ;
  assign m_axi_awaddr[29] = \<const0> ;
  assign m_axi_awaddr[28] = \<const0> ;
  assign m_axi_awaddr[27] = \<const0> ;
  assign m_axi_awaddr[26] = \<const0> ;
  assign m_axi_awaddr[25] = \<const0> ;
  assign m_axi_awaddr[24] = \<const0> ;
  assign m_axi_awaddr[23] = \<const0> ;
  assign m_axi_awaddr[22] = \<const0> ;
  assign m_axi_awaddr[21] = \<const0> ;
  assign m_axi_awaddr[20] = \<const0> ;
  assign m_axi_awaddr[19] = \<const0> ;
  assign m_axi_awaddr[18] = \<const0> ;
  assign m_axi_awaddr[17] = \<const0> ;
  assign m_axi_awaddr[16] = \<const0> ;
  assign m_axi_awaddr[15] = \<const0> ;
  assign m_axi_awaddr[14] = \<const0> ;
  assign m_axi_awaddr[13] = \<const0> ;
  assign m_axi_awaddr[12] = \<const0> ;
  assign m_axi_awaddr[11] = \<const0> ;
  assign m_axi_awaddr[10] = \<const0> ;
  assign m_axi_awaddr[9] = \<const0> ;
  assign m_axi_awaddr[8] = \<const0> ;
  assign m_axi_awaddr[7] = \<const0> ;
  assign m_axi_awaddr[6] = \<const0> ;
  assign m_axi_awaddr[5] = \<const0> ;
  assign m_axi_awaddr[4] = \<const0> ;
  assign m_axi_awaddr[3] = \<const0> ;
  assign m_axi_awaddr[2] = \<const0> ;
  assign m_axi_awaddr[1] = \<const0> ;
  assign m_axi_awaddr[0] = \<const0> ;
  assign m_axi_awburst[1] = \<const0> ;
  assign m_axi_awburst[0] = \<const0> ;
  assign m_axi_awcache[3] = \<const0> ;
  assign m_axi_awcache[2] = \<const0> ;
  assign m_axi_awcache[1] = \<const0> ;
  assign m_axi_awcache[0] = \<const0> ;
  assign m_axi_awid[0] = \<const0> ;
  assign m_axi_awlen[7] = \<const0> ;
  assign m_axi_awlen[6] = \<const0> ;
  assign m_axi_awlen[5] = \<const0> ;
  assign m_axi_awlen[4] = \<const0> ;
  assign m_axi_awlen[3] = \<const0> ;
  assign m_axi_awlen[2] = \<const0> ;
  assign m_axi_awlen[1] = \<const0> ;
  assign m_axi_awlen[0] = \<const0> ;
  assign m_axi_awlock[0] = \<const0> ;
  assign m_axi_awprot[2] = \<const0> ;
  assign m_axi_awprot[1] = \<const0> ;
  assign m_axi_awprot[0] = \<const0> ;
  assign m_axi_awqos[3] = \<const0> ;
  assign m_axi_awqos[2] = \<const0> ;
  assign m_axi_awqos[1] = \<const0> ;
  assign m_axi_awqos[0] = \<const0> ;
  assign m_axi_awregion[3] = \<const0> ;
  assign m_axi_awregion[2] = \<const0> ;
  assign m_axi_awregion[1] = \<const0> ;
  assign m_axi_awregion[0] = \<const0> ;
  assign m_axi_awsize[2] = \<const0> ;
  assign m_axi_awsize[1] = \<const0> ;
  assign m_axi_awsize[0] = \<const0> ;
  assign m_axi_awuser[0] = \<const0> ;
  assign m_axi_awvalid = \<const0> ;
  assign m_axi_bready = \<const0> ;
  assign m_axi_rready = \<const0> ;
  assign m_axi_wdata[63] = \<const0> ;
  assign m_axi_wdata[62] = \<const0> ;
  assign m_axi_wdata[61] = \<const0> ;
  assign m_axi_wdata[60] = \<const0> ;
  assign m_axi_wdata[59] = \<const0> ;
  assign m_axi_wdata[58] = \<const0> ;
  assign m_axi_wdata[57] = \<const0> ;
  assign m_axi_wdata[56] = \<const0> ;
  assign m_axi_wdata[55] = \<const0> ;
  assign m_axi_wdata[54] = \<const0> ;
  assign m_axi_wdata[53] = \<const0> ;
  assign m_axi_wdata[52] = \<const0> ;
  assign m_axi_wdata[51] = \<const0> ;
  assign m_axi_wdata[50] = \<const0> ;
  assign m_axi_wdata[49] = \<const0> ;
  assign m_axi_wdata[48] = \<const0> ;
  assign m_axi_wdata[47] = \<const0> ;
  assign m_axi_wdata[46] = \<const0> ;
  assign m_axi_wdata[45] = \<const0> ;
  assign m_axi_wdata[44] = \<const0> ;
  assign m_axi_wdata[43] = \<const0> ;
  assign m_axi_wdata[42] = \<const0> ;
  assign m_axi_wdata[41] = \<const0> ;
  assign m_axi_wdata[40] = \<const0> ;
  assign m_axi_wdata[39] = \<const0> ;
  assign m_axi_wdata[38] = \<const0> ;
  assign m_axi_wdata[37] = \<const0> ;
  assign m_axi_wdata[36] = \<const0> ;
  assign m_axi_wdata[35] = \<const0> ;
  assign m_axi_wdata[34] = \<const0> ;
  assign m_axi_wdata[33] = \<const0> ;
  assign m_axi_wdata[32] = \<const0> ;
  assign m_axi_wdata[31] = \<const0> ;
  assign m_axi_wdata[30] = \<const0> ;
  assign m_axi_wdata[29] = \<const0> ;
  assign m_axi_wdata[28] = \<const0> ;
  assign m_axi_wdata[27] = \<const0> ;
  assign m_axi_wdata[26] = \<const0> ;
  assign m_axi_wdata[25] = \<const0> ;
  assign m_axi_wdata[24] = \<const0> ;
  assign m_axi_wdata[23] = \<const0> ;
  assign m_axi_wdata[22] = \<const0> ;
  assign m_axi_wdata[21] = \<const0> ;
  assign m_axi_wdata[20] = \<const0> ;
  assign m_axi_wdata[19] = \<const0> ;
  assign m_axi_wdata[18] = \<const0> ;
  assign m_axi_wdata[17] = \<const0> ;
  assign m_axi_wdata[16] = \<const0> ;
  assign m_axi_wdata[15] = \<const0> ;
  assign m_axi_wdata[14] = \<const0> ;
  assign m_axi_wdata[13] = \<const0> ;
  assign m_axi_wdata[12] = \<const0> ;
  assign m_axi_wdata[11] = \<const0> ;
  assign m_axi_wdata[10] = \<const0> ;
  assign m_axi_wdata[9] = \<const0> ;
  assign m_axi_wdata[8] = \<const0> ;
  assign m_axi_wdata[7] = \<const0> ;
  assign m_axi_wdata[6] = \<const0> ;
  assign m_axi_wdata[5] = \<const0> ;
  assign m_axi_wdata[4] = \<const0> ;
  assign m_axi_wdata[3] = \<const0> ;
  assign m_axi_wdata[2] = \<const0> ;
  assign m_axi_wdata[1] = \<const0> ;
  assign m_axi_wdata[0] = \<const0> ;
  assign m_axi_wid[0] = \<const0> ;
  assign m_axi_wlast = \<const0> ;
  assign m_axi_wstrb[7] = \<const0> ;
  assign m_axi_wstrb[6] = \<const0> ;
  assign m_axi_wstrb[5] = \<const0> ;
  assign m_axi_wstrb[4] = \<const0> ;
  assign m_axi_wstrb[3] = \<const0> ;
  assign m_axi_wstrb[2] = \<const0> ;
  assign m_axi_wstrb[1] = \<const0> ;
  assign m_axi_wstrb[0] = \<const0> ;
  assign m_axi_wuser[0] = \<const0> ;
  assign m_axi_wvalid = \<const0> ;
  assign m_axis_tdata[7] = \<const0> ;
  assign m_axis_tdata[6] = \<const0> ;
  assign m_axis_tdata[5] = \<const0> ;
  assign m_axis_tdata[4] = \<const0> ;
  assign m_axis_tdata[3] = \<const0> ;
  assign m_axis_tdata[2] = \<const0> ;
  assign m_axis_tdata[1] = \<const0> ;
  assign m_axis_tdata[0] = \<const0> ;
  assign m_axis_tdest[0] = \<const0> ;
  assign m_axis_tid[0] = \<const0> ;
  assign m_axis_tkeep[0] = \<const0> ;
  assign m_axis_tlast = \<const0> ;
  assign m_axis_tstrb[0] = \<const0> ;
  assign m_axis_tuser[3] = \<const0> ;
  assign m_axis_tuser[2] = \<const0> ;
  assign m_axis_tuser[1] = \<const0> ;
  assign m_axis_tuser[0] = \<const0> ;
  assign m_axis_tvalid = \<const0> ;
  assign overflow = \<const0> ;
  assign prog_empty = \<const0> ;
  assign rd_data_count[4] = \<const0> ;
  assign rd_data_count[3] = \<const0> ;
  assign rd_data_count[2] = \<const0> ;
  assign rd_data_count[1] = \<const0> ;
  assign rd_data_count[0] = \<const0> ;
  assign rd_rst_busy = wr_rst_busy;
  assign s_axi_arready = \<const0> ;
  assign s_axi_awready = \<const0> ;
  assign s_axi_bid[0] = \<const0> ;
  assign s_axi_bresp[1] = \<const0> ;
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_buser[0] = \<const0> ;
  assign s_axi_bvalid = \<const0> ;
  assign s_axi_rdata[63] = \<const0> ;
  assign s_axi_rdata[62] = \<const0> ;
  assign s_axi_rdata[61] = \<const0> ;
  assign s_axi_rdata[60] = \<const0> ;
  assign s_axi_rdata[59] = \<const0> ;
  assign s_axi_rdata[58] = \<const0> ;
  assign s_axi_rdata[57] = \<const0> ;
  assign s_axi_rdata[56] = \<const0> ;
  assign s_axi_rdata[55] = \<const0> ;
  assign s_axi_rdata[54] = \<const0> ;
  assign s_axi_rdata[53] = \<const0> ;
  assign s_axi_rdata[52] = \<const0> ;
  assign s_axi_rdata[51] = \<const0> ;
  assign s_axi_rdata[50] = \<const0> ;
  assign s_axi_rdata[49] = \<const0> ;
  assign s_axi_rdata[48] = \<const0> ;
  assign s_axi_rdata[47] = \<const0> ;
  assign s_axi_rdata[46] = \<const0> ;
  assign s_axi_rdata[45] = \<const0> ;
  assign s_axi_rdata[44] = \<const0> ;
  assign s_axi_rdata[43] = \<const0> ;
  assign s_axi_rdata[42] = \<const0> ;
  assign s_axi_rdata[41] = \<const0> ;
  assign s_axi_rdata[40] = \<const0> ;
  assign s_axi_rdata[39] = \<const0> ;
  assign s_axi_rdata[38] = \<const0> ;
  assign s_axi_rdata[37] = \<const0> ;
  assign s_axi_rdata[36] = \<const0> ;
  assign s_axi_rdata[35] = \<const0> ;
  assign s_axi_rdata[34] = \<const0> ;
  assign s_axi_rdata[33] = \<const0> ;
  assign s_axi_rdata[32] = \<const0> ;
  assign s_axi_rdata[31] = \<const0> ;
  assign s_axi_rdata[30] = \<const0> ;
  assign s_axi_rdata[29] = \<const0> ;
  assign s_axi_rdata[28] = \<const0> ;
  assign s_axi_rdata[27] = \<const0> ;
  assign s_axi_rdata[26] = \<const0> ;
  assign s_axi_rdata[25] = \<const0> ;
  assign s_axi_rdata[24] = \<const0> ;
  assign s_axi_rdata[23] = \<const0> ;
  assign s_axi_rdata[22] = \<const0> ;
  assign s_axi_rdata[21] = \<const0> ;
  assign s_axi_rdata[20] = \<const0> ;
  assign s_axi_rdata[19] = \<const0> ;
  assign s_axi_rdata[18] = \<const0> ;
  assign s_axi_rdata[17] = \<const0> ;
  assign s_axi_rdata[16] = \<const0> ;
  assign s_axi_rdata[15] = \<const0> ;
  assign s_axi_rdata[14] = \<const0> ;
  assign s_axi_rdata[13] = \<const0> ;
  assign s_axi_rdata[12] = \<const0> ;
  assign s_axi_rdata[11] = \<const0> ;
  assign s_axi_rdata[10] = \<const0> ;
  assign s_axi_rdata[9] = \<const0> ;
  assign s_axi_rdata[8] = \<const0> ;
  assign s_axi_rdata[7] = \<const0> ;
  assign s_axi_rdata[6] = \<const0> ;
  assign s_axi_rdata[5] = \<const0> ;
  assign s_axi_rdata[4] = \<const0> ;
  assign s_axi_rdata[3] = \<const0> ;
  assign s_axi_rdata[2] = \<const0> ;
  assign s_axi_rdata[1] = \<const0> ;
  assign s_axi_rdata[0] = \<const0> ;
  assign s_axi_rid[0] = \<const0> ;
  assign s_axi_rlast = \<const0> ;
  assign s_axi_rresp[1] = \<const0> ;
  assign s_axi_rresp[0] = \<const0> ;
  assign s_axi_ruser[0] = \<const0> ;
  assign s_axi_rvalid = \<const0> ;
  assign s_axi_wready = \<const0> ;
  assign s_axis_tready = \<const0> ;
  assign sbiterr = \<const0> ;
  assign underflow = \<const0> ;
  assign valid = \<const0> ;
  assign wr_ack = \<const0> ;
  assign wr_data_count[4] = \<const0> ;
  assign wr_data_count[3] = \<const0> ;
  assign wr_data_count[2] = \<const0> ;
  assign wr_data_count[1] = \<const0> ;
  assign wr_data_count[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  nvme_data_cmd_fifo_fifo_generator_v13_2_5_synth inst_fifo_gen
       (.clk(clk),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .prog_full(prog_full),
        .rd_en(rd_en),
        .rst(rst),
        .wr_en(wr_en),
        .wr_rst_busy(wr_rst_busy));
endmodule

(* ORIG_REF_NAME = "fifo_generator_v13_2_5_synth" *) 
module nvme_data_cmd_fifo_fifo_generator_v13_2_5_synth
   (full,
    empty,
    wr_rst_busy,
    dout,
    prog_full,
    rst,
    clk,
    din,
    wr_en,
    rd_en);
  output full;
  output empty;
  output wr_rst_busy;
  output [127:0]dout;
  output prog_full;
  input rst;
  input clk;
  input [127:0]din;
  input wr_en;
  input rd_en;

  wire clk;
  wire [127:0]din;
  wire [127:0]dout;
  wire empty;
  wire full;
  wire prog_full;
  wire rd_en;
  wire rst;
  wire wr_en;
  wire wr_rst_busy;

  nvme_data_cmd_fifo_fifo_generator_top \gconvfifo.rf 
       (.clk(clk),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .prog_full(prog_full),
        .rd_en(rd_en),
        .rst(rst),
        .wr_en(wr_en),
        .wr_rst_busy(wr_rst_busy));
endmodule

(* ORIG_REF_NAME = "logic_sshft" *) 
module nvme_data_cmd_fifo_logic_sshft
   (full,
    empty,
    ram_rd_en,
    ram_wr_en,
    prog_full,
    Q,
    clk,
    out,
    AR,
    ram_full_i_reg,
    wr_en,
    rd_en);
  output full;
  output empty;
  output ram_rd_en;
  output ram_wr_en;
  output prog_full;
  output [4:0]Q;
  input clk;
  input out;
  input [0:0]AR;
  input ram_full_i_reg;
  input wr_en;
  input rd_en;

  wire [0:0]AR;
  wire [4:0]Q;
  wire clk;
  wire comp0;
  wire comp1;
  wire empty;
  wire full;
  wire out;
  wire [4:0]pntr_d1;
  wire pntr_d11__0;
  wire prog_full;
  wire ram_empty_comb;
  wire ram_empty_fb;
  wire ram_full_i_reg;
  wire ram_rd_en;
  wire ram_wr_en;
  wire rd_en;
  wire sel;
  wire wr_en;

  nvme_data_cmd_fifo_updn_cntr__parameterized0 c0
       (.AR(AR),
        .D(pntr_d1),
        .E(sel),
        .clk(clk),
        .comp0(comp0),
        .\count_reg[1]_0 (ram_rd_en),
        .out(ram_empty_fb),
        .pntr_d11__0(pntr_d11__0),
        .ram_empty_comb(ram_empty_comb),
        .ram_empty_fb_i_reg(ram_wr_en));
  nvme_data_cmd_fifo_updn_cntr__parameterized1 c1
       (.AR(AR),
        .E(sel),
        .clk(clk),
        .comp1(comp1),
        .\count_reg[1]_0 (ram_rd_en));
  nvme_data_cmd_fifo_updn_cntr crd
       (.AR(AR),
        .E(sel),
        .Q(Q),
        .clk(clk),
        .\count_reg[1]_0 (ram_rd_en));
  nvme_data_cmd_fifo_wr_pf_sshft \gpf.wrpf 
       (.AR(AR),
        .D(pntr_d1),
        .clk(clk),
        .\gpf1.prog_full_i_reg_0 (ram_full_i_reg),
        .\greg.ram_rd_en_i_reg_0 (ram_rd_en),
        .\greg.ram_wr_en_i_reg_0 (ram_wr_en),
        .out(out),
        .prog_full(prog_full));
  nvme_data_cmd_fifo_rd_status_flags_sshft rsts
       (.AR(AR),
        .clk(clk),
        .empty(empty),
        .out(ram_empty_fb),
        .ram_empty_comb(ram_empty_comb),
        .rd_en(rd_en),
        .rd_en_0(ram_rd_en));
  nvme_data_cmd_fifo_wr_status_flags_sshft wsts
       (.E(sel),
        .clk(clk),
        .comp0(comp0),
        .comp1(comp1),
        .\count_reg[4] (ram_rd_en),
        .full(full),
        .out(out),
        .pntr_d11__0(pntr_d11__0),
        .ram_full_i_reg_0(ram_full_i_reg),
        .wr_en(wr_en),
        .wr_en_0(ram_wr_en));
endmodule

(* ORIG_REF_NAME = "memory" *) 
module nvme_data_cmd_fifo_memory
   (dout,
    Q,
    ram_wr_en,
    din,
    clk,
    E,
    AR);
  output [127:0]dout;
  input [4:0]Q;
  input ram_wr_en;
  input [127:0]din;
  input clk;
  input [0:0]E;
  input [0:0]AR;

  wire [0:0]AR;
  wire [0:0]E;
  wire [4:0]Q;
  wire clk;
  wire [127:0]din;
  wire [127:0]dout;
  wire ram_wr_en;

  nvme_data_cmd_fifo_shft_ram \gsm.sm 
       (.AR(AR),
        .E(E),
        .Q(Q),
        .clk(clk),
        .din(din),
        .dout(dout),
        .ram_wr_en(ram_wr_en));
endmodule

(* ORIG_REF_NAME = "rd_status_flags_sshft" *) 
module nvme_data_cmd_fifo_rd_status_flags_sshft
   (out,
    empty,
    rd_en_0,
    ram_empty_comb,
    clk,
    AR,
    rd_en);
  output out;
  output empty;
  output rd_en_0;
  input ram_empty_comb;
  input clk;
  input [0:0]AR;
  input rd_en;

  wire [0:0]AR;
  wire clk;
  wire ram_empty_comb;
  (* DONT_TOUCH *) wire ram_empty_fb_i;
  (* DONT_TOUCH *) wire ram_empty_i;
  wire rd_en;
  wire rd_en_0;

  assign empty = ram_empty_i;
  assign out = ram_empty_fb_i;
  LUT2 #(
    .INIT(4'h2)) 
    \dout_i[127]_i_1 
       (.I0(rd_en),
        .I1(ram_empty_fb_i),
        .O(rd_en_0));
  (* DONT_TOUCH *) 
  (* KEEP = "yes" *) 
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_empty_fb_i_reg
       (.C(clk),
        .CE(1'b1),
        .D(ram_empty_comb),
        .PRE(AR),
        .Q(ram_empty_fb_i));
  (* DONT_TOUCH *) 
  (* KEEP = "yes" *) 
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_empty_i_reg
       (.C(clk),
        .CE(1'b1),
        .D(ram_empty_comb),
        .PRE(AR),
        .Q(ram_empty_i));
endmodule

(* ORIG_REF_NAME = "reset_blk_ramfifo" *) 
module nvme_data_cmd_fifo_reset_blk_ramfifo
   (out,
    \grstd1.grst_full.grst_f.rst_d3_reg_0 ,
    wr_rst_busy,
    AR,
    rst,
    clk);
  output out;
  output \grstd1.grst_full.grst_f.rst_d3_reg_0 ;
  output wr_rst_busy;
  output [0:0]AR;
  input rst;
  input clk;

  wire [0:0]AR;
  wire clk;
  wire \ngwrdrst.grst.g7serrst.gnsckt_wrst.gcc_rst.sckt_wr_rst_cc_reg_n_0_[3] ;
  wire [3:1]p_0_in;
  (* DONT_TOUCH *) wire [2:0]rd_rst_reg;
  wire rst;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_d1;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_d2;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_d3;
  wire rst_d30;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_d4;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_d5;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_d6;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_d7;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_rd_reg1;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_rd_reg2;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_wr_reg1;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_wr_reg2;
  wire wr_rst_busy;
  (* DONT_TOUCH *) wire [2:0]wr_rst_reg;

  assign \grstd1.grst_full.grst_f.rst_d3_reg_0  = rst_d3;
  assign out = rst_d2;
  LUT3 #(
    .INIT(8'hFE)) 
    \dout_i[127]_i_3 
       (.I0(p_0_in[2]),
        .I1(p_0_in[1]),
        .I2(rst_wr_reg2),
        .O(AR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d1_reg 
       (.C(clk),
        .CE(1'b1),
        .D(wr_rst_busy),
        .PRE(rst_wr_reg2),
        .Q(rst_d1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d2_reg 
       (.C(clk),
        .CE(1'b1),
        .D(rst_d1),
        .PRE(rst_wr_reg2),
        .Q(rst_d2));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \grstd1.grst_full.grst_f.rst_d3_i_1 
       (.I0(p_0_in[2]),
        .I1(p_0_in[1]),
        .I2(rst_wr_reg2),
        .I3(rst_d2),
        .O(rst_d30));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d3_reg 
       (.C(clk),
        .CE(1'b1),
        .D(rst_d30),
        .PRE(rst_wr_reg2),
        .Q(rst_d3));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d4_reg 
       (.C(clk),
        .CE(1'b1),
        .D(rst_d3),
        .PRE(rst_wr_reg2),
        .Q(rst_d4));
  LUT1 #(
    .INIT(2'h2)) 
    i_0
       (.I0(1'b1),
        .O(wr_rst_reg[2]));
  LUT1 #(
    .INIT(2'h2)) 
    i_1
       (.I0(1'b1),
        .O(wr_rst_reg[1]));
  LUT1 #(
    .INIT(2'h2)) 
    i_10
       (.I0(1'b1),
        .O(rst_d6));
  LUT1 #(
    .INIT(2'h2)) 
    i_11
       (.I0(1'b1),
        .O(rst_d7));
  LUT1 #(
    .INIT(2'h2)) 
    i_2
       (.I0(1'b1),
        .O(wr_rst_reg[0]));
  LUT1 #(
    .INIT(2'h2)) 
    i_3
       (.I0(1'b1),
        .O(rd_rst_reg[2]));
  LUT1 #(
    .INIT(2'h2)) 
    i_4
       (.I0(1'b1),
        .O(rd_rst_reg[1]));
  LUT1 #(
    .INIT(2'h2)) 
    i_5
       (.I0(1'b1),
        .O(rd_rst_reg[0]));
  LUT1 #(
    .INIT(2'h2)) 
    i_6
       (.I0(1'b0),
        .O(rst_wr_reg1));
  LUT1 #(
    .INIT(2'h2)) 
    i_7
       (.I0(1'b0),
        .O(rst_rd_reg1));
  LUT1 #(
    .INIT(2'h2)) 
    i_8
       (.I0(1'b0),
        .O(rst_rd_reg2));
  LUT1 #(
    .INIT(2'h2)) 
    i_9
       (.I0(1'b1),
        .O(rst_d5));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.gnsckt_wrst.gcc_rst.sckt_wr_rst_cc_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(rst_wr_reg2),
        .Q(p_0_in[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.gnsckt_wrst.gcc_rst.sckt_wr_rst_cc_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(p_0_in[1]),
        .Q(p_0_in[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.gnsckt_wrst.gcc_rst.sckt_wr_rst_cc_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(p_0_in[2]),
        .Q(p_0_in[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.gnsckt_wrst.gcc_rst.sckt_wr_rst_cc_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(p_0_in[3]),
        .Q(\ngwrdrst.grst.g7serrst.gnsckt_wrst.gcc_rst.sckt_wr_rst_cc_reg_n_0_[3] ),
        .R(1'b0));
  (* DEF_VAL = "1'b0" *) 
  (* DEST_SYNC_FF = "2" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* INV_DEF_VAL = "1'b1" *) 
  (* RST_ACTIVE_HIGH = "1" *) 
  (* VERSION = "0" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  (* XPM_MODULE = "TRUE" *) 
  nvme_data_cmd_fifo_xpm_cdc_async_rst \ngwrdrst.grst.g7serrst.gnsckt_wrst.rst_wr_reg2_inst 
       (.dest_arst(rst_wr_reg2),
        .dest_clk(clk),
        .src_arst(rst));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    rd_rst_busy_INST_0
       (.I0(p_0_in[3]),
        .I1(\ngwrdrst.grst.g7serrst.gnsckt_wrst.gcc_rst.sckt_wr_rst_cc_reg_n_0_[3] ),
        .I2(p_0_in[1]),
        .I3(p_0_in[2]),
        .I4(rst_wr_reg2),
        .O(wr_rst_busy));
endmodule

(* ORIG_REF_NAME = "shft_ram" *) 
module nvme_data_cmd_fifo_shft_ram
   (dout,
    Q,
    ram_wr_en,
    din,
    clk,
    E,
    AR);
  output [127:0]dout;
  input [4:0]Q;
  input ram_wr_en;
  input [127:0]din;
  input clk;
  input [0:0]E;
  input [0:0]AR;

  wire [0:0]AR;
  wire [0:0]E;
  wire [4:0]Q;
  wire clk;
  wire [127:0]din;
  wire [127:0]dout;
  wire [127:0]\dout_2d[0]_0 ;
  wire [127:0]dout_mem;
  wire ram_wr_en;
  wire [127:0]shft_connect;

  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[0] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[0]),
        .Q(dout[0]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[100] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[100]),
        .Q(dout[100]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[101] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[101]),
        .Q(dout[101]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[102] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[102]),
        .Q(dout[102]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[103] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[103]),
        .Q(dout[103]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[104] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[104]),
        .Q(dout[104]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[105] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[105]),
        .Q(dout[105]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[106] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[106]),
        .Q(dout[106]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[107] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[107]),
        .Q(dout[107]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[108] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[108]),
        .Q(dout[108]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[109] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[109]),
        .Q(dout[109]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[10] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[10]),
        .Q(dout[10]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[110] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[110]),
        .Q(dout[110]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[111] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[111]),
        .Q(dout[111]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[112] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[112]),
        .Q(dout[112]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[113] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[113]),
        .Q(dout[113]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[114] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[114]),
        .Q(dout[114]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[115] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[115]),
        .Q(dout[115]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[116] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[116]),
        .Q(dout[116]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[117] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[117]),
        .Q(dout[117]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[118] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[118]),
        .Q(dout[118]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[119] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[119]),
        .Q(dout[119]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[11] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[11]),
        .Q(dout[11]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[120] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[120]),
        .Q(dout[120]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[121] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[121]),
        .Q(dout[121]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[122] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[122]),
        .Q(dout[122]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[123] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[123]),
        .Q(dout[123]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[124] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[124]),
        .Q(dout[124]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[125] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[125]),
        .Q(dout[125]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[126] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[126]),
        .Q(dout[126]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[127] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[127]),
        .Q(dout[127]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[12] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[12]),
        .Q(dout[12]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[13] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[13]),
        .Q(dout[13]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[14] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[14]),
        .Q(dout[14]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[15] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[15]),
        .Q(dout[15]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[16] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[16]),
        .Q(dout[16]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[17] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[17]),
        .Q(dout[17]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[18] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[18]),
        .Q(dout[18]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[19] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[19]),
        .Q(dout[19]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[1] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[1]),
        .Q(dout[1]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[20] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[20]),
        .Q(dout[20]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[21] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[21]),
        .Q(dout[21]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[22] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[22]),
        .Q(dout[22]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[23] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[23]),
        .Q(dout[23]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[24] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[24]),
        .Q(dout[24]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[25] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[25]),
        .Q(dout[25]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[26] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[26]),
        .Q(dout[26]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[27] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[27]),
        .Q(dout[27]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[28] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[28]),
        .Q(dout[28]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[29] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[29]),
        .Q(dout[29]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[2] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[2]),
        .Q(dout[2]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[30] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[30]),
        .Q(dout[30]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[31] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[31]),
        .Q(dout[31]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[32] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[32]),
        .Q(dout[32]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[33] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[33]),
        .Q(dout[33]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[34] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[34]),
        .Q(dout[34]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[35] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[35]),
        .Q(dout[35]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[36] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[36]),
        .Q(dout[36]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[37] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[37]),
        .Q(dout[37]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[38] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[38]),
        .Q(dout[38]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[39] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[39]),
        .Q(dout[39]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[3] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[3]),
        .Q(dout[3]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[40] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[40]),
        .Q(dout[40]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[41] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[41]),
        .Q(dout[41]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[42] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[42]),
        .Q(dout[42]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[43] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[43]),
        .Q(dout[43]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[44] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[44]),
        .Q(dout[44]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[45] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[45]),
        .Q(dout[45]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[46] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[46]),
        .Q(dout[46]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[47] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[47]),
        .Q(dout[47]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[48] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[48]),
        .Q(dout[48]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[49] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[49]),
        .Q(dout[49]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[4] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[4]),
        .Q(dout[4]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[50] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[50]),
        .Q(dout[50]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[51] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[51]),
        .Q(dout[51]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[52] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[52]),
        .Q(dout[52]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[53] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[53]),
        .Q(dout[53]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[54] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[54]),
        .Q(dout[54]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[55] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[55]),
        .Q(dout[55]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[56] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[56]),
        .Q(dout[56]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[57] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[57]),
        .Q(dout[57]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[58] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[58]),
        .Q(dout[58]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[59] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[59]),
        .Q(dout[59]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[5] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[5]),
        .Q(dout[5]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[60] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[60]),
        .Q(dout[60]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[61] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[61]),
        .Q(dout[61]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[62] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[62]),
        .Q(dout[62]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[63] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[63]),
        .Q(dout[63]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[64] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[64]),
        .Q(dout[64]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[65] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[65]),
        .Q(dout[65]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[66] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[66]),
        .Q(dout[66]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[67] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[67]),
        .Q(dout[67]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[68] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[68]),
        .Q(dout[68]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[69] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[69]),
        .Q(dout[69]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[6] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[6]),
        .Q(dout[6]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[70] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[70]),
        .Q(dout[70]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[71] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[71]),
        .Q(dout[71]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[72] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[72]),
        .Q(dout[72]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[73] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[73]),
        .Q(dout[73]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[74] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[74]),
        .Q(dout[74]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[75] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[75]),
        .Q(dout[75]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[76] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[76]),
        .Q(dout[76]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[77] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[77]),
        .Q(dout[77]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[78] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[78]),
        .Q(dout[78]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[79] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[79]),
        .Q(dout[79]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[7] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[7]),
        .Q(dout[7]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[80] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[80]),
        .Q(dout[80]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[81] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[81]),
        .Q(dout[81]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[82] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[82]),
        .Q(dout[82]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[83] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[83]),
        .Q(dout[83]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[84] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[84]),
        .Q(dout[84]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[85] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[85]),
        .Q(dout[85]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[86] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[86]),
        .Q(dout[86]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[87] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[87]),
        .Q(dout[87]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[88] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[88]),
        .Q(dout[88]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[89] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[89]),
        .Q(dout[89]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[8] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[8]),
        .Q(dout[8]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[90] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[90]),
        .Q(dout[90]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[91] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[91]),
        .Q(dout[91]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[92] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[92]),
        .Q(dout[92]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[93] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[93]),
        .Q(dout[93]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[94] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[94]),
        .Q(dout[94]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[95] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[95]),
        .Q(dout[95]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[96] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[96]),
        .Q(dout[96]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[97] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[97]),
        .Q(dout[97]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[98] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[98]),
        .Q(dout[98]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[99] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[99]),
        .Q(dout[99]));
  FDCE #(
    .INIT(1'b0)) 
    \dout_i_reg[9] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(dout_mem[9]),
        .Q(dout[9]));
  nvme_data_cmd_fifo_shft_wrapper \gsms.gsms[1].sms 
       (.D(dout_mem),
        .DOUT(\dout_2d[0]_0 ),
        .DOUT_END(shft_connect),
        .Q(Q),
        .clk(clk),
        .ram_wr_en(ram_wr_en));
  nvme_data_cmd_fifo_shft_wrapper_0 \gsms.sm1 
       (.DOUT(\dout_2d[0]_0 ),
        .DOUT_END(shft_connect),
        .Q(Q[3:0]),
        .clk(clk),
        .din(din),
        .ram_wr_en(ram_wr_en));
endmodule

(* ORIG_REF_NAME = "shft_wrapper" *) 
module nvme_data_cmd_fifo_shft_wrapper
   (D,
    Q,
    DOUT,
    ram_wr_en,
    DOUT_END,
    clk);
  output [127:0]D;
  input [4:0]Q;
  input [127:0]DOUT;
  input ram_wr_en;
  input [127:0]DOUT_END;
  input clk;

  wire [127:0]D;
  wire [127:0]DOUT;
  wire [127:0]DOUT_END;
  wire [4:0]Q;
  wire clk;
  wire [127:0]\dout_2d[1]_1 ;
  wire \gram.gsms[0].gv4.srl16_n_1 ;
  wire \gram.gsms[100].gv4.srl16_n_1 ;
  wire \gram.gsms[101].gv4.srl16_n_1 ;
  wire \gram.gsms[102].gv4.srl16_n_1 ;
  wire \gram.gsms[103].gv4.srl16_n_1 ;
  wire \gram.gsms[104].gv4.srl16_n_1 ;
  wire \gram.gsms[105].gv4.srl16_n_1 ;
  wire \gram.gsms[106].gv4.srl16_n_1 ;
  wire \gram.gsms[107].gv4.srl16_n_1 ;
  wire \gram.gsms[108].gv4.srl16_n_1 ;
  wire \gram.gsms[109].gv4.srl16_n_1 ;
  wire \gram.gsms[10].gv4.srl16_n_1 ;
  wire \gram.gsms[110].gv4.srl16_n_1 ;
  wire \gram.gsms[111].gv4.srl16_n_1 ;
  wire \gram.gsms[112].gv4.srl16_n_1 ;
  wire \gram.gsms[113].gv4.srl16_n_1 ;
  wire \gram.gsms[114].gv4.srl16_n_1 ;
  wire \gram.gsms[115].gv4.srl16_n_1 ;
  wire \gram.gsms[116].gv4.srl16_n_1 ;
  wire \gram.gsms[117].gv4.srl16_n_1 ;
  wire \gram.gsms[118].gv4.srl16_n_1 ;
  wire \gram.gsms[119].gv4.srl16_n_1 ;
  wire \gram.gsms[11].gv4.srl16_n_1 ;
  wire \gram.gsms[120].gv4.srl16_n_1 ;
  wire \gram.gsms[121].gv4.srl16_n_1 ;
  wire \gram.gsms[122].gv4.srl16_n_1 ;
  wire \gram.gsms[123].gv4.srl16_n_1 ;
  wire \gram.gsms[124].gv4.srl16_n_1 ;
  wire \gram.gsms[125].gv4.srl16_n_1 ;
  wire \gram.gsms[126].gv4.srl16_n_1 ;
  wire \gram.gsms[127].gv4.srl16_n_1 ;
  wire \gram.gsms[12].gv4.srl16_n_1 ;
  wire \gram.gsms[13].gv4.srl16_n_1 ;
  wire \gram.gsms[14].gv4.srl16_n_1 ;
  wire \gram.gsms[15].gv4.srl16_n_1 ;
  wire \gram.gsms[16].gv4.srl16_n_1 ;
  wire \gram.gsms[17].gv4.srl16_n_1 ;
  wire \gram.gsms[18].gv4.srl16_n_1 ;
  wire \gram.gsms[19].gv4.srl16_n_1 ;
  wire \gram.gsms[1].gv4.srl16_n_1 ;
  wire \gram.gsms[20].gv4.srl16_n_1 ;
  wire \gram.gsms[21].gv4.srl16_n_1 ;
  wire \gram.gsms[22].gv4.srl16_n_1 ;
  wire \gram.gsms[23].gv4.srl16_n_1 ;
  wire \gram.gsms[24].gv4.srl16_n_1 ;
  wire \gram.gsms[25].gv4.srl16_n_1 ;
  wire \gram.gsms[26].gv4.srl16_n_1 ;
  wire \gram.gsms[27].gv4.srl16_n_1 ;
  wire \gram.gsms[28].gv4.srl16_n_1 ;
  wire \gram.gsms[29].gv4.srl16_n_1 ;
  wire \gram.gsms[2].gv4.srl16_n_1 ;
  wire \gram.gsms[30].gv4.srl16_n_1 ;
  wire \gram.gsms[31].gv4.srl16_n_1 ;
  wire \gram.gsms[32].gv4.srl16_n_1 ;
  wire \gram.gsms[33].gv4.srl16_n_1 ;
  wire \gram.gsms[34].gv4.srl16_n_1 ;
  wire \gram.gsms[35].gv4.srl16_n_1 ;
  wire \gram.gsms[36].gv4.srl16_n_1 ;
  wire \gram.gsms[37].gv4.srl16_n_1 ;
  wire \gram.gsms[38].gv4.srl16_n_1 ;
  wire \gram.gsms[39].gv4.srl16_n_1 ;
  wire \gram.gsms[3].gv4.srl16_n_1 ;
  wire \gram.gsms[40].gv4.srl16_n_1 ;
  wire \gram.gsms[41].gv4.srl16_n_1 ;
  wire \gram.gsms[42].gv4.srl16_n_1 ;
  wire \gram.gsms[43].gv4.srl16_n_1 ;
  wire \gram.gsms[44].gv4.srl16_n_1 ;
  wire \gram.gsms[45].gv4.srl16_n_1 ;
  wire \gram.gsms[46].gv4.srl16_n_1 ;
  wire \gram.gsms[47].gv4.srl16_n_1 ;
  wire \gram.gsms[48].gv4.srl16_n_1 ;
  wire \gram.gsms[49].gv4.srl16_n_1 ;
  wire \gram.gsms[4].gv4.srl16_n_1 ;
  wire \gram.gsms[50].gv4.srl16_n_1 ;
  wire \gram.gsms[51].gv4.srl16_n_1 ;
  wire \gram.gsms[52].gv4.srl16_n_1 ;
  wire \gram.gsms[53].gv4.srl16_n_1 ;
  wire \gram.gsms[54].gv4.srl16_n_1 ;
  wire \gram.gsms[55].gv4.srl16_n_1 ;
  wire \gram.gsms[56].gv4.srl16_n_1 ;
  wire \gram.gsms[57].gv4.srl16_n_1 ;
  wire \gram.gsms[58].gv4.srl16_n_1 ;
  wire \gram.gsms[59].gv4.srl16_n_1 ;
  wire \gram.gsms[5].gv4.srl16_n_1 ;
  wire \gram.gsms[60].gv4.srl16_n_1 ;
  wire \gram.gsms[61].gv4.srl16_n_1 ;
  wire \gram.gsms[62].gv4.srl16_n_1 ;
  wire \gram.gsms[63].gv4.srl16_n_1 ;
  wire \gram.gsms[64].gv4.srl16_n_1 ;
  wire \gram.gsms[65].gv4.srl16_n_1 ;
  wire \gram.gsms[66].gv4.srl16_n_1 ;
  wire \gram.gsms[67].gv4.srl16_n_1 ;
  wire \gram.gsms[68].gv4.srl16_n_1 ;
  wire \gram.gsms[69].gv4.srl16_n_1 ;
  wire \gram.gsms[6].gv4.srl16_n_1 ;
  wire \gram.gsms[70].gv4.srl16_n_1 ;
  wire \gram.gsms[71].gv4.srl16_n_1 ;
  wire \gram.gsms[72].gv4.srl16_n_1 ;
  wire \gram.gsms[73].gv4.srl16_n_1 ;
  wire \gram.gsms[74].gv4.srl16_n_1 ;
  wire \gram.gsms[75].gv4.srl16_n_1 ;
  wire \gram.gsms[76].gv4.srl16_n_1 ;
  wire \gram.gsms[77].gv4.srl16_n_1 ;
  wire \gram.gsms[78].gv4.srl16_n_1 ;
  wire \gram.gsms[79].gv4.srl16_n_1 ;
  wire \gram.gsms[7].gv4.srl16_n_1 ;
  wire \gram.gsms[80].gv4.srl16_n_1 ;
  wire \gram.gsms[81].gv4.srl16_n_1 ;
  wire \gram.gsms[82].gv4.srl16_n_1 ;
  wire \gram.gsms[83].gv4.srl16_n_1 ;
  wire \gram.gsms[84].gv4.srl16_n_1 ;
  wire \gram.gsms[85].gv4.srl16_n_1 ;
  wire \gram.gsms[86].gv4.srl16_n_1 ;
  wire \gram.gsms[87].gv4.srl16_n_1 ;
  wire \gram.gsms[88].gv4.srl16_n_1 ;
  wire \gram.gsms[89].gv4.srl16_n_1 ;
  wire \gram.gsms[8].gv4.srl16_n_1 ;
  wire \gram.gsms[90].gv4.srl16_n_1 ;
  wire \gram.gsms[91].gv4.srl16_n_1 ;
  wire \gram.gsms[92].gv4.srl16_n_1 ;
  wire \gram.gsms[93].gv4.srl16_n_1 ;
  wire \gram.gsms[94].gv4.srl16_n_1 ;
  wire \gram.gsms[95].gv4.srl16_n_1 ;
  wire \gram.gsms[96].gv4.srl16_n_1 ;
  wire \gram.gsms[97].gv4.srl16_n_1 ;
  wire \gram.gsms[98].gv4.srl16_n_1 ;
  wire \gram.gsms[99].gv4.srl16_n_1 ;
  wire \gram.gsms[9].gv4.srl16_n_1 ;
  wire ram_wr_en;

  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[0]_i_1 
       (.I0(\dout_2d[1]_1 [0]),
        .I1(Q[4]),
        .I2(DOUT[0]),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[100]_i_1 
       (.I0(\dout_2d[1]_1 [100]),
        .I1(Q[4]),
        .I2(DOUT[100]),
        .O(D[100]));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[101]_i_1 
       (.I0(\dout_2d[1]_1 [101]),
        .I1(Q[4]),
        .I2(DOUT[101]),
        .O(D[101]));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[102]_i_1 
       (.I0(\dout_2d[1]_1 [102]),
        .I1(Q[4]),
        .I2(DOUT[102]),
        .O(D[102]));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[103]_i_1 
       (.I0(\dout_2d[1]_1 [103]),
        .I1(Q[4]),
        .I2(DOUT[103]),
        .O(D[103]));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[104]_i_1 
       (.I0(\dout_2d[1]_1 [104]),
        .I1(Q[4]),
        .I2(DOUT[104]),
        .O(D[104]));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[105]_i_1 
       (.I0(\dout_2d[1]_1 [105]),
        .I1(Q[4]),
        .I2(DOUT[105]),
        .O(D[105]));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[106]_i_1 
       (.I0(\dout_2d[1]_1 [106]),
        .I1(Q[4]),
        .I2(DOUT[106]),
        .O(D[106]));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[107]_i_1 
       (.I0(\dout_2d[1]_1 [107]),
        .I1(Q[4]),
        .I2(DOUT[107]),
        .O(D[107]));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[108]_i_1 
       (.I0(\dout_2d[1]_1 [108]),
        .I1(Q[4]),
        .I2(DOUT[108]),
        .O(D[108]));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[109]_i_1 
       (.I0(\dout_2d[1]_1 [109]),
        .I1(Q[4]),
        .I2(DOUT[109]),
        .O(D[109]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[10]_i_1 
       (.I0(\dout_2d[1]_1 [10]),
        .I1(Q[4]),
        .I2(DOUT[10]),
        .O(D[10]));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[110]_i_1 
       (.I0(\dout_2d[1]_1 [110]),
        .I1(Q[4]),
        .I2(DOUT[110]),
        .O(D[110]));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[111]_i_1 
       (.I0(\dout_2d[1]_1 [111]),
        .I1(Q[4]),
        .I2(DOUT[111]),
        .O(D[111]));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[112]_i_1 
       (.I0(\dout_2d[1]_1 [112]),
        .I1(Q[4]),
        .I2(DOUT[112]),
        .O(D[112]));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[113]_i_1 
       (.I0(\dout_2d[1]_1 [113]),
        .I1(Q[4]),
        .I2(DOUT[113]),
        .O(D[113]));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[114]_i_1 
       (.I0(\dout_2d[1]_1 [114]),
        .I1(Q[4]),
        .I2(DOUT[114]),
        .O(D[114]));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[115]_i_1 
       (.I0(\dout_2d[1]_1 [115]),
        .I1(Q[4]),
        .I2(DOUT[115]),
        .O(D[115]));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[116]_i_1 
       (.I0(\dout_2d[1]_1 [116]),
        .I1(Q[4]),
        .I2(DOUT[116]),
        .O(D[116]));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[117]_i_1 
       (.I0(\dout_2d[1]_1 [117]),
        .I1(Q[4]),
        .I2(DOUT[117]),
        .O(D[117]));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[118]_i_1 
       (.I0(\dout_2d[1]_1 [118]),
        .I1(Q[4]),
        .I2(DOUT[118]),
        .O(D[118]));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[119]_i_1 
       (.I0(\dout_2d[1]_1 [119]),
        .I1(Q[4]),
        .I2(DOUT[119]),
        .O(D[119]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[11]_i_1 
       (.I0(\dout_2d[1]_1 [11]),
        .I1(Q[4]),
        .I2(DOUT[11]),
        .O(D[11]));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[120]_i_1 
       (.I0(\dout_2d[1]_1 [120]),
        .I1(Q[4]),
        .I2(DOUT[120]),
        .O(D[120]));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[121]_i_1 
       (.I0(\dout_2d[1]_1 [121]),
        .I1(Q[4]),
        .I2(DOUT[121]),
        .O(D[121]));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[122]_i_1 
       (.I0(\dout_2d[1]_1 [122]),
        .I1(Q[4]),
        .I2(DOUT[122]),
        .O(D[122]));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[123]_i_1 
       (.I0(\dout_2d[1]_1 [123]),
        .I1(Q[4]),
        .I2(DOUT[123]),
        .O(D[123]));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[124]_i_1 
       (.I0(\dout_2d[1]_1 [124]),
        .I1(Q[4]),
        .I2(DOUT[124]),
        .O(D[124]));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[125]_i_1 
       (.I0(\dout_2d[1]_1 [125]),
        .I1(Q[4]),
        .I2(DOUT[125]),
        .O(D[125]));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[126]_i_1 
       (.I0(\dout_2d[1]_1 [126]),
        .I1(Q[4]),
        .I2(DOUT[126]),
        .O(D[126]));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[127]_i_2 
       (.I0(\dout_2d[1]_1 [127]),
        .I1(Q[4]),
        .I2(DOUT[127]),
        .O(D[127]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[12]_i_1 
       (.I0(\dout_2d[1]_1 [12]),
        .I1(Q[4]),
        .I2(DOUT[12]),
        .O(D[12]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[13]_i_1 
       (.I0(\dout_2d[1]_1 [13]),
        .I1(Q[4]),
        .I2(DOUT[13]),
        .O(D[13]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[14]_i_1 
       (.I0(\dout_2d[1]_1 [14]),
        .I1(Q[4]),
        .I2(DOUT[14]),
        .O(D[14]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[15]_i_1 
       (.I0(\dout_2d[1]_1 [15]),
        .I1(Q[4]),
        .I2(DOUT[15]),
        .O(D[15]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[16]_i_1 
       (.I0(\dout_2d[1]_1 [16]),
        .I1(Q[4]),
        .I2(DOUT[16]),
        .O(D[16]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[17]_i_1 
       (.I0(\dout_2d[1]_1 [17]),
        .I1(Q[4]),
        .I2(DOUT[17]),
        .O(D[17]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[18]_i_1 
       (.I0(\dout_2d[1]_1 [18]),
        .I1(Q[4]),
        .I2(DOUT[18]),
        .O(D[18]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[19]_i_1 
       (.I0(\dout_2d[1]_1 [19]),
        .I1(Q[4]),
        .I2(DOUT[19]),
        .O(D[19]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[1]_i_1 
       (.I0(\dout_2d[1]_1 [1]),
        .I1(Q[4]),
        .I2(DOUT[1]),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[20]_i_1 
       (.I0(\dout_2d[1]_1 [20]),
        .I1(Q[4]),
        .I2(DOUT[20]),
        .O(D[20]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[21]_i_1 
       (.I0(\dout_2d[1]_1 [21]),
        .I1(Q[4]),
        .I2(DOUT[21]),
        .O(D[21]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[22]_i_1 
       (.I0(\dout_2d[1]_1 [22]),
        .I1(Q[4]),
        .I2(DOUT[22]),
        .O(D[22]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[23]_i_1 
       (.I0(\dout_2d[1]_1 [23]),
        .I1(Q[4]),
        .I2(DOUT[23]),
        .O(D[23]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[24]_i_1 
       (.I0(\dout_2d[1]_1 [24]),
        .I1(Q[4]),
        .I2(DOUT[24]),
        .O(D[24]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[25]_i_1 
       (.I0(\dout_2d[1]_1 [25]),
        .I1(Q[4]),
        .I2(DOUT[25]),
        .O(D[25]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[26]_i_1 
       (.I0(\dout_2d[1]_1 [26]),
        .I1(Q[4]),
        .I2(DOUT[26]),
        .O(D[26]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[27]_i_1 
       (.I0(\dout_2d[1]_1 [27]),
        .I1(Q[4]),
        .I2(DOUT[27]),
        .O(D[27]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[28]_i_1 
       (.I0(\dout_2d[1]_1 [28]),
        .I1(Q[4]),
        .I2(DOUT[28]),
        .O(D[28]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[29]_i_1 
       (.I0(\dout_2d[1]_1 [29]),
        .I1(Q[4]),
        .I2(DOUT[29]),
        .O(D[29]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[2]_i_1 
       (.I0(\dout_2d[1]_1 [2]),
        .I1(Q[4]),
        .I2(DOUT[2]),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[30]_i_1 
       (.I0(\dout_2d[1]_1 [30]),
        .I1(Q[4]),
        .I2(DOUT[30]),
        .O(D[30]));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[31]_i_1 
       (.I0(\dout_2d[1]_1 [31]),
        .I1(Q[4]),
        .I2(DOUT[31]),
        .O(D[31]));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[32]_i_1 
       (.I0(\dout_2d[1]_1 [32]),
        .I1(Q[4]),
        .I2(DOUT[32]),
        .O(D[32]));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[33]_i_1 
       (.I0(\dout_2d[1]_1 [33]),
        .I1(Q[4]),
        .I2(DOUT[33]),
        .O(D[33]));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[34]_i_1 
       (.I0(\dout_2d[1]_1 [34]),
        .I1(Q[4]),
        .I2(DOUT[34]),
        .O(D[34]));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[35]_i_1 
       (.I0(\dout_2d[1]_1 [35]),
        .I1(Q[4]),
        .I2(DOUT[35]),
        .O(D[35]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[36]_i_1 
       (.I0(\dout_2d[1]_1 [36]),
        .I1(Q[4]),
        .I2(DOUT[36]),
        .O(D[36]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[37]_i_1 
       (.I0(\dout_2d[1]_1 [37]),
        .I1(Q[4]),
        .I2(DOUT[37]),
        .O(D[37]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[38]_i_1 
       (.I0(\dout_2d[1]_1 [38]),
        .I1(Q[4]),
        .I2(DOUT[38]),
        .O(D[38]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[39]_i_1 
       (.I0(\dout_2d[1]_1 [39]),
        .I1(Q[4]),
        .I2(DOUT[39]),
        .O(D[39]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[3]_i_1 
       (.I0(\dout_2d[1]_1 [3]),
        .I1(Q[4]),
        .I2(DOUT[3]),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[40]_i_1 
       (.I0(\dout_2d[1]_1 [40]),
        .I1(Q[4]),
        .I2(DOUT[40]),
        .O(D[40]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[41]_i_1 
       (.I0(\dout_2d[1]_1 [41]),
        .I1(Q[4]),
        .I2(DOUT[41]),
        .O(D[41]));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[42]_i_1 
       (.I0(\dout_2d[1]_1 [42]),
        .I1(Q[4]),
        .I2(DOUT[42]),
        .O(D[42]));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[43]_i_1 
       (.I0(\dout_2d[1]_1 [43]),
        .I1(Q[4]),
        .I2(DOUT[43]),
        .O(D[43]));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[44]_i_1 
       (.I0(\dout_2d[1]_1 [44]),
        .I1(Q[4]),
        .I2(DOUT[44]),
        .O(D[44]));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[45]_i_1 
       (.I0(\dout_2d[1]_1 [45]),
        .I1(Q[4]),
        .I2(DOUT[45]),
        .O(D[45]));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[46]_i_1 
       (.I0(\dout_2d[1]_1 [46]),
        .I1(Q[4]),
        .I2(DOUT[46]),
        .O(D[46]));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[47]_i_1 
       (.I0(\dout_2d[1]_1 [47]),
        .I1(Q[4]),
        .I2(DOUT[47]),
        .O(D[47]));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[48]_i_1 
       (.I0(\dout_2d[1]_1 [48]),
        .I1(Q[4]),
        .I2(DOUT[48]),
        .O(D[48]));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[49]_i_1 
       (.I0(\dout_2d[1]_1 [49]),
        .I1(Q[4]),
        .I2(DOUT[49]),
        .O(D[49]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[4]_i_1 
       (.I0(\dout_2d[1]_1 [4]),
        .I1(Q[4]),
        .I2(DOUT[4]),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[50]_i_1 
       (.I0(\dout_2d[1]_1 [50]),
        .I1(Q[4]),
        .I2(DOUT[50]),
        .O(D[50]));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[51]_i_1 
       (.I0(\dout_2d[1]_1 [51]),
        .I1(Q[4]),
        .I2(DOUT[51]),
        .O(D[51]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[52]_i_1 
       (.I0(\dout_2d[1]_1 [52]),
        .I1(Q[4]),
        .I2(DOUT[52]),
        .O(D[52]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[53]_i_1 
       (.I0(\dout_2d[1]_1 [53]),
        .I1(Q[4]),
        .I2(DOUT[53]),
        .O(D[53]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[54]_i_1 
       (.I0(\dout_2d[1]_1 [54]),
        .I1(Q[4]),
        .I2(DOUT[54]),
        .O(D[54]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[55]_i_1 
       (.I0(\dout_2d[1]_1 [55]),
        .I1(Q[4]),
        .I2(DOUT[55]),
        .O(D[55]));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[56]_i_1 
       (.I0(\dout_2d[1]_1 [56]),
        .I1(Q[4]),
        .I2(DOUT[56]),
        .O(D[56]));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[57]_i_1 
       (.I0(\dout_2d[1]_1 [57]),
        .I1(Q[4]),
        .I2(DOUT[57]),
        .O(D[57]));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[58]_i_1 
       (.I0(\dout_2d[1]_1 [58]),
        .I1(Q[4]),
        .I2(DOUT[58]),
        .O(D[58]));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[59]_i_1 
       (.I0(\dout_2d[1]_1 [59]),
        .I1(Q[4]),
        .I2(DOUT[59]),
        .O(D[59]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[5]_i_1 
       (.I0(\dout_2d[1]_1 [5]),
        .I1(Q[4]),
        .I2(DOUT[5]),
        .O(D[5]));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[60]_i_1 
       (.I0(\dout_2d[1]_1 [60]),
        .I1(Q[4]),
        .I2(DOUT[60]),
        .O(D[60]));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[61]_i_1 
       (.I0(\dout_2d[1]_1 [61]),
        .I1(Q[4]),
        .I2(DOUT[61]),
        .O(D[61]));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[62]_i_1 
       (.I0(\dout_2d[1]_1 [62]),
        .I1(Q[4]),
        .I2(DOUT[62]),
        .O(D[62]));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[63]_i_1 
       (.I0(\dout_2d[1]_1 [63]),
        .I1(Q[4]),
        .I2(DOUT[63]),
        .O(D[63]));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[64]_i_1 
       (.I0(\dout_2d[1]_1 [64]),
        .I1(Q[4]),
        .I2(DOUT[64]),
        .O(D[64]));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[65]_i_1 
       (.I0(\dout_2d[1]_1 [65]),
        .I1(Q[4]),
        .I2(DOUT[65]),
        .O(D[65]));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[66]_i_1 
       (.I0(\dout_2d[1]_1 [66]),
        .I1(Q[4]),
        .I2(DOUT[66]),
        .O(D[66]));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[67]_i_1 
       (.I0(\dout_2d[1]_1 [67]),
        .I1(Q[4]),
        .I2(DOUT[67]),
        .O(D[67]));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[68]_i_1 
       (.I0(\dout_2d[1]_1 [68]),
        .I1(Q[4]),
        .I2(DOUT[68]),
        .O(D[68]));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[69]_i_1 
       (.I0(\dout_2d[1]_1 [69]),
        .I1(Q[4]),
        .I2(DOUT[69]),
        .O(D[69]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[6]_i_1 
       (.I0(\dout_2d[1]_1 [6]),
        .I1(Q[4]),
        .I2(DOUT[6]),
        .O(D[6]));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[70]_i_1 
       (.I0(\dout_2d[1]_1 [70]),
        .I1(Q[4]),
        .I2(DOUT[70]),
        .O(D[70]));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[71]_i_1 
       (.I0(\dout_2d[1]_1 [71]),
        .I1(Q[4]),
        .I2(DOUT[71]),
        .O(D[71]));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[72]_i_1 
       (.I0(\dout_2d[1]_1 [72]),
        .I1(Q[4]),
        .I2(DOUT[72]),
        .O(D[72]));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[73]_i_1 
       (.I0(\dout_2d[1]_1 [73]),
        .I1(Q[4]),
        .I2(DOUT[73]),
        .O(D[73]));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[74]_i_1 
       (.I0(\dout_2d[1]_1 [74]),
        .I1(Q[4]),
        .I2(DOUT[74]),
        .O(D[74]));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[75]_i_1 
       (.I0(\dout_2d[1]_1 [75]),
        .I1(Q[4]),
        .I2(DOUT[75]),
        .O(D[75]));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[76]_i_1 
       (.I0(\dout_2d[1]_1 [76]),
        .I1(Q[4]),
        .I2(DOUT[76]),
        .O(D[76]));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[77]_i_1 
       (.I0(\dout_2d[1]_1 [77]),
        .I1(Q[4]),
        .I2(DOUT[77]),
        .O(D[77]));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[78]_i_1 
       (.I0(\dout_2d[1]_1 [78]),
        .I1(Q[4]),
        .I2(DOUT[78]),
        .O(D[78]));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[79]_i_1 
       (.I0(\dout_2d[1]_1 [79]),
        .I1(Q[4]),
        .I2(DOUT[79]),
        .O(D[79]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[7]_i_1 
       (.I0(\dout_2d[1]_1 [7]),
        .I1(Q[4]),
        .I2(DOUT[7]),
        .O(D[7]));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[80]_i_1 
       (.I0(\dout_2d[1]_1 [80]),
        .I1(Q[4]),
        .I2(DOUT[80]),
        .O(D[80]));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[81]_i_1 
       (.I0(\dout_2d[1]_1 [81]),
        .I1(Q[4]),
        .I2(DOUT[81]),
        .O(D[81]));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[82]_i_1 
       (.I0(\dout_2d[1]_1 [82]),
        .I1(Q[4]),
        .I2(DOUT[82]),
        .O(D[82]));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[83]_i_1 
       (.I0(\dout_2d[1]_1 [83]),
        .I1(Q[4]),
        .I2(DOUT[83]),
        .O(D[83]));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[84]_i_1 
       (.I0(\dout_2d[1]_1 [84]),
        .I1(Q[4]),
        .I2(DOUT[84]),
        .O(D[84]));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[85]_i_1 
       (.I0(\dout_2d[1]_1 [85]),
        .I1(Q[4]),
        .I2(DOUT[85]),
        .O(D[85]));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[86]_i_1 
       (.I0(\dout_2d[1]_1 [86]),
        .I1(Q[4]),
        .I2(DOUT[86]),
        .O(D[86]));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[87]_i_1 
       (.I0(\dout_2d[1]_1 [87]),
        .I1(Q[4]),
        .I2(DOUT[87]),
        .O(D[87]));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[88]_i_1 
       (.I0(\dout_2d[1]_1 [88]),
        .I1(Q[4]),
        .I2(DOUT[88]),
        .O(D[88]));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[89]_i_1 
       (.I0(\dout_2d[1]_1 [89]),
        .I1(Q[4]),
        .I2(DOUT[89]),
        .O(D[89]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[8]_i_1 
       (.I0(\dout_2d[1]_1 [8]),
        .I1(Q[4]),
        .I2(DOUT[8]),
        .O(D[8]));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[90]_i_1 
       (.I0(\dout_2d[1]_1 [90]),
        .I1(Q[4]),
        .I2(DOUT[90]),
        .O(D[90]));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[91]_i_1 
       (.I0(\dout_2d[1]_1 [91]),
        .I1(Q[4]),
        .I2(DOUT[91]),
        .O(D[91]));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[92]_i_1 
       (.I0(\dout_2d[1]_1 [92]),
        .I1(Q[4]),
        .I2(DOUT[92]),
        .O(D[92]));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[93]_i_1 
       (.I0(\dout_2d[1]_1 [93]),
        .I1(Q[4]),
        .I2(DOUT[93]),
        .O(D[93]));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[94]_i_1 
       (.I0(\dout_2d[1]_1 [94]),
        .I1(Q[4]),
        .I2(DOUT[94]),
        .O(D[94]));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[95]_i_1 
       (.I0(\dout_2d[1]_1 [95]),
        .I1(Q[4]),
        .I2(DOUT[95]),
        .O(D[95]));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[96]_i_1 
       (.I0(\dout_2d[1]_1 [96]),
        .I1(Q[4]),
        .I2(DOUT[96]),
        .O(D[96]));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[97]_i_1 
       (.I0(\dout_2d[1]_1 [97]),
        .I1(Q[4]),
        .I2(DOUT[97]),
        .O(D[97]));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[98]_i_1 
       (.I0(\dout_2d[1]_1 [98]),
        .I1(Q[4]),
        .I2(DOUT[98]),
        .O(D[98]));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[99]_i_1 
       (.I0(\dout_2d[1]_1 [99]),
        .I1(Q[4]),
        .I2(DOUT[99]),
        .O(D[99]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \dout_i[9]_i_1 
       (.I0(\dout_2d[1]_1 [9]),
        .I1(Q[4]),
        .I2(DOUT[9]),
        .O(D[9]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[0].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[0]),
        .Q(\dout_2d[1]_1 [0]),
        .Q15(\gram.gsms[0].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[100].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[100]),
        .Q(\dout_2d[1]_1 [100]),
        .Q15(\gram.gsms[100].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[101].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[101]),
        .Q(\dout_2d[1]_1 [101]),
        .Q15(\gram.gsms[101].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[102].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[102]),
        .Q(\dout_2d[1]_1 [102]),
        .Q15(\gram.gsms[102].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[103].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[103]),
        .Q(\dout_2d[1]_1 [103]),
        .Q15(\gram.gsms[103].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[104].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[104]),
        .Q(\dout_2d[1]_1 [104]),
        .Q15(\gram.gsms[104].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[105].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[105]),
        .Q(\dout_2d[1]_1 [105]),
        .Q15(\gram.gsms[105].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[106].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[106]),
        .Q(\dout_2d[1]_1 [106]),
        .Q15(\gram.gsms[106].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[107].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[107]),
        .Q(\dout_2d[1]_1 [107]),
        .Q15(\gram.gsms[107].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[108].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[108]),
        .Q(\dout_2d[1]_1 [108]),
        .Q15(\gram.gsms[108].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[109].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[109]),
        .Q(\dout_2d[1]_1 [109]),
        .Q15(\gram.gsms[109].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[10].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[10]),
        .Q(\dout_2d[1]_1 [10]),
        .Q15(\gram.gsms[10].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[110].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[110]),
        .Q(\dout_2d[1]_1 [110]),
        .Q15(\gram.gsms[110].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[111].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[111]),
        .Q(\dout_2d[1]_1 [111]),
        .Q15(\gram.gsms[111].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[112].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[112]),
        .Q(\dout_2d[1]_1 [112]),
        .Q15(\gram.gsms[112].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[113].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[113]),
        .Q(\dout_2d[1]_1 [113]),
        .Q15(\gram.gsms[113].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[114].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[114]),
        .Q(\dout_2d[1]_1 [114]),
        .Q15(\gram.gsms[114].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[115].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[115]),
        .Q(\dout_2d[1]_1 [115]),
        .Q15(\gram.gsms[115].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[116].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[116]),
        .Q(\dout_2d[1]_1 [116]),
        .Q15(\gram.gsms[116].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[117].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[117]),
        .Q(\dout_2d[1]_1 [117]),
        .Q15(\gram.gsms[117].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[118].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[118]),
        .Q(\dout_2d[1]_1 [118]),
        .Q15(\gram.gsms[118].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[119].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[119]),
        .Q(\dout_2d[1]_1 [119]),
        .Q15(\gram.gsms[119].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[11].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[11]),
        .Q(\dout_2d[1]_1 [11]),
        .Q15(\gram.gsms[11].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[120].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[120]),
        .Q(\dout_2d[1]_1 [120]),
        .Q15(\gram.gsms[120].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[121].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[121]),
        .Q(\dout_2d[1]_1 [121]),
        .Q15(\gram.gsms[121].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[122].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[122]),
        .Q(\dout_2d[1]_1 [122]),
        .Q15(\gram.gsms[122].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[123].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[123]),
        .Q(\dout_2d[1]_1 [123]),
        .Q15(\gram.gsms[123].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[124].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[124]),
        .Q(\dout_2d[1]_1 [124]),
        .Q15(\gram.gsms[124].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[125].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[125]),
        .Q(\dout_2d[1]_1 [125]),
        .Q15(\gram.gsms[125].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[126].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[126]),
        .Q(\dout_2d[1]_1 [126]),
        .Q15(\gram.gsms[126].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[127].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[127]),
        .Q(\dout_2d[1]_1 [127]),
        .Q15(\gram.gsms[127].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[12].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[12]),
        .Q(\dout_2d[1]_1 [12]),
        .Q15(\gram.gsms[12].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[13].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[13]),
        .Q(\dout_2d[1]_1 [13]),
        .Q15(\gram.gsms[13].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[14].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[14]),
        .Q(\dout_2d[1]_1 [14]),
        .Q15(\gram.gsms[14].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[15].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[15]),
        .Q(\dout_2d[1]_1 [15]),
        .Q15(\gram.gsms[15].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[16].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[16]),
        .Q(\dout_2d[1]_1 [16]),
        .Q15(\gram.gsms[16].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[17].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[17]),
        .Q(\dout_2d[1]_1 [17]),
        .Q15(\gram.gsms[17].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[18].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[18]),
        .Q(\dout_2d[1]_1 [18]),
        .Q15(\gram.gsms[18].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[19].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[19]),
        .Q(\dout_2d[1]_1 [19]),
        .Q15(\gram.gsms[19].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[1].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[1]),
        .Q(\dout_2d[1]_1 [1]),
        .Q15(\gram.gsms[1].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[20].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[20]),
        .Q(\dout_2d[1]_1 [20]),
        .Q15(\gram.gsms[20].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[21].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[21]),
        .Q(\dout_2d[1]_1 [21]),
        .Q15(\gram.gsms[21].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[22].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[22]),
        .Q(\dout_2d[1]_1 [22]),
        .Q15(\gram.gsms[22].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[23].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[23]),
        .Q(\dout_2d[1]_1 [23]),
        .Q15(\gram.gsms[23].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[24].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[24]),
        .Q(\dout_2d[1]_1 [24]),
        .Q15(\gram.gsms[24].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[25].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[25]),
        .Q(\dout_2d[1]_1 [25]),
        .Q15(\gram.gsms[25].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[26].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[26]),
        .Q(\dout_2d[1]_1 [26]),
        .Q15(\gram.gsms[26].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[27].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[27]),
        .Q(\dout_2d[1]_1 [27]),
        .Q15(\gram.gsms[27].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[28].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[28]),
        .Q(\dout_2d[1]_1 [28]),
        .Q15(\gram.gsms[28].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[29].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[29]),
        .Q(\dout_2d[1]_1 [29]),
        .Q15(\gram.gsms[29].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[2].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[2]),
        .Q(\dout_2d[1]_1 [2]),
        .Q15(\gram.gsms[2].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[30].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[30]),
        .Q(\dout_2d[1]_1 [30]),
        .Q15(\gram.gsms[30].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[31].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[31]),
        .Q(\dout_2d[1]_1 [31]),
        .Q15(\gram.gsms[31].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[32].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[32]),
        .Q(\dout_2d[1]_1 [32]),
        .Q15(\gram.gsms[32].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[33].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[33]),
        .Q(\dout_2d[1]_1 [33]),
        .Q15(\gram.gsms[33].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[34].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[34]),
        .Q(\dout_2d[1]_1 [34]),
        .Q15(\gram.gsms[34].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[35].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[35]),
        .Q(\dout_2d[1]_1 [35]),
        .Q15(\gram.gsms[35].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[36].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[36]),
        .Q(\dout_2d[1]_1 [36]),
        .Q15(\gram.gsms[36].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[37].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[37]),
        .Q(\dout_2d[1]_1 [37]),
        .Q15(\gram.gsms[37].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[38].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[38]),
        .Q(\dout_2d[1]_1 [38]),
        .Q15(\gram.gsms[38].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[39].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[39]),
        .Q(\dout_2d[1]_1 [39]),
        .Q15(\gram.gsms[39].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[3].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[3]),
        .Q(\dout_2d[1]_1 [3]),
        .Q15(\gram.gsms[3].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[40].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[40]),
        .Q(\dout_2d[1]_1 [40]),
        .Q15(\gram.gsms[40].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[41].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[41]),
        .Q(\dout_2d[1]_1 [41]),
        .Q15(\gram.gsms[41].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[42].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[42]),
        .Q(\dout_2d[1]_1 [42]),
        .Q15(\gram.gsms[42].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[43].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[43]),
        .Q(\dout_2d[1]_1 [43]),
        .Q15(\gram.gsms[43].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[44].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[44]),
        .Q(\dout_2d[1]_1 [44]),
        .Q15(\gram.gsms[44].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[45].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[45]),
        .Q(\dout_2d[1]_1 [45]),
        .Q15(\gram.gsms[45].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[46].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[46]),
        .Q(\dout_2d[1]_1 [46]),
        .Q15(\gram.gsms[46].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[47].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[47]),
        .Q(\dout_2d[1]_1 [47]),
        .Q15(\gram.gsms[47].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[48].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[48]),
        .Q(\dout_2d[1]_1 [48]),
        .Q15(\gram.gsms[48].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[49].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[49]),
        .Q(\dout_2d[1]_1 [49]),
        .Q15(\gram.gsms[49].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[4].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[4]),
        .Q(\dout_2d[1]_1 [4]),
        .Q15(\gram.gsms[4].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[50].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[50]),
        .Q(\dout_2d[1]_1 [50]),
        .Q15(\gram.gsms[50].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[51].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[51]),
        .Q(\dout_2d[1]_1 [51]),
        .Q15(\gram.gsms[51].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[52].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[52]),
        .Q(\dout_2d[1]_1 [52]),
        .Q15(\gram.gsms[52].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[53].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[53]),
        .Q(\dout_2d[1]_1 [53]),
        .Q15(\gram.gsms[53].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[54].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[54]),
        .Q(\dout_2d[1]_1 [54]),
        .Q15(\gram.gsms[54].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[55].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[55]),
        .Q(\dout_2d[1]_1 [55]),
        .Q15(\gram.gsms[55].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[56].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[56]),
        .Q(\dout_2d[1]_1 [56]),
        .Q15(\gram.gsms[56].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[57].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[57]),
        .Q(\dout_2d[1]_1 [57]),
        .Q15(\gram.gsms[57].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[58].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[58]),
        .Q(\dout_2d[1]_1 [58]),
        .Q15(\gram.gsms[58].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[59].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[59]),
        .Q(\dout_2d[1]_1 [59]),
        .Q15(\gram.gsms[59].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[5].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[5]),
        .Q(\dout_2d[1]_1 [5]),
        .Q15(\gram.gsms[5].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[60].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[60]),
        .Q(\dout_2d[1]_1 [60]),
        .Q15(\gram.gsms[60].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[61].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[61]),
        .Q(\dout_2d[1]_1 [61]),
        .Q15(\gram.gsms[61].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[62].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[62]),
        .Q(\dout_2d[1]_1 [62]),
        .Q15(\gram.gsms[62].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[63].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[63]),
        .Q(\dout_2d[1]_1 [63]),
        .Q15(\gram.gsms[63].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[64].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[64]),
        .Q(\dout_2d[1]_1 [64]),
        .Q15(\gram.gsms[64].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[65].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[65]),
        .Q(\dout_2d[1]_1 [65]),
        .Q15(\gram.gsms[65].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[66].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[66]),
        .Q(\dout_2d[1]_1 [66]),
        .Q15(\gram.gsms[66].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[67].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[67]),
        .Q(\dout_2d[1]_1 [67]),
        .Q15(\gram.gsms[67].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[68].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[68]),
        .Q(\dout_2d[1]_1 [68]),
        .Q15(\gram.gsms[68].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[69].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[69]),
        .Q(\dout_2d[1]_1 [69]),
        .Q15(\gram.gsms[69].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[6].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[6]),
        .Q(\dout_2d[1]_1 [6]),
        .Q15(\gram.gsms[6].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[70].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[70]),
        .Q(\dout_2d[1]_1 [70]),
        .Q15(\gram.gsms[70].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[71].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[71]),
        .Q(\dout_2d[1]_1 [71]),
        .Q15(\gram.gsms[71].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[72].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[72]),
        .Q(\dout_2d[1]_1 [72]),
        .Q15(\gram.gsms[72].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[73].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[73]),
        .Q(\dout_2d[1]_1 [73]),
        .Q15(\gram.gsms[73].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[74].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[74]),
        .Q(\dout_2d[1]_1 [74]),
        .Q15(\gram.gsms[74].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[75].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[75]),
        .Q(\dout_2d[1]_1 [75]),
        .Q15(\gram.gsms[75].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[76].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[76]),
        .Q(\dout_2d[1]_1 [76]),
        .Q15(\gram.gsms[76].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[77].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[77]),
        .Q(\dout_2d[1]_1 [77]),
        .Q15(\gram.gsms[77].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[78].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[78]),
        .Q(\dout_2d[1]_1 [78]),
        .Q15(\gram.gsms[78].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[79].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[79]),
        .Q(\dout_2d[1]_1 [79]),
        .Q15(\gram.gsms[79].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[7].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[7]),
        .Q(\dout_2d[1]_1 [7]),
        .Q15(\gram.gsms[7].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[80].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[80]),
        .Q(\dout_2d[1]_1 [80]),
        .Q15(\gram.gsms[80].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[81].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[81]),
        .Q(\dout_2d[1]_1 [81]),
        .Q15(\gram.gsms[81].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[82].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[82]),
        .Q(\dout_2d[1]_1 [82]),
        .Q15(\gram.gsms[82].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[83].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[83]),
        .Q(\dout_2d[1]_1 [83]),
        .Q15(\gram.gsms[83].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[84].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[84]),
        .Q(\dout_2d[1]_1 [84]),
        .Q15(\gram.gsms[84].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[85].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[85]),
        .Q(\dout_2d[1]_1 [85]),
        .Q15(\gram.gsms[85].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[86].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[86]),
        .Q(\dout_2d[1]_1 [86]),
        .Q15(\gram.gsms[86].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[87].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[87]),
        .Q(\dout_2d[1]_1 [87]),
        .Q15(\gram.gsms[87].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[88].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[88]),
        .Q(\dout_2d[1]_1 [88]),
        .Q15(\gram.gsms[88].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[89].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[89]),
        .Q(\dout_2d[1]_1 [89]),
        .Q15(\gram.gsms[89].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[8].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[8]),
        .Q(\dout_2d[1]_1 [8]),
        .Q15(\gram.gsms[8].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[90].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[90]),
        .Q(\dout_2d[1]_1 [90]),
        .Q15(\gram.gsms[90].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[91].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[91]),
        .Q(\dout_2d[1]_1 [91]),
        .Q15(\gram.gsms[91].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[92].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[92]),
        .Q(\dout_2d[1]_1 [92]),
        .Q15(\gram.gsms[92].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[93].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[93]),
        .Q(\dout_2d[1]_1 [93]),
        .Q15(\gram.gsms[93].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[94].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[94]),
        .Q(\dout_2d[1]_1 [94]),
        .Q15(\gram.gsms[94].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[95].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[95]),
        .Q(\dout_2d[1]_1 [95]),
        .Q15(\gram.gsms[95].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[96].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[96]),
        .Q(\dout_2d[1]_1 [96]),
        .Q15(\gram.gsms[96].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[97].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[97]),
        .Q(\dout_2d[1]_1 [97]),
        .Q15(\gram.gsms[97].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[98].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[98]),
        .Q(\dout_2d[1]_1 [98]),
        .Q15(\gram.gsms[98].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[99].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[99]),
        .Q(\dout_2d[1]_1 [99]),
        .Q15(\gram.gsms[99].gv4.srl16_n_1 ));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[9].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(DOUT_END[9]),
        .Q(\dout_2d[1]_1 [9]),
        .Q15(\gram.gsms[9].gv4.srl16_n_1 ));
endmodule

(* ORIG_REF_NAME = "shft_wrapper" *) 
module nvme_data_cmd_fifo_shft_wrapper_0
   (DOUT,
    DOUT_END,
    ram_wr_en,
    din,
    Q,
    clk);
  output [127:0]DOUT;
  output [127:0]DOUT_END;
  input ram_wr_en;
  input [127:0]din;
  input [3:0]Q;
  input clk;

  wire [127:0]DOUT;
  wire [127:0]DOUT_END;
  wire [3:0]Q;
  wire clk;
  wire [127:0]din;
  wire ram_wr_en;

  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[0].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[0]),
        .Q(DOUT[0]),
        .Q15(DOUT_END[0]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[100].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[100]),
        .Q(DOUT[100]),
        .Q15(DOUT_END[100]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[101].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[101]),
        .Q(DOUT[101]),
        .Q15(DOUT_END[101]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[102].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[102]),
        .Q(DOUT[102]),
        .Q15(DOUT_END[102]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[103].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[103]),
        .Q(DOUT[103]),
        .Q15(DOUT_END[103]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[104].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[104]),
        .Q(DOUT[104]),
        .Q15(DOUT_END[104]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[105].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[105]),
        .Q(DOUT[105]),
        .Q15(DOUT_END[105]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[106].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[106]),
        .Q(DOUT[106]),
        .Q15(DOUT_END[106]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[107].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[107]),
        .Q(DOUT[107]),
        .Q15(DOUT_END[107]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[108].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[108]),
        .Q(DOUT[108]),
        .Q15(DOUT_END[108]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[109].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[109]),
        .Q(DOUT[109]),
        .Q15(DOUT_END[109]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[10].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[10]),
        .Q(DOUT[10]),
        .Q15(DOUT_END[10]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[110].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[110]),
        .Q(DOUT[110]),
        .Q15(DOUT_END[110]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[111].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[111]),
        .Q(DOUT[111]),
        .Q15(DOUT_END[111]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[112].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[112]),
        .Q(DOUT[112]),
        .Q15(DOUT_END[112]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[113].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[113]),
        .Q(DOUT[113]),
        .Q15(DOUT_END[113]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[114].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[114]),
        .Q(DOUT[114]),
        .Q15(DOUT_END[114]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[115].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[115]),
        .Q(DOUT[115]),
        .Q15(DOUT_END[115]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[116].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[116]),
        .Q(DOUT[116]),
        .Q15(DOUT_END[116]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[117].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[117]),
        .Q(DOUT[117]),
        .Q15(DOUT_END[117]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[118].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[118]),
        .Q(DOUT[118]),
        .Q15(DOUT_END[118]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[119].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[119]),
        .Q(DOUT[119]),
        .Q15(DOUT_END[119]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[11].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[11]),
        .Q(DOUT[11]),
        .Q15(DOUT_END[11]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[120].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[120]),
        .Q(DOUT[120]),
        .Q15(DOUT_END[120]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[121].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[121]),
        .Q(DOUT[121]),
        .Q15(DOUT_END[121]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[122].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[122]),
        .Q(DOUT[122]),
        .Q15(DOUT_END[122]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[123].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[123]),
        .Q(DOUT[123]),
        .Q15(DOUT_END[123]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[124].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[124]),
        .Q(DOUT[124]),
        .Q15(DOUT_END[124]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[125].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[125]),
        .Q(DOUT[125]),
        .Q15(DOUT_END[125]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[126].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[126]),
        .Q(DOUT[126]),
        .Q15(DOUT_END[126]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[127].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[127]),
        .Q(DOUT[127]),
        .Q15(DOUT_END[127]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[12].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[12]),
        .Q(DOUT[12]),
        .Q15(DOUT_END[12]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[13].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[13]),
        .Q(DOUT[13]),
        .Q15(DOUT_END[13]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[14].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[14]),
        .Q(DOUT[14]),
        .Q15(DOUT_END[14]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[15].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[15]),
        .Q(DOUT[15]),
        .Q15(DOUT_END[15]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[16].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[16]),
        .Q(DOUT[16]),
        .Q15(DOUT_END[16]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[17].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[17]),
        .Q(DOUT[17]),
        .Q15(DOUT_END[17]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[18].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[18]),
        .Q(DOUT[18]),
        .Q15(DOUT_END[18]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[19].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[19]),
        .Q(DOUT[19]),
        .Q15(DOUT_END[19]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[1].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[1]),
        .Q(DOUT[1]),
        .Q15(DOUT_END[1]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[20].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[20]),
        .Q(DOUT[20]),
        .Q15(DOUT_END[20]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[21].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[21]),
        .Q(DOUT[21]),
        .Q15(DOUT_END[21]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[22].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[22]),
        .Q(DOUT[22]),
        .Q15(DOUT_END[22]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[23].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[23]),
        .Q(DOUT[23]),
        .Q15(DOUT_END[23]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[24].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[24]),
        .Q(DOUT[24]),
        .Q15(DOUT_END[24]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[25].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[25]),
        .Q(DOUT[25]),
        .Q15(DOUT_END[25]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[26].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[26]),
        .Q(DOUT[26]),
        .Q15(DOUT_END[26]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[27].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[27]),
        .Q(DOUT[27]),
        .Q15(DOUT_END[27]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[28].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[28]),
        .Q(DOUT[28]),
        .Q15(DOUT_END[28]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[29].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[29]),
        .Q(DOUT[29]),
        .Q15(DOUT_END[29]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[2].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[2]),
        .Q(DOUT[2]),
        .Q15(DOUT_END[2]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[30].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[30]),
        .Q(DOUT[30]),
        .Q15(DOUT_END[30]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[31].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[31]),
        .Q(DOUT[31]),
        .Q15(DOUT_END[31]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[32].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[32]),
        .Q(DOUT[32]),
        .Q15(DOUT_END[32]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[33].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[33]),
        .Q(DOUT[33]),
        .Q15(DOUT_END[33]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[34].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[34]),
        .Q(DOUT[34]),
        .Q15(DOUT_END[34]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[35].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[35]),
        .Q(DOUT[35]),
        .Q15(DOUT_END[35]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[36].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[36]),
        .Q(DOUT[36]),
        .Q15(DOUT_END[36]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[37].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[37]),
        .Q(DOUT[37]),
        .Q15(DOUT_END[37]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[38].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[38]),
        .Q(DOUT[38]),
        .Q15(DOUT_END[38]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[39].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[39]),
        .Q(DOUT[39]),
        .Q15(DOUT_END[39]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[3].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[3]),
        .Q(DOUT[3]),
        .Q15(DOUT_END[3]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[40].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[40]),
        .Q(DOUT[40]),
        .Q15(DOUT_END[40]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[41].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[41]),
        .Q(DOUT[41]),
        .Q15(DOUT_END[41]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[42].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[42]),
        .Q(DOUT[42]),
        .Q15(DOUT_END[42]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[43].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[43]),
        .Q(DOUT[43]),
        .Q15(DOUT_END[43]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[44].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[44]),
        .Q(DOUT[44]),
        .Q15(DOUT_END[44]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[45].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[45]),
        .Q(DOUT[45]),
        .Q15(DOUT_END[45]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[46].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[46]),
        .Q(DOUT[46]),
        .Q15(DOUT_END[46]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[47].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[47]),
        .Q(DOUT[47]),
        .Q15(DOUT_END[47]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[48].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[48]),
        .Q(DOUT[48]),
        .Q15(DOUT_END[48]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[49].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[49]),
        .Q(DOUT[49]),
        .Q15(DOUT_END[49]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[4].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[4]),
        .Q(DOUT[4]),
        .Q15(DOUT_END[4]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[50].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[50]),
        .Q(DOUT[50]),
        .Q15(DOUT_END[50]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[51].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[51]),
        .Q(DOUT[51]),
        .Q15(DOUT_END[51]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[52].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[52]),
        .Q(DOUT[52]),
        .Q15(DOUT_END[52]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[53].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[53]),
        .Q(DOUT[53]),
        .Q15(DOUT_END[53]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[54].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[54]),
        .Q(DOUT[54]),
        .Q15(DOUT_END[54]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[55].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[55]),
        .Q(DOUT[55]),
        .Q15(DOUT_END[55]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[56].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[56]),
        .Q(DOUT[56]),
        .Q15(DOUT_END[56]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[57].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[57]),
        .Q(DOUT[57]),
        .Q15(DOUT_END[57]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[58].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[58]),
        .Q(DOUT[58]),
        .Q15(DOUT_END[58]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[59].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[59]),
        .Q(DOUT[59]),
        .Q15(DOUT_END[59]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[5].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[5]),
        .Q(DOUT[5]),
        .Q15(DOUT_END[5]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[60].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[60]),
        .Q(DOUT[60]),
        .Q15(DOUT_END[60]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[61].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[61]),
        .Q(DOUT[61]),
        .Q15(DOUT_END[61]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[62].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[62]),
        .Q(DOUT[62]),
        .Q15(DOUT_END[62]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[63].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[63]),
        .Q(DOUT[63]),
        .Q15(DOUT_END[63]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[64].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[64]),
        .Q(DOUT[64]),
        .Q15(DOUT_END[64]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[65].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[65]),
        .Q(DOUT[65]),
        .Q15(DOUT_END[65]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[66].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[66]),
        .Q(DOUT[66]),
        .Q15(DOUT_END[66]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[67].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[67]),
        .Q(DOUT[67]),
        .Q15(DOUT_END[67]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[68].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[68]),
        .Q(DOUT[68]),
        .Q15(DOUT_END[68]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[69].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[69]),
        .Q(DOUT[69]),
        .Q15(DOUT_END[69]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[6].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[6]),
        .Q(DOUT[6]),
        .Q15(DOUT_END[6]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[70].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[70]),
        .Q(DOUT[70]),
        .Q15(DOUT_END[70]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[71].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[71]),
        .Q(DOUT[71]),
        .Q15(DOUT_END[71]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[72].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[72]),
        .Q(DOUT[72]),
        .Q15(DOUT_END[72]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[73].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[73]),
        .Q(DOUT[73]),
        .Q15(DOUT_END[73]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[74].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[74]),
        .Q(DOUT[74]),
        .Q15(DOUT_END[74]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[75].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[75]),
        .Q(DOUT[75]),
        .Q15(DOUT_END[75]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[76].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[76]),
        .Q(DOUT[76]),
        .Q15(DOUT_END[76]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[77].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[77]),
        .Q(DOUT[77]),
        .Q15(DOUT_END[77]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[78].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[78]),
        .Q(DOUT[78]),
        .Q15(DOUT_END[78]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[79].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[79]),
        .Q(DOUT[79]),
        .Q15(DOUT_END[79]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[7].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[7]),
        .Q(DOUT[7]),
        .Q15(DOUT_END[7]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[80].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[80]),
        .Q(DOUT[80]),
        .Q15(DOUT_END[80]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[81].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[81]),
        .Q(DOUT[81]),
        .Q15(DOUT_END[81]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[82].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[82]),
        .Q(DOUT[82]),
        .Q15(DOUT_END[82]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[83].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[83]),
        .Q(DOUT[83]),
        .Q15(DOUT_END[83]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[84].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[84]),
        .Q(DOUT[84]),
        .Q15(DOUT_END[84]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[85].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[85]),
        .Q(DOUT[85]),
        .Q15(DOUT_END[85]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[86].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[86]),
        .Q(DOUT[86]),
        .Q15(DOUT_END[86]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[87].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[87]),
        .Q(DOUT[87]),
        .Q15(DOUT_END[87]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[88].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[88]),
        .Q(DOUT[88]),
        .Q15(DOUT_END[88]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[89].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[89]),
        .Q(DOUT[89]),
        .Q15(DOUT_END[89]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[8].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[8]),
        .Q(DOUT[8]),
        .Q15(DOUT_END[8]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[90].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[90]),
        .Q(DOUT[90]),
        .Q15(DOUT_END[90]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[91].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[91]),
        .Q(DOUT[91]),
        .Q15(DOUT_END[91]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[92].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[92]),
        .Q(DOUT[92]),
        .Q15(DOUT_END[92]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[93].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[93]),
        .Q(DOUT[93]),
        .Q15(DOUT_END[93]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[94].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[94]),
        .Q(DOUT[94]),
        .Q15(DOUT_END[94]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[95].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[95]),
        .Q(DOUT[95]),
        .Q15(DOUT_END[95]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[96].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[96]),
        .Q(DOUT[96]),
        .Q15(DOUT_END[96]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[97].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[97]),
        .Q(DOUT[97]),
        .Q15(DOUT_END[97]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[98].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[98]),
        .Q(DOUT[98]),
        .Q15(DOUT_END[98]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[99].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[99]),
        .Q(DOUT[99]),
        .Q15(DOUT_END[99]));
  (* box_type = "PRIMITIVE" *) 
  SRLC16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \gram.gsms[9].gv4.srl16 
       (.A0(Q[0]),
        .A1(Q[1]),
        .A2(Q[2]),
        .A3(Q[3]),
        .CE(ram_wr_en),
        .CLK(clk),
        .D(din[9]),
        .Q(DOUT[9]),
        .Q15(DOUT_END[9]));
endmodule

(* ORIG_REF_NAME = "updn_cntr" *) 
module nvme_data_cmd_fifo_updn_cntr
   (Q,
    \count_reg[1]_0 ,
    E,
    clk,
    AR);
  output [4:0]Q;
  input \count_reg[1]_0 ;
  input [0:0]E;
  input clk;
  input [0:0]AR;

  wire [0:0]AR;
  wire [0:0]E;
  wire [4:0]Q;
  wire clk;
  wire \count[0]_i_1_n_0 ;
  wire \count[1]_i_1__1_n_0 ;
  wire \count[2]_i_1_n_0 ;
  wire \count[3]_i_1_n_0 ;
  wire \count[4]_i_2_n_0 ;
  wire \count_reg[1]_0 ;

  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \count[0]_i_1 
       (.I0(Q[0]),
        .O(\count[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \count[1]_i_1__1 
       (.I0(Q[0]),
        .I1(\count_reg[1]_0 ),
        .I2(Q[1]),
        .O(\count[1]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'hD2B4)) 
    \count[2]_i_1 
       (.I0(Q[0]),
        .I1(\count_reg[1]_0 ),
        .I2(Q[2]),
        .I3(Q[1]),
        .O(\count[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'hBF40FD02)) 
    \count[3]_i_1 
       (.I0(\count_reg[1]_0 ),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(Q[3]),
        .I4(Q[2]),
        .O(\count[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF7FF0800FFEF0010)) 
    \count[4]_i_2 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(\count_reg[1]_0 ),
        .I3(Q[2]),
        .I4(Q[4]),
        .I5(Q[3]),
        .O(\count[4]_i_2_n_0 ));
  FDPE #(
    .INIT(1'b1)) 
    \count_reg[0] 
       (.C(clk),
        .CE(E),
        .D(\count[0]_i_1_n_0 ),
        .PRE(AR),
        .Q(Q[0]));
  FDPE #(
    .INIT(1'b1)) 
    \count_reg[1] 
       (.C(clk),
        .CE(E),
        .D(\count[1]_i_1__1_n_0 ),
        .PRE(AR),
        .Q(Q[1]));
  FDPE #(
    .INIT(1'b1)) 
    \count_reg[2] 
       (.C(clk),
        .CE(E),
        .D(\count[2]_i_1_n_0 ),
        .PRE(AR),
        .Q(Q[2]));
  FDPE #(
    .INIT(1'b1)) 
    \count_reg[3] 
       (.C(clk),
        .CE(E),
        .D(\count[3]_i_1_n_0 ),
        .PRE(AR),
        .Q(Q[3]));
  FDPE #(
    .INIT(1'b1)) 
    \count_reg[4] 
       (.C(clk),
        .CE(E),
        .D(\count[4]_i_2_n_0 ),
        .PRE(AR),
        .Q(Q[4]));
endmodule

(* ORIG_REF_NAME = "updn_cntr" *) 
module nvme_data_cmd_fifo_updn_cntr__parameterized0
   (D,
    ram_empty_comb,
    comp0,
    \count_reg[1]_0 ,
    ram_empty_fb_i_reg,
    pntr_d11__0,
    out,
    E,
    clk,
    AR);
  output [4:0]D;
  output ram_empty_comb;
  output comp0;
  input \count_reg[1]_0 ;
  input ram_empty_fb_i_reg;
  input pntr_d11__0;
  input out;
  input [0:0]E;
  input clk;
  input [0:0]AR;

  wire [0:0]AR;
  wire [4:0]D;
  wire [0:0]E;
  wire clk;
  wire comp0;
  wire \count[0]_i_1__1_n_0 ;
  wire \count[1]_i_1__0_n_0 ;
  wire \count[2]_i_1__0_n_0 ;
  wire \count[3]_i_1__0_n_0 ;
  wire \count[4]_i_1__0_n_0 ;
  wire \count_reg[1]_0 ;
  wire out;
  wire [4:0]pntr;
  wire pntr_d11__0;
  wire ram_empty_comb;
  wire ram_empty_fb_i_i_2_n_0;
  wire ram_empty_fb_i_reg;

  LUT1 #(
    .INIT(2'h1)) 
    \count[0]_i_1__1 
       (.I0(pntr[0]),
        .O(\count[0]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \count[1]_i_1__0 
       (.I0(pntr[0]),
        .I1(\count_reg[1]_0 ),
        .I2(pntr[1]),
        .O(\count[1]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hD2B4)) 
    \count[2]_i_1__0 
       (.I0(pntr[0]),
        .I1(\count_reg[1]_0 ),
        .I2(pntr[2]),
        .I3(pntr[1]),
        .O(\count[2]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hBF40FD02)) 
    \count[3]_i_1__0 
       (.I0(\count_reg[1]_0 ),
        .I1(pntr[0]),
        .I2(pntr[1]),
        .I3(pntr[3]),
        .I4(pntr[2]),
        .O(\count[3]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'hF7FF0800FFEF0010)) 
    \count[4]_i_1__0 
       (.I0(pntr[1]),
        .I1(pntr[0]),
        .I2(\count_reg[1]_0 ),
        .I3(pntr[2]),
        .I4(pntr[4]),
        .I5(pntr[3]),
        .O(\count[4]_i_1__0_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \count_reg[0] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(\count[0]_i_1__1_n_0 ),
        .Q(pntr[0]));
  FDCE #(
    .INIT(1'b0)) 
    \count_reg[1] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(\count[1]_i_1__0_n_0 ),
        .Q(pntr[1]));
  FDCE #(
    .INIT(1'b0)) 
    \count_reg[2] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(\count[2]_i_1__0_n_0 ),
        .Q(pntr[2]));
  FDCE #(
    .INIT(1'b0)) 
    \count_reg[3] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(\count[3]_i_1__0_n_0 ),
        .Q(pntr[3]));
  FDCE #(
    .INIT(1'b0)) 
    \count_reg[4] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(\count[4]_i_1__0_n_0 ),
        .Q(pntr[4]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h9A)) 
    \greg.pntr_d1[0]_i_1 
       (.I0(pntr[0]),
        .I1(\count_reg[1]_0 ),
        .I2(ram_empty_fb_i_reg),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hF708)) 
    \greg.pntr_d1[1]_i_1 
       (.I0(pntr[0]),
        .I1(ram_empty_fb_i_reg),
        .I2(\count_reg[1]_0 ),
        .I3(pntr[1]),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hBFFF4000)) 
    \greg.pntr_d1[2]_i_1 
       (.I0(\count_reg[1]_0 ),
        .I1(ram_empty_fb_i_reg),
        .I2(pntr[0]),
        .I3(pntr[1]),
        .I4(pntr[2]),
        .O(D[2]));
  LUT6 #(
    .INIT(64'hFF7FFFFF00800000)) 
    \greg.pntr_d1[3]_i_1 
       (.I0(pntr[1]),
        .I1(pntr[0]),
        .I2(ram_empty_fb_i_reg),
        .I3(\count_reg[1]_0 ),
        .I4(pntr[2]),
        .I5(pntr[3]),
        .O(D[3]));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \greg.pntr_d1[4]_i_1 
       (.I0(pntr[2]),
        .I1(pntr_d11__0),
        .I2(pntr[0]),
        .I3(pntr[1]),
        .I4(pntr[3]),
        .I5(pntr[4]),
        .O(D[4]));
  LUT6 #(
    .INIT(64'hFFF3FFFF00000080)) 
    ram_empty_fb_i_i_1
       (.I0(\count_reg[1]_0 ),
        .I1(ram_empty_fb_i_i_2_n_0),
        .I2(pntr[0]),
        .I3(pntr[1]),
        .I4(ram_empty_fb_i_reg),
        .I5(out),
        .O(ram_empty_comb));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h01)) 
    ram_empty_fb_i_i_2
       (.I0(pntr[3]),
        .I1(pntr[2]),
        .I2(pntr[4]),
        .O(ram_empty_fb_i_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    ram_full_fb_i_i_3
       (.I0(pntr[1]),
        .I1(pntr[0]),
        .I2(pntr[4]),
        .I3(pntr[2]),
        .I4(pntr[3]),
        .O(comp0));
endmodule

(* ORIG_REF_NAME = "updn_cntr" *) 
module nvme_data_cmd_fifo_updn_cntr__parameterized1
   (comp1,
    \count_reg[1]_0 ,
    E,
    clk,
    AR);
  output comp1;
  input \count_reg[1]_0 ;
  input [0:0]E;
  input clk;
  input [0:0]AR;

  wire [0:0]AR;
  wire [0:0]E;
  wire clk;
  wire comp1;
  wire \count[0]_i_1__0_n_0 ;
  wire \count[1]_i_1_n_0 ;
  wire \count[2]_i_1__1_n_0 ;
  wire \count[3]_i_1__1_n_0 ;
  wire \count[4]_i_1__1_n_0 ;
  wire \count_reg[1]_0 ;
  wire [4:0]pntr_plus1;

  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \count[0]_i_1__0 
       (.I0(pntr_plus1[0]),
        .O(\count[0]_i_1__0_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \count[1]_i_1 
       (.I0(pntr_plus1[0]),
        .I1(\count_reg[1]_0 ),
        .I2(pntr_plus1[1]),
        .O(\count[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'hD2B4)) 
    \count[2]_i_1__1 
       (.I0(pntr_plus1[0]),
        .I1(\count_reg[1]_0 ),
        .I2(pntr_plus1[2]),
        .I3(pntr_plus1[1]),
        .O(\count[2]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'hBF40FD02)) 
    \count[3]_i_1__1 
       (.I0(\count_reg[1]_0 ),
        .I1(pntr_plus1[0]),
        .I2(pntr_plus1[1]),
        .I3(pntr_plus1[3]),
        .I4(pntr_plus1[2]),
        .O(\count[3]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'hF7FF0800FFEF0010)) 
    \count[4]_i_1__1 
       (.I0(pntr_plus1[1]),
        .I1(pntr_plus1[0]),
        .I2(\count_reg[1]_0 ),
        .I3(pntr_plus1[2]),
        .I4(pntr_plus1[4]),
        .I5(pntr_plus1[3]),
        .O(\count[4]_i_1__1_n_0 ));
  FDPE #(
    .INIT(1'b1)) 
    \count_reg[0] 
       (.C(clk),
        .CE(E),
        .D(\count[0]_i_1__0_n_0 ),
        .PRE(AR),
        .Q(pntr_plus1[0]));
  FDCE #(
    .INIT(1'b0)) 
    \count_reg[1] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(\count[1]_i_1_n_0 ),
        .Q(pntr_plus1[1]));
  FDCE #(
    .INIT(1'b0)) 
    \count_reg[2] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(\count[2]_i_1__1_n_0 ),
        .Q(pntr_plus1[2]));
  FDCE #(
    .INIT(1'b0)) 
    \count_reg[3] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(\count[3]_i_1__1_n_0 ),
        .Q(pntr_plus1[3]));
  FDCE #(
    .INIT(1'b0)) 
    \count_reg[4] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(\count[4]_i_1__1_n_0 ),
        .Q(pntr_plus1[4]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    ram_full_fb_i_i_2
       (.I0(pntr_plus1[1]),
        .I1(pntr_plus1[0]),
        .I2(pntr_plus1[4]),
        .I3(pntr_plus1[2]),
        .I4(pntr_plus1[3]),
        .O(comp1));
endmodule

(* ORIG_REF_NAME = "wr_pf_sshft" *) 
module nvme_data_cmd_fifo_wr_pf_sshft
   (prog_full,
    \greg.ram_rd_en_i_reg_0 ,
    clk,
    AR,
    \greg.ram_wr_en_i_reg_0 ,
    out,
    \gpf1.prog_full_i_reg_0 ,
    D);
  output prog_full;
  input \greg.ram_rd_en_i_reg_0 ;
  input clk;
  input [0:0]AR;
  input \greg.ram_wr_en_i_reg_0 ;
  input out;
  input \gpf1.prog_full_i_reg_0 ;
  input [4:0]D;

  wire [0:0]AR;
  wire [4:0]D;
  wire clk;
  wire eqOp__3;
  wire \gpf1.prog_full_i_i_1_n_0 ;
  wire \gpf1.prog_full_i_reg_0 ;
  wire \greg.pntr_d1_reg_n_0_[0] ;
  wire \greg.pntr_d1_reg_n_0_[1] ;
  wire \greg.pntr_d1_reg_n_0_[2] ;
  wire \greg.pntr_d1_reg_n_0_[3] ;
  wire \greg.pntr_d1_reg_n_0_[4] ;
  wire \greg.ram_rd_en_i_reg_0 ;
  wire \greg.ram_wr_en_i_reg_0 ;
  wire out;
  wire prog_full;
  wire ram_rd_en_i;
  wire ram_wr_en_i;

  LUT5 #(
    .INIT(32'h51550040)) 
    \gpf1.prog_full_i_i_1 
       (.I0(\gpf1.prog_full_i_reg_0 ),
        .I1(eqOp__3),
        .I2(ram_wr_en_i),
        .I3(ram_rd_en_i),
        .I4(prog_full),
        .O(\gpf1.prog_full_i_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h10000000)) 
    \gpf1.prog_full_i_i_2 
       (.I0(\greg.pntr_d1_reg_n_0_[1] ),
        .I1(\greg.pntr_d1_reg_n_0_[0] ),
        .I2(\greg.pntr_d1_reg_n_0_[3] ),
        .I3(\greg.pntr_d1_reg_n_0_[2] ),
        .I4(\greg.pntr_d1_reg_n_0_[4] ),
        .O(eqOp__3));
  FDPE #(
    .INIT(1'b1)) 
    \gpf1.prog_full_i_reg 
       (.C(clk),
        .CE(1'b1),
        .D(\gpf1.prog_full_i_i_1_n_0 ),
        .PRE(out),
        .Q(prog_full));
  FDCE \greg.pntr_d1_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .CLR(AR),
        .D(D[0]),
        .Q(\greg.pntr_d1_reg_n_0_[0] ));
  FDCE \greg.pntr_d1_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .CLR(AR),
        .D(D[1]),
        .Q(\greg.pntr_d1_reg_n_0_[1] ));
  FDCE \greg.pntr_d1_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .CLR(AR),
        .D(D[2]),
        .Q(\greg.pntr_d1_reg_n_0_[2] ));
  FDCE \greg.pntr_d1_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .CLR(AR),
        .D(D[3]),
        .Q(\greg.pntr_d1_reg_n_0_[3] ));
  FDCE \greg.pntr_d1_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .CLR(AR),
        .D(D[4]),
        .Q(\greg.pntr_d1_reg_n_0_[4] ));
  FDCE #(
    .INIT(1'b0)) 
    \greg.ram_rd_en_i_reg 
       (.C(clk),
        .CE(1'b1),
        .CLR(AR),
        .D(\greg.ram_rd_en_i_reg_0 ),
        .Q(ram_rd_en_i));
  FDCE #(
    .INIT(1'b0)) 
    \greg.ram_wr_en_i_reg 
       (.C(clk),
        .CE(1'b1),
        .CLR(AR),
        .D(\greg.ram_wr_en_i_reg_0 ),
        .Q(ram_wr_en_i));
endmodule

(* ORIG_REF_NAME = "wr_status_flags_sshft" *) 
module nvme_data_cmd_fifo_wr_status_flags_sshft
   (full,
    wr_en_0,
    pntr_d11__0,
    E,
    clk,
    out,
    comp1,
    \count_reg[4] ,
    comp0,
    ram_full_i_reg_0,
    wr_en);
  output full;
  output wr_en_0;
  output pntr_d11__0;
  output [0:0]E;
  input clk;
  input out;
  input comp1;
  input \count_reg[4] ;
  input comp0;
  input ram_full_i_reg_0;
  input wr_en;

  wire [0:0]E;
  wire clk;
  wire comp0;
  wire comp1;
  wire \count_reg[4] ;
  wire out;
  wire pntr_d11__0;
  (* DONT_TOUCH *) wire ram_afull_fb_0;
  (* DONT_TOUCH *) wire ram_afull_i;
  wire ram_full_comb;
  (* DONT_TOUCH *) wire ram_full_fb_i;
  (* DONT_TOUCH *) wire ram_full_i;
  wire ram_full_i_reg_0;
  wire wr_en;
  wire wr_en_0;

  assign full = ram_full_i;
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \count[4]_i_1 
       (.I0(wr_en_0),
        .I1(\count_reg[4] ),
        .O(E));
  LUT2 #(
    .INIT(4'h2)) 
    \gram.gsms[0].gv4.srl16_i_1 
       (.I0(wr_en),
        .I1(ram_full_fb_i),
        .O(wr_en_0));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \greg.pntr_d1[4]_i_2 
       (.I0(wr_en_0),
        .I1(\count_reg[4] ),
        .O(pntr_d11__0));
  LUT1 #(
    .INIT(2'h2)) 
    i_0
       (.I0(1'b1),
        .O(ram_afull_i));
  LUT1 #(
    .INIT(2'h2)) 
    i_1
       (.I0(1'b1),
        .O(ram_afull_fb_0));
  LUT6 #(
    .INIT(64'h08080FFF08080808)) 
    ram_full_fb_i_i_1
       (.I0(wr_en_0),
        .I1(comp1),
        .I2(\count_reg[4] ),
        .I3(comp0),
        .I4(ram_full_i_reg_0),
        .I5(ram_full_fb_i),
        .O(ram_full_comb));
  (* DONT_TOUCH *) 
  (* KEEP = "yes" *) 
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_full_fb_i_reg
       (.C(clk),
        .CE(1'b1),
        .D(ram_full_comb),
        .PRE(out),
        .Q(ram_full_fb_i));
  (* DONT_TOUCH *) 
  (* KEEP = "yes" *) 
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_full_i_reg
       (.C(clk),
        .CE(1'b1),
        .D(ram_full_comb),
        .PRE(out),
        .Q(ram_full_i));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
