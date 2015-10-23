READ_ME.TXT file for KCPSM3
---------------------------

[Release 8a - 4th August - New ZIP file to correct fault with PB_BMM.EXE file supplied Release 8]


Release 8

Date : 6th July 2005

Macro Version v1.30
Assembler Version v1.30

This is the 8th release of PicoBlaze for Spartan-3, Spartan-3E Virtex-II, Virtex-IIPro and 
Virtex-4 devices. 

Note that the main documentation for this macro, User Guide (UG129), is not included in 
this package. It should be downloaded from the PicoBlaze web site (www.xilinx.com/picoblaze)
where a forum and other user pages can also be accessed. 



New information
---------------

This release includes minor changes to the assembler and provides descriptions and tools to 
facilitate the use of the Xilinx DATA2MEM utility (see DATA2MEM_assistance directory). This 
provides a way to modify a PicoBlaze program directly in the configuration BIT file and should 
be very useful for program development in designs.

Additional UART macros are provided (in VHDL) which allow parity bits to be transmitted and 
received. These have been used in a few designs, but your help is requested in verifying them and 
any feedback would be most welcome. Please see the VHDL directory for the additional files and notes. 

My continued thanks to Nick Sawyer and Shalin Sheth of Xilinx for their ongoing support of the 
Verilog files. 


Relatively New Information
--------------------------

Do check out the JTAG loader utility which allows rapid modifications to be made to PSM 
programs during development. Once you have used it once, you will use it all the time.  
Thanks here to Kristian Chaplin of Xilinx for this very useful tool. 

The assembler has a new 'INST' directive (please read Additional Assembler Notes). 
 

Author
------

Ken Chapman
email: chapman@xilinx.com 
Staff Engineer - Applications Specialist
Xilinx Ltd (UK)

email: ken.chapman@xilinx.com



picoblaze@xilinx.com
-------------------- 

It is advised that questions are directed to 'picoblaze@xilinx.com' especially concerning the 
Verilog code. Use of the PicoBlaze forum is also encouraged.  


Quick Description
-----------------

KCPSM3 is a very simple 8-bit micro controller designed to be 100% embedded into a 
Spartan-3(E), Virtex-II(PRO) or Virtex-4 device and is based on the popular KCPSM and 
KCPSM2 macros which have the collective name 'PicoBlaze'.

It features 16 general purpose registers and an internal 64-byte scratch pad memory. 
A simple ALU supporting addition, subtraction, compare, logical operations and testing 
including parity, shifts and rotates. The ALU also supports Carry and Zero flags which
can be used in conditional jumps and calls. An internal program counter stack supports 
nested subroutines automatically. Controls include a reset, an interrupt and interrupt
acknowledge. 

The KCPSM3 assembler is supplied to assist in the development of programs. 

Performance >44 MIPS. Best of all, it uses just 96 slices 
   - you could fit 12 of them into an XC3S200 device, but would you ever need to?!

The main documentation is provided in User Guide UG129 and is supplemented by the original 
'KCPSM3_manual.pdf' supplied with this package.


Important Note
--------------

It should be appreciated that it is virtually impossible to fully test a processor given
the almost infinite number of combinations of code and signals which can be encountered. 
However, KCPSM3 benefited greatly from being based heavily on the experience gained with 
KCPSM and KCPSM2 which are extremely stable designs used by thousands of engineers for 
nearly five years. KCPSM3 was completed in June 2003 and has been a used by many engineers
in a wide range of applications during the past 24 months.

So although this version of KCPSM3 and the assembler are believed to be stable and fully 
operational, your help is requested in the continuous verification of the functionality
of the KCPSM3 macro and assembler. All reports, (good or bad) or recommendations will be 
gratefully received by the author..... 

Please send your reports via email to: ken.chapman@xilinx.com


 
KCPSM3 Macro Revision History
-----------------------------

V1.00 - First release to users.
V1.10 - Change of '--translate off' and '--translate on' meta command directives 
        to '--synthesis translate off' and '--synthesis translate on'. 
V1.20 - Addition of code to enhance simulation. No functional changes. 
V1.30 - Functional change. The ENABLE INTERRUPT instruction is used to enable 
        the interrupt input and an active interrupt automatically disables future
        interrupts. The functional change was made to deal with a situation in which
        the ENABLE INTERRUPT instruction is being used in a program at a point where
        the interrupt input is already enabled. If the execution of this instruction
        occurred at the same time as an active interrupt event, the net effect was 
        that the interrupts were not disabled by the interrupt event. The change 
        has no effect on any other situation. 

        An improvement to the ZERO and CARRY flag logic was also made which has no 
        effect on functionality but is an enhancement to performance.

        
KCPSM3 Assembler Revision History
---------------------------------

V1.00  - First release to users.
V1.01  - Improvement to interpretation of PSM file name.
V1.10  - Support of Verilog and System Generator design flows.
V1.12  - Improved handling of TAB characters and blank lines in PSM file.
V1.13  - Allow ROM_form.v to contain concatenation statements which use curly brackets.
V1.20  - Addition of the INST directive. Improved coverage of Verilog syntax.
V1.30  - Time stamp added to the LOG, VHDL and Verilog files (The ROM_form templates 
         supplied with this release are required to benefit from this feature).
         Generation of MEM file required by DATA2MEM. 


Contents
--------

This package contains many files, but don't panic, many of them are additional 
files which I hope you will find useful reference. Files have been grouped into 
directories to help you find the files you would like to access.


READ_ME.TXT - This file

KCPSM3_Manual.PDF - Alternative and older form of documentation for KCPSM3.
              Please see User Guide UG129 for more further information.

UART_Manual.pdf - Documentation for simple UART transmitter and Receiver macros which are 
                  suitable for connection to KCPSM3.

UART_real_time_clock.pdf - Documentation for a reference design in which KCPSM3 and the UART macros
                           are used to provide a real time digital clock with alarm. The document 
                           describes key aspects of the VHDL hardware design and assembler code.

kcpsm3.ngc - This is an alternative file defining the KCPSM3 processor and 
             would be used as a 'black box' in a non HDL design flow.




VHDL files
----------

kcpsm3.vhd. - The VHDL definition of the KCPSM3 processor. This file is the 
              primary design flow for implementation and simulation. The use of 
              this file is described in the documentation.

embedded_kcspm3.vhd - VHDL file in which the KCPSM3 processor is connected to its 
                      associated program ROM. This can be used as example code and 
                      is described in the documentation.   
               
kcpsm3_int_test.vhd - Example design VHDL file as used in the documentation.

test_bench.vhd - Example VHDL test bench to use with kcpsm3_int_test.vhd to 
                 reproduce the wave forms seen in the documentation.

uart_clock.vhd - VHDL hardware description for the real time clock reference design

uart_tx.vhd - UART transmitter, 8-bit, no parity, 1 stop bit, with integral 16-byte FIFO 
              buffer. Occupies 18 slices.

uart_rx.vhd - UART receiver, 8-bit, no parity, 1 stop bit, with integral 16-byte FIFO buffer.
              Occupies 22 slices.

kcuart_tx.vhd - UART transmitter, 8-bit, no parity, 1 stop bit.
                Can be used standalone, but typically used as part of uart_tx.vhd.

kcuart_rx.vhd - UART receiver, 8-bit, no parity, 1 stop bit.
                Can be used standalone, but typically used as part of uart_rx.vhd.

bbfifo_16x8.vhd - A 16 byte synchronous FIFO buffer occupying 8 slices.
                  Used in uart_tx and uart_rx, but also useful standalone.


UART9_readme.txt - Description of the 9-bit UART macros suitable for parity operations.
                   NOTE: You should be familiar with the normal 8-bit UART macros and 
                   documentation before trying these versions.

uart9_tx.vhd - 9-bit UART transmitter with integral 16-character FIFO buffer.

uart9_rx.vhd - 9-bit UART receiver with integral 16-character FIFO buffer.

kcuart9_tx.vhd - 9-bit UART transmitter.

kcuart9_rx.vhd - 9-bit UART receiver.

bbfifo9_16x9.vhd - A 16 character synchronous FIFO buffer occupying 9 slices.
                   Used in uart9_tx and uart9_rx, but also useful standalone.





Verilog files
-------------

kcpsm3.v. - The Verilog definition of the KCPSM3 processor. This file is the 
            primary design flow for implementation and simulation. The use of 
            this file is described in the documentation.

embedded_kcspm3.v - Verilog file in which the KCPSM3 processor is connected to its 
                    associated program ROM. This can be used as example code and 
                    is described in the documentation.   
               
kcpsm3_int_test.v - Example design Verilog file as used in the documentation.

testbench.v - Example Verilog test bench to use with kcpsm3_int_test.v to 
              reproduce the wave forms seen in the documentation.

uart_clock.v - VHDL hardware description for the real time clock reference design

uart_tx.v - UART transmitter, 8-bit, no parity, 1 stop bit, with integral 16-byte FIFO 
            buffer. Occupies 18 slices.

uart_rx.v - UART receiver, 8-bit, no parity, 1 stop bit, with integral 16-byte FIFO buffer.
            Occupies 22 slices.

kcuart_tx.v - UART transmitter, 8-bit, no parity, 1 stop bit.
              Can be used standalone, but typically used as part of uart_tx.v.

kcuart_rx.v - UART receiver, 8-bit, no parity, 1 stop bit.
              Can be used standalone, but typically used as part of uart_rx.v.

bbfifo_16x8.v - A 16 byte synchronous FIFO buffer occupying 8 slices.
                Used in uart_tx and uart_rx, but also useful standalone.



Assembler Files
---------------

**NOTE** You must copy KCPSM3.EXE, ROM_form.vhd, ROM_form.v and ROM_form.coe into 
your working director regardless of which HDL language you are using. Please also 
read "Additional Assembler Notes" included later.


KCPSM3.EXE - The assembler for KCPSM3 programs.

ROM_form.vhd - VHDL template file read by the assembler and used to define the 
               style in which the program ROM will be implemented. This file 
               must be placed in the same working directory as KCPSM3.EXE.

ROM_form.v - Verilog template file read by the assembler and used to define the 
             style in which the program ROM will be implemented. This file 
             must be placed in the same working directory as KCPSM3.EXE.

ROM_form.coe - Coefficient template file read by the assembler and used to define
               the style in which the program ROM will be implemented via the 
               Core Generator flow. This file must be placed in the same working
               directory as KCPSM3.EXE.

cleanup.bat - simple batch file to use after successful assembly of your code. 
              At the dos prompt type 'cleanup <progname>' and this batch file
              will replace your PSM file with the formatted (FMT) file. It will
              maintain one copy of your original file as 'previous_<progname>.psm'.
 
int_test.psm - Example PSM file as used in the documentation.

uclock.psm - PSM assembler program for the real time clock reference design



JTAG Loader
-----------

JTAG_loader_quick_guide.pdf - Description of how to use the JTAG loader.

hex2svfsetup.exe  - Four executables used in the loading sequence
hex2svf.exe
svf2xsvf.exe
playxsvf.exe

jtag_loader.bat - Batch file to automate execution sequence

JTAG_Loader_ROM_form.vhd - New ROM template to include JTAG interface. Remember 
                  to rename as 'ROM_form.vhd' and overwrite the normal file
                  used by the KCPSM3 assembler.

Normal_ROM_form.vhd - The normal 'ROM_form.vhd' file when development is complete.

JTAG_Loader_ROM_form.v - New ROM template to include JTAG interface. Remember 
                  to rename as 'ROM_form.v' and overwrite the normal file
                  used by the KCPSM3 assembler.

Normal_ROM_form.v - The normal 'ROM_form.v' file when development is complete.



DATA2MEM_assistance Files
-------------------------

DATA2MEM_how_to_use_it_with_PicoBlaze.txt - Description of a DATA2MEM design flow.

change_pb_bits.bat - Batch file to automate the DATA2MEM design flow and provide a 
                     starting point for your own batch files.

PB_BMM.EXE - Program to assist in the identification of Block Memories in your designs. 



Additional Assembler Notes
--------------------------

Copy KCPSM3.EXE into your working directory. You must also copy the template 
files ROM_form.vhd, ROM_form.v and ROM_form.coe into the same directory. All template 
files are required, regardless of the design flow you intend to use.

You can modify the template files (see documentation), but no checking of syntax
is performed by the assembler. The JTAG loader uses different templates which are 
provided.

The assembler is only a simple DOS based utility. File names have a limit of 8-characters
and care should be taken not to use in a project directory with a very deep hierarchy 
requiring a long path specification. If you encounter an unexpected failure, please 
attempt to assemble you program in a simple directory such as c:\temp to determine if 
the problem is related to these DOS limitations. 

The assembler is normally used by first opening a DOS window in the working directory
and then executing KCPSM3 from within that window (please see KCPSM3_manual.pdf). 
Attempting to execute KCPSM3.EXE  directly from within Windows will only cause a DOS 
box to be displayed momentarily providing no opportunity to enter a PSM file name.

It is highly recommended that all files required by the assembler are located in the 
same working directory. Users have been successful using this utility on various networks
but the author will not support or address any issues related to any difficulties 
resulting from using KCPSM3 in this way.

To redirect the DOS screen output to a file the > symbol can be used in the DOS 
command line. 

C:\DESIGN>kcpsm3 simple > screen_dump.txt

Many PicoBlaze users have also reported how much they like the free assembler and 
simulator provided by Mediatronix. 


INST Directive

Version v1.20 of the assembler introduced a new 'INST' directive which allows the 
definition of any instruction code in line with the existing instructions. The INST
directive has only one operand which must be a 5 digit hexadecimal value in the range
00000 to 3FFFF corresponding to the 18-bit instruction memory formed in a Block RAM.

Examples of valid syntax for INST directive

    INST 3245C
    INST 14FA2
    inst 2abfe

This directive was added to enable data to be embedded within the program memory
space which can then be accessed via the second port of the dual port Block RAM. 
The INST directives will normally be preceded by the ADDRESS directive to locate 
such data at a predictable location within the memory space.

Obviously great care should be taken to ensure that data values are not encountered by 
KCPSM3 during normal operation as the macro does not support illegal op-code trapping.
 


More than 96 slices or less than 96 slices! 
-------------------------------------------

When synthesizing the 'kcpsm3.vhd' file using XST (Release 6.1.01i - xst G.24) the 
reported design figures for all the primitive components will be correct. However, the 
'Device utilization summary' will provide an estimate of 131 slices for the final size.
Fortunately, the MAP tool is able to recognise the relationship between the large 
number of primitives and achieve the much smaller size of 96 slices.

Occasionally constraints on the design may result in a small increase in size when 
mapped. For example, forcing the mapping into a rectangular area has been shown to 
result in a size of 98 slices.

A figure of 91 slices can be achieved by adjusting the MAP property called 
'CLB Pack Factor Percentage' to '1' (default is '100'). This should be considered as
the minimum size for the complete macro.

It is quite common to not utilise all the available input and output signals of the 
KCPSM3 macro in the system design. For example, the INTERRUPT input may be connected
to 'GND' and READ_STROBE and INTERRUPT_ACK may be left unconnected. This can result in 
a small reduction in size as the MAP tool removes unnecessary logic. However, the 
reductions in size will be in the order of a few slices and any significant reduction
should be investigated as this would most likely indicate an error in your design 
(i.e. failure to connect a valid clock input). 



Potential synthesis issues
--------------------------

The HDL supplied for the KCPSM3 macro and the HDL generated by the assembler 
(derived from the ROM_form templates) has been written to be suitable for both 
synthesis and simulation. 

In order for a simulator to have the correct information, the code includes 'INIT'
values defined using 'generic map' statements for each primitive component.
Synthesis tools also require the 'INIT' values to be defined, but in this case the 
definition is performed using a separate 'attribute' statements'. The synthesis tool 
must then be instructed to ignore the 'generic map' information which is achieved
using meta command directives. Unfortunately, there is no real standard for these 
directives and different synthesis tools will expect slightly different syntax.

The supplied HDL has been written using the directives '--synthesis translate_off'
and '--synthesis translate_on' and can be seen in the code as shown in this example:-

  t_state_lut: LUT1
  --synthesis translate_off
    generic map (INIT => X"1")         
  --synthesis translate_on
  port map( I0 => t_state,
             O => not_t_state );

If your synthesis tool reports any issues with processing the 'INIT' values declared 
as part of the 'generic map' statements then it is not ignoring these lines as intended.
In this case you should globally replace the directives in the 'kcpsm3' and 
'ROM_form' files to match the requirements of your synthesis tool. The syntax 
variants of this meta command directive encountered by the author are as follows:-

--translate_off                --translate_on 
--synthesis translate_off      --synthesis translate_on
--synopsys translate_off       --synopsys translate_on
--pragma translate_off         --pragma translate_on

XST is able to interpret all of the above variants so '--synthesis translate_off'
and '--synthesis translate_on' have been used in the supplied code because it is
the most frequently acceptable variant by other synthesis tools.



XST in ISE v7.1i - WARNING:Xst:2185
-----------------------------------

With this release, XST was given the ability to interpret INIT values contained in 
generic maps and this should ultimately avoid the requirement to have separate INIT 
attributes and generic maps.

Unfortunately, this enhancement now results in XST producing numerous warning messages
of the type 'WARNING:Xst:2185' which report a "Possible simulation mismatch". Although 
these can be safely ignored (and filtered) it is appreciated that they are less than 
desirable. 

It is hoped that the KCPSM3 code can be supplied in a modified form in the near future. 
However, until it is confirmed that changes to coding style are correctly interpreted
by the tools from all leading HDL synthesis and simulation vendors this will not be 
possible. I hope you can understand my position in this respect and will be patient for 
a return to a truly clean solution once again.   

How to filter this message. 

In Project navigator -> Edit -> Message Filters... 
    Check the box next to 'Filter enabled' and then save using File -> Save

Now return to your project and run XST again and when you return to the message filters
window you will find that all the warning messages have appeared in the lower half of the 
screen. 

Move any one of the XST 2185 messages into the top window (Click once on message to select
it and then click and drag it to the top window).

In the top window, select the box under 'Filter Text' and right click to choose the 'Delete'
option. This will change the text to read "blank" line "blank": Possible... etc. Now this one
filter will remove all of the 2185 warnings in one go.

Save the changes with File -> Save.

Now when running XST all of the 2185 messages will have been removed.





Simulation with VHDL-87
-----------------------

Some VHDL simulators may not be able to use the VHDL supplied as it uses various VHDL-93
constructs. In this case, it may be better to generate a simulation model for KCPSM3
using the following command....

ngd2vhdl kcspm3.ngd sim_model_kcpsm3.vhd

Obviously, this model should not then be used for synthesis. 


-------------------------------------------------------------------------------
END OF FILE READ_ME.TXT
-------------------------------------------------------------------------------


