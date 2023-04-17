----------------------------------------------------------
--
--! @title One-digit custom 7-segment display decoder
--! @author Vojtech Tlamka, Vojtech Kuchar
--! Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
--!
--! @copyright (c) 2023 Vojtech Tlamka, Vojtech Kuchar
--! This work is licensed under the terms of the MIT license
--!
--! Decoder for one-digit Seven-segment display, Common Anode
--! (active-low). Decoder defines 16 hexadecimal symbols
--! as follows: 0, 1, ..., 9, A, L, P, t, S, <blank>.
--! All segments are also turn off when "blank" is high.
--! Decimal Point is not implemented.
--
-- Hardware: Nexys A7-50T, xc7a50ticsg324-1L
-- Software: TerosHDL, Vivado 2020.2, EDA Playground
--
----------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

entity hex_7seg is
  port (
    blank : in    std_logic;                    --! Display is clear if blank = 1
    hex   : in    std_logic_vector(3 downto 0); --! Binary representation of one hexadecimal symbol
    seg   : out   std_logic_vector(6 downto 0)  --! Seven active-low segments in the order: a, b, ..., g
  );
end entity hex_7seg;

architecture behavioral of hex_7seg is

begin
  --------------------------------------------------------
  -- p_7seg_decoder:
  -- A combinational process for 7-segment display (Common
  -- Anode) decoder. Any time "hex" or "blank" is changed,
  -- the process is "executed". Output pin seg(6) controls
  -- segment A, seg(5) segment B, etc.
  --
  -- Display is clear/blank if signal blank = 1.
  --------------------------------------------------------

  p_7seg_decoder : process (blank, hex) is
  
  begin

    if (blank = '1') then
      seg <= "1111111";     -- Blank display
	  
    else
      case hex is

        when "0000" =>
          seg <= "0000001"; -- 0

        when "0001" =>
          seg <= "1001111"; -- 1
        
        when "0010" =>        
          seg <= "0010010"; -- 2

        when "0011" =>        
          seg <= "0000110"; -- 3
          
        when "0100" =>        
          seg <= "1001100"; -- 4
          
        when "0101" =>        
          seg <= "0100100"; -- 5
          
        when "0110" =>        
          seg <= "0100000"; -- 6
          
        when "0111" =>        
          seg <= "0001111"; -- 7

        when "1000" =>
          seg <= "0000000"; -- 8
        
        when "1001" =>        
          seg <= "0000100"; -- 9
          
        when "1010" =>        
          seg <= "0001000"; -- A

        when "1011" =>        
          seg <= "1110001"; -- L
          
        when "1100" =>        
          seg <= "0011000"; -- P
          
        when "1101" =>        
          seg <= "1110000"; -- t

        when "1110" =>
          seg <= "0100100"; -- S

        when "1111" =>
          seg <= "1111111"; -- Blank

        when others =>
          seg <= "1111111"; -- Blank

      end case;
    end if;

  end process p_7seg_decoder;
end architecture behavioral;
