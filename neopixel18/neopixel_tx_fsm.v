//	Copyright (c) 2015 Kareem Matariyeh
//
//	Licensed under the Apache License, Version 2.0 (the "License");
//	you may not use this file except in compliance with the License.
//	You may obtain a copy of the License at
//
//		 http://www.apache.org/licenses/LICENSE-2.0
//
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Creator: 		 Kareem Matariyeh (asm2750)
//
// Create Date:    23:00:15 01/03/2015
// Design Name: 	 neopixel_tx
// Module Name:    neopixel_tx_fsm
// Project Name: 	 neopixel (ws2812) transmitter
// Target Devices: Any device able to fit design at timing requirements
// Tool versions:  Any tool able to synthesize design
// Description: 	 This state machine reads from a FIFO interface and outputs the
//						 data serially using the neopixel(ws2812) signaling standard.
//
// Dependencies: 	 None, module prefers to use FIFO but a GPIO can work too
//
// Revision:
// Revision 1.00 - Design Implmented and working on Spartan 6 XC6SLX6
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module neopixel_tx_fsm(
	input wire clk,					// 20MHz clock for FSM
	input wire rst,					// active low reset
	input wire mode,					// 1 = 800kHz speed, 0 = 400kHz
	input wire tx_enable,			// xmit enable flag so user can preload fifo
	input wire empty_flg,			// FIFO empty status indicator
	input wire [23:0] neo_dIn,		// data order is GRB with G7 (msb) transmitted first
	input wire rgb_msgTyp,			// 1 = color data message, 0 = reset message (51us low)

	output wire rd_next,				// read strobe for FSM
	output wire neo_tx_out			// neopixel data stream output
   );

	// state machine definitions
	parameter idle = 2'b00;				// nothing happening or hard reset
	parameter chk_fifo = 2'b01;		// FIFO read handler
	parameter neo_sendRst = 2'b10;   // reset signal send state
	parameter neo_sendRGB = 2'b11; 	// color data send state

	// FSM counter
	reg [1:0] neostate;

	// data sender related members
	reg [4:0] dataCntr; 	// counter for data bits
	reg [9:0] pulseCntr;	// full pulse width counter
	reg tx_compSig;		// FSM signal to exit a send state
	reg neo_dOut;			// data stream output register

	// output signal boundry members
	wire [9:0] onePulse; 	// hi signal time for 1
	wire [9:0] zeroPulse;  	// hi signal time for 0
	wire [9:0] fullPulse;	// entire pulse width time

	// output signal boundry values
	parameter rst_pulse 	= 10'd1020; // reset pulse is always 51us

	parameter one800 		= 10'd12;	// all vals are:
	parameter zero800		= 10'd5;		// (#cycles - 2) * period + 2 clk period
	parameter pulse800	= 10'd23;   // i.e. a 350ns pulse is 350ns/50ns - 2 = 5 cycles

	parameter one400		= 10'd12;
	parameter zero400		= 10'd26;
	parameter pulse400	= 10'd48;


	// state machine block -- controls state of entire design
	always@(posedge clk or negedge rst) begin
		if(!rst) begin // async reset
			neostate <= idle;
		end
		else begin // actual state machine

			case(neostate)
				idle: begin // start up and reset goes idle
					if(!empty_flg && tx_enable) begin // FIFO must be not empty and tx enabled
						neostate <= chk_fifo;
					end
				end // end idle state

				chk_fifo: begin // check message type in the msg FIFO

					if(empty_flg || !tx_enable) begin // if tx disabled or FIFO is empty then go idle
						neostate <= idle;
					end

					else begin // there is a message in the msg FIFO and the tx enabled, go to desired
						// save the FIFO output for compatability with other FIFOs
						if(rgb_msgTyp) begin // color data message is in the FIFO
							neostate <= neo_sendRGB;
						end

						else begin // reset message in the FIFO
							neostate <= neo_sendRst;
						end
					end // end else
				end // end chk_fifo state


				// *** NOTE: These two states run until finished, only a reset will force an exit
				neo_sendRst: begin // send a reset signal then check the FIFO for another message
					if(tx_compSig) begin // check if sender is finished
						neostate <= chk_fifo;
					end
				end // end neo_sendRst

				neo_sendRGB: begin // send 24 bits of color data that is being output by FIFO
					if(tx_compSig) begin
						neostate <= chk_fifo;
					end
				end // end neo_sendRGB

			endcase // end state machine case
		end
	end // end state machine block


	// data sender block -- used to control data output
	always@(posedge clk/*pulseCntr, neostate*/) begin

		if(neostate == neo_sendRst) begin // bring the serial output low for 51us

			if(pulseCntr >= rst_pulse) begin	// 51us has elapsed signal the FSM,
				tx_compSig <= 1;					// get next FIFO element if possible, and keep output low
				neo_dOut <= 0;
			end

			else begin // 51us has not yet passed
				neo_dOut <= 0;
			end
		end // neo_sendRst

		else if(neostate == neo_sendRGB) begin // sending color data

			if(dataCntr > 0) begin // if the data counter is above 0 keep processing

				if(pulseCntr == fullPulse) begin // if a full pulse was sent then deinc the data counter
					dataCntr <= dataCntr - 5'd1;
				end
				else if((neo_dIn[dataCntr - 1] && pulseCntr > onePulse && pulseCntr < fullPulse) ||
						  (!neo_dIn[dataCntr - 1] && pulseCntr > zeroPulse && pulseCntr < fullPulse)) begin
					neo_dOut <= 0;		// if the pulse counter is past the high boundry then output low till next data bit
				end

				else begin
					neo_dOut <= 1; 	// if the pulse counter is not past the high boundry then output high
				end
			end // end dataCntr > 0

			else begin // reached the end of the data, let the FSM know and reset the counter
				dataCntr <= 5'd24;
				tx_compSig <= 1;
			end
		end // neo_sendRGB

		else begin // all other states
			dataCntr <= 5'd24; // keep the data counter in the reset state
			tx_compSig <= 0;	 // keep the signal low so FSM doesnt get confused

			if(neostate == chk_fifo && rgb_msgTyp && !empty_flg && tx_enable) begin // output preset
				neo_dOut <= 1; // if the next message is color data then bring the output high
			end

			else  begin // if one of the requirements above is missing then keep the output low
				neo_dOut <= 0;
			end
		end // all other states

	end // end data sender block


	// pulse counter block -- used to get accurate output pulses
	always@(posedge clk) begin

		// if a send state is active then increment the pulse counter
		if(neostate == neo_sendRst)begin // count for 51us when in the reset state

			if(pulseCntr <= rst_pulse - 10'd1) begin
				pulseCntr <= pulseCntr + 10'd1;
			end
		end // end neo_sendRst

		else if (neostate == neo_sendRGB) begin // color data state

			if(pulseCntr <= fullPulse) begin // count for a full pulse length
				pulseCntr <= pulseCntr + 10'd1;
			end

			else begin // once a full pulse has been sent reset for next bit
				 pulseCntr <= 0;
			end
		end // end neo_sendRGB

		else begin // all other states dont use the counter
			pulseCntr <= 0;
		end
	end // end pulse counter


	// pulse width times based on the value of mode (1 = 800kHz, 0 = 400kHz)
	// value is in clk cycles (clks should be subtracted so pulse is accurate i.e. 350ns = 5 cycles not 7)
	assign onePulse = (mode)? one800 : one400;
	assign zeroPulse = (mode)? zero800 : zero400;
	assign fullPulse = (mode)? pulse800 : pulse400;

	assign rd_next = tx_compSig; // FIFO read next signal is tied to the tx complete signal
	assign neo_tx_out = neo_dOut; // connect the output register to the output port

endmodule
