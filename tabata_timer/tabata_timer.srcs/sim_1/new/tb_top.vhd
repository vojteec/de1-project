----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2023 23:35:17
-- Design Name: 
-- Module Name: tb_top - Behavioral
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

entity tb_top is
--  Port ( );
end tb_top;

architecture testbench of tb_top is

signal sig_clk_100mhz   : std_logic;
signal sig_rst          : std_logic;
signal sig_up           : std_logic;
signal sig_down         : std_logic;
signal sig_left         : std_logic;
signal sig_right        : std_logic;
signal sig_switch       : std_logic;

begin

uut_top : entity work.top
    port map (
        CLK100MHZ => sig_clk_100mhz,
        BTNC      => sig_rst,
        BTNU      => sig_up,
        BTND      => sig_down,
        BTNL      => sig_left,
        BTNR      => sig_right,
        SW        => sig_switch
    );
end testbench;
