module logic(clk, led);

input clk;
output [0:4] led;

// 0-4 counter incremented by 1Hz signal
reg [2:0] cnt;
initial cnt <= 3'h0;
always @(posedge clk) begin
	if (cnt >= 3'h4) begin
		cnt <= 3'h0;
	end else begin
		cnt <= cnt + 3'h1;
	end
end

// LED controlled by counter value
genvar i;
generate
	for (i = 0; i < 5; i = i+1) begin
		assign led[i] = (cnt == i) ? 0 : 1;
	end
endgenerate

endmodule