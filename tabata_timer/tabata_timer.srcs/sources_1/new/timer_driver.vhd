----------------------------------------------------------
--
--! @title Timer driver for tabata timer
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

entity timer_driver is
  port (
    enable  : in    std_logic;   -- switcher between menu and timer mode
    clk     : in    std_logic;   -- counter for managing push button treshold and timer
    l_t     : in    integer;     -- stored lap time in seconds
    p_t     : in    integer;     -- stored pause time in seconds
    laps    : in    integer;     -- stored lap count
	btnc    : in    std_logic;   -- BTNC input (START / STOP)
	lap_n   : out   integer;     -- current lap/pause
    bl_vect : out   std_logic_vector(7 downto 0) := "00000000";  -- blicking dp vector
		-- 11111111 for running timer (blicking clock decimal point)
	sel_st  : out   integer := 1;     -- menu option switch
		-- 0 -> blank
		-- 1 -> lap number
		-- 2 -> pause number
	num_val : out   std_logic_vector(9 downto 0) := (others => '0');  -- clock in secs
	val_t   : out   std_logic := '0'    -- type of num_val (0 -> time)
);
end entity timer_driver;


architecture behavioral of timer_driver is

  type timer_state is (stop, lap, pause);
-- values for navigating through the menu
  signal current_state : timer_state := stop;
-- signals of menu values
  signal inner_clock : integer := l_t;
  signal inner_laps : integer := 1;
  
  signal blicking_vector : std_logic_vector(7 downto 0) := "00000000";
  
  
-- BTN debouncing signals
  type btn_state is (press_wait, treshold, release_wait);
-- btn is pressed "output" - after treshold etc.
  signal btnc_pressed : std_logic := '0';
-- btn inner state (waiting for press / treshold / waiting for release)
  signal btnc_state : btn_state := press_wait;
-- inner btn debounce conter
  signal btnc_debounce_counter : integer := 0;
  constant debounce_treshold : integer := 1000000;
  -- 1000000 for 100 MHz clock signal equals 0,01 sec
  
  signal clock_enable_signal : std_logic := '0';
  
begin
	
  clock_enable : entity work.clock_enable
	  port map (
		g_MAX	=> 100000000, -- 1 second
		clk		=> clk,
		rst		=> '0',
		ce		=> clock_enable_signal
	);
	
	  
  -- PROCESS MANAGING LEFT BTN FUNCTIONALITY
  p_btn : process (clk) is
  begin
    if (rising_edge(clk) AND enable = '1') then
    
		-- START / STOP BUTTON ACTIONS
		if (btnc_pressed = '1') then
		  case (current_state) is
		      when stop => -- starting new timer
		          current_state <= lap;
		      when others => -- stopping the timer
		          current_state <= stop;
		  end case;
		end if;
		
		-- TIMER CLOCK ITSELF (clock enable has 1 second period)
		if(clock_enable_signal = '1') then
		  case (current_state) is
		    when stop =>
		        inner_laps <= 1;
                blicking_vector <= (others => '0');
                sel_st <= 1;
                inner_clock <= l_t;

            when lap =>
                -- END OF TIMER
                if (inner_laps = laps AND inner_clock = 0) then
                  current_state <= stop;
                
                -- END OF LAP
                elsif(inner_clock = 0) then
                  inner_clock <= p_t;
                  sel_st <= 2;
                  current_state <= pause;              
                
                else
                  -- IF CONTINUING
                  inner_clock <= inner_clock - 1;
                  blicking_vector <= (others => '1');
                  
                end if;
                
            when pause =>
                -- END OF PAUSE
                if(inner_clock = 0) then
                  inner_clock <= l_t;
				  inner_laps <= inner_laps + 1;
				  sel_st <= 1;
                  current_state <= lap;
                  
                else
                  inner_clock <= inner_clock - 1;
                  blicking_vector <= (others => '1');
                
                end if;
                
            when others =>
                current_state <= stop;
		  end case;
		end if;
		
		
	-- BUTTON DEBOUNCING
		-- one button press = one action to do = resetting pressed status
		btnc_pressed <= '0';
		
		case (btnc_state) is
			-- waiting for button input
			when press_wait =>
				-- goes to second state after button press
				if(btnc = '1') then
					btnc_state <= treshold;
				end if;
			-- counting press treshold
			when treshold =>
				if (btnc_debounce_counter = debounce_treshold) then
					btnc_debounce_counter <= 0;
					-- if button is still pressed then is really pressed
					if (btnc = '1') then
						btnc_pressed <= '1';
					end if;
					btnc_state <= release_wait;
				else
					-- counting treshold
					btnc_debounce_counter <= btnc_debounce_counter + 1;
				end if;
			-- waiting for button release
			when release_wait =>
				if(btnc = '0') then
					btnc_state <= press_wait;
				end if;
            when others =>
					btnc_state <= press_wait;
		end case;
	
		-- output value
		num_val <= std_logic_vector(to_unsigned(inner_clock, 10));
   
	-- RESETTING ALL SIGNALS
	elsif (enable = '0') then
		btnc_state <= press_wait;
		current_state <= stop;
        inner_clock <= l_t;
        inner_laps <= 1;
        blicking_vector <= (others => '0');
        btnc_debounce_counter <= 0;
        btnc_pressed <= '0';
  
    end if;
  end process p_btn;
	
   -- output values from signal
   lap_n <= inner_laps;
   bl_vect <= blicking_vector;

end architecture behavioral;
