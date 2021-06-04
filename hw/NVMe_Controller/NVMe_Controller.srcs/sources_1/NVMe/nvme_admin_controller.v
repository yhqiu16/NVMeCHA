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
// Create Date: 03/27/2020 10:35:38 PM
// Design Name: 
// Module Name: nvme_admin_controller
// Project Name: SSD Controller
// Target Devices: 
// Tool Versions: 
// Description: NVMe Controller of Admin Queue (1 SQ + 1 CQ)
//                  SQ fetch, CQ submit
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module nvme_admin_controller #(
    parameter DATA_WIDTH = 256
)(
    input                        ps_clk_clk_n,
    input                        ps_clk_clk_p,
    input                        ps_reset,
    input                        clk,
    input                        sys_rstn,
    input                        rst_n,
    
    input                        nvme_reg_cc_en,
    output                       ps_csts_rdy,
    input  [ 1:0]                nvme_reg_cc_shn,
    output [ 1:0]                ps_csts_shst,
    // Host SQ&CQ ID
//    input  [15:0]                qid,
    // host submission queu
    input  [63:0]                sq_base_addr,
    input  [15:0]                sq_size,
    input  [15:0]                sq_tail,
    // host completion queu
    input  [63:0]                cq_base_addr,
    input  [15:0]                cq_size,
    input  [15:0]                cq_head,
    
    // C2H DMA descriptor for CQ
    input                        c2h_dsc_byp_ready,   
    output                       c2h_dsc_byp_load, 
    output [63 : 0]              c2h_dsc_byp_src_addr,   
    output [63 : 0]              c2h_dsc_byp_dst_addr,   
    output [27 : 0]              c2h_dsc_byp_len,   
    output [15 : 0]              c2h_dsc_byp_ctl,   
    // H2C DMA descriptor for SQ 
    input                        h2c_dsc_byp_ready,   
    output                       h2c_dsc_byp_load, 
    output [63 : 0]              h2c_dsc_byp_src_addr,   
    output [63 : 0]              h2c_dsc_byp_dst_addr,   
    output [27 : 0]              h2c_dsc_byp_len,   
    output [15 : 0]              h2c_dsc_byp_ctl,         
    
    // AXI ST interface to fetch cmd submission data
    output                       axis_h2c_tready,
    input                        axis_h2c_tvalid,
    input  [DATA_WIDTH-1:0]      axis_h2c_tdata,
    input  [DATA_WIDTH/8-1:0]    axis_h2c_tkeep,
    input                        axis_h2c_tlast,         
    // AXI ST interface to submit cmd completion data
    input                        axis_c2h_tready,
    output                       axis_c2h_tvalid,
    output [DATA_WIDTH-1:0]      axis_c2h_tdata,
    output [DATA_WIDTH/8-1:0]    axis_c2h_tkeep,
    output                       axis_c2h_tlast,
    // AXI-Lite interfaces to access XDMA internel registers
    output    [31:0]             m0_axi_araddr,
    output    [ 2:0]             m0_axi_arprot,
    input                        m0_axi_arready,
    output                       m0_axi_arvalid,
    output    [31:0]             m0_axi_awaddr,
    output    [ 2:0]             m0_axi_awprot,
    input                        m0_axi_awready,
    output                       m0_axi_awvalid,
    output                       m0_axi_bready,
    input     [ 1:0]             m0_axi_bresp,
    input                        m0_axi_bvalid,
    input     [31:0]             m0_axi_rdata,
    output                       m0_axi_rready,
    input     [ 1:0]             m0_axi_rresp,
    input                        m0_axi_rvalid,
    output    [31:0]             m0_axi_wdata,
    input                        m0_axi_wready,
    output    [ 3:0]             m0_axi_wstrb,
    output                       m0_axi_wvalid,
    
    // interrupt
    input                        usr_irq_enable,
    output                       usr_irq_req,
    input                        usr_irq_ack, 
    
    // NVMe I/O sq & cq reset
    output    [31:0]             sq_reset,
    output    [31:0]             cq_reset,
    // NVMe IO CQ Interruput enable
    output    [31:0]             iocq_irq_enable,
    // NVMe I/O sq & cq regs
    output    [63:0]             sq_base_addr_1,
    output    [15:0]             sq_size_1,
    output    [15:0]             sq_id_1,
    output    [63:0]             cq_base_addr_1,
    output    [15:0]             cq_size_1,
    output    [15:0]             cq_id_1,
    output    [63:0]             sq_base_addr_2,
    output    [15:0]             sq_size_2,
    output    [15:0]             sq_id_2,
    output    [63:0]             cq_base_addr_2,
    output    [15:0]             cq_size_2,
    output    [15:0]             cq_id_2,
    output    [63:0]             sq_base_addr_3,
    output    [15:0]             sq_size_3,
    output    [15:0]             sq_id_3,
    output    [63:0]             cq_base_addr_3,
    output    [15:0]             cq_size_3,
    output    [15:0]             cq_id_3,
    output    [63:0]             sq_base_addr_4,
    output    [15:0]             sq_size_4,
    output    [15:0]             sq_id_4,
    output    [63:0]             cq_base_addr_4,
    output    [15:0]             cq_size_4,
    output    [15:0]             cq_id_4,
    output    [63:0]             sq_base_addr_5,
    output    [15:0]             sq_size_5,
    output    [15:0]             sq_id_5,
    output    [63:0]             cq_base_addr_5,
    output    [15:0]             cq_size_5,
    output    [15:0]             cq_id_5,
    output    [63:0]             sq_base_addr_6,
    output    [15:0]             sq_size_6,
    output    [15:0]             sq_id_6,
    output    [63:0]             cq_base_addr_6,
    output    [15:0]             cq_size_6,
    output    [15:0]             cq_id_6,
    output    [63:0]             sq_base_addr_7,
    output    [15:0]             sq_size_7,
    output    [15:0]             sq_id_7,
    output    [63:0]             cq_base_addr_7,
    output    [15:0]             cq_size_7,
    output    [15:0]             cq_id_7,
    output    [63:0]             sq_base_addr_8,
    output    [15:0]             sq_size_8,
    output    [15:0]             sq_id_8,
    output    [63:0]             cq_base_addr_8,
    output    [15:0]             cq_size_8,
    output    [15:0]             cq_id_8,
    output    [63:0]             sq_base_addr_9,
    output    [15:0]             sq_size_9,
    output    [15:0]             sq_id_9,
    output    [63:0]             cq_base_addr_9,
    output    [15:0]             cq_size_9,
    output    [15:0]             cq_id_9,
    output    [63:0]             sq_base_addr_10,
    output    [15:0]             sq_size_10,
    output    [15:0]             sq_id_10,
    output    [63:0]             cq_base_addr_10,
    output    [15:0]             cq_size_10,
    output    [15:0]             cq_id_10,
    output    [63:0]             sq_base_addr_11,
    output    [15:0]             sq_size_11,
    output    [15:0]             sq_id_11,
    output    [63:0]             cq_base_addr_11,
    output    [15:0]             cq_size_11,
    output    [15:0]             cq_id_11,
    output    [63:0]             sq_base_addr_12,
    output    [15:0]             sq_size_12,
    output    [15:0]             sq_id_12,
    output    [63:0]             cq_base_addr_12,
    output    [15:0]             cq_size_12,
    output    [15:0]             cq_id_12,
    output    [63:0]             sq_base_addr_13,
    output    [15:0]             sq_size_13,
    output    [15:0]             sq_id_13,
    output    [63:0]             cq_base_addr_13,
    output    [15:0]             cq_size_13,
    output    [15:0]             cq_id_13,
    output    [63:0]             sq_base_addr_14,
    output    [15:0]             sq_size_14,
    output    [15:0]             sq_id_14,
    output    [63:0]             cq_base_addr_14,
    output    [15:0]             cq_size_14,
    output    [15:0]             cq_id_14,
    output    [63:0]             sq_base_addr_15,
    output    [15:0]             sq_size_15,
    output    [15:0]             sq_id_15,
    output    [63:0]             cq_base_addr_15,
    output    [15:0]             cq_size_15,
    output    [15:0]             cq_id_15,
    output    [63:0]             sq_base_addr_16,
    output    [15:0]             sq_size_16,
    output    [15:0]             sq_id_16,
    output    [63:0]             cq_base_addr_16,
    output    [15:0]             cq_size_16,
    output    [15:0]             cq_id_16,
    
    // UART Ports
    input                        UART_0_rxd,
    output                       UART_0_txd
                
);


wire          ps_bp_clk;
wire          ps_bp_rst;
wire          ps_bp_en;
wire [ 3:0]   ps_bp_we;
wire [15:0]   ps_bp_addr;
wire [31:0]   ps_bp_din;
wire [31:0]   ps_bp_dout;

wire          asq_bp_clk;
wire          asq_bp_rst;
wire          asq_bp_en;
wire [ 15:0]  asq_bp_we;
wire [ 12:0]  asq_bp_addr;
wire [127:0]  asq_bp_din;
wire [127:0]  asq_bp_dout;
wire          acq_bp_clk;
wire          acq_bp_rst;
wire          acq_bp_en;
wire [ 15:0]  acq_bp_we;
wire [ 12:0]  acq_bp_addr;
wire [127:0]  acq_bp_din;
wire [127:0]  acq_bp_dout;
wire          h2c_data_bp_clk;
wire          h2c_data_bp_rst;
wire          h2c_data_bp_en;
wire [ 15:0]  h2c_data_bp_we;
wire [ 12:0]  h2c_data_bp_addr;
wire [127:0]  h2c_data_bp_din;
wire [127:0]  h2c_data_bp_dout;
wire          c2h_data_bp_clk;
wire          c2h_data_bp_rst;
wire          c2h_data_bp_en;
wire [ 15:0]  c2h_data_bp_we;
wire [ 12:0]  c2h_data_bp_addr;
wire [127:0]  c2h_data_bp_din;
wire [127:0]  c2h_data_bp_dout;


// DMA descriptor info
wire [31:0]   asq_dsc_ctl; // [0] load; trace rising edge
wire [31:0]   asq_dsc_len;
wire [63:0]   asq_dsc_addr;
wire [31:0]   acq_dsc_ctl;
wire [31:0]   acq_dsc_len;
wire [63:0]   acq_dsc_addr;

wire [15:0]   sq_head;
wire [ 7:0]   asq_buf_wr_ptr;
wire [ 7:0]   acq_buf_rd_ptr;
wire          h2c_dma_trans_done;
wire          c2h_dma_trans_done;


wire                       q_c2h_dsc_byp_ready;   
wire                       q_c2h_dsc_byp_load; 
wire [63 : 0]              q_c2h_dsc_byp_src_addr;   
wire [63 : 0]              q_c2h_dsc_byp_dst_addr;   
wire [27 : 0]              q_c2h_dsc_byp_len;   
wire [15 : 0]              q_c2h_dsc_byp_ctl;    
wire                       q_axis_c2h_tready;
wire                       q_axis_c2h_tvalid;
wire [  DATA_WIDTH-1:0]    q_axis_c2h_tdata;
wire [  DATA_WIDTH/8-1:0]  q_axis_c2h_tkeep;
wire                       q_axis_c2h_tlast;    
    
wire                       q_h2c_dsc_byp_ready;   
wire                       q_h2c_dsc_byp_load; 
wire [63 : 0]              q_h2c_dsc_byp_src_addr;   
wire [63 : 0]              q_h2c_dsc_byp_dst_addr;   
wire [27 : 0]              q_h2c_dsc_byp_len;   
wire [15 : 0]              q_h2c_dsc_byp_ctl;    
wire                       q_axis_h2c_tready;
wire                       q_axis_h2c_tvalid;
wire [  DATA_WIDTH-1:0]    q_axis_h2c_tdata;
wire [  DATA_WIDTH/8-1:0]  q_axis_h2c_tkeep;
wire                       q_axis_h2c_tlast; 

wire                       d_c2h_dsc_byp_ready;   
wire                       d_c2h_dsc_byp_load; 
wire [63 : 0]              d_c2h_dsc_byp_src_addr;   
wire [63 : 0]              d_c2h_dsc_byp_dst_addr;   
wire [27 : 0]              d_c2h_dsc_byp_len;   
wire [15 : 0]              d_c2h_dsc_byp_ctl;    
wire                       d_axis_c2h_tready;
wire                       d_axis_c2h_tvalid;
wire [  DATA_WIDTH-1:0]    d_axis_c2h_tdata;
wire [  DATA_WIDTH/8-1:0]  d_axis_c2h_tkeep;
wire                       d_axis_c2h_tlast;    
    
wire                       d_h2c_dsc_byp_ready;   
wire                       d_h2c_dsc_byp_load; 
wire [63 : 0]              d_h2c_dsc_byp_src_addr;   
wire [63 : 0]              d_h2c_dsc_byp_dst_addr;   
wire [27 : 0]              d_h2c_dsc_byp_len;   
wire [15 : 0]              d_h2c_dsc_byp_ctl;    
wire                       d_axis_h2c_tready;
wire                       d_axis_h2c_tvalid;
wire [  DATA_WIDTH-1:0]    d_axis_h2c_tdata;
wire [  DATA_WIDTH/8-1:0]  d_axis_h2c_tkeep;
wire                       d_axis_h2c_tlast; 


ps_subsystem_wrapper ps_subsystem_inst(             
    .ps_clk_clk_n     (ps_clk_clk_n    ),
    .ps_clk_clk_p     (ps_clk_clk_p    ),
    .ps_reset         (ps_reset        ),   
    .m_axi_aclk       (clk             ),        
    .m_axi_aresetn    (sys_rstn        ),          
    .m0_axi_araddr    (m0_axi_araddr   ),          
    .m0_axi_arprot    (m0_axi_arprot   ),          
    .m0_axi_arready   (m0_axi_arready  ),           
    .m0_axi_arvalid   (m0_axi_arvalid  ),           
    .m0_axi_awaddr    (m0_axi_awaddr   ),          
    .m0_axi_awprot    (m0_axi_awprot   ),          
    .m0_axi_awready   (m0_axi_awready  ),           
    .m0_axi_awvalid   (m0_axi_awvalid  ),           
    .m0_axi_bready    (m0_axi_bready   ),          
    .m0_axi_bresp     (m0_axi_bresp    ),         
    .m0_axi_bvalid    (m0_axi_bvalid   ),          
    .m0_axi_rdata     (m0_axi_rdata    ),         
    .m0_axi_rready    (m0_axi_rready   ),          
    .m0_axi_rresp     (m0_axi_rresp    ),         
    .m0_axi_rvalid    (m0_axi_rvalid   ),          
    .m0_axi_wdata     (m0_axi_wdata    ),         
    .m0_axi_wready    (m0_axi_wready   ),          
    .m0_axi_wstrb     (m0_axi_wstrb    ),         
    .m0_axi_wvalid    (m0_axi_wvalid   ),                                                         
    .ps_bp_clk        (ps_bp_clk       ),       
    .ps_bp_rst        (ps_bp_rst       ),      
    .ps_bp_en         (ps_bp_en        ),    
    .ps_bp_we         (ps_bp_we        ),    
    .ps_bp_addr       (ps_bp_addr      ),               
    .ps_bp_din        (ps_bp_din       ),               
    .ps_bp_dout       (ps_bp_dout      ), 
    .ps_bp_ro_0_clk   (asq_bp_clk      ),       
    .ps_bp_ro_0_rst   (asq_bp_rst      ),      
    .ps_bp_ro_0_en    (asq_bp_en       ),    
    .ps_bp_ro_0_we    (asq_bp_we       ),    
    .ps_bp_ro_0_addr  (asq_bp_addr     ),               
    .ps_bp_ro_0_din   (asq_bp_din      ),               
    .ps_bp_ro_0_dout  (asq_bp_dout     ), 
    .ps_bp_wo_0_clk   (acq_bp_clk      ),       
    .ps_bp_wo_0_rst   (acq_bp_rst      ),      
    .ps_bp_wo_0_en    (acq_bp_en       ),    
    .ps_bp_wo_0_we    (acq_bp_we       ),    
    .ps_bp_wo_0_addr  (acq_bp_addr     ),               
    .ps_bp_wo_0_din   (acq_bp_din      ),               
    .ps_bp_wo_0_dout  (acq_bp_dout     ), 
    .ps_bp_ro_1_clk   (h2c_data_bp_clk ),       
    .ps_bp_ro_1_rst   (h2c_data_bp_rst ),      
    .ps_bp_ro_1_en    (h2c_data_bp_en  ),    
    .ps_bp_ro_1_we    (h2c_data_bp_we  ),    
    .ps_bp_ro_1_addr  (h2c_data_bp_addr),               
    .ps_bp_ro_1_din   (h2c_data_bp_din ),               
    .ps_bp_ro_1_dout  (h2c_data_bp_dout), 
    .ps_bp_wo_1_clk   (c2h_data_bp_clk ),       
    .ps_bp_wo_1_rst   (c2h_data_bp_rst ),      
    .ps_bp_wo_1_en    (c2h_data_bp_en  ),    
    .ps_bp_wo_1_we    (c2h_data_bp_we  ),    
    .ps_bp_wo_1_addr  (c2h_data_bp_addr),               
    .ps_bp_wo_1_din   (c2h_data_bp_din ),               
    .ps_bp_wo_1_dout  (c2h_data_bp_dout),                                                
    .UART_0_rxd       (UART_0_rxd      ),
    .UART_0_txd       (UART_0_txd      )                  
);



ps_regfile ps_regfile(
    .bp_clk            (ps_bp_clk         ),
    .bp_rst            (ps_bp_rst         ),
    .bp_en             (ps_bp_en          ),
    .bp_we             (ps_bp_we          ),
    .bp_addr           (ps_bp_addr        ),
    .bp_wrdata         (ps_bp_din         ),
    .bp_rddata         (ps_bp_dout        ),
    .nvme_reg_cc_en    (nvme_reg_cc_en    ),  
    .ps_csts_rdy       (ps_csts_rdy       ),
    .nvme_reg_cc_shn   (nvme_reg_cc_shn   ),
    .ps_csts_shst      (ps_csts_shst      ),
    .asq_buf_wr_ptr    (asq_buf_wr_ptr    ),         
    .acq_buf_rd_ptr    (acq_buf_rd_ptr    ),         
    .h2c_dma_trans_done(h2c_dma_trans_done),             
    .c2h_dma_trans_done(c2h_dma_trans_done),              
    .asq_dsc_ctl       (asq_dsc_ctl       ),
    .asq_dsc_len       (asq_dsc_len       ),
    .asq_dsc_addr      (asq_dsc_addr      ),
    .acq_dsc_ctl       (acq_dsc_ctl       ),
    .acq_dsc_len       (acq_dsc_len       ),
    .acq_dsc_addr      (acq_dsc_addr      ),
    .sq_reset          (sq_reset          ),
    .cq_reset          (cq_reset          ),
    .iocq_irq_enable   (iocq_irq_enable   ),
    .sq_base_addr_1    (sq_base_addr_1    ),
    .sq_size_1         (sq_size_1         ),
    .sq_id_1           (sq_id_1           ),
    .cq_base_addr_1    (cq_base_addr_1    ),
    .cq_size_1         (cq_size_1         ),
    .cq_id_1           (cq_id_1           ),
    .sq_base_addr_2    (sq_base_addr_2    ),
    .sq_size_2         (sq_size_2         ),
    .sq_id_2           (sq_id_2           ),
    .cq_base_addr_2    (cq_base_addr_2    ),
    .cq_size_2         (cq_size_2         ),
    .cq_id_2           (cq_id_2           ),
    .sq_base_addr_3    (sq_base_addr_3    ),
    .sq_size_3         (sq_size_3         ),
    .sq_id_3           (sq_id_3           ),
    .cq_base_addr_3    (cq_base_addr_3    ),
    .cq_size_3         (cq_size_3         ),
    .cq_id_3           (cq_id_3           ),
    .sq_base_addr_4    (sq_base_addr_4    ),
    .sq_size_4         (sq_size_4         ),
    .sq_id_4           (sq_id_4           ),
    .cq_base_addr_4    (cq_base_addr_4    ),
    .cq_size_4         (cq_size_4         ),
    .cq_id_4           (cq_id_4           ),
    .sq_base_addr_5    (sq_base_addr_5    ),
    .sq_size_5         (sq_size_5         ),
    .sq_id_5           (sq_id_5           ),
    .cq_base_addr_5    (cq_base_addr_5    ),
    .cq_size_5         (cq_size_5         ),
    .cq_id_5           (cq_id_5           ),
    .sq_base_addr_6    (sq_base_addr_6    ),
    .sq_size_6         (sq_size_6         ),
    .sq_id_6           (sq_id_6           ),
    .cq_base_addr_6    (cq_base_addr_6    ),
    .cq_size_6         (cq_size_6         ),
    .cq_id_6           (cq_id_6           ),
    .sq_base_addr_7    (sq_base_addr_7    ),
    .sq_size_7         (sq_size_7         ),
    .sq_id_7           (sq_id_7           ),
    .cq_base_addr_7    (cq_base_addr_7    ),
    .cq_size_7         (cq_size_7         ),
    .cq_id_7           (cq_id_7           ),
    .sq_base_addr_8    (sq_base_addr_8    ),
    .sq_size_8         (sq_size_8         ),
    .sq_id_8           (sq_id_8           ),
    .cq_base_addr_8    (cq_base_addr_8    ),
    .cq_size_8         (cq_size_8         ),
    .cq_id_8           (cq_id_8           ),
    .sq_base_addr_9    (sq_base_addr_9    ),
    .sq_size_9         (sq_size_9         ),
    .sq_id_9           (sq_id_9           ),
    .cq_base_addr_9    (cq_base_addr_9    ),
    .cq_size_9         (cq_size_9         ),
    .cq_id_9           (cq_id_9           ),
    .sq_base_addr_10   (sq_base_addr_10   ),
    .sq_size_10        (sq_size_10        ),
    .sq_id_10          (sq_id_10          ),
    .cq_base_addr_10   (cq_base_addr_10   ),
    .cq_size_10        (cq_size_10        ),
    .cq_id_10          (cq_id_10          ),
    .sq_base_addr_11   (sq_base_addr_11   ),
    .sq_size_11        (sq_size_11        ),
    .sq_id_11          (sq_id_11          ),
    .cq_base_addr_11   (cq_base_addr_11   ),
    .cq_size_11        (cq_size_11        ),
    .cq_id_11          (cq_id_11          ),
    .sq_base_addr_12   (sq_base_addr_12   ),
    .sq_size_12        (sq_size_12        ),
    .sq_id_12          (sq_id_12          ),
    .cq_base_addr_12   (cq_base_addr_12   ),
    .cq_size_12        (cq_size_12        ),
    .cq_id_12          (cq_id_12          ),
    .sq_base_addr_13   (sq_base_addr_13   ),
    .sq_size_13        (sq_size_13        ),
    .sq_id_13          (sq_id_13          ),
    .cq_base_addr_13   (cq_base_addr_13   ),
    .cq_size_13        (cq_size_13        ),
    .cq_id_13          (cq_id_13          ),
    .sq_base_addr_14   (sq_base_addr_14   ),
    .sq_size_14        (sq_size_14        ),
    .sq_id_14          (sq_id_14          ),
    .cq_base_addr_14   (cq_base_addr_14   ),
    .cq_size_14        (cq_size_14        ),
    .cq_id_14          (cq_id_14          ),
    .sq_base_addr_15   (sq_base_addr_15   ),
    .sq_size_15        (sq_size_15        ),
    .sq_id_15          (sq_id_15          ),
    .cq_base_addr_15   (cq_base_addr_15   ),
    .cq_size_15        (cq_size_15        ),
    .cq_id_15          (cq_id_15          ),
    .sq_base_addr_16   (sq_base_addr_16   ),
    .sq_size_16        (sq_size_16        ),
    .sq_id_16          (sq_id_16          ),
    .cq_base_addr_16   (cq_base_addr_16   ),
    .cq_size_16        (cq_size_16        ),
    .cq_id_16          (cq_id_16          )
);


nvme_admin_sq_fetch nvme_admin_sq_fetch(
    .clk                 (clk                   ), 
    .rst_n               (rst_n                 ), 
    .sq_base_addr        (sq_base_addr          ), 
    .sq_size             (sq_size               ), 
    .sq_tail             (sq_tail               ), 
    .sq_head             (sq_head               ), 
    .h2c_dsc_byp_ready   (q_h2c_dsc_byp_ready   ), 
    .h2c_dsc_byp_load    (q_h2c_dsc_byp_load    ), 
    .h2c_dsc_byp_src_addr(q_h2c_dsc_byp_src_addr), 
    .h2c_dsc_byp_dst_addr(q_h2c_dsc_byp_dst_addr), 
    .h2c_dsc_byp_len     (q_h2c_dsc_byp_len     ), 
    .h2c_dsc_byp_ctl     (q_h2c_dsc_byp_ctl     ), 
    .axis_h2c_tready     (q_axis_h2c_tready     ), 
    .axis_h2c_tvalid     (q_axis_h2c_tvalid     ), 
    .axis_h2c_tdata      (q_axis_h2c_tdata      ), 
    .axis_h2c_tkeep      (q_axis_h2c_tkeep      ), 
    .axis_h2c_tlast      (q_axis_h2c_tlast      ), 
    .wr_ptr              (asq_buf_wr_ptr        ),
    .bp_clk              (asq_bp_clk            ),
    .bp_rst              (asq_bp_rst            ),
    .bp_en               (asq_bp_en             ),
    .bp_we               (asq_bp_we             ),
    .bp_addr             (asq_bp_addr           ),
    .bp_wrdata           (asq_bp_din            ),
    .bp_rddata           (asq_bp_dout           )
);


nvme_admin_cq_submit nvme_admin_cq_submit(
    .clk                 (clk                   ),  
    .rst_n               (rst_n                 ),  
    .cq_base_addr        (cq_base_addr          ),  
    .cq_size             (cq_size               ),  
    .cq_head             (cq_head               ),  
    .sq_id               (16'h0                 ),  
    .sq_head             (sq_head               ),  
    .c2h_dsc_byp_ready   (q_c2h_dsc_byp_ready   ),  
    .c2h_dsc_byp_load    (q_c2h_dsc_byp_load    ),  
    .c2h_dsc_byp_src_addr(q_c2h_dsc_byp_src_addr),  
    .c2h_dsc_byp_dst_addr(q_c2h_dsc_byp_dst_addr),  
    .c2h_dsc_byp_len     (q_c2h_dsc_byp_len     ),  
    .c2h_dsc_byp_ctl     (q_c2h_dsc_byp_ctl     ),  
    .axis_c2h_tready     (q_axis_c2h_tready     ),  
    .axis_c2h_tvalid     (q_axis_c2h_tvalid     ),  
    .axis_c2h_tdata      (q_axis_c2h_tdata      ),  
    .axis_c2h_tkeep      (q_axis_c2h_tkeep      ),  
    .axis_c2h_tlast      (q_axis_c2h_tlast      ),  
    .usr_irq_enable      (usr_irq_enable        ),  
    .usr_irq_req         (usr_irq_req           ),  
    .usr_irq_ack         (usr_irq_ack           ),  
    .rd_ptr              (acq_buf_rd_ptr        ),
    .bp_clk              (acq_bp_clk            ),
    .bp_rst              (acq_bp_rst            ),
    .bp_en               (acq_bp_en             ),
    .bp_we               (acq_bp_we             ),
    .bp_addr             (acq_bp_addr           ),
    .bp_wrdata           (acq_bp_din            ),
    .bp_rddata           (acq_bp_dout           )   
);


nvme_admin_data_fetch nvme_admin_data_fetch(
    .clk                 (clk                   ), 
    .rst_n               (rst_n                 ), 
    .ps_dsc_ctl          (asq_dsc_ctl           ),              
    .ps_dsc_len          (asq_dsc_len           ),             
    .ps_dsc_addr         (asq_dsc_addr          ),  
    .dma_trans_done      (h2c_dma_trans_done    ),
    .h2c_dsc_byp_ready   (d_h2c_dsc_byp_ready   ), 
    .h2c_dsc_byp_load    (d_h2c_dsc_byp_load    ), 
    .h2c_dsc_byp_src_addr(d_h2c_dsc_byp_src_addr), 
    .h2c_dsc_byp_dst_addr(d_h2c_dsc_byp_dst_addr), 
    .h2c_dsc_byp_len     (d_h2c_dsc_byp_len     ), 
    .h2c_dsc_byp_ctl     (d_h2c_dsc_byp_ctl     ), 
    .axis_h2c_tready     (d_axis_h2c_tready     ), 
    .axis_h2c_tvalid     (d_axis_h2c_tvalid     ), 
    .axis_h2c_tdata      (d_axis_h2c_tdata      ), 
    .axis_h2c_tkeep      (d_axis_h2c_tkeep      ), 
    .axis_h2c_tlast      (d_axis_h2c_tlast      ), 
    .bp_clk              (h2c_data_bp_clk       ),
    .bp_rst              (h2c_data_bp_rst       ),
    .bp_en               (h2c_data_bp_en        ),
    .bp_we               (h2c_data_bp_we        ),
    .bp_addr             (h2c_data_bp_addr      ),
    .bp_wrdata           (h2c_data_bp_din       ),
    .bp_rddata           (h2c_data_bp_dout      )
);


nvme_admin_data_submit nvme_admin_data_submit(
    .clk                 (clk                   ),  
    .rst_n               (rst_n                 ),  
    .ps_dsc_ctl          (acq_dsc_ctl           ),              
    .ps_dsc_len          (acq_dsc_len           ),             
    .ps_dsc_addr         (acq_dsc_addr          ),  
    .dma_trans_done      (c2h_dma_trans_done    ),  
    .c2h_dsc_byp_ready   (d_c2h_dsc_byp_ready   ),  
    .c2h_dsc_byp_load    (d_c2h_dsc_byp_load    ),  
    .c2h_dsc_byp_src_addr(d_c2h_dsc_byp_src_addr),  
    .c2h_dsc_byp_dst_addr(d_c2h_dsc_byp_dst_addr),  
    .c2h_dsc_byp_len     (d_c2h_dsc_byp_len     ),  
    .c2h_dsc_byp_ctl     (d_c2h_dsc_byp_ctl     ),  
    .axis_c2h_tready     (d_axis_c2h_tready     ),  
    .axis_c2h_tvalid     (d_axis_c2h_tvalid     ),  
    .axis_c2h_tdata      (d_axis_c2h_tdata      ),  
    .axis_c2h_tkeep      (d_axis_c2h_tkeep      ),  
    .axis_c2h_tlast      (d_axis_c2h_tlast      ),   
    .bp_clk              (c2h_data_bp_clk       ),
    .bp_rst              (c2h_data_bp_rst       ),
    .bp_en               (c2h_data_bp_en        ),
    .bp_we               (c2h_data_bp_we        ),
    .bp_addr             (c2h_data_bp_addr      ),
    .bp_wrdata           (c2h_data_bp_din       ),
    .bp_rddata           (c2h_data_bp_dout      )   
);


xdma_h2c_arbiter_two #(
    .ARBITER_LOW_BIT (12)
) xdma_h2c_arbiter(
    .clk                      (clk                     ),      
    .rst_n                    (rst_n                   ),           
    .m_h2c_dsc_byp_ready      (h2c_dsc_byp_ready       ),                         
    .m_h2c_dsc_byp_load       (h2c_dsc_byp_load        ),                      
    .m_h2c_dsc_byp_src_addr   (h2c_dsc_byp_src_addr    ),                            
    .m_h2c_dsc_byp_dst_addr   (h2c_dsc_byp_dst_addr    ),                            
    .m_h2c_dsc_byp_len        (h2c_dsc_byp_len         ),                       
    .m_h2c_dsc_byp_ctl        (h2c_dsc_byp_ctl         ),                        
    .s_axis_h2c_tready        (axis_h2c_tready         ),                    
    .s_axis_h2c_tvalid        (axis_h2c_tvalid         ),                    
    .s_axis_h2c_tdata         (axis_h2c_tdata          ),                   
    .s_axis_h2c_tkeep         (axis_h2c_tkeep          ),                   
    .s_axis_h2c_tlast         (axis_h2c_tlast          ),                      
    .s_h2c_dsc_byp_ready_0    (q_h2c_dsc_byp_ready   ),                           
    .s_h2c_dsc_byp_load_0     (q_h2c_dsc_byp_load    ),                        
    .s_h2c_dsc_byp_src_addr_0 (q_h2c_dsc_byp_src_addr),                              
    .s_h2c_dsc_byp_dst_addr_0 (64'h0000              ),                             
    .s_h2c_dsc_byp_len_0      (q_h2c_dsc_byp_len     ),                         
    .s_h2c_dsc_byp_ctl_0      (q_h2c_dsc_byp_ctl     ),                           
    .m_axis_h2c_tready_0      (q_axis_h2c_tready     ),                      
    .m_axis_h2c_tvalid_0      (q_axis_h2c_tvalid     ),                      
    .m_axis_h2c_tdata_0       (q_axis_h2c_tdata      ),                     
    .m_axis_h2c_tkeep_0       (q_axis_h2c_tkeep      ),                     
    .m_axis_h2c_tlast_0       (q_axis_h2c_tlast      ),                          
    .s_h2c_dsc_byp_ready_1    (d_h2c_dsc_byp_ready   ),                           
    .s_h2c_dsc_byp_load_1     (d_h2c_dsc_byp_load    ),                        
    .s_h2c_dsc_byp_src_addr_1 (d_h2c_dsc_byp_src_addr),                              
    .s_h2c_dsc_byp_dst_addr_1 (64'h1000              ),                              
    .s_h2c_dsc_byp_len_1      (d_h2c_dsc_byp_len     ),                         
    .s_h2c_dsc_byp_ctl_1      (d_h2c_dsc_byp_ctl     ),                          
    .m_axis_h2c_tready_1      (d_axis_h2c_tready     ),                      
    .m_axis_h2c_tvalid_1      (d_axis_h2c_tvalid     ),                      
    .m_axis_h2c_tdata_1       (d_axis_h2c_tdata      ),                     
    .m_axis_h2c_tkeep_1       (d_axis_h2c_tkeep      ),                     
    .m_axis_h2c_tlast_1       (d_axis_h2c_tlast      )                        
);



xdma_c2h_arbiter_two #(
    .ARBITER_LOW_BIT (12)
) xdma_c2h_arbiter(
    .clk                      (clk                   ), 
    .rst_n                    (rst_n                 ),   
    .m_c2h_dsc_byp_ready      (c2h_dsc_byp_ready     ), 
    .m_c2h_dsc_byp_load       (c2h_dsc_byp_load      ), 
    .m_c2h_dsc_byp_src_addr   (c2h_dsc_byp_src_addr  ), 
    .m_c2h_dsc_byp_dst_addr   (c2h_dsc_byp_dst_addr  ), 
    .m_c2h_dsc_byp_len        (c2h_dsc_byp_len       ), 
    .m_c2h_dsc_byp_ctl        (c2h_dsc_byp_ctl       ),    
    .m_axis_c2h_tready        (axis_c2h_tready       ), 
    .m_axis_c2h_tvalid        (axis_c2h_tvalid       ), 
    .m_axis_c2h_tdata         (axis_c2h_tdata        ), 
    .m_axis_c2h_tkeep         (axis_c2h_tkeep        ), 
    .m_axis_c2h_tlast         (axis_c2h_tlast        ),     
    .s_c2h_dsc_byp_ready_0    (q_c2h_dsc_byp_ready   ), 
    .s_c2h_dsc_byp_load_0     (q_c2h_dsc_byp_load    ), 
    .s_c2h_dsc_byp_src_addr_0 (64'h0000              ), 
    .s_c2h_dsc_byp_dst_addr_0 (q_c2h_dsc_byp_dst_addr), 
    .s_c2h_dsc_byp_len_0      (q_c2h_dsc_byp_len     ), 
    .s_c2h_dsc_byp_ctl_0      (q_c2h_dsc_byp_ctl     ),    
    .s_axis_c2h_tready_0      (q_axis_c2h_tready     ), 
    .s_axis_c2h_tvalid_0      (q_axis_c2h_tvalid     ), 
    .s_axis_c2h_tdata_0       (q_axis_c2h_tdata      ), 
    .s_axis_c2h_tkeep_0       (q_axis_c2h_tkeep      ), 
    .s_axis_c2h_tlast_0       (q_axis_c2h_tlast      ),    
    .s_c2h_dsc_byp_ready_1    (d_c2h_dsc_byp_ready   ), 
    .s_c2h_dsc_byp_load_1     (d_c2h_dsc_byp_load    ), 
    .s_c2h_dsc_byp_src_addr_1 (64'h1000              ), 
    .s_c2h_dsc_byp_dst_addr_1 (d_c2h_dsc_byp_dst_addr), 
    .s_c2h_dsc_byp_len_1      (d_c2h_dsc_byp_len     ), 
    .s_c2h_dsc_byp_ctl_1      (d_c2h_dsc_byp_ctl     ),    
    .s_axis_c2h_tready_1      (d_axis_c2h_tready     ), 
    .s_axis_c2h_tvalid_1      (d_axis_c2h_tvalid     ), 
    .s_axis_c2h_tdata_1       (d_axis_c2h_tdata      ), 
    .s_axis_c2h_tkeep_1       (d_axis_c2h_tkeep      ), 
    .s_axis_c2h_tlast_1       (d_axis_c2h_tlast      )  
);









endmodule
