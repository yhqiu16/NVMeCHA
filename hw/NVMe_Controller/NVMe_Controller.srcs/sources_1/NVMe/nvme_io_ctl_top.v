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
// Create Date: 10/13/2020 04:28:31 PM
// Design Name: 
// Module Name: nvme_io_ctl_top
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


module nvme_io_ctl_top#(
    parameter DATA_WIDTH = 256
)(
    input                        clk,
    input                        rst_n,
    
    // Host SQ&CQ ID
    input  [15:0]                sq_id,
    // host submission queu
    input  [63:0]                sq_base_addr,
    input  [15:0]                sq_size,
    input  [15:0]                sq_tail,
    // host completion queu
    input  [63:0]                cq_base_addr,
    input  [15:0]                cq_size,
    input  [15:0]                cq_head,
    
    input      [  7:0]           mps_width,   // memeory page size bitwidth
    input      [  7:0]           lbads_width, // LBA data size bitwidth
    
    // C2H DMA descriptor for CQ
    input                        q_c2h_dsc_byp_ready,   
    output                       q_c2h_dsc_byp_load, 
    output [63 : 0]              q_c2h_dsc_byp_src_addr,   
    output [63 : 0]              q_c2h_dsc_byp_dst_addr,   
    output [27 : 0]              q_c2h_dsc_byp_len,   
    output [15 : 0]              q_c2h_dsc_byp_ctl,   
    // H2C DMA descriptor for SQ 
    input                        q_h2c_dsc_byp_ready,   
    output                       q_h2c_dsc_byp_load, 
    output [63 : 0]              q_h2c_dsc_byp_src_addr,   
    output [63 : 0]              q_h2c_dsc_byp_dst_addr,   
    output [27 : 0]              q_h2c_dsc_byp_len,   
    output [15 : 0]              q_h2c_dsc_byp_ctl,  
    
    // C2H DMA descriptor for reading data
    input                        d_c2h_dsc_byp_ready,   
    output                       d_c2h_dsc_byp_load, 
    output [63 : 0]              d_c2h_dsc_byp_src_addr,   
    output [63 : 0]              d_c2h_dsc_byp_dst_addr,   
    output [27 : 0]              d_c2h_dsc_byp_len,   
    output [15 : 0]              d_c2h_dsc_byp_ctl,   
    // H2C DMA descriptor for programming data
    input                        d_h2c_dsc_byp_ready,   
    output                       d_h2c_dsc_byp_load, 
    output [63 : 0]              d_h2c_dsc_byp_src_addr,   
    output [63 : 0]              d_h2c_dsc_byp_dst_addr,   
    output [27 : 0]              d_h2c_dsc_byp_len,   
    output [15 : 0]              d_h2c_dsc_byp_ctl,  
    
    // AXI ST interface to fetch cmd submission data
    output                       q_axis_h2c_tready,
    input                        q_axis_h2c_tvalid,
    input  [DATA_WIDTH-1:0]      q_axis_h2c_tdata,
    input  [DATA_WIDTH/8-1:0]    q_axis_h2c_tkeep,
    input                        q_axis_h2c_tlast,         
    // AXI ST interface to submit cmd completion data
    input                        q_axis_c2h_tready,
    output                       q_axis_c2h_tvalid,
    output [DATA_WIDTH-1:0]      q_axis_c2h_tdata,
    output [DATA_WIDTH/8-1:0]    q_axis_c2h_tkeep,
    output                       q_axis_c2h_tlast,
    
    // AXI ST interface to fetch programming data
    output                       d_axis_h2c_tready,
    input                        d_axis_h2c_tvalid,
    input  [DATA_WIDTH-1:0]      d_axis_h2c_tdata,
    input  [DATA_WIDTH/8-1:0]    d_axis_h2c_tkeep,
    input                        d_axis_h2c_tlast,         
    // AXI ST interface to submit reading data
    input                        d_axis_c2h_tready,
    output                       d_axis_c2h_tvalid,
    output [DATA_WIDTH-1:0]      d_axis_c2h_tdata,
    output [DATA_WIDTH/8-1:0]    d_axis_c2h_tkeep,
    output                       d_axis_c2h_tlast,
    
    // interrupt
    input                        usr_irq_enable,
    output                       usr_irq_req,
    input                        usr_irq_ack
);


wire [23 : 0]                axis_data_avail;
wire                         axis_wready;
wire                         axis_wvalid;
wire [  DATA_WIDTH-1 : 0]    axis_wdata;
wire [DATA_WIDTH/8-1 : 0]    axis_wkeep;
wire                         axis_wlast;
wire                         axis_rready;
wire                         axis_rvalid;
wire [  DATA_WIDTH-1 : 0]    axis_rdata;
wire [DATA_WIDTH/8-1 : 0]    axis_rkeep;
wire [ 15 : 0]               axis_rid;
wire [  3 : 0]               axis_ruser;
wire                         axis_rlast; 

wire                         i_req_ready;
wire                         o_req_valid;
wire [255:0]                 o_req_data;
wire                         o_res_ready;
wire                         i_res_valid;
wire [127:0]                 i_res_data;



nvme_io_controller nvme_io_controller(
    .clk                   (clk                     ), 
    .rst_n                 (rst_n                   ), 
    .sq_id                 (sq_id                   ), 
    .sq_base_addr          (sq_base_addr            ),  
    .sq_size               (sq_size                 ),  
    .sq_tail               (sq_tail                 ),  
    .cq_base_addr          (cq_base_addr            ),  
    .cq_size               (cq_size                 ),  
    .cq_head               (cq_head                 ),  
    .mps_width             (mps_width               ),
    .lbads_width           (lbads_width             ),
    .c2h_dsc_byp_ready_0   (q_c2h_dsc_byp_ready     ),
    .c2h_dsc_byp_load_0    (q_c2h_dsc_byp_load      ),
    .c2h_dsc_byp_src_addr_0(q_c2h_dsc_byp_src_addr  ),
    .c2h_dsc_byp_dst_addr_0(q_c2h_dsc_byp_dst_addr  ),
    .c2h_dsc_byp_len_0     (q_c2h_dsc_byp_len       ),
    .c2h_dsc_byp_ctl_0     (q_c2h_dsc_byp_ctl       ),
    .h2c_dsc_byp_ready_0   (q_h2c_dsc_byp_ready     ),
    .h2c_dsc_byp_load_0    (q_h2c_dsc_byp_load      ),
    .h2c_dsc_byp_src_addr_0(q_h2c_dsc_byp_src_addr  ),
    .h2c_dsc_byp_dst_addr_0(q_h2c_dsc_byp_dst_addr  ),
    .h2c_dsc_byp_len_0     (q_h2c_dsc_byp_len       ),
    .h2c_dsc_byp_ctl_0     (q_h2c_dsc_byp_ctl       ),
    .c2h_dsc_byp_ready_1   (d_c2h_dsc_byp_ready     ),
    .c2h_dsc_byp_load_1    (d_c2h_dsc_byp_load      ),
    .c2h_dsc_byp_src_addr_1(d_c2h_dsc_byp_src_addr  ),
    .c2h_dsc_byp_dst_addr_1(d_c2h_dsc_byp_dst_addr  ),
    .c2h_dsc_byp_len_1     (d_c2h_dsc_byp_len       ),
    .c2h_dsc_byp_ctl_1     (d_c2h_dsc_byp_ctl       ),
    .h2c_dsc_byp_ready_1   (d_h2c_dsc_byp_ready     ),
    .h2c_dsc_byp_load_1    (d_h2c_dsc_byp_load      ),
    .h2c_dsc_byp_src_addr_1(d_h2c_dsc_byp_src_addr  ),
    .h2c_dsc_byp_dst_addr_1(d_h2c_dsc_byp_dst_addr  ),
    .h2c_dsc_byp_len_1     (d_h2c_dsc_byp_len       ),
    .h2c_dsc_byp_ctl_1     (d_h2c_dsc_byp_ctl       ),
    .axis_h2c_tready_0     (q_axis_h2c_tready       ),
    .axis_h2c_tvalid_0     (q_axis_h2c_tvalid       ),
    .axis_h2c_tdata_0      (q_axis_h2c_tdata        ),
    .axis_h2c_tkeep_0      (q_axis_h2c_tkeep        ),
    .axis_h2c_tlast_0      (q_axis_h2c_tlast        ),
    .axis_c2h_tready_0     (q_axis_c2h_tready       ),
    .axis_c2h_tvalid_0     (q_axis_c2h_tvalid       ),
    .axis_c2h_tdata_0      (q_axis_c2h_tdata        ),
    .axis_c2h_tkeep_0      (q_axis_c2h_tkeep        ),
    .axis_c2h_tlast_0      (q_axis_c2h_tlast        ),
    .axis_h2c_tready_1     (d_axis_h2c_tready       ),
    .axis_h2c_tvalid_1     (d_axis_h2c_tvalid       ),
    .axis_h2c_tdata_1      (d_axis_h2c_tdata        ),
    .axis_h2c_tkeep_1      (d_axis_h2c_tkeep        ),
    .axis_h2c_tlast_1      (d_axis_h2c_tlast        ),
    .axis_c2h_tready_1     (d_axis_c2h_tready       ),
    .axis_c2h_tvalid_1     (d_axis_c2h_tvalid       ),
    .axis_c2h_tdata_1      (d_axis_c2h_tdata        ),
    .axis_c2h_tkeep_1      (d_axis_c2h_tkeep        ),
    .axis_c2h_tlast_1      (d_axis_c2h_tlast        ),
    .axis_data_avail       (axis_data_avail         ),
    .axis_wready           (axis_wready             ),
    .axis_wvalid           (axis_wvalid             ),
    .axis_wdata            (axis_wdata              ),
    .axis_wkeep            (axis_wkeep              ),
    .axis_wlast            (axis_wlast              ),
    .axis_rready           (axis_rready             ),
    .axis_rvalid           (axis_rvalid             ),
    .axis_rdata            (axis_rdata              ),
    .axis_rkeep            (axis_rkeep              ),
    .axis_rid              (axis_rid                ),
    .axis_ruser            (axis_ruser              ),
    .axis_rlast            (axis_rlast              ),
    .i_req_ready           (i_req_ready             ),
    .o_req_valid           (o_req_valid             ),
    .o_req_data            (o_req_data              ),
    .o_res_ready           (o_res_ready             ),
    .i_res_valid           (i_res_valid             ),
    .i_res_data            (i_res_data              ),
    .usr_irq_enable        (usr_irq_enable          ),
    .usr_irq_req           (usr_irq_req             ),
    .usr_irq_ack           (usr_irq_ack             ) 
);


user_app user_app(
    .clk           (clk             ),               
    .rst_n         (rst_n           ),                 
    .o_req_ready   (i_req_ready     ),                        
    .i_req_valid   (o_req_valid     ),                       
    .i_req_data    (o_req_data      ),                      
    .i_res_ready   (o_res_ready     ),                       
    .o_res_valid   (i_res_valid     ),                       
    .o_res_data    (i_res_data      ),                        
    .s_data_avail  (axis_data_avail ),                         
    .s_axis_tready (axis_wready     ),                          
    .s_axis_tvalid (axis_wvalid     ),                                              
    .s_axis_tdata  (axis_wdata      ),                         
    .s_axis_tlast  (axis_wlast      ),                         
    .m_axis_tready (axis_rready     ),                         
    .m_axis_tvalid (axis_rvalid     ),                                                 
    .m_axis_tdata  (axis_rdata      ), 
    .m_axis_tid    (axis_rid        ),                       
    .m_axis_tlast  (axis_rlast      )                        
);


assign axis_rkeep = 32'hffff_ffff;
assign axis_ruser = 4'h0;



endmodule
