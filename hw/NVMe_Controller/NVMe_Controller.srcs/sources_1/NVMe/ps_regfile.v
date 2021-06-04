`timescale 1ns/1ps
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
// Create Date: 2020/10/11
// Design Name: 
// Module Name: ps_regfile
// Project Name: NVMe Controller
// Target Devices: KCU105
// Description: 
// 				Register File for PS
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ps_regfile (
    // BRAM Ports
    input               bp_clk,
    input               bp_rst,
    input               bp_en,
    input      [ 3:0]   bp_we,
    input      [15:0]   bp_addr,
    input      [31:0]   bp_wrdata,
    output reg [31:0]   bp_rddata,
    
    // registers
    input               nvme_reg_cc_en,
    output reg          ps_csts_rdy,
    input      [ 1:0]   nvme_reg_cc_shn,
    output reg [ 1:0]   ps_csts_shst,
    
    // DMA descriptor info
    output reg [31:0]   asq_dsc_ctl, // [0] load, trace rising edge
    output reg [31:0]   asq_dsc_len,
    output reg [63:0]   asq_dsc_addr,
    output reg [31:0]   acq_dsc_ctl,
    output reg [31:0]   acq_dsc_len,
    output reg [63:0]   acq_dsc_addr,
  
    // NVMe admin sq & cq regs
    input      [ 7:0]   asq_buf_wr_ptr,
    input      [ 7:0]   acq_buf_rd_ptr,
    input               h2c_dma_trans_done,
    input               c2h_dma_trans_done,
    // NVMe I/O sq & cq reset
    output reg [31:0]   sq_reset,
    output reg [31:0]   cq_reset,
    // NVMe IO CQ Interruput enable
    output reg [31:0]   iocq_irq_enable,
    // NVMe I/O sq & cq regs
    output     [63:0]   sq_base_addr_1,
    output     [15:0]   sq_size_1,
    output     [15:0]   sq_id_1,
    output     [63:0]   cq_base_addr_1,
    output     [15:0]   cq_size_1,
    output     [15:0]   cq_id_1,
    output     [63:0]   sq_base_addr_2,
    output     [15:0]   sq_size_2,
    output     [15:0]   sq_id_2,
    output     [63:0]   cq_base_addr_2,
    output     [15:0]   cq_size_2,
    output     [15:0]   cq_id_2,
    output     [63:0]   sq_base_addr_3,
    output     [15:0]   sq_size_3,
    output     [15:0]   sq_id_3,
    output     [63:0]   cq_base_addr_3,
    output     [15:0]   cq_size_3,
    output     [15:0]   cq_id_3,
    output     [63:0]   sq_base_addr_4,
    output     [15:0]   sq_size_4,
    output     [15:0]   sq_id_4,
    output     [63:0]   cq_base_addr_4,
    output     [15:0]   cq_size_4,
    output     [15:0]   cq_id_4,
    output     [63:0]   sq_base_addr_5,
    output     [15:0]   sq_size_5,
    output     [15:0]   sq_id_5,
    output     [63:0]   cq_base_addr_5,
    output     [15:0]   cq_size_5,
    output     [15:0]   cq_id_5,
    output     [63:0]   sq_base_addr_6,
    output     [15:0]   sq_size_6,
    output     [15:0]   sq_id_6,
    output     [63:0]   cq_base_addr_6,
    output     [15:0]   cq_size_6,
    output     [15:0]   cq_id_6,
    output     [63:0]   sq_base_addr_7,
    output     [15:0]   sq_size_7,
    output     [15:0]   sq_id_7,
    output     [63:0]   cq_base_addr_7,
    output     [15:0]   cq_size_7,
    output     [15:0]   cq_id_7,
    output     [63:0]   sq_base_addr_8,
    output     [15:0]   sq_size_8,
    output     [15:0]   sq_id_8,
    output     [63:0]   cq_base_addr_8,
    output     [15:0]   cq_size_8,
    output     [15:0]   cq_id_8,
    output     [63:0]   sq_base_addr_9,
    output     [15:0]   sq_size_9,
    output     [15:0]   sq_id_9,
    output     [63:0]   cq_base_addr_9,
    output     [15:0]   cq_size_9,
    output     [15:0]   cq_id_9,
    output     [63:0]   sq_base_addr_10,
    output     [15:0]   sq_size_10,
    output     [15:0]   sq_id_10,
    output     [63:0]   cq_base_addr_10,
    output     [15:0]   cq_size_10,
    output     [15:0]   cq_id_10,
    output     [63:0]   sq_base_addr_11,
    output     [15:0]   sq_size_11,
    output     [15:0]   sq_id_11,
    output     [63:0]   cq_base_addr_11,
    output     [15:0]   cq_size_11,
    output     [15:0]   cq_id_11,
    output     [63:0]   sq_base_addr_12,
    output     [15:0]   sq_size_12,
    output     [15:0]   sq_id_12,
    output     [63:0]   cq_base_addr_12,
    output     [15:0]   cq_size_12,
    output     [15:0]   cq_id_12,
    output     [63:0]   sq_base_addr_13,
    output     [15:0]   sq_size_13,
    output     [15:0]   sq_id_13,
    output     [63:0]   cq_base_addr_13,
    output     [15:0]   cq_size_13,
    output     [15:0]   cq_id_13,
    output     [63:0]   sq_base_addr_14,
    output     [15:0]   sq_size_14,
    output     [15:0]   sq_id_14,
    output     [63:0]   cq_base_addr_14,
    output     [15:0]   cq_size_14,
    output     [15:0]   cq_id_14,
    output     [63:0]   sq_base_addr_15,
    output     [15:0]   sq_size_15,
    output     [15:0]   sq_id_15,
    output     [63:0]   cq_base_addr_15,
    output     [15:0]   cq_size_15,
    output     [15:0]   cq_id_15,
    output     [63:0]   sq_base_addr_16,
    output     [15:0]   sq_size_16,
    output     [15:0]   sq_id_16,
    output     [63:0]   cq_base_addr_16,
    output     [15:0]   cq_size_16,
    output     [15:0]   cq_id_16
);

localparam
    IO_QUEUE_NUM         = 16,
    ADDR_ASQ_DSC_CTL     = 16'h0000,
    ADDR_ASQ_DSC_LEN     = 16'h0004,
    ADDR_ASQ_DSC_ADDRL   = 16'h0008,
    ADDR_ASQ_DSC_ADDRH   = 16'h000C,
    ADDR_ACQ_DSC_CTL     = 16'h0010,
    ADDR_ACQ_DSC_LEN     = 16'h0014,
    ADDR_ACQ_DSC_ADDRL   = 16'h0018,
    ADDR_ACQ_DSC_ADDRH   = 16'h001C,
    ADDR_REG_CC_EN       = 16'h0020,
    ADDR_CSTS_RDY        = 16'h0024,
    ADDR_REG_CC_SHN      = 16'h0028,
    ADDR_CSTS_SHST       = 16'h002C,
    ADDR_ASQ_BUF_WPTR    = 16'h0040,
    ADDR_ACQ_BUF_RPTR    = 16'h0044,
    ADDR_H2C_DMA_STATUS  = 16'h0048,
    ADDR_C2H_DMA_STATUS  = 16'h004C,
    ADDR_SQ_RESET        = 16'h0070,
    ADDR_CQ_RESET        = 16'h0074,
    ADDR_IOCQ_IRQ_ENABLE = 16'h0078,
    ADDR_IO_QUEUE        = 16'h0080;

genvar i;
reg [63:0] sq_base_addr [IO_QUEUE_NUM-1 : 0];
reg [15:0] sq_size      [IO_QUEUE_NUM-1 : 0];
reg [15:0] sq_id        [IO_QUEUE_NUM-1 : 0];
reg [63:0] cq_base_addr [IO_QUEUE_NUM-1 : 0];
reg [15:0] cq_size      [IO_QUEUE_NUM-1 : 0];
reg [15:0] cq_id        [IO_QUEUE_NUM-1 : 0];


assign sq_base_addr_1   = sq_base_addr[0]; 
assign sq_size_1        = sq_size[0];      
assign sq_id_1          = sq_id[0];        
assign cq_base_addr_1   = cq_base_addr[0]; 
assign cq_size_1        = cq_size[0];      
assign cq_id_1          = cq_id[0];        
assign sq_base_addr_2   = sq_base_addr[1]; 
assign sq_size_2        = sq_size[1];      
assign sq_id_2          = sq_id[1];        
assign cq_base_addr_2   = cq_base_addr[1]; 
assign cq_size_2        = cq_size[1];      
assign cq_id_2          = cq_id[1];        
assign sq_base_addr_3   = sq_base_addr[2]; 
assign sq_size_3        = sq_size[2];      
assign sq_id_3          = sq_id[2];        
assign cq_base_addr_3   = cq_base_addr[2]; 
assign cq_size_3        = cq_size[2];      
assign cq_id_3          = cq_id[2];        
assign sq_base_addr_4   = sq_base_addr[3]; 
assign sq_size_4        = sq_size[3];      
assign sq_id_4          = sq_id[3];        
assign cq_base_addr_4   = cq_base_addr[3]; 
assign cq_size_4        = cq_size[3];      
assign cq_id_4          = cq_id[3];        
assign sq_base_addr_5   = sq_base_addr[4]; 
assign sq_size_5        = sq_size[4];      
assign sq_id_5          = sq_id[4];        
assign cq_base_addr_5   = cq_base_addr[4]; 
assign cq_size_5        = cq_size[4];      
assign cq_id_5          = cq_id[4];        
assign sq_base_addr_6   = sq_base_addr[5]; 
assign sq_size_6        = sq_size[5];      
assign sq_id_6          = sq_id[5];        
assign cq_base_addr_6   = cq_base_addr[5]; 
assign cq_size_6        = cq_size[5];      
assign cq_id_6          = cq_id[5];        
assign sq_base_addr_7   = sq_base_addr[6]; 
assign sq_size_7        = sq_size[6];      
assign sq_id_7          = sq_id[6];        
assign cq_base_addr_7   = cq_base_addr[6]; 
assign cq_size_7        = cq_size[6];      
assign cq_id_7          = cq_id[6];        
assign sq_base_addr_8   = sq_base_addr[7]; 
assign sq_size_8        = sq_size[7];      
assign sq_id_8          = sq_id[7];        
assign cq_base_addr_8   = cq_base_addr[7]; 
assign cq_size_8        = cq_size[7];      
assign cq_id_8          = cq_id[7];        
assign sq_base_addr_9   = sq_base_addr[8]; 
assign sq_size_9        = sq_size[8];      
assign sq_id_9          = sq_id[8];        
assign cq_base_addr_9   = cq_base_addr[8]; 
assign cq_size_9        = cq_size[8];      
assign cq_id_9          = cq_id[8];        
assign sq_base_addr_10  = sq_base_addr[9]; 
assign sq_size_10       = sq_size[9];      
assign sq_id_10         = sq_id[9];        
assign cq_base_addr_10  = cq_base_addr[9]; 
assign cq_size_10       = cq_size[9];      
assign cq_id_10         = cq_id[9];        
assign sq_base_addr_11  = sq_base_addr[10];
assign sq_size_11       = sq_size[10];     
assign sq_id_11         = sq_id[10];       
assign cq_base_addr_11  = cq_base_addr[10];
assign cq_size_11       = cq_size[10];     
assign cq_id_11         = cq_id[10];       
assign sq_base_addr_12  = sq_base_addr[11];
assign sq_size_12       = sq_size[11];     
assign sq_id_12         = sq_id[11];       
assign cq_base_addr_12  = cq_base_addr[11];
assign cq_size_12       = cq_size[11];     
assign cq_id_12         = cq_id[11];       
assign sq_base_addr_13  = sq_base_addr[12];
assign sq_size_13       = sq_size[12];     
assign sq_id_13         = sq_id[12];       
assign cq_base_addr_13  = cq_base_addr[12];
assign cq_size_13       = cq_size[12];     
assign cq_id_13         = cq_id[12];       
assign sq_base_addr_14  = sq_base_addr[13];
assign sq_size_14       = sq_size[13];     
assign sq_id_14         = sq_id[13];       
assign cq_base_addr_14  = cq_base_addr[13];
assign cq_size_14       = cq_size[13];     
assign cq_id_14         = cq_id[13];       
assign sq_base_addr_15  = sq_base_addr[14];
assign sq_size_15       = sq_size[14];     
assign sq_id_15         = sq_id[14];       
assign cq_base_addr_15  = cq_base_addr[14];
assign cq_size_15       = cq_size[14];     
assign cq_id_15         = cq_id[14];       
assign sq_base_addr_16  = sq_base_addr[15];
assign sq_size_16       = sq_size[15];     
assign sq_id_16         = sq_id[15];       
assign cq_base_addr_16  = cq_base_addr[15];
assign cq_size_16       = cq_size[15];     
assign cq_id_16         = cq_id[15];       
             

// read latency: 1 cycles
always@(posedge bp_clk or posedge bp_rst)
begin
    if(bp_rst)
        bp_rddata <= 32'h0;
    else if(bp_en & (bp_we == 4'h0)) begin
        case(bp_addr)
            ADDR_ASQ_DSC_CTL          : bp_rddata <= asq_dsc_ctl;
            ADDR_ASQ_DSC_LEN          : bp_rddata <= asq_dsc_len;
            ADDR_ASQ_DSC_ADDRL        : bp_rddata <= asq_dsc_addr[31:0];
            ADDR_ASQ_DSC_ADDRH        : bp_rddata <= asq_dsc_addr[63:32];
            ADDR_ACQ_DSC_CTL          : bp_rddata <= acq_dsc_ctl;        
            ADDR_ACQ_DSC_LEN          : bp_rddata <= acq_dsc_len;        
            ADDR_ACQ_DSC_ADDRL        : bp_rddata <= acq_dsc_addr[31:0]; 
            ADDR_ACQ_DSC_ADDRH        : bp_rddata <= acq_dsc_addr[63:32];
            ADDR_REG_CC_EN            : bp_rddata <= {31'h0, nvme_reg_cc_en};
            ADDR_CSTS_RDY             : bp_rddata <= {31'h0, ps_csts_rdy};
            ADDR_REG_CC_SHN           : bp_rddata <= {30'h0, nvme_reg_cc_shn};
            ADDR_CSTS_SHST            : bp_rddata <= {30'h0, ps_csts_shst};
            ADDR_ASQ_BUF_WPTR         : bp_rddata <= asq_buf_wr_ptr;
            ADDR_ACQ_BUF_RPTR         : bp_rddata <= acq_buf_rd_ptr;
            ADDR_H2C_DMA_STATUS       : bp_rddata <= h2c_dma_trans_done;
            ADDR_C2H_DMA_STATUS       : bp_rddata <= c2h_dma_trans_done;
            ADDR_SQ_RESET             : bp_rddata <= sq_reset;   
            ADDR_CQ_RESET             : bp_rddata <= cq_reset;
            ADDR_IOCQ_IRQ_ENABLE      : bp_rddata <= iocq_irq_enable;
           (ADDR_IO_QUEUE + 16'h00)   : bp_rddata <= sq_base_addr[0][31:0];
           (ADDR_IO_QUEUE + 16'h04)   : bp_rddata <= sq_base_addr[0][63:32];
           (ADDR_IO_QUEUE + 16'h08)   : bp_rddata <= {sq_size[0], sq_id[0]};
           (ADDR_IO_QUEUE + 16'h0C)   : bp_rddata <= cq_base_addr[0][31:0];
           (ADDR_IO_QUEUE + 16'h10)   : bp_rddata <= cq_base_addr[0][63:32];
           (ADDR_IO_QUEUE + 16'h14)   : bp_rddata <= {cq_size[0], cq_id[0]};
           (ADDR_IO_QUEUE + 16'h18)   : bp_rddata <= sq_base_addr[1][31:0];
           (ADDR_IO_QUEUE + 16'h1C)   : bp_rddata <= sq_base_addr[1][63:32];
           (ADDR_IO_QUEUE + 16'h20)   : bp_rddata <= {sq_size[1], sq_id[1]};
           (ADDR_IO_QUEUE + 16'h24)   : bp_rddata <= cq_base_addr[1][31:0];
           (ADDR_IO_QUEUE + 16'h28)   : bp_rddata <= cq_base_addr[1][63:32];
           (ADDR_IO_QUEUE + 16'h2C)   : bp_rddata <= {cq_size[1], cq_id[1]};
           (ADDR_IO_QUEUE + 16'h30)   : bp_rddata <= sq_base_addr[2][31:0];
           (ADDR_IO_QUEUE + 16'h34)   : bp_rddata <= sq_base_addr[2][63:32];
           (ADDR_IO_QUEUE + 16'h38)   : bp_rddata <= {sq_size[2], sq_id[2]};
           (ADDR_IO_QUEUE + 16'h3C)   : bp_rddata <= cq_base_addr[2][31:0];
           (ADDR_IO_QUEUE + 16'h40)   : bp_rddata <= cq_base_addr[2][63:32];
           (ADDR_IO_QUEUE + 16'h44)   : bp_rddata <= {cq_size[2], cq_id[2]};
           (ADDR_IO_QUEUE + 16'h48)   : bp_rddata <= sq_base_addr[3][31:0];
           (ADDR_IO_QUEUE + 16'h4C)   : bp_rddata <= sq_base_addr[3][63:32];
           (ADDR_IO_QUEUE + 16'h50)   : bp_rddata <= {sq_size[3], sq_id[3]};
           (ADDR_IO_QUEUE + 16'h54)   : bp_rddata <= cq_base_addr[3][31:0];
           (ADDR_IO_QUEUE + 16'h58)   : bp_rddata <= cq_base_addr[3][63:32];
           (ADDR_IO_QUEUE + 16'h5C)   : bp_rddata <= {cq_size[3], cq_id[3]};
           (ADDR_IO_QUEUE + 16'h60)   : bp_rddata <= sq_base_addr[4][31:0];
           (ADDR_IO_QUEUE + 16'h64)   : bp_rddata <= sq_base_addr[4][63:32];
           (ADDR_IO_QUEUE + 16'h68)   : bp_rddata <= {sq_size[4], sq_id[4]};
           (ADDR_IO_QUEUE + 16'h6C)   : bp_rddata <= cq_base_addr[4][31:0];
           (ADDR_IO_QUEUE + 16'h70)   : bp_rddata <= cq_base_addr[4][63:32];
           (ADDR_IO_QUEUE + 16'h74)   : bp_rddata <= {cq_size[4], cq_id[4]};
           (ADDR_IO_QUEUE + 16'h78)   : bp_rddata <= sq_base_addr[5][31:0];
           (ADDR_IO_QUEUE + 16'h7C)   : bp_rddata <= sq_base_addr[5][63:32];
           (ADDR_IO_QUEUE + 16'h80)   : bp_rddata <= {sq_size[5], sq_id[5]};
           (ADDR_IO_QUEUE + 16'h84)   : bp_rddata <= cq_base_addr[5][31:0];
           (ADDR_IO_QUEUE + 16'h88)   : bp_rddata <= cq_base_addr[5][63:32];
           (ADDR_IO_QUEUE + 16'h8C)   : bp_rddata <= {cq_size[5], cq_id[5]};
           (ADDR_IO_QUEUE + 16'h90)   : bp_rddata <= sq_base_addr[6][31:0];
           (ADDR_IO_QUEUE + 16'h94)   : bp_rddata <= sq_base_addr[6][63:32];
           (ADDR_IO_QUEUE + 16'h98)   : bp_rddata <= {sq_size[6], sq_id[6]};
           (ADDR_IO_QUEUE + 16'h9C)   : bp_rddata <= cq_base_addr[6][31:0];
           (ADDR_IO_QUEUE + 16'hA0)   : bp_rddata <= cq_base_addr[6][63:32];
           (ADDR_IO_QUEUE + 16'hA4)   : bp_rddata <= {cq_size[6], cq_id[6]};
           (ADDR_IO_QUEUE + 16'hA8)   : bp_rddata <= sq_base_addr[7][31:0];
           (ADDR_IO_QUEUE + 16'hAC)   : bp_rddata <= sq_base_addr[7][63:32];
           (ADDR_IO_QUEUE + 16'hB0)   : bp_rddata <= {sq_size[7], sq_id[7]};
           (ADDR_IO_QUEUE + 16'hB4)   : bp_rddata <= cq_base_addr[7][31:0];
           (ADDR_IO_QUEUE + 16'hB8)   : bp_rddata <= cq_base_addr[7][63:32];
           (ADDR_IO_QUEUE + 16'hBC)   : bp_rddata <= {cq_size[7], cq_id[7]};
           (ADDR_IO_QUEUE + 16'hC0)   : bp_rddata <= sq_base_addr[8][31:0];
           (ADDR_IO_QUEUE + 16'hC4)   : bp_rddata <= sq_base_addr[8][63:32];
           (ADDR_IO_QUEUE + 16'hC8)   : bp_rddata <= {sq_size[8], sq_id[8]};
           (ADDR_IO_QUEUE + 16'hCC)   : bp_rddata <= cq_base_addr[8][31:0];
           (ADDR_IO_QUEUE + 16'hD0)   : bp_rddata <= cq_base_addr[8][63:32];
           (ADDR_IO_QUEUE + 16'hD4)   : bp_rddata <= {cq_size[8], cq_id[8]};
           (ADDR_IO_QUEUE + 16'hD8)   : bp_rddata <= sq_base_addr[9][31:0];
           (ADDR_IO_QUEUE + 16'hDC)   : bp_rddata <= sq_base_addr[9][63:32];
           (ADDR_IO_QUEUE + 16'hE0)   : bp_rddata <= {sq_size[9], sq_id[9]};
           (ADDR_IO_QUEUE + 16'hE4)   : bp_rddata <= cq_base_addr[9][31:0];
           (ADDR_IO_QUEUE + 16'hE8)   : bp_rddata <= cq_base_addr[9][63:32];
           (ADDR_IO_QUEUE + 16'hEC)   : bp_rddata <= {cq_size[9], cq_id[9]};
           (ADDR_IO_QUEUE + 16'hF0)   : bp_rddata <= sq_base_addr[10][31:0];
           (ADDR_IO_QUEUE + 16'hF4)   : bp_rddata <= sq_base_addr[10][63:32];
           (ADDR_IO_QUEUE + 16'hF8)   : bp_rddata <= {sq_size[10], sq_id[10]};
           (ADDR_IO_QUEUE + 16'hFC)   : bp_rddata <= cq_base_addr[10][31:0];
           (ADDR_IO_QUEUE + 16'h100)  : bp_rddata <= cq_base_addr[10][63:32];
           (ADDR_IO_QUEUE + 16'h104)  : bp_rddata <= {cq_size[10], cq_id[10]};
           (ADDR_IO_QUEUE + 16'h108)  : bp_rddata <= sq_base_addr[11][31:0];
           (ADDR_IO_QUEUE + 16'h10C)  : bp_rddata <= sq_base_addr[11][63:32];
           (ADDR_IO_QUEUE + 16'h110)  : bp_rddata <= {sq_size[11], sq_id[11]};
           (ADDR_IO_QUEUE + 16'h114)  : bp_rddata <= cq_base_addr[11][31:0];
           (ADDR_IO_QUEUE + 16'h118)  : bp_rddata <= cq_base_addr[11][63:32];
           (ADDR_IO_QUEUE + 16'h11C)  : bp_rddata <= {cq_size[11], cq_id[11]};
           (ADDR_IO_QUEUE + 16'h120)  : bp_rddata <= sq_base_addr[12][31:0];
           (ADDR_IO_QUEUE + 16'h124)  : bp_rddata <= sq_base_addr[12][63:32];
           (ADDR_IO_QUEUE + 16'h128)  : bp_rddata <= {sq_size[12], sq_id[12]};
           (ADDR_IO_QUEUE + 16'h12C)  : bp_rddata <= cq_base_addr[12][31:0];
           (ADDR_IO_QUEUE + 16'h130)  : bp_rddata <= cq_base_addr[12][63:32];
           (ADDR_IO_QUEUE + 16'h134)  : bp_rddata <= {cq_size[12], cq_id[12]};
           (ADDR_IO_QUEUE + 16'h138)  : bp_rddata <= sq_base_addr[13][31:0];
           (ADDR_IO_QUEUE + 16'h13C)  : bp_rddata <= sq_base_addr[13][63:32];
           (ADDR_IO_QUEUE + 16'h140)  : bp_rddata <= {sq_size[13], sq_id[13]};
           (ADDR_IO_QUEUE + 16'h144)  : bp_rddata <= cq_base_addr[13][31:0];
           (ADDR_IO_QUEUE + 16'h148)  : bp_rddata <= cq_base_addr[13][63:32];
           (ADDR_IO_QUEUE + 16'h14C)  : bp_rddata <= {cq_size[13], cq_id[13]};
           (ADDR_IO_QUEUE + 16'h150)  : bp_rddata <= sq_base_addr[14][31:0];
           (ADDR_IO_QUEUE + 16'h154)  : bp_rddata <= sq_base_addr[14][63:32];
           (ADDR_IO_QUEUE + 16'h158)  : bp_rddata <= {sq_size[14], sq_id[14]};
           (ADDR_IO_QUEUE + 16'h15C)  : bp_rddata <= cq_base_addr[14][31:0];
           (ADDR_IO_QUEUE + 16'h160)  : bp_rddata <= cq_base_addr[14][63:32];
           (ADDR_IO_QUEUE + 16'h164)  : bp_rddata <= {cq_size[14], cq_id[14]};
           (ADDR_IO_QUEUE + 16'h168)  : bp_rddata <= sq_base_addr[15][31:0];
           (ADDR_IO_QUEUE + 16'h16C)  : bp_rddata <= sq_base_addr[15][63:32];
           (ADDR_IO_QUEUE + 16'h170)  : bp_rddata <= {sq_size[15], sq_id[15]};
           (ADDR_IO_QUEUE + 16'h174)  : bp_rddata <= cq_base_addr[15][31:0];
           (ADDR_IO_QUEUE + 16'h178)  : bp_rddata <= cq_base_addr[15][63:32];
           (ADDR_IO_QUEUE + 16'h17C)  : bp_rddata <= {cq_size[15], cq_id[15]};        
            default: bp_rddata <= 32'h0;
        endcase
    end  
        
end



// Admin SQ DMA descriptor control register
always@(posedge bp_clk or posedge bp_rst)
begin
    if(bp_rst)
        asq_dsc_ctl <= 32'h0;
    else if(bp_en & (bp_we != 4'h0) & (bp_addr == ADDR_ASQ_DSC_CTL))  
        asq_dsc_ctl <= bp_wrdata;
end


// Admin SQ DMA descriptor length register
always@(posedge bp_clk or posedge bp_rst)
begin
    if(bp_rst)
        asq_dsc_len <= 32'h0;
    else if(bp_en & (bp_we != 4'h0) & (bp_addr == ADDR_ASQ_DSC_LEN))  
        asq_dsc_len <= bp_wrdata;
end


// Admin SQ DMA descriptor host address register, low 32b
always@(posedge bp_clk or posedge bp_rst)
begin
    if(bp_rst)
        asq_dsc_addr[31:0] <= 32'h0;
    else if(bp_en & (bp_we != 4'h0) & (bp_addr == ADDR_ASQ_DSC_ADDRL))  
        asq_dsc_addr[31:0] <= bp_wrdata;
end


// Admin SQ DMA descriptor host address register, high 32b
always@(posedge bp_clk or posedge bp_rst)
begin
    if(bp_rst)
        asq_dsc_addr[63:32] <= 32'h0;
    else if(bp_en & (bp_we != 4'h0) & (bp_addr == ADDR_ASQ_DSC_ADDRH))  
        asq_dsc_addr[63:32] <= bp_wrdata;
end


// Admin CQ DMA descriptor control register
always@(posedge bp_clk or posedge bp_rst)
begin
    if(bp_rst)
        acq_dsc_ctl <= 32'h0;
    else if(bp_en & (bp_we != 4'h0) & (bp_addr == ADDR_ACQ_DSC_CTL))  
        acq_dsc_ctl <= bp_wrdata;
end


// Admin CQ DMA descriptor length register
always@(posedge bp_clk or posedge bp_rst)
begin
    if(bp_rst)
        acq_dsc_len <= 32'h0;
    else if(bp_en & (bp_we != 4'h0) & (bp_addr == ADDR_ACQ_DSC_LEN))  
        acq_dsc_len <= bp_wrdata;
end


// Admin CQ DMA descriptor host address register, low 32b
always@(posedge bp_clk or posedge bp_rst)
begin
    if(bp_rst)
        acq_dsc_addr[31:0] <= 32'h0;
    else if(bp_en & (bp_we != 4'h0) & (bp_addr == ADDR_ACQ_DSC_ADDRL))  
        acq_dsc_addr[31:0] <= bp_wrdata;
end


// Admin CQ DMA descriptor host address register, high 32b
always@(posedge bp_clk or posedge bp_rst)
begin
    if(bp_rst)
        acq_dsc_addr[63:32] <= 32'h0;
    else if(bp_en & (bp_we != 4'h0) & (bp_addr == ADDR_ACQ_DSC_ADDRH))  
        acq_dsc_addr[63:32] <= bp_wrdata;
end


// NVMe CSTS Ready
always@(posedge bp_clk or posedge bp_rst)
begin
    if(bp_rst)
        ps_csts_rdy <= 1'h0;
    else if(bp_en & (bp_we != 4'h0) & (bp_addr == ADDR_CSTS_RDY))  
        ps_csts_rdy <= bp_wrdata[0];
end

// NVMe CSTS Shut dowm status
always@(posedge bp_clk or posedge bp_rst)
begin
    if(bp_rst)
        ps_csts_shst <= 2'h0;
    else if(bp_en & (bp_we != 4'h0) & (bp_addr == ADDR_CSTS_SHST))  
        ps_csts_shst <= bp_wrdata[1:0];
end


// IO SQ Reset
always@(posedge bp_clk or posedge bp_rst)
begin
    if(bp_rst)
        sq_reset <= 32'h0;
    else if(bp_en & (bp_we != 4'h0) & (bp_addr == ADDR_SQ_RESET))  
        sq_reset <= bp_wrdata;
end


// IO CQ Reset
always@(posedge bp_clk or posedge bp_rst)
begin
    if(bp_rst)
        cq_reset <= 32'h0;
    else if(bp_en & (bp_we != 4'h0) & (bp_addr == ADDR_CQ_RESET))  
        cq_reset <= bp_wrdata;
end


// IO CQ Interrupt ENABLE
always@(posedge bp_clk or posedge bp_rst)
begin
    if(bp_rst)
        iocq_irq_enable <= 32'h0;
    else if(bp_en & (bp_we != 4'h0) & (bp_addr == ADDR_IOCQ_IRQ_ENABLE))  
        iocq_irq_enable <= bp_wrdata;
end




generate for(i = 0; i < IO_QUEUE_NUM; i = i + 1) begin: ioq_regs_write
    always@(posedge bp_clk or posedge bp_rst)
    begin
        if(bp_rst)
            sq_base_addr[i][31:0] <= 32'h0;
        else if(bp_en & (bp_we != 4'h0) & (bp_addr == (ADDR_IO_QUEUE + 24*i + 0)))  
            sq_base_addr[i][31:0] <= bp_wrdata;
    end

    always@(posedge bp_clk or posedge bp_rst)
    begin
        if(bp_rst)
            sq_base_addr[i][63:32] <= 32'h0;
        else if(bp_en & (bp_we != 4'h0) & (bp_addr == (ADDR_IO_QUEUE + 24*i + 4)))  
            sq_base_addr[i][63:32] <= bp_wrdata;
    end

    always@(posedge bp_clk or posedge bp_rst)
    begin
        if(bp_rst)
            sq_size[i] <= 16'h0;
        else if(bp_en & (bp_we != 4'h0) & (bp_addr == (ADDR_IO_QUEUE + 24*i + 8)))  
            sq_size[i] <= bp_wrdata[31:16];
    end

    always@(posedge bp_clk or posedge bp_rst)
    begin
        if(bp_rst)
            sq_id[i] <= 16'h0;
        else if(bp_en & (bp_we != 4'h0) & (bp_addr == (ADDR_IO_QUEUE + 24*i + 8)))  
            sq_id[i] <= bp_wrdata[15:0];
    end

    always@(posedge bp_clk or posedge bp_rst)
    begin
        if(bp_rst)
            cq_base_addr[i][31:0] <= 32'h0;
        else if(bp_en & (bp_we != 4'h0) & (bp_addr == (ADDR_IO_QUEUE + 24*i + 12)))  
            cq_base_addr[i][31:0] <= bp_wrdata;
    end

    always@(posedge bp_clk or posedge bp_rst)
    begin
        if(bp_rst)
            cq_base_addr[i][63:32] <= 32'h0;
        else if(bp_en & (bp_we != 4'h0) & (bp_addr == (ADDR_IO_QUEUE + 24*i + 16)))  
            cq_base_addr[i][63:32] <= bp_wrdata;
    end

    always@(posedge bp_clk or posedge bp_rst)
    begin
        if(bp_rst)
            cq_size[i] <= 16'h0;
        else if(bp_en & (bp_we != 4'h0) & (bp_addr == (ADDR_IO_QUEUE + 24*i + 20)))  
            cq_size[i] <= bp_wrdata[31:16];
    end

    always@(posedge bp_clk or posedge bp_rst)
    begin
        if(bp_rst)
            cq_id[i] <= 16'h0;
        else if(bp_en & (bp_we != 4'h0) & (bp_addr == (ADDR_IO_QUEUE + 24*i + 20)))  
            cq_id[i] <= bp_wrdata[15:0];
    end

end
endgenerate






endmodule

