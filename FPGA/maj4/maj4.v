`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCSC Extension - Digital Design with FPGA
// Engineer: Jae-Yang Park
// 
// Create Date:    19:09:53 01/28/2014 
// Design Name: 
// Module Name:    maj4 
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
module maj4(a, b, c, d, f);
	input a, b, c, d;
	output f;
	
	assign f = (a & b) | (a & c) | (a & d) | (b & c) | (b & d) | (c & d);
endmodule

module s3_maj4(sw, Led);
	input [6:3] sw;
	output [3:3] Led;
	
	maj4 U1 (.a(sw[6]), .b(sw[5]), .c(sw[4]), .d(sw[3]), .f(Led[3]));
	
endmodule
