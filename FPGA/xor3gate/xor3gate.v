`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCSC Extension - Digital Design with FPGA
// Engineer: Jae-Yang Park
// 
// Create Date:    19:12:43 01/27/2014 
// Design Name: 
// Module Name:    xor3gate 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module xor3gate(a, b, c, f);
	input a, b, c;
	output f;
	
	assign f = a ^ b ^ c;
endmodule

module s3_xor3gate(sw, Led);
	input 	[5:3] sw;
	output 	[5:5] Led;
	
	xor3gate U1 (.a(sw[5]), .b(sw[4]), .c(sw[3]), .f(Led[5]));
endmodule	