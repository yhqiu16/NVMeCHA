// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Mon Oct 19 17:02:57 2020
// Host        : yhqiu running 64-bit CentOS Linux release 7.8.2003 (Core)
// Command     : write_verilog -force -mode funcsim
//               /mnt/F/SSD/PJs_2019.2/NVMe_Controller/NVMe_Controller.srcs/sources_1/bd/ps_subsystem/ip/ps_subsystem_clk_wiz_1_0/ps_subsystem_clk_wiz_1_0_sim_netlist.v
// Design      : ps_subsystem_clk_wiz_1_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcku040-ffva1156-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* NotValidForBitStream *)
module ps_subsystem_clk_wiz_1_0
   (clk_200M,
    reset,
    locked,
    clk_in1_p,
    clk_in1_n);
  output clk_200M;
  input reset;
  output locked;
  input clk_in1_p;
  input clk_in1_n;

  wire clk_200M;
  (* IBUF_LOW_PWR *) wire clk_in1_n;
  (* IBUF_LOW_PWR *) wire clk_in1_p;
  wire locked;
  wire reset;

  ps_subsystem_clk_wiz_1_0_ps_subsystem_clk_wiz_1_0_clk_wiz inst
       (.clk_200M(clk_200M),
        .clk_in1_n(clk_in1_n),
        .clk_in1_p(clk_in1_p),
        .locked(locked),
        .reset(reset));
endmodule

(* ORIG_REF_NAME = "ps_subsystem_clk_wiz_1_0_clk_wiz" *) 
module ps_subsystem_clk_wiz_1_0_ps_subsystem_clk_wiz_1_0_clk_wiz
   (clk_200M,
    reset,
    locked,
    clk_in1_p,
    clk_in1_n);
  output clk_200M;
  input reset;
  output locked;
  input clk_in1_p;
  input clk_in1_n;

  wire clk_200M;
  wire clk_200M_ps_subsystem_clk_wiz_1_0;
  wire clk_in1_n;
  wire clk_in1_p;
  wire clk_in1_ps_subsystem_clk_wiz_1_0;
  wire locked;
  wire reset;
  wire NLW_mmcme3_adv_inst_CDDCDONE_UNCONNECTED;
  wire NLW_mmcme3_adv_inst_CLKFBIN_UNCONNECTED;
  wire NLW_mmcme3_adv_inst_CLKFBOUT_UNCONNECTED;
  wire NLW_mmcme3_adv_inst_CLKFBOUTB_UNCONNECTED;
  wire NLW_mmcme3_adv_inst_CLKFBSTOPPED_UNCONNECTED;
  wire NLW_mmcme3_adv_inst_CLKINSTOPPED_UNCONNECTED;
  wire NLW_mmcme3_adv_inst_CLKOUT0B_UNCONNECTED;
  wire NLW_mmcme3_adv_inst_CLKOUT1_UNCONNECTED;
  wire NLW_mmcme3_adv_inst_CLKOUT1B_UNCONNECTED;
  wire NLW_mmcme3_adv_inst_CLKOUT2_UNCONNECTED;
  wire NLW_mmcme3_adv_inst_CLKOUT2B_UNCONNECTED;
  wire NLW_mmcme3_adv_inst_CLKOUT3_UNCONNECTED;
  wire NLW_mmcme3_adv_inst_CLKOUT3B_UNCONNECTED;
  wire NLW_mmcme3_adv_inst_CLKOUT4_UNCONNECTED;
  wire NLW_mmcme3_adv_inst_CLKOUT5_UNCONNECTED;
  wire NLW_mmcme3_adv_inst_CLKOUT6_UNCONNECTED;
  wire NLW_mmcme3_adv_inst_DRDY_UNCONNECTED;
  wire NLW_mmcme3_adv_inst_PSDONE_UNCONNECTED;
  wire [15:0]NLW_mmcme3_adv_inst_DO_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* CAPACITANCE = "DONT_CARE" *) 
  (* IBUF_DELAY_VALUE = "0" *) 
  (* IFD_DELAY_VALUE = "AUTO" *) 
  IBUFDS #(
    .DIFF_TERM("FALSE"),
    .IOSTANDARD("DEFAULT")) 
    clkin1_ibufds
       (.I(clk_in1_p),
        .IB(clk_in1_n),
        .O(clk_in1_ps_subsystem_clk_wiz_1_0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* XILINX_LEGACY_PRIM = "BUFG" *) 
  BUFGCE #(
    .CE_TYPE("ASYNC"),
    .SIM_DEVICE("ULTRASCALE")) 
    clkout1_buf
       (.CE(1'b1),
        .I(clk_200M_ps_subsystem_clk_wiz_1_0),
        .O(clk_200M));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "MLO" *) 
  MMCME3_ADV #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKFBOUT_MULT_F(8.000000),
    .CLKFBOUT_PHASE(0.000000),
    .CLKFBOUT_USE_FINE_PS("FALSE"),
    .CLKIN1_PERIOD(8.000000),
    .CLKIN2_PERIOD(0.000000),
    .CLKOUT0_DIVIDE_F(5.000000),
    .CLKOUT0_DUTY_CYCLE(0.500000),
    .CLKOUT0_PHASE(0.000000),
    .CLKOUT0_USE_FINE_PS("FALSE"),
    .CLKOUT1_DIVIDE(1),
    .CLKOUT1_DUTY_CYCLE(0.500000),
    .CLKOUT1_PHASE(0.000000),
    .CLKOUT1_USE_FINE_PS("FALSE"),
    .CLKOUT2_DIVIDE(1),
    .CLKOUT2_DUTY_CYCLE(0.500000),
    .CLKOUT2_PHASE(0.000000),
    .CLKOUT2_USE_FINE_PS("FALSE"),
    .CLKOUT3_DIVIDE(1),
    .CLKOUT3_DUTY_CYCLE(0.500000),
    .CLKOUT3_PHASE(0.000000),
    .CLKOUT3_USE_FINE_PS("FALSE"),
    .CLKOUT4_CASCADE("FALSE"),
    .CLKOUT4_DIVIDE(1),
    .CLKOUT4_DUTY_CYCLE(0.500000),
    .CLKOUT4_PHASE(0.000000),
    .CLKOUT4_USE_FINE_PS("FALSE"),
    .CLKOUT5_DIVIDE(1),
    .CLKOUT5_DUTY_CYCLE(0.500000),
    .CLKOUT5_PHASE(0.000000),
    .CLKOUT5_USE_FINE_PS("FALSE"),
    .CLKOUT6_DIVIDE(1),
    .CLKOUT6_DUTY_CYCLE(0.500000),
    .CLKOUT6_PHASE(0.000000),
    .CLKOUT6_USE_FINE_PS("FALSE"),
    .COMPENSATION("INTERNAL"),
    .DIVCLK_DIVIDE(1),
    .IS_CLKFBIN_INVERTED(1'b0),
    .IS_CLKIN1_INVERTED(1'b0),
    .IS_CLKIN2_INVERTED(1'b0),
    .IS_CLKINSEL_INVERTED(1'b0),
    .IS_PSEN_INVERTED(1'b0),
    .IS_PSINCDEC_INVERTED(1'b0),
    .IS_PWRDWN_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .REF_JITTER1(0.010000),
    .REF_JITTER2(0.010000),
    .SS_EN("FALSE"),
    .SS_MODE("CENTER_HIGH"),
    .SS_MOD_PERIOD(10000),
    .STARTUP_WAIT("FALSE")) 
    mmcme3_adv_inst
       (.CDDCDONE(NLW_mmcme3_adv_inst_CDDCDONE_UNCONNECTED),
        .CDDCREQ(1'b0),
        .CLKFBIN(NLW_mmcme3_adv_inst_CLKFBIN_UNCONNECTED),
        .CLKFBOUT(NLW_mmcme3_adv_inst_CLKFBOUT_UNCONNECTED),
        .CLKFBOUTB(NLW_mmcme3_adv_inst_CLKFBOUTB_UNCONNECTED),
        .CLKFBSTOPPED(NLW_mmcme3_adv_inst_CLKFBSTOPPED_UNCONNECTED),
        .CLKIN1(clk_in1_ps_subsystem_clk_wiz_1_0),
        .CLKIN2(1'b0),
        .CLKINSEL(1'b1),
        .CLKINSTOPPED(NLW_mmcme3_adv_inst_CLKINSTOPPED_UNCONNECTED),
        .CLKOUT0(clk_200M_ps_subsystem_clk_wiz_1_0),
        .CLKOUT0B(NLW_mmcme3_adv_inst_CLKOUT0B_UNCONNECTED),
        .CLKOUT1(NLW_mmcme3_adv_inst_CLKOUT1_UNCONNECTED),
        .CLKOUT1B(NLW_mmcme3_adv_inst_CLKOUT1B_UNCONNECTED),
        .CLKOUT2(NLW_mmcme3_adv_inst_CLKOUT2_UNCONNECTED),
        .CLKOUT2B(NLW_mmcme3_adv_inst_CLKOUT2B_UNCONNECTED),
        .CLKOUT3(NLW_mmcme3_adv_inst_CLKOUT3_UNCONNECTED),
        .CLKOUT3B(NLW_mmcme3_adv_inst_CLKOUT3B_UNCONNECTED),
        .CLKOUT4(NLW_mmcme3_adv_inst_CLKOUT4_UNCONNECTED),
        .CLKOUT5(NLW_mmcme3_adv_inst_CLKOUT5_UNCONNECTED),
        .CLKOUT6(NLW_mmcme3_adv_inst_CLKOUT6_UNCONNECTED),
        .DADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DCLK(1'b0),
        .DEN(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DO(NLW_mmcme3_adv_inst_DO_UNCONNECTED[15:0]),
        .DRDY(NLW_mmcme3_adv_inst_DRDY_UNCONNECTED),
        .DWE(1'b0),
        .LOCKED(locked),
        .PSCLK(1'b0),
        .PSDONE(NLW_mmcme3_adv_inst_PSDONE_UNCONNECTED),
        .PSEN(1'b0),
        .PSINCDEC(1'b0),
        .PWRDWN(1'b0),
        .RST(reset));
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
