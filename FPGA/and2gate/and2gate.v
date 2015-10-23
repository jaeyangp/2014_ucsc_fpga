`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCSC Ext. Digital Design with FPGA
// Engineer: Jae-Yang Park
// 
// Create Date:    17:48:54 01/26/2014 
// Design Name: 
// Module Name:    and2gate 
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
module and2gate(a, b, f);
	input a, b;
	output f;
	
	assign f = a & b;
endmodule

module s3_and2gate (sw, Led);
	input [7:6] sw;
	output [4:4] Led;
	
	and2gate U1 (sw[7], sw[6], Led[4]);
endmodule	
