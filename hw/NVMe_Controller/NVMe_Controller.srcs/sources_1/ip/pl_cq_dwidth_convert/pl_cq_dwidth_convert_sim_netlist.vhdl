-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
-- Date        : Sat Oct 10 21:25:03 2020
-- Host        : yhqiu running 64-bit CentOS Linux release 7.8.2003 (Core)
-- Command     : write_vhdl -force -mode funcsim -rename_top pl_cq_dwidth_convert -prefix
--               pl_cq_dwidth_convert_ pl_cq_dwidth_convert_sim_netlist.vhdl
-- Design      : pl_cq_dwidth_convert
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xcku040-ffva1156-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axisc_upsizer is
  port (
    m_axis_tlast : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_tdata : out STD_LOGIC_VECTOR ( 255 downto 0 );
    m_axis_tkeep : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axis_tlast : in STD_LOGIC;
    aclk : in STD_LOGIC;
    aclken : in STD_LOGIC;
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    s_axis_tkeep : in STD_LOGIC_VECTOR ( 15 downto 0 );
    m_axis_tready : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC
  );
end pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axisc_upsizer;

architecture STRUCTURE of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axisc_upsizer is
  signal \^q\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal acc_data : STD_LOGIC;
  signal \acc_data[255]_i_1_n_0\ : STD_LOGIC;
  signal acc_last_i_1_n_0 : STD_LOGIC;
  signal acc_last_i_2_n_0 : STD_LOGIC;
  signal acc_strb : STD_LOGIC;
  signal \^m_axis_tlast\ : STD_LOGIC;
  signal r0_data : STD_LOGIC_VECTOR ( 127 downto 0 );
  signal r0_keep : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal r0_last : STD_LOGIC;
  signal r0_last_reg_n_0 : STD_LOGIC;
  signal \r0_reg_sel[0]_i_1_n_0\ : STD_LOGIC;
  signal \r0_reg_sel[1]_i_1_n_0\ : STD_LOGIC;
  signal \r0_reg_sel[1]_i_2_n_0\ : STD_LOGIC;
  signal \r0_reg_sel_reg_n_0_[0]\ : STD_LOGIC;
  signal \r0_reg_sel_reg_n_0_[1]\ : STD_LOGIC;
  signal state : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \state[1]_i_2_n_0\ : STD_LOGIC;
  signal \state[2]_i_2_n_0\ : STD_LOGIC;
  signal \state_reg_n_0_[2]\ : STD_LOGIC;
  attribute FSM_ENCODING : string;
  attribute FSM_ENCODING of \state_reg[0]\ : label is "none";
  attribute FSM_ENCODING of \state_reg[1]\ : label is "none";
  attribute FSM_ENCODING of \state_reg[2]\ : label is "none";
begin
  Q(1 downto 0) <= \^q\(1 downto 0);
  m_axis_tlast <= \^m_axis_tlast\;
\acc_data[127]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00008000"
    )
        port map (
      I0 => aclken,
      I1 => \state_reg_n_0_[2]\,
      I2 => \r0_reg_sel_reg_n_0_[0]\,
      I3 => \^q\(0),
      I4 => \^q\(1),
      O => acc_data
    );
\acc_data[255]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => \^q\(0),
      I1 => aclken,
      I2 => \^q\(1),
      O => \acc_data[255]_i_1_n_0\
    );
\acc_data_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(0),
      Q => m_axis_tdata(0),
      R => '0'
    );
\acc_data_reg[100]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(100),
      Q => m_axis_tdata(100),
      R => '0'
    );
\acc_data_reg[101]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(101),
      Q => m_axis_tdata(101),
      R => '0'
    );
\acc_data_reg[102]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(102),
      Q => m_axis_tdata(102),
      R => '0'
    );
\acc_data_reg[103]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(103),
      Q => m_axis_tdata(103),
      R => '0'
    );
\acc_data_reg[104]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(104),
      Q => m_axis_tdata(104),
      R => '0'
    );
\acc_data_reg[105]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(105),
      Q => m_axis_tdata(105),
      R => '0'
    );
\acc_data_reg[106]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(106),
      Q => m_axis_tdata(106),
      R => '0'
    );
\acc_data_reg[107]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(107),
      Q => m_axis_tdata(107),
      R => '0'
    );
\acc_data_reg[108]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(108),
      Q => m_axis_tdata(108),
      R => '0'
    );
\acc_data_reg[109]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(109),
      Q => m_axis_tdata(109),
      R => '0'
    );
\acc_data_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(10),
      Q => m_axis_tdata(10),
      R => '0'
    );
\acc_data_reg[110]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(110),
      Q => m_axis_tdata(110),
      R => '0'
    );
\acc_data_reg[111]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(111),
      Q => m_axis_tdata(111),
      R => '0'
    );
\acc_data_reg[112]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(112),
      Q => m_axis_tdata(112),
      R => '0'
    );
\acc_data_reg[113]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(113),
      Q => m_axis_tdata(113),
      R => '0'
    );
\acc_data_reg[114]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(114),
      Q => m_axis_tdata(114),
      R => '0'
    );
\acc_data_reg[115]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(115),
      Q => m_axis_tdata(115),
      R => '0'
    );
\acc_data_reg[116]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(116),
      Q => m_axis_tdata(116),
      R => '0'
    );
\acc_data_reg[117]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(117),
      Q => m_axis_tdata(117),
      R => '0'
    );
\acc_data_reg[118]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(118),
      Q => m_axis_tdata(118),
      R => '0'
    );
\acc_data_reg[119]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(119),
      Q => m_axis_tdata(119),
      R => '0'
    );
\acc_data_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(11),
      Q => m_axis_tdata(11),
      R => '0'
    );
\acc_data_reg[120]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(120),
      Q => m_axis_tdata(120),
      R => '0'
    );
\acc_data_reg[121]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(121),
      Q => m_axis_tdata(121),
      R => '0'
    );
\acc_data_reg[122]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(122),
      Q => m_axis_tdata(122),
      R => '0'
    );
\acc_data_reg[123]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(123),
      Q => m_axis_tdata(123),
      R => '0'
    );
\acc_data_reg[124]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(124),
      Q => m_axis_tdata(124),
      R => '0'
    );
\acc_data_reg[125]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(125),
      Q => m_axis_tdata(125),
      R => '0'
    );
\acc_data_reg[126]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(126),
      Q => m_axis_tdata(126),
      R => '0'
    );
\acc_data_reg[127]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(127),
      Q => m_axis_tdata(127),
      R => '0'
    );
\acc_data_reg[128]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(0),
      Q => m_axis_tdata(128),
      R => '0'
    );
\acc_data_reg[129]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(1),
      Q => m_axis_tdata(129),
      R => '0'
    );
\acc_data_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(12),
      Q => m_axis_tdata(12),
      R => '0'
    );
\acc_data_reg[130]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(2),
      Q => m_axis_tdata(130),
      R => '0'
    );
\acc_data_reg[131]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(3),
      Q => m_axis_tdata(131),
      R => '0'
    );
\acc_data_reg[132]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(4),
      Q => m_axis_tdata(132),
      R => '0'
    );
\acc_data_reg[133]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(5),
      Q => m_axis_tdata(133),
      R => '0'
    );
\acc_data_reg[134]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(6),
      Q => m_axis_tdata(134),
      R => '0'
    );
\acc_data_reg[135]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(7),
      Q => m_axis_tdata(135),
      R => '0'
    );
\acc_data_reg[136]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(8),
      Q => m_axis_tdata(136),
      R => '0'
    );
\acc_data_reg[137]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(9),
      Q => m_axis_tdata(137),
      R => '0'
    );
\acc_data_reg[138]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(10),
      Q => m_axis_tdata(138),
      R => '0'
    );
\acc_data_reg[139]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(11),
      Q => m_axis_tdata(139),
      R => '0'
    );
\acc_data_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(13),
      Q => m_axis_tdata(13),
      R => '0'
    );
\acc_data_reg[140]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(12),
      Q => m_axis_tdata(140),
      R => '0'
    );
\acc_data_reg[141]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(13),
      Q => m_axis_tdata(141),
      R => '0'
    );
\acc_data_reg[142]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(14),
      Q => m_axis_tdata(142),
      R => '0'
    );
\acc_data_reg[143]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(15),
      Q => m_axis_tdata(143),
      R => '0'
    );
\acc_data_reg[144]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(16),
      Q => m_axis_tdata(144),
      R => '0'
    );
\acc_data_reg[145]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(17),
      Q => m_axis_tdata(145),
      R => '0'
    );
\acc_data_reg[146]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(18),
      Q => m_axis_tdata(146),
      R => '0'
    );
\acc_data_reg[147]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(19),
      Q => m_axis_tdata(147),
      R => '0'
    );
\acc_data_reg[148]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(20),
      Q => m_axis_tdata(148),
      R => '0'
    );
\acc_data_reg[149]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(21),
      Q => m_axis_tdata(149),
      R => '0'
    );
\acc_data_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(14),
      Q => m_axis_tdata(14),
      R => '0'
    );
\acc_data_reg[150]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(22),
      Q => m_axis_tdata(150),
      R => '0'
    );
\acc_data_reg[151]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(23),
      Q => m_axis_tdata(151),
      R => '0'
    );
\acc_data_reg[152]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(24),
      Q => m_axis_tdata(152),
      R => '0'
    );
\acc_data_reg[153]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(25),
      Q => m_axis_tdata(153),
      R => '0'
    );
\acc_data_reg[154]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(26),
      Q => m_axis_tdata(154),
      R => '0'
    );
\acc_data_reg[155]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(27),
      Q => m_axis_tdata(155),
      R => '0'
    );
\acc_data_reg[156]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(28),
      Q => m_axis_tdata(156),
      R => '0'
    );
\acc_data_reg[157]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(29),
      Q => m_axis_tdata(157),
      R => '0'
    );
\acc_data_reg[158]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(30),
      Q => m_axis_tdata(158),
      R => '0'
    );
\acc_data_reg[159]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(31),
      Q => m_axis_tdata(159),
      R => '0'
    );
\acc_data_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(15),
      Q => m_axis_tdata(15),
      R => '0'
    );
\acc_data_reg[160]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(32),
      Q => m_axis_tdata(160),
      R => '0'
    );
\acc_data_reg[161]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(33),
      Q => m_axis_tdata(161),
      R => '0'
    );
\acc_data_reg[162]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(34),
      Q => m_axis_tdata(162),
      R => '0'
    );
\acc_data_reg[163]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(35),
      Q => m_axis_tdata(163),
      R => '0'
    );
\acc_data_reg[164]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(36),
      Q => m_axis_tdata(164),
      R => '0'
    );
\acc_data_reg[165]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(37),
      Q => m_axis_tdata(165),
      R => '0'
    );
\acc_data_reg[166]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(38),
      Q => m_axis_tdata(166),
      R => '0'
    );
\acc_data_reg[167]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(39),
      Q => m_axis_tdata(167),
      R => '0'
    );
\acc_data_reg[168]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(40),
      Q => m_axis_tdata(168),
      R => '0'
    );
\acc_data_reg[169]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(41),
      Q => m_axis_tdata(169),
      R => '0'
    );
\acc_data_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(16),
      Q => m_axis_tdata(16),
      R => '0'
    );
\acc_data_reg[170]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(42),
      Q => m_axis_tdata(170),
      R => '0'
    );
\acc_data_reg[171]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(43),
      Q => m_axis_tdata(171),
      R => '0'
    );
\acc_data_reg[172]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(44),
      Q => m_axis_tdata(172),
      R => '0'
    );
\acc_data_reg[173]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(45),
      Q => m_axis_tdata(173),
      R => '0'
    );
\acc_data_reg[174]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(46),
      Q => m_axis_tdata(174),
      R => '0'
    );
\acc_data_reg[175]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(47),
      Q => m_axis_tdata(175),
      R => '0'
    );
\acc_data_reg[176]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(48),
      Q => m_axis_tdata(176),
      R => '0'
    );
\acc_data_reg[177]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(49),
      Q => m_axis_tdata(177),
      R => '0'
    );
\acc_data_reg[178]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(50),
      Q => m_axis_tdata(178),
      R => '0'
    );
\acc_data_reg[179]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(51),
      Q => m_axis_tdata(179),
      R => '0'
    );
\acc_data_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(17),
      Q => m_axis_tdata(17),
      R => '0'
    );
\acc_data_reg[180]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(52),
      Q => m_axis_tdata(180),
      R => '0'
    );
\acc_data_reg[181]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(53),
      Q => m_axis_tdata(181),
      R => '0'
    );
\acc_data_reg[182]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(54),
      Q => m_axis_tdata(182),
      R => '0'
    );
\acc_data_reg[183]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(55),
      Q => m_axis_tdata(183),
      R => '0'
    );
\acc_data_reg[184]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(56),
      Q => m_axis_tdata(184),
      R => '0'
    );
\acc_data_reg[185]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(57),
      Q => m_axis_tdata(185),
      R => '0'
    );
\acc_data_reg[186]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(58),
      Q => m_axis_tdata(186),
      R => '0'
    );
\acc_data_reg[187]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(59),
      Q => m_axis_tdata(187),
      R => '0'
    );
\acc_data_reg[188]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(60),
      Q => m_axis_tdata(188),
      R => '0'
    );
\acc_data_reg[189]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(61),
      Q => m_axis_tdata(189),
      R => '0'
    );
\acc_data_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(18),
      Q => m_axis_tdata(18),
      R => '0'
    );
\acc_data_reg[190]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(62),
      Q => m_axis_tdata(190),
      R => '0'
    );
\acc_data_reg[191]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(63),
      Q => m_axis_tdata(191),
      R => '0'
    );
\acc_data_reg[192]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(64),
      Q => m_axis_tdata(192),
      R => '0'
    );
\acc_data_reg[193]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(65),
      Q => m_axis_tdata(193),
      R => '0'
    );
\acc_data_reg[194]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(66),
      Q => m_axis_tdata(194),
      R => '0'
    );
\acc_data_reg[195]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(67),
      Q => m_axis_tdata(195),
      R => '0'
    );
\acc_data_reg[196]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(68),
      Q => m_axis_tdata(196),
      R => '0'
    );
\acc_data_reg[197]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(69),
      Q => m_axis_tdata(197),
      R => '0'
    );
\acc_data_reg[198]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(70),
      Q => m_axis_tdata(198),
      R => '0'
    );
\acc_data_reg[199]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(71),
      Q => m_axis_tdata(199),
      R => '0'
    );
\acc_data_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(19),
      Q => m_axis_tdata(19),
      R => '0'
    );
\acc_data_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(1),
      Q => m_axis_tdata(1),
      R => '0'
    );
\acc_data_reg[200]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(72),
      Q => m_axis_tdata(200),
      R => '0'
    );
\acc_data_reg[201]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(73),
      Q => m_axis_tdata(201),
      R => '0'
    );
\acc_data_reg[202]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(74),
      Q => m_axis_tdata(202),
      R => '0'
    );
\acc_data_reg[203]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(75),
      Q => m_axis_tdata(203),
      R => '0'
    );
\acc_data_reg[204]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(76),
      Q => m_axis_tdata(204),
      R => '0'
    );
\acc_data_reg[205]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(77),
      Q => m_axis_tdata(205),
      R => '0'
    );
\acc_data_reg[206]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(78),
      Q => m_axis_tdata(206),
      R => '0'
    );
\acc_data_reg[207]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(79),
      Q => m_axis_tdata(207),
      R => '0'
    );
\acc_data_reg[208]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(80),
      Q => m_axis_tdata(208),
      R => '0'
    );
\acc_data_reg[209]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(81),
      Q => m_axis_tdata(209),
      R => '0'
    );
\acc_data_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(20),
      Q => m_axis_tdata(20),
      R => '0'
    );
\acc_data_reg[210]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(82),
      Q => m_axis_tdata(210),
      R => '0'
    );
\acc_data_reg[211]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(83),
      Q => m_axis_tdata(211),
      R => '0'
    );
\acc_data_reg[212]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(84),
      Q => m_axis_tdata(212),
      R => '0'
    );
\acc_data_reg[213]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(85),
      Q => m_axis_tdata(213),
      R => '0'
    );
\acc_data_reg[214]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(86),
      Q => m_axis_tdata(214),
      R => '0'
    );
\acc_data_reg[215]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(87),
      Q => m_axis_tdata(215),
      R => '0'
    );
\acc_data_reg[216]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(88),
      Q => m_axis_tdata(216),
      R => '0'
    );
\acc_data_reg[217]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(89),
      Q => m_axis_tdata(217),
      R => '0'
    );
\acc_data_reg[218]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(90),
      Q => m_axis_tdata(218),
      R => '0'
    );
\acc_data_reg[219]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(91),
      Q => m_axis_tdata(219),
      R => '0'
    );
\acc_data_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(21),
      Q => m_axis_tdata(21),
      R => '0'
    );
\acc_data_reg[220]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(92),
      Q => m_axis_tdata(220),
      R => '0'
    );
\acc_data_reg[221]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(93),
      Q => m_axis_tdata(221),
      R => '0'
    );
\acc_data_reg[222]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(94),
      Q => m_axis_tdata(222),
      R => '0'
    );
\acc_data_reg[223]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(95),
      Q => m_axis_tdata(223),
      R => '0'
    );
\acc_data_reg[224]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(96),
      Q => m_axis_tdata(224),
      R => '0'
    );
\acc_data_reg[225]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(97),
      Q => m_axis_tdata(225),
      R => '0'
    );
\acc_data_reg[226]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(98),
      Q => m_axis_tdata(226),
      R => '0'
    );
\acc_data_reg[227]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(99),
      Q => m_axis_tdata(227),
      R => '0'
    );
\acc_data_reg[228]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(100),
      Q => m_axis_tdata(228),
      R => '0'
    );
\acc_data_reg[229]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(101),
      Q => m_axis_tdata(229),
      R => '0'
    );
\acc_data_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(22),
      Q => m_axis_tdata(22),
      R => '0'
    );
\acc_data_reg[230]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(102),
      Q => m_axis_tdata(230),
      R => '0'
    );
\acc_data_reg[231]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(103),
      Q => m_axis_tdata(231),
      R => '0'
    );
\acc_data_reg[232]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(104),
      Q => m_axis_tdata(232),
      R => '0'
    );
\acc_data_reg[233]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(105),
      Q => m_axis_tdata(233),
      R => '0'
    );
\acc_data_reg[234]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(106),
      Q => m_axis_tdata(234),
      R => '0'
    );
\acc_data_reg[235]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(107),
      Q => m_axis_tdata(235),
      R => '0'
    );
\acc_data_reg[236]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(108),
      Q => m_axis_tdata(236),
      R => '0'
    );
\acc_data_reg[237]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(109),
      Q => m_axis_tdata(237),
      R => '0'
    );
\acc_data_reg[238]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(110),
      Q => m_axis_tdata(238),
      R => '0'
    );
\acc_data_reg[239]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(111),
      Q => m_axis_tdata(239),
      R => '0'
    );
\acc_data_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(23),
      Q => m_axis_tdata(23),
      R => '0'
    );
\acc_data_reg[240]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(112),
      Q => m_axis_tdata(240),
      R => '0'
    );
\acc_data_reg[241]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(113),
      Q => m_axis_tdata(241),
      R => '0'
    );
\acc_data_reg[242]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(114),
      Q => m_axis_tdata(242),
      R => '0'
    );
\acc_data_reg[243]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(115),
      Q => m_axis_tdata(243),
      R => '0'
    );
\acc_data_reg[244]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(116),
      Q => m_axis_tdata(244),
      R => '0'
    );
\acc_data_reg[245]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(117),
      Q => m_axis_tdata(245),
      R => '0'
    );
\acc_data_reg[246]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(118),
      Q => m_axis_tdata(246),
      R => '0'
    );
\acc_data_reg[247]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(119),
      Q => m_axis_tdata(247),
      R => '0'
    );
\acc_data_reg[248]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(120),
      Q => m_axis_tdata(248),
      R => '0'
    );
\acc_data_reg[249]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(121),
      Q => m_axis_tdata(249),
      R => '0'
    );
\acc_data_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(24),
      Q => m_axis_tdata(24),
      R => '0'
    );
\acc_data_reg[250]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(122),
      Q => m_axis_tdata(250),
      R => '0'
    );
\acc_data_reg[251]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(123),
      Q => m_axis_tdata(251),
      R => '0'
    );
\acc_data_reg[252]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(124),
      Q => m_axis_tdata(252),
      R => '0'
    );
\acc_data_reg[253]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(125),
      Q => m_axis_tdata(253),
      R => '0'
    );
\acc_data_reg[254]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(126),
      Q => m_axis_tdata(254),
      R => '0'
    );
\acc_data_reg[255]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tdata(127),
      Q => m_axis_tdata(255),
      R => '0'
    );
\acc_data_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(25),
      Q => m_axis_tdata(25),
      R => '0'
    );
\acc_data_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(26),
      Q => m_axis_tdata(26),
      R => '0'
    );
\acc_data_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(27),
      Q => m_axis_tdata(27),
      R => '0'
    );
\acc_data_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(28),
      Q => m_axis_tdata(28),
      R => '0'
    );
\acc_data_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(29),
      Q => m_axis_tdata(29),
      R => '0'
    );
\acc_data_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(2),
      Q => m_axis_tdata(2),
      R => '0'
    );
\acc_data_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(30),
      Q => m_axis_tdata(30),
      R => '0'
    );
\acc_data_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(31),
      Q => m_axis_tdata(31),
      R => '0'
    );
\acc_data_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(32),
      Q => m_axis_tdata(32),
      R => '0'
    );
\acc_data_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(33),
      Q => m_axis_tdata(33),
      R => '0'
    );
\acc_data_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(34),
      Q => m_axis_tdata(34),
      R => '0'
    );
\acc_data_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(35),
      Q => m_axis_tdata(35),
      R => '0'
    );
\acc_data_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(36),
      Q => m_axis_tdata(36),
      R => '0'
    );
\acc_data_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(37),
      Q => m_axis_tdata(37),
      R => '0'
    );
\acc_data_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(38),
      Q => m_axis_tdata(38),
      R => '0'
    );
\acc_data_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(39),
      Q => m_axis_tdata(39),
      R => '0'
    );
\acc_data_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(3),
      Q => m_axis_tdata(3),
      R => '0'
    );
\acc_data_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(40),
      Q => m_axis_tdata(40),
      R => '0'
    );
\acc_data_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(41),
      Q => m_axis_tdata(41),
      R => '0'
    );
\acc_data_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(42),
      Q => m_axis_tdata(42),
      R => '0'
    );
\acc_data_reg[43]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(43),
      Q => m_axis_tdata(43),
      R => '0'
    );
\acc_data_reg[44]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(44),
      Q => m_axis_tdata(44),
      R => '0'
    );
\acc_data_reg[45]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(45),
      Q => m_axis_tdata(45),
      R => '0'
    );
\acc_data_reg[46]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(46),
      Q => m_axis_tdata(46),
      R => '0'
    );
\acc_data_reg[47]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(47),
      Q => m_axis_tdata(47),
      R => '0'
    );
\acc_data_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(48),
      Q => m_axis_tdata(48),
      R => '0'
    );
\acc_data_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(49),
      Q => m_axis_tdata(49),
      R => '0'
    );
\acc_data_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(4),
      Q => m_axis_tdata(4),
      R => '0'
    );
\acc_data_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(50),
      Q => m_axis_tdata(50),
      R => '0'
    );
\acc_data_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(51),
      Q => m_axis_tdata(51),
      R => '0'
    );
\acc_data_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(52),
      Q => m_axis_tdata(52),
      R => '0'
    );
\acc_data_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(53),
      Q => m_axis_tdata(53),
      R => '0'
    );
\acc_data_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(54),
      Q => m_axis_tdata(54),
      R => '0'
    );
\acc_data_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(55),
      Q => m_axis_tdata(55),
      R => '0'
    );
\acc_data_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(56),
      Q => m_axis_tdata(56),
      R => '0'
    );
\acc_data_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(57),
      Q => m_axis_tdata(57),
      R => '0'
    );
\acc_data_reg[58]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(58),
      Q => m_axis_tdata(58),
      R => '0'
    );
\acc_data_reg[59]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(59),
      Q => m_axis_tdata(59),
      R => '0'
    );
\acc_data_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(5),
      Q => m_axis_tdata(5),
      R => '0'
    );
\acc_data_reg[60]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(60),
      Q => m_axis_tdata(60),
      R => '0'
    );
\acc_data_reg[61]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(61),
      Q => m_axis_tdata(61),
      R => '0'
    );
\acc_data_reg[62]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(62),
      Q => m_axis_tdata(62),
      R => '0'
    );
\acc_data_reg[63]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(63),
      Q => m_axis_tdata(63),
      R => '0'
    );
\acc_data_reg[64]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(64),
      Q => m_axis_tdata(64),
      R => '0'
    );
\acc_data_reg[65]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(65),
      Q => m_axis_tdata(65),
      R => '0'
    );
\acc_data_reg[66]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(66),
      Q => m_axis_tdata(66),
      R => '0'
    );
\acc_data_reg[67]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(67),
      Q => m_axis_tdata(67),
      R => '0'
    );
\acc_data_reg[68]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(68),
      Q => m_axis_tdata(68),
      R => '0'
    );
\acc_data_reg[69]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(69),
      Q => m_axis_tdata(69),
      R => '0'
    );
\acc_data_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(6),
      Q => m_axis_tdata(6),
      R => '0'
    );
\acc_data_reg[70]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(70),
      Q => m_axis_tdata(70),
      R => '0'
    );
\acc_data_reg[71]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(71),
      Q => m_axis_tdata(71),
      R => '0'
    );
\acc_data_reg[72]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(72),
      Q => m_axis_tdata(72),
      R => '0'
    );
\acc_data_reg[73]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(73),
      Q => m_axis_tdata(73),
      R => '0'
    );
\acc_data_reg[74]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(74),
      Q => m_axis_tdata(74),
      R => '0'
    );
\acc_data_reg[75]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(75),
      Q => m_axis_tdata(75),
      R => '0'
    );
\acc_data_reg[76]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(76),
      Q => m_axis_tdata(76),
      R => '0'
    );
\acc_data_reg[77]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(77),
      Q => m_axis_tdata(77),
      R => '0'
    );
\acc_data_reg[78]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(78),
      Q => m_axis_tdata(78),
      R => '0'
    );
\acc_data_reg[79]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(79),
      Q => m_axis_tdata(79),
      R => '0'
    );
\acc_data_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(7),
      Q => m_axis_tdata(7),
      R => '0'
    );
\acc_data_reg[80]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(80),
      Q => m_axis_tdata(80),
      R => '0'
    );
\acc_data_reg[81]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(81),
      Q => m_axis_tdata(81),
      R => '0'
    );
\acc_data_reg[82]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(82),
      Q => m_axis_tdata(82),
      R => '0'
    );
\acc_data_reg[83]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(83),
      Q => m_axis_tdata(83),
      R => '0'
    );
\acc_data_reg[84]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(84),
      Q => m_axis_tdata(84),
      R => '0'
    );
\acc_data_reg[85]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(85),
      Q => m_axis_tdata(85),
      R => '0'
    );
\acc_data_reg[86]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(86),
      Q => m_axis_tdata(86),
      R => '0'
    );
\acc_data_reg[87]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(87),
      Q => m_axis_tdata(87),
      R => '0'
    );
\acc_data_reg[88]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(88),
      Q => m_axis_tdata(88),
      R => '0'
    );
\acc_data_reg[89]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(89),
      Q => m_axis_tdata(89),
      R => '0'
    );
\acc_data_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(8),
      Q => m_axis_tdata(8),
      R => '0'
    );
\acc_data_reg[90]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(90),
      Q => m_axis_tdata(90),
      R => '0'
    );
\acc_data_reg[91]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(91),
      Q => m_axis_tdata(91),
      R => '0'
    );
\acc_data_reg[92]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(92),
      Q => m_axis_tdata(92),
      R => '0'
    );
\acc_data_reg[93]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(93),
      Q => m_axis_tdata(93),
      R => '0'
    );
\acc_data_reg[94]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(94),
      Q => m_axis_tdata(94),
      R => '0'
    );
\acc_data_reg[95]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(95),
      Q => m_axis_tdata(95),
      R => '0'
    );
\acc_data_reg[96]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(96),
      Q => m_axis_tdata(96),
      R => '0'
    );
\acc_data_reg[97]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(97),
      Q => m_axis_tdata(97),
      R => '0'
    );
\acc_data_reg[98]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(98),
      Q => m_axis_tdata(98),
      R => '0'
    );
\acc_data_reg[99]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(99),
      Q => m_axis_tdata(99),
      R => '0'
    );
\acc_data_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_data(9),
      Q => m_axis_tdata(9),
      R => '0'
    );
\acc_keep[31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00008000"
    )
        port map (
      I0 => aclken,
      I1 => \state_reg_n_0_[2]\,
      I2 => r0_last_reg_n_0,
      I3 => \^q\(0),
      I4 => \^q\(1),
      O => acc_strb
    );
\acc_keep_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_keep(0),
      Q => m_axis_tkeep(0),
      R => '0'
    );
\acc_keep_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_keep(10),
      Q => m_axis_tkeep(10),
      R => '0'
    );
\acc_keep_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_keep(11),
      Q => m_axis_tkeep(11),
      R => '0'
    );
\acc_keep_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_keep(12),
      Q => m_axis_tkeep(12),
      R => '0'
    );
\acc_keep_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_keep(13),
      Q => m_axis_tkeep(13),
      R => '0'
    );
\acc_keep_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_keep(14),
      Q => m_axis_tkeep(14),
      R => '0'
    );
\acc_keep_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_keep(15),
      Q => m_axis_tkeep(15),
      R => '0'
    );
\acc_keep_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tkeep(0),
      Q => m_axis_tkeep(16),
      R => acc_strb
    );
\acc_keep_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tkeep(1),
      Q => m_axis_tkeep(17),
      R => acc_strb
    );
\acc_keep_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tkeep(2),
      Q => m_axis_tkeep(18),
      R => acc_strb
    );
\acc_keep_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tkeep(3),
      Q => m_axis_tkeep(19),
      R => acc_strb
    );
\acc_keep_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_keep(1),
      Q => m_axis_tkeep(1),
      R => '0'
    );
\acc_keep_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tkeep(4),
      Q => m_axis_tkeep(20),
      R => acc_strb
    );
\acc_keep_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tkeep(5),
      Q => m_axis_tkeep(21),
      R => acc_strb
    );
\acc_keep_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tkeep(6),
      Q => m_axis_tkeep(22),
      R => acc_strb
    );
\acc_keep_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tkeep(7),
      Q => m_axis_tkeep(23),
      R => acc_strb
    );
\acc_keep_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tkeep(8),
      Q => m_axis_tkeep(24),
      R => acc_strb
    );
\acc_keep_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tkeep(9),
      Q => m_axis_tkeep(25),
      R => acc_strb
    );
\acc_keep_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tkeep(10),
      Q => m_axis_tkeep(26),
      R => acc_strb
    );
\acc_keep_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tkeep(11),
      Q => m_axis_tkeep(27),
      R => acc_strb
    );
\acc_keep_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tkeep(12),
      Q => m_axis_tkeep(28),
      R => acc_strb
    );
\acc_keep_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tkeep(13),
      Q => m_axis_tkeep(29),
      R => acc_strb
    );
\acc_keep_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_keep(2),
      Q => m_axis_tkeep(2),
      R => '0'
    );
\acc_keep_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tkeep(14),
      Q => m_axis_tkeep(30),
      R => acc_strb
    );
\acc_keep_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \acc_data[255]_i_1_n_0\,
      D => s_axis_tkeep(15),
      Q => m_axis_tkeep(31),
      R => acc_strb
    );
\acc_keep_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_keep(3),
      Q => m_axis_tkeep(3),
      R => '0'
    );
\acc_keep_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_keep(4),
      Q => m_axis_tkeep(4),
      R => '0'
    );
\acc_keep_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_keep(5),
      Q => m_axis_tkeep(5),
      R => '0'
    );
\acc_keep_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_keep(6),
      Q => m_axis_tkeep(6),
      R => '0'
    );
\acc_keep_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_keep(7),
      Q => m_axis_tkeep(7),
      R => '0'
    );
\acc_keep_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_keep(8),
      Q => m_axis_tkeep(8),
      R => '0'
    );
\acc_keep_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => acc_data,
      D => r0_keep(9),
      Q => m_axis_tkeep(9),
      R => '0'
    );
acc_last_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF40000000"
    )
        port map (
      I0 => \^q\(1),
      I1 => aclken,
      I2 => \state_reg_n_0_[2]\,
      I3 => r0_last_reg_n_0,
      I4 => \^q\(0),
      I5 => acc_last_i_2_n_0,
      O => acc_last_i_1_n_0
    );
acc_last_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BAFF8A00"
    )
        port map (
      I0 => s_axis_tlast,
      I1 => \state_reg_n_0_[2]\,
      I2 => \^q\(1),
      I3 => aclken,
      I4 => \^m_axis_tlast\,
      O => acc_last_i_2_n_0
    );
acc_last_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => acc_last_i_1_n_0,
      Q => \^m_axis_tlast\,
      R => '0'
    );
\r0_data[127]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^q\(0),
      I1 => aclken,
      O => r0_last
    );
\r0_data_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(0),
      Q => r0_data(0),
      R => '0'
    );
\r0_data_reg[100]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(100),
      Q => r0_data(100),
      R => '0'
    );
\r0_data_reg[101]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(101),
      Q => r0_data(101),
      R => '0'
    );
\r0_data_reg[102]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(102),
      Q => r0_data(102),
      R => '0'
    );
\r0_data_reg[103]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(103),
      Q => r0_data(103),
      R => '0'
    );
\r0_data_reg[104]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(104),
      Q => r0_data(104),
      R => '0'
    );
\r0_data_reg[105]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(105),
      Q => r0_data(105),
      R => '0'
    );
\r0_data_reg[106]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(106),
      Q => r0_data(106),
      R => '0'
    );
\r0_data_reg[107]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(107),
      Q => r0_data(107),
      R => '0'
    );
\r0_data_reg[108]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(108),
      Q => r0_data(108),
      R => '0'
    );
\r0_data_reg[109]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(109),
      Q => r0_data(109),
      R => '0'
    );
\r0_data_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(10),
      Q => r0_data(10),
      R => '0'
    );
\r0_data_reg[110]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(110),
      Q => r0_data(110),
      R => '0'
    );
\r0_data_reg[111]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(111),
      Q => r0_data(111),
      R => '0'
    );
\r0_data_reg[112]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(112),
      Q => r0_data(112),
      R => '0'
    );
\r0_data_reg[113]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(113),
      Q => r0_data(113),
      R => '0'
    );
\r0_data_reg[114]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(114),
      Q => r0_data(114),
      R => '0'
    );
\r0_data_reg[115]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(115),
      Q => r0_data(115),
      R => '0'
    );
\r0_data_reg[116]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(116),
      Q => r0_data(116),
      R => '0'
    );
\r0_data_reg[117]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(117),
      Q => r0_data(117),
      R => '0'
    );
\r0_data_reg[118]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(118),
      Q => r0_data(118),
      R => '0'
    );
\r0_data_reg[119]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(119),
      Q => r0_data(119),
      R => '0'
    );
\r0_data_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(11),
      Q => r0_data(11),
      R => '0'
    );
\r0_data_reg[120]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(120),
      Q => r0_data(120),
      R => '0'
    );
\r0_data_reg[121]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(121),
      Q => r0_data(121),
      R => '0'
    );
\r0_data_reg[122]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(122),
      Q => r0_data(122),
      R => '0'
    );
\r0_data_reg[123]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(123),
      Q => r0_data(123),
      R => '0'
    );
\r0_data_reg[124]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(124),
      Q => r0_data(124),
      R => '0'
    );
\r0_data_reg[125]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(125),
      Q => r0_data(125),
      R => '0'
    );
\r0_data_reg[126]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(126),
      Q => r0_data(126),
      R => '0'
    );
\r0_data_reg[127]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(127),
      Q => r0_data(127),
      R => '0'
    );
\r0_data_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(12),
      Q => r0_data(12),
      R => '0'
    );
\r0_data_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(13),
      Q => r0_data(13),
      R => '0'
    );
\r0_data_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(14),
      Q => r0_data(14),
      R => '0'
    );
\r0_data_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(15),
      Q => r0_data(15),
      R => '0'
    );
\r0_data_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(16),
      Q => r0_data(16),
      R => '0'
    );
\r0_data_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(17),
      Q => r0_data(17),
      R => '0'
    );
\r0_data_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(18),
      Q => r0_data(18),
      R => '0'
    );
\r0_data_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(19),
      Q => r0_data(19),
      R => '0'
    );
\r0_data_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(1),
      Q => r0_data(1),
      R => '0'
    );
\r0_data_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(20),
      Q => r0_data(20),
      R => '0'
    );
\r0_data_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(21),
      Q => r0_data(21),
      R => '0'
    );
\r0_data_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(22),
      Q => r0_data(22),
      R => '0'
    );
\r0_data_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(23),
      Q => r0_data(23),
      R => '0'
    );
\r0_data_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(24),
      Q => r0_data(24),
      R => '0'
    );
\r0_data_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(25),
      Q => r0_data(25),
      R => '0'
    );
\r0_data_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(26),
      Q => r0_data(26),
      R => '0'
    );
\r0_data_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(27),
      Q => r0_data(27),
      R => '0'
    );
\r0_data_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(28),
      Q => r0_data(28),
      R => '0'
    );
\r0_data_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(29),
      Q => r0_data(29),
      R => '0'
    );
\r0_data_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(2),
      Q => r0_data(2),
      R => '0'
    );
\r0_data_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(30),
      Q => r0_data(30),
      R => '0'
    );
\r0_data_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(31),
      Q => r0_data(31),
      R => '0'
    );
\r0_data_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(32),
      Q => r0_data(32),
      R => '0'
    );
\r0_data_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(33),
      Q => r0_data(33),
      R => '0'
    );
\r0_data_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(34),
      Q => r0_data(34),
      R => '0'
    );
\r0_data_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(35),
      Q => r0_data(35),
      R => '0'
    );
\r0_data_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(36),
      Q => r0_data(36),
      R => '0'
    );
\r0_data_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(37),
      Q => r0_data(37),
      R => '0'
    );
\r0_data_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(38),
      Q => r0_data(38),
      R => '0'
    );
\r0_data_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(39),
      Q => r0_data(39),
      R => '0'
    );
\r0_data_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(3),
      Q => r0_data(3),
      R => '0'
    );
\r0_data_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(40),
      Q => r0_data(40),
      R => '0'
    );
\r0_data_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(41),
      Q => r0_data(41),
      R => '0'
    );
\r0_data_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(42),
      Q => r0_data(42),
      R => '0'
    );
\r0_data_reg[43]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(43),
      Q => r0_data(43),
      R => '0'
    );
\r0_data_reg[44]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(44),
      Q => r0_data(44),
      R => '0'
    );
\r0_data_reg[45]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(45),
      Q => r0_data(45),
      R => '0'
    );
\r0_data_reg[46]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(46),
      Q => r0_data(46),
      R => '0'
    );
\r0_data_reg[47]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(47),
      Q => r0_data(47),
      R => '0'
    );
\r0_data_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(48),
      Q => r0_data(48),
      R => '0'
    );
\r0_data_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(49),
      Q => r0_data(49),
      R => '0'
    );
\r0_data_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(4),
      Q => r0_data(4),
      R => '0'
    );
\r0_data_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(50),
      Q => r0_data(50),
      R => '0'
    );
\r0_data_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(51),
      Q => r0_data(51),
      R => '0'
    );
\r0_data_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(52),
      Q => r0_data(52),
      R => '0'
    );
\r0_data_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(53),
      Q => r0_data(53),
      R => '0'
    );
\r0_data_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(54),
      Q => r0_data(54),
      R => '0'
    );
\r0_data_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(55),
      Q => r0_data(55),
      R => '0'
    );
\r0_data_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(56),
      Q => r0_data(56),
      R => '0'
    );
\r0_data_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(57),
      Q => r0_data(57),
      R => '0'
    );
\r0_data_reg[58]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(58),
      Q => r0_data(58),
      R => '0'
    );
\r0_data_reg[59]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(59),
      Q => r0_data(59),
      R => '0'
    );
\r0_data_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(5),
      Q => r0_data(5),
      R => '0'
    );
\r0_data_reg[60]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(60),
      Q => r0_data(60),
      R => '0'
    );
\r0_data_reg[61]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(61),
      Q => r0_data(61),
      R => '0'
    );
\r0_data_reg[62]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(62),
      Q => r0_data(62),
      R => '0'
    );
\r0_data_reg[63]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(63),
      Q => r0_data(63),
      R => '0'
    );
\r0_data_reg[64]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(64),
      Q => r0_data(64),
      R => '0'
    );
\r0_data_reg[65]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(65),
      Q => r0_data(65),
      R => '0'
    );
\r0_data_reg[66]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(66),
      Q => r0_data(66),
      R => '0'
    );
\r0_data_reg[67]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(67),
      Q => r0_data(67),
      R => '0'
    );
\r0_data_reg[68]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(68),
      Q => r0_data(68),
      R => '0'
    );
\r0_data_reg[69]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(69),
      Q => r0_data(69),
      R => '0'
    );
\r0_data_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(6),
      Q => r0_data(6),
      R => '0'
    );
\r0_data_reg[70]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(70),
      Q => r0_data(70),
      R => '0'
    );
\r0_data_reg[71]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(71),
      Q => r0_data(71),
      R => '0'
    );
\r0_data_reg[72]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(72),
      Q => r0_data(72),
      R => '0'
    );
\r0_data_reg[73]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(73),
      Q => r0_data(73),
      R => '0'
    );
\r0_data_reg[74]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(74),
      Q => r0_data(74),
      R => '0'
    );
\r0_data_reg[75]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(75),
      Q => r0_data(75),
      R => '0'
    );
\r0_data_reg[76]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(76),
      Q => r0_data(76),
      R => '0'
    );
\r0_data_reg[77]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(77),
      Q => r0_data(77),
      R => '0'
    );
\r0_data_reg[78]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(78),
      Q => r0_data(78),
      R => '0'
    );
\r0_data_reg[79]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(79),
      Q => r0_data(79),
      R => '0'
    );
\r0_data_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(7),
      Q => r0_data(7),
      R => '0'
    );
\r0_data_reg[80]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(80),
      Q => r0_data(80),
      R => '0'
    );
\r0_data_reg[81]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(81),
      Q => r0_data(81),
      R => '0'
    );
\r0_data_reg[82]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(82),
      Q => r0_data(82),
      R => '0'
    );
\r0_data_reg[83]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(83),
      Q => r0_data(83),
      R => '0'
    );
\r0_data_reg[84]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(84),
      Q => r0_data(84),
      R => '0'
    );
\r0_data_reg[85]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(85),
      Q => r0_data(85),
      R => '0'
    );
\r0_data_reg[86]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(86),
      Q => r0_data(86),
      R => '0'
    );
\r0_data_reg[87]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(87),
      Q => r0_data(87),
      R => '0'
    );
\r0_data_reg[88]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(88),
      Q => r0_data(88),
      R => '0'
    );
\r0_data_reg[89]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(89),
      Q => r0_data(89),
      R => '0'
    );
\r0_data_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(8),
      Q => r0_data(8),
      R => '0'
    );
\r0_data_reg[90]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(90),
      Q => r0_data(90),
      R => '0'
    );
\r0_data_reg[91]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(91),
      Q => r0_data(91),
      R => '0'
    );
\r0_data_reg[92]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(92),
      Q => r0_data(92),
      R => '0'
    );
\r0_data_reg[93]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(93),
      Q => r0_data(93),
      R => '0'
    );
\r0_data_reg[94]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(94),
      Q => r0_data(94),
      R => '0'
    );
\r0_data_reg[95]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(95),
      Q => r0_data(95),
      R => '0'
    );
\r0_data_reg[96]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(96),
      Q => r0_data(96),
      R => '0'
    );
\r0_data_reg[97]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(97),
      Q => r0_data(97),
      R => '0'
    );
\r0_data_reg[98]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(98),
      Q => r0_data(98),
      R => '0'
    );
\r0_data_reg[99]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(99),
      Q => r0_data(99),
      R => '0'
    );
\r0_data_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tdata(9),
      Q => r0_data(9),
      R => '0'
    );
\r0_keep_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tkeep(0),
      Q => r0_keep(0),
      R => '0'
    );
\r0_keep_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tkeep(10),
      Q => r0_keep(10),
      R => '0'
    );
\r0_keep_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tkeep(11),
      Q => r0_keep(11),
      R => '0'
    );
\r0_keep_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tkeep(12),
      Q => r0_keep(12),
      R => '0'
    );
\r0_keep_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tkeep(13),
      Q => r0_keep(13),
      R => '0'
    );
\r0_keep_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tkeep(14),
      Q => r0_keep(14),
      R => '0'
    );
\r0_keep_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tkeep(15),
      Q => r0_keep(15),
      R => '0'
    );
\r0_keep_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tkeep(1),
      Q => r0_keep(1),
      R => '0'
    );
\r0_keep_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tkeep(2),
      Q => r0_keep(2),
      R => '0'
    );
\r0_keep_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tkeep(3),
      Q => r0_keep(3),
      R => '0'
    );
\r0_keep_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tkeep(4),
      Q => r0_keep(4),
      R => '0'
    );
\r0_keep_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tkeep(5),
      Q => r0_keep(5),
      R => '0'
    );
\r0_keep_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tkeep(6),
      Q => r0_keep(6),
      R => '0'
    );
\r0_keep_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tkeep(7),
      Q => r0_keep(7),
      R => '0'
    );
\r0_keep_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tkeep(8),
      Q => r0_keep(8),
      R => '0'
    );
\r0_keep_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tkeep(9),
      Q => r0_keep(9),
      R => '0'
    );
r0_last_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => r0_last,
      D => s_axis_tlast,
      Q => r0_last_reg_n_0,
      R => '0'
    );
\r0_reg_sel[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"8AAAAAAA"
    )
        port map (
      I0 => \r0_reg_sel_reg_n_0_[0]\,
      I1 => \^q\(1),
      I2 => \^q\(0),
      I3 => \state_reg_n_0_[2]\,
      I4 => aclken,
      O => \r0_reg_sel[0]_i_1_n_0\
    );
\r0_reg_sel[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FF80"
    )
        port map (
      I0 => aclken,
      I1 => m_axis_tready,
      I2 => \^q\(1),
      I3 => SR(0),
      O => \r0_reg_sel[1]_i_1_n_0\
    );
\r0_reg_sel[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFBFFF00008000"
    )
        port map (
      I0 => \r0_reg_sel_reg_n_0_[0]\,
      I1 => aclken,
      I2 => \state_reg_n_0_[2]\,
      I3 => \^q\(0),
      I4 => \^q\(1),
      I5 => \r0_reg_sel_reg_n_0_[1]\,
      O => \r0_reg_sel[1]_i_2_n_0\
    );
\r0_reg_sel_reg[0]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => aclk,
      CE => '1',
      D => \r0_reg_sel[0]_i_1_n_0\,
      Q => \r0_reg_sel_reg_n_0_[0]\,
      S => \r0_reg_sel[1]_i_1_n_0\
    );
\r0_reg_sel_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => '1',
      D => \r0_reg_sel[1]_i_2_n_0\,
      Q => \r0_reg_sel_reg_n_0_[1]\,
      R => \r0_reg_sel[1]_i_1_n_0\
    );
\state[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CBFFFBFFFBFBFBFB"
    )
        port map (
      I0 => m_axis_tready,
      I1 => \^q\(1),
      I2 => \state_reg_n_0_[2]\,
      I3 => s_axis_tvalid,
      I4 => r0_last_reg_n_0,
      I5 => \^q\(0),
      O => state(0)
    );
\state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1F10"
    )
        port map (
      I0 => \state_reg_n_0_[2]\,
      I1 => m_axis_tready,
      I2 => \^q\(1),
      I3 => \state[1]_i_2_n_0\,
      O => state(1)
    );
\state[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F8A8F88800000000"
    )
        port map (
      I0 => s_axis_tvalid,
      I1 => \r0_reg_sel_reg_n_0_[1]\,
      I2 => \state_reg_n_0_[2]\,
      I3 => r0_last_reg_n_0,
      I4 => \r0_reg_sel_reg_n_0_[0]\,
      I5 => \^q\(0),
      O => \state[1]_i_2_n_0\
    );
\state[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00B0FFFF00B00000"
    )
        port map (
      I0 => s_axis_tvalid,
      I1 => \^q\(0),
      I2 => m_axis_tready,
      I3 => \state_reg_n_0_[2]\,
      I4 => \^q\(1),
      I5 => \state[2]_i_2_n_0\,
      O => state(2)
    );
\state[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0404044400000000"
    )
        port map (
      I0 => \r0_reg_sel_reg_n_0_[1]\,
      I1 => s_axis_tvalid,
      I2 => \state_reg_n_0_[2]\,
      I3 => r0_last_reg_n_0,
      I4 => \r0_reg_sel_reg_n_0_[0]\,
      I5 => \^q\(0),
      O => \state[2]_i_2_n_0\
    );
\state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => aclken,
      D => state(0),
      Q => \^q\(0),
      R => SR(0)
    );
\state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => aclken,
      D => state(1),
      Q => \^q\(1),
      R => SR(0)
    );
\state_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => aclken,
      D => state(2),
      Q => \state_reg_n_0_[2]\,
      R => SR(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    aclken : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    s_axis_tstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axis_tkeep : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axis_tlast : in STD_LOGIC;
    s_axis_tid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tdest : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tvalid : out STD_LOGIC;
    m_axis_tready : in STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 255 downto 0 );
    m_axis_tstrb : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_tkeep : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_tlast : out STD_LOGIC;
    m_axis_tid : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tdest : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tuser : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute C_AXIS_SIGNAL_SET : string;
  attribute C_AXIS_SIGNAL_SET of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is "32'b00000000000000000000000000011011";
  attribute C_AXIS_TDEST_WIDTH : integer;
  attribute C_AXIS_TDEST_WIDTH of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 1;
  attribute C_AXIS_TID_WIDTH : integer;
  attribute C_AXIS_TID_WIDTH of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 1;
  attribute C_FAMILY : string;
  attribute C_FAMILY of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is "kintexu";
  attribute C_M_AXIS_TDATA_WIDTH : integer;
  attribute C_M_AXIS_TDATA_WIDTH of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 256;
  attribute C_M_AXIS_TUSER_WIDTH : integer;
  attribute C_M_AXIS_TUSER_WIDTH of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 1;
  attribute C_S_AXIS_TDATA_WIDTH : integer;
  attribute C_S_AXIS_TDATA_WIDTH of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 128;
  attribute C_S_AXIS_TUSER_WIDTH : integer;
  attribute C_S_AXIS_TUSER_WIDTH of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 1;
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is "yes";
  attribute G_INDX_SS_TDATA : integer;
  attribute G_INDX_SS_TDATA of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 1;
  attribute G_INDX_SS_TDEST : integer;
  attribute G_INDX_SS_TDEST of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 6;
  attribute G_INDX_SS_TID : integer;
  attribute G_INDX_SS_TID of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 5;
  attribute G_INDX_SS_TKEEP : integer;
  attribute G_INDX_SS_TKEEP of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 3;
  attribute G_INDX_SS_TLAST : integer;
  attribute G_INDX_SS_TLAST of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 4;
  attribute G_INDX_SS_TREADY : integer;
  attribute G_INDX_SS_TREADY of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 0;
  attribute G_INDX_SS_TSTRB : integer;
  attribute G_INDX_SS_TSTRB of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 2;
  attribute G_INDX_SS_TUSER : integer;
  attribute G_INDX_SS_TUSER of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 7;
  attribute G_MASK_SS_TDATA : integer;
  attribute G_MASK_SS_TDATA of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 2;
  attribute G_MASK_SS_TDEST : integer;
  attribute G_MASK_SS_TDEST of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 64;
  attribute G_MASK_SS_TID : integer;
  attribute G_MASK_SS_TID of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 32;
  attribute G_MASK_SS_TKEEP : integer;
  attribute G_MASK_SS_TKEEP of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 8;
  attribute G_MASK_SS_TLAST : integer;
  attribute G_MASK_SS_TLAST of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 16;
  attribute G_MASK_SS_TREADY : integer;
  attribute G_MASK_SS_TREADY of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 1;
  attribute G_MASK_SS_TSTRB : integer;
  attribute G_MASK_SS_TSTRB of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 4;
  attribute G_MASK_SS_TUSER : integer;
  attribute G_MASK_SS_TUSER of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 128;
  attribute G_TASK_SEVERITY_ERR : integer;
  attribute G_TASK_SEVERITY_ERR of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 2;
  attribute G_TASK_SEVERITY_INFO : integer;
  attribute G_TASK_SEVERITY_INFO of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 0;
  attribute G_TASK_SEVERITY_WARNING : integer;
  attribute G_TASK_SEVERITY_WARNING of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 1;
  attribute P_AXIS_SIGNAL_SET : string;
  attribute P_AXIS_SIGNAL_SET of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is "32'b00000000000000000000000000011011";
  attribute P_D1_REG_CONFIG : integer;
  attribute P_D1_REG_CONFIG of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 0;
  attribute P_D1_TUSER_WIDTH : integer;
  attribute P_D1_TUSER_WIDTH of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 16;
  attribute P_D2_TDATA_WIDTH : integer;
  attribute P_D2_TDATA_WIDTH of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 256;
  attribute P_D2_TUSER_WIDTH : integer;
  attribute P_D2_TUSER_WIDTH of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 32;
  attribute P_D3_REG_CONFIG : integer;
  attribute P_D3_REG_CONFIG of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 0;
  attribute P_D3_TUSER_WIDTH : integer;
  attribute P_D3_TUSER_WIDTH of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 32;
  attribute P_M_RATIO : integer;
  attribute P_M_RATIO of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 1;
  attribute P_SS_TKEEP_REQUIRED : integer;
  attribute P_SS_TKEEP_REQUIRED of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 8;
  attribute P_S_RATIO : integer;
  attribute P_S_RATIO of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter : entity is 2;
end pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter;

architecture STRUCTURE of pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter is
  signal \<const0>\ : STD_LOGIC;
  signal areset_r : STD_LOGIC;
  signal p_0_in : STD_LOGIC;
begin
  m_axis_tdest(0) <= \<const0>\;
  m_axis_tid(0) <= \<const0>\;
  m_axis_tstrb(31) <= \<const0>\;
  m_axis_tstrb(30) <= \<const0>\;
  m_axis_tstrb(29) <= \<const0>\;
  m_axis_tstrb(28) <= \<const0>\;
  m_axis_tstrb(27) <= \<const0>\;
  m_axis_tstrb(26) <= \<const0>\;
  m_axis_tstrb(25) <= \<const0>\;
  m_axis_tstrb(24) <= \<const0>\;
  m_axis_tstrb(23) <= \<const0>\;
  m_axis_tstrb(22) <= \<const0>\;
  m_axis_tstrb(21) <= \<const0>\;
  m_axis_tstrb(20) <= \<const0>\;
  m_axis_tstrb(19) <= \<const0>\;
  m_axis_tstrb(18) <= \<const0>\;
  m_axis_tstrb(17) <= \<const0>\;
  m_axis_tstrb(16) <= \<const0>\;
  m_axis_tstrb(15) <= \<const0>\;
  m_axis_tstrb(14) <= \<const0>\;
  m_axis_tstrb(13) <= \<const0>\;
  m_axis_tstrb(12) <= \<const0>\;
  m_axis_tstrb(11) <= \<const0>\;
  m_axis_tstrb(10) <= \<const0>\;
  m_axis_tstrb(9) <= \<const0>\;
  m_axis_tstrb(8) <= \<const0>\;
  m_axis_tstrb(7) <= \<const0>\;
  m_axis_tstrb(6) <= \<const0>\;
  m_axis_tstrb(5) <= \<const0>\;
  m_axis_tstrb(4) <= \<const0>\;
  m_axis_tstrb(3) <= \<const0>\;
  m_axis_tstrb(2) <= \<const0>\;
  m_axis_tstrb(1) <= \<const0>\;
  m_axis_tstrb(0) <= \<const0>\;
  m_axis_tuser(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
areset_r_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => aresetn,
      O => p_0_in
    );
areset_r_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => '1',
      D => p_0_in,
      Q => areset_r,
      R => '0'
    );
\gen_upsizer_conversion.axisc_upsizer_0\: entity work.pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axisc_upsizer
     port map (
      Q(1) => m_axis_tvalid,
      Q(0) => s_axis_tready,
      SR(0) => areset_r,
      aclk => aclk,
      aclken => aclken,
      m_axis_tdata(255 downto 0) => m_axis_tdata(255 downto 0),
      m_axis_tkeep(31 downto 0) => m_axis_tkeep(31 downto 0),
      m_axis_tlast => m_axis_tlast,
      m_axis_tready => m_axis_tready,
      s_axis_tdata(127 downto 0) => s_axis_tdata(127 downto 0),
      s_axis_tkeep(15 downto 0) => s_axis_tkeep(15 downto 0),
      s_axis_tlast => s_axis_tlast,
      s_axis_tvalid => s_axis_tvalid
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity pl_cq_dwidth_convert is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    s_axis_tkeep : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axis_tlast : in STD_LOGIC;
    m_axis_tvalid : out STD_LOGIC;
    m_axis_tready : in STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 255 downto 0 );
    m_axis_tkeep : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_tlast : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of pl_cq_dwidth_convert : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of pl_cq_dwidth_convert : entity is "pl_cq_dwidth_convert,axis_dwidth_converter_v1_1_19_axis_dwidth_converter,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of pl_cq_dwidth_convert : entity is "yes";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of pl_cq_dwidth_convert : entity is "axis_dwidth_converter_v1_1_19_axis_dwidth_converter,Vivado 2019.2";
end pl_cq_dwidth_convert;

architecture STRUCTURE of pl_cq_dwidth_convert is
  signal NLW_inst_m_axis_tdest_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_m_axis_tid_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_m_axis_tstrb_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_inst_m_axis_tuser_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  attribute C_AXIS_SIGNAL_SET : string;
  attribute C_AXIS_SIGNAL_SET of inst : label is "32'b00000000000000000000000000011011";
  attribute C_AXIS_TDEST_WIDTH : integer;
  attribute C_AXIS_TDEST_WIDTH of inst : label is 1;
  attribute C_AXIS_TID_WIDTH : integer;
  attribute C_AXIS_TID_WIDTH of inst : label is 1;
  attribute C_FAMILY : string;
  attribute C_FAMILY of inst : label is "kintexu";
  attribute C_M_AXIS_TDATA_WIDTH : integer;
  attribute C_M_AXIS_TDATA_WIDTH of inst : label is 256;
  attribute C_M_AXIS_TUSER_WIDTH : integer;
  attribute C_M_AXIS_TUSER_WIDTH of inst : label is 1;
  attribute C_S_AXIS_TDATA_WIDTH : integer;
  attribute C_S_AXIS_TDATA_WIDTH of inst : label is 128;
  attribute C_S_AXIS_TUSER_WIDTH : integer;
  attribute C_S_AXIS_TUSER_WIDTH of inst : label is 1;
  attribute DowngradeIPIdentifiedWarnings of inst : label is "yes";
  attribute G_INDX_SS_TDATA : integer;
  attribute G_INDX_SS_TDATA of inst : label is 1;
  attribute G_INDX_SS_TDEST : integer;
  attribute G_INDX_SS_TDEST of inst : label is 6;
  attribute G_INDX_SS_TID : integer;
  attribute G_INDX_SS_TID of inst : label is 5;
  attribute G_INDX_SS_TKEEP : integer;
  attribute G_INDX_SS_TKEEP of inst : label is 3;
  attribute G_INDX_SS_TLAST : integer;
  attribute G_INDX_SS_TLAST of inst : label is 4;
  attribute G_INDX_SS_TREADY : integer;
  attribute G_INDX_SS_TREADY of inst : label is 0;
  attribute G_INDX_SS_TSTRB : integer;
  attribute G_INDX_SS_TSTRB of inst : label is 2;
  attribute G_INDX_SS_TUSER : integer;
  attribute G_INDX_SS_TUSER of inst : label is 7;
  attribute G_MASK_SS_TDATA : integer;
  attribute G_MASK_SS_TDATA of inst : label is 2;
  attribute G_MASK_SS_TDEST : integer;
  attribute G_MASK_SS_TDEST of inst : label is 64;
  attribute G_MASK_SS_TID : integer;
  attribute G_MASK_SS_TID of inst : label is 32;
  attribute G_MASK_SS_TKEEP : integer;
  attribute G_MASK_SS_TKEEP of inst : label is 8;
  attribute G_MASK_SS_TLAST : integer;
  attribute G_MASK_SS_TLAST of inst : label is 16;
  attribute G_MASK_SS_TREADY : integer;
  attribute G_MASK_SS_TREADY of inst : label is 1;
  attribute G_MASK_SS_TSTRB : integer;
  attribute G_MASK_SS_TSTRB of inst : label is 4;
  attribute G_MASK_SS_TUSER : integer;
  attribute G_MASK_SS_TUSER of inst : label is 128;
  attribute G_TASK_SEVERITY_ERR : integer;
  attribute G_TASK_SEVERITY_ERR of inst : label is 2;
  attribute G_TASK_SEVERITY_INFO : integer;
  attribute G_TASK_SEVERITY_INFO of inst : label is 0;
  attribute G_TASK_SEVERITY_WARNING : integer;
  attribute G_TASK_SEVERITY_WARNING of inst : label is 1;
  attribute P_AXIS_SIGNAL_SET : string;
  attribute P_AXIS_SIGNAL_SET of inst : label is "32'b00000000000000000000000000011011";
  attribute P_D1_REG_CONFIG : integer;
  attribute P_D1_REG_CONFIG of inst : label is 0;
  attribute P_D1_TUSER_WIDTH : integer;
  attribute P_D1_TUSER_WIDTH of inst : label is 16;
  attribute P_D2_TDATA_WIDTH : integer;
  attribute P_D2_TDATA_WIDTH of inst : label is 256;
  attribute P_D2_TUSER_WIDTH : integer;
  attribute P_D2_TUSER_WIDTH of inst : label is 32;
  attribute P_D3_REG_CONFIG : integer;
  attribute P_D3_REG_CONFIG of inst : label is 0;
  attribute P_D3_TUSER_WIDTH : integer;
  attribute P_D3_TUSER_WIDTH of inst : label is 32;
  attribute P_M_RATIO : integer;
  attribute P_M_RATIO of inst : label is 1;
  attribute P_SS_TKEEP_REQUIRED : integer;
  attribute P_SS_TKEEP_REQUIRED of inst : label is 8;
  attribute P_S_RATIO : integer;
  attribute P_S_RATIO of inst : label is 2;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of aclk : signal is "xilinx.com:signal:clock:1.0 CLKIF CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of aclk : signal is "XIL_INTERFACENAME CLKIF, FREQ_HZ 10000000, PHASE 0.000, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of aresetn : signal is "xilinx.com:signal:reset:1.0 RSTIF RST";
  attribute X_INTERFACE_PARAMETER of aresetn : signal is "XIL_INTERFACENAME RSTIF, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_axis_tlast : signal is "xilinx.com:interface:axis:1.0 M_AXIS TLAST";
  attribute X_INTERFACE_PARAMETER of m_axis_tlast : signal is "XIL_INTERFACENAME M_AXIS, TDATA_NUM_BYTES 32, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_axis_tready : signal is "xilinx.com:interface:axis:1.0 M_AXIS TREADY";
  attribute X_INTERFACE_INFO of m_axis_tvalid : signal is "xilinx.com:interface:axis:1.0 M_AXIS TVALID";
  attribute X_INTERFACE_INFO of s_axis_tlast : signal is "xilinx.com:interface:axis:1.0 S_AXIS TLAST";
  attribute X_INTERFACE_PARAMETER of s_axis_tlast : signal is "XIL_INTERFACENAME S_AXIS, TDATA_NUM_BYTES 16, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axis_tready : signal is "xilinx.com:interface:axis:1.0 S_AXIS TREADY";
  attribute X_INTERFACE_INFO of s_axis_tvalid : signal is "xilinx.com:interface:axis:1.0 S_AXIS TVALID";
  attribute X_INTERFACE_INFO of m_axis_tdata : signal is "xilinx.com:interface:axis:1.0 M_AXIS TDATA";
  attribute X_INTERFACE_INFO of m_axis_tkeep : signal is "xilinx.com:interface:axis:1.0 M_AXIS TKEEP";
  attribute X_INTERFACE_INFO of s_axis_tdata : signal is "xilinx.com:interface:axis:1.0 S_AXIS TDATA";
  attribute X_INTERFACE_INFO of s_axis_tkeep : signal is "xilinx.com:interface:axis:1.0 S_AXIS TKEEP";
begin
inst: entity work.pl_cq_dwidth_convert_axis_dwidth_converter_v1_1_19_axis_dwidth_converter
     port map (
      aclk => aclk,
      aclken => '1',
      aresetn => aresetn,
      m_axis_tdata(255 downto 0) => m_axis_tdata(255 downto 0),
      m_axis_tdest(0) => NLW_inst_m_axis_tdest_UNCONNECTED(0),
      m_axis_tid(0) => NLW_inst_m_axis_tid_UNCONNECTED(0),
      m_axis_tkeep(31 downto 0) => m_axis_tkeep(31 downto 0),
      m_axis_tlast => m_axis_tlast,
      m_axis_tready => m_axis_tready,
      m_axis_tstrb(31 downto 0) => NLW_inst_m_axis_tstrb_UNCONNECTED(31 downto 0),
      m_axis_tuser(0) => NLW_inst_m_axis_tuser_UNCONNECTED(0),
      m_axis_tvalid => m_axis_tvalid,
      s_axis_tdata(127 downto 0) => s_axis_tdata(127 downto 0),
      s_axis_tdest(0) => '0',
      s_axis_tid(0) => '0',
      s_axis_tkeep(15 downto 0) => s_axis_tkeep(15 downto 0),
      s_axis_tlast => s_axis_tlast,
      s_axis_tready => s_axis_tready,
      s_axis_tstrb(15 downto 0) => B"1111111111111111",
      s_axis_tuser(0) => '0',
      s_axis_tvalid => s_axis_tvalid
    );
end STRUCTURE;
