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
    clk     : in    std_logic;   -- main clock 100 MHz
    rst     : in    std_logic;   -- reset signal
    bl_vect : in    std_logic_vector(7 downto 0);  -- blicking segments vector
    lap_n   : in    integer;     -- number of current lap/pause
	state   : in    integer;     -- left 4-digits state
		-- 0 -> blank
		-- 1 -> lap display
		-- 2 -> pause display
		-- 3 -> lap time
		-- 4 -> pause time
		-- 5 -> lap count
	num_val : in    std_logic_vector(9 downto 0) := (others => '0');  -- value to display
	val_t   : in    std_logic;    -- type of num_val (time / lap count)
		-- 0 -> time value
		-- 1 -> number value
    seg_out_dp    : out   std_logic := '1';		-- 3 outputs to physical 7-segment display
    seg_out_seg   : out   std_logic_vector(6 downto 0) := (others => '1');
    seg_out_anode : out   std_logic_vector(7 downto 0) := (others => '1')
);
end entity display_driver;


architecture behavioral of display_driver is

	-- non-blicking output signals
    signal sig_dig0          : std_logic_vector(3 downto 0) := (others => '1');
    signal sig_dig1          : std_logic_vector(3 downto 0) := (others => '1');
    signal sig_dig2          : std_logic_vector(3 downto 0) := (others => '1');
    signal sig_dig3          : std_logic_vector(3 downto 0) := (others => '1');
    signal sig_dig4          : std_logic_vector(3 downto 0) := (others => '1');
    signal sig_dig5          : std_logic_vector(3 downto 0) := (others => '1');
    signal sig_dig6          : std_logic_vector(3 downto 0) := (others => '1');
    signal sig_dig7          : std_logic_vector(3 downto 0) := (others => '1');
    signal sig_dp_vect       : std_logic_vector(7 downto 0) := (others => '1');
	-- blicking output signals
    signal sig_dig0_disp     : std_logic_vector(3 downto 0) := (others => '1');
    signal sig_dig1_disp     : std_logic_vector(3 downto 0) := (others => '1');
    signal sig_dig2_disp     : std_logic_vector(3 downto 0) := (others => '1');
    signal sig_dig3_disp     : std_logic_vector(3 downto 0) := (others => '1');
    signal sig_dig4_disp     : std_logic_vector(3 downto 0) := (others => '1');
    signal sig_dig5_disp     : std_logic_vector(3 downto 0) := (others => '1');
    signal sig_dig6_disp     : std_logic_vector(3 downto 0) := (others => '1');
    signal sig_dig7_disp     : std_logic_vector(3 downto 0) := (others => '1');
    signal sig_dp_vect_disp  : std_logic_vector(7 downto 0) := (others => '1');
    
    begin
    
	-- logcial value to actual data conversion for implementation
    state_to_digits : entity work.state_to_digits
        port map (
            lapn  => lap_n,
            state => state,
            dig0  => sig_dig0,
            dig1  => sig_dig1,
            dig2  => sig_dig2,
            dig3  => sig_dig3
        );
        
	-- logcial value to actual data conversion for implementation
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
        
	-- entity blicking the sig_digX to sig_digX_disp
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
            data0_out    => sig_dig0_disp,
            data1_out    => sig_dig1_disp,
            data2_out    => sig_dig2_disp,
            data3_out    => sig_dig3_disp,
            data4_out    => sig_dig4_disp,
            data5_out    => sig_dig5_disp,
            data6_out    => sig_dig6_disp,
            data7_out    => sig_dig7_disp,
            dp_vect_out  => sig_dp_vect_disp
        );
    
	-- actual value displayer - outputs back to the top to connect
	-- to physical 7-segment display
    driver_7seg_8digits : entity work.driver_7seg_8digits
        port map (
            clk     => clk,
            rst     => rst,
            data0   => sig_dig0_disp,
            data1   => sig_dig1_disp,
            data2   => sig_dig2_disp,
            data3   => sig_dig3_disp,
            data4   => sig_dig4_disp,
            data5   => sig_dig5_disp,
            data6   => sig_dig6_disp,
            data7   => sig_dig7_disp,
            dp_vect => sig_dp_vect_disp,
            dp      => seg_out_dp,
            seg     => seg_out_seg,
            dig     => seg_out_anode
        );
end architecture behavioral;