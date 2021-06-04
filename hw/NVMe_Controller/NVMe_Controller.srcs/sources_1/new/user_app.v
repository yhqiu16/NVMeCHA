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
// Create Date: 10/13/2020 11:28:42 AM
// Design Name: 
// Module Name: user_app
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


module user_app#(
    parameter DATA_WIDTH = 256  // cannot change
)(
    input                         clk,
    input                         rst_n,
    
    // request fifo write ports
    output                        o_req_ready, 
    input                         i_req_valid,
    input                 [255:0] i_req_data,
    
    // response fifo read ports
    input                         i_res_ready,
    output reg                    o_res_valid,
    output reg            [127:0] o_res_data,  
    
    // write data fifo axi-stream interfaces
    output [23 : 0]               s_data_avail,  // availiable data number to write
    output                        s_axis_tready, 
    input                         s_axis_tvalid,                     
    input  [DATA_WIDTH - 1 : 0]   s_axis_tdata, 
    input                         s_axis_tlast, 
    
    // read data fifo axi-stream interfaces
    input                         m_axis_tready,
    output                        m_axis_tvalid,                        
    output [  DATA_WIDTH - 1 : 0] m_axis_tdata,
    output [15:0]                 m_axis_tid,
    output                        m_axis_tlast
);
    
//(*MARK_DEBUG="true"*)

localparam 
    REQ_IDLE     = 2'h0,
    REQ_DISPATCH = 2'h1,
    REQ_FINISH   = 2'h2,
    REC_IDLE     = 1'h0,
    REC_WAIT     = 1'h1;
    
reg [  1:0] req_state;

reg         wr_req_state;
reg         wr_rec_state;
wire        wr_req_ready;
reg         wr_req_valid;   
reg  [15:0] wr_req_id;
reg  [23:0] wr_req_len;
wire        wr_rec_ready;
reg         wr_rec_valid;
reg  [15:0] wr_rec_id;
reg  [23:0] wr_rec_len;
reg         wr_res_ready;
wire        wr_res_valid;
wire [79:0] wr_res_data;

reg         rd_req_state;
reg         rd_rec_state;
wire        rd_req_ready;
reg         rd_req_valid;   
reg  [15:0] rd_req_id;
reg  [23:0] rd_req_len;
wire        rd_rec_ready;
reg         rd_rec_valid;
reg  [15:0] rd_rec_id;
reg  [23:0] rd_rec_len;
wire        rd_res_ready;
wire        rd_res_valid;
wire [79:0] rd_res_data;

reg         ot_req_state;
reg         ot_rec_state;
wire        ot_req_ready;
reg         ot_req_valid;   
reg  [15:0] ot_req_id;
//reg  [23:0] ot_req_len;
wire        ot_rec_ready;
reg         ot_rec_valid;
reg  [15:0] ot_rec_id;
//reg  [23:0] ot_rec_len;
reg         ot_res_ready;
wire        ot_res_valid;
wire [79:0] ot_res_data;

reg [255:0] req_data_r;
wire [15:0] i_cmd;
wire [15:0] i_cmd_id;
wire [23:0] i_len;

assign i_cmd     = req_data_r[15:0];
assign i_cmd_id  = req_data_r[31:16];
assign i_len     = req_data_r[95:72];


//always@(posedge clk or negedge rst_n)
//if(~rst_n) begin
//    o_req_ready <= 1'b0;
//end else if((req_state == REQ_IDLE) & (~i_req_valid)) begin
//    o_req_ready <= 1'b1;
//end else begin
//    o_req_ready <= 1'b0;
//end

assign o_req_ready = (req_state == REQ_IDLE);

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    req_state    <= REQ_IDLE;
    req_data_r   <= 256'h0;
end else begin
    case(req_state) 
        REQ_IDLE: begin
            if(i_req_valid) begin
                req_state  <= REQ_DISPATCH;
                req_data_r <= i_req_data;
            end          
        end                
        
        REQ_DISPATCH: begin
            if(((i_cmd[7:0] == 8'h80) & (wr_req_state == REC_IDLE)) ||
               ((i_cmd[7:0] == 8'h00) & (rd_req_state == REC_IDLE)) ||
               ((i_cmd[7:0] != 8'h00) & (i_cmd[7:0] != 8'h80) & (ot_req_state == REC_IDLE)))
                req_state   <= REQ_FINISH;    
        end

        REQ_FINISH: begin
//            if((wr_req_valid & wr_req_ready) || (rd_req_valid & rd_req_ready) || (ot_req_valid & ot_req_ready)) begin
                req_state   <= REQ_IDLE;
//            end
        end        
    endcase
end



always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    wr_req_state <= REC_IDLE;
    wr_req_valid <= 1'h0;  
    wr_req_id    <= 16'h0;
    wr_req_len   <= 24'h0; 
end else begin
    case(wr_req_state) 
        REC_IDLE: begin
            if((req_state == REQ_DISPATCH) & (i_cmd[7:0] == 8'h80)) begin
                wr_req_state <= REC_WAIT;
                wr_req_valid <= 1'h1;
                wr_req_id    <= i_cmd_id;
                wr_req_len   <= i_len;
            end          
        end                
        REC_WAIT: begin
            if(wr_req_valid & wr_req_ready) begin
                wr_req_state <= REC_IDLE;
                wr_req_valid <= 1'h0; 
            end
        end        
    endcase
end

assign wr_req_ready = (wr_rec_state == REC_IDLE);

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    wr_rec_state <= REC_IDLE;
    wr_rec_valid <= 1'h0;   
    wr_rec_id    <= 16'h0;
    wr_rec_len   <= 24'h0; 
end else begin
    case(wr_rec_state) 
        REC_IDLE: begin
            if(wr_req_valid) begin
                wr_rec_state <= REC_WAIT;
                wr_rec_valid <= 1'h1;
                wr_rec_id    <= wr_req_id;
                wr_rec_len   <= wr_req_len; 
            end          
        end                

        REC_WAIT: begin
            if(wr_rec_valid & wr_rec_ready) begin
                wr_rec_state <= REC_IDLE;
                wr_rec_valid <= 1'h0; 
            end
        end        
    endcase
end


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    rd_req_state <= REC_IDLE;
    rd_req_valid <= 1'h0;  
    rd_req_id    <= 16'h0;
    rd_req_len   <= 24'h0; 
end else begin
    case(rd_req_state) 
        REC_IDLE: begin
            if((req_state == REQ_DISPATCH) & (i_cmd[7:0] == 8'h00)) begin
                rd_req_state <= REC_WAIT;
                rd_req_valid <= 1'h1;
                rd_req_id    <= i_cmd_id;
                rd_req_len   <= i_len;
            end          
        end                
        REC_WAIT: begin
            if(rd_req_valid & rd_req_ready) begin
                rd_req_state <= REC_IDLE;
                rd_req_valid <= 1'h0; 
            end
        end        
    endcase
end

assign rd_req_ready = (rd_rec_state == REC_IDLE);

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    rd_rec_state <= REC_IDLE;
    rd_rec_valid <= 1'h0;   
    rd_rec_id    <= 16'h0;
    rd_rec_len   <= 24'h0; 
end else begin
    case(rd_rec_state) 
        REC_IDLE: begin
            if(rd_req_valid) begin
                rd_rec_state <= REC_WAIT;
                rd_rec_valid <= 1'h1;
                rd_rec_id    <= rd_req_id;
                rd_rec_len   <= rd_req_len; 
            end          
        end                

        REC_WAIT: begin
            if(rd_rec_valid & rd_rec_ready) begin
                rd_rec_state <= REC_IDLE;
                rd_rec_valid <= 1'h0; 
            end
        end        
    endcase
end


always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    ot_req_state <= REC_IDLE;
    ot_req_valid <= 1'h0;  
    ot_req_id    <= 16'h0;
//    ot_req_len   <= 24'h0; 
end else begin
    case(ot_req_state) 
        REC_IDLE: begin
            if((req_state == REQ_DISPATCH) & (i_cmd[7:0] != 8'h00) & (i_cmd[7:0] != 8'h80)) begin
                ot_req_state <= REC_WAIT;
                ot_req_valid <= 1'h1;
                ot_req_id    <= i_cmd_id;
//                ot_req_len   <= i_len;
            end          
        end                
        REC_WAIT: begin
            if(ot_req_valid & ot_req_ready) begin
                ot_req_state <= REC_IDLE;
                ot_req_valid <= 1'h0; 
            end
        end        
    endcase
end

assign ot_req_ready = (ot_rec_state == REC_IDLE);

always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    ot_rec_state <= REC_IDLE;
    ot_rec_valid <= 1'h0;   
    ot_rec_id    <= 16'h0;
//    ot_rec_len   <= 24'h0; 
end else begin
    case(ot_rec_state) 
        REC_IDLE: begin
            if(ot_req_valid) begin
                ot_rec_state <= REC_WAIT;
                ot_rec_valid <= 1'h1;
                ot_rec_id    <= ot_req_id;
//                ot_rec_len   <= ot_req_len; 
            end          
        end                

        REC_WAIT: begin
            if(ot_rec_valid & ot_rec_ready) begin
                ot_rec_state <= REC_IDLE;
                ot_rec_valid <= 1'h0; 
            end
        end        
    endcase
end





user_write user_write(
    .clk          (clk            ),            
    .rst_n        (rst_n          ),              
    .o_req_ready  (wr_rec_ready   ),                    
    .i_req_valid  (wr_rec_valid   ),                    
    .i_req_len    (wr_rec_len     ),                   
    .i_req_id     (wr_rec_id      ),                    
    .i_res_ready  (wr_res_ready   ),                    
    .o_res_valid  (wr_res_valid   ),                    
    .o_res_data   (wr_res_data    ),                   
    .o_data_avail (s_data_avail   ),                     
    .o_axis_ready (s_axis_tready  ),                     
    .i_axis_valid (s_axis_tvalid  ),                     
    .i_axis_data  (s_axis_tdata   ),                    
    .i_axis_last  (s_axis_tlast   )                    
);


user_read user_read(
    .clk          (clk           ),            
    .rst_n        (rst_n         ),                 
    .o_req_ready  (rd_rec_ready  ),                    
    .i_req_valid  (rd_rec_valid  ),                    
    .i_req_len    (rd_rec_len    ),                   
    .i_req_id     (rd_rec_id     ),                   
    .i_res_ready  (rd_res_ready  ),                    
    .o_res_valid  (rd_res_valid  ),                    
    .o_res_data   (rd_res_data   ),                      
    .i_axis_ready (m_axis_tready ),                     
    .o_axis_valid (m_axis_tvalid ),                     
    .o_axis_data  (m_axis_tdata  ),
    .o_axis_id    (m_axis_tid    ),                    
    .o_axis_last  (m_axis_tlast  )                    
);


user_other_cmd user_other_cmd(
    .clk          (clk            ),            
    .rst_n        (rst_n          ),              
    .o_req_ready  (ot_rec_ready   ),                    
    .i_req_valid  (ot_rec_valid   ),                                      
    .i_req_id     (ot_rec_id      ),                    
    .i_res_ready  (ot_res_ready   ),                    
    .o_res_valid  (ot_res_valid   ),                    
    .o_res_data   (ot_res_data    )                   
);




assign rd_res_ready = 1'b1;


localparam 
    RES_IDLE = 2'h0,
    RES_PICK = 2'h1,
    RES_OUT  = 2'h2;
    
reg [1:0] res_state;


// do not output Read response
always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    res_state    <= RES_IDLE;
    o_res_valid  <= 1'h0;
    o_res_data   <= 128'h0;
end else begin
    case(res_state) 
        RES_IDLE: begin
            if(wr_res_valid | ot_res_valid) begin
                res_state <= RES_PICK;
            end          
        end                
        
        RES_PICK: begin
            res_state   <= RES_OUT;
            o_res_valid <= 1'h1;
            if(wr_res_valid) begin
                o_res_data <= {16'h0, wr_res_data[79:64], 32'h0, wr_res_data[63:0]};
            end else begin
                o_res_data <= {16'h0, ot_res_data[79:64], 32'h0, ot_res_data[63:0]};
            end         
        end

        RES_OUT: begin
            if(o_res_valid & i_res_ready) begin
                res_state   <= RES_IDLE;
                o_res_valid <= 1'h0;
            end
        end        
    endcase
end



always@(posedge clk or negedge rst_n)
if(~rst_n) begin
    wr_res_ready <= 1'h0;
    ot_res_ready <= 1'h0;
end else if((res_state == RES_PICK) & wr_res_valid) begin
    wr_res_ready <= 1'h1;
    ot_res_ready <= 1'h0;
end else if(res_state == RES_PICK) begin
    wr_res_ready <= 1'h0;
    ot_res_ready <= 1'h1;
end else begin
    wr_res_ready <= 1'h0;
    ot_res_ready <= 1'h0;
end 


//always@(posedge clk or negedge rst_n)
//if(~rst_n) begin
//    res_state    <= RES_IDLE;
//    o_res_valid  <= 1'h0;
//    o_res_data   <= 128'h0;
//end else begin
//    case(res_state) 
//        RES_IDLE: begin
//            if(rd_res_valid | wr_res_valid | ot_res_valid) begin
//                res_state <= RES_PICK;
//            end          
//        end                
        
//        RES_PICK: begin
//            res_state   <= RES_OUT;
//            o_res_valid <= 1'h1;
//            if(rd_res_valid) begin                                         
//                o_res_data <= {16'h0, rd_res_data[79:64], 32'h0, rd_res_data[63:0]};
//            end else if(wr_res_valid) begin
//                o_res_data <= {16'h0, wr_res_data[79:64], 32'h0, wr_res_data[63:0]};
//            end else begin
//                o_res_data <= {16'h0, ot_res_data[79:64], 32'h0, ot_res_data[63:0]};
//            end         
//        end

//        RES_OUT: begin
//            if(o_res_valid & i_res_ready) begin
//                res_state   <= RES_IDLE;
//                o_res_valid <= 1'h0;
//            end
//        end        
//    endcase
//end



//always@(posedge clk or negedge rst_n)
//if(~rst_n) begin
//    rd_res_ready <= 1'h0;
//    wr_res_ready <= 1'h0;
//    ot_res_ready <= 1'h0;
//end else if((res_state == RES_PICK) & rd_res_valid) begin
//    rd_res_ready <= 1'h1;
//    wr_res_ready <= 1'h0;
//    ot_res_ready <= 1'h0;
//end else if((res_state == RES_PICK) & wr_res_valid) begin
//    rd_res_ready <= 1'h0;
//    wr_res_ready <= 1'h1;
//    ot_res_ready <= 1'h0;
//end else if(res_state == RES_PICK) begin
//    rd_res_ready <= 1'h0;
//    wr_res_ready <= 1'h0;
//    ot_res_ready <= 1'h1;
//end else begin
//    rd_res_ready <= 1'h0;
//    wr_res_ready <= 1'h0;
//    ot_res_ready <= 1'h0;
//end   
    
    
    
    
endmodule
