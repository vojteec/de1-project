----------------------------------------------------------
--
-- Template for traffic lights controller testbench.
-- Nexys A7-50T, xc7a50ticsg324-1L
-- TerosHDL, Vivado v2020.2, EDA Playground
--
-- Copyright (c) 2020 Tomas Fryza
-- Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
----------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

----------------------------------------------------------
-- Entity declaration for testbench
----------------------------------------------------------

entity tb_mode_switch is
  -- Entity of testbench is always empty
end entity tb_mode_switch;

----------------------------------------------------------
-- Architecture body for testbench
----------------------------------------------------------

architecture testbench of tb_mode_switch is

  -- Local constants
  constant c_CLK_100MHZ_PERIOD : time := 10 ns;

  -- Local signals
  signal sig_switch_button : std_logic;
  signal sig_bl_vect       : std_logic_vector(7 downto 0);
  signal sig_sel_st        : integer;
  signal sig_num_val       : std_logic_vector(9 downto 0);
  signal sig_timer_enable  : std_logic;
  signal sig_menu_enable   : std_logic;
  signal sig_val_t         : std_logic;

begin

  -- Connecting testbench signals with tlc entity
  -- (Unit Under Test)
  uut_mode_switch : entity work.mode_switch
    port map (
	switch_button <= sig_switch_button,
	menu_bl_vect <= "00101101",
	menu_sel_st  <= 3,
	menu_num_val  <= "1101010010",
	menu_val_t  <= '1',
	timer_bl_vect <= "11111111",
	timer_sel_st  <= 1,
	timer_num_val <= "1100110011",
	timer_val_t  <= '0',
	bl_vect <= sig_bl_vec,
	sel_st <= sig_sel_st,
	num_val <= sig_num_val,
	timer_enable <= sig_timer_enable,
	menu_enable <= sig_menu_enable,
    val_t <= sig_val_t
	);

  --------------------------------------------------------
  -- Clock generation process
  --------------------------------------------------------
  p_switch_button_gen : process is
  begin
  
      sig_switch_button <= '0';
      wait for 40 ns;
      sig_switch_button <= '1';
      wait for 90 ns;
      sig_switch_button <= '0';
      wait for 250 ns;
      sig_switch_button <= '1';
      wait;

    wait;

  end process p_switch_button_gen;
  
  --------------------------------------------------------
  -- Data generation process
  --------------------------------------------------------
  p_stimulus : process is
  begin

    report "Stimulus process started";
    -- No other input data is needed.
    report "Stimulus process finished";
    wait;

  end process p_stimulus;

end architecture testbench;
