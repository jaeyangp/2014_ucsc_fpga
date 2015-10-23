`timescale 1ns / 1ps
module in_to_out(in, out);
	parameter IN = 8;
	parameter OUT = 16;
	input [IN-1:0] in;
	output [OUT-1:0] out;
	
	assign out = in;
endmodule

module add16(CLK1, arst, seg, an, Led);
	parameter N = 7;
	parameter W = 4;
	parameter S8 = 8;
	parameter S16 = 16;
	
	input CLK1, arst;
	output [0:N-1] seg;
	output [W-1:0] an;
	output [N:0] Led;
	
	wire [9:0] address;
	wire [17:0] instruction;
	wire [7:0] port_id, in_port, out_port;
	wire write_strobe, read_strobe, interrupt_ack;
	
	wire [N-1:0] seg_out;
	reg [7:0] out_port_reg_l, out_port_reg_h;
	wire [S16-1:0] out_port_reg;
	wire [S16-1:0] num;
	wire [S16-1:0] text;
	wire done;
	reg done_reg;
	
	assign out_port_reg = {out_port_reg_h, out_port_reg_l};

	embedded_kcpsm3 U(port_id, write_strobe, read_strobe, out_port, in_port, interrupt, interrupt_ack, arst, CLK1);
	in_to_out #(S16, S16) I(out_port_reg, num);
	bin2bcd #(S16, S16) M(num, text);
	display D(text, CLK1, arst, seg, an);
	one_second ONE (CLK1, arst, done);
	
	always @(posedge CLK1) begin
		if (arst == 1'b1) begin
			out_port_reg_l <= 7'b0;
			out_port_reg_h <= 7'b0;
		end
		else if (write_strobe == 1'b1) begin
			if (port_id[1:0] == 2'b01)
				out_port_reg_l <= out_port;
			else if (port_id[1:0] == 2'b10)	
				out_port_reg_h <= out_port;
		end
		else if (read_strobe == 1'b1)
			done_reg <= 1'b0;
		else
			done_reg <= done;
	end
	
	assign in_port = done_reg;
	assign Led = out_port_reg_l;

endmodule
