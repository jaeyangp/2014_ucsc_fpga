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
	
module decoder(text,s,y,val) ;
	input [15:0] text;
	input [1:0] s ;
	output reg [3:0] y ;
	output reg [3:0] val ;
 
	always @(*) begin
		case (s)
			0: begin
				y <= 4'b1110 ;
				val <= text[3:0] ;
			end
			1:begin
				y <= 4'b1101 ;
				val <= text[7:4] ;
			end
			2:begin
				y <= 4'b1011 ;
				val <= text[11:8] ;
			end
			3: begin
				y <= 4'b0111 ;
				val <= text[15:12] ;
			end
			default:begin
				y <= 4'bx ;
				val <= 4'bx ;
			end
		endcase
	end
 endmodule
  
module display(CLK1, arst, seg, an, Led);
	parameter C = 26;	// counter, 
	parameter N = 7;	// seven segment
	parameter W = 3;	// size of binary number, # of Led
	parameter CRYSTAL = 50;	// 50MHz
	parameter NUM_SEC = 1;	
	parameter [C-1:0] STOPAT = (CRYSTAL * 1_000_000 * NUM_SEC) - 1;
	
	parameter ROMOUT = 14;	// size of rom output
	parameter BCD = 4;		// size of bcd
	
	input CLK1, arst;
	output [0:N-1] seg;
	output [3:0] an;
	output [W-1:0] Led;
	wire [C-1:0] clock;
	wire [W-1:0] zero_to_f_counter;
	wire one_sec_clock;
	wire [ROMPUT-1:0] random_num;
	wire [BCD-1:0] ones, tens, hundreds, thousands;
	
	assign an = 4'b0000;
	
	mod_counter #(C, STOPAT) U1 (.clk(CLK1), .arst(arst), .q(clock), .done(one_sec_clock));
	//counter #(W) S (.clk(CLK1), .arst(arst), .en(one_sec_clock), .q(zero_to_f_counter));
	//rom #(W, ROMOUT) R (.in(zero_to_f_counter), .out(random_num));
	//bin2bcd #(ROMOUT, BCD) B (.in(random_num), .ones(ones), .tens(tens), .hundreds(hundreds), .thousands(thousands));
	
	
	//hex2_7seg_lut D (bcd_out, seg);
	
	//assign Led = zero_to_f_counter;
endmodule
