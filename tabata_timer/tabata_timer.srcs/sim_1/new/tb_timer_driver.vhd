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

entity tb_timer_driver is
  -- Entity of testbench is always empty
end entity tb_timer_driver;

----------------------------------------------------------
-- Architecture body for testbench
----------------------------------------------------------

architecture testbench of tb_timer_driver is

  -- Local constants
  constant c_CLK_100MHZ_PERIOD : time := 10 ns;

  -- Local signals
  signal  sig_enable : std_logic;
  signal  sig_clk_100mhz : std_logic;
  signal  sig_btnc : std_logic;
  signal  sig_lap_n : integer;
  signal  sig_bl_vect : std_logic_vector(7 downto 0);
  signal  sig_sel_st : integer;
  signal  sig_num_val : std_logic_vector(7 downto 0);
  signal  sig_val_t : std_logic;

begin

  -- Connecting testbench signals with tlc entity
  -- (Unit Under Test)
  uut_timer_driver : entity work.timer_driver
    port map (
      enable   => sig_enable,
      clk      => sig_clk_100mhz,
      l_t      => 11,
      p_t      => 7,
      laps     => 3,
      btnc     => sig_btnc,
      lap_n    => sig_lap_n,
      bl_vect  => sig_bl_vect,
      sel_st   => sig_sel_st,
      num_val  => sig_num_val,
      val_t    => sig_val_t
    );

  --------------------------------------------------------
  -- Clock generation process
  --------------------------------------------------------
  p_clk_gen : process is
  begin

    while now < 10000 ns loop -- 10 usec of simulation

      sig_clk_100mhz <= '0';
      wait for c_CLK_100MHZ_PERIOD / 2;
      sig_clk_100mhz <= '1';
      wait for c_CLK_100MHZ_PERIOD / 2;

    end loop;

    wait;

  end process p_clk_gen;

  --------------------------------------------------------
  -- Reset generation process
  --------------------------------------------------------
  p_enable_gen : process is
  begin

    sig_enable <= '0';
    wait for 40 ns;

    -- Reset activated
    sig_enable <= '1';
    wait for 800 ns;

    -- Reset deactivated
    sig_enable <= '0';
    wait;

  end process p_enable_gen;

  --------------------------------------------------------
  -- Reset generation process
  --------------------------------------------------------
  p_btnc_gen : process is
  begin

    sig_btnc <= '0';
    wait for 200 ns;

    -- Reset activated
    sig_btnc <= '1';
    wait for 30 ns;

    -- Reset deactivated
    sig_btnc <= '0';
    wait;

  end process p_btnc_gen;

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
