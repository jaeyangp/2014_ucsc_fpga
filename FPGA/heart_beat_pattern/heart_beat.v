`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCSC Extension-Digital Design using FPGA
// Engineer: Jae-Yang Park
// 
// Create Date:    12:21:12 02/17/2014 
// Design Name: Problem 3.7.8
// Module Name:    heart_beat 
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

`define USQUARE 7'b0011100
`define DSQUARE 7'b1100010

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
	
module heart_beat(CLK1, arst, seg, an);
	parameter N = 7;	// seven segment
	parameter C = 27;	// counter, 
	parameter CRYSTAL = 50;	// 50MHz
	parameter NUM_SEC = 1;	
	parameter STOPAT = (CRYSTAL * 1_000_000 * NUM_SEC) - 1;
	
	input CLK1, arst;
	output [0:N-1] seg;
	output [3:0] an;
	reg [0:N-1] seg;
	reg [3:0] an, up_an, down_an;	
	reg [2:0] shift_count;
	reg up_down;	// 0: up, 1: down square
	
	// one second counter
	mod_counter #(C, STOPAT) U1 (.clk(CLK1), .arst(arst), .done(one_sec_clock));
	
	always @ (posedge one_sec_clock or posedge arst) begin
		if (arst == 1'b1) begin
			seg <= `USQUARE;
			an <= 4'b1111;
			up_an <= 4'b0111;
			down_an <= 4'b1110;
			shift_count <= 3'b000;
			up_down <= 1'b0;	// 0: upper square, 1: down
		end
		else begin
			if (up_down == 1'b0) begin
				seg <= `USQUARE;
				an <= up_an;
				up_an <= {up_an[0], up_an[3:1]};	// rotate 1 bit right

				if (shift_count == 3'b011) begin
					up_down <= 1'b1;
					up_an <= 4'b0111;
				end
			end
			else if (up_down == 1'b1) begin
				seg <= `DSQUARE;
				an <= down_an;
				down_an <= {down_an[2:0], down_an[3]};	// rotate 1 bit left
				
				if (shift_count == 3'b111) begin
					up_down <= 1'b0;
					down_an <= 4'b1110;
				end	
			end	
			
			shift_count <= shift_count + 1;
		end
	end
endmodule

