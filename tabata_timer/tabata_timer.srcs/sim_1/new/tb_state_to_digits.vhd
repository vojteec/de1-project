----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2023 23:36:41
-- Design Name: 
-- Module Name: tb_state_to_digits - Behavioral
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

entity tb_state_to_digits is
--  Port ( );
end tb_state_to_digits;

architecture Behavioral of tb_state_to_digits is

	signal sig_lapn   : integer;
	signal sig_state  : integer;
	signal sig_dig7   : std_logic_vector(3 downto 0);
	signal sig_dig6   : std_logic_vector(3 downto 0);
	signal sig_dig5   : std_logic_vector(3 downto 0);
	signal sig_dig4   : std_logic_vector(3 downto 0);
	
begin

	uut_state_to_digits : entity work.state_to_digits
		port map (
			lapn  => sig_lapn,
			state => sig_state,
			dig7  => sig_dig7,
			dig6  => sig_dig6,
			dig5  => sig_dig5,
			dig4  => sig_dig4
		);

	p_lapn : process is
	begin
		sig_lapn <= 0;
		wait for 50 ns;
		sig_lapn <= 1;
		wait for 50 ns;
		sig_lapn <= 2;
		wait for 50 ns;
		sig_lapn <= 3;
		wait for 50 ns;
		sig_lapn <= 4;
		wait for 50 ns;
		sig_lapn <= 5;
		wait for 50 ns;
		sig_lapn <= 6;
		wait for 50 ns;
		sig_lapn <= 7;
		wait for 50 ns;
		sig_lapn <= 8;
		wait for 50 ns;
		sig_lapn <= 9;
		wait for 50 ns;
		sig_lapn <= 10;
		wait for 50 ns;
		sig_lapn <= 11;
		wait;
	end process p_lapn;
	
	p_state : process is
	begin
		sig_state <= 0;
		wait for 70 ns;
		sig_state <= 1;
		wait for 70 ns;
		sig_state <= 2;
		wait for 70 ns;
		sig_state <= 3;
		wait for 70 ns;
		sig_state <= 4;
		wait for 70 ns;
		sig_state <= 5;
		wait;
	end process p_state;
	
  --------------------------------------------------------
  -- Data generation process
  --------------------------------------------------------
  p_stimulus : process is
  begin

    report "Stimulus process started";
    -- No other input data is needed.
    report "Stimulus process finished";
    wait;

  end process p_stimulus;
  
end architecture Behavioral;
