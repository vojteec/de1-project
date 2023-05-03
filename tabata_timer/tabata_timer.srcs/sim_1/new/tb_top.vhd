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

	constant c_CLK_100MHZ_PERIOD : time := 10 ns;
	signal sig_clk_100mhz   : std_logic;
	signal sig_btnc         : std_logic;
	signal sig_btnu         : std_logic;
	signal sig_btnd         : std_logic;
	signal sig_btnl         : std_logic;
	signal sig_btnr         : std_logic;
	signal sig_sw           : std_logic;
	signal sig_cathode      : std_logic_vector(6 downto 0);
	signal sig_dp			: std_logic;
	signal sig_anode        : std_logic_vector(7 downto 0);

begin

uut_top : entity work.top
    port map (
        CLK100MHZ => sig_clk_100mhz,
        BTNC      => sig_rst,
        BTNU      => sig_up,
        BTND      => sig_down,
        BTNL      => sig_left,
        BTNR      => sig_right,
        SW        => sig_switch,
        CA        => sig_cathode(0),
        CB        => sig_cathode(1),
        CC        => sig_cathode(2),
        CD        => sig_cathode(3),
        CE        => sig_cathode(4),
        CF        => sig_cathode(5),
        CG        => sig_cathode(6),
        DP        => sig_dp,
        AN        => sig_anode,
    );
	
  --------------------------------------------------------
  -- Clock generation process
  --------------------------------------------------------
	p_clk_gen : process is
	begin

		while now < 10000 ns loop -- 10 usec of simulation

		  sig_clk_100mhz <= '0';
		  wait for c_CLK_100MHZ_PERIOD / 2;
		  sig_clk_100mhz <= '1';
		  wait for c_CLK_100MHZ_PERIOD / 2;

		end loop;

		wait;
	
	end process p_clk_gen;
	
	
  --------------------------------------------------------
  -- BTNC generation process
  --------------------------------------------------------
  p_btnc_gen : process is
  begin

	while now < 10000 ns loop -- 10 usec of simulation
		sig_btnc <= '0';
		wait for 20 ns;

		sig_btnc <= '1';
		wait for 50 ns;
	end loop;
	
    wait;

  end process p_btnc_gen;
  --------------------------------------------------------
  -- BTNL generation process
  --------------------------------------------------------
  p_btnl_gen : process is
  begin

	while now < 10000 ns loop -- 10 usec of simulation
		sig_btnl <= '0';
		wait for 30 ns;

		sig_btnl <= '1';
		wait for 40 ns;
	end loop;
	
    wait;

  end process p_btnl_gen;
  --------------------------------------------------------
  -- BTNR generation process
  --------------------------------------------------------
  p_btnr_gen : process is
  begin

	while now < 10000 ns loop -- 10 usec of simulation
		sig_btnr <= '0';
		wait for 35 ns;

		sig_btnr <= '1';
		wait for 64 ns;
	end loop;

    wait;

  end process p_btnr_gen;
  --------------------------------------------------------
  -- BTNU generation process
  --------------------------------------------------------
  p_btnu_gen : process is
  begin

	while now < 10000 ns loop -- 10 usec of simulation
		sig_btnu <= '0';
		wait for 94 ns;

		sig_btnu <= '1';
		wait for 34 ns;
	end loop;

    wait;

  end process p_btnu_gen;
  --------------------------------------------------------
  -- BTND generation process
  --------------------------------------------------------
  p_btnd_gen : process is
  begin

	while now < 10000 ns loop -- 10 usec of simulation
		sig_btnd <= '0';
		wait for 45 ns;

		sig_btnd <= '1';
		wait for 82 ns;
	end loop;
	
    wait;

  end process p_btnd_gen;
  --------------------------------------------------------
  -- SW generation process
  --------------------------------------------------------
  p_sw_gen : process is
  begin

    sig_sw <= '0';
    wait for 500 ns;

    sig_sw <= '1';

    wait;

  end process p_sw_gen;

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
	
end architecture testbench;
