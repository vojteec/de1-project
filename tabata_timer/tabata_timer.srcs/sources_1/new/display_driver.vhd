----------------------------------------------------------
--
--! @title Display driver for tabata timer
--! @author Vojtech Kuchar
--! Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
--!
--! @copyright (c) 2023 Vojtech Kuchar
--! This work is licensed under the terms of the MIT license
--
-- Hardware: Nexys A7-50T, xc7a50ticsg324-1L
-- Software: TerosHDL, Vivado 2020.2, EDA Playground
--
----------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity display_driver is
  port (
    clk     : in    std_logic;   -- counter for managing push button treshold
    rst     : in    std_logic;   -- reset button
    act_l_t : in    integer;     -- stored lap time in seconds
    act_p_t : in    integer;     -- stored pause time in seconds
    bl_vect : in    std_logic_vector(7 downto 0) := "11110000";  -- blicking segments vector
	sel_st  : in   integer := 3;     -- menu option switch
		-- 0 -> blank
		-- 3 -> lap time
		-- 4 -> pause time
		-- 5 -> lap count
	num_val : in    std_logic_vector(9 downto 0);  -- number value
	val_t   : in    std_logic := '0';    -- type of num_val (time / lap count)
		-- 0 -> time value
		-- 1 -> number value
    dp      : out   std_logic;
    seg     : out   std_logic_vector(6 downto 0);
    dig     : out   std_logic_vector(7 downto 0)
);
end entity display_driver;


architecture behavioral of display_driver is

    signal sig_dig0     : std_logic_vector(3 downto 0);
    signal sig_dig1     : std_logic_vector(3 downto 0);
    signal sig_dig2     : std_logic_vector(3 downto 0);
    signal sig_dig3     : std_logic_vector(3 downto 0);
    signal sig_dig4     : std_logic_vector(3 downto 0);
    signal sig_dig5     : std_logic_vector(3 downto 0);
    signal sig_dig6     : std_logic_vector(3 downto 0);
    signal sig_dig7     : std_logic_vector(3 downto 0);
    signal sig_dp_vect  : std_logic_vector(7 downto 0);
    
    begin
    
    state_to_digits : entity work.state_to_digits
        port map (
            lapn  => act_l_t,
            state => sel_st,
            dig0  => sig_dig0,
            dig1  => sig_dig1,
            dig2  => sig_dig2,
            dig3  => sig_dig3
        );
        
    value_to_digits : entity work.value_to_digits
        port map (
            val_t   => val_t,
            val     => num_val,
            dig4    => sig_dig4,
            dig5    => sig_dig5,
            dig6    => sig_dig6,
            dig7    => sig_dig7,
            dp_vect => sig_dp_vect
        );
        
    blicker : entity work.blicker
        port map (
            clk          => clk,
            rst          => rst,
            bl_vect      => bl_vect,
            data0_in     => sig_dig0,
            data1_in     => sig_dig1,
            data2_in     => sig_dig2,
            data3_in     => sig_dig3,
            data4_in     => sig_dig4,
            data5_in     => sig_dig5,
            data6_in     => sig_dig6,
            data7_in     => sig_dig7,
            dp_vect_in   => sig_dp_vect,
            data0_out    => sig_dig0,
            data1_out    => sig_dig1,
            data2_out    => sig_dig2,
            data3_out    => sig_dig3,
            data4_out    => sig_dig4,
            data5_out    => sig_dig5,
            data6_out    => sig_dig6,
            data7_out    => sig_dig7,
            dp_vect_out  => sig_dp_vect
        );
        
    driver_7seg_8digits : entity work.driver_7seg_8digits
        port map (
            clk     => clk,
            rst     => rst,
            data0   => sig_dig0,
            data1   => sig_dig1,
            data2   => sig_dig2,
            data3   => sig_dig3,
            data4   => sig_dig4,
            data5   => sig_dig5,
            data6   => sig_dig6,
            data7   => sig_dig7,
            dp_vect => sig_dp_vect,
            dp      => dp,
            seg     => seg,
            dig     => dig
        );
end architecture behavioral;