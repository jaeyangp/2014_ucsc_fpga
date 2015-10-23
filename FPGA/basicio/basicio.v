`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:41:37 03/16/2014 
// Design Name: 
// Module Name:    basicio 
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
module basicio(CLK1, sw, arst, seg, an, Led);
	parameter N = 7;
	parameter W = 4;
	
	input CLK1, arst;
	input [N:0] sw;
	output [0:N-1] seg;
	output [W-1:0] an;
	output [N:0] Led;
	
	//wire [9:0] address;
	//wire [17:0] instruction;
	wire [7:0] port_id, in_port, out_port;
	wire write_strobe;
	//wire interrupt_ack;
	wire read_strobe;
	reg [7:0] out_port_reg;
	
	embedded_kcpsm3 U(port_id, write_strobe, read_strobe, out_port, in_port, interrupt, interrupt_ack, arst, CLK1);
	
	always @(posedge CLK1) begin
		if (write_strobe) begin
			out_port_reg = out_port;
		end
	end

	hex2_7seg_lut H(out_port_reg, seg);
	
	assign an = 4'b0111;
	assign in_port = sw;
	assign Led = out_port_reg;

endmodule
