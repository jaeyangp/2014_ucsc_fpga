////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2004 Xilinx, Inc.
// All Rights Reserved
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: 1.01
//  \   \         Filename: uart_clock.v
//  /   /         Date Last Modified:  08/04/2004
// /___/   /\     Date Created: 10/xx/2002
// \   \  /  \
//  \___\/\___\
//
//Device:  	Xilinx
//Purpose: 	
// 	KCPSM3 reference design - Real Time Clock with UART communications
// 	The design demonstrates the following:-
//           Connection of KCPSM3 to Program ROM
//           Connection of UART macros supplied with PicoBlaze with
//                Baud rate generation
//           Definition of input and output ports with 
//                Minimum decoding
//                Pipelining where appropriate
//           Interrupt circuit with
//                Simple fixed period timer
//                Automatic clearing using interrupt acknowledge from KCPSM3
//
// 	The design is set up for a 50MHz system clock and UART communications 
//	rate of 38400 baud.
//
// 	Please read design documentation to modify to your own requirements.
//
//Reference:
// 	None
//Revision History:
//    Rev 1.00 - kc - Start of design entry in VHDL,  10/xx/2002.
//    Rev 1.01 - sus - Converted to verilog,  08/04/2004.
////////////////////////////////////////////////////////////////////////////////
// Contact: e-mail  picoblaze@xilinx.com
//////////////////////////////////////////////////////////////////////////////////
//
// Disclaimer: 
// LIMITED WARRANTY AND DISCLAIMER. These designs are
// provided to you "as is". Xilinx and its licensors make and you
// receive no warranties or conditions, express, implied,
// statutory or otherwise, and Xilinx specifically disclaims any
// implied warranties of merchantability, non-infringement, or
// fitness for a particular purpose. Xilinx does not warrant that
// the functions contained in these designs will meet your
// requirements, or that the operation of these designs will be
// uninterrupted or error free, or that defects in the Designs
// will be corrected. Furthermore, Xilinx does not warrant or
// make any representations regarding use or the results of the
// use of the designs in terms of correctness, accuracy,
// reliability, or otherwise.
//
// LIMITATION OF LIABILITY. In no event will Xilinx or its
// licensors be liable for any loss of data, lost profits, cost
// or procurement of substitute goods or services, or for any
// special, incidental, consequential, or indirect damages
// arising from the use or operation of the designs or
// accompanying documentation, however caused and on any theory
// of liability. This limitation will apply even if Xilinx
// has been advised of the possibility of such damage. This
// limitation shall apply not-withstanding the failure of the 
// essential purpose of any limited remedies herein. 
//////////////////////////////////////////////////////////////////////////////////


module uart_clock
(	tx,
	rx,
	alarm,
	clk);

output	tx;
input 	rx;
output 	alarm;
input 	clk;

wire   	tx;
wire   	rx;
reg   	alarm;
wire   	clk;


//
//----------------------------------------------------------------------------------
//
// declaration of KCPSM3
//
//
// declaration of program ROM
//
//
// declaration of UART transmitter with integral 16 byte FIFO buffer
//
//
// declaration of UART Receiver with integral 16 byte FIFO buffer
//
//
//----------------------------------------------------------------------------------
//
// Signals used to connect KCPSM3 to program ROM and I/O logic
//
wire [9:0] 	address;
wire [17:0]	instruction;
wire [7:0]	port_id;
wire [7:0] 	out_port;
reg [7:0] 	in_port;
wire  	write_strobe;
wire  	read_strobe;
reg  		interrupt;
wire  	interrupt_ack;

// Signals for connection of peripherals
wire [7:0] 	uart_status_port;

// Signals to form an timer generating an interrupt every microsecond
reg [6:0] 	timer_count;
reg  		timer_pulse;

// Signals for UART connections

reg [9:0] 	baud_count;
reg  		en_16_x_baud;
wire  	write_to_uart;
wire  	tx_full;
wire  	tx_half_full;
reg  		read_from_uart;
wire [7:0] 	rx_data;
wire  	rx_data_present;
wire  	rx_full;
wire  	rx_half_full;

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------
//
// Start of circuit description
//
//
//--------------------------------------------------------------------------------------------------------------------------------
// KCPSM3 and the program memory 
//--------------------------------------------------------------------------------------------------------------------------------
//

kcpsm3 processor
(	.address(address),
    	.instruction(instruction),
    	.port_id(port_id),
    	.write_strobe(write_strobe),
    	.out_port(out_port),
    	.read_strobe(read_strobe),
    	.in_port(in_port),
    	.interrupt(interrupt),
    	.interrupt_ack(interrupt_ack),
    	.reset(1'b0),
    	.clk(clk));

uclock program_rom
(	.address(address),
    	.instruction(instruction),
   	.clk(clk));

//
//--------------------------------------------------------------------------------------------------------------------------------
// Interrupt 
//--------------------------------------------------------------------------------------------------------------------------------
//
//
// Interrupt is a generated once every 50 clock cycles to provide a 1us reference. 
// Interrupt is automatically cleared by interrupt acknowledgment from KCPSM3.
//
//

always @(posedge clk) begin
      
      if (timer_count==49) 
		begin
         		timer_count <= 1'b0;
         		timer_pulse <= 1'b1;
		end
       else
		begin
         		timer_count <= timer_count + 1;
         		timer_pulse <= 1'b0;
		end
      

      if (interrupt_ack == 1'b1)
		begin
         		interrupt <= 1'b0;
		end
       else if (timer_pulse == 1'b1) 
		begin 
         		interrupt <= 1'b1;
		end
        else
		begin
         		interrupt <= interrupt;
		end

end

//--------------------------------------------------------------------------------------------------------------------------------
// KCPSM3 input ports 
//--------------------------------------------------------------------------------------------------------------------------------
//
//
// UART FIFO status signals to form a bus
//

  assign uart_status_port = {3'b 000,rx_data_present,rx_full,rx_half_full,tx_full,tx_half_full};

//
// The inputs connect via a pipelined multiplexer
//

  always @(posedge clk) begin
    case(port_id[0] )
    // read UART status at address 00 hex
    1'b 0 : 
	begin
      in_port <= uart_status_port;
    	end
    // read UART receive data at address 01 hex
    1'b 1 : 
	begin
      in_port <= rx_data;
    	end
    // Don't care used for all other addresses to ensure minimum logic implementation
    default : 
	begin
      in_port <= 8'b XXXXXXXX;
    	end
    endcase

    // Form read strobe for UART receiver FIFO buffer.
    // The fact that the read strobe will occur after the actual data is read by 
    // the KCPSM3 is acceptable because it is really means 'I have read you'!

    read_from_uart <= read_strobe & port_id[0] ;

  end

//--------------------------------------------------------------------------------------------------------------------------------
// KCPSM3 output ports 
//--------------------------------------------------------------------------------------------------------------------------------
//
// adding the output registers to the clock processor
  always @(posedge clk) begin
    if(write_strobe == 1'b 1) begin
      // Alarm register at address 00 hex with data bit0 providing control
      if(port_id[0]  == 1'b 0) begin
        alarm <= out_port[0] ;
      end
    end
  end

//
// write to UART transmitter FIFO buffer at address 01 hex.
// This is a combinatorial decode because the FIFO is the 'port register'.
//
assign write_to_uart = write_strobe & port_id[0] ;
//
//--------------------------------------------------------------------------------------------------------------------------------
// UART  
//--------------------------------------------------------------------------------------------------------------------------------
//
// Connect the 8-bit, 1 stop-bit, no parity transmit and receive macros.
// Each contains an embedded 16-byte FIFO buffer.
//
uart_tx transmit
(	.data_in(out_port),
    	.write_buffer(write_to_uart),
    	.reset_buffer(1'b0),
    	.en_16_x_baud(en_16_x_baud),
    	.serial_out(tx),
    	.buffer_full(tx_full),
    	.buffer_half_full(tx_half_full),
    	.clk(clk));

uart_rx receive
(	.serial_in(rx),
    	.data_out(rx_data),
    	.read_buffer(read_from_uart),
    	.reset_buffer(1'b0),
    	.en_16_x_baud(en_16_x_baud),
    	.buffer_data_present(rx_data_present),
    	.buffer_full(rx_full),
    	.buffer_half_full(rx_half_full),
    	.clk(clk));


// Set baud rate to 96 for the UART communications
// Requires en_16_x_baud to be 153600Hz which is a single cycle pulse every 325 cycles at 50MHz 
//
// NOTE : If the highest value for baud_count exceeds 127 you will need to adjust 
//        the width in the reg declaration for baud_count.
//
//--------------------------------------------------------------------------------------------------------------------------------
  always @(posedge clk) begin
      if (baud_count == 324) 
		begin
           		baud_count <= 1'b0;
      	     	en_16_x_baud <= 1'b1;
		end
       else
		begin
           		baud_count <= baud_count + 1;
           		en_16_x_baud <= 1'b0;
      	end
    end

endmodule

//----------------------------------------------------------------------------------------------------------------------------------
//
// END OF FILE uart_clock.v
//
//----------------------------------------------------------------------------------------------------------------------------------

