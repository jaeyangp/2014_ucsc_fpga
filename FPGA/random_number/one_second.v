`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCSC Extendion - Digital Design using FPGA
// Engineer: Jae-Yang Park
// 
// Create Date:    18:45:09 02/09/2014 
// Design Name:  Problem 3.7.6
// Module Name:    oneminute
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
module counter(clk, arst, en, q);
	parameter N = 7;
	
	input clk, arst, en;
	output [N-1:0] q;
	reg [N-1:0] q;
	
	always @(posedge clk or posedge arst)
		if (arst == 1'b1)
			q <= 0;
		else if (en)
			q <= q + 1;
endmodule

module mod_counter(clk, arst, q, done);
	parameter N = 7;
	parameter MAX = 127;
	
	input clk, arst;
	output [N-1:0] q;
	output done;
	reg [N-1:0] q;
	reg done;
	
	always @(posedge clk or posedge arst) begin
		if (arst == 1'b1) begin
			q <= 0;
			done <= 0;
		end
		else if (q == MAX) begin
			q <= 0;
			done <= 1;
		end
		else begin
			q <= q + 1;
			done <= 0;
		end
	end
endmodule
	
module one_second(CLK1, arst, one_sec_clock);
	parameter C = 26;	// counter, 
	parameter CRYSTAL = 50;	// 50MHz
	parameter NUM_SEC = 1;	
	parameter [C-1:0] STOPAT = (CRYSTAL * 1_000_000 * NUM_SEC) - 1;
	
	input CLK1, arst;
	output one_sec_clock;
	wire [C-1:0] clock;
	
	mod_counter #(C, STOPAT) ONE_MC (.clk(CLK1), .arst(arst), .q(clock), .done(one_sec_clock));
endmodule
