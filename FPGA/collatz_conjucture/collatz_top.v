`timescale 1ns / 1ps

module collatz(clk, arst, en, out);
	parameter N = 6;	// number to calc for collatz conjucture
	parameter C = 8; 	// size for count, 8 bit: ~ 255
	parameter O = 14;	// output size
	
	input clk, arst, en;	
	output [O-1:0] out;
	
	reg [O-1:0] number;
	
	assign out = number;
	
	always @(posedge clk or posedge arst) begin
		if (arst == 1'b1) begin
			number <= N;
		end	
		else if (en) begin
			if (number[0] == 1'b1) begin 	// odd number
				number <= 3 * number + 1;
			end	
			else begin							// even number
				number <= number >> 1;		// number/2
			end	
			
			if (number == 1)
				number <= number;
		end
	end	
endmodule
  
module collatz_top(CLK1, arst, seg, an, Led);
	parameter N = 7;
	parameter W = 4;
	parameter S = 8;
	parameter H = 14;
	parameter CL = 6;		// number to test
	
	input CLK1, arst;
	output [0:N-1] seg;
	output [W-1:0] an;
	output [S-1:0] Led;
	
	wire [15:0] text;
	wire one_sec;
	wire [S-1:0] num_sel;
	wire [H-1:0] bin_text;

	assign Led = (bin_text == 14'b1) ? Led : num_sel;
	
	one_second ONE (.CLK1(CLK1), .arst(arst), .one_sec_clock(one_sec));
	counter #(S) CNT (.clk(CLK1), .arst(arst), .en(one_sec), .q(num_sel));
	collatz #(.N(CL)) CALC (.clk(CLK1), .arst(arst), .en(one_sec), .out(bin_text));
	bin2bcd #(H, W) BCD (.in(bin_text), .ones(text[3:0]), .tens(text[7:4]), .hundreds(text[11:8]), .thousands(text[15:12]));
	display T (.text(text), .clk(CLK1), .arst(arst), .seg(seg), .an(an));

endmodule
