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
defparam OSCH_inst.NOM_FREQ = "7.00";
OSCH OSCH_inst(.STDBY(1'b0), .OSC(INTERNAL_OSC), .SEDSTDBY());

// default pin state
assign PIN7 = 0;
assign PIN8 = 0;
assign PIN9 = 0;
assign PIN17 = 0;
assign PIN18 = 0;
assign PIN19 = 0;
assign PIN20 = 0;
assign LEDn = 0;

// pin signals
wire key1, key2, key3, key4, buzzer;
assign key1 = ~PIN11;
assign key2 = ~PIN12;
assign key3 = ~PIN13;
assign key4 = ~PIN14;
assign PIN10 = ~buzzer;

defparam logic.freq = 7000000;
defparam logic.width = 15;
defparam logic.volw = 8;
defparam logic.volume = 7;
logic logic(.clk(INTERNAL_OSC), .key1(key1), .key2(key2), .key3(key3), .key4(key4), .buzzer(buzzer));

endmodule
