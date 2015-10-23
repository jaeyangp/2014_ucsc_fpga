////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2004 Xilinx, Inc.
// All Rights Reserved
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: 1.01
//  \   \         Filename: testbench.v
//  /   /         Date Last Modified:  08/04/2004
// /___/   /\     Date Created: 06/xx/2003
// \   \  /  \
//  \___\/\___\
//
//Device:  	Xilinx
//Purpose: 	
// 	Test Bench for kcpsm3_int_test.vhd
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



`timescale 1ns/100ps

module testbench;
  
// signals to connect kcpsm3_int_test 

wire [7:0] counter;
wire [7:0] waveforms;
reg interrupt_event;
reg clk;

// Define the unit under test

   kcpsm3_int_test uut
   (         .counter(counter),
             .waveforms(waveforms),
             .interrupt_event(interrupt_event),
             .clk(clk) );


// Test Bench begins
 
  // Nominal 50MHz clock which also defines number of cycles in simulation 


   parameter PERIOD = 20;

   always begin
      clk = 1'b0;
      #(PERIOD/2) clk = 1'b1;
      #(PERIOD/2);
   end  

initial
	begin
		interrupt_event <= 1'b0; 
      	#(30*PERIOD) interrupt_event <= 1'b1; 
		#(PERIOD) interrupt_event <= 1'b0; 
		#(67*PERIOD) interrupt_event <= 1'b1;
		#(PERIOD) interrupt_event <= 1'b0;  
		#(30*PERIOD) interrupt_event <= 1'b1; 
		#(PERIOD) interrupt_event <= 1'b0; 
		#(20*PERIOD);
    end

endmodule
