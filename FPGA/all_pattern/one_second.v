`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCSC Extension - Digital Design using FPGA
// Engineer: Jae-Yang Park
// 
// Create Date:    19:59:51 02/16/2014 
// Design Name: Problem 3.7.7
// Module Name:    disp_all_pattern 
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
	
module disp_all_pattern(CLK1, arst, seg, an);
	parameter N = 7;	// seven segment
	parameter C = 27;	// counter, 
	parameter CRYSTAL = 50;	// 50MHz
	parameter NUM_SEC = 1;	
	parameter STOPAT = (CRYSTAL * 1_000_000 * NUM_SEC) - 1;
	
	input CLK1, arst;
	output [0:N-1] seg;
	output [3:0] an;
	reg [0:N-1] seg;
	reg [3:0] an;	
	
	mod_counter #(C, STOPAT) U1 (.clk(CLK1), .arst(arst), .done(one_sec_clock));
	
	always @ (posedge one_sec_clock or posedge arst) begin
		if (arst == 1'b1) begin
			seg <= 7'b111_1111;
			an <= 4'b1111;
		end
		else begin
			seg <= seg - 1;
			an <= 4'b0000;		
		end
	end
	
endmodule

