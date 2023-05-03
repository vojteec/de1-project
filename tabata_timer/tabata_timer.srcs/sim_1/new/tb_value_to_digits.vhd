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

entity tb_value_to_digits is
  -- Entity of testbench is always empty
end entity tb_value_to_digits;

----------------------------------------------------------
-- Architecture body for testbench
----------------------------------------------------------

architecture testbench of tb_value_to_digits is

  -- Local signals
  signal sig_val_t      : std_logic;
  signal sig_dig3       : std_logic_vector(3 downto 0);
  signal sig_dig2       : std_logic_vector(3 downto 0);
  signal sig_dig1       : std_logic_vector(3 downto 0);
  signal sig_dig0       : std_logic_vector(3 downto 0);
  signal sig_dp_vect    : std_logic_vector(7 downto 0);

begin

  -- Connecting testbench signals with tlc entity
  -- (Unit Under Test)
  uut_value_to_digits : entity work.value_to_digits
    port map (
      val_t		=> sig_val_t,
      val  		=> std_logic_vector(to_unsigned(81), 10),
      dig3 		=> sig_dig3,
      dig2 		=> sig_dig2,
      dig1 		=> sig_dig1,
      dig0 		=> sig_dig0,
      dp_vect	=> sig_dp_vect
    );

  --------------------------------------------------------
  -- Reset generation process
  --------------------------------------------------------
  p_val_t_gen : process is
  begin

    sig_val_t <= '0';
    wait for 200 ns;

    -- Reset activated
    sig_val_t <= '1';
    wait for 500 ns;

    -- Reset deactivated
    sig_val_t <= '0';
    wait;

  end process p_val_t_gen;

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
