`timescale 1ns / 1ns
module Processor;

reg clk, enALU;
reg[31:0] PC;
wire[31:0] nextPC, instruction, imm, wRegData, readData1, readData2, ALUidata, ALUresult;
wire[4:0] reg1, reg2, regw; //register/operand input, decoder output
wire[3:0] ALUctrl; //decoder to ALU
wire reg2loc, ubr, cbr, memRead, memWrite, mem2Reg, ALUsrc, regWrite; //control bits(decoder) to mux
wire zero; //PC input, ALU output

PC start(
.clk		(clk),
.currentPC	(PC),
.imm 		(imm),
.br		(cbr),
.ub		(ubr),
.zero		(zero),
.nextPC		(nextPC)
);

Instruction_Memory iMem(
.address    (PC),
.instruction(instruction)
);

Decoder dec(
.instruction(instruction),
.reg2loc    (reg2loc),
.ub         (ubr),
.cb         (cbr),
.memr       (memRead),
.memw       (memWrite),
.mem2r      (mem2Reg),
.ALUsrc     (ALUsrc),
.regw       (regWrite),
.ALUctrl    (ALUctrl),
.reg1       (reg1),
.wreg       (regw),
.reg2       (reg2),
.imm        (imm)
);

Registers register(
.reg1    (reg1),
.reg2    (reg2),
.regW    (regw),
.wRegData(wRegData),
.imm     (imm),
.RegWrite(regWrite),
.ALUsrc  (ALUsrc),
.data1   (readData1),
.ALUidata(ALUidata),
.memWdata(readData2)
);

ALU alu(
.data1  (readData1),
.data2  (ALUidata),
.ALUctrl(ALUctrl),
.result (ALUresult),
.enable	(enALU),
.zero   (zero)
);

Data_Memory datamem(
.addr 	   (ALUresult),
.wData     (readData2),
.memr      (memRead),
.memw      (memWrite),
.mem2reg   (mem2Reg),
.dataMemOut(wRegData)
);

//assign nextPC = PC; 

initial begin
	PC = 32'h00000100;
end

initial begin
	clk = 0;
	repeat(1000) begin
	#1 clk = ~clk;
	end // repeat(1000)
end

always @(ALUidata) enALU = 1;
always @(ALUresult) enALU = 0;

always @(nextPC) begin
	PC = nextPC;
	enALU = 0;
end

endmodule
