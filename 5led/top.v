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
assign PIN8 = 0;
assign PIN9 = 0;
assign PIN10 = 0;
assign PIN17 = 0;
assign PIN18 = 0;
assign PIN19 = 0;
assign LEDn = 1;

// pin signals
wire [0:4] led;
assign PIN20 = led[0];
assign PIN14 = led[1];
assign PIN13 = led[2];
assign PIN12 = led[3];
assign PIN11 = led[4];

// divide to 1Hz
wire freq1hz;
reg [19:0] divider;
initial divider <= 0;
always @(posedge INTERNAL_OSC) divider <= divider + 1;
assign freq1hz = divider[19];

logic logic(.clk(freq1hz), .led(led));

endmodule
