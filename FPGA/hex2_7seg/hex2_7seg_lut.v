`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCSC Extension - Digital Design using FPGA
// Engineer: Jae-Yang Park
// 
// Create Date:    18:53:04 02/03/2014 
// Design Name: 
// Module Name:    hex2_7seg_lut 
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
module hex2_7seg_lut(in, out);
	input [3:0] in;
	output [6:0] out;
	
	LUT4 #(16'h2812) CA (out[6], in[0], in[1], in[2], in[3]);	// a
	LUT4 #(16'hd860) CB (out[5], in[0], in[1], in[2], in[3]);	// b
	LUT4 #(16'hd004) CC (out[4], in[0], in[1], in[2], in[3]);	// c
	LUT4 #(16'h8492) CD (out[3], in[0], in[1], in[2], in[3]);	// d
	LUT4 #(16'h02ba) CE (out[2], in[0], in[1], in[2], in[3]);	// e
	LUT4 #(16'h208e) CF (out[1], in[0], in[1], in[2], in[3]);	// f
	LUT4 #(16'h1083) CG (out[0], in[0], in[1], in[2], in[3]);	// g

endmodule

module s3_hex2_7seg(sw, seg, an);
	input [3:0] sw;
	output [0:6] seg;
	output [3:0] an;
	
	assign an = 4'b0000;
	hex2_7seg_lut U(.in(sw), .out(seg));
endmodule