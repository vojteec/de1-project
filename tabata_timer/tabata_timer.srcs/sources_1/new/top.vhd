----------------------------------------------------------
--
--! @title TOP level design for tabata timer
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

entity top is
    Port ( CLK100MHZ : in STD_LOGIC;
           -- not being used yet
		   BTNC : in STD_LOGIC;
           BTNU : in STD_LOGIC;
           BTND : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           BTNR : in STD_LOGIC;
		   -- to implement / menu-timer switch
           --SW   : in STD_LOGIC;
           CA   : out STD_LOGIC;
           CB   : out STD_LOGIC;
           CC   : out STD_LOGIC;
           CD   : out STD_LOGIC;
           CE   : out STD_LOGIC;
           CF   : out STD_LOGIC;
           CG   : out STD_LOGIC;
           DP   : out STD_LOGIC;
           AN   : out STD_LOGIC_VECTOR (7 downto 0));
end top;


architecture behavioral of top is

  -- local settings storage
  -- default values after power on set
  signal local_l_t : integer := 300;
  signal local_p_t : integer := 30;
  signal local_laps : integer := 5;
  
  -- returned values from menu
  signal ret_l_t : integer := 300;
  signal ret_p_t : integer := 30;
  signal ret_laps : integer := 5;
  
  -- signals for display_driver inputs from menu and timer driver
  signal bl_vect_sig : std_logic_vector(7 downto 0) := (others => '0');
  signal state_sig   : integer := 1;
  signal value_sig   : std_logic_vector(9 downto 0) := (others => '0');
  signal val_t_sig   : std_logic := '0';

begin

  menu_driver : entity work.menu_driver
	port map (
		clk      => CLK100MHZ,
		l_t      => local_l_t,
		p_t      => local_p_t,
		laps     => local_laps,
		btnl     => BTNL,
		btnr     => BTNR,
		btnu     => BTNU,
		btnd     => BTND,
		bl_vect  => bl_vect_sig,
		sel_st   => state_sig,
		num_val  => value_sig,
		val_t    => val_t_sig,
		l_t_o    => ret_l_t,
		p_t_o    => ret_p_t,
		laps_o   => ret_laps
	);
	
  display_driver : entity work.display_driver
	port map (
		clk         => CLK100MHZ,
		bl_vect     => bl_vect_sig,
		lap_n       => 0, -- to implement with timer_driver
		state       => state_sig,
		num_val     => value_sig,
		val_t       => val_t_sig,
		seg_out_dp  => DP,
		seg_out_seg(6) => CA,
		seg_out_seg(5) => CB,
		seg_out_seg(4) => CC,
		seg_out_seg(3) => CD,
		seg_out_seg(2) => CE,
		seg_out_seg(1) => CF,
		seg_out_seg(0) => CG,
		seg_out_anode(7 downto 0) => AN(7 downto 0)
	);

  -- setting local values to set values
  local_l_t  <= ret_l_t;
  local_p_t  <= ret_p_t;
  local_laps <= ret_laps;

end architecture behavioral;
