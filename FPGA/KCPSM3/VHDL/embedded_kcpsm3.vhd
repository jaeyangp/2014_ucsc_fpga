--
-- EMBEDDED_KCPSM3.VHD
--
-- Ken Chapman - Xilinx Ltd - 3rd June 2003
--
-- This file instantiates the KCPSM3 processor macro and connects the 
-- program ROM.
--
-- NOTE: The name of the program ROM will probably need to be changed to 
--       reflect the name of the program (PSM) file applied to the assembler.
--
------------------------------------------------------------------------------------
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
entity embedded_kcpsm3 is
    Port (      port_id : out std_logic_vector(7 downto 0);
           write_strobe : out std_logic;
            read_strobe : out std_logic;
               out_port : out std_logic_vector(7 downto 0);
                in_port : in std_logic_vector(7 downto 0);
              interrupt : in std_logic;
          interrupt_ack : out std_logic;
                  reset : in std_logic;
                    clk : in std_logic);
end embedded_kcpsm3;
--
------------------------------------------------------------------------------------
--
-- Start of test achitecture
--
architecture connectivity of embedded_kcpsm3 is
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
  component prog_rom 
    Port (      address : in std_logic_vector(9 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                    clk : in std_logic);
    end component;
--
------------------------------------------------------------------------------------
--
-- Signals used to connect KCPSM3 to program ROM
--
signal     address : std_logic_vector(9 downto 0);
signal instruction : std_logic_vector(17 downto 0);
--
------------------------------------------------------------------------------------
--
-- Start of test circuit description
--
begin

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

  program: prog_rom
    port map(      address => address,
               instruction => instruction,
                       clk => clk);

end connectivity;

------------------------------------------------------------------------------------
--
-- END OF FILE EMBEDDED_KCPSM3.VHD
--
------------------------------------------------------------------------------------

