`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCSC Extension - Digital Design using FPGA
// Engineer: Jae-Yang Park
// 
// Create Date:    19:27:10 02/02/2014 
// Design Name: 
// Module Name:    test_sw_lut 
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
module test_sw_lut(in, out);
	input [7:0] in;
	output [7:0] out;
	reg [7:0] out;
	reg zero7654, zero321;
	
	always @ (*) begin
		LUT3 #(8'h0) U0_321 (zero321, in[3], in[2], in[1]);
		LUT4 #(16'h0) U0_4 (zero7654, in[7], in[6], in[5], in[4]);
		
		LUT1 #(2'h1) U7 (out[7], in[7]);
		LUT2 #(4'h2) U6 (out[6], in[7], in[6]);
		LUT3 #(8'h02) U5 (out[5], in[7], in[6], in[5]);
		LUT4 #(16'h0100) U4 (out[4], in[7], in[6], in[5], in[4]);
		
		LUT2 #(4'h2) U3 (out[3], zero7654, in[3]);
		LUT3 #(8'h02) U2(out[2], zero7654, in[3], in[2]);
		LUT4 #(16'h1) U1 (out[1], zero7654, in[3], in[2], in[1])'
		
		LUT3 #(8'h01) U0 (out[0], zero7654, zero321, in[0]);
	end
endmodule

module s3_test_sw(sw, Led);
	input [7:0] sw;
	output [7:0] Led;
	
	test_sw U1 (.in(sw), .out(Led));
endmodule

		
		


endmodule
