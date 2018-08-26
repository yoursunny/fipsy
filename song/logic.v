module logic(buzzer, clk, tempo);

`include "notes.vh"

output buzzer;
input clk;   // 2.08MHz
input tempo; // 32Hz

reg [9:1] state;
reg [17:1] div;
wire enable;

defparam w.width = 12;
wave w(.buzzer(buzzer), .clk(clk), .enable(enable), .div(div), .volume(1'b1));

wire [6:0] index;
assign index = state[9:3];

always @(posedge tempo) begin
  state = state + 1;
  case (index)
    0,1: div = M6;
    2,3: div = M6;
    4,5,6,7: div = M7;
    8,9: div = M6;
    10,11: div = M6;
    12,13,14,15: div = M7;
    16,17: div = M6;
    18,19: div = M7;
    20,21: div = H1;
    22,23: div = M7;
    24,25: div = M6;
    26: div = M7;
    27: div = M6;
    28,29,30,31: div = M4;
    32,33: div = M3;
    34,35: div = M1;
    36,37: div = M3;
    38,39: div = M4;
    40,41: div = M3;
    42: div = M3;
    43: div = M1;
    44,45,46,47: div = L7;
    48,49: div = M6;
    50,51: div = M7;
    52,53: div = H1;
    54,55: div = M7;
    56,57: div = M6;
    58: div = M7;
    59: div = M6;
    60,61,62,63: div = M4;
    64,65: div = M3;
    66,67: div = M1;
    68,69: div = M3;
    70,71: div = M4;
    72,73: div = M3;
    74: div = M3;
    75: div = M1;
    76,77,78,79: div = L7;
    80,81: div = M6;
    82,83: div = M6;
    84,85,86,87: div = M7;
    88,89: div = M6;
    90,91: div = M6;
    92,93,94,95: div = M7;
    96,97: div = M3;
    98,99: div = M4;
    100: div = M7;
    101: div = M6;
    102,103: div = M4;
    104,105,106,107,108,109: div = M3;
    default: div = 0;
  endcase
end

assign enable = (index <= 109);

endmodule
