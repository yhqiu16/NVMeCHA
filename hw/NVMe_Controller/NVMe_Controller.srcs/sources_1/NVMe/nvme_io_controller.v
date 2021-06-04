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
// Module Name: nvme_io_controller
// Project Name: SSD Controller
// Target Devices: 
// Tool Versions: 
// Description: NVMe IO Controller of single channel (1 SQ + 1 CQ)
//                  SQ fetch, CQ submit, program data and read data DMA transmission
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module nvme_io_controller #(
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
    
    input  [23 : 0]              axis_data_avail,
    input                        axis_wready,
    output                       axis_wvalid,
    output  [DATA_WIDTH-1 : 0]   axis_wdata,
    output  [DATA_WIDTH/8-1 : 0] axis_wkeep,
    output                       axis_wlast,
        
    output                       axis_rready,
    input                        axis_rvalid,
    input  [DATA_WIDTH-1 : 0]    axis_rdata,
    input  [DATA_WIDTH/8-1 : 0]  axis_rkeep,
    input  [ 15 : 0]             axis_rid,
    input  [  3 : 0]             axis_ruser,
    input                        axis_rlast, 
     
    // output request data
    input                        i_req_ready,
    output reg                   o_req_valid,
    output reg [255:0]           o_req_data,
    // input respond data
    output reg                   o_res_ready,
    input                        i_res_valid,
    input      [127:0]           i_res_data,
    
    // interrupt
    input                        usr_irq_enable,
    output                       usr_irq_req,
    input                        usr_irq_ack        
    
);


// SQ Entry Format
// Dword 0   : [ 7 : 0]  OPC, Opcode
//             [ 9 : 8]  FUSE, fused operation
//             [15 : 14] PSDT, PRP or SGL for Data Transfer
//             [31 : 16] CID, Command ID            
// Dword 1   : [31 : 0]  NSID, Namespace Identifier
// Dword 2-3 : [63 : 0]  RESERVED
// Dword 4-5 : [63 : 0]  MPTR, metadata pointer
// Dword 6-9 :           DPTR, Data Pointer
//             [63 : 0]  PRP1, PRP Entry 1
//             [127:64]  PRP2, PRP Entry 2
//        or   [127:0]   SGL1, SGL Entry 1
// Dword 10-15:          Command Specific


// CQ Entry Format
// Dword 0   : [31 : 0]  command specific
// Dword 1   : [31 : 0]  reserved
// Dword 2   : [31 : 16] SQ ID
//             [15 : 0]  SQ Head Pointer
// Dword 3   : [31 : 17] status field
//             [16]      phase tag
//             [15 : 0]  CID, Command ID


wire [ 15:0] sq_head;
//wire [ 15:0] cq_tail;
wire         sq_ori_req_ready;
wire         sq_ori_req_valid;
wire [511:0] sq_ori_req_data;

wire         sq_req_ready;
wire         sq_req_valid;
wire [511:0] sq_req_data;

wire         cq_res_ready;
reg          cq_res_valid;
reg  [127:0] cq_res_data;

reg          byp_res_ready;
wire         byp_res_valid;
wire [127:0] byp_res_data;

reg          c2h_res_ready;
wire         c2h_res_valid;
wire [127:0] c2h_res_data;

wire         prp_req_ready;
reg          prp_req_valid;
reg  [  7:0] prp_req_opc;   // operation code
reg  [ 15:0] prp_req_cid;   // Command ID
reg  [127:0] prp_req_dptr;  // data pointer
reg  [ 15:0] prp_req_nlb;   // number of logical blocks

wire         h2c_cmd_ready;
wire         h2c_cmd_valid;
wire [ 63:0] h2c_host_addr;
wire [ 31:0] h2c_data_len;
wire [ 15:0] h2c_cmd_id;
wire         h2c_cmd_last;

wire         c2h_cmd_ready;
wire         c2h_cmd_valid;
wire [ 63:0] c2h_host_addr;
wire [ 31:0] c2h_data_len;
wire [ 15:0] c2h_cmd_id;
wire         c2h_cmd_last;
//reg  [  3:0] c2h_cmd_type;

wire                       sq_h2c_dsc_byp_ready;   
wire                       sq_h2c_dsc_byp_load; 
wire [63 : 0]              sq_h2c_dsc_byp_src_addr;   
wire [63 : 0]              sq_h2c_dsc_byp_dst_addr;   
wire [27 : 0]              sq_h2c_dsc_byp_len;   
wire [15 : 0]              sq_h2c_dsc_byp_ctl; 

wire                       sq_axis_h2c_tready;
wire                       sq_axis_h2c_tvalid;
wire [DATA_WIDTH-1:0]      sq_axis_h2c_tdata;
wire [DATA_WIDTH/8-1:0]    sq_axis_h2c_tkeep;
wire                       sq_axis_h2c_tlast; 

wire                       prp_h2c_dsc_byp_ready;   
wire                       prp_h2c_dsc_byp_load; 
wire [63 : 0]              prp_h2c_dsc_byp_src_addr;   
wire [63 : 0]              prp_h2c_dsc_byp_dst_addr;   
wire [27 : 0]              prp_h2c_dsc_byp_len;   
wire [15 : 0]              prp_h2c_dsc_byp_ctl; 

wire                       prp_axis_h2c_tready;
wire                       prp_axis_h2c_tvalid;
wire [DATA_WIDTH-1:0]      prp_axis_h2c_tdata;
wire [DATA_WIDTH/8-1:0]    prp_axis_h2c_tkeep;
wire                       prp_axis_h2c_tlast; 

wire [  7:0] opc;
wire [ 15:0] cid;
wire [127:0] dptr; // data pointer
wire [ 63:0] slba; // starting LBA
wire [ 15:0] nlb;  // number of logical blocks
wire [ 31:0] data_len;


nvme_sq_fetch nvme_sq_fetch(
    .clk                 (clk                    ),   // input            clk,
    .rst_n               (rst_n                  ),   // input            rst_n,
    .sq_base_addr        (sq_base_addr           ),   // input  [63:0]    sq_base_addr,
    .sq_size             (sq_size                ),   // input  [15:0]    sq_size, // number of slots
    .sq_tail             (sq_tail                ),   // input  [15:0]    sq_tail, // slot index
    .sq_head             (sq_head                ),   // output [15:0]    sq_head, // slot index
    .h2c_dsc_byp_ready   (sq_h2c_dsc_byp_ready   ),   // input            h2c_dsc_byp_ready,   
    .h2c_dsc_byp_load    (sq_h2c_dsc_byp_load    ),   // output           h2c_dsc_byp_load, 
    .h2c_dsc_byp_src_addr(sq_h2c_dsc_byp_src_addr),   // output [63 : 0]  h2c_dsc_byp_src_addr,   
    .h2c_dsc_byp_dst_addr(sq_h2c_dsc_byp_dst_addr),   // output [63 : 0]  h2c_dsc_byp_dst_addr,   
    .h2c_dsc_byp_len     (sq_h2c_dsc_byp_len     ),   // output [27 : 0]  h2c_dsc_byp_len,   
    .h2c_dsc_byp_ctl     (sq_h2c_dsc_byp_ctl     ),   // output [15 : 0]  h2c_dsc_byp_ctl,  
    .axis_h2c_tready     (sq_axis_h2c_tready     ),   // output           axis_h2c_tready,
    .axis_h2c_tvalid     (sq_axis_h2c_tvalid     ),   // input            axis_h2c_tvalid,
    .axis_h2c_tdata      (sq_axis_h2c_tdata      ),   // input  [255:0]   axis_h2c_tdata,
    .axis_h2c_tkeep      (sq_axis_h2c_tkeep      ),   // input  [31:0]    axis_h2c_tkeep,
    .axis_h2c_tlast      (sq_axis_h2c_tlast      ),   // input            axis_h2c_tlast,
    .i_req_ready         (sq_ori_req_ready       ),   // input            i_req_ready,
    .o_req_valid         (sq_ori_req_valid       ),   // output           o_req_valid,
    .o_req_data          (sq_ori_req_data        )    // output [511:0]   o_req_data 
);



nvme_cq_submit nvme_cq_submit(
    .clk                 (clk                   ),  // input           clk                 
    .rst_n               (rst_n                 ),  // input           rst_n               
    .cq_base_addr        (cq_base_addr          ),  // input  [63:0]   cq_base_addr        
    .cq_size             (cq_size               ),  // input  [15:0]   cq_size             
    .cq_head             (cq_head               ),  // input  [15:0]   cq_head             
    .sq_id               (sq_id                 ),  // input  [15:0]   sq_id               
    .sq_head             (sq_head               ),  // input  [15:0]   sq_head             
    .c2h_dsc_byp_ready   (c2h_dsc_byp_ready_0   ),  // input           c2h_dsc_byp_ready   
    .c2h_dsc_byp_load    (c2h_dsc_byp_load_0    ),  // output          c2h_dsc_byp_load    
    .c2h_dsc_byp_src_addr(c2h_dsc_byp_src_addr_0),  // output [63 : 0] c2h_dsc_byp_src_addr
    .c2h_dsc_byp_dst_addr(c2h_dsc_byp_dst_addr_0),  // output [63 : 0] c2h_dsc_byp_dst_addr
    .c2h_dsc_byp_len     (c2h_dsc_byp_len_0     ),  // output [27 : 0] c2h_dsc_byp_len     
    .c2h_dsc_byp_ctl     (c2h_dsc_byp_ctl_0     ),  // output [15 : 0] c2h_dsc_byp_ctl     
    .axis_c2h_tready     (axis_c2h_tready_0     ),  // input           axis_c2h_tready     
    .axis_c2h_tvalid     (axis_c2h_tvalid_0     ),  // output          axis_c2h_tvalid     
    .axis_c2h_tdata      (axis_c2h_tdata_0      ),  // output [255:0]  axis_c2h_tdata      
    .axis_c2h_tkeep      (axis_c2h_tkeep_0      ),  // output [31:0]   axis_c2h_tkeep      
    .axis_c2h_tlast      (axis_c2h_tlast_0      ),  // output          axis_c2h_tlast      
    .o_res_ready         (cq_res_ready          ),  // output          o_res_ready         
    .i_res_valid         (cq_res_valid          ),  // input           i_res_valid         
    .i_res_data          (cq_res_data           ),  // input  [127:0]  i_res_data          
    .usr_irq_enable      (usr_irq_enable        ),  // input           usr_irq_enable      
    .usr_irq_req         (usr_irq_req           ),  // output          usr_irq_req         
    .usr_irq_ack         (usr_irq_ack           )   // input           usr_irq_ack         
);


// validate SQ entry
// if donot need Read/Write operation, then directly generate CQ entry
io_cmd_validate io_cmd_validate(
    .clk             (clk             ), 
    .rst_n           (rst_n           ), 
    .o_req_ready     (sq_ori_req_ready), 
    .i_req_valid     (sq_ori_req_valid), 
    .i_req_data      (sq_ori_req_data ), 
    .i_val_req_ready (sq_req_ready    ), 
    .o_val_req_valid (sq_req_valid    ), 
    .o_val_req_data  (sq_req_data     ), 
    .i_res_ready     (byp_res_ready   ), 
    .o_res_valid     (byp_res_valid   ), 
    .o_res_data      (byp_res_data    ) 
 );



prp_manager_share prp_manager_share(
    .clk                  (clk                     ),
    .rst_n                (rst_n                   ),
    .o_req_ready          (prp_req_ready           ),
    .i_req_valid          (prp_req_valid           ),
    .i_req_opc            (prp_req_opc             ),
    .i_req_cid            (prp_req_cid             ),
    .i_req_dptr           (prp_req_dptr            ),
    .i_req_nlb            (prp_req_nlb             ),
    .mps_width            (mps_width               ),
    .lbads_width          (lbads_width             ),
    .i_rd_ready           (c2h_cmd_ready           ),
    .o_rd_valid           (c2h_cmd_valid           ),
    .o_rd_host_addr       (c2h_host_addr           ),
    .o_rd_data_len        (c2h_data_len            ),
    .o_rd_cid             (c2h_cmd_id              ),
    .o_rd_last            (c2h_cmd_last            ),
    .i_wr_ready           (h2c_cmd_ready           ),
    .o_wr_valid           (h2c_cmd_valid           ),
    .o_wr_host_addr       (h2c_host_addr           ),
    .o_wr_data_len        (h2c_data_len            ),
    .o_wr_cid             (h2c_cmd_id              ),
    .o_wr_last            (h2c_cmd_last            ),
    .h2c_dsc_byp_ready    (prp_h2c_dsc_byp_ready   ),
    .h2c_dsc_byp_load     (prp_h2c_dsc_byp_load    ),
    .h2c_dsc_byp_src_addr (prp_h2c_dsc_byp_src_addr),
    .h2c_dsc_byp_dst_addr (prp_h2c_dsc_byp_dst_addr),
    .h2c_dsc_byp_len      (prp_h2c_dsc_byp_len     ),
    .h2c_dsc_byp_ctl      (prp_h2c_dsc_byp_ctl     ),
    .axis_h2c_tready      (prp_axis_h2c_tready     ),
    .axis_h2c_tvalid      (prp_axis_h2c_tvalid     ),
    .axis_h2c_tdata       (prp_axis_h2c_tdata      ),
    .axis_h2c_tkeep       (prp_axis_h2c_tkeep      ),
    .axis_h2c_tlast       (prp_axis_h2c_tlast      )
);


nvme_h2c_data_fetch nvme_h2c_data_fetch(
    .clk                 (clk                   ), // input           clk                 
    .rst_n               (rst_n                 ), // input           rst_n               
    .o_cmd_ready         (h2c_cmd_ready         ), // output          o_cmd_ready         
    .i_cmd_valid         (h2c_cmd_valid         ), // input           i_cmd_valid         
    .i_host_addr         (h2c_host_addr         ), // input  [63:0]   i_host_addr         // data addr in host memory
    .i_data_len          (h2c_data_len          ), // input  [31:0]   i_data_len          // transfer length of data
    .i_cmd_id            (h2c_cmd_id            ), // input  [15:0]   i_cmd_id            // command id
    .h2c_dsc_byp_ready   (h2c_dsc_byp_ready_1   ), // input           h2c_dsc_byp_ready           
    .h2c_dsc_byp_load    (h2c_dsc_byp_load_1    ), // output          h2c_dsc_byp_load         
    .h2c_dsc_byp_src_addr(h2c_dsc_byp_src_addr_1), // output [63 : 0] h2c_dsc_byp_src_addr           
    .h2c_dsc_byp_dst_addr(h2c_dsc_byp_dst_addr_1), // output [63 : 0] h2c_dsc_byp_dst_addr           
    .h2c_dsc_byp_len     (h2c_dsc_byp_len_1     ), // output [27 : 0] h2c_dsc_byp_len           
    .h2c_dsc_byp_ctl     (h2c_dsc_byp_ctl_1     ),  // output [15 : 0] h2c_dsc_byp_ctl 
    .axis_h2c_tready     (axis_h2c_tready_1     ),                  
    .axis_h2c_tvalid     (axis_h2c_tvalid_1     ),                  
    .axis_h2c_tdata      (axis_h2c_tdata_1      ),                 
    .axis_h2c_tkeep      (axis_h2c_tkeep_1      ),                 
    .axis_h2c_tlast      (axis_h2c_tlast_1      ),                       
    .m_data_avail        (axis_data_avail       ),               
    .m_axis_tready       (axis_wready           ),                
    .m_axis_tvalid       (axis_wvalid           ),                                        
    .m_axis_tdata        (axis_wdata            ), 
    .m_axis_tkeep        (axis_wkeep            ),              
    .m_axis_tlast        (axis_wlast            )     
);



nvme_c2h_data_submit nvme_c2h_data_submit(
    .clk                 (clk                   ),  // input            clk                 
    .rst_n               (rst_n                 ),  // input            rst_n               
    .o_cmd_ready         (c2h_cmd_ready         ),  // output           o_cmd_ready         
    .i_cmd_valid         (c2h_cmd_valid         ),  // input            i_cmd_valid         
    .i_host_addr         (c2h_host_addr         ),  // input  [63:0]    i_host_addr         // data addr in host memory
    .i_data_len          (c2h_data_len          ),  // input  [31:0]    i_data_len          // transfer length of data
    .i_cmd_id            (c2h_cmd_id            ),  // input  [15:0]    i_cmd_id            // command id
    .i_cmd_type          (4'h0                  ),  // input  [3:0]     i_cmd_type          // command type
    .i_cmd_last          (c2h_cmd_last          ),
    .i_res_ready         (c2h_res_ready         ),
    .o_res_valid         (c2h_res_valid         ),
    .o_res_data          (c2h_res_data          ),
    .c2h_dsc_byp_ready   (c2h_dsc_byp_ready_1   ),  // input            c2h_dsc_byp_ready           
    .c2h_dsc_byp_load    (c2h_dsc_byp_load_1    ),  // output           c2h_dsc_byp_load         
    .c2h_dsc_byp_src_addr(c2h_dsc_byp_src_addr_1),  // output [63 : 0]  c2h_dsc_byp_src_addr           
    .c2h_dsc_byp_dst_addr(c2h_dsc_byp_dst_addr_1),  // output [63 : 0]  c2h_dsc_byp_dst_addr           
    .c2h_dsc_byp_len     (c2h_dsc_byp_len_1     ),  // output [27 : 0]  c2h_dsc_byp_len           
    .c2h_dsc_byp_ctl     (c2h_dsc_byp_ctl_1     ),  // output [15 : 0]  c2h_dsc_byp_ctl        
    .s_axis_tready       (axis_rready           ),  // output           o_rready            
    .s_axis_tvalid       (axis_rvalid           ),  // input            i_rvalid            
    .s_axis_tdata        (axis_rdata            ),  // input  [255 : 0] i_rdata             
    .s_axis_tkeep        (axis_rkeep            ),  // input  [ 31 : 0] i_rkeep             
    .s_axis_tid          (axis_rid              ),  // input  [ 15 : 0] i_rid     
    .s_axis_tuser        (axis_ruser            ),  // input  [  3 : 0] i_ruser         
    .s_axis_tlast        (axis_rlast            ),  // input            i_rlast             
    .axis_c2h_tready     (axis_c2h_tready_1     ),  // input            axis_c2h_tready        
    .axis_c2h_tvalid     (axis_c2h_tvalid_1     ),  // output           axis_c2h_tvalid        
    .axis_c2h_tdata      (axis_c2h_tdata_1      ),  // output [255:0]   axis_c2h_tdata        
    .axis_c2h_tkeep      (axis_c2h_tkeep_1      ),  // output [31:0]    axis_c2h_tkeep        
    .axis_c2h_tlast      (axis_c2h_tlast_1      )   // output           axis_c2h_tlast      
);


// H2C DMA Channel Arbiter
xdma_h2c_arbiter_two #(
    .ARBITER_LOW_BIT (12)
) xdma_h2c_arbiter(
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
    
    .s_h2c_dsc_byp_ready_0    (sq_h2c_dsc_byp_ready    ),                           
    .s_h2c_dsc_byp_load_0     (sq_h2c_dsc_byp_load     ),                        
    .s_h2c_dsc_byp_src_addr_0 (sq_h2c_dsc_byp_src_addr ),                              
    .s_h2c_dsc_byp_dst_addr_0 (64'h0000                ),                             
    .s_h2c_dsc_byp_len_0      (sq_h2c_dsc_byp_len      ),                         
    .s_h2c_dsc_byp_ctl_0      (sq_h2c_dsc_byp_ctl      ),                           
    .m_axis_h2c_tready_0      (sq_axis_h2c_tready      ),                      
    .m_axis_h2c_tvalid_0      (sq_axis_h2c_tvalid      ),                      
    .m_axis_h2c_tdata_0       (sq_axis_h2c_tdata       ),                     
    .m_axis_h2c_tkeep_0       (sq_axis_h2c_tkeep       ),                     
    .m_axis_h2c_tlast_0       (sq_axis_h2c_tlast       ),                      
    
    .s_h2c_dsc_byp_ready_1    (prp_h2c_dsc_byp_ready   ),                           
    .s_h2c_dsc_byp_load_1     (prp_h2c_dsc_byp_load    ),                        
    .s_h2c_dsc_byp_src_addr_1 (prp_h2c_dsc_byp_src_addr),                              
    .s_h2c_dsc_byp_dst_addr_1 (64'h1000                ),                              
    .s_h2c_dsc_byp_len_1      (prp_h2c_dsc_byp_len     ),                         
    .s_h2c_dsc_byp_ctl_1      (prp_h2c_dsc_byp_ctl     ),                           
    .m_axis_h2c_tready_1      (prp_axis_h2c_tready     ),                      
    .m_axis_h2c_tvalid_1      (prp_axis_h2c_tvalid     ),                      
    .m_axis_h2c_tdata_1       (prp_axis_h2c_tdata      ),                     
    .m_axis_h2c_tkeep_1       (prp_axis_h2c_tkeep      ),                     
    .m_axis_h2c_tlast_1       (prp_axis_h2c_tlast      )                        
);



// SQ resuest is broadcast to nfc_device, h2c_data_fetch, and c2h_data_submit
//    all requests to nfc_device
//    programming requests to h2c_data_fetch
//    reading page and parameter requests to c2h_data_submit

assign opc      = sq_req_data[7:0];
assign cid      = sq_req_data[31:16];
assign dptr     = sq_req_data[319:192];
assign slba     = sq_req_data[383:320];
assign nlb      = sq_req_data[399:384];
assign data_len = (nlb + 1) << lbads_width;

localparam
    SQ_IDLE   = 1'h0,
    SQ_GEN    = 1'h1;

reg  sq_state;
reg  dev_state;
reg  prp_state;
//reg  h2c_state;
//reg  c2h_state;

assign sq_req_ready = (sq_state == SQ_IDLE);

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    sq_state <= SQ_IDLE;
end else begin
    case(sq_state)
        SQ_IDLE: begin
            if(sq_req_valid) begin
                sq_state <= SQ_GEN;
            end
        end
        SQ_GEN: begin
            if((dev_state == SQ_IDLE) && (prp_state == SQ_IDLE)) begin
                sq_state <= SQ_IDLE;
            end
        end
    endcase
end

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    dev_state   <= SQ_IDLE;
    o_req_valid <= 1'b0;
    o_req_data  <= 256'h0;
end else begin
    case(dev_state)
        SQ_IDLE: begin
            if(sq_req_valid & sq_req_ready & (opc == `NVME_WRITE)) begin
                dev_state   <= SQ_GEN;
                o_req_valid <= 1'b1;
                o_req_data  <= {data_len[23:0], slba[39:0], cid, 16'h1080}; // NVME OPC convert to ONFI OPC
//                o_req_data  <= {col_num, col_addr_len, metadata, len[23:0], nand_addr[39:0], cid, opc};
            end else if(sq_req_valid & sq_req_ready & (opc == `NVME_READ)) begin
                dev_state   <= SQ_GEN;
                o_req_valid <= 1'b1;
                o_req_data  <= {data_len[23:0], slba[39:0], cid, 16'h3000}; // NVME OPC convert to ONFI OPC
            end
        end
        SQ_GEN: begin
            if(i_req_ready) begin
                dev_state   <= SQ_IDLE;
                o_req_valid <= 1'b0;
//                o_req_data  <= 256'h0;
            end
        end
    endcase
end


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    prp_state     <= SQ_IDLE;
    prp_req_valid <= 1'b0;
    prp_req_opc   <= 8'h0;
    prp_req_cid   <= 16'h0;
    prp_req_dptr  <= 128'h0;
    prp_req_nlb   <= 16'h0;   
end else begin
    case(prp_state)
        SQ_IDLE: begin
            if(sq_req_valid & sq_req_ready) begin
                prp_state     <= SQ_GEN;
                prp_req_valid <= 1'b1;
				prp_req_opc   <= opc;
                prp_req_cid   <= cid;
                prp_req_dptr  <= dptr;
                prp_req_nlb   <= nlb;               
            end
        end
        SQ_GEN: begin
            if(prp_req_ready) begin
                prp_state    <= SQ_IDLE;
                prp_req_valid <= 1'b0;
//                prp_req_opc   <= 8'h0;
//                prp_req_cid   <= 16'h0;
//                prp_req_dptr  <= 128'h0;
//                prp_req_nlb   <= 16'h0;  
            end
        end
    endcase
end



// CQ respond MUX
localparam 
    CQ_IDLE = 2'h0,
    CQ_PICK = 2'h1,
    CQ_OUT  = 2'h2;

reg [1:0] cq_state;

//assign byp_res_ready = (cq_state == CQ_IDLE) & byp_res_valid;
//assign c2h_res_ready = (cq_state == CQ_IDLE) & c2h_res_valid & (~byp_res_valid);
//assign o_res_ready   = (cq_state == CQ_IDLE) & i_res_valid & (~c2h_res_valid) & (~byp_res_valid);

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    cq_state     <= CQ_IDLE;
    cq_res_valid <= 1'b0;
    cq_res_data  <= 128'h0;
end else begin
    case(cq_state) 
        CQ_IDLE: begin
            if(byp_res_valid | c2h_res_valid | i_res_valid) begin
                cq_state     <= CQ_PICK;
            end
        end
        CQ_PICK: begin
            cq_state     <= CQ_OUT;
            cq_res_valid <= 1'b1;
            if(byp_res_valid) begin
                cq_res_data  <= byp_res_data;
            end else if(c2h_res_valid) begin
                cq_res_data  <= c2h_res_data;
            end else begin
                cq_res_data  <= i_res_data;
            end
        end
        CQ_OUT: begin
            if(cq_res_valid & cq_res_ready) begin
                cq_state     <= CQ_IDLE;
                cq_res_valid <= 1'b0;
//                cq_res_data  <= 128'h0;
            end
        end
    endcase
end


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    byp_res_ready <= 1'h0;
    c2h_res_ready <= 1'h0;
    o_res_ready   <= 1'h0;
end else if((cq_state == CQ_PICK) & byp_res_valid) begin
    byp_res_ready <= 1'h1;
    c2h_res_ready <= 1'h0;
    o_res_ready   <= 1'h0;
end else if((cq_state == CQ_PICK) & c2h_res_valid) begin
    byp_res_ready <= 1'h0;
    c2h_res_ready <= 1'h1;
    o_res_ready   <= 1'h0;
end else if(cq_state == CQ_PICK) begin
    byp_res_ready <= 1'h0;
    c2h_res_ready <= 1'h0;
    o_res_ready   <= 1'h1;
end else begin
    byp_res_ready <= 1'h0;
    c2h_res_ready <= 1'h0;
    o_res_ready   <= 1'h0;
end 


endmodule
