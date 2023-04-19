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
--   dig0..3(3:0) -- HEX values for individual digits
--
----------------------------------------------------------

entity state_to_digits is
  port (
    lapn     : in    integer;
    state    : in    integer;
    dig0     : out   std_logic_vector(3 downto 0);
    dig1     : out   std_logic_vector(3 downto 0);
    dig2     : out   std_logic_vector(3 downto 0);
    dig3     : out   std_logic_vector(3 downto 0)
  );
end entity state_to_digits;


architecture behavioral of state_to_digits is

begin

  p_state_to_digits : process (clk) is
  begin
	
	-- showing blank display
	if(state = 0) then
	  dig0 <= 15;
	  dig1 <= 15;
	  dig2 <= 15;
	  dig3 <= 15;
	
	-- showing lap number
	elsif(state = 1 || state = 2)
	  dig0 <= 15; -- first position BLANK
	  
	  -- showing LAP
	  if (state = 1)
	    dig1 <= 11;
		
	  -- showing PAUSE
	  elsif (state = 2)
	    dig1 <= 12;
		
	  end if;
	  
	  -- lap/pause number itself
	  dig2 <= std_logic_vector(to_unsigned((lapn / 10) mod 10, 4));
	  dig3 <= std_logic_vector(to_unsigned((lapn) mod 10, 4));
	
	-- showing LAP TIME
	elsif(state = 3)
	  dig0 <= 15; -- blank
	  dig1 <= 11; -- L
	  dig2 <= 13; -- t
	  dig3 <= 15; -- blank
	
	-- showing PAUSE TIME
	elsif(state = 4)
	  dig0 <= 15; -- blank
	  dig1 <= 12; -- P
	  dig2 <= 13; -- t
	  dig3 <= 15; -- blank
	
	-- showing LAP COUNT
	elsif(state = 5)
	  dig0 <= 11; -- L
	  dig1 <= 10; -- A
	  dig2 <= 12; -- P
	  dig3 <= 14; -- S
	
	end if;

  end process p_state_to_digits;

end architecture behavioral;
