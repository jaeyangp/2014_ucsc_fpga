`timescale 1ns / 1ps

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

module decoder(text, s, y, val) ;
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
  
module display(text, clk, arst, seg, an);
	parameter C = 26;	// counter, 
	parameter N = 7;	// seven segment
	parameter W = 4;	
	parameter S = 2;
	parameter ANODE_FREQ = 19;
	
	input [15:0] text;
	input clk, arst;
	output [0:N-1] seg;
	output [W-1:0] an;
	
	wire [C-1:0] q;
	wire [S-1:0] sel;
	wire [W-1:0] zero_to_f_counter;

	assign sel[1] = q[ANODE_FREQ];
	assign sel[0] = q[ANODE_FREQ - 1];
	
	counter #C DISP_C (.clk(clk), .arst(arst), .en(1), .q(q));
	decoder DISP_D (.text(text), .s(sel), .y(an), .val(zero_to_f_counter));
	hex2_7seg_lut DISP_H (.in(zero_to_f_counter), .out(seg));
	
endmodule
