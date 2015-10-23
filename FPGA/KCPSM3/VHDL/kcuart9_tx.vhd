-- Constant (K) Compact UART Transmitter
--
-- 9-Bit UART Transmitter
--
-- 9 data bits, no parity, 1 stop bit
--     or
-- 8 data bits, parity, 1 stop bit 
--    where the value of the parity bit must be computed externally and provided as data_in(8).
--
-- NOTE : This macro is intended to be attached to bbfifo_16x9 and operation requires the 
--        interaction of signals to and from that FIFO buffer to work correctly. 
--
-- Version : 1.00 (derived from kcuart_tx version 1.10)
-- Version Date : 10th February 2005
--
-- Ken Chapman
-- Xilinx Ltd
-- Benchmark House
-- 203 Brooklands Road
-- Weybridge
-- Surrey KT13 ORH
-- United Kingdom
--
-- chapman@xilinx.com
--
------------------------------------------------------------------------------------
--
-- NOTICE:
--
-- Copyright Xilinx, Inc. 2005.   This code may be contain portions patented by other 
-- third parties.  By providing this core as one possible implementation of a standard,
-- Xilinx is making no representation that the provided implementation of this standard 
-- is free from any claims of infringement by any third party.  Xilinx expressly 
-- disclaims any warranty with respect to the adequacy of the implementation, including 
-- but not limited to any warranty or representation that the implementation is free 
-- from claims of any third party.  Futhermore, Xilinx is providing this core as a 
-- courtesy to you and suggests that you contact all third parties to obtain the 
-- necessary rights to use this implementation.
--
------------------------------------------------------------------------------------
--
-- Library declarations
--
-- The Unisim Library is used to define Xilinx primitives. It is also used during
-- simulation. The source can be viewed at %XILINX%\vhdl\src\unisims\unisim_VCOMP.vhd
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library unisim;
use unisim.vcomponents.all;
--
------------------------------------------------------------------------------------
--
-- Main Entity for KCUART9_TX
--
entity kcuart9_tx is
    Port (        data_in : in std_logic_vector(8 downto 0);
           send_character : in std_logic;
             en_16_x_baud : in std_logic;
               serial_out : out std_logic;
              tx_complete : out std_logic;
                      clk : in std_logic);
    end kcuart9_tx;
--
------------------------------------------------------------------------------------
--
-- Start of Main Architecture for KCUART9_TX
--	 
architecture low_level_definition of kcuart9_tx is
--
------------------------------------------------------------------------------------
--
------------------------------------------------------------------------------------
--
-- Signals used in KCUART9_TX
--
------------------------------------------------------------------------------------
--
signal data_01            : std_logic;
signal data_23            : std_logic;
signal data_45            : std_logic;
signal data_67            : std_logic;
signal data_0123          : std_logic;
signal data_4567          : std_logic;
signal data_01234567      : std_logic;
signal data_01234567_reg  : std_logic;

signal data8_buf          : std_logic;
signal force_serial       : std_logic;
signal next_serial        : std_logic;

signal bit_count          : std_logic_vector(2 downto 0);
signal next_bit_count     : std_logic_vector(2 downto 0);
signal half_bit_count     : std_logic_vector(2 downto 0);
signal bit_count_cy       : std_logic_vector(1 downto 0);

signal baud_count         : std_logic_vector(3 downto 0);
signal next_baud_count    : std_logic_vector(3 downto 0);
signal half_baud_count    : std_logic_vector(3 downto 0);
signal baud_count_cy      : std_logic_vector(3 downto 0);
signal tx_bit_en          : std_logic;

signal decode7            : std_logic;
signal sel_last_bit       : std_logic;
signal parity_bit         : std_logic;
signal next_transmit      : std_logic;
signal transmit           : std_logic;
signal next_tx_complete   : std_logic;
--
--
------------------------------------------------------------------------------------
--
-- Attributes to define LUT contents during implementation 
-- The information is repeated in the generic map for functional simulation--
--
------------------------------------------------------------------------------------
--
attribute INIT : string; 
attribute INIT of mux1_lut      : label is "E4";
attribute INIT of mux2_lut      : label is "E4";
attribute INIT of mux3_lut      : label is "E4";
attribute INIT of mux4_lut      : label is "E4";

attribute INIT of buf_data8     : label is "2";
attribute INIT of force_lut     : label is "E0FF";

attribute INIT of count7_lut    : label is "80";
attribute INIT of transmit_lut  : label is "32";
attribute INIT of complete_lut  : label is "8";

--
------------------------------------------------------------------------------------
--
-- Start of KCUART9_TX circuit description
--
------------------------------------------------------------------------------------
--	
begin

  -- 8 to 1 multiplexer to convert parallel data to serial

  mux1_lut: LUT3
  --synthesis translate_off
    generic map (INIT => X"E4")
  --synthesis translate_on
  port map( I0 => bit_count(0),
            I1 => data_in(0),
            I2 => data_in(1),
             O => data_01 );

  mux2_lut: LUT3
  --synthesis translate_off
    generic map (INIT => X"E4")
  --synthesis translate_on
  port map( I0 => bit_count(0),
            I1 => data_in(2),
            I2 => data_in(3),
             O => data_23 );

  mux3_lut: LUT3
  --synthesis translate_off
    generic map (INIT => X"E4")
  --synthesis translate_on
  port map( I0 => bit_count(0),
            I1 => data_in(4),
            I2 => data_in(5),
             O => data_45 );

  mux4_lut: LUT3
  --synthesis translate_off
    generic map (INIT => X"E4")
  --synthesis translate_on
  port map( I0 => bit_count(0),
            I1 => data_in(6),
            I2 => data_in(7),
             O => data_67 );


  mux5_muxf5: MUXF5
  port map(  I1 => data_23,
             I0 => data_01,
              S => bit_count(1),
              O => data_0123 );

  mux6_muxf5: MUXF5
  port map(  I1 => data_67,
             I0 => data_45,
              S => bit_count(1),
              O => data_4567 );

  mux7_muxf6: MUXF6
  port map(  I1 => data_4567,
             I0 => data_0123,
              S => bit_count(2),
              O => data_01234567 );

  pipeline_mux: FD
  port map ( D => data_01234567,
             Q => data_01234567_reg,
             C => clk);

  -- Serial output logic

  buf_data8: LUT1
  --synthesis translate_off
  generic map (INIT => X"2")
  --synthesis translate_on
  port map( I0 => data_in(8),
             O => data8_buf );

  force_lut: LUT4
  --synthesis translate_off
  generic map (INIT => X"E0FF")
  --synthesis translate_on
  port map( I0 => data_01234567_reg,
            I1 => parity_bit,
            I2 => transmit,
            I3 => send_character,
             O => force_serial );


  mux8_muxf5: MUXF5
  port map(  I1 => data8_buf,
             I0 => force_serial,
              S => sel_last_bit,
              O => next_serial );

  -- Final output flip-flop initialised to start at '1' 
  high_start: for i in 1 to 1 generate
  --
  attribute INIT : bit; 
  attribute INIT of output_reg    : label is '1'; 
  --
  begin

    output_reg: FDE
    --synthesis translate_off
    generic map (INIT => '1')
    --synthesis translate_on
    port map ( D => next_serial,
               Q => serial_out,
              CE => tx_bit_en,
               C => clk);
  
  end generate high_start;


  -- bit counter

  bit_count_loop: for i in 0 to 2 generate
  --
  attribute INIT : string; 
  attribute INIT of bit_count_lut : label is "B"; 
  --
  begin

     bit_reg: FDE
     port map ( D => next_bit_count(i),
                Q => bit_count(i),
               CE => tx_bit_en,
                C => clk);

     bit_count_lut: LUT2
     --synthesis translate_off
     generic map (INIT => X"B")
     --synthesis translate_on
     port map( I0 => bit_count(i),
               I1 => transmit,
                O => half_bit_count(i));

     lsb_bit_count: if i=0 generate
     begin

       bit_count_xor: XORCY
       port map( LI => half_bit_count(i),
                 CI => '1',
                  O => next_bit_count(i));

       bit_count_muxcy: MUXCY
       port map( DI => '0',
                 CI => '1',
                  S => half_bit_count(i),
                  O => bit_count_cy(i));

     end generate lsb_bit_count;

     upper_bit_count: if i>0 generate
     begin

       bit_count_xor: XORCY
       port map( LI => half_bit_count(i),
                 CI => bit_count_cy(i-1),
                  O => next_bit_count(i));

       middle_bit_count: if i=1 generate
       begin

         bit_count_muxcy: MUXCY
         port map( DI => '0',
                   CI => bit_count_cy(i-1),
                    S => half_bit_count(i),
                    O => bit_count_cy(i));
       
       end generate middle_bit_count;
 
     end generate upper_bit_count;

  end generate bit_count_loop;
 

  -- baud counter

  baud_count_loop: for i in 0 to 3 generate
  --
  attribute INIT : string; 
  attribute INIT of baud_count_lut : label is "2"; 
  --
  begin

     baud_reg: FDE
     port map ( D => next_baud_count(i),
                Q => baud_count(i),
               CE => en_16_x_baud,
                C => clk);

     baud_count_lut: LUT1
     --synthesis translate_off
     generic map (INIT => X"2")
     --synthesis translate_on
     port map( I0 => baud_count(i),
                O => half_baud_count(i));

     lsb_baud_count: if i=0 generate
     begin

       baud_count_xor: XORCY
       port map( LI => half_baud_count(i),
                 CI => en_16_x_baud,
                  O => next_baud_count(i));

       baud_count_muxcy: MUXCY
       port map( DI => '0',
                 CI => en_16_x_baud,
                  S => half_baud_count(i),
                  O => baud_count_cy(i));

     end generate lsb_baud_count;

     upper_baud_count: if i>0 generate
     begin

       baud_count_xor: XORCY
       port map( LI => half_baud_count(i),
                 CI => baud_count_cy(i-1),
                  O => next_baud_count(i));

       baud_count_muxcy: MUXCY
       port map( DI => '0',
                 CI => baud_count_cy(i-1),
                  S => half_baud_count(i),
                  O => baud_count_cy(i));

     end generate upper_baud_count;

  end generate baud_count_loop;
 
  bit_en_reg: FD
  port map ( D => baud_count_cy(3),
             Q => tx_bit_en,
             C => clk);

  -- state machine

  count7_lut: LUT3
  --synthesis translate_off
  generic map (INIT => X"80")
  --synthesis translate_on
  port map( I0 => bit_count(0),
            I1 => bit_count(1),
            I2 => bit_count(2),
             O => decode7 );

  sel_last_reg: FDE
  port map ( D => decode7,
             Q => sel_last_bit,
            CE => tx_bit_en,
             C => clk);

  parity_reg: FDE
  port map ( D => sel_last_bit,
             Q => parity_bit,
            CE => tx_bit_en,
             C => clk);

  transmit_lut: LUT3
  --synthesis translate_off
  generic map (INIT => X"32")
  --synthesis translate_on
  port map( I0 => send_character,
            I1 => parity_bit,
            I2 => transmit,
             O => next_transmit );

  transmit_reg: FDE
  port map ( D => next_transmit,
             Q => transmit,
            CE => tx_bit_en,
             C => clk);

  complete_lut: LUT2
  --synthesis translate_off
  generic map (INIT => X"8")
  --synthesis translate_on
  port map( I0 => parity_bit,
            I1 => tx_bit_en,
             O => next_tx_complete );

  complete_reg: FD
  port map ( D => next_tx_complete,
             Q => tx_complete,
             C => clk);

end low_level_definition;

------------------------------------------------------------------------------------
--
-- END OF FILE KCUART9_TX.VHD
--
------------------------------------------------------------------------------------


