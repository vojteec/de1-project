----------------------------------------------------------
--
--! @title N-bit Up/Down binary counter
--! @author Tomas Fryza
--! Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
--!
--! @copyright (c) 2019 Tomas Fryza
--! This work is licensed under the terms of the MIT license
--!
--! Implementation of bidirectional N-bit counter. Number
--! of bits is set by `g_CNT_WIDTH` and counting direction
--! by `cnt_up` input.
--
-- Hardware: Nexys A7-50T, xc7a50ticsg324-1L
-- Software: TerosHDL, Vivado 2020.2, EDA Playground
--
----------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all; 

----------------------------------------------------------
-- Entity declaration for N-bit counter
----------------------------------------------------------

entity dec_bin_converter is
  port (
    dec    : in    INTEGER; --! Main clock
    bin    : out   std_logic_vector(9 downto 0) --! Starting counter value
  );
end entity dec_bin_converter;

----------------------------------------------------------
-- Architecture body for N-bit counter
----------------------------------------------------------

architecture behavioral of dec_bin_converter is

begin

  -- Output must be retyped from "unsigned" to "std_logic_vector"
  bin <= std_logic_vector(TO_UNSIGNED(dec, 10));

end architecture behavioral;
