-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
-- Date        : Tue Oct 13 18:23:40 2020
-- Host        : yhqiu running 64-bit CentOS Linux release 7.8.2003 (Core)
-- Command     : write_vhdl -force -mode synth_stub
--               /mnt/F/SSD/PJs_2019.2/NVMe_Controller/NVMe_Controller.srcs/sources_1/ip/axis_1s2m/axis_1s2m_stub.vhdl
-- Design      : axis_1s2m
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xcku040-ffva1156-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity axis_1s2m is
  Port ( 
    ACLK : in STD_LOGIC;
    ARESETN : in STD_LOGIC;
    S00_AXIS_ACLK : in STD_LOGIC;
    S00_AXIS_ARESETN : in STD_LOGIC;
    S00_AXIS_TVALID : in STD_LOGIC;
    S00_AXIS_TREADY : out STD_LOGIC;
    S00_AXIS_TDATA : in STD_LOGIC_VECTOR ( 255 downto 0 );
    S00_AXIS_TKEEP : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXIS_TLAST : in STD_LOGIC;
    S00_AXIS_TDEST : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXIS_ACLK : in STD_LOGIC;
    M01_AXIS_ACLK : in STD_LOGIC;
    M00_AXIS_ARESETN : in STD_LOGIC;
    M01_AXIS_ARESETN : in STD_LOGIC;
    M00_AXIS_TVALID : out STD_LOGIC;
    M01_AXIS_TVALID : out STD_LOGIC;
    M00_AXIS_TREADY : in STD_LOGIC;
    M01_AXIS_TREADY : in STD_LOGIC;
    M00_AXIS_TDATA : out STD_LOGIC_VECTOR ( 255 downto 0 );
    M01_AXIS_TDATA : out STD_LOGIC_VECTOR ( 255 downto 0 );
    M00_AXIS_TKEEP : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXIS_TKEEP : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXIS_TLAST : out STD_LOGIC;
    M01_AXIS_TLAST : out STD_LOGIC;
    M00_AXIS_TDEST : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXIS_TDEST : out STD_LOGIC_VECTOR ( 0 to 0 );
    S00_DECODE_ERR : out STD_LOGIC
  );

end axis_1s2m;

architecture stub of axis_1s2m is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "ACLK,ARESETN,S00_AXIS_ACLK,S00_AXIS_ARESETN,S00_AXIS_TVALID,S00_AXIS_TREADY,S00_AXIS_TDATA[255:0],S00_AXIS_TKEEP[31:0],S00_AXIS_TLAST,S00_AXIS_TDEST[0:0],M00_AXIS_ACLK,M01_AXIS_ACLK,M00_AXIS_ARESETN,M01_AXIS_ARESETN,M00_AXIS_TVALID,M01_AXIS_TVALID,M00_AXIS_TREADY,M01_AXIS_TREADY,M00_AXIS_TDATA[255:0],M01_AXIS_TDATA[255:0],M00_AXIS_TKEEP[31:0],M01_AXIS_TKEEP[31:0],M00_AXIS_TLAST,M01_AXIS_TLAST,M00_AXIS_TDEST[0:0],M01_AXIS_TDEST[0:0],S00_DECODE_ERR";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "axis_interconnect_v1_1_18_axis_interconnect_16x16_top,Vivado 2019.2";
begin
end;
