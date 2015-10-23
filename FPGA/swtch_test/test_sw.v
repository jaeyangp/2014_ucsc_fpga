`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCSC Extension-Digital Design using FPGA
// Engineer: Jae-Yang Park
// 
// Create Date:    18:10:41 02/02/2014 
// Design Name: 
// Module Name:    test_sw 
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
module test_sw(in, out);
	input [7:0] in;
	output [7:0] out;
	reg [7:0] out;
	
	always @(*) begin
		casex(in)
			8'b1xxx_xxxx: out = 8'b10000000;
			8'b01xx_xxxx: out = 8'b01000000;
			8'b001x_xxxx: out = 8'b00100000;
			8'b0001_xxxx: out = 8'b00010000;
			8'b0000_1xxx: out = 8'b00001000;
			8'b0000_01xx: out = 8'b00000100;
			8'b0000_001x: out = 8'b00000010;
			8'b0000_0001: out = 8'b00000001;
			default: out = 8'b00000000;
		endcase
	end
endmodule

module test_sw_lut(in, out);
	input [7:0] in;
	output [7:0] out;
	wire out7654, out321;
	
	LUT4 #(16'hFF00) U7 (out[7], in[4], in[5], in[6], in[7]);
	LUT4 #(16'h00F0) U6 (out[6], in[4], in[5], in[6], in[7]);
	LUT4 #(16'h000C) U5 (out[5], in[4], in[5], in[6], in[7]);
	LUT4 #(16'h0002) U4 (out[4], in[4], in[5], in[6], in[7]);
	
	LUT4 #(16'h0001) UG0 (out7654, in[4], in[5], in[6], in[7]);
	
	LUT4 #(16'hF000) U3 (out[3], in[1], in[2], in[3], out7654);
	LUT4 #(16'h0C00) U2 (out[2], in[1], in[2], in[3], out7654);
	LUT4 #(16'h0200) U1 (out[1], in[1], in[2], in[3], out7654);
	
	LUT4 #(16'h0001) UG1 (out321, in[1], in[2], in[3], 1'b0);
	
	LUT4 #(16'h4000) U0 (out[0], 1'b0, in[0], out321, out7654);
	
endmodule

module s3_test_sw(sw, Led);
	input [7:0] sw;
	output [7:0] Led;
	
	test_sw U (.in(sw), .out(Led));
endmodule

module s3_test_sw_lut(sw, Led);
	input [7:0] sw;
	output [7:0] Led;
	
	test_sw_lut U (.in(sw), .out(Led));
endmodule

module isequal(in, equal_out);
	input [7:0] in;
	output equal_out;
	wire [7:0] f1, f2;
	
	test_sw U1 (.in(in), .out(f1));
	test_sw_lut U2 (.in(in), .out(f2));
	
	assign equal_out = (f1 == f2) ? 1'b0 : 1'b1;

endmodule
