//-----------------------------------------------------------------------------
//
// (c) Copyright 2012-2012 Xilinx, Inc. All rights reserved.
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
//
//-----------------------------------------------------------------------------
//
// Project    : Ultrascale FPGA Gen3 Integrated Block for PCI Express
// File       : xdma_0_pcie3_ip_tph_tbl.v
// Version    : 4.4 
//-----------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////

`timescale 1ps/1ps

module xdma_0_pcie3_ip_tph_tbl
#(
  parameter TCQ = 100
  ) (
  input  wire         user_clk,
  input  wire         reset_n,
  input  wire   [4:0] cfg_tph_stt_address_i,
  input  wire   [3:0] cfg_tph_function_num_i,
  input  wire  [31:0] cfg_tph_stt_write_data_i,
  input  wire         cfg_tph_stt_write_enable_i,
  input  wire   [3:0] cfg_tph_stt_write_byte_valid_i,
  output wire  [31:0] cfg_tph_stt_read_data_o,
  input  wire         cfg_tph_stt_read_enable_i,
  output wire         cfg_tph_stt_read_data_valid_o,
  input  wire   [4:0] user_tph_stt_address_i,
  input  wire   [3:0] user_tph_function_num_i,
  input  wire         user_tph_stt_read_enable_i,
  output wire  [31:0] user_tph_stt_read_data_o,
  output wire         user_tph_stt_read_data_valid_o
  );

  reg                 reg_cfg_tph_stt_read_data_valid_o;
  reg                 reg_user_tph_stt_read_data_valid_o;
  reg           [8:0] reg_count;
  reg                 reg_state = 1'b0;
  reg                 reg_next_state = 1'b0;
  reg                 reg_web;
  reg                 reg_cfg_tph_stt_read_enable_i;
  reg                 reg_user_tph_stt_read_enable_i;
  wire          [3:0] wea;
  wire                web;
  wire          [8:0] addra;
  wire          [8:0] addrb;
  wire         [31:0] dina;
  wire         [31:0] dinb;
  wire          [8:0] count_w;
  wire                ram_scrub_in_process_w;
  wire                state_w;
  wire                next_state_w;
  wire         [31:0] douta;
  wire         [31:0] doutb;

  always @(posedge user_clk or negedge reset_n)
  begin
    if (!reset_n)
    begin
      reg_cfg_tph_stt_read_data_valid_o <= #TCQ 1'b0;
      reg_cfg_tph_stt_read_enable_i <= #TCQ 1'b0;
    end
    else
    begin
      if (cfg_tph_stt_read_enable_i && reg_cfg_tph_stt_read_enable_i &&
          !reg_cfg_tph_stt_read_data_valid_o && !ram_scrub_in_process_w)
      begin
        reg_cfg_tph_stt_read_data_valid_o <= #TCQ 1'b1;
      end
      else
      begin
        reg_cfg_tph_stt_read_data_valid_o <= #TCQ 1'b0;
      end
      reg_cfg_tph_stt_read_enable_i <= #TCQ cfg_tph_stt_read_enable_i;
    end
  end

  always @(posedge user_clk or negedge reset_n)
  begin
    if (!reset_n)
    begin
      reg_user_tph_stt_read_data_valid_o <= #TCQ 1'b0;
      reg_user_tph_stt_read_enable_i <= #TCQ 1'b0;
    end
    else
    begin
      if (user_tph_stt_read_enable_i && reg_user_tph_stt_read_enable_i &&
          !reg_user_tph_stt_read_data_valid_o && !ram_scrub_in_process_w)
      begin
        reg_user_tph_stt_read_data_valid_o <= #TCQ 1'b1;
      end
      else
      begin
        reg_user_tph_stt_read_data_valid_o <= #TCQ 1'b0;
      end
      reg_user_tph_stt_read_enable_i <= #TCQ user_tph_stt_read_enable_i;
    end
  end

  always @(posedge user_clk)
  begin
    reg_state <= #TCQ next_state_w;
    if (state_w)
    begin
      reg_count <= #TCQ count_w + 1'b1;
    end
    else
    begin
      reg_count <= #TCQ 9'b0;
    end
  end

  always @*
  begin
    case (state_w)
      1'b0:
      begin
        if (!reset_n)
        begin
          reg_next_state = 1'b1;
        end
        else
        begin
          reg_next_state = 1'b0;
        end
      end
      1'b1:
      begin
        if (count_w == 9'h1FF)
        begin
          reg_next_state = 1'b0;
        end
        else
        begin
          reg_next_state = 1'b1;
        end
      end
    endcase
  end

  RAMB36E2 #(
    .DOA_REG (1),
    .DOB_REG (0),
    .EN_ECC_READ ("FALSE"),
    .EN_ECC_WRITE ("FALSE"),
    .INIT_A (36'h000000000),
    .INIT_B (36'h000000000),
    .INIT_FILE ("NONE"),
//    .RDADDR_COLLISION_HWCONFIG ("DELAYED_WRITE"),
    .READ_WIDTH_A (36),
    .READ_WIDTH_B (36),
    .RSTREG_PRIORITY_A ("REGCE"),
    .RSTREG_PRIORITY_B ("REGCE"),
    .SIM_COLLISION_CHECK ("GENERATE_X_ONLY"),
    .SRVAL_A (36'h000000000),
    .SRVAL_B (36'h000000000),
    .WRITE_MODE_A ("WRITE_FIRST"),
    .WRITE_MODE_B ("WRITE_FIRST"),
    .WRITE_WIDTH_A (36),
    .WRITE_WIDTH_B (36))
  ramb36e2_inst (
    .ADDRENA (1'b1),
    .ADDRENB (1'b1),
    .CASDIMUXA (1'b0),
    .CASDIMUXB (1'b0),
    .CASDOMUXA (1'b0),
    .CASDOMUXB (1'b0),
    .CASDOMUXEN_A (1'b0),
    .CASDOMUXEN_B (1'b0),
    .CASINDBITERR (1'b0),
    .CASINSBITERR (1'b0),
    .CASOREGIMUXA (1'b0),
    .CASOREGIMUXB (1'b0),
    .CASOREGIMUXEN_A (1'b0),
    .CASOREGIMUXEN_B (1'b0),
    .ECCPIPECE (1'b0),
    .SLEEP (1'b0),
    .CASDINA (32'b0),
    .CASDINB (32'b0),
    .CASDINPA(4'b0),
    .CASDINPB(4'b0),
    .CASDOUTA (),
    .CASDOUTB (),
    .CASDOUTPA (),
    .CASDOUTPB (),
    .CASOUTDBITERR (),
    .CASOUTSBITERR (),
    .CLKARDCLK (user_clk),
    .CLKBWRCLK (user_clk),
    .DBITERR (),
    .ENARDEN (1'b1),
    .ENBWREN (1'b1),
    .INJECTDBITERR (1'b0),
    .INJECTSBITERR (1'b0),
    .REGCEAREGCE (1'b1),
    .REGCEB (1'b0),
    .RSTRAMARSTRAM (1'b0),
    .RSTRAMB (1'b0),
    .RSTREGARSTREG (1'b0),
    .RSTREGB (1'b0),
    .SBITERR (),
    .ADDRARDADDR ({1'b0, addra[8:0], 5'b00000}),
    .ADDRBWRADDR ({1'b0, addrb[8:0], 5'b00000}),
    .DINADIN (dina[31:0]),
    .DINBDIN (dinb[31:0]),
    .DINPADINP (4'b0000),
    .DINPBDINP (4'b0000),
    .DOUTADOUT (douta[31:0]),
    .DOUTBDOUT (doutb[31:0]),
    .DOUTPADOUTP (),
    .DOUTPBDOUTP (),
    .ECCPARITY (),
    .RDADDRECC (),
    .WEA (wea[3:0]),
    .WEBWE ({4'b0000, web, web, web, web})
  );

  assign addra = {cfg_tph_function_num_i, cfg_tph_stt_address_i};
  assign dina = cfg_tph_stt_write_data_i;
  assign wea[3] = cfg_tph_stt_write_enable_i && cfg_tph_stt_write_byte_valid_i[3];
  assign wea[2] = cfg_tph_stt_write_enable_i && cfg_tph_stt_write_byte_valid_i[2];
  assign wea[1] = cfg_tph_stt_write_enable_i && cfg_tph_stt_write_byte_valid_i[1];
  assign wea[0] = cfg_tph_stt_write_enable_i && cfg_tph_stt_write_byte_valid_i[0];
  assign cfg_tph_stt_read_data_o = douta;
  assign cfg_tph_stt_read_data_valid_o = reg_cfg_tph_stt_read_data_valid_o;
  assign ram_scrub_in_process_w = state_w;
  assign count_w = reg_count;
  assign state_w = reg_state;
  assign next_state_w = reg_next_state;
  assign dinb = 32'b0;
  assign web = reg_next_state;
  assign user_tph_stt_read_data_o = doutb;
  assign addrb = ram_scrub_in_process_w ? count_w : {user_tph_function_num_i, user_tph_stt_address_i};
  assign user_tph_stt_read_data_valid_o = reg_user_tph_stt_read_data_valid_o;

endmodule
