----------------------------------------------------------
--
--! @title Converter for blicking digital display 
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
-- Entity declaration for display blicker
--
-- Inputs:
--   clk             -- Main clock
--   bl_vect		 -- Idividual digits blicking state
--     -- 0        -> static
--     -- 1        -> blicking
--     -- 11111111 -> clock mode (only central clock dp blicking)
--   dataX_in(3:0)   -- Input data values for individual digits
--   dp_vect_in(7:0) -- Input decimal points for individual digits
--
-- Outputs:
--   dataX_out(3:0)   -- Output data values for individual digits
--   dp_vect_out(7:0) -- Output decimal points for individual digits
--
----------------------------------------------------------

entity blicker is
  port (
    clk         : in    std_logic;
    bl_vect     : in    std_logic_vector(7 downto 0);
    data0_in    : in    std_logic_vector(3 downto 0);
    data1_in    : in    std_logic_vector(3 downto 0);
    data2_in    : in    std_logic_vector(3 downto 0);
    data3_in    : in    std_logic_vector(3 downto 0);
    data4_in    : in    std_logic_vector(3 downto 0);
    data5_in    : in    std_logic_vector(3 downto 0);
    data6_in    : in    std_logic_vector(3 downto 0);
    data7_in    : in    std_logic_vector(3 downto 0);
    dp_vect_in  : in    std_logic_vector(7 downto 0);
    data0_out   : out   std_logic_vector(3 downto 0);
    data1_out   : out   std_logic_vector(3 downto 0);
    data2_out   : out   std_logic_vector(3 downto 0);
    data3_out   : out   std_logic_vector(3 downto 0);
    data4_out   : out   std_logic_vector(3 downto 0);
    data5_out   : out   std_logic_vector(3 downto 0);
    data6_out   : out   std_logic_vector(3 downto 0);
    data7_out   : out   std_logic_vector(3 downto 0);
    dp_vect_out : out   std_logic_vector(7 downto 0)
  );
end entity blicker;


architecture behavioral of blicker is

  -- Internal clock enable
  signal sig_en_500ms : std_logic;
  -- Internal boolean to indicate whether the segments are currently blank
  signal blank : std_logic := '0';

begin

  --------------------------------------------------------
  -- Generating enable pulse every 500 ms
  --------------------------------------------------------
  clk_en0 : entity work.clock_enable
    generic map (
       g_MAX => 50000000  -- @ 500 ms IMPLEMENTATION
      --g_MAX => 4       -- @ 4 ns SIMULATION
    )
    port map (
      clk => clk,
      rst => '0',
      ce  => sig_en_500ms
    );

  --------------------------------------------------------
  -- Blicking selected segment(s) with 500 ms period
  --------------------------------------------------------
  p_blicker : process (clk) is
  begin

    if (rising_edge(clk)) then
  
	  -- creating default state
	  data0_out <= data0_in;
	  data1_out <= data1_in;
	  data2_out <= data2_in;
	  data3_out <= data3_in;
	  data4_out <= data4_in;
	  data5_out <= data5_in;
	  data6_out <= data6_in;
	  data7_out <= data7_in;
	  dp_vect_out <= dp_vect_in;
	
	  -- clock mode
	  -- blicking central decimal point for clock
	  if (bl_vect = "11111111") then
	    if (blank = '1') then
		  dp_vect_out(2) <= '1';
		end if;
	
	  -- blanking individual segments if blank is active
	  -- if (blank = '0') then we keep the default values
      elsif (blank = '1') then
	    
		if(bl_vect(7) = '1') then
		  data7_out <= "1111";
		end if;
		if(bl_vect(6) = '1') then
		  data6_out <= "1111";
		end if;
		if(bl_vect(5) = '1') then
		  data5_out <= "1111";
		end if;
		if(bl_vect(4) = '1') then
		  data4_out <= "1111";
		end if;
		if(bl_vect(3) = '1') then
		  data3_out <= "1111";
		end if;
		if(bl_vect(2) = '1') then
		  data2_out <= "1111";
		end if;
		if(bl_vect(1) = '1') then
		  data1_out <= "1111";
		end if;
		if(bl_vect(0) = '1') then
		  data0_out <= "1111";
		end if;

      end if;
	
	  -- inverting 'blank status' signal every 500 ms
	  if (sig_en_500ms = '1') then
	      
	      if(blank = '0') then
	  	    blank <= '1';
	      
	      elsif(blank = '1') then
	  	    blank <= '0';
	      
	      end if;
	  end if;
    end if;

  end process p_blicker;

end architecture behavioral;
