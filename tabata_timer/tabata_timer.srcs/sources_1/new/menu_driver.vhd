----------------------------------------------------------
--
--! @title Menu driver for tabata timer
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

entity menu_driver is
  port (
    enable  : in    std_logic;   -- switcher between menu and timer mode
    clk     : in    std_logic;   -- counter for managing push button treshold
    l_t     : in    integer;     -- stored lap time in seconds
    p_t     : in    integer;     -- stored pause time in seconds
    laps    : in    integer;     -- stored lap count
	btnl    : in    std_logic;   -- BTNL input
	btnr    : in    std_logic;   -- BTNR input
	btnu    : in    std_logic;   -- BTNU input
	btnd    : in    std_logic;   -- BTND input
    bl_vect : out   std_logic_vector(7 downto 0) := "11110000";  -- blicking segments vector
	sel_st  : out   integer := 3;     -- menu option switch
		-- 0 -> blank
		-- 3 -> lap time
		-- 4 -> pause time
		-- 5 -> lap count
	num_val : out   std_logic_vector(9 downto 0) := (others => '0');  -- number value
	val_t   : out   std_logic := '0';    -- type of num_val (time / lap count)
		-- 0 -> time value
		-- 1 -> number value
	l_t_o   : out   integer := 0;      -- set lap time in seconds (16:59 MAX)
	p_t_o   : out   integer := 0;      -- set pause time in seconds (16:59 MAX)
	laps_o  : out   integer := 0       -- set lap count
);
end entity menu_driver;


architecture behavioral of menu_driver is

  type menu_state is (lap_time, pause_time, lap_count);
  type edit_state is (option, minute, second, number);
-- values for navigating through the menu
  signal current_option : menu_state := lap_time;
  signal current_edit : edit_state := option;
-- signals of menu values
  signal inner_l_t : integer := l_t;
  signal inner_p_t : integer := p_t;
  signal inner_laps : integer := laps;
  signal num_val_signal : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(l_t, 10));
-- BTN debouncing signals
  type btn_state is (press_wait, treshold, release_wait);
-- btn is pressed "output" - after treshold etc.
  signal btnl_pressed : std_logic := '0';
  signal btnr_pressed : std_logic := '0';
  signal btnu_pressed : std_logic := '0';
  signal btnd_pressed : std_logic := '0';
-- btn inner state (waiting for press / treshold / waiting for release)
  signal btnl_state : btn_state := press_wait;
  signal btnr_state : btn_state := press_wait;
  signal btnu_state : btn_state := press_wait;
  signal btnd_state : btn_state := press_wait;
-- inner btn debounce conter
  signal btnl_debounce_counter : integer := 0;
  signal btnr_debounce_counter : integer := 0;
  signal btnu_debounce_counter : integer := 0;
  signal btnd_debounce_counter : integer := 0;
  constant debounce_treshold : integer := 1000000;
  -- 1000000 for 100 MHz clock signal equals 0,01 sec
  signal blicking_vector : std_logic_vector(7 downto 0) := "11110000";
  
begin

  -- PROCESS MANAGING LEFT BTN FUNCTIONALITY
  p_btn : process (clk) is
  begin
    if (rising_edge(clk) AND enable = '1') then
		-- BTNL MOVING CURSOR ONE POSITION TO THE LEFT
		if (btnl_pressed = '1') then
			case (current_edit) is
				when option =>
					case (current_option) is
						when lap_count =>
							current_edit <= number;
							blicking_vector <= "00000011";
						when others =>
							current_edit <= second;
							blicking_vector <= "00000011";
					end case;
				when minute =>
					current_edit <= option;
					blicking_vector <= "11110000";
				when second =>
					current_edit <= minute;
					blicking_vector <= "00001100";
				when number =>
					current_edit <= option;
					blicking_vector <= "11110000";
                when others =>
                  inner_p_t <= inner_p_t;
			end case;
		end if;
		
		-- BTNR MOVING CURSOR ONE POSITION TO THE RIGHT
		if (btnr_pressed = '1') then
			case (current_edit) is
				when option =>
					case (current_option) is
						when lap_count =>
							current_edit <= number;
							blicking_vector <= "00000011";
						when others =>
							current_edit <= minute;
							blicking_vector <= "00001100";
					end case;
				when minute =>
					current_edit <= second;
					blicking_vector <= "00000011";
				when second =>
					current_edit <= option;
					blicking_vector <= "11110000";
				when number =>
					current_edit <= option;
					blicking_vector <= "11110000";
                when others =>
                  inner_p_t <= inner_p_t;
			end case;
		end if;
		
		-- BTNU INCREASING VALUE / GOING UP IN THE OPTION STATE LIST
		if (btnu_pressed = '1') then
			case (current_edit) is
				when option =>
					case (current_option) is
						when lap_time =>
							current_option <= lap_count;
							sel_st <= 5; -- lap count
							num_val_signal <= std_logic_vector(to_unsigned(inner_laps, 10));
							val_t <= '1'; -- number
						when pause_time =>
							current_option <= lap_time;
							sel_st <= 3; -- lap time
							num_val_signal <= std_logic_vector(to_unsigned(inner_l_t, 10));
							val_t <= '0'; -- time
						when lap_count =>
							current_option <= pause_time;
							sel_st <= 4; -- pause time
							num_val_signal <= std_logic_vector(to_unsigned(inner_p_t, 10));
							val_t <= '0'; -- time
						when others =>
						  inner_p_t <= inner_p_t;
					end case;
				when number =>
					if(inner_laps < 99) then
						inner_laps <= inner_laps + 1;
						num_val_signal <= std_logic_vector(unsigned(num_val_signal) + 1);
					end if;
				when minute =>
					case (current_option) is
						when lap_time =>
							if(inner_l_t < 900) then
								inner_l_t <= inner_l_t + 60;
								num_val_signal <= std_logic_vector(unsigned(num_val_signal) + 60);
							end if;
						when pause_time =>
							if(inner_p_t < 900) then
								inner_p_t <= inner_p_t + 60;
								num_val_signal <= std_logic_vector(unsigned(num_val_signal) + 60);
							end if;
						when others =>
						  inner_p_t <= inner_p_t;
					end case;
				when second =>
					case (current_option) is
						when lap_time =>
							if(inner_l_t < 1019) then
								inner_l_t <= inner_l_t + 1;
								num_val_signal <= std_logic_vector(unsigned(num_val_signal) + 1);
							end if;
						when pause_time =>
							if(inner_p_t < 1019) then
								inner_p_t <= inner_p_t + 1;
								num_val_signal <= std_logic_vector(unsigned(num_val_signal) + 1);
							end if;
						when others =>
						  inner_p_t <= inner_p_t;
					end case;
                when others =>
                  inner_p_t <= inner_p_t;
			end case;
		end if;
		
		-- BTND DECREASING VALUE / GOING DOWN IN THE OPTION STATE LIST
		if (btnd_pressed = '1') then
			case (current_edit) is
				when option =>
					case (current_option) is
						when lap_time =>
							current_option <= pause_time;
							sel_st <= 4; -- pause time
							num_val_signal <= std_logic_vector(to_unsigned(inner_p_t, 10));
							val_t <= '0'; -- time
						when pause_time =>
							current_option <= lap_count;
							sel_st <= 5; -- lap count
							num_val_signal <= std_logic_vector(to_unsigned(inner_laps, 10));
							val_t <= '1'; -- number
						when lap_count =>
							current_option <= lap_time;
							sel_st <= 3; -- lap time
							num_val_signal <= std_logic_vector(to_unsigned(inner_l_t, 10));
							val_t <= '0'; -- time
						when others =>
						  inner_p_t <= inner_p_t;
					end case;
				when number =>
					if(inner_laps > 1) then
						inner_laps <= inner_laps - 1;
						num_val_signal <= std_logic_vector(unsigned(num_val_signal) - 1);
					end if;
				when minute =>
					case (current_option) is
						when lap_time =>
							if(inner_l_t > 60) then
								inner_l_t <= inner_l_t - 60;
								num_val_signal <= std_logic_vector(unsigned(num_val_signal) - 60);
							end if;
						when pause_time =>
							if(inner_p_t > 60) then
								inner_p_t <= inner_p_t - 60;
								num_val_signal <= std_logic_vector(unsigned(num_val_signal) - 60);
							end if;
						when others =>
						  inner_p_t <= inner_p_t;
					end case;
				when second =>
					case (current_option) is
						when lap_time =>
							if(inner_l_t > 1) then
								inner_l_t <= inner_l_t - 1;
								num_val_signal <= std_logic_vector(unsigned(num_val_signal) - 1);
							end if;
						when pause_time =>
							if(inner_p_t > 1) then
								inner_p_t <= inner_p_t - 1;
								num_val_signal <= std_logic_vector(unsigned(num_val_signal) - 1);
							end if;
						when others =>
						  inner_p_t <= inner_p_t;
					end case;
                when others =>
                  inner_p_t <= inner_p_t;
			end case;
		end if;
		
		-- one button press = one action to do = resetting pressed status
		btnl_pressed <= '0';
		btnr_pressed <= '0';
		btnu_pressed <= '0';
		btnd_pressed <= '0';
		
	-- BUTTONS DEBOUNCING
		case (btnl_state) is
			-- waiting for button input
			when press_wait =>
				-- goes to second state after button press
				if(btnl = '1') then
					btnl_state <= treshold;
				end if;
			-- counting press treshold
			when treshold =>
				if (btnl_debounce_counter = debounce_treshold) then
					btnl_debounce_counter <= 0;
					-- if button is still pressed then is really pressed
					if (btnl = '1') then
						btnl_pressed <= '1';
					end if;
					btnl_state <= release_wait;
				else
					-- counting treshold
					btnl_debounce_counter <= btnl_debounce_counter + 1;
				end if;
			-- waiting for button release
			when release_wait =>
				if(btnl = '0') then
					btnl_state <= press_wait;
				end if;
            when others =>
              btnl_state <= press_wait;
		end case;
		
		case (btnr_state) is
			-- waiting for button input
			when press_wait =>
				-- goes to second state after button press
				if(btnr = '1') then
					btnr_state <= treshold;
				end if;
			-- counting press treshold
			when treshold =>
				if (btnr_debounce_counter = debounce_treshold) then
					btnr_debounce_counter <= 0;
					-- if button is still pressed then is really pressed
					if (btnr = '1') then
						btnr_pressed <= '1';
					end if;
					btnr_state <= release_wait;
				else
					-- counting treshold
					btnr_debounce_counter <= btnr_debounce_counter + 1;
				end if;
			-- waiting for button release
			when release_wait =>
				if(btnr = '0') then
					btnr_state <= press_wait;
				end if;
            when others =>
              btnr_state <= press_wait;
		end case;
		
		case (btnu_state) is
			-- waiting for button input
			when press_wait =>
				-- goes to second state after button press
				if(btnu = '1') then
					btnu_state <= treshold;
				end if;
			-- counting press treshold
			when treshold =>
				if (btnu_debounce_counter = debounce_treshold) then
					btnu_debounce_counter <= 0;
					-- if button is still pressed then is really pressed
					if (btnu = '1') then
						btnu_pressed <= '1';
					end if;
					btnu_state <= release_wait;
				else
					-- counting treshold
					btnu_debounce_counter <= btnu_debounce_counter + 1;
				end if;
			-- waiting for button release
			when release_wait =>
				if(btnu = '0') then
					btnu_state <= press_wait;
				end if;
            when others =>
              btnu_state <= press_wait;
		end case;
		
		case (btnd_state) is
			-- waiting for button input
			when press_wait =>
				-- goes to second state after button press
				if(btnd = '1') then
					btnd_state <= treshold;
				end if;
			-- counting press treshold
			when treshold =>
				if (btnd_debounce_counter = debounce_treshold) then
					btnd_debounce_counter <= 0;
					-- if button is still pressed then is really pressed
					if (btnd = '1') then
						btnd_pressed <= '1';
					end if;
					btnd_state <= release_wait;
				else
					-- counting treshold
					btnd_debounce_counter <= btnd_debounce_counter + 1;
				end if;
			-- waiting for button release
			when release_wait =>
				if(btnd = '0') then
					btnd_state <= press_wait;
				end if;
            when others =>
              btnd_state <= press_wait;
		end case;
		
      -- output number value from signal
      num_val <= num_val_signal;
      -- returing set values in menu back to top to save them
      l_t_o <= inner_l_t;
      p_t_o <= inner_p_t;
      laps_o <= inner_laps;
      bl_vect <= blicking_vector;
    end if;
  
  end process p_btn;

end architecture behavioral;
