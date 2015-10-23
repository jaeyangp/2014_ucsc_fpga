UART9 readme.txt

Please open this file in Notepad or WordPad or use a non proportional font for best display format.



9-Bit UART Macros with Integral FIFO Buffers.
Suitable for communication with Parity.


Release 1 - 3rd March 2005




Author
------

Ken Chapman
Staff Engineer - Spartan Applications Specialist
Xilinx Ltd (UK)

email: ken.chapman@xilinx.com


Introduction
------------

These macros have been supplied to complement the standard 8-bit UART macros supplied with PicoBlaze. 
You are advised to look at the standard macros and documentation (UART_manual.pdf) first as these 
variants take almost the same format and must be used and controlled in the same fundamental way.

The UART9 macros provide a UART which has 1 start bit, 9 data bits and 1 stop bit. 
The additional data bit can be used to provide different functionality depending on the way you 
choose to interpret it. 

Transmitter macro is called 'uart9_tx.vhd' and the additional bit is data_in(8).
Receiver macro is called 'uart9_rx.vhd' and the additional bit is data_out(8).

Parity - Drive data_in(8) with a High or Low depending on the state or the remaining data bits
         data_in(7 downto 0) and the desired ODD or EVEN parity.
         Interpret and check the received data_out(8) as required by your application.

Data - The additional bit can be used as an additional data bit.

Stop bit - Forcing a High and checking for High allows the UART to provide 1 start bit, 8 data 
           bits and 2 stop bits format.


Is Parity Required?
-------------------

The most common reason for the 9th bit is to provide support for parity. Before choosing to 
implement parity in a system you should ask the fundamental question "Do I really need it?".
To help answer that question, you need to consider what your system will do if a parity error
should occur. Will it just ignore an error and what will be the effect if it does? If it 
does not ignore the error, then what will it do? All of these factors will need to be solved 
at a higher level than these macros and PicoBlaze will almost certainly provide a suitable 
platform in which to implement this protocol.

In many cases the need for parity is simply to enable connection to another piece of equipment 
which expects parity and which can not be changed. It is not unusual in these cases for the received 
parity to be ignored or for incorrect data to be discarded with unpredictable results. Fortunately 
most serial connections such as RS232 are now very reliable once initial communication has 
been established.



Using the Macros 
----------------

The macros are provided as source VHDL and should be instantiated in your design. Each macro 
also uses two sub macros and therefore these files must also be added to the project.

uart9_tx
   |
   |__kcuart9_tx
   |
   |__bbfifo_16x9


uart9_rx
   |
   |__kcuart9_rx
   |
   |__bbfifo_16x9


The instantiation templates are exactly the same as those required for the standard 8-bit 
macros except that the data bus in each case is now 9 bits. 


Component declaration........

----------------------------------------------------------------------------------------

  component uart9_tx
    Port (            data_in : in std_logic_vector(8 downto 0);
                 write_buffer : in std_logic;
                 reset_buffer : in std_logic;
                 en_16_x_baud : in std_logic;
                   serial_out : out std_logic;
                  buffer_full : out std_logic;
             buffer_half_full : out std_logic;
                          clk : in std_logic);
    end component;


  component uart9_rx
    Port (            serial_in : in std_logic;
                       data_out : out std_logic_vector(8 downto 0);
                    read_buffer : in std_logic;
                   reset_buffer : in std_logic;
                   en_16_x_baud : in std_logic;
            buffer_data_present : out std_logic;
                    buffer_full : out std_logic;
               buffer_half_full : out std_logic;
                            clk : in std_logic);
  end component;


----------------------------------------------------------------------------------------

Component Instantiation......

Signal names will probably change to fit with your design.

----------------------------------------------------------------------------------------

  transmit: uart9_tx 
  port map (            data_in => data_in, 
                   write_buffer => write_buffer,
                   reset_buffer => reset_buffer,
                   en_16_x_baud => en_16_x_baud,
                     serial_out => serial_out,
                    buffer_full => buffer_full,
               buffer_half_full => buffer_half_full,
                            clk => clk );

  receive: uart9_rx
  port map (            serial_in => serial_in,
                         data_out => data_out
                      read_buffer => read_buffer
                     reset_buffer => reset_buffer,
                     en_16_x_baud => en_16_x_baud,
              buffer_data_present => buffer_data_present,
                      buffer_full => buffer_full,
                 buffer_half_full => buffer_half_full,
                              clk => clk );  


----------------------------------------------------------------------------------------


Providing Parity
----------------

Parity is defined as being ODD or EVEN. The term ODD and EVEN refers to the total number of 
High (1) bits being transmitted including the parity bit itself. 

For example the ASCII code for the letter 'A' is 41 hex. The 8-bit binary representation is 
therefore 01000001 which clearly has an even number of 1's. So the parity bit will High (1) 
for ODD parity and '0' for EVEN parity.  

To transmit parity using the uart9_tx macro, the parity bit needs to be computed and then 
applied along with the 8 data bits when activating the write_buffer control. This could be
achieved in hardware by creating an XOR gate for EVEN parity or an XNOR for ODD parity.

--ODD parity 
data_in(8) <= data_in(0) xor data_in(1) xor data_in(2) xor data_in(3)   
                  xor data_in(4) xor data_in(5) xor data_in(6) xor data_in(7); 

PicoBlaze can also be used to calculate parity and may offer additional flexibility.
Since the ports and operation of PicoBlaze is 8-bits, connections to the uart_tx now 
requires 2 ports. The first port can be used to provide the parity bit which will then 
be held in a register. Then when the second port writes the main 8-bit data directly 
into the FIFO buffer the parity bit is combined to form the complete 9-bit value. By 
careful design the spare bits of the port used to set the parity bits can also be used
for control the reset on the UART FIFO buffers if required.

When receiving data, hardware logic could again be used to compute the parity of the data
and compare this with the received parity bit (XNOR gate). This would result in a 
'parity error' flag which the associated processor would still need to read. So unless 
the processor is really very occupied, it is probably easier and more efficient to read 
the parity bit directly and perform the error test in software. 


----------------------------------------------------------------------------------------

PicoBlaze interface to uart9_tx and uart_rx supporting parity.  

The following sections of code describe a potential interface between PicoBlaze and the 
uart9 macros. Notice how the FIFO buffers are fully controlled and monitored by the 
Processor and the parity bit is treated as bit7 of allocated input and output ports.    

----------------------------------------------------------------------------------------

signal rx_data             : std_logic_vector(8 downto 0);
signal tx_data             : std_logic_vector(8 downto 0);
signal tx_parity           : std_logic;
signal write_to_uart       : std_logic;
signal tx_full             : std_logic;
signal tx_half_full        : std_logic;
signal read_from_uart      : std_logic;
signal rx_data_present     : std_logic;
signal rx_full             : std_logic;
signal rx_half_full        : std_logic;
signal uart_status         : std_logic_vector(7 downto 0);
signal tx_reset            : std_logic;
signal rx_reset            : std_logic;

...............

  --UART Transmitter interface

  parity_tx_port: process(clk)
  begin

    if clk'event and clk='1' then
      if write_strobe='1' then

        -- PORT 20 : UART FIFO control and transmitter parity.
        if port_id(5)='1' then
          tx_reset <= out_port(0);
          rx_reset <= out_port(1);
          tx_parity <= out_port(7);
        end if;

      end if;
    end if; 

  end process parity_tx_port;

  -- PORT 10 : Write data to UART transmitter. 
  write_to_uart <= write_strobe and port_id(4);

  tx_data <= tx_parity & out_port;

  transmit: uart9_tx 
  port map (            data_in => tx_data, 
                   write_buffer => write_to_uart,
                   reset_buffer => reset_buffer,
                   en_16_x_baud => en_16_x_baud,
                     serial_out => serial_out,
                    buffer_full => buffer_full,
               buffer_half_full => buffer_half_full,
                            clk => clk );

...............

  --UART Receiver interface

  input_ports: process(clk)
  begin
    if clk'event and clk='1' then

      case port_id(1 downto 0) is

        --PORT 00 : Read FIFO status including receiver parity bit 
        when "00" =>    in_port <= uart_status;  

        --PORT 01 : Read receiver UART 
        when "01" =>    in_port <= rx_data(7 downto 0);

        --PORT 02 - if required
        --when "10" =>    in_port <= ?????;

        --PORT 03 - if required
        --when "11" =>    in_port <= ?????;

        -- Don't care used to ensure minimum logic
        when others =>    in_port <= "XXXXXXXX";  

      end case;

      -- Form read strobe for UART receiver FIFO buffer for address 01.

      read_from_uart <= read_strobe and (not port_id(1)) and port_id(0); 

    end if;

  receive: uart9_rx
  port map (            serial_in => rx,
                         data_out => rx_data,
                      read_buffer => read_from_uart,
                     reset_buffer => rx_reset,
                     en_16_x_baud => en_38400_baud,
              buffer_data_present => rx_data_present,
                      buffer_full => rx_full,
                 buffer_half_full => rx_half_full,
                              clk => clk );  


  uart_status <= rx_data(8) & "00" & rx_full & rx_half_full & rx_data_present & tx_full & tx_half_full ;



----------------------------------------------------------------------------------------

PicoBlaze to uart9_tx PSM code example    

The following sections of PSM code relate to the VHDL interface above and enable a byte 
of data to be transmitted or received via the UART including parity. CONSTANT directives
have been used to define both the port numbers and the allocations of bits within a given
port.

The parity generation is performed by the TEST instruction. It is vital that the 
transmitter code (UART_write) sets the parity output port first and then writes the 
actual data. The receiver code (UART_read) captures the received parity as part of the 
polling of the FIFO status bits. It then reads the data, computes parity and compares this 
with the received bit. The ZERO flag (Z) indicates any parity errors which can then be 
used at the higher level in the program. 

----------------------------------------------------------------------------------------

                    CONSTANT UART_write_port, 10        ;UART Tx 8-bit data output
                    ;
                    CONSTANT UART_control_port, 20      ;UART reset and parity output
                    CONSTANT tx_reset, 01               ;  Tx Buffer Reset - bit0
                    CONSTANT rx_reset, 02               ;  Rx Buffer Reset - bit1
                    CONSTANT tx_parity, 80              ;        Tx Parity - bit7
                    ;
                    CONSTANT UART_status_port, 00       ;Communications status input
                    CONSTANT tx_half_full, 01           ;  Transmitter          half full - bit0
                    CONSTANT tx_full, 02                ;    UART FIFO               full - bit1
                    CONSTANT rx_data_present, 04        ;  Receiver          data present - bit2
                    CONSTANT rx_half_full, 08           ;    UART FIFO          half full - bit3
                    CONSTANT rx_full, 10                ;                            full - bit4
                    CONSTANT status_nul5, 20            ;                          unused - bit5
                    CONSTANT status_nul6, 40            ;                          unused - bit6
                    CONSTANT rx_parity, 80              ;    Parity Bit            parity - bit7
                    ;
                    CONSTANT UART_read_port, 01         ;UART Rx 8-bit data input
                    ;

                    NAMEREG sF, UART_data               ;used for main 8-bit UART data
                    NAMEREG sE, UART_status             ;used for UART status and control
                    ;

                    ;
                    ;Write byte to UART with EVEN or ODD parity.
                    ;
                    ;Data should be provided in register 'UART_data'
                    ;
                    ;Odd and even Parity is describes the total number of 1's sent
                    ;in the complete 9-bit packet formed of 8-bit data and the parity bit.
                    ;For EVEN parity comment out the line indicated ***.
                    ;For ODD parity include the line indicated ***.
                    ;
                    ;Registers used s0, UART_data and UART_status
                    ;
        UART_write: INPUT UART_status, UART_status_port
                    TEST UART_status, tx_full           ;test for space in buffer
                    JUMP NZ, UART_write                 ;wait if no space
                    LOAD s0, 00                         ;compute parity for data being sent
                    TEST UART_data, FF
                    SRA s0                              ;move parity value into MSB
                    XOR s0, 80                          ;**** include this line for ODD parity
                    OUTPUT s0, UART_control_port        ;send parity to UART (no reset)
                    OUTPUT UART_data, UART_write_port   ;write data and parity into transmitter
                    RETURN
                    ;


                    ;Read byte from UART with test for EVEN or ODD parity.
                    ;
                    ;The routine tests and waits for available data and then reads the byte
                    ;data into  register 'UART_data'. The data is then tested against the parity
                    ;bit received. For good data the ZERO flag will be set. A parity error will
                    ;will be signified by the ZERO flag being reset.
                    ;
                    ;Odd and even Parity is describes the total number of 1's sent
                    ;in the complete 9-bit packet formed of 8-bit data and the parity bit.
                    ;For EVEN parity comment out the line indicated ***.
                    ;For ODD parity include the line indicated ***.
                    ;
                    ;Registers used s0, UART_data and UART_status
                    ;
                    ;
         UART_read: INPUT UART_status, UART_status_port ;Test for available character
                    TEST UART_status, rx_data_present   ;test for space in buffer
                    INPUT UART_data, UART_read_port
                    LOAD s0, 00                         ;compute parity for received data
                    TEST UART_data, FF
                    SRA s0
                    XOR s0, 80                          ;****include this line for ODD parity
                    AND UART_status, rx_parity          ;isolate parity bit received
                    XOR s0, UART_status                 ;ZERO set if parity matches
                    RETURN
                    ;

----------------------------------------------------------------------------------------



Simple Error Correction Technique
---------------------------------

This is a very old technique which can provide a degree of error correction. Although a 
parity error can indicate that an error has occurred, it is not possible to know which bit 
has been received in error. This technique can be used to detect and correct the occasional 
bit error. 

In this example we assume that 8 bytes of data are to be sent. These are the ASCII characters
ABCDEFGH. First each byte is transmitted with ODD parity (although EVEN could also be used).

A    0 1 0 0 0 0 0 1   1
B    0 1 0 0 0 0 1 0   1
C    0 1 0 0 0 0 1 1   0
D    0 1 0 0 0 1 0 0   1
E    0 1 0 0 0 1 0 1   0
F    0 1 0 0 0 1 1 0   0
G    0 1 0 0 0 1 1 1   1
H    0 1 0 0 0 1 0 0   1

Next a 'parity byte' is transmitted. Each bit represents the ODD parity of the corresponding bit 
transmitted in the last 8 bytes. In other words, it is the ODD parity associated with each of 
the above columns.

     1 1 1 1 1 0 1 1   *

It is debatable as to what to transmit as parity for this 'parity byte'. It could just be the 
parity of the 'parity byte' in the normal way. It could be the parity of the previous 8 parity 
bits transmitted or a combination of both. The uart9 macros allow you to make the choice in 
software because it is treated the same way as any other data bit.


Now consider receiving the above data packet, but with a bit error at bit 6 of the character 'D'.

A    0 1 0 0 0 0 0 1   1
B    0 1 0 0 0 0 1 0   1
C    0 1 0 0 0 0 1 1   0
D    0 0 0 0 0 1 0 0   1   <----- Parity error
E    0 1 0 0 0 1 0 1   0
F    0 1 0 0 0 1 1 0   0
G    0 1 0 0 0 1 1 1   1
H    0 1 0 0 0 1 0 0   1
     1 1 1 1 1 0 1 1   *

       ^
       |
     parity
     error

The parity error on the 'D' line tells us there has been some kind of error but we do not know 
which bit caused it. The 'parity byte' also indicates that an error has occurred in the bit 6 
column, but we don't know which byte was the cause. However, it can easily be seen that the 
intersection of these error points reveals the bit error and it would therefore be reasonable 
to correct this bit by simple inversion.

It is possible to correct more than one bit error in a packet so long as the errors occur in 
different rows and columns. There is always a danger that the parity bits may be corrupted and 
this is where the parity of the 'parity byte' (*) could benefit from being the computation of
all 16 parity bits.

-----------------------------------------------------------------------------------------------
End of file UART9_readme.txt
-----------------------------------------------------------------------------------------------
