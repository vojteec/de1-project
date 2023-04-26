----------------------------------------------------------
--
--! @title Converter from integer value to numbers for digits
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
-- Entity declaration for value to digit converter
-- Inputs:
--   valt         -- Type of input value
--     -- 0 -> time value
--     -- 1 -> number value
--   val          -- Actual value to be converted
--     -- valt=0 -> number of seconds
--     -- valt=1 -> decimal value to show
--
-- Outputs:
--   dig3..0(3:0) -- HEX values for individual digits
--   dp_vect      -- Vector of enabled decimal points
--
----------------------------------------------------------

entity value_to_digits is
  port (
    val_t    : in    std_logic;
    val      : in    std_logic_vector(9 downto 0);
    dig3     : out   std_logic_vector(3 downto 0);
    dig2     : out   std_logic_vector(3 downto 0);
    dig1     : out   std_logic_vector(3 downto 0);
    dig0     : out   std_logic_vector(3 downto 0);
    dp_vect  : out   std_logic_vector(7 downto 0)
  );
end entity value_to_digits;


architecture behavioral of value_to_digits is

	-- Retyping input value to integer
	signal int_val : integer := to_integer(unsigned(val));

begin

  p_value_to_digits : process (val, val_t) is
  begin
	
	-- showing time
	if(val_t = '0') then
	
	  dig3 <= std_logic_vector(to_unsigned((int_val / 600) mod 10, 4));
	  dig2 <= std_logic_vector(to_unsigned((int_val / 60) mod 10, 4));
	  dig1 <= std_logic_vector(to_unsigned(((int_val - ((int_val / 600) mod 10) * 600 - ((int_val / 60) mod 10) * 60) / 10) mod 10, 4));
	  dig0 <= std_logic_vector(to_unsigned(((int_val - ((int_val / 600) mod 10) * 600 - ((int_val / 60) mod 10) * 60)) mod 10, 4));
	  
	  -- if on "tens of minutes" is 0 to be displayed
	  if((int_val / 600) mod 10 = 0) then
	  	dig3 <= "1111";       -- make it blank = don't show the redundant 0
		    -- x16 is blank digit in our 7-seg driver
	  end if;
	  
	  dp_vect <= "11111011";
	
	
	-- showing decimal value (= number of laps)
	elsif (val_t = '1') then
	  dig3 <= std_logic_vector(to_unsigned((int_val / 1000) mod 10, 4));
	  dig2 <= std_logic_vector(to_unsigned((int_val / 100) mod 10, 4));
	  dig1 <= std_logic_vector(to_unsigned((int_val / 10) mod 10, 4));
	  dig0 <= std_logic_vector(to_unsigned((int_val) mod 10, 4));
	  
	  -- don't show redundant zeroes for decimal value
	  if(int_val < 10) then
		dig3 <= "1111";
		dig2 <= "1111";
		dig1 <= "1111";
		
	  elsif(int_val < 100) then
		dig3 <= "1111";
		dig2 <= "1111";
		
	  elsif(int_val < 1000) then
		dig3 <= "1111";
	  end if;
	  
	  dp_vect <= (others => '1');
	
	end if;
  end process p_value_to_digits;

end architecture behavioral;
