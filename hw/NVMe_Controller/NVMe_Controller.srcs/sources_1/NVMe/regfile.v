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
// Create Date: 03/28/2020 08:08:51 PM
// Design Name: 
// Module Name: regfile
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

`include "nvme_param.vh"


module regfile #(parameter
    AXIL_ADDR_WIDTH = 16,
    AXIL_DATA_WIDTH = 32
)(
    input                           aclk,
    input                           areset,
    input                           aclk_en,
    // AXI-Lite Interfaces
    output                          axil_awready,
    input                           axil_awvalid,
    input  [AXIL_ADDR_WIDTH-1:0]    axil_awaddr,
    output                          axil_wready,
    input                           axil_wvalid,
    input  [AXIL_DATA_WIDTH-1:0]    axil_wdata,
    input  [AXIL_DATA_WIDTH/8-1:0]  axil_wstrb,
    input                           axil_bready,
    output                          axil_bvalid,
    output [1:0]                    axil_bresp,
    output                          axil_arready,
    input                           axil_arvalid,
    input  [AXIL_ADDR_WIDTH-1:0]    axil_araddr,
    input                           axil_rready,
    output                          axil_rvalid,
    output [AXIL_DATA_WIDTH-1:0]    axil_rdata,
    output [1:0]                    axil_rresp,
    
    // registers
    output reg                      dma_soft_rstn,
    output                          nvme_reg_cc_en,
    input                           nvme_reg_csts_rdy,
    output     [ 1:0]               nvme_reg_cc_shn,
    input      [ 1:0]               nvme_reg_csts_shst,
    input                           nvme_cc_reset, // reset due to controller configuration register
    output reg [ 7:0]               mps_width,
    output reg [31:0]               irq_mask,
    output     [63:0]               o_sq_base_addr_0,
    output     [15:0]               o_sq_size_0,
    output     [15:0]               o_sq_tail_0,
    output     [63:0]               o_cq_base_addr_0,
    output     [15:0]               o_cq_size_0,
    output     [15:0]               o_cq_head_0,
    output     [15:0]               o_sq_tail_1,
    output     [15:0]               o_cq_head_1,
    output     [15:0]               o_sq_tail_2,
    output     [15:0]               o_cq_head_2,
    output     [15:0]               o_sq_tail_3,
    output     [15:0]               o_cq_head_3,
    output     [15:0]               o_sq_tail_4,
    output     [15:0]               o_cq_head_4,
    output     [15:0]               o_sq_tail_5,
    output     [15:0]               o_cq_head_5,
    output     [15:0]               o_sq_tail_6,
    output     [15:0]               o_cq_head_6,
    output     [15:0]               o_sq_tail_7,
    output     [15:0]               o_cq_head_7,
    output     [15:0]               o_sq_tail_8,
    output     [15:0]               o_cq_head_8,
    output     [15:0]               o_sq_tail_9,
    output     [15:0]               o_cq_head_9,
    output     [15:0]               o_sq_tail_10,
    output     [15:0]               o_cq_head_10,
    output     [15:0]               o_sq_tail_11,
    output     [15:0]               o_cq_head_11,
    output     [15:0]               o_sq_tail_12,
    output     [15:0]               o_cq_head_12,
    output     [15:0]               o_sq_tail_13,
    output     [15:0]               o_cq_head_13,
    output     [15:0]               o_sq_tail_14,
    output     [15:0]               o_cq_head_14,
    output     [15:0]               o_sq_tail_15,
    output     [15:0]               o_cq_head_15,
    output     [15:0]               o_sq_tail_16,
    output     [15:0]               o_cq_head_16    
);


//------------------------NVMe Specification BAR0 Address Info-------------------
// 0x00 : Controller capability low 32bits  (RO)
// 0x04 : Controller capability high 32bits (RO)
// 0x08 : Version (RO)
// 0x0c : Interrupt Mask Set   (RWS)
// 0x10 : Interrupt Mask Clear (RWC)
// 0x14 : Controller configuration (RW/RO)
// 0x18 : Reserved
// 0x1c : Controller status (RO/RWC)
// 0x20 : NVM Subsystem reset (RW)
// 0x24 : Admin Queue Attributes (RW)
// 0x28 : Admin Submission Queue base address low 32bit  (RW)
// 0x2c : Admin Submission Queue base address high 32bit (RW)
// 0x30 : Admin Completion Queue base address low 32bit  (RW)
// 0x34 : Admin Completion Queue base address high 32bit (RW)
// ...  : reserved
// 0x1000 : Tail Doorbell of SQ 0 (Admin) (RW)
// 0x1004 : Head Doorbell of CQ 0 (Admin) (RW)
// 0x1008 : Tail Doorbell of SQ 1 (RW)
// 0x100c : Head Doorbell of CQ 1 (RW)
// ...  : SQ & CQ n
// (RO = Read only, RW = Read Write, R/W = Read Write, the value read may not be the last value write
//  RWC = Read/Write 1 to Clear, RWS = Read/Write 1 to Set)

//------------------------Parameter----------------------
localparam    
    WRIDLE                = 2'd0,
    WRDATA                = 2'd1,
    WRRESP                = 2'd2,
    WRRESET               = 2'd3,
    RDIDLE                = 2'd0,
    RDDATA                = 2'd1,
    RDRESET               = 2'd2,
    ADDR_CAPL             = 16'h00,
    ADDR_CAPH             = 16'h04,
    ADDR_VS               = 16'h08,
    ADDR_INTMS            = 16'h0c,
    ADDR_INTMC            = 16'h10,
    ADDR_CC               = 16'h14,
    ADDR_CSTS             = 16'h1c,
    ADDR_NSSR             = 16'h20,
    ADDR_AQA              = 16'h24,
    ADDR_ASQL             = 16'h28,
    ADDR_ASQH             = 16'h2c,
    ADDR_ACQL             = 16'h30,
    ADDR_ACQH             = 16'h34,
    ADDR_SQ_TAIL_0        = 16'h1000,
    ADDR_CQ_HEAD_0        = 16'h1004,
    ADDR_SQ_TAIL_1        = 16'h1008,
    ADDR_CQ_HEAD_1        = 16'h100c,
    ADDR_SQ_TAIL_2        = 16'h1010,
    ADDR_CQ_HEAD_2        = 16'h1014,
    ADDR_SQ_TAIL_3        = 16'h1018,
    ADDR_CQ_HEAD_3        = 16'h101c,
    ADDR_SQ_TAIL_4        = 16'h1020,
    ADDR_CQ_HEAD_4        = 16'h1024,
    ADDR_SQ_TAIL_5        = 16'h1028,
    ADDR_CQ_HEAD_5        = 16'h102c,
    ADDR_SQ_TAIL_6        = 16'h1030,
    ADDR_CQ_HEAD_6        = 16'h1034,
    ADDR_SQ_TAIL_7        = 16'h1038,
    ADDR_CQ_HEAD_7        = 16'h103c,
    ADDR_SQ_TAIL_8        = 16'h1040,
    ADDR_CQ_HEAD_8        = 16'h1044,
    ADDR_SQ_TAIL_9        = 16'h1048,
    ADDR_CQ_HEAD_9        = 16'h104c,
    ADDR_SQ_TAIL_10       = 16'h1050,
    ADDR_CQ_HEAD_10       = 16'h1054,
    ADDR_SQ_TAIL_11       = 16'h1058,
    ADDR_CQ_HEAD_11       = 16'h105c,
    ADDR_SQ_TAIL_12       = 16'h1060,
    ADDR_CQ_HEAD_12       = 16'h1064,
    ADDR_SQ_TAIL_13       = 16'h1068,
    ADDR_CQ_HEAD_13       = 16'h106c,
    ADDR_SQ_TAIL_14       = 16'h1070,
    ADDR_CQ_HEAD_14       = 16'h1074,
    ADDR_SQ_TAIL_15       = 16'h1078,
    ADDR_CQ_HEAD_15       = 16'h107c,
    ADDR_SQ_TAIL_16       = 16'h1080,
    ADDR_CQ_HEAD_16       = 16'h1084;     
    
//------------------------Local signal-------------------
reg  [1:0]                    wstate = WRRESET;
reg  [1:0]                    wnext;
reg  [AXIL_ADDR_WIDTH-1:0]    waddr = 'h0;
wire [31:0]                   wmask;
wire                          aw_hs;
wire                          w_hs;
reg  [1:0]                    rstate = RDRESET;
reg  [1:0]                    rnext;
reg  [31:0]                   rdata = 32'h0;
wire                          ar_hs;
wire [AXIL_ADDR_WIDTH-1:0]    raddr;

// internal registers
reg                           int_dma_soft_rst = 1'b0;
reg  [ 3:0]                   int_cc_iocqes; // IO Completion Queue Entry Size
reg  [ 3:0]                   int_cc_iosqes; // IO Submission Queue Entry Size
reg  [ 1:0]                   int_cc_shn; // shutdown notification
reg  [ 2:0]                   int_cc_ams; // arbitration mechanism selected
reg  [ 3:0]                   int_cc_mps; // memory page size, 2^(12+mps)
reg  [ 2:0]                   int_cc_css; // IO Command Set Selected
reg                           int_cc_en; // Controller configuration enable
wire                          int_csts_pp; // processing paused
reg                           int_csts_nssro; // NVM Subsystem Reset Occurred
//wire [ 1:0]                   int_csts_shst; // shutdown status
wire                          int_csts_cfs; // Controller Fatal status
//reg                           int_csts_rdy; // Ready
reg  [31:0]                   int_nssrc; // NVM Subsystem Reset Control
reg  [11:0]                   int_acqs; // admin completion queue size 
reg  [11:0]                   int_asqs; // admin submission queue size 
reg  [63:0]                   int_asqb; // admin submission queue base address
reg  [63:0]                   int_acqb; // admin completion queue base address
//reg  [31:0]                   irq_mask; // Not used for MSI-X Interrupt
reg  [15:0] sq_size_0;
reg  [31:0] sq_tail_0;
reg  [15:0] cq_size_0;
reg  [31:0] cq_head_0;
reg  [31:0] sq_tail_1;
reg  [31:0] cq_head_1;
reg  [31:0] sq_tail_2;
reg  [31:0] cq_head_2;
reg  [31:0] sq_tail_3;
reg  [31:0] cq_head_3;
reg  [31:0] sq_tail_4;
reg  [31:0] cq_head_4;
reg  [31:0] sq_tail_5;
reg  [31:0] cq_head_5;
reg  [31:0] sq_tail_6;
reg  [31:0] cq_head_6;
reg  [31:0] sq_tail_7;
reg  [31:0] cq_head_7;
reg  [31:0] sq_tail_8;
reg  [31:0] cq_head_8;
reg  [31:0] sq_tail_9;
reg  [31:0] cq_head_9;
reg  [31:0] sq_tail_10;
reg  [31:0] cq_head_10;
reg  [31:0] sq_tail_11;
reg  [31:0] cq_head_11;
reg  [31:0] sq_tail_12;
reg  [31:0] cq_head_12;
reg  [31:0] sq_tail_13;
reg  [31:0] cq_head_13;
reg  [31:0] sq_tail_14;
reg  [31:0] cq_head_14;
reg  [31:0] sq_tail_15;
reg  [31:0] cq_head_15;
reg  [31:0] sq_tail_16;
reg  [31:0] cq_head_16; 

assign int_csts_cfs = 1'b0;
//assign int_csts_shst = 2'h0;
assign int_csts_pp = 1'b0;

assign o_sq_size_0  = sq_size_0[15:0];                    
assign o_sq_tail_0  = sq_tail_0[15:0];                                           
assign o_cq_size_0  = cq_size_0[15:0];                    
assign o_cq_head_0  = cq_head_0[15:0];                    
assign o_sq_tail_1  = sq_tail_1[15:0];                    
assign o_cq_head_1  = cq_head_1[15:0];                    
assign o_sq_tail_2  = sq_tail_2[15:0];                    
assign o_cq_head_2  = cq_head_2[15:0];                    
assign o_sq_tail_3  = sq_tail_3[15:0];                    
assign o_cq_head_3  = cq_head_3[15:0];                    
assign o_sq_tail_4  = sq_tail_4[15:0];                    
assign o_cq_head_4  = cq_head_4[15:0];                    
assign o_sq_tail_5  = sq_tail_5[15:0];                    
assign o_cq_head_5  = cq_head_5[15:0];                    
assign o_sq_tail_6  = sq_tail_6[15:0];                    
assign o_cq_head_6  = cq_head_6[15:0];                    
assign o_sq_tail_7  = sq_tail_7[15:0];                    
assign o_cq_head_7  = cq_head_7[15:0];                    
assign o_sq_tail_8  = sq_tail_8[15:0];                    
assign o_cq_head_8  = cq_head_8[15:0];                    
assign o_sq_tail_9  = sq_tail_9[15:0];                    
assign o_cq_head_9  = cq_head_9[15:0];                    
assign o_sq_tail_10 = sq_tail_10[15:0];                     
assign o_cq_head_10 = cq_head_10[15:0];                     
assign o_sq_tail_11 = sq_tail_11[15:0];                     
assign o_cq_head_11 = cq_head_11[15:0];                     
assign o_sq_tail_12 = sq_tail_12[15:0];                     
assign o_cq_head_12 = cq_head_12[15:0];                     
assign o_sq_tail_13 = sq_tail_13[15:0];                     
assign o_cq_head_13 = cq_head_13[15:0];                     
assign o_sq_tail_14 = sq_tail_14[15:0];                     
assign o_cq_head_14 = cq_head_14[15:0];                     
assign o_sq_tail_15 = sq_tail_15[15:0];                     
assign o_cq_head_15 = cq_head_15[15:0];                     
assign o_sq_tail_16 = sq_tail_16[15:0];                     
assign o_cq_head_16 = cq_head_16[15:0];                      
     
//------------------------Instantiation------------------

//------------------------AXI write fsm------------------
assign axil_awready = (wstate == WRIDLE);
assign axil_wready  = (wstate == WRDATA);
assign axil_bresp   = 2'b00;  // OKAY
assign axil_bvalid  = (wstate == WRRESP);
assign wmask   = { {8{axil_wstrb[3]}}, {8{axil_wstrb[2]}}, {8{axil_wstrb[1]}}, {8{axil_wstrb[0]}} };
assign aw_hs   = axil_awvalid & axil_awready;
assign w_hs    = axil_wvalid & axil_wready;

// wstate
always @(posedge aclk) begin
    if (areset)
        wstate <= WRRESET;
    else if (aclk_en)
        wstate <= wnext;
end

// wnext
always @(*) begin
    case (wstate)
        WRIDLE:
            if (axil_awvalid)
                wnext = WRDATA;
            else
                wnext = WRIDLE;
        WRDATA:
            if (axil_wvalid)
                wnext = WRRESP;
            else
                wnext = WRDATA;
        WRRESP:
            if (axil_bready)
                wnext = WRIDLE;
            else
                wnext = WRRESP;
        default:
            wnext = WRIDLE;
    endcase
end

// waddr
always @(posedge aclk) begin
    if (aclk_en) begin
        if (aw_hs)
            waddr <= axil_awaddr[AXIL_ADDR_WIDTH-1:0];
    end
end

//------------------------AXI read fsm-------------------
assign axil_arready = (rstate == RDIDLE);
assign axil_rdata   = rdata;
assign axil_rresp   = 2'b00;  // OKAY
assign axil_rvalid  = (rstate == RDDATA);
assign ar_hs   = axil_arvalid & axil_arready;
assign raddr   = axil_araddr[AXIL_ADDR_WIDTH-1:0];

// rstate
always @(posedge aclk) begin
    if (areset)
        rstate <= RDRESET;
    else if (aclk_en)
        rstate <= rnext;
end

// rnext
always @(*) begin
    case (rstate)
        RDIDLE:
            if (axil_arvalid)
                rnext = RDDATA;
            else
                rnext = RDIDLE;
        RDDATA:
            if (axil_rready & axil_rvalid)
                rnext = RDIDLE;
            else
                rnext = RDDATA;
        default:
            rnext = RDIDLE;
    endcase
end



// rdata
always @(posedge aclk) begin
    if (aclk_en) begin
        if (ar_hs) begin
            case (raddr)
                ADDR_CAPL:  rdata <= {`TIMEOUT, 5'h0, 2'h0, 1'h1, `MAX_QSIZE};                    
                ADDR_CAPH:  rdata <= {8'h0, `MPSMAX, `MPSMIN, 3'h0, 8'h1, 1'b0, 4'h0};
                ADDR_VS:    rdata <= {16'h1, 8'h2, 8'h0};
                ADDR_INTMS: rdata <= irq_mask;
                ADDR_INTMC: rdata <= irq_mask;
                ADDR_CC:    rdata <= {8'h0, int_cc_iocqes, int_cc_iosqes, int_cc_shn, int_cc_ams, int_cc_mps, int_cc_css, 3'h0, int_cc_en};
                ADDR_CSTS:  rdata <= {26'h0, int_csts_pp, int_csts_nssro, nvme_reg_csts_shst, int_csts_cfs, nvme_reg_csts_rdy};
                ADDR_NSSR:  rdata <= int_nssrc;
                ADDR_AQA:   rdata <= {4'h0, int_acqs, 4'h0, int_asqs};
                ADDR_ASQL:  rdata <= int_asqb[31:0];
                ADDR_ASQH:  rdata <= int_asqb[63:32];
                ADDR_ACQL:  rdata <= int_acqb[31:0];
                ADDR_ACQH:  rdata <= int_acqb[63:32];
                ADDR_SQ_TAIL_0:       rdata <= sq_tail_0;
                ADDR_CQ_HEAD_0:       rdata <= cq_head_0;
                ADDR_SQ_TAIL_1:       rdata <= sq_tail_1;
                ADDR_CQ_HEAD_1:       rdata <= cq_head_1;
                ADDR_SQ_TAIL_2:       rdata <= sq_tail_2;
                ADDR_CQ_HEAD_2:       rdata <= cq_head_2;
                ADDR_SQ_TAIL_3:       rdata <= sq_tail_3;
                ADDR_CQ_HEAD_3:       rdata <= cq_head_3;
                ADDR_SQ_TAIL_4:       rdata <= sq_tail_4;
                ADDR_CQ_HEAD_4:       rdata <= cq_head_4;
                ADDR_SQ_TAIL_5:       rdata <= sq_tail_5;
                ADDR_CQ_HEAD_5:       rdata <= cq_head_5;
                ADDR_SQ_TAIL_6:       rdata <= sq_tail_6;
                ADDR_CQ_HEAD_6:       rdata <= cq_head_6;
                ADDR_SQ_TAIL_7:       rdata <= sq_tail_7;
                ADDR_CQ_HEAD_7:       rdata <= cq_head_7;   
                ADDR_SQ_TAIL_8:       rdata <= sq_tail_8;
                ADDR_CQ_HEAD_8:       rdata <= cq_head_8;
                ADDR_SQ_TAIL_9:       rdata <= sq_tail_9;
                ADDR_CQ_HEAD_9:       rdata <= cq_head_9;
                ADDR_SQ_TAIL_10:      rdata <= sq_tail_10;
                ADDR_CQ_HEAD_10:      rdata <= cq_head_10;
                ADDR_SQ_TAIL_11:      rdata <= sq_tail_11;
                ADDR_CQ_HEAD_11:      rdata <= cq_head_11;
                ADDR_SQ_TAIL_12:      rdata <= sq_tail_12;
                ADDR_CQ_HEAD_12:      rdata <= cq_head_12;
                ADDR_SQ_TAIL_13:      rdata <= sq_tail_13;
                ADDR_CQ_HEAD_13:      rdata <= cq_head_13;
                ADDR_SQ_TAIL_14:      rdata <= sq_tail_14;
                ADDR_CQ_HEAD_14:      rdata <= cq_head_14;
                ADDR_SQ_TAIL_15:      rdata <= sq_tail_15;
                ADDR_CQ_HEAD_15:      rdata <= cq_head_15;  
                ADDR_SQ_TAIL_16:      rdata <= sq_tail_16;
                ADDR_CQ_HEAD_16:      rdata <= cq_head_16;  
                default:              rdata <= 32'h0;            
            endcase
        end
    end
end


//------------------------Register logic-----------------
//assign int_csts_rdy = nvme_reg_csts_rdy;

// irq_mask
always @(posedge aclk) begin
    if (areset)
        irq_mask <= 32'b0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_INTMS)
            irq_mask <= irq_mask | (axil_wdata & wmask); // Set
        else if (w_hs && waddr == ADDR_INTMC)
            irq_mask <= irq_mask & (~(axil_wdata & wmask)); // Clear
    end
end


// int_cc_iocqes
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        int_cc_iocqes <= 4'h4;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CC && axil_wstrb[2])
            int_cc_iocqes <=  axil_wdata[23:20];
    end
end

// int_cc_iosqes
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        int_cc_iosqes <= 4'h6;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CC && axil_wstrb[2])
            int_cc_iosqes <=  axil_wdata[19:16];
    end
end

// int_cc_shn
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        int_cc_shn <= 2'b0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CC && axil_wstrb[1])
            int_cc_shn <=  axil_wdata[15:14];
    end
end

assign nvme_reg_cc_shn = int_cc_shn;

// int_cc_ams
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        int_cc_ams <= 3'b0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CC && axil_wstrb[1])
            int_cc_ams <=  axil_wdata[13:11];
    end
end

// int_cc_mps
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        int_cc_mps <= 4'b0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CC)
            int_cc_mps <=  axil_wdata[10:7] & ({axil_wstrb[1],axil_wstrb[1],axil_wstrb[1], axil_wstrb[0]});
    end
end

always @(posedge aclk) mps_width <= int_cc_mps + 8'hc;

// int_cc_css
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        int_cc_css <= 3'b0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CC && axil_wstrb[0])
            int_cc_css <=  axil_wdata[6:4];
    end
end

// int_cc_en
always @(posedge aclk) begin
    if (areset)
        int_cc_en <= 1'b0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CC && axil_wstrb[0])
            int_cc_en <=  axil_wdata[0];
    end
end

assign nvme_reg_cc_en = int_cc_en;

// int_csts_nssro
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        int_csts_nssro <= 1'b0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CSTS && axil_wstrb[0])
            int_csts_nssro <=  int_csts_nssro & (~axil_wdata[4]);  // RWC
    end
end


// int_nssrc
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        int_nssrc <= 32'b0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_NSSR)
            int_nssrc <=  axil_wdata & wmask;  
    end
end


// int_dma_soft_rstn
always @(posedge aclk) begin
    if (aclk_en) begin
        if (w_hs && waddr == ADDR_NSSR && ((axil_wdata & wmask) == 32'h4e564d65))
            int_dma_soft_rst <=  1'b1;
        else 
            int_dma_soft_rst <= 1'b0;
    end
end

reg flag = 1'b0;
reg [15:0] cnt = 16'h0;
always @(posedge aclk) begin
    if (int_dma_soft_rst & (~flag)) begin
        flag <= 1'b1;
        cnt  <= 16'h0;
    end else if(flag & (cnt < 16'd250)) begin
        flag <= 1'b1;
        cnt  <= cnt + 16'h1;
    end else if(flag) begin
        flag <= 1'b0;
        cnt  <= 16'h0;
    end
end

//assign dma_soft_rstn = ~flag;
always @(posedge aclk) dma_soft_rstn <= ~flag;



// int_acqs
always @(posedge aclk) begin
    if (areset)
        int_acqs <= 12'b0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_AQA)
            int_acqs <= axil_wdata[27:16] & ({{4{axil_wstrb[3]}}, {8{axil_wstrb[2]}}});
    end
end

always @(posedge aclk) begin
    if (areset)
        cq_size_0 <= 16'b0;
    else if (aclk_en) begin
        cq_size_0 <= int_acqs + 16'h1;
    end
end

//assign cq_size_0 = int_acqs;

// int_asqs
always @(posedge aclk) begin
    if (areset)
        int_asqs <= 12'b0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_AQA)
            int_asqs <= axil_wdata[11:0] & ({{4{axil_wstrb[1]}}, {8{axil_wstrb[0]}}});
    end
end


always @(posedge aclk) begin
    if (areset)
        sq_size_0 <= 16'b0;
    else if (aclk_en) begin
        sq_size_0 <= int_asqs + 16'h1;
    end
end

//assign sq_size_0 = int_asqs;

// int_asqb
//always @(posedge aclk) begin
//    if (areset)
//        int_asqb[31:0] <= 32'b0;
//    else if (aclk_en) begin
//        if (w_hs && waddr == ADDR_ASQL)
//            int_asqb[31:12] <= axil_wdata[31:12] & ({{8{axil_wstrb[3]}}, {8{axil_wstrb[2]}}, {4{axil_wstrb[1]}}});
//    end
//end

always @(posedge aclk) begin
    if (areset)
        int_asqb[31:0] <= 32'b0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_ASQL)
            int_asqb[31:0] <= axil_wdata & wmask;
    end
end

// int_asqb
always @(posedge aclk) begin
    if (areset)
        int_asqb[63:32] <= 32'b0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_ASQH)
            int_asqb[63:32] <= axil_wdata & wmask;
    end
end

assign o_sq_base_addr_0 = int_asqb;

// int_acqb
always @(posedge aclk) begin
    if (areset)
        int_acqb[31:0] <= 32'b0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_ACQL)
            int_acqb[31:0] <= axil_wdata & wmask;
//            int_acqb[31:12] <= axil_wdata[31:12] & ({{8{axil_wstrb[3]}}, {8{axil_wstrb[2]}}, {4{axil_wstrb[1]}}});
    end
end

// int_acqb
always @(posedge aclk) begin
    if (areset)
        int_acqb[63:32] <= 32'b0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_ACQH)
            int_acqb[63:32] <= axil_wdata & wmask;
    end
end

assign o_cq_base_addr_0 = int_acqb;




// sq_tail_0[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        sq_tail_0 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_SQ_TAIL_0)
            sq_tail_0 <= (axil_wdata & wmask) | (sq_tail_0 & ~wmask);
    end
end


// cq_head_0[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        cq_head_0 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CQ_HEAD_0)
            cq_head_0 <= (axil_wdata & wmask) | (cq_head_0 & ~wmask);
    end
end


// sq_tail_1[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        sq_tail_1 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_SQ_TAIL_1)
            sq_tail_1 <= (axil_wdata & wmask) | (sq_tail_1 & ~wmask);
    end
end


// cq_head_1[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        cq_head_1 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CQ_HEAD_1)
            cq_head_1 <= (axil_wdata & wmask) | (cq_head_1 & ~wmask);
    end
end


// sq_tail_2[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        sq_tail_2 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_SQ_TAIL_2)
            sq_tail_2 <= (axil_wdata & wmask) | (sq_tail_2 & ~wmask);
    end
end


// cq_head_2[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        cq_head_2 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CQ_HEAD_2)
            cq_head_2 <= (axil_wdata & wmask) | (cq_head_2 & ~wmask);
    end
end


// sq_tail_3[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        sq_tail_3 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_SQ_TAIL_3)
            sq_tail_3 <= (axil_wdata & wmask) | (sq_tail_3 & ~wmask);
    end
end


// cq_head_3[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        cq_head_3 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CQ_HEAD_3)
            cq_head_3 <= (axil_wdata & wmask) | (cq_head_3 & ~wmask);
    end
end


// sq_tail_4[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        sq_tail_4 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_SQ_TAIL_4)
            sq_tail_4 <= (axil_wdata & wmask) | (sq_tail_4 & ~wmask);
    end
end


// cq_head_4[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        cq_head_4 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CQ_HEAD_4)
            cq_head_4 <= (axil_wdata & wmask) | (cq_head_4 & ~wmask);
    end
end


// sq_tail_5[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        sq_tail_5 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_SQ_TAIL_5)
            sq_tail_5 <= (axil_wdata & wmask) | (sq_tail_5 & ~wmask);
    end
end


// cq_head_5[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        cq_head_5 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CQ_HEAD_5)
            cq_head_5 <= (axil_wdata & wmask) | (cq_head_5 & ~wmask);
    end
end


// sq_tail_6[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        sq_tail_6 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_SQ_TAIL_6)
            sq_tail_6 <= (axil_wdata & wmask) | (sq_tail_6 & ~wmask);
    end
end

// cq_head_6[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        cq_head_6 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CQ_HEAD_6)
            cq_head_6 <= (axil_wdata & wmask) | (cq_head_6 & ~wmask);
    end
end


// sq_tail_7[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        sq_tail_7 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_SQ_TAIL_7)
            sq_tail_7 <= (axil_wdata & wmask) | (sq_tail_7 & ~wmask);
    end
end

// cq_head_7[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        cq_head_7 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CQ_HEAD_7)
            cq_head_7 <= (axil_wdata & wmask) | (cq_head_7 & ~wmask);
    end
end


// sq_tail_8[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        sq_tail_8 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_SQ_TAIL_8)
            sq_tail_8 <= (axil_wdata & wmask) | (sq_tail_8 & ~wmask);
    end
end


// cq_head_8[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        cq_head_8 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CQ_HEAD_8)
            cq_head_8 <= (axil_wdata & wmask) | (cq_head_8 & ~wmask);
    end
end

// sq_tail_9[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        sq_tail_9 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_SQ_TAIL_9)
            sq_tail_9 <= (axil_wdata & wmask) | (sq_tail_9 & ~wmask);
    end
end

// cq_head_9[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        cq_head_9 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CQ_HEAD_9)
            cq_head_9 <= (axil_wdata & wmask) | (cq_head_9 & ~wmask);
    end
end

// sq_tail_10[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        sq_tail_10 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_SQ_TAIL_10)
            sq_tail_10 <= (axil_wdata & wmask) | (sq_tail_10 & ~wmask);
    end
end


// cq_head_10[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        cq_head_10 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CQ_HEAD_10)
            cq_head_10 <= (axil_wdata & wmask) | (cq_head_10 & ~wmask);
    end
end


// sq_tail_11[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        sq_tail_11 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_SQ_TAIL_11)
            sq_tail_11 <= (axil_wdata & wmask) | (sq_tail_11 & ~wmask);
    end
end


// cq_head_11[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        cq_head_11 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CQ_HEAD_11)
            cq_head_11 <= (axil_wdata & wmask) | (cq_head_11 & ~wmask);
    end
end

// sq_tail_12[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        sq_tail_12 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_SQ_TAIL_12)
            sq_tail_12 <= (axil_wdata & wmask) | (sq_tail_12 & ~wmask);
    end
end


// cq_head_12[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        cq_head_12 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CQ_HEAD_12)
            cq_head_12 <= (axil_wdata & wmask) | (cq_head_12 & ~wmask);
    end
end

// sq_tail_13[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        sq_tail_13 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_SQ_TAIL_13)
            sq_tail_13 <= (axil_wdata & wmask) | (sq_tail_13 & ~wmask);
    end
end

// cq_head_13[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        cq_head_13 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CQ_HEAD_13)
            cq_head_13 <= (axil_wdata & wmask) | (cq_head_13 & ~wmask);
    end
end


// sq_tail_14[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        sq_tail_14 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_SQ_TAIL_14)
            sq_tail_14 <= (axil_wdata & wmask) | (sq_tail_14 & ~wmask);
    end
end


// cq_head_14[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        cq_head_14 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CQ_HEAD_14)
            cq_head_14 <= (axil_wdata & wmask) | (cq_head_14 & ~wmask);
    end
end


// sq_tail_15[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        sq_tail_15 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_SQ_TAIL_15)
            sq_tail_15 <= (axil_wdata & wmask) | (sq_tail_15 & ~wmask);
    end
end

// cq_head_15[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        cq_head_15 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CQ_HEAD_15)
            cq_head_15 <= (axil_wdata & wmask) | (cq_head_15 & ~wmask);
    end
end

// sq_tail_16[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        sq_tail_16 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_SQ_TAIL_16)
            sq_tail_16 <= (axil_wdata & wmask) | (sq_tail_16 & ~wmask);
    end
end

// cq_head_16[31:0]
always @(posedge aclk) begin
    if (areset | nvme_cc_reset)
        cq_head_16 <= 32'h0;
    else if (aclk_en) begin
        if (w_hs && waddr == ADDR_CQ_HEAD_16)
            cq_head_16 <= (axil_wdata & wmask) | (cq_head_16 & ~wmask);
    end
end
//------------------------Memory logic-------------------




endmodule
