module PC(
input[31:0] currentPC, imm,
input br, ub, zero, clk,
output reg[31:0] nextPC
);

reg en; //for mux
reg enALU;

reg PCsrc;
wire[31:0] PCplus4, branchPCres, PCresult;
reg[31:0] shiftedImm;

ALU PC4(
.data1 (currentPC), 
.data2 (32'd4),
.ALUctrl (4'b0010),
.result (PCplus4),
.enable (enALU),
.zero	()
);

ALU branchPC(
.data1 (currentPC), 
.data2 (shiftedImm),
.ALUctrl (4'b0010),
.result (branchPCres),
.enable (enALU),
.zero	()
);

Multiplexers ALUinput(
.opt1 (branchPCres),
.opt2 (PCplus4),
.sel  (PCsrc),
.enable (en),
.muxout (PCresult)
);

always @(PCplus4, branchPCres) en = 1;
always @(PCresult) begin
	en = 0;
	nextPC = PCresult;
end

always @(posedge clk) begin
	PCsrc = ub | (br & zero);
	shiftedImm = imm << 2;
	enALU = 1;
end

always @(negedge clk) begin
	enALU = 0;
end

endmodule
