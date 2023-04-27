----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2023 02:20:02 PM
-- Design Name: 
-- Module Name: mode_switch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mode_switch is
  Port (
        switch_button : in std_logic := '0';
            -- 1 -> menu
            -- 2 -> timer
		menu_bl_vect  : in std_logic_vector(7 downto 0) := (others => '0');
		menu_sel_st   : in integer := 1;
		menu_num_val  : in std_logic_vector(9 downto 0) := (others => '0');
		menu_val_t    : in std_logic := '0';
		timer_bl_vect : in std_logic_vector(7 downto 0) := (others => '0');
		timer_sel_st  : in integer := 1;
		timer_num_val : in std_logic_vector(9 downto 0) := (others => '0');
		timer_val_t   : in std_logic := '0';
		bl_vect : out std_logic_vector(7 downto 0) := (others => '0');
		sel_st  : out integer := 1;
		num_val : out std_logic_vector(9 downto 0) := (others => '0');
		timer_enable  : out std_logic := '1';
		menu_enable   : out std_logic := '0';
		val_t   : out std_logic := '0'  
  );
end mode_switch;

architecture Behavioral of mode_switch is
    signal bl_vect_signal : std_logic_vector(7 downto 0) := timer_bl_vect;
    signal sel_st_signal  : integer := timer_sel_st;
    signal num_val_signal : std_logic_vector(9 downto 0) := timer_num_val;
    signal val_t_signal   : std_logic := timer_val_t;
    
begin
p_switch : process (switch_button) is
  begin
            -- MENU
    if (switch_button = '1') then
        bl_vect_signal <= menu_bl_vect;
        sel_st_signal <= menu_sel_st;
        num_val_signal <= menu_num_val;
        val_t_signal <= menu_val_t;
        timer_enable <= '0';
        menu_enable <= '1';
            -- TIMER
    else 
        bl_vect_signal <= timer_bl_vect;
        sel_st_signal <= timer_sel_st;
        num_val_signal <= timer_num_val;
        val_t_signal <= timer_val_t;
        timer_enable <= '1';
        menu_enable <= '0';
    end if;
  end process p_switch;
  
  bl_vect <= bl_vect_signal;
  sel_st <= sel_st_signal;
  num_val <= num_val_signal;
  val_t <= val_t_signal;
end architecture behavioral;
