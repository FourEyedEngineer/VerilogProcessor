module ALU(
input[31:0] data1, data2, //data input
input[3:0] ALUctrl, //control input
input enable, 
output reg[31:0] result, //ALU result
output reg zero
);

always @(enable) begin
	if (enable) begin
		case(ALUctrl)
			4'b0010: result = data1 + data2;	//LDR, STR, ADD
			4'b0100: result = data1 | data2;	//ORR
			4'b0101: result = !(data1 | data2);	//NOR
			4'b0110: result = data1 & data2;	//AND
			4'b0111: zero = (data2 == 0) ? 1 : 0;	//CBZ
			4'b1001: result = data1 ^ data2;	//EOR
			4'b1010: result = data1 - data2;	//SUB
			4'b1100: result = !(data1 & data2);	//NAND
			4'b1101: result = data2;		//MOV 
			default: begin 
				result = 32'bx; zero = 32'bx;
			end
		endcase
	end
end

endmodule
