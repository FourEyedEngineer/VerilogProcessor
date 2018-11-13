`timescale 1s / 1s
module test_ALU;

//Operands
reg[31:0] a, b;

//Select
reg[3:0] sel;

//Result
wire[31:0] result;
wire zero;

//Instantiate in Unit Under Test
ALU uut (
.data1(a),
.data2(b),
.ALUc(sel),
.result(result),
.zero(zero)
);

initial begin
a = 32'd5; b = 32'd7;
sel = 4'b0010;
#5 sel = 4'b0110; a = 32'd6; b = 32'd2;
#5 sel = 4'b0111; a = 32'd3; b = 32'd8;
#5 b = 32'd0;
end

endmodule
