module top(
  PIN7, PIN8, PIN9, PIN10,
  PIN11, PIN12, PIN13, PIN14, PIN17, PIN18, PIN19, PIN20,
  LEDn
 );

// pins
inout PIN7, PIN8, PIN9, PIN10, PIN11, PIN12, PIN13, PIN14, PIN17, PIN18, PIN19, PIN20;
output LEDn;

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

// internal oscillator
wire INTERNAL_OSC;
defparam OSCH_inst.NOM_FREQ = "20.46";
OSCH OSCH_inst(.STDBY(1'b0), .OSC(INTERNAL_OSC), .SEDSTDBY());

// clock and reset
wire clk, rst;
assign clk = INTERNAL_OSC;
assign rst = PIN10;

// NeoPixel transmitter
wire neoPixelPin, rdNext, msgTyp;
assign PIN14 = neoPixelPin;
neopixel_tx_fsm np(
  .clk(clk),
  .rst(rst),
  .mode(1'b1),
  .tx_enable(1'b1),
  .empty_flg(1'b0),
  .neo_dIn(colors[23:0]),
  .rgb_msgTyp(msgTyp),
  .rd_next(rdNext),
  .neo_tx_out(neoPixelPin)
);

// EFB counter
wire efbOvf; // overflow at 39960, approximately 512Hz
efb EFB_inst(.tc_clki(clk), .tc_rstn(rst), .tc_int(efbOvf), .tc_oc());

// color control
reg [0:8] cnt; // counter for 512Hz to 1Hz
reg change; // color rotation requested, set every 1Hz, clear upon completion
reg [143:0] colors; // current colors
reg [5:0] index;
wire [4:0] pos = index[5:1]; // pixel position; reset WS2812 when >= pixel count
wire ticker = index[0]; // transmitter needs two clock cycles per message

assign msgTyp = pos < 5'd18;
always @(posedge clk or negedge rst) begin
  if (!rst) begin

    cnt <= 1'b0;
    change <= 1'b0;

    index <= ~6'd0;
    colors[23:0] <= 24'h660000;
    colors[47:24] <= 24'h333300;
    colors[71:48] <= 24'h006600;
    colors[95:72] <= 24'h003333;
    colors[119:96] <= 24'h000066;
    colors[143:120] <= 24'h330033;

  end else begin
    if (efbOvf) begin
      cnt <= cnt + 1'b1;
      if (cnt == 1'b0) begin
        change <= 1'b1;
      end
    end

    if (rdNext) begin
      index <= index - 5'd1;

      if (ticker && pos < 5'd18) begin
        if (change) begin
          change <= 1'b0;
        end else begin
          colors <= {colors[119:0], colors[143:120]};
        end
      end

    end
  end
end

endmodule
