`timescale 1s / 1s
module test_Decoder;

//instruction
reg[31:0]inst;

//control bits
wire reg2loc, unconb, conb, memread, memwrite, mem2reg, ALUsrc, regwrite;
wire[3:0] ALUctrl;

//Reg + immediate
wire[4:0] readreg1, readreg2, writereg;
wire[31:0] immediate;

//Instantiate in Unit Under Test
Decoder uut (
.instruction(inst),
.reg2loc(reg2loc),
.ub	(unconb),
.cb	(conb),
.memr	(memread),
.memw	(memwrite),
.mem2r	(mem2reg),
.ALUsrc	(ALUsrc),
.regw	(regwrite),
.ALUctrl(ALUctrl),
.reg1	(readreg1),
.reg2	(readreg2),
.wreg	(writereg),
.imm	(immediate)
);

initial begin
inst = 32'b10001011000_10101_000000_10100_01001; //ADD X9, X20, X21
#4 inst = 32'b1001000100_000000000001_10110_10110; //ADDI X22, X22, #1
#4 inst = 32'b11111000010_000000000_00_01010_01001; //LDUR X9, [X10, #0]
#4 inst = 32'b10110100_0000000000001000001_00111; //CBZ X7, name //addr 65
#4 inst = 32'b100101_11111111111111111111111011; //BL branchto //addr -5
#4 inst = 32'b110100101_000000000000001010_00011; //MOVZ X3, #10
end

endmodule
