module logic(buzzer, clk, tempo);

`include "notes.vh"

output buzzer;
input clk;   // 2.08MHz
input tempo; // 32Hz

reg [11:1] state;
wire [17:1] div;
wire enable;

defparam w.width = 12;
wave w(.buzzer(buzzer), .clk(clk), .enable(enable), .div(div), .volume(1'b1));

always @(posedge tempo) begin
  state <= state + 1;
end

wire [8:0] index; // 8Hz
assign index = state[11:3];
assign div =
  (index <=   1) ? M6 :
  (index <=   3) ? M6 :
  (index <=   7) ? M7 :
  (index <=   9) ? M6 :
  (index <=  11) ? M6 :
  (index <=  15) ? M7 :
  (index <=  17) ? M6 :
  (index <=  19) ? M7 :
  (index <=  21) ? H1 :
  (index <=  23) ? M7 :
  (index <=  25) ? M6 :
  (index <=  26) ? M7 :
  (index <=  27) ? M6 :
  (index <=  31) ? M4 :
  (index <=  33) ? M3 :
  (index <=  35) ? M1 :
  (index <=  37) ? M3 :
  (index <=  39) ? M4 :
  (index <=  41) ? M3 :
  (index <=  42) ? M3 :
  (index <=  43) ? M1 :
  (index <=  47) ? L7 :
  (index <=  49) ? M6 :
  (index <=  51) ? M7 :
  (index <=  53) ? H1 :
  (index <=  55) ? M7 :
  (index <=  57) ? M6 :
  (index <=  58) ? M7 :
  (index <=  59) ? M6 :
  (index <=  63) ? M4 :
  (index <=  65) ? M3 :
  (index <=  67) ? M1 :
  (index <=  69) ? M3 :
  (index <=  71) ? M4 :
  (index <=  73) ? M3 :
  (index <=  74) ? M3 :
  (index <=  75) ? M1 :
  (index <=  79) ? L7 :
  (index <=  81) ? M6 :
  (index <=  83) ? M6 :
  (index <=  87) ? M7 :
  (index <=  89) ? M6 :
  (index <=  91) ? M6 :
  (index <=  95) ? M7 :
  (index <=  97) ? M3 :
  (index <=  99) ? M4 :
  (index <= 100) ? M7 :
  (index <= 101) ? M6 :
  (index <= 103) ? M4 :
  (index <= 109) ? M3 : 0;

assign enable = (index <= 109);

endmodule
