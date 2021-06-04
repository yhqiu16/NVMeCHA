//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Wed Dec 16 10:18:45 2020
//Host        : yhqiu running 64-bit CentOS Linux release 7.8.2003 (Core)
//Command     : generate_target ps_subsystem_wrapper.bd
//Design      : ps_subsystem_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module ps_subsystem_wrapper
   (UART_0_rxd,
    UART_0_txd,
    m0_axi_araddr,
    m0_axi_arprot,
    m0_axi_arready,
    m0_axi_arvalid,
    m0_axi_awaddr,
    m0_axi_awprot,
    m0_axi_awready,
    m0_axi_awvalid,
    m0_axi_bready,
    m0_axi_bresp,
    m0_axi_bvalid,
    m0_axi_rdata,
    m0_axi_rready,
    m0_axi_rresp,
    m0_axi_rvalid,
    m0_axi_wdata,
    m0_axi_wready,
    m0_axi_wstrb,
    m0_axi_wvalid,
    m_axi_aclk,
    m_axi_aresetn,
    ps_bp_addr,
    ps_bp_clk,
    ps_bp_din,
    ps_bp_dout,
    ps_bp_en,
    ps_bp_ro_0_addr,
    ps_bp_ro_0_clk,
    ps_bp_ro_0_din,
    ps_bp_ro_0_dout,
    ps_bp_ro_0_en,
    ps_bp_ro_0_rst,
    ps_bp_ro_0_we,
    ps_bp_ro_1_addr,
    ps_bp_ro_1_clk,
    ps_bp_ro_1_din,
    ps_bp_ro_1_dout,
    ps_bp_ro_1_en,
    ps_bp_ro_1_rst,
    ps_bp_ro_1_we,
    ps_bp_rst,
    ps_bp_we,
    ps_bp_wo_0_addr,
    ps_bp_wo_0_clk,
    ps_bp_wo_0_din,
    ps_bp_wo_0_dout,
    ps_bp_wo_0_en,
    ps_bp_wo_0_rst,
    ps_bp_wo_0_we,
    ps_bp_wo_1_addr,
    ps_bp_wo_1_clk,
    ps_bp_wo_1_din,
    ps_bp_wo_1_dout,
    ps_bp_wo_1_en,
    ps_bp_wo_1_rst,
    ps_bp_wo_1_we,
    ps_clk_clk_n,
    ps_clk_clk_p,
    ps_reset);
  input UART_0_rxd;
  output UART_0_txd;
  output [31:0]m0_axi_araddr;
  output [2:0]m0_axi_arprot;
  input m0_axi_arready;
  output m0_axi_arvalid;
  output [31:0]m0_axi_awaddr;
  output [2:0]m0_axi_awprot;
  input m0_axi_awready;
  output m0_axi_awvalid;
  output m0_axi_bready;
  input [1:0]m0_axi_bresp;
  input m0_axi_bvalid;
  input [31:0]m0_axi_rdata;
  output m0_axi_rready;
  input [1:0]m0_axi_rresp;
  input m0_axi_rvalid;
  output [31:0]m0_axi_wdata;
  input m0_axi_wready;
  output [3:0]m0_axi_wstrb;
  output m0_axi_wvalid;
  input m_axi_aclk;
  input m_axi_aresetn;
  output [15:0]ps_bp_addr;
  output ps_bp_clk;
  output [31:0]ps_bp_din;
  input [31:0]ps_bp_dout;
  output ps_bp_en;
  output [12:0]ps_bp_ro_0_addr;
  output ps_bp_ro_0_clk;
  output [127:0]ps_bp_ro_0_din;
  input [127:0]ps_bp_ro_0_dout;
  output ps_bp_ro_0_en;
  output ps_bp_ro_0_rst;
  output [15:0]ps_bp_ro_0_we;
  output [12:0]ps_bp_ro_1_addr;
  output ps_bp_ro_1_clk;
  output [127:0]ps_bp_ro_1_din;
  input [127:0]ps_bp_ro_1_dout;
  output ps_bp_ro_1_en;
  output ps_bp_ro_1_rst;
  output [15:0]ps_bp_ro_1_we;
  output ps_bp_rst;
  output [3:0]ps_bp_we;
  output [12:0]ps_bp_wo_0_addr;
  output ps_bp_wo_0_clk;
  output [127:0]ps_bp_wo_0_din;
  input [127:0]ps_bp_wo_0_dout;
  output ps_bp_wo_0_en;
  output ps_bp_wo_0_rst;
  output [15:0]ps_bp_wo_0_we;
  output [12:0]ps_bp_wo_1_addr;
  output ps_bp_wo_1_clk;
  output [127:0]ps_bp_wo_1_din;
  input [127:0]ps_bp_wo_1_dout;
  output ps_bp_wo_1_en;
  output ps_bp_wo_1_rst;
  output [15:0]ps_bp_wo_1_we;
  input ps_clk_clk_n;
  input ps_clk_clk_p;
  input ps_reset;

  wire UART_0_rxd;
  wire UART_0_txd;
  wire [31:0]m0_axi_araddr;
  wire [2:0]m0_axi_arprot;
  wire m0_axi_arready;
  wire m0_axi_arvalid;
  wire [31:0]m0_axi_awaddr;
  wire [2:0]m0_axi_awprot;
  wire m0_axi_awready;
  wire m0_axi_awvalid;
  wire m0_axi_bready;
  wire [1:0]m0_axi_bresp;
  wire m0_axi_bvalid;
  wire [31:0]m0_axi_rdata;
  wire m0_axi_rready;
  wire [1:0]m0_axi_rresp;
  wire m0_axi_rvalid;
  wire [31:0]m0_axi_wdata;
  wire m0_axi_wready;
  wire [3:0]m0_axi_wstrb;
  wire m0_axi_wvalid;
  wire m_axi_aclk;
  wire m_axi_aresetn;
  wire [15:0]ps_bp_addr;
  wire ps_bp_clk;
  wire [31:0]ps_bp_din;
  wire [31:0]ps_bp_dout;
  wire ps_bp_en;
  wire [12:0]ps_bp_ro_0_addr;
  wire ps_bp_ro_0_clk;
  wire [127:0]ps_bp_ro_0_din;
  wire [127:0]ps_bp_ro_0_dout;
  wire ps_bp_ro_0_en;
  wire ps_bp_ro_0_rst;
  wire [15:0]ps_bp_ro_0_we;
  wire [12:0]ps_bp_ro_1_addr;
  wire ps_bp_ro_1_clk;
  wire [127:0]ps_bp_ro_1_din;
  wire [127:0]ps_bp_ro_1_dout;
  wire ps_bp_ro_1_en;
  wire ps_bp_ro_1_rst;
  wire [15:0]ps_bp_ro_1_we;
  wire ps_bp_rst;
  wire [3:0]ps_bp_we;
  wire [12:0]ps_bp_wo_0_addr;
  wire ps_bp_wo_0_clk;
  wire [127:0]ps_bp_wo_0_din;
  wire [127:0]ps_bp_wo_0_dout;
  wire ps_bp_wo_0_en;
  wire ps_bp_wo_0_rst;
  wire [15:0]ps_bp_wo_0_we;
  wire [12:0]ps_bp_wo_1_addr;
  wire ps_bp_wo_1_clk;
  wire [127:0]ps_bp_wo_1_din;
  wire [127:0]ps_bp_wo_1_dout;
  wire ps_bp_wo_1_en;
  wire ps_bp_wo_1_rst;
  wire [15:0]ps_bp_wo_1_we;
  wire ps_clk_clk_n;
  wire ps_clk_clk_p;
  wire ps_reset;

  ps_subsystem ps_subsystem_i
       (.UART_0_rxd(UART_0_rxd),
        .UART_0_txd(UART_0_txd),
        .m0_axi_araddr(m0_axi_araddr),
        .m0_axi_arprot(m0_axi_arprot),
        .m0_axi_arready(m0_axi_arready),
        .m0_axi_arvalid(m0_axi_arvalid),
        .m0_axi_awaddr(m0_axi_awaddr),
        .m0_axi_awprot(m0_axi_awprot),
        .m0_axi_awready(m0_axi_awready),
        .m0_axi_awvalid(m0_axi_awvalid),
        .m0_axi_bready(m0_axi_bready),
        .m0_axi_bresp(m0_axi_bresp),
        .m0_axi_bvalid(m0_axi_bvalid),
        .m0_axi_rdata(m0_axi_rdata),
        .m0_axi_rready(m0_axi_rready),
        .m0_axi_rresp(m0_axi_rresp),
        .m0_axi_rvalid(m0_axi_rvalid),
        .m0_axi_wdata(m0_axi_wdata),
        .m0_axi_wready(m0_axi_wready),
        .m0_axi_wstrb(m0_axi_wstrb),
        .m0_axi_wvalid(m0_axi_wvalid),
        .m_axi_aclk(m_axi_aclk),
        .m_axi_aresetn(m_axi_aresetn),
        .ps_bp_addr(ps_bp_addr),
        .ps_bp_clk(ps_bp_clk),
        .ps_bp_din(ps_bp_din),
        .ps_bp_dout(ps_bp_dout),
        .ps_bp_en(ps_bp_en),
        .ps_bp_ro_0_addr(ps_bp_ro_0_addr),
        .ps_bp_ro_0_clk(ps_bp_ro_0_clk),
        .ps_bp_ro_0_din(ps_bp_ro_0_din),
        .ps_bp_ro_0_dout(ps_bp_ro_0_dout),
        .ps_bp_ro_0_en(ps_bp_ro_0_en),
        .ps_bp_ro_0_rst(ps_bp_ro_0_rst),
        .ps_bp_ro_0_we(ps_bp_ro_0_we),
        .ps_bp_ro_1_addr(ps_bp_ro_1_addr),
        .ps_bp_ro_1_clk(ps_bp_ro_1_clk),
        .ps_bp_ro_1_din(ps_bp_ro_1_din),
        .ps_bp_ro_1_dout(ps_bp_ro_1_dout),
        .ps_bp_ro_1_en(ps_bp_ro_1_en),
        .ps_bp_ro_1_rst(ps_bp_ro_1_rst),
        .ps_bp_ro_1_we(ps_bp_ro_1_we),
        .ps_bp_rst(ps_bp_rst),
        .ps_bp_we(ps_bp_we),
        .ps_bp_wo_0_addr(ps_bp_wo_0_addr),
        .ps_bp_wo_0_clk(ps_bp_wo_0_clk),
        .ps_bp_wo_0_din(ps_bp_wo_0_din),
        .ps_bp_wo_0_dout(ps_bp_wo_0_dout),
        .ps_bp_wo_0_en(ps_bp_wo_0_en),
        .ps_bp_wo_0_rst(ps_bp_wo_0_rst),
        .ps_bp_wo_0_we(ps_bp_wo_0_we),
        .ps_bp_wo_1_addr(ps_bp_wo_1_addr),
        .ps_bp_wo_1_clk(ps_bp_wo_1_clk),
        .ps_bp_wo_1_din(ps_bp_wo_1_din),
        .ps_bp_wo_1_dout(ps_bp_wo_1_dout),
        .ps_bp_wo_1_en(ps_bp_wo_1_en),
        .ps_bp_wo_1_rst(ps_bp_wo_1_rst),
        .ps_bp_wo_1_we(ps_bp_wo_1_we),
        .ps_clk_clk_n(ps_clk_clk_n),
        .ps_clk_clk_p(ps_clk_clk_p),
        .ps_reset(ps_reset));
endmodule
