`define VOLW 1
`define CLKFREQ 2080000

localparam integer L5 = (`CLKFREQ / 195.998 / (1 << `VOLW));
localparam integer L6 = (`CLKFREQ / 220.000 / (1 << `VOLW));
localparam integer L7 = (`CLKFREQ / 246.942 / (1 << `VOLW));
localparam integer M1 = (`CLKFREQ / 261.626 / (1 << `VOLW));
localparam integer M2 = (`CLKFREQ / 293.665 / (1 << `VOLW));
localparam integer M3 = (`CLKFREQ / 329.628 / (1 << `VOLW));
localparam integer M4 = (`CLKFREQ / 349.228 / (1 << `VOLW));
localparam integer M5 = (`CLKFREQ / 391.995 / (1 << `VOLW));
localparam integer M6 = (`CLKFREQ / 440.000 / (1 << `VOLW));
localparam integer M7 = (`CLKFREQ / 493.883 / (1 << `VOLW));
localparam integer H1 = (`CLKFREQ / 523.251 / (1 << `VOLW));
localparam integer H2 = (`CLKFREQ / 587.330 / (1 << `VOLW));
localparam integer H3 = (`CLKFREQ / 659.255 / (1 << `VOLW));
localparam integer H4 = (`CLKFREQ / 698.456 / (1 << `VOLW));
localparam integer H5 = (`CLKFREQ / 783.991 / (1 << `VOLW));
localparam integer H6 = (`CLKFREQ / 880.000 / (1 << `VOLW));
