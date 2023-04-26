----------------------------------------------------------
--
--! @title Converter from integer value representing current
--! application state to numbers for digits to display
--! @author Vojtech Tlamka
--! Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
--!
--! @copyright (c) 2023 Vojtech Tlamka
--! This work is licensed under the terms of the MIT license
--
-- Hardware: Nexys A7-50T, xc7a50ticsg324-1L
-- Software: TerosHDL, Vivado 2020.2, EDA Playground
--
----------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

----------------------------------------------------------
-- Entity declaration for state to digit converter
-- Inputs:
--   lapn         -- Number of current lap/pause
--   state        -- Actual value to be converted
--     -- 0 -> blank display
--     -- 1 -> lap
--     -- 2 -> pause
--     -- 3 -> lap time
--     -- 4 -> pause time
--     -- 5 -> number of laps
--
-- Outputs:
--   dig7..4(3:0) -- HEX values for individual digits
--
----------------------------------------------------------

entity state_to_digits is
  port (
    lapn     : in    integer;
    state    : in    integer;
    dig7     : out   std_logic_vector(3 downto 0);
    dig6     : out   std_logic_vector(3 downto 0);
    dig5     : out   std_logic_vector(3 downto 0);
    dig4     : out   std_logic_vector(3 downto 0)
  );
end entity state_to_digits;


architecture behavioral of state_to_digits is

begin

  p_state_to_digits : process (lapn, state) is
  begin
	
	-- showing blank display
	if(state = 0) then
	  dig7 <= "1111";
	  dig6 <= "1111";
	  dig5 <= "1111";
	  dig4 <= "1111";
	
	-- showing lap number
	elsif(state = 1 OR state = 2) then
	  dig7 <= "1111"; -- first position BLANK
	  
	  -- showing LAP
	  if (state = 1) then
	    dig6 <= "1011";
		
	  -- showing PAUSE
	  elsif (state = 2) then
	    dig6 <= "1100";
		
	  end if;
	  
	  -- lap/pause number itself
	  dig5 <= std_logic_vector(to_unsigned((lapn / 10) mod 10, 4));
	  dig4 <= std_logic_vector(to_unsigned((lapn) mod 10, 4));
	
	-- showing LAP TIME
	elsif(state = 3) then
	  dig7 <= "1111"; -- blank
	  dig6 <= "1011"; -- L
	  dig5 <= "1101"; -- t
	  dig4 <= "1111"; -- blank
	
	-- showing PAUSE TIME
	elsif(state = 4) then
	  dig7 <= "1111"; -- blank
	  dig6 <= "1100"; -- P
	  dig5 <= "1101"; -- t
	  dig4 <= "1111"; -- blank
	
	-- showing LAP COUNT
	elsif(state = 5) then
	  dig7 <= "1011"; -- L
	  dig6 <= "1010"; -- A
	  dig5 <= "1100"; -- P
	  dig4 <= "1110"; -- S
	
	end if;

  end process p_state_to_digits;

end architecture behavioral;
