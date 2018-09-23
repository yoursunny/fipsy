module logic(buzzer0, buzzer1, clk, tempo);

`include "notes.vh"

output buzzer0, buzzer1;
input clk;   // 2.08MHz
input tempo; // 32Hz

reg [9:1] state;
reg [17:1] div0;
reg [17:1] div1;
wire enable;

defparam w0.width = 13;
wave w0(.buzzer(buzzer0), .clk(clk), .enable(enable), .div(div0), .volume(1'b1));
defparam w1.width = 13;
wave w1(.buzzer(buzzer1), .clk(clk), .enable(enable), .div(div1), .volume(1'b1));

wire [6:0] index;
assign index = state[9:3];

always @(posedge tempo) begin
  state = state + 1;
  case (index)
    0,1: div0 = M6;
    2,3: div0 = M6;
    4,5,6,7: div0 = M7;
    8,9: div0 = M6;
    10,11: div0 = M6;
    12,13,14,15: div0 = M7;
    16,17: div0 = M6;
    18,19: div0 = M7;
    20,21: div0 = H1;
    22,23: div0 = M7;
    24,25: div0 = M6;
    26: div0 = M7;
    27: div0 = M6;
    28,29,30,31: div0 = M4;
    32,33: div0 = M3;
    34,35: div0 = M1;
    36,37: div0 = M3;
    38,39: div0 = M4;
    40,41: div0 = M3;
    42: div0 = M3;
    43: div0 = M1;
    44,45,46,47: div0 = L7;
    48,49: div0 = M6;
    50,51: div0 = M7;
    52,53: div0 = H1;
    54,55: div0 = M7;
    56,57: div0 = M6;
    58: div0 = M7;
    59: div0 = M6;
    60,61,62,63: div0 = M4;
    64,65: div0 = M3;
    66,67: div0 = M1;
    68,69: div0 = M3;
    70,71: div0 = M4;
    72,73: div0 = M3;
    74: div0 = M3;
    75: div0 = M1;
    76,77,78,79: div0 = L7;
    80,81: div0 = M6;
    82,83: div0 = M6;
    84,85,86,87: div0 = M7;
    88,89: div0 = M6;
    90,91: div0 = M6;
    92,93,94,95: div0 = M7;
    96,97: div0 = M3;
    98,99: div0 = M4;
    100: div0 = M7;
    101: div0 = M6;
    102,103: div0 = M4;
    104,105,106,107,108,109: div0 = M3;
    default: div0 = 0;
  endcase
  case (index)
    0,1: div1 = M6;
    2,3: div1 = M4;
    4,5,6,7: div1 = M3;
    8,9: div1 = M6;
    10,11: div1 = M4;
    12,13,14,15: div1 = M3;
    16: div1 = M4;
    17: div1 = M3;
    18: div1 = M2;
    19: div1 = M3;
    20,21: div1 = M6;
    22,23: div1 = M4;
    24: div1 = M3;
    25: div1 = M4;
    26: div1 = M3;
    27: div1 = M1;
    28,29,30,31: div1 = M2;
    32,33: div1 = M1;
    34,35: div1 = L6;
    36: div1 = L7;
    37: div1 = M1;
    38,39: div1 = M2;
    40,41: div1 = M3;
    42: div1 = M3;
    43: div1 = M1;
    44,45,46,47: div1 = L7;
    48: div1 = M4;
    49: div1 = M3;
    50: div1 = M2;
    51: div1 = M3;
    52,53: div1 = M6;
    54,55: div1 = M4;
    56: div1 = M3;
    57: div1 = M4;
    58: div1 = M3;
    59: div1 = M1;
    60,61,62,63: div1 = M2;
    64,65: div1 = M1;
    66,67: div1 = L6;
    68: div1 = L7;
    69: div1 = M1;
    70,71: div1 = M2;
    72,73: div1 = M3;
    74: div1 = M1;
    75: div1 = L6;
    76,77,78,79: div1 = L7;
    80: div1 = M3;
    81: div1 = M4;
    82: div1 = M3;
    83: div1 = M1;
    84,85,86,87: div1 = M3;
    88: div1 = M3;
    89: div1 = M4;
    90: div1 = M3;
    91: div1 = M1;
    92,93,94,95: div1 = M3;
    96,97: div1 = M3;
    98,99: div1 = M2;
    100: div1 = M4;
    101: div1 = M3;
    102,103: div1 = M2;
    104,105,106,107,108,109: div1 = M3;
    default: div1 = 0;
  endcase
end

assign enable = (index <= 109);

endmodule
