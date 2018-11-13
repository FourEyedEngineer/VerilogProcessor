module Multiplexers(
input[31:0] opt1, opt2, //opt1=1, opt2=0
input sel, enable,
output reg[31:0] muxout
);

always @(enable) begin
	if (enable) muxout = (sel) ? opt1 : opt2;
	else muxout = muxout;
end

endmodule
