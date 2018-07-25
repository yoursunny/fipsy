module top(
  PIN7, PIN8, PIN9, PIN10,
  PIN11, PIN12, PIN13, PIN14, PIN17, PIN18, PIN19, PIN20,
  LEDn
 );

// pins
inout PIN7, PIN8, PIN9, PIN10, PIN11, PIN12, PIN13, PIN14, PIN17, PIN18, PIN19, PIN20;
output LEDn;
wire PIN7, PIN8, PIN9, PIN10, PIN11, PIN12, PIN13, PIN14, PIN17, PIN18, PIN19, PIN20, LEDn;

// internal oscillator
wire INTERNAL_OSC;
defparam OSCH_inst.NOM_FREQ = "2.08";
OSCH OSCH_inst(.STDBY(1'b0), .OSC(INTERNAL_OSC), .SEDSTDBY());

// default pin state
assign PIN7 = 0;
assign PIN8 = 0;
assign PIN9 = 0;
assign PIN10 = 0;
assign PIN11 = 0;
assign PIN12 = 0;
assign PIN13 = 0;
assign PIN14 = 0;
assign PIN17 = 0;
assign PIN18 = 0;
assign PIN19 = 0;
assign PIN20 = 0;
assign LEDn = 0;

endmodule
