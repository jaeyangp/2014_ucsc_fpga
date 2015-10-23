`timescale 1ns / 1ps

module mux51_case(in, out);
	parameter S = 3;			// 
	parameter N = 1 << S;	// # of cases
	input [N-1:0] in;
	output out;	
	reg out;

	wire [S-1:0] sel;
	
	assign sel[2:0] = in[7:5];
	
	always @(*) begin
		case (sel)
			3'b000: out = in[0];
			3'b001: out = in[1];
			3'b010: out = in[2];
			3'b011: out = in[3];
			3'b100: out = in[4];
			default: out = 1'b0;
		endcase
	end	
endmodule

module mux51_if(in, out);
	parameter S = 3;			// 
	parameter N = 1 << S;	// # of cases
	input [N-1:0] in;
	output out;	
	reg out;

	wire [S-1:0] sel;
	
	assign sel[2:0] = in[7:5];
	
	always @(*) begin
		out = (sel == 3'b000) ? in[0] :
				(sel == 3'b001) ? in[1] :
				(sel == 3'b010) ? in[2] :
				(sel == 3'b011) ? in[3] :
				(sel == 3'b100) ? in[4] : 1'b0;
	end	
endmodule

// 2 levels of logic  
module mux51_luts_1(in, out);
	parameter S = 3;			// 
	parameter N = 1 << S;	// # of cases
	input [N-1:0] in;
	output out;	
	
	wire [S-1:0] sel;
	wire l1, l2, l3, l4, l5;

	assign sel[2:0] = in[7:5];

	LUT4 #(16'h00ca) L1(l1, in[0], in[1], sel[0], 1'b0);
	LUT4 #(16'h00ca) L2(l2, in[2], in[3], sel[0], 1'b0);
	LUT4 #(16'h0002) L3(l3, in[4], sel[0], 1'b0, 1'b0);
	LUT4 #(16'h00ca) L4(l4, l1, l2, sel[1], 1'b0);
	LUT4 #(16'h0002) L5(l5, l3, sel[1], 1'b0, 1'b0);
	
	MUXF5 F5_1(out, l4, l5, sel[2]);

endmodule

// 1 level of logic
module mux51_luts_2(in, out);
	parameter S = 3;			// 
	parameter N = 1 << S;	// # of cases
	input [N-1:0] in;
	output out;	

	wire [S-1:0] sel;
	wire l1, l2, l3, l4, l5;

	assign sel[2:0] = in[7:5];

	LUT4 #(16'h00ca) L1(l1, in[0], in[1], sel[0], 1'b0);
	LUT4 #(16'h00ca) L2(l2, in[2], in[3], sel[0], 1'b0);
	LUT4 #(16'h0002) L3(l3, in[4], sel[0], 1'b0, 1'b0);
	MUXF5 F5_1(l4, l1, l2, sel[1]);
	MUXF5 F5_2(l5, l3, 1'b0, sel[1]);
	MUXF6 F6_1(out, l4, l5, sel[2]);

endmodule  

module mux_top(CLK1, arst, seg, an, Led);
	parameter N = 7;
	parameter W = 4;
	parameter S = 8;
	parameter H = 14;		// binary size ..9999
	parameter MS = 3;		// mux sel
	parameter MN = 1 << MS;		// mux 5:1 
	
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
	assign disp_text[7:4] = text[3:0];
	assign disp_text[11:8] = text[7:4];
	assign disp_text[15:12] = text[11:8];
	
	one_second ONE (.CLK1(CLK1), .arst(arst), .one_sec_clock(one_sec));
	counter #(MN+MS) CNT (.clk(CLK1), .arst(arst), .en(one_sec), .q(num_sel));
	mux51_case #(.S(MS)) MUX5_1 (.in(num_sel), .out(selected1));
	mux51_if #(.S(MS)) MUX5_2 (.in(num_sel), .out(selected2));
	mux51_luts_1 #(.S(MS)) MUX5_3 (.in(num_sel), .out(selected3));
	mux51_luts_2 #(.S(MS)) MUX5_4 (.in(num_sel), .out(selected4));
	bin2bcd #(H, W) BCD (.in(num_sel), .out(text));
	display T (.text(disp_text), .clk(CLK1), .arst(arst), .seg(seg), .an(an));

endmodule
