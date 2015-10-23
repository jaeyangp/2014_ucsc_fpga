`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCSC Extension - Digital Design using FPGA
// Engineer: Jae-Yang Park
// 
// Create Date:    19:54:34 02/16/2014 
// Design Name: 
// Module Name:    all_pattern 
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

module counter(clk, arst,q) ;
  parameter N = 7 ;
  input clk,arst ;
  output [N-1:0] q ;
  reg [N-1:0] q ;
 
  always@(posedge clk or posedge arst)
  if (arst == 1'b1)
  q <= 0 ;
  else
  q <= q + 1 ;  
endmodule
 
module all_pattern(CLK1, arst, seg, an, Led) ;
  parameter C = 26 ;
  parameter N = 7 ;
  parameter W = 4 ;
  parameter CRYSTAL = 50 ; // 50 MHZ
  parameter NUM_SEC = 1 ;
  parameter STOPAT = (CRYSTAL * 1_000_000 * NUM_SEC)- 1;
 
  input CLK1, arst;
  output [0:N-1] seg ;
  output [3:0] an ;
  output [W-1:0] Led ;
  wire [C-1:0] clock ;
  wire [W-1:0] zero_to_f_counter ;
  wire one_second_clock ;
 
  assign an = 4'b0000 ; /* ON ON OFF ON */
  assign one_second_clock = (clock == STOPAT) ? 1: 0 ;
 
  counter #C U(CLK1,(arst|| one_second_clock),clock) ;
  counter #W S(one_second_clock,arst,zero_to_f_counter) ;
  hex2_7seg_lut D(zero_to_f_counter,seg);
  assign Led = zero_to_f_counter;
endmodule
 
endmodule
