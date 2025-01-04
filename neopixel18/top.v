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
defparam OSCH_inst.NOM_FREQ = "20.46";
OSCH OSCH_inst(.STDBY(1'b0), .OSC(INTERNAL_OSC), .SEDSTDBY());

// default pin state
assign PIN7 = 0;
assign PIN8 = 0;
assign PIN9 = 0;
assign PIN11 = 0;
assign PIN12 = 0;
assign PIN13 = 0;
assign PIN17 = 0;
assign PIN18 = 0;
assign PIN19 = 0;
assign PIN20 = 0;
assign LEDn = 0;

// wires
wire clk, rst, neoPixelPin, rdNext, msgTyp;
reg [0:23] cnt;
reg change;
reg [7:0] ledG = 8'h0;
reg [7:0] ledR = 8'h0;
reg [7:0] ledB = 8'h0;
reg [5:0] index = 6'd0;
wire [4:0] pos = index[5:1];
wire ticker = index[0];

assign clk = INTERNAL_OSC;
assign rst = PIN10;
assign PIN14 = neoPixelPin;

// NeoPixel transmitter
neopixel_tx_fsm np(
  .clk(clk),
  .rst(rst),
  .mode(1'b1),
  .tx_enable(1'b1),
  .empty_flg(1'b0),
  .neo_dIn({ledG, ledR, ledB}),
  .rgb_msgTyp(msgTyp),
  .rd_next(rdNext),
  .neo_tx_out(neoPixelPin)
);

// color control
assign msgTyp = pos < 5'd18;
always @(posedge clk or negedge rst) begin
  if (!rst) begin

    cnt <= 1'b0;
    change <= 1'b0;

    index <= ~6'd0;

    ledG <= 8'h30;
    ledR <= 8'h00;
    ledB <= 8'h00;

  end else begin
    cnt <= cnt + 1'b1;
    if (cnt == 0) begin
      change <= 1'b1;
    end

    if (rdNext) begin
      index <= index - 5'd1;

      if (ticker && pos < 5'd18) begin
        if (change) begin
          change <= 1'b0;
        end else begin
          ledG <= ledR;
          ledR <= ledB;
          ledB <= ledG;
        end
      end

    end
  end
end

endmodule
