module wave(buzzer, clk, enable, div, volume);

parameter width = 17;     // minimum log2(clk_freq/max_div)
parameter volw = 1;       // width of volume counter, minimum 1

output buzzer;         // passive buzzer
input clk;             // clock
input enable;          // enable
input [width:1] div;   // music note, = clkFreq / noteFreq / (1 << volw)
input [volw:1] volume; // volume setting

reg [width:1] cnt;
reg [volw:1] spk;

initial begin
	cnt <= 0;
	spk <= 0;
end

always @(posedge clk) begin
	if (cnt >= div) begin
		cnt <= 0;
		spk <= spk + 1;
	end else begin
		cnt <= cnt + 1;
	end
end

assign buzzer = enable ? (spk < volume) : 0'bZ;

endmodule
