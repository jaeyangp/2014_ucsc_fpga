`timescale 1ns / 1ps

module add3(in, out); 
	parameter N = 4;
	
	input [N-1:0] in; 
	output [N-1:0] out; 
	reg [N-1:0] out; 
 
	always @ (in) begin
		case (in) 
			4'b0000: out <= 4'b0000; 
			4'b0001: out <= 4'b0001; 
			4'b0010: out <= 4'b0010; 
			4'b0011: out <= 4'b0011; 
			4'b0100: out <= 4'b0100; 
			4'b0101: out <= 4'b1000; 
			4'b0110: out <= 4'b1001; 
			4'b0111: out <= 4'b1010; 
			4'b1000: out <= 4'b1011; 
			4'b1001: out <= 4'b1100; 
			default: out <= 4'b0000; 
		endcase
	end
endmodule 

module bin2bcd(in, ones, tens, hundreds, thousands);
	parameter N = 14;		// input size, decimal 9999 is hex 270f (14 bits)
	parameter C = 4;		// chunk size
	input [N-1:0] in; 
	output [C-1:0] ones, tens, hundreds, thousands; 
	
	wire [C-1:0] d1, d2, d3, d4, d5, d6, d7, d8;
	wire [C-1:0] d9, d10, d11, d12, d13, d14, d15, d16;
	wire [C-1:0] d17, d18, d19, d20, d21, d22, d23, d24, d25, d26;
	wire [C-1:0] c1, c2, c3, c4, c5, c6, c7, c8;
	wire [C-1:0] c9, c10, c11, c12, c13, c14, c15, c16;
	wire [C-1:0] c17, c18, c19, c20, c21, c22, c23, c24, c25, c26;
	
 
	assign d1 = {1'b0, in[13:11]}; 
	add3 #(C) m1(d1, c1); 
	
	assign d2 = {c1[2:0], in[10]}; 
	add3 #(C) m2(d2, c2); 
	
	assign d3 = {c2[2:0], in[9]}; 
	add3 #(C) m3(d3, c3); 
	
	assign d4 = {c3[2:0], in[8]}; 
	add3 #(C) m4(d4, c4); 
	
	assign d5 = {c4[2:0], in[7]}; 
	add3 #(C) m5(d5, c5); 
	
	assign d6 = {c5[2:0], in[6]}; 
	add3 #(C) m6(d6, c6); 

	assign d7 = {c6[2:0], in[5]}; 
	add3 #(C) m7(d7, c7); 

	assign d8 = {c7[2:0], in[4]}; 
	add3 #(C) m8(d8, c8); 

	assign d9 = {c8[2:0], in[3]}; 
	add3 #(C) m9(d9, c9); 

	assign d10 = {c9[2:0], in[2]}; 
	add3 #(C) m10(d10, c10); 

	assign d11 = {c10[2:0], in[1]}; 
	add3 #(C) m11(d11, c11); 

	assign d12 = {1'b0, c1[3], c2[3], c3[3]}; 
	add3 #(C) m12(d12, c12); 

	assign d13 = {c12[2:0], c4[3]}; 
	add3 #(C) m13(d13, c13); 

	assign d14 = {c13[2:0], c5[3]}; 
	add3 #(C) m14(d14, c14); 

	assign d15 = {c14[2:0], c6[3]}; 
	add3 #(C) m15(d15, c15); 

	assign d16 = {c15[2:0], c7[3]}; 
	add3 #(C) m16(d16, c16); 

	assign d17 = {c16[2:0], c8[3]}; 
	add3 #(C) m17(d17, c17); 

	assign d18 = {c17[2:0], c9[3]}; 
	add3 #(C) m18(d18, c18); 

	assign d19 = {c18[2:0], c10[3]}; 
	add3 #(C) m19(d19, c19); 

	assign d20 = {1'b0, c12[3], c13[3], c14[3]}; 
	add3 #(C) m20(d20, c20); 

	assign d21 = {c20[2:0], c15[3]};
	add3 #(C) m21(d21, c21); 
	
	assign d22 = {c21[2:0], c16[3]};
	add3 #(C) m22(d22, c22); 

	assign d23 = {c22[2:0], c17[3]};
	add3 #(C) m23(d23, c23); 

	assign d24 = {c23[2:0], c18[3]};	
	add3 #(C) m24(d24, c24);

	assign d25 = {1'b0, c20[3], c21[3], c22[3]};
	add3 #(C) m25(d25, c25); 
	
	assign d26 = {c25[2:0], c23[3]};
	add3 #(C) m26(d26, c26); 

	assign ones = {c11[2:0], in[0]}; 
	assign tens = {c19[2:0], c11[3]}; 
	assign hundreds = {c24[2:0], c19[3]}; 
	assign thousands = {c26[2:0], c24[3]};	
 
endmodule 