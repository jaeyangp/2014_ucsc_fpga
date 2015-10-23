`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCSC Ext. FPGA Class
// Engineer: Jae-Yang Park
// 
// Create Date:    18:55:34 01/20/2014 
// Design Name: 
// Module Name:    sol1 
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
module sol1(a, b, c, f);
	input a, b, c;
	output f;
	
	assign f = a ^ b ^ c;
endmodule
