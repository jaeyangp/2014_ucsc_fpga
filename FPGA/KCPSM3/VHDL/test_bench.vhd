-- Test Bench for kcpsm3_int_test.vhd
--
-- Ken Chapman - Xilinx Ltd - June 2003
--
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 

  -- Design to be tested

  COMPONENT kcpsm3_int_test
    Port (         counter : out std_logic_vector(7 downto 0);
                 waveforms : out std_logic_vector(7 downto 0);
           interrupt_event : in std_logic;
                       clk : in std_logic);
  END COMPONENT;

-- signals to connect kcpsm3_int_test 

SIGNAL counter         : std_logic_vector(7 downto 0);
SIGNAL waveforms       : std_logic_vector(7 downto 0);
SIGNAL interrupt_event : std_logic := '0';
SIGNAL clk : std_logic := '0';

BEGIN

-- Define the unit under test

   uut: kcpsm3_int_test 
   port map (         counter => counter,
                    waveforms => waveforms,
              interrupt_event => interrupt_event,
                          clk => clk);


-- Test Bench begins
 
  -- Nominal 50MHz clock which also defines number of cycles in simulation 
  test_clock: process
      variable max_cycles : integer :=400;
      variable cycle_count : integer := 0;
    begin
      -- Define the clock cycles and the clock cycle counter
	   while cycle_count < max_cycles loop
	     clk <= '0';
		  wait for 10 ns;
		  clk <= '1';
		  cycle_count := cycle_count + 1;
		  wait for 10 ns;

        --Now define stimulus relative to a given clock cycle

        case cycle_count is

          when 30 =>  interrupt_event <= '1'; 

          when 67 =>  interrupt_event <= '1'; 

          when 183 =>  interrupt_event <= '1';  
 
          when others => interrupt_event <= '0';   -- no interrupt

        end case;

      end loop;

      wait; -- end of simulation.
  
  end process;

END;
