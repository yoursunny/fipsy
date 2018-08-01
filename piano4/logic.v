module logic(clk, key1, key2, key3, key4, buzzer);

parameter freq = 2080000;  // clock frequency
parameter note1 = 261.626; // key1 note frequency, default C4
parameter note2 = 329.628; // key2 note frequency, default E4
parameter note3 = 391.995; // key3 note frequency, default G4
parameter note4 = 523.251; // key4 note frequency, default C5
parameter width = 13;      // minimum ceil(log2(freq/min(note1,note2,note3,note4)))
parameter volw = 1;        // width of volume counter
parameter volume = 1;      // volume, minimum 1, maximum ((1<<volw)-1)

input clk;
input key1, key2, key3, key4;
output buzzer; // passive buzzer

reg [width:1] div;
reg enable;

always @(posedge clk) begin
	enable <= key1 | key2 | key3 | key4;

	if (key1) begin
		div <= freq / note1 / (1 << volw);
	end else if (key2) begin
		div <= freq / note2 / (1 << volw);
	end else if (key3) begin
		div <= freq / note3 / (1 << volw);
	end else if (key4) begin
		div <= freq / note4 / (1 << volw);
	end
end

defparam w.width = width;
defparam w.volw = volw;
wave w(.buzzer(buzzer), .clk(clk), .enable(enable), .div(div), .volume(volume));

endmodule