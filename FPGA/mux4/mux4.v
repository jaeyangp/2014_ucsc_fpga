`timescale 1ns / 1ps

module mux41_case(in, out);
	parameter S = 2;			// 
	parameter N = 1 << S;	// # of cases
	input [N+S-1:0] in;
	output out;	
	reg out;
	wire [S-1:0] sel;
	
	assign sel[1:0] = in[5:4];	
	
	always @(*) begin
		case (sel)
			2'b00: out = in[0];
			2'b01: out = in[1];
			2'b10: out = in[2];
			2'b11: out = in[3];
			default: out = 1'b0;
		endcase
	end	
endmodule
  
module mux41_3_luts(in, out);
	parameter S = 2;			// 
	parameter N = 1 << S;	// # of cases
	input [N+S-1:0] in;
	output out;	
	wire [S-1:0] sel;
	wire l1, l2;

	assign sel[1:0] = in[5:4];
	
	LUT4 #(16'h00ca) L1(l1, in[0], in[1], sel[0], 1'b0);
	LUT4 #(16'h00ca) L2(l2, in[2], in[3], sel[0], 1'b0);
	LUT4 #(16'h00ca) L3(out, l1, l2, sel[1], 1'b0);

endmodule

module mux41_2_luts_no_muxf5(in, out);
	parameter S = 2;			// 
	parameter N = 1 << S;	// # of cases
	input [N+S-1:0] in;
	output out;	
	wire [S-1:0] sel;
	wire l1, l2, o1;

	assign sel[1:0] = in[5:4];
	
	LUT4 #(16'h00ca) L1(l1, in[0], in[1], sel[0], sel[1]);
	LUT4 #(16'hca00) L2(l2, in[2], in[3], sel[0], sel[1]);

	MUXCY CY1(o1, 1'b1, 1'b0, l1);
	MUXCY CY2(out, 1'b1, o1, l2);
	
endmodule

module mux41_2_luts_1_muxf5(in, out);
	parameter S = 2;			// 
	parameter N = 1 << S;	// # of cases
	input [N+S-1:0] in;
	output out;	
	wire [S-1:0] sel;
	wire l1, l2;
	
	assign sel[1:0] = in[5:4];
	
	LUT4 #(16'h00ca) L1(l1, in[0], in[1], sel[0], 1'b0);
	LUT4 #(16'h00ca) L2(l2, in[2], in[3], sel[0], 1'b0);

	MUXF5 F5(out, l1, l2, sel[1]);
endmodule  

module mux_top(CLK1, arst, seg, an, Led);
	parameter N = 7;
	parameter W = 4;
	parameter S = 8;
	parameter H = 14;		// binary size ..9999
	parameter MS = 2;		// mux sel
	parameter MN = 1 << MS;		// mux 4:1 
	
	input CLK1, arst;
	output [0:N-1] seg;
	output [W-1:0] an;
	output [S-1:0] Led;
	
	wire [15:0] text, disp_text;
	wire one_sec;
	wire [S-1:0] num_sel;
	wire selected;
	wire selected1, selected2, selected3, selected4;

	assign Led = num_sel;
	assign selected = (selected1 == selected2 == selected3 == selected4);
	assign disp_text[3:0] = {3'b0, selected}; 
	assign disp_text[7:4] = 4'b0;
	assign disp_text[11:8] = text[3:0];
	assign disp_text[15:12] = text[7:4];
	
	one_second ONE (.CLK1(CLK1), .arst(arst), .one_sec_clock(one_sec));
	counter #(N-1) CNT (.clk(CLK1), .arst(arst), .en(one_sec), .q(num_sel));
	mux41_case #(.S(MS)) MUX4_1 (.in(num_sel), .out(selected1));
	mux41_3_luts #(.S(MS)) MUX4_2 (.in(num_sel), .out(selected2));
	mux41_2_luts_no_muxf5 #(.S(MS)) MUX4_3 (.in(num_sel), .out(selected3));
	mux41_2_luts_1_muxf5 #(.S(MS)) MUX4_4 (.in(num_sel), .out(selected4));
	bin2bcd #(H, W) BCD (.in(num_sel), .out(text));
	display T (.text(disp_text), .clk(CLK1), .arst(arst), .seg(seg), .an(an));

endmodule