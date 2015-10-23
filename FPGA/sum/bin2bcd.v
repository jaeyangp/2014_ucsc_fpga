`timescale 1ns / 1ps

module bin2bcd(in, out);
	parameter N = 14;		// input size, decimal 9999 is hex 270f (14 bits)
	parameter C = 4;		// chunk size
	input [N-1:0] in; 
	output [15:0] out; 	// bcd output
	
	reg [N-1:0] bin;
	reg [N+3:0] bcd;
	reg [N+3:0] result;
	
	assign out = bcd[15:0];
	
	always @(*) begin
		bin = in;
		result = 0;
		
		repeat (N - 1) begin
			result[0] = bin[N-1];
			if (result[3:0] > 4)
				result[3:0] = result[3:0] + 4'd3;
			if (result[7:4] > 4)
				result[7:4] = result[7:4] + 4'd3;
			if (result[11:8] > 4)
				result[11:8] = result[11:8] + 4'd3;
			if (result[15:12] > 4)
				result[15:12] = result[15:12] + 4'd3;
				
			result = result << 1;
			bin = bin << 1;
		end

		result[0] = bin[N-1];
		bcd <= result;
	end
endmodule	
