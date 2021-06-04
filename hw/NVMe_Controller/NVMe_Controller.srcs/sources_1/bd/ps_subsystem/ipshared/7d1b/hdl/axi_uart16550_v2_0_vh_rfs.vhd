-------------------------------------------------------------------------------
-- rx_fifo_control.vhd - entity/architecture pair
-------------------------------------------------------------------------------
--  ***************************************************************************
--  ** DISCLAIMER OF LIABILITY                                               **
--  **                                                                       **
--  **  This file contains proprietary and confidential information of       **
--  **  Xilinx, Inc. ("Xilinx"), that is distributed under a license         **
--  **  from Xilinx, and may be used, copied and/or disclosed only           **
--  **  pursuant to the terms of a valid license agreement with Xilinx.      **
--  **                                                                       **
--  **  XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION                **
--  **  ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER           **
--  **  EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT                  **
--  **  LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,            **
--  **  MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx        **
--  **  does not warrant that functions included in the Materials will       **
--  **  meet the requirements of Licensee, or that the operation of the      **
--  **  Materials will be uninterrupted or error-free, or that defects       **
--  **  in the Materials will be corrected. Furthermore, Xilinx does         **
--  **  not warrant or make any representations regarding use, or the        **
--  **  results of the use, of the Materials in terms of correctness,        **
--  **  accuracy, reliability or otherwise.                                  **
--  **                                                                       **
--  **  Xilinx products are not designed or intended to be fail-safe,        **
--  **  or for use in any application requiring fail-safe performance,       **
--  **  such as life-support or safety devices or systems, Class III         **
--  **  medical devices, nuclear facilities, applications related to         **
--  **  the deployment of airbags, or any other applications that could      **
--  **  lead to death, personal injury or severe property or                 **
--  **  environmental damage (individually and collectively, "critical       **
--  **  applications"). Customer assumes the sole risk and liability         **
--  **  of any use of Xilinx products in critical applications,              **
--  **  subject only to applicable laws and regulations governing            **
--  **  limitations on product liability.                                    **
--  **                                                                       **
--  **  Copyright 2010 Xilinx, Inc.                                          **
--  **  All rights reserved.                                                 **
--  **                                                                       **
--  **  This disclaimer and copyright notice must be retained as part        **
--  **  of this file at all times.                                           **
--  ***************************************************************************
-------------------------------------------------------------------------------
-- Filename:        rx_fifo_control.vhd
-- Version:         v2.0
-- Description:     Contains UART rx FIFO control logic
--
-- VHDL-Standard:   VHDL'93
--
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_cmb" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned."+";

-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------
entity rx_fifo_control is
generic (
    C_FAMILY         : string := "virtex7");              -- XILINX FPGA family
  port (
    Rst              : in  std_logic;                     -- Rst
    Sys_clk          : in  std_logic;                     -- Sys Clock
    Rclk             : in  std_logic;                     -- Receiver clock  
    Fcr              : in  std_logic_vector(7 downto 0 ); -- Fifo Control reg
    Rx_fifo_empty    : in  std_logic;                     -- Rx fifo empty
    Rx_fifo_count    : in  std_logic_vector(3 downto 0 ); -- Rx fifo count
    Rx_fifo_rd_en    : in  std_logic;                     -- Rx fifo read en
    Rx_fifo_wr_en    : in  std_logic;                     -- Rx fifo write en
    Rx_fifo_data_in  : in  std_logic_vector(10 downto 0); -- Rx fifo data in
    Rx_fifo_trigger  : out std_logic;                     -- Rx fifo trigger
    Rx_fifo_timeout  : out std_logic;                     -- Rx fifo timeout
    Rx_error_in_fifo : out std_logic;                     -- Rx error in fifo
    Rx_fifo_rst      : in  std_logic                      -- Rx fifo rst
    );

end rx_fifo_control;

-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------
architecture implementation of rx_fifo_control is

-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of implementation : architecture is "yes";
  
-------------------------------------------------------------------------------
-- Signal Declarations
-------------------------------------------------------------------------------
  signal trigger_level_in        : std_logic_vector(1 downto 0 );
  signal fifo_trigger_level      : std_logic_vector(3 downto 0 );
  signal fifo_trigger_level_flag : std_logic;
  signal character_counter       : std_logic_vector(9 downto 0);
  signal character_counter_rst   : std_logic;
  signal character_counter_en    : std_logic;
  
begin

  trigger_level_in <= Fcr(7) & Fcr(6);

  -----------------------------------------------------------------------------
  -- PROCESS: FIFO_TRIGGER_LEVEL_DECODE_PROCESS
  -- purpose: rx_fifo trigger level generation
  -----------------------------------------------------------------------------
  FIFO_TRIGGER_LEVEL_DECODE_PROCESS : process (trigger_level_in)
  begin  -- process
    case trigger_level_in is
      when "00" =>
        fifo_trigger_level <= "0000";   
      when "01" =>                      
        fifo_trigger_level <= "0011";   
      when "10" =>                      
        fifo_trigger_level <= "0111";   
      when "11" =>                      
        fifo_trigger_level <= "1101";   
      -- coverage off
      when others =>
        fifo_trigger_level <= "0000"; 
      -- coverage on  
    end case;
  end process;

  fifo_trigger_level_flag <= '1' when ( Rx_fifo_empty = '0' and 
                                ((Rx_fifo_count >= fifo_trigger_level) = TRUE))
                                else '0';

  -----------------------------------------------------------------------------
  -- PROCESS: FIFO_TRIGGER_LEVEL_PROC
  -- purpose: rx_fifo trigger flag generation
  -----------------------------------------------------------------------------
  FIFO_TRIGGER_LEVEL_PROC : process (Sys_clk)
  begin  -- process
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then                  -- asynchronous reset (active high)
        Rx_fifo_trigger <= '0';
      else
        Rx_fifo_trigger <= fifo_trigger_level_flag;
      end if;  
    end if;
  end process;

  -- Character counter reset
  character_counter_rst <= '1' when (Rx_fifo_rd_en = '1' or Rx_fifo_wr_en = '1'
                                  or Rx_fifo_empty = '1' or Rx_fifo_rst = '1')
                                  else 
                           '0';
                           
  -- Character counter enable
  character_counter_en  <= '1' when (character_counter(9) = '0' or 
                                     character_counter(8) = '0') else 
                           '0';
                       
  -- rx_fifo timeout 
  Rx_fifo_timeout       <= '1' when (character_counter(9) = '1' and 
                                     character_counter(8) = '1' and 
                                     Rx_fifo_empty = '0')       else 
                           '0';

  -----------------------------------------------------------------------------
  -- PROCESS: FIFO_CHARACTER_TIMEOUT
  -- purpose: character counter timeout
  -----------------------------------------------------------------------------
  FIFO_CHARACTER_TIMEOUT : process (Sys_clk)
  begin
    if Sys_clk'EVENT and Sys_clk = '1' then
      if character_counter_rst = '1' then
        character_counter <= "0000000000";
      elsif Rclk = '1' and character_counter_en = '1' then
        character_counter <= character_counter + "0000000001";
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- PROCESS: RX_ERROR_IN_FIFO_PROC
  -- purpose: tracks parity, framing and break errors in rx fifo
  -----------------------------------------------------------------------------
  RX_ERROR_IN_FIFO_PROC : process (Sys_clk) is
  begin  -- process RX_ERROR_IN_FIFO_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                  -- asynchronous reset (active high)
        Rx_error_in_fifo <= '0';
      else
        Rx_error_in_fifo <= (Rx_fifo_data_in(10) or Rx_fifo_data_in(9) or 
                             Rx_fifo_data_in(8)) and Rx_fifo_wr_en;
      end if;
    end if;
  end process RX_ERROR_IN_FIFO_PROC;

end implementation;



-------------------------------------------------------------------------------
-- xuart_tx_load_sm.vhd - entity/architecture pair
-------------------------------------------------------------------------------
--  ***************************************************************************
--  ** DISCLAIMER OF LIABILITY                                               **
--  **                                                                       **
--  **  This file contains proprietary and confidential information of       **
--  **  Xilinx, Inc. ("Xilinx"), that is distributed under a license         **
--  **  from Xilinx, and may be used, copied and/or disclosed only           **
--  **  pursuant to the terms of a valid license agreement with Xilinx.      **
--  **                                                                       **
--  **  XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION                **
--  **  ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER           **
--  **  EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT                  **
--  **  LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,            **
--  **  MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx        **
--  **  does not warrant that functions included in the Materials will       **
--  **  meet the requirements of Licensee, or that the operation of the      **
--  **  Materials will be uninterrupted or error-free, or that defects       **
--  **  in the Materials will be corrected. Furthermore, Xilinx does         **
--  **  not warrant or make any representations regarding use, or the        **
--  **  results of the use, of the Materials in terms of correctness,        **
--  **  accuracy, reliability or otherwise.                                  **
--  **                                                                       **
--  **  Xilinx products are not designed or intended to be fail-safe,        **
--  **  or for use in any application requiring fail-safe performance,       **
--  **  such as life-support or safety devices or systems, Class III         **
--  **  medical devices, nuclear facilities, applications related to         **
--  **  the deployment of airbags, or any other applications that could      **
--  **  lead to death, personal injury or severe property or                 **
--  **  environmental damage (individually and collectively, "critical       **
--  **  applications"). Customer assumes the sole risk and liability         **
--  **  of any use of Xilinx products in critical applications,              **
--  **  subject only to applicable laws and regulations governing            **
--  **  limitations on product liability.                                    **
--  **                                                                       **
--  **  Copyright 2010 Xilinx, Inc.                                          **
--  **  All rights reserved.                                                 **
--  **                                                                       **
--  **  This disclaimer and copyright notice must be retained as part        **
--  **  of this file at all times.                                           **
--  ***************************************************************************
-------------------------------------------------------------------------------
-- Filename:        xuart_tx_load_sm.vhd
-- Version:         v2.0
-- Description:     xuart transmitter load state machine
--
-- VHDL-Standard:   VHDL'93
--
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_cmb" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------
entity xuart_tx_load_sm is
  port (
    Rst       : in  std_logic;                    -- Rst input
    Sys_clk   : in  std_logic;                    -- Sys clock
    Thr       : in  std_logic_vector(7 downto 0); -- Trasmit holding reg
    Write_thr : in  std_logic;                    -- Thr write
    Load_tx   : in  std_logic;                    -- load Tx input  
    Tsr       : out std_logic_vector(7 downto 0); -- Transmit shift reg
    Thre      : out std_logic;                    -- Thr reg empty
    Tsre      : out std_logic                     -- Tsr reg empty
    );
end xuart_tx_load_sm;

-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------
architecture implementation of xuart_tx_load_sm is

-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of implementation : architecture is "yes";

  -- state types are based on TSR_THR
  type   state_type is (EMPTY_EMPTY, EMPTY_FULL, FULL_EMPTY, FULL_FULL);
  signal current_state, next_state : state_type;

  signal thre_com : std_logic;
  signal tsre_com : std_logic;
  signal tsr_com  : std_logic_vector(7 downto 0);
  signal tsr_int  : std_logic_vector(7 downto 0);
  
begin

  Tsr <= tsr_int;

  -----------------------------------------------------------------------------
  -- PROCESS: TX_LOAD_SM_REG_PROCESS
  -- purpose: Transmit register load and next state logic
  -----------------------------------------------------------------------------
  TX_LOAD_SM_REG_PROCESS : process (Sys_clk) is
  begin  -- process TX_LOAD_SM_REG_PROCESS
    if Sys_clk'event and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                  -- synchronous reset (active high)
        current_state <= EMPTY_EMPTY;
        tsr_int       <= X"FF";
        Thre          <= '1';
        Tsre          <= '1';
      else
        current_state <= next_state;
        tsr_int       <= tsr_com;
        Thre          <= thre_com;
        Tsre          <= tsre_com;
      end if;
    end if;
  end process TX_LOAD_SM_REG_PROCESS;
  
  -----------------------------------------------------------------------------
  -- PROCESS: TX_LOAD_SM_COM_PROCESS
  -- purpose: uart16550 transmission register loading process
  -----------------------------------------------------------------------------
  TX_LOAD_SM_COM_PROCESS : process (current_state, Load_tx, Rst, Thr, tsr_int,
                                    Write_thr) is

  begin  -- process TX_LOAD_SM_COM_PROCESS

      next_state <= current_state;
      tsr_com    <= tsr_int;
      tsre_com   <= '1';
      thre_com   <= '1';

      case current_state is

        when EMPTY_EMPTY =>
          if Write_thr = '1' then
            next_state <= EMPTY_FULL;
            tsr_com    <= Thr;
            tsre_com   <= '1';
            thre_com   <= '0';
          else
            next_state <= EMPTY_EMPTY;
            tsr_com    <= tsr_int;
            tsre_com   <= '1';
            thre_com   <= '1';
          end if;

        when EMPTY_FULL =>
          next_state <= FULL_EMPTY;
          tsr_com    <= Thr;
          tsre_com   <= '0';
          thre_com   <= '1';

        when FULL_EMPTY =>
          if (Load_tx = '0' and Write_thr = '1') then
            next_state <= FULL_FULL;
            tsr_com    <= tsr_int;
            tsre_com   <= '0';
            thre_com   <= '0';
          elsif (Load_tx = '1' and Write_thr = '1') then
            next_state <= EMPTY_FULL;
            tsr_com    <= tsr_int;
            tsre_com   <= '1';
            thre_com   <= '0';
          elsif (Load_tx = '1' and Write_thr = '0') then
            next_state <= EMPTY_EMPTY;
            tsr_com    <= tsr_int;
            tsre_com   <= '1';
            thre_com   <= '1';
          else
            next_state <= FULL_EMPTY;
            tsr_com    <= tsr_int;
            tsre_com   <= '0';
            thre_com   <= '1';
          end if;

        when FULL_FULL =>
          tsr_com <= tsr_int;
          if (Load_tx = '1') then
            next_state <= EMPTY_FULL;
            tsre_com   <= '1';
            thre_com   <= '0';
          else
            next_state <= FULL_FULL;
            tsre_com   <= '0';
            thre_com   <= '0';
          end if;

        -- added coverage off to disable the coverage for default state
        -- as state machine will never enter in defualt state while doing
        -- verification. 
        -- coverage off
        when others =>
          next_state <= EMPTY_EMPTY;
          tsr_com    <= tsr_int;
          tsre_com   <= '1';
          thre_com   <= '1';
        -- coverage on 

      end case;
  end process TX_LOAD_SM_COM_PROCESS;

end implementation;


-------------------------------------------------------------------------------
-- tx_fifo_block.vhd - entity/architecture pair
-------------------------------------------------------------------------------
--  ***************************************************************************
--  ** DISCLAIMER OF LIABILITY                                               **
--  **                                                                       **
--  **  This file contains proprietary and confidential information of       **
--  **  Xilinx, Inc. ("Xilinx"), that is distributed under a license         **
--  **  from Xilinx, and may be used, copied and/or disclosed only           **
--  **  pursuant to the terms of a valid license agreement with Xilinx.      **
--  **                                                                       **
--  **  XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION                **
--  **  ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER           **
--  **  EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT                  **
--  **  LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,            **
--  **  MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx        **
--  **  does not warrant that functions included in the Materials will       **
--  **  meet the requirements of Licensee, or that the operation of the      **
--  **  Materials will be uninterrupted or error-free, or that defects       **
--  **  in the Materials will be corrected. Furthermore, Xilinx does         **
--  **  not warrant or make any representations regarding use, or the        **
--  **  results of the use, of the Materials in terms of correctness,        **
--  **  accuracy, reliability or otherwise.                                  **
--  **                                                                       **
--  **  Xilinx products are not designed or intended to be fail-safe,        **
--  **  or for use in any application requiring fail-safe performance,       **
--  **  such as life-support or safety devices or systems, Class III         **
--  **  medical devices, nuclear facilities, applications related to         **
--  **  the deployment of airbags, or any other applications that could      **
--  **  lead to death, personal injury or severe property or                 **
--  **  environmental damage (individually and collectively, "critical       **
--  **  applications"). Customer assumes the sole risk and liability         **
--  **  of any use of Xilinx products in critical applications,              **
--  **  subject only to applicable laws and regulations governing            **
--  **  limitations on product liability.                                    **
--  **                                                                       **
--  **  Copyright 2010 Xilinx, Inc.                                          **
--  **  All rights reserved.                                                 **
--  **                                                                       **
--  **  This disclaimer and copyright notice must be retained as part        **
--  **  of this file at all times.                                           **
--  ***************************************************************************
-------------------------------------------------------------------------------
-- Filename:        tx_fifo_block.vhd
-- Version:         v2.0
-- Description:     Contains the uart transmitter fifo
--
-- VHDL-Standard:   VHDL'93
--
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_cmb" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------
-- proc common package of the proc common library is used for different 
-- function declarations
-------------------------------------------------------------------------------
library lib_srl_fifo_v1_0_2;
use lib_srl_fifo_v1_0_2.srl_fifo_rbu_f;

-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------
entity tx_fifo_block is
  generic (
    C_FAMILY         : string := "virtex7");              -- XILINX FPGA family
  port (
    Tx_fifo_data_in  : in  std_logic_VECTOR(7 downto 0 ); -- Tx fifo data in
    Tx_fifo_wr_en    : in  std_logic;                     -- Tx fifo write en  
    Tx_fifo_data_out : out std_logic_VECTOR(7 downto 0 ); -- Tx fifo data out
    Tx_fifo_clk      : in  std_logic;                     -- Tx fifo clk
    Tx_fifo_rd_en    : in  std_logic;                     -- Tx fifo read en  
    Tx_fifo_rst      : in  std_logic;                     -- Tx fifo Rst   
    Tx_fifo_empty    : out std_logic;                     -- Tx fifo empty  
    Tx_fifo_full     : out std_logic                      -- Tx fifo full   
    );

end tx_fifo_block;


-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------
architecture implementation of tx_fifo_block is
-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of implementation : architecture is "yes";
 
  signal tx_fifo_empty_i : std_logic;
  signal tx_fifo_full_i  : std_logic;
  signal tx_fifo_rd_en_i : std_logic;
  signal tx_fifo_wr_en_i : std_logic;

begin
  Tx_fifo_empty   <= tx_fifo_empty_i;
  Tx_fifo_full    <= tx_fifo_full_i;
  tx_fifo_rd_en_i <= Tx_fifo_rd_en and (not tx_fifo_empty_i);
  tx_fifo_wr_en_i <= Tx_fifo_wr_en and (not tx_fifo_full_i);
 
   srl_fifo_rbu_f_i1 : entity lib_srl_fifo_v1_0_2.srl_fifo_rbu_f
     generic map (
       C_DWIDTH => 8,
       C_DEPTH  => 16,
       C_FAMILY => C_FAMILY
                 )
     port map (
       Clk           => Tx_fifo_clk,       -- [in]
       Reset         => Tx_fifo_rst,       -- [in]
       FIFO_Write    => tx_fifo_wr_en_i,   -- [in]
       Data_In       => Tx_fifo_data_in,   -- [in]
       FIFO_Read     => tx_fifo_rd_en_i,   -- [in]
       Data_Out      => Tx_fifo_data_out,  -- [out]
       FIFO_Full     => tx_fifo_full_i,    -- [out]
       FIFO_Empty    => tx_fifo_empty_i,   -- [out]
       Addr          => open,              -- [out]
       Num_To_Reread => X"0",              -- [in]
       Underflow     => open,              -- [out]
       Overflow      => open);             -- [out]
  -------------------------------------------    
end implementation;


-------------------------------------------------------------------------------
-- tx16550.vhd - entity/architecture pair
-------------------------------------------------------------------------------
--  ***************************************************************************
--  ** DISCLAIMER OF LIABILITY                                               **
--  **                                                                       **
--  **  This file contains proprietary and confidential information of       **
--  **  Xilinx, Inc. ("Xilinx"), that is distributed under a license         **
--  **  from Xilinx, and may be used, copied and/or disclosed only           **
--  **  pursuant to the terms of a valid license agreement with Xilinx.      **
--  **                                                                       **
--  **  XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION                **
--  **  ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER           **
--  **  EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT                  **
--  **  LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,            **
--  **  MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx        **
--  **  does not warrant that functions included in the Materials will       **
--  **  meet the requirements of Licensee, or that the operation of the      **
--  **  Materials will be uninterrupted or error-free, or that defects       **
--  **  in the Materials will be corrected. Furthermore, Xilinx does         **
--  **  not warrant or make any representations regarding use, or the        **
--  **  results of the use, of the Materials in terms of correctness,        **
--  **  accuracy, reliability or otherwise.                                  **
--  **                                                                       **
--  **  Xilinx products are not designed or intended to be fail-safe,        **
--  **  or for use in any application requiring fail-safe performance,       **
--  **  such as life-support or safety devices or systems, Class III         **
--  **  medical devices, nuclear facilities, applications related to         **
--  **  the deployment of airbags, or any other applications that could      **
--  **  lead to death, personal injury or severe property or                 **
--  **  environmental damage (individually and collectively, "critical       **
--  **  applications"). Customer assumes the sole risk and liability         **
--  **  of any use of Xilinx products in critical applications,              **
--  **  subject only to applicable laws and regulations governing            **
--  **  limitations on product liability.                                    **
--  **                                                                       **
--  **  Copyright 2010 Xilinx, Inc.                                          **
--  **  All rights reserved.                                                 **
--  **                                                                       **
--  **  This disclaimer and copyright notice must be retained as part        **
--  **  of this file at all times.                                           **
--  ***************************************************************************
-------------------------------------------------------------------------------
-- Filename:        tx16550.vhd
-- Version:         v2.0
-- Description:     Implements the transmitter section of uart16550
--
-- VHDL-Standard:   VHDL'93
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_cmb" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned."+";

-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------
entity tx16550 is
  port (
    Sys_clk          : in  std_logic;   -- Sys clock
    Rst              : in  std_logic;   -- sys reset
    BaudoutN         : in  std_logic;   -- baudout
    Lcr              : in  std_logic_vector (7 downto 0);  
                                        -- line control register
    Thr              : in  std_logic_vector (7 downto 0);  
                                        -- transmitter holding register
    Tx_empty         : out std_logic;   -- transmit shift register empty signal
    Start_tx         : in  std_logic;   -- transmit holding register empty flag
    Sout             : out std_logic;   -- serial data out
    Tsr_loaded       : out std_logic;   -- Thr loaded into tsr
    Tx_fifo_rd_en    : out std_logic;   -- read enable for transmit fifo
    Fcr_0            : in  std_logic;   -- tx fifo enabled
    Tx_fifo_data_out : in  std_logic_vector (7 downto 0)
                                        -- tx fifo data output
    );
end tx16550;

-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------
architecture implementation of tx16550 is

-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of implementation : architecture is "yes";
------------------------------ Signal Declarations  ---------------------------
  type STATE_TYPE is (IDLE, START_BIT, DATA_BIT1, DATA_BIT2, DATA_BIT3, 
                      DATA_BIT4, DATA_BIT5, DATA_BIT6, DATA_BIT7, DATA_BIT8, 
                      PARITY_BIT, STOP_BIT1, STOP_BIT2);

  signal transmit_state     : STATE_TYPE;  -- states for transmit state machine
  signal next_state         : STATE_TYPE;  -- states for transmit state machine
  signal tsr                : std_logic_vector (7 downto 0);  
                                          -- transmit shift register 
  signal tsr_com            : std_logic_vector (7 downto 0);  
                                          -- transmit shift register input
  signal tx_parity          : std_logic;  -- tx_parity signal
  signal clkdiv             : std_logic_vector (3 downto 0);  -- clock counter
  signal clk1x              : std_logic;  -- serial data clock
  signal clk2x              : std_logic;  -- 2x clock for creating 1/2 stop bit
  signal sout_com           : std_logic;  -- serial data out 
  signal transmitting_n     : std_logic;  -- transmit shift reg empty signal
  signal transmitting_n_com : std_logic;  -- transmit shift reg empty signal
  signal parity_enable      : std_logic;  -- Lcr(3) PE(parity enabled when '1')
  signal even_parity        : std_logic;  -- Lcr(4) EPS (even parity selected
                                          -- when '1')
  signal stick_parity       : std_logic;  -- Lcr(5) enables stick parity.
  signal tx_parity_com      : std_logic;  -- tx_parity logic
  signal set_break          : std_logic;  -- Lcr(6) BC (if set Sout is 
                                          --             forced to '0')
  signal numbits            : std_logic_vector (1 downto 0); -- Lcr(1) & Lcr(0)
  signal num_stop_bits      : std_logic;  -- number of stop bits
  signal half_stop_bit      : std_logic;  -- flags half a stop bit
  signal tsr_loaded_com     : std_logic;  -- Tsr_loaded logic 
  signal tx_fifo_rd_en_com  : std_logic;  -- transmit fifo read enable logic   

begin


  -----------------------------------------------------------------------------
  -- PROCESS: TX_EMPTY_PROC
  -- purpose: Tx_empty generation logic
  -----------------------------------------------------------------------------
  TX_EMPTY_PROC : process (Sys_clk) is
  begin  -- process TX_EMPTY_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        Tx_empty <= '1';
      else
        Tx_empty <= transmitting_n and clk1x;
      end if;
    end if;
  end process TX_EMPTY_PROC;

  num_stop_bits <= Lcr(2);
  half_stop_bit <= '1' when (num_stop_bits = '1' and
                             numbits = "00" and
                             transmit_state = STOP_BIT2) else '0';
  parity_enable <= Lcr(3);
  even_parity   <= Lcr(4);
  stick_parity  <= (Lcr(5) and (not Lcr(4))) or ((not Lcr(5) and tx_parity));
  set_break     <= Lcr(6);
  numbits       <= Lcr(1) & Lcr(0);

  -----------------------------------------------------------------------------
  -- PROCESS: CLOCK_DIV_PROCESS
  -- purpose: clk_div counter 
  -----------------------------------------------------------------------------
  CLOCK_DIV_PROCESS : process (Sys_clk) is
  begin  -- process CLOCK_DIV_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                  -- synchronous reset (active high)
        clkdiv <= "0000";
      elsif (clk2x = '1' and half_stop_bit = '1') then
        clkdiv <= clkdiv + "1000";
      elsif BaudoutN = '0' then
        clkdiv <= clkdiv + "0001";
      end if;
    end if;
  end process CLOCK_DIV_PROCESS;

  -----------------------------------------------------------------------------
  -- PROCESS: CLK_1X_PROCESS
  -- purpose: clock_1x generation
  -----------------------------------------------------------------------------
  CLK_1X_PROCESS : process (Sys_clk) is
  begin  -- process CLK_1X_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                  -- synchronous reset (active high)
        clk1x <= '0';
      elsif (clkdiv = "0111" and BaudoutN = '0') then
        clk1x <= '1';
      else
        clk1x <= '0';
      end if;
    end if;
  end process CLK_1X_PROCESS;

  -----------------------------------------------------------------------------
  -- PROCESS: CLK_2X_PROCESS
  -- purpose: clk2x generation
  -----------------------------------------------------------------------------
  CLK_2X_PROCESS : process (Sys_clk) is
  begin  -- process CLK_2X_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                  -- synchronous reset (active high)
        clk2x <= '0';
      elsif (clkdiv = "1111" and BaudoutN = '0') then
        clk2x <= '1';
      else
        clk2x <= '0';
      end if;
    end if;
  end process CLK_2X_PROCESS;

 tx_fifo_rd_en_com <= '1' when (clk1x='1' and transmit_state=START_BIT) else 
                      '0';

  -----------------------------------------------------------------------------
  -- PROCESS: TX_FIFO_RD_EN_PROC
  -- purpose: transmit fifo read enable logic
  -----------------------------------------------------------------------------
  TX_FIFO_RD_EN_PROC : process (Sys_clk) is
  begin  -- process TX_FIFO_RD_EN_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        Tx_fifo_rd_en <= '0';
      else
        Tx_fifo_rd_en <= tx_fifo_rd_en_com;
      end if;
    end if;
  end process TX_FIFO_RD_EN_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: TRANSMIT_SM_REG_PROC
  -- purpose: Sout register logic and next state generation logic
  -----------------------------------------------------------------------------
  TRANSMIT_SM_REG_PROC : process (Sys_clk) is
  begin  -- process TRANSMIT_SM_REG_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                  -- synchronous reset (active high)
        Sout           <= '1';
        transmitting_n <= '1';
        tsr            <= (others => '1');
        Tsr_loaded     <= '0';
        tx_parity      <= '0';
        transmit_state <= IDLE;
      elsif clk1x = '1' or (clk2x = '1' and half_stop_bit = '1') then
        Sout           <= sout_com and (not set_break);
        tsr            <= tsr_com;
        Tsr_loaded     <= tsr_loaded_com;
        tx_parity      <= tx_parity_com;
        transmit_state <= next_state;
      else
        Tsr_loaded <= '0';
      end if;
      transmitting_n <= transmitting_n_com;
    end if;
  end process TRANSMIT_SM_REG_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: TRANSMIT_SM_COM
  -- purpose: Transmit state machine
  -----------------------------------------------------------------------------
  TRANSMIT_SM_COM : process (even_parity, Fcr_0, Rst, num_stop_bits, numbits,
                             parity_enable, Start_tx, stick_parity, Thr,
                             transmit_state, tsr, Tx_fifo_data_out, tx_parity)
  begin
    
      next_state         <= transmit_state;
      tsr_loaded_com     <= '0';
      transmitting_n_com <= '1';
      tx_parity_com      <= '0';
      sout_com           <= '1';
      tsr_com            <= (others => '1');

      case transmit_state is
        when IDLE =>
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '1';
          if Start_tx = '0' then
            next_state <= START_BIT;
          else
            next_state <= IDLE;
          end if;

        when START_BIT =>
          sout_com           <= '0';         -- generates low start bit
          tsr_loaded_com     <= '1';
          transmitting_n_com <= '0';
          if Fcr_0 = '1' then
            tsr_com <= Tx_fifo_data_out;
          else
            tsr_com <= Thr;                  -- load data
          end if;
          tx_parity_com <= not even_parity;  -- initialize parity counter
          next_state    <= DATA_BIT1;

        when DATA_BIT1 =>
          tsr_com            <= '1' & tsr(7 downto 1);
          sout_com           <= tsr(0);
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          tx_parity_com      <= tx_parity xor tsr(0);
          next_state         <= DATA_BIT2;

        when DATA_BIT2 =>
          tsr_com            <= '1' & tsr(7 downto 1);
          sout_com           <= tsr(0);
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          tx_parity_com      <= tx_parity xor tsr(0);
          next_state         <= DATA_BIT3;

        when DATA_BIT3 =>
          tsr_com            <= '1' & tsr(7 downto 1);
          sout_com           <= tsr(0);
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          tx_parity_com      <= tx_parity xor tsr(0);
          next_state         <= DATA_BIT4;

        when DATA_BIT4 =>
          tsr_com            <= '1' & tsr(7 downto 1);
          sout_com           <= tsr(0);
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          tx_parity_com      <= tx_parity xor tsr(0);
          next_state         <= DATA_BIT5;

        when DATA_BIT5 =>
          tsr_com            <= '1' & tsr(7 downto 1);
          sout_com           <= tsr(0);
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          tx_parity_com      <= tx_parity xor tsr(0);
          if numbits /= "00" then
            next_state <= DATA_BIT6;
          elsif parity_enable = '1' then
            next_state <= PARITY_BIT;
          else
            next_state <= STOP_BIT1;
          end if;

        when DATA_BIT6 =>
          tsr_com            <= '1' & tsr(7 downto 1);
          sout_com           <= tsr(0);
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          tx_parity_com      <= tx_parity xor tsr(0);
          if numbits /= "01" then
            next_state <= DATA_BIT7;
          elsif parity_enable = '1' then
            next_state <= PARITY_BIT;
          else
            next_state <= STOP_BIT1;
          end if;

        when DATA_BIT7 =>
          tsr_com            <= '1' & tsr(7 downto 1);
          sout_com           <= tsr(0);
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          tx_parity_com      <= tx_parity xor tsr(0);
          if numbits /= "10" then
            next_state <= DATA_BIT8;
          elsif parity_enable = '1' then
            next_state <= PARITY_BIT;
          else
            next_state <= STOP_BIT1;
          end if;

        when DATA_BIT8 =>
          tsr_com            <= '1' & tsr(7 downto 1);
          sout_com           <= tsr(0);
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          tx_parity_com      <= tx_parity xor tsr(0);
          if parity_enable = '1' then
            next_state <= PARITY_BIT;
          else
            next_state <= STOP_BIT1;
          end if;

        when PARITY_BIT =>
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          sout_com           <= stick_parity;
          next_state         <= STOP_BIT1;

        when STOP_BIT1 =>
          tsr_loaded_com <= '0';
          sout_com       <= '1';
          if num_stop_bits = '1' then
            next_state <= STOP_BIT2;
          else
            if Start_tx = '0' then
              transmitting_n_com <= '0';
              next_state         <= START_BIT;
            else
              transmitting_n_com <= '1';
              next_state         <= IDLE;
            end if;
          end if;

        when STOP_BIT2 =>
          tsr_loaded_com <= '0';
          sout_com       <= '1';
          if Start_tx = '0' then
            transmitting_n_com <= '0';
            next_state         <= START_BIT;
          else
            transmitting_n_com <= '1';
            next_state         <= IDLE;
          end if;

        -- added coverage off to disable the coverage for default state
        -- as state machine will never enter in defualt state while doing
        -- verification. 
        -- coverage off
        when others =>
          next_state <= IDLE;
        -- coverage on 

      end case;

  end process;

end implementation;




-------------------------------------------------------------------------------
-- rx_fifo_block.vhd - entity/architecture pair
-------------------------------------------------------------------------------
--  ***************************************************************************
--  ** DISCLAIMER OF LIABILITY                                               **
--  **                                                                       **
--  **  This file contains proprietary and confidential information of       **
--  **  Xilinx, Inc. ("Xilinx"), that is distributed under a license         **
--  **  from Xilinx, and may be used, copied and/or disclosed only           **
--  **  pursuant to the terms of a valid license agreement with Xilinx.      **
--  **                                                                       **
--  **  XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION                **
--  **  ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER           **
--  **  EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT                  **
--  **  LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,            **
--  **  MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx        **
--  **  does not warrant that functions included in the Materials will       **
--  **  meet the requirements of Licensee, or that the operation of the      **
--  **  Materials will be uninterrupted or error-free, or that defects       **
--  **  in the Materials will be corrected. Furthermore, Xilinx does         **
--  **  not warrant or make any representations regarding use, or the        **
--  **  results of the use, of the Materials in terms of correctness,        **
--  **  accuracy, reliability or otherwise.                                  **
--  **                                                                       **
--  **  Xilinx products are not designed or intended to be fail-safe,        **
--  **  or for use in any application requiring fail-safe performance,       **
--  **  such as life-support or safety devices or systems, Class III         **
--  **  medical devices, nuclear facilities, applications related to         **
--  **  the deployment of airbags, or any other applications that could      **
--  **  lead to death, personal injury or severe property or                 **
--  **  environmental damage (individually and collectively, "critical       **
--  **  applications"). Customer assumes the sole risk and liability         **
--  **  of any use of Xilinx products in critical applications,              **
--  **  subject only to applicable laws and regulations governing            **
--  **  limitations on product liability.                                    **
--  **                                                                       **
--  **  Copyright 2010 Xilinx, Inc.                                          **
--  **  All rights reserved.                                                 **
--  **                                                                       **
--  **  This disclaimer and copyright notice must be retained as part        **
--  **  of this file at all times.                                           **
--  ***************************************************************************
-------------------------------------------------------------------------------
-- Filename:        rx_fifo_block.vhd
-- Version:         v2.0
-- Description:     Contains UART rx FIFO and FIFO control circuitry
--
-- VHDL-Standard:   VHDL'93
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_cmb" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------
-- axi_uart16550_v2_0_22 library is used for axi_uart16550_v2_0_22 
-- component declarations
-------------------------------------------------------------------------------
library axi_uart16550_v2_0_22;

-------------------------------------------------------------------------------
-- proc common package of the proc common library is used for different 
-- function declarations
-------------------------------------------------------------------------------
library lib_srl_fifo_v1_0_2;
use lib_srl_fifo_v1_0_2.srl_fifo_rbu_f;

-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------
entity rx_fifo_block is
  generic (
    C_FAMILY         : string := "virtex7");               -- XILINX FPGA family
  port (
    Sys_clk          : in  std_logic;                      -- System Clk
    Rclk             : in  std_logic;                      -- Receiver clock
    Rst              : in  std_logic;                      -- Rst                  
    Rx_fifo_data_in  : in  std_logic_vector(10 downto 0 ); -- Rx fifo data in
    Rx_fifo_wr_en    : in  std_logic;                      -- Rx fifo write en
    Rx_fifo_rd_en    : in  std_logic;                      -- Rx fifo read en
    Rx_fifo_rst      : in  std_logic;                      -- Rx fifo rst
    Fcr              : in  std_logic_vector(7 downto 0 );  -- Fifo Control reg
    Rx_fifo_data_out : out std_logic_vector(10 downto 0 ); -- Rx fifo data out
    Rx_fifo_empty    : out std_logic;                      -- Rx fifo empty
    Rx_fifo_timeout  : out std_logic;                      -- Rx fifo timeout 
    Rx_fifo_trigger  : out std_logic;                      -- Rx fifo trigger
    Rx_fifo_full     : out std_logic;                      -- Rx fifo full
    Rx_error_in_fifo : out std_logic                       -- Rx error in fifo
    );


end rx_fifo_block;


-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------
architecture implementation of rx_fifo_block is

-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of implementation : architecture is "yes";
  
-------------------------------------------------------------------------------
-- Signal Declarations
-------------------------------------------------------------------------------
  signal rx_fifo_empty_i   : std_logic;
  signal rx_fifo_full_i    : std_logic;
  signal rx_fifo_count     : std_logic_vector(3 downto 0);
  signal rx_fifo_rd_en_i   : std_logic;
  signal rx_fifo_wr_en_i   : std_logic;
  
begin

  Rx_fifo_empty   <= rx_fifo_empty_i;
  Rx_fifo_full    <= rx_fifo_full_i;
  rx_fifo_rd_en_i <= Rx_fifo_rd_en and (not rx_fifo_empty_i);
  rx_fifo_wr_en_i <= Rx_fifo_wr_en and (not rx_fifo_full_i);

  -----------------------------------------------------------------------------
  -- Instantiating rx_fifo_control module
  -----------------------------------------------------------------------------
  rx_fifo_control_1 : entity axi_uart16550_v2_0_22.rx_fifo_control
  generic map (
      C_FAMILY         =>  C_FAMILY )
    port map (
      Fcr              => Fcr,
      Rx_fifo_empty    => rx_fifo_empty_i,
      rx_fifo_count    => rx_fifo_count,
      Rx_fifo_rd_en    => rx_fifo_rd_en_i,
      Rx_fifo_wr_en    => rx_fifo_wr_en_i,
      Rx_fifo_data_in  => Rx_fifo_data_in,
      Rx_fifo_trigger  => Rx_fifo_trigger,
      Rx_fifo_timeout  => Rx_fifo_timeout,
      Rx_error_in_fifo => Rx_error_in_fifo,
      Rclk             => Rclk,
      Rst              => Rst,
      Rx_fifo_rst      => Rx_fifo_rst,
      Sys_clk          => Sys_clk);
      
  -----------------------------------------------------------------------------
  -- Instantiating srl_fifo from proc_common
  -----------------------------------------------------------------------------
  srl_fifo_rbu_f_i1 : entity lib_srl_fifo_v1_0_2.srl_fifo_rbu_f
    generic map (
      C_DWIDTH => 11,
      C_DEPTH  => 16,
      C_FAMILY => C_FAMILY 
                )
    port map (
      Clk           => Sys_clk,            -- [in]
      Reset         => Rx_fifo_rst,        -- [in]
      FIFO_Write    => rx_fifo_wr_en_i,    -- [in]
      Data_In       => Rx_fifo_data_in,    -- [in]
      FIFO_Read     => rx_fifo_rd_en_i,    -- [in]
      Data_Out      => Rx_fifo_data_out,   -- [out]
      FIFO_Full     => rx_fifo_full_i,     -- [out]
      FIFO_Empty    => rx_fifo_empty_i,    -- [out]
      Addr          => rx_fifo_count,      -- [out]
      Num_To_Reread => X"0",               -- [in]
      Underflow     => open,               -- [out]
      Overflow      => open);              -- [out]
  -------------------------------------------       
 
end implementation;


-------------------------------------------------------------------------------
-- rx16550.vhd - entity/architecture pair
-------------------------------------------------------------------------------
--  ***************************************************************************
--  ** DISCLAIMER OF LIABILITY                                               **
--  **                                                                       **
--  **  This file contains proprietary and confidential information of       **
--  **  Xilinx, Inc. ("Xilinx"), that is distributed under a license         **
--  **  from Xilinx, and may be used, copied and/or disclosed only           **
--  **  pursuant to the terms of a valid license agreement with Xilinx.      **
--  **                                                                       **
--  **  XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION                **
--  **  ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER           **
--  **  EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT                  **
--  **  LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,            **
--  **  MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx        **
--  **  does not warrant that functions included in the Materials will       **
--  **  meet the requirements of Licensee, or that the operation of the      **
--  **  Materials will be uninterrupted or error-free, or that defects       **
--  **  in the Materials will be corrected. Furthermore, Xilinx does         **
--  **  not warrant or make any representations regarding use, or the        **
--  **  results of the use, of the Materials in terms of correctness,        **
--  **  accuracy, reliability or otherwise.                                  **
--  **                                                                       **
--  **  Xilinx products are not designed or intended to be fail-safe,        **
--  **  or for use in any application requiring fail-safe performance,       **
--  **  such as life-support or safety devices or systems, Class III         **
--  **  medical devices, nuclear facilities, applications related to         **
--  **  the deployment of airbags, or any other applications that could      **
--  **  lead to death, personal injury or severe property or                 **
--  **  environmental damage (individually and collectively, "critical       **
--  **  applications"). Customer assumes the sole risk and liability         **
--  **  of any use of Xilinx products in critical applications,              **
--  **  subject only to applicable laws and regulations governing            **
--  **  limitations on product liability.                                    **
--  **                                                                       **
--  **  Copyright 2010 Xilinx, Inc.                                          **
--  **  All rights reserved.                                                 **
--  **                                                                       **
--  **  This disclaimer and copyright notice must be retained as part        **
--  **  of this file at all times.                                           **
--  ***************************************************************************
-------------------------------------------------------------------------------
-- Filename:        rx16550.vhd
-- Version:         v2.0
-- Description:     Implements the receiver portion of uart16550
--
-- VHDL-Standard:   VHDL'93
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_cmb" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned."+";
use ieee.std_logic_unsigned."-";

-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------
entity rx16550 is
  port (
    Sys_clk            : in  std_logic;  -- sysclk
    Rclk               : in  std_logic;  -- receive clock
    Rst                : in  std_logic;  -- reset
    Lcr                : in  std_logic_vector (7 downto 0);  
                                         -- line control register
    Rbr                : out std_logic_vector (7 downto 0);  
                                         -- receiver holding register
    Fcr_0              : in  std_logic;  -- FIFO enable indication bit from FCR
    Sin                : in  std_logic;  -- serial data out
    Parity_error       : out std_logic;  -- parity error flag
    Framing_error      : out std_logic;  -- framing error flag
    Break_interrupt    : out std_logic;  -- break interrupt flag
    Data_ready         : out std_logic;  -- data ready flag
    Rx_fifo_data_in    : out std_logic_vector (10 downto 0);  
                                         -- receiver fifo data input
    Character_received : out std_logic;  -- flags character has been received
    Have_bi_in_fifo_n  : out std_logic   -- break interrupt is in fifo
    );

end rx16550;

-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------
architecture implementation of rx16550 is

-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of implementation : architecture is "yes";

-------------------------- Constant Declarations  -----------------------------
--------------------------- Signal Declarations  ------------------------------
  
  type STATE_TYPE is (IDLE, START_BIT, DATA_BIT1, DATA_BIT2, DATA_BIT3, 
                      DATA_BIT4, DATA_BIT5, DATA_BIT6, DATA_BIT7, DATA_BIT8,
                      PARITY_BIT, STOP_BIT1, STOP_BIT2, FRAME_ERROR);

-------------------------------------------------------------------------------
-- Signal Declarations
-------------------------------------------------------------------------------
  signal receive_state       : STATE_TYPE;  -- states for receive state machine
  signal next_state          : STATE_TYPE;  -- states for receive state machine
  signal rsr                 : std_logic_vector (7 downto 0);  -- receive shift
                                                               -- register
  signal rbr_d               : std_logic_vector (7 downto 0);  -- internal copy
                                                               -- of Rbr
  signal rx_parity_com       : std_logic;  -- rx_parity signal
  signal parity_error_d      : std_logic;  -- internal version of  
                                           -- Parity_error output
  signal parity_error_i      : std_logic;  -- internal version of 
                                           --Parity_error output
  signal parity_error_latch  : std_logic;  -- internal version of 
                                           -- Parity_error output
  signal clkdiv              : std_logic_vector (3 downto 0); -- clock counter
  signal clk1x               : std_logic;  -- serial data clock
  signal clk1x_d             : std_logic;  -- serial data clock delsyed 1
                                           -- Sys_clk cycle
  signal clk2x               : std_logic;  -- 2x clock for creating 1/2 
                                           --stop bit
  signal sin_d1              : std_logic;  -- serial data in delayed by 1
  signal sin_d2              : std_logic;  -- serial data in delayed by 2
  signal sin_d3              : std_logic;  -- serial data in delayed by 3
  signal sin_d4              : std_logic;  -- serial data in delayed by 4
  signal sin_d5              : std_logic;  -- serial data in delayed by 5
  signal sin_d6              : std_logic;  -- serial data in delayed by 6
  signal sin_d7              : std_logic;  -- serial data in delayed by 7
  signal sin_d8              : std_logic;  -- serial data in delayed by 8
  signal sin_d9              : std_logic;  -- serial data in delayed by 9
  signal sin_d10             : std_logic;  -- serial data in delayed by 10
  signal parity_enable       : std_logic;  -- Lcr(3) PE (parity enabled 
                                           -- when '1')
  signal even_parity         : std_logic;  -- Lcr(4) EPS (even parity 
                                           -- selected )
  signal numbits             : std_logic_vector (1 downto 0);  
                                           -- Lcr(1) & Lcr(0)
  signal got_start_bit_d     : std_logic;  -- found start bit register
  signal got_start_bit_com   : std_logic;  -- found start bit logic
  signal resynch_clkdiv      : std_logic;
  signal resynch_clkdiv_d    : std_logic;
  signal num_stop_bits       : std_logic;  -- number of stop bits
  signal half_stop_bit       : std_logic;  -- flags half a stop bit
  signal clk_div_en          : std_logic;  -- enables sample clock
  signal framing_error_com   : std_logic;  -- framing error logic
  signal framing_error_d     : std_logic;  -- internal version of 
                                           -- Framing_error
  signal framing_error_i     : std_logic;  -- internal version of 
                                           -- Framing_error
                                           -- output
  signal framing_error_flag  : std_logic;  -- framing error logic
  signal break_interrupt_com : std_logic;  -- inverse of break interrupt 
                                           -- (for local accumulation of bits)
  signal break_interrupt_error_d   : std_logic;  -- break interrupt accumulator
  signal break_interrupt_i         : std_logic;  -- break interrupt accumulator
  signal break_interrupt_flag      : std_logic;  -- break interrupt accumulator
  signal character_received_com    : std_logic;
  signal character_received_d      : std_logic;
  signal character_received_flag   : std_logic;
  signal character_received_rclk   : std_logic;
  signal load_rbr_d                : std_logic;
  signal load_rbr_com              : std_logic;
  signal have_bi_in_fifo_n_i       : std_logic;
  signal resynch_clkdiv_startbit   : std_logic;
  signal resynch_clkdiv_startbit_d : std_logic;
  signal clk_div_rst               : std_logic;
  signal stick_parity              : std_logic;
  signal resynch_clkdiv_frame      : std_logic;
  signal resynch_clkdiv_frame_d    : std_logic;
  signal clock_1x_early            : std_logic;

begin


  stick_parity  <= Lcr(5);
  parity_enable <= Lcr(3);
  even_parity   <= Lcr(4);
  num_stop_bits <= Lcr(2);

  half_stop_bit <= '1' when (num_stop_bits = '1' and numbits = "00" and 
                             receive_state = STOP_BIT1) else '0';
  numbits       <= Lcr(1) & Lcr(0);

  Have_bi_in_fifo_n <= have_bi_in_fifo_n_i;
-------------------------------------------------------------------------------
-- Rclk processes
-------------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- PROCESS: SIN_DELAY_PROC
  -- purpose: register and delay Sin input
  -----------------------------------------------------------------------------
  SIN_DELAY_PROC : process (Sys_clk) is
  begin  -- process SIN_DELAY_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        sin_d1  <= '0';
        sin_d2  <= '0';
        sin_d3  <= '0';
        sin_d4  <= '0';
        sin_d5  <= '0';
        sin_d6  <= '0';
        sin_d7  <= '0';
        sin_d8  <= '0';
        sin_d9  <= '0';
        sin_d10 <= '0';
      elsif Rclk = '1' then
        sin_d1  <= Sin;
        sin_d2  <= sin_d1;
        sin_d3  <= sin_d2;
        sin_d4  <= sin_d3;
        sin_d5  <= sin_d4;
        sin_d6  <= sin_d5;
        sin_d7  <= sin_d6;
        sin_d8  <= sin_d7;
        sin_d9  <= sin_d8;
        sin_d10 <= sin_d9;
      end if;
    end if;
  end process SIN_DELAY_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: GOT_START_BIT_PROC
  -- purpose: register got_start_bit_d
  -----------------------------------------------------------------------------
  GOT_START_BIT_PROC : process (Sys_clk) is
  begin  -- process GOT_START_BIT_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        got_start_bit_d  <= '0';
      elsif Rclk = '1' then
        got_start_bit_d  <= got_start_bit_com;
      end if;
    end if;
  end process GOT_START_BIT_PROC;

  -- detect the start of the frame and re-sync the clock_div logic to sample
  -- the data at the centre of the Sin input
  resynch_clkdiv <= '1' when ((got_start_bit_d = '1' and 
                               framing_error_d = '0' and
                               sin_d5 = '0' and sin_d6 = '1' and 
                               clock_1x_early = '0' and
                               ((num_stop_bits = '0' and 
                                 receive_state = STOP_BIT1) or
                                receive_state = STOP_BIT2)) and Rclk = '1')else 
                    '0';

  -- Generated clkdiv resynch signal when the receive state is in START_BIT 
  -- delayed start_bit is detected. 
  -- Modified for CR:441089 
  resynch_clkdiv_startbit <= '1' when (got_start_bit_d = '1' and 
                                       sin_d9 = '0' and sin_d10 = '1' and 
                                 receive_state = START_BIT and Rclk = '1') else
                             '0';


  -- Generated clkdiv resynch signal in case of framming error to synchronize 
  -- with sin. 
  resynch_clkdiv_frame <= '1' when ((got_start_bit_d = '1' and 
                                     framing_error_d = '1' and
                                     sin_d9 = '0' and sin_d10 = '1' and 
                                     ((num_stop_bits = '0' and 
                                       receive_state = FRAME_ERROR) or
                                      receive_state = STOP_BIT2)) 
                                      and Rclk = '1') else 
                          '0';
  
  -----------------------------------------------------------------------------
  -- PROCESS: RESYNCH_CLKDIV_PROC
  -- purpose: register resynch_clkdiv_d and resynch_clkdiv_startbit_d
  -----------------------------------------------------------------------------
  RESYNCH_CLKDIV_PROC : process (Sys_clk) is
  begin  -- process RESYNCH_CLKDIV_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        resynch_clkdiv_d <= '0';
        resynch_clkdiv_startbit_d <= '0';
      else
        resynch_clkdiv_d <= resynch_clkdiv;
        resynch_clkdiv_startbit_d <= resynch_clkdiv_startbit;
        resynch_clkdiv_frame_d <= resynch_clkdiv_frame;    
      end if;
    end if;
  end process RESYNCH_CLKDIV_PROC;
  
  -- generate clock_div reset
  clk_div_rst <= '1' when ((receive_state = IDLE and clk1x_d = '1') or
                           have_bi_in_fifo_n_i = '0') else 
                 '0';          

  -----------------------------------------------------------------------------
  -- PROCESS: CLOCK_DIV_EN_PROC
  -- purpose: register resynch_clkdiv_d and resynch_clkdiv_startbit_d
  -----------------------------------------------------------------------------
  CLOCK_DIV_EN_PROC : process (Sys_clk) is
  begin  -- process CLOCK_DIV_EN_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' or clk_div_rst = '1' then -- synchronous reset 
        clk_div_en <= '0';                   -- (active high)  
      elsif Rclk = '1' then
        if (got_start_bit_d = '0' and sin_d1 = '0' and sin_d2 = '1') then
          clk_div_en <= '1';
        end if;
      end if;
    end if;
  end process CLOCK_DIV_EN_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: CLOCK_DIV_PROCESS
  -- purpose: clk_div counter to synchronize with the Sin input
  -----------------------------------------------------------------------------
  CLOCK_DIV_PROCESS : process (Sys_clk) is
  begin  -- process CLOCK_DIV_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' or clk_div_en = '0' then  -- synchronous reset (active high)
        clkdiv <= "0000";
      elsif (resynch_clkdiv = '1' or resynch_clkdiv_startbit = '1') then
        clkdiv <= "0000"; 
      elsif (clk2x = '1' and half_stop_bit = '1') then
        clkdiv <= "0111";
      elsif resynch_clkdiv_d = '1' then
        clkdiv <= "0100";       
      elsif resynch_clkdiv_startbit_d = '1' or resynch_clkdiv_frame_d = '1' then
        clkdiv <= "1000";
      elsif Rclk = '1' and clk_div_en = '1' then
        clkdiv <= clkdiv + "0001";
      end if;
    end if;
  end process CLOCK_DIV_PROCESS;

  -----------------------------------------------------------------------------
  -- PROCESS: CLK_1X_PROCESS
  -- purpose: clock_1x generation
  -----------------------------------------------------------------------------
  CLK_1X_PROCESS : process (Sys_clk) is
  begin  -- process CLK_1X_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        clk1x <= '0';
      elsif (Rclk = '1' and clkdiv = "0111" and 
             resynch_clkdiv = '0' and resynch_clkdiv_startbit = '0') then
        clk1x <= '1';
      else
        clk1x <= '0';
      end if;
    end if;
  end process CLK_1X_PROCESS;


  -----------------------------------------------------------------------------
  -- PROCESS: CLK_1X_EARLY_PROCESS
  -- purpose: clock_1x_early generation
  -----------------------------------------------------------------------------
  CLK_1X_EARLY_PROCESS : process (Sys_clk) is
  begin  -- process CLK_1X_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        clock_1x_early <= '0';
      elsif (Rclk = '1' and clkdiv = "0110" ) then
        clock_1x_early <= '1';
      else
        clock_1x_early <= '0';
      end if;
    end if;
  end process CLK_1X_EARLY_PROCESS;

  -----------------------------------------------------------------------------
  -- PROCESS: CLK_1X_DELAY_PROC
  -- purpose: delay clk1x
  -----------------------------------------------------------------------------
  CLK_1X_DELAY_PROC : process (Sys_clk) is
  begin  -- process CLK_1X_DELAY_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then
        clk1x_d <= '0';
      else
        clk1x_d <= clk1x;
      end if;
    end if;
  end process CLK_1X_DELAY_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: CLK_2X_PROCESS
  -- purpose: clk2x generation
  -----------------------------------------------------------------------------
  CLK_2X_PROCESS : process (Sys_clk) is
  begin  -- process CLK_2X_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        clk2x <= '0';
      elsif (Rclk = '1' and clkdiv = "1111") then
        clk2x <= '1';
      else
        clk2x <= '0';
      end if;
    end if;
  end process CLK_2X_PROCESS;

  -----------------------------------------------------------------------------
  -- PROCESS: CHAR_RECEIVED_PROC
  -- purpose: generate character receive clock
  -----------------------------------------------------------------------------
  CHAR_RECEIVED_PROC : process (Sys_clk) is
  begin  -- process CHAR_RECEIVED_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        character_received_rclk <= '0';
      elsif Rclk = '1' then
        character_received_rclk <= character_received_d;
      end if;
    end if;
  end process CHAR_RECEIVED_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: FRAMING_ERROR_PROC
  -- purpose: framing error flag generation
  -----------------------------------------------------------------------------
  FRAMING_ERROR_PROC : process (Sys_clk) is
  begin  -- process DATA_RDY_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then               -- rising clock edge
      if Rst = '1' or character_received_rclk = '1' then  -- synchronous reset 
        framing_error_flag <= '0';                        -- (active high)
      elsif Rclk = '1' and framing_error_d = '1' then
        framing_error_flag <= '1';
      end if;
    end if;
  end process FRAMING_ERROR_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: BREAK_INTERRUPT_ERROR_PROC
  -- purpose: break interrupt error flag generation
  -----------------------------------------------------------------------------
  BREAK_INTERRUPT_ERROR_PROC : process (Sys_clk) is
  begin  -- process DATA_RDY_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then               -- rising clock edge
      if Rst = '1' or character_received_rclk = '1' then  -- synchronous reset
        break_interrupt_flag <= '0';                      --  (active high)
      elsif Rclk = '1' and break_interrupt_error_d = '1' then
        break_interrupt_flag <= '1';
      end if;
    end if;
  end process BREAK_INTERRUPT_ERROR_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: CHARACTER_RECEIVED_PROC
  -- purpose: character received flag generation
  -----------------------------------------------------------------------------
  CHARACTER_RECEIVED_PROC : process (Sys_clk) is
  begin  -- process DATA_RDY_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then               -- rising clock edge
      if Rst = '1' or character_received_rclk = '1' then  -- synchronous reset
        character_received_flag <= '0';                   --  (active high)
      else
        character_received_flag <= Rclk and character_received_d;
      end if;
    end if;
  end process CHARACTER_RECEIVED_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: CONDITION_CODE_PROC
  -- purpose: Pass condition flags on
  -----------------------------------------------------------------------------
  CONDITION_CODE_PROC : process (Sys_clk) is
  begin  -- process CONDITION_CODE_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        Rbr                <= (others => '0');
        parity_error_i     <= '0';
        framing_error_i    <= '0';
        Data_ready         <= '0';
        break_interrupt_i  <= '0';
        Character_received <= '0';
      else
        Rbr                <= rbr_d;
        parity_error_i     <= parity_error_latch and character_received_flag 
                                                 and parity_enable;
        framing_error_i    <= framing_error_flag and character_received_flag;
        break_interrupt_i  <= (not break_interrupt_flag) and 
                              character_received_flag;
        Character_received <= character_received_flag;
        Data_ready         <= character_received_flag;
      end if;
    end if;
  end process CONDITION_CODE_PROC;

  -- rx_fifo_data input generation
  Rx_fifo_data_in(7 downto 0) <= rbr_d(7 downto 0);
  Rx_fifo_data_in(8)          <= break_interrupt_i;
  Rx_fifo_data_in(9)          <= framing_error_i;
  Rx_fifo_data_in(10)         <= parity_error_i;
  
  -- generate error
  Parity_error                <= parity_error_i;                                 
  Framing_error               <= framing_error_i;
  Break_interrupt             <= break_interrupt_i;

  -----------------------------------------------------------------------------
  -- PROCESS: HAVE_BI_IN_FIFO_PROC
  -- purpose: generate receive fifo rst
  -----------------------------------------------------------------------------
  HAVE_BI_IN_FIFO_PROC : process (Sys_clk) is
  begin  -- process HAVE_BI_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' or sin_d2 = '1' then      -- synchronous reset (active high)
        have_bi_in_fifo_n_i <= '1';
      elsif (Fcr_0 = '0' and break_interrupt_flag = '0' and 
                             character_received_flag = '1') then
        have_bi_in_fifo_n_i <= '0';
      elsif (Fcr_0 = '1' and break_interrupt_flag = '0' and 
                                                  break_interrupt_i = '1') then
             have_bi_in_fifo_n_i <= '0';
      end if;
    end if;
  end process HAVE_BI_IN_FIFO_PROC;

-------------------------------------------------------------------------------
-- 16x clock processes
-------------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- PROCESS: LOAD_RBR_COND_PROC
  -- purpose: generate receive buffer load 
  -----------------------------------------------------------------------------
  LOAD_RBR_COND_PROC : process (Sys_clk) is
  begin  -- process LOAD_RBR_COND_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then        -- rising clock edge
      if Rst = '1' or resynch_clkdiv_d = '1' then  -- synchronous reset 
        load_rbr_d <= '0';                               -- (active high)
      elsif clk2x = '1' then
        load_rbr_d <= load_rbr_com;
      end if;
    end if;
  end process LOAD_RBR_COND_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: RBR_PROCESS
  -- purpose: load Rbr with receive data
  -----------------------------------------------------------------------------
  RBR_PROCESS : process (Sys_clk) is
  begin  -- process RBR_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        rbr_d <= (others => '0');
      elsif clk1x = '1' and load_rbr_d = '1' then
        case numbits is
          when "11" =>                  -- 8 bits
            rbr_d(7 downto 0) <= rsr(7 downto 0);
          when "10" =>                  -- 7 bits
            rbr_d(7 downto 0) <= '0' & rsr(7 downto 1);
          when "01" =>                  -- 6 bits
            rbr_d(7 downto 0) <= "00" & rsr(7 downto 2);
          when "00" =>                  -- 5 bits
            rbr_d(7 downto 0) <= "000" & rsr(7 downto 3);
          -- coverage off
          when others =>                -- default to 8
            rbr_d(7 downto 0) <= rsr(7 downto 0);
          -- coverage on
        end case;
      end if;
    end if;
  end process RBR_PROCESS;

  -----------------------------------------------------------------------------
  -- PROCESS: PARITY_LATCH_PROC
  -- purpose: latch parity error
  -----------------------------------------------------------------------------
  PARITY_LATCH_PROC : process (Sys_clk) is
  begin  -- process PARITY_LATCH_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then               -- rising clock edge
      if Rst = '1' or character_received_rclk = '1' then  -- synchronous reset 
        parity_error_latch <= '0';                        -- (active high)
      elsif clk2x = '1' and load_rbr_d = '1' then
        parity_error_latch <= parity_error_d;
      end if;
    end if;
  end process PARITY_LATCH_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: SHIFT_RSR_PROC
  -- purpose: shift register to capture serial Sin input
  -----------------------------------------------------------------------------
  SHIFT_RSR_PROC : process (Sys_clk) is
  begin  -- process SHIFT_RSR_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        rsr <= (others => '0');
      elsif clk1x_d = '1' then
        rsr(7)          <= sin_d2;
        rsr(6 downto 0) <= rsr(7 downto 1);
      end if;
    end if;
  end process SHIFT_RSR_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: RECEIVE_SM_REG_PROC
  -- purpose: register error flag and next state generation logic
  -----------------------------------------------------------------------------
  RECEIVE_SM_REG_PROC : process (Sys_clk) is
  begin  -- process RECEIVE_SM_REG_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then           -- rising clock edge
      if Rst = '1' or have_bi_in_fifo_n_i = '0' then  -- synchronous reset 
        parity_error_d          <= '0';               -- (active high)
        break_interrupt_error_d <= '0';
        framing_error_d         <= '0';
        character_received_d    <= '0';
        receive_state           <= IDLE;
      elsif clk1x = '1' then
        parity_error_d          <= rx_parity_com;
        break_interrupt_error_d <= break_interrupt_com;
        framing_error_d         <= framing_error_com;
        character_received_d    <= character_received_com;
        receive_state           <= next_state;
      end if;
    end if;
  end process RECEIVE_SM_REG_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: RECEIVE_SM_COM_PROC
  -- purpose: Receive state machine
  -----------------------------------------------------------------------------
  RECEIVE_SM_COM_PROC : process (break_interrupt_error_d, even_parity, Rst,    
                                 num_stop_bits, numbits, parity_enable,stick_parity,
                                 parity_error_d, receive_state, sin_d2) is
  begin  -- process RECEIVE_SM_COM_PROC
      rx_parity_com          <= '0';
      break_interrupt_com    <= '0';
      framing_error_com      <= '0';
      character_received_com <= '0';
      load_rbr_com           <= '0';
      got_start_bit_com      <= '0';
      next_state             <= receive_state;

      case receive_state is
        when IDLE =>
          rx_parity_com          <= not even_parity;
          break_interrupt_com    <= '0';
          framing_error_com      <= '0';
          character_received_com <= '0';
          load_rbr_com           <= '0';
          got_start_bit_com      <= '0';
          if sin_d2 = '0' then
            next_state <= START_BIT;
          else
            next_state <= IDLE;
          end if;

        when START_BIT =>
          rx_parity_com          <= parity_error_d xor sin_d2;
          break_interrupt_com    <= break_interrupt_error_d or sin_d2;
          framing_error_com      <= '0';
          character_received_com <= '0';
          load_rbr_com           <= '0';
          got_start_bit_com      <= '1';
          next_state             <= DATA_BIT1;

        when DATA_BIT1 =>
          rx_parity_com          <= parity_error_d xor sin_d2;
          break_interrupt_com    <= break_interrupt_error_d or sin_d2;
          framing_error_com      <= '0';
          character_received_com <= '0';
          load_rbr_com           <= '0';
          got_start_bit_com      <= '1';
          next_state             <= DATA_BIT2;

        when DATA_BIT2 =>
          rx_parity_com          <= parity_error_d xor sin_d2;
          break_interrupt_com    <= break_interrupt_error_d or sin_d2;
          framing_error_com      <= '0';
          character_received_com <= '0';
          load_rbr_com           <= '0';
          got_start_bit_com      <= '1';
          next_state             <= DATA_BIT3;

        when DATA_BIT3 =>
          rx_parity_com          <= parity_error_d xor sin_d2;
          break_interrupt_com    <= break_interrupt_error_d or sin_d2;
          framing_error_com      <= '0';
          character_received_com <= '0';
          load_rbr_com           <= '0';
          got_start_bit_com      <= '1';
          next_state             <= DATA_BIT4;

        when DATA_BIT4 =>
          rx_parity_com          <= parity_error_d xor sin_d2;
          break_interrupt_com    <= break_interrupt_error_d or sin_d2;
          framing_error_com      <= '0';
          character_received_com <= '0';
          load_rbr_com           <= '0';
          got_start_bit_com      <= '1';
          next_state             <= DATA_BIT5;

        when DATA_BIT5 =>
          character_received_com <= '0';
          got_start_bit_com      <= '1';

          -- When stic parity is enabled, Parity bit is checked as not of 
          -- Even Parity Select
          if stick_parity = '1' and numbits = "00"then 
            rx_parity_com        <= even_parity xnor sin_d2;
          else 
            rx_parity_com        <= parity_error_d xor sin_d2;
          end if;
          

          if numbits /= "00" then
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '0';
            next_state           <= DATA_BIT6;
          elsif parity_enable = '1' then
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '1';
            next_state           <= PARITY_BIT;
          elsif num_stop_bits = '0' and sin_d2 = '0' then
            break_interrupt_com  <= '0';
            framing_error_com    <= '1';
            load_rbr_com         <= '1';
            next_state           <= FRAME_ERROR; -- In case of frame error, 
                                               -- sample start bit twice
          elsif num_stop_bits = '1' and sin_d2 = '0' then
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '1';
            load_rbr_com           <= '1';
            next_state             <= STOP_BIT1; -- In case of frame error, 
                                                 -- sample start bit twice
          else
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '1';
            next_state           <= STOP_BIT1;
          end if;
          
        when DATA_BIT6 =>
          character_received_com <= '0';
          got_start_bit_com      <= '1';
          
          -- When stic parity is enabled, Parity bit is checked as not of 
          -- Even Parity Select
          if stick_parity = '1' and numbits = "01"then 
            rx_parity_com        <= even_parity xnor sin_d2;
          else 
            rx_parity_com        <= parity_error_d xor sin_d2;
          end if;

          if numbits /= "01" then
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '0';
            next_state           <= DATA_BIT7;
          elsif parity_enable = '1' then
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '1';
            next_state           <= PARITY_BIT;
          elsif num_stop_bits = '0' and sin_d2 = '0' then
            break_interrupt_com  <= '0';
            framing_error_com    <= '1';
            load_rbr_com         <= '1';
            next_state           <= FRAME_ERROR; -- In case of frame error, 
                                                 -- sample start bit twice
          elsif num_stop_bits = '1' and sin_d2 = '0' then
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '1';
            load_rbr_com           <= '1';
            next_state             <= STOP_BIT1; -- In case of frame error, 
                                                 -- sample start bit twice
          else
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '1';
            next_state           <= STOP_BIT1;
          end if;

        when DATA_BIT7 =>
          character_received_com <= '0';
          got_start_bit_com      <= '1';
          
          -- When stic parity is enabled, Parity bit is checked as not of 
          -- Even Parity Select
          if stick_parity = '1' and numbits = "10"then 
            rx_parity_com        <= even_parity xnor sin_d2;
          else 
            rx_parity_com        <= parity_error_d xor sin_d2;
          end if;
          
          if numbits /= "10" then
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '0';
            next_state           <= DATA_BIT8;
          elsif parity_enable = '1' then
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '1';
            next_state           <= PARITY_BIT;
          elsif num_stop_bits = '0' and sin_d2 = '0' then
            break_interrupt_com  <= '0';
            framing_error_com    <= '1';
            load_rbr_com         <= '1';
            next_state           <= FRAME_ERROR; -- In case of frame error, 
                                               -- sample start bit twice
          elsif num_stop_bits = '1' and sin_d2 = '0' then
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '1';
            load_rbr_com           <= '1';
            next_state             <= STOP_BIT1; -- In case of frame error, 
                                                 -- sample start bit twice
          else
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '1';
            next_state           <= STOP_BIT1;
          end if;

        when DATA_BIT8 =>
          load_rbr_com           <= '1';
          got_start_bit_com      <= '1';
          
          -- When stic parity is enabled, Parity bit is checked as not of 
          -- Even Parity Select
          if stick_parity = '1' then 
            rx_parity_com        <= even_parity xnor sin_d2;
          else 
            rx_parity_com        <= parity_error_d xor sin_d2;
          end if;
          
          if parity_enable = '1' then
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '0';
            character_received_com <= '0';
            next_state             <= PARITY_BIT;
          elsif num_stop_bits = '0' and sin_d2 = '0' then
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '1';
            character_received_com <= '0';
            next_state             <= FRAME_ERROR; -- In case of frame error, 
                                                 -- sample start bit twice
          elsif num_stop_bits = '1' and sin_d2 = '0' then
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '1';
            character_received_com <= '0';
            next_state             <= STOP_BIT1; -- In case of frame error, 
                                                 -- sample start bit twice
          else
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '0';
            character_received_com <= '0';
            next_state             <= STOP_BIT1;
          end if;

        when PARITY_BIT =>
          rx_parity_com       <= not even_parity;
          load_rbr_com        <= '0';
          got_start_bit_com   <= '1';
          
          if num_stop_bits = '0' and sin_d2 = '0' then
            break_interrupt_com    <= '0';
            framing_error_com      <= '1';
            character_received_com <= '0';
            next_state             <= FRAME_ERROR; -- In case of frame error, 
                                                 -- sample start bit twice
          elsif num_stop_bits = '1' and sin_d2 = '0' then
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '1';
            character_received_com <= '0';
            next_state             <= STOP_BIT1; -- In case of frame error, 
                                                   -- sample start bit twice
          else
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '0';
            character_received_com <= '0';
            next_state             <= STOP_BIT1;
          end if;

        when STOP_BIT1 =>
          rx_parity_com <= not even_parity;
          load_rbr_com  <= '0';

          if num_stop_bits = '1' then
              break_interrupt_com    <= break_interrupt_error_d or sin_d2;
              framing_error_com      <= '0';
              character_received_com <= '0';
              got_start_bit_com      <= '1';
              next_state             <= STOP_BIT2;
          else
            if sin_d2 = '0' then
              break_interrupt_com    <= '0';
              framing_error_com      <= '0';
              character_received_com <= '1';
              got_start_bit_com      <= '1';
              next_state             <= START_BIT;
            else
              break_interrupt_com    <= '0';
              framing_error_com      <= '0';
              character_received_com <= '1';
              got_start_bit_com      <= '0';
              next_state             <= IDLE;
            end if;
          end if;

        when STOP_BIT2 =>
          rx_parity_com          <= not even_parity;
          break_interrupt_com    <= '0';
          framing_error_com      <= '0';
          load_rbr_com           <= '0';
          character_received_com <= '1';

          if sin_d2 = '0' then
            got_start_bit_com    <= '1';
            next_state           <= START_BIT;
          else
            got_start_bit_com    <= '0';
            next_state           <= IDLE;
          end if;
          
        when FRAME_ERROR =>
          rx_parity_com          <= not even_parity;
          break_interrupt_com    <= '0';
          framing_error_com      <= '0';
          load_rbr_com           <= '0';
          character_received_com <= '1';

          if sin_d2 = '0' then
            got_start_bit_com    <= '1';
            next_state           <= START_BIT;
          else
            got_start_bit_com    <= '0';
            next_state           <= IDLE;
          end if;
        

        -- coverage off
        when others =>
          rx_parity_com          <= '0';
          break_interrupt_com    <= '0';
          framing_error_com      <= '0';
          load_rbr_com           <= '0';
          character_received_com <= '0';
          got_start_bit_com      <= '0';
          next_state             <= IDLE;
        -- coverage on
      end case;

  end process RECEIVE_SM_COM_PROC;

end implementation;


-------------------------------------------------------------------------------
-- uart16550.vhd - entity/architecture pair
-------------------------------------------------------------------------------
--  ***************************************************************************
--  ** DISCLAIMER OF LIABILITY                                               **
--  **                                                                       **
--  **  This file contains proprietary and confidential information of       **
--  **  Xilinx, Inc. ("Xilinx"), that is distributed under a license         **
--  **  from Xilinx, and may be used, copied and/or disclosed only           **
--  **  pursuant to the terms of a valid license agreement with Xilinx.      **
--  **                                                                       **
--  **  XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION                **
--  **  ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER           **
--  **  EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT                  **
--  **  LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,            **
--  **  MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx        **
--  **  does not warrant that functions included in the Materials will       **
--  **  meet the requirements of Licensee, or that the operation of the      **
--  **  Materials will be uninterrupted or error-free, or that defects       **
--  **  in the Materials will be corrected. Furthermore, Xilinx does         **
--  **  not warrant or make any representations regarding use, or the        **
--  **  results of the use, of the Materials in terms of correctness,        **
--  **  accuracy, reliability or otherwise.                                  **
--  **                                                                       **
--  **  Xilinx products are not designed or intended to be fail-safe,        **
--  **  or for use in any application requiring fail-safe performance,       **
--  **  such as life-support or safety devices or systems, Class III         **
--  **  medical devices, nuclear facilities, applications related to         **
--  **  the deployment of airbags, or any other applications that could      **
--  **  lead to death, personal injury or severe property or                 **
--  **  environmental damage (individually and collectively, "critical       **
--  **  applications"). Customer assumes the sole risk and liability         **
--  **  of any use of Xilinx products in critical applications,              **
--  **  subject only to applicable laws and regulations governing            **
--  **  limitations on product liability.                                    **
--  **                                                                       **
--  **  Copyright 2010 Xilinx, Inc.                                          **
--  **  All rights reserved.                                                 **
--  **                                                                       **
--  **  This disclaimer and copyright notice must be retained as part        **
--  **  of this file at all times.                                           **
--  ***************************************************************************
-------------------------------------------------------------------------------
-- Filename:        uart16550.vhd
-- Version:         v2.0
-- Description:     16550 compatable UART 
--
-- VHDL-Standard:   VHDL'93
--
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_cmb" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned."+";
use ieee.std_logic_unsigned."-";
use ieee.std_logic_unsigned.all;

-------------------------------------------------------------------------------
-- axi_uart16550_v2_0_22 library is used for axi_uart16550_v2_0_22 
-- component declarations
-------------------------------------------------------------------------------
library axi_uart16550_v2_0_22;
use axi_uart16550_v2_0_22.xuart_tx_load_sm;
use axi_uart16550_v2_0_22.rx16550;
use axi_uart16550_v2_0_22.tx16550;
use axi_uart16550_v2_0_22.tx_fifo_block;
use axi_uart16550_v2_0_22.rx_fifo_block;

-------------------------------------------------------------------------------
-- proc common package of the proc common library is used for different 
-- function declarations
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Vcomponents from unisim library is used for FIFO instatiation
-- function declarations
-------------------------------------------------------------------------------
library unisim;
use unisim.Vcomponents.all;

-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------
entity uart16550 is
  generic (
    C_IS_A_16550          : BOOLEAN  := FALSE; -- UART mode
    C_HAS_EXTERNAL_XIN    : BOOLEAN  := FALSE; -- External XIN  
    C_S_AXI_CLK_FREQ_HZ   : integer  := 100_000_000; -- AXI Clock Frequency
    C_EXTERNAL_XIN_CLK_HZ : integer  := 50_000_000;  -- XIN Clock Frequency
    C_FAMILY              : string   := "virtex7"; -- XILINX FPGA family
    C_SIM_DEVICE          : string   := "VERSAL_AI_CORE_ES1"); -- SIM DEVICE 
  port (
    Din           : in  std_logic_vector (7 downto 0);  -- data bus in
    Dout          : out std_logic_vector (7 downto 0);  -- data bus out
    Sout          : out std_logic;   -- serial output
    BaudoutN      : out std_logic;   -- baud clock output
    BaudoutN_int  : out std_logic;   -- baud internal clock 
    Intr          : out std_logic;   -- interrupt
    Ddis          : out std_logic;   -- driver disable
    TxrdyN        : out std_logic;   -- transmitter DMA signal (active low)
    RxrdyN        : out std_logic;   -- receiver DMA signal (active low)
    Xout          : out std_logic;   -- external crystal output (xin_n)
    RtsN          : out std_logic;   -- request to send (active low)
    DtrN          : out std_logic;   -- data terminal ready (active low)
    Out1N         : out std_logic;   -- user controlled output (active low)
    Out2N         : out std_logic;   -- user controlled output (active low)
    Addr          : in  std_logic_vector (2 downto 0) := "000";  -- address bus
    Cs0           : in  std_logic;   -- chip select 0 (active high)
    Cs1           : in  std_logic;   -- chip select 1 (active high)
    Cs2N          : in  std_logic;   -- chip select 2 (active low)
    AdsN          : in  std_logic;   -- address/chip select strobe (active low)
    Sin           : in  std_logic;   -- serial in
    Rclk          : in  std_logic;   -- receiver clock (16 x baud rate)
    Xin           : in  std_logic;   -- external crystal input
    Rd            : in  std_logic;   -- read strobe (active high)
    RdN           : in  std_logic;   -- read strobe (active low)
    Wr            : in  std_logic;   -- write strobe (active high)
    WrN           : in  std_logic;   -- write stobe (active low)
    Rst           : in  std_logic;   -- master reset, active high
    CtsN          : in  std_logic;   -- clear to send (active low)
    DcdN          : in  std_logic;   -- data carrier detect (active low)
    DsrN          : in  std_logic;   -- data set ready (active low)
    RiN           : in  std_logic;   -- ring indicator (active low)
    Freeze        : in  std_logic;   -- Freezes UART for software debug
    Sys_clk       : in  std_logic);  -- Device interrupt output to processor


end uart16550;

-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------
architecture implementation of uart16550 is
-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of implementation : architecture is "yes";


  -----------------------------------------------------------------------------
  -- Function: get_sel_baud
  -- Purpose: Get the baud reference clock to calculate the default baud rate. 
  -----------------------------------------------------------------------------
  function get_sel_baud return integer is
  variable sel_baud_clk : integer;
  begin

      if C_HAS_EXTERNAL_XIN = FALSE then 
         sel_baud_clk := C_S_AXI_CLK_FREQ_HZ;
      else
         sel_baud_clk := C_EXTERNAL_XIN_CLK_HZ;
      end if;
    
      return sel_baud_clk;
  end function get_sel_baud;

  constant BAUD_REF_CLOCK : integer := get_sel_baud;
  constant BAUD_DEFAULT   : integer := (BAUD_REF_CLOCK/(16 * 9600));
  constant BAUD_DEFAULT_X : std_logic_vector(15 downto 0)
                            := CONV_STD_LOGIC_VECTOR(BAUD_DEFAULT,16); 

  type  bo2sl_type is array(boolean) of std_logic;
  constant bo2sl          : bo2sl_type := (false => '0', true => '1');
 -- constant ODDR_IO        : boolean := supported(C_FAMILY, (u_ODDR));
 -- constant OSERDESE3_IO        : boolean := supported(C_FAMILY, (u_OSERDESE3));

-------------------------------------------------------------------------------
-- internal signals and registers
-------------------------------------------------------------------------------
  signal Rbr          : std_logic_vector (7 downto 0);  -- receiver buffer 
                                                        -- register
  signal Thr          : std_logic_vector (7 downto 0);  -- transmitter holding 
                                                       -- register(write only)
  signal Tsr          : std_logic_vector (7 downto 0);
  signal ier          : std_logic_vector (7 downto 0);  -- interrupt enable 
                                                        -- register
  signal iir          : std_logic_vector (7 downto 0);  -- interrupt 
                                                        -- identification reg
  signal thre_iir_set : std_logic;
  signal thre_iir_rst : std_logic;
  signal lsr5_d       : std_logic;
  signal ier1_d       : std_logic;
  signal Lcr          : std_logic_vector (7 downto 0); -- line control reg
  signal mcr          : std_logic_vector (7 downto 0); -- modem control reg
  signal mcr4_d       : std_logic;
  signal lsr          : std_logic_vector (7 downto 0); -- line status reg
  signal msr          : std_logic_vector (7 downto 0); -- modem status reg
  signal scr          : std_logic_vector (7 downto 0); -- scratch register
                                                       -- (user space)
  signal dll          : std_logic_vector (7 downto 0); -- divisor latch (least
                                                       -- significant byte)
  signal dlm          : std_logic_vector (7 downto 0); -- divisor latch 
                                                    -- (most significant byte)

  signal chipSelect           : std_logic;  -- Cs0 and Cs1 and (not Cs2N)
  signal readStrobe           : std_logic;  -- chipSelect and (Rd or (not RdN))
  signal writeStrobe          : std_logic;  -- chipSelect and (Wr or (not WrN))
  signal dlab                 : std_logic;  -- divisor latch access bit Lcr[7]
  signal addr_d               : std_logic_vector (2 downto 0);  
                                            -- internal address latch
  signal internalBus          : std_logic_vector (7 downto 0);  
                                            -- internal data bus
  signal baudCounter          : std_logic_vector (15 downto 0);  
                                            -- baud clock generator
  signal clockDiv             : std_logic_vector (15 downto 0);
  signal framing_error        : std_logic;  -- signals receiver framing error
  signal parity_error         : std_logic;
  signal data_ready           : std_logic;
  signal data_ready_interrupt : std_logic;  -- condition for a data
                                            -- ready interrupt
  signal break_interrupt      : std_logic;
  signal receiver_error       : std_logic;  -- any receiver error
  signal receiver_timeout     : std_logic;  -- receiver fifo timeout
  signal Thre                 : std_logic;  -- transmitter holding reg empty
  signal start_tx             : std_logic;  -- start transmission
  signal tx_empty             : std_logic;  -- transmitter empty
  signal Tsre                 : std_logic;  -- transmitter shift reg empty
  signal read_rbr             : std_logic;  -- high when reading Rbr
  signal writing_thr          : std_logic;  -- high when writing transmitter 
                                            -- holding register
  signal tsr_loaded           : std_logic;  -- signals Thr loaded into Tsr
  signal modem_prev_val       : std_logic_vector (3 downto 0);  
                                            -- holds last value of modem 
                                            -- control inputs
  signal modem_prev_rst_in    : std_logic_vector (3 downto 0);
  signal modem_status_changes : std_logic;  -- any change in modem input status
  signal tx_sout              : std_logic;  -- Sout from transmitter
  signal rx_sin               : std_logic;  -- Sin to receiver
  signal rx_rst               : std_logic;
  signal msr_rst              : std_logic;  -- resets msr
  signal lsr0_rst             : std_logic;  -- resets lsr(0)
  signal lsr5_rst             : std_logic;  -- resets lsr(5)
  signal lsr6_rst             : std_logic;  -- resets lsr(6)
  signal lsr7_rst             : std_logic;  -- resets lsr(7)
  signal lsr_rst              : std_logic;  -- resets rest of lsr
  signal lsr0_set             : std_logic;  -- sets lsr(0)
  signal lsr1_set             : std_logic;  -- sets lsr(1)
  signal lsr2_set             : std_logic;  -- sets lsr(2)
  signal lsr3_set             : std_logic;  -- sets lsr(3)
  signal lsr4_set             : std_logic;  -- sets lsr(4)
  signal lsr5_set             : std_logic;  -- sets lsr(5)
  signal lsr6_set             : std_logic;  -- sets lsr(6)
  signal lsr7_set             : std_logic;  -- sets lsr(7)
  signal iir_rst              : std_logic;  -- resets  iir

  signal rbr_sel              : std_logic;  -- selects rbr
  signal thr_sel              : std_logic;  -- selects Thr
  signal ier_sel              : std_logic;  -- selects ier
  signal iir_sel              : std_logic;  -- selects iir (read only)
  signal lcr_sel              : std_logic;  -- selects Lcr
  signal mcr_sel              : std_logic;  -- selects mcr
  signal lsr_sel              : std_logic;  -- selects lsr
  signal msr_sel              : std_logic;  -- selects msr
  signal scr_sel              : std_logic;  -- selects scr
  signal dll_sel              : std_logic;  -- selects dll
  signal dlm_sel              : std_logic;  -- selects dlm
  signal character_received   : std_logic;
  signal rxrdyN_int           : std_logic;
  signal txrdyN_int           : std_logic;
  signal rd_d                 : std_logic;
  signal rdN_d                : std_logic;
  signal wr_d                 : std_logic;
  signal wrN_d                : std_logic;
  signal ctsN_d               : std_logic;  -- clear to send (active low)
  signal dcdN_d               : std_logic;  -- data carrier detect (active low)
  signal dsrN_d               : std_logic;  -- data set ready (active low)
  signal riN_d                : std_logic;
  signal d_d                  : std_logic_vector(7 downto 0);
  signal load_baudlower       : std_logic;
  signal load_baudupper       : std_logic;
  signal divisor_latch_loaded : std_logic;
  signal baud_counter_loaded  : std_logic;
  signal baudoutN_int_i       : std_logic;
  signal baud_divisor_is_1    : std_logic;
  signal sys_clk_n            : std_logic;
  signal baud_int             : std_logic;
  signal baud_d0              : std_logic;
  signal baud_d1              : std_logic;
  


  -----------------------------------------------------------------------------
  -- these signals will synthesize away when C_IS_A_16550 = FALSE
  -----------------------------------------------------------------------------
  -- fifo related signals
  signal fifo_mode1 : std_logic;
  signal fcr        : std_logic_vector (7 downto 0);  -- fifo control register
  signal fcr_0_prev : std_logic;  -- register to hold previous value of fcr(0)
  signal fcr_w_sel  : std_logic;  -- selects fcr (write only)
  signal fcr_r_sel  : std_logic;  -- selcts fcr (read only, not in the spec)

  -- transmitter fifo signals
  signal tx_fifo_data_out  : std_logic_vector(7 downto 0 );
  signal tx_fifo_rd_en_int : std_logic;
  signal tx_fifo_full      : std_logic;
  signal tx_fifo_empty     : std_logic;

  -- receiver fifo signals
  signal rx_fifo_timeout      : std_logic;
  signal rx_fifo_trigger      : std_logic;
  signal rx_fifo_data_out     : std_logic_vector(10 downto 0 );
  signal rx_fifo_data_in      : std_logic_vector(10 downto 0 );
  signal rx_fifo_empty        : std_logic;
  signal rx_fifo_overrun      : std_logic;
  signal rx_error_in_fifo     : std_logic;
  signal rx_error_in_fifo_cnt : std_logic_vector(3 downto 0);
  signal rx_error_in_fifo_int : std_logic;
  signal rx_fifo_full         : std_logic;
  signal rx_fifo_rd_en        : std_logic;
  signal rx_fifo_rd_en_d      : std_logic;
  signal have_bi_in_fifo_n    : std_logic;
  signal rx_fifo_rd_en_d1     : std_logic;
  signal lsr2_rst             : std_logic;

  signal rx_error_in_fifo_lst : std_logic;
  signal rx_error_out_fifo    : std_logic;

begin  -- implementation

-------------------------------------------------------------------------------
-- NOTE: ANY LOGIC RELATED TO 16550 FUNCTIONALITY WILL SYNTHESIZE OR GENERATE
-- AWAY WHEN C_IS_A_16550 = FALSE
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- misc. combinational output signals
-------------------------------------------------------------------------------
  Xout <= not Xin;                      -- external crystal output (xin_n),
                                        -- duplicated in xuart.vhd to create a
                                        -- standalone uart

  DtrN  <= (not mcr(0)) or mcr(4);      -- data terminal ready
  RtsN  <= (not mcr(1)) or mcr(4);      -- request to send
  Out1N <= (not mcr(2)) or mcr(4);      -- user output 1
  Out2N <= (not mcr(3)) or mcr(4);      -- user output 2

-------------------------------------------------------------------------------
-- Sin/Sout loop back
-------------------------------------------------------------------------------  
  Sout     <= (tx_sout or mcr(4)) and (not Lcr(6));
  rx_sin   <= (((Sin and (not mcr(4))) or (tx_sout and mcr(4))) or Freeze);

-------------------------------------------------------------------------------
-- TxrdyN and RxrdyN
-------------------------------------------------------------------------------
  RxrdyN <= rxrdyN_int;
  TxrdyN <= txrdyN_int;

-------------------------------------------------------------------------------
-- PROCESS: RXRDYN_PROCESS
-- purpose: generarte RxrdyN
-------------------------------------------------------------------------------
  RXRDYN_PROCESS : process (Sys_clk) is
  begin  -- process RXRDYN_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                  -- synchronous reset (active high)
        rxrdyN_int <= '1';
      elsif fifo_mode1 = '1' then
        rxrdyN_int <= (((not rxrdyN_int) and (not lsr(0))) or
                       (rxrdyN_int and ((not rx_fifo_timeout) and
                                        (not rx_fifo_trigger))));
      else
        rxrdyN_int <= not lsr(0);
      end if;
    end if;
  end process RXRDYN_PROCESS;

-------------------------------------------------------------------------------
-- PROCESS: TXRDYN_PROCESS
-- purpose: generarte TxrdyN
-------------------------------------------------------------------------------
  TXRDYN_PROCESS : process (Sys_clk) is
  begin  -- process RXRDYN_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        txrdyN_int <= '0';
      elsif fifo_mode1 = '1' then
        txrdyN_int <= (((not txrdyN_int) and tx_fifo_full) or
                       (txrdyN_int and (not lsr(5))));
      else
        txrdyN_int <= not lsr(5);
      end if;
    end if;
  end process TXRDYN_PROCESS;

-------------------------------------------------------------------------------
-- PROCESS: INTR_PROCESS
-- purpose: Interrupt output generation
-------------------------------------------------------------------------------
  INTR_PROCESS : process (Sys_clk) is
  begin  -- process INTR_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        Intr <= '0';
      else
        Intr <= (not iir(0)) and (not Freeze);
      end if;
    end if;
  end process INTR_PROCESS;

-------------------------------------------------------------------------------
-- PROCESS: REGISTER_RW_PROCESS
-- purpose: register inputs
-------------------------------------------------------------------------------
  REGISTER_RW_PROCESS : process (Sys_clk) is
  begin
    if Sys_clk'EVENT and Sys_clk = '1' then
      rd_d  <= Rd;
      rdN_d <= RdN;
      wr_d  <= Wr;
      wrN_d <= WrN;
      d_d   <= Din;
      Ddis  <= not readStrobe;    --  driver disable
    end if;
  end process REGISTER_RW_PROCESS;

-------------------------------------------------------------------------------
-- PROCESS: REGISTER_RW_PROCESS
-- purpose: registers modem inputs
-------------------------------------------------------------------------------
  REGISTER_MODEM_INPUTS : process (Sys_clk) is
  begin  -- process REGISTER_MODEM_INPUTS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      ctsN_d <= CtsN;
      dcdN_d <= DcdN;
      dsrN_d <= DsrN;
      riN_d  <= RiN;
    end if;
  end process REGISTER_MODEM_INPUTS;

-------------------------------------------------------------------------------  
-- PROCESS: LATCH_ADDRESS
-- purpose: latch address and chip selects
-------------------------------------------------------------------------------
  LATCH_ADDRESS : process (Sys_clk) is
  begin  -- process latchAddress
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        addr_d     <= "000";
        chipSelect <= '0';
      elsif AdsN = '0' then
        addr_d     <= Addr;
        chipSelect <= Cs0 and Cs1 and (not Cs2N);
      end if;
    end if;
  end process LATCH_ADDRESS;


                                        -- create readStrobe signal
  readStrobe <= chipSelect and (rd_d or (not rdN_d));

                                        -- create writeStrobe signal
  writeStrobe <= chipSelect and (wr_d or (not wrN_d));

  internalBus <= d_d;

-------------------------------------------------------------------------------
-- address decoder
-------------------------------------------------------------------------------

  rbr_sel   <= bo2sl( dlab & addr_d = "0000" ); -- Receiver Buffer Reg    (R)
  thr_sel   <= rbr_sel;                         -- Transmiter Holding Reg (W)
  ier_sel   <= bo2sl( dlab & addr_d = "0001" ); -- Interrupt Enable Reg   (RW)
  iir_sel   <= bo2sl( dlab & addr_d = "0010" ); -- Intr Identification Reg(R)
  fcr_r_sel <= bo2sl( dlab & addr_d = "1010" ); -- FIFO Control Reg (R)
  fcr_w_sel <= bo2sl(        addr_d =  "010" ); -- FIFO Control Reg (W)
  lcr_sel   <= bo2sl(        addr_d =  "011" ); -- Line Control Reg (RW)
  mcr_sel   <= bo2sl(        addr_d =  "100" ); -- Modem Control Reg (RW)
  lsr_sel   <= bo2sl(        addr_d =  "101" ); -- Line Status Reg (RW)
  msr_sel   <= bo2sl(        addr_d =  "110" ); -- Modem status Reg (RW)
  scr_sel   <= bo2sl(        addr_d =  "111" ); -- Scratch Reg (RW)
  dll_sel   <= bo2sl( dlab & addr_d = "1000" ); -- Divisor Latch Reg L (RW)
  dlm_sel   <= bo2sl( dlab & addr_d = "1001" ); -- Divisor Latch Reg M (RW)

-------------------------------------------------------------------------------
-- read internal registers
-------------------------------------------------------------------------------

  read_rbr <= '1' when (readStrobe = '1' and rbr_sel = '1') else '0';

-------------------------------------------------------------------------------  
-- PROCESS: READ_REGISTERS
-- purpose: latch address and chip selects
-------------------------------------------------------------------------------
  READ_REGISTERS : process (Sys_clk) is
  begin  -- process readRegisters
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        Dout <= "00000000";
      elsif readStrobe = '1' then
        if rbr_sel = '1' then
          if fcr(0) = '1' then
            Dout <= rx_fifo_data_out(7 downto 0);
          else
            Dout <= Rbr;
          end if;
        elsif ier_sel = '1' then
          Dout <= ier;
        elsif iir_sel = '1' then
          Dout <= iir;
        elsif fcr_r_sel = '1' then
          Dout <= fcr;
        elsif lcr_sel = '1' then
          Dout <= Lcr;
        elsif mcr_sel = '1' then
          Dout <= mcr;
        elsif lsr_sel = '1' then
          Dout <= lsr;
        elsif msr_sel = '1' then
          Dout <= msr;
        elsif scr_sel = '1' then
          Dout <= scr;
        elsif dll_sel = '1' then
          Dout <= dll;
        elsif dlm_sel = '1' then
          Dout <= dlm;
        -- coverage off
        else
          Dout <= (others => '0');
        -- coverage on  
        end if;
      end if;
    end if;
  end process READ_REGISTERS;

-------------------------------------------------------------------------------  
-- PROCESS: THR_WRITE
-- purpose: write Thr register
-------------------------------------------------------------------------------
  THR_WRITE : process (Sys_clk) is
  begin  -- process thrWrite
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        Thr             <= (others => '1');
        writing_thr     <= '0';
      elsif writeStrobe = '1' and thr_sel = '1' then
        Thr         <= internalBus;
        writing_thr <= '1';
      else
        writing_thr <= '0';
      end if;
    end if;
  end process THR_WRITE;

  xuart_tx_load_sm_1 : entity axi_uart16550_v2_0_22.xuart_tx_load_sm
    port map (
      Rst       => Rst,
      Sys_clk   => Sys_clk,
      Thr       => Thr,
      Write_thr => writing_thr,
      Load_tx   => tsr_loaded,
      Tsr       => Tsr,
      Thre      => Thre,
      Tsre      => Tsre);

-------------------------------------------------------------------------------  
-- PROCESS: IER_WRITE
-- purpose: write ier register
-------------------------------------------------------------------------------
  IER_WRITE : process (Sys_clk) is
  begin  -- process ierWrite
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        ier(3 downto 0) <= (others => '0');
      elsif writeStrobe = '1' and ier_sel = '1' then
        ier (3 downto 0)<= internalBus(3 downto 0);
      end if;
    end if;
  end process IER_WRITE;

        ier (7 downto 4)<= "0000"; 

-------------------------------------------------------------------------------  
-- PROCESS: DELAY_LSR5_AND_IER1_PROC
-- purpose: delay LSR5 bit
-------------------------------------------------------------------------------
  DELAY_LSR5_AND_IER1_PROC : process (Sys_clk) is
  begin  -- process DELAY_LSR5_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      lsr5_d <= lsr(5);
      ier1_d <= ier(1);
    end if;
  end process DELAY_LSR5_AND_IER1_PROC;


-------------------------------------------------------------------------------  
-- PROCESS: IER_WRITE
-- purpose: set THRE and IIR registers
-------------------------------------------------------------------------------
  SET_THRE_IIR_PROCESS : process (Sys_clk) is
  begin
    if Sys_clk'EVENT and Sys_clk = '1' then
      if thre_iir_rst = '1' then
        thre_iir_set <= '0';
      elsif Rst = '1' or
           (lsr5_d = '0' and lsr(5) = '1') or
           (lsr(5) = '1' and iir_rst = '1') or
           (ier(1) = '1' and ier1_d = '0' and lsr(5) = '1') then
        thre_iir_set <= '1';
      end if;
    end if;
  end process SET_THRE_IIR_PROCESS;

  -- THRE reset
  thre_iir_rst <= '1' when ((readStrobe = '1' and iir_sel = '1' and 
                         iir(3 downto 0) = "0010") or writing_thr = '1') else 
                  '0';

  -- Receiver Error
  receiver_error       <= '1' when (lsr(1) = '1' or lsr(2) = '1' or 
                                    lsr(3) = '1' or lsr(4) = '1') else '0';
                                    
  -- Modem status change
  modem_status_changes <= '1' when (msr(0) = '1' or msr(1) = '1' or 
                                    msr(2) = '1' or msr(3) = '1') else '0';
                                    

  -- IIR reset
  iir_rst <= '1' when ((lsr_rst = '1' and iir(3 downto 0) = "0110") or
                       (fcr(0) = '0'  and read_rbr = '1' and 
                                          iir(3 downto 0) = "0100") or 
                       (fcr(0) = '1'  and read_rbr = '1' and 
                                          iir(3 downto 0) = "1100") or
                       (fcr(0) = '1'  and rx_fifo_trigger = '0' and 
                                          iir(3 downto 0) = "0100") or 
                       --thre_iir_rst = '1' or
                       (readStrobe = '1' and msr_sel = '1' 
                                         and iir(3 downto 0) = "0000"))
             else '0';

  -- Data ready interrupt generation
  data_ready_interrupt <= '1' when ((fcr(0) = '0' and lsr(0) = '1') or 
                                    (fcr(0) = '1' and rx_fifo_trigger = '1'))
             else '0';


-------------------------------------------------------------------------------  
-- PROCESS: IIR_WRITE
-- purpose: write iir register (iir is read only)
-------------------------------------------------------------------------------
  IIR_WRITE : process (Sys_clk) is
  begin
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or iir_rst = '1' then
        iir(3 downto 0) <= "0001";
      elsif ier(2) = '1' and receiver_error = '1' then
        iir(3 downto 0) <= "0110";
      elsif ier(0) = '1' and receiver_timeout = '1' then
        iir(3 downto 0) <= "1100";
      elsif ier(0) = '1' and data_ready_interrupt = '1' then
        iir(3 downto 0) <= "0100";
      elsif ier(1) = '1' and thre_iir_set = '1' then
        iir(3 downto 0) <= "0010";
      elsif ier(3) = '1' and modem_status_changes = '1' then
        iir(3 downto 0) <= "0000";
      else
        iir(3 downto 0) <= "0001";
      end if;
      iir(7 downto 6) <= fcr(0) & fcr(0);  -- always 1 when fcr(0) is set
      iir(5 downto 4) <= "00";             -- always 0
    end if;
  end process IIR_WRITE;


-------------------------------------------------------------------------------  
-- PROCESS: LCR_WRITE
-- purpose: write Lcr register
-------------------------------------------------------------------------------
  LCR_WRITE : process (Sys_clk) is
  begin  -- process lcrWrite
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        Lcr  <= "00000011";
        dlab <= '0';
      elsif writeStrobe = '1' and lcr_sel = '1' then
        Lcr  <= internalBus;
      else
        dlab <= Lcr(7);
      end if;
    end if;
  end process LCR_WRITE;

-------------------------------------------------------------------------------  
-- PROCESS: MCR_WRITE
-- purpose: write mcr register
-------------------------------------------------------------------------------
  MCR_WRITE : process (Sys_clk) is
  begin  -- process mcrWrite
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        mcr <= (others => '0');
      elsif writeStrobe = '1' and mcr_sel = '1' then
        mcr <= "000" & internalBus(4 downto 0);
      end if;
    end if;
  end process MCR_WRITE;

-------------------------------------------------------------------------------  
-- PROCESS: IER_WRITE
-- purpose: delay mcr register
-------------------------------------------------------------------------------
  MCR4_DELAY_PROC: process (Sys_clk) is
  begin  -- process MCR4_DELAY_PROC
    if Sys_clk'event and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                  -- synchronous reset (active high)
        mcr4_d <= '0';
      else
        mcr4_d <= mcr(4);
      end if;
    end if;
  end process MCR4_DELAY_PROC;


  -- LSR bit resets
  lsr0_rst <= '1' when ((fcr(0) = '0' and read_rbr = '1') or (fcr(0) = '1' and 
                         rx_fifo_empty = '1')) else '0';

  -- THRE reset
  lsr5_rst <= '1' when ((fcr(0) = '0' and Thre = '0') or (fcr(0) = '1' and
                         tx_fifo_empty = '0')) else '0';
                         
  -- Transmitter empty reset
  lsr6_rst <= '1' when ((fcr(0) = '1' and tsr_loaded = '1') or 
                        (fcr(0) = '0' and (Thre = '0' or Tsre = '0')) or
                         lsr(5) = '0') else '0';
                         
  -- Error in receive FIFO reset
  lsr7_rst <= '1' when ((fcr(0) = '1' and (lsr_rst = '1' or 
                                           rx_error_in_fifo_int = '0')) or 
                         fcr(0) = '0') else '0';
                         
  -- LSR reset
  lsr_rst  <= '1' when (readStrobe = '1' and lsr_sel = '1') else '0';


  -- LSR bit set
  -- Data ready set
  lsr0_set <= '1' when ((fcr(0) = '0' and data_ready = '1') or 
                        (fcr(0) = '1' and rx_fifo_empty = '0')) else '0';
                        
  -- Overrun error set
  lsr1_set <= '1' when ((fcr(0) = '0' and data_ready_interrupt = '1' and 
                         data_ready = '1') or rx_fifo_overrun = '1') else '0';
                         
  -- THRE empty set
  lsr5_set <= '1' when ((fcr(0) = '0' and Thre = '1') or 
                        (fcr(0) = '1' and tx_fifo_empty = '1')) else '0';
                        
  -- Transmitter empty set
  lsr6_set <= '1' when ((fcr(0) = '1' and tx_empty = '1' and lsr(5) = '1') or 
                        (fcr(0) = '0' and Tsre = '1' and Thre = '1')) else '0';
                        
  -- Error in Receive FIFO set
  lsr7_set <= '1' when (fcr(0) = '1' and rx_error_in_fifo_int = '1' and 
                        lsr_rst = '0') else '0';

  -- Modified for CR:440029
  -- LSR register is set as soon as error is detected in the received data when
  -- the data is available at the top of the FIFO. Doesn't wait for the data to
  -- read from the FIFO.
  lsr2_set <= '1' when (Lcr(3) = '1' and ((fcr(0) = '0' and parity_error = '1')  
                    or (fcr(0) = '1' and rx_fifo_data_out(10) = '1' and 
                        rx_fifo_empty = '0' and (rx_fifo_rd_en_d = '0' and 
                        rx_fifo_rd_en_d1 = '0' ) ))) else '0';

  
  -- Framing error set
  lsr3_set <= '1' when ((fcr(0) = '0' and framing_error = '1') or 
                        (fcr(0) = '1' and rx_fifo_data_out(9) = '1' and 
                         rx_fifo_empty = '0' and (rx_fifo_rd_en_d = '0' and 
                         rx_fifo_rd_en_d1 = '0' ))) else '0';

  -- Break Interrupt set
  lsr4_set <= '1' when ((fcr(0) = '0' and break_interrupt = '1') or 
                        (fcr(0) = '1' and rx_fifo_data_out(8) = '1' and 
                         rx_fifo_empty = '0' and (rx_fifo_rd_en_d = '0' and 
                         rx_fifo_rd_en_d1 = '0' ))) else '0';

-------------------------------------------------------------------------------  
-- PROCESS: LSR2_RST_GEN
-- purpose: Generated lsr2_rst for reseting parity error flag in the LSR
-- Modified for CR:481176
-------------------------------------------------------------------------------
  LSR2_RST_GEN : process (Sys_clk) is
  begin  -- process lsr2 reset gen
  
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        lsr2_rst <= '0';
      elsif lsr_rst = '1' and rx_fifo_empty = '0' then
        lsr2_rst <= '1';
      elsif rx_fifo_rd_en_d = '1' or writeStrobe = '1'  then
        lsr2_rst <= '0';
      end if;
    end if;
  end process LSR2_RST_GEN;

-------------------------------------------------------------------------------  
-- PROCESS: LSR_WRITE
-- purpose: write lsr register
-------------------------------------------------------------------------------
  LSR_WRITE : process (Sys_clk) is
  begin  -- process lsrWrite

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or lsr0_rst = '1' then
        lsr(0) <= '0';
      elsif lsr0_set = '1' then
        lsr(0) <= '1';
      elsif writeStrobe = '1' and lsr_sel = '1' then
        lsr(0) <= internalBus(0);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or lsr_rst = '1' then
        lsr(1) <= '0';
      elsif lsr1_set = '1' then
        lsr(1) <= '1';
      elsif writeStrobe = '1' and lsr_sel = '1' then
        lsr(1) <= internalBus(1);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or lsr_rst = '1' or lsr2_rst='1' then
        lsr(2) <= '0';
      elsif lsr2_set = '1' then
        lsr(2) <= '1';
      elsif writeStrobe = '1' and lsr_sel = '1' then
        lsr(2) <= internalBus(2);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or lsr_rst = '1' or lsr2_rst='1' then
        lsr(3) <= '0';
      elsif lsr3_set = '1' then
        lsr(3) <= '1';
      elsif writeStrobe = '1' and lsr_sel = '1' then
        lsr(3) <= internalBus(3);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or lsr_rst = '1' or lsr2_rst='1' then
        lsr(4) <= '0';
      elsif lsr4_set = '1' then
        lsr(4) <= '1';
      elsif writeStrobe = '1' and lsr_sel = '1' then
        lsr(4) <= internalBus(4);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if lsr5_rst = '1' then
        lsr(5) <= '0';
      elsif Rst = '1' or lsr5_set = '1' then
        lsr(5) <= '1';
      --elsif writeStrobe = '1' and lsr_sel = '1' then  --Since these lines won't be covering 
      --lsr(5) <= internalBus(5);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if lsr6_rst = '1' then
        lsr(6) <= '0';
      elsif Rst = '1' or lsr6_set = '1' then
        lsr(6) <= '1';
      elsif writeStrobe = '1' and lsr_sel = '1' then
        lsr(6) <= internalBus(6);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or lsr7_rst = '1' then
        lsr(7) <= '0';
      elsif lsr7_set = '1' then
        lsr(7) <= '1';
     -- elsif writeStrobe = '1' and lsr_sel = '1' then --since these lines won't be covereing
     --   lsr(7) <= internalBus(7);
      end if;
    end if;
  end process LSR_WRITE;

  -- Modem status register reset
  msr_rst <= '1' when (readStrobe = '1' and msr_sel = '1') else '0';

-------------------------------------------------------------------------------  
-- PROCESS: MSR_WRITE
-- purpose: write msr register
-------------------------------------------------------------------------------
  MSR_WRITE : process (Sys_clk) is
  begin  -- process msrWrite
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or msr_rst = '1' then
        msr(0) <= '0';
      elsif msr(0) = '0' and (modem_prev_val(0) /= msr(4)) then
        msr(0) <= '1';
      elsif writeStrobe = '1' and msr_sel = '1' then
        msr(0) <= internalBus(0);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or msr_rst = '1' then
        msr(1) <= '0';
      elsif msr(1) = '0' and (modem_prev_val(1) /= msr(5)) then
        msr(1) <= '1';
      elsif writeStrobe = '1' and msr_sel = '1' then
        msr(1) <= internalBus(1);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or msr_rst = '1' then
        msr(2) <= '0';
      elsif msr(2) = '0' and (modem_prev_val(2) /= msr(6)) then
        msr(2) <= '1';
      elsif writeStrobe = '1' and msr_sel = '1' then
        msr(2) <= internalBus(2);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or msr_rst = '1' then
        msr(3) <= '0';
      elsif msr(3) = '0' and (modem_prev_val(3) /= msr(7)) then
        msr(3) <= '1';
      elsif writeStrobe = '1' and msr_sel = '1' then
        msr(3) <= internalBus(3);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        msr(4) <= not ctsN_d;
      elsif writeStrobe = '1' and msr_sel = '1' then
        msr(4) <= internalBus(4);
      elsif mcr(4) = '1' then
        msr(4) <= mcr(1);
      else
        msr(4) <= not ctsN_d;
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        msr(5) <= not dsrN_d;
      elsif writeStrobe = '1' and msr_sel = '1' then
        msr(5) <= internalBus(5);
      elsif mcr(4) = '1' then
        msr(5) <= mcr(0);
      else
        msr(5) <= not dsrN_d;
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        msr(6) <= not riN_d;
      elsif writeStrobe = '1' and msr_sel = '1' then
        msr(6) <= internalBus(5);
      elsif mcr(4) = '1' then
        msr(6) <= mcr(2);
      else
        msr(6) <= not riN_d;
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        msr(7) <= not dcdN_d;
      elsif writeStrobe = '1' and msr_sel = '1' then
        msr(7) <= internalBus(5);
      elsif mcr(4) = '1' then
        msr(7) <= mcr(3);
      else
        msr(7) <= not dcdN_d;
      end if;
    end if;
  end process MSR_WRITE;

  modem_prev_rst_in(0) <= not ctsN_d;
  modem_prev_rst_in(1) <= not dsrN_d;
  modem_prev_rst_in(2) <= not riN_d;
  modem_prev_rst_in(3) <= not dcdN_d;


-------------------------------------------------------------------------------  
-- PROCESS: MODEM_PREV_VAL_PROC
-- purpose: loads previous value of modem control signals
-------------------------------------------------------------------------------
  MODEM_PREV_VAL_PROC : process (Sys_clk) is
  begin  -- process MSR_PREV_VAL_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then         -- asynchronous reset (active high)
        modem_prev_val <= modem_prev_rst_in(3 downto 0);
      elsif msr_rst = '1' then
        modem_prev_val <= msr(7 downto 4);
      end if;
    end if;
  end process MODEM_PREV_VAL_PROC;

-------------------------------------------------------------------------------  
-- PROCESS: SCR_WRITE
-- purpose: write scr register
-------------------------------------------------------------------------------
  SCR_WRITE : process (Sys_clk) is
  begin  -- process scrWrite
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        scr <= "00000000";
      elsif writeStrobe = '1' and scr_sel = '1' then
        scr <= internalBus;
      end if;
    end if;
  end process SCR_WRITE;

-------------------------------------------------------------------------------  
-- PROCESS: DLL_WRITE
-- purpose: write dll register
-------------------------------------------------------------------------------
  DLL_WRITE : process (Sys_clk) is
  begin  -- process dllWrite
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        --dll <= "00000000";
        dll <= BAUD_DEFAULT_X(7 downto 0);
      elsif writeStrobe = '1' and dll_sel = '1' then
        dll <= internalBus;
      end if;
    end if;
  end process DLL_WRITE;

-------------------------------------------------------------------------------  
-- PROCESS: DLM_WRITE
-- purpose: write dlm register
-------------------------------------------------------------------------------
  DLM_WRITE : process (Sys_clk) is
  begin  -- process dlmWrite
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        --dlm <= "00000000";
        dlm <= BAUD_DEFAULT_X(15 downto 8);
      elsif writeStrobe = '1' and dlm_sel = '1' then
        dlm <= internalBus;
      end if;
    end if;
  end process DLM_WRITE;


-------------------------------------------------------------------------------  
-- PROCESS: LOAD_BAUDCOUNTER_CONTROLS
-- purpose: load baud counter
-------------------------------------------------------------------------------
  LOAD_BAUDCOUNTER_CONTROLS : process (Sys_clk) is
  begin  -- process LOAD_BAUDCOUNTER_CONTROLS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      load_baudlower <= (writeStrobe and dll_sel);
      load_baudupper <= (writeStrobe and dlm_sel);
    end if;
  end process LOAD_BAUDCOUNTER_CONTROLS;

-------------------------------------------------------------------------------  
-- PROCESS: DIVISOR_LATCH_LOADED_PROC
-- purpose: flags if dll or dlm have been loaded
-------------------------------------------------------------------------------
  DIVISOR_LATCH_LOADED_PROC : process (Sys_clk) is
  begin  -- process DIVISOR_LATCH_LOADED_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then        -- rising clock edge
      if Rst = '1' or baud_counter_loaded = '1' then  -- asynchronous reset 
        divisor_latch_loaded <= '0';                 -- (active high)
      elsif load_baudlower = '1' or load_baudupper = '1' then
        divisor_latch_loaded <= '1';
      end if;
    end if;
  end process DIVISOR_LATCH_LOADED_PROC;



  clockDiv <= dlm & dll;

-------------------------------------------------------------------------------  
-- PROCESS: BAUD_COUNT
-- purpose: counts the baud sample based on the value from DLL and DLM
-------------------------------------------------------------------------------
  BAUD_COUNT : process (Sys_clk) is
  begin  -- process baudCount
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then         -- asynchronous reset (active high)
        --baudCounter         <= "0000000000000000";
        baudCounter         <= clockDiv;
        baud_counter_loaded <= '0';
      elsif Xin = '1' then
        if baudCounter = "0000000000000001" or divisor_latch_loaded = '1' then
          baudCounter         <= clockDiv;
          baud_counter_loaded <= '1';
        else
          baudCounter         <= baudCounter - "0000000000000001";
          baud_counter_loaded <= '0';
        end if;
      end if;
    end if;
  end process BAUD_COUNT;

-------------------------------------------------------------------------------  
-- PROCESS: BAUDRATE_GENERATOR
-- purpose: generate BaudoutN clock
-------------------------------------------------------------------------------
  BAUDRATE_GENERATOR : process (Sys_clk) is
  begin  -- process baudRateGenerator
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if (Xin = '1' and baudCounter = "0000000000000001") then
        baudoutN_int_i <= '0';
      else
        baudoutN_int_i <= '1';
      end if;
    end if;
  end process BAUDRATE_GENERATOR;

  -- Check if baud divisor value is '1'
  baud_divisor_is_1 <= '1' when clockDiv = "0000000000000001" else
                       '0';

  -- Generating inverted clock
  sys_clk_n <= not Sys_clk;

-------------------------------------------------------------------------------
-- NO_EXTERNAL_XIN : External XIN is not present.
-- Added for Baud generator to accept value 0x01 as a devisor
-- For Divisor value = 1, BaudoutN_int is same as sys_clk.
-------------------------------------------------------------------------------
  NO_EXTERNAL_XIN : if C_HAS_EXTERNAL_XIN /= TRUE generate

     baud_int  <= '0' when baud_divisor_is_1 = '1' else
                  baudoutN_int_i;

-------------------------------------------------------------------------------  
-- PROCESS: BAUD Divisor=1 check 
-- purpose: Check if baud divisor value is '1'
-------------------------------------------------------------------------------
--  BAUD_DIVISOR : process (Sys_clk) is
--  begin  -- process baudRateGenerator
--    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
--      baud_d0 <= baudoutN_int_i and not baud_divisor_is_1;
--      baud_d1 <= baudoutN_int_i or baud_divisor_is_1;
--    end if;
--  end process BAUD_DIVISOR;

     -- BaoudoutN Logic
     baud_d0 <= baudoutN_int_i and not baud_divisor_is_1;
     baud_d1 <= baudoutN_int_i or baud_divisor_is_1;

      --Generate BaudoutN using ODDR
   --         ODDR_GEN : if ODDR_IO = TRUE generate

   --          BAUD_FF: ODDR
   --            port map (
   --              Q   => BaudoutN,      --[out]
   --              C   => Sys_clk,       --[in]
   --              CE  => '1',           --[in]
   --              D1  => baud_d0,       --[in]
   --              D2  => baud_d1,       --[in]
   --              S   => '0',           --[in]
   --              R   => Rst);          --[in]

   --      end generate ODDR_GEN;
         

    --Generate BaudoutN using ODDR2
        ODDR2_GEN : if ( 
            (C_FAMILY = "virtex7") or
            (C_FAMILY = "kintex7") or
            (C_FAMILY = "spartan7") or
            (C_FAMILY = "zynq") or
            (C_FAMILY = "artix7")  
           ) generate

                  BAUD_FF: ODDR
                    port map (
                      Q   => BaudoutN,      --[out]
                      C   => Sys_clk,       --[in]
                      CE  => '1',           --[in]
                      D1  => baud_d0,       --[in]
                      D2  => baud_d1,       --[in]
                      S   => '0',           --[in]
                      R   => Rst);          --[in]

        end generate ODDR2_GEN;

        OSERDESE3_ODDR_GEN : if (
            (C_FAMILY /= "virtex7") and
            (C_FAMILY /= "kintex7") and
            (C_FAMILY /= "spartan7") and
            (C_FAMILY /= "zynq") and
            (C_FAMILY /= "artix7")  
           ) generate
             -- CR-1018192
             -- updated to pass sim_device parmeter value whenever the part family is versal because versal architecture is different from previous device families (ultrascale and before ultrascale)
               OSERDESE3_ODDR_GEN_VERSAL : if (
                   (C_FAMILY = "versal"    ) 
                  ) generate 

                        BAUD_FF: ODDRE1
                          generic map (
                           SIM_DEVICE => C_SIM_DEVICE
                           )
                          port map (
                            Q   => BaudoutN ,       --[out]
                            C   => Sys_clk  ,       --[in]
                            D1  => baud_d0  ,       --[in]
                            D2  => baud_d1  ,       --[in]
                            SR   => Rst    );       --[in]

                end generate OSERDESE3_ODDR_GEN_VERSAL;

               OSERDESE3_ODDR_GEN_VERSAL_ES1 : if ( 
                   (C_FAMILY = "versal_es1")
                  ) generate 

                        BAUD_FF: ODDRE1
                          generic map (
                           SIM_DEVICE => C_SIM_DEVICE
                           )
                          port map (
                            Q   => BaudoutN ,       --[out]
                            C   => Sys_clk  ,       --[in]
                            D1  => baud_d0  ,       --[in]
                            D2  => baud_d1  ,       --[in]
                            SR   => Rst    );       --[in]

                end generate OSERDESE3_ODDR_GEN_VERSAL_ES1;

               OSERDESE3_ODDR_GEN_VERSAL_ES2 : if (
                   (C_FAMILY = "versal_es2")
                  ) generate 

                        BAUD_FF: ODDRE1
                          generic map (
                           SIM_DEVICE => C_SIM_DEVICE
                           )
                          port map (
                            Q   => BaudoutN ,       --[out]
                            C   => Sys_clk  ,       --[in]
                            D1  => baud_d0  ,       --[in]
                            D2  => baud_d1  ,       --[in]
                            SR   => Rst    );       --[in]

                end generate OSERDESE3_ODDR_GEN_VERSAL_ES2;

 
               OSERDESE3_ODDR_GEN_NOT_VERSAL : if (
                   (C_FAMILY /= "versal"    ) and 
                   (C_FAMILY /= "versal_es1") and 
                   (C_FAMILY /= "versal_es2")
                  ) generate 

                        BAUD_FF: ODDRE1
                          port map (
                            Q   => BaudoutN ,       --[out]
                            C   => Sys_clk  ,       --[in]
                            D1  => baud_d0  ,       --[in]
                            D2  => baud_d1  ,       --[in]
                            SR   => Rst    );       --[in]

                end generate OSERDESE3_ODDR_GEN_NOT_VERSAL;
     --             BAUD_FF:OSERDESE3 
     --   	  generic map(
     --             DATA_WIDTH => 4,
     --             INIT => '0',
     --             IS_CLKDIV_INVERTED => '0',
     --             IS_CLK_INVERTED => '0',
     --             ODDR_MODE => "TRUE",
     --             IS_RST_INVERTED => '0',
     --             OSERDES_D_BYPASS => "TRUE",
     --             OSERDES_T_BYPASS => "TRUE"
     --                         )
     --             port map (
     --               CLK => Sys_clk,
     --               CLKDIV => Sys_clk,
     --               D(7 downto 6) =>"00",
     --               D(5) => baud_d1,
     --               D(4) => baud_d1,
     --               D(3 downto 2) =>"00" ,
     --               D(1) => baud_d0,
     --               D(0) => baud_d0,
     --               OQ => BaudoutN,
     --               RST => '0',
     --               T => '0',
     --               T_OUT => open
     --             );

        end generate OSERDESE3_ODDR_GEN;
 
  end generate NO_EXTERNAL_XIN;

  BaudoutN_int <= baud_int;

-------------------------------------------------------------------------------
-- EXTERNAL_XIN : External XIN is used.
-- Added for Baud generator to accept value 0x01 as a devisor
-- For Divisor value = 1, BaudoutN_int is same as XIN.
-------------------------------------------------------------------------------
   EXTERNAL_XIN : if C_HAS_EXTERNAL_XIN = TRUE generate

      baud_int <= not Xin when baud_divisor_is_1 = '1' else
                      baudoutN_int_i;

      BaudoutN <= baud_int;

   end generate EXTERNAL_XIN;



-------------------------------------------------------------------------------
-- receiver instantiation
-------------------------------------------------------------------------------  
  rx16550_1 : entity axi_uart16550_v2_0_22.rx16550
    port map (
      Sys_clk            => Sys_clk,
      Rclk               => Rclk,
      Rst                => rx_rst,
      Lcr                => Lcr,
      Rbr                => Rbr,
      Fcr_0              => fcr(0),
      Sin                => rx_sin,
      Parity_error       => parity_error,
      Framing_error      => framing_error,
      Break_interrupt    => break_interrupt,
      Data_ready         => data_ready,
      Rx_fifo_data_in    => rx_fifo_data_in,
      Character_received => character_received,
      Have_bi_in_fifo_n  => have_bi_in_fifo_n);


  rx_rst <= '1' when ((mcr(4) /= mcr4_d) or Rst = '1') else '0';
  
-------------------------------------------------------------------------------
-- transmitter instantiation
-------------------------------------------------------------------------------
  tx16550_1 : entity axi_uart16550_v2_0_22.tx16550
    port map (
      Sys_clk          => Sys_clk,
      Rst              => Rst,
      BaudoutN         => baud_int,
      Lcr              => Lcr,
      Thr              => Tsr,
      Tx_empty         => tx_empty,
      Start_tx         => start_tx,
      Sout             => tx_sout,
      Tsr_loaded       => tsr_loaded,
      Tx_fifo_rd_en    => tx_fifo_rd_en_int,
      Fcr_0            => fcr(0),
      Tx_fifo_data_out => tx_fifo_data_out);

-------------------------------------------------------------------------------
-- PROCESS: START_TX_PROCESS
-- purpose: generate start_tx
-------------------------------------------------------------------------------
  START_TX_PROCESS : process (Freeze, fcr, lsr, Tsre) is
  begin  -- process START_TX_PROCESS
    if fcr(0) = '1' then
      start_tx <= lsr(5) or Freeze;
    else
      start_tx <= Tsre or Freeze;
    end if;
  end process START_TX_PROCESS;


-------------------------------------------------------------------------------
-- fifo related logic (will synthesize away when C_IS_A_16550 = FALSE
-------------------------------------------------------------------------------
  fifo_mode1           <= fcr(0) and fcr(3);
  receiver_timeout     <= '1' when (fcr(0) = '1' and rx_fifo_timeout = '1') 
                              else '0';
  rx_fifo_overrun      <= '1' when (fcr(0) = '1' and rx_fifo_full = '1' and
                                    character_received = '1') else '0';
  rx_error_in_fifo_int <= '0' when (rx_error_in_fifo_cnt = "0000")  else 
                          '1';
  rx_error_in_fifo_lst <= '1' when (rx_error_in_fifo_cnt = "0001" and 
                                    lsr_rst = '1')  else 
                          '0';
  rx_error_out_fifo    <=  rx_fifo_data_out(10) or rx_fifo_data_out(9) or
                           rx_fifo_data_out(8);
                          
  rx_fifo_rd_en        <= fcr(0) and read_rbr;

-------------------------------------------------------------------------------
-- Generate FIFOs or not, based on C_IS_A_16550
-------------------------------------------------------------------------------
  NOT_GENERATING_FIFOS : if C_IS_A_16550 /= TRUE generate
  begin
    fcr                  <= (others => '0');
    fcr_0_prev           <= '0';
    tx_fifo_data_out     <= (others => '0');
    tx_fifo_rd_en_int    <= '0';
    tx_fifo_full         <= '0';
    tx_fifo_empty        <= '0';
    rx_fifo_data_out     <= (others => '0');
    rx_fifo_empty        <= '0';
    rx_fifo_full         <= '0';
    rx_fifo_timeout      <= '0';
    rx_fifo_trigger      <= '0';
    rx_fifo_rd_en_d      <= '0';
    rx_error_in_fifo     <= '0';
    rx_error_in_fifo_cnt <= "0000";
  end generate NOT_GENERATING_FIFOS;

-------------------------------------------------------------------------------
   -- Generating FIFO 
-------------------------------------------------------------------------------
  GENERATING_FIFOS : if C_IS_A_16550 = TRUE generate
    
    signal fcr_0_changed : std_logic;   -- flags a change in fcr(0)

    signal tx_fifo_wr_en   : std_logic;
    signal tx_fifo_wr_en_d : std_logic;
    signal tx_fifo_rd_en   : std_logic;
    signal tx_fifo_rst     : std_logic;

    signal rx_fifo_wr_en : std_logic;
    signal rx_fifo_rst   : std_logic;

    signal rx_error_in_fifo_cnt_up : std_logic;
    signal rx_error_in_fifo_cnt_dn : std_logic;

    begin
    
    fcr_0_changed <= '1' when (writeStrobe = '1' and fcr_w_sel = '1' and 
                              (fcr(0) xor fcr_0_prev) = '1') else '0';
    rx_fifo_wr_en <= (fcr(0) and (character_received and (not rx_fifo_full) and
                                  have_bi_in_fifo_n));
    tx_fifo_wr_en <= (fcr(0) and writeStrobe and thr_sel);
    tx_fifo_rd_en <= (fcr(0) and tx_fifo_rd_en_int);

    ---------------------------------------------------------------------------
    -- PROCESS: FCR_0_WRITE
    -- purpose: write fcr register
    ---------------------------------------------------------------------------
    FCR_0_WRITE : process (Sys_clk) is
    begin  -- process fcrWrite
      if Sys_clk'EVENT and Sys_clk = '1' then
        if Rst = '1' then
          fcr(0) <= '0';
        elsif writeStrobe = '1' and fcr_w_sel = '1' then
          fcr(0) <= internalBus(0);
        end if;
      end if;
    end process FCR_0_WRITE;
    
    ---------------------------------------------------------------------------
    -- PROCESS: FCR_1_WRITE
    -- purpose: write fcr register
    ---------------------------------------------------------------------------
    FCR_1_WRITE : process (Sys_clk) is
    begin  -- process fcrWrite
      if Sys_clk'EVENT and Sys_clk = '1' then
        if Rst = '1' then  -- fcr(0) must be set to write fcr(7 downto 1)
          fcr(7 downto 1) <= (others => '0');
        elsif writeStrobe = '1' and fcr_w_sel = '1' and fcr_0_prev = '1' then
          fcr(7 downto 1) <= internalBus(7 downto 6) & "00" & 
                             internalBus(3 downto 1);
        else
          fcr(7 downto 1) <= fcr(7 downto 6) & "00" & fcr(3) & "00";
        end if;
      end if;
    end process FCR_1_WRITE;

    ---------------------------------------------------------------------------
    -- PROCESS: PREV_FCR_0_PROCESS
    -- purpose: generate fcr bit
    ---------------------------------------------------------------------------
    PREV_FCR_0_PROCESS : process (Sys_clk) is
    begin  -- process fcrWrite
      if Sys_clk'EVENT and Sys_clk = '1' then
        if Rst = '1' then
          fcr_0_prev <= '0';
        elsif writeStrobe = '0' and fcr_w_sel = '1' then
          fcr_0_prev <= fcr(0);
        end if;
      end if;
    end process PREV_FCR_0_PROCESS;

    ---------------------------------------------------------------------------
    -- transmitter fifo instantiation
    ---------------------------------------------------------------------------
    tx_fifo_block_1 : entity axi_uart16550_v2_0_22.tx_fifo_block
     generic map (
        C_FAMILY         => C_FAMILY )
      port map (
        Tx_fifo_data_in  => Thr,
        Tx_fifo_wr_en    => tx_fifo_wr_en_d,
        Tx_fifo_data_out => tx_fifo_data_out,
        Tx_fifo_clk      => Sys_clk,
        Tx_fifo_rd_en    => tx_fifo_rd_en,
        Tx_fifo_rst      => tx_fifo_rst,
        Tx_fifo_empty    => tx_fifo_empty,
        Tx_fifo_full     => tx_fifo_full);

    ---------------------------------------------------------------------------
        -- PROCESS: TX_FIFO_READ_EN
        -- purpose: delays tx_fifo_rd_en 1 clock cycle
    ---------------------------------------------------------------------------
    TX_FIFO_READ_EN : process (Sys_clk) is
    begin  -- process TX_FIFO_WRITE_EN
      if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
        if Rst = '1' then       -- asynchronous reset (active high)
          tx_fifo_wr_en_d <= '0';
        else
          tx_fifo_wr_en_d <= tx_fifo_wr_en;
        end if;
      end if;
    end process TX_FIFO_READ_EN;

    ---------------------------------------------------------------------------
    -- PROCESS: REGISTER_TX_FIFO_RST
    -- purpose: registers tx_fifo_rst
    ---------------------------------------------------------------------------
    REGISTER_TX_FIFO_RST : process (Sys_clk) is
    begin  -- process REGISTER_RX_FIFO_RST
      if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
        tx_fifo_rst <= (Rst or fcr(2) or fcr_0_changed);
      end if;
    end process REGISTER_TX_FIFO_RST;

    ---------------------------------------------------------------------------
    -- receiver fifo instantiation
    ---------------------------------------------------------------------------
    rx_fifo_block_1 : entity axi_uart16550_v2_0_22.rx_fifo_block
       generic map (
        C_FAMILY           =>  C_FAMILY )
       port map (
        Sys_clk            => Sys_clk,
        Rclk               => Rclk,
        Rst                => Rst,
        Rx_fifo_data_in    => rx_fifo_data_in,
        Rx_fifo_wr_en      => rx_fifo_wr_en,
        Rx_fifo_data_out   => rx_fifo_data_out,
        Rx_fifo_rd_en      => rx_fifo_rd_en_d,
        Rx_fifo_rst        => rx_fifo_rst,
        Rx_fifo_empty      => rx_fifo_empty,
        Fcr                => fcr,
        Rx_fifo_timeout    => rx_fifo_timeout,
        Rx_fifo_trigger    => rx_fifo_trigger,
        Rx_fifo_full       => rx_fifo_full,
        Rx_error_in_fifo   => rx_error_in_fifo);

    ---------------------------------------------------------------------------
    -- PROCESS: RX_FIFO_READ_EN
    -- purpose: delays rx_fifo_rd_en 1 clock cycle
    ---------------------------------------------------------------------------
    RX_FIFO_READ_EN : process (Sys_clk) is
    begin  -- process TX_FIFO_WRITE_EN
      if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
        if Rst = '1' then       -- asynchronous reset (active high)
          rx_fifo_rd_en_d  <= '0';
          rx_fifo_rd_en_d1 <= '0';
        else
          rx_fifo_rd_en_d  <= rx_fifo_rd_en;
          rx_fifo_rd_en_d1 <= rx_fifo_rd_en_d;
        end if;
      end if;
    end process RX_FIFO_READ_EN;

    ---------------------------------------------------------------------------
    -- PROCESS: RX_ERR_IN_FIFO_CNT_UP_PROC
    -- purpose: finds rising edge of rx_error_in_fifo
    ---------------------------------------------------------------------------
    RX_ERR_IN_FIFO_CNT_UP_PROC : process (Sys_clk) is
    begin  -- process RX_ERR_IN_FIFO_CNT_UP_PROC
      if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
        if Rst = '1' then       -- asynchronous reset (active high)
          rx_error_in_fifo_cnt_up <= '0';
        else
          rx_error_in_fifo_cnt_up <= rx_error_in_fifo;
        end if;
      end if;
    end process RX_ERR_IN_FIFO_CNT_UP_PROC;

    ---------------------------------------------------------------------------
    -- PROCESS: RX_ERR_IN_FIFO_CNT_UP_PROC
    -- purpose: tracks errors being removed from rx fifo
    ---------------------------------------------------------------------------
    RX_ERR_IN_FIFO_CNT_DN_PROC : process (Sys_clk) is
    begin  -- process RX_ERR_IN_FIFO_CNT_DN_PROC
      if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
        if Rst = '1' then       -- asynchronous reset (active high)
          rx_error_in_fifo_cnt_dn <= '0';
        else
          rx_error_in_fifo_cnt_dn <= (rx_error_out_fifo  and 
                                     (rx_fifo_rd_en_d or rx_error_in_fifo_lst));
        end if;
      end if;
    end process RX_ERR_IN_FIFO_CNT_DN_PROC;

    ---------------------------------------------------------------------------
    -- PROCESS: RX_ERR_IN_FIFO_CNT_PROC
    -- purpose: tracks number of rx errors in fifo
    ---------------------------------------------------------------------------
    RX_ERR_IN_FIFO_CNT_PROC : process (Sys_clk) is
    begin  -- process RX_ERR_IN_FIFO_CNT_PROC
      if Sys_clk'EVENT and Sys_clk = '1' then         -- rising clock edge
        if Rst = '1' or rx_fifo_rst = '1' then           -- asynchronous reset 
          rx_error_in_fifo_cnt <= "0000";               -- (active high)
        elsif (rx_error_in_fifo_cnt_up = '1' and 
                rx_error_in_fifo_cnt /= "1111")    then
          rx_error_in_fifo_cnt <= rx_error_in_fifo_cnt + "0001";
        elsif (rx_error_in_fifo_cnt_dn = '1' and 
                rx_error_in_fifo_cnt /= "0000")     then
          rx_error_in_fifo_cnt <= rx_error_in_fifo_cnt - "0001";
        end if;
      end if;
    end process RX_ERR_IN_FIFO_CNT_PROC;

    ---------------------------------------------------------------------------
    -- PROCESS: REGISTER_RX_FIFO_RST
    -- purpose: registers rx_fifo_rst
    ---------------------------------------------------------------------------
    REGISTER_RX_FIFO_RST : process (Sys_clk) is
    begin  -- process REGISTER_RX_FIFO_RST
      if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
        rx_fifo_rst <= (Rst or fcr(1) or fcr_0_changed);
      end if;
    end process REGISTER_RX_FIFO_RST;
    
  end generate GENERATING_FIFOS;

end implementation;


-------------------------------------------------------------------------------
-- ipic_if.vhd - entity/architecture pair
-------------------------------------------------------------------------------
--  ***************************************************************************
--  ** DISCLAIMER OF LIABILITY                                               **
--  **                                                                       **
--  **  This file contains proprietary and confidential information of       **
--  **  Xilinx, Inc. ("Xilinx"), that is distributed under a license         **
--  **  from Xilinx, and may be used, copied and/or disclosed only           **
--  **  pursuant to the terms of a valid license agreement with Xilinx.      **
--  **                                                                       **
--  **  XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION                **
--  **  ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER           **
--  **  EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT                  **
--  **  LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,            **
--  **  MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx        **
--  **  does not warrant that functions included in the Materials will       **
--  **  meet the requirements of Licensee, or that the operation of the      **
--  **  Materials will be uninterrupted or error-free, or that defects       **
--  **  in the Materials will be corrected. Furthermore, Xilinx does         **
--  **  not warrant or make any representations regarding use, or the        **
--  **  results of the use, of the Materials in terms of correctness,        **
--  **  accuracy, reliability or otherwise.                                  **
--  **                                                                       **
--  **  Xilinx products are not designed or intended to be fail-safe,        **
--  **  or for use in any application requiring fail-safe performance,       **
--  **  such as life-support or safety devices or systems, Class III         **
--  **  medical devices, nuclear facilities, applications related to         **
--  **  the deployment of airbags, or any other applications that could      **
--  **  lead to death, personal injury or severe property or                 **
--  **  environmental damage (individually and collectively, "critical       **
--  **  applications"). Customer assumes the sole risk and liability         **
--  **  of any use of Xilinx products in critical applications,              **
--  **  subject only to applicable laws and regulations governing            **
--  **  limitations on product liability.                                    **
--  **                                                                       **
--  **  Copyright 2010 Xilinx, Inc.                                          **
--  **  All rights reserved.                                                 **
--  **                                                                       **
--  **  This disclaimer and copyright notice must be retained as part        **
--  **  of this file at all times.                                           **
--  ***************************************************************************
-------------------------------------------------------------------------------
-- Filename:        ipic_if.vhd
-- Version:         v1.01.a
-- Description:     This module has the logic for generation ofacknowledgemet
--                  signals for read and write transactions to UART and also
--                  incorporates the logic for generation of 3-bit address 
--                  for UART registers alongwith single pulse read and write
--                  signals for UART.

-- VHDL-Standard:   VHDL'93
--
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_cmb" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------
-- Definition of Generics:

-- Definition of ports:
--   IPIC 
--     Bus2IP_Clk           -- Bus to IP clock 
--     Bus2IP_Reset         -- Bus to IP reset   
--     Bus2IP_RdCE          -- Bus to IP read chip enables
--     Bus2IP_WrCE          -- Bus to IP write chip enables
--     Bus2IP_RdReq         -- Bus to IP read request
--     Bus2IP_WrReq         -- Bus to IP write request
--     IP2Bus_WrAcknowledge -- IP to Bus write acknowledge
--     IP2Bus_RdAcknowledge -- IP to Bus read acknowledge
      
--  UART core Interface signals
--     Rd                   -- UART Read
--     Wr                   -- UART Write        
        
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------
entity ipic_if is
  port (
     -- IPIC Signals
        Bus2IP_Clk           : in std_logic;
        Bus2IP_Reset         : in std_logic;
        Bus2IP_RdCE          : in std_logic;
        Bus2IP_WrCE          : in std_logic;
        Bus2IP_RdReq         : out std_logic;
        Bus2IP_WrReq         : out std_logic;
                             
     -- UART Signals         
        Wr                   : out std_logic;
        Rd                   : out std_logic;
                             
     -- IPIF signals         
        IP2Bus_WrAcknowledge : out std_logic;
        IP2Bus_RdAcknowledge : out std_logic
      );
end ipic_if;

-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------

architecture imp of ipic_if is
-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of imp : architecture is "yes";
-------------------------------------------------------------------------------
-- Function Declarations
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Signal Declarations
-------------------------------------------------------------------------------

  signal bus2ip_rdreq_i   : std_logic;
  signal bus2ip_wrreq_i   : std_logic;
  
  signal ip2bus_wrack     : std_logic;
  signal ip2bus_rdack     : std_logic;
  signal ip2bus_wrack_d1  : std_logic;
  signal ip2bus_rdack_d1  : std_logic;
  signal bus2ip_rdreq_d1  : std_logic;
  signal bus2ip_rdreq_d2  : std_logic;
  signal bus2ip_rdreq_d3  : std_logic;
  signal bus2ip_rdreq_d4  : std_logic;
      
  signal wrReq_d1         : std_logic;
  signal wrReq_d2         : std_logic;
  signal wrReq_d3         : std_logic;

begin 
    
  -----------------------------------------------------------------------------
  -- bus2ip_rdreq_i generated if any one of the Bus2IP_RdCE is asserted 
  -----------------------------------------------------------------------------
  bus2ip_rdreq_i  <= Bus2IP_RdCE;
  
  -----------------------------------------------------------------------------
  -- bus2ip_wrreq_i generated if any one of the Bus2IP_WrCE is asserted 
  -----------------------------------------------------------------------------
  bus2ip_wrreq_i  <= Bus2IP_WrCE;                         
  
  Bus2IP_RdReq    <= bus2ip_rdreq_i;
  Bus2IP_WrReq    <= bus2ip_wrreq_i;
 
  ---------------------------------------------------------------------------
  -- PROCESS: RDREQ_D
  -- purpose: register bus2ip_rdreq
  ---------------------------------------------------------------------------
  RDREQ_D : process (Bus2IP_Clk) is
    begin  
      if Bus2IP_Clk'EVENT and Bus2IP_Clk = '1' then  -- rising clock edge
        if Bus2IP_Reset = '1' then                  
          bus2ip_rdreq_d1 <= '0';
        else
          bus2ip_rdreq_d1 <= bus2ip_rdreq_i;
        end if;
      end if;
  end process RDREQ_D;
   
  ---------------------------------------------------------------------------
  -- PROCESS: RX_ERR_IN_FIFO_CNT_PROC
  -- purpose: Write Ack & read Acks back to IPIF are registered
  ---------------------------------------------------------------------------
  ACKN: process(Bus2IP_Clk)
  begin
    if(Bus2IP_Clk'event and Bus2IP_Clk = '1') then
      if Bus2IP_Reset = '1' then
        ip2bus_wrack_d1       <= '0';
        ip2bus_rdack_d1       <= '0';
        IP2Bus_WrAcknowledge  <= '0';
        IP2Bus_RdAcknowledge  <= '0';
      else                    
        ip2bus_wrack_d1       <= ip2bus_wrack;
        ip2bus_rdack_d1       <= ip2bus_rdack;
        IP2Bus_WrAcknowledge  <= ip2bus_wrack_d1;
        IP2Bus_RdAcknowledge  <= ip2bus_rdack_d1;
      end if;
    end if;
  end process ACKN; 
  
   
 ------------------------------------------------------------------------------
  -- The logic in XUART_WRITE process for the generation of acknowledge and 
  -- write signal for write operations initiated in UART 16550 registers 
 ------------------------------------------------------------------------------ 
  XUART_WRITE : process (Bus2IP_Clk) is
    begin  -- process XUART_WRITE
     if Bus2IP_Clk'EVENT and Bus2IP_Clk = '1' then  -- rising clock edge
       if Bus2IP_Reset = '1' then                  
         wrReq_d1   <= '0';
         wrReq_d2   <= '0';
         wrReq_d3   <= '0';
       else         
         wrReq_d1   <= bus2ip_wrreq_i;
         wrReq_d2   <= wrReq_d1;
         wrReq_d3   <= wrReq_d2;
       end if;
     end if;
  end process XUART_WRITE;
      
  ip2bus_wrack  <= wrReq_d2 and (not wrReq_d3);
  Wr            <= bus2ip_wrreq_i and (not wrReq_d1);
   
   
 ------------------------------------------------------------------------------
  -- The logic in XUART_READ process for the generation of acknowledge and read
  -- signal for read operations initiated in UART 16550 registers 
 ------------------------------------------------------------------------------  
  XUART_READ : process (Bus2IP_Clk) is
  begin  -- process XUART_READ
    if Bus2IP_Clk'EVENT and Bus2IP_Clk = '1' then  -- rising clock edge
      if Bus2IP_Reset = '1' then                  
        bus2ip_rdreq_d2 <= '0';
        bus2ip_rdreq_d3 <= '0';
        bus2ip_rdreq_d4 <= '0';
      else
        bus2ip_rdreq_d2 <= bus2ip_rdreq_d1;
        bus2ip_rdreq_d3 <= bus2ip_rdreq_d2;
        bus2ip_rdreq_d4 <= bus2ip_rdreq_d3;
      end if;
    end if;
  end process XUART_READ;
  
  -- Read ack generation
  ip2bus_rdack <= bus2ip_rdreq_d3 and (not bus2ip_rdreq_d4);
  Rd           <= bus2ip_rdreq_d1 and (not bus2ip_rdreq_d2);  
  
end imp;


--------------------------------------------------------------------------------
-- xuart.vhd - entity/architecture pair
--------------------------------------------------------------------------------
--  ***************************************************************************
--  ** DISCLAIMER OF LIABILITY                                               **
--  **                                                                       **
--  **  This file contains proprietary and confidential information of       **
--  **  Xilinx, Inc. ("Xilinx"), that is distributed under a license         **
--  **  from Xilinx, and may be used, copied and/or disclosed only           **
--  **  pursuant to the terms of a valid license agreement with Xilinx.      **
--  **                                                                       **
--  **  XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION                **
--  **  ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER           **
--  **  EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT                  **
--  **  LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,            **
--  **  MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx        **
--  **  does not warrant that functions included in the Materials will       **
--  **  meet the requirements of Licensee, or that the operation of the      **
--  **  Materials will be uninterrupted or error-free, or that defects       **
--  **  in the Materials will be corrected. Furthermore, Xilinx does         **
--  **  not warrant or make any representations regarding use, or the        **
--  **  results of the use, of the Materials in terms of correctness,        **
--  **  accuracy, reliability or otherwise.                                  **
--  **                                                                       **
--  **  Xilinx products are not designed or intended to be fail-safe,        **
--  **  or for use in any application requiring fail-safe performance,       **
--  **  such as life-support or safety devices or systems, Class III         **
--  **  medical devices, nuclear facilities, applications related to         **
--  **  the deployment of airbags, or any other applications that could      **
--  **  lead to death, personal injury or severe property or                 **
--  **  environmental damage (individually and collectively, "critical       **
--  **  applications"). Customer assumes the sole risk and liability         **
--  **  of any use of Xilinx products in critical applications,              **
--  **  subject only to applicable laws and regulations governing            **
--  **  limitations on product liability.                                    **
--  **                                                                       **
--  **  Copyright 2010 Xilinx, Inc.                                          **
--  **  All rights reserved.                                                 **
--  **                                                                       **
--  **  This disclaimer and copyright notice must be retained as part        **
--  **  of this file at all times.                                           **
--  ***************************************************************************
-------------------------------------------------------------------------------
-- Filename:        xuart.vhd
-- Version:         v2.0
-- Description:     This module instantiates the uart 16550 core , 
--                  and ipic_if.vhd modules
--                                        
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_cmb" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library lib_cdc_v1_0_2;

-------------------------------------------------------------------------------
-- axi_uart16550_v2_0_22 library is used for axi_uart16550_v2_0_22 
-- component declarations
-------------------------------------------------------------------------------
library axi_uart16550_v2_0_22;
use axi_uart16550_v2_0_22.uart16550;
use axi_uart16550_v2_0_22.ipic_if;


-------------------------------------------------------------------------------
-- Definition of Generics:
-- System generics
--    C_FAMILY              --  Xilinx FPGA Family
--    C_S_AXI_CLK_FREQ_HZ   --  System clock frequency driving UART lite
--                              peripheral in Hz
--                            
-- AXI generics               
--    C_S_AXI_BASEADDR      --  Base address of the core
--    C_S_AXI_HIGHADDR      --  Permits alias of address space
--                              by making greater than xFFF
--    C_S_AXI_ADDR_WIDTH    --  Width of AXI Address Bus (in bits)
--    C_S_AXI_DATA_WIDTH    --  Width of the AXI Data Bus (in bits)
--			    
-- UART 16550 generics         
--    C_IS_A_16550          --  Selection of UART for 16450 or 16550 mode
--    C_HAS_EXTERNAL_XIN    --  External XIN
--    C_HAS_EXTERNAL_RCLK   --  External RCLK
--    C_EXTERNAL_XIN_CLK_HZ --  External XIN clock frequency
-------------------------------------------------------------------------------
--
-- Definition of ports:
-- IPIC signals
--    Bus2IP_Clk          --  Bus to IP clock
--    Bus2IP_Reset        --  Bus to IP reset
--    Bus2IP_Addr         --  Bus to IP address
--    Bus2IP_RdCE         --  Bus to IP read chip enables
--    Bus2IP_WrCE         --  Bus to IP write chip enables
--    Bus2IP_Data         --  Bus to IP data
--    IP2Bus_Data         --  IP to bus data
--    IP2Bus_WrAck        --  IP to bus write acknowledge
--    IP2Bus_RdAck        --  IP to bus read acknowledge
--
-- UART16550 interface signals
--    BaudoutN            --  Transmitter Clock
--    CtsN                --  Clear To Send (active low)
--    DcdN                --  Data Carrier Detect (active low)
--    Ddis                --  Driver Disable
--    DsrN                --  Data Set Ready (active low)
--    DtrN                --  Data Terminal Ready (active low)
--    Out1N               --  User controlled output1
--    Out2N               --  User controlled output2
--    Rclk                --  Receiver 16x Clock
--    RiN                 --  Ring Indicator (active low)
--    RtsN                --  Request To Send (active low)
--    RxrdyN              --  DMA control signal
--    Sin                 --  Serial Data Input
--    Sout                --  Serial Data Output
--    Xin                 --  Baud Rate Generator reference clock
--    Xout                --  Inverted XIN
--    TxrdyN              --  DMA control signal
--    IP2INTC_Irpt        --  Interrupt signal
--    Freeze              --  Freezes UART for software debug (active high)
--    Intr                --  Uart interupt (not used)
-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------

entity xuart is
  
  generic (
    C_FAMILY                : string;
    C_SIM_DEVICE            : string;
    C_S_AXI_CLK_FREQ_HZ     : integer                 := 100_000_000;
    AXI_DATA_WIDTH          : integer  range 32 to 32 := 32;
    AXI_ADDR_WIDTH          : integer                 := 32; 
    C_IS_A_16550            : boolean;
    C_HAS_EXTERNAL_XIN      : boolean;
    C_HAS_EXTERNAL_RCLK     : boolean;
    C_EXTERNAL_XIN_CLK_HZ   : integer                 := 25_000_000
    ); 

   port (

    -- Controls to the IP/IPIF modules
    Bus2IP_Clk     : in  std_logic;
    Bus2IP_Reset   : in  std_logic;
    Bus2IP_Addr    : in  std_logic_vector(2 downto 0);
    Bus2IP_RdCE    : in  std_logic;
    Bus2IP_WrCE    : in  std_logic;
    Bus2IP_Data    : in  std_logic_vector((AXI_DATA_WIDTH-1) downto 0);
    IP2Bus_Data    : out std_logic_vector((AXI_DATA_WIDTH-1) downto 0);
    IP2Bus_WrAck   : out std_logic;
    IP2Bus_RdAck   : out std_logic;
    
    -- Uart Signals
    BaudoutN       : out std_logic;
    CtsN           : in  std_logic;
    DcdN           : in  std_logic;
    Ddis           : out std_logic;
    DsrN           : in  std_logic;
    DtrN           : out std_logic;
    Out1N          : out std_logic;
    Out2N          : out std_logic;
    Rclk           : in  std_logic;
    RiN            : in  std_logic;
    RtsN           : out std_logic;
    RxrdyN         : out std_logic;
    Sin            : in  std_logic;
    Sout           : out std_logic;
    IP2INTC_Irpt   : out std_logic;
    TxrdyN         : out std_logic;
    Xin            : in  std_logic;
    Xout           : out std_logic;
    Freeze         : in  std_logic;
    Intr           : out std_logic
    );

end xuart;

-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------
architecture imp of xuart is

-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of imp : architecture is "yes";


  -----------------------------------------------------------------------------
    -- Signal and Type Declarations
  -----------------------------------------------------------------------------
  signal Rd               : std_logic;
  signal Wr               : std_logic;
  signal baudoutN_int     : std_logic;
  signal rclk_int         : std_logic;
  signal uart_intr        : std_logic;
  signal xin_int          : std_logic;
  signal bus2ip_cs_i      : std_logic;
  signal bus2ip_rdreq_i   : std_logic;
  signal bus2ip_wrreq_i   : std_logic;
 
  -----------------------------------------------------------------------------
    -- Begin Architecture
  -----------------------------------------------------------------------------
    
  begin
  
  -----------------------------------------------------------------------------
  -- Component Instantiations
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
    -- Entity UART instantiation
  -----------------------------------------------------------------------------
       
   UART16550_I_1 : entity axi_uart16550_v2_0_22.uart16550
    generic map (
      C_FAMILY              => C_FAMILY,
      C_SIM_DEVICE          => C_SIM_DEVICE,
      C_S_AXI_CLK_FREQ_HZ   => C_S_AXI_CLK_FREQ_HZ,
      C_IS_A_16550          => C_IS_A_16550,
      C_HAS_EXTERNAL_XIN    => C_HAS_EXTERNAL_XIN,
      C_EXTERNAL_XIN_CLK_HZ => C_EXTERNAL_XIN_CLK_HZ)
    port map (
      Din          => Bus2IP_Data(7 downto 0),
      Dout         => IP2Bus_Data(7 downto 0),
      Sout         => Sout,
      BaudoutN     => BaudoutN,
      BaudoutN_int => baudoutN_int, 
      Intr         => uart_intr,
      Ddis         => Ddis,
      TxrdyN       => TxrdyN,
      RxrdyN       => RxrdyN,
      Xout         => Xout,
      RtsN         => RtsN,
      DtrN         => DtrN,
      Out1N        => Out1N,
      Out2N        => Out2N,
      Addr         => Bus2IP_Addr,
      Cs0          => bus2ip_cs_i,
      Cs1          => '1',
      Cs2N         => '0',
      AdsN         => '0',
      Sin          => Sin,
      Rclk         => rclk_int,
      Xin          => xin_int,
      Rd           => Rd,
      RdN          => '1',
      Wr           => Wr,
      WrN          => '1',
      Rst          => Bus2IP_Reset,
      CtsN         => CtsN,
      DcdN         => DcdN,
      DsrN         => DsrN,
      RiN          => RiN,
      Freeze       => Freeze,
      Sys_clk      => Bus2IP_Clk);


  -- IPIC signals
  IP2Bus_Data(AXI_DATA_WIDTH-1 downto 8) <= (others => '0');
  IP2INTC_Irpt  <= uart_intr;  
  Intr          <= uart_intr;



  -----------------------------------------------------------------------------
    -- Entity IPIC_IC instantiation
  -----------------------------------------------------------------------------
  
  IPIC_IF_I_1 : entity axi_uart16550_v2_0_22.ipic_if 
    port map
       (
       Bus2IP_Clk             => Bus2IP_Clk,
       Bus2IP_Reset           => Bus2IP_Reset,
       Bus2IP_RdCE            => Bus2IP_RdCE,
       Bus2IP_WrCE            => Bus2IP_WrCE,
       Bus2IP_RdReq           => bus2ip_rdreq_i,
       Bus2IP_WrReq           => bus2ip_wrreq_i,
       Wr                     => Wr,
       Rd                     => Rd,
                              
       -- IPIF signals        
       IP2Bus_WrAcknowledge   => IP2Bus_WrAck,
       IP2Bus_RdAcknowledge   => IP2Bus_RdAck
       );
  
  -----------------------------------------------------------------------------
  -- GENERATING_EXTERNAL_RCLK : Synchronize Rclk clock with system clock if 
  -- external receive clock is selected.
  -----------------------------------------------------------------------------
  GENERATING_EXTERNAL_RCLK : if C_HAS_EXTERNAL_RCLK = TRUE generate

    signal rclk_d1 : std_logic;
    signal rclk_d2 : std_logic;
    signal rclk_d3 : std_logic;

  begin
  
    ---------------------------------------------------------------------------
     -- purpose: detects rising edge of Rclk
     -- type   : sequential
     -- inputs : Bus2IP_Clk, Rclk
    ---------------------------------------------------------------------------
    RCLK_CDC : entity lib_cdc_v1_0_2.cdc_sync
    generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => 4
    )
    port map (
        prmry_aclk                 => '0',
        prmry_resetn               => '0', 
        prmry_in                   => Rclk, 
        prmry_vect_in              => (others => '0'),
                                    
        scndry_aclk                => Bus2IP_Clk , 
        scndry_resetn              => '0',
        scndry_out                 => rclk_d2,
        scndry_vect_out            => open
    );

    RCLK_RISING_EDGE : process (Bus2IP_Clk) is
      begin  -- process RCLK_RISING_EDGE
        if Bus2IP_Clk'event and Bus2IP_Clk = '1' then  -- rising clock edge
          --rclk_d1 <= Rclk;
          rclk_d3 <= rclk_d2;
      end if;
    end process RCLK_RISING_EDGE;
    
    rclk_int <= rclk_d2 and (not rclk_d3) and (not Bus2IP_Reset);
  end generate GENERATING_EXTERNAL_RCLK;

  -----------------------------------------------------------------------------
  -- NOT_GENERATING_EXTERNAL_RCLK : If external receive clock is not available,
  -- use baudoutN_int as a receive clock
  -----------------------------------------------------------------------------
  NOT_GENERATING_EXTERNAL_RCLK : if C_HAS_EXTERNAL_RCLK /= TRUE generate
  begin
    rclk_int <= not baudoutN_int;
  end generate NOT_GENERATING_EXTERNAL_RCLK;

  -----------------------------------------------------------------------------
  -- GENERATING_EXTERNAL_XIN : Synchronize Xin clock with system clock if 
  -- external Xin clock is selected.
  -----------------------------------------------------------------------------
  GENERATING_EXTERNAL_XIN : if C_HAS_EXTERNAL_XIN = TRUE generate

    signal xin_d1 : std_logic;
    signal xin_d2 : std_logic;
    signal xin_d3 : std_logic;

  begin
  
    ---------------------------------------------------------------------------
    -- purpose: detects rising edge of xin
    -- Type   : sequential
    -- inputs : Bus2IP_Clk, xin
    -- outputs: xin_rising
    ---------------------------------------------------------------------------
    XIN_CDC : entity lib_cdc_v1_0_2.cdc_sync
    generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => 4
    )
    port map (
        prmry_aclk                 => '0',
        prmry_resetn               => '0', 
        prmry_in                   => Xin, 
        prmry_vect_in              => (others => '0'),
                                    
        scndry_aclk                => Bus2IP_Clk , 
        scndry_resetn              => '0',
        scndry_out                 => xin_d2,
        scndry_vect_out            => open
    );

    XIN_RISING_EDGE: process (Bus2IP_Clk) is
    begin  -- process XIN_RISING_EDGE
      if Bus2IP_Clk'event and Bus2IP_Clk = '1' then  -- rising clock edge
         -- xin_d1 <= Xin;
          xin_d3 <= xin_d2;
      end if;
    end process XIN_RISING_EDGE;
    xin_int <= xin_d2 and (not xin_d3);  -- inverted to make baudoutN
  end generate GENERATING_EXTERNAL_XIN;

  -----------------------------------------------------------------------------
  -- NOT_GENERATING_EXTERNAL_XIN : If external xin clock is not available,
  -- drive xin_int with '1'. 
  -----------------------------------------------------------------------------
  NOT_GENERATING_EXTERNAL_XIN : if C_HAS_EXTERNAL_XIN /= TRUE generate
  begin
    xin_int <= '1';                      -- xin in always active
  end generate NOT_GENERATING_EXTERNAL_XIN;
  
  bus2ip_cs_i <= bus2ip_rdreq_i or bus2ip_wrreq_i;  

end imp;


-------------------------------------------------------------------------------
-- axi_uart16550.vhd - entity/architecture pair
-------------------------------------------------------------------------------
--  ***************************************************************************
--  ** DISCLAIMER OF LIABILITY                                               **
--  **                                                                       **
--  **  This file contains proprietary and confidential information of       **
--  **  Xilinx, Inc. ("Xilinx"), that is distributed under a license         **
--  **  from Xilinx, and may be used, copied and/or disclosed only           **
--  **  pursuant to the terms of a valid license agreement with Xilinx.      **
--  **                                                                       **
--  **  XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION                **
--  **  ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER           **
--  **  EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT                  **
--  **  LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,            **
--  **  MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx        **
--  **  does not warrant that functions included in the Materials will       **
--  **  meet the requirements of Licensee, or that the operation of the      **
--  **  Materials will be uninterrupted or error-free, or that defects       **
--  **  in the Materials will be corrected. Furthermore, Xilinx does         **
--  **  not warrant or make any representations regarding use, or the        **
--  **  results of the use, of the Materials in terms of correctness,        **
--  **  accuracy, reliability or otherwise.                                  **
--  **                                                                       **
--  **  Xilinx products are not designed or intended to be fail-safe,        **
--  **  or for use in any application requiring fail-safe performance,       **
--  **  such as life-support or safety devices or systems, Class III         **
--  **  medical devices, nuclear facilities, applications related to         **
--  **  the deployment of airbags, or any other applications that could      **
--  **  lead to death, personal injury or severe property or                 **
--  **  environmental damage (individually and collectively, "critical       **
--  **  applications"). Customer assumes the sole risk and liability         **
--  **  of any use of Xilinx products in critical applications,              **
--  **  subject only to applicable laws and regulations governing            **
--  **  limitations on product liability.                                    **
--  **                                                                       **
--  **  Copyright 2010 Xilinx, Inc.                                          **
--  **  All rights reserved.                                                 **
--  **                                                                       **
--  **  This disclaimer and copyright notice must be retained as part        **
--  **  of this file at all times.                                           **
--  ***************************************************************************
-------------------------------------------------------------------------------
-- Filename:        axi_uart16550.vhd
-- Version:         v2.0
-- Description:     This is the top level module for axi 16550 uart core.
--                  This module has interfaces to AXI Lite IPIF,
--                  Serial port and Modem and incorporates the logic for 
--                  UART 16550 core functionality and interfacing logic 
--                  for AXI.
--
-- VHDL-Standard:   VHDL'93
--
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_cmb" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------
-- axi_uart16550_v2_0_22 library is used for axi_uart16550_v2_0_22 
-- component declarations
-------------------------------------------------------------------------------
library axi_uart16550_v2_0_22;
    use axi_uart16550_v2_0_22.xuart;

-------------------------------------------------------------------------------
-- axi_lite_ipif_v2_0 library is used for AXI Lite IPIF 
-- component declarations
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- proc common package of the proc common library is used for different 
-- function declarations
-------------------------------------------------------------------------------
library axi_lite_ipif_v3_0_4;
-- SLV64_ARRAY_TYPE refered from ipif_pkg
use axi_lite_ipif_v3_0_4.ipif_pkg.SLV64_ARRAY_TYPE;
-- INTEGER_ARRAY_TYPE refered from ipif_pkg
use axi_lite_ipif_v3_0_4.ipif_pkg.INTEGER_ARRAY_TYPE;
    use axi_lite_ipif_v3_0_4.axi_lite_ipif;

-------------------------------------------------------------------------------
-- Definition of Generics :
-------------------------------------------------------------------------------
-- System generics
--    C_FAMILY              --  Xilinx FPGA Family
--    C_S_AXI_ACLK_FREQ_HZ  --  System clock frequency driving UART lite
--                              peripheral in Hz
--                          
-- AXI generics             
--    C_S_AXI_ADDR_WIDTH    --  Width of AXI Address Bus (in bits)
--    C_S_AXI_DATA_WIDTH    --  Width of the AXI Data Bus (in bits)
--
-- UART 16550 generics       
--    C_IS_A_16550          --  Selection of UART for 16450 or 16550 mode
--    C_HAS_EXTERNAL_XIN    --  External XIN
--    C_HAS_EXTERNAL_RCLK   --  External RCLK
--    C_EXTERNAL_XIN_CLK_HZ --  External XIN clock frequency
-------------------------------------------------------------------------------
-- Definition of Ports :
-------------------------------------------------------------------------------
-- System signals
--    s_axi_aclk          --  AXI Clock
--    s_axi_aresetn       --  AXI Reset
--    ip2intc_irpt        --  Device interrupt output to microprocessor 
--                            interrupt input or system interrupt controller.
--    freeze              --  Freezes UART for software debug (active high)
--                            
-- AXI signals                
--    s_axi_awaddr        --  AXI Write address
--    s_axi_awvalid       --  Write address valid
--    s_axi_awready       --  Write address ready
--    s_axi_wdata         --  Write data
--    s_axi_wstrb         --  Write strobes
--    s_axi_wvalid        --  Write valid
--    s_axi_wready        --  Write ready
--    s_axi_bresp         --  Write response
--    s_axi_bvalid        --  Write response valid
--    s_axi_bready        --  Response ready
--    s_axi_araddr        --  Read address
--    s_axi_arvalid       --  Read address valid
--    s_axi_arready       --  Read address ready
--    s_axi_rdata         --  Read data
--    s_axi_rresp         --  Read response
--    s_axi_rvalid        --  Read valid
--    s_axi_rready        --  Read ready
--
-- UART16550 interface signals
--    baudoutn            --  Transmitter Clock
--    rclk                --  Receiver 16x Clock
--    sin                 --  Serial Data Input
--    sout                --  Serial Data Output
--    xin                 --  Baud Rate Generator reference clock
--    xout                --  Inverted XIN
--    ctsn                --  Clear To Send (active low)
--    dcdn                --  Data Carrier Detect (active low)
--    dsrn                --  Data Set Ready (active low)
--    dtrn                --  Data Terminal Ready (active low)
--    rin                 --  Ring Indicator (active low)
--    rtsn                --  Request To Send (active low)
--    ddis                --  Driver Disable
--    out1n               --  User controlled output1
--    out2n               --  User controlled output2
--    rxrdyn              --  DMA control signal
--    txrdyn              --  DMA control signal
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------

entity axi_uart16550 is

  generic (

--  -- System Parameter
    C_FAMILY              : string                        := "virtex7";
    C_SIM_DEVICE          : string                        := "VERSAL_AI_CORE_ES1";
    C_S_AXI_ACLK_FREQ_HZ  : integer                       := 100_000_000;
--  -- AXI Parameters
    C_S_AXI_ADDR_WIDTH    : integer                       := 13;
    C_S_AXI_DATA_WIDTH    : integer range 32 to 128       := 32;
--  -- UARTLite Parameters
    C_IS_A_16550          : integer range 0 to 1          := 1;
    C_HAS_EXTERNAL_XIN    : integer range 0 to 1          := 0;
    C_HAS_EXTERNAL_RCLK   : integer range 0 to 1          := 0;
    C_EXTERNAL_XIN_CLK_HZ : integer                       := 25_000_000
   );
 
  port (
    -- System signals
    s_axi_aclk       : in  std_logic;
    s_axi_aresetn    : in  std_logic;
    ip2intc_irpt     : out std_logic;
    freeze           : in  std_logic;

-- AXI signals
    s_axi_awaddr     : in  std_logic_vector(12 downto 0);
    s_axi_awvalid    : in  std_logic;
    s_axi_awready    : out std_logic;
    s_axi_wdata      : in  std_logic_vector(31 downto 0);
    s_axi_wstrb      : in  std_logic_vector(3 downto 0);
    s_axi_wvalid     : in  std_logic;
    s_axi_wready     : out std_logic;
    s_axi_bresp      : out std_logic_vector(1 downto 0);
    s_axi_bvalid     : out std_logic;
    s_axi_bready     : in  std_logic;
    s_axi_araddr     : in  std_logic_vector(12 downto 0);
    s_axi_arvalid    : in  std_logic;
    s_axi_arready    : out std_logic;
    s_axi_rdata      : out std_logic_vector(31 downto 0);
    s_axi_rresp      : out std_logic_vector(1 downto 0);
    s_axi_rvalid     : out std_logic;
    s_axi_rready     : in  std_logic;

    -- UART16550 Interface Signals
    baudoutn         : out std_logic;
    ctsn             : in  std_logic;
    dcdn             : in  std_logic;
    ddis             : out std_logic;
    dsrn             : in  std_logic;
    dtrn             : out std_logic;
    out1n            : out std_logic;
    out2n            : out std_logic;
    rclk             : in  std_logic := '0';
    rin              : in  std_logic;
    rtsn             : out std_logic;
    rxrdyn           : out std_logic;
    sin              : in  std_logic;
    sout             : out std_logic;
    txrdyn           : out std_logic;
    xin              : in  std_logic := '0';
    xout             : out std_logic
);

  
  attribute SIGIS                       : string;             
  attribute SIGIS of rclk               : signal   is "CLK";  
  attribute SIGIS of xin                : signal   is "CLK";
  attribute SIGIS of ip2intc_irpt       : signal   is "INTERRUPT";

end entity axi_uart16550;

-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------
architecture rtl of axi_uart16550 is
-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";

 

  -----------------------------------------------------------------------------
    -- Constant Declarations
  -----------------------------------------------------------------------------
  constant  ZEROES                : std_logic_vector := X"00000000";

 
  constant UART_REG_BASEADDR  : std_logic_vector  := X"00000000" or X"00001000";
  constant UART_REG_HIGHADDR  : std_logic_vector  := X"00000000" or X"0000101F";
 
  constant ARD_ADDR_RANGE_ARRAY : SLV64_ARRAY_TYPE  :=
        (
         ZEROES & UART_REG_BASEADDR, -- Uart Reg Base Address
         ZEROES & UART_REG_HIGHADDR  -- Uart Reg High Address
        );

  constant ARD_NUM_CE_ARRAY     : INTEGER_ARRAY_TYPE :=
          (
           0 => 1   
          );

  constant AXI_MIN_SIZE       : std_logic_vector(31 downto 0) := X"0000001F";
  constant USE_WSTRB          : integer := 1;
  constant DPHASE_TIMEOUT     : integer := 0;

  -----------------------------------------------------------------------------
    -- Signal and Type Declarations
  -----------------------------------------------------------------------------
  signal bus2ip_clk_i     : std_logic;
  signal bus2ip_data_i    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal bus2ip_addr_i    : std_logic_vector(12 downto 0);
  signal bus2ip_reset_i   : std_logic;
  signal ip2bus_data_i    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal bus2ip_rdce_i    : std_logic_vector(0 downto 0);
  signal bus2ip_wrce_i    : std_logic_vector(0 downto 0);
  signal ip2bus_wrack_i   : std_logic;
  signal ip2bus_rdack_i   : std_logic;
  signal bus2ip_reset_int      : std_logic;
  signal bus2ip_reset_int_core : std_logic;

 
  -----------------------------------------------------------------------------
    -- Begin Architecture
  -----------------------------------------------------------------------------
    
  begin
  

  -----------------------------------------------------------------------------
  -- Component Instantiations
  -----------------------------------------------------------------------------

    --------------------------------------------------------------------------
    -- Instantiate AXI lite IPIF
    --------------------------------------------------------------------------
    AXI_LITE_IPIF_I : entity axi_lite_ipif_v3_0_4.axi_lite_ipif
      generic map
       (
        C_S_AXI_ADDR_WIDTH        => 13,
        C_S_AXI_DATA_WIDTH        => C_S_AXI_DATA_WIDTH,
        C_S_AXI_MIN_SIZE          => AXI_MIN_SIZE,
        C_USE_WSTRB               => USE_WSTRB,
        C_DPHASE_TIMEOUT          => DPHASE_TIMEOUT,
        C_ARD_ADDR_RANGE_ARRAY    => ARD_ADDR_RANGE_ARRAY,
        C_ARD_NUM_CE_ARRAY        => ARD_NUM_CE_ARRAY,
        C_FAMILY                  => C_FAMILY
       )
     port map
       (
        S_AXI_ACLK       => s_axi_aclk,
        S_AXI_ARESETN    => s_axi_aresetn,
        S_AXI_AWADDR     => s_axi_awaddr,
        S_AXI_AWVALID    => s_axi_awvalid,
        S_AXI_AWREADY    => s_axi_awready,
        S_AXI_WDATA      => s_axi_wdata,
        S_AXI_WSTRB      => s_axi_wstrb,
        S_AXI_WVALID     => s_axi_wvalid,
        S_AXI_WREADY     => s_axi_wready,
        S_AXI_BRESP      => s_axi_bresp,
        S_AXI_BVALID     => s_axi_bvalid,
        S_AXI_BREADY     => s_axi_bready,
        S_AXI_ARADDR     => s_axi_araddr,
        S_AXI_ARVALID    => s_axi_arvalid,
        S_AXI_ARREADY    => s_axi_arready,
        S_AXI_RDATA      => s_axi_rdata,
        S_AXI_RRESP      => s_axi_rresp,
        S_AXI_RVALID     => s_axi_rvalid,
        S_AXI_RREADY     => s_axi_rready,
     
     -- IP Interconnect (IPIC) port signals 
        Bus2IP_Clk       => bus2ip_clk_i,
        Bus2IP_Resetn    => bus2ip_reset_int,
        Bus2IP_Addr      => bus2ip_addr_i,
        Bus2IP_Data      => bus2ip_data_i,
        Bus2IP_RNW       => open,
        Bus2IP_BE        => open,
        Bus2IP_CS        => open,
        Bus2IP_RdCE      => bus2ip_rdce_i,
        Bus2IP_WrCE      => bus2ip_wrce_i,
        IP2Bus_Data      => ip2bus_data_i,
        IP2Bus_WrAck     => ip2bus_wrack_i,
        IP2Bus_RdAck     => ip2bus_rdack_i,
        IP2Bus_Error     => '0'
       );


      ----------------------
      --REG_RESET_FROM_IPIF: convert active low to active hig reset to rest of 
      --                     the core.
      ----------------------    
      REG_RESET_FROM_IPIF: process (s_axi_aclk) is
      begin
           if(s_axi_aclk'event and s_axi_aclk = '1') then
           bus2ip_reset_int_core <= not(bus2ip_reset_int);
           end if;
      end process REG_RESET_FROM_IPIF;

    --------------------------------------------------------------------------
    -- Instantiate UART16550
    --------------------------------------------------------------------------

    XUART_I_1 : entity axi_uart16550_v2_0_22.xuart
    generic map (
      C_IS_A_16550          => C_IS_A_16550 /= 0,         -- default TRUE
      C_HAS_EXTERNAL_XIN    => C_HAS_EXTERNAL_XIN /= 0,   -- default TRUE
      C_HAS_EXTERNAL_RCLK   => C_HAS_EXTERNAL_RCLK /= 0,  -- default TRUE
      C_EXTERNAL_XIN_CLK_HZ => C_EXTERNAL_XIN_CLK_HZ,
      C_FAMILY              => C_FAMILY,
      C_SIM_DEVICE          => C_SIM_DEVICE,
      C_S_AXI_CLK_FREQ_HZ   => C_S_AXI_ACLK_FREQ_HZ,
      AXI_ADDR_WIDTH        => 13,
      AXI_DATA_WIDTH        => C_S_AXI_DATA_WIDTH
      )
    port map (
      Bus2IP_Clk     => bus2ip_clk_i,
      Bus2IP_Reset   => bus2ip_reset_int_core,
      Bus2IP_Addr    => bus2ip_addr_i(4 downto 2),
      Bus2IP_Data    => bus2ip_data_i,
      Bus2IP_RdCE    => bus2ip_rdce_i(0),
      Bus2IP_WrCE    => bus2ip_wrce_i(0),
      IP2Bus_Data    => ip2bus_data_i,
      IP2Bus_WrAck   => ip2bus_wrack_i,
      IP2Bus_RdAck   => ip2bus_rdack_i,

      BaudoutN       => baudoutn,
      CtsN           => ctsn,
      DcdN           => dcdn,
      Ddis           => ddis,
      DsrN           => dsrn,
      DtrN           => dtrn,
      Out1N          => out1n,
      Out2N          => out2n,
      Rclk           => rclk,
      RiN            => rin,
      RtsN           => rtsn,
      RxrdyN         => rxrdyn,
      Sin            => sin,
      Sout           => sout,
      IP2INTC_Irpt   => ip2intc_irpt,
      TxrdyN         => txrdyn,
      Xin            => xin,
      Xout           => xout,
      Intr           => open,
      Freeze         => freeze
     );

      
end architecture rtl;


