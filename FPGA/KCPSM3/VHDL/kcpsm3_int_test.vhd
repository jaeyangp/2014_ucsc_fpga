--
-- Interrupt test for KCPSM3 
--
-- Ken Chapman - Xilinx Ltd - June 2003
--
--
------------------------------------------------------------------------------------
--
-- Library declarations
--
-- Standard IEEE libraries
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--
------------------------------------------------------------------------------------
--
--
entity kcpsm3_int_test is
    Port (         counter : out std_logic_vector(7 downto 0);
                 waveforms : out std_logic_vector(7 downto 0);
           interrupt_event : in std_logic;
                       clk : in std_logic);
    end kcpsm3_int_test;
--
------------------------------------------------------------------------------------
--
-- Start of test achitecture
--
architecture Behavioral of kcpsm3_int_test is
--
------------------------------------------------------------------------------------
--
-- declaration of KCPSM3
--
  component kcpsm3 
    Port (      address : out std_logic_vector(9 downto 0);
            instruction : in std_logic_vector(17 downto 0);
                port_id : out std_logic_vector(7 downto 0);
           write_strobe : out std_logic;
               out_port : out std_logic_vector(7 downto 0);
            read_strobe : out std_logic;
                in_port : in std_logic_vector(7 downto 0);
              interrupt : in std_logic;
          interrupt_ack : out std_logic;
                  reset : in std_logic;
                    clk : in std_logic);
    end component;
--
-- declaration of program ROM
--
  component int_test 
    Port (      address : in std_logic_vector(9 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                    clk : in std_logic);
    end component;
--
------------------------------------------------------------------------------------
--
-- Signals used to connect KCPSM3 to program ROM and I/O logic
--
signal address       : std_logic_vector(9 downto 0);
signal instruction   : std_logic_vector(17 downto 0);
signal port_id       : std_logic_vector(7 downto 0);
signal out_port      : std_logic_vector(7 downto 0);
signal in_port       : std_logic_vector(7 downto 0);
signal write_strobe  : std_logic;
signal read_strobe   : std_logic;
signal interrupt     : std_logic :='0';
signal interrupt_ack : std_logic;
signal reset         : std_logic;
--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- Start of circuit description
--
begin

  -- Inserting KCPSM3 and the program memory

  processor: kcpsm3
    port map(      address => address,
               instruction => instruction,
                   port_id => port_id,
              write_strobe => write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     reset => reset,
                       clk => clk);
 
  program: int_test
    port map(      address => address,
               instruction => instruction,
                       clk => clk);

  -- Unused inputs on processor

  in_port <= "00000000";
  reset <= '0';

  -- Adding the output registers to the processor
   
  IO_registers: process(clk)
  begin

    if clk'event and clk='1' then

      -- waveform register at address 02
      if port_id(1)='1' and write_strobe='1' then
        waveforms <= out_port;
      end if;

      -- Interrupt Counter register at address 04
      if port_id(2)='1' and write_strobe='1' then
        counter <= out_port;
      end if;

    end if;
 
  end process IO_registers;



  -- Adding the interrupt input
  -- Note that the initial value of interrupt (low) is  
  -- defined at signal declaration.
   
  interrupt_control: process(clk)
  begin

    if clk'event and clk='1' then
      if interrupt_ack='1' then
        interrupt <= '0';
       elsif interrupt_event='1' then
        interrupt <= '1';
       else
        interrupt <= interrupt;
      end if;
    end if; 

  end process interrupt_control;

end Behavioral;

------------------------------------------------------------------------------------
--
-- END OF FILE KCPSM3_INT_TEST.VHD
--
------------------------------------------------------------------------------------

