module Decoder(
input[31:0] instruction,
output reg reg2loc, ub, cb, memr, memw, mem2r, ALUsrc, regw,
output reg[3:0] ALUctrl,
output reg[4:0] reg1, reg2, wreg,
output reg[31:0] imm
);

reg[31:0] Rm, RdRt;
reg en;
wire[31:0] register2;

Multiplexers r2(
.opt1 (RdRt),
.opt2 (Rm),
.sel  (reg2loc),
.enable (en),
.muxout (register2)
);

always @(RdRt, Rm) en = 1;
always @(register2) begin
	en = 0;
	reg2 = register2[4:0];
end

integer i; // for function

function [31:0]signextend(input[31:0]immVal, sizeofImm, input MSB);
begin	
	for (i = sizeofImm; i < 32; i = i + 1) begin
		immVal[i] = MSB;
	end
	signextend = immVal;
end
endfunction

always @(instruction) begin
	Rm = signextend(instruction[20:16], 5, 0);
	RdRt = signextend(instruction[4:0], 5, 0);
	
	reg1 = instruction[9:5]; //the same for all instructions it just might be ignored by some of them
	wreg = RdRt; //the same for all instructions it just might be ignored by some of them
	casex(instruction[31:28])
		4'b1xx0: begin//R-format
			reg2loc = 0;
			ub = 0; cb = 0; //Is it a branch?
			ALUsrc = 0;
			memr = 0; memw = 0; regw = 1; mem2r = 0;
			//Multiplexers R2(RdRt, Rm, reg2loc, reg2);
			imm = 32'bx;

			//ALUctrl bits
			if (instruction[30:29] == 2'b00) ALUctrl = (instruction[24]) ? 4'b0010 : 4'b0110; //ADD/AND
			else if (instruction[30:29] == 2'b01) ALUctrl = 4'b0100; //ORR
			else if (instruction[30:29] == 2'b11) ALUctrl = 4'b1001; //EOR
			else if (instruction[30:29] == 2'b10) ALUctrl = 4'b1010; //SUB
		end
		4'b1111: begin//D-format
			ub = 0; cb = 0;
			mem2r = 1; //x for STUR
			ALUsrc = 1;
			imm =  signextend(instruction[20:12], 9, instruction[20]); //offset
			ALUctrl = 4'b0010;

			if (instruction[22] == 0) begin //STUR
				reg2loc = 1; memr = 0; memw = 1; regw = 0;
			end
			else begin //LDUR
				reg2loc = 1'bx; memr = 1; memw = 0; regw = 1;
			end
		end
		4'b1101: begin//MOVZ or EORI/SUBI
			reg2loc = 1'bx; 
			ub = 0; cb = 0;
			ALUsrc = 1;
			memr = 0; memw = 0; regw = 1; mem2r = 0;
			
			if (instruction[23] == 1) begin //MOVZ
				imm = signextend(instruction[22:5], 18, instruction[22]);
				ALUctrl = 4'b1101;
			end
			else begin //EORI/SUBI
				imm = signextend(instruction[21:10], 12, instruction[21]);
				ALUctrl = (instruction[25]) ? 4'b1001 : 4'b1010;//EORI/SUBI
			end
		end
		4'b1011: begin//CB-format or ORRI
			reg2loc = 1; //x for ORRI so reg 2 is also x
			ub = 0;
			memr = 0; memw = 0; 
			mem2r = 0; //x for CB

			if (instruction[26] == 1) begin //CB
				cb = 1;
				ALUsrc = 0;
				regw = 0;
				imm = signextend(instruction[23:5], 19, instruction[23]);
				ALUctrl = 4'b0111;
			end
			else begin //ORRI
				cb = 0;
				ALUsrc = 1;
				regw = 1;
				imm = signextend(instruction[21:10], 12, instruction[21]);
				ALUctrl = 4'b0100;
			end
		end
		4'b1xx1: begin//I-format or BL
			reg2loc = 1'bx; 
			cb = 0; 
			ALUsrc = 1; //x for BL
			memr = 0; memw = 0;
			mem2r = 0; //x for BL

			if (instruction[26] == 1) begin //BL
				ub = 1; 
				regw = 0;
				imm = signextend(instruction[25:0], 26, instruction[25]);
				ALUctrl = 4'bx;
			end
			else begin //I-format
				ub = 0; 
				regw = 1;
				imm = signextend(instruction[21:10], 12, instruction[21]);

				if (instruction[31:28] == 4'b1001) begin
					ALUctrl =  (instruction[24]) ? 4'b0010 : 4'b0110; //ANDI/ADDI
				end
			end
		end
		4'bx001: begin//B-format
			reg2loc = 1'bx; 
			ub = 1; cb = 0; 
			ALUsrc = 1'bx;
			memr = 0; memw = 0; regw = 0; mem2r = 1'bx;
			ALUctrl = 4'bx;
			imm = signextend(instruction[25:0], 26, instruction[25]);
		end
		default: begin
			reg2loc = 1'bx; 
			ub = 0; cb = 0; 
			ALUsrc = 1'bx;
			memr = 0; memw = 0; regw = 0; mem2r = 1'bx;
			ALUctrl = 4'bx;
			imm = 32'bx;
		end
	endcase
end

endmodule

