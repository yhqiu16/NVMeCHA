// (c) Copyright 2011-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
// Register Slice
//   Generic single-channel AXI pipeline register on forward and/or reverse signal path
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axic_sync_clock_converter
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_axisc_sync_clock_converter # (
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
  parameter C_FAMILY     = "virtex6",
  parameter integer C_PAYLOAD_WIDTH = 32,
  parameter integer C_S_ACLK_RATIO = 1,
  parameter integer C_M_ACLK_RATIO = 1,
  parameter integer C_MODE = 1  // 0 = light-weight (1-deep); 1 = fully-pipelined (2-deep)
  )
 (
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
  input wire                         SAMPLE_CYCLE_EARLY,
  input wire                         SAMPLE_CYCLE,
  // Slave side
  input  wire                        S_ACLK,
  input  wire                        S_ARESETN,
  input  wire [C_PAYLOAD_WIDTH-1:0]  S_PAYLOAD,
  input  wire                        S_VALID,
  output wire                        S_READY,

  // Master side
  input  wire                        M_ACLK,
  input  wire                        M_ARESETN,
  output wire [C_PAYLOAD_WIDTH-1:0]  M_PAYLOAD,
  output wire                        M_VALID,
  input  wire                        M_READY
);

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
localparam [1:0] ZERO = 2'b10;
localparam [1:0] ONE  = 2'b11;
localparam [1:0] FULL = 2'b01;
localparam [1:0] INIT = 2'b00;
localparam integer P_LIGHT_WT = 0;
localparam integer P_FULLY_REG = 1;

////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////

generate
  if (C_S_ACLK_RATIO == C_M_ACLK_RATIO) begin : gen_passthru
    assign M_PAYLOAD = S_PAYLOAD;
    assign M_VALID   = S_VALID;
    assign S_READY   = M_READY;      
  end else begin : gen_sync_clock_converter
    wire s_sample_cycle;
    wire s_sample_cycle_early;
    wire m_sample_cycle;
    wire m_sample_cycle_early;

    wire slow_aclk;
    wire slow_areset;
    reg  s_areset_r;
    reg  m_areset_r;
   
    reg  s_ready_r; 
    wire s_ready_ns; 
    reg  m_valid_r; 
    wire m_valid_ns; 
    reg  [C_PAYLOAD_WIDTH-1:0] m_payload_r;
    reg  [C_PAYLOAD_WIDTH-1:0] m_storage_r;
    wire [C_PAYLOAD_WIDTH-1:0] m_payload_ns; 
    wire [C_PAYLOAD_WIDTH-1:0] m_storage_ns; 
    reg  m_ready_hold;
    wire m_ready_sample;
    wire load_payload;
    wire load_storage;
    wire load_payload_from_storage;
    reg [1:0] state;
    reg [1:0] next_state;
    
    always @(posedge S_ACLK) begin
      s_areset_r <= ~(S_ARESETN & M_ARESETN);
    end
  
    always @(posedge M_ACLK) begin
      m_areset_r <= ~(S_ARESETN & M_ARESETN);
    end

    assign slow_aclk   = (C_S_ACLK_RATIO > C_M_ACLK_RATIO) ? M_ACLK   : S_ACLK;
    assign slow_areset = (C_S_ACLK_RATIO > C_M_ACLK_RATIO) ? m_areset_r : s_areset_r;
    assign s_sample_cycle_early = (C_S_ACLK_RATIO > C_M_ACLK_RATIO) ? SAMPLE_CYCLE_EARLY : 1'b1;
    assign s_sample_cycle       = (C_S_ACLK_RATIO > C_M_ACLK_RATIO) ? SAMPLE_CYCLE : 1'b1;
    assign m_sample_cycle_early = (C_S_ACLK_RATIO > C_M_ACLK_RATIO) ? 1'b1 : SAMPLE_CYCLE_EARLY;
    assign m_sample_cycle       = (C_S_ACLK_RATIO > C_M_ACLK_RATIO) ? 1'b1 : SAMPLE_CYCLE;

    // Output flop for S_READY, value is encoded into state machine.
    assign s_ready_ns = (C_S_ACLK_RATIO > C_M_ACLK_RATIO) ? state[1] & (state != INIT) : next_state[1];

    always @(posedge S_ACLK) begin 
      if (s_areset_r) begin
        s_ready_r <= 1'b0;
      end
      else begin
        s_ready_r <= s_sample_cycle_early ? s_ready_ns : 1'b0;
      end
    end

    assign S_READY = s_ready_r;

    // Output flop for M_VALID
    assign m_valid_ns = next_state[0];

    always @(posedge M_ACLK) begin 
      if (m_areset_r) begin
        m_valid_r <= 1'b0;
      end
      else begin
        m_valid_r <= m_sample_cycle ? m_valid_ns : m_valid_r & ~M_READY;
      end
    end

    assign M_VALID = m_valid_r;

    // Hold register for M_READY when M_ACLK is fast.
    always @(posedge M_ACLK) begin 
      if (m_areset_r) begin
        m_ready_hold <= 1'b0;
      end
      else begin
        m_ready_hold <= m_sample_cycle ? 1'b0 : m_ready_sample;
      end
    end

    assign m_ready_sample = (M_READY ) | m_ready_hold;
    // Output/storage flops for PAYLOAD
    assign m_payload_ns = ~load_payload ? m_payload_r :
                           load_payload_from_storage ? m_storage_r : 
                           S_PAYLOAD;

    assign m_storage_ns = (C_MODE == P_FULLY_REG) ? (load_storage ? S_PAYLOAD : m_storage_r) : {C_PAYLOAD_WIDTH{1'b0}};

    always @(posedge slow_aclk) begin 
      m_payload_r <= m_payload_ns;
      m_storage_r <= (C_MODE == P_FULLY_REG) ? m_storage_ns : 0;
    end

    assign M_PAYLOAD = m_payload_r;

    // load logic
    assign load_storage = (C_MODE == P_FULLY_REG) && (state != FULL);
    assign load_payload = m_ready_sample || (state == ZERO);
    assign load_payload_from_storage = (C_MODE == P_FULLY_REG) && (state == FULL) && m_ready_sample;
    
    // State machine
    always @(posedge slow_aclk) begin 
      state <= next_state;
    end

    always @* begin 
      if (slow_areset) begin 
        next_state = INIT;
      end else begin
        case (state)
          INIT: begin
            next_state = ZERO;
          end
          // No transaction stored locally
          ZERO: begin
            if (S_VALID) begin
              next_state = (C_MODE == P_FULLY_REG) ? ONE : FULL; // Push from empty
            end
            else begin
              next_state = ZERO;
            end
          end

          // One transaction stored locally
          ONE: begin
            if (m_ready_sample & ~S_VALID) begin 
              next_state = ZERO; // Read out one so move to ZERO
            end
            else if (~m_ready_sample & S_VALID) begin
              next_state = FULL;  // Got another one so move to FULL
            end
            else begin
              next_state = ONE;
            end
          end

          // Storage registers full
          FULL: begin 
            if (m_ready_sample) begin
              next_state = (C_MODE == P_FULLY_REG) ? ONE : ZERO; // Pop from full
            end
            else begin
              next_state = FULL;
            end
          end
        endcase // case (state)
      end
    end
  end // gen_sync_clock_converter
  endgenerate
endmodule // axisc_sync_clock_converter

`default_nettype wire


// (c) Copyright 2011-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
// Register Slice
//   Generic single-channel AXI pipeline register on forward and/or reverse signal path
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axic_register_slice
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_axisc_sample_cycle_ratio # (
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
  parameter C_RATIO = 2 // Must be > 0
  )
 (
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
  input  wire                    SLOW_ACLK,
  input  wire                    FAST_ACLK,

  output wire                    SAMPLE_CYCLE_EARLY,
  output wire                    SAMPLE_CYCLE
);

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
localparam P_DELAY = C_RATIO > 2 ? C_RATIO-1 : C_RATIO-1; 
////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
reg                slow_aclk_div2 = 0;
reg                posedge_finder_first;
reg                posedge_finder_second;
wire               first_edge;
wire               second_edge;
reg  [P_DELAY-1:0] sample_cycle_d;
(* shreg_extract = "no" *) reg                sample_cycle_r;


////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////
generate
  if (C_RATIO == 1) begin : gen_always_sample
    assign SAMPLE_CYCLE_EARLY = 1'b1;
    assign SAMPLE_CYCLE = 1'b1;
  end
  else begin : gen_sample_cycle
    genvar i;
    always @(posedge SLOW_ACLK) begin 
      slow_aclk_div2 <= ~slow_aclk_div2;
    end

    // Find matching rising edges by clocking slow_aclk_div2 onto faster clock
    always @(posedge FAST_ACLK) begin 
      posedge_finder_first <= slow_aclk_div2;
    end
    always @(posedge FAST_ACLK) begin 
      posedge_finder_second <= ~slow_aclk_div2;
    end

    assign first_edge = slow_aclk_div2 & ~posedge_finder_first;
    assign second_edge = ~slow_aclk_div2 & ~posedge_finder_second;

    always @(*) begin 
      sample_cycle_d[P_DELAY-1] = first_edge | second_edge;
    end
   
    // delay the posedge alignment by C_RATIO - 1 to set the sample cycle as
    // the clock one cycle before the posedge.
    for (i = P_DELAY-1; i > 0; i = i - 1) begin : gen_delay
      always @(posedge FAST_ACLK) begin
        sample_cycle_d[i-1] <= sample_cycle_d[i];
      end
    end

    always @(posedge FAST_ACLK) begin 
      sample_cycle_r <= sample_cycle_d[0];
    end
    assign SAMPLE_CYCLE_EARLY = sample_cycle_d[0];
    assign SAMPLE_CYCLE = sample_cycle_r;
  end
endgenerate

endmodule // axisc_sample_cycle_ratio

`default_nettype wire


//  (c) Copyright 2011-2013 Xilinx, Inc. All rights reserved.
//
//  This file contains confidential and proprietary information
//  of Xilinx, Inc. and is protected under U.S. and
//  international copyright and other intellectual property
//  laws.
//
//  DISCLAIMER
//  This disclaimer is not a license and does not grant any
//  rights to the materials distributed herewith. Except as
//  otherwise provided in a valid license issued to you by
//  Xilinx, and to the maximum extent permitted by applicable
//  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
//  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//  (2) Xilinx shall not be liable (whether in contract or tort,
//  including negligence, or under any other theory of
//  liability) for any loss or damage of any kind or nature
//  related to, arising under or in connection with these
//  materials, including for any direct, or any indirect,
//  special, incidental, or consequential loss or damage
//  (including loss of data, profits, goodwill, or any type of
//  loss or damage suffered as a result of any action brought
//  by a third party) even if such damage or loss was
//  reasonably foreseeable or Xilinx had been advised of the
//  possibility of the same.
//
//  CRITICAL APPLICATIONS
//  Xilinx products are not designed or intended to be fail-
//  safe, or for use in any application requiring fail-safe
//  performance, such as life-support or safety devices or
//  systems, Class III medical devices, nuclear facilities,
//  applications related to the deployment of airbags, or any
//  other applications that could lead to death, personal
//  injury, or severe property or environmental damage
//  (individually and collectively, "Critical
//  Applications"). Customer assumes the sole risk and
//  liability of any use of Xilinx products in Critical
//  Applications, subject only to applicable laws and
//  regulations governing limitations on product liability.
//
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//  PART OF THIS FILE AT ALL TIMES. 
//-----------------------------------------------------------------------------
//
// axis_clock_converter
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axis_clock_converter
//     util_aclken_converter (optional)
//     fifo_generator
//       or
//     axisc_sync_clock_converter
//     util_aclken_converter (optional)
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_axis_clock_converter #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
  parameter         C_FAMILY           = "virtex6",
  parameter integer C_AXIS_TDATA_WIDTH = 32,
  parameter integer C_AXIS_TID_WIDTH   = 1,
  parameter integer C_AXIS_TDEST_WIDTH = 1,
  parameter integer C_AXIS_TUSER_WIDTH = 1,
  parameter [31:0]  C_AXIS_SIGNAL_SET  = 32'hFF,
  // C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional signals are present
  //   [0] => TREADY present
  //   [1] => TDATA present
  //   [2] => TSTRB present, TDATA must be present
  //   [3] => TKEEP present, TDATA must be present
  //   [4] => TLAST present
  //   [5] => TID present
  //   [6] => TDEST present
  //   [7] => TUSER present
  parameter         C_IS_ACLK_ASYNC     = 1'b1,
  parameter integer C_S_AXIS_ACLK_RATIO = 1,
  parameter integer C_M_AXIS_ACLK_RATIO = 1,
  parameter integer C_ACLKEN_CONV_MODE  = 0,
  // C_ACLKEN_CONV_MODE: Determines how to handle the clock enable pins during
  // clock conversion
  // 0 -- Clock enables not converted
  // 1 -- S_AXIS_ACLKEN can toggle,  M_AXIS_ACLKEN always high.
  // 2 -- S_AXIS_ACLKEN always high, M_AXIS_ACLKEN can toggle.
  // 3 -- S_AXIS_ACLKEN can toggle,  M_AXIS_ACLKEN can toggle.
  parameter integer C_SYNCHRONIZER_STAGE = 2
  )
  (
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
   // System Signals
   input wire                             S_AXIS_ARESETN,
   input wire                             M_AXIS_ARESETN,
   input wire                             S_AXIS_ACLKEN,
   input wire                             M_AXIS_ACLKEN,

   // Slave side
   input  wire                            S_AXIS_ACLK,
   input  wire                            S_AXIS_TVALID,
   output wire                            S_AXIS_TREADY,
   input  wire [C_AXIS_TDATA_WIDTH-1:0]   S_AXIS_TDATA,
   input  wire [C_AXIS_TDATA_WIDTH/8-1:0] S_AXIS_TSTRB,
   input  wire [C_AXIS_TDATA_WIDTH/8-1:0] S_AXIS_TKEEP,
   input  wire                            S_AXIS_TLAST,
   input  wire [C_AXIS_TID_WIDTH-1:0]     S_AXIS_TID,
   input  wire [C_AXIS_TDEST_WIDTH-1:0]   S_AXIS_TDEST,
   input  wire [C_AXIS_TUSER_WIDTH-1:0]   S_AXIS_TUSER,

   // Master side
   input  wire                            M_AXIS_ACLK,
   output wire                            M_AXIS_TVALID,
   input  wire                            M_AXIS_TREADY,
   output wire [C_AXIS_TDATA_WIDTH-1:0]   M_AXIS_TDATA,
   output wire [C_AXIS_TDATA_WIDTH/8-1:0] M_AXIS_TSTRB,
   output wire [C_AXIS_TDATA_WIDTH/8-1:0] M_AXIS_TKEEP,
   output wire                            M_AXIS_TLAST,
   output wire [C_AXIS_TID_WIDTH-1:0]     M_AXIS_TID,
   output wire [C_AXIS_TDEST_WIDTH-1:0]   M_AXIS_TDEST,
   output wire [C_AXIS_TUSER_WIDTH-1:0]   M_AXIS_TUSER

   );

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
`include "axis_interconnect_v1_1_18.vh"

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
localparam integer LP_S_ACLKEN_CAN_TOGGLE = (C_ACLKEN_CONV_MODE == 1) || (C_ACLKEN_CONV_MODE == 3);
localparam integer LP_M_ACLKEN_CAN_TOGGLE = (C_ACLKEN_CONV_MODE == 2) || (C_ACLKEN_CONV_MODE == 3);
localparam integer P_FIFO_MODE            = 1;  // clock converter use of fifo_gen will not 
                                                // use packet mode.                                           
localparam integer P_FIFO_DEPTH           = 32; // clock converter use of fifo_gen be fixed 
                                                // at 32 deep fifo.
                                          
localparam integer P_S_AXIS_ACLK_RATIO    = f_lcm(C_S_AXIS_ACLK_RATIO, C_M_AXIS_ACLK_RATIO) / C_M_AXIS_ACLK_RATIO;
localparam integer P_M_AXIS_ACLK_RATIO    = f_lcm(C_S_AXIS_ACLK_RATIO, C_M_AXIS_ACLK_RATIO) / C_S_AXIS_ACLK_RATIO;
                                          
localparam integer P_INST_FIFO_GEN        =  C_IS_ACLK_ASYNC || (P_S_AXIS_ACLK_RATIO != 1 && P_M_AXIS_ACLK_RATIO != 1);
                                          
localparam integer P_TPAYLOAD_WIDTH       = f_payload_width(C_AXIS_TDATA_WIDTH, C_AXIS_TID_WIDTH, 
                                                 C_AXIS_TDEST_WIDTH, C_AXIS_TUSER_WIDTH, 
                                                 C_AXIS_SIGNAL_SET);
localparam integer P_SAMPLE_CYCLE_RATIO   = (C_S_AXIS_ACLK_RATIO > C_M_AXIS_ACLK_RATIO) 
                                            ? C_S_AXIS_ACLK_RATIO : C_M_AXIS_ACLK_RATIO;


////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
wire [P_TPAYLOAD_WIDTH-1:0] s_axis_tpayload;

wire [P_TPAYLOAD_WIDTH-1:0] d1_tpayload;
wire                        d1_tvalid;
wire                        d1_tready;

wire [P_TPAYLOAD_WIDTH-1:0] d2_tpayload;
wire                        d2_tvalid;
wire                        d2_tready;

wire [P_TPAYLOAD_WIDTH-1:0] m_axis_tpayload;


////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////



generate
  if (P_INST_FIFO_GEN) begin : gen_fifo_gen_ck_conv
    // Asynchronous and default is to use fifo_gen for clock conversion
    axis_interconnect_v1_1_18_axis_data_fifo #(
      .C_FAMILY           ( C_FAMILY           ) ,
      .C_AXIS_TDATA_WIDTH ( C_AXIS_TDATA_WIDTH ) ,
      .C_AXIS_TID_WIDTH   ( C_AXIS_TID_WIDTH   ) ,
      .C_AXIS_TDEST_WIDTH ( C_AXIS_TDEST_WIDTH ) ,
      .C_AXIS_TUSER_WIDTH ( C_AXIS_TUSER_WIDTH ) ,
      .C_AXIS_SIGNAL_SET  ( C_AXIS_SIGNAL_SET  ) ,
      .C_FIFO_DEPTH       ( P_FIFO_DEPTH       ) ,
      .C_FIFO_MODE        ( P_FIFO_MODE        ) ,
      .C_IS_ACLK_ASYNC    ( 1                  ) , // enables clock cross when 1
      .C_ACLKEN_CONV_MODE ( C_ACLKEN_CONV_MODE ) ,
      .C_SYNCHRONIZER_STAGE ( C_SYNCHRONIZER_STAGE )
    )
    axis_data_fifo_0
    (
      .S_AXIS_ARESETN ( S_AXIS_ARESETN ) ,
      .M_AXIS_ARESETN ( M_AXIS_ARESETN ) ,
      .S_AXIS_ACLK    ( S_AXIS_ACLK    ) ,
      .S_AXIS_ACLKEN  ( S_AXIS_ACLKEN  ) ,
      .S_AXIS_TVALID  ( S_AXIS_TVALID  ) ,
      .S_AXIS_TREADY  ( S_AXIS_TREADY  ) ,
      .S_AXIS_TDATA   ( S_AXIS_TDATA   ) ,
      .S_AXIS_TSTRB   ( S_AXIS_TSTRB   ) ,
      .S_AXIS_TKEEP   ( S_AXIS_TKEEP   ) ,
      .S_AXIS_TLAST   ( S_AXIS_TLAST   ) ,
      .S_AXIS_TID     ( S_AXIS_TID     ) ,
      .S_AXIS_TDEST   ( S_AXIS_TDEST   ) ,
      .S_AXIS_TUSER   ( S_AXIS_TUSER   ) ,
      .M_AXIS_ACLK    ( M_AXIS_ACLK    ) ,
      .M_AXIS_ACLKEN  ( M_AXIS_ACLKEN  ) ,
      .M_AXIS_TVALID  ( M_AXIS_TVALID  ) ,
      .M_AXIS_TREADY  ( M_AXIS_TREADY  ) ,
      .M_AXIS_TDATA   ( M_AXIS_TDATA   ) ,
      .M_AXIS_TSTRB   ( M_AXIS_TSTRB   ) ,
      .M_AXIS_TKEEP   ( M_AXIS_TKEEP   ) ,
      .M_AXIS_TLAST   ( M_AXIS_TLAST   ) ,
      .M_AXIS_TID     ( M_AXIS_TID     ) ,
      .M_AXIS_TDEST   ( M_AXIS_TDEST   ) ,
      .M_AXIS_TUSER   ( M_AXIS_TUSER   ) ,
      .AXIS_DATA_COUNT    (            ) ,
      .AXIS_WR_DATA_COUNT (            ) ,
      .AXIS_RD_DATA_COUNT (            ) 
    );
  end
  else begin : gen_sync_ck_conv

    wire                        slow_aclk;
    wire                        fast_aclk;
    wire                        sample_cycle_early;
    wire                        sample_cycle;

    axis_interconnect_v1_1_18_util_axis2vector #(
      .C_TDATA_WIDTH    ( C_AXIS_TDATA_WIDTH ) ,
      .C_TID_WIDTH      ( C_AXIS_TID_WIDTH   ) ,
      .C_TDEST_WIDTH    ( C_AXIS_TDEST_WIDTH ) ,
      .C_TUSER_WIDTH    ( C_AXIS_TUSER_WIDTH ) ,
      .C_TPAYLOAD_WIDTH ( P_TPAYLOAD_WIDTH   ) ,
      .C_SIGNAL_SET     ( C_AXIS_SIGNAL_SET  ) 
    )
    util_axis2vector_0 (
      .TDATA    ( S_AXIS_TDATA    ) ,
      .TSTRB    ( S_AXIS_TSTRB    ) ,
      .TKEEP    ( S_AXIS_TKEEP    ) ,
      .TLAST    ( S_AXIS_TLAST    ) ,
      .TID      ( S_AXIS_TID      ) ,
      .TDEST    ( S_AXIS_TDEST    ) ,
      .TUSER    ( S_AXIS_TUSER    ) ,
      .TPAYLOAD ( s_axis_tpayload )
    );

    if (LP_S_ACLKEN_CAN_TOGGLE) begin : gen_s_aclken_converter
      axis_interconnect_v1_1_18_util_aclken_converter #( 
        .C_PAYLOAD_WIDTH       ( P_TPAYLOAD_WIDTH       ) ,
        .C_S_ACLKEN_CAN_TOGGLE ( LP_S_ACLKEN_CAN_TOGGLE ) ,
        .C_M_ACLKEN_CAN_TOGGLE ( 0                      ) 
      )
      s_util_aclken_converter_0 ( 
        .ACLK      ( S_AXIS_ACLK     ) ,
        .ARESETN   ( S_AXIS_ARESETN  ) ,
        .S_ACLKEN  ( S_AXIS_ACLKEN   ) ,
        .S_PAYLOAD ( s_axis_tpayload ) ,
        .S_VALID   ( S_AXIS_TVALID   ) ,
        .S_READY   ( S_AXIS_TREADY   ) ,
        .M_ACLKEN  ( 1'b1            ) ,
        .M_PAYLOAD ( d1_tpayload     ) ,
        .M_VALID   ( d1_tvalid       ) ,
        .M_READY   ( d1_tready       )
      );
    end
    else begin : gen_s_aclken_passthru
      assign d1_tpayload = s_axis_tpayload;
      assign d1_tvalid   = S_AXIS_TVALID;
      assign S_AXIS_TREADY = d1_tready;
    end

    // Sample cycle used to determine when to assert a signal on a fast clock
    // to be flopped onto a slow clock.
    assign slow_aclk   = (C_S_AXIS_ACLK_RATIO > C_M_AXIS_ACLK_RATIO) ? M_AXIS_ACLK   : S_AXIS_ACLK;
    assign fast_aclk   = (C_S_AXIS_ACLK_RATIO < C_M_AXIS_ACLK_RATIO) ? M_AXIS_ACLK   : S_AXIS_ACLK;

    axis_interconnect_v1_1_18_axisc_sample_cycle_ratio #(
      .C_RATIO ( P_SAMPLE_CYCLE_RATIO )
    ) 
    axisc_sample_cycle_ratio_m (
      .SLOW_ACLK          ( slow_aclk          ) ,
      .FAST_ACLK          ( fast_aclk          ) ,
      .SAMPLE_CYCLE_EARLY ( sample_cycle_early ) ,
      .SAMPLE_CYCLE       ( sample_cycle       ) 
    );

    axis_interconnect_v1_1_18_axisc_sync_clock_converter #( 
      .C_FAMILY        ( C_FAMILY            ) ,
      .C_PAYLOAD_WIDTH ( P_TPAYLOAD_WIDTH    ) ,
      .C_S_ACLK_RATIO  ( P_S_AXIS_ACLK_RATIO ) ,
      .C_M_ACLK_RATIO  ( P_M_AXIS_ACLK_RATIO ) ,
      .C_MODE          ( 1 )
    )
    axisc_sync_clock_converter_0 (
      .SAMPLE_CYCLE_EARLY ( sample_cycle_early ) ,
      .SAMPLE_CYCLE       ( sample_cycle       ) ,
      .S_ACLK             ( S_AXIS_ACLK        ) ,
      .S_ARESETN          ( S_AXIS_ARESETN     ) ,
      .S_PAYLOAD          ( d1_tpayload        ) ,
      .S_VALID            ( d1_tvalid          ) ,
      .S_READY            ( d1_tready          ) ,
      .M_ACLK             ( M_AXIS_ACLK        ) ,
      .M_ARESETN          ( M_AXIS_ARESETN     ) ,
      .M_PAYLOAD          ( d2_tpayload        ) ,
      .M_VALID            ( d2_tvalid          ) ,
      .M_READY            ( d2_tready          ) 
    );

    if (LP_M_ACLKEN_CAN_TOGGLE) begin : gen_m_aclken_converter
      axis_interconnect_v1_1_18_util_aclken_converter #( 
        .C_PAYLOAD_WIDTH       ( P_TPAYLOAD_WIDTH       ) ,
        .C_S_ACLKEN_CAN_TOGGLE ( 0                      ) ,
        .C_M_ACLKEN_CAN_TOGGLE ( LP_M_ACLKEN_CAN_TOGGLE ) 
      )
      m_util_aclken_converter_0 ( 
        .ACLK      ( M_AXIS_ACLK     ) ,
        .ARESETN   ( M_AXIS_ARESETN  ) ,
        .S_ACLKEN  ( 1'b1            ) ,
        .S_PAYLOAD ( d2_tpayload     ) ,
        .S_VALID   ( d2_tvalid       ) ,
        .S_READY   ( d2_tready       ) ,
        .M_ACLKEN  ( M_AXIS_ACLKEN   ) ,
        .M_PAYLOAD ( m_axis_tpayload ) ,
        .M_VALID   ( M_AXIS_TVALID   ) ,
        .M_READY   ( M_AXIS_TREADY   ) 
      );
    end
    else begin : gen_m_aclken_passthru
      assign m_axis_tpayload = d2_tpayload;
      assign M_AXIS_TVALID = d2_tvalid;
      assign d2_tready = M_AXIS_TREADY;
    end

    axis_interconnect_v1_1_18_util_vector2axis #(
      .C_TDATA_WIDTH    ( C_AXIS_TDATA_WIDTH ) ,
      .C_TID_WIDTH      ( C_AXIS_TID_WIDTH   ) ,
      .C_TDEST_WIDTH    ( C_AXIS_TDEST_WIDTH ) ,
      .C_TUSER_WIDTH    ( C_AXIS_TUSER_WIDTH ) ,
      .C_TPAYLOAD_WIDTH ( P_TPAYLOAD_WIDTH   ) ,
      .C_SIGNAL_SET     ( C_AXIS_SIGNAL_SET  ) 
    )
    util_vector2axis_0 (
      .TPAYLOAD ( m_axis_tpayload ) ,
      .TDATA    ( M_AXIS_TDATA    ) ,
      .TSTRB    ( M_AXIS_TSTRB    ) ,
      .TKEEP    ( M_AXIS_TKEEP    ) ,
      .TLAST    ( M_AXIS_TLAST    ) ,
      .TID      ( M_AXIS_TID      ) ,
      .TDEST    ( M_AXIS_TDEST    ) ,
      .TUSER    ( M_AXIS_TUSER    ) 
    );
  end

endgenerate



endmodule // axis_clock_converter

`default_nettype wire


//  (c) Copyright 2012-2014 Xilinx, Inc. All rights reserved.
//
//  This file contains confidential and proprietary information
//  of Xilinx, Inc. and is protected under U.S. and
//  international copyright and other intellectual property
//  laws.
//
//  DISCLAIMER
//  This disclaimer is not a license and does not grant any
//  rights to the materials distributed herewith. Except as
//  otherwise provided in a valid license issued to you by
//  Xilinx, and to the maximum extent permitted by applicable
//  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
//  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//  (2) Xilinx shall not be liable (whether in contract or tort,
//  including negligence, or under any other theory of
//  liability) for any loss or damage of any kind or nature
//  related to, arising under or in connection with these
//  materials, including for any direct, or any indirect,
//  special, incidental, or consequential loss or damage
//  (including loss of data, profits, goodwill, or any type of
//  loss or damage suffered as a result of any action brought
//  by a third party) even if such damage or loss was
//  reasonably foreseeable or Xilinx had been advised of the
//  possibility of the same.
//
//  CRITICAL APPLICATIONS
//  Xilinx products are not designed or intended to be fail-
//  safe, or for use in any application requiring fail-safe
//  performance, such as life-support or safety devices or
//  systems, Class III medical devices, nuclear facilities,
//  applications related to the deployment of airbags, or any
//  other applications that could lead to death, personal
//  injury, or severe property or environmental damage
//  (individually and collectively, "Critical
//  Applications"). Customer assumes the sole risk and
//  liability of any use of Xilinx products in Critical
//  Applications, subject only to applicable laws and
//  regulations governing limitations on product liability.
//
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//  PART OF THIS FILE AT ALL TIMES. 
//-----------------------------------------------------------------------------
//
// axis_data_fifo
//   Instantiates AXIS FIFO Generator Core
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axis_data_fifo
//     fifo-generator_v9_3
//--------------------------------------------------------------------------

`timescale 1ps/1ps

module axis_interconnect_v1_1_18_axis_data_fifo #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter         C_FAMILY           = "virtex6",
   parameter integer C_AXIS_TDATA_WIDTH = 32,
   parameter integer C_AXIS_TID_WIDTH   = 1,
   parameter integer C_AXIS_TDEST_WIDTH = 1,
   parameter integer C_AXIS_TUSER_WIDTH = 1,
   parameter [31:0]  C_AXIS_SIGNAL_SET  = 32'hFF,
   // C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional signals are present
   //   [0] => TREADY present
   //   [1] => TDATA present
   //   [2] => TSTRB present, TDATA must be present
   //   [3] => TKEEP present, TDATA must be present
   //   [4] => TLAST present
   //   [5] => TID present
   //   [6] => TDEST present
   //   [7] => TUSER present
   parameter integer C_FIFO_DEPTH       = 1024,
   //  Valid values 16,32,64,128,256,512,1024,2048,4096,...
   parameter integer C_FIFO_MODE  = 1,
   // Values: 
   //   0 == N0 FIFO
   //   1 == Regular FIFO
   //   2 == Store and Forward FIFO (Packet Mode). Requires TLAST. 
   parameter integer C_IS_ACLK_ASYNC    = 0,
   //  Enables async clock cross when 1.
   parameter integer C_ACLKEN_CONV_MODE  = 0,
   // C_ACLKEN_CONV_MODE: Determines how to handle the clock enable pins during
   // clock conversion
   // 0 -- Clock enables not converted
   // 1 -- S_AXIS_ACLKEN can toggle,  M_AXIS_ACLKEN always high.
   // 2 -- S_AXIS_ACLKEN always high, M_AXIS_ACLKEN can toggle.
   // 3 -- S_AXIS_ACLKEN can toggle,  M_AXIS_ACLKEN can toggle.
   parameter integer C_SYNCHRONIZER_STAGE = 2
   )
  (
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
   // System Signals
   input wire                             S_AXIS_ARESETN,
   input wire                             M_AXIS_ARESETN,
/*   input wire ACLKEN,*/

   // Slave side
   input  wire                            S_AXIS_ACLK,
   input  wire                            S_AXIS_ACLKEN,
   input  wire                            S_AXIS_TVALID,
   output wire                            S_AXIS_TREADY,
   input  wire [C_AXIS_TDATA_WIDTH-1:0]   S_AXIS_TDATA,
   input  wire [C_AXIS_TDATA_WIDTH/8-1:0] S_AXIS_TSTRB,
   input  wire [C_AXIS_TDATA_WIDTH/8-1:0] S_AXIS_TKEEP,
   input  wire                            S_AXIS_TLAST,
   input  wire [C_AXIS_TID_WIDTH-1:0]     S_AXIS_TID,
   input  wire [C_AXIS_TDEST_WIDTH-1:0]   S_AXIS_TDEST,
   input  wire [C_AXIS_TUSER_WIDTH-1:0]   S_AXIS_TUSER,

   // Master side
   input  wire                            M_AXIS_ACLK,
   input  wire                            M_AXIS_ACLKEN,
   output wire                            M_AXIS_TVALID,
   input  wire                            M_AXIS_TREADY,
   output wire [C_AXIS_TDATA_WIDTH-1:0]   M_AXIS_TDATA,
   output wire [C_AXIS_TDATA_WIDTH/8-1:0] M_AXIS_TSTRB,
   output wire [C_AXIS_TDATA_WIDTH/8-1:0] M_AXIS_TKEEP,
   output wire                            M_AXIS_TLAST,
   output wire [C_AXIS_TID_WIDTH-1:0]     M_AXIS_TID,
   output wire [C_AXIS_TDEST_WIDTH-1:0]   M_AXIS_TDEST,
   output wire [C_AXIS_TUSER_WIDTH-1:0]   M_AXIS_TUSER,

   // Status signals
   output wire [31:0]                     AXIS_DATA_COUNT,
   output wire [31:0]                     AXIS_WR_DATA_COUNT,
   output wire [31:0]                     AXIS_RD_DATA_COUNT
   );

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
`include "axis_interconnect_v1_1_18.vh"

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
localparam P_TREADY_EXISTS = C_AXIS_SIGNAL_SET[0]? 1: 0;
localparam P_TDATA_EXISTS  = C_AXIS_SIGNAL_SET[1]? 1: 0;
localparam P_TSTRB_EXISTS  = C_AXIS_SIGNAL_SET[2]? 1: 0;
localparam P_TKEEP_EXISTS  = C_AXIS_SIGNAL_SET[3]? 1: 0;
localparam P_TLAST_EXISTS  = C_AXIS_SIGNAL_SET[4]? 1: 0;
localparam P_TID_EXISTS    = C_AXIS_SIGNAL_SET[5]? 1: 0;
localparam P_TDEST_EXISTS  = C_AXIS_SIGNAL_SET[6]? 1: 0;
localparam P_TUSER_EXISTS  = C_AXIS_SIGNAL_SET[7]? 1: 0;
localparam P_AXIS_PAYLOAD_WIDTH = f_payload_width(C_AXIS_TDATA_WIDTH, C_AXIS_TID_WIDTH, C_AXIS_TDEST_WIDTH, 
                                             C_AXIS_TUSER_WIDTH, C_AXIS_SIGNAL_SET);
localparam P_WR_PNTR_WIDTH = f_clogb2(C_FIFO_DEPTH);
localparam P_FIFO_COUNT_WIDTH = P_WR_PNTR_WIDTH+1;
localparam P_FIFO_TYPE     = (C_FIFO_DEPTH > 32) ? 1 : 2; // 1 = bram, 2 = lutram.  Force 1 when > 32 deep.
localparam P_IMPLEMENTATION_TYPE_AXIS = C_IS_ACLK_ASYNC ? P_FIFO_TYPE + 10 : P_FIFO_TYPE;
localparam P_COMMON_CLOCK  = C_IS_ACLK_ASYNC ? 0 : 1;
localparam P_MSGON_VAL     = C_IS_ACLK_ASYNC ? 0 : 1;

// Packet mode only valid if tlast is enabled.  Force to 0 if no TLAST
// present.
localparam integer P_APPLICATION_TYPE_AXIS = P_TLAST_EXISTS ? (C_FIFO_MODE == 2) : 0;
localparam integer LP_S_ACLKEN_CAN_TOGGLE = (C_ACLKEN_CONV_MODE == 1) || (C_ACLKEN_CONV_MODE == 3);
localparam integer LP_M_ACLKEN_CAN_TOGGLE = (C_ACLKEN_CONV_MODE == 2) || (C_ACLKEN_CONV_MODE == 3);
                                           

////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
wire [P_FIFO_COUNT_WIDTH-1:0]   axis_data_count_i;
wire [P_FIFO_COUNT_WIDTH-1:0]   axis_wr_data_count_i;
wire [P_FIFO_COUNT_WIDTH-1:0]   axis_rd_data_count_i;
(* KEEP = "TRUE" *)
wire                            s_and_m_aresetn_i;
wire                            d1_tvalid;
wire                            d1_tready;
wire [C_AXIS_TDATA_WIDTH-1:0]   d1_tdata;
wire [C_AXIS_TDATA_WIDTH/8-1:0] d1_tstrb;
wire [C_AXIS_TDATA_WIDTH/8-1:0] d1_tkeep;
wire                            d1_tlast;
wire [C_AXIS_TID_WIDTH-1:0]     d1_tid  ;
wire [C_AXIS_TDEST_WIDTH-1:0]   d1_tdest;
wire [C_AXIS_TUSER_WIDTH-1:0]   d1_tuser;

wire                            d2_tvalid;
wire                            d2_tready;
wire [C_AXIS_TDATA_WIDTH-1:0]   d2_tdata;
wire [C_AXIS_TDATA_WIDTH/8-1:0] d2_tstrb;
wire [C_AXIS_TDATA_WIDTH/8-1:0] d2_tkeep;
wire                            d2_tlast;
wire [C_AXIS_TID_WIDTH-1:0]     d2_tid  ;
wire [C_AXIS_TDEST_WIDTH-1:0]   d2_tdest;
wire [C_AXIS_TUSER_WIDTH-1:0]   d2_tuser;

////////////////////////////////////////////////////////////////////////////////
// Tie offs to reduce warnings
////////////////////////////////////////////////////////////////////////////////
localparam C_DIN_WIDTH           = 18;
localparam C_RD_PNTR_WIDTH       = 10;
localparam C_WR_PNTR_WIDTH       = 10;
localparam C_DOUT_WIDTH          = 18;
localparam C_DATA_COUNT_WIDTH    = 10;
localparam C_RD_DATA_COUNT_WIDTH = 10;
localparam C_WR_DATA_COUNT_WIDTH = 10;
localparam C_AXI_ID_WIDTH        = 4;
localparam C_AXI_ADDR_WIDTH      = 32;
localparam C_AXI_DATA_WIDTH      = 64;
localparam C_AXI_AWUSER_WIDTH    = 1;
localparam C_AXI_ARUSER_WIDTH    = 1;
localparam C_AXI_RUSER_WIDTH     = 1;
localparam C_AXI_BUSER_WIDTH     = 1;
localparam C_AXI_WUSER_WIDTH     = 1;
localparam C_WR_PNTR_WIDTH_RACH  = 4;
localparam C_WR_PNTR_WIDTH_RDCH  = 10;
localparam C_WR_PNTR_WIDTH_WACH  = 4;
localparam C_WR_PNTR_WIDTH_WDCH  = 10;
localparam C_WR_PNTR_WIDTH_WRCH  = 4;
localparam C_RD_PNTR_WIDTH_RACH  = 4;
localparam C_RD_PNTR_WIDTH_RDCH  = 10;
localparam C_RD_PNTR_WIDTH_WACH  = 4;
localparam C_RD_PNTR_WIDTH_WDCH  = 10;
localparam C_RD_PNTR_WIDTH_WRCH  = 4;
localparam C_WR_PNTR_WIDTH_AXIS  = P_WR_PNTR_WIDTH;

wire                               BACKUP;
wire                               BACKUP_MARKER;
wire                               CLK;
wire                               RST;
wire                               SRST;
wire                               WR_CLK;
wire                               WR_RST_BUSY;
wire                               WR_RST;
wire                               RD_CLK;
wire                               RD_RST_BUSY;
wire                               RD_RST;
wire [C_DIN_WIDTH-1:0]             DIN;
wire                               WR_EN;
wire                               RD_EN;
// Optional wires
wire [C_RD_PNTR_WIDTH-1:0]         PROG_EMPTY_THRESH;
wire [C_RD_PNTR_WIDTH-1:0]         PROG_EMPTY_THRESH_ASSERT;
wire [C_RD_PNTR_WIDTH-1:0]         PROG_EMPTY_THRESH_NEGATE;
wire [C_WR_PNTR_WIDTH-1:0]         PROG_FULL_THRESH;
wire [C_WR_PNTR_WIDTH-1:0]         PROG_FULL_THRESH_ASSERT;
wire [C_WR_PNTR_WIDTH-1:0]         PROG_FULL_THRESH_NEGATE;
wire                               INT_CLK;
wire                               INJECTDBITERR;
wire                               INJECTSBITERR;

wire [C_DOUT_WIDTH-1:0]           DOUT;
wire                              FULL;
wire                              ALMOST_FULL;
wire                              WR_ACK;
wire                              OVERFLOW;
wire                              EMPTY;
wire                              ALMOST_EMPTY;
wire                              VALID;
wire                              UNDERFLOW;
wire [C_DATA_COUNT_WIDTH-1:0]     DATA_COUNT;
wire [C_RD_DATA_COUNT_WIDTH-1:0]  RD_DATA_COUNT;
wire [C_WR_DATA_COUNT_WIDTH-1:0]  WR_DATA_COUNT;
wire                              PROG_FULL;
wire                              PROG_EMPTY;
wire                              SBITERR;
wire                              SLEEP;
wire                              DBITERR;


// AXI Global Signal
wire                               M_ACLK;
wire                               S_ACLK;
wire                               S_ARESETN;
wire                               S_ACLK_EN;
wire                               M_ACLK_EN;

// AXI Full/Lite Slave Write Channel (write side)
wire [C_AXI_ID_WIDTH-1:0]          S_AXI_AWID;
wire [C_AXI_ADDR_WIDTH-1:0]        S_AXI_AWADDR;
wire [8-1:0]                       S_AXI_AWLEN;
wire [3-1:0]                       S_AXI_AWSIZE;
wire [2-1:0]                       S_AXI_AWBURST;
wire [2-1:0]                       S_AXI_AWLOCK;
wire [4-1:0]                       S_AXI_AWCACHE;
wire [3-1:0]                       S_AXI_AWPROT;
wire [4-1:0]                       S_AXI_AWQOS;
wire [4-1:0]                       S_AXI_AWREGION;
wire [C_AXI_AWUSER_WIDTH-1:0]      S_AXI_AWUSER;
wire                               S_AXI_AWVALID;
wire                              S_AXI_AWREADY;
wire [C_AXI_ID_WIDTH-1:0]          S_AXI_WID;
wire [C_AXI_DATA_WIDTH-1:0]        S_AXI_WDATA;
wire [C_AXI_DATA_WIDTH/8-1:0]      S_AXI_WSTRB;
wire                               S_AXI_WLAST;
wire [C_AXI_WUSER_WIDTH-1:0]       S_AXI_WUSER;
wire                               S_AXI_WVALID;
wire                              S_AXI_WREADY;
wire [C_AXI_ID_WIDTH-1:0]         S_AXI_BID;
wire [2-1:0]                      S_AXI_BRESP;
wire [C_AXI_BUSER_WIDTH-1:0]      S_AXI_BUSER;
wire                              S_AXI_BVALID;
wire                               S_AXI_BREADY;

// AXI Full/Lite Master Write Channel (Read side)
wire [C_AXI_ID_WIDTH-1:0]         M_AXI_AWID;
wire [C_AXI_ADDR_WIDTH-1:0]       M_AXI_AWADDR;
wire [8-1:0]                      M_AXI_AWLEN;
wire [3-1:0]                      M_AXI_AWSIZE;
wire [2-1:0]                      M_AXI_AWBURST;
wire [2-1:0]                      M_AXI_AWLOCK;
wire [4-1:0]                      M_AXI_AWCACHE;
wire [3-1:0]                      M_AXI_AWPROT;
wire [4-1:0]                      M_AXI_AWQOS;
wire [4-1:0]                      M_AXI_AWREGION;
wire [C_AXI_AWUSER_WIDTH-1:0]     M_AXI_AWUSER;
wire                              M_AXI_AWVALID;
wire                               M_AXI_AWREADY;
wire [C_AXI_ID_WIDTH-1:0]         M_AXI_WID;
wire [C_AXI_DATA_WIDTH-1:0]       M_AXI_WDATA;
wire [C_AXI_DATA_WIDTH/8-1:0]     M_AXI_WSTRB;
wire                              M_AXI_WLAST;
wire [C_AXI_WUSER_WIDTH-1:0]      M_AXI_WUSER;
wire                              M_AXI_WVALID;
wire                               M_AXI_WREADY;
wire [C_AXI_ID_WIDTH-1:0]          M_AXI_BID;
wire [2-1:0]                       M_AXI_BRESP;
wire [C_AXI_BUSER_WIDTH-1:0]       M_AXI_BUSER;
wire                               M_AXI_BVALID;
wire                              M_AXI_BREADY;


// AXI Full/Lite Slave Read Channel (Write side)
wire [C_AXI_ID_WIDTH-1:0]          S_AXI_ARID;
wire [C_AXI_ADDR_WIDTH-1:0]        S_AXI_ARADDR; 
wire [8-1:0]                       S_AXI_ARLEN;
wire [3-1:0]                       S_AXI_ARSIZE;
wire [2-1:0]                       S_AXI_ARBURST;
wire [2-1:0]                       S_AXI_ARLOCK;
wire [4-1:0]                       S_AXI_ARCACHE;
wire [3-1:0]                       S_AXI_ARPROT;
wire [4-1:0]                       S_AXI_ARQOS;
wire [4-1:0]                       S_AXI_ARREGION;
wire [C_AXI_ARUSER_WIDTH-1:0]      S_AXI_ARUSER;
wire                               S_AXI_ARVALID;
wire                              S_AXI_ARREADY;
wire [C_AXI_ID_WIDTH-1:0]         S_AXI_RID;       
wire [C_AXI_DATA_WIDTH-1:0]       S_AXI_RDATA; 
wire [2-1:0]                      S_AXI_RRESP;
wire                              S_AXI_RLAST;
wire [C_AXI_RUSER_WIDTH-1:0]      S_AXI_RUSER;
wire                              S_AXI_RVALID;
wire                               S_AXI_RREADY;



// AXI Full/Lite Master Read Channel (Read side)
wire [C_AXI_ID_WIDTH-1:0]         M_AXI_ARID;        
wire [C_AXI_ADDR_WIDTH-1:0]       M_AXI_ARADDR;  
wire [8-1:0]                      M_AXI_ARLEN;
wire [3-1:0]                      M_AXI_ARSIZE;
wire [2-1:0]                      M_AXI_ARBURST;
wire [2-1:0]                      M_AXI_ARLOCK;
wire [4-1:0]                      M_AXI_ARCACHE;
wire [3-1:0]                      M_AXI_ARPROT;
wire [4-1:0]                      M_AXI_ARQOS;
wire [4-1:0]                      M_AXI_ARREGION;
wire [C_AXI_ARUSER_WIDTH-1:0]     M_AXI_ARUSER;
wire                              M_AXI_ARVALID;
wire                               M_AXI_ARREADY;
wire [C_AXI_ID_WIDTH-1:0]          M_AXI_RID;        
wire [C_AXI_DATA_WIDTH-1:0]        M_AXI_RDATA;  
wire [2-1:0]                       M_AXI_RRESP;
wire                               M_AXI_RLAST;
wire [C_AXI_RUSER_WIDTH-1:0]       M_AXI_RUSER;
wire                               M_AXI_RVALID;
wire                              M_AXI_RREADY;

// AXI Full/Lite Write Address Channel Signals
wire                               AXI_AW_INJECTSBITERR;
wire                               AXI_AW_INJECTDBITERR;
wire  [C_WR_PNTR_WIDTH_WACH-1:0]   AXI_AW_PROG_FULL_THRESH;
wire  [C_WR_PNTR_WIDTH_WACH-1:0]   AXI_AW_PROG_EMPTY_THRESH;
wire [C_WR_PNTR_WIDTH_WACH:0]     AXI_AW_DATA_COUNT;
wire [C_WR_PNTR_WIDTH_WACH:0]     AXI_AW_WR_DATA_COUNT;
wire [C_WR_PNTR_WIDTH_WACH:0]     AXI_AW_RD_DATA_COUNT;
wire                              AXI_AW_SBITERR;
wire                              AXI_AW_DBITERR;
wire                              AXI_AW_OVERFLOW;
wire                              AXI_AW_UNDERFLOW;
wire                              AXI_AW_PROG_FULL;
wire                              AXI_AW_PROG_EMPTY;


// AXI Full/Lite Write Data Channel Signals
wire                               AXI_W_INJECTSBITERR;
wire                               AXI_W_INJECTDBITERR;
wire  [C_WR_PNTR_WIDTH_WDCH-1:0]   AXI_W_PROG_FULL_THRESH;
wire  [C_WR_PNTR_WIDTH_WDCH-1:0]   AXI_W_PROG_EMPTY_THRESH;
wire [C_WR_PNTR_WIDTH_WDCH:0]     AXI_W_DATA_COUNT;
wire [C_WR_PNTR_WIDTH_WDCH:0]     AXI_W_WR_DATA_COUNT;
wire [C_WR_PNTR_WIDTH_WDCH:0]     AXI_W_RD_DATA_COUNT;
wire                              AXI_W_SBITERR;
wire                              AXI_W_DBITERR;
wire                              AXI_W_OVERFLOW;
wire                              AXI_W_UNDERFLOW;
wire                              AXI_W_PROG_FULL;
wire                              AXI_W_PROG_EMPTY;


// AXI Full/Lite Write Response Channel Signals
wire                               AXI_B_INJECTSBITERR;
wire                               AXI_B_INJECTDBITERR;
wire  [C_WR_PNTR_WIDTH_WRCH-1:0]   AXI_B_PROG_FULL_THRESH;
wire  [C_WR_PNTR_WIDTH_WRCH-1:0]   AXI_B_PROG_EMPTY_THRESH;
wire [C_WR_PNTR_WIDTH_WRCH:0]     AXI_B_DATA_COUNT;
wire [C_WR_PNTR_WIDTH_WRCH:0]     AXI_B_WR_DATA_COUNT;
wire [C_WR_PNTR_WIDTH_WRCH:0]     AXI_B_RD_DATA_COUNT;
wire                              AXI_B_SBITERR;
wire                              AXI_B_DBITERR;
wire                              AXI_B_OVERFLOW;
wire                              AXI_B_UNDERFLOW;
wire                              AXI_B_PROG_FULL;
wire                              AXI_B_PROG_EMPTY;



// AXI Full/Lite Read Address Channel Signals
wire                               AXI_AR_INJECTSBITERR;
wire                               AXI_AR_INJECTDBITERR;
wire  [C_WR_PNTR_WIDTH_RACH-1:0]   AXI_AR_PROG_FULL_THRESH;
wire  [C_WR_PNTR_WIDTH_RACH-1:0]   AXI_AR_PROG_EMPTY_THRESH;
wire [C_WR_PNTR_WIDTH_RACH:0]     AXI_AR_DATA_COUNT;
wire [C_WR_PNTR_WIDTH_RACH:0]     AXI_AR_WR_DATA_COUNT;
wire [C_WR_PNTR_WIDTH_RACH:0]     AXI_AR_RD_DATA_COUNT;
wire                              AXI_AR_SBITERR;
wire                              AXI_AR_DBITERR;
wire                              AXI_AR_OVERFLOW;
wire                              AXI_AR_UNDERFLOW;
wire                              AXI_AR_PROG_FULL;
wire                              AXI_AR_PROG_EMPTY;


// AXI Full/Lite Read Data Channel Signals
wire                               AXI_R_INJECTSBITERR;
wire                               AXI_R_INJECTDBITERR;
wire  [C_WR_PNTR_WIDTH_RDCH-1:0]   AXI_R_PROG_FULL_THRESH;
wire  [C_WR_PNTR_WIDTH_RDCH-1:0]   AXI_R_PROG_EMPTY_THRESH;
wire [C_WR_PNTR_WIDTH_RDCH:0]     AXI_R_DATA_COUNT;
wire [C_WR_PNTR_WIDTH_RDCH:0]     AXI_R_WR_DATA_COUNT;
wire [C_WR_PNTR_WIDTH_RDCH:0]     AXI_R_RD_DATA_COUNT;
wire                              AXI_R_SBITERR;
wire                              AXI_R_DBITERR;
wire                              AXI_R_OVERFLOW;
wire                              AXI_R_UNDERFLOW;
wire                              AXI_R_PROG_FULL;
wire                              AXI_R_PROG_EMPTY;


// AXI Streaming FIFO Related Signals
wire                               AXIS_INJECTSBITERR;
wire                               AXIS_INJECTDBITERR;
wire  [C_WR_PNTR_WIDTH_AXIS-1:0]   AXIS_PROG_FULL_THRESH;
wire  [C_WR_PNTR_WIDTH_AXIS-1:0]   AXIS_PROG_EMPTY_THRESH;
wire                              AXIS_SBITERR;
wire                              AXIS_DBITERR;
wire                              AXIS_OVERFLOW;
wire                              AXIS_UNDERFLOW;
wire                              AXIS_PROG_FULL;
wire                              AXIS_PROG_EMPTY;

assign S_ACLK_EN                = 1'b1;
assign M_ACLK_EN                = 1'b1;
assign BACKUP                   = 1'b0;
assign BACKUP_MARKER            = 1'b0;
assign CLK                      = 1'b0;
assign RST                      = 1'b0;
assign SRST                     = 1'b0;
assign WR_CLK                   = 1'b0;
assign WR_RST                   = 1'b0;
assign RD_CLK                   = 1'b0;
assign RD_RST                   = 1'b0;
assign DIN                      = {C_DIN_WIDTH{1'b0}};
assign WR_EN                    = 1'b0;
assign RD_EN                    = 1'b0;
assign PROG_EMPTY_THRESH        = {C_RD_PNTR_WIDTH{1'b0}};
assign PROG_EMPTY_THRESH_ASSERT = {C_RD_PNTR_WIDTH{1'b0}};
assign PROG_EMPTY_THRESH_NEGATE = {C_RD_PNTR_WIDTH{1'b0}};
assign PROG_FULL_THRESH         = {C_WR_PNTR_WIDTH{1'b0}};
assign PROG_FULL_THRESH_ASSERT  = {C_WR_PNTR_WIDTH{1'b0}};
assign PROG_FULL_THRESH_NEGATE  = {C_WR_PNTR_WIDTH{1'b0}};
assign INT_CLK                  = 1'b0;
assign INJECTDBITERR            = 1'b0;
assign INJECTSBITERR            = 1'b0;
assign S_AXI_AWID               = {C_AXI_ID_WIDTH{1'b0}};
assign S_AXI_AWADDR             = {C_AXI_ADDR_WIDTH{1'b0}};
assign S_AXI_AWLEN              = {8{1'b0}};
assign S_AXI_AWSIZE             = {3{1'b0}};
assign S_AXI_AWBURST            = {2{1'b0}};
assign S_AXI_AWLOCK             = {2{1'b0}};
assign S_AXI_AWCACHE            = {4{1'b0}};
assign S_AXI_AWPROT             = {3{1'b0}};
assign S_AXI_AWQOS              = {4{1'b0}};
assign S_AXI_AWREGION           = {4{1'b0}};
assign S_AXI_AWUSER             = {C_AXI_AWUSER_WIDTH{1'b0}};
assign S_AXI_AWVALID            = 1'b0;
assign S_AXI_WID                = {C_AXI_ID_WIDTH{1'b0}};
assign S_AXI_WDATA              = {C_AXI_DATA_WIDTH{1'b0}};
assign S_AXI_WSTRB              = {C_AXI_DATA_WIDTH/8{1'b0}};
assign S_AXI_WLAST              = 1'b0;
assign S_AXI_WUSER              = {C_AXI_WUSER_WIDTH{1'b0}};
assign S_AXI_WVALID             = 1'b0;
assign S_AXI_BREADY             = 1'b0;
assign M_AXI_AWREADY            = 1'b0;
assign M_AXI_WREADY             = 1'b0;
assign M_AXI_BID                = {C_AXI_ID_WIDTH{1'b0}};
assign M_AXI_BRESP              = {2{1'b0}};
assign M_AXI_BUSER              = {C_AXI_BUSER_WIDTH{1'b0}};
assign M_AXI_BVALID             = 1'b0;
assign S_AXI_ARID               = {C_AXI_ID_WIDTH{1'b0}};
assign S_AXI_ARADDR             = {C_AXI_ADDR_WIDTH{1'b0}};
assign S_AXI_ARLEN              = {8{1'b0}};
assign S_AXI_ARSIZE             = {3{1'b0}};
assign S_AXI_ARBURST            = {2{1'b0}};
assign S_AXI_ARLOCK             = {2{1'b0}};
assign S_AXI_ARCACHE            = {4{1'b0}};
assign S_AXI_ARPROT             = {3{1'b0}};
assign S_AXI_ARQOS              = {4{1'b0}};
assign S_AXI_ARREGION           = {4{1'b0}};
assign S_AXI_ARUSER             = {C_AXI_ARUSER_WIDTH{1'b0}};
assign S_AXI_ARVALID            = 1'b0;
assign S_AXI_RREADY             = 1'b0;
assign M_AXI_ARREADY            = 1'b0;
assign M_AXI_RID                = {C_AXI_ID_WIDTH{1'b0}};
assign M_AXI_RDATA              = {C_AXI_DATA_WIDTH{1'b0}};
assign M_AXI_RRESP              = {2{1'b0}};
assign M_AXI_RLAST              = 1'b0;
assign M_AXI_RUSER              = {C_AXI_RUSER_WIDTH{1'b0}};
assign M_AXI_RVALID             = 1'b0;
assign AXI_AW_INJECTSBITERR     = 1'b0;
assign AXI_AW_INJECTDBITERR     = 1'b0;
assign AXI_AW_PROG_FULL_THRESH  = {C_WR_PNTR_WIDTH_WACH{1'b0}};
assign AXI_AW_PROG_EMPTY_THRESH = {C_WR_PNTR_WIDTH_WACH{1'b0}};
assign AXI_W_INJECTSBITERR      = 1'b0;
assign AXI_W_INJECTDBITERR      = 1'b0;
assign AXI_W_PROG_FULL_THRESH   = {C_WR_PNTR_WIDTH_WDCH{1'b0}};
assign AXI_W_PROG_EMPTY_THRESH  = {C_WR_PNTR_WIDTH_WDCH{1'b0}};
assign AXI_B_INJECTSBITERR      = 1'b0;
assign AXI_B_INJECTDBITERR      = 1'b0;
assign AXI_B_PROG_FULL_THRESH   = {C_WR_PNTR_WIDTH_WRCH{1'b0}};
assign AXI_B_PROG_EMPTY_THRESH  = {C_WR_PNTR_WIDTH_WRCH{1'b0}};
assign AXI_AR_INJECTSBITERR     = 1'b0;
assign AXI_AR_INJECTDBITERR     = 1'b0;
assign AXI_AR_PROG_FULL_THRESH  = {C_WR_PNTR_WIDTH_RACH{1'b0}};
assign AXI_AR_PROG_EMPTY_THRESH = {C_WR_PNTR_WIDTH_RACH{1'b0}};
assign AXI_R_INJECTSBITERR      = 1'b0;
assign AXI_R_INJECTDBITERR      = 1'b0;
assign AXI_R_PROG_FULL_THRESH   = {C_WR_PNTR_WIDTH_RDCH{1'b0}};
assign AXI_R_PROG_EMPTY_THRESH  = {C_WR_PNTR_WIDTH_RDCH{1'b0}};
assign AXIS_INJECTSBITERR       = 1'b0;
assign AXIS_INJECTDBITERR       = 1'b0;
assign AXIS_PROG_FULL_THRESH    = {C_WR_PNTR_WIDTH_AXIS{1'b0}};
assign AXIS_PROG_EMPTY_THRESH   = {C_WR_PNTR_WIDTH_AXIS{1'b0}};
assign SLEEP                    = 1'b0;

////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////

// Both S and M have to be out of reset before fifo will be let out of reset.
assign s_and_m_aresetn_i = S_AXIS_ARESETN & M_AXIS_ARESETN;

generate 
  if (C_FIFO_MODE > 0) begin : gen_fifo_generator
    assign AXIS_DATA_COUNT    = (P_COMMON_CLOCK == 1) ? {{(32-P_FIFO_COUNT_WIDTH){1'b0}}, axis_data_count_i} : AXIS_WR_DATA_COUNT;
    assign AXIS_WR_DATA_COUNT = (P_COMMON_CLOCK == 0) ? {{(32-P_FIFO_COUNT_WIDTH){1'b0}}, axis_wr_data_count_i} : AXIS_DATA_COUNT;
    assign AXIS_RD_DATA_COUNT = (P_COMMON_CLOCK == 0) ? {{(32-P_FIFO_COUNT_WIDTH){1'b0}}, axis_rd_data_count_i} : AXIS_DATA_COUNT;

    axis_interconnect_v1_1_18_util_aclken_converter_wrapper #( 
      .C_TDATA_WIDTH         ( C_AXIS_TDATA_WIDTH     ) ,
      .C_TID_WIDTH           ( C_AXIS_TID_WIDTH       ) ,
      .C_TDEST_WIDTH         ( C_AXIS_TDEST_WIDTH     ) ,
      .C_TUSER_WIDTH         ( C_AXIS_TUSER_WIDTH     ) ,
      .C_S_ACLKEN_CAN_TOGGLE ( LP_S_ACLKEN_CAN_TOGGLE ) ,
      .C_M_ACLKEN_CAN_TOGGLE ( 0                      ) 
    )
    s_util_aclken_converter_wrapper_0 ( 
      .ACLK     ( S_AXIS_ACLK    ) ,
      .ARESETN  ( S_AXIS_ARESETN ) ,
      .S_ACLKEN ( S_AXIS_ACLKEN  ) ,
      .S_VALID  ( S_AXIS_TVALID  ) ,
      .S_READY  ( S_AXIS_TREADY  ) ,
      .S_TDATA  ( S_AXIS_TDATA   ) ,
      .S_TSTRB  ( S_AXIS_TSTRB   ) ,
      .S_TKEEP  ( S_AXIS_TKEEP   ) ,
      .S_TLAST  ( S_AXIS_TLAST   ) ,
      .S_TID    ( S_AXIS_TID     ) ,
      .S_TDEST  ( S_AXIS_TDEST   ) ,
      .S_TUSER  ( S_AXIS_TUSER   ) ,
      .M_ACLKEN ( M_AXIS_ACLKEN  ) ,
      .M_VALID  ( d1_tvalid      ) ,
      .M_READY  ( d1_tready      ) ,
      .M_TDATA  ( d1_tdata       ) ,
      .M_TSTRB  ( d1_tstrb       ) ,
      .M_TKEEP  ( d1_tkeep       ) ,
      .M_TLAST  ( d1_tlast       ) ,
      .M_TID    ( d1_tid         ) ,
      .M_TDEST  ( d1_tdest       ) ,
      .M_TUSER  ( d1_tuser       ) 
    );
    // synthesis xilinx_generatecore
    fifo_generator_v13_2_5 #(
      .C_ADD_NGC_CONSTRAINT                ( 0                          ) ,
      .C_APPLICATION_TYPE_AXIS             ( P_APPLICATION_TYPE_AXIS    ) ,
      .C_APPLICATION_TYPE_RACH             ( 0                          ) ,
      .C_APPLICATION_TYPE_RDCH             ( 0                          ) ,
      .C_APPLICATION_TYPE_WACH             ( 0                          ) ,
      .C_APPLICATION_TYPE_WDCH             ( 0                          ) ,
      .C_APPLICATION_TYPE_WRCH             ( 0                          ) ,
      .C_AXI_ADDR_WIDTH                    ( 32                         ) ,
      .C_AXI_ARUSER_WIDTH                  ( 1                          ) ,
      .C_AXI_AWUSER_WIDTH                  ( 1                          ) ,
      .C_AXI_BUSER_WIDTH                   ( 1                          ) ,
      .C_AXI_DATA_WIDTH                    ( 64                         ) ,
      .C_AXI_ID_WIDTH                      ( 4                          ) ,
      .C_AXI_LEN_WIDTH                     ( 8         ) ,
      .C_AXI_LOCK_WIDTH                    ( 2         ) ,
      .C_AXI_RUSER_WIDTH                   ( 1                          ) ,
      .C_AXIS_TDATA_WIDTH                  ( C_AXIS_TDATA_WIDTH         ) ,
      .C_AXIS_TDEST_WIDTH                  ( C_AXIS_TDEST_WIDTH         ) ,
      .C_AXIS_TID_WIDTH                    ( C_AXIS_TID_WIDTH           ) ,
      .C_AXIS_TKEEP_WIDTH                  ( C_AXIS_TDATA_WIDTH/8       ) ,
      .C_AXIS_TSTRB_WIDTH                  ( C_AXIS_TDATA_WIDTH/8       ) ,
      .C_AXIS_TUSER_WIDTH                  ( C_AXIS_TUSER_WIDTH         ) ,
      .C_AXIS_TYPE                         ( 0                          ) ,
      .C_AXI_TYPE                          ( 0                          ) ,
      .C_AXI_WUSER_WIDTH                   ( 1                          ) ,
      .C_COMMON_CLOCK                      ( P_COMMON_CLOCK             ) ,
      .C_COUNT_TYPE                        ( 0                          ) ,
      .C_DATA_COUNT_WIDTH                  ( 10                         ) ,
      .C_DEFAULT_VALUE                     ( "BlankString"              ) ,
      .C_DIN_WIDTH                         ( 18                         ) ,
      .C_DIN_WIDTH_AXIS                    ( P_AXIS_PAYLOAD_WIDTH       ) ,
      .C_DIN_WIDTH_RACH                    ( 32                         ) ,
      .C_DIN_WIDTH_RDCH                    ( 64                         ) ,
      .C_DIN_WIDTH_WACH                    ( 32                         ) ,
      .C_DIN_WIDTH_WDCH                    ( 64                         ) ,
      .C_DIN_WIDTH_WRCH                    ( 2                          ) ,
      .C_DOUT_RST_VAL                      ( "0"                        ) ,
      .C_DOUT_WIDTH                        ( 18                         ) ,
      .C_ENABLE_RLOCS                      ( 0                          ) ,
      .C_ENABLE_RST_SYNC                   ( 1                          ) ,
      .C_ERROR_INJECTION_TYPE              ( 0                          ) ,
      .C_ERROR_INJECTION_TYPE_AXIS         ( 0                          ) ,
      .C_ERROR_INJECTION_TYPE_RACH         ( 0                          ) ,
      .C_ERROR_INJECTION_TYPE_RDCH         ( 0                          ) ,
      .C_ERROR_INJECTION_TYPE_WACH         ( 0                          ) ,
      .C_ERROR_INJECTION_TYPE_WDCH         ( 0                          ) ,
      .C_ERROR_INJECTION_TYPE_WRCH         ( 0                          ) ,
      .C_FAMILY                            ( C_FAMILY                   ) ,
      .C_FULL_FLAGS_RST_VAL                ( 1                          ) ,
      .C_HAS_ALMOST_EMPTY                  ( 0                          ) ,
      .C_HAS_ALMOST_FULL                   ( 0                          ) ,
      .C_HAS_AXI_ARUSER                    ( 0                          ) ,
      .C_HAS_AXI_AWUSER                    ( 0                          ) ,
      .C_HAS_AXI_BUSER                     ( 0                          ) ,
      .C_HAS_AXI_ID                        ( 0         ) ,
      .C_HAS_AXI_RD_CHANNEL                ( 0                          ) ,
      .C_HAS_AXI_RUSER                     ( 0                          ) ,
      .C_HAS_AXIS_TDATA                    ( P_TDATA_EXISTS             ) ,
      .C_HAS_AXIS_TDEST                    ( P_TDEST_EXISTS             ) ,
      .C_HAS_AXIS_TID                      ( P_TID_EXISTS               ) ,
      .C_HAS_AXIS_TKEEP                    ( P_TKEEP_EXISTS             ) ,
      .C_HAS_AXIS_TLAST                    ( P_TLAST_EXISTS             ) ,
      .C_HAS_AXIS_TREADY                   ( P_TREADY_EXISTS            ) ,
      .C_HAS_AXIS_TSTRB                    ( P_TSTRB_EXISTS             ) ,
      .C_HAS_AXIS_TUSER                    ( P_TUSER_EXISTS             ) ,
      .C_HAS_AXI_WR_CHANNEL                ( 0                          ) ,
      .C_HAS_AXI_WUSER                     ( 0                          ) ,
      .C_HAS_BACKUP                        ( 0                          ) ,
      .C_HAS_DATA_COUNT                    ( 0                          ) ,
      .C_HAS_DATA_COUNTS_AXIS              ( 1                          ) ,
      .C_HAS_DATA_COUNTS_RACH              ( 0                          ) ,
      .C_HAS_DATA_COUNTS_RDCH              ( 0                          ) ,
      .C_HAS_DATA_COUNTS_WACH              ( 0                          ) ,
      .C_HAS_DATA_COUNTS_WDCH              ( 0                          ) ,
      .C_HAS_DATA_COUNTS_WRCH              ( 0                          ) ,
      .C_HAS_INT_CLK                       ( 0                          ) ,
      .C_HAS_MASTER_CE                     ( 0                          ) ,
      .C_HAS_MEMINIT_FILE                  ( 0                          ) ,
      .C_HAS_OVERFLOW                      ( 0                          ) ,
      .C_HAS_PROG_FLAGS_AXIS               ( 0                          ) ,
      .C_HAS_PROG_FLAGS_RACH               ( 0                          ) ,
      .C_HAS_PROG_FLAGS_RDCH               ( 0                          ) ,
      .C_HAS_PROG_FLAGS_WACH               ( 0                          ) ,
      .C_HAS_PROG_FLAGS_WDCH               ( 0                          ) ,
      .C_HAS_PROG_FLAGS_WRCH               ( 0                          ) ,
      .C_HAS_RD_DATA_COUNT                 ( 0                          ) ,
      .C_HAS_RD_RST                        ( 0                          ) ,
      .C_HAS_RST                           ( 1                          ) ,
      .C_HAS_SLAVE_CE                      ( 0                          ) ,
      .C_HAS_SRST                          ( 0                          ) ,
      .C_HAS_UNDERFLOW                     ( 0                          ) ,
      .C_HAS_VALID                         ( 0                          ) ,
      .C_HAS_WR_ACK                        ( 0                          ) ,
      .C_HAS_WR_DATA_COUNT                 ( 0                          ) ,
      .C_HAS_WR_RST                        ( 0                          ) ,
      .C_IMPLEMENTATION_TYPE               ( 0                          ) ,
      .C_IMPLEMENTATION_TYPE_AXIS          ( P_IMPLEMENTATION_TYPE_AXIS ) ,
      .C_IMPLEMENTATION_TYPE_RACH          ( 2                          ) ,
      .C_IMPLEMENTATION_TYPE_RDCH          ( 1                          ) ,
      .C_IMPLEMENTATION_TYPE_WACH          ( 2                          ) ,
      .C_IMPLEMENTATION_TYPE_WDCH          ( 1                          ) ,
      .C_IMPLEMENTATION_TYPE_WRCH          ( 2                          ) ,
      .C_INIT_WR_PNTR_VAL                  ( 0                          ) ,
      .C_INTERFACE_TYPE                    ( 1                          ) ,
      .C_MEMORY_TYPE                       ( 1                          ) ,
      .C_MIF_FILE_NAME                     ( "BlankString"              ) ,
      .C_MSGON_VAL                         ( P_MSGON_VAL                ) ,
      .C_OPTIMIZATION_MODE                 ( 0                          ) ,
      .C_OVERFLOW_LOW                      ( 0                          ) ,
      .C_POWER_SAVING_MODE                 ( 0         ) ,
      .C_PRELOAD_LATENCY                   ( 1                          ) ,
      .C_PRELOAD_REGS                      ( 0                          ) ,
      .C_PRIM_FIFO_TYPE                    ( "4kx4"                     ) ,
      .C_PRIM_FIFO_TYPE_AXIS               ( "512x36"  ) ,
      .C_PRIM_FIFO_TYPE_RACH               ( "512x36"  ) ,
      .C_PRIM_FIFO_TYPE_RDCH               ( "512x36"  ) ,
      .C_PRIM_FIFO_TYPE_WACH               ( "512x36"  ) ,
      .C_PRIM_FIFO_TYPE_WDCH               ( "512x36"  ) ,
      .C_PRIM_FIFO_TYPE_WRCH               ( "512x36"  ) ,
      .C_PROG_EMPTY_THRESH_ASSERT_VAL      ( 2                          ) ,
      .C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS ( C_FIFO_DEPTH - 2           ) ,
      .C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH ( 14                         ) ,
      .C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH ( 1022                       ) ,
      .C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH ( 14                         ) ,
      .C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH ( 1022                       ) ,
      .C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH ( 14                         ) ,
      .C_PROG_EMPTY_THRESH_NEGATE_VAL      ( 3                          ) ,
      .C_PROG_EMPTY_TYPE                   ( 0                          ) ,
      .C_PROG_EMPTY_TYPE_AXIS              ( 0                          ) ,
      .C_PROG_EMPTY_TYPE_RACH              ( 0                          ) ,
      .C_PROG_EMPTY_TYPE_RDCH              ( 0                          ) ,
      .C_PROG_EMPTY_TYPE_WACH              ( 0                          ) ,
      .C_PROG_EMPTY_TYPE_WDCH              ( 0                          ) ,
      .C_PROG_EMPTY_TYPE_WRCH              ( 0                          ) ,
      .C_PROG_FULL_THRESH_ASSERT_VAL       ( 1022                       ) ,
      .C_PROG_FULL_THRESH_ASSERT_VAL_AXIS  ( C_FIFO_DEPTH - 1           ) ,
      .C_PROG_FULL_THRESH_ASSERT_VAL_RACH  ( 15                         ) ,
      .C_PROG_FULL_THRESH_ASSERT_VAL_RDCH  ( 1023                       ) ,
      .C_PROG_FULL_THRESH_ASSERT_VAL_WACH  ( 15                         ) ,
      .C_PROG_FULL_THRESH_ASSERT_VAL_WDCH  ( 1023                       ) ,
      .C_PROG_FULL_THRESH_ASSERT_VAL_WRCH  ( 15                         ) ,
      .C_PROG_FULL_THRESH_NEGATE_VAL       ( 1021                       ) ,
      .C_PROG_FULL_TYPE                    ( 0                          ) ,
      .C_PROG_FULL_TYPE_AXIS               ( 0                          ) ,
      .C_PROG_FULL_TYPE_RACH               ( 0                          ) ,
      .C_PROG_FULL_TYPE_RDCH               ( 0                          ) ,
      .C_PROG_FULL_TYPE_WACH               ( 0                          ) ,
      .C_PROG_FULL_TYPE_WDCH               ( 0                          ) ,
      .C_PROG_FULL_TYPE_WRCH               ( 0                          ) ,
      .C_RACH_TYPE                         ( 0                          ) ,
      .C_RDCH_TYPE                         ( 0                          ) ,
      .C_RD_DATA_COUNT_WIDTH               ( 10                         ) ,
      .C_RD_DEPTH                          ( 1024                       ) ,
      .C_RD_FREQ                           ( 1                          ) ,
      .C_RD_PNTR_WIDTH                     ( 10                         ) ,
      .C_REG_SLICE_MODE_AXIS               ( 0                          ) ,
      .C_REG_SLICE_MODE_RACH               ( 0                          ) ,
      .C_REG_SLICE_MODE_RDCH               ( 0                          ) ,
      .C_REG_SLICE_MODE_WACH               ( 0                          ) ,
      .C_REG_SLICE_MODE_WDCH               ( 0                          ) ,
      .C_REG_SLICE_MODE_WRCH               ( 0                          ) ,
      .C_SYNCHRONIZER_STAGE                ( C_SYNCHRONIZER_STAGE       ) ,
      .C_UNDERFLOW_LOW                     ( 0                          ) ,
      .C_USE_COMMON_OVERFLOW               ( 0                          ) ,
      .C_USE_COMMON_UNDERFLOW              ( 0                          ) ,
      .C_USE_DEFAULT_SETTINGS              ( 0                          ) ,
      .C_USE_DOUT_RST                      ( 1                          ) ,
      .C_USE_ECC                           ( 0                          ) ,
      .C_USE_ECC_AXIS                      ( 0                          ) ,
      .C_USE_ECC_RACH                      ( 0                          ) ,
      .C_USE_ECC_RDCH                      ( 0                          ) ,
      .C_USE_ECC_WACH                      ( 0                          ) ,
      .C_USE_ECC_WDCH                      ( 0                          ) ,
      .C_USE_ECC_WRCH                      ( 0                          ) ,
      .C_USE_EMBEDDED_REG                  ( 0                          ) ,
      .C_USE_FIFO16_FLAGS                  ( 0                          ) ,
      .C_USE_FWFT_DATA_COUNT               ( 0                          ) ,
      .C_USE_PIPELINE_REG                  ( 0         ) ,
      .C_VALID_LOW                         ( 0                          ) ,
      .C_WACH_TYPE                         ( 0                          ) ,
      .C_WDCH_TYPE                         ( 0                          ) ,
      .C_WR_ACK_LOW                        ( 0                          ) ,
      .C_WRCH_TYPE                         ( 0                          ) ,
      .C_WR_DATA_COUNT_WIDTH               ( 10                         ) ,
      .C_WR_DEPTH                          ( 1024                       ) ,
      .C_WR_DEPTH_AXIS                     ( C_FIFO_DEPTH               ) ,
      .C_WR_DEPTH_RACH                     ( 16                         ) ,
      .C_WR_DEPTH_RDCH                     ( 1024                       ) ,
      .C_WR_DEPTH_WACH                     ( 16                         ) ,
      .C_WR_DEPTH_WDCH                     ( 1024                       ) ,
      .C_WR_DEPTH_WRCH                     ( 16                         ) ,
      .C_WR_FREQ                           ( 1                          ) ,
      .C_WR_PNTR_WIDTH                     ( 10                         ) ,
      .C_WR_PNTR_WIDTH_AXIS                ( P_WR_PNTR_WIDTH            ) ,
      .C_WR_PNTR_WIDTH_RACH                ( 4                          ) ,
      .C_WR_PNTR_WIDTH_RDCH                ( 10                         ) ,
      .C_WR_PNTR_WIDTH_WACH                ( 4                          ) ,
      .C_WR_PNTR_WIDTH_WDCH                ( 10                         ) ,
      .C_WR_PNTR_WIDTH_WRCH                ( 4                          ) ,
      .C_WR_RESPONSE_LATENCY               ( 1                          )
    )
    fifo_generator_inst (
      .almost_empty             ( ALMOST_EMPTY             ) ,
      .almost_full              ( ALMOST_FULL              ) ,
      .axi_ar_data_count        ( AXI_AR_DATA_COUNT        ) ,
      .axi_ar_dbiterr           ( AXI_AR_DBITERR           ) ,
      .axi_ar_injectdbiterr     ( AXI_AR_INJECTDBITERR     ) ,
      .axi_ar_injectsbiterr     ( AXI_AR_INJECTSBITERR     ) ,
      .axi_ar_overflow          ( AXI_AR_OVERFLOW          ) ,
      .axi_ar_prog_empty        ( AXI_AR_PROG_EMPTY        ) ,
      .axi_ar_prog_empty_thresh ( AXI_AR_PROG_EMPTY_THRESH ) ,
      .axi_ar_prog_full         ( AXI_AR_PROG_FULL         ) ,
      .axi_ar_prog_full_thresh  ( AXI_AR_PROG_FULL_THRESH  ) ,
      .axi_ar_rd_data_count     ( AXI_AR_RD_DATA_COUNT     ) ,
      .axi_ar_sbiterr           ( AXI_AR_SBITERR           ) ,
      .axi_ar_underflow         ( AXI_AR_UNDERFLOW         ) ,
      .axi_ar_wr_data_count     ( AXI_AR_WR_DATA_COUNT     ) ,
      .axi_aw_data_count        ( AXI_AW_DATA_COUNT        ) ,
      .axi_aw_dbiterr           ( AXI_AW_DBITERR           ) ,
      .axi_aw_injectdbiterr     ( AXI_AW_INJECTDBITERR     ) ,
      .axi_aw_injectsbiterr     ( AXI_AW_INJECTSBITERR     ) ,
      .axi_aw_overflow          ( AXI_AW_OVERFLOW          ) ,
      .axi_aw_prog_empty        ( AXI_AW_PROG_EMPTY        ) ,
      .axi_aw_prog_empty_thresh ( AXI_AW_PROG_EMPTY_THRESH ) ,
      .axi_aw_prog_full         ( AXI_AW_PROG_FULL         ) ,
      .axi_aw_prog_full_thresh  ( AXI_AW_PROG_FULL_THRESH  ) ,
      .axi_aw_rd_data_count     ( AXI_AW_RD_DATA_COUNT     ) ,
      .axi_aw_sbiterr           ( AXI_AW_SBITERR           ) ,
      .axi_aw_underflow         ( AXI_AW_UNDERFLOW         ) ,
      .axi_aw_wr_data_count     ( AXI_AW_WR_DATA_COUNT     ) ,
      .axi_b_data_count         ( AXI_B_DATA_COUNT         ) ,
      .axi_b_dbiterr            ( AXI_B_DBITERR            ) ,
      .axi_b_injectdbiterr      ( AXI_B_INJECTDBITERR      ) ,
      .axi_b_injectsbiterr      ( AXI_B_INJECTSBITERR      ) ,
      .axi_b_overflow           ( AXI_B_OVERFLOW           ) ,
      .axi_b_prog_empty         ( AXI_B_PROG_EMPTY         ) ,
      .axi_b_prog_empty_thresh  ( AXI_B_PROG_EMPTY_THRESH  ) ,
      .axi_b_prog_full          ( AXI_B_PROG_FULL          ) ,
      .axi_b_prog_full_thresh   ( AXI_B_PROG_FULL_THRESH   ) ,
      .axi_b_rd_data_count      ( AXI_B_RD_DATA_COUNT      ) ,
      .axi_b_sbiterr            ( AXI_B_SBITERR            ) ,
      .axi_b_underflow          ( AXI_B_UNDERFLOW          ) ,
      .axi_b_wr_data_count      ( AXI_B_WR_DATA_COUNT      ) ,
      .axi_r_data_count         ( AXI_R_DATA_COUNT         ) ,
      .axi_r_dbiterr            ( AXI_R_DBITERR            ) ,
      .axi_r_injectdbiterr      ( AXI_R_INJECTDBITERR      ) ,
      .axi_r_injectsbiterr      ( AXI_R_INJECTSBITERR      ) ,
      .axi_r_overflow           ( AXI_R_OVERFLOW           ) ,
      .axi_r_prog_empty         ( AXI_R_PROG_EMPTY         ) ,
      .axi_r_prog_empty_thresh  ( AXI_R_PROG_EMPTY_THRESH  ) ,
      .axi_r_prog_full          ( AXI_R_PROG_FULL          ) ,
      .axi_r_prog_full_thresh   ( AXI_R_PROG_FULL_THRESH   ) ,
      .axi_r_rd_data_count      ( AXI_R_RD_DATA_COUNT      ) ,
      .axi_r_sbiterr            ( AXI_R_SBITERR            ) ,
      .axi_r_underflow          ( AXI_R_UNDERFLOW          ) ,
      .axi_r_wr_data_count      ( AXI_R_WR_DATA_COUNT      ) ,
      .axis_data_count          ( axis_data_count_i        ) ,
      .axis_dbiterr             ( AXIS_DBITERR             ) ,
      .axis_injectdbiterr       ( AXIS_INJECTDBITERR       ) ,
      .axis_injectsbiterr       ( AXIS_INJECTSBITERR       ) ,
      .axis_overflow            ( AXIS_OVERFLOW            ) ,
      .axis_prog_empty          ( AXIS_PROG_EMPTY          ) ,
      .axis_prog_empty_thresh   ( AXIS_PROG_EMPTY_THRESH   ) ,
      .axis_prog_full           ( AXIS_PROG_FULL           ) ,
      .axis_prog_full_thresh    ( AXIS_PROG_FULL_THRESH    ) ,
      .axis_rd_data_count       ( axis_rd_data_count_i     ) ,
      .axis_sbiterr             ( AXIS_SBITERR             ) ,
      .axis_underflow           ( AXIS_UNDERFLOW           ) ,
      .axis_wr_data_count       ( axis_wr_data_count_i     ) ,
      .axi_w_data_count         ( AXI_W_DATA_COUNT         ) ,
      .axi_w_dbiterr            ( AXI_W_DBITERR            ) ,
      .axi_w_injectdbiterr      ( AXI_W_INJECTDBITERR      ) ,
      .axi_w_injectsbiterr      ( AXI_W_INJECTSBITERR      ) ,
      .axi_w_overflow           ( AXI_W_OVERFLOW           ) ,
      .axi_w_prog_empty         ( AXI_W_PROG_EMPTY         ) ,
      .axi_w_prog_empty_thresh  ( AXI_W_PROG_EMPTY_THRESH  ) ,
      .axi_w_prog_full          ( AXI_W_PROG_FULL          ) ,
      .axi_w_prog_full_thresh   ( AXI_W_PROG_FULL_THRESH   ) ,
      .axi_w_rd_data_count      ( AXI_W_RD_DATA_COUNT      ) ,
      .axi_w_sbiterr            ( AXI_W_SBITERR            ) ,
      .axi_w_underflow          ( AXI_W_UNDERFLOW          ) ,
      .axi_w_wr_data_count      ( AXI_W_WR_DATA_COUNT      ) ,
      .backup                   ( BACKUP                   ) ,
      .backup_marker            ( BACKUP_MARKER            ) ,
      .clk                      ( CLK                      ) ,
      .data_count               ( DATA_COUNT               ) ,
      .dbiterr                  ( DBITERR                  ) ,
      .din                      ( DIN                      ) ,
      .dout                     ( DOUT                     ) ,
      .empty                    ( EMPTY                    ) ,
      .full                     ( FULL                     ) ,
      .injectdbiterr            ( INJECTDBITERR            ) ,
      .injectsbiterr            ( INJECTSBITERR            ) ,
      .int_clk                  ( INT_CLK                  ) ,
      .m_aclk_en                ( M_ACLK_EN                ) ,
      .m_aclk                   ( M_AXIS_ACLK              ) ,
      .m_axi_araddr             ( M_AXI_ARADDR             ) ,
      .m_axi_arburst            ( M_AXI_ARBURST            ) ,
      .m_axi_arcache            ( M_AXI_ARCACHE            ) ,
      .m_axi_arid               ( M_AXI_ARID               ) ,
      .m_axi_arlen              ( M_AXI_ARLEN              ) ,
      .m_axi_arlock             ( M_AXI_ARLOCK             ) ,
      .m_axi_arprot             ( M_AXI_ARPROT             ) ,
      .m_axi_arqos              ( M_AXI_ARQOS              ) ,
      .m_axi_arready            ( M_AXI_ARREADY            ) ,
      .m_axi_arregion           ( M_AXI_ARREGION           ) ,
      .m_axi_arsize             ( M_AXI_ARSIZE             ) ,
      .m_axi_aruser             ( M_AXI_ARUSER             ) ,
      .m_axi_arvalid            ( M_AXI_ARVALID            ) ,
      .m_axi_awaddr             ( M_AXI_AWADDR             ) ,
      .m_axi_awburst            ( M_AXI_AWBURST            ) ,
      .m_axi_awcache            ( M_AXI_AWCACHE            ) ,
      .m_axi_awid               ( M_AXI_AWID               ) ,
      .m_axi_awlen              ( M_AXI_AWLEN              ) ,
      .m_axi_awlock             ( M_AXI_AWLOCK             ) ,
      .m_axi_awprot             ( M_AXI_AWPROT             ) ,
      .m_axi_awqos              ( M_AXI_AWQOS              ) ,
      .m_axi_awready            ( M_AXI_AWREADY            ) ,
      .m_axi_awregion           ( M_AXI_AWREGION           ) ,
      .m_axi_awsize             ( M_AXI_AWSIZE             ) ,
      .m_axi_awuser             ( M_AXI_AWUSER             ) ,
      .m_axi_awvalid            ( M_AXI_AWVALID            ) ,
      .m_axi_bid                ( M_AXI_BID                ) ,
      .m_axi_bready             ( M_AXI_BREADY             ) ,
      .m_axi_bresp              ( M_AXI_BRESP              ) ,
      .m_axi_buser              ( M_AXI_BUSER              ) ,
      .m_axi_bvalid             ( M_AXI_BVALID             ) ,
      .m_axi_rdata              ( M_AXI_RDATA              ) ,
      .m_axi_rid                ( M_AXI_RID                ) ,
      .m_axi_rlast              ( M_AXI_RLAST              ) ,
      .m_axi_rready             ( M_AXI_RREADY             ) ,
      .m_axi_rresp              ( M_AXI_RRESP              ) ,
      .m_axi_ruser              ( M_AXI_RUSER              ) ,
      .m_axi_rvalid             ( M_AXI_RVALID             ) ,
      .m_axis_tdata             ( d2_tdata                 ) ,
      .m_axis_tdest             ( d2_tdest                 ) ,
      .m_axis_tid               ( d2_tid                   ) ,
      .m_axis_tkeep             ( d2_tkeep                 ) ,
      .m_axis_tlast             ( d2_tlast                 ) ,
      .m_axis_tready            ( d2_tready                ) ,
      .m_axis_tstrb             ( d2_tstrb                 ) ,
      .m_axis_tuser             ( d2_tuser                 ) ,
      .m_axis_tvalid            ( d2_tvalid                ) ,
      .m_axi_wdata              ( M_AXI_WDATA              ) ,
      .m_axi_wid                ( M_AXI_WID                ) ,
      .m_axi_wlast              ( M_AXI_WLAST              ) ,
      .m_axi_wready             ( M_AXI_WREADY             ) ,
      .m_axi_wstrb              ( M_AXI_WSTRB              ) ,
      .m_axi_wuser              ( M_AXI_WUSER              ) ,
      .m_axi_wvalid             ( M_AXI_WVALID             ) ,
      .overflow                 ( OVERFLOW                 ) ,
      .prog_empty               ( PROG_EMPTY               ) ,
      .prog_empty_thresh_assert ( PROG_EMPTY_THRESH_ASSERT ) ,
      .prog_empty_thresh_negate ( PROG_EMPTY_THRESH_NEGATE ) ,
      .prog_empty_thresh        ( PROG_EMPTY_THRESH        ) ,
      .prog_full                ( PROG_FULL                ) ,
      .prog_full_thresh_assert  ( PROG_FULL_THRESH_ASSERT  ) ,
      .prog_full_thresh_negate  ( PROG_FULL_THRESH_NEGATE  ) ,
      .prog_full_thresh         ( PROG_FULL_THRESH         ) ,
      .rd_clk                   ( RD_CLK                   ) ,
      .rd_data_count            ( RD_DATA_COUNT            ) ,
      .rd_en                    ( RD_EN                    ) ,
      .rd_rst_busy              ( RD_RST_BUSY              ) ,
      .rd_rst                   ( RD_RST                   ) ,
      .rst                      ( RST                      ) ,
      .s_aclk_en                ( S_ACLK_EN                ) ,
      .s_aclk                   ( S_AXIS_ACLK              ) ,
      .s_aresetn                ( s_and_m_aresetn_i        ) ,
      .s_axi_araddr             ( S_AXI_ARADDR             ) ,
      .s_axi_arburst            ( S_AXI_ARBURST            ) ,
      .s_axi_arcache            ( S_AXI_ARCACHE            ) ,
      .s_axi_arid               ( S_AXI_ARID               ) ,
      .s_axi_arlen              ( S_AXI_ARLEN              ) ,
      .s_axi_arlock             ( S_AXI_ARLOCK             ) ,
      .s_axi_arprot             ( S_AXI_ARPROT             ) ,
      .s_axi_arqos              ( S_AXI_ARQOS              ) ,
      .s_axi_arready            ( S_AXI_ARREADY            ) ,
      .s_axi_arregion           ( S_AXI_ARREGION           ) ,
      .s_axi_arsize             ( S_AXI_ARSIZE             ) ,
      .s_axi_aruser             ( S_AXI_ARUSER             ) ,
      .s_axi_arvalid            ( S_AXI_ARVALID            ) ,
      .s_axi_awaddr             ( S_AXI_AWADDR             ) ,
      .s_axi_awburst            ( S_AXI_AWBURST            ) ,
      .s_axi_awcache            ( S_AXI_AWCACHE            ) ,
      .s_axi_awid               ( S_AXI_AWID               ) ,
      .s_axi_awlen              ( S_AXI_AWLEN              ) ,
      .s_axi_awlock             ( S_AXI_AWLOCK             ) ,
      .s_axi_awprot             ( S_AXI_AWPROT             ) ,
      .s_axi_awqos              ( S_AXI_AWQOS              ) ,
      .s_axi_awready            ( S_AXI_AWREADY            ) ,
      .s_axi_awregion           ( S_AXI_AWREGION           ) ,
      .s_axi_awsize             ( S_AXI_AWSIZE             ) ,
      .s_axi_awuser             ( S_AXI_AWUSER             ) ,
      .s_axi_awvalid            ( S_AXI_AWVALID            ) ,
      .s_axi_bid                ( S_AXI_BID                ) ,
      .s_axi_bready             ( S_AXI_BREADY             ) ,
      .s_axi_bresp              ( S_AXI_BRESP              ) ,
      .s_axi_buser              ( S_AXI_BUSER              ) ,
      .s_axi_bvalid             ( S_AXI_BVALID             ) ,
      .s_axi_rdata              ( S_AXI_RDATA              ) ,
      .s_axi_rid                ( S_AXI_RID                ) ,
      .s_axi_rlast              ( S_AXI_RLAST              ) ,
      .s_axi_rready             ( S_AXI_RREADY             ) ,
      .s_axi_rresp              ( S_AXI_RRESP              ) ,
      .s_axi_ruser              ( S_AXI_RUSER              ) ,
      .s_axi_rvalid             ( S_AXI_RVALID             ) ,
      .s_axis_tdata             ( d1_tdata                 ) ,
      .s_axis_tdest             ( d1_tdest                 ) ,
      .s_axis_tid               ( d1_tid                   ) ,
      .s_axis_tkeep             ( d1_tkeep                 ) ,
      .s_axis_tlast             ( d1_tlast                 ) ,
      .s_axis_tready            ( d1_tready                ) ,
      .s_axis_tstrb             ( d1_tstrb                 ) ,
      .s_axis_tuser             ( d1_tuser                 ) ,
      .s_axis_tvalid            ( d1_tvalid                ) ,
      .s_axi_wdata              ( S_AXI_WDATA              ) ,
      .s_axi_wid                ( S_AXI_WID                ) ,
      .s_axi_wlast              ( S_AXI_WLAST              ) ,
      .s_axi_wready             ( S_AXI_WREADY             ) ,
      .s_axi_wstrb              ( S_AXI_WSTRB              ) ,
      .s_axi_wuser              ( S_AXI_WUSER              ) ,
      .s_axi_wvalid             ( S_AXI_WVALID             ) ,
      .sbiterr                  ( SBITERR                  ) ,
      .sleep                    ( SLEEP                    ) ,
      .srst                     ( SRST                     ) ,
      .underflow                ( UNDERFLOW                ) ,
      .valid                    ( VALID                    ) ,
      .wr_ack                   ( WR_ACK                   ) ,
      .wr_clk                   ( WR_CLK                   ) ,
      .wr_data_count            ( WR_DATA_COUNT            ) ,
      .wr_en                    ( WR_EN                    ) ,
      .wr_rst_busy              ( WR_RST_BUSY              ) ,
      .wr_rst                   ( WR_RST                   ) 
    );

    axis_interconnect_v1_1_18_util_aclken_converter_wrapper #( 
      .C_TDATA_WIDTH         ( C_AXIS_TDATA_WIDTH     ) ,
      .C_TID_WIDTH           ( C_AXIS_TID_WIDTH       ) ,
      .C_TDEST_WIDTH         ( C_AXIS_TDEST_WIDTH     ) ,
      .C_TUSER_WIDTH         ( C_AXIS_TUSER_WIDTH     ) ,
      .C_S_ACLKEN_CAN_TOGGLE (                      0 ) ,
      .C_M_ACLKEN_CAN_TOGGLE ( LP_M_ACLKEN_CAN_TOGGLE )
    )
    m_util_aclken_converter_wrapper_0 ( 
      .ACLK     ( M_AXIS_ACLK    ) ,
      .ARESETN  ( M_AXIS_ARESETN ) ,
      .S_ACLKEN ( S_AXIS_ACLKEN  ) ,
      .S_VALID  ( d2_tvalid      ) ,
      .S_READY  ( d2_tready      ) ,
      .S_TDATA  ( d2_tdata       ) ,
      .S_TSTRB  ( d2_tstrb       ) ,
      .S_TKEEP  ( d2_tkeep       ) ,
      .S_TLAST  ( d2_tlast       ) ,
      .S_TID    ( d2_tid         ) ,
      .S_TDEST  ( d2_tdest       ) ,
      .S_TUSER  ( d2_tuser       ) ,
      .M_ACLKEN ( M_AXIS_ACLKEN  ) ,
      .M_VALID  ( M_AXIS_TVALID  ) ,
      .M_READY  ( (C_AXIS_SIGNAL_SET[0] == 0) ? 1'b1 : M_AXIS_TREADY  ) ,
      .M_TDATA  ( M_AXIS_TDATA   ) ,
      .M_TSTRB  ( M_AXIS_TSTRB   ) ,
      .M_TKEEP  ( M_AXIS_TKEEP   ) ,
      .M_TLAST  ( M_AXIS_TLAST   ) ,
      .M_TID    ( M_AXIS_TID     ) ,
      .M_TDEST  ( M_AXIS_TDEST   ) ,
      .M_TUSER  ( M_AXIS_TUSER   )  
    );
  end
  else begin : gen_fifo_passthru
    assign S_AXIS_TREADY   = (C_AXIS_SIGNAL_SET[0] == 0) ? 1'b1 : M_AXIS_TREADY ;
    assign M_AXIS_TVALID   = S_AXIS_TVALID ;
    assign M_AXIS_TDATA    = S_AXIS_TDATA  ;
    assign M_AXIS_TSTRB    = S_AXIS_TSTRB  ;
    assign M_AXIS_TKEEP    = S_AXIS_TKEEP  ;
    assign M_AXIS_TLAST    = S_AXIS_TLAST  ;
    assign M_AXIS_TID      = S_AXIS_TID    ;
    assign M_AXIS_TDEST    = S_AXIS_TDEST  ;
    assign M_AXIS_TUSER    = S_AXIS_TUSER  ;
    assign AXIS_DATA_COUNT = 32'b0;
    assign AXIS_WR_DATA_COUNT = 32'b0;
    assign AXIS_RD_DATA_COUNT = 32'b0;
  end
endgenerate

endmodule // axis_data_fifo



// (c) Copyright 2011-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   arb_rr
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_arb_rr #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter         C_FAMILY        = "virtex7",
   parameter integer C_NUM_SI_SLOTS  = 8,
   parameter integer C_LOG_SI_SLOTS  = 3,
   parameter         C_ARB_ALGORITHM = "ROUND_ROBIN"
)
(
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
   // System Signals
   input wire ACLK,
   input wire ARESET,
   input wire ACLKEN,

   input  wire [C_NUM_SI_SLOTS-1:0] ARB_REQ,
   input  wire                      ARB_DONE, 
   output wire [C_NUM_SI_SLOTS-1:0] ARB_GNT,
   output wire [C_LOG_SI_SLOTS-1:0] ARB_SEL
);

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
function [C_NUM_SI_SLOTS*C_LOG_SI_SLOTS-1:0] f_port_priority_init (
  input integer num_slaves
);
  begin : main
    integer i;
    for (i = 0; i < num_slaves; i = i + 1) begin
      f_port_priority_init[i*C_LOG_SI_SLOTS+:C_LOG_SI_SLOTS] = i[C_LOG_SI_SLOTS-1:0];
    end
  end
endfunction

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
wire                                     arb_busy_ns;
reg                                      arb_busy_r;

wire                                     advance;
wire [C_LOG_SI_SLOTS-1:0]                barrel_cntr_ns;
reg  [C_LOG_SI_SLOTS-1:0]                barrel_cntr;
wire [C_NUM_SI_SLOTS-1:0]                arb_req_rot;
wire [C_NUM_SI_SLOTS-1:0]                arb_req_i;
reg  [C_NUM_SI_SLOTS*C_LOG_SI_SLOTS-1:0] port_priority_r;
wire [C_NUM_SI_SLOTS*C_LOG_SI_SLOTS-1:0] port_priority_ns;
wire [C_LOG_SI_SLOTS-1:0]                sel_i;
wire                                     valid_i; 

wire [C_LOG_SI_SLOTS-1:0]                arb_sel_ns;
reg  [C_LOG_SI_SLOTS-1:0]                arb_sel_r;

wire [C_NUM_SI_SLOTS-1:0]                sel_decode_i;
wire [C_NUM_SI_SLOTS-1:0]                arb_gnt_ns;
reg  [C_NUM_SI_SLOTS-1:0]                arb_gnt_r;
////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////

// Generate busy logic.  When arbiter is busy a new REQ can't be granted and
// priority will not advance.
assign arb_busy_ns = (valid_i) | (arb_busy_r & ~ARB_DONE);

always @(posedge ACLK) begin 
  if (ARESET) begin
    arb_busy_r <= 1'b0;
  end
  else if (ACLKEN) begin
    arb_busy_r <= arb_busy_ns;
  end
end

assign advance = ~arb_busy_r | (|arb_gnt_r);

assign barrel_cntr_ns = (barrel_cntr == C_NUM_SI_SLOTS-1) ? {C_LOG_SI_SLOTS{1'b0}} : barrel_cntr + 1'b1 ; 

always @(posedge ACLK) begin
  if (ARESET) begin
    barrel_cntr <= {C_LOG_SI_SLOTS{1'b0}};
  end
  else if (ACLKEN && C_ARB_ALGORITHM == "ROUND_ROBIN") begin
    barrel_cntr <= advance ? barrel_cntr_ns : barrel_cntr;
  end
end

assign arb_req_i = ARB_REQ & ~arb_gnt_r;
assign arb_req_rot[C_NUM_SI_SLOTS-1:0] = {arb_req_i, arb_req_i} >> barrel_cntr;

// Port Priority implements round robin arbitration
always @(posedge ACLK) begin
  if (ARESET) begin
    port_priority_r <= f_port_priority_init(C_NUM_SI_SLOTS);
  end
  else if (ACLKEN && (C_ARB_ALGORITHM == "ROUND_ROBIN")) begin
    port_priority_r <= advance ? port_priority_ns : port_priority_r;
  end
end

assign port_priority_ns[0+:(C_NUM_SI_SLOTS-1)*C_LOG_SI_SLOTS] = 
         port_priority_r[1*C_LOG_SI_SLOTS+:(C_NUM_SI_SLOTS-1)*C_LOG_SI_SLOTS];
assign port_priority_ns[(C_NUM_SI_SLOTS-1)*C_LOG_SI_SLOTS+:C_LOG_SI_SLOTS] = port_priority_r[0+:C_LOG_SI_SLOTS];

axis_interconnect_v1_1_18_dynamic_priority_encoder #(
  .C_FAMILY    ( C_FAMILY       ) ,
  .C_REQ_WIDTH ( C_NUM_SI_SLOTS ) ,
  .C_ENC_WIDTH ( C_LOG_SI_SLOTS ) 
)
dynamic_priority_encoder_0
(
  .REQ           ( arb_req_rot     ) ,
  .PORT_PRIORITY ( port_priority_r ) ,
  .SEL           ( sel_i           ) ,
  .VALID         ( valid_i         ) 
);

assign arb_sel_ns = valid_i & (~arb_busy_r | ARB_DONE) ? sel_i : arb_sel_r;

always @(posedge ACLK) begin 
  if (ARESET) begin
    arb_sel_r <= {C_LOG_SI_SLOTS{1'b0}};
  end
  else if (ACLKEN) begin
    arb_sel_r <= arb_sel_ns;
  end
end

assign ARB_SEL = arb_sel_r;

// Decode sel from integer to one-hot
generate
  genvar i;
  for (i = 0; i < C_NUM_SI_SLOTS; i = i + 1) begin : gen_sel_decode_one_hot
    assign sel_decode_i[i] = (i == sel_i); 
  end
endgenerate

assign arb_gnt_ns = valid_i & (~arb_busy_r | ARB_DONE) ? sel_decode_i : {C_LOG_SI_SLOTS{1'b0}};

always @(posedge ACLK) begin 
  if (ARESET) begin
    arb_gnt_r <= {C_LOG_SI_SLOTS{1'b0}};
  end
  else if (ACLKEN) begin
    arb_gnt_r <= arb_gnt_ns;
  end
end

assign ARB_GNT = arb_gnt_r;

endmodule // arb_rr

`default_nettype wire


// (c) Copyright 2011-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axisc_decoder
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_axisc_decoder #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter         C_FAMILY           = "virtex7",
   parameter integer C_AXIS_TDATA_WIDTH = 32,
   parameter integer C_AXIS_TID_WIDTH   = 1,
   parameter integer C_AXIS_TDEST_WIDTH = 1,
   parameter integer C_AXIS_TUSER_WIDTH = 1,
   parameter [31:0]  C_AXIS_SIGNAL_SET  = 32'hFF,
   // C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional signals are present
   //   [0] => TREADY present
   //   [1] => TDATA present
   //   [2] => TSTRB present, TDATA must be present
   //   [3] => TKEEP present, TDATA must be present
   //   [4] => TLAST present
   //   [5] => TID present
   //   [6] => TDEST present
   //   [7] => TUSER present
   parameter integer C_TPAYLOAD_WIDTH  = 44,
   parameter integer C_NUM_MI_SLOTS    = 1,
   parameter integer C_USE_PACKET_MODE = 1,
   // C_USE_PACKET_MODE: Indicates to monitor TLAST to signal ARB_DONE
   parameter integer C_REG_CONFIG      = 1, 
   // C_REG_CONFIG: Registers payload and ARB_REQ signal
   //   0 => BYPASS    = The channel is just wired through the module.
   //   1 => FWD_REV   = Both FWD and REV (fully-registered)
   //   2 => FWD       = The master VALID and payload signals are registrated. 
   //   3 => REV       = The slave ready signal is registrated
   //   4 => RESERVED (all outputs driven to 0).
   //   5 => RESERVED (all outputs driven to 0).
   //   6 => INPUTS    = Slave and Master side inputs are registrated.
   //   7 => LIGHT_WT  = 1-stage pipeline register with bubble cycle, both FWD and REV pipelining
   //   8 => ARB_REQ only = No register on incoming signals.  Only a register
   //   on ARB_REQ output. (Causes bubble cycles) Throughput is halved.
   parameter [C_NUM_MI_SLOTS-1:0] C_CONNECTIVITY = {C_NUM_MI_SLOTS{1'b1}},
   // Specifies connectivity matrix for sparse crossbar configurations
   parameter [C_NUM_MI_SLOTS*C_AXIS_TDEST_WIDTH-1:0] C_BASETDEST = {C_NUM_MI_SLOTS*C_AXIS_TDEST_WIDTH{1'b1}},
   // Array of TDEST base/high pairs for each master interface
   parameter [C_NUM_MI_SLOTS*C_AXIS_TDEST_WIDTH-1:0] C_HIGHTDEST = {C_NUM_MI_SLOTS*C_AXIS_TDEST_WIDTH{1'b0}}
)
(
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
   // System Signals
   input wire ACLK,
   input wire ARESET,
   input wire ACLKEN,

   // Slave side
   input  wire                          S_AXIS_TVALID,
   output wire                          S_AXIS_TREADY,
   input  wire [C_TPAYLOAD_WIDTH-1:0]   S_AXIS_TPAYLOAD,
   input  wire [C_AXIS_TDEST_WIDTH-1:0] S_AXIS_TDEST,

   // Master side
   output wire [C_NUM_MI_SLOTS-1:0]     M_AXIS_TVALID,
   input  wire [C_NUM_MI_SLOTS-1:0]     M_AXIS_TREADY,
   output wire [C_TPAYLOAD_WIDTH-1:0]   M_AXIS_TPAYLOAD,

   // ARBITER Side
   output wire                          ARB_LAST,
   output wire [C_AXIS_TID_WIDTH-1:0]   ARB_ID,
   output wire [C_AXIS_TDEST_WIDTH-1:0] ARB_DEST,
   output wire [C_AXIS_TUSER_WIDTH-1:0] ARB_USER,
   output wire [C_NUM_MI_SLOTS-1:0]     ARB_REQ,
   input  wire [C_NUM_MI_SLOTS-1:0]     ARB_DONE,
   input  wire [C_NUM_MI_SLOTS-1:0]     ARB_GNT,
   output wire [C_NUM_MI_SLOTS-1:0]     ARB_ACTIVE, // Status

   // err signals
   output wire                          DECODE_ERR
);

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
`include "axis_interconnect_v1_1_18.vh"

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
localparam TDW = C_AXIS_TDEST_WIDTH;
localparam P_TDEST_PRESENT = C_AXIS_SIGNAL_SET[G_INDX_SS_TDEST];

////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
wire [C_NUM_MI_SLOTS-1:0]  busy_ns;
reg  [C_NUM_MI_SLOTS-1:0]  busy_r;
wire [C_NUM_MI_SLOTS-1:0]  dest_compare_match;
wire [C_NUM_MI_SLOTS-1:0]  arb_req_ns;
wire [C_NUM_MI_SLOTS-1:0]  arb_req_i;
wire                       decode_err_ns;
reg                        decode_err_r;
wire                       tready_or_decode_err;
wire                       m_axis_tvalid_payload;
wire                       m_axis_tvalid_req;
wire                       m_tready_from_decoded_slave;
////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////

// This selects only the TREADY of the MI slot we are requesting.
assign m_tready_from_decoded_slave = |(arb_req_i & M_AXIS_TREADY);

/* assign ARB_DONE = (C_USE_PACKET_MODE) ? ARB_LAST & m_tready_from_decoded_slave : m_tready_from_decoded_slave;*/

assign busy_ns =  (ARB_GNT | busy_r) & ~ARB_DONE;

always @(posedge ACLK) begin 
  if (ARESET) begin
    busy_r <= {C_NUM_MI_SLOTS{1'b0}};
  end else if (ACLKEN) begin
    busy_r <= busy_ns;
  end
end

assign ARB_ACTIVE = busy_r;

generate
genvar mi;

  if (P_TDEST_PRESENT) begin : gen_tdest_decoder
    for (mi = 0; mi < C_NUM_MI_SLOTS; mi = mi + 1) begin : gen_decode_loop
      if (C_CONNECTIVITY[mi] && (C_BASETDEST[mi*TDW+:TDW] <= C_HIGHTDEST[mi*TDW+:TDW])) begin : gen_master_connectivity
        assign dest_compare_match[mi] = ((S_AXIS_TDEST >= C_BASETDEST[mi*TDW+:TDW]) && (S_AXIS_TDEST <= C_HIGHTDEST[mi*TDW+:TDW])) 
                            ? 1'b1 : 1'b0;
       
        // Mux in the comparison only when S_AXIS_TVALID to avoid x propogation.
        assign arb_req_ns[mi] = S_AXIS_TVALID ? dest_compare_match[mi] : 1'b0; 
      end
      else begin : no_master_connectivity
        assign arb_req_ns[mi] = 1'b0;
      end
    end

    wire [C_NUM_MI_SLOTS-1:0] arb_req_out;

    axis_interconnect_v1_1_18_axisc_register_slice #(
      .C_FAMILY     ( C_FAMILY         ) ,
      .C_DATA_WIDTH ( C_TPAYLOAD_WIDTH ) ,
      .C_REG_CONFIG ( C_REG_CONFIG     ) 
    )
    axisc_register_slice_0 (
      .ACLK           ( ACLK                  ) ,
      .ARESET         ( ARESET                ) ,
      .ACLKEN         ( ACLKEN                ) ,
      .S_VALID        ( S_AXIS_TVALID         ) ,
      .S_READY        ( S_AXIS_TREADY         ) ,
      .S_PAYLOAD_DATA ( S_AXIS_TPAYLOAD       ) ,

      .M_VALID        ( m_axis_tvalid_payload ) , // Tvalid ignored, and the tvalid from the reg slice below is used.
      .M_READY        ( tready_or_decode_err  ) ,
      .M_PAYLOAD_DATA ( M_AXIS_TPAYLOAD       ) 
    );

    axis_interconnect_v1_1_18_axisc_register_slice #(
      .C_FAMILY     ( C_FAMILY       ) ,
      .C_DATA_WIDTH ( C_NUM_MI_SLOTS ) ,
      .C_REG_CONFIG ( C_REG_CONFIG   ) 
    )
    axisc_register_slice_1 (
      .ACLK           ( ACLK                 ) ,
      .ARESET         ( ARESET               ) ,
      .ACLKEN         ( ACLKEN               ) ,
      .S_VALID        ( S_AXIS_TVALID        ) ,
      .S_READY        (                      ) , // Ready output ignored since the Ready from reg_slice_0 is identical.
      .S_PAYLOAD_DATA ( arb_req_ns           ) ,

      .M_VALID        ( m_axis_tvalid_req    ) ,
      .M_READY        ( tready_or_decode_err ) ,
      .M_PAYLOAD_DATA ( arb_req_out          ) 
    );
    
    assign arb_req_i = m_axis_tvalid_req ? arb_req_out : {C_NUM_MI_SLOTS{1'b0}};

  end
  // If no tdest, then no tdest decoding can be performed. If single mi
  // system always decode to mi[0].
  else if (P_TDEST_PRESENT == 0 && C_NUM_MI_SLOTS == 1 && C_CONNECTIVITY[0] == 1'b1) begin : gen_no_tdest_decoder
    assign S_AXIS_TREADY = tready_or_decode_err;

    assign m_axis_tvalid_payload = S_AXIS_TVALID;
    assign M_AXIS_TPAYLOAD = S_AXIS_TPAYLOAD;
    assign m_axis_tvalid_req = S_AXIS_TVALID;
    assign arb_req_i = S_AXIS_TVALID;
  end
  // This case represents P_TDEST_PRESNT == 0 and C_NUM_MI_SLOTS > 1).  Need
  // tdets pins to route to multiple MI slots.
  else begin : gen_invalid_configuration 
    assign arb_req_i = {C_NUM_MI_SLOTS{1'b0}};
    assign S_AXIS_TREADY = 1'b0;
    assign m_axis_tvalid_payload = 1'b0;
    assign m_axis_tvalid_req = 1'b0;
    assign M_AXIS_TPAYLOAD = S_AXIS_TPAYLOAD;
  end
endgenerate

assign M_AXIS_TVALID = arb_req_i;

assign ARB_REQ = ~busy_r & arb_req_i;
// Decode Err: Decode err occurs when M_AXIS_TVALID = 1'b1 but none of the ARB_REQ
// have been asserted
assign decode_err_ns = ~(|arb_req_i) & m_axis_tvalid_req;

// decode_err is registered to minimize timing impact.  Results in a bubble
// cycle when an err occurs
always @(posedge ACLK) begin
  if (ARESET) begin
    decode_err_r <= {C_NUM_MI_SLOTS{1'b0}};
  end
  else if (ACLKEN) begin
    decode_err_r <= decode_err_ns & ~decode_err_r;
  end
end

assign tready_or_decode_err = m_tready_from_decoded_slave | decode_err_r;
assign DECODE_ERR = decode_err_r;

// Output ARBITER decision value from M_AXIS_TPAYLOAD
axis_interconnect_v1_1_18_util_vector2axis #(
  .C_TDATA_WIDTH    ( C_AXIS_TDATA_WIDTH ) ,
  .C_TID_WIDTH      ( C_AXIS_TID_WIDTH   ) ,
  .C_TDEST_WIDTH    ( C_AXIS_TDEST_WIDTH ) ,
  .C_TUSER_WIDTH    ( C_AXIS_TUSER_WIDTH ) ,
  .C_TPAYLOAD_WIDTH ( C_TPAYLOAD_WIDTH   ) ,
  .C_SIGNAL_SET     ( C_AXIS_SIGNAL_SET  ) 
)
util_vector2axis_0 (
  .TPAYLOAD ( M_AXIS_TPAYLOAD ) ,
  .TDATA    (                 ) ,
  .TSTRB    (                 ) ,
  .TKEEP    (                 ) ,
  .TLAST    ( ARB_LAST        ) ,
  .TID      ( ARB_ID          ) ,
  .TDEST    ( ARB_DEST        ) ,
  .TUSER    ( ARB_USER        ) 
);

endmodule // axisc_decoder

`default_nettype wire


// (c) Copyright 2011-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axisc_transfer_mux
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_axisc_transfer_mux #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter         C_FAMILY           = "virtex7",
   parameter         C_TPAYLOAD_WIDTH   = 32,
   parameter integer C_AXIS_TDATA_WIDTH = 32,
   parameter integer C_AXIS_TID_WIDTH   = 1,
   parameter integer C_AXIS_TDEST_WIDTH = 1,
   parameter integer C_AXIS_TUSER_WIDTH = 1,
   parameter [31:0]  C_AXIS_SIGNAL_SET  = 32'hFF,
   // C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional signals are present
   //   [0] => TREADY present
   //   [1] => TDATA present
   //   [2] => TSTRB present, TDATA must be present
   //   [3] => TKEEP present, TDATA must be present
   //   [4] => TLAST present
   //   [5] => TID present
   //   [6] => TDEST present
   //   [7] => TUSER present
   parameter integer C_NUM_SI_SLOTS     = 2,
   parameter integer C_LOG_SI_SLOTS     = 1,
   parameter integer C_USE_PACKET_MODE  = 1,
   // C_USE_PACKET_MODE: 
   //   0 => Ignore TLAST
   //   1 => Signal ARB_DONE on TLAST
   parameter integer C_MAX_XFERS_PER_ARB = 5,
   // C_MAX_XFERS_PER_ARB: 
   //  0 => Ignore number of transfers to signal DONE
   //  1+ => Signal ARB_DONE after x TRANSFERS
   parameter integer C_NUM_CYCLES_TIMEOUT = 5,
   // C_NUM_CYCLE_TIMEOUT: 
   //  0 => Ignore TIMEOUT parameter
   //  1+ => Signal ARB_DONE after x cylces of TVALID low
   parameter integer C_REG_CONFIG       = 1, 
   // C_REG_CONFIG: Registers payload and ARB_REQ signal
   //   0 => BYPASS    = The channel is just wired through the module.
   //   1 => FWD_REV   = Both FWD and REV (fully-registered)
   //   2 => FWD       = The master VALID and payload signals are registrated. 
   //   3 => REV       = The slave ready signal is registrated
   //   4 => RESERVED (all outputs driven to 0).
   //   5 => RESERVED (all outputs driven to 0).
   //   6 => INPUTS    = Slave and Master side inputs are registrated.
   //   7 => LIGHT_WT  = 1-stage pipeline register with bubble cycle, both FWD and REV pipelining
   parameter [C_NUM_SI_SLOTS-1:0] C_CONNECTIVITY = {C_NUM_SI_SLOTS{1'b1}},
   // Specifies connectivity matrix for sparse crossbar configurations
   parameter integer C_SINGLE_SLAVE_CONNECTIVITY = 1
)
(
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
   // System Signals
   input wire ACLK,
   input wire ARESET,
   input wire ACLKEN,

   // Slave side
   input  wire [C_NUM_SI_SLOTS-1:0]                  S_AXIS_TVALID,
   output wire [C_NUM_SI_SLOTS-1:0]                  S_AXIS_TREADY,
   input  wire [C_NUM_SI_SLOTS*C_TPAYLOAD_WIDTH-1:0] S_AXIS_TPAYLOAD,

   // Master side
   output wire                                       M_AXIS_TVALID,
   input  wire                                       M_AXIS_TREADY,
   output wire [C_TPAYLOAD_WIDTH-1:0]                M_AXIS_TPAYLOAD,

   // Arbiter side
   input  wire [C_NUM_SI_SLOTS-1:0]                  ARB_GNT,
   input  wire [C_LOG_SI_SLOTS-1:0]                  ARB_SEL,
   output wire                                       ARB_DONE
);

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
`include "axis_interconnect_v1_1_18.vh"

localparam P_LOG_NUM_SLAVE_SLOTS = f_clogb2(C_NUM_SI_SLOTS);
function [C_NUM_SI_SLOTS-1:0] f_onehot_to_binary ( 
  input integer  onehot
);
begin : main 
  integer i;
  for (i = 0; onehot[i] != 1; i = i + 1) begin
  end
  f_onehot_to_binary = i;
end
endfunction
////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
// Check if Connectivity is a power of a 2 which would mean that there is only
// 1 slave connected.
// localparam P_SINGLE_SLAVE_CONNECTIVITY = ((C_CONNECTIVITY & (C_CONNECTIVITY-1)) == 0);
localparam P_FIXED_MUX_VALUE = f_onehot_to_binary(C_CONNECTIVITY);

////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
wire [C_NUM_SI_SLOTS-1:0]   busy_ns;
/*reg  [C_NUM_SI_SLOTS-1:0]   busy_r;*/
wire [C_NUM_SI_SLOTS-1:0]   busy_r;
wire [C_LOG_SI_SLOTS-1:0]   sel_i;
wire [C_TPAYLOAD_WIDTH-1:0] axis_tpayload_mux_out;
wire                        axis_tvalid_mux_out;
wire                        axis_tready_mux_in;
wire                        axis_tlast_i;
wire [C_NUM_SI_SLOTS-1:0]   output_enable;
////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////

axis_interconnect_v1_1_18_axisc_arb_responder #( 
  .C_FAMILY             ( C_FAMILY             ) ,
  .C_ARB_GNT_WIDTH      ( C_NUM_SI_SLOTS       ) ,
  .C_USE_PACKET_MODE    ( C_USE_PACKET_MODE    ) ,
  .C_MAX_XFERS_PER_ARB  ( C_MAX_XFERS_PER_ARB  ) ,
  .C_NUM_CYCLES_TIMEOUT ( C_NUM_CYCLES_TIMEOUT ) ,
  .C_SINGLE_SLAVE_CONNECTIVITY (C_SINGLE_SLAVE_CONNECTIVITY )
)
axisc_arb_responder (
  .ACLK        ( ACLK                ) ,
  .ARESET      ( ARESET              ) ,
  .ACLKEN      ( ACLKEN              ) ,
  .AXIS_TVALID ( axis_tvalid_mux_out ) ,
  .AXIS_TREADY ( axis_tready_mux_in  ) ,
  .AXIS_TLAST  ( axis_tlast_i        ) ,
  .ARB_GNT     ( ARB_GNT             ) ,
  .ARB_DONE    ( ARB_DONE            ) ,
  .ARB_BUSY    ( busy_r              ) 
);

/*assign busy_ns = ARB_DONE ? 1'b0 : ARB_GNT | busy_r;*/
/**/
/*always @(posedge ACLK) begin */
/*  if (ARESET) begin*/
/*    busy_r <= {C_NUM_SI_SLOTS{1'b0}};*/
/*  end else if (ACLKEN) begin*/
/*    busy_r <= busy_ns;*/
/*  end*/
/*end*/
/**/
/*assign ARB_DONE = (C_USE_PACKET_MODE && axis_tlast_i) & axis_tvalid_mux_out & axis_tready_mux_in;*/

assign sel_i = (C_SINGLE_SLAVE_CONNECTIVITY | C_NUM_SI_SLOTS == 1) ? P_FIXED_MUX_VALUE :
               ARB_SEL;

assign output_enable = ( C_NUM_SI_SLOTS == 1 ) ? 1'b1 : 
                       ( C_SINGLE_SLAVE_CONNECTIVITY ) ? C_CONNECTIVITY[C_NUM_SI_SLOTS-1:0] :
                       ARB_GNT | busy_r;

axis_interconnect_v1_1_18_mux_enc #(
  .C_FAMILY     ( C_FAMILY              ) ,
  .C_RATIO      ( C_NUM_SI_SLOTS        ) ,
  .C_SEL_WIDTH  ( P_LOG_NUM_SLAVE_SLOTS ) ,
  .C_DATA_WIDTH ( C_TPAYLOAD_WIDTH      ) 
)
mux_enc_0
(
  .S  ( sel_i                 ) ,
  .A  ( S_AXIS_TPAYLOAD       ) ,
  .O  ( axis_tpayload_mux_out ) ,
  .OE ( 1'b1                  ) 
);
axis_interconnect_v1_1_18_mux_enc #(
  .C_FAMILY     ( C_FAMILY              ) ,
  .C_RATIO      ( C_NUM_SI_SLOTS        ) ,
  .C_SEL_WIDTH  ( P_LOG_NUM_SLAVE_SLOTS ) ,
  .C_DATA_WIDTH ( 1                     ) 
)
mux_enc_1
(
  .S  ( sel_i               ) ,
  .A  ( S_AXIS_TVALID       ) ,
  .O  ( axis_tvalid_mux_out ) ,
  .OE ( | output_enable     ) 
);

axis_interconnect_v1_1_18_util_vector2axis #(
  .C_TDATA_WIDTH    ( C_AXIS_TDATA_WIDTH ) ,
  .C_TID_WIDTH      ( C_AXIS_TID_WIDTH   ) ,
  .C_TDEST_WIDTH    ( C_AXIS_TDEST_WIDTH ) ,
  .C_TUSER_WIDTH    ( C_AXIS_TUSER_WIDTH ) ,
  .C_TPAYLOAD_WIDTH ( C_TPAYLOAD_WIDTH   ) ,
  .C_SIGNAL_SET     ( C_AXIS_SIGNAL_SET  ) 
)
util_vector2axis_0 (
  .TPAYLOAD ( axis_tpayload_mux_out ) ,
  .TDATA    (                       ) ,
  .TSTRB    (                       ) ,
  .TKEEP    (                       ) ,
  .TLAST    ( axis_tlast_i          ) ,
  .TID      (                       ) ,
  .TDEST    (                       ) ,
  .TUSER    (                       ) 
);

assign S_AXIS_TREADY = {C_NUM_SI_SLOTS{axis_tready_mux_in}} & output_enable;

axis_interconnect_v1_1_18_axisc_register_slice #(
  .C_FAMILY     ( C_FAMILY         ) ,
  .C_DATA_WIDTH ( C_TPAYLOAD_WIDTH ) ,
  .C_REG_CONFIG ( C_REG_CONFIG     ) 
)
axisc_register_slice_0 (
  .ACLK           ( ACLK                  ) ,
  .ARESET         ( ARESET                ) ,
  .ACLKEN         ( ACLKEN                ) ,
  .S_VALID        ( axis_tvalid_mux_out   ) ,
  .S_READY        ( axis_tready_mux_in    ) ,
  .S_PAYLOAD_DATA ( axis_tpayload_mux_out ) ,

  .M_VALID        ( M_AXIS_TVALID         ) ,
  .M_READY        ( M_AXIS_TREADY         ) ,
  .M_PAYLOAD_DATA ( M_AXIS_TPAYLOAD       ) 
);

endmodule // axisc_transfer_mux

`default_nettype wire


// (c) Copyright 2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axisc_arb_responder
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_axisc_arb_responder #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter         C_FAMILY           = "virtex7",
   parameter integer C_ARB_GNT_WIDTH    = 1,
   parameter integer C_USE_PACKET_MODE  = 1,
   // C_USE_PACKET_MODE: 
   //   0 => Ignore TLAST
   //   1 => Signal ARB_DONE on TLAST
   parameter integer C_MAX_XFERS_PER_ARB = 0,
   // C_MAX_XFERS_PER_ARB: 
   //  0 => Ignore number of transfers to signal DONE
   //  1+ => Signal ARB_DONE after x TRANSFERS
   parameter integer C_NUM_CYCLES_TIMEOUT = 0,
   // C_NUM_CYCLE_TIMEOUT: 
   //  0 => Ignore TIMEOUT parameter
   //  1+ => Signal ARB_DONE after x cylces of TVALID low
   parameter integer C_SINGLE_SLAVE_CONNECTIVITY = 0
   // C_SINGLE_SLAVE_CONNECTIVITY:
   // Indicates there is no need for arbiter, assert arb_done on every
   // VALID/READY.
)
(
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
   // System Signals
   input wire ACLK,
   input wire ARESET,
   input wire ACLKEN,

   // AXIS monitored signals
   input wire                           AXIS_TVALID,
   input wire                           AXIS_TREADY,
   input wire                           AXIS_TLAST,

   // Arbiter side
   input  wire [C_ARB_GNT_WIDTH-1:0]    ARB_GNT,
   output wire                          ARB_DONE,

   // Status Signals
   output wire [C_ARB_GNT_WIDTH-1:0]    ARB_BUSY
);

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
`include "axis_interconnect_v1_1_18.vh"

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
localparam integer P_XFER_CNT_WIDTH = f_clogb2(C_MAX_XFERS_PER_ARB);
localparam integer P_TIMEOUT_CNT_WIDTH = f_clogb2(C_NUM_CYCLES_TIMEOUT+1);
localparam integer P_FORCE_MAX_XFERS_PER_ARB_ONE = (C_USE_PACKET_MODE == 0 
                                                    && C_MAX_XFERS_PER_ARB == 0 
                                                    && C_NUM_CYCLES_TIMEOUT == 0) ? 1 : 0;



////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
wire [C_ARB_GNT_WIDTH-1:0]   busy_ns;
reg  [C_ARB_GNT_WIDTH-1:0]   busy_r;

wire tlast_done;
wire xfer_done;
wire timeout_done;
wire timeout_done_ns;
////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////
assign busy_ns = timeout_done_ns | ARB_DONE ? {C_ARB_GNT_WIDTH{1'b0}} : ARB_GNT | busy_r;

always @(posedge ACLK) begin 
  if (ARESET) begin
    busy_r <= {C_ARB_GNT_WIDTH{1'b0}};
  end else if (ACLKEN) begin
    busy_r <= busy_ns;
  end
end

assign ARB_BUSY = busy_r;

assign ARB_DONE = tlast_done | xfer_done | timeout_done;

generate 
  if (C_SINGLE_SLAVE_CONNECTIVITY | P_FORCE_MAX_XFERS_PER_ARB_ONE) begin : gen_default_response
    assign tlast_done = 1'b0;
    assign xfer_done = AXIS_TVALID & AXIS_TREADY;
    assign timeout_done = 1'b0;
    assign timeout_done_ns = 1'b0;
  end
  else begin : gen_configurable_response
    // Generate TLAST DONE block
    assign tlast_done = C_USE_PACKET_MODE & (AXIS_TVALID & AXIS_TREADY) ? AXIS_TLAST : 1'b0;

    // Generate XFER_DONE block
    if (C_MAX_XFERS_PER_ARB == 0) begin : gen_max_xfer_per_arb_cnt_disabled
      assign xfer_done = 1'b0;
    end
    else if (C_MAX_XFERS_PER_ARB == 1) begin : gen_max_xfers_per_arb_cnt_one
      assign xfer_done = AXIS_TVALID & AXIS_TREADY;
    end
    else begin : gen_max_xfer_per_arb_cntr
      reg [P_XFER_CNT_WIDTH-1:0] xfer_cnt;
      reg                        xfer_done_r;
      wire                       xfer_cnt_ns;


      always @(posedge ACLK) begin 
        if (ARESET) begin
          xfer_cnt <= {P_XFER_CNT_WIDTH{1'b0}};
        end else if (ACLKEN) begin
          xfer_cnt <= ARB_DONE ? {P_XFER_CNT_WIDTH{1'b0}} : 
                    (AXIS_TVALID & AXIS_TREADY) ? xfer_cnt + 1'b1 : xfer_cnt;
        end
        else begin 
          xfer_cnt <= xfer_cnt;
        end
      end

      always @(posedge ACLK) begin
        if (ARESET) begin
          xfer_done_r <= 1'b0;
        end else if (ACLKEN) begin
          xfer_done_r <= ARB_DONE ? 1'b0 : 
                         (AXIS_TVALID & AXIS_TREADY) ? (xfer_cnt == C_MAX_XFERS_PER_ARB-2) : xfer_done_r;
        end
        else begin
          xfer_done_r <= xfer_done_r;
        end
      end
      assign xfer_done = xfer_done_r & AXIS_TVALID & AXIS_TREADY;
    end

    // Generate TIMEOUT DONE block
    if (C_NUM_CYCLES_TIMEOUT == 0) begin : gen_num_cycles_timeout_disabled
      assign timeout_done = 1'b0;
      assign timeout_done_ns = 1'b0;
    end
    else begin : gen_num_cycles_timeout_cntr
      reg [P_TIMEOUT_CNT_WIDTH-1:0] timeout_cnt;
      reg                           timeout_done_r;
      always @(posedge ACLK) begin 
        if (ARESET) begin
          timeout_cnt <= {P_TIMEOUT_CNT_WIDTH{1'b0}};
        end else if (ACLKEN) begin
          timeout_cnt <= AXIS_TVALID ? {P_TIMEOUT_CNT_WIDTH{1'b0}} : timeout_cnt + 1'b1;
        end else begin
          timeout_cnt <= timeout_cnt;
        end
      end

      assign timeout_done_ns = (|busy_r) ? (timeout_cnt == C_NUM_CYCLES_TIMEOUT) & ~AXIS_TVALID : 1'b0;

      always @(posedge ACLK) begin
        if (ARESET) begin
          timeout_done_r <= 1'b0;
        end else if (ACLKEN) begin
          timeout_done_r <= timeout_done_ns;
        end
      end
      assign timeout_done = timeout_done_r;
    end
  end
endgenerate

endmodule // axisc_transfer_mux

`default_nettype wire


// (c) Copyright 2011-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axis_switch_arbiter
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_axis_switch_arbiter #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter         C_FAMILY        = "virtex7",
   parameter integer C_NUM_SI_SLOTS  = 8,
   parameter integer C_LOG_SI_SLOTS  = 3,
   parameter integer C_NUM_MI_SLOTS  = 2,
   parameter         C_ARB_ALGORITHM = "ROUND_ROBIN",
   parameter         C_SINGLE_SLAVE_CONNECTIVITY_ARRAY = {C_NUM_MI_SLOTS{1'b0}} 
)
(
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
   // System Signals
   input wire ACLK,
   input wire ARESETN,
   input wire ACLKEN,

   input  wire  [C_NUM_MI_SLOTS*C_NUM_SI_SLOTS-1:0] ARB_REQ,
   input  wire  [C_NUM_MI_SLOTS-1:0]                ARB_DONE,
   output wire  [C_NUM_MI_SLOTS*C_NUM_SI_SLOTS-1:0] ARB_GNT,
   output wire  [C_NUM_MI_SLOTS*C_LOG_SI_SLOTS-1:0] ARB_SEL
);

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
reg areset;

////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////

always @(posedge ACLK) begin
  areset <= ~ARESETN;
end

generate
  genvar i;
  for (i = 0; i < C_NUM_MI_SLOTS; i = i + 1) begin : gen_mi_arb
    if (C_SINGLE_SLAVE_CONNECTIVITY_ARRAY[i]) begin : gen_arb_tie_off
      assign ARB_GNT [i*C_NUM_SI_SLOTS+:C_NUM_SI_SLOTS] = ARB_REQ[i*C_NUM_SI_SLOTS+:C_NUM_SI_SLOTS];
      assign ARB_SEL [i*C_LOG_SI_SLOTS+:C_LOG_SI_SLOTS] = {C_LOG_SI_SLOTS{1'b0}};
    end else if (C_ARB_ALGORITHM == "ROUND_ROBIN" || C_ARB_ALGORITHM == "FIXED") begin : gen_rr
      axis_interconnect_v1_1_18_arb_rr #(
        .C_FAMILY        ( C_FAMILY        ) ,
        .C_NUM_SI_SLOTS  ( C_NUM_SI_SLOTS  ) ,
        .C_LOG_SI_SLOTS  ( C_LOG_SI_SLOTS  ) ,
        .C_ARB_ALGORITHM ( C_ARB_ALGORITHM ) 
      )
      arb_rr_0
      (
        .ACLK     ( ACLK                                       ) ,
        .ARESET   ( areset                                     ) ,
        .ACLKEN   ( ACLKEN                                     ) ,
        .ARB_REQ  ( ARB_REQ [i*C_NUM_SI_SLOTS+:C_NUM_SI_SLOTS] ) ,
        .ARB_DONE ( ARB_DONE[i]                                ) ,
        .ARB_SEL  ( ARB_SEL [i*C_LOG_SI_SLOTS+:C_LOG_SI_SLOTS] ) ,
        .ARB_GNT  ( ARB_GNT [i*C_NUM_SI_SLOTS+:C_NUM_SI_SLOTS] ) 
      );
    end
  end
endgenerate

endmodule // axis_switch_arbiter

`default_nettype wire


// (c) Copyright 2011-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   dynamic_priority_encoder
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_dynamic_priority_encoder #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter         C_FAMILY    = "virtex7",
   parameter integer C_REQ_WIDTH = 8,
   parameter integer C_ENC_WIDTH = 3
)
(
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
   input  wire  [C_REQ_WIDTH-1:0]             REQ,
   input  wire  [C_REQ_WIDTH*C_ENC_WIDTH-1:0] PORT_PRIORITY,
   output wire  [C_ENC_WIDTH-1:0]             SEL,
   output wire                                VALID
);

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
// `include "axis_interconnect_v1_1_18.vh"

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
localparam P_NATIVE = 4; // Encoder defined for 4 inputs

////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////

// Priority encoder specified completed for up to 8 inputs and is configurable 
// with the localparam P_NATIVE.  If less than P_NATIVE inputs instantiate a 
// P_NATIVE input priority encoder and tie off upper bits.  Allow synthesis tool 
// to prune.  If more than P_NATIVE bits, then halve the numeber of inputs and
// recursively call two encoder instances for lsb and msb.  MUX output of lsb
// and msb with valid_lsb to get final result.
generate
if (C_REQ_WIDTH < P_NATIVE) begin : pri_encoder_padded

  wire [P_NATIVE-1:0]               req_i;
  wire [P_NATIVE*C_ENC_WIDTH-1:0]   port_priority_i;

  // Pad MSB of req with 0s.
  assign req_i = {{P_NATIVE-C_REQ_WIDTH{1'b0}}, REQ};
  assign port_priority_i = {{(P_NATIVE-C_REQ_WIDTH)*C_ENC_WIDTH{1'b0}}, PORT_PRIORITY};

  axis_interconnect_v1_1_18_dynamic_priority_encoder #(
    .C_FAMILY    ( C_FAMILY    ) ,
    .C_REQ_WIDTH ( P_NATIVE    ) ,
    .C_ENC_WIDTH ( C_ENC_WIDTH ) 
  )
  dynamic_priority_encoder_padded_0
  (
    .REQ           ( req_i           ) ,
    .PORT_PRIORITY ( port_priority_i ) ,
    .SEL           ( SEL             ) ,
    .VALID         ( VALID           ) 
  );
end
else if (C_REQ_WIDTH == P_NATIVE) begin : pri_encoder_4bit

  reg [C_ENC_WIDTH-1:0] sel_i;
  reg                   valid_i;

  // Select based on priority of 0 highest P_NATIVE lowest
  // The mod value with constant is used to avoid compilation warnings when
  // P_NATIVE < 8.
  always @* begin
    if ( REQ[0] ) begin 
      sel_i = PORT_PRIORITY[0*C_ENC_WIDTH+:C_ENC_WIDTH];
    end else if ( REQ[1%P_NATIVE] && P_NATIVE > 2) begin 
      sel_i = PORT_PRIORITY[1%P_NATIVE*C_ENC_WIDTH+:C_ENC_WIDTH];
    end else if ( REQ[2%P_NATIVE] && P_NATIVE > 3) begin 
      sel_i = PORT_PRIORITY[2%P_NATIVE*C_ENC_WIDTH+:C_ENC_WIDTH];
    end else if ( REQ[3%P_NATIVE] && P_NATIVE > 4) begin 
      sel_i = PORT_PRIORITY[3%P_NATIVE*C_ENC_WIDTH+:C_ENC_WIDTH];
    end else if ( REQ[4%P_NATIVE] && P_NATIVE > 5) begin 
      sel_i = PORT_PRIORITY[4%P_NATIVE*C_ENC_WIDTH+:C_ENC_WIDTH];
    end else if ( REQ[5%P_NATIVE] && P_NATIVE > 6) begin 
      sel_i = PORT_PRIORITY[5%P_NATIVE*C_ENC_WIDTH+:C_ENC_WIDTH];
    end else if ( REQ[6%P_NATIVE] && P_NATIVE > 7) begin 
      sel_i = PORT_PRIORITY[6%P_NATIVE*C_ENC_WIDTH+:C_ENC_WIDTH];
    end else begin
      sel_i = PORT_PRIORITY[(P_NATIVE-1)*C_ENC_WIDTH+:C_ENC_WIDTH];
    end
  end

  // Valid when any input value is 1
  always @* begin
    valid_i = |REQ;
  end

  assign SEL = sel_i;
  assign VALID = valid_i;
end
else if (C_REQ_WIDTH > P_NATIVE) begin : recursive_dynamic_priority_encoder

  wire [C_REQ_WIDTH/2-1:0]                             req_lsb;
  wire [C_REQ_WIDTH-(C_REQ_WIDTH/2)-1:0]               req_msb;
  wire [(C_REQ_WIDTH/2)*C_ENC_WIDTH-1:0]               port_priority_lsb;
  wire [(C_REQ_WIDTH-(C_REQ_WIDTH/2))*C_ENC_WIDTH-1:0] port_priority_msb;
  wire [C_ENC_WIDTH-1:0]                               sel_lsb;
  wire [C_ENC_WIDTH-1:0]                               sel_msb;
  wire                                                 valid_lsb;
  wire                                                 valid_msb;

  assign req_lsb = REQ[C_REQ_WIDTH/2-1:0];
  assign req_msb = REQ[C_REQ_WIDTH-1:C_REQ_WIDTH/2];
  assign port_priority_lsb = PORT_PRIORITY[(C_REQ_WIDTH/2)*C_ENC_WIDTH-1:0];
  assign port_priority_msb = PORT_PRIORITY[C_REQ_WIDTH*C_ENC_WIDTH-1:(C_REQ_WIDTH/2)*C_ENC_WIDTH];

  axis_interconnect_v1_1_18_dynamic_priority_encoder #(
    .C_FAMILY    ( C_FAMILY      ) ,
    .C_REQ_WIDTH ( C_REQ_WIDTH/2 ) ,
    .C_ENC_WIDTH ( C_ENC_WIDTH   ) 
  )
  dynamic_priority_encoder_lsb_0
  (
    .REQ           ( req_lsb           ) ,
    .PORT_PRIORITY ( port_priority_lsb ) ,
    .SEL           ( sel_lsb           ) ,
    .VALID         ( valid_lsb         ) 
  );

  axis_interconnect_v1_1_18_dynamic_priority_encoder #(
    .C_FAMILY    ( C_FAMILY                      ) ,
    .C_REQ_WIDTH ( C_REQ_WIDTH - (C_REQ_WIDTH/2) ) ,
    .C_ENC_WIDTH ( C_ENC_WIDTH                   ) 
  )
  dynamic_priority_encoder_msb_0
  (
    .REQ           ( req_msb           ) ,
    .PORT_PRIORITY ( port_priority_msb ) ,
    .SEL           ( sel_msb           ) ,
    .VALID         ( valid_msb         ) 
  );

  assign SEL = valid_lsb ? sel_lsb : sel_msb;
  assign VALID = valid_lsb | valid_msb;  
end
endgenerate

endmodule // dynamic_priority_encoder

`default_nettype wire


// (c) Copyright 2011-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axis_switch
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_axis_switch #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter         C_FAMILY            = "virtex7",
   parameter integer C_AXIS_TDATA_WIDTH  = 32,
   parameter integer C_AXIS_TID_WIDTH    = 1,
   parameter integer C_AXIS_TDEST_WIDTH  = 2,
   parameter integer C_AXIS_TUSER_WIDTH  = 1,
   parameter [31:0]  C_AXIS_SIGNAL_SET   = 32'hFF,
   // C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional signals are present
   //   [0] => TREADY present
   //   [1] => TDATA present
   //   [2] => TSTRB present, TDATA must be present
   //   [3] => TKEEP present, TDATA must be present
   //   [4] => TLAST present
   //   [5] => TID present
   //   [6] => TDEST present
   //   [7] => TUSER present
   parameter integer C_MI_REG_CONFIG     = 0,
   parameter integer C_SI_REG_CONFIG     = 1,
   parameter integer C_NUM_SI_SLOTS      = 4,
   parameter integer C_LOG_SI_SLOTS      = 2,
   parameter integer C_NUM_MI_SLOTS      = 4,
   // 0 - External Arbiter
   // 1 - Internal Arbiter: Round Robin
   // 2 - Internal Arbiter: Fixed
   // 3-31 - Internal Arbiter: Reserved
   // 32 - External Arbiter: Packet Mode
   // 33 - Internal Arbiter: Round Robin: Packet Mode
   // 34 - Internal Arbiter: Fixed: Packet Mode
   // 35 - Internal Arbiter: Reserved: Packet Mode
   parameter integer C_SWITCH_MODE       = 33,
   parameter integer C_MAX_XFERS_PER_ARB = 0,
   // C_MAX_XFERS_PER_ARB: 
   //  0 => Ignore number of transfers to signal DONE
   //  1+ => Signal ARB_DONE after x TRANSFERS
   parameter integer C_NUM_CYCLES_TIMEOUT = 0,
   // C_NUM_CYCLE_TIMEOUT: 
   //  0 => Ignore TIMEOUT parameter
   //  1+ => Signal ARB_DONE after x cylces of TVALID low
   parameter [C_NUM_MI_SLOTS*C_NUM_SI_SLOTS-1:0] C_M_AXIS_CONNECTIVITY_ARRAY = {C_NUM_MI_SLOTS*C_NUM_SI_SLOTS{1'b1}},
   parameter [C_NUM_MI_SLOTS*C_AXIS_TDEST_WIDTH-1:0] C_M_AXIS_BASETDEST_ARRAY = {C_NUM_MI_SLOTS*C_AXIS_TDEST_WIDTH{1'b1}},
   parameter [C_NUM_MI_SLOTS*C_AXIS_TDEST_WIDTH-1:0] C_M_AXIS_HIGHTDEST_ARRAY = {C_NUM_MI_SLOTS*C_AXIS_TDEST_WIDTH{1'b0}}

 )
 ( 
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////

   // System Signals
   input wire ACLK,
   input wire ARESETN,
   input wire ACLKEN,

   // Slave side
   input  wire [C_NUM_SI_SLOTS-1:0]                                   S_AXIS_TVALID,
   output wire [C_NUM_SI_SLOTS-1:0]                                   S_AXIS_TREADY,
   input  wire [C_NUM_SI_SLOTS*C_AXIS_TDATA_WIDTH-1:0]                S_AXIS_TDATA,
   input  wire [C_NUM_SI_SLOTS*C_AXIS_TDATA_WIDTH/8-1:0]              S_AXIS_TSTRB,
   input  wire [C_NUM_SI_SLOTS*C_AXIS_TDATA_WIDTH/8-1:0]              S_AXIS_TKEEP,
   input  wire [C_NUM_SI_SLOTS-1:0]                                   S_AXIS_TLAST,
   input  wire [C_NUM_SI_SLOTS*C_AXIS_TID_WIDTH-1:0]                  S_AXIS_TID,
   input  wire [C_NUM_SI_SLOTS*C_AXIS_TDEST_WIDTH-1:0]                S_AXIS_TDEST,
   input  wire [C_NUM_SI_SLOTS*C_AXIS_TUSER_WIDTH-1:0]                S_AXIS_TUSER,

   // Master side
   output wire [C_NUM_MI_SLOTS-1:0]                                   M_AXIS_TVALID,
   input  wire [C_NUM_MI_SLOTS-1:0]                                   M_AXIS_TREADY,
   output wire [C_NUM_MI_SLOTS*C_AXIS_TDATA_WIDTH-1:0]                M_AXIS_TDATA,
   output wire [C_NUM_MI_SLOTS*C_AXIS_TDATA_WIDTH/8-1:0]              M_AXIS_TSTRB,
   output wire [C_NUM_MI_SLOTS*C_AXIS_TDATA_WIDTH/8-1:0]              M_AXIS_TKEEP,
   output wire [C_NUM_MI_SLOTS-1:0]                                   M_AXIS_TLAST,
   output wire [C_NUM_MI_SLOTS*C_AXIS_TID_WIDTH-1:0]                  M_AXIS_TID,
   output wire [C_NUM_MI_SLOTS*C_AXIS_TDEST_WIDTH-1:0]                M_AXIS_TDEST,
   output wire [C_NUM_MI_SLOTS*C_AXIS_TUSER_WIDTH-1:0]                M_AXIS_TUSER ,
   
   // Arbiter interface
   output wire [C_NUM_MI_SLOTS*C_NUM_SI_SLOTS-1:0]                    ARB_REQ,
   input  wire [C_NUM_MI_SLOTS*C_NUM_SI_SLOTS-1:0]                    ARB_GNT,
   input  wire [C_NUM_MI_SLOTS-1:0]                                   ARB_BUSY,
   output wire [C_NUM_MI_SLOTS*C_NUM_SI_SLOTS-1:0]                    ARB_LAST,
   output wire [C_NUM_MI_SLOTS*C_NUM_SI_SLOTS*C_AXIS_TID_WIDTH-1:0]   ARB_ID,
   output wire [C_NUM_MI_SLOTS*C_NUM_SI_SLOTS*C_AXIS_TDEST_WIDTH-1:0] ARB_DEST,
   output wire [C_NUM_MI_SLOTS*C_NUM_SI_SLOTS*C_AXIS_TUSER_WIDTH-1:0] ARB_USER,
   input wire  [C_NUM_SI_SLOTS-1:0]                                   ARB_REQ_SUPPRESS,

   // Err output
   output wire [C_NUM_SI_SLOTS-1:0]                                   S_DECODE_ERR
   );

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
function [C_NUM_MI_SLOTS*C_NUM_SI_SLOTS-1:0] f_transform_mxn_to_nxm (
  input integer                                    m_width,
  input integer                                    n_width,
  input [C_NUM_SI_SLOTS*C_NUM_MI_SLOTS-1:0] x
);
begin : main
  integer i;
  integer j;
  for (j = 0; j < n_width; j = j+1) begin
    for (i = 0; i < m_width; i = i+1) begin
      f_transform_mxn_to_nxm[j*m_width+i] = x[j+n_width*i];
    end
  end
end
endfunction

function [C_NUM_MI_SLOTS-1:0] f_calc_single_slave_connectivity_array (
  input integer                                    num_masters,
  input [C_NUM_SI_SLOTS*C_NUM_MI_SLOTS-1:0] x
);
begin : main
  integer i;
  integer j;
  for (j = 0; j < num_masters; j = j+1) begin
    f_calc_single_slave_connectivity_array[j] = (x[j*C_NUM_SI_SLOTS+:C_NUM_SI_SLOTS] & (x[j*C_NUM_SI_SLOTS+:C_NUM_SI_SLOTS]-1)) ? 1'b0 : 1'b1;
  end
end
endfunction

`include "axis_interconnect_v1_1_18.vh"


////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
localparam P_DECODER_CONNECTIVITY_ARRAY = f_transform_mxn_to_nxm(C_NUM_MI_SLOTS, C_NUM_SI_SLOTS,C_M_AXIS_CONNECTIVITY_ARRAY);
localparam P_TPAYLOAD_WIDTH = f_payload_width(C_AXIS_TDATA_WIDTH, C_AXIS_TID_WIDTH, C_AXIS_TDEST_WIDTH, 
                                              C_AXIS_TUSER_WIDTH, C_AXIS_SIGNAL_SET);
localparam P_USE_PACKET_MODE  = (C_SWITCH_MODE >= 32 && C_NUM_SI_SLOTS > 1) ? 1 : 0; // Packet mode not enabled if only one SI slot.
   // PACKET_MODE: 
   //   0 => Ignore TLAST
   //   1 => Signal ARB_DONE on TLAST
localparam P_INTERNAL_ARBITER = ((C_SWITCH_MODE % 32) != 0) ? 1 : 0;
localparam P_ARB_ALGORITHM    = ((C_SWITCH_MODE % 32) == 1) ? "ROUND_ROBIN" : "FIXED";
localparam [C_NUM_MI_SLOTS-1:0] P_SINGLE_SLAVE_CONNECTIVITY_ARRAY = f_calc_single_slave_connectivity_array(C_NUM_MI_SLOTS, C_M_AXIS_CONNECTIVITY_ARRAY);

////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
reg areset_r;

wire [C_NUM_SI_SLOTS*P_TPAYLOAD_WIDTH-1:0]     s_axis_tpayload;

// Wires between arbiter/decoder/transfer_mux
wire [ C_NUM_SI_SLOTS*C_NUM_MI_SLOTS-1:0                  ] dec_tvalid;
wire [ C_NUM_SI_SLOTS*C_NUM_MI_SLOTS-1:0                  ] dec_tready;
wire [ C_NUM_SI_SLOTS*P_TPAYLOAD_WIDTH-1:0                ] dec_tpayload;
wire [ C_NUM_SI_SLOTS*1-1:0                               ] dec_tlast;
wire [ C_NUM_SI_SLOTS*C_AXIS_TID_WIDTH-1:0                ] dec_tid;
wire [ C_NUM_SI_SLOTS*C_AXIS_TDEST_WIDTH-1:0              ] dec_tdest;
wire [ C_NUM_SI_SLOTS*C_AXIS_TUSER_WIDTH-1:0              ] dec_tuser;
wire [ C_NUM_SI_SLOTS*C_NUM_MI_SLOTS-1:0                  ] dec_arb_gnt;
wire [ C_NUM_SI_SLOTS*C_NUM_MI_SLOTS-1:0                  ] dec_arb_req;
wire [ C_NUM_SI_SLOTS*C_NUM_MI_SLOTS-1:0                  ] dec_arb_done;
wire [ C_NUM_SI_SLOTS*C_NUM_MI_SLOTS-1:0                  ] dec_arb_active;

wire [ C_NUM_MI_SLOTS*C_NUM_SI_SLOTS-1:0                  ] mux_tvalid;
wire [ C_NUM_MI_SLOTS*C_NUM_SI_SLOTS-1:0                  ] mux_tready;
wire [ C_NUM_MI_SLOTS*C_AXIS_TDATA_WIDTH-1:0              ] mux_tdata;
wire [ C_NUM_MI_SLOTS*C_NUM_SI_SLOTS*P_TPAYLOAD_WIDTH-1:0 ] mux_tpayload;
wire [ C_NUM_MI_SLOTS*C_NUM_SI_SLOTS-1:0                  ] arb_req_i;
wire [ C_NUM_MI_SLOTS-1:0                                 ] arb_done_i;
wire [ C_NUM_MI_SLOTS*C_NUM_SI_SLOTS-1:0                  ] arb_gnt_i;
wire [ C_NUM_MI_SLOTS*C_LOG_SI_SLOTS-1:0                  ] arb_sel_i;
wire [ C_NUM_MI_SLOTS*P_TPAYLOAD_WIDTH-1:0                ] tmo_tpayload;
        

////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////
always @(posedge ACLK) begin 
  areset_r <= ~ARESETN;
end

generate
  genvar si;
  genvar mi;
  for (si = 0; si < C_NUM_SI_SLOTS; si = si + 1) begin : gen_decoder
    axis_interconnect_v1_1_18_util_axis2vector #(
      .C_TDATA_WIDTH    ( C_AXIS_TDATA_WIDTH ) ,
      .C_TID_WIDTH      ( C_AXIS_TID_WIDTH   ) ,
      .C_TDEST_WIDTH    ( C_AXIS_TDEST_WIDTH ) ,
      .C_TUSER_WIDTH    ( C_AXIS_TUSER_WIDTH ) ,
      .C_TPAYLOAD_WIDTH ( P_TPAYLOAD_WIDTH   ) ,
      .C_SIGNAL_SET     ( C_AXIS_SIGNAL_SET  ) 
    )
    util_axis2vector_0 (
      .TDATA    ( S_AXIS_TDATA    [ si*C_AXIS_TDATA_WIDTH   +: C_AXIS_TDATA_WIDTH   ] ) ,
      .TSTRB    ( S_AXIS_TSTRB    [ si*C_AXIS_TDATA_WIDTH/8 +: C_AXIS_TDATA_WIDTH/8 ] ) ,
      .TKEEP    ( S_AXIS_TKEEP    [ si*C_AXIS_TDATA_WIDTH/8 +: C_AXIS_TDATA_WIDTH/8 ] ) ,
      .TLAST    ( S_AXIS_TLAST    [ si                      +: 1                    ] ) ,
      .TID      ( S_AXIS_TID      [ si*C_AXIS_TID_WIDTH     +: C_AXIS_TID_WIDTH     ] ) ,
      .TDEST    ( S_AXIS_TDEST    [ si*C_AXIS_TDEST_WIDTH   +: C_AXIS_TDEST_WIDTH   ] ) ,
      .TUSER    ( S_AXIS_TUSER    [ si*C_AXIS_TUSER_WIDTH   +: C_AXIS_TUSER_WIDTH   ] ) ,
      .TPAYLOAD ( s_axis_tpayload [ si*P_TPAYLOAD_WIDTH     +: P_TPAYLOAD_WIDTH     ] ) 
    );

    axis_interconnect_v1_1_18_axisc_decoder #(
      .C_FAMILY           ( C_FAMILY                                                        ) ,
      .C_AXIS_TDATA_WIDTH ( C_AXIS_TDATA_WIDTH                                              ) ,
      .C_AXIS_TID_WIDTH   ( C_AXIS_TID_WIDTH                                                ) ,
      .C_AXIS_TDEST_WIDTH ( C_AXIS_TDEST_WIDTH                                              ) ,
      .C_AXIS_TUSER_WIDTH ( C_AXIS_TUSER_WIDTH                                              ) ,
      .C_AXIS_SIGNAL_SET  ( C_AXIS_SIGNAL_SET                                               ) ,
      .C_TPAYLOAD_WIDTH   ( P_TPAYLOAD_WIDTH                                                ) ,
      .C_NUM_MI_SLOTS     ( C_NUM_MI_SLOTS                                                  ) ,
      .C_USE_PACKET_MODE  ( P_USE_PACKET_MODE                                               ) ,
      .C_REG_CONFIG       ( C_SI_REG_CONFIG                                                    ) ,
      .C_CONNECTIVITY     ( P_DECODER_CONNECTIVITY_ARRAY[si*C_NUM_MI_SLOTS+:C_NUM_MI_SLOTS] ) ,
      .C_BASETDEST        ( C_M_AXIS_BASETDEST_ARRAY[0+:C_NUM_MI_SLOTS*C_AXIS_TDEST_WIDTH]  ) ,
      .C_HIGHTDEST        ( C_M_AXIS_HIGHTDEST_ARRAY[0+:C_NUM_MI_SLOTS*C_AXIS_TDEST_WIDTH]  ) 
    )
    axisc_decoder_0
    (
      .ACLK            ( ACLK                                                            ) ,
      .ACLKEN          ( ACLKEN                                                          ) ,
      .ARESET          ( areset_r                                                        ) ,
      .S_AXIS_TVALID   ( S_AXIS_TVALID   [ si                    +: 1                  ] ) ,
      .S_AXIS_TREADY   ( S_AXIS_TREADY   [ si                    +: 1                  ] ) ,
      .S_AXIS_TPAYLOAD ( s_axis_tpayload [ si*P_TPAYLOAD_WIDTH   +: P_TPAYLOAD_WIDTH   ] ) ,
      .S_AXIS_TDEST    ( S_AXIS_TDEST    [ si*C_AXIS_TDEST_WIDTH +: C_AXIS_TDEST_WIDTH ] ) ,
      .M_AXIS_TVALID   ( dec_tvalid      [ si*C_NUM_MI_SLOTS     +: C_NUM_MI_SLOTS     ] ) ,
      .M_AXIS_TREADY   ( dec_tready      [ si*C_NUM_MI_SLOTS     +: C_NUM_MI_SLOTS     ] ) ,
      .M_AXIS_TPAYLOAD ( dec_tpayload    [ si*P_TPAYLOAD_WIDTH   +: P_TPAYLOAD_WIDTH   ] ) ,
      .ARB_LAST        ( dec_tlast       [ si                    +: 1                  ] ) ,
      .ARB_ID          ( dec_tid         [ si*C_AXIS_TID_WIDTH   +: C_AXIS_TID_WIDTH   ] ) ,
      .ARB_DEST        ( dec_tdest       [ si*C_AXIS_TDEST_WIDTH +: C_AXIS_TDEST_WIDTH ] ) ,
      .ARB_USER        ( dec_tuser       [ si*C_AXIS_TUSER_WIDTH +: C_AXIS_TUSER_WIDTH ] ) ,
      .ARB_REQ         ( dec_arb_req     [ si*C_NUM_MI_SLOTS     +: C_NUM_MI_SLOTS     ] ) ,
      .ARB_GNT         ( dec_arb_gnt     [ si*C_NUM_MI_SLOTS     +: C_NUM_MI_SLOTS     ] ) ,
      .ARB_DONE        ( dec_arb_done    [ si*C_NUM_MI_SLOTS     +: C_NUM_MI_SLOTS     ] ) ,
      .ARB_ACTIVE      ( dec_arb_active  [ si*C_NUM_MI_SLOTS     +: C_NUM_MI_SLOTS     ] ) ,
      .DECODE_ERR      ( S_DECODE_ERR    [ si                    +: 1                  ] )
    );
  end
  // These loops transform the output of the SI Decoders signals to arrange them into ARB
  // interface order
  for (mi = 0; mi < C_NUM_MI_SLOTS; mi = mi + 1) begin : gen_si2mi_master_transform
    for (si = 0; si < C_NUM_SI_SLOTS; si = si + 1) begin : gen_si2mi_slave_transform
      // These signals map 1:N from 1 per SI to multiple MI
      assign mux_tvalid   [ (mi*C_NUM_SI_SLOTS+si)                                        ] = dec_tvalid   [ si*C_NUM_MI_SLOTS+mi                      ] ;
      assign mux_tpayload [ (mi*C_NUM_SI_SLOTS+si)*P_TPAYLOAD_WIDTH+:P_TPAYLOAD_WIDTH     ] = dec_tpayload [ si*P_TPAYLOAD_WIDTH+:P_TPAYLOAD_WIDTH     ] ;
      assign ARB_LAST     [ (mi*C_NUM_SI_SLOTS+si)                                        ] = dec_tlast    [ si                                        ] ;
      assign ARB_ID       [ (mi*C_NUM_SI_SLOTS+si)*C_AXIS_TID_WIDTH+:C_AXIS_TID_WIDTH     ] = dec_tid      [ si*C_AXIS_TID_WIDTH+:C_AXIS_TID_WIDTH     ] ;
      assign ARB_DEST     [ (mi*C_NUM_SI_SLOTS+si)*C_AXIS_TDEST_WIDTH+:C_AXIS_TDEST_WIDTH ] = dec_tdest    [ si*C_AXIS_TDEST_WIDTH+:C_AXIS_TDEST_WIDTH ] ;
      assign ARB_USER     [ (mi*C_NUM_SI_SLOTS+si)*C_AXIS_TUSER_WIDTH+:C_AXIS_TUSER_WIDTH ] = dec_tuser    [ si*C_AXIS_TUSER_WIDTH+:C_AXIS_TUSER_WIDTH ] ;
      // These signals map 1:1 from multiple per SI to multiple per MI
      assign ARB_REQ      [ (mi*C_NUM_SI_SLOTS+si)                                        ] = dec_arb_req  [ si*C_NUM_MI_SLOTS+mi                   ] & ~ARB_REQ_SUPPRESS[si];
      assign arb_req_i    [ (mi*C_NUM_SI_SLOTS+si)                                        ] = dec_arb_req  [ si*C_NUM_MI_SLOTS+mi                   ] & ~ARB_REQ_SUPPRESS[si];
    end
  end
  // These loops transform the input to the Decoders signals to arrange them into 
  // slave interface order
  for (si = 0; si < C_NUM_SI_SLOTS; si = si + 1) begin : gen_mi2si_slave_transform
    for (mi = 0; mi < C_NUM_MI_SLOTS; mi = mi + 1) begin : gen_mi2si_master_transform
      assign dec_tready [ si*C_NUM_MI_SLOTS+mi ] = mux_tready[ mi*C_NUM_SI_SLOTS+si ];
      assign dec_arb_gnt[ si*C_NUM_MI_SLOTS+mi ] = arb_gnt_i [ mi*C_NUM_SI_SLOTS+si ];
      assign dec_arb_done[si*C_NUM_MI_SLOTS+mi ] = arb_done_i [ mi ];
    end
  end
  for (mi = 0; mi < C_NUM_MI_SLOTS; mi = mi + 1) begin : gen_transfer_mux
    axis_interconnect_v1_1_18_axisc_transfer_mux #(
      .C_FAMILY           ( C_FAMILY                                                ) ,
      .C_TPAYLOAD_WIDTH   ( P_TPAYLOAD_WIDTH                                        ) ,
      .C_AXIS_TDATA_WIDTH ( C_AXIS_TDATA_WIDTH                                      ) ,
      .C_AXIS_TID_WIDTH   ( C_AXIS_TID_WIDTH                                        ) ,
      .C_AXIS_TDEST_WIDTH ( C_AXIS_TDEST_WIDTH                                      ) ,
      .C_AXIS_TUSER_WIDTH ( C_AXIS_TUSER_WIDTH                                      ) ,
      .C_AXIS_SIGNAL_SET  ( C_AXIS_SIGNAL_SET                                       ) ,
      .C_USE_PACKET_MODE  ( P_USE_PACKET_MODE                                       ) ,
      .C_MAX_XFERS_PER_ARB( C_MAX_XFERS_PER_ARB                                     ) ,
      .C_NUM_CYCLES_TIMEOUT ( C_NUM_CYCLES_TIMEOUT                                  ) ,
      .C_NUM_SI_SLOTS     ( C_NUM_SI_SLOTS                                          ) ,
      .C_LOG_SI_SLOTS     ( C_LOG_SI_SLOTS                                          ) ,
      .C_REG_CONFIG       ( C_MI_REG_CONFIG                                         ) ,
      .C_CONNECTIVITY     ( C_M_AXIS_CONNECTIVITY_ARRAY[mi*C_NUM_SI_SLOTS+:C_NUM_SI_SLOTS] ) ,
      .C_SINGLE_SLAVE_CONNECTIVITY ( P_SINGLE_SLAVE_CONNECTIVITY_ARRAY[mi] )
    )
    axisc_transfer_mux_0
    (
      .ACLK            ( ACLK                                                                               ) ,
      .ACLKEN          ( ACLKEN                                                                             ) ,
      .ARESET          ( areset_r                                                                           ) ,
      .S_AXIS_TVALID   ( mux_tvalid   [mi*C_NUM_SI_SLOTS+:C_NUM_SI_SLOTS]                                   ) ,
      .S_AXIS_TREADY   ( mux_tready   [mi*C_NUM_SI_SLOTS+:C_NUM_SI_SLOTS]                                   ) ,
      .S_AXIS_TPAYLOAD ( mux_tpayload [mi*C_NUM_SI_SLOTS*P_TPAYLOAD_WIDTH+:C_NUM_SI_SLOTS*P_TPAYLOAD_WIDTH] ) ,
      .M_AXIS_TVALID   ( M_AXIS_TVALID[mi+:1]                                                               ) ,
      .M_AXIS_TREADY   ( M_AXIS_TREADY[mi+:1]                                                               ) ,
      .M_AXIS_TPAYLOAD ( tmo_tpayload [mi*P_TPAYLOAD_WIDTH+:P_TPAYLOAD_WIDTH]                               ) ,
      .ARB_GNT         ( arb_gnt_i    [mi*C_NUM_SI_SLOTS+:C_NUM_SI_SLOTS]                                   ) ,
      .ARB_DONE        ( arb_done_i   [mi+:1]                                                               ) ,
      .ARB_SEL         ( arb_sel_i    [mi*C_LOG_SI_SLOTS+:C_LOG_SI_SLOTS]                                   ) 
    );

    axis_interconnect_v1_1_18_util_vector2axis #(
      .C_TDATA_WIDTH    ( C_AXIS_TDATA_WIDTH ) ,
      .C_TID_WIDTH      ( C_AXIS_TID_WIDTH   ) ,
      .C_TDEST_WIDTH    ( C_AXIS_TDEST_WIDTH ) ,
      .C_TUSER_WIDTH    ( C_AXIS_TUSER_WIDTH ) ,
      .C_TPAYLOAD_WIDTH ( P_TPAYLOAD_WIDTH   ) ,
      .C_SIGNAL_SET     ( C_AXIS_SIGNAL_SET  ) 
    )
    util_vector2axis_0 (
      .TPAYLOAD ( tmo_tpayload[mi*P_TPAYLOAD_WIDTH+:P_TPAYLOAD_WIDTH]         ) ,
      .TDATA    ( M_AXIS_TDATA[mi*C_AXIS_TDATA_WIDTH+:C_AXIS_TDATA_WIDTH]     ) ,
      .TSTRB    ( M_AXIS_TSTRB[mi*C_AXIS_TDATA_WIDTH/8+:C_AXIS_TDATA_WIDTH/8] ) ,
      .TKEEP    ( M_AXIS_TKEEP[mi*C_AXIS_TDATA_WIDTH/8+:C_AXIS_TDATA_WIDTH/8] ) ,
      .TLAST    ( M_AXIS_TLAST[mi+:1]                                         ) ,
      .TID      ( M_AXIS_TID  [mi*C_AXIS_TID_WIDTH+:C_AXIS_TID_WIDTH]         ) ,
      .TDEST    ( M_AXIS_TDEST[mi*C_AXIS_TDEST_WIDTH+:C_AXIS_TDEST_WIDTH]     ) ,
      .TUSER    ( M_AXIS_TUSER[mi*C_AXIS_TUSER_WIDTH+:C_AXIS_TUSER_WIDTH]     ) 
    );
  end
  if (C_NUM_SI_SLOTS > 1) begin : gen_arbiter
    if (P_INTERNAL_ARBITER) begin : gen_int_arbiter
      axis_interconnect_v1_1_18_axis_switch_arbiter #(
        .C_FAMILY        ( C_FAMILY            ) ,
        .C_NUM_SI_SLOTS  ( C_NUM_SI_SLOTS      ) ,
        .C_LOG_SI_SLOTS  ( C_LOG_SI_SLOTS      ) ,
        .C_NUM_MI_SLOTS  ( C_NUM_MI_SLOTS      ) ,
        .C_ARB_ALGORITHM ( P_ARB_ALGORITHM     ) ,
        .C_SINGLE_SLAVE_CONNECTIVITY_ARRAY ( P_SINGLE_SLAVE_CONNECTIVITY_ARRAY )
      )
      axis_interconnect_v1_1_18_axis_switch_arbiter (
        .ACLK     ( ACLK       ) ,
        .ARESETN  ( ARESETN    ) ,
        .ACLKEN   ( ACLKEN     ) ,
        .ARB_REQ  ( arb_req_i  ) ,
        .ARB_DONE ( arb_done_i ) ,
        .ARB_SEL  ( arb_sel_i  ) ,
        .ARB_GNT  ( arb_gnt_i  ) 
      );
    end
    else begin : gen_ext_arbiter
      assign ARB_REQ = arb_req_i;
    /*    assign ARB_DONE = arb_done_i;*/
    /*    assign arb_sel_i = ARB_SEL;*/
      assign arb_gnt_i = ARB_GNT;
    end
  end else begin : gen_all_arb_tieoffs
    assign arb_gnt_i = arb_req_i;
    assign arb_sel_i = {C_NUM_MI_SLOTS{1'b0}};
  end


endgenerate

endmodule // axis_switch

`default_nettype wire


// (c) Copyright 2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
// axis_subset_converter
//   Converts signal sets and id/dest dwidth based on default tie off rules.
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axis_subset_converter
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_axis_subset_converter #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter         C_FAMILY           = "virtex7",
   parameter integer C_AXIS_TDATA_WIDTH = 32,
   parameter integer C_S_AXIS_TID_WIDTH   = 1,
   parameter integer C_S_AXIS_TDEST_WIDTH = 1,
   parameter integer C_AXIS_TUSER_WIDTH = 1,
   parameter [31:0]  C_S_AXIS_SIGNAL_SET  = 32'hFF, 
   // C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional signals are present
   //   [0] => TREADY present (Required)
   //   [1] => TDATA present (Required, used to calculate ratios)
   //   [2] => TSTRB present, TDATA must be present
   //   [3] => TKEEP present, TDATA must be present (Required if TLAST, TID,
   //            TDEST present
   //   [4] => TLAST present
   //   [5] => TID present
   //   [6] => TDEST present
   //   [7] => TUSER present
   parameter integer C_M_AXIS_TID_WIDTH   = 1,
   parameter integer C_M_AXIS_TDEST_WIDTH = 1,
   parameter [31:0]  C_M_AXIS_SIGNAL_SET  = 32'hFF,
   parameter integer C_DEFAULT_TLAST = 0
   )
  (
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
   // System Signals
   input wire ACLK,
   input wire ARESETN,
   input wire ACLKEN,

   // Slave side
   input  wire                              S_AXIS_TVALID,
   output wire                              S_AXIS_TREADY,
   input  wire [C_AXIS_TDATA_WIDTH-1:0]     S_AXIS_TDATA,
   input  wire [C_AXIS_TDATA_WIDTH/8-1:0]   S_AXIS_TSTRB,
   input  wire [C_AXIS_TDATA_WIDTH/8-1:0]   S_AXIS_TKEEP,
   input  wire                              S_AXIS_TLAST,
   input  wire [C_S_AXIS_TID_WIDTH-1:0]     S_AXIS_TID,
   input  wire [C_S_AXIS_TDEST_WIDTH-1:0]   S_AXIS_TDEST,
   input  wire [C_AXIS_TUSER_WIDTH-1:0]     S_AXIS_TUSER,

   // Master side
   output wire                              M_AXIS_TVALID,
   input  wire                              M_AXIS_TREADY,
   output wire [C_AXIS_TDATA_WIDTH-1:0]     M_AXIS_TDATA,
   output wire [C_AXIS_TDATA_WIDTH/8-1:0]   M_AXIS_TSTRB,
   output wire [C_AXIS_TDATA_WIDTH/8-1:0]   M_AXIS_TKEEP,
   output wire                              M_AXIS_TLAST,
   output wire [C_M_AXIS_TID_WIDTH-1:0]     M_AXIS_TID,
   output wire [C_M_AXIS_TDEST_WIDTH-1:0]   M_AXIS_TDEST,
   output wire [C_AXIS_TUSER_WIDTH-1:0]     M_AXIS_TUSER,

   // Status Signals
   output wire                              SPARSE_TKEEP_REMOVED
   // SPARSE_TKEEP_REMOVED outputs a 1 if TKEEP is being removed and 
   // a conversion process detects a TKEEP that is not all HIGH
   );

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
`include "axis_interconnect_v1_1_18.vh"

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////

// Calculate if signal is added or removed. tready is in opposite direction,
// it's meaning is reversed.
localparam [31:0] P_SIGNAL_SET_ADD = (C_S_AXIS_SIGNAL_SET ^ C_M_AXIS_SIGNAL_SET) & {C_M_AXIS_SIGNAL_SET[31:1], C_S_AXIS_SIGNAL_SET[0]};
localparam [31:0] P_SIGNAL_SET_REM = (C_S_AXIS_SIGNAL_SET ^ C_M_AXIS_SIGNAL_SET) & {C_S_AXIS_SIGNAL_SET[31:1], C_M_AXIS_SIGNAL_SET[0]};
// TODO: possible optimization calculate for C_DEFAULT_TLAST-1
localparam integer P_TLAST_CNTR_WIDTH = (C_DEFAULT_TLAST > 1) ? f_clogb2(C_DEFAULT_TLAST) : 1;
////////////////////////////////////////////////////////////////////////////////
// DRCs
////////////////////////////////////////////////////////////////////////////////
// synthesis translate_off
// synthesis translate_on
////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
wire                            default_tready;
wire [C_AXIS_TDATA_WIDTH-1:0]   default_tdata;
wire [C_AXIS_TDATA_WIDTH/8-1:0] default_tstrb;
wire [C_AXIS_TDATA_WIDTH/8-1:0] default_tkeep;
wire                            default_tlast;
wire [C_M_AXIS_TID_WIDTH-1:0]   default_tid;
wire [C_M_AXIS_TDEST_WIDTH-1:0] default_tdest;
wire [C_AXIS_TUSER_WIDTH-1:0]   default_tuser;

wire                            pulsed_tlast_i;
wire                            sparse_tkeep;
////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////
// Assign default values based on AMBA 4 AXI4-Stream Protocol Specification v1.0

// 3.1.1 Optional TREADY
assign default_tready = 1'b1;

// 3.1.5 Optional TDATA (No default value specified, assign 0)
assign default_tdata = {C_AXIS_TDATA_WIDTH{1'b0}};

// 3.1.2 Optional TKEEP and TSTRB
// assign TSTRB from M_AXIS_TKEEP if defined, else assign from S_AXIS_TKEEP if
// assigned, else assign all bits HIGH.

assign default_tstrb = C_M_AXIS_SIGNAL_SET[G_INDX_SS_TKEEP] ? M_AXIS_TKEEP :
                       C_S_AXIS_SIGNAL_SET[G_INDX_SS_TKEEP] ? S_AXIS_TKEEP :
                       {C_AXIS_TDATA_WIDTH/8{1'b1}};
// Default value of tkeep is always all bits HIGH.
assign default_tkeep = {C_AXIS_TDATA_WIDTH/8{1'b1}};

// 3.1.3 Optional TLAST 
assign default_tlast = (C_DEFAULT_TLAST == 0) ? 1'b0 : 
                       (C_DEFAULT_TLAST == 1) ? 1'b1 : 
                       pulsed_tlast_i;
generate
if (C_DEFAULT_TLAST > 1) begin : gen_pulsed_tlast_cntr
//  reg                             pulsed_tlast_r;
  wire                            pulsed_tlast_ns;
  reg  [P_TLAST_CNTR_WIDTH-1:0]   pulsed_tlast_cntr;
  wire [P_TLAST_CNTR_WIDTH-1:0]   pulsed_tlast_cntr_ns;
 
  assign pulsed_tlast_cntr_ns = pulsed_tlast_i ? {P_TLAST_CNTR_WIDTH{1'b0}} : pulsed_tlast_cntr + 1'b1;

  always @(posedge ACLK) begin
    if (~ARESETN) begin
      pulsed_tlast_cntr <= {P_TLAST_CNTR_WIDTH{1'b0}};
    end
    else if (ACLKEN) begin
      pulsed_tlast_cntr <= S_AXIS_TVALID & S_AXIS_TREADY ? pulsed_tlast_cntr_ns : pulsed_tlast_cntr;
    end
  end

  assign pulsed_tlast_i = (pulsed_tlast_cntr == (C_DEFAULT_TLAST - 1)) ? 1'b1 : 1'b0;

//  always @(posedge ACLK) begin
//    if (~ARESETN) begin
//      pulsed_tlast_r <= 1'b0;
//    end
//    else if (ACLKEN) begin
//      pulsed_tlast_r <= S_AXIS_TVALID & S_AXIS_TREADY ? pulsed_tlast_i : pulsed_tlast_r;
//    end
//  end

//  assign pulsed_tlast_i = pulsed_tlast_r;
end else begin : gen_no_pulsed_tlast_cntr
  assign pulsed_tlast_i = 1'b0;
end
endgenerate

// 3.1.4 Optional TID, TDEST, and TUSER
// * A slave with additional TID, TDEST, and TUSER inputs must have all bits
// fixed LOW.
assign default_tid = {C_M_AXIS_TID_WIDTH{1'b0}};
assign default_tdest = {C_M_AXIS_TDEST_WIDTH{1'b0}};
assign default_tuser = {C_AXIS_TUSER_WIDTH{1'b0}};

assign sparse_tkeep = M_AXIS_TVALID & M_AXIS_TREADY ? ~(&M_AXIS_TKEEP) : 1'b0;
// TVALID required and always passed through.
assign M_AXIS_TVALID = S_AXIS_TVALID; 
assign S_AXIS_TREADY = P_SIGNAL_SET_ADD[G_INDX_SS_TREADY] ? default_tready : M_AXIS_TREADY;
assign M_AXIS_TDATA  = P_SIGNAL_SET_ADD[G_INDX_SS_TDATA] ? default_tdata : S_AXIS_TDATA;
assign M_AXIS_TSTRB  = P_SIGNAL_SET_ADD[G_INDX_SS_TSTRB] ? default_tstrb : S_AXIS_TSTRB;
assign M_AXIS_TKEEP  = P_SIGNAL_SET_ADD[G_INDX_SS_TKEEP] ? default_tkeep : S_AXIS_TKEEP;
assign M_AXIS_TLAST  = P_SIGNAL_SET_ADD[G_INDX_SS_TLAST] ? default_tlast : S_AXIS_TLAST;
assign M_AXIS_TID    = P_SIGNAL_SET_ADD[G_INDX_SS_TID]   ? default_tid   : S_AXIS_TID | default_tid;
assign M_AXIS_TDEST  = P_SIGNAL_SET_ADD[G_INDX_SS_TDEST] ? default_tdest : S_AXIS_TDEST | default_tdest;
assign M_AXIS_TUSER  = P_SIGNAL_SET_ADD[G_INDX_SS_TUSER] ? default_tuser : S_AXIS_TUSER;
assign SPARSE_TKEEP_REMOVED = P_SIGNAL_SET_REM[G_INDX_SS_TKEEP] ? sparse_tkeep : 1'b0;

endmodule // axis_subset_converter

`default_nettype wire


// (c) Copyright 2010-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
// Description: 
//  Optimized Mux using MUXF7/8.
//  Any mux ratio.
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   mux_enc
//
//--------------------------------------------------------------------------
`timescale 1ps/1ps


module axis_interconnect_v1_1_18_mux_enc #
  (
   parameter         C_FAMILY                       = "rtl",
                       // FPGA Family. Current version: virtex6 or spartan6.
   parameter integer C_RATIO                        = 4,
                       // Mux select ratio. Can be any binary value (>= 1)
   parameter integer C_SEL_WIDTH                    = 2,
                       // Log2-ceiling of C_RATIO (>= 1)
   parameter integer C_DATA_WIDTH                   = 1
                       // Data width for comparator (>= 1)
   )
  (
   input  wire [C_SEL_WIDTH-1:0]                    S,
   input  wire [C_RATIO*C_DATA_WIDTH-1:0]           A,
   output wire [C_DATA_WIDTH-1:0]                   O,
   input  wire                                      OE
   );
  
  wire [C_DATA_WIDTH-1:0] o_i;
  genvar bit_cnt;
  
  function [C_DATA_WIDTH-1:0] f_mux
    (
     input [C_SEL_WIDTH-1:0] s,
     input [C_RATIO*C_DATA_WIDTH-1:0] a
     );
    integer i;
    reg [C_RATIO*C_DATA_WIDTH-1:0] carry;
    begin
      carry[C_DATA_WIDTH-1:0] = {C_DATA_WIDTH{(s==0)?1'b1:1'b0}} & a[C_DATA_WIDTH-1:0];
      for (i=1;i<C_RATIO;i=i+1) begin : gen_carrychain_enc
        carry[i*C_DATA_WIDTH +: C_DATA_WIDTH] = 
          carry[(i-1)*C_DATA_WIDTH +: C_DATA_WIDTH] |
          ({C_DATA_WIDTH{(s==i)?1'b1:1'b0}} & a[i*C_DATA_WIDTH +: C_DATA_WIDTH]);
      end
      f_mux = carry[C_DATA_WIDTH*C_RATIO-1:C_DATA_WIDTH*(C_RATIO-1)];
    end
  endfunction
  
  function [C_DATA_WIDTH-1:0] f_mux4
    (
     input [1:0] s,
     input [4*C_DATA_WIDTH-1:0] a
     );
    integer i;
    reg [4*C_DATA_WIDTH-1:0] carry;
    begin
      carry[C_DATA_WIDTH-1:0] = {C_DATA_WIDTH{(s==0)?1'b1:1'b0}} & a[C_DATA_WIDTH-1:0];
      for (i=1;i<4;i=i+1) begin : gen_carrychain_enc
        carry[i*C_DATA_WIDTH +: C_DATA_WIDTH] = 
          carry[(i-1)*C_DATA_WIDTH +: C_DATA_WIDTH] |
          ({C_DATA_WIDTH{(s==i)?1'b1:1'b0}} & a[i*C_DATA_WIDTH +: C_DATA_WIDTH]);
      end
      f_mux4 = carry[C_DATA_WIDTH*4-1:C_DATA_WIDTH*3];
    end
  endfunction
  
  assign O = o_i & {C_DATA_WIDTH{OE}};  // OE is gated AFTER any MUXF7/8 (can only optimize forward into downstream logic)
  
  generate
    if ( C_RATIO < 2 ) begin : gen_bypass
      assign o_i = A;
    end else if ( C_FAMILY == "rtl" || C_RATIO < 5 ) begin : gen_rtl
      assign o_i = f_mux(S, A);
      
    end else begin : gen_fpga
      wire [C_DATA_WIDTH-1:0] l;
      wire [C_DATA_WIDTH-1:0] h;
      wire [C_DATA_WIDTH-1:0] ll;
      wire [C_DATA_WIDTH-1:0] lh;
      wire [C_DATA_WIDTH-1:0] hl;
      wire [C_DATA_WIDTH-1:0] hh;
      
      case (C_RATIO)
        1, 5, 9, 13: 
          assign hh = A[(C_RATIO-1)*C_DATA_WIDTH +: C_DATA_WIDTH];
        2, 6, 10, 14:
          assign hh = S[0] ? 
            A[(C_RATIO-1)*C_DATA_WIDTH +: C_DATA_WIDTH] :
            A[(C_RATIO-2)*C_DATA_WIDTH +: C_DATA_WIDTH] ;
        3, 7, 11, 15:
          assign hh = S[1] ? 
            A[(C_RATIO-1)*C_DATA_WIDTH +: C_DATA_WIDTH] :
            (S[0] ? 
              A[(C_RATIO-2)*C_DATA_WIDTH +: C_DATA_WIDTH] :
              A[(C_RATIO-3)*C_DATA_WIDTH +: C_DATA_WIDTH] );
        4, 8, 12, 16:
          assign hh = S[1] ? 
            (S[0] ? 
              A[(C_RATIO-1)*C_DATA_WIDTH +: C_DATA_WIDTH] :
              A[(C_RATIO-2)*C_DATA_WIDTH +: C_DATA_WIDTH] ) :
            (S[0] ? 
              A[(C_RATIO-3)*C_DATA_WIDTH +: C_DATA_WIDTH] :
              A[(C_RATIO-4)*C_DATA_WIDTH +: C_DATA_WIDTH] );
        17:
          assign hh = S[1] ? 
            (S[0] ? 
              A[15*C_DATA_WIDTH +: C_DATA_WIDTH] :
              A[14*C_DATA_WIDTH +: C_DATA_WIDTH] ) :
            (S[0] ? 
              A[13*C_DATA_WIDTH +: C_DATA_WIDTH] :
              A[12*C_DATA_WIDTH +: C_DATA_WIDTH] );
        default:
          assign hh = 0; 
      endcase

      case (C_RATIO)
        5, 6, 7, 8: begin
          assign l = f_mux4(S[1:0], A[0 +: 4*C_DATA_WIDTH]);
          for (bit_cnt = 0; bit_cnt < C_DATA_WIDTH ; bit_cnt = bit_cnt + 1) begin : gen_mux_5_8
            MUXF7 mux_s2_inst 
            (
             .I0  (l[bit_cnt]),
             .I1  (hh[bit_cnt]),
             .S   (S[2]),
             .O   (o_i[bit_cnt])
            ); 
          end
        end
          
        9, 10, 11, 12: begin
          assign ll = f_mux4(S[1:0], A[0 +: 4*C_DATA_WIDTH]);
          assign lh = f_mux4(S[1:0], A[4*C_DATA_WIDTH +: 4*C_DATA_WIDTH]);
          for (bit_cnt = 0; bit_cnt < C_DATA_WIDTH ; bit_cnt = bit_cnt + 1) begin : gen_mux_9_12
            MUXF7 muxf_s2_low_inst 
            (
             .I0  (ll[bit_cnt]),
             .I1  (lh[bit_cnt]),
             .S   (S[2]),
             .O   (l[bit_cnt])
            ); 
            MUXF8 muxf_s3_inst 
            (
             .I0  (l[bit_cnt]),
             .I1  (hh[bit_cnt]),
             .S   (S[3]),
             .O   (o_i[bit_cnt])
            ); 
          end
        end
          
        13,14,15,16: begin
          assign ll = f_mux4(S[1:0], A[0 +: 4*C_DATA_WIDTH]);
          assign lh = f_mux4(S[1:0], A[4*C_DATA_WIDTH +: 4*C_DATA_WIDTH]);
          assign hl = f_mux4(S[1:0], A[8*C_DATA_WIDTH +: 4*C_DATA_WIDTH]);
          for (bit_cnt = 0; bit_cnt < C_DATA_WIDTH ; bit_cnt = bit_cnt + 1) begin : gen_mux_13_16
            MUXF7 muxf_s2_low_inst 
            (
             .I0  (ll[bit_cnt]),
             .I1  (lh[bit_cnt]),
             .S   (S[2]),
             .O   (l[bit_cnt])
            ); 
            MUXF7 muxf_s2_hi_inst 
            (
             .I0  (hl[bit_cnt]),
             .I1  (hh[bit_cnt]),
             .S   (S[2]),
             .O   (h[bit_cnt])
            );
          
            MUXF8 muxf_s3_inst 
            (
             .I0  (l[bit_cnt]),
             .I1  (h[bit_cnt]),
             .S   (S[3]),
             .O   (o_i[bit_cnt])
            ); 
          end
        end
          
        17: begin
          assign ll = S[4] ? A[16*C_DATA_WIDTH +: C_DATA_WIDTH] : f_mux4(S[1:0], A[0 +: 4*C_DATA_WIDTH]);  // 5-input mux
          assign lh = f_mux4(S[1:0], A[4*C_DATA_WIDTH +: 4*C_DATA_WIDTH]);
          assign hl = f_mux4(S[1:0], A[8*C_DATA_WIDTH +: 4*C_DATA_WIDTH]);
          for (bit_cnt = 0; bit_cnt < C_DATA_WIDTH ; bit_cnt = bit_cnt + 1) begin : gen_mux_17
            MUXF7 muxf_s2_low_inst 
            (
             .I0  (ll[bit_cnt]),
             .I1  (lh[bit_cnt]),
             .S   (S[2]),
             .O   (l[bit_cnt])
            ); 
            MUXF7 muxf_s2_hi_inst 
            (
             .I0  (hl[bit_cnt]),
             .I1  (hh[bit_cnt]),
             .S   (S[2]),
             .O   (h[bit_cnt])
            ); 
            MUXF8 muxf_s3_inst 
            (
             .I0  (l[bit_cnt]),
             .I1  (h[bit_cnt]),
             .S   (S[3]),
             .O   (o_i[bit_cnt])
            ); 
          end
        end
          
        default:  // If RATIO > 17, use RTL
          assign o_i = f_mux(S, A);
      endcase
    end  // gen_fpga
  endgenerate
endmodule



// (c) Copyright 2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axis_interconnect_v1_1_18_util_aclken_converter
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_util_aclken_converter # (
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
  parameter integer C_PAYLOAD_WIDTH       = 32,
  parameter integer C_S_ACLKEN_CAN_TOGGLE = 1,
  parameter integer C_M_ACLKEN_CAN_TOGGLE = 1
  )
 (
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
  // Slave side
  input  wire                        ACLK,
  input  wire                        ARESETN,

  input  wire                        S_ACLKEN,
  input  wire [C_PAYLOAD_WIDTH-1:0]  S_PAYLOAD,
  input  wire                        S_VALID,
  output wire                        S_READY,

  // Master side
  input  wire                        M_ACLKEN,
  output wire [C_PAYLOAD_WIDTH-1:0]  M_PAYLOAD,
  output wire                        M_VALID,
  input  wire                        M_READY
);

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////

// State machine states
localparam SM_NOT_READY    = 3'b000;
localparam SM_EMPTY        = 3'b001;
localparam SM_R0_NOT_READY = 3'b010;
localparam SM_R0           = 3'b011;
localparam SM_R1           = 3'b100;
localparam SM_FULL         = 3'b110;

////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
wire s_aclken_i;
wire m_aclken_i;
reg  areset;

reg [2:0] state;

// r0 is the output register
reg [C_PAYLOAD_WIDTH-1:0] r0;
wire                      load_r0;
wire                      load_r0_from_r1;

// r1 is the overflow register
reg [C_PAYLOAD_WIDTH-1:0] r1;
wire                      load_r1;
////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////

assign s_aclken_i = C_S_ACLKEN_CAN_TOGGLE ? S_ACLKEN : 1'b1;
assign m_aclken_i = C_M_ACLKEN_CAN_TOGGLE ? M_ACLKEN : 1'b1;

always @(posedge ACLK) begin 
  areset <= ~ARESETN;
end

// Valid/Ready outputs encoded into state machine.
assign S_READY = state[0];
assign M_VALID = state[1];

// State machine: Controls outputs and hold register state info
always @(posedge ACLK) begin 
  if (areset) begin
    state <= SM_NOT_READY;
  end
  else begin 
    case (state)
      // De-assert s_ready, de-assert m_valid, R0 unoccupied, R1 unoccupied
      SM_NOT_READY: begin
        if (s_aclken_i) begin
          state <= SM_EMPTY;
        end
        else begin
          state <= state;
        end
      end

      // Assert s_ready, de-assert m_valid, R0 unoccupied, R1 unoccupied
      SM_EMPTY: begin
        if (s_aclken_i & S_VALID & m_aclken_i) begin
          state <= SM_R0;
        end
        else if (s_aclken_i & S_VALID & ~m_aclken_i) begin
          state <= SM_R1;
        end
        else begin 
          state <= state;
        end
      end

      // Assert s_ready, Assert m_valid, R0 occupied, R1 unoccupied
      SM_R0: begin
        if ((m_aclken_i & M_READY) & ~(s_aclken_i & S_VALID)) begin
          state <= SM_EMPTY;
        end
        else if (~(m_aclken_i & M_READY) & (s_aclken_i & S_VALID)) begin
          state <= SM_FULL;
        end
        else begin 
          state <= state;
        end
      end

      // De-assert s_ready, Assert m_valid, R0 occupied, R1 unoccupied
      SM_R0_NOT_READY: begin
        if (s_aclken_i & m_aclken_i & M_READY) begin
          state <= SM_EMPTY;
        end
        else if (~s_aclken_i & m_aclken_i & M_READY) begin
          state <= SM_NOT_READY;
        end
        else if (s_aclken_i) begin
          state <= SM_R0;
        end
        else begin 
          state <= state;
        end
      end

      // De-assert s_ready, De-assert m_valid, R0 unoccupied, R1 occupied
      SM_R1: begin
        if (~s_aclken_i & m_aclken_i) begin
          state <= SM_R0_NOT_READY;
        end
        else if (s_aclken_i & m_aclken_i) begin 
          state <= SM_R0;
        end
        else begin 
          state <= state;
        end
      end

      // De-assert s_ready, De-assert m_valid, R0 occupied, R1 occupied
      SM_FULL: begin
        if (~s_aclken_i & m_aclken_i & M_READY) begin
          state <= SM_R0_NOT_READY;
        end
        else if (s_aclken_i & m_aclken_i & M_READY) begin 
          state <= SM_R0;
        end
        else begin 
          state <= state;
        end
      end

      default: begin
        state <= SM_NOT_READY;
      end
    endcase
  end
end

assign M_PAYLOAD = r0;

always @(posedge ACLK) begin
  if (m_aclken_i) begin 
    r0 <= ~load_r0 ? r0 :
          load_r0_from_r1 ? r1 :
          S_PAYLOAD ;
  end
end

assign load_r0 = (state == SM_EMPTY) 
                 | (state == SM_R1) 
                 | ((state == SM_R0) & M_READY)
                 | ((state == SM_FULL) & M_READY);

assign load_r0_from_r1 = (state == SM_R1) | (state == SM_FULL);

always @(posedge ACLK) begin
  r1 <= ~load_r1 ? r1 : S_PAYLOAD;
end

assign load_r1 = (state == SM_EMPTY) | (state == SM_R0);


endmodule // axis_interconnect_v1_1_18_util_aclken_converter

`default_nettype wire


// (c) Copyright 2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axis_interconnect_v1_1_18_util_aclken_converter_wrapper
//     axis_interconnect_v1_1_18_util_axis2vector
//     axis_interconnect_v1_1_18_util_aclken_converter
//     axis_interconnect_v1_1_18_util_vector2axis 
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_util_aclken_converter_wrapper # (
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
  parameter integer C_TDATA_WIDTH = 32,
  parameter integer C_TID_WIDTH   = 1,
  parameter integer C_TDEST_WIDTH = 1,
  parameter integer C_TUSER_WIDTH = 1,
  parameter [31:0]  C_SIGNAL_SET  = 32'hFF,
  // C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional signals are present
  //   [0] => TREADY present
  //   [1] => TDATA present
  //   [2] => TSTRB present, TDATA must be present
  //   [3] => TKEEP present, TDATA must be present
  //   [4] => TLAST present
  //   [5] => TID present
  //   [6] => TDEST present
  //   [7] => TUSER present
  parameter integer C_S_ACLKEN_CAN_TOGGLE = 1,
  parameter integer C_M_ACLKEN_CAN_TOGGLE = 1
  )
 (
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
  // Slave side
  input  wire                       ACLK,
  input  wire                       ARESETN,
  input  wire                       S_ACLKEN,
  input  wire                       S_VALID,
  output wire                       S_READY,
  input  wire [C_TDATA_WIDTH-1:0]   S_TDATA,
  input  wire [C_TDATA_WIDTH/8-1:0] S_TSTRB,
  input  wire [C_TDATA_WIDTH/8-1:0] S_TKEEP,
  input  wire                       S_TLAST,
  input  wire [C_TID_WIDTH-1:0]     S_TID,
  input  wire [C_TDEST_WIDTH-1:0]   S_TDEST,
  input  wire [C_TUSER_WIDTH-1:0]   S_TUSER,
                                    
  input  wire                       M_ACLKEN,
  output wire                       M_VALID,
  input  wire                       M_READY,
  output wire [C_TDATA_WIDTH-1:0]   M_TDATA,
  output wire [C_TDATA_WIDTH/8-1:0] M_TSTRB,
  output wire [C_TDATA_WIDTH/8-1:0] M_TKEEP,
  output wire                       M_TLAST,
  output wire [C_TID_WIDTH-1:0]     M_TID,
  output wire [C_TDEST_WIDTH-1:0]   M_TDEST,
  output wire [C_TUSER_WIDTH-1:0]   M_TUSER
);

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
`include "axis_interconnect_v1_1_18.vh"


////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////

localparam integer P_TPAYLOAD_WIDTH       = f_payload_width(C_TDATA_WIDTH, C_TID_WIDTH, 
                                                 C_TDEST_WIDTH, C_TUSER_WIDTH, 
                                                 C_SIGNAL_SET);
////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
wire [P_TPAYLOAD_WIDTH-1:0] s_tpayload;
wire [P_TPAYLOAD_WIDTH-1:0] m_tpayload;

////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////

axis_interconnect_v1_1_18_util_axis2vector #(
  .C_TDATA_WIDTH    ( C_TDATA_WIDTH ) ,
  .C_TID_WIDTH      ( C_TID_WIDTH   ) ,
  .C_TDEST_WIDTH    ( C_TDEST_WIDTH ) ,
  .C_TUSER_WIDTH    ( C_TUSER_WIDTH ) ,
  .C_TPAYLOAD_WIDTH ( P_TPAYLOAD_WIDTH   ) ,
  .C_SIGNAL_SET     ( C_SIGNAL_SET  ) 
)
util_axis2vector_0 (
  .TDATA    ( S_TDATA    ) ,
  .TSTRB    ( S_TSTRB    ) ,
  .TKEEP    ( S_TKEEP    ) ,
  .TLAST    ( S_TLAST    ) ,
  .TID      ( S_TID      ) ,
  .TDEST    ( S_TDEST    ) ,
  .TUSER    ( S_TUSER    ) ,
  .TPAYLOAD ( s_tpayload )
);

generate
if (C_S_ACLKEN_CAN_TOGGLE | C_M_ACLKEN_CAN_TOGGLE) begin : gen_aclken_converter
  axis_interconnect_v1_1_18_util_aclken_converter #( 
    .C_PAYLOAD_WIDTH       ( P_TPAYLOAD_WIDTH       ) ,
    .C_S_ACLKEN_CAN_TOGGLE ( C_S_ACLKEN_CAN_TOGGLE ) ,
    .C_M_ACLKEN_CAN_TOGGLE ( C_M_ACLKEN_CAN_TOGGLE ) 
  )
  s_util_aclken_converter_0 ( 
    .ACLK      ( ACLK       ) ,
    .ARESETN   ( ARESETN    ) ,
    .S_ACLKEN  ( S_ACLKEN   ) ,
    .S_PAYLOAD ( s_tpayload ) ,
    .S_VALID   ( S_VALID   ) ,
    .S_READY   ( S_READY   ) ,
    .M_ACLKEN  ( M_ACLKEN   ) ,
    .M_PAYLOAD ( m_tpayload ) ,
    .M_VALID   ( M_VALID   ) ,
    .M_READY   ( M_READY   ) 
  );
end
else begin : gen_aclken_passthru
  assign m_tpayload = s_tpayload;
  assign M_VALID   = S_VALID;
  assign S_READY = M_READY;
end
endgenerate

axis_interconnect_v1_1_18_util_vector2axis #(
  .C_TDATA_WIDTH    ( C_TDATA_WIDTH ) ,
  .C_TID_WIDTH      ( C_TID_WIDTH   ) ,
  .C_TDEST_WIDTH    ( C_TDEST_WIDTH ) ,
  .C_TUSER_WIDTH    ( C_TUSER_WIDTH ) ,
  .C_TPAYLOAD_WIDTH ( P_TPAYLOAD_WIDTH   ) ,
  .C_SIGNAL_SET     ( C_SIGNAL_SET  ) 
)
util_vector2axis_0 (
  .TPAYLOAD ( m_tpayload ) ,
  .TDATA    ( M_TDATA    ) ,
  .TSTRB    ( M_TSTRB    ) ,
  .TKEEP    ( M_TKEEP    ) ,
  .TLAST    ( M_TLAST    ) ,
  .TID      ( M_TID      ) ,
  .TDEST    ( M_TDEST    ) ,
  .TUSER    ( M_TUSER    ) 
);

endmodule // axis_interconnect_v1_1_18_util_aclken_converter_wrapper

`default_nettype wire


// (c) Copyright 2011-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
// axis to vector
//   A generic module to merge all axis 'data' signals into one signal called payload.
//   This is strictly wires, so no clk, reset, aclken, valid/ready are required.
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axis_interconnect_v1_1_18_util_axis2vector
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_util_axis2vector #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter integer C_TDATA_WIDTH = 32,
   parameter integer C_TID_WIDTH   = 1,
   parameter integer C_TDEST_WIDTH = 1,
   parameter integer C_TUSER_WIDTH = 1,
   parameter integer C_TPAYLOAD_WIDTH = 44,
   parameter [31:0]  C_SIGNAL_SET  = 32'hFF
   // C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional signals are present
   //   [0] => TREADY present
   //   [1] => TDATA present
   //   [2] => TSTRB present, TDATA must be present
   //   [3] => TKEEP present, TDATA must be present
   //   [4] => TLAST present
   //   [5] => TID present
   //   [6] => TDEST present
   //   [7] => TUSER present
   )
  (
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
   // inputs
   input  wire [C_TDATA_WIDTH-1:0]   TDATA,
   input  wire [C_TDATA_WIDTH/8-1:0] TSTRB,
   input  wire [C_TDATA_WIDTH/8-1:0] TKEEP,
   input  wire                       TLAST,
   input  wire [C_TID_WIDTH-1:0]     TID,
   input  wire [C_TDEST_WIDTH-1:0]   TDEST,
   input  wire [C_TUSER_WIDTH-1:0]   TUSER,

   // outputs
   output wire [C_TPAYLOAD_WIDTH-1:0] TPAYLOAD
   );

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
`include "axis_interconnect_v1_1_18.vh"

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
localparam P_TDATA_INDX = f_get_tdata_indx(C_TDATA_WIDTH, C_TID_WIDTH,
                                           C_TDEST_WIDTH, C_TUSER_WIDTH, 
                                           C_SIGNAL_SET);
localparam P_TSTRB_INDX = f_get_tstrb_indx(C_TDATA_WIDTH, C_TID_WIDTH,
                                           C_TDEST_WIDTH, C_TUSER_WIDTH, 
                                           C_SIGNAL_SET);
localparam P_TKEEP_INDX = f_get_tkeep_indx(C_TDATA_WIDTH, C_TID_WIDTH,
                                           C_TDEST_WIDTH, C_TUSER_WIDTH, 
                                           C_SIGNAL_SET);
localparam P_TLAST_INDX = f_get_tlast_indx(C_TDATA_WIDTH, C_TID_WIDTH,
                                           C_TDEST_WIDTH, C_TUSER_WIDTH, 
                                           C_SIGNAL_SET);
localparam P_TID_INDX   = f_get_tid_indx  (C_TDATA_WIDTH, C_TID_WIDTH,
                                           C_TDEST_WIDTH, C_TUSER_WIDTH, 
                                           C_SIGNAL_SET);
localparam P_TDEST_INDX = f_get_tdest_indx(C_TDATA_WIDTH, C_TID_WIDTH,
                                           C_TDEST_WIDTH, C_TUSER_WIDTH, 
                                           C_SIGNAL_SET);
localparam P_TUSER_INDX = f_get_tuser_indx(C_TDATA_WIDTH, C_TID_WIDTH,
                                           C_TDEST_WIDTH, C_TUSER_WIDTH, 
                                           C_SIGNAL_SET);
////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////
generate
  if (C_SIGNAL_SET[G_INDX_SS_TDATA]) begin : gen_tdata
    assign TPAYLOAD[P_TDATA_INDX+:C_TDATA_WIDTH]   = TDATA;
  end
  if (C_SIGNAL_SET[G_INDX_SS_TSTRB]) begin : gen_tstrb
    assign TPAYLOAD[P_TSTRB_INDX+:C_TDATA_WIDTH/8] = TSTRB;
  end
  if (C_SIGNAL_SET[G_INDX_SS_TKEEP]) begin : gen_tkeep
    assign TPAYLOAD[P_TKEEP_INDX+:C_TDATA_WIDTH/8] = TKEEP;
  end
  if (C_SIGNAL_SET[G_INDX_SS_TLAST]) begin : gen_tlast
    assign TPAYLOAD[P_TLAST_INDX+:1]               = TLAST;
  end
  if (C_SIGNAL_SET[G_INDX_SS_TID]) begin : gen_tid
    assign TPAYLOAD[P_TID_INDX+:C_TID_WIDTH]       = TID;
  end
  if (C_SIGNAL_SET[G_INDX_SS_TDEST]) begin : gen_tdest
    assign TPAYLOAD[P_TDEST_INDX+:C_TDEST_WIDTH]   = TDEST;
  end
  if (C_SIGNAL_SET[G_INDX_SS_TUSER]) begin : gen_tuser
    assign TPAYLOAD[P_TUSER_INDX+:C_TUSER_WIDTH]   = TUSER;
  end
endgenerate
endmodule 

`default_nettype wire


// (c) Copyright 2011-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
// axis to vector
//   A generic module to unmerge all axis 'data' signals from payload.
//   This is strictly wires, so no clk, reset, aclken, valid/ready are required.
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axis_interconnect_v1_1_18_util_vector2axis
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_util_vector2axis #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter integer C_TDATA_WIDTH = 32,
   parameter integer C_TID_WIDTH   = 1,
   parameter integer C_TDEST_WIDTH = 1,
   parameter integer C_TUSER_WIDTH = 1,
   parameter integer C_TPAYLOAD_WIDTH = 44,
   parameter [31:0]  C_SIGNAL_SET  = 32'hFF
   // C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional signals are present
   //   [0] => TREADY present
   //   [1] => TDATA present
   //   [2] => TSTRB present, TDATA must be present
   //   [3] => TKEEP present, TDATA must be present
   //   [4] => TLAST present
   //   [5] => TID present
   //   [6] => TDEST present
   //   [7] => TUSER present
   )
  (
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
   // outputs
   input  wire [C_TPAYLOAD_WIDTH-1:0] TPAYLOAD,

   // inputs
   output wire [C_TDATA_WIDTH-1:0]   TDATA,
   output wire [C_TDATA_WIDTH/8-1:0] TSTRB,
   output wire [C_TDATA_WIDTH/8-1:0] TKEEP,
   output wire                       TLAST,
   output wire [C_TID_WIDTH-1:0]     TID,
   output wire [C_TDEST_WIDTH-1:0]   TDEST,
   output wire [C_TUSER_WIDTH-1:0]   TUSER
   );

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
`include "axis_interconnect_v1_1_18.vh"

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
localparam P_TDATA_INDX = f_get_tdata_indx(C_TDATA_WIDTH, C_TID_WIDTH,
                                           C_TDEST_WIDTH, C_TUSER_WIDTH, 
                                           C_SIGNAL_SET);
localparam P_TSTRB_INDX = f_get_tstrb_indx(C_TDATA_WIDTH, C_TID_WIDTH,
                                           C_TDEST_WIDTH, C_TUSER_WIDTH, 
                                           C_SIGNAL_SET);
localparam P_TKEEP_INDX = f_get_tkeep_indx(C_TDATA_WIDTH, C_TID_WIDTH,
                                           C_TDEST_WIDTH, C_TUSER_WIDTH, 
                                           C_SIGNAL_SET);
localparam P_TLAST_INDX = f_get_tlast_indx(C_TDATA_WIDTH, C_TID_WIDTH,
                                           C_TDEST_WIDTH, C_TUSER_WIDTH, 
                                           C_SIGNAL_SET);
localparam P_TID_INDX   = f_get_tid_indx  (C_TDATA_WIDTH, C_TID_WIDTH,
                                           C_TDEST_WIDTH, C_TUSER_WIDTH, 
                                           C_SIGNAL_SET);
localparam P_TDEST_INDX = f_get_tdest_indx(C_TDATA_WIDTH, C_TID_WIDTH,
                                           C_TDEST_WIDTH, C_TUSER_WIDTH, 
                                           C_SIGNAL_SET);
localparam P_TUSER_INDX = f_get_tuser_indx(C_TDATA_WIDTH, C_TID_WIDTH,
                                           C_TDEST_WIDTH, C_TUSER_WIDTH, 
                                           C_SIGNAL_SET);
////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////
generate
  if (C_SIGNAL_SET[G_INDX_SS_TDATA]) begin : gen_tdata
    assign TDATA = TPAYLOAD[P_TDATA_INDX+:C_TDATA_WIDTH]  ;
  end
  if (C_SIGNAL_SET[G_INDX_SS_TSTRB]) begin : gen_tstrb
    assign TSTRB = TPAYLOAD[P_TSTRB_INDX+:C_TDATA_WIDTH/8];
  end
  if (C_SIGNAL_SET[G_INDX_SS_TKEEP]) begin : gen_tkeep
    assign TKEEP = TPAYLOAD[P_TKEEP_INDX+:C_TDATA_WIDTH/8];
  end
  if (C_SIGNAL_SET[G_INDX_SS_TLAST]) begin : gen_tlast
    assign TLAST = TPAYLOAD[P_TLAST_INDX+:1]              ;
  end
  if (C_SIGNAL_SET[G_INDX_SS_TID]) begin : gen_tid
    assign TID   = TPAYLOAD[P_TID_INDX+:C_TID_WIDTH]      ;
  end
  if (C_SIGNAL_SET[G_INDX_SS_TDEST]) begin : gen_tdest
    assign TDEST = TPAYLOAD[P_TDEST_INDX+:C_TDEST_WIDTH]  ;
  end
  if (C_SIGNAL_SET[G_INDX_SS_TUSER]) begin : gen_tuser
    assign TUSER = TPAYLOAD[P_TUSER_INDX+:C_TUSER_WIDTH]  ;
  end
endgenerate
endmodule 

`default_nettype wire


// (c) Copyright 2010-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
// Register Slice
//   Generic single-channel AXI pipeline register on forward and/or reverse signal path
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axic_register_slice
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps

module axis_interconnect_v1_1_18_axisc_register_slice #
  (
   parameter C_FAMILY     = "virtex6",
   parameter C_DATA_WIDTH = 32,
   parameter C_REG_CONFIG = 32'h00000000
   // C_REG_CONFIG:
   //   0 => BYPASS    = The channel is just wired through the module.
   //   1 => FWD_REV   = Both FWD and REV (fully-registered)
   //   2 => FWD       = The master VALID and payload signals are registrated. 
   //   3 => REV       = The slave ready signal is registrated
   //   4 => RESERVED (all outputs driven to 0).
   //   5 => RESERVED (all outputs driven to 0).
   //   6 => INPUTS    = Slave and Master side inputs are registrated.
   //   7 => LIGHT_WT  = 1-stage pipeline register with bubble cycle, both FWD and REV pipelining
   )
  (
   // System Signals
   input wire ACLK,
   input wire ARESET,
   input wire ACLKEN,

   // Slave side
   input  wire [C_DATA_WIDTH-1:0] S_PAYLOAD_DATA,
   input  wire S_VALID,
   output wire S_READY,

   // Master side
   output  wire [C_DATA_WIDTH-1:0] M_PAYLOAD_DATA,
   output wire M_VALID,
   input  wire M_READY
   );

  (* use_clock_enable = "yes" *)

  generate
  ////////////////////////////////////////////////////////////////////
  //
  // C_REG_CONFIG = 0
  // Bypass mode
  //
  ////////////////////////////////////////////////////////////////////
    if (C_REG_CONFIG == 32'h00000000)
    begin
      assign M_PAYLOAD_DATA = S_PAYLOAD_DATA;
      assign M_VALID        = S_VALID;
      assign S_READY        = M_READY;      
    end
  ////////////////////////////////////////////////////////////////////
  //
  // C_REG_CONFIG = 1 (or 8)
  // Both FWD and REV mode
  //
  ////////////////////////////////////////////////////////////////////
    else if ((C_REG_CONFIG == 32'h00000001) || (C_REG_CONFIG == 32'h00000008))
    begin
      reg [1:0] state;
      localparam [1:0] 
        ZERO = 2'b10,
        ONE  = 2'b11,
        TWO  = 2'b01;
      
      reg [C_DATA_WIDTH-1:0] storage_data1;
      reg [C_DATA_WIDTH-1:0] storage_data2;
      reg                    load_s1;
      wire                   load_s2;
      wire                   load_s1_from_s2;
      reg                    s_ready_i; //local signal of output
      wire                   m_valid_i; //local signal of output

      // assign local signal to its output signal
      assign S_READY = s_ready_i;
      assign M_VALID = m_valid_i;

      (* equivalent_register_removal = "no" *) reg [1:0] areset_d; // Reset delay register
      always @(posedge ACLK) begin
        if (ACLKEN) begin
          areset_d <= {areset_d[0], ARESET};
        end
      end
      
      // Load storage1 with either slave side data or from storage2
      always @(posedge ACLK) 
      begin
        if (ACLKEN) begin
          storage_data1 <= ~load_s1 ? storage_data1 : 
                           load_s1_from_s2 ? storage_data2 : 
                           S_PAYLOAD_DATA; 
        end
      end

      // Load storage2 with slave side data
      always @(posedge ACLK) 
      begin
        if (ACLKEN) begin
          storage_data2 <= load_s2 ? S_PAYLOAD_DATA : storage_data2;
        end
      end

      assign M_PAYLOAD_DATA = storage_data1;

      // Always load s2 on a valid transaction even if it's unnecessary
      assign load_s2 = S_VALID & s_ready_i;

      // Loading s1
      always @ *
      begin
        if ( ((state == ZERO) && (S_VALID == 1)) || // Load when empty on slave transaction
             // Load when ONE if we both have read and write at the same time
             ((state == ONE) && (S_VALID == 1) && (M_READY == 1)) ||
             // Load when TWO and we have a transaction on Master side
             ((state == TWO) && (M_READY == 1)))
          load_s1 = 1'b1;
        else
          load_s1 = 1'b0;
      end // always @ *

      assign load_s1_from_s2 = (state == TWO);
                       
      // State Machine for handling output signals
      always @(posedge ACLK) begin
        if (ARESET) begin
          s_ready_i <= 1'b0;
          state <= ZERO;
        end else if (ACLKEN && areset_d == 2'b10) begin
          s_ready_i <= 1'b1;
          state <= ZERO;
        end else if (ACLKEN && areset_d == 2'b00) begin
          case (state)
            // No transaction stored locally
            ZERO: if (S_VALID) state <= ONE; // Got one so move to ONE

            // One transaction stored locally
            ONE: begin
              if (M_READY & ~S_VALID) state <= ZERO; // Read out one so move to ZERO
              if (~M_READY & S_VALID) begin
                state <= TWO;  // Got another one so move to TWO
                s_ready_i <= 1'b0;
              end
            end

            // TWO transaction stored locally
            TWO: if (M_READY) begin
              state <= ONE; // Read out one so move to ONE
              s_ready_i <= 1'b1;
            end
          endcase // case (state)
        end
      end // always @ (posedge ACLK)
      
      assign m_valid_i = state[0];

    end // if (C_REG_CONFIG == 1)
    
  ////////////////////////////////////////////////////////////////////
  //
  // C_REG_CONFIG = 2
  // Only FWD mode
  //
  ////////////////////////////////////////////////////////////////////
    else if (C_REG_CONFIG == 32'h00000002)
    begin
      reg [C_DATA_WIDTH-1:0] storage_data;
      wire                   s_ready_i; //local signal of output
      reg                    m_valid_i; //local signal of output

      // assign local signal to its output signal
      assign S_READY = s_ready_i;
      assign M_VALID = m_valid_i;

      (* equivalent_register_removal = "no" *) reg [1:0] areset_d; // Reset delay register
      always @(posedge ACLK) begin
        if (ACLKEN) begin
          areset_d <= {areset_d[0], ARESET};
        end
      end
      
      // Save payload data whenever we have a transaction on the slave side
      always @(posedge ACLK) 
      begin
        if (ACLKEN)
          storage_data <= (S_VALID & s_ready_i) ? S_PAYLOAD_DATA : storage_data;
      end

      assign M_PAYLOAD_DATA = storage_data;
      
      // M_Valid set to high when we have a completed transfer on slave side
      // Is removed on a M_READY except if we have a new transfer on the slave side
      always @(posedge ACLK) begin
        if (areset_d) begin
          m_valid_i <= 1'b0;
        end 
        else if (ACLKEN) begin
            m_valid_i <= S_VALID ? 1'b1 :  // Always set m_valid_i when slave side is valid
                       M_READY ? 1'b0 :  // Clear (or keep) when no slave side is valid but master side is ready
                         m_valid_i;
        end
      end // always @ (posedge ACLK)
      
      // Slave Ready is either when Master side drives M_Ready or we have space in our storage data
      assign s_ready_i = (M_READY | ~m_valid_i) & ~|areset_d;

    end // if (C_REG_CONFIG == 2)
  ////////////////////////////////////////////////////////////////////
  //
  // C_REG_CONFIG = 3
  // Only REV mode
  //
  ////////////////////////////////////////////////////////////////////
    else if (C_REG_CONFIG == 32'h00000003)
    begin
      reg [C_DATA_WIDTH-1:0] storage_data;
      reg                    s_ready_i; //local signal of output
      reg                    has_valid_storage_i;
      reg                    has_valid_storage;

      (* equivalent_register_removal = "no" *) reg areset_d; // Reset delay register
      always @(posedge ACLK) begin
        if (ACLKEN) begin
          areset_d <= ARESET;
        end
      end
      
      // Save payload data whenever we have a transaction on the slave side
      always @(posedge ACLK) 
      begin
        if (ACLKEN)
          storage_data <= (S_VALID & s_ready_i) ? S_PAYLOAD_DATA : storage_data;
      end

      assign M_PAYLOAD_DATA = has_valid_storage ? storage_data : S_PAYLOAD_DATA;

      // Need to determine when we need to save a payload
      // Need a combinatorial signals since it will also effect S_READY
      always @ *
      begin
        // Set the value if we have a slave transaction but master side is not ready
        if (S_VALID & s_ready_i & ~M_READY)
          has_valid_storage_i = 1'b1;
        
        // Clear the value if it's set and Master side completes the transaction but we don't have a new slave side 
        // transaction 
        else if ( (has_valid_storage == 1) && (M_READY == 1) && ( (S_VALID == 0) || (s_ready_i == 0)))
          has_valid_storage_i = 1'b0;
        else
          has_valid_storage_i = has_valid_storage;
      end // always @ *

      always @(posedge ACLK) 
      begin
        if (ARESET) begin
          has_valid_storage <= 1'b0;
        end
        else if (ACLKEN) begin
          has_valid_storage <= has_valid_storage_i;
        end
      end

      // S_READY is either clocked M_READY or that we have room in local storage
      always @(posedge ACLK) begin
        if (ARESET) begin
          s_ready_i <= 1'b0;
        end
        else if (ACLKEN) begin
          s_ready_i <= M_READY | ~has_valid_storage_i;
        end
      end

      // assign local signal to its output signal
      assign S_READY = s_ready_i;

      // M_READY is either combinatorial S_READY or that we have valid data in local storage
      assign M_VALID = (S_VALID | has_valid_storage) & ~areset_d;
      
    end // if (C_REG_CONFIG == 3)
    
  ////////////////////////////////////////////////////////////////////
  //
  // C_REG_CONFIG = 4 or 5 is NO LONGER SUPPORTED
  //
  ////////////////////////////////////////////////////////////////////
    else if ((C_REG_CONFIG == 32'h00000004) || (C_REG_CONFIG == 32'h00000005))
    begin
// synthesis translate_off
      initial begin  
        $display ("ERROR: For axi_register_slice, C_REG_CONFIG = 4 or 5 is RESERVED.");
      end
// synthesis translate_on
      assign M_PAYLOAD_DATA = 0;
      assign M_VALID        = 1'b0;
      assign S_READY        = 1'b0;    
    end  

  ////////////////////////////////////////////////////////////////////
  //
  // C_REG_CONFIG = 6
  // INPUTS mode
  //
  ////////////////////////////////////////////////////////////////////
    else if (C_REG_CONFIG == 32'h00000006)
    begin
      reg [1:0] state;
      reg [1:0] next_state;
      localparam [1:0] 
        ZERO = 2'b00,
        ONE  = 2'b01,
        TWO  = 2'b11;

      reg [C_DATA_WIDTH-1:0] storage_data1;
      reg [C_DATA_WIDTH-1:0] storage_data2;
      reg                    s_valid_d;
      reg                    s_ready_d;
      reg                    m_ready_d;
      reg                    m_valid_d;
      reg                    load_s2;
      reg                    sel_s2;
      wire                   new_access;
      wire                   access_done;
      wire                   s_ready_i; //local signal of output
      reg                    s_ready_ii;
      reg                    m_valid_i; //local signal of output
      
      (* equivalent_register_removal = "no" *) reg areset_d; // Reset delay register
      always @(posedge ACLK) begin
        if (ACLKEN) begin
          areset_d <= ARESET;
        end
      end
      
      // assign local signal to its output signal
      assign S_READY = s_ready_i;
      assign M_VALID = m_valid_i;
      assign s_ready_i = s_ready_ii & ~areset_d;

      // Registrate input control signals
      always @(posedge ACLK) 
      begin
        if (ARESET) begin          
          s_valid_d <= 1'b0;
          s_ready_d <= 1'b0;
          m_ready_d <= 1'b0;
        end else if (ACLKEN) begin
          s_valid_d <= S_VALID;
          s_ready_d <= s_ready_i;
          m_ready_d <= M_READY;
        end
      end // always @ (posedge ACLK)

      // Load storage1 with slave side payload data when slave side ready is high
      always @(posedge ACLK) 
      begin
        if (ACLKEN)
          storage_data1 <= (s_ready_i) ? S_PAYLOAD_DATA : storage_data1;          
      end

      // Load storage2 with storage data 
      always @(posedge ACLK) 
      begin
        if (ACLKEN)
          storage_data2 <= load_s2 ? storage_data1 : storage_data2;
      end

      always @(posedge ACLK) 
      begin
        if (ARESET) 
          m_valid_d <= 1'b0;
        else if (ACLKEN)
          m_valid_d <= m_valid_i;
      end

      // Local help signals
      assign new_access  = s_ready_d & s_valid_d;
      assign access_done = m_ready_d & m_valid_d;


      // State Machine for handling output signals
      always @*
      begin
        next_state = state; // Stay in the same state unless we need to move to another state
        load_s2   = 0;
        sel_s2    = 0;
        m_valid_i = 0;
        s_ready_ii = 0;
        case (state)
            // No transaction stored locally
            ZERO: begin
              load_s2   = 0;
              sel_s2    = 0;
              m_valid_i = 0;
              s_ready_ii = 1;
              if (new_access) begin
                next_state = ONE; // Got one so move to ONE
                load_s2   = 1;
                m_valid_i = 0;
              end
              else begin
                next_state = next_state;
                load_s2   = load_s2;
                m_valid_i = m_valid_i;
              end

            end // case: ZERO

            // One transaction stored locally
            ONE: begin
              load_s2   = 0;
              sel_s2    = 1;
              m_valid_i = 1;
              s_ready_ii = 1;
              if (~new_access & access_done) begin
                next_state = ZERO; // Read out one so move to ZERO
                m_valid_i = 0;                      
              end
              else if (new_access & ~access_done) begin
                next_state = TWO;  // Got another one so move to TWO
                s_ready_ii = 0;
              end
              else if (new_access & access_done) begin
                load_s2   = 1;
                sel_s2    = 0;
              end
              else begin
                load_s2   = load_s2;
                sel_s2    = sel_s2;
              end


            end // case: ONE

            // TWO transaction stored locally
            TWO: begin
              load_s2   = 0;
              sel_s2    = 1;
              m_valid_i = 1;
              s_ready_ii = 0;
              if (access_done) begin 
                next_state = ONE; // Read out one so move to ONE
                s_ready_ii  = 1;
                load_s2    = 1;
                sel_s2     = 0;
              end
              else begin
                next_state = next_state;
                s_ready_ii  = s_ready_ii;
                load_s2    = load_s2;
                sel_s2     = sel_s2;
              end
            end // case: TWO
        endcase // case (state)
      end // always @ *


      // State Machine for handling output signals
      always @(posedge ACLK) 
      begin
        if (ARESET) 
          state <= ZERO;
        else if (ACLKEN)
          state <= next_state; // Stay in the same state unless we need to move to another state
      end
      
      // Master Payload mux
      assign M_PAYLOAD_DATA = sel_s2?storage_data2:storage_data1;

    end // if (C_REG_CONFIG == 6)
  ////////////////////////////////////////////////////////////////////
  //
  // C_REG_CONFIG = 7
  // Light-weight mode.
  // 1-stage pipeline register with bubble cycle, both FWD and REV pipelining
  // Operates same as 1-deep FIFO
  //
  ////////////////////////////////////////////////////////////////////
    else if (C_REG_CONFIG == 32'h00000007)
    begin
      reg [C_DATA_WIDTH-1:0] storage_data1;
      reg                    s_ready_i; //local signal of output
      reg                    m_valid_i; //local signal of output

      // assign local signal to its output signal
      assign S_READY = s_ready_i;
      assign M_VALID = m_valid_i;

      (* equivalent_register_removal = "no" *) reg [1:0] areset_d; // Reset delay register
      always @(posedge ACLK) begin
        if (ACLKEN) begin
          areset_d <= {areset_d[0], ARESET};
        end
      end
      
      // Load storage1 with slave side data
      always @(posedge ACLK) 
      begin
        if (ARESET) begin
          s_ready_i <= 1'b0;
          m_valid_i <= 1'b0;
        end else if (ACLKEN && areset_d == 2'b10) begin
          s_ready_i <= 1'b1;
        end else if (ACLKEN && areset_d == 2'b00) begin
          if (m_valid_i & M_READY) begin
            s_ready_i <= 1'b1;
            m_valid_i <= 1'b0;
          end else if (S_VALID & s_ready_i) begin
            s_ready_i <= 1'b0;
            m_valid_i <= 1'b1;
          end
        end
        if (~m_valid_i) begin
          storage_data1 <= S_PAYLOAD_DATA;        
        end
      end
      assign M_PAYLOAD_DATA = storage_data1;
    end // if (C_REG_CONFIG == 7)
    
    else begin : default_case
      // Passthrough
      assign M_PAYLOAD_DATA = S_PAYLOAD_DATA;
      assign M_VALID        = S_VALID;
      assign S_READY        = M_READY;      
    end

  endgenerate
endmodule // axisc_register_slice


// (c) Copyright 2011-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
// Register Slice
//   Generic single-channel AXIS pipeline register on forward and/or reverse signal path.
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axis_register_slice
//     util_axis2vector
//     axisc_register_slice
//     util_vector2axis
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_axis_register_slice #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter         C_FAMILY           = "virtex6",
   parameter integer C_AXIS_TDATA_WIDTH = 32,
   parameter integer C_AXIS_TID_WIDTH   = 1,
   parameter integer C_AXIS_TDEST_WIDTH = 1,
   parameter integer C_AXIS_TUSER_WIDTH = 1,
   parameter [31:0]  C_AXIS_SIGNAL_SET  = 32'hFF,
   // C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional signals are present
   //   [0] => TREADY present
   //   [1] => TDATA present
   //   [2] => TSTRB present, TDATA must be present
   //   [3] => TKEEP present, TDATA must be present
   //   [4] => TLAST present
   //   [5] => TID present
   //   [6] => TDEST present
   //   [7] => TUSER present
   parameter integer C_REG_CONFIG       = 0
   // C_REG_CONFIG:
   //   0 => BYPASS    = The channel is just wired through the module.
   //   1 => FWD_REV   = Both FWD and REV (fully-registered)
   //   2 => FWD       = The master VALID and payload signals are registrated. 
   //   3 => REV       = The slave ready signal is registrated
   //   4 => RESERVED (all outputs driven to 0).
   //   5 => RESERVED (all outputs driven to 0).
   //   6 => INPUTS    = Slave and Master side inputs are registrated.
   //   7 => LIGHT_WT  = 1-stage pipeline register with bubble cycle, both FWD and REV pipelining
   )
  (
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
   // System Signals
   input wire ACLK,
   input wire ARESETN,
   input wire ACLKEN,

   // Slave side
   input  wire                            S_AXIS_TVALID,
   output wire                            S_AXIS_TREADY,
   input  wire [C_AXIS_TDATA_WIDTH-1:0]   S_AXIS_TDATA,
   input  wire [C_AXIS_TDATA_WIDTH/8-1:0] S_AXIS_TSTRB,
   input  wire [C_AXIS_TDATA_WIDTH/8-1:0] S_AXIS_TKEEP,
   input  wire                            S_AXIS_TLAST,
   input  wire [C_AXIS_TID_WIDTH-1:0]     S_AXIS_TID,
   input  wire [C_AXIS_TDEST_WIDTH-1:0]   S_AXIS_TDEST,
   input  wire [C_AXIS_TUSER_WIDTH-1:0]   S_AXIS_TUSER,

   // Master side
   output wire                            M_AXIS_TVALID,
   input  wire                            M_AXIS_TREADY,
   output wire [C_AXIS_TDATA_WIDTH-1:0]   M_AXIS_TDATA,
   output wire [C_AXIS_TDATA_WIDTH/8-1:0] M_AXIS_TSTRB,
   output wire [C_AXIS_TDATA_WIDTH/8-1:0] M_AXIS_TKEEP,
   output wire                            M_AXIS_TLAST,
   output wire [C_AXIS_TID_WIDTH-1:0]     M_AXIS_TID,
   output wire [C_AXIS_TDEST_WIDTH-1:0]   M_AXIS_TDEST,
   output wire [C_AXIS_TUSER_WIDTH-1:0]   M_AXIS_TUSER
   );

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
`include "axis_interconnect_v1_1_18.vh"

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
  localparam P_TPAYLOAD_WIDTH = f_payload_width(C_AXIS_TDATA_WIDTH, C_AXIS_TID_WIDTH, 
                                                C_AXIS_TDEST_WIDTH, C_AXIS_TUSER_WIDTH, 
                                                C_AXIS_SIGNAL_SET);

////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
reg                         areset_r;
wire [P_TPAYLOAD_WIDTH-1:0] S_AXIS_TPAYLOAD;
wire [P_TPAYLOAD_WIDTH-1:0] M_AXIS_TPAYLOAD;

////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////
always @(posedge ACLK) begin
  areset_r <= ~ARESETN;
end

  axis_interconnect_v1_1_18_util_axis2vector #(
    .C_TDATA_WIDTH    ( C_AXIS_TDATA_WIDTH ) ,
    .C_TID_WIDTH      ( C_AXIS_TID_WIDTH   ) ,
    .C_TDEST_WIDTH    ( C_AXIS_TDEST_WIDTH ) ,
    .C_TUSER_WIDTH    ( C_AXIS_TUSER_WIDTH ) ,
    .C_TPAYLOAD_WIDTH ( P_TPAYLOAD_WIDTH   ) ,
    .C_SIGNAL_SET     ( C_AXIS_SIGNAL_SET  ) 
  )
  util_axis2vector_0 (
    .TDATA    ( S_AXIS_TDATA    ) ,
    .TSTRB    ( S_AXIS_TSTRB    ) ,
    .TKEEP    ( S_AXIS_TKEEP    ) ,
    .TLAST    ( S_AXIS_TLAST    ) ,
    .TID      ( S_AXIS_TID      ) ,
    .TDEST    ( S_AXIS_TDEST    ) ,
    .TUSER    ( S_AXIS_TUSER    ) ,
    .TPAYLOAD ( S_AXIS_TPAYLOAD )
  );

  axis_interconnect_v1_1_18_axisc_register_slice #(
    .C_FAMILY     ( C_FAMILY         ) ,
    .C_DATA_WIDTH ( P_TPAYLOAD_WIDTH ) ,
    .C_REG_CONFIG ( C_REG_CONFIG     ) 
  )
  axisc_register_slice_0 (
    .ACLK           ( ACLK            ) ,
    .ARESET         ( areset_r        ) ,
    .ACLKEN         ( ACLKEN          ) ,
    .S_VALID        ( S_AXIS_TVALID   ) ,
    .S_READY        ( S_AXIS_TREADY   ) ,
    .S_PAYLOAD_DATA ( S_AXIS_TPAYLOAD ) ,

    .M_VALID        ( M_AXIS_TVALID   ) ,
    .M_READY        ( (C_AXIS_SIGNAL_SET[0] == 0) ? 1'b1 : M_AXIS_TREADY   ) ,
    .M_PAYLOAD_DATA ( M_AXIS_TPAYLOAD ) 
  );

  axis_interconnect_v1_1_18_util_vector2axis #(
    .C_TDATA_WIDTH    ( C_AXIS_TDATA_WIDTH ) ,
    .C_TID_WIDTH      ( C_AXIS_TID_WIDTH   ) ,
    .C_TDEST_WIDTH    ( C_AXIS_TDEST_WIDTH ) ,
    .C_TUSER_WIDTH    ( C_AXIS_TUSER_WIDTH ) ,
    .C_TPAYLOAD_WIDTH ( P_TPAYLOAD_WIDTH   ) ,
    .C_SIGNAL_SET     ( C_AXIS_SIGNAL_SET  ) 
  )
  util_vector2axis_0 (
    .TPAYLOAD ( M_AXIS_TPAYLOAD ) ,
    .TDATA    ( M_AXIS_TDATA    ) ,
    .TSTRB    ( M_AXIS_TSTRB    ) ,
    .TKEEP    ( M_AXIS_TKEEP    ) ,
    .TLAST    ( M_AXIS_TLAST    ) ,
    .TID      ( M_AXIS_TID      ) ,
    .TDEST    ( M_AXIS_TDEST    ) ,
    .TUSER    ( M_AXIS_TUSER    ) 
  );


endmodule // axis_register_slice

`default_nettype wire


// (c) Copyright 2011-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
// axisc_downsizer
//   Convert from SI data width > MI datawidth.
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_axisc_downsizer #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter         C_FAMILY             = "virtex6",
   parameter integer C_S_AXIS_TDATA_WIDTH = 96,
   parameter integer C_M_AXIS_TDATA_WIDTH = 32,
   parameter integer C_AXIS_TID_WIDTH     = 1,
   parameter integer C_AXIS_TDEST_WIDTH   = 1,
   parameter integer C_S_AXIS_TUSER_WIDTH = 3,
   parameter integer C_M_AXIS_TUSER_WIDTH = 1,
   parameter [31:0]  C_AXIS_SIGNAL_SET    = 32'hFF ,
   // C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional signals are present
   //   [0] => TREADY present
   //   [1] => TDATA present
   //   [2] => TSTRB present, TDATA must be present
   //   [3] => TKEEP present, TDATA must be present
   //   [4] => TLAST present
   //   [5] => TID present
   //   [6] => TDEST present
   //   [7] => TUSER present
   parameter integer C_RATIO = 3   // Should always be C_RATIO:1 (downsizer)
   )
  (
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
   // System Signals
   input wire ACLK,
   input wire ARESET,
   input wire ACLKEN,

   // Slave side
   input  wire                              S_AXIS_TVALID,
   output wire                              S_AXIS_TREADY,
   input  wire [C_S_AXIS_TDATA_WIDTH-1:0]   S_AXIS_TDATA,
   input  wire [C_S_AXIS_TDATA_WIDTH/8-1:0] S_AXIS_TSTRB,
   input  wire [C_S_AXIS_TDATA_WIDTH/8-1:0] S_AXIS_TKEEP,
   input  wire                              S_AXIS_TLAST,
   input  wire [C_AXIS_TID_WIDTH-1:0]       S_AXIS_TID,
   input  wire [C_AXIS_TDEST_WIDTH-1:0]     S_AXIS_TDEST,
   input  wire [C_S_AXIS_TUSER_WIDTH-1:0]   S_AXIS_TUSER,

   // Master side
   output wire                              M_AXIS_TVALID,
   input  wire                              M_AXIS_TREADY,
   output wire [C_M_AXIS_TDATA_WIDTH-1:0]   M_AXIS_TDATA,
   output wire [C_M_AXIS_TDATA_WIDTH/8-1:0] M_AXIS_TSTRB,
   output wire [C_M_AXIS_TDATA_WIDTH/8-1:0] M_AXIS_TKEEP,
   output wire                              M_AXIS_TLAST,
   output wire [C_AXIS_TID_WIDTH-1:0]       M_AXIS_TID,
   output wire [C_AXIS_TDEST_WIDTH-1:0]     M_AXIS_TDEST,
   output wire [C_M_AXIS_TUSER_WIDTH-1:0]   M_AXIS_TUSER
   );

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
`include "axis_interconnect_v1_1_18.vh"

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
localparam P_S_AXIS_TSTRB_WIDTH = C_S_AXIS_TDATA_WIDTH/8;
localparam P_M_AXIS_TSTRB_WIDTH = C_M_AXIS_TDATA_WIDTH/8;
localparam P_RATIO_WIDTH = f_clogb2(C_RATIO);
// State Machine possible states.
localparam SM_RESET          = 3'b000;
localparam SM_IDLE           = 3'b001;
localparam SM_ACTIVE         = 3'b010;
localparam SM_END           = 3'b011;
localparam SM_END_TO_ACTIVE = 3'b110;

////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
reg    [2:0]                    state;

wire [C_RATIO-1:0]              is_null;
wire [C_RATIO-1:0]              r0_is_end;

wire [C_M_AXIS_TDATA_WIDTH-1:0] data_out; 
wire [P_M_AXIS_TSTRB_WIDTH-1:0] strb_out;
wire [P_M_AXIS_TSTRB_WIDTH-1:0] keep_out;
wire                            last_out;
wire [C_AXIS_TID_WIDTH-1:0]     id_out;
wire [C_AXIS_TDEST_WIDTH-1:0]   dest_out;
wire [C_M_AXIS_TUSER_WIDTH-1:0] user_out;

reg  [C_S_AXIS_TDATA_WIDTH-1:0] r0_data;
reg  [P_S_AXIS_TSTRB_WIDTH-1:0] r0_strb;
reg  [P_S_AXIS_TSTRB_WIDTH-1:0] r0_keep;
reg                             r0_last;
reg  [C_AXIS_TID_WIDTH-1:0]     r0_id;
reg  [C_AXIS_TDEST_WIDTH-1:0]   r0_dest;
reg  [C_S_AXIS_TUSER_WIDTH-1:0] r0_user;
reg  [C_RATIO-1:0]              r0_is_null_r;

wire                            r0_load;

reg  [C_M_AXIS_TDATA_WIDTH-1:0] r1_data;
reg  [P_M_AXIS_TSTRB_WIDTH-1:0] r1_strb;
reg  [P_M_AXIS_TSTRB_WIDTH-1:0] r1_keep;
reg                             r1_last;
reg  [C_AXIS_TID_WIDTH-1:0]     r1_id;
reg  [C_AXIS_TDEST_WIDTH-1:0]   r1_dest;
reg  [C_M_AXIS_TUSER_WIDTH-1:0] r1_user;

wire                            r1_load;

reg  [P_RATIO_WIDTH-1:0]        r0_out_sel_r;
wire [P_RATIO_WIDTH-1:0]        r0_out_sel_ns;
wire                            sel_adv;
reg  [P_RATIO_WIDTH-1:0]        r0_out_sel_next_r;
wire [P_RATIO_WIDTH-1:0]        r0_out_sel_next_ns;
reg                             xfer_is_end;
reg                             next_xfer_is_end;

////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////
// S Ready/M Valid outputs are encoded in the current state.
assign S_AXIS_TREADY = state[0];
assign M_AXIS_TVALID = state[1];

// State machine controls M_AXIS_TVALID and S_AXIS_TREADY, and loading
always @(posedge ACLK) begin
  if (ARESET) begin
    state <= SM_RESET;
  end else if (ACLKEN) begin
    case (state)
      SM_RESET: begin
        state <= SM_IDLE;
      end
      
      // No transactions
      SM_IDLE: begin
        if (S_AXIS_TVALID) begin
          state <= SM_ACTIVE;
        end
        else begin
          state <= SM_IDLE;
        end
      end

      // Active entry in holding register r0
      SM_ACTIVE: begin
        if (M_AXIS_TREADY & r0_is_end[0]) begin
          state <= SM_IDLE;
        end
        else if (M_AXIS_TREADY & next_xfer_is_end) begin
          state <= SM_END;
        end
        else begin
          state <= SM_ACTIVE;
        end
      end

      // Entry in last transfer register r1.
      SM_END: begin
        if (M_AXIS_TREADY & S_AXIS_TVALID) begin
          state <= SM_ACTIVE;
        end
        else if (M_AXIS_TREADY & ~S_AXIS_TVALID) begin
          state <= SM_IDLE;
        end
        else if (~M_AXIS_TREADY & S_AXIS_TVALID) begin
          state <= SM_END_TO_ACTIVE;
        end
        else begin
          state <= SM_END;
        end
      end
        
      SM_END_TO_ACTIVE: begin
        if (M_AXIS_TREADY) begin
          state <= SM_ACTIVE;
        end
        else begin
          state <= SM_END_TO_ACTIVE;
        end
      end

      default: begin
        state <= SM_IDLE;
      end

    endcase // case (state)
  end
end 

// Algorithm to figure out which beat is the last non-null transfer. Split into 2 steps.
// 1) Figuring out which output transfers are null before storing in r0.
//    (cycle steal to reduce critical path).
// 2) For transfer X, if transfer X+1 to transfer C_RATIO-1 is null, then transfer
//    X is the new END transfer for the split. Transfer C_RATIO-1 is always marked
//    as END.
genvar i; 
generate
  if (C_AXIS_SIGNAL_SET[G_INDX_SS_TKEEP]) begin : gen_tkeep_is_enabled
    for (i = 0; i < C_RATIO-1; i = i + 1) begin : gen_is_null 
      // 1)
      assign is_null[i] = ~(|S_AXIS_TKEEP[i*P_M_AXIS_TSTRB_WIDTH +: P_M_AXIS_TSTRB_WIDTH]);
      // 2)
      assign r0_is_end[i] =  (&r0_is_null_r[C_RATIO-1:i+1]);
    end
    assign is_null[C_RATIO-1] = ~(|S_AXIS_TKEEP[(C_RATIO-1)*P_M_AXIS_TSTRB_WIDTH +: P_M_AXIS_TSTRB_WIDTH]);
    assign r0_is_end[C_RATIO-1] = 1'b1;
  end
  else begin : gen_tkeep_is_disabled
    assign is_null = {C_RATIO{1'b0}};
    assign r0_is_end = {1'b1, {C_RATIO-1{1'b0}}};
  end
endgenerate

assign M_AXIS_TDATA = data_out[0+:C_M_AXIS_TDATA_WIDTH];
assign M_AXIS_TSTRB = strb_out[0+:P_M_AXIS_TSTRB_WIDTH];
assign M_AXIS_TKEEP = keep_out[0+:P_M_AXIS_TSTRB_WIDTH];
assign M_AXIS_TLAST = last_out;
assign M_AXIS_TID   = id_out[0+:C_AXIS_TID_WIDTH];
assign M_AXIS_TDEST = dest_out[0+:C_AXIS_TDEST_WIDTH];
assign M_AXIS_TUSER = user_out[0+:C_M_AXIS_TUSER_WIDTH];

// Select data output by shifting data right, upper most datum is always from r1
assign data_out = {r1_data, r0_data[0+:C_M_AXIS_TDATA_WIDTH*(C_RATIO-1)]} >> (C_M_AXIS_TDATA_WIDTH*r0_out_sel_r);
assign strb_out = {r1_strb, r0_strb[0+:P_M_AXIS_TSTRB_WIDTH*(C_RATIO-1)]} >> (P_M_AXIS_TSTRB_WIDTH*r0_out_sel_r);
assign keep_out = {r1_keep, r0_keep[0+:P_M_AXIS_TSTRB_WIDTH*(C_RATIO-1)]} >> (P_M_AXIS_TSTRB_WIDTH*r0_out_sel_r);
assign last_out = (state == SM_END || state == SM_END_TO_ACTIVE) ? r1_last : r0_last & r0_is_end[0];
assign id_out   = (state == SM_END || state == SM_END_TO_ACTIVE) ? r1_id : r0_id;
assign dest_out = (state == SM_END || state == SM_END_TO_ACTIVE) ? r1_dest : r0_dest;
assign user_out = {r1_user, r0_user[0+:C_M_AXIS_TUSER_WIDTH*(C_RATIO-1)]} >> (C_M_AXIS_TUSER_WIDTH*r0_out_sel_r);

// First register stores the incoming transfer.
always @(posedge ACLK) begin
  if (ACLKEN) begin
    r0_data    <= r0_load ? S_AXIS_TDATA : r0_data;
    r0_strb    <= r0_load ? S_AXIS_TSTRB : r0_strb;
    r0_keep    <= r0_load ? S_AXIS_TKEEP : r0_keep;
    r0_last    <= r0_load ? S_AXIS_TLAST : r0_last;
    r0_id      <= r0_load ? S_AXIS_TID   : r0_id  ;
    r0_dest    <= r0_load ? S_AXIS_TDEST : r0_dest;
    r0_user    <= r0_load ? S_AXIS_TUSER : r0_user;
  end
end

// r0_is_null_r must always be set to known values to avoid x propagations.
always @(posedge ACLK) begin
  if (ARESET) begin
    r0_is_null_r <= {C_RATIO{1'b0}};
  end
  else if (ACLKEN) begin
    r0_is_null_r <= r0_load & S_AXIS_TVALID ? is_null : r0_is_null_r;
  end
end

assign r0_load = (state == SM_IDLE) || (state == SM_END);
// Second register only stores a single slice of r0.
always @(posedge ACLK) begin
  if (ACLKEN) begin
    r1_data    <= r1_load ? r0_data >> (C_M_AXIS_TDATA_WIDTH*r0_out_sel_next_r) : r1_data;
    r1_strb    <= r1_load ? r0_strb >> (P_M_AXIS_TSTRB_WIDTH*r0_out_sel_next_r) : r1_strb;
    r1_keep    <= r1_load ? r0_keep >> (P_M_AXIS_TSTRB_WIDTH*r0_out_sel_next_r) : r1_keep;
    r1_last    <= r1_load ? r0_last : r1_last;
    r1_id      <= r1_load ? r0_id   : r1_id  ;
    r1_dest    <= r1_load ? r0_dest : r1_dest;
    r1_user    <= r1_load ? r0_user >> (C_M_AXIS_TUSER_WIDTH*r0_out_sel_next_r) : r1_user;
  end
end

assign r1_load = (state == SM_ACTIVE);

// Counter to select which datum to send.
always @(posedge ACLK) begin
  if (ARESET) begin
    r0_out_sel_r <= {P_RATIO_WIDTH{1'b0}};
  end else if (ACLKEN) begin
    r0_out_sel_r <= r0_out_sel_ns;
 end
end

assign r0_out_sel_ns = (xfer_is_end & sel_adv) || (state == SM_IDLE) ? {P_RATIO_WIDTH{1'b0}} 
                       : next_xfer_is_end & sel_adv ? C_RATIO[P_RATIO_WIDTH-1:0]-1'b1 
                       : sel_adv ? r0_out_sel_next_r : r0_out_sel_r; 

assign sel_adv = M_AXIS_TREADY;


// Count ahead to the next value
always @(posedge ACLK) begin
  if (ARESET) begin
    r0_out_sel_next_r <= {P_RATIO_WIDTH{1'b0}} + 1'b1;
  end else if (ACLKEN) begin
    r0_out_sel_next_r <= r0_out_sel_next_ns;
 end
end

assign r0_out_sel_next_ns = (xfer_is_end & sel_adv) || (state == SM_IDLE) ? {P_RATIO_WIDTH{1'b0}} + 1'b1
                            : ~next_xfer_is_end & sel_adv ? r0_out_sel_next_r + 1'b1
                            : r0_out_sel_next_r;

always @(*) begin
  xfer_is_end = r0_is_end[r0_out_sel_r];
end

always @(*) begin
  next_xfer_is_end = r0_is_end[r0_out_sel_next_r];
end

endmodule // axisc_downsizer

`default_nettype wire


// (c) Copyright 2011-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
// axisc_downsizer
//   Convert from SI data width < MI datawidth.
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_axisc_upsizer #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter         C_FAMILY             = "virtex6",
   parameter integer C_S_AXIS_TDATA_WIDTH = 32,
   parameter integer C_M_AXIS_TDATA_WIDTH = 96,
   parameter integer C_AXIS_TID_WIDTH     = 1,
   parameter integer C_AXIS_TDEST_WIDTH   = 1,
   parameter integer C_S_AXIS_TUSER_WIDTH = 1,
   parameter integer C_M_AXIS_TUSER_WIDTH = 3,
   parameter [31:0]  C_AXIS_SIGNAL_SET    = 32'hFF ,
   // C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional signals are present
   //   [0] => TREADY present
   //   [1] => TDATA present
   //   [2] => TSTRB present, TDATA must be present
   //   [3] => TKEEP present, TDATA must be present
   //   [4] => TLAST present
   //   [5] => TID present
   //   [6] => TDEST present
   //   [7] => TUSER present
   parameter integer C_RATIO = 3   // Should always be 1:C_RATIO (upsizer)
   )
  (
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
   // System Signals
   input wire ACLK,
   input wire ARESET,
   input wire ACLKEN,

   // Slave side
   input  wire                              S_AXIS_TVALID,
   output wire                              S_AXIS_TREADY,
   input  wire [C_S_AXIS_TDATA_WIDTH-1:0]   S_AXIS_TDATA,
   input  wire [C_S_AXIS_TDATA_WIDTH/8-1:0] S_AXIS_TSTRB,
   input  wire [C_S_AXIS_TDATA_WIDTH/8-1:0] S_AXIS_TKEEP,
   input  wire                              S_AXIS_TLAST,
   input  wire [C_AXIS_TID_WIDTH-1:0]       S_AXIS_TID,
   input  wire [C_AXIS_TDEST_WIDTH-1:0]     S_AXIS_TDEST,
   input  wire [C_S_AXIS_TUSER_WIDTH-1:0]   S_AXIS_TUSER,

   // Master side
   output wire                              M_AXIS_TVALID,
   input  wire                              M_AXIS_TREADY,
   output wire [C_M_AXIS_TDATA_WIDTH-1:0]   M_AXIS_TDATA,
   output wire [C_M_AXIS_TDATA_WIDTH/8-1:0] M_AXIS_TSTRB,
   output wire [C_M_AXIS_TDATA_WIDTH/8-1:0] M_AXIS_TKEEP,
   output wire                              M_AXIS_TLAST,
   output wire [C_AXIS_TID_WIDTH-1:0]       M_AXIS_TID,
   output wire [C_AXIS_TDEST_WIDTH-1:0]     M_AXIS_TDEST,
   output wire [C_M_AXIS_TUSER_WIDTH-1:0]   M_AXIS_TUSER
   );

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
`include "axis_interconnect_v1_1_18.vh"

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
localparam P_READY_EXIST = C_AXIS_SIGNAL_SET[0];
localparam P_DATA_EXIST  = C_AXIS_SIGNAL_SET[1];
localparam P_STRB_EXIST  = C_AXIS_SIGNAL_SET[2];
localparam P_KEEP_EXIST  = C_AXIS_SIGNAL_SET[3];
localparam P_LAST_EXIST  = C_AXIS_SIGNAL_SET[4];
localparam P_ID_EXIST    = C_AXIS_SIGNAL_SET[5];
localparam P_DEST_EXIST  = C_AXIS_SIGNAL_SET[6];
localparam P_USER_EXIST  = C_AXIS_SIGNAL_SET[7];
localparam P_S_AXIS_TSTRB_WIDTH = C_S_AXIS_TDATA_WIDTH/8;
localparam P_M_AXIS_TSTRB_WIDTH = C_M_AXIS_TDATA_WIDTH/8;

// State Machine possible states. Bits 1:0 used to encode output signals.
//                                     /--- M_AXIS_TVALID state
//                                     |/-- S_AXIS_TREADY state
localparam SM_RESET              = 3'b000; // De-assert Ready during reset
localparam SM_IDLE               = 3'b001; // R0 reg is empty
localparam SM_ACTIVE             = 3'b101; // R0 reg is active
localparam SM_END                = 3'b011; // R0 reg is empty and ACC reg is active
localparam SM_END_TO_ACTIVE      = 3'b010; // R0/ACC reg are both active.

////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
reg  [2:0]                      state;

reg  [C_M_AXIS_TDATA_WIDTH-1:0] acc_data;
reg  [P_M_AXIS_TSTRB_WIDTH-1:0] acc_strb;
reg  [P_M_AXIS_TSTRB_WIDTH-1:0] acc_keep;
reg                             acc_last;
reg  [C_AXIS_TID_WIDTH-1:0]     acc_id;
reg  [C_AXIS_TDEST_WIDTH-1:0]   acc_dest;
reg  [C_M_AXIS_TUSER_WIDTH-1:0] acc_user;

wire [C_RATIO-1:0]              acc_reg_en;
reg  [C_RATIO-1:0]              r0_reg_sel;
wire                            next_xfer_is_end;

reg  [C_S_AXIS_TDATA_WIDTH-1:0] r0_data;
reg  [P_S_AXIS_TSTRB_WIDTH-1:0] r0_strb;
reg  [P_S_AXIS_TSTRB_WIDTH-1:0] r0_keep;
reg                             r0_last;
reg  [C_AXIS_TID_WIDTH-1:0]     r0_id;
reg  [C_AXIS_TDEST_WIDTH-1:0]   r0_dest;
reg  [C_S_AXIS_TUSER_WIDTH-1:0] r0_user;

wire                            id_match;
wire                            dest_match;
wire                            id_dest_mismatch;

////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////

// S Ready/M Valid outputs are encoded in the current state.
assign S_AXIS_TREADY = state[0];
assign M_AXIS_TVALID = state[1];

// State machine controls M_AXIS_TVALID and S_AXIS_TREADY, and loading
always @(posedge ACLK) begin
  if (ARESET) begin
    state <= SM_RESET;
  end else if (ACLKEN) begin
    case (state)
      SM_RESET: begin
        state <= SM_IDLE;
      end
      
      SM_IDLE: begin
        if (S_AXIS_TVALID & id_dest_mismatch & ~r0_reg_sel[0]) begin
          state <= SM_END_TO_ACTIVE;
        end
        else if (S_AXIS_TVALID & next_xfer_is_end) begin
          state <= SM_END;
        end
        else if (S_AXIS_TVALID) begin
          state <= SM_ACTIVE;
        end
        else begin
          state <= SM_IDLE;
        end
      end

      SM_ACTIVE: begin 
        if (S_AXIS_TVALID & (id_dest_mismatch | r0_last)) begin
          state <= SM_END_TO_ACTIVE;
        end
        else if ((~S_AXIS_TVALID & r0_last) | (S_AXIS_TVALID & next_xfer_is_end)) begin
          state <= SM_END;
        end
        else if (S_AXIS_TVALID & ~next_xfer_is_end) begin
          state <= SM_ACTIVE;
        end
        else begin 
          state <= SM_IDLE;
        end
      end

      SM_END: begin
        if (M_AXIS_TREADY & S_AXIS_TVALID) begin
          state <= SM_ACTIVE;
        end
        else if ( ~M_AXIS_TREADY & S_AXIS_TVALID) begin
          state <= SM_END_TO_ACTIVE;
        end
        else if ( M_AXIS_TREADY & ~S_AXIS_TVALID) begin 
          state <= SM_IDLE;
        end
        else begin
          state <= SM_END;
        end
      end

      SM_END_TO_ACTIVE: begin
        if (M_AXIS_TREADY) begin
          state <= SM_ACTIVE;
        end
        else begin
          state <= SM_END_TO_ACTIVE;
        end
      end

      default: begin
        state <= SM_IDLE;
      end

    endcase // case (state)
  end
end 


assign M_AXIS_TDATA = acc_data;
assign M_AXIS_TSTRB = acc_strb;
assign M_AXIS_TKEEP = acc_keep;
assign M_AXIS_TUSER = acc_user;

generate 
  genvar i;
  // DATA/USER/STRB/KEEP accumulators
  always @(posedge ACLK) begin
    if (ACLKEN) begin
      acc_data[0*C_S_AXIS_TDATA_WIDTH+:C_S_AXIS_TDATA_WIDTH] <= acc_reg_en[0] ? r0_data
        : acc_data[0*C_S_AXIS_TDATA_WIDTH+:C_S_AXIS_TDATA_WIDTH];
      acc_user[0*C_S_AXIS_TUSER_WIDTH+:C_S_AXIS_TUSER_WIDTH] <= acc_reg_en[0] ? r0_user
        : acc_user[0*C_S_AXIS_TUSER_WIDTH+:C_S_AXIS_TUSER_WIDTH];
      acc_strb[0*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH] <= acc_reg_en[0] ? r0_strb
        : acc_strb[0*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH];
      acc_keep[0*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH] <= acc_reg_en[0] ? r0_keep
        : acc_keep[0*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH];
    end
  end
  for (i = 1; i < C_RATIO-1; i = i + 1) begin : gen_data_accumulator
    always @(posedge ACLK) begin
      if (ACLKEN) begin
        acc_data[i*C_S_AXIS_TDATA_WIDTH+:C_S_AXIS_TDATA_WIDTH] <= acc_reg_en[i] ? r0_data
          : acc_data[i*C_S_AXIS_TDATA_WIDTH+:C_S_AXIS_TDATA_WIDTH];
        acc_user[i*C_S_AXIS_TUSER_WIDTH+:C_S_AXIS_TUSER_WIDTH] <= acc_reg_en[i] ? r0_user
          : acc_user[i*C_S_AXIS_TUSER_WIDTH+:C_S_AXIS_TUSER_WIDTH];
        acc_strb[i*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH] <= acc_reg_en[0] ? {P_S_AXIS_TSTRB_WIDTH{1'b0}} 
          : acc_reg_en[i] ? r0_strb : acc_strb[i*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH];
        acc_keep[i*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH] <= acc_reg_en[0] ? {P_S_AXIS_TSTRB_WIDTH{1'b0}} 
          : acc_reg_en[i] ? r0_keep : acc_keep[i*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH];
      end
    end
  end
  always @(posedge ACLK) begin
    if (ACLKEN) begin
      acc_data[(C_RATIO-1)*C_S_AXIS_TDATA_WIDTH+:C_S_AXIS_TDATA_WIDTH] <= (state == SM_IDLE) | (state == SM_ACTIVE) 
        ? S_AXIS_TDATA : acc_data[(C_RATIO-1)*C_S_AXIS_TDATA_WIDTH+:C_S_AXIS_TDATA_WIDTH];
      acc_user[(C_RATIO-1)*C_S_AXIS_TUSER_WIDTH+:C_S_AXIS_TUSER_WIDTH] <= (state == SM_IDLE) | (state == SM_ACTIVE) 
        ? S_AXIS_TUSER : acc_user[(C_RATIO-1)*C_S_AXIS_TUSER_WIDTH+:C_S_AXIS_TUSER_WIDTH];
      acc_strb[(C_RATIO-1)*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH] <= (acc_reg_en[0] && C_RATIO > 2) | (state == SM_ACTIVE & r0_last) | (id_dest_mismatch & (state == SM_ACTIVE | state == SM_IDLE))
        ? {P_S_AXIS_TSTRB_WIDTH{1'b0}} : (state == SM_IDLE) | (state == SM_ACTIVE) 
        ? S_AXIS_TSTRB : acc_strb[(C_RATIO-1)*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH];
      acc_keep[(C_RATIO-1)*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH] <= (acc_reg_en[0] && C_RATIO > 2) | (state == SM_ACTIVE & r0_last) | (id_dest_mismatch & (state == SM_ACTIVE| state == SM_IDLE))
        ? {P_S_AXIS_TSTRB_WIDTH{1'b0}} : (state == SM_IDLE) | (state == SM_ACTIVE) 
        ? S_AXIS_TKEEP : acc_keep[(C_RATIO-1)*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH];
    end
  end

endgenerate

assign acc_reg_en = (state == SM_ACTIVE) ? r0_reg_sel : {C_RATIO{1'b0}};

// Accumulator selector (1 hot left barrel shifter)
always @(posedge ACLK) begin
  if (ARESET) begin
    r0_reg_sel[0] <= 1'b1;
    r0_reg_sel[1+:C_RATIO-1] <= {C_RATIO{1'b0}};
  end else if (ACLKEN) begin
    r0_reg_sel[0]            <= M_AXIS_TVALID & M_AXIS_TREADY ? 1'b1              
        : (state == SM_ACTIVE) ? 1'b0 : r0_reg_sel[0];
    r0_reg_sel[1+:C_RATIO-1] <= M_AXIS_TVALID & M_AXIS_TREADY ? {C_RATIO-1{1'b0}} 
        : (state == SM_ACTIVE) ? r0_reg_sel[0+:C_RATIO-1] : r0_reg_sel[1+:C_RATIO-1];
  end
end

assign next_xfer_is_end  = (r0_reg_sel[C_RATIO-2] && (state == SM_ACTIVE)) | r0_reg_sel[C_RATIO-1];

always @(posedge ACLK) begin 
  if (ACLKEN) begin
    r0_data <= S_AXIS_TREADY ? S_AXIS_TDATA : r0_data;
    r0_strb <= S_AXIS_TREADY ? S_AXIS_TSTRB : r0_strb;
    r0_keep <= S_AXIS_TREADY ? S_AXIS_TKEEP : r0_keep;
    r0_last <= (!P_LAST_EXIST) ? 1'b0 : S_AXIS_TREADY ? S_AXIS_TLAST : r0_last;
    r0_id   <= (S_AXIS_TREADY & S_AXIS_TVALID) ? S_AXIS_TID   : r0_id;
    r0_dest <= (S_AXIS_TREADY & S_AXIS_TVALID) ? S_AXIS_TDEST : r0_dest;
    r0_user <= S_AXIS_TREADY ? S_AXIS_TUSER : r0_user;
  end
end

assign M_AXIS_TLAST = acc_last;

always @(posedge ACLK) begin
  if (ACLKEN) begin
    acc_last <= (state == SM_END | state == SM_END_TO_ACTIVE) ? acc_last : 
                (state == SM_ACTIVE & r0_last ) ? 1'b1 :
                (id_dest_mismatch & (state == SM_IDLE)) ? 1'b0 : 
                (id_dest_mismatch & (state == SM_ACTIVE)) ? r0_last :
                 S_AXIS_TLAST;
  end
end

assign M_AXIS_TID   = acc_id;
assign M_AXIS_TDEST = acc_dest;

always @(posedge ACLK) begin
  if (ACLKEN) begin
    acc_id <= acc_reg_en[0] ? r0_id : acc_id;
    acc_dest <= acc_reg_en[0] ? r0_dest : acc_dest;
  end
end

assign id_match = P_ID_EXIST ? (S_AXIS_TID == r0_id) : 1'b1;
assign dest_match = P_DEST_EXIST ?  (S_AXIS_TDEST == r0_dest) : 1'b1;

assign id_dest_mismatch = (~id_match | ~dest_match) ? 1'b1 : 1'b0;

endmodule // axisc_upsizer

`default_nettype wire


// (c) Copyright 2011-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
// axis_dwidth_converter
//   Converts data when C_S_AXIS_TDATA_WIDTH != C_M_AXIS_TDATA_WIDTH.
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axis_dwidth_converter
//     register_slice (instantiated with upsizer)
//     axisc_upsizer
//     axisc_downsizer
//     register_slice (instantiated with downsizer)
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_axis_dwidth_converter #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter         C_FAMILY           = "virtex7",
   parameter integer C_S_AXIS_TDATA_WIDTH = 32,
   parameter integer C_M_AXIS_TDATA_WIDTH = 32,
   parameter integer C_AXIS_TID_WIDTH   = 1,
   parameter integer C_AXIS_TDEST_WIDTH = 1,
//   parameter integer C_AXIS_TUSER_BITS_PER_BYTE = 1, // Must be > 0 for width converter
   parameter integer C_S_AXIS_TUSER_WIDTH = 1,
   parameter integer C_M_AXIS_TUSER_WIDTH = 1,
   parameter [31:0]  C_AXIS_SIGNAL_SET  = 32'hFF
   // C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional signals are present
   //   [0] => TREADY present (Required)
   //   [1] => TDATA present (Required, used to calculate ratios)
   //   [2] => TSTRB present, TDATA must be present
   //   [3] => TKEEP present, TDATA must be present (Required if TLAST, TID,
   //   TDEST present
   //   [4] => TLAST present
   //   [5] => TID present
   //   [6] => TDEST present
   //   [7] => TUSER present
   )
  (
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
   // System Signals
   input wire ACLK,
   input wire ARESETN,
   input wire ACLKEN,

   // Slave side
   input  wire                              S_AXIS_TVALID,
   output wire                              S_AXIS_TREADY,
   input  wire [C_S_AXIS_TDATA_WIDTH-1:0]   S_AXIS_TDATA,
   input  wire [C_S_AXIS_TDATA_WIDTH/8-1:0] S_AXIS_TSTRB,
   input  wire [C_S_AXIS_TDATA_WIDTH/8-1:0] S_AXIS_TKEEP,
   input  wire                              S_AXIS_TLAST,
   input  wire [C_AXIS_TID_WIDTH-1:0]       S_AXIS_TID,
   input  wire [C_AXIS_TDEST_WIDTH-1:0]     S_AXIS_TDEST,
   input  wire [C_S_AXIS_TUSER_WIDTH-1:0]   S_AXIS_TUSER,

   // Master side
   output wire                              M_AXIS_TVALID,
   input  wire                              M_AXIS_TREADY,
   output wire [C_M_AXIS_TDATA_WIDTH-1:0]   M_AXIS_TDATA,
   output wire [C_M_AXIS_TDATA_WIDTH/8-1:0] M_AXIS_TSTRB,
   output wire [C_M_AXIS_TDATA_WIDTH/8-1:0] M_AXIS_TKEEP,
   output wire                              M_AXIS_TLAST,
   output wire [C_AXIS_TID_WIDTH-1:0]       M_AXIS_TID,
   output wire [C_AXIS_TDEST_WIDTH-1:0]     M_AXIS_TDEST,
   output wire [C_M_AXIS_TUSER_WIDTH-1:0]   M_AXIS_TUSER
   );

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
`include "axis_interconnect_v1_1_18.vh"

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
// TKEEP required if TID/TLAST/TDEST signals enabled
localparam [31:0]  P_SS_TKEEP_REQUIRED = (C_AXIS_SIGNAL_SET & (G_MASK_SS_TID | G_MASK_SS_TDEST | G_MASK_SS_TLAST)) 
                                          ? G_MASK_SS_TKEEP : 32'h0;
// TREADY/TDATA must always be present
localparam [31:0]  P_AXIS_SIGNAL_SET  = C_AXIS_SIGNAL_SET | G_MASK_SS_TREADY | G_MASK_SS_TDATA | P_SS_TKEEP_REQUIRED;
localparam P_S_RATIO = f_lcm(C_S_AXIS_TDATA_WIDTH, C_M_AXIS_TDATA_WIDTH) / C_S_AXIS_TDATA_WIDTH;
localparam P_M_RATIO = f_lcm(C_S_AXIS_TDATA_WIDTH, C_M_AXIS_TDATA_WIDTH) / C_M_AXIS_TDATA_WIDTH;
localparam P_D2_TDATA_WIDTH = C_S_AXIS_TDATA_WIDTH * P_S_RATIO;
// To protect against bad TUSER M/S ratios when not using TUSER, base all
// TUSER widths off of the calculated ratios and the slave tuser input width.
localparam P_D1_TUSER_WIDTH = C_AXIS_SIGNAL_SET[G_INDX_SS_TUSER] ? C_S_AXIS_TUSER_WIDTH : C_S_AXIS_TDATA_WIDTH/8;
localparam P_D2_TUSER_WIDTH = P_D1_TUSER_WIDTH * P_S_RATIO;
localparam P_D3_TUSER_WIDTH = P_D2_TUSER_WIDTH / P_M_RATIO;

localparam P_D1_REG_CONFIG = 0; // Disable
localparam P_D3_REG_CONFIG = 0; // Disable

////////////////////////////////////////////////////////////////////////////////
// DRCs
////////////////////////////////////////////////////////////////////////////////
// synthesis translate_off
integer retval;
integer retval_all;
initial
begin : DRC
  retval_all = 0;
  t_check_tdata_width(C_S_AXIS_TDATA_WIDTH, "C_S_AXIS_TDATA_WIDTH", "axis_dwidth_converter", G_TASK_SEVERITY_ERROR, retval);
  retval_all = retval_all | retval;

  t_check_tdata_width(C_M_AXIS_TDATA_WIDTH, "C_M_AXIS_TDATA_WIDTH", "axis_dwidth_converter", G_TASK_SEVERITY_ERROR, retval);
  retval_all = retval_all | retval;
  if (C_AXIS_SIGNAL_SET[G_INDX_SS_TUSER]) begin
    t_check_tuser_width(C_S_AXIS_TUSER_WIDTH, "C_S_AXIS_TUSER_WIDTH", C_S_AXIS_TDATA_WIDTH, "C_S_AXIS_TDATA_WIDTH", "axis_dwidth_converter", G_TASK_SEVERITY_ERROR, retval);
    retval_all = retval_all | retval;
    t_check_tuser_width(C_M_AXIS_TUSER_WIDTH, "C_M_AXIS_TUSER_WIDTH", C_M_AXIS_TDATA_WIDTH, "C_M_AXIS_TDATA_WIDTH", "axis_dwidth_converter", G_TASK_SEVERITY_ERROR, retval);
    retval_all = retval_all | retval;
  end
  if (retval_all > 0) begin
    $stop;
  end

end
// synthesis translate_on
////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////

reg                               areset_r;

// Tie-offs for required signals if not present on inputs
wire                              tready_in;
wire [C_S_AXIS_TDATA_WIDTH-1:0]   tdata_in;
wire [C_S_AXIS_TDATA_WIDTH/8-1:0] tkeep_in;
wire [P_D1_TUSER_WIDTH-1:0]       tuser_in;

// Output of first register stage
wire                              d1_valid;
wire                              d1_ready;
wire [C_S_AXIS_TDATA_WIDTH-1:0]   d1_data;
wire [C_S_AXIS_TDATA_WIDTH/8-1:0] d1_strb;
wire [C_S_AXIS_TDATA_WIDTH/8-1:0] d1_keep;
wire                              d1_last;
wire [C_AXIS_TID_WIDTH-1:0]       d1_id;
wire [C_AXIS_TDEST_WIDTH-1:0]     d1_dest;
wire [P_D1_TUSER_WIDTH-1:0]       d1_user;

// Output of upsizer stage
wire                              d2_valid;
wire                              d2_ready;
wire [P_D2_TDATA_WIDTH-1:0]       d2_data;
wire [P_D2_TDATA_WIDTH/8-1:0]     d2_strb;
wire [P_D2_TDATA_WIDTH/8-1:0]     d2_keep;
wire                              d2_last;
wire [C_AXIS_TID_WIDTH-1:0]       d2_id;
wire [C_AXIS_TDEST_WIDTH-1:0]     d2_dest;
wire [P_D2_TUSER_WIDTH-1:0]       d2_user;

// Output of downsizer stage
wire                              d3_valid;
wire                              d3_ready;
wire [C_M_AXIS_TDATA_WIDTH-1:0]   d3_data;
wire [C_M_AXIS_TDATA_WIDTH/8-1:0] d3_strb;
wire [C_M_AXIS_TDATA_WIDTH/8-1:0] d3_keep;
wire                              d3_last;
wire [C_AXIS_TID_WIDTH-1:0]       d3_id;
wire [C_AXIS_TDEST_WIDTH-1:0]     d3_dest;
wire [P_D3_TUSER_WIDTH-1:0]       d3_user;
wire [P_D3_TUSER_WIDTH-1:0]       m_axis_tuser_out;



////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////

always @(posedge ACLK) begin
  areset_r <= ~ARESETN;
end

// Tie-offs for required signals if not present on inputs
assign tready_in = C_AXIS_SIGNAL_SET[G_INDX_SS_TREADY] ? M_AXIS_TREADY : 1'b1;
assign tdata_in = C_AXIS_SIGNAL_SET[G_INDX_SS_TDATA] ? S_AXIS_TDATA : {C_S_AXIS_TDATA_WIDTH{1'b0}};
assign tkeep_in = C_AXIS_SIGNAL_SET[G_INDX_SS_TKEEP] ? S_AXIS_TKEEP : {(C_S_AXIS_TDATA_WIDTH/8){1'b1}};
assign tuser_in = C_AXIS_SIGNAL_SET[G_INDX_SS_TUSER] ? S_AXIS_TUSER : {P_D1_TUSER_WIDTH{1'b1}};

axis_interconnect_v1_1_18_axis_register_slice #(
  .C_FAMILY           ( C_FAMILY               ) ,
  .C_AXIS_TDATA_WIDTH ( C_S_AXIS_TDATA_WIDTH   ) ,
  .C_AXIS_TID_WIDTH   ( C_AXIS_TID_WIDTH       ) ,
  .C_AXIS_TDEST_WIDTH ( C_AXIS_TDEST_WIDTH     ) ,
  .C_AXIS_TUSER_WIDTH ( P_D1_TUSER_WIDTH       ) ,
  .C_AXIS_SIGNAL_SET  ( P_AXIS_SIGNAL_SET      ) ,
  .C_REG_CONFIG       ( P_D1_REG_CONFIG        )
)
axis_register_slice_0
(
  .ACLK          ( ACLK          ) ,
  .ACLKEN        ( ACLKEN        ) ,
  .ARESETN       ( ARESETN       ) ,
  .S_AXIS_TVALID ( S_AXIS_TVALID ) ,
  .S_AXIS_TREADY ( S_AXIS_TREADY ) ,
  .S_AXIS_TDATA  ( tdata_in      ) ,
  .S_AXIS_TSTRB  ( S_AXIS_TSTRB  ) ,
  .S_AXIS_TKEEP  ( tkeep_in      ) ,
  .S_AXIS_TLAST  ( S_AXIS_TLAST  ) ,
  .S_AXIS_TID    ( S_AXIS_TID    ) ,
  .S_AXIS_TDEST  ( S_AXIS_TDEST  ) ,
  .S_AXIS_TUSER  ( tuser_in      ) ,
  .M_AXIS_TVALID ( d1_valid      ) ,
  .M_AXIS_TREADY ( d1_ready      ) ,
  .M_AXIS_TDATA  ( d1_data       ) ,
  .M_AXIS_TSTRB  ( d1_strb       ) ,
  .M_AXIS_TKEEP  ( d1_keep       ) ,
  .M_AXIS_TLAST  ( d1_last       ) ,
  .M_AXIS_TID    ( d1_id         ) ,
  .M_AXIS_TDEST  ( d1_dest       ) ,
  .M_AXIS_TUSER  ( d1_user       ) 
);


generate
  if (P_S_RATIO > 1) begin : gen_upsizer_conversion
    axis_interconnect_v1_1_18_axisc_upsizer #(
      .C_FAMILY             ( C_FAMILY             ) ,
      .C_S_AXIS_TDATA_WIDTH ( C_S_AXIS_TDATA_WIDTH ) ,
      .C_M_AXIS_TDATA_WIDTH ( P_D2_TDATA_WIDTH     ) ,
      .C_AXIS_TID_WIDTH     ( C_AXIS_TID_WIDTH     ) ,
      .C_AXIS_TDEST_WIDTH   ( C_AXIS_TDEST_WIDTH   ) ,
      .C_S_AXIS_TUSER_WIDTH  ( P_D1_TUSER_WIDTH    ) ,
      .C_M_AXIS_TUSER_WIDTH  ( P_D2_TUSER_WIDTH    ) ,
      .C_AXIS_SIGNAL_SET    ( P_AXIS_SIGNAL_SET    ) ,
      .C_RATIO              ( P_S_RATIO            ) 
    )
    axisc_upsizer_0 (
      .ACLK          ( ACLK     ) ,
      .ARESET        ( areset_r ) ,
      .ACLKEN        ( ACLKEN   ) ,
      .S_AXIS_TVALID ( d1_valid ) ,
      .S_AXIS_TREADY ( d1_ready ) ,
      .S_AXIS_TDATA  ( d1_data  ) ,
      .S_AXIS_TSTRB  ( d1_strb  ) ,
      .S_AXIS_TKEEP  ( d1_keep  ) ,
      .S_AXIS_TLAST  ( d1_last  ) ,
      .S_AXIS_TID    ( d1_id    ) ,
      .S_AXIS_TDEST  ( d1_dest  ) ,
      .S_AXIS_TUSER  ( d1_user  ) ,
      .M_AXIS_TVALID ( d2_valid ) ,
      .M_AXIS_TREADY ( d2_ready ) ,
      .M_AXIS_TDATA  ( d2_data  ) ,
      .M_AXIS_TSTRB  ( d2_strb  ) ,
      .M_AXIS_TKEEP  ( d2_keep  ) ,
      .M_AXIS_TLAST  ( d2_last  ) ,
      .M_AXIS_TID    ( d2_id    ) ,
      .M_AXIS_TDEST  ( d2_dest  ) ,
      .M_AXIS_TUSER  ( d2_user  ) 
    );
  end
  else begin : gen_no_upsizer_passthru
    assign d2_valid = d1_valid;
    assign d1_ready = d2_ready;
    assign d2_data  = d1_data;
    assign d2_strb  = d1_strb;
    assign d2_keep  = d1_keep;
    assign d2_last  = d1_last;
    assign d2_id    = d1_id;
    assign d2_dest  = d1_dest;
    assign d2_user  = d1_user;
  end
  if (P_M_RATIO > 1) begin : gen_downsizer_conversion
    axis_interconnect_v1_1_18_axisc_downsizer #(
      .C_FAMILY             ( C_FAMILY             ) ,
      .C_S_AXIS_TDATA_WIDTH ( P_D2_TDATA_WIDTH     ) ,
      .C_M_AXIS_TDATA_WIDTH ( C_M_AXIS_TDATA_WIDTH ) ,
      .C_AXIS_TID_WIDTH     ( C_AXIS_TID_WIDTH     ) ,
      .C_AXIS_TDEST_WIDTH   ( C_AXIS_TDEST_WIDTH   ) ,
      .C_S_AXIS_TUSER_WIDTH  ( P_D2_TUSER_WIDTH    ) ,
      .C_M_AXIS_TUSER_WIDTH  ( P_D3_TUSER_WIDTH    ) ,
      .C_AXIS_SIGNAL_SET    ( P_AXIS_SIGNAL_SET    ) ,
      .C_RATIO              ( P_M_RATIO            ) 
    )
    axisc_downsizer_0 (
      .ACLK          ( ACLK     ) ,
      .ARESET        ( areset_r ) ,
      .ACLKEN        ( ACLKEN   ) ,
      .S_AXIS_TVALID ( d2_valid ) ,
      .S_AXIS_TREADY ( d2_ready ) ,
      .S_AXIS_TDATA  ( d2_data  ) ,
      .S_AXIS_TSTRB  ( d2_strb  ) ,
      .S_AXIS_TKEEP  ( d2_keep  ) ,
      .S_AXIS_TLAST  ( d2_last  ) ,
      .S_AXIS_TID    ( d2_id    ) ,
      .S_AXIS_TDEST  ( d2_dest  ) ,
      .S_AXIS_TUSER  ( d2_user  ) ,
      .M_AXIS_TVALID ( d3_valid ) ,
      .M_AXIS_TREADY ( d3_ready ) ,
      .M_AXIS_TDATA  ( d3_data  ) ,
      .M_AXIS_TSTRB  ( d3_strb  ) ,
      .M_AXIS_TKEEP  ( d3_keep  ) ,
      .M_AXIS_TLAST  ( d3_last  ) ,
      .M_AXIS_TID    ( d3_id    ) ,
      .M_AXIS_TDEST  ( d3_dest  ) ,
      .M_AXIS_TUSER  ( d3_user  ) 
    );
  end
  else begin : gen_no_downsizer_passthru
    assign d3_valid = d2_valid;
    assign d2_ready = d3_ready;
    assign d3_data  = d2_data;
    assign d3_strb  = d2_strb;
    assign d3_keep  = d2_keep;
    assign d3_last  = d2_last;
    assign d3_id    = d2_id;
    assign d3_dest  = d2_dest;
    assign d3_user  = d2_user;
  end
endgenerate

axis_interconnect_v1_1_18_axis_register_slice #(
  .C_FAMILY           ( C_FAMILY             ) ,
  .C_AXIS_TDATA_WIDTH ( C_M_AXIS_TDATA_WIDTH ) ,
  .C_AXIS_TID_WIDTH   ( C_AXIS_TID_WIDTH     ) ,
  .C_AXIS_TDEST_WIDTH ( C_AXIS_TDEST_WIDTH   ) ,
  .C_AXIS_TUSER_WIDTH ( P_D3_TUSER_WIDTH     ) ,
  .C_AXIS_SIGNAL_SET  ( P_AXIS_SIGNAL_SET    ) ,
  .C_REG_CONFIG       ( P_D3_REG_CONFIG      )
)
axis_register_slice_1
(
  .ACLK          ( ACLK          ) ,
  .ACLKEN        ( ACLKEN        ) ,
  .ARESETN       ( ARESETN       ) ,
  .S_AXIS_TVALID ( d3_valid      ) ,
  .S_AXIS_TREADY ( d3_ready      ) ,
  .S_AXIS_TDATA  ( d3_data       ) ,
  .S_AXIS_TSTRB  ( d3_strb       ) ,
  .S_AXIS_TKEEP  ( d3_keep       ) ,
  .S_AXIS_TLAST  ( d3_last       ) ,
  .S_AXIS_TID    ( d3_id         ) ,
  .S_AXIS_TDEST  ( d3_dest       ) ,
  .S_AXIS_TUSER  ( d3_user       ) ,
  .M_AXIS_TVALID ( M_AXIS_TVALID ) ,
  .M_AXIS_TREADY ( tready_in     ) ,
  .M_AXIS_TDATA  ( M_AXIS_TDATA  ) ,
  .M_AXIS_TSTRB  ( M_AXIS_TSTRB  ) ,
  .M_AXIS_TKEEP  ( M_AXIS_TKEEP  ) ,
  .M_AXIS_TLAST  ( M_AXIS_TLAST  ) ,
  .M_AXIS_TID    ( M_AXIS_TID    ) ,
  .M_AXIS_TDEST  ( M_AXIS_TDEST  ) ,
  .M_AXIS_TUSER  ( m_axis_tuser_out )
);

assign M_AXIS_TUSER = C_AXIS_SIGNAL_SET[G_INDX_SS_TUSER] ? m_axis_tuser_out[P_D3_TUSER_WIDTH-1:0] 
                                                    : {C_M_AXIS_TUSER_WIDTH{1'bx}};

endmodule // axis_dwidth_converter

`default_nettype wire


//  (c) Copyright 2011-2013 Xilinx, Inc. All rights reserved.
//
//  This file contains confidential and proprietary information
//  of Xilinx, Inc. and is protected under U.S. and
//  international copyright and other intellectual property
//  laws.
//
//  DISCLAIMER
//  This disclaimer is not a license and does not grant any
//  rights to the materials distributed herewith. Except as
//  otherwise provided in a valid license issued to you by
//  Xilinx, and to the maximum extent permitted by applicable
//  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
//  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//  (2) Xilinx shall not be liable (whether in contract or tort,
//  including negligence, or under any other theory of
//  liability) for any loss or damage of any kind or nature
//  related to, arising under or in connection with these
//  materials, including for any direct, or any indirect,
//  special, incidental, or consequential loss or damage
//  (including loss of data, profits, goodwill, or any type of
//  loss or damage suffered as a result of any action brought
//  by a third party) even if such damage or loss was
//  reasonably foreseeable or Xilinx had been advised of the
//  possibility of the same.
//
//  CRITICAL APPLICATIONS
//  Xilinx products are not designed or intended to be fail-
//  safe, or for use in any application requiring fail-safe
//  performance, such as life-support or safety devices or
//  systems, Class III medical devices, nuclear facilities,
//  applications related to the deployment of airbags, or any
//  other applications that could lead to death, personal
//  injury, or severe property or environmental damage
//  (individually and collectively, "Critical
//  Applications"). Customer assumes the sole risk and
//  liability of any use of Xilinx products in Critical
//  Applications, subject only to applicable laws and
//  regulations governing limitations on product liability.
//
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//  PART OF THIS FILE AT ALL TIMES. 
//-----------------------------------------------------------------------------
//
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   dynamic_datapath
//     subset_converter
//     register_slice
//     dwidth_converter(up)
//     clock_converter
//     dwidth_converter(down)
//     packer
//     FIFO   
//  
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_dynamic_datapath #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter         C_FAMILY             = "virtex6",
   parameter [31:0]  C_S_AXIS_TDATA_WIDTH = 32'd32,
   parameter [31:0]  C_S_AXIS_TID_WIDTH   = 32'd1,
   parameter [31:0]  C_S_AXIS_TDEST_WIDTH = 32'd1,
   parameter [31:0]  C_S_AXIS_TUSER_WIDTH = 32'd1,
   parameter [31:0]  C_S_AXIS_SIGNAL_SET  = 32'hFF ,
   parameter [31:0]  C_S_AXIS_ACLK_RATIO  = 32'd0,
   parameter [31:0]  C_M_AXIS_TDATA_WIDTH = 32'd32,
   parameter [31:0]  C_M_AXIS_TID_WIDTH   = 32'd1,
   parameter [31:0]  C_M_AXIS_TDEST_WIDTH = 32'd1,
   parameter [31:0]  C_M_AXIS_TUSER_WIDTH = 32'd2,
   parameter [31:0]  C_M_AXIS_SIGNAL_SET  = 32'hFF ,
   // C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional signals are present
   //   [0] => TREADY present
   //   [1] => TDATA present
   //   [2] => TSTRB present, TDATA must be present
   //   [3] => TKEEP present, TDATA must be present
   //   [4] => TLAST present
   //   [5] => TID present
   //   [6] => TDEST present
   //   [7] => TUSER present
   parameter [31:0]  C_M_AXIS_ACLK_RATIO = 32'd0,
   parameter [31:0]  C_REG_CONFIG        = 32'd1,
   parameter [31:0]  C_IS_ACLK_ASYNC     = 32'd0,
   parameter [31:0]  C_ACLKEN_CONV_MODE  = 32'd0,
   parameter [31:0]  C_FIFO_DEPTH        = 32'd1024,
   parameter [31:0]  C_FIFO_MODE         = 1,
   parameter [8*32-1:0] C_MODULE_ORDER = {32'h0, 32'h1, 32'h2, 32'h4, 32'h6, 32'h5, 32'h8, 32'h7} ,
   // C_MODULE_ORDER is an array of modules to be instantiated from left (SI) to
   // right (MI). 
   // Available Modules:
   // 0 = Pass through (just wires)
   // 1 = Register Slice
   // 2 = Subset Converter
   // 3 = Data Width Converter (any)
   // 4 = Data Width Converter (up only)
   // 5 = Data Width Converter (down only)
   // 6 = Clock Converter
   // 7 = Data FIFO
   // 8 = Packer
   parameter integer C_SYNCHRONIZER_STAGE = 2
   )
  (
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////

   // Slave side
   input wire                               S_AXIS_ACLK,
   input wire                               S_AXIS_ARESETN,
   input wire                               S_AXIS_ACLKEN,
   input  wire                              S_AXIS_TVALID,
   output wire                              S_AXIS_TREADY,
   input  wire [C_S_AXIS_TDATA_WIDTH-1:0]   S_AXIS_TDATA,
   input  wire [C_S_AXIS_TDATA_WIDTH/8-1:0] S_AXIS_TSTRB,
   input  wire [C_S_AXIS_TDATA_WIDTH/8-1:0] S_AXIS_TKEEP,
   input  wire                              S_AXIS_TLAST,
   input  wire [C_S_AXIS_TID_WIDTH-1:0]     S_AXIS_TID,
   input  wire [C_S_AXIS_TDEST_WIDTH-1:0]   S_AXIS_TDEST,
   input  wire [C_S_AXIS_TUSER_WIDTH-1:0]   S_AXIS_TUSER,

   // Master side
   input wire                               M_AXIS_ACLK,
   input wire                               M_AXIS_ARESETN,
   input wire                               M_AXIS_ACLKEN,
   output wire                              M_AXIS_TVALID,
   input  wire                              M_AXIS_TREADY,
   output wire [C_M_AXIS_TDATA_WIDTH-1:0]   M_AXIS_TDATA,
   output wire [C_M_AXIS_TDATA_WIDTH/8-1:0] M_AXIS_TSTRB,
   output wire [C_M_AXIS_TDATA_WIDTH/8-1:0] M_AXIS_TKEEP,
   output wire                              M_AXIS_TLAST,
   output wire [C_M_AXIS_TID_WIDTH-1:0]     M_AXIS_TID,
   output wire [C_M_AXIS_TDEST_WIDTH-1:0]   M_AXIS_TDEST,
   output wire [C_M_AXIS_TUSER_WIDTH-1:0]   M_AXIS_TUSER,

   // Status signals
   output wire                              SPARSE_TKEEP_REMOVED,
   output wire                              PACKER_ERR,
   output wire [31:0]                       S_FIFO_DATA_COUNT,
   output wire [31:0]                       M_FIFO_DATA_COUNT 

   );

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
// `include "axis_interconnect_v1_1_18.vh"

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
// Special rule, if doing async clock conversion and using a fifo, then merge
// clock conversion into data fifo
localparam P_CK_CONV_IN_DATA_FIFO = (C_IS_ACLK_ASYNC == 32'd1) && (C_FIFO_MODE == 32'd1) && (C_FIFO_DEPTH > 32'd0);
localparam P_DEFAULT_TLAST = 0; // Set TLAST LOW.

// Dynamic Datapath index values
localparam integer P_INDX_DP_PASS_THRU = 32'd0;
localparam integer P_INDX_DP_REG_SLICE = 32'd1;
localparam integer P_INDX_DP_SS_CONV   = 32'd2;
localparam integer P_INDX_DP_DW_CONV   = 32'd3;
localparam integer P_INDX_DP_DW_CONV_U = 32'd4;
localparam integer P_INDX_DP_DW_CONV_D = 32'd5;
localparam integer P_INDX_DP_CK_CONV   = 32'd6;
localparam integer P_INDX_DP_DATA_FIFO = 32'd7;
localparam integer P_INDX_DP_PACKER    = 32'd8;

// Determine which generates instantiate modules
localparam P_GEN_PASS_THRU = (C_MODULE_ORDER[31:0] == P_INDX_DP_PASS_THRU);
localparam P_GEN_REG_SLICE = (C_MODULE_ORDER[31:0] == P_INDX_DP_REG_SLICE) && (C_REG_CONFIG > 0);
 // TODO: Add cases other than signal subset conversion
localparam P_GEN_SS_CONV   = (C_MODULE_ORDER[31:0] == P_INDX_DP_SS_CONV  ) && (C_S_AXIS_SIGNAL_SET != C_M_AXIS_SIGNAL_SET);
localparam P_GEN_DW_CONV   = (C_MODULE_ORDER[31:0] == P_INDX_DP_DW_CONV  ) && (C_S_AXIS_TDATA_WIDTH != C_M_AXIS_TDATA_WIDTH);
localparam P_GEN_DW_CONV_U = (C_MODULE_ORDER[31:0] == P_INDX_DP_DW_CONV_U) && (C_S_AXIS_TDATA_WIDTH < C_M_AXIS_TDATA_WIDTH);
localparam P_GEN_DW_CONV_D = (C_MODULE_ORDER[31:0] == P_INDX_DP_DW_CONV_D) && (C_S_AXIS_TDATA_WIDTH > C_M_AXIS_TDATA_WIDTH);
localparam P_GEN_CK_CONV   = (C_MODULE_ORDER[31:0] == P_INDX_DP_CK_CONV  ) 
                              && (!P_CK_CONV_IN_DATA_FIFO) 
                              && (C_IS_ACLK_ASYNC == 1 || C_S_AXIS_ACLK_RATIO != C_M_AXIS_ACLK_RATIO);
localparam P_GEN_DATA_FIFO = (C_MODULE_ORDER[31:0] == P_INDX_DP_DATA_FIFO) && (C_FIFO_DEPTH > 0) && (C_FIFO_MODE > 0);
localparam P_GEN_PACKER    = (C_MODULE_ORDER[31:0] == P_INDX_DP_PACKER   ) && 0; // TODO: implmement

localparam P_INT_TDATA_WIDTH   = (P_GEN_DW_CONV || P_GEN_DW_CONV_U || P_GEN_DW_CONV_D) ? C_S_AXIS_TDATA_WIDTH : C_M_AXIS_TDATA_WIDTH;
localparam P_INT_TUSER_WIDTH   = (P_GEN_DW_CONV || P_GEN_DW_CONV_U || P_GEN_DW_CONV_D) ? C_S_AXIS_TUSER_WIDTH : C_M_AXIS_TUSER_WIDTH;
localparam P_INT_TID_WIDTH     = (P_GEN_SS_CONV) ? C_S_AXIS_TID_WIDTH : C_M_AXIS_TID_WIDTH;
localparam P_INT_TDEST_WIDTH   = (P_GEN_SS_CONV) ? C_S_AXIS_TDEST_WIDTH : C_M_AXIS_TDEST_WIDTH;
localparam P_INT_SIGNAL_SET    = (P_GEN_SS_CONV) ? C_S_AXIS_SIGNAL_SET : C_M_AXIS_SIGNAL_SET;
localparam P_INT_IS_ACLK_ASYNC = (P_GEN_CK_CONV || (P_GEN_DATA_FIFO && P_CK_CONV_IN_DATA_FIFO)) ? 0 : C_IS_ACLK_ASYNC;
localparam P_DF_IS_ACLK_ASYNC  = (P_CK_CONV_IN_DATA_FIFO) ? 1 : 0;
localparam P_INT_ACLK_RATIO    = (P_GEN_CK_CONV || (P_GEN_DATA_FIFO && P_CK_CONV_IN_DATA_FIFO)) ? C_S_AXIS_ACLK_RATIO : C_M_AXIS_ACLK_RATIO;
localparam P_INT_FIFO_DEPTH    = (P_GEN_DATA_FIFO) ? 0 : C_FIFO_DEPTH;
localparam P_INT_FIFO_MODE     = (P_GEN_DATA_FIFO) ? 0 : C_FIFO_MODE ;



////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
// Slave interface input  
wire                              int_aclk;
wire                              int_aclken;
wire                              int_aresetn;
wire                              int_tvalid;
wire                              int_tready;
wire [P_INT_TDATA_WIDTH-1:0]      int_tdata;
wire [P_INT_TDATA_WIDTH/8-1:0]    int_tstrb;
wire [P_INT_TDATA_WIDTH/8-1:0]    int_tkeep;
wire                              int_tlast;
wire [P_INT_TID_WIDTH-1:0]        int_tid;
wire [P_INT_TDEST_WIDTH-1:0]      int_tdest;
wire [P_INT_TUSER_WIDTH-1:0]      int_tuser;
wire                              int_sparse_tkeep_removed;
wire                              int_packer_err;
wire [31:0]                       int_s_fifo_data_count;
wire [31:0]                       int_m_fifo_data_count;
wire [31:0]                       int_fifo_data_count; // Unused, but provided for monitoring
wire                              nested_sparse_tkeep_removed;
wire                              nested_packer_err;
wire [31:0]                       nested_s_fifo_data_count;
wire [31:0]                       nested_m_fifo_data_count;

////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////

assign int_aclk    = (P_GEN_CK_CONV || (P_GEN_DATA_FIFO && P_CK_CONV_IN_DATA_FIFO)) ? S_AXIS_ACLK : M_AXIS_ACLK;
assign int_aclken  = (P_GEN_CK_CONV || (P_GEN_DATA_FIFO && P_CK_CONV_IN_DATA_FIFO)) ? S_AXIS_ACLKEN : M_AXIS_ACLKEN;
assign int_aresetn = (P_GEN_CK_CONV || (P_GEN_DATA_FIFO && P_CK_CONV_IN_DATA_FIFO)) ? S_AXIS_ARESETN : M_AXIS_ARESETN;

assign S_FIFO_DATA_COUNT    = (P_GEN_DATA_FIFO) ? int_s_fifo_data_count : nested_s_fifo_data_count;
assign M_FIFO_DATA_COUNT    = (P_GEN_DATA_FIFO || (P_GEN_CK_CONV && (C_FIFO_MODE > 0) && (C_FIFO_DEPTH > 0))) 
                              ? int_m_fifo_data_count : nested_m_fifo_data_count;
assign PACKER_ERR           = (P_GEN_PACKER   ) ? int_packer_err      : nested_packer_err     ;
assign SPARSE_TKEEP_REMOVED = (P_GEN_SS_CONV  ) ? int_sparse_tkeep_removed : nested_sparse_tkeep_removed;

generate 
  if (P_GEN_REG_SLICE) begin : gen_register_slice
    axis_interconnect_v1_1_18_axis_register_slice #(
      .C_FAMILY           ( C_FAMILY               ) ,
      .C_AXIS_TDATA_WIDTH ( C_M_AXIS_TDATA_WIDTH   ) ,
      .C_AXIS_TID_WIDTH   ( C_M_AXIS_TID_WIDTH     ) ,
      .C_AXIS_TDEST_WIDTH ( C_M_AXIS_TDEST_WIDTH   ) ,
      .C_AXIS_TUSER_WIDTH ( C_M_AXIS_TUSER_WIDTH   ) ,
      .C_AXIS_SIGNAL_SET  ( C_M_AXIS_SIGNAL_SET    ) ,
      .C_REG_CONFIG       ( C_REG_CONFIG           )
    )
    axis_register_slice_0
    (
      .ACLK          ( M_AXIS_ACLK    ) ,
      .ACLKEN        ( M_AXIS_ACLKEN  ) ,
      .ARESETN       ( M_AXIS_ARESETN ) ,
      .S_AXIS_TVALID ( int_tvalid     ) ,
      .S_AXIS_TREADY ( int_tready     ) ,
      .S_AXIS_TDATA  ( int_tdata      ) ,
      .S_AXIS_TSTRB  ( int_tstrb      ) ,
      .S_AXIS_TKEEP  ( int_tkeep      ) ,
      .S_AXIS_TLAST  ( int_tlast      ) ,
      .S_AXIS_TID    ( int_tid        ) ,
      .S_AXIS_TDEST  ( int_tdest      ) ,
      .S_AXIS_TUSER  ( int_tuser      ) ,
      .M_AXIS_TVALID ( M_AXIS_TVALID  ) ,
      .M_AXIS_TREADY ( M_AXIS_TREADY  ) ,
      .M_AXIS_TDATA  ( M_AXIS_TDATA   ) ,
      .M_AXIS_TSTRB  ( M_AXIS_TSTRB   ) ,
      .M_AXIS_TKEEP  ( M_AXIS_TKEEP   ) ,
      .M_AXIS_TLAST  ( M_AXIS_TLAST   ) ,
      .M_AXIS_TID    ( M_AXIS_TID     ) ,
      .M_AXIS_TDEST  ( M_AXIS_TDEST   ) ,
      .M_AXIS_TUSER  ( M_AXIS_TUSER   ) 
    );

  end
  else if (P_GEN_SS_CONV) begin : gen_subset_converter
    axis_interconnect_v1_1_18_axis_subset_converter #(
      .C_FAMILY             ( C_FAMILY               ) ,
      .C_AXIS_TDATA_WIDTH   ( C_M_AXIS_TDATA_WIDTH   ) ,
      .C_AXIS_TUSER_WIDTH   ( C_M_AXIS_TUSER_WIDTH   ) ,
      .C_M_AXIS_TID_WIDTH   ( C_M_AXIS_TID_WIDTH     ) ,
      .C_M_AXIS_TDEST_WIDTH ( C_M_AXIS_TDEST_WIDTH   ) ,
      .C_M_AXIS_SIGNAL_SET  ( C_M_AXIS_SIGNAL_SET    ) , 
      .C_S_AXIS_TID_WIDTH   ( C_S_AXIS_TID_WIDTH     ) ,
      .C_S_AXIS_TDEST_WIDTH ( C_S_AXIS_TDEST_WIDTH   ) ,
      .C_S_AXIS_SIGNAL_SET  ( C_S_AXIS_SIGNAL_SET    ) , 
      .C_DEFAULT_TLAST      ( P_DEFAULT_TLAST        )
    )
    axis_subset_converter_0
    (
      .ACLK              ( M_AXIS_ACLK       ) ,
      .ACLKEN            ( M_AXIS_ACLKEN     ) ,
      .ARESETN           ( M_AXIS_ARESETN    ) ,
      .S_AXIS_TVALID     ( int_tvalid        ) ,
      .S_AXIS_TREADY     ( int_tready        ) ,
      .S_AXIS_TDATA      ( int_tdata         ) ,
      .S_AXIS_TSTRB      ( int_tstrb         ) ,
      .S_AXIS_TKEEP      ( int_tkeep         ) ,
      .S_AXIS_TLAST      ( int_tlast         ) ,
      .S_AXIS_TID        ( int_tid           ) ,
      .S_AXIS_TDEST      ( int_tdest         ) ,
      .S_AXIS_TUSER      ( int_tuser         ) ,
      .M_AXIS_TVALID     ( M_AXIS_TVALID     ) ,
      .M_AXIS_TREADY     ( M_AXIS_TREADY     ) ,
      .M_AXIS_TDATA      ( M_AXIS_TDATA      ) ,
      .M_AXIS_TSTRB      ( M_AXIS_TSTRB      ) ,
      .M_AXIS_TKEEP      ( M_AXIS_TKEEP      ) ,
      .M_AXIS_TLAST      ( M_AXIS_TLAST      ) ,
      .M_AXIS_TID        ( M_AXIS_TID        ) ,
      .M_AXIS_TDEST      ( M_AXIS_TDEST      ) ,
      .M_AXIS_TUSER      ( M_AXIS_TUSER      ) ,
      .SPARSE_TKEEP_REMOVED ( int_sparse_tkeep_removed )
    );
  end
  else if (P_GEN_DW_CONV || P_GEN_DW_CONV_U || P_GEN_DW_CONV_D) begin : gen_dwidth_converter
    axis_interconnect_v1_1_18_axis_dwidth_converter #(
      .C_FAMILY             ( C_FAMILY               ) ,
      .C_S_AXIS_TDATA_WIDTH ( P_INT_TDATA_WIDTH      ) ,
      .C_S_AXIS_TUSER_WIDTH ( P_INT_TUSER_WIDTH      ) ,
      .C_M_AXIS_TDATA_WIDTH ( C_M_AXIS_TDATA_WIDTH   ) ,
      .C_M_AXIS_TUSER_WIDTH ( C_M_AXIS_TUSER_WIDTH   ) ,
      .C_AXIS_TID_WIDTH     ( C_M_AXIS_TID_WIDTH     ) ,
      .C_AXIS_TDEST_WIDTH   ( C_M_AXIS_TDEST_WIDTH   ) ,
      .C_AXIS_SIGNAL_SET    ( C_M_AXIS_SIGNAL_SET    )
    )
    axis_dwidth_converter_0
    (
      .ACLK          ( M_AXIS_ACLK    ) ,
      .ACLKEN        ( M_AXIS_ACLKEN  ) ,
      .ARESETN       ( M_AXIS_ARESETN ) ,
      .S_AXIS_TVALID ( int_tvalid     ) ,
      .S_AXIS_TREADY ( int_tready     ) ,
      .S_AXIS_TDATA  ( int_tdata      ) ,
      .S_AXIS_TSTRB  ( int_tstrb      ) ,
      .S_AXIS_TKEEP  ( int_tkeep      ) ,
      .S_AXIS_TLAST  ( int_tlast      ) ,
      .S_AXIS_TID    ( int_tid        ) ,
      .S_AXIS_TDEST  ( int_tdest      ) ,
      .S_AXIS_TUSER  ( int_tuser      ) ,
      .M_AXIS_TVALID ( M_AXIS_TVALID  ) ,
      .M_AXIS_TREADY ( M_AXIS_TREADY  ) ,
      .M_AXIS_TDATA  ( M_AXIS_TDATA   ) ,
      .M_AXIS_TSTRB  ( M_AXIS_TSTRB   ) ,
      .M_AXIS_TKEEP  ( M_AXIS_TKEEP   ) ,
      .M_AXIS_TLAST  ( M_AXIS_TLAST   ) ,
      .M_AXIS_TID    ( M_AXIS_TID     ) ,
      .M_AXIS_TDEST  ( M_AXIS_TDEST   ) ,
      .M_AXIS_TUSER  ( M_AXIS_TUSER   ) 
    );
  end
  else if (P_GEN_CK_CONV) begin : gen_clock_converter
    axis_interconnect_v1_1_18_axis_clock_converter #(
      .C_FAMILY            ( C_FAMILY             ) ,
      .C_AXIS_TDATA_WIDTH  ( C_M_AXIS_TDATA_WIDTH ) ,
      .C_AXIS_TID_WIDTH    ( C_M_AXIS_TID_WIDTH   ) ,
      .C_AXIS_TDEST_WIDTH  ( C_M_AXIS_TDEST_WIDTH ) ,
      .C_AXIS_TUSER_WIDTH  ( C_M_AXIS_TUSER_WIDTH ) ,
      .C_AXIS_SIGNAL_SET   ( C_M_AXIS_SIGNAL_SET  ) ,
      .C_IS_ACLK_ASYNC     ( C_IS_ACLK_ASYNC      ) ,
      .C_S_AXIS_ACLK_RATIO ( C_S_AXIS_ACLK_RATIO  ) ,
      .C_M_AXIS_ACLK_RATIO ( C_M_AXIS_ACLK_RATIO  ) ,
      .C_ACLKEN_CONV_MODE  ( C_ACLKEN_CONV_MODE   ) , 
      .C_SYNCHRONIZER_STAGE ( C_SYNCHRONIZER_STAGE )
    )
    axis_clock_converter_0
    (
      .S_AXIS_ACLK    ( S_AXIS_ACLK    ) ,
      .S_AXIS_ACLKEN  ( S_AXIS_ACLKEN  ) ,
      .S_AXIS_ARESETN ( S_AXIS_ARESETN ) ,
      .S_AXIS_TVALID  ( int_tvalid     ) ,
      .S_AXIS_TREADY  ( int_tready     ) ,
      .S_AXIS_TDATA   ( int_tdata      ) ,
      .S_AXIS_TSTRB   ( int_tstrb      ) ,
      .S_AXIS_TKEEP   ( int_tkeep      ) ,
      .S_AXIS_TLAST   ( int_tlast      ) ,
      .S_AXIS_TID     ( int_tid        ) ,
      .S_AXIS_TDEST   ( int_tdest      ) ,
      .S_AXIS_TUSER   ( int_tuser      ) ,
      .M_AXIS_ACLK    ( M_AXIS_ACLK    ) ,
      .M_AXIS_ARESETN ( M_AXIS_ARESETN ) ,
      .M_AXIS_ACLKEN  ( M_AXIS_ACLKEN  ) ,
      .M_AXIS_TVALID  ( M_AXIS_TVALID  ) ,
      .M_AXIS_TREADY  ( M_AXIS_TREADY  ) ,
      .M_AXIS_TDATA   ( M_AXIS_TDATA   ) ,
      .M_AXIS_TSTRB   ( M_AXIS_TSTRB   ) ,
      .M_AXIS_TKEEP   ( M_AXIS_TKEEP   ) ,
      .M_AXIS_TLAST   ( M_AXIS_TLAST   ) ,
      .M_AXIS_TID     ( M_AXIS_TID     ) ,
      .M_AXIS_TDEST   ( M_AXIS_TDEST   ) ,
      .M_AXIS_TUSER   ( M_AXIS_TUSER   ) 
    );

    if (C_FIFO_MODE > 0 && C_FIFO_DEPTH > 0) begin : gen_rd_fifo_data_count_synchronizer
      reg [31:0] int_rd_fifo_data_count_d1;
      reg [31:0] int_rd_fifo_data_count_d2;

      always @(posedge M_AXIS_ACLK) begin
        if (M_AXIS_ACLKEN) begin 
          int_rd_fifo_data_count_d1 <= nested_m_fifo_data_count;
          int_rd_fifo_data_count_d2 <= int_rd_fifo_data_count_d1;
        end
      end
    
      assign int_m_fifo_data_count = int_rd_fifo_data_count_d2;
    end

  end
  else if (P_GEN_DATA_FIFO) begin : gen_data_fifo
    wire [31:0] int_wr_fifo_data_count;
    axis_interconnect_v1_1_18_axis_data_fifo #(
      .C_FAMILY            ( C_FAMILY             ) ,
      .C_AXIS_TDATA_WIDTH  ( C_M_AXIS_TDATA_WIDTH ) ,
      .C_AXIS_TID_WIDTH    ( C_M_AXIS_TID_WIDTH   ) ,
      .C_AXIS_TDEST_WIDTH  ( C_M_AXIS_TDEST_WIDTH ) ,
      .C_AXIS_TUSER_WIDTH  ( C_M_AXIS_TUSER_WIDTH ) ,
      .C_AXIS_SIGNAL_SET   ( C_M_AXIS_SIGNAL_SET  ) ,
      .C_FIFO_DEPTH        ( C_FIFO_DEPTH         ) ,
      .C_FIFO_MODE         ( C_FIFO_MODE          ) ,
      .C_IS_ACLK_ASYNC     ( P_DF_IS_ACLK_ASYNC   ) ,
      .C_ACLKEN_CONV_MODE  ( C_ACLKEN_CONV_MODE   ) ,
      .C_SYNCHRONIZER_STAGE ( C_SYNCHRONIZER_STAGE )

    )
    axis_data_fifo_0
    (
      .S_AXIS_ARESETN ( int_aresetn    ) ,
      .S_AXIS_ACLK    ( int_aclk       ) ,
      .S_AXIS_ACLKEN  ( int_aclken     ) ,
      .S_AXIS_TVALID  ( int_tvalid     ) ,
      .S_AXIS_TREADY  ( int_tready     ) ,
      .S_AXIS_TDATA   ( int_tdata      ) ,
      .S_AXIS_TSTRB   ( int_tstrb      ) ,
      .S_AXIS_TKEEP   ( int_tkeep      ) ,
      .S_AXIS_TLAST   ( int_tlast      ) ,
      .S_AXIS_TID     ( int_tid        ) ,
      .S_AXIS_TDEST   ( int_tdest      ) ,
      .S_AXIS_TUSER   ( int_tuser      ) ,
      .M_AXIS_ACLK    ( M_AXIS_ACLK    ) ,
      .M_AXIS_ACLKEN  ( M_AXIS_ACLKEN  ) ,
      .M_AXIS_ARESETN ( M_AXIS_ARESETN ) ,
      .M_AXIS_TVALID  ( M_AXIS_TVALID  ) ,
      .M_AXIS_TREADY  ( M_AXIS_TREADY  ) ,
      .M_AXIS_TDATA   ( M_AXIS_TDATA   ) ,
      .M_AXIS_TSTRB   ( M_AXIS_TSTRB   ) ,
      .M_AXIS_TKEEP   ( M_AXIS_TKEEP   ) ,
      .M_AXIS_TLAST   ( M_AXIS_TLAST   ) ,
      .M_AXIS_TID     ( M_AXIS_TID     ) ,
      .M_AXIS_TDEST   ( M_AXIS_TDEST   ) ,
      .M_AXIS_TUSER   ( M_AXIS_TUSER   ) ,
      .AXIS_RD_DATA_COUNT ( int_m_fifo_data_count ) ,
      .AXIS_WR_DATA_COUNT ( int_wr_fifo_data_count ) ,
      .AXIS_DATA_COUNT ( int_fifo_data_count ) 
    );

    // If doing clock conversion in data fifo then axis_wr_data_count already 
    // clocked on S_AXIS_ACLK, otherwise we need to synchronize.
    if (!P_CK_CONV_IN_DATA_FIFO || (C_S_AXIS_ACLK_RATIO == C_M_AXIS_ACLK_RATIO) || C_IS_ACLK_ASYNC) begin : gen_wr_fifo_data_count_passthru
      assign int_s_fifo_data_count = int_wr_fifo_data_count;
    end
    else begin : gen_wr_fifo_data_count_synchronizer
      reg [31:0] int_wr_fifo_data_count_d1;
      reg [31:0] int_wr_fifo_data_count_d2;
      always @(posedge S_AXIS_ACLK) begin
        if (S_AXIS_ACLKEN) begin 
          int_wr_fifo_data_count_d1 <= int_wr_fifo_data_count;
          int_wr_fifo_data_count_d2 <= int_wr_fifo_data_count_d1;
        end
      end

      assign int_s_fifo_data_count = int_wr_fifo_data_count_d2;
    end
  end
  else begin : gen_passthru //  if (C_MODULE_ORDER[31:0] == G_DP_PASS_THRU) begin : gen_passthru
    assign int_tready      = M_AXIS_TREADY;
    assign M_AXIS_TVALID   = int_tvalid;
    assign M_AXIS_TDATA    = int_tdata;
    assign M_AXIS_TSTRB    = int_tstrb;
    assign M_AXIS_TKEEP    = int_tkeep;
    assign M_AXIS_TLAST    = int_tlast;
    assign M_AXIS_TID      = int_tid;
    assign M_AXIS_TDEST    = int_tdest;
    assign M_AXIS_TUSER    = int_tuser;
  end

  // Gens the nesting loop if modulesd still exist
  if ((C_MODULE_ORDER >> 32)) begin : gen_nested
    axis_interconnect_v1_1_18_dynamic_datapath #(
      .C_FAMILY             ( C_FAMILY             ) ,
      .C_S_AXIS_TDATA_WIDTH ( C_S_AXIS_TDATA_WIDTH ) ,
      .C_S_AXIS_TID_WIDTH   ( C_S_AXIS_TID_WIDTH   ) ,
      .C_S_AXIS_TDEST_WIDTH ( C_S_AXIS_TDEST_WIDTH ) ,
      .C_S_AXIS_TUSER_WIDTH ( C_S_AXIS_TUSER_WIDTH ) ,
      .C_S_AXIS_SIGNAL_SET  ( C_S_AXIS_SIGNAL_SET  ) ,
      .C_S_AXIS_ACLK_RATIO  ( C_S_AXIS_ACLK_RATIO  ) ,
      .C_M_AXIS_TDATA_WIDTH ( P_INT_TDATA_WIDTH    ) ,
      .C_M_AXIS_TID_WIDTH   ( P_INT_TID_WIDTH      ) ,
      .C_M_AXIS_TDEST_WIDTH ( P_INT_TDEST_WIDTH    ) ,
      .C_M_AXIS_TUSER_WIDTH ( P_INT_TUSER_WIDTH    ) ,
      .C_M_AXIS_SIGNAL_SET  ( P_INT_SIGNAL_SET     ) ,
      .C_M_AXIS_ACLK_RATIO  ( P_INT_ACLK_RATIO     ) ,
      .C_REG_CONFIG         ( C_REG_CONFIG         ) ,
      .C_IS_ACLK_ASYNC      ( P_INT_IS_ACLK_ASYNC  ) ,
      .C_ACLKEN_CONV_MODE   ( C_ACLKEN_CONV_MODE   ) ,
      .C_FIFO_DEPTH         ( P_INT_FIFO_DEPTH     ) ,
      .C_FIFO_MODE          ( P_INT_FIFO_MODE      ) ,
      .C_MODULE_ORDER       ( C_MODULE_ORDER >> 32 ) ,
      .C_SYNCHRONIZER_STAGE ( C_SYNCHRONIZER_STAGE )
    )
    dynamic_datapath_0
    (
      .S_AXIS_ACLK        ( S_AXIS_ACLK           ) ,
      .S_AXIS_ACLKEN      ( S_AXIS_ACLKEN         ) ,
      .S_AXIS_ARESETN     ( S_AXIS_ARESETN        ) ,
      .S_AXIS_TVALID      ( S_AXIS_TVALID         ) ,
      .S_AXIS_TREADY      ( S_AXIS_TREADY         ) ,
      .S_AXIS_TDATA       ( S_AXIS_TDATA          ) ,
      .S_AXIS_TSTRB       ( S_AXIS_TSTRB          ) ,
      .S_AXIS_TKEEP       ( S_AXIS_TKEEP          ) ,
      .S_AXIS_TLAST       ( S_AXIS_TLAST          ) ,
      .S_AXIS_TID         ( S_AXIS_TID            ) ,
      .S_AXIS_TDEST       ( S_AXIS_TDEST          ) ,
      .S_AXIS_TUSER       ( S_AXIS_TUSER          ) ,
      .M_AXIS_ACLK        ( int_aclk              ) ,
      .M_AXIS_ACLKEN      ( int_aclken            ) ,
      .M_AXIS_ARESETN     ( int_aresetn           ) ,
      .M_AXIS_TVALID      ( int_tvalid            ) ,
      .M_AXIS_TREADY      ( int_tready            ) ,
      .M_AXIS_TDATA       ( int_tdata             ) ,
      .M_AXIS_TSTRB       ( int_tstrb             ) ,
      .M_AXIS_TKEEP       ( int_tkeep             ) ,
      .M_AXIS_TLAST       ( int_tlast             ) ,
      .M_AXIS_TID         ( int_tid               ) ,
      .M_AXIS_TDEST       ( int_tdest             ) ,
      .M_AXIS_TUSER       ( int_tuser             ) ,
      .SPARSE_TKEEP_REMOVED ( nested_sparse_tkeep_removed   ) ,
      .PACKER_ERR         ( nested_packer_err        ) ,
      .S_FIFO_DATA_COUNT    ( nested_s_fifo_data_count   ),
      .M_FIFO_DATA_COUNT    ( nested_m_fifo_data_count   ) 

    );
  end else begin : no_next
    assign S_AXIS_TREADY = int_tready;
    assign int_tvalid = S_AXIS_TVALID;
    assign int_tdata  = S_AXIS_TDATA;
    assign int_tstrb  = S_AXIS_TSTRB;
    assign int_tkeep  = S_AXIS_TKEEP;
    assign int_tlast  = S_AXIS_TLAST;
    assign int_tid    = S_AXIS_TID;
    assign int_tdest  = S_AXIS_TDEST;
    assign int_tuser  = S_AXIS_TUSER;
    assign nested_sparse_tkeep_removed = 1'b0;
    assign nested_packer_err = 1'b0;
    assign nested_s_fifo_data_count = 32'h0;
    assign nested_m_fifo_data_count = 32'h0;
  end
endgenerate

endmodule // dynamic_datapath

`default_nettype wire


//  (c) Copyright 2011-2013 Xilinx, Inc. All rights reserved.
//
//  This file contains confidential and proprietary information
//  of Xilinx, Inc. and is protected under U.S. and
//  international copyright and other intellectual property
//  laws.
//
//  DISCLAIMER
//  This disclaimer is not a license and does not grant any
//  rights to the materials distributed herewith. Except as
//  otherwise provided in a valid license issued to you by
//  Xilinx, and to the maximum extent permitted by applicable
//  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
//  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//  (2) Xilinx shall not be liable (whether in contract or tort,
//  including negligence, or under any other theory of
//  liability) for any loss or damage of any kind or nature
//  related to, arising under or in connection with these
//  materials, including for any direct, or any indirect,
//  special, incidental, or consequential loss or damage
//  (including loss of data, profits, goodwill, or any type of
//  loss or damage suffered as a result of any action brought
//  by a third party) even if such damage or loss was
//  reasonably foreseeable or Xilinx had been advised of the
//  possibility of the same.
//
//  CRITICAL APPLICATIONS
//  Xilinx products are not designed or intended to be fail-
//  safe, or for use in any application requiring fail-safe
//  performance, such as life-support or safety devices or
//  systems, Class III medical devices, nuclear facilities,
//  applications related to the deployment of airbags, or any
//  other applications that could lead to death, personal
//  injury, or severe property or environmental damage
//  (individually and collectively, "Critical
//  Applications"). Customer assumes the sole risk and
//  liability of any use of Xilinx products in Critical
//  Applications, subject only to applicable laws and
//  regulations governing limitations on product liability.
//
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//  PART OF THIS FILE AT ALL TIMES. 
//-----------------------------------------------------------------------------
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axis_interconnect
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_axis_interconnect #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   // C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional signals are present
   //   [0] => TREADY present
   //   [1] => TDATA present
   //   [2] => TSTRB present, TDATA must be present
   //   [3] => TKEEP present, TDATA must be present
   //   [4] => TLAST present
   //   [5] => TID present
   //   [6] => TDEST present
   //   [7] => TUSER present
   // Generate Parameters
   parameter         C_FAMILY               = "virtex7",
                                                     
   parameter integer C_NUM_MI_SLOTS         = 1,
   parameter integer C_NUM_SI_SLOTS         = 1,
                                                     
   parameter integer C_AXIS_TDATA_MAX_WIDTH = 8,
   parameter integer C_AXIS_TUSER_MAX_WIDTH = 1,

   parameter integer C_SWITCH_MI_REG_CONFIG = 0,
   parameter integer C_SWITCH_SI_REG_CONFIG = 1,
   parameter integer C_SWITCH_MODE          = 33,
   // C_SWITCH_MODE
   // 0 - External Arbiter
   // 1 - Internal Arbiter: Round Robin
   // 2 - Internal Arbiter: Fixed
   // 3-31 - Internal Arbiter: Reserved
   // 32 - External Arbiter: Packet Mode
   // 33 - Internal Arbiter: Round Robin: Packet Mode
   // 34 - Internal Arbiter: Fixed: Packet Mode
   // 35 - Internal Arbiter: Reserved: Packet Mode
   parameter integer C_SWITCH_MAX_XFERS_PER_ARB = 0,
   // C_MAX_XFERS_PER_ARB: 
   //  0 => Ignore number of transfers to signal DONE
   //  1+ => Signal ARB_DONE after x TRANSFERS
   parameter integer C_SWITCH_NUM_CYCLES_TIMEOUT = 0,
   // C_NUM_CYCLE_TIMEOUT: 
   //  0 => Ignore TIMEOUT parameter
   //  1+ => Signal ARB_DONE after x cylces of TVALID low

   // Switch Parameters
   parameter integer C_SWITCH_TDATA_WIDTH     = 32,
   parameter integer C_SWITCH_TID_WIDTH       = 1,
   parameter integer C_SWITCH_TDEST_WIDTH     = 1,
   parameter integer C_SWITCH_TUSER_WIDTH     = 1,
   parameter [31:0]  C_SWITCH_SIGNAL_SET      = 32'h7F,
   parameter integer C_SWITCH_ACLK_RATIO      = 1,
   parameter integer C_SWITCH_USE_ACLKEN      = 0,
   parameter integer C_SYNCHRONIZER_STAGE     = 2,
   parameter [C_NUM_MI_SLOTS*C_NUM_SI_SLOTS-1:0] C_M_AXIS_CONNECTIVITY_ARRAY = {C_NUM_MI_SLOTS*C_NUM_SI_SLOTS{1'b1}},
   parameter [C_NUM_MI_SLOTS*C_SWITCH_TDEST_WIDTH-1:0] C_M_AXIS_BASETDEST_ARRAY = {2'b11,2'b10,2'b01,2'b00},
   parameter [C_NUM_MI_SLOTS*C_SWITCH_TDEST_WIDTH-1:0] C_M_AXIS_HIGHTDEST_ARRAY = {2'b11,2'b10,2'b01,2'b00},


   // Datapath parameters
   parameter [C_NUM_SI_SLOTS*32-1:0] C_S_AXIS_TDATA_WIDTH_ARRAY    = {C_NUM_SI_SLOTS{32'd8}},
   parameter [C_NUM_SI_SLOTS*32-1:0] C_S_AXIS_TUSER_WIDTH_ARRAY    = {C_NUM_SI_SLOTS{32'd1}},
   parameter [C_NUM_SI_SLOTS*32-1:0] C_S_AXIS_IS_ACLK_ASYNC_ARRAY  = {C_NUM_SI_SLOTS{32'd0}},
   parameter [C_NUM_SI_SLOTS*32-1:0] C_S_AXIS_ACLK_RATIO_ARRAY     = {C_NUM_SI_SLOTS{32'd1}},
   parameter [C_NUM_SI_SLOTS*32-1:0] C_S_AXIS_REG_CONFIG_ARRAY     = {C_NUM_SI_SLOTS{32'd1}},
   parameter [C_NUM_SI_SLOTS*32-1:0] C_S_AXIS_FIFO_DEPTH_ARRAY     = {C_NUM_SI_SLOTS{32'd32}},
   parameter [C_NUM_SI_SLOTS*32-1:0] C_S_AXIS_FIFO_MODE_ARRAY      = {C_NUM_SI_SLOTS{32'd0}},

   parameter [C_NUM_MI_SLOTS*32-1:0] C_M_AXIS_TDATA_WIDTH_ARRAY    = {C_NUM_MI_SLOTS{32'd8}},
   parameter [C_NUM_MI_SLOTS*32-1:0] C_M_AXIS_TUSER_WIDTH_ARRAY    = {C_NUM_MI_SLOTS{32'd1}},
   parameter [C_NUM_MI_SLOTS*32-1:0] C_M_AXIS_ACLK_RATIO_ARRAY     = {C_NUM_MI_SLOTS{32'd1}},
   parameter [C_NUM_MI_SLOTS*32-1:0] C_M_AXIS_REG_CONFIG_ARRAY     = {C_NUM_MI_SLOTS{32'd1}},
   parameter [C_NUM_MI_SLOTS*32-1:0] C_M_AXIS_IS_ACLK_ASYNC_ARRAY  = {C_NUM_MI_SLOTS{32'd0}},
   parameter [C_NUM_MI_SLOTS*32-1:0] C_M_AXIS_FIFO_DEPTH_ARRAY     = {C_NUM_MI_SLOTS{32'd32}},
   parameter [C_NUM_MI_SLOTS*32-1:0] C_M_AXIS_FIFO_MODE_ARRAY      = {C_NUM_MI_SLOTS{32'd0}}

   )
  (
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
   // System Signals
   input wire ACLK,
   input wire ARESETN,
   input wire ACLKEN,

   // Slave side
   input wire  [C_NUM_SI_SLOTS*1-1:0]                        S_AXIS_ACLK,
   input wire  [C_NUM_SI_SLOTS*1-1:0]                        S_AXIS_ARESETN,
   input wire  [C_NUM_SI_SLOTS*1-1:0]                        S_AXIS_ACLKEN,
   input  wire [C_NUM_SI_SLOTS*1-1:0]                        S_AXIS_TVALID,
   output wire [C_NUM_SI_SLOTS*1-1:0]                        S_AXIS_TREADY,
   input  wire [C_NUM_SI_SLOTS*C_AXIS_TDATA_MAX_WIDTH-1:0]   S_AXIS_TDATA,
   input  wire [C_NUM_SI_SLOTS*C_AXIS_TDATA_MAX_WIDTH/8-1:0] S_AXIS_TSTRB,
   input  wire [C_NUM_SI_SLOTS*C_AXIS_TDATA_MAX_WIDTH/8-1:0] S_AXIS_TKEEP,
   input  wire [C_NUM_SI_SLOTS*1-1:0]                        S_AXIS_TLAST,
   input  wire [C_NUM_SI_SLOTS*C_SWITCH_TID_WIDTH-1:0]       S_AXIS_TID,
   input  wire [C_NUM_SI_SLOTS*C_SWITCH_TDEST_WIDTH-1:0]     S_AXIS_TDEST,
   input  wire [C_NUM_SI_SLOTS*C_AXIS_TUSER_MAX_WIDTH-1:0]   S_AXIS_TUSER,

   // Master side
   input wire  [C_NUM_MI_SLOTS*1-1:0]                        M_AXIS_ACLK,
   input wire  [C_NUM_MI_SLOTS*1-1:0]                        M_AXIS_ARESETN,
   input wire  [C_NUM_MI_SLOTS*1-1:0]                        M_AXIS_ACLKEN,
   output wire [C_NUM_MI_SLOTS*1-1:0]                        M_AXIS_TVALID,
   input  wire [C_NUM_MI_SLOTS*1-1:0]                        M_AXIS_TREADY,
   output wire [C_NUM_MI_SLOTS*C_AXIS_TDATA_MAX_WIDTH-1:0]   M_AXIS_TDATA,
   output wire [C_NUM_MI_SLOTS*C_AXIS_TDATA_MAX_WIDTH/8-1:0] M_AXIS_TSTRB,
   output wire [C_NUM_MI_SLOTS*C_AXIS_TDATA_MAX_WIDTH/8-1:0] M_AXIS_TKEEP,
   output wire [C_NUM_MI_SLOTS*1-1:0]                        M_AXIS_TLAST,
   output wire [C_NUM_MI_SLOTS*C_SWITCH_TID_WIDTH-1:0]       M_AXIS_TID,
   output wire [C_NUM_MI_SLOTS*C_SWITCH_TDEST_WIDTH-1:0]     M_AXIS_TDEST,
   output wire [C_NUM_MI_SLOTS*C_AXIS_TUSER_MAX_WIDTH-1:0]   M_AXIS_TUSER,

   // Control/Status signals
   input wire  [C_NUM_SI_SLOTS*1-1:0]                        S_ARB_REQ_SUPPRESS,
   output wire [C_NUM_SI_SLOTS*1-1:0]                        S_DECODE_ERR,
   output wire [C_NUM_SI_SLOTS*1-1:0]                        S_SPARSE_TKEEP_REMOVED,
   output wire [C_NUM_SI_SLOTS*1-1:0]                        S_PACKER_ERR,
   output wire [C_NUM_SI_SLOTS*32-1:0]                       S_FIFO_DATA_COUNT,
   output wire [C_NUM_MI_SLOTS*1-1:0]                        M_SPARSE_TKEEP_REMOVED,
   output wire [C_NUM_MI_SLOTS*1-1:0]                        M_PACKER_ERR,
   output wire [C_NUM_MI_SLOTS*32-1:0]                       M_FIFO_DATA_COUNT
   );

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
 `include "axis_interconnect_v1_1_18.vh"

////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
// Dynamic Datapath index values
localparam integer P_INDX_DP_PASS_THRU = 32'd0;
localparam integer P_INDX_DP_REG_SLICE = 32'd1;
localparam integer P_INDX_DP_SS_CONV   = 32'd2;
localparam integer P_INDX_DP_DW_CONV   = 32'd3;
localparam integer P_INDX_DP_DW_CONV_U = 32'd4;
localparam integer P_INDX_DP_DW_CONV_D = 32'd5;
localparam integer P_INDX_DP_CK_CONV   = 32'd6;
localparam integer P_INDX_DP_DATA_FIFO = 32'd7;
localparam integer P_INDX_DP_PACKER    = 32'd8;

localparam P_LOG_SI_SLOTS = f_clogb2(C_NUM_SI_SLOTS);
localparam P_GEN_SWITCH = (C_NUM_MI_SLOTS == 1) && (C_NUM_SI_SLOTS == 1) ? 0 : 1;

localparam [31:0]  P_SS_TKEEP_REQUIRED = (C_SWITCH_SIGNAL_SET & (G_MASK_SS_TID | G_MASK_SS_TDEST | G_MASK_SS_TLAST)) 
                                          ? G_MASK_SS_TKEEP : 32'h0;
// TREADY/TDATA must always be present
localparam [31:0]  P_SWITCH_SIGNAL_SET  = C_SWITCH_SIGNAL_SET | P_SS_TKEEP_REQUIRED;
localparam [31:0]  P_SI_SIGNAL_SET = C_SWITCH_SIGNAL_SET;
localparam [31:0]  P_MI_SIGNAL_SET = C_SWITCH_SIGNAL_SET;
localparam [31:0]  P_ACLKEN_CONV_MODE = C_SWITCH_USE_ACLKEN ? 3 : 0;


// Define the order of the modules in the dynamic datapath.  Instantied from
// left to right.
localparam P_SI_MODULE_ORDER = { 
                                 P_INDX_DP_SS_CONV,
                                 P_INDX_DP_REG_SLICE,
                                 P_INDX_DP_DW_CONV_U,
                                 P_INDX_DP_CK_CONV,
                                 P_INDX_DP_DW_CONV_D,
                                 P_INDX_DP_PACKER,
                                 P_INDX_DP_DATA_FIFO
                               };

localparam P_MI_MODULE_ORDER = { 
                                 P_INDX_DP_DATA_FIFO,
                                 P_INDX_DP_DW_CONV_U,
                                 P_INDX_DP_CK_CONV,
                                 P_INDX_DP_DW_CONV_D,
                                 P_INDX_DP_PACKER,
                                 P_INDX_DP_SS_CONV,
                                 P_INDX_DP_REG_SLICE
                               };
                               
////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////

wire [C_NUM_SI_SLOTS-1:0]                        si_tvalid;
wire [C_NUM_SI_SLOTS-1:0]                        si_tready;
wire [C_NUM_SI_SLOTS*C_SWITCH_TDATA_WIDTH-1:0]   si_tdata;
wire [C_NUM_SI_SLOTS*C_SWITCH_TDATA_WIDTH/8-1:0] si_tstrb;
wire [C_NUM_SI_SLOTS*C_SWITCH_TDATA_WIDTH/8-1:0] si_tkeep;
wire [C_NUM_SI_SLOTS-1:0]                        si_tlast;
wire [C_NUM_SI_SLOTS*C_SWITCH_TID_WIDTH-1:0]     si_tid;
wire [C_NUM_SI_SLOTS*C_SWITCH_TDEST_WIDTH-1:0]   si_tdest;
wire [C_NUM_SI_SLOTS*C_SWITCH_TUSER_WIDTH-1:0]   si_tuser;

wire [C_NUM_MI_SLOTS-1:0]                        mi_tvalid;
wire [C_NUM_MI_SLOTS-1:0]                        mi_tready;
wire [C_NUM_MI_SLOTS*C_SWITCH_TDATA_WIDTH-1:0]   mi_tdata;
wire [C_NUM_MI_SLOTS*C_SWITCH_TDATA_WIDTH/8-1:0] mi_tstrb;
wire [C_NUM_MI_SLOTS*C_SWITCH_TDATA_WIDTH/8-1:0] mi_tkeep;
wire [C_NUM_MI_SLOTS-1:0]                        mi_tlast;
wire [C_NUM_MI_SLOTS*C_SWITCH_TID_WIDTH-1:0]     mi_tid;
wire [C_NUM_MI_SLOTS*C_SWITCH_TDEST_WIDTH-1:0]   mi_tdest;
wire [C_NUM_MI_SLOTS*C_SWITCH_TUSER_WIDTH-1:0]   mi_tuser;

// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////

// Instantiate switch
generate
  genvar si; 
  genvar mi;
  if (P_GEN_SWITCH) begin : gen_switch
    axis_interconnect_v1_1_18_axis_switch #(
      .C_FAMILY                    ( C_FAMILY                    ) ,
      .C_AXIS_TDATA_WIDTH          ( C_SWITCH_TDATA_WIDTH        ) ,
      .C_AXIS_TID_WIDTH            ( C_SWITCH_TID_WIDTH          ) ,
      .C_AXIS_TDEST_WIDTH          ( C_SWITCH_TDEST_WIDTH        ) ,
      .C_AXIS_TUSER_WIDTH          ( C_SWITCH_TUSER_WIDTH        ) ,
      .C_AXIS_SIGNAL_SET           ( P_SWITCH_SIGNAL_SET         ) ,
      .C_SI_REG_CONFIG             ( C_SWITCH_SI_REG_CONFIG      ) ,
      .C_MI_REG_CONFIG             ( C_SWITCH_MI_REG_CONFIG      ) ,
      .C_NUM_SI_SLOTS              ( C_NUM_SI_SLOTS              ) ,
      .C_LOG_SI_SLOTS              ( P_LOG_SI_SLOTS              ) ,
      .C_NUM_MI_SLOTS              ( C_NUM_MI_SLOTS              ) ,
      .C_SWITCH_MODE               ( C_SWITCH_MODE               ) ,
      .C_MAX_XFERS_PER_ARB         ( C_SWITCH_MAX_XFERS_PER_ARB  ) ,
      .C_NUM_CYCLES_TIMEOUT        ( C_SWITCH_NUM_CYCLES_TIMEOUT ) ,
      .C_M_AXIS_CONNECTIVITY_ARRAY ( C_M_AXIS_CONNECTIVITY_ARRAY ) ,
      .C_M_AXIS_BASETDEST_ARRAY    ( C_M_AXIS_BASETDEST_ARRAY    ) ,
      .C_M_AXIS_HIGHTDEST_ARRAY    ( C_M_AXIS_HIGHTDEST_ARRAY    ) 
    )
    axis_switch_0 ( 
      .ACLK          ( ACLK            ) ,
      .ARESETN       ( ARESETN         ) ,
      .ACLKEN        ( C_SWITCH_USE_ACLKEN ? ACLKEN : 1'b1 ) ,
      .S_AXIS_TVALID ( si_tvalid       ) ,
      .S_AXIS_TREADY ( si_tready       ) ,
      .S_AXIS_TDATA  ( si_tdata        ) ,
      .S_AXIS_TSTRB  ( si_tstrb        ) ,
      .S_AXIS_TKEEP  ( si_tkeep        ) ,
      .S_AXIS_TLAST  ( si_tlast        ) ,
      .S_AXIS_TID    ( si_tid          ) ,
      .S_AXIS_TDEST  ( si_tdest        ) ,
      .S_AXIS_TUSER  ( si_tuser        ) ,
      .M_AXIS_TVALID ( mi_tvalid       ) ,
      .M_AXIS_TREADY ( mi_tready       ) ,
      .M_AXIS_TDATA  ( mi_tdata        ) ,
      .M_AXIS_TSTRB  ( mi_tstrb        ) ,
      .M_AXIS_TKEEP  ( mi_tkeep        ) ,
      .M_AXIS_TLAST  ( mi_tlast        ) ,
      .M_AXIS_TID    ( mi_tid          ) ,
      .M_AXIS_TDEST  ( mi_tdest        ) ,
      .M_AXIS_TUSER  ( mi_tuser        ) ,
      .ARB_REQ       (                 ) ,
      .ARB_GNT       (                 ) ,
      .ARB_BUSY      (                 ) ,
      .ARB_LAST      (                 ) ,
      .ARB_ID        (                 ) ,
      .ARB_DEST      (                 ) ,
      .ARB_USER      (                 ) ,
      .ARB_REQ_SUPPRESS ( S_ARB_REQ_SUPPRESS ) ,
      .S_DECODE_ERR  ( S_DECODE_ERR    ) 
    );
  end
  else begin : gen_no_switch
    assign si_tready = mi_tready;
    assign mi_tvalid = si_tvalid;
    assign mi_tdata  = si_tdata;
    assign mi_tstrb  = si_tstrb;
    assign mi_tkeep  = si_tkeep;
    assign mi_tlast  = si_tlast;
    assign mi_tid    = si_tid;
    assign mi_tdest  = si_tdest;
    assign mi_tuser  = si_tuser;
    assign S_DECODE_ERR = 1'b0;
  end

  for (si = 0 ; si < C_NUM_SI_SLOTS; si = si + 1) begin : inst_si_datapath
    axis_interconnect_v1_1_18_dynamic_datapath # ( 
      .C_FAMILY             ( C_FAMILY                                   ) ,
      .C_S_AXIS_TDATA_WIDTH ( C_S_AXIS_TDATA_WIDTH_ARRAY [ si*32+:32 ]   ) ,
      .C_S_AXIS_TID_WIDTH   ( C_SWITCH_TID_WIDTH                         ) ,
      .C_S_AXIS_TDEST_WIDTH ( C_SWITCH_TDEST_WIDTH                       ) ,
      .C_S_AXIS_TUSER_WIDTH ( C_S_AXIS_TUSER_WIDTH_ARRAY [ si*32+:32 ]   ) ,
      .C_S_AXIS_SIGNAL_SET  ( P_SI_SIGNAL_SET                            ) ,
      .C_S_AXIS_ACLK_RATIO  ( C_S_AXIS_ACLK_RATIO_ARRAY  [ si*32+:32 ]   ) ,
      .C_M_AXIS_TDATA_WIDTH ( C_SWITCH_TDATA_WIDTH                       ) ,
      .C_M_AXIS_TID_WIDTH   ( C_SWITCH_TID_WIDTH                         ) ,
      .C_M_AXIS_TDEST_WIDTH ( C_SWITCH_TDEST_WIDTH                       ) ,
      .C_M_AXIS_TUSER_WIDTH ( C_SWITCH_TUSER_WIDTH                       ) ,
      .C_M_AXIS_SIGNAL_SET  ( P_SWITCH_SIGNAL_SET                        ) ,
      .C_M_AXIS_ACLK_RATIO  ( C_SWITCH_ACLK_RATIO                        ) ,
      .C_ACLKEN_CONV_MODE   ( P_ACLKEN_CONV_MODE                         ) ,
      .C_REG_CONFIG         ( C_S_AXIS_REG_CONFIG_ARRAY    [ si*32+:32 ] ) ,
      .C_IS_ACLK_ASYNC      ( C_S_AXIS_IS_ACLK_ASYNC_ARRAY [ si*32+:32 ] ) ,
      .C_FIFO_DEPTH         ( C_S_AXIS_FIFO_DEPTH_ARRAY    [ si*32+:32 ] ) ,
      .C_FIFO_MODE          ( C_S_AXIS_FIFO_MODE_ARRAY     [ si*32+:32 ] ) ,
      .C_MODULE_ORDER       ( P_SI_MODULE_ORDER                          ) ,
      .C_SYNCHRONIZER_STAGE ( C_SYNCHRONIZER_STAGE                       )
    )
    dynamic_datapath_si ( 
      .S_AXIS_ACLK       ( S_AXIS_ACLK       [ si                                                               ] ) ,
      .S_AXIS_ARESETN    ( S_AXIS_ARESETN    [ si                                                               ] ) ,
      .S_AXIS_ACLKEN     ( C_SWITCH_USE_ACLKEN ? S_AXIS_ACLKEN [ si ] : 1'b1                                      ) ,
      .S_AXIS_TVALID     ( S_AXIS_TVALID     [ si                                                               ] ) ,
      .S_AXIS_TREADY     ( S_AXIS_TREADY     [ si                                                               ] ) ,
      .S_AXIS_TDATA      ( S_AXIS_TDATA      [ si*C_AXIS_TDATA_MAX_WIDTH+:C_S_AXIS_TDATA_WIDTH_ARRAY[si*32+:32] ] ) ,
      .S_AXIS_TSTRB      ( S_AXIS_TSTRB      [ si*C_AXIS_TDATA_MAX_WIDTH/8+:C_S_AXIS_TDATA_WIDTH_ARRAY[si*32+:32]/8 ] ) ,
      .S_AXIS_TKEEP      ( S_AXIS_TKEEP      [ si*C_AXIS_TDATA_MAX_WIDTH/8+:C_S_AXIS_TDATA_WIDTH_ARRAY[si*32+:32]/8 ] ) ,
      .S_AXIS_TLAST      ( S_AXIS_TLAST      [ si                                                               ] ) ,
      .S_AXIS_TID        ( S_AXIS_TID        [ si*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH                      ] ) ,
      .S_AXIS_TDEST      ( S_AXIS_TDEST      [ si*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH                  ] ) ,
      .S_AXIS_TUSER      ( S_AXIS_TUSER      [ si*C_AXIS_TUSER_MAX_WIDTH+:C_S_AXIS_TUSER_WIDTH_ARRAY[si*32+:32] ] ) ,
      .M_AXIS_ACLK       ( ACLK                                                                         ) ,
      .M_AXIS_ARESETN    ( ARESETN                                                                      ) ,
      .M_AXIS_ACLKEN     ( C_SWITCH_USE_ACLKEN ? ACLKEN : 1'b1                                      ) ,
      .M_AXIS_TVALID     ( si_tvalid         [ si                                                ]  ) ,
      .M_AXIS_TREADY     ( si_tready         [ si                                                ]  ) ,
      .M_AXIS_TDATA      ( si_tdata          [ si*C_SWITCH_TDATA_WIDTH+:  C_SWITCH_TDATA_WIDTH   ]  ) ,
      .M_AXIS_TSTRB      ( si_tstrb          [ si*C_SWITCH_TDATA_WIDTH/8+:C_SWITCH_TDATA_WIDTH/8 ]  ) ,
      .M_AXIS_TKEEP      ( si_tkeep          [ si*C_SWITCH_TDATA_WIDTH/8+:C_SWITCH_TDATA_WIDTH/8 ]  ) ,
      .M_AXIS_TLAST      ( si_tlast          [ si                                                ]  ) ,
      .M_AXIS_TID        ( si_tid            [ si*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH         ]  ) ,
      .M_AXIS_TDEST      ( si_tdest          [ si*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH     ]  ) ,
      .M_AXIS_TUSER      ( si_tuser          [ si*C_SWITCH_TUSER_WIDTH+:C_SWITCH_TUSER_WIDTH     ]  ) ,
      .SPARSE_TKEEP_REMOVED ( S_SPARSE_TKEEP_REMOVED [ si ]                                         ) ,
      .PACKER_ERR        ( S_PACKER_ERR      [ si                                                ]  ) ,
      .M_FIFO_DATA_COUNT (                                                                          ) ,
      .S_FIFO_DATA_COUNT ( S_FIFO_DATA_COUNT [ si*32+:32                                         ]  )
    );
  end
  for (mi = 0 ; mi < C_NUM_MI_SLOTS; mi = mi + 1) begin : inst_mi_datapath
    axis_interconnect_v1_1_18_dynamic_datapath # ( 
      .C_FAMILY             ( C_FAMILY                                    ) ,
      .C_S_AXIS_TDATA_WIDTH ( C_SWITCH_TDATA_WIDTH                        ) ,
      .C_S_AXIS_TID_WIDTH   ( C_SWITCH_TID_WIDTH                          ) ,
      .C_S_AXIS_TDEST_WIDTH ( C_SWITCH_TDEST_WIDTH                        ) ,
      .C_S_AXIS_TUSER_WIDTH ( C_SWITCH_TUSER_WIDTH                        ) ,
      .C_S_AXIS_SIGNAL_SET  ( P_SWITCH_SIGNAL_SET                         ) ,
      .C_S_AXIS_ACLK_RATIO  ( C_SWITCH_ACLK_RATIO                         ) ,
      .C_ACLKEN_CONV_MODE   ( P_ACLKEN_CONV_MODE                          ) ,
      .C_M_AXIS_TDATA_WIDTH ( C_M_AXIS_TDATA_WIDTH_ARRAY   [ mi*32+:32 ]  ) ,
      .C_M_AXIS_TID_WIDTH   ( C_SWITCH_TID_WIDTH                          ) ,
      .C_M_AXIS_TDEST_WIDTH ( C_SWITCH_TDEST_WIDTH                        ) ,
      .C_M_AXIS_TUSER_WIDTH ( C_M_AXIS_TUSER_WIDTH_ARRAY   [ mi*32+:32 ]  ) ,
      .C_M_AXIS_SIGNAL_SET  ( P_MI_SIGNAL_SET                             ) ,
      .C_M_AXIS_ACLK_RATIO  ( C_M_AXIS_ACLK_RATIO_ARRAY    [ mi*32+:32 ]  ) ,
      .C_REG_CONFIG         ( C_M_AXIS_REG_CONFIG_ARRAY    [ mi*32+:32 ]  ) ,
      .C_IS_ACLK_ASYNC      ( C_M_AXIS_IS_ACLK_ASYNC_ARRAY [ mi*32+:32 ]  ) ,
      .C_FIFO_DEPTH         ( C_M_AXIS_FIFO_DEPTH_ARRAY    [ mi*32+:32 ]  ) ,
      .C_FIFO_MODE          ( C_M_AXIS_FIFO_MODE_ARRAY     [ mi*32+:32 ]  ) ,
      .C_MODULE_ORDER       ( P_MI_MODULE_ORDER                           ) ,
      .C_SYNCHRONIZER_STAGE ( C_SYNCHRONIZER_STAGE                        )
    )
    dynamic_datapath_mi ( 
      .S_AXIS_ACLK       ( ACLK                                                                                          ) ,
      .S_AXIS_ARESETN    ( ARESETN                                                                                       ) ,
      .S_AXIS_ACLKEN     ( C_SWITCH_USE_ACLKEN ? ACLKEN : 1'b1                                                           ) ,
      .S_AXIS_TVALID     ( mi_tvalid            [ mi                                                                   ] ) ,
      .S_AXIS_TREADY     ( mi_tready            [ mi                                                                   ] ) ,
      .S_AXIS_TDATA      ( mi_tdata             [ mi*C_SWITCH_TDATA_WIDTH+:C_SWITCH_TDATA_WIDTH                        ] ) ,
      .S_AXIS_TSTRB      ( mi_tstrb             [ mi*C_SWITCH_TDATA_WIDTH/8+:C_SWITCH_TDATA_WIDTH/8                    ] ) ,
      .S_AXIS_TKEEP      ( mi_tkeep             [ mi*C_SWITCH_TDATA_WIDTH/8+:C_SWITCH_TDATA_WIDTH/8                    ] ) ,
      .S_AXIS_TLAST      ( mi_tlast             [ mi                                                                   ] ) ,
      .S_AXIS_TID        ( mi_tid               [ mi*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH                            ] ) ,
      .S_AXIS_TDEST      ( mi_tdest             [ mi*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH                        ] ) ,
      .S_AXIS_TUSER      ( mi_tuser             [ mi*C_SWITCH_TUSER_WIDTH+:C_SWITCH_TUSER_WIDTH                        ] ) ,
      .M_AXIS_ACLK       ( M_AXIS_ACLK          [ mi                                                                   ] ) ,
      .M_AXIS_ARESETN    ( M_AXIS_ARESETN       [ mi                                                                   ] ) ,
      .M_AXIS_ACLKEN     ( C_SWITCH_USE_ACLKEN ? M_AXIS_ACLKEN [ mi ]  : 1'b1                                            ) ,
      .M_AXIS_TVALID     ( M_AXIS_TVALID        [ mi                                                                   ] ) ,
      .M_AXIS_TREADY     ( M_AXIS_TREADY        [ mi                                                                   ] ) ,
      .M_AXIS_TDATA      ( M_AXIS_TDATA         [ mi*C_AXIS_TDATA_MAX_WIDTH+:C_M_AXIS_TDATA_WIDTH_ARRAY[mi*32+:32]     ] ) ,
      .M_AXIS_TSTRB      ( M_AXIS_TSTRB         [ mi*C_AXIS_TDATA_MAX_WIDTH/8+:C_M_AXIS_TDATA_WIDTH_ARRAY[mi*32+:32]/8 ] ) ,
      .M_AXIS_TKEEP      ( M_AXIS_TKEEP         [ mi*C_AXIS_TDATA_MAX_WIDTH/8+:C_M_AXIS_TDATA_WIDTH_ARRAY[mi*32+:32]/8 ] ) ,
      .M_AXIS_TLAST      ( M_AXIS_TLAST         [ mi                                                                   ] ) ,
      .M_AXIS_TID        ( M_AXIS_TID           [ mi*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH                              ] ) ,
      .M_AXIS_TDEST      ( M_AXIS_TDEST         [ mi*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH                          ] ) ,
      .M_AXIS_TUSER      ( M_AXIS_TUSER         [ mi*C_AXIS_TUSER_MAX_WIDTH+:C_M_AXIS_TUSER_WIDTH_ARRAY[mi*32+:32]     ] ) ,
      .SPARSE_TKEEP_REMOVED ( M_SPARSE_TKEEP_REMOVED [ mi                                                              ] ) ,
      .PACKER_ERR        ( M_PACKER_ERR         [ mi                                                                   ] ) ,
      .S_FIFO_DATA_COUNT (                                                                                               ) ,
      .M_FIFO_DATA_COUNT   ( M_FIFO_DATA_COUNT  [ mi*32+:32                                                            ] ) 
    );
  end
endgenerate

endmodule // axis_interconnect

`default_nettype wire


//  (c) Copyright 2011-2013 Xilinx, Inc. All rights reserved.
//
//  This file contains confidential and proprietary information
//  of Xilinx, Inc. and is protected under U.S. and
//  international copyright and other intellectual property
//  laws.
//
//  DISCLAIMER
//  This disclaimer is not a license and does not grant any
//  rights to the materials distributed herewith. Except as
//  otherwise provided in a valid license issued to you by
//  Xilinx, and to the maximum extent permitted by applicable
//  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
//  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//  (2) Xilinx shall not be liable (whether in contract or tort,
//  including negligence, or under any other theory of
//  liability) for any loss or damage of any kind or nature
//  related to, arising under or in connection with these
//  materials, including for any direct, or any indirect,
//  special, incidental, or consequential loss or damage
//  (including loss of data, profits, goodwill, or any type of
//  loss or damage suffered as a result of any action brought
//  by a third party) even if such damage or loss was
//  reasonably foreseeable or Xilinx had been advised of the
//  possibility of the same.
//
//  CRITICAL APPLICATIONS
//  Xilinx products are not designed or intended to be fail-
//  safe, or for use in any application requiring fail-safe
//  performance, such as life-support or safety devices or
//  systems, Class III medical devices, nuclear facilities,
//  applications related to the deployment of airbags, or any
//  other applications that could lead to death, personal
//  injury, or severe property or environmental damage
//  (individually and collectively, "Critical
//  Applications"). Customer assumes the sole risk and
//  liability of any use of Xilinx products in Critical
//  Applications, subject only to applicable laws and
//  regulations governing limitations on product liability.
//
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//  PART OF THIS FILE AT ALL TIMES. 
//-----------------------------------------------------------------------------
// This is a computer generated file.
//-----------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_interconnect_v1_1_18_axis_interconnect_16x16_top #(

///////////////////////////////////////////////////////////////////////////////
// Parameter Declarations
///////////////////////////////////////////////////////////////////////////////
  parameter  C_FAMILY = "virtex7",
  parameter integer C_NUM_MI_SLOTS = 1,
  parameter integer C_NUM_SI_SLOTS = 1,
  parameter integer C_SWITCH_MI_REG_CONFIG = 0,
  parameter integer C_SWITCH_SI_REG_CONFIG = 1,
  parameter integer C_SWITCH_MODE = 33,
  parameter integer C_SWITCH_MAX_XFERS_PER_ARB = 0,
  parameter integer C_SWITCH_NUM_CYCLES_TIMEOUT = 0,
  parameter integer C_SWITCH_TDATA_WIDTH = 32,
  parameter integer C_SWITCH_TID_WIDTH = 1,
  parameter integer C_SWITCH_TDEST_WIDTH = 1,
  parameter integer C_SWITCH_TUSER_WIDTH = 1,
  parameter [31:0] C_SWITCH_SIGNAL_SET = 32'h7F,
  parameter integer C_SWITCH_ACLK_RATIO = 1,
  parameter integer C_SWITCH_USE_ACLKEN = 0,
  parameter integer C_SYNCHRONIZER_STAGE = 2,
  parameter [16-1:0] C_M00_AXIS_CONNECTIVITY = 16'b0,
  parameter [16-1:0] C_M01_AXIS_CONNECTIVITY = 16'b0,
  parameter [16-1:0] C_M02_AXIS_CONNECTIVITY = 16'b0,
  parameter [16-1:0] C_M03_AXIS_CONNECTIVITY = 16'b0,
  parameter [16-1:0] C_M04_AXIS_CONNECTIVITY = 16'b0,
  parameter [16-1:0] C_M05_AXIS_CONNECTIVITY = 16'b0,
  parameter [16-1:0] C_M06_AXIS_CONNECTIVITY = 16'b0,
  parameter [16-1:0] C_M07_AXIS_CONNECTIVITY = 16'b0,
  parameter [16-1:0] C_M08_AXIS_CONNECTIVITY = 16'b0,
  parameter [16-1:0] C_M09_AXIS_CONNECTIVITY = 16'b0,
  parameter [16-1:0] C_M10_AXIS_CONNECTIVITY = 16'b0,
  parameter [16-1:0] C_M11_AXIS_CONNECTIVITY = 16'b0,
  parameter [16-1:0] C_M12_AXIS_CONNECTIVITY = 16'b0,
  parameter [16-1:0] C_M13_AXIS_CONNECTIVITY = 16'b0,
  parameter [16-1:0] C_M14_AXIS_CONNECTIVITY = 16'b0,
  parameter [16-1:0] C_M15_AXIS_CONNECTIVITY = 16'b0,
  parameter integer C_M00_AXIS_BASETDEST = 32'b0,
  parameter integer C_M01_AXIS_BASETDEST = 32'b0,
  parameter integer C_M02_AXIS_BASETDEST = 32'b0,
  parameter integer C_M03_AXIS_BASETDEST = 32'b0,
  parameter integer C_M04_AXIS_BASETDEST = 32'b0,
  parameter integer C_M05_AXIS_BASETDEST = 32'b0,
  parameter integer C_M06_AXIS_BASETDEST = 32'b0,
  parameter integer C_M07_AXIS_BASETDEST = 32'b0,
  parameter integer C_M08_AXIS_BASETDEST = 32'b0,
  parameter integer C_M09_AXIS_BASETDEST = 32'b0,
  parameter integer C_M10_AXIS_BASETDEST = 32'b0,
  parameter integer C_M11_AXIS_BASETDEST = 32'b0,
  parameter integer C_M12_AXIS_BASETDEST = 32'b0,
  parameter integer C_M13_AXIS_BASETDEST = 32'b0,
  parameter integer C_M14_AXIS_BASETDEST = 32'b0,
  parameter integer C_M15_AXIS_BASETDEST = 32'b0,
  parameter integer C_M00_AXIS_HIGHTDEST = 32'b0,
  parameter integer C_M01_AXIS_HIGHTDEST = 32'b0,
  parameter integer C_M02_AXIS_HIGHTDEST = 32'b0,
  parameter integer C_M03_AXIS_HIGHTDEST = 32'b0,
  parameter integer C_M04_AXIS_HIGHTDEST = 32'b0,
  parameter integer C_M05_AXIS_HIGHTDEST = 32'b0,
  parameter integer C_M06_AXIS_HIGHTDEST = 32'b0,
  parameter integer C_M07_AXIS_HIGHTDEST = 32'b0,
  parameter integer C_M08_AXIS_HIGHTDEST = 32'b0,
  parameter integer C_M09_AXIS_HIGHTDEST = 32'b0,
  parameter integer C_M10_AXIS_HIGHTDEST = 32'b0,
  parameter integer C_M11_AXIS_HIGHTDEST = 32'b0,
  parameter integer C_M12_AXIS_HIGHTDEST = 32'b0,
  parameter integer C_M13_AXIS_HIGHTDEST = 32'b0,
  parameter integer C_M14_AXIS_HIGHTDEST = 32'b0,
  parameter integer C_M15_AXIS_HIGHTDEST = 32'b0,
  parameter integer C_S00_AXIS_TDATA_WIDTH = 8,
  parameter integer C_S01_AXIS_TDATA_WIDTH = 8,
  parameter integer C_S02_AXIS_TDATA_WIDTH = 8,
  parameter integer C_S03_AXIS_TDATA_WIDTH = 8,
  parameter integer C_S04_AXIS_TDATA_WIDTH = 8,
  parameter integer C_S05_AXIS_TDATA_WIDTH = 8,
  parameter integer C_S06_AXIS_TDATA_WIDTH = 8,
  parameter integer C_S07_AXIS_TDATA_WIDTH = 8,
  parameter integer C_S08_AXIS_TDATA_WIDTH = 8,
  parameter integer C_S09_AXIS_TDATA_WIDTH = 8,
  parameter integer C_S10_AXIS_TDATA_WIDTH = 8,
  parameter integer C_S11_AXIS_TDATA_WIDTH = 8,
  parameter integer C_S12_AXIS_TDATA_WIDTH = 8,
  parameter integer C_S13_AXIS_TDATA_WIDTH = 8,
  parameter integer C_S14_AXIS_TDATA_WIDTH = 8,
  parameter integer C_S15_AXIS_TDATA_WIDTH = 8,
  parameter integer C_S00_AXIS_TUSER_WIDTH = 1,
  parameter integer C_S01_AXIS_TUSER_WIDTH = 1,
  parameter integer C_S02_AXIS_TUSER_WIDTH = 1,
  parameter integer C_S03_AXIS_TUSER_WIDTH = 1,
  parameter integer C_S04_AXIS_TUSER_WIDTH = 1,
  parameter integer C_S05_AXIS_TUSER_WIDTH = 1,
  parameter integer C_S06_AXIS_TUSER_WIDTH = 1,
  parameter integer C_S07_AXIS_TUSER_WIDTH = 1,
  parameter integer C_S08_AXIS_TUSER_WIDTH = 1,
  parameter integer C_S09_AXIS_TUSER_WIDTH = 1,
  parameter integer C_S10_AXIS_TUSER_WIDTH = 1,
  parameter integer C_S11_AXIS_TUSER_WIDTH = 1,
  parameter integer C_S12_AXIS_TUSER_WIDTH = 1,
  parameter integer C_S13_AXIS_TUSER_WIDTH = 1,
  parameter integer C_S14_AXIS_TUSER_WIDTH = 1,
  parameter integer C_S15_AXIS_TUSER_WIDTH = 1,
  parameter integer C_S00_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_S01_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_S02_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_S03_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_S04_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_S05_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_S06_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_S07_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_S08_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_S09_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_S10_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_S11_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_S12_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_S13_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_S14_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_S15_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_S00_AXIS_ACLK_RATIO = 1,
  parameter integer C_S01_AXIS_ACLK_RATIO = 1,
  parameter integer C_S02_AXIS_ACLK_RATIO = 1,
  parameter integer C_S03_AXIS_ACLK_RATIO = 1,
  parameter integer C_S04_AXIS_ACLK_RATIO = 1,
  parameter integer C_S05_AXIS_ACLK_RATIO = 1,
  parameter integer C_S06_AXIS_ACLK_RATIO = 1,
  parameter integer C_S07_AXIS_ACLK_RATIO = 1,
  parameter integer C_S08_AXIS_ACLK_RATIO = 1,
  parameter integer C_S09_AXIS_ACLK_RATIO = 1,
  parameter integer C_S10_AXIS_ACLK_RATIO = 1,
  parameter integer C_S11_AXIS_ACLK_RATIO = 1,
  parameter integer C_S12_AXIS_ACLK_RATIO = 1,
  parameter integer C_S13_AXIS_ACLK_RATIO = 1,
  parameter integer C_S14_AXIS_ACLK_RATIO = 1,
  parameter integer C_S15_AXIS_ACLK_RATIO = 1,
  parameter integer C_S00_AXIS_REG_CONFIG = 1,
  parameter integer C_S01_AXIS_REG_CONFIG = 1,
  parameter integer C_S02_AXIS_REG_CONFIG = 1,
  parameter integer C_S03_AXIS_REG_CONFIG = 1,
  parameter integer C_S04_AXIS_REG_CONFIG = 1,
  parameter integer C_S05_AXIS_REG_CONFIG = 1,
  parameter integer C_S06_AXIS_REG_CONFIG = 1,
  parameter integer C_S07_AXIS_REG_CONFIG = 1,
  parameter integer C_S08_AXIS_REG_CONFIG = 1,
  parameter integer C_S09_AXIS_REG_CONFIG = 1,
  parameter integer C_S10_AXIS_REG_CONFIG = 1,
  parameter integer C_S11_AXIS_REG_CONFIG = 1,
  parameter integer C_S12_AXIS_REG_CONFIG = 1,
  parameter integer C_S13_AXIS_REG_CONFIG = 1,
  parameter integer C_S14_AXIS_REG_CONFIG = 1,
  parameter integer C_S15_AXIS_REG_CONFIG = 1,
  parameter integer C_S00_AXIS_FIFO_DEPTH = 32,
  parameter integer C_S01_AXIS_FIFO_DEPTH = 32,
  parameter integer C_S02_AXIS_FIFO_DEPTH = 32,
  parameter integer C_S03_AXIS_FIFO_DEPTH = 32,
  parameter integer C_S04_AXIS_FIFO_DEPTH = 32,
  parameter integer C_S05_AXIS_FIFO_DEPTH = 32,
  parameter integer C_S06_AXIS_FIFO_DEPTH = 32,
  parameter integer C_S07_AXIS_FIFO_DEPTH = 32,
  parameter integer C_S08_AXIS_FIFO_DEPTH = 32,
  parameter integer C_S09_AXIS_FIFO_DEPTH = 32,
  parameter integer C_S10_AXIS_FIFO_DEPTH = 32,
  parameter integer C_S11_AXIS_FIFO_DEPTH = 32,
  parameter integer C_S12_AXIS_FIFO_DEPTH = 32,
  parameter integer C_S13_AXIS_FIFO_DEPTH = 32,
  parameter integer C_S14_AXIS_FIFO_DEPTH = 32,
  parameter integer C_S15_AXIS_FIFO_DEPTH = 32,
  parameter integer C_S00_AXIS_FIFO_MODE = 0,
  parameter integer C_S01_AXIS_FIFO_MODE = 0,
  parameter integer C_S02_AXIS_FIFO_MODE = 0,
  parameter integer C_S03_AXIS_FIFO_MODE = 0,
  parameter integer C_S04_AXIS_FIFO_MODE = 0,
  parameter integer C_S05_AXIS_FIFO_MODE = 0,
  parameter integer C_S06_AXIS_FIFO_MODE = 0,
  parameter integer C_S07_AXIS_FIFO_MODE = 0,
  parameter integer C_S08_AXIS_FIFO_MODE = 0,
  parameter integer C_S09_AXIS_FIFO_MODE = 0,
  parameter integer C_S10_AXIS_FIFO_MODE = 0,
  parameter integer C_S11_AXIS_FIFO_MODE = 0,
  parameter integer C_S12_AXIS_FIFO_MODE = 0,
  parameter integer C_S13_AXIS_FIFO_MODE = 0,
  parameter integer C_S14_AXIS_FIFO_MODE = 0,
  parameter integer C_S15_AXIS_FIFO_MODE = 0,
  parameter integer C_M00_AXIS_TDATA_WIDTH = 8,
  parameter integer C_M01_AXIS_TDATA_WIDTH = 8,
  parameter integer C_M02_AXIS_TDATA_WIDTH = 8,
  parameter integer C_M03_AXIS_TDATA_WIDTH = 8,
  parameter integer C_M04_AXIS_TDATA_WIDTH = 8,
  parameter integer C_M05_AXIS_TDATA_WIDTH = 8,
  parameter integer C_M06_AXIS_TDATA_WIDTH = 8,
  parameter integer C_M07_AXIS_TDATA_WIDTH = 8,
  parameter integer C_M08_AXIS_TDATA_WIDTH = 8,
  parameter integer C_M09_AXIS_TDATA_WIDTH = 8,
  parameter integer C_M10_AXIS_TDATA_WIDTH = 8,
  parameter integer C_M11_AXIS_TDATA_WIDTH = 8,
  parameter integer C_M12_AXIS_TDATA_WIDTH = 8,
  parameter integer C_M13_AXIS_TDATA_WIDTH = 8,
  parameter integer C_M14_AXIS_TDATA_WIDTH = 8,
  parameter integer C_M15_AXIS_TDATA_WIDTH = 8,
  parameter integer C_M00_AXIS_TUSER_WIDTH = 1,
  parameter integer C_M01_AXIS_TUSER_WIDTH = 1,
  parameter integer C_M02_AXIS_TUSER_WIDTH = 1,
  parameter integer C_M03_AXIS_TUSER_WIDTH = 1,
  parameter integer C_M04_AXIS_TUSER_WIDTH = 1,
  parameter integer C_M05_AXIS_TUSER_WIDTH = 1,
  parameter integer C_M06_AXIS_TUSER_WIDTH = 1,
  parameter integer C_M07_AXIS_TUSER_WIDTH = 1,
  parameter integer C_M08_AXIS_TUSER_WIDTH = 1,
  parameter integer C_M09_AXIS_TUSER_WIDTH = 1,
  parameter integer C_M10_AXIS_TUSER_WIDTH = 1,
  parameter integer C_M11_AXIS_TUSER_WIDTH = 1,
  parameter integer C_M12_AXIS_TUSER_WIDTH = 1,
  parameter integer C_M13_AXIS_TUSER_WIDTH = 1,
  parameter integer C_M14_AXIS_TUSER_WIDTH = 1,
  parameter integer C_M15_AXIS_TUSER_WIDTH = 1,
  parameter integer C_M00_AXIS_ACLK_RATIO = 1,
  parameter integer C_M01_AXIS_ACLK_RATIO = 1,
  parameter integer C_M02_AXIS_ACLK_RATIO = 1,
  parameter integer C_M03_AXIS_ACLK_RATIO = 1,
  parameter integer C_M04_AXIS_ACLK_RATIO = 1,
  parameter integer C_M05_AXIS_ACLK_RATIO = 1,
  parameter integer C_M06_AXIS_ACLK_RATIO = 1,
  parameter integer C_M07_AXIS_ACLK_RATIO = 1,
  parameter integer C_M08_AXIS_ACLK_RATIO = 1,
  parameter integer C_M09_AXIS_ACLK_RATIO = 1,
  parameter integer C_M10_AXIS_ACLK_RATIO = 1,
  parameter integer C_M11_AXIS_ACLK_RATIO = 1,
  parameter integer C_M12_AXIS_ACLK_RATIO = 1,
  parameter integer C_M13_AXIS_ACLK_RATIO = 1,
  parameter integer C_M14_AXIS_ACLK_RATIO = 1,
  parameter integer C_M15_AXIS_ACLK_RATIO = 1,
  parameter integer C_M00_AXIS_REG_CONFIG = 1,
  parameter integer C_M01_AXIS_REG_CONFIG = 1,
  parameter integer C_M02_AXIS_REG_CONFIG = 1,
  parameter integer C_M03_AXIS_REG_CONFIG = 1,
  parameter integer C_M04_AXIS_REG_CONFIG = 1,
  parameter integer C_M05_AXIS_REG_CONFIG = 1,
  parameter integer C_M06_AXIS_REG_CONFIG = 1,
  parameter integer C_M07_AXIS_REG_CONFIG = 1,
  parameter integer C_M08_AXIS_REG_CONFIG = 1,
  parameter integer C_M09_AXIS_REG_CONFIG = 1,
  parameter integer C_M10_AXIS_REG_CONFIG = 1,
  parameter integer C_M11_AXIS_REG_CONFIG = 1,
  parameter integer C_M12_AXIS_REG_CONFIG = 1,
  parameter integer C_M13_AXIS_REG_CONFIG = 1,
  parameter integer C_M14_AXIS_REG_CONFIG = 1,
  parameter integer C_M15_AXIS_REG_CONFIG = 1,
  parameter integer C_M00_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_M01_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_M02_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_M03_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_M04_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_M05_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_M06_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_M07_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_M08_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_M09_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_M10_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_M11_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_M12_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_M13_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_M14_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_M15_AXIS_IS_ACLK_ASYNC = 0,
  parameter integer C_M00_AXIS_FIFO_DEPTH = 32,
  parameter integer C_M01_AXIS_FIFO_DEPTH = 32,
  parameter integer C_M02_AXIS_FIFO_DEPTH = 32,
  parameter integer C_M03_AXIS_FIFO_DEPTH = 32,
  parameter integer C_M04_AXIS_FIFO_DEPTH = 32,
  parameter integer C_M05_AXIS_FIFO_DEPTH = 32,
  parameter integer C_M06_AXIS_FIFO_DEPTH = 32,
  parameter integer C_M07_AXIS_FIFO_DEPTH = 32,
  parameter integer C_M08_AXIS_FIFO_DEPTH = 32,
  parameter integer C_M09_AXIS_FIFO_DEPTH = 32,
  parameter integer C_M10_AXIS_FIFO_DEPTH = 32,
  parameter integer C_M11_AXIS_FIFO_DEPTH = 32,
  parameter integer C_M12_AXIS_FIFO_DEPTH = 32,
  parameter integer C_M13_AXIS_FIFO_DEPTH = 32,
  parameter integer C_M14_AXIS_FIFO_DEPTH = 32,
  parameter integer C_M15_AXIS_FIFO_DEPTH = 32,
  parameter integer C_M00_AXIS_FIFO_MODE = 0,
  parameter integer C_M01_AXIS_FIFO_MODE = 0,
  parameter integer C_M02_AXIS_FIFO_MODE = 0,
  parameter integer C_M03_AXIS_FIFO_MODE = 0,
  parameter integer C_M04_AXIS_FIFO_MODE = 0,
  parameter integer C_M05_AXIS_FIFO_MODE = 0,
  parameter integer C_M06_AXIS_FIFO_MODE = 0,
  parameter integer C_M07_AXIS_FIFO_MODE = 0,
  parameter integer C_M08_AXIS_FIFO_MODE = 0,
  parameter integer C_M09_AXIS_FIFO_MODE = 0,
  parameter integer C_M10_AXIS_FIFO_MODE = 0,
  parameter integer C_M11_AXIS_FIFO_MODE = 0,
  parameter integer C_M12_AXIS_FIFO_MODE = 0,
  parameter integer C_M13_AXIS_FIFO_MODE = 0,
  parameter integer C_M14_AXIS_FIFO_MODE = 0,
  parameter integer C_M15_AXIS_FIFO_MODE = 0
)
(

///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
  input wire  ACLK,
  input wire  ARESETN,
  input wire  ACLKEN,
  input wire  S00_AXIS_ACLK,
  input wire  S01_AXIS_ACLK,
  input wire  S02_AXIS_ACLK,
  input wire  S03_AXIS_ACLK,
  input wire  S04_AXIS_ACLK,
  input wire  S05_AXIS_ACLK,
  input wire  S06_AXIS_ACLK,
  input wire  S07_AXIS_ACLK,
  input wire  S08_AXIS_ACLK,
  input wire  S09_AXIS_ACLK,
  input wire  S10_AXIS_ACLK,
  input wire  S11_AXIS_ACLK,
  input wire  S12_AXIS_ACLK,
  input wire  S13_AXIS_ACLK,
  input wire  S14_AXIS_ACLK,
  input wire  S15_AXIS_ACLK,
  input wire  S00_AXIS_ARESETN,
  input wire  S01_AXIS_ARESETN,
  input wire  S02_AXIS_ARESETN,
  input wire  S03_AXIS_ARESETN,
  input wire  S04_AXIS_ARESETN,
  input wire  S05_AXIS_ARESETN,
  input wire  S06_AXIS_ARESETN,
  input wire  S07_AXIS_ARESETN,
  input wire  S08_AXIS_ARESETN,
  input wire  S09_AXIS_ARESETN,
  input wire  S10_AXIS_ARESETN,
  input wire  S11_AXIS_ARESETN,
  input wire  S12_AXIS_ARESETN,
  input wire  S13_AXIS_ARESETN,
  input wire  S14_AXIS_ARESETN,
  input wire  S15_AXIS_ARESETN,
  input wire  S00_AXIS_ACLKEN,
  input wire  S01_AXIS_ACLKEN,
  input wire  S02_AXIS_ACLKEN,
  input wire  S03_AXIS_ACLKEN,
  input wire  S04_AXIS_ACLKEN,
  input wire  S05_AXIS_ACLKEN,
  input wire  S06_AXIS_ACLKEN,
  input wire  S07_AXIS_ACLKEN,
  input wire  S08_AXIS_ACLKEN,
  input wire  S09_AXIS_ACLKEN,
  input wire  S10_AXIS_ACLKEN,
  input wire  S11_AXIS_ACLKEN,
  input wire  S12_AXIS_ACLKEN,
  input wire  S13_AXIS_ACLKEN,
  input wire  S14_AXIS_ACLKEN,
  input wire  S15_AXIS_ACLKEN,
  input wire  S00_AXIS_TVALID,
  input wire  S01_AXIS_TVALID,
  input wire  S02_AXIS_TVALID,
  input wire  S03_AXIS_TVALID,
  input wire  S04_AXIS_TVALID,
  input wire  S05_AXIS_TVALID,
  input wire  S06_AXIS_TVALID,
  input wire  S07_AXIS_TVALID,
  input wire  S08_AXIS_TVALID,
  input wire  S09_AXIS_TVALID,
  input wire  S10_AXIS_TVALID,
  input wire  S11_AXIS_TVALID,
  input wire  S12_AXIS_TVALID,
  input wire  S13_AXIS_TVALID,
  input wire  S14_AXIS_TVALID,
  input wire  S15_AXIS_TVALID,
  output wire  S00_AXIS_TREADY,
  output wire  S01_AXIS_TREADY,
  output wire  S02_AXIS_TREADY,
  output wire  S03_AXIS_TREADY,
  output wire  S04_AXIS_TREADY,
  output wire  S05_AXIS_TREADY,
  output wire  S06_AXIS_TREADY,
  output wire  S07_AXIS_TREADY,
  output wire  S08_AXIS_TREADY,
  output wire  S09_AXIS_TREADY,
  output wire  S10_AXIS_TREADY,
  output wire  S11_AXIS_TREADY,
  output wire  S12_AXIS_TREADY,
  output wire  S13_AXIS_TREADY,
  output wire  S14_AXIS_TREADY,
  output wire  S15_AXIS_TREADY,
  input wire [C_S00_AXIS_TDATA_WIDTH-1:0] S00_AXIS_TDATA,
  input wire [C_S01_AXIS_TDATA_WIDTH-1:0] S01_AXIS_TDATA,
  input wire [C_S02_AXIS_TDATA_WIDTH-1:0] S02_AXIS_TDATA,
  input wire [C_S03_AXIS_TDATA_WIDTH-1:0] S03_AXIS_TDATA,
  input wire [C_S04_AXIS_TDATA_WIDTH-1:0] S04_AXIS_TDATA,
  input wire [C_S05_AXIS_TDATA_WIDTH-1:0] S05_AXIS_TDATA,
  input wire [C_S06_AXIS_TDATA_WIDTH-1:0] S06_AXIS_TDATA,
  input wire [C_S07_AXIS_TDATA_WIDTH-1:0] S07_AXIS_TDATA,
  input wire [C_S08_AXIS_TDATA_WIDTH-1:0] S08_AXIS_TDATA,
  input wire [C_S09_AXIS_TDATA_WIDTH-1:0] S09_AXIS_TDATA,
  input wire [C_S10_AXIS_TDATA_WIDTH-1:0] S10_AXIS_TDATA,
  input wire [C_S11_AXIS_TDATA_WIDTH-1:0] S11_AXIS_TDATA,
  input wire [C_S12_AXIS_TDATA_WIDTH-1:0] S12_AXIS_TDATA,
  input wire [C_S13_AXIS_TDATA_WIDTH-1:0] S13_AXIS_TDATA,
  input wire [C_S14_AXIS_TDATA_WIDTH-1:0] S14_AXIS_TDATA,
  input wire [C_S15_AXIS_TDATA_WIDTH-1:0] S15_AXIS_TDATA,
  input wire [C_S00_AXIS_TDATA_WIDTH/8-1:0] S00_AXIS_TSTRB,
  input wire [C_S01_AXIS_TDATA_WIDTH/8-1:0] S01_AXIS_TSTRB,
  input wire [C_S02_AXIS_TDATA_WIDTH/8-1:0] S02_AXIS_TSTRB,
  input wire [C_S03_AXIS_TDATA_WIDTH/8-1:0] S03_AXIS_TSTRB,
  input wire [C_S04_AXIS_TDATA_WIDTH/8-1:0] S04_AXIS_TSTRB,
  input wire [C_S05_AXIS_TDATA_WIDTH/8-1:0] S05_AXIS_TSTRB,
  input wire [C_S06_AXIS_TDATA_WIDTH/8-1:0] S06_AXIS_TSTRB,
  input wire [C_S07_AXIS_TDATA_WIDTH/8-1:0] S07_AXIS_TSTRB,
  input wire [C_S08_AXIS_TDATA_WIDTH/8-1:0] S08_AXIS_TSTRB,
  input wire [C_S09_AXIS_TDATA_WIDTH/8-1:0] S09_AXIS_TSTRB,
  input wire [C_S10_AXIS_TDATA_WIDTH/8-1:0] S10_AXIS_TSTRB,
  input wire [C_S11_AXIS_TDATA_WIDTH/8-1:0] S11_AXIS_TSTRB,
  input wire [C_S12_AXIS_TDATA_WIDTH/8-1:0] S12_AXIS_TSTRB,
  input wire [C_S13_AXIS_TDATA_WIDTH/8-1:0] S13_AXIS_TSTRB,
  input wire [C_S14_AXIS_TDATA_WIDTH/8-1:0] S14_AXIS_TSTRB,
  input wire [C_S15_AXIS_TDATA_WIDTH/8-1:0] S15_AXIS_TSTRB,
  input wire [C_S00_AXIS_TDATA_WIDTH/8-1:0] S00_AXIS_TKEEP,
  input wire [C_S01_AXIS_TDATA_WIDTH/8-1:0] S01_AXIS_TKEEP,
  input wire [C_S02_AXIS_TDATA_WIDTH/8-1:0] S02_AXIS_TKEEP,
  input wire [C_S03_AXIS_TDATA_WIDTH/8-1:0] S03_AXIS_TKEEP,
  input wire [C_S04_AXIS_TDATA_WIDTH/8-1:0] S04_AXIS_TKEEP,
  input wire [C_S05_AXIS_TDATA_WIDTH/8-1:0] S05_AXIS_TKEEP,
  input wire [C_S06_AXIS_TDATA_WIDTH/8-1:0] S06_AXIS_TKEEP,
  input wire [C_S07_AXIS_TDATA_WIDTH/8-1:0] S07_AXIS_TKEEP,
  input wire [C_S08_AXIS_TDATA_WIDTH/8-1:0] S08_AXIS_TKEEP,
  input wire [C_S09_AXIS_TDATA_WIDTH/8-1:0] S09_AXIS_TKEEP,
  input wire [C_S10_AXIS_TDATA_WIDTH/8-1:0] S10_AXIS_TKEEP,
  input wire [C_S11_AXIS_TDATA_WIDTH/8-1:0] S11_AXIS_TKEEP,
  input wire [C_S12_AXIS_TDATA_WIDTH/8-1:0] S12_AXIS_TKEEP,
  input wire [C_S13_AXIS_TDATA_WIDTH/8-1:0] S13_AXIS_TKEEP,
  input wire [C_S14_AXIS_TDATA_WIDTH/8-1:0] S14_AXIS_TKEEP,
  input wire [C_S15_AXIS_TDATA_WIDTH/8-1:0] S15_AXIS_TKEEP,
  input wire  S00_AXIS_TLAST,
  input wire  S01_AXIS_TLAST,
  input wire  S02_AXIS_TLAST,
  input wire  S03_AXIS_TLAST,
  input wire  S04_AXIS_TLAST,
  input wire  S05_AXIS_TLAST,
  input wire  S06_AXIS_TLAST,
  input wire  S07_AXIS_TLAST,
  input wire  S08_AXIS_TLAST,
  input wire  S09_AXIS_TLAST,
  input wire  S10_AXIS_TLAST,
  input wire  S11_AXIS_TLAST,
  input wire  S12_AXIS_TLAST,
  input wire  S13_AXIS_TLAST,
  input wire  S14_AXIS_TLAST,
  input wire  S15_AXIS_TLAST,
  input wire [C_SWITCH_TID_WIDTH-1:0] S00_AXIS_TID,
  input wire [C_SWITCH_TID_WIDTH-1:0] S01_AXIS_TID,
  input wire [C_SWITCH_TID_WIDTH-1:0] S02_AXIS_TID,
  input wire [C_SWITCH_TID_WIDTH-1:0] S03_AXIS_TID,
  input wire [C_SWITCH_TID_WIDTH-1:0] S04_AXIS_TID,
  input wire [C_SWITCH_TID_WIDTH-1:0] S05_AXIS_TID,
  input wire [C_SWITCH_TID_WIDTH-1:0] S06_AXIS_TID,
  input wire [C_SWITCH_TID_WIDTH-1:0] S07_AXIS_TID,
  input wire [C_SWITCH_TID_WIDTH-1:0] S08_AXIS_TID,
  input wire [C_SWITCH_TID_WIDTH-1:0] S09_AXIS_TID,
  input wire [C_SWITCH_TID_WIDTH-1:0] S10_AXIS_TID,
  input wire [C_SWITCH_TID_WIDTH-1:0] S11_AXIS_TID,
  input wire [C_SWITCH_TID_WIDTH-1:0] S12_AXIS_TID,
  input wire [C_SWITCH_TID_WIDTH-1:0] S13_AXIS_TID,
  input wire [C_SWITCH_TID_WIDTH-1:0] S14_AXIS_TID,
  input wire [C_SWITCH_TID_WIDTH-1:0] S15_AXIS_TID,
  input wire [C_SWITCH_TDEST_WIDTH-1:0] S00_AXIS_TDEST,
  input wire [C_SWITCH_TDEST_WIDTH-1:0] S01_AXIS_TDEST,
  input wire [C_SWITCH_TDEST_WIDTH-1:0] S02_AXIS_TDEST,
  input wire [C_SWITCH_TDEST_WIDTH-1:0] S03_AXIS_TDEST,
  input wire [C_SWITCH_TDEST_WIDTH-1:0] S04_AXIS_TDEST,
  input wire [C_SWITCH_TDEST_WIDTH-1:0] S05_AXIS_TDEST,
  input wire [C_SWITCH_TDEST_WIDTH-1:0] S06_AXIS_TDEST,
  input wire [C_SWITCH_TDEST_WIDTH-1:0] S07_AXIS_TDEST,
  input wire [C_SWITCH_TDEST_WIDTH-1:0] S08_AXIS_TDEST,
  input wire [C_SWITCH_TDEST_WIDTH-1:0] S09_AXIS_TDEST,
  input wire [C_SWITCH_TDEST_WIDTH-1:0] S10_AXIS_TDEST,
  input wire [C_SWITCH_TDEST_WIDTH-1:0] S11_AXIS_TDEST,
  input wire [C_SWITCH_TDEST_WIDTH-1:0] S12_AXIS_TDEST,
  input wire [C_SWITCH_TDEST_WIDTH-1:0] S13_AXIS_TDEST,
  input wire [C_SWITCH_TDEST_WIDTH-1:0] S14_AXIS_TDEST,
  input wire [C_SWITCH_TDEST_WIDTH-1:0] S15_AXIS_TDEST,
  input wire [C_S00_AXIS_TUSER_WIDTH-1:0] S00_AXIS_TUSER,
  input wire [C_S01_AXIS_TUSER_WIDTH-1:0] S01_AXIS_TUSER,
  input wire [C_S02_AXIS_TUSER_WIDTH-1:0] S02_AXIS_TUSER,
  input wire [C_S03_AXIS_TUSER_WIDTH-1:0] S03_AXIS_TUSER,
  input wire [C_S04_AXIS_TUSER_WIDTH-1:0] S04_AXIS_TUSER,
  input wire [C_S05_AXIS_TUSER_WIDTH-1:0] S05_AXIS_TUSER,
  input wire [C_S06_AXIS_TUSER_WIDTH-1:0] S06_AXIS_TUSER,
  input wire [C_S07_AXIS_TUSER_WIDTH-1:0] S07_AXIS_TUSER,
  input wire [C_S08_AXIS_TUSER_WIDTH-1:0] S08_AXIS_TUSER,
  input wire [C_S09_AXIS_TUSER_WIDTH-1:0] S09_AXIS_TUSER,
  input wire [C_S10_AXIS_TUSER_WIDTH-1:0] S10_AXIS_TUSER,
  input wire [C_S11_AXIS_TUSER_WIDTH-1:0] S11_AXIS_TUSER,
  input wire [C_S12_AXIS_TUSER_WIDTH-1:0] S12_AXIS_TUSER,
  input wire [C_S13_AXIS_TUSER_WIDTH-1:0] S13_AXIS_TUSER,
  input wire [C_S14_AXIS_TUSER_WIDTH-1:0] S14_AXIS_TUSER,
  input wire [C_S15_AXIS_TUSER_WIDTH-1:0] S15_AXIS_TUSER,
  input wire  M00_AXIS_ACLK,
  input wire  M01_AXIS_ACLK,
  input wire  M02_AXIS_ACLK,
  input wire  M03_AXIS_ACLK,
  input wire  M04_AXIS_ACLK,
  input wire  M05_AXIS_ACLK,
  input wire  M06_AXIS_ACLK,
  input wire  M07_AXIS_ACLK,
  input wire  M08_AXIS_ACLK,
  input wire  M09_AXIS_ACLK,
  input wire  M10_AXIS_ACLK,
  input wire  M11_AXIS_ACLK,
  input wire  M12_AXIS_ACLK,
  input wire  M13_AXIS_ACLK,
  input wire  M14_AXIS_ACLK,
  input wire  M15_AXIS_ACLK,
  input wire  M00_AXIS_ARESETN,
  input wire  M01_AXIS_ARESETN,
  input wire  M02_AXIS_ARESETN,
  input wire  M03_AXIS_ARESETN,
  input wire  M04_AXIS_ARESETN,
  input wire  M05_AXIS_ARESETN,
  input wire  M06_AXIS_ARESETN,
  input wire  M07_AXIS_ARESETN,
  input wire  M08_AXIS_ARESETN,
  input wire  M09_AXIS_ARESETN,
  input wire  M10_AXIS_ARESETN,
  input wire  M11_AXIS_ARESETN,
  input wire  M12_AXIS_ARESETN,
  input wire  M13_AXIS_ARESETN,
  input wire  M14_AXIS_ARESETN,
  input wire  M15_AXIS_ARESETN,
  input wire  M00_AXIS_ACLKEN,
  input wire  M01_AXIS_ACLKEN,
  input wire  M02_AXIS_ACLKEN,
  input wire  M03_AXIS_ACLKEN,
  input wire  M04_AXIS_ACLKEN,
  input wire  M05_AXIS_ACLKEN,
  input wire  M06_AXIS_ACLKEN,
  input wire  M07_AXIS_ACLKEN,
  input wire  M08_AXIS_ACLKEN,
  input wire  M09_AXIS_ACLKEN,
  input wire  M10_AXIS_ACLKEN,
  input wire  M11_AXIS_ACLKEN,
  input wire  M12_AXIS_ACLKEN,
  input wire  M13_AXIS_ACLKEN,
  input wire  M14_AXIS_ACLKEN,
  input wire  M15_AXIS_ACLKEN,
  output wire  M00_AXIS_TVALID,
  output wire  M01_AXIS_TVALID,
  output wire  M02_AXIS_TVALID,
  output wire  M03_AXIS_TVALID,
  output wire  M04_AXIS_TVALID,
  output wire  M05_AXIS_TVALID,
  output wire  M06_AXIS_TVALID,
  output wire  M07_AXIS_TVALID,
  output wire  M08_AXIS_TVALID,
  output wire  M09_AXIS_TVALID,
  output wire  M10_AXIS_TVALID,
  output wire  M11_AXIS_TVALID,
  output wire  M12_AXIS_TVALID,
  output wire  M13_AXIS_TVALID,
  output wire  M14_AXIS_TVALID,
  output wire  M15_AXIS_TVALID,
  input wire  M00_AXIS_TREADY,
  input wire  M01_AXIS_TREADY,
  input wire  M02_AXIS_TREADY,
  input wire  M03_AXIS_TREADY,
  input wire  M04_AXIS_TREADY,
  input wire  M05_AXIS_TREADY,
  input wire  M06_AXIS_TREADY,
  input wire  M07_AXIS_TREADY,
  input wire  M08_AXIS_TREADY,
  input wire  M09_AXIS_TREADY,
  input wire  M10_AXIS_TREADY,
  input wire  M11_AXIS_TREADY,
  input wire  M12_AXIS_TREADY,
  input wire  M13_AXIS_TREADY,
  input wire  M14_AXIS_TREADY,
  input wire  M15_AXIS_TREADY,
  output wire [C_M00_AXIS_TDATA_WIDTH-1:0] M00_AXIS_TDATA,
  output wire [C_M01_AXIS_TDATA_WIDTH-1:0] M01_AXIS_TDATA,
  output wire [C_M02_AXIS_TDATA_WIDTH-1:0] M02_AXIS_TDATA,
  output wire [C_M03_AXIS_TDATA_WIDTH-1:0] M03_AXIS_TDATA,
  output wire [C_M04_AXIS_TDATA_WIDTH-1:0] M04_AXIS_TDATA,
  output wire [C_M05_AXIS_TDATA_WIDTH-1:0] M05_AXIS_TDATA,
  output wire [C_M06_AXIS_TDATA_WIDTH-1:0] M06_AXIS_TDATA,
  output wire [C_M07_AXIS_TDATA_WIDTH-1:0] M07_AXIS_TDATA,
  output wire [C_M08_AXIS_TDATA_WIDTH-1:0] M08_AXIS_TDATA,
  output wire [C_M09_AXIS_TDATA_WIDTH-1:0] M09_AXIS_TDATA,
  output wire [C_M10_AXIS_TDATA_WIDTH-1:0] M10_AXIS_TDATA,
  output wire [C_M11_AXIS_TDATA_WIDTH-1:0] M11_AXIS_TDATA,
  output wire [C_M12_AXIS_TDATA_WIDTH-1:0] M12_AXIS_TDATA,
  output wire [C_M13_AXIS_TDATA_WIDTH-1:0] M13_AXIS_TDATA,
  output wire [C_M14_AXIS_TDATA_WIDTH-1:0] M14_AXIS_TDATA,
  output wire [C_M15_AXIS_TDATA_WIDTH-1:0] M15_AXIS_TDATA,
  output wire [C_M00_AXIS_TDATA_WIDTH/8-1:0] M00_AXIS_TSTRB,
  output wire [C_M01_AXIS_TDATA_WIDTH/8-1:0] M01_AXIS_TSTRB,
  output wire [C_M02_AXIS_TDATA_WIDTH/8-1:0] M02_AXIS_TSTRB,
  output wire [C_M03_AXIS_TDATA_WIDTH/8-1:0] M03_AXIS_TSTRB,
  output wire [C_M04_AXIS_TDATA_WIDTH/8-1:0] M04_AXIS_TSTRB,
  output wire [C_M05_AXIS_TDATA_WIDTH/8-1:0] M05_AXIS_TSTRB,
  output wire [C_M06_AXIS_TDATA_WIDTH/8-1:0] M06_AXIS_TSTRB,
  output wire [C_M07_AXIS_TDATA_WIDTH/8-1:0] M07_AXIS_TSTRB,
  output wire [C_M08_AXIS_TDATA_WIDTH/8-1:0] M08_AXIS_TSTRB,
  output wire [C_M09_AXIS_TDATA_WIDTH/8-1:0] M09_AXIS_TSTRB,
  output wire [C_M10_AXIS_TDATA_WIDTH/8-1:0] M10_AXIS_TSTRB,
  output wire [C_M11_AXIS_TDATA_WIDTH/8-1:0] M11_AXIS_TSTRB,
  output wire [C_M12_AXIS_TDATA_WIDTH/8-1:0] M12_AXIS_TSTRB,
  output wire [C_M13_AXIS_TDATA_WIDTH/8-1:0] M13_AXIS_TSTRB,
  output wire [C_M14_AXIS_TDATA_WIDTH/8-1:0] M14_AXIS_TSTRB,
  output wire [C_M15_AXIS_TDATA_WIDTH/8-1:0] M15_AXIS_TSTRB,
  output wire [C_M00_AXIS_TDATA_WIDTH/8-1:0] M00_AXIS_TKEEP,
  output wire [C_M01_AXIS_TDATA_WIDTH/8-1:0] M01_AXIS_TKEEP,
  output wire [C_M02_AXIS_TDATA_WIDTH/8-1:0] M02_AXIS_TKEEP,
  output wire [C_M03_AXIS_TDATA_WIDTH/8-1:0] M03_AXIS_TKEEP,
  output wire [C_M04_AXIS_TDATA_WIDTH/8-1:0] M04_AXIS_TKEEP,
  output wire [C_M05_AXIS_TDATA_WIDTH/8-1:0] M05_AXIS_TKEEP,
  output wire [C_M06_AXIS_TDATA_WIDTH/8-1:0] M06_AXIS_TKEEP,
  output wire [C_M07_AXIS_TDATA_WIDTH/8-1:0] M07_AXIS_TKEEP,
  output wire [C_M08_AXIS_TDATA_WIDTH/8-1:0] M08_AXIS_TKEEP,
  output wire [C_M09_AXIS_TDATA_WIDTH/8-1:0] M09_AXIS_TKEEP,
  output wire [C_M10_AXIS_TDATA_WIDTH/8-1:0] M10_AXIS_TKEEP,
  output wire [C_M11_AXIS_TDATA_WIDTH/8-1:0] M11_AXIS_TKEEP,
  output wire [C_M12_AXIS_TDATA_WIDTH/8-1:0] M12_AXIS_TKEEP,
  output wire [C_M13_AXIS_TDATA_WIDTH/8-1:0] M13_AXIS_TKEEP,
  output wire [C_M14_AXIS_TDATA_WIDTH/8-1:0] M14_AXIS_TKEEP,
  output wire [C_M15_AXIS_TDATA_WIDTH/8-1:0] M15_AXIS_TKEEP,
  output wire  M00_AXIS_TLAST,
  output wire  M01_AXIS_TLAST,
  output wire  M02_AXIS_TLAST,
  output wire  M03_AXIS_TLAST,
  output wire  M04_AXIS_TLAST,
  output wire  M05_AXIS_TLAST,
  output wire  M06_AXIS_TLAST,
  output wire  M07_AXIS_TLAST,
  output wire  M08_AXIS_TLAST,
  output wire  M09_AXIS_TLAST,
  output wire  M10_AXIS_TLAST,
  output wire  M11_AXIS_TLAST,
  output wire  M12_AXIS_TLAST,
  output wire  M13_AXIS_TLAST,
  output wire  M14_AXIS_TLAST,
  output wire  M15_AXIS_TLAST,
  output wire [C_SWITCH_TID_WIDTH-1:0] M00_AXIS_TID,
  output wire [C_SWITCH_TID_WIDTH-1:0] M01_AXIS_TID,
  output wire [C_SWITCH_TID_WIDTH-1:0] M02_AXIS_TID,
  output wire [C_SWITCH_TID_WIDTH-1:0] M03_AXIS_TID,
  output wire [C_SWITCH_TID_WIDTH-1:0] M04_AXIS_TID,
  output wire [C_SWITCH_TID_WIDTH-1:0] M05_AXIS_TID,
  output wire [C_SWITCH_TID_WIDTH-1:0] M06_AXIS_TID,
  output wire [C_SWITCH_TID_WIDTH-1:0] M07_AXIS_TID,
  output wire [C_SWITCH_TID_WIDTH-1:0] M08_AXIS_TID,
  output wire [C_SWITCH_TID_WIDTH-1:0] M09_AXIS_TID,
  output wire [C_SWITCH_TID_WIDTH-1:0] M10_AXIS_TID,
  output wire [C_SWITCH_TID_WIDTH-1:0] M11_AXIS_TID,
  output wire [C_SWITCH_TID_WIDTH-1:0] M12_AXIS_TID,
  output wire [C_SWITCH_TID_WIDTH-1:0] M13_AXIS_TID,
  output wire [C_SWITCH_TID_WIDTH-1:0] M14_AXIS_TID,
  output wire [C_SWITCH_TID_WIDTH-1:0] M15_AXIS_TID,
  output wire [C_SWITCH_TDEST_WIDTH-1:0] M00_AXIS_TDEST,
  output wire [C_SWITCH_TDEST_WIDTH-1:0] M01_AXIS_TDEST,
  output wire [C_SWITCH_TDEST_WIDTH-1:0] M02_AXIS_TDEST,
  output wire [C_SWITCH_TDEST_WIDTH-1:0] M03_AXIS_TDEST,
  output wire [C_SWITCH_TDEST_WIDTH-1:0] M04_AXIS_TDEST,
  output wire [C_SWITCH_TDEST_WIDTH-1:0] M05_AXIS_TDEST,
  output wire [C_SWITCH_TDEST_WIDTH-1:0] M06_AXIS_TDEST,
  output wire [C_SWITCH_TDEST_WIDTH-1:0] M07_AXIS_TDEST,
  output wire [C_SWITCH_TDEST_WIDTH-1:0] M08_AXIS_TDEST,
  output wire [C_SWITCH_TDEST_WIDTH-1:0] M09_AXIS_TDEST,
  output wire [C_SWITCH_TDEST_WIDTH-1:0] M10_AXIS_TDEST,
  output wire [C_SWITCH_TDEST_WIDTH-1:0] M11_AXIS_TDEST,
  output wire [C_SWITCH_TDEST_WIDTH-1:0] M12_AXIS_TDEST,
  output wire [C_SWITCH_TDEST_WIDTH-1:0] M13_AXIS_TDEST,
  output wire [C_SWITCH_TDEST_WIDTH-1:0] M14_AXIS_TDEST,
  output wire [C_SWITCH_TDEST_WIDTH-1:0] M15_AXIS_TDEST,
  output wire [C_M00_AXIS_TUSER_WIDTH-1:0] M00_AXIS_TUSER,
  output wire [C_M01_AXIS_TUSER_WIDTH-1:0] M01_AXIS_TUSER,
  output wire [C_M02_AXIS_TUSER_WIDTH-1:0] M02_AXIS_TUSER,
  output wire [C_M03_AXIS_TUSER_WIDTH-1:0] M03_AXIS_TUSER,
  output wire [C_M04_AXIS_TUSER_WIDTH-1:0] M04_AXIS_TUSER,
  output wire [C_M05_AXIS_TUSER_WIDTH-1:0] M05_AXIS_TUSER,
  output wire [C_M06_AXIS_TUSER_WIDTH-1:0] M06_AXIS_TUSER,
  output wire [C_M07_AXIS_TUSER_WIDTH-1:0] M07_AXIS_TUSER,
  output wire [C_M08_AXIS_TUSER_WIDTH-1:0] M08_AXIS_TUSER,
  output wire [C_M09_AXIS_TUSER_WIDTH-1:0] M09_AXIS_TUSER,
  output wire [C_M10_AXIS_TUSER_WIDTH-1:0] M10_AXIS_TUSER,
  output wire [C_M11_AXIS_TUSER_WIDTH-1:0] M11_AXIS_TUSER,
  output wire [C_M12_AXIS_TUSER_WIDTH-1:0] M12_AXIS_TUSER,
  output wire [C_M13_AXIS_TUSER_WIDTH-1:0] M13_AXIS_TUSER,
  output wire [C_M14_AXIS_TUSER_WIDTH-1:0] M14_AXIS_TUSER,
  output wire [C_M15_AXIS_TUSER_WIDTH-1:0] M15_AXIS_TUSER,
  input wire  S00_ARB_REQ_SUPPRESS,
  input wire  S01_ARB_REQ_SUPPRESS,
  input wire  S02_ARB_REQ_SUPPRESS,
  input wire  S03_ARB_REQ_SUPPRESS,
  input wire  S04_ARB_REQ_SUPPRESS,
  input wire  S05_ARB_REQ_SUPPRESS,
  input wire  S06_ARB_REQ_SUPPRESS,
  input wire  S07_ARB_REQ_SUPPRESS,
  input wire  S08_ARB_REQ_SUPPRESS,
  input wire  S09_ARB_REQ_SUPPRESS,
  input wire  S10_ARB_REQ_SUPPRESS,
  input wire  S11_ARB_REQ_SUPPRESS,
  input wire  S12_ARB_REQ_SUPPRESS,
  input wire  S13_ARB_REQ_SUPPRESS,
  input wire  S14_ARB_REQ_SUPPRESS,
  input wire  S15_ARB_REQ_SUPPRESS,
  output wire  S00_DECODE_ERR,
  output wire  S01_DECODE_ERR,
  output wire  S02_DECODE_ERR,
  output wire  S03_DECODE_ERR,
  output wire  S04_DECODE_ERR,
  output wire  S05_DECODE_ERR,
  output wire  S06_DECODE_ERR,
  output wire  S07_DECODE_ERR,
  output wire  S08_DECODE_ERR,
  output wire  S09_DECODE_ERR,
  output wire  S10_DECODE_ERR,
  output wire  S11_DECODE_ERR,
  output wire  S12_DECODE_ERR,
  output wire  S13_DECODE_ERR,
  output wire  S14_DECODE_ERR,
  output wire  S15_DECODE_ERR,
  output wire  S00_SPARSE_TKEEP_REMOVED,
  output wire  S01_SPARSE_TKEEP_REMOVED,
  output wire  S02_SPARSE_TKEEP_REMOVED,
  output wire  S03_SPARSE_TKEEP_REMOVED,
  output wire  S04_SPARSE_TKEEP_REMOVED,
  output wire  S05_SPARSE_TKEEP_REMOVED,
  output wire  S06_SPARSE_TKEEP_REMOVED,
  output wire  S07_SPARSE_TKEEP_REMOVED,
  output wire  S08_SPARSE_TKEEP_REMOVED,
  output wire  S09_SPARSE_TKEEP_REMOVED,
  output wire  S10_SPARSE_TKEEP_REMOVED,
  output wire  S11_SPARSE_TKEEP_REMOVED,
  output wire  S12_SPARSE_TKEEP_REMOVED,
  output wire  S13_SPARSE_TKEEP_REMOVED,
  output wire  S14_SPARSE_TKEEP_REMOVED,
  output wire  S15_SPARSE_TKEEP_REMOVED,
  output wire  S00_PACKER_ERR,
  output wire  S01_PACKER_ERR,
  output wire  S02_PACKER_ERR,
  output wire  S03_PACKER_ERR,
  output wire  S04_PACKER_ERR,
  output wire  S05_PACKER_ERR,
  output wire  S06_PACKER_ERR,
  output wire  S07_PACKER_ERR,
  output wire  S08_PACKER_ERR,
  output wire  S09_PACKER_ERR,
  output wire  S10_PACKER_ERR,
  output wire  S11_PACKER_ERR,
  output wire  S12_PACKER_ERR,
  output wire  S13_PACKER_ERR,
  output wire  S14_PACKER_ERR,
  output wire  S15_PACKER_ERR,
  output wire [32-1:0] S00_FIFO_DATA_COUNT,
  output wire [32-1:0] S01_FIFO_DATA_COUNT,
  output wire [32-1:0] S02_FIFO_DATA_COUNT,
  output wire [32-1:0] S03_FIFO_DATA_COUNT,
  output wire [32-1:0] S04_FIFO_DATA_COUNT,
  output wire [32-1:0] S05_FIFO_DATA_COUNT,
  output wire [32-1:0] S06_FIFO_DATA_COUNT,
  output wire [32-1:0] S07_FIFO_DATA_COUNT,
  output wire [32-1:0] S08_FIFO_DATA_COUNT,
  output wire [32-1:0] S09_FIFO_DATA_COUNT,
  output wire [32-1:0] S10_FIFO_DATA_COUNT,
  output wire [32-1:0] S11_FIFO_DATA_COUNT,
  output wire [32-1:0] S12_FIFO_DATA_COUNT,
  output wire [32-1:0] S13_FIFO_DATA_COUNT,
  output wire [32-1:0] S14_FIFO_DATA_COUNT,
  output wire [32-1:0] S15_FIFO_DATA_COUNT,
  output wire  M00_SPARSE_TKEEP_REMOVED,
  output wire  M01_SPARSE_TKEEP_REMOVED,
  output wire  M02_SPARSE_TKEEP_REMOVED,
  output wire  M03_SPARSE_TKEEP_REMOVED,
  output wire  M04_SPARSE_TKEEP_REMOVED,
  output wire  M05_SPARSE_TKEEP_REMOVED,
  output wire  M06_SPARSE_TKEEP_REMOVED,
  output wire  M07_SPARSE_TKEEP_REMOVED,
  output wire  M08_SPARSE_TKEEP_REMOVED,
  output wire  M09_SPARSE_TKEEP_REMOVED,
  output wire  M10_SPARSE_TKEEP_REMOVED,
  output wire  M11_SPARSE_TKEEP_REMOVED,
  output wire  M12_SPARSE_TKEEP_REMOVED,
  output wire  M13_SPARSE_TKEEP_REMOVED,
  output wire  M14_SPARSE_TKEEP_REMOVED,
  output wire  M15_SPARSE_TKEEP_REMOVED,
  output wire  M00_PACKER_ERR,
  output wire  M01_PACKER_ERR,
  output wire  M02_PACKER_ERR,
  output wire  M03_PACKER_ERR,
  output wire  M04_PACKER_ERR,
  output wire  M05_PACKER_ERR,
  output wire  M06_PACKER_ERR,
  output wire  M07_PACKER_ERR,
  output wire  M08_PACKER_ERR,
  output wire  M09_PACKER_ERR,
  output wire  M10_PACKER_ERR,
  output wire  M11_PACKER_ERR,
  output wire  M12_PACKER_ERR,
  output wire  M13_PACKER_ERR,
  output wire  M14_PACKER_ERR,
  output wire  M15_PACKER_ERR,
  output wire [32-1:0] M00_FIFO_DATA_COUNT,
  output wire [32-1:0] M01_FIFO_DATA_COUNT,
  output wire [32-1:0] M02_FIFO_DATA_COUNT,
  output wire [32-1:0] M03_FIFO_DATA_COUNT,
  output wire [32-1:0] M04_FIFO_DATA_COUNT,
  output wire [32-1:0] M05_FIFO_DATA_COUNT,
  output wire [32-1:0] M06_FIFO_DATA_COUNT,
  output wire [32-1:0] M07_FIFO_DATA_COUNT,
  output wire [32-1:0] M08_FIFO_DATA_COUNT,
  output wire [32-1:0] M09_FIFO_DATA_COUNT,
  output wire [32-1:0] M10_FIFO_DATA_COUNT,
  output wire [32-1:0] M11_FIFO_DATA_COUNT,
  output wire [32-1:0] M12_FIFO_DATA_COUNT,
  output wire [32-1:0] M13_FIFO_DATA_COUNT,
  output wire [32-1:0] M14_FIFO_DATA_COUNT,
  output wire [32-1:0] M15_FIFO_DATA_COUNT
);

///////////////////////////////////////////////////////////////////////////////
// Function Declarations
///////////////////////////////////////////////////////////////////////////////

// Function to calculate max widths
function integer f_calc_max_width (
  input integer switch_width,
  input [(16)*32-1:0] mi_width_array,
  input [(16)*32-1:0] si_width_array,
  input integer num_mi,
  input integer num_si
  );
  begin : main
    integer si;
    integer mi;
    f_calc_max_width = switch_width;

    for (mi = 0; mi < num_mi; mi = mi + 1) begin 
      if (mi_width_array[mi*32+:32] > f_calc_max_width) begin
        f_calc_max_width = mi_width_array[mi*32+:32];
      end
    end
    for (si = 0; si < num_si; si = si + 1) begin 
      if (si_width_array[si*32+:32] > f_calc_max_width) begin
        f_calc_max_width = si_width_array[si*32+:32];
      end
    end
  end
endfunction

///////////////////////////////////////////////////////////////////////////////
// Local Parameter Declarations
///////////////////////////////////////////////////////////////////////////////
  localparam integer C_AXIS_TDATA_MAX_WIDTH = f_calc_max_width(C_SWITCH_TDATA_WIDTH[0+:32],{C_M15_AXIS_TDATA_WIDTH[0+:32],C_M14_AXIS_TDATA_WIDTH[0+:32],C_M13_AXIS_TDATA_WIDTH[0+:32],C_M12_AXIS_TDATA_WIDTH[0+:32],C_M11_AXIS_TDATA_WIDTH[0+:32],C_M10_AXIS_TDATA_WIDTH[0+:32],C_M09_AXIS_TDATA_WIDTH[0+:32],C_M08_AXIS_TDATA_WIDTH[0+:32],C_M07_AXIS_TDATA_WIDTH[0+:32],C_M06_AXIS_TDATA_WIDTH[0+:32],C_M05_AXIS_TDATA_WIDTH[0+:32],C_M04_AXIS_TDATA_WIDTH[0+:32],C_M03_AXIS_TDATA_WIDTH[0+:32],C_M02_AXIS_TDATA_WIDTH[0+:32],C_M01_AXIS_TDATA_WIDTH[0+:32],C_M00_AXIS_TDATA_WIDTH[0+:32]},{C_S15_AXIS_TDATA_WIDTH[0+:32],C_S14_AXIS_TDATA_WIDTH[0+:32],C_S13_AXIS_TDATA_WIDTH[0+:32],C_S12_AXIS_TDATA_WIDTH[0+:32],C_S11_AXIS_TDATA_WIDTH[0+:32],C_S10_AXIS_TDATA_WIDTH[0+:32],C_S09_AXIS_TDATA_WIDTH[0+:32],C_S08_AXIS_TDATA_WIDTH[0+:32],C_S07_AXIS_TDATA_WIDTH[0+:32],C_S06_AXIS_TDATA_WIDTH[0+:32],C_S05_AXIS_TDATA_WIDTH[0+:32],C_S04_AXIS_TDATA_WIDTH[0+:32],C_S03_AXIS_TDATA_WIDTH[0+:32],C_S02_AXIS_TDATA_WIDTH[0+:32],C_S01_AXIS_TDATA_WIDTH[0+:32],C_S00_AXIS_TDATA_WIDTH[0+:32]},C_NUM_MI_SLOTS,C_NUM_SI_SLOTS);
  localparam integer C_AXIS_TUSER_MAX_WIDTH = f_calc_max_width(C_SWITCH_TUSER_WIDTH[0+:32],{C_M15_AXIS_TUSER_WIDTH[0+:32],C_M14_AXIS_TUSER_WIDTH[0+:32],C_M13_AXIS_TUSER_WIDTH[0+:32],C_M12_AXIS_TUSER_WIDTH[0+:32],C_M11_AXIS_TUSER_WIDTH[0+:32],C_M10_AXIS_TUSER_WIDTH[0+:32],C_M09_AXIS_TUSER_WIDTH[0+:32],C_M08_AXIS_TUSER_WIDTH[0+:32],C_M07_AXIS_TUSER_WIDTH[0+:32],C_M06_AXIS_TUSER_WIDTH[0+:32],C_M05_AXIS_TUSER_WIDTH[0+:32],C_M04_AXIS_TUSER_WIDTH[0+:32],C_M03_AXIS_TUSER_WIDTH[0+:32],C_M02_AXIS_TUSER_WIDTH[0+:32],C_M01_AXIS_TUSER_WIDTH[0+:32],C_M00_AXIS_TUSER_WIDTH[0+:32]},{C_S15_AXIS_TUSER_WIDTH[0+:32],C_S14_AXIS_TUSER_WIDTH[0+:32],C_S13_AXIS_TUSER_WIDTH[0+:32],C_S12_AXIS_TUSER_WIDTH[0+:32],C_S11_AXIS_TUSER_WIDTH[0+:32],C_S10_AXIS_TUSER_WIDTH[0+:32],C_S09_AXIS_TUSER_WIDTH[0+:32],C_S08_AXIS_TUSER_WIDTH[0+:32],C_S07_AXIS_TUSER_WIDTH[0+:32],C_S06_AXIS_TUSER_WIDTH[0+:32],C_S05_AXIS_TUSER_WIDTH[0+:32],C_S04_AXIS_TUSER_WIDTH[0+:32],C_S03_AXIS_TUSER_WIDTH[0+:32],C_S02_AXIS_TUSER_WIDTH[0+:32],C_S01_AXIS_TUSER_WIDTH[0+:32],C_S00_AXIS_TUSER_WIDTH[0+:32]},C_NUM_MI_SLOTS,C_NUM_SI_SLOTS);
  localparam [16*C_NUM_SI_SLOTS-1:0] P_M_AXIS_CONNECTIVITY_ARRAY = {C_M15_AXIS_CONNECTIVITY[C_NUM_SI_SLOTS-1:0],C_M14_AXIS_CONNECTIVITY[C_NUM_SI_SLOTS-1:0],C_M13_AXIS_CONNECTIVITY[C_NUM_SI_SLOTS-1:0],C_M12_AXIS_CONNECTIVITY[C_NUM_SI_SLOTS-1:0],C_M11_AXIS_CONNECTIVITY[C_NUM_SI_SLOTS-1:0],C_M10_AXIS_CONNECTIVITY[C_NUM_SI_SLOTS-1:0],C_M09_AXIS_CONNECTIVITY[C_NUM_SI_SLOTS-1:0],C_M08_AXIS_CONNECTIVITY[C_NUM_SI_SLOTS-1:0],C_M07_AXIS_CONNECTIVITY[C_NUM_SI_SLOTS-1:0],C_M06_AXIS_CONNECTIVITY[C_NUM_SI_SLOTS-1:0],C_M05_AXIS_CONNECTIVITY[C_NUM_SI_SLOTS-1:0],C_M04_AXIS_CONNECTIVITY[C_NUM_SI_SLOTS-1:0],C_M03_AXIS_CONNECTIVITY[C_NUM_SI_SLOTS-1:0],C_M02_AXIS_CONNECTIVITY[C_NUM_SI_SLOTS-1:0],C_M01_AXIS_CONNECTIVITY[C_NUM_SI_SLOTS-1:0],C_M00_AXIS_CONNECTIVITY[C_NUM_SI_SLOTS-1:0]};
  localparam [16*C_SWITCH_TDEST_WIDTH-1:0] P_M_AXIS_BASETDEST_ARRAY = {C_M15_AXIS_BASETDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M14_AXIS_BASETDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M13_AXIS_BASETDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M12_AXIS_BASETDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M11_AXIS_BASETDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M10_AXIS_BASETDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M09_AXIS_BASETDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M08_AXIS_BASETDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M07_AXIS_BASETDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M06_AXIS_BASETDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M05_AXIS_BASETDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M04_AXIS_BASETDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M03_AXIS_BASETDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M02_AXIS_BASETDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M01_AXIS_BASETDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M00_AXIS_BASETDEST[C_SWITCH_TDEST_WIDTH-1:0]};
  localparam [16*C_SWITCH_TDEST_WIDTH-1:0] P_M_AXIS_HIGHTDEST_ARRAY = {C_M15_AXIS_HIGHTDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M14_AXIS_HIGHTDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M13_AXIS_HIGHTDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M12_AXIS_HIGHTDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M11_AXIS_HIGHTDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M10_AXIS_HIGHTDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M09_AXIS_HIGHTDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M08_AXIS_HIGHTDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M07_AXIS_HIGHTDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M06_AXIS_HIGHTDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M05_AXIS_HIGHTDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M04_AXIS_HIGHTDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M03_AXIS_HIGHTDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M02_AXIS_HIGHTDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M01_AXIS_HIGHTDEST[C_SWITCH_TDEST_WIDTH-1:0],C_M00_AXIS_HIGHTDEST[C_SWITCH_TDEST_WIDTH-1:0]};
  localparam [16*32-1:0] P_S_AXIS_TDATA_WIDTH_ARRAY = {C_S15_AXIS_TDATA_WIDTH[32-1:0],C_S14_AXIS_TDATA_WIDTH[32-1:0],C_S13_AXIS_TDATA_WIDTH[32-1:0],C_S12_AXIS_TDATA_WIDTH[32-1:0],C_S11_AXIS_TDATA_WIDTH[32-1:0],C_S10_AXIS_TDATA_WIDTH[32-1:0],C_S09_AXIS_TDATA_WIDTH[32-1:0],C_S08_AXIS_TDATA_WIDTH[32-1:0],C_S07_AXIS_TDATA_WIDTH[32-1:0],C_S06_AXIS_TDATA_WIDTH[32-1:0],C_S05_AXIS_TDATA_WIDTH[32-1:0],C_S04_AXIS_TDATA_WIDTH[32-1:0],C_S03_AXIS_TDATA_WIDTH[32-1:0],C_S02_AXIS_TDATA_WIDTH[32-1:0],C_S01_AXIS_TDATA_WIDTH[32-1:0],C_S00_AXIS_TDATA_WIDTH[32-1:0]};
  localparam [16*32-1:0] P_S_AXIS_TUSER_WIDTH_ARRAY = {C_S15_AXIS_TUSER_WIDTH[32-1:0],C_S14_AXIS_TUSER_WIDTH[32-1:0],C_S13_AXIS_TUSER_WIDTH[32-1:0],C_S12_AXIS_TUSER_WIDTH[32-1:0],C_S11_AXIS_TUSER_WIDTH[32-1:0],C_S10_AXIS_TUSER_WIDTH[32-1:0],C_S09_AXIS_TUSER_WIDTH[32-1:0],C_S08_AXIS_TUSER_WIDTH[32-1:0],C_S07_AXIS_TUSER_WIDTH[32-1:0],C_S06_AXIS_TUSER_WIDTH[32-1:0],C_S05_AXIS_TUSER_WIDTH[32-1:0],C_S04_AXIS_TUSER_WIDTH[32-1:0],C_S03_AXIS_TUSER_WIDTH[32-1:0],C_S02_AXIS_TUSER_WIDTH[32-1:0],C_S01_AXIS_TUSER_WIDTH[32-1:0],C_S00_AXIS_TUSER_WIDTH[32-1:0]};
  localparam [16*32-1:0] P_S_AXIS_IS_ACLK_ASYNC_ARRAY = {C_S15_AXIS_IS_ACLK_ASYNC[32-1:0],C_S14_AXIS_IS_ACLK_ASYNC[32-1:0],C_S13_AXIS_IS_ACLK_ASYNC[32-1:0],C_S12_AXIS_IS_ACLK_ASYNC[32-1:0],C_S11_AXIS_IS_ACLK_ASYNC[32-1:0],C_S10_AXIS_IS_ACLK_ASYNC[32-1:0],C_S09_AXIS_IS_ACLK_ASYNC[32-1:0],C_S08_AXIS_IS_ACLK_ASYNC[32-1:0],C_S07_AXIS_IS_ACLK_ASYNC[32-1:0],C_S06_AXIS_IS_ACLK_ASYNC[32-1:0],C_S05_AXIS_IS_ACLK_ASYNC[32-1:0],C_S04_AXIS_IS_ACLK_ASYNC[32-1:0],C_S03_AXIS_IS_ACLK_ASYNC[32-1:0],C_S02_AXIS_IS_ACLK_ASYNC[32-1:0],C_S01_AXIS_IS_ACLK_ASYNC[32-1:0],C_S00_AXIS_IS_ACLK_ASYNC[32-1:0]};
  localparam [16*32-1:0] P_S_AXIS_ACLK_RATIO_ARRAY = {C_S15_AXIS_ACLK_RATIO[32-1:0],C_S14_AXIS_ACLK_RATIO[32-1:0],C_S13_AXIS_ACLK_RATIO[32-1:0],C_S12_AXIS_ACLK_RATIO[32-1:0],C_S11_AXIS_ACLK_RATIO[32-1:0],C_S10_AXIS_ACLK_RATIO[32-1:0],C_S09_AXIS_ACLK_RATIO[32-1:0],C_S08_AXIS_ACLK_RATIO[32-1:0],C_S07_AXIS_ACLK_RATIO[32-1:0],C_S06_AXIS_ACLK_RATIO[32-1:0],C_S05_AXIS_ACLK_RATIO[32-1:0],C_S04_AXIS_ACLK_RATIO[32-1:0],C_S03_AXIS_ACLK_RATIO[32-1:0],C_S02_AXIS_ACLK_RATIO[32-1:0],C_S01_AXIS_ACLK_RATIO[32-1:0],C_S00_AXIS_ACLK_RATIO[32-1:0]};
  localparam [16*32-1:0] P_S_AXIS_REG_CONFIG_ARRAY = {C_S15_AXIS_REG_CONFIG[32-1:0],C_S14_AXIS_REG_CONFIG[32-1:0],C_S13_AXIS_REG_CONFIG[32-1:0],C_S12_AXIS_REG_CONFIG[32-1:0],C_S11_AXIS_REG_CONFIG[32-1:0],C_S10_AXIS_REG_CONFIG[32-1:0],C_S09_AXIS_REG_CONFIG[32-1:0],C_S08_AXIS_REG_CONFIG[32-1:0],C_S07_AXIS_REG_CONFIG[32-1:0],C_S06_AXIS_REG_CONFIG[32-1:0],C_S05_AXIS_REG_CONFIG[32-1:0],C_S04_AXIS_REG_CONFIG[32-1:0],C_S03_AXIS_REG_CONFIG[32-1:0],C_S02_AXIS_REG_CONFIG[32-1:0],C_S01_AXIS_REG_CONFIG[32-1:0],C_S00_AXIS_REG_CONFIG[32-1:0]};
  localparam [16*32-1:0] P_S_AXIS_FIFO_DEPTH_ARRAY = {C_S15_AXIS_FIFO_DEPTH[32-1:0],C_S14_AXIS_FIFO_DEPTH[32-1:0],C_S13_AXIS_FIFO_DEPTH[32-1:0],C_S12_AXIS_FIFO_DEPTH[32-1:0],C_S11_AXIS_FIFO_DEPTH[32-1:0],C_S10_AXIS_FIFO_DEPTH[32-1:0],C_S09_AXIS_FIFO_DEPTH[32-1:0],C_S08_AXIS_FIFO_DEPTH[32-1:0],C_S07_AXIS_FIFO_DEPTH[32-1:0],C_S06_AXIS_FIFO_DEPTH[32-1:0],C_S05_AXIS_FIFO_DEPTH[32-1:0],C_S04_AXIS_FIFO_DEPTH[32-1:0],C_S03_AXIS_FIFO_DEPTH[32-1:0],C_S02_AXIS_FIFO_DEPTH[32-1:0],C_S01_AXIS_FIFO_DEPTH[32-1:0],C_S00_AXIS_FIFO_DEPTH[32-1:0]};
  localparam [16*32-1:0] P_S_AXIS_FIFO_MODE_ARRAY = {C_S15_AXIS_FIFO_MODE[32-1:0],C_S14_AXIS_FIFO_MODE[32-1:0],C_S13_AXIS_FIFO_MODE[32-1:0],C_S12_AXIS_FIFO_MODE[32-1:0],C_S11_AXIS_FIFO_MODE[32-1:0],C_S10_AXIS_FIFO_MODE[32-1:0],C_S09_AXIS_FIFO_MODE[32-1:0],C_S08_AXIS_FIFO_MODE[32-1:0],C_S07_AXIS_FIFO_MODE[32-1:0],C_S06_AXIS_FIFO_MODE[32-1:0],C_S05_AXIS_FIFO_MODE[32-1:0],C_S04_AXIS_FIFO_MODE[32-1:0],C_S03_AXIS_FIFO_MODE[32-1:0],C_S02_AXIS_FIFO_MODE[32-1:0],C_S01_AXIS_FIFO_MODE[32-1:0],C_S00_AXIS_FIFO_MODE[32-1:0]};
  localparam [16*32-1:0] P_M_AXIS_TDATA_WIDTH_ARRAY = {C_M15_AXIS_TDATA_WIDTH[32-1:0],C_M14_AXIS_TDATA_WIDTH[32-1:0],C_M13_AXIS_TDATA_WIDTH[32-1:0],C_M12_AXIS_TDATA_WIDTH[32-1:0],C_M11_AXIS_TDATA_WIDTH[32-1:0],C_M10_AXIS_TDATA_WIDTH[32-1:0],C_M09_AXIS_TDATA_WIDTH[32-1:0],C_M08_AXIS_TDATA_WIDTH[32-1:0],C_M07_AXIS_TDATA_WIDTH[32-1:0],C_M06_AXIS_TDATA_WIDTH[32-1:0],C_M05_AXIS_TDATA_WIDTH[32-1:0],C_M04_AXIS_TDATA_WIDTH[32-1:0],C_M03_AXIS_TDATA_WIDTH[32-1:0],C_M02_AXIS_TDATA_WIDTH[32-1:0],C_M01_AXIS_TDATA_WIDTH[32-1:0],C_M00_AXIS_TDATA_WIDTH[32-1:0]};
  localparam [16*32-1:0] P_M_AXIS_TUSER_WIDTH_ARRAY = {C_M15_AXIS_TUSER_WIDTH[32-1:0],C_M14_AXIS_TUSER_WIDTH[32-1:0],C_M13_AXIS_TUSER_WIDTH[32-1:0],C_M12_AXIS_TUSER_WIDTH[32-1:0],C_M11_AXIS_TUSER_WIDTH[32-1:0],C_M10_AXIS_TUSER_WIDTH[32-1:0],C_M09_AXIS_TUSER_WIDTH[32-1:0],C_M08_AXIS_TUSER_WIDTH[32-1:0],C_M07_AXIS_TUSER_WIDTH[32-1:0],C_M06_AXIS_TUSER_WIDTH[32-1:0],C_M05_AXIS_TUSER_WIDTH[32-1:0],C_M04_AXIS_TUSER_WIDTH[32-1:0],C_M03_AXIS_TUSER_WIDTH[32-1:0],C_M02_AXIS_TUSER_WIDTH[32-1:0],C_M01_AXIS_TUSER_WIDTH[32-1:0],C_M00_AXIS_TUSER_WIDTH[32-1:0]};
  localparam [16*32-1:0] P_M_AXIS_ACLK_RATIO_ARRAY = {C_M15_AXIS_ACLK_RATIO[32-1:0],C_M14_AXIS_ACLK_RATIO[32-1:0],C_M13_AXIS_ACLK_RATIO[32-1:0],C_M12_AXIS_ACLK_RATIO[32-1:0],C_M11_AXIS_ACLK_RATIO[32-1:0],C_M10_AXIS_ACLK_RATIO[32-1:0],C_M09_AXIS_ACLK_RATIO[32-1:0],C_M08_AXIS_ACLK_RATIO[32-1:0],C_M07_AXIS_ACLK_RATIO[32-1:0],C_M06_AXIS_ACLK_RATIO[32-1:0],C_M05_AXIS_ACLK_RATIO[32-1:0],C_M04_AXIS_ACLK_RATIO[32-1:0],C_M03_AXIS_ACLK_RATIO[32-1:0],C_M02_AXIS_ACLK_RATIO[32-1:0],C_M01_AXIS_ACLK_RATIO[32-1:0],C_M00_AXIS_ACLK_RATIO[32-1:0]};
  localparam [16*32-1:0] P_M_AXIS_REG_CONFIG_ARRAY = {C_M15_AXIS_REG_CONFIG[32-1:0],C_M14_AXIS_REG_CONFIG[32-1:0],C_M13_AXIS_REG_CONFIG[32-1:0],C_M12_AXIS_REG_CONFIG[32-1:0],C_M11_AXIS_REG_CONFIG[32-1:0],C_M10_AXIS_REG_CONFIG[32-1:0],C_M09_AXIS_REG_CONFIG[32-1:0],C_M08_AXIS_REG_CONFIG[32-1:0],C_M07_AXIS_REG_CONFIG[32-1:0],C_M06_AXIS_REG_CONFIG[32-1:0],C_M05_AXIS_REG_CONFIG[32-1:0],C_M04_AXIS_REG_CONFIG[32-1:0],C_M03_AXIS_REG_CONFIG[32-1:0],C_M02_AXIS_REG_CONFIG[32-1:0],C_M01_AXIS_REG_CONFIG[32-1:0],C_M00_AXIS_REG_CONFIG[32-1:0]};
  localparam [16*32-1:0] P_M_AXIS_IS_ACLK_ASYNC_ARRAY = {C_M15_AXIS_IS_ACLK_ASYNC[32-1:0],C_M14_AXIS_IS_ACLK_ASYNC[32-1:0],C_M13_AXIS_IS_ACLK_ASYNC[32-1:0],C_M12_AXIS_IS_ACLK_ASYNC[32-1:0],C_M11_AXIS_IS_ACLK_ASYNC[32-1:0],C_M10_AXIS_IS_ACLK_ASYNC[32-1:0],C_M09_AXIS_IS_ACLK_ASYNC[32-1:0],C_M08_AXIS_IS_ACLK_ASYNC[32-1:0],C_M07_AXIS_IS_ACLK_ASYNC[32-1:0],C_M06_AXIS_IS_ACLK_ASYNC[32-1:0],C_M05_AXIS_IS_ACLK_ASYNC[32-1:0],C_M04_AXIS_IS_ACLK_ASYNC[32-1:0],C_M03_AXIS_IS_ACLK_ASYNC[32-1:0],C_M02_AXIS_IS_ACLK_ASYNC[32-1:0],C_M01_AXIS_IS_ACLK_ASYNC[32-1:0],C_M00_AXIS_IS_ACLK_ASYNC[32-1:0]};
  localparam [16*32-1:0] P_M_AXIS_FIFO_DEPTH_ARRAY = {C_M15_AXIS_FIFO_DEPTH[32-1:0],C_M14_AXIS_FIFO_DEPTH[32-1:0],C_M13_AXIS_FIFO_DEPTH[32-1:0],C_M12_AXIS_FIFO_DEPTH[32-1:0],C_M11_AXIS_FIFO_DEPTH[32-1:0],C_M10_AXIS_FIFO_DEPTH[32-1:0],C_M09_AXIS_FIFO_DEPTH[32-1:0],C_M08_AXIS_FIFO_DEPTH[32-1:0],C_M07_AXIS_FIFO_DEPTH[32-1:0],C_M06_AXIS_FIFO_DEPTH[32-1:0],C_M05_AXIS_FIFO_DEPTH[32-1:0],C_M04_AXIS_FIFO_DEPTH[32-1:0],C_M03_AXIS_FIFO_DEPTH[32-1:0],C_M02_AXIS_FIFO_DEPTH[32-1:0],C_M01_AXIS_FIFO_DEPTH[32-1:0],C_M00_AXIS_FIFO_DEPTH[32-1:0]};
  localparam [16*32-1:0] P_M_AXIS_FIFO_MODE_ARRAY = {C_M15_AXIS_FIFO_MODE[32-1:0],C_M14_AXIS_FIFO_MODE[32-1:0],C_M13_AXIS_FIFO_MODE[32-1:0],C_M12_AXIS_FIFO_MODE[32-1:0],C_M11_AXIS_FIFO_MODE[32-1:0],C_M10_AXIS_FIFO_MODE[32-1:0],C_M09_AXIS_FIFO_MODE[32-1:0],C_M08_AXIS_FIFO_MODE[32-1:0],C_M07_AXIS_FIFO_MODE[32-1:0],C_M06_AXIS_FIFO_MODE[32-1:0],C_M05_AXIS_FIFO_MODE[32-1:0],C_M04_AXIS_FIFO_MODE[32-1:0],C_M03_AXIS_FIFO_MODE[32-1:0],C_M02_AXIS_FIFO_MODE[32-1:0],C_M01_AXIS_FIFO_MODE[32-1:0],C_M00_AXIS_FIFO_MODE[32-1:0]};

///////////////////////////////////////////////////////////////////////////////
// Wire Declarations
///////////////////////////////////////////////////////////////////////////////
  wire [16*1-1:0] s_axis_aclk_i;
  wire [16*1-1:0] s_axis_aresetn_i;
  wire [16*1-1:0] s_axis_aclken_i;
  wire [16*1-1:0] s_axis_tvalid_i;
  wire [16*1-1:0] s_axis_tready_i;
  wire [16*C_AXIS_TDATA_MAX_WIDTH-1:0] s_axis_tdata_i;
  wire [16*C_AXIS_TDATA_MAX_WIDTH/8-1:0] s_axis_tstrb_i;
  wire [16*C_AXIS_TDATA_MAX_WIDTH/8-1:0] s_axis_tkeep_i;
  wire [16*1-1:0] s_axis_tlast_i;
  wire [16*C_SWITCH_TID_WIDTH-1:0] s_axis_tid_i;
  wire [16*C_SWITCH_TDEST_WIDTH-1:0] s_axis_tdest_i;
  wire [16*C_AXIS_TUSER_MAX_WIDTH-1:0] s_axis_tuser_i;
  wire [16*1-1:0] m_axis_aclk_i;
  wire [16*1-1:0] m_axis_aresetn_i;
  wire [16*1-1:0] m_axis_aclken_i;
  wire [16*1-1:0] m_axis_tvalid_i;
  wire [16*1-1:0] m_axis_tready_i;
  wire [16*C_AXIS_TDATA_MAX_WIDTH-1:0] m_axis_tdata_i;
  wire [16*C_AXIS_TDATA_MAX_WIDTH/8-1:0] m_axis_tstrb_i;
  wire [16*C_AXIS_TDATA_MAX_WIDTH/8-1:0] m_axis_tkeep_i;
  wire [16*1-1:0] m_axis_tlast_i;
  wire [16*C_SWITCH_TID_WIDTH-1:0] m_axis_tid_i;
  wire [16*C_SWITCH_TDEST_WIDTH-1:0] m_axis_tdest_i;
  wire [16*C_AXIS_TUSER_MAX_WIDTH-1:0] m_axis_tuser_i;
  wire [16*1-1:0] s_arb_req_suppress_i;
  wire [16*1-1:0] s_decode_err_i;
  wire [16*1-1:0] s_sparse_tkeep_removed_i;
  wire [16*1-1:0] s_packer_err_i;
  wire [16*32-1:0] s_fifo_data_count_i;
  wire [16*1-1:0] m_sparse_tkeep_removed_i;
  wire [16*1-1:0] m_packer_err_i;
  wire [16*32-1:0] m_fifo_data_count_i;

///////////////////////////////////////////////////////////////////////////////
// RTL
///////////////////////////////////////////////////////////////////////////////
  assign s_axis_aclk_i[0*1+:1] = S00_AXIS_ACLK;
  assign s_axis_aclk_i[1*1+:1] = S01_AXIS_ACLK;
  assign s_axis_aclk_i[2*1+:1] = S02_AXIS_ACLK;
  assign s_axis_aclk_i[3*1+:1] = S03_AXIS_ACLK;
  assign s_axis_aclk_i[4*1+:1] = S04_AXIS_ACLK;
  assign s_axis_aclk_i[5*1+:1] = S05_AXIS_ACLK;
  assign s_axis_aclk_i[6*1+:1] = S06_AXIS_ACLK;
  assign s_axis_aclk_i[7*1+:1] = S07_AXIS_ACLK;
  assign s_axis_aclk_i[8*1+:1] = S08_AXIS_ACLK;
  assign s_axis_aclk_i[9*1+:1] = S09_AXIS_ACLK;
  assign s_axis_aclk_i[10*1+:1] = S10_AXIS_ACLK;
  assign s_axis_aclk_i[11*1+:1] = S11_AXIS_ACLK;
  assign s_axis_aclk_i[12*1+:1] = S12_AXIS_ACLK;
  assign s_axis_aclk_i[13*1+:1] = S13_AXIS_ACLK;
  assign s_axis_aclk_i[14*1+:1] = S14_AXIS_ACLK;
  assign s_axis_aclk_i[15*1+:1] = S15_AXIS_ACLK;
  assign s_axis_aresetn_i[0*1+:1] = S00_AXIS_ARESETN;
  assign s_axis_aresetn_i[1*1+:1] = S01_AXIS_ARESETN;
  assign s_axis_aresetn_i[2*1+:1] = S02_AXIS_ARESETN;
  assign s_axis_aresetn_i[3*1+:1] = S03_AXIS_ARESETN;
  assign s_axis_aresetn_i[4*1+:1] = S04_AXIS_ARESETN;
  assign s_axis_aresetn_i[5*1+:1] = S05_AXIS_ARESETN;
  assign s_axis_aresetn_i[6*1+:1] = S06_AXIS_ARESETN;
  assign s_axis_aresetn_i[7*1+:1] = S07_AXIS_ARESETN;
  assign s_axis_aresetn_i[8*1+:1] = S08_AXIS_ARESETN;
  assign s_axis_aresetn_i[9*1+:1] = S09_AXIS_ARESETN;
  assign s_axis_aresetn_i[10*1+:1] = S10_AXIS_ARESETN;
  assign s_axis_aresetn_i[11*1+:1] = S11_AXIS_ARESETN;
  assign s_axis_aresetn_i[12*1+:1] = S12_AXIS_ARESETN;
  assign s_axis_aresetn_i[13*1+:1] = S13_AXIS_ARESETN;
  assign s_axis_aresetn_i[14*1+:1] = S14_AXIS_ARESETN;
  assign s_axis_aresetn_i[15*1+:1] = S15_AXIS_ARESETN;
  assign s_axis_aclken_i[0*1+:1] = S00_AXIS_ACLKEN;
  assign s_axis_aclken_i[1*1+:1] = S01_AXIS_ACLKEN;
  assign s_axis_aclken_i[2*1+:1] = S02_AXIS_ACLKEN;
  assign s_axis_aclken_i[3*1+:1] = S03_AXIS_ACLKEN;
  assign s_axis_aclken_i[4*1+:1] = S04_AXIS_ACLKEN;
  assign s_axis_aclken_i[5*1+:1] = S05_AXIS_ACLKEN;
  assign s_axis_aclken_i[6*1+:1] = S06_AXIS_ACLKEN;
  assign s_axis_aclken_i[7*1+:1] = S07_AXIS_ACLKEN;
  assign s_axis_aclken_i[8*1+:1] = S08_AXIS_ACLKEN;
  assign s_axis_aclken_i[9*1+:1] = S09_AXIS_ACLKEN;
  assign s_axis_aclken_i[10*1+:1] = S10_AXIS_ACLKEN;
  assign s_axis_aclken_i[11*1+:1] = S11_AXIS_ACLKEN;
  assign s_axis_aclken_i[12*1+:1] = S12_AXIS_ACLKEN;
  assign s_axis_aclken_i[13*1+:1] = S13_AXIS_ACLKEN;
  assign s_axis_aclken_i[14*1+:1] = S14_AXIS_ACLKEN;
  assign s_axis_aclken_i[15*1+:1] = S15_AXIS_ACLKEN;
  assign s_axis_tvalid_i[0*1+:1] = S00_AXIS_TVALID;
  assign s_axis_tvalid_i[1*1+:1] = S01_AXIS_TVALID;
  assign s_axis_tvalid_i[2*1+:1] = S02_AXIS_TVALID;
  assign s_axis_tvalid_i[3*1+:1] = S03_AXIS_TVALID;
  assign s_axis_tvalid_i[4*1+:1] = S04_AXIS_TVALID;
  assign s_axis_tvalid_i[5*1+:1] = S05_AXIS_TVALID;
  assign s_axis_tvalid_i[6*1+:1] = S06_AXIS_TVALID;
  assign s_axis_tvalid_i[7*1+:1] = S07_AXIS_TVALID;
  assign s_axis_tvalid_i[8*1+:1] = S08_AXIS_TVALID;
  assign s_axis_tvalid_i[9*1+:1] = S09_AXIS_TVALID;
  assign s_axis_tvalid_i[10*1+:1] = S10_AXIS_TVALID;
  assign s_axis_tvalid_i[11*1+:1] = S11_AXIS_TVALID;
  assign s_axis_tvalid_i[12*1+:1] = S12_AXIS_TVALID;
  assign s_axis_tvalid_i[13*1+:1] = S13_AXIS_TVALID;
  assign s_axis_tvalid_i[14*1+:1] = S14_AXIS_TVALID;
  assign s_axis_tvalid_i[15*1+:1] = S15_AXIS_TVALID;
  assign S00_AXIS_TREADY = s_axis_tready_i[0*1+:1];
  assign S01_AXIS_TREADY = s_axis_tready_i[1*1+:1];
  assign S02_AXIS_TREADY = s_axis_tready_i[2*1+:1];
  assign S03_AXIS_TREADY = s_axis_tready_i[3*1+:1];
  assign S04_AXIS_TREADY = s_axis_tready_i[4*1+:1];
  assign S05_AXIS_TREADY = s_axis_tready_i[5*1+:1];
  assign S06_AXIS_TREADY = s_axis_tready_i[6*1+:1];
  assign S07_AXIS_TREADY = s_axis_tready_i[7*1+:1];
  assign S08_AXIS_TREADY = s_axis_tready_i[8*1+:1];
  assign S09_AXIS_TREADY = s_axis_tready_i[9*1+:1];
  assign S10_AXIS_TREADY = s_axis_tready_i[10*1+:1];
  assign S11_AXIS_TREADY = s_axis_tready_i[11*1+:1];
  assign S12_AXIS_TREADY = s_axis_tready_i[12*1+:1];
  assign S13_AXIS_TREADY = s_axis_tready_i[13*1+:1];
  assign S14_AXIS_TREADY = s_axis_tready_i[14*1+:1];
  assign S15_AXIS_TREADY = s_axis_tready_i[15*1+:1];
  assign s_axis_tdata_i[0*C_AXIS_TDATA_MAX_WIDTH+:C_S00_AXIS_TDATA_WIDTH] = S00_AXIS_TDATA[C_S00_AXIS_TDATA_WIDTH-1:0];
  assign s_axis_tdata_i[1*C_AXIS_TDATA_MAX_WIDTH+:C_S01_AXIS_TDATA_WIDTH] = S01_AXIS_TDATA[C_S01_AXIS_TDATA_WIDTH-1:0];
  assign s_axis_tdata_i[2*C_AXIS_TDATA_MAX_WIDTH+:C_S02_AXIS_TDATA_WIDTH] = S02_AXIS_TDATA[C_S02_AXIS_TDATA_WIDTH-1:0];
  assign s_axis_tdata_i[3*C_AXIS_TDATA_MAX_WIDTH+:C_S03_AXIS_TDATA_WIDTH] = S03_AXIS_TDATA[C_S03_AXIS_TDATA_WIDTH-1:0];
  assign s_axis_tdata_i[4*C_AXIS_TDATA_MAX_WIDTH+:C_S04_AXIS_TDATA_WIDTH] = S04_AXIS_TDATA[C_S04_AXIS_TDATA_WIDTH-1:0];
  assign s_axis_tdata_i[5*C_AXIS_TDATA_MAX_WIDTH+:C_S05_AXIS_TDATA_WIDTH] = S05_AXIS_TDATA[C_S05_AXIS_TDATA_WIDTH-1:0];
  assign s_axis_tdata_i[6*C_AXIS_TDATA_MAX_WIDTH+:C_S06_AXIS_TDATA_WIDTH] = S06_AXIS_TDATA[C_S06_AXIS_TDATA_WIDTH-1:0];
  assign s_axis_tdata_i[7*C_AXIS_TDATA_MAX_WIDTH+:C_S07_AXIS_TDATA_WIDTH] = S07_AXIS_TDATA[C_S07_AXIS_TDATA_WIDTH-1:0];
  assign s_axis_tdata_i[8*C_AXIS_TDATA_MAX_WIDTH+:C_S08_AXIS_TDATA_WIDTH] = S08_AXIS_TDATA[C_S08_AXIS_TDATA_WIDTH-1:0];
  assign s_axis_tdata_i[9*C_AXIS_TDATA_MAX_WIDTH+:C_S09_AXIS_TDATA_WIDTH] = S09_AXIS_TDATA[C_S09_AXIS_TDATA_WIDTH-1:0];
  assign s_axis_tdata_i[10*C_AXIS_TDATA_MAX_WIDTH+:C_S10_AXIS_TDATA_WIDTH] = S10_AXIS_TDATA[C_S10_AXIS_TDATA_WIDTH-1:0];
  assign s_axis_tdata_i[11*C_AXIS_TDATA_MAX_WIDTH+:C_S11_AXIS_TDATA_WIDTH] = S11_AXIS_TDATA[C_S11_AXIS_TDATA_WIDTH-1:0];
  assign s_axis_tdata_i[12*C_AXIS_TDATA_MAX_WIDTH+:C_S12_AXIS_TDATA_WIDTH] = S12_AXIS_TDATA[C_S12_AXIS_TDATA_WIDTH-1:0];
  assign s_axis_tdata_i[13*C_AXIS_TDATA_MAX_WIDTH+:C_S13_AXIS_TDATA_WIDTH] = S13_AXIS_TDATA[C_S13_AXIS_TDATA_WIDTH-1:0];
  assign s_axis_tdata_i[14*C_AXIS_TDATA_MAX_WIDTH+:C_S14_AXIS_TDATA_WIDTH] = S14_AXIS_TDATA[C_S14_AXIS_TDATA_WIDTH-1:0];
  assign s_axis_tdata_i[15*C_AXIS_TDATA_MAX_WIDTH+:C_S15_AXIS_TDATA_WIDTH] = S15_AXIS_TDATA[C_S15_AXIS_TDATA_WIDTH-1:0];
  assign s_axis_tstrb_i[0*C_AXIS_TDATA_MAX_WIDTH/8+:C_S00_AXIS_TDATA_WIDTH/8] = S00_AXIS_TSTRB[C_S00_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tstrb_i[1*C_AXIS_TDATA_MAX_WIDTH/8+:C_S01_AXIS_TDATA_WIDTH/8] = S01_AXIS_TSTRB[C_S01_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tstrb_i[2*C_AXIS_TDATA_MAX_WIDTH/8+:C_S02_AXIS_TDATA_WIDTH/8] = S02_AXIS_TSTRB[C_S02_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tstrb_i[3*C_AXIS_TDATA_MAX_WIDTH/8+:C_S03_AXIS_TDATA_WIDTH/8] = S03_AXIS_TSTRB[C_S03_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tstrb_i[4*C_AXIS_TDATA_MAX_WIDTH/8+:C_S04_AXIS_TDATA_WIDTH/8] = S04_AXIS_TSTRB[C_S04_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tstrb_i[5*C_AXIS_TDATA_MAX_WIDTH/8+:C_S05_AXIS_TDATA_WIDTH/8] = S05_AXIS_TSTRB[C_S05_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tstrb_i[6*C_AXIS_TDATA_MAX_WIDTH/8+:C_S06_AXIS_TDATA_WIDTH/8] = S06_AXIS_TSTRB[C_S06_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tstrb_i[7*C_AXIS_TDATA_MAX_WIDTH/8+:C_S07_AXIS_TDATA_WIDTH/8] = S07_AXIS_TSTRB[C_S07_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tstrb_i[8*C_AXIS_TDATA_MAX_WIDTH/8+:C_S08_AXIS_TDATA_WIDTH/8] = S08_AXIS_TSTRB[C_S08_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tstrb_i[9*C_AXIS_TDATA_MAX_WIDTH/8+:C_S09_AXIS_TDATA_WIDTH/8] = S09_AXIS_TSTRB[C_S09_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tstrb_i[10*C_AXIS_TDATA_MAX_WIDTH/8+:C_S10_AXIS_TDATA_WIDTH/8] = S10_AXIS_TSTRB[C_S10_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tstrb_i[11*C_AXIS_TDATA_MAX_WIDTH/8+:C_S11_AXIS_TDATA_WIDTH/8] = S11_AXIS_TSTRB[C_S11_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tstrb_i[12*C_AXIS_TDATA_MAX_WIDTH/8+:C_S12_AXIS_TDATA_WIDTH/8] = S12_AXIS_TSTRB[C_S12_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tstrb_i[13*C_AXIS_TDATA_MAX_WIDTH/8+:C_S13_AXIS_TDATA_WIDTH/8] = S13_AXIS_TSTRB[C_S13_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tstrb_i[14*C_AXIS_TDATA_MAX_WIDTH/8+:C_S14_AXIS_TDATA_WIDTH/8] = S14_AXIS_TSTRB[C_S14_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tstrb_i[15*C_AXIS_TDATA_MAX_WIDTH/8+:C_S15_AXIS_TDATA_WIDTH/8] = S15_AXIS_TSTRB[C_S15_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tkeep_i[0*C_AXIS_TDATA_MAX_WIDTH/8+:C_S00_AXIS_TDATA_WIDTH/8] = S00_AXIS_TKEEP[C_S00_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tkeep_i[1*C_AXIS_TDATA_MAX_WIDTH/8+:C_S01_AXIS_TDATA_WIDTH/8] = S01_AXIS_TKEEP[C_S01_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tkeep_i[2*C_AXIS_TDATA_MAX_WIDTH/8+:C_S02_AXIS_TDATA_WIDTH/8] = S02_AXIS_TKEEP[C_S02_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tkeep_i[3*C_AXIS_TDATA_MAX_WIDTH/8+:C_S03_AXIS_TDATA_WIDTH/8] = S03_AXIS_TKEEP[C_S03_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tkeep_i[4*C_AXIS_TDATA_MAX_WIDTH/8+:C_S04_AXIS_TDATA_WIDTH/8] = S04_AXIS_TKEEP[C_S04_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tkeep_i[5*C_AXIS_TDATA_MAX_WIDTH/8+:C_S05_AXIS_TDATA_WIDTH/8] = S05_AXIS_TKEEP[C_S05_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tkeep_i[6*C_AXIS_TDATA_MAX_WIDTH/8+:C_S06_AXIS_TDATA_WIDTH/8] = S06_AXIS_TKEEP[C_S06_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tkeep_i[7*C_AXIS_TDATA_MAX_WIDTH/8+:C_S07_AXIS_TDATA_WIDTH/8] = S07_AXIS_TKEEP[C_S07_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tkeep_i[8*C_AXIS_TDATA_MAX_WIDTH/8+:C_S08_AXIS_TDATA_WIDTH/8] = S08_AXIS_TKEEP[C_S08_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tkeep_i[9*C_AXIS_TDATA_MAX_WIDTH/8+:C_S09_AXIS_TDATA_WIDTH/8] = S09_AXIS_TKEEP[C_S09_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tkeep_i[10*C_AXIS_TDATA_MAX_WIDTH/8+:C_S10_AXIS_TDATA_WIDTH/8] = S10_AXIS_TKEEP[C_S10_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tkeep_i[11*C_AXIS_TDATA_MAX_WIDTH/8+:C_S11_AXIS_TDATA_WIDTH/8] = S11_AXIS_TKEEP[C_S11_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tkeep_i[12*C_AXIS_TDATA_MAX_WIDTH/8+:C_S12_AXIS_TDATA_WIDTH/8] = S12_AXIS_TKEEP[C_S12_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tkeep_i[13*C_AXIS_TDATA_MAX_WIDTH/8+:C_S13_AXIS_TDATA_WIDTH/8] = S13_AXIS_TKEEP[C_S13_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tkeep_i[14*C_AXIS_TDATA_MAX_WIDTH/8+:C_S14_AXIS_TDATA_WIDTH/8] = S14_AXIS_TKEEP[C_S14_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tkeep_i[15*C_AXIS_TDATA_MAX_WIDTH/8+:C_S15_AXIS_TDATA_WIDTH/8] = S15_AXIS_TKEEP[C_S15_AXIS_TDATA_WIDTH/8-1:0];
  assign s_axis_tlast_i[0*1+:1] = S00_AXIS_TLAST;
  assign s_axis_tlast_i[1*1+:1] = S01_AXIS_TLAST;
  assign s_axis_tlast_i[2*1+:1] = S02_AXIS_TLAST;
  assign s_axis_tlast_i[3*1+:1] = S03_AXIS_TLAST;
  assign s_axis_tlast_i[4*1+:1] = S04_AXIS_TLAST;
  assign s_axis_tlast_i[5*1+:1] = S05_AXIS_TLAST;
  assign s_axis_tlast_i[6*1+:1] = S06_AXIS_TLAST;
  assign s_axis_tlast_i[7*1+:1] = S07_AXIS_TLAST;
  assign s_axis_tlast_i[8*1+:1] = S08_AXIS_TLAST;
  assign s_axis_tlast_i[9*1+:1] = S09_AXIS_TLAST;
  assign s_axis_tlast_i[10*1+:1] = S10_AXIS_TLAST;
  assign s_axis_tlast_i[11*1+:1] = S11_AXIS_TLAST;
  assign s_axis_tlast_i[12*1+:1] = S12_AXIS_TLAST;
  assign s_axis_tlast_i[13*1+:1] = S13_AXIS_TLAST;
  assign s_axis_tlast_i[14*1+:1] = S14_AXIS_TLAST;
  assign s_axis_tlast_i[15*1+:1] = S15_AXIS_TLAST;
  assign s_axis_tid_i[0*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH] = S00_AXIS_TID[C_SWITCH_TID_WIDTH-1:0];
  assign s_axis_tid_i[1*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH] = S01_AXIS_TID[C_SWITCH_TID_WIDTH-1:0];
  assign s_axis_tid_i[2*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH] = S02_AXIS_TID[C_SWITCH_TID_WIDTH-1:0];
  assign s_axis_tid_i[3*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH] = S03_AXIS_TID[C_SWITCH_TID_WIDTH-1:0];
  assign s_axis_tid_i[4*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH] = S04_AXIS_TID[C_SWITCH_TID_WIDTH-1:0];
  assign s_axis_tid_i[5*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH] = S05_AXIS_TID[C_SWITCH_TID_WIDTH-1:0];
  assign s_axis_tid_i[6*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH] = S06_AXIS_TID[C_SWITCH_TID_WIDTH-1:0];
  assign s_axis_tid_i[7*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH] = S07_AXIS_TID[C_SWITCH_TID_WIDTH-1:0];
  assign s_axis_tid_i[8*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH] = S08_AXIS_TID[C_SWITCH_TID_WIDTH-1:0];
  assign s_axis_tid_i[9*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH] = S09_AXIS_TID[C_SWITCH_TID_WIDTH-1:0];
  assign s_axis_tid_i[10*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH] = S10_AXIS_TID[C_SWITCH_TID_WIDTH-1:0];
  assign s_axis_tid_i[11*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH] = S11_AXIS_TID[C_SWITCH_TID_WIDTH-1:0];
  assign s_axis_tid_i[12*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH] = S12_AXIS_TID[C_SWITCH_TID_WIDTH-1:0];
  assign s_axis_tid_i[13*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH] = S13_AXIS_TID[C_SWITCH_TID_WIDTH-1:0];
  assign s_axis_tid_i[14*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH] = S14_AXIS_TID[C_SWITCH_TID_WIDTH-1:0];
  assign s_axis_tid_i[15*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH] = S15_AXIS_TID[C_SWITCH_TID_WIDTH-1:0];
  assign s_axis_tdest_i[0*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH] = S00_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0];
  assign s_axis_tdest_i[1*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH] = S01_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0];
  assign s_axis_tdest_i[2*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH] = S02_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0];
  assign s_axis_tdest_i[3*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH] = S03_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0];
  assign s_axis_tdest_i[4*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH] = S04_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0];
  assign s_axis_tdest_i[5*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH] = S05_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0];
  assign s_axis_tdest_i[6*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH] = S06_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0];
  assign s_axis_tdest_i[7*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH] = S07_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0];
  assign s_axis_tdest_i[8*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH] = S08_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0];
  assign s_axis_tdest_i[9*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH] = S09_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0];
  assign s_axis_tdest_i[10*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH] = S10_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0];
  assign s_axis_tdest_i[11*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH] = S11_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0];
  assign s_axis_tdest_i[12*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH] = S12_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0];
  assign s_axis_tdest_i[13*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH] = S13_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0];
  assign s_axis_tdest_i[14*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH] = S14_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0];
  assign s_axis_tdest_i[15*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH] = S15_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0];
  assign s_axis_tuser_i[0*C_AXIS_TUSER_MAX_WIDTH+:C_S00_AXIS_TUSER_WIDTH] = S00_AXIS_TUSER[C_S00_AXIS_TUSER_WIDTH-1:0];
  assign s_axis_tuser_i[1*C_AXIS_TUSER_MAX_WIDTH+:C_S01_AXIS_TUSER_WIDTH] = S01_AXIS_TUSER[C_S01_AXIS_TUSER_WIDTH-1:0];
  assign s_axis_tuser_i[2*C_AXIS_TUSER_MAX_WIDTH+:C_S02_AXIS_TUSER_WIDTH] = S02_AXIS_TUSER[C_S02_AXIS_TUSER_WIDTH-1:0];
  assign s_axis_tuser_i[3*C_AXIS_TUSER_MAX_WIDTH+:C_S03_AXIS_TUSER_WIDTH] = S03_AXIS_TUSER[C_S03_AXIS_TUSER_WIDTH-1:0];
  assign s_axis_tuser_i[4*C_AXIS_TUSER_MAX_WIDTH+:C_S04_AXIS_TUSER_WIDTH] = S04_AXIS_TUSER[C_S04_AXIS_TUSER_WIDTH-1:0];
  assign s_axis_tuser_i[5*C_AXIS_TUSER_MAX_WIDTH+:C_S05_AXIS_TUSER_WIDTH] = S05_AXIS_TUSER[C_S05_AXIS_TUSER_WIDTH-1:0];
  assign s_axis_tuser_i[6*C_AXIS_TUSER_MAX_WIDTH+:C_S06_AXIS_TUSER_WIDTH] = S06_AXIS_TUSER[C_S06_AXIS_TUSER_WIDTH-1:0];
  assign s_axis_tuser_i[7*C_AXIS_TUSER_MAX_WIDTH+:C_S07_AXIS_TUSER_WIDTH] = S07_AXIS_TUSER[C_S07_AXIS_TUSER_WIDTH-1:0];
  assign s_axis_tuser_i[8*C_AXIS_TUSER_MAX_WIDTH+:C_S08_AXIS_TUSER_WIDTH] = S08_AXIS_TUSER[C_S08_AXIS_TUSER_WIDTH-1:0];
  assign s_axis_tuser_i[9*C_AXIS_TUSER_MAX_WIDTH+:C_S09_AXIS_TUSER_WIDTH] = S09_AXIS_TUSER[C_S09_AXIS_TUSER_WIDTH-1:0];
  assign s_axis_tuser_i[10*C_AXIS_TUSER_MAX_WIDTH+:C_S10_AXIS_TUSER_WIDTH] = S10_AXIS_TUSER[C_S10_AXIS_TUSER_WIDTH-1:0];
  assign s_axis_tuser_i[11*C_AXIS_TUSER_MAX_WIDTH+:C_S11_AXIS_TUSER_WIDTH] = S11_AXIS_TUSER[C_S11_AXIS_TUSER_WIDTH-1:0];
  assign s_axis_tuser_i[12*C_AXIS_TUSER_MAX_WIDTH+:C_S12_AXIS_TUSER_WIDTH] = S12_AXIS_TUSER[C_S12_AXIS_TUSER_WIDTH-1:0];
  assign s_axis_tuser_i[13*C_AXIS_TUSER_MAX_WIDTH+:C_S13_AXIS_TUSER_WIDTH] = S13_AXIS_TUSER[C_S13_AXIS_TUSER_WIDTH-1:0];
  assign s_axis_tuser_i[14*C_AXIS_TUSER_MAX_WIDTH+:C_S14_AXIS_TUSER_WIDTH] = S14_AXIS_TUSER[C_S14_AXIS_TUSER_WIDTH-1:0];
  assign s_axis_tuser_i[15*C_AXIS_TUSER_MAX_WIDTH+:C_S15_AXIS_TUSER_WIDTH] = S15_AXIS_TUSER[C_S15_AXIS_TUSER_WIDTH-1:0];
  assign m_axis_aclk_i[0*1+:1] = M00_AXIS_ACLK;
  assign m_axis_aclk_i[1*1+:1] = M01_AXIS_ACLK;
  assign m_axis_aclk_i[2*1+:1] = M02_AXIS_ACLK;
  assign m_axis_aclk_i[3*1+:1] = M03_AXIS_ACLK;
  assign m_axis_aclk_i[4*1+:1] = M04_AXIS_ACLK;
  assign m_axis_aclk_i[5*1+:1] = M05_AXIS_ACLK;
  assign m_axis_aclk_i[6*1+:1] = M06_AXIS_ACLK;
  assign m_axis_aclk_i[7*1+:1] = M07_AXIS_ACLK;
  assign m_axis_aclk_i[8*1+:1] = M08_AXIS_ACLK;
  assign m_axis_aclk_i[9*1+:1] = M09_AXIS_ACLK;
  assign m_axis_aclk_i[10*1+:1] = M10_AXIS_ACLK;
  assign m_axis_aclk_i[11*1+:1] = M11_AXIS_ACLK;
  assign m_axis_aclk_i[12*1+:1] = M12_AXIS_ACLK;
  assign m_axis_aclk_i[13*1+:1] = M13_AXIS_ACLK;
  assign m_axis_aclk_i[14*1+:1] = M14_AXIS_ACLK;
  assign m_axis_aclk_i[15*1+:1] = M15_AXIS_ACLK;
  assign m_axis_aresetn_i[0*1+:1] = M00_AXIS_ARESETN;
  assign m_axis_aresetn_i[1*1+:1] = M01_AXIS_ARESETN;
  assign m_axis_aresetn_i[2*1+:1] = M02_AXIS_ARESETN;
  assign m_axis_aresetn_i[3*1+:1] = M03_AXIS_ARESETN;
  assign m_axis_aresetn_i[4*1+:1] = M04_AXIS_ARESETN;
  assign m_axis_aresetn_i[5*1+:1] = M05_AXIS_ARESETN;
  assign m_axis_aresetn_i[6*1+:1] = M06_AXIS_ARESETN;
  assign m_axis_aresetn_i[7*1+:1] = M07_AXIS_ARESETN;
  assign m_axis_aresetn_i[8*1+:1] = M08_AXIS_ARESETN;
  assign m_axis_aresetn_i[9*1+:1] = M09_AXIS_ARESETN;
  assign m_axis_aresetn_i[10*1+:1] = M10_AXIS_ARESETN;
  assign m_axis_aresetn_i[11*1+:1] = M11_AXIS_ARESETN;
  assign m_axis_aresetn_i[12*1+:1] = M12_AXIS_ARESETN;
  assign m_axis_aresetn_i[13*1+:1] = M13_AXIS_ARESETN;
  assign m_axis_aresetn_i[14*1+:1] = M14_AXIS_ARESETN;
  assign m_axis_aresetn_i[15*1+:1] = M15_AXIS_ARESETN;
  assign m_axis_aclken_i[0*1+:1] = M00_AXIS_ACLKEN;
  assign m_axis_aclken_i[1*1+:1] = M01_AXIS_ACLKEN;
  assign m_axis_aclken_i[2*1+:1] = M02_AXIS_ACLKEN;
  assign m_axis_aclken_i[3*1+:1] = M03_AXIS_ACLKEN;
  assign m_axis_aclken_i[4*1+:1] = M04_AXIS_ACLKEN;
  assign m_axis_aclken_i[5*1+:1] = M05_AXIS_ACLKEN;
  assign m_axis_aclken_i[6*1+:1] = M06_AXIS_ACLKEN;
  assign m_axis_aclken_i[7*1+:1] = M07_AXIS_ACLKEN;
  assign m_axis_aclken_i[8*1+:1] = M08_AXIS_ACLKEN;
  assign m_axis_aclken_i[9*1+:1] = M09_AXIS_ACLKEN;
  assign m_axis_aclken_i[10*1+:1] = M10_AXIS_ACLKEN;
  assign m_axis_aclken_i[11*1+:1] = M11_AXIS_ACLKEN;
  assign m_axis_aclken_i[12*1+:1] = M12_AXIS_ACLKEN;
  assign m_axis_aclken_i[13*1+:1] = M13_AXIS_ACLKEN;
  assign m_axis_aclken_i[14*1+:1] = M14_AXIS_ACLKEN;
  assign m_axis_aclken_i[15*1+:1] = M15_AXIS_ACLKEN;
  assign M00_AXIS_TVALID = m_axis_tvalid_i[0*1+:1];
  assign M01_AXIS_TVALID = m_axis_tvalid_i[1*1+:1];
  assign M02_AXIS_TVALID = m_axis_tvalid_i[2*1+:1];
  assign M03_AXIS_TVALID = m_axis_tvalid_i[3*1+:1];
  assign M04_AXIS_TVALID = m_axis_tvalid_i[4*1+:1];
  assign M05_AXIS_TVALID = m_axis_tvalid_i[5*1+:1];
  assign M06_AXIS_TVALID = m_axis_tvalid_i[6*1+:1];
  assign M07_AXIS_TVALID = m_axis_tvalid_i[7*1+:1];
  assign M08_AXIS_TVALID = m_axis_tvalid_i[8*1+:1];
  assign M09_AXIS_TVALID = m_axis_tvalid_i[9*1+:1];
  assign M10_AXIS_TVALID = m_axis_tvalid_i[10*1+:1];
  assign M11_AXIS_TVALID = m_axis_tvalid_i[11*1+:1];
  assign M12_AXIS_TVALID = m_axis_tvalid_i[12*1+:1];
  assign M13_AXIS_TVALID = m_axis_tvalid_i[13*1+:1];
  assign M14_AXIS_TVALID = m_axis_tvalid_i[14*1+:1];
  assign M15_AXIS_TVALID = m_axis_tvalid_i[15*1+:1];
  assign m_axis_tready_i[0*1+:1] = M00_AXIS_TREADY;
  assign m_axis_tready_i[1*1+:1] = M01_AXIS_TREADY;
  assign m_axis_tready_i[2*1+:1] = M02_AXIS_TREADY;
  assign m_axis_tready_i[3*1+:1] = M03_AXIS_TREADY;
  assign m_axis_tready_i[4*1+:1] = M04_AXIS_TREADY;
  assign m_axis_tready_i[5*1+:1] = M05_AXIS_TREADY;
  assign m_axis_tready_i[6*1+:1] = M06_AXIS_TREADY;
  assign m_axis_tready_i[7*1+:1] = M07_AXIS_TREADY;
  assign m_axis_tready_i[8*1+:1] = M08_AXIS_TREADY;
  assign m_axis_tready_i[9*1+:1] = M09_AXIS_TREADY;
  assign m_axis_tready_i[10*1+:1] = M10_AXIS_TREADY;
  assign m_axis_tready_i[11*1+:1] = M11_AXIS_TREADY;
  assign m_axis_tready_i[12*1+:1] = M12_AXIS_TREADY;
  assign m_axis_tready_i[13*1+:1] = M13_AXIS_TREADY;
  assign m_axis_tready_i[14*1+:1] = M14_AXIS_TREADY;
  assign m_axis_tready_i[15*1+:1] = M15_AXIS_TREADY;
  assign M00_AXIS_TDATA[C_M00_AXIS_TDATA_WIDTH-1:0] = m_axis_tdata_i[0*C_AXIS_TDATA_MAX_WIDTH+:C_M00_AXIS_TDATA_WIDTH];
  assign M01_AXIS_TDATA[C_M01_AXIS_TDATA_WIDTH-1:0] = m_axis_tdata_i[1*C_AXIS_TDATA_MAX_WIDTH+:C_M01_AXIS_TDATA_WIDTH];
  assign M02_AXIS_TDATA[C_M02_AXIS_TDATA_WIDTH-1:0] = m_axis_tdata_i[2*C_AXIS_TDATA_MAX_WIDTH+:C_M02_AXIS_TDATA_WIDTH];
  assign M03_AXIS_TDATA[C_M03_AXIS_TDATA_WIDTH-1:0] = m_axis_tdata_i[3*C_AXIS_TDATA_MAX_WIDTH+:C_M03_AXIS_TDATA_WIDTH];
  assign M04_AXIS_TDATA[C_M04_AXIS_TDATA_WIDTH-1:0] = m_axis_tdata_i[4*C_AXIS_TDATA_MAX_WIDTH+:C_M04_AXIS_TDATA_WIDTH];
  assign M05_AXIS_TDATA[C_M05_AXIS_TDATA_WIDTH-1:0] = m_axis_tdata_i[5*C_AXIS_TDATA_MAX_WIDTH+:C_M05_AXIS_TDATA_WIDTH];
  assign M06_AXIS_TDATA[C_M06_AXIS_TDATA_WIDTH-1:0] = m_axis_tdata_i[6*C_AXIS_TDATA_MAX_WIDTH+:C_M06_AXIS_TDATA_WIDTH];
  assign M07_AXIS_TDATA[C_M07_AXIS_TDATA_WIDTH-1:0] = m_axis_tdata_i[7*C_AXIS_TDATA_MAX_WIDTH+:C_M07_AXIS_TDATA_WIDTH];
  assign M08_AXIS_TDATA[C_M08_AXIS_TDATA_WIDTH-1:0] = m_axis_tdata_i[8*C_AXIS_TDATA_MAX_WIDTH+:C_M08_AXIS_TDATA_WIDTH];
  assign M09_AXIS_TDATA[C_M09_AXIS_TDATA_WIDTH-1:0] = m_axis_tdata_i[9*C_AXIS_TDATA_MAX_WIDTH+:C_M09_AXIS_TDATA_WIDTH];
  assign M10_AXIS_TDATA[C_M10_AXIS_TDATA_WIDTH-1:0] = m_axis_tdata_i[10*C_AXIS_TDATA_MAX_WIDTH+:C_M10_AXIS_TDATA_WIDTH];
  assign M11_AXIS_TDATA[C_M11_AXIS_TDATA_WIDTH-1:0] = m_axis_tdata_i[11*C_AXIS_TDATA_MAX_WIDTH+:C_M11_AXIS_TDATA_WIDTH];
  assign M12_AXIS_TDATA[C_M12_AXIS_TDATA_WIDTH-1:0] = m_axis_tdata_i[12*C_AXIS_TDATA_MAX_WIDTH+:C_M12_AXIS_TDATA_WIDTH];
  assign M13_AXIS_TDATA[C_M13_AXIS_TDATA_WIDTH-1:0] = m_axis_tdata_i[13*C_AXIS_TDATA_MAX_WIDTH+:C_M13_AXIS_TDATA_WIDTH];
  assign M14_AXIS_TDATA[C_M14_AXIS_TDATA_WIDTH-1:0] = m_axis_tdata_i[14*C_AXIS_TDATA_MAX_WIDTH+:C_M14_AXIS_TDATA_WIDTH];
  assign M15_AXIS_TDATA[C_M15_AXIS_TDATA_WIDTH-1:0] = m_axis_tdata_i[15*C_AXIS_TDATA_MAX_WIDTH+:C_M15_AXIS_TDATA_WIDTH];
  assign M00_AXIS_TSTRB[C_M00_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tstrb_i[0*C_AXIS_TDATA_MAX_WIDTH/8+:C_M00_AXIS_TDATA_WIDTH/8];
  assign M01_AXIS_TSTRB[C_M01_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tstrb_i[1*C_AXIS_TDATA_MAX_WIDTH/8+:C_M01_AXIS_TDATA_WIDTH/8];
  assign M02_AXIS_TSTRB[C_M02_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tstrb_i[2*C_AXIS_TDATA_MAX_WIDTH/8+:C_M02_AXIS_TDATA_WIDTH/8];
  assign M03_AXIS_TSTRB[C_M03_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tstrb_i[3*C_AXIS_TDATA_MAX_WIDTH/8+:C_M03_AXIS_TDATA_WIDTH/8];
  assign M04_AXIS_TSTRB[C_M04_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tstrb_i[4*C_AXIS_TDATA_MAX_WIDTH/8+:C_M04_AXIS_TDATA_WIDTH/8];
  assign M05_AXIS_TSTRB[C_M05_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tstrb_i[5*C_AXIS_TDATA_MAX_WIDTH/8+:C_M05_AXIS_TDATA_WIDTH/8];
  assign M06_AXIS_TSTRB[C_M06_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tstrb_i[6*C_AXIS_TDATA_MAX_WIDTH/8+:C_M06_AXIS_TDATA_WIDTH/8];
  assign M07_AXIS_TSTRB[C_M07_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tstrb_i[7*C_AXIS_TDATA_MAX_WIDTH/8+:C_M07_AXIS_TDATA_WIDTH/8];
  assign M08_AXIS_TSTRB[C_M08_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tstrb_i[8*C_AXIS_TDATA_MAX_WIDTH/8+:C_M08_AXIS_TDATA_WIDTH/8];
  assign M09_AXIS_TSTRB[C_M09_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tstrb_i[9*C_AXIS_TDATA_MAX_WIDTH/8+:C_M09_AXIS_TDATA_WIDTH/8];
  assign M10_AXIS_TSTRB[C_M10_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tstrb_i[10*C_AXIS_TDATA_MAX_WIDTH/8+:C_M10_AXIS_TDATA_WIDTH/8];
  assign M11_AXIS_TSTRB[C_M11_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tstrb_i[11*C_AXIS_TDATA_MAX_WIDTH/8+:C_M11_AXIS_TDATA_WIDTH/8];
  assign M12_AXIS_TSTRB[C_M12_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tstrb_i[12*C_AXIS_TDATA_MAX_WIDTH/8+:C_M12_AXIS_TDATA_WIDTH/8];
  assign M13_AXIS_TSTRB[C_M13_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tstrb_i[13*C_AXIS_TDATA_MAX_WIDTH/8+:C_M13_AXIS_TDATA_WIDTH/8];
  assign M14_AXIS_TSTRB[C_M14_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tstrb_i[14*C_AXIS_TDATA_MAX_WIDTH/8+:C_M14_AXIS_TDATA_WIDTH/8];
  assign M15_AXIS_TSTRB[C_M15_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tstrb_i[15*C_AXIS_TDATA_MAX_WIDTH/8+:C_M15_AXIS_TDATA_WIDTH/8];
  assign M00_AXIS_TKEEP[C_M00_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tkeep_i[0*C_AXIS_TDATA_MAX_WIDTH/8+:C_M00_AXIS_TDATA_WIDTH/8];
  assign M01_AXIS_TKEEP[C_M01_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tkeep_i[1*C_AXIS_TDATA_MAX_WIDTH/8+:C_M01_AXIS_TDATA_WIDTH/8];
  assign M02_AXIS_TKEEP[C_M02_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tkeep_i[2*C_AXIS_TDATA_MAX_WIDTH/8+:C_M02_AXIS_TDATA_WIDTH/8];
  assign M03_AXIS_TKEEP[C_M03_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tkeep_i[3*C_AXIS_TDATA_MAX_WIDTH/8+:C_M03_AXIS_TDATA_WIDTH/8];
  assign M04_AXIS_TKEEP[C_M04_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tkeep_i[4*C_AXIS_TDATA_MAX_WIDTH/8+:C_M04_AXIS_TDATA_WIDTH/8];
  assign M05_AXIS_TKEEP[C_M05_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tkeep_i[5*C_AXIS_TDATA_MAX_WIDTH/8+:C_M05_AXIS_TDATA_WIDTH/8];
  assign M06_AXIS_TKEEP[C_M06_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tkeep_i[6*C_AXIS_TDATA_MAX_WIDTH/8+:C_M06_AXIS_TDATA_WIDTH/8];
  assign M07_AXIS_TKEEP[C_M07_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tkeep_i[7*C_AXIS_TDATA_MAX_WIDTH/8+:C_M07_AXIS_TDATA_WIDTH/8];
  assign M08_AXIS_TKEEP[C_M08_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tkeep_i[8*C_AXIS_TDATA_MAX_WIDTH/8+:C_M08_AXIS_TDATA_WIDTH/8];
  assign M09_AXIS_TKEEP[C_M09_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tkeep_i[9*C_AXIS_TDATA_MAX_WIDTH/8+:C_M09_AXIS_TDATA_WIDTH/8];
  assign M10_AXIS_TKEEP[C_M10_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tkeep_i[10*C_AXIS_TDATA_MAX_WIDTH/8+:C_M10_AXIS_TDATA_WIDTH/8];
  assign M11_AXIS_TKEEP[C_M11_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tkeep_i[11*C_AXIS_TDATA_MAX_WIDTH/8+:C_M11_AXIS_TDATA_WIDTH/8];
  assign M12_AXIS_TKEEP[C_M12_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tkeep_i[12*C_AXIS_TDATA_MAX_WIDTH/8+:C_M12_AXIS_TDATA_WIDTH/8];
  assign M13_AXIS_TKEEP[C_M13_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tkeep_i[13*C_AXIS_TDATA_MAX_WIDTH/8+:C_M13_AXIS_TDATA_WIDTH/8];
  assign M14_AXIS_TKEEP[C_M14_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tkeep_i[14*C_AXIS_TDATA_MAX_WIDTH/8+:C_M14_AXIS_TDATA_WIDTH/8];
  assign M15_AXIS_TKEEP[C_M15_AXIS_TDATA_WIDTH/8-1:0] = m_axis_tkeep_i[15*C_AXIS_TDATA_MAX_WIDTH/8+:C_M15_AXIS_TDATA_WIDTH/8];
  assign M00_AXIS_TLAST = m_axis_tlast_i[0*1+:1];
  assign M01_AXIS_TLAST = m_axis_tlast_i[1*1+:1];
  assign M02_AXIS_TLAST = m_axis_tlast_i[2*1+:1];
  assign M03_AXIS_TLAST = m_axis_tlast_i[3*1+:1];
  assign M04_AXIS_TLAST = m_axis_tlast_i[4*1+:1];
  assign M05_AXIS_TLAST = m_axis_tlast_i[5*1+:1];
  assign M06_AXIS_TLAST = m_axis_tlast_i[6*1+:1];
  assign M07_AXIS_TLAST = m_axis_tlast_i[7*1+:1];
  assign M08_AXIS_TLAST = m_axis_tlast_i[8*1+:1];
  assign M09_AXIS_TLAST = m_axis_tlast_i[9*1+:1];
  assign M10_AXIS_TLAST = m_axis_tlast_i[10*1+:1];
  assign M11_AXIS_TLAST = m_axis_tlast_i[11*1+:1];
  assign M12_AXIS_TLAST = m_axis_tlast_i[12*1+:1];
  assign M13_AXIS_TLAST = m_axis_tlast_i[13*1+:1];
  assign M14_AXIS_TLAST = m_axis_tlast_i[14*1+:1];
  assign M15_AXIS_TLAST = m_axis_tlast_i[15*1+:1];
  assign M00_AXIS_TID[C_SWITCH_TID_WIDTH-1:0] = m_axis_tid_i[0*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH];
  assign M01_AXIS_TID[C_SWITCH_TID_WIDTH-1:0] = m_axis_tid_i[1*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH];
  assign M02_AXIS_TID[C_SWITCH_TID_WIDTH-1:0] = m_axis_tid_i[2*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH];
  assign M03_AXIS_TID[C_SWITCH_TID_WIDTH-1:0] = m_axis_tid_i[3*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH];
  assign M04_AXIS_TID[C_SWITCH_TID_WIDTH-1:0] = m_axis_tid_i[4*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH];
  assign M05_AXIS_TID[C_SWITCH_TID_WIDTH-1:0] = m_axis_tid_i[5*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH];
  assign M06_AXIS_TID[C_SWITCH_TID_WIDTH-1:0] = m_axis_tid_i[6*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH];
  assign M07_AXIS_TID[C_SWITCH_TID_WIDTH-1:0] = m_axis_tid_i[7*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH];
  assign M08_AXIS_TID[C_SWITCH_TID_WIDTH-1:0] = m_axis_tid_i[8*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH];
  assign M09_AXIS_TID[C_SWITCH_TID_WIDTH-1:0] = m_axis_tid_i[9*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH];
  assign M10_AXIS_TID[C_SWITCH_TID_WIDTH-1:0] = m_axis_tid_i[10*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH];
  assign M11_AXIS_TID[C_SWITCH_TID_WIDTH-1:0] = m_axis_tid_i[11*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH];
  assign M12_AXIS_TID[C_SWITCH_TID_WIDTH-1:0] = m_axis_tid_i[12*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH];
  assign M13_AXIS_TID[C_SWITCH_TID_WIDTH-1:0] = m_axis_tid_i[13*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH];
  assign M14_AXIS_TID[C_SWITCH_TID_WIDTH-1:0] = m_axis_tid_i[14*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH];
  assign M15_AXIS_TID[C_SWITCH_TID_WIDTH-1:0] = m_axis_tid_i[15*C_SWITCH_TID_WIDTH+:C_SWITCH_TID_WIDTH];
  assign M00_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0] = m_axis_tdest_i[0*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH];
  assign M01_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0] = m_axis_tdest_i[1*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH];
  assign M02_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0] = m_axis_tdest_i[2*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH];
  assign M03_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0] = m_axis_tdest_i[3*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH];
  assign M04_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0] = m_axis_tdest_i[4*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH];
  assign M05_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0] = m_axis_tdest_i[5*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH];
  assign M06_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0] = m_axis_tdest_i[6*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH];
  assign M07_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0] = m_axis_tdest_i[7*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH];
  assign M08_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0] = m_axis_tdest_i[8*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH];
  assign M09_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0] = m_axis_tdest_i[9*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH];
  assign M10_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0] = m_axis_tdest_i[10*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH];
  assign M11_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0] = m_axis_tdest_i[11*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH];
  assign M12_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0] = m_axis_tdest_i[12*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH];
  assign M13_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0] = m_axis_tdest_i[13*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH];
  assign M14_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0] = m_axis_tdest_i[14*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH];
  assign M15_AXIS_TDEST[C_SWITCH_TDEST_WIDTH-1:0] = m_axis_tdest_i[15*C_SWITCH_TDEST_WIDTH+:C_SWITCH_TDEST_WIDTH];
  assign M00_AXIS_TUSER[C_M00_AXIS_TUSER_WIDTH-1:0] = m_axis_tuser_i[0*C_AXIS_TUSER_MAX_WIDTH+:C_M00_AXIS_TUSER_WIDTH];
  assign M01_AXIS_TUSER[C_M01_AXIS_TUSER_WIDTH-1:0] = m_axis_tuser_i[1*C_AXIS_TUSER_MAX_WIDTH+:C_M01_AXIS_TUSER_WIDTH];
  assign M02_AXIS_TUSER[C_M02_AXIS_TUSER_WIDTH-1:0] = m_axis_tuser_i[2*C_AXIS_TUSER_MAX_WIDTH+:C_M02_AXIS_TUSER_WIDTH];
  assign M03_AXIS_TUSER[C_M03_AXIS_TUSER_WIDTH-1:0] = m_axis_tuser_i[3*C_AXIS_TUSER_MAX_WIDTH+:C_M03_AXIS_TUSER_WIDTH];
  assign M04_AXIS_TUSER[C_M04_AXIS_TUSER_WIDTH-1:0] = m_axis_tuser_i[4*C_AXIS_TUSER_MAX_WIDTH+:C_M04_AXIS_TUSER_WIDTH];
  assign M05_AXIS_TUSER[C_M05_AXIS_TUSER_WIDTH-1:0] = m_axis_tuser_i[5*C_AXIS_TUSER_MAX_WIDTH+:C_M05_AXIS_TUSER_WIDTH];
  assign M06_AXIS_TUSER[C_M06_AXIS_TUSER_WIDTH-1:0] = m_axis_tuser_i[6*C_AXIS_TUSER_MAX_WIDTH+:C_M06_AXIS_TUSER_WIDTH];
  assign M07_AXIS_TUSER[C_M07_AXIS_TUSER_WIDTH-1:0] = m_axis_tuser_i[7*C_AXIS_TUSER_MAX_WIDTH+:C_M07_AXIS_TUSER_WIDTH];
  assign M08_AXIS_TUSER[C_M08_AXIS_TUSER_WIDTH-1:0] = m_axis_tuser_i[8*C_AXIS_TUSER_MAX_WIDTH+:C_M08_AXIS_TUSER_WIDTH];
  assign M09_AXIS_TUSER[C_M09_AXIS_TUSER_WIDTH-1:0] = m_axis_tuser_i[9*C_AXIS_TUSER_MAX_WIDTH+:C_M09_AXIS_TUSER_WIDTH];
  assign M10_AXIS_TUSER[C_M10_AXIS_TUSER_WIDTH-1:0] = m_axis_tuser_i[10*C_AXIS_TUSER_MAX_WIDTH+:C_M10_AXIS_TUSER_WIDTH];
  assign M11_AXIS_TUSER[C_M11_AXIS_TUSER_WIDTH-1:0] = m_axis_tuser_i[11*C_AXIS_TUSER_MAX_WIDTH+:C_M11_AXIS_TUSER_WIDTH];
  assign M12_AXIS_TUSER[C_M12_AXIS_TUSER_WIDTH-1:0] = m_axis_tuser_i[12*C_AXIS_TUSER_MAX_WIDTH+:C_M12_AXIS_TUSER_WIDTH];
  assign M13_AXIS_TUSER[C_M13_AXIS_TUSER_WIDTH-1:0] = m_axis_tuser_i[13*C_AXIS_TUSER_MAX_WIDTH+:C_M13_AXIS_TUSER_WIDTH];
  assign M14_AXIS_TUSER[C_M14_AXIS_TUSER_WIDTH-1:0] = m_axis_tuser_i[14*C_AXIS_TUSER_MAX_WIDTH+:C_M14_AXIS_TUSER_WIDTH];
  assign M15_AXIS_TUSER[C_M15_AXIS_TUSER_WIDTH-1:0] = m_axis_tuser_i[15*C_AXIS_TUSER_MAX_WIDTH+:C_M15_AXIS_TUSER_WIDTH];
  assign s_arb_req_suppress_i[0*1+:1] = S00_ARB_REQ_SUPPRESS;
  assign s_arb_req_suppress_i[1*1+:1] = S01_ARB_REQ_SUPPRESS;
  assign s_arb_req_suppress_i[2*1+:1] = S02_ARB_REQ_SUPPRESS;
  assign s_arb_req_suppress_i[3*1+:1] = S03_ARB_REQ_SUPPRESS;
  assign s_arb_req_suppress_i[4*1+:1] = S04_ARB_REQ_SUPPRESS;
  assign s_arb_req_suppress_i[5*1+:1] = S05_ARB_REQ_SUPPRESS;
  assign s_arb_req_suppress_i[6*1+:1] = S06_ARB_REQ_SUPPRESS;
  assign s_arb_req_suppress_i[7*1+:1] = S07_ARB_REQ_SUPPRESS;
  assign s_arb_req_suppress_i[8*1+:1] = S08_ARB_REQ_SUPPRESS;
  assign s_arb_req_suppress_i[9*1+:1] = S09_ARB_REQ_SUPPRESS;
  assign s_arb_req_suppress_i[10*1+:1] = S10_ARB_REQ_SUPPRESS;
  assign s_arb_req_suppress_i[11*1+:1] = S11_ARB_REQ_SUPPRESS;
  assign s_arb_req_suppress_i[12*1+:1] = S12_ARB_REQ_SUPPRESS;
  assign s_arb_req_suppress_i[13*1+:1] = S13_ARB_REQ_SUPPRESS;
  assign s_arb_req_suppress_i[14*1+:1] = S14_ARB_REQ_SUPPRESS;
  assign s_arb_req_suppress_i[15*1+:1] = S15_ARB_REQ_SUPPRESS;
  assign S00_DECODE_ERR = s_decode_err_i[0*1+:1];
  assign S01_DECODE_ERR = s_decode_err_i[1*1+:1];
  assign S02_DECODE_ERR = s_decode_err_i[2*1+:1];
  assign S03_DECODE_ERR = s_decode_err_i[3*1+:1];
  assign S04_DECODE_ERR = s_decode_err_i[4*1+:1];
  assign S05_DECODE_ERR = s_decode_err_i[5*1+:1];
  assign S06_DECODE_ERR = s_decode_err_i[6*1+:1];
  assign S07_DECODE_ERR = s_decode_err_i[7*1+:1];
  assign S08_DECODE_ERR = s_decode_err_i[8*1+:1];
  assign S09_DECODE_ERR = s_decode_err_i[9*1+:1];
  assign S10_DECODE_ERR = s_decode_err_i[10*1+:1];
  assign S11_DECODE_ERR = s_decode_err_i[11*1+:1];
  assign S12_DECODE_ERR = s_decode_err_i[12*1+:1];
  assign S13_DECODE_ERR = s_decode_err_i[13*1+:1];
  assign S14_DECODE_ERR = s_decode_err_i[14*1+:1];
  assign S15_DECODE_ERR = s_decode_err_i[15*1+:1];
  assign S00_SPARSE_TKEEP_REMOVED = s_sparse_tkeep_removed_i[0*1+:1];
  assign S01_SPARSE_TKEEP_REMOVED = s_sparse_tkeep_removed_i[1*1+:1];
  assign S02_SPARSE_TKEEP_REMOVED = s_sparse_tkeep_removed_i[2*1+:1];
  assign S03_SPARSE_TKEEP_REMOVED = s_sparse_tkeep_removed_i[3*1+:1];
  assign S04_SPARSE_TKEEP_REMOVED = s_sparse_tkeep_removed_i[4*1+:1];
  assign S05_SPARSE_TKEEP_REMOVED = s_sparse_tkeep_removed_i[5*1+:1];
  assign S06_SPARSE_TKEEP_REMOVED = s_sparse_tkeep_removed_i[6*1+:1];
  assign S07_SPARSE_TKEEP_REMOVED = s_sparse_tkeep_removed_i[7*1+:1];
  assign S08_SPARSE_TKEEP_REMOVED = s_sparse_tkeep_removed_i[8*1+:1];
  assign S09_SPARSE_TKEEP_REMOVED = s_sparse_tkeep_removed_i[9*1+:1];
  assign S10_SPARSE_TKEEP_REMOVED = s_sparse_tkeep_removed_i[10*1+:1];
  assign S11_SPARSE_TKEEP_REMOVED = s_sparse_tkeep_removed_i[11*1+:1];
  assign S12_SPARSE_TKEEP_REMOVED = s_sparse_tkeep_removed_i[12*1+:1];
  assign S13_SPARSE_TKEEP_REMOVED = s_sparse_tkeep_removed_i[13*1+:1];
  assign S14_SPARSE_TKEEP_REMOVED = s_sparse_tkeep_removed_i[14*1+:1];
  assign S15_SPARSE_TKEEP_REMOVED = s_sparse_tkeep_removed_i[15*1+:1];
  assign S00_PACKER_ERR = s_packer_err_i[0*1+:1];
  assign S01_PACKER_ERR = s_packer_err_i[1*1+:1];
  assign S02_PACKER_ERR = s_packer_err_i[2*1+:1];
  assign S03_PACKER_ERR = s_packer_err_i[3*1+:1];
  assign S04_PACKER_ERR = s_packer_err_i[4*1+:1];
  assign S05_PACKER_ERR = s_packer_err_i[5*1+:1];
  assign S06_PACKER_ERR = s_packer_err_i[6*1+:1];
  assign S07_PACKER_ERR = s_packer_err_i[7*1+:1];
  assign S08_PACKER_ERR = s_packer_err_i[8*1+:1];
  assign S09_PACKER_ERR = s_packer_err_i[9*1+:1];
  assign S10_PACKER_ERR = s_packer_err_i[10*1+:1];
  assign S11_PACKER_ERR = s_packer_err_i[11*1+:1];
  assign S12_PACKER_ERR = s_packer_err_i[12*1+:1];
  assign S13_PACKER_ERR = s_packer_err_i[13*1+:1];
  assign S14_PACKER_ERR = s_packer_err_i[14*1+:1];
  assign S15_PACKER_ERR = s_packer_err_i[15*1+:1];
  assign S00_FIFO_DATA_COUNT[32-1:0] = s_fifo_data_count_i[0*32+:32];
  assign S01_FIFO_DATA_COUNT[32-1:0] = s_fifo_data_count_i[1*32+:32];
  assign S02_FIFO_DATA_COUNT[32-1:0] = s_fifo_data_count_i[2*32+:32];
  assign S03_FIFO_DATA_COUNT[32-1:0] = s_fifo_data_count_i[3*32+:32];
  assign S04_FIFO_DATA_COUNT[32-1:0] = s_fifo_data_count_i[4*32+:32];
  assign S05_FIFO_DATA_COUNT[32-1:0] = s_fifo_data_count_i[5*32+:32];
  assign S06_FIFO_DATA_COUNT[32-1:0] = s_fifo_data_count_i[6*32+:32];
  assign S07_FIFO_DATA_COUNT[32-1:0] = s_fifo_data_count_i[7*32+:32];
  assign S08_FIFO_DATA_COUNT[32-1:0] = s_fifo_data_count_i[8*32+:32];
  assign S09_FIFO_DATA_COUNT[32-1:0] = s_fifo_data_count_i[9*32+:32];
  assign S10_FIFO_DATA_COUNT[32-1:0] = s_fifo_data_count_i[10*32+:32];
  assign S11_FIFO_DATA_COUNT[32-1:0] = s_fifo_data_count_i[11*32+:32];
  assign S12_FIFO_DATA_COUNT[32-1:0] = s_fifo_data_count_i[12*32+:32];
  assign S13_FIFO_DATA_COUNT[32-1:0] = s_fifo_data_count_i[13*32+:32];
  assign S14_FIFO_DATA_COUNT[32-1:0] = s_fifo_data_count_i[14*32+:32];
  assign S15_FIFO_DATA_COUNT[32-1:0] = s_fifo_data_count_i[15*32+:32];
  assign M00_SPARSE_TKEEP_REMOVED = m_sparse_tkeep_removed_i[0*1+:1];
  assign M01_SPARSE_TKEEP_REMOVED = m_sparse_tkeep_removed_i[1*1+:1];
  assign M02_SPARSE_TKEEP_REMOVED = m_sparse_tkeep_removed_i[2*1+:1];
  assign M03_SPARSE_TKEEP_REMOVED = m_sparse_tkeep_removed_i[3*1+:1];
  assign M04_SPARSE_TKEEP_REMOVED = m_sparse_tkeep_removed_i[4*1+:1];
  assign M05_SPARSE_TKEEP_REMOVED = m_sparse_tkeep_removed_i[5*1+:1];
  assign M06_SPARSE_TKEEP_REMOVED = m_sparse_tkeep_removed_i[6*1+:1];
  assign M07_SPARSE_TKEEP_REMOVED = m_sparse_tkeep_removed_i[7*1+:1];
  assign M08_SPARSE_TKEEP_REMOVED = m_sparse_tkeep_removed_i[8*1+:1];
  assign M09_SPARSE_TKEEP_REMOVED = m_sparse_tkeep_removed_i[9*1+:1];
  assign M10_SPARSE_TKEEP_REMOVED = m_sparse_tkeep_removed_i[10*1+:1];
  assign M11_SPARSE_TKEEP_REMOVED = m_sparse_tkeep_removed_i[11*1+:1];
  assign M12_SPARSE_TKEEP_REMOVED = m_sparse_tkeep_removed_i[12*1+:1];
  assign M13_SPARSE_TKEEP_REMOVED = m_sparse_tkeep_removed_i[13*1+:1];
  assign M14_SPARSE_TKEEP_REMOVED = m_sparse_tkeep_removed_i[14*1+:1];
  assign M15_SPARSE_TKEEP_REMOVED = m_sparse_tkeep_removed_i[15*1+:1];
  assign M00_PACKER_ERR = m_packer_err_i[0*1+:1];
  assign M01_PACKER_ERR = m_packer_err_i[1*1+:1];
  assign M02_PACKER_ERR = m_packer_err_i[2*1+:1];
  assign M03_PACKER_ERR = m_packer_err_i[3*1+:1];
  assign M04_PACKER_ERR = m_packer_err_i[4*1+:1];
  assign M05_PACKER_ERR = m_packer_err_i[5*1+:1];
  assign M06_PACKER_ERR = m_packer_err_i[6*1+:1];
  assign M07_PACKER_ERR = m_packer_err_i[7*1+:1];
  assign M08_PACKER_ERR = m_packer_err_i[8*1+:1];
  assign M09_PACKER_ERR = m_packer_err_i[9*1+:1];
  assign M10_PACKER_ERR = m_packer_err_i[10*1+:1];
  assign M11_PACKER_ERR = m_packer_err_i[11*1+:1];
  assign M12_PACKER_ERR = m_packer_err_i[12*1+:1];
  assign M13_PACKER_ERR = m_packer_err_i[13*1+:1];
  assign M14_PACKER_ERR = m_packer_err_i[14*1+:1];
  assign M15_PACKER_ERR = m_packer_err_i[15*1+:1];
  assign M00_FIFO_DATA_COUNT[32-1:0] = m_fifo_data_count_i[0*32+:32];
  assign M01_FIFO_DATA_COUNT[32-1:0] = m_fifo_data_count_i[1*32+:32];
  assign M02_FIFO_DATA_COUNT[32-1:0] = m_fifo_data_count_i[2*32+:32];
  assign M03_FIFO_DATA_COUNT[32-1:0] = m_fifo_data_count_i[3*32+:32];
  assign M04_FIFO_DATA_COUNT[32-1:0] = m_fifo_data_count_i[4*32+:32];
  assign M05_FIFO_DATA_COUNT[32-1:0] = m_fifo_data_count_i[5*32+:32];
  assign M06_FIFO_DATA_COUNT[32-1:0] = m_fifo_data_count_i[6*32+:32];
  assign M07_FIFO_DATA_COUNT[32-1:0] = m_fifo_data_count_i[7*32+:32];
  assign M08_FIFO_DATA_COUNT[32-1:0] = m_fifo_data_count_i[8*32+:32];
  assign M09_FIFO_DATA_COUNT[32-1:0] = m_fifo_data_count_i[9*32+:32];
  assign M10_FIFO_DATA_COUNT[32-1:0] = m_fifo_data_count_i[10*32+:32];
  assign M11_FIFO_DATA_COUNT[32-1:0] = m_fifo_data_count_i[11*32+:32];
  assign M12_FIFO_DATA_COUNT[32-1:0] = m_fifo_data_count_i[12*32+:32];
  assign M13_FIFO_DATA_COUNT[32-1:0] = m_fifo_data_count_i[13*32+:32];
  assign M14_FIFO_DATA_COUNT[32-1:0] = m_fifo_data_count_i[14*32+:32];
  assign M15_FIFO_DATA_COUNT[32-1:0] = m_fifo_data_count_i[15*32+:32];

axis_interconnect_v1_1_18_axis_interconnect #(
  .C_FAMILY ( C_FAMILY ),
  .C_NUM_MI_SLOTS ( C_NUM_MI_SLOTS ),
  .C_NUM_SI_SLOTS ( C_NUM_SI_SLOTS ),
  .C_AXIS_TDATA_MAX_WIDTH ( C_AXIS_TDATA_MAX_WIDTH ),
  .C_AXIS_TUSER_MAX_WIDTH ( C_AXIS_TUSER_MAX_WIDTH ),
  .C_SWITCH_MI_REG_CONFIG ( C_SWITCH_MI_REG_CONFIG ),
  .C_SWITCH_SI_REG_CONFIG ( C_SWITCH_SI_REG_CONFIG ),
  .C_SWITCH_MODE ( C_SWITCH_MODE ),
  .C_SWITCH_MAX_XFERS_PER_ARB ( C_SWITCH_MAX_XFERS_PER_ARB ),
  .C_SWITCH_NUM_CYCLES_TIMEOUT ( C_SWITCH_NUM_CYCLES_TIMEOUT ),
  .C_SWITCH_TDATA_WIDTH ( C_SWITCH_TDATA_WIDTH ),
  .C_SWITCH_TID_WIDTH ( C_SWITCH_TID_WIDTH ),
  .C_SWITCH_TDEST_WIDTH ( C_SWITCH_TDEST_WIDTH ),
  .C_SWITCH_TUSER_WIDTH ( C_SWITCH_TUSER_WIDTH ),
  .C_SWITCH_SIGNAL_SET ( C_SWITCH_SIGNAL_SET[31:0] ),
  .C_SWITCH_ACLK_RATIO ( C_SWITCH_ACLK_RATIO ),
  .C_SWITCH_USE_ACLKEN ( C_SWITCH_USE_ACLKEN ),
  .C_SYNCHRONIZER_STAGE ( C_SYNCHRONIZER_STAGE),
  .C_M_AXIS_CONNECTIVITY_ARRAY ( P_M_AXIS_CONNECTIVITY_ARRAY[C_NUM_MI_SLOTS*C_NUM_SI_SLOTS-1:0] ),
  .C_M_AXIS_BASETDEST_ARRAY ( P_M_AXIS_BASETDEST_ARRAY[C_NUM_MI_SLOTS*C_SWITCH_TDEST_WIDTH-1:0] ),
  .C_M_AXIS_HIGHTDEST_ARRAY ( P_M_AXIS_HIGHTDEST_ARRAY[C_NUM_MI_SLOTS*C_SWITCH_TDEST_WIDTH-1:0] ),
  .C_S_AXIS_TDATA_WIDTH_ARRAY ( P_S_AXIS_TDATA_WIDTH_ARRAY[C_NUM_SI_SLOTS*32-1:0] ),
  .C_S_AXIS_TUSER_WIDTH_ARRAY ( P_S_AXIS_TUSER_WIDTH_ARRAY[C_NUM_SI_SLOTS*32-1:0] ),
  .C_S_AXIS_IS_ACLK_ASYNC_ARRAY ( P_S_AXIS_IS_ACLK_ASYNC_ARRAY[C_NUM_SI_SLOTS*32-1:0] ),
  .C_S_AXIS_ACLK_RATIO_ARRAY ( P_S_AXIS_ACLK_RATIO_ARRAY[C_NUM_SI_SLOTS*32-1:0] ),
  .C_S_AXIS_REG_CONFIG_ARRAY ( P_S_AXIS_REG_CONFIG_ARRAY[C_NUM_SI_SLOTS*32-1:0] ),
  .C_S_AXIS_FIFO_DEPTH_ARRAY ( P_S_AXIS_FIFO_DEPTH_ARRAY[C_NUM_SI_SLOTS*32-1:0] ),
  .C_S_AXIS_FIFO_MODE_ARRAY ( P_S_AXIS_FIFO_MODE_ARRAY[C_NUM_SI_SLOTS*32-1:0] ),
  .C_M_AXIS_TDATA_WIDTH_ARRAY ( P_M_AXIS_TDATA_WIDTH_ARRAY[C_NUM_MI_SLOTS*32-1:0] ),
  .C_M_AXIS_TUSER_WIDTH_ARRAY ( P_M_AXIS_TUSER_WIDTH_ARRAY[C_NUM_MI_SLOTS*32-1:0] ),
  .C_M_AXIS_ACLK_RATIO_ARRAY ( P_M_AXIS_ACLK_RATIO_ARRAY[C_NUM_MI_SLOTS*32-1:0] ),
  .C_M_AXIS_REG_CONFIG_ARRAY ( P_M_AXIS_REG_CONFIG_ARRAY[C_NUM_MI_SLOTS*32-1:0] ),
  .C_M_AXIS_IS_ACLK_ASYNC_ARRAY ( P_M_AXIS_IS_ACLK_ASYNC_ARRAY[C_NUM_MI_SLOTS*32-1:0] ),
  .C_M_AXIS_FIFO_DEPTH_ARRAY ( P_M_AXIS_FIFO_DEPTH_ARRAY[C_NUM_MI_SLOTS*32-1:0] ),
  .C_M_AXIS_FIFO_MODE_ARRAY ( P_M_AXIS_FIFO_MODE_ARRAY[C_NUM_MI_SLOTS*32-1:0] )
)
axis_interconnect_0 (
  .ACLK ( ACLK ),
  .ARESETN ( ARESETN ),
  .ACLKEN ( ACLKEN ),
  .S_AXIS_ACLK ( s_axis_aclk_i[C_NUM_SI_SLOTS*1-1:0] ),
  .S_AXIS_ARESETN ( s_axis_aresetn_i[C_NUM_SI_SLOTS*1-1:0] ),
  .S_AXIS_ACLKEN ( s_axis_aclken_i[C_NUM_SI_SLOTS*1-1:0] ),
  .S_AXIS_TVALID ( s_axis_tvalid_i[C_NUM_SI_SLOTS*1-1:0] ),
  .S_AXIS_TREADY ( s_axis_tready_i[C_NUM_SI_SLOTS*1-1:0] ),
  .S_AXIS_TDATA ( s_axis_tdata_i[C_NUM_SI_SLOTS*C_AXIS_TDATA_MAX_WIDTH-1:0] ),
  .S_AXIS_TSTRB ( s_axis_tstrb_i[C_NUM_SI_SLOTS*C_AXIS_TDATA_MAX_WIDTH/8-1:0] ),
  .S_AXIS_TKEEP ( s_axis_tkeep_i[C_NUM_SI_SLOTS*C_AXIS_TDATA_MAX_WIDTH/8-1:0] ),
  .S_AXIS_TLAST ( s_axis_tlast_i[C_NUM_SI_SLOTS*1-1:0] ),
  .S_AXIS_TID ( s_axis_tid_i[C_NUM_SI_SLOTS*C_SWITCH_TID_WIDTH-1:0] ),
  .S_AXIS_TDEST ( s_axis_tdest_i[C_NUM_SI_SLOTS*C_SWITCH_TDEST_WIDTH-1:0] ),
  .S_AXIS_TUSER ( s_axis_tuser_i[C_NUM_SI_SLOTS*C_AXIS_TUSER_MAX_WIDTH-1:0] ),
  .M_AXIS_ACLK ( m_axis_aclk_i[C_NUM_MI_SLOTS*1-1:0] ),
  .M_AXIS_ARESETN ( m_axis_aresetn_i[C_NUM_MI_SLOTS*1-1:0] ),
  .M_AXIS_ACLKEN ( m_axis_aclken_i[C_NUM_MI_SLOTS*1-1:0] ),
  .M_AXIS_TVALID ( m_axis_tvalid_i[C_NUM_MI_SLOTS*1-1:0] ),
  .M_AXIS_TREADY ( m_axis_tready_i[C_NUM_MI_SLOTS*1-1:0] ),
  .M_AXIS_TDATA ( m_axis_tdata_i[C_NUM_MI_SLOTS*C_AXIS_TDATA_MAX_WIDTH-1:0] ),
  .M_AXIS_TSTRB ( m_axis_tstrb_i[C_NUM_MI_SLOTS*C_AXIS_TDATA_MAX_WIDTH/8-1:0] ),
  .M_AXIS_TKEEP ( m_axis_tkeep_i[C_NUM_MI_SLOTS*C_AXIS_TDATA_MAX_WIDTH/8-1:0] ),
  .M_AXIS_TLAST ( m_axis_tlast_i[C_NUM_MI_SLOTS*1-1:0] ),
  .M_AXIS_TID ( m_axis_tid_i[C_NUM_MI_SLOTS*C_SWITCH_TID_WIDTH-1:0] ),
  .M_AXIS_TDEST ( m_axis_tdest_i[C_NUM_MI_SLOTS*C_SWITCH_TDEST_WIDTH-1:0] ),
  .M_AXIS_TUSER ( m_axis_tuser_i[C_NUM_MI_SLOTS*C_AXIS_TUSER_MAX_WIDTH-1:0] ),
  .S_ARB_REQ_SUPPRESS ( s_arb_req_suppress_i[C_NUM_SI_SLOTS*1-1:0] ),
  .S_DECODE_ERR ( s_decode_err_i[C_NUM_SI_SLOTS*1-1:0] ),
  .S_SPARSE_TKEEP_REMOVED ( s_sparse_tkeep_removed_i[C_NUM_SI_SLOTS*1-1:0] ),
  .S_PACKER_ERR ( s_packer_err_i[C_NUM_SI_SLOTS*1-1:0] ),
  .S_FIFO_DATA_COUNT ( s_fifo_data_count_i[C_NUM_SI_SLOTS*32-1:0] ),
  .M_SPARSE_TKEEP_REMOVED ( m_sparse_tkeep_removed_i[C_NUM_MI_SLOTS*1-1:0] ),
  .M_PACKER_ERR ( m_packer_err_i[C_NUM_MI_SLOTS*1-1:0] ),
  .M_FIFO_DATA_COUNT ( m_fifo_data_count_i[C_NUM_MI_SLOTS*32-1:0] )
);
endmodule // axis_interconnect_16x16_top
`default_nettype wire


