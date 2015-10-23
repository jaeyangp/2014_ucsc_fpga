rem Batch file to update PicoBlaze program within a BIT file
rem Ken Chapman - Xilinx Ltd - July 2005
rem
rem  Invoke using command
rem   change_pb_bits prog_name design_name
rem     where
rem       program = The name of your PSM program (8 character limit)  
rem       design_name = The name of your top level design and BIT file
rem     Do not specify file extensions (names only)
rem
echo Running Assembler
kcpsm3 %1 
if exist .\%1.mem goto make_bmm:
  echo ERROR - Unable to assemble program - Check PSM file
  goto end
:make_bmm
echo Creating BMM file
echo Select a BRAM from the list provided
pb_bmm %1.bmm %2.ncd
if exist .\%1.bmm goto make_bit:
  echo ERROR - Unable to create BMM file - Check design name
  goto end
:make_bit
echo Generating new BIT file
data2mem -bm %1.bmm -bd %1.mem -bt %2.bit -o b new_%2.bit
:end
pause
