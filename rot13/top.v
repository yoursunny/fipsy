`include "baudgen.vh"

module top(
  PIN7, PIN8, PIN9, PIN10,
  PIN11, PIN12, PIN13, PIN14, PIN17, PIN18, PIN19, PIN20,
  LEDn
 );

// pins
inout PIN7, PIN8, PIN9, PIN10, PIN11, PIN12, PIN13, PIN14, PIN17, PIN18, PIN19, PIN20;
output LEDn;

// internal oscillator
wire INTERNAL_OSC;
defparam OSCH_inst.NOM_FREQ = "2.08";
OSCH OSCH_inst(.STDBY(1'b0), .OSC(INTERNAL_OSC), .SEDSTDBY());

// default pin state
assign PIN7 = 0;
assign PIN10 = 0;
assign PIN11 = 0;
assign PIN12 = 0;
assign PIN13 = 0;
assign PIN14 = 0;
assign PIN17 = 0;
assign PIN18 = 0;
assign PIN19 = 0;
assign PIN20 = 0;

// wires
wire clk, rxPin, txPin, rxAvail, txReady;
wire [7:0] rxByte;
wire [7:0] rotByte;
reg hasByte = 0;
reg insertNewline = 0;
reg [7:0] txByte;
reg txStart = 0;
reg [0:0] lossCnt = 0;
assign clk = INTERNAL_OSC;
assign PIN9 = rxPin;
assign PIN8 = txPin;
assign LEDn = lossCnt[0];

// modules
uart_rx #(.BAUDRATE(`B115200)) RX0 (
  .clk(clk),
  .rstn(1'b1),
  .rx(rxPin),
  .rcv(rxAvail),
  .data(rxByte)
);

uart_tx #(.BAUDRATE(`B115200)) TX0 (
  .clk(clk),
  .rstn(1'b1),
  .start(txStart),
  .data(txByte),
  .tx(txPin),
  .ready(txReady)
);

// logic
assign rotByte =
  ((rxByte >= 8'h41 && rxByte <= 8'h4D) || (rxByte >= 8'h61 && rxByte <= 8'h6D)) ? rxByte + 8'd13 :
  ((rxByte >= 8'h4E && rxByte <= 8'h5A) || (rxByte >= 8'h6E && rxByte <= 8'h7A)) ? rxByte - 8'd13 :
  rxByte;

always @(posedge clk) begin
  txStart = 1'b0;
  if (rxAvail) begin
    if (hasByte) begin
      lossCnt = lossCnt + 1'b1;
    end
    txByte = rotByte;
    hasByte = 1'b1;
  end
  if (txReady & hasByte) begin
    txStart = 1'b1;
    hasByte = 1'b0;
    if (insertNewline) begin
      insertNewline = 1'b0;
      txByte = 8'h0A;
    end else if (txByte == 8'h0D) begin
      insertNewline = 1'b1;
      hasByte = 1'b1;
    end
  end
end

endmodule
