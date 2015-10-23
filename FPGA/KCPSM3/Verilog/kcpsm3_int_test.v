////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2004 Xilinx, Inc.
// All Rights Reserved
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: 1.01
//  \   \         Filename: kcpsm3_int_test.v
//  /   /         Date Last Modified:  08/04/2004
// /___/   /\     Date Created: 06/xx/2003
// \   \  /  \
//  \___\/\___\
//
//Device:  	Xilinx
//Purpose: 	
// 	Interrupt test for KCPSM3 
//Reference:
// 	None
//Revision History:
//    Rev 1.00 - kc - Start of design entry in VHDL,  06/xx/2003.
//    Rev 1.01 - sus - Converted to verilog,  08/04/2004.
////////////////////////////////////////////////////////////////////////////////
// Contact: e-mail  picoblaze@xilinx.com
//////////////////////////////////////////////////////////////////////////////////
//
// Disclaimer: 
// LIMITED WARRANTY AND DISCLAIMER. These designs are
// provided to you "as is". Xilinx and its licensors make and you
// receive no warranties or conditions, express, implied,
// statutory or otherwise, and Xilinx specifically disclaims any
// implied warranties of merchantability, non-infringement, or
// fitness for a particular purpose. Xilinx does not warrant that
// the functions contained in these designs will meet your
// requirements, or that the operation of these designs will be
// uninterrupted or error free, or that defects in the Designs
// will be corrected. Furthermore, Xilinx does not warrant or
// make any representations regarding use or the results of the
// use of the designs in terms of correctness, accuracy,
// reliability, or otherwise.
//
// LIMITATION OF LIABILITY. In no event will Xilinx or its
// licensors be liable for any loss of data, lost profits, cost
// or procurement of substitute goods or services, or for any
// special, incidental, consequential, or indirect damages
// arising from the use or operation of the designs or
// accompanying documentation, however caused and on any theory
// of liability. This limitation will apply even if Xilinx
// has been advised of the possibility of such damage. This
// limitation shall apply not-withstanding the failure of the 
// essential purpose of any limited remedies herein. 
//////////////////////////////////////////////////////////////////////////////////



module kcpsm3_int_test
(	counter,
	waveforms,
	interrupt_event,
	clk );

output[7:0]	counter;
output[7:0] waveforms;
input 	interrupt_event;
input 	clk;

reg  [7:0] 	counter;
reg  [7:0] 	waveforms;
wire   	interrupt_event;
wire   	clk;


//
//----------------------------------------------------------------------------------
//
// Start of test achitecture
//
//
//----------------------------------------------------------------------------------
// Signals used to connect KCPSM3 to program ROM and I/O logic

wire [9:0] 	address;
wire [17:0] instruction;
wire [7:0] 	port_id;
wire [7:0] 	out_port;
wire [7:0] 	in_port;
wire  	write_strobe;
wire  	read_strobe;
reg  		interrupt;
wire  	interrupt_ack;
wire  	reset;

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------
//
// Start of circuit description
//

  // Inserting KCPSM3 and the program memory
	kcpsm3 processor
	(	.address(address),
		.instruction(instruction),
		.port_id(port_id),
		.write_strobe(write_strobe),
		.out_port(out_port),
    		.read_strobe(read_strobe),
    		.in_port(in_port),
    		.interrupt(interrupt),
    		.interrupt_ack(interrupt_ack),
    		.reset(reset),
    		.clk(clk));

  	int_test program
	(	.address(address),
		.instruction(instruction),
		.clk(clk));

  // Unused inputs on processor
  assign in_port = 8'b 00000000;
  assign reset = 1'b 0;

  // Adding the output registers to the processor
  always @(posedge clk) begin
    
    // waveform register at address 02
    if(port_id[1]  == 1'b 1 && write_strobe == 1'b 1) 
	begin
      	waveforms <= out_port;
	end
    
    // Interrupt Counter register at address 04
    if(port_id[2]  == 1'b 1 && write_strobe == 1'b 1) 
     	begin
      	counter <= out_port;
     	end
  end

  // Adding the interrupt input
  // Note that the initial value of interrupt (low) is  
  // defined at signal declaration.
  always @(posedge clk) begin
    if(interrupt_ack == 1'b 1) 
	begin
      	interrupt <= 1'b 0;
    	end
    else if(interrupt_event == 1'b 1) 
	begin
      	interrupt <= 1'b 1;
    	end
    else 
	begin
      	interrupt <= interrupt;
    	end
  end

endmodule

//----------------------------------------------------------------------------------
//
// END OF FILE KCPSM3_INT_TEST.V
//
//----------------------------------------------------------------------------------

