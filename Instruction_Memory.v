module Instruction_Memory(
input[31:0] address,
output reg[31:0] instruction
);

reg missFlag;

reg[29:0] setAddress[0:15];
reg[31:0] setData[0:15];

wire[29:0] blockAddress = address[31:2]; //tag and index
wire[3:0] setID = blockAddress[3:0];

always @(address, blockAddress, setID) begin : search
	if(blockAddress == setAddress[setID]) begin
		instruction = setData[setID];
	end
	else begin
		missFlag = 1;
		instruction = 32'bx;
	end
end //always

initial begin
	setAddress[0] = 32'h00000040; setData[0] = 32'hF8400281; //LDUR X1, [X20, #0]
	setAddress[1] = 32'h00000041; setData[1] = 32'h8B010022; //ADD X2, X1, X1
	setAddress[2] = 32'h00000042; setData[2] = 32'hD1000333; //SUBI X19, X25, #0
	setAddress[3] = 32'h00000043; setData[3] = 32'hB40000E3; //CBZ X3
	setAddress[4] = 32'h00000044; setData[4] = 32'h91002294; //ADDI X20, X20, #8
	setAddress[5] = 32'h00000045; setData[5] = 32'hF81F4281; //STUR X1, [X20, #-12]
	setAddress[6] = 32'h00000046; setData[6] = 32'hD2800143; //MOVZ X3, #10
	setAddress[7] = 32'h00000047; setData[7] = 32'h8B030333; //AND X19, X25, X3
	setAddress[8] = 32'h00000048; setData[8] = 32'hAA030333; //ORR X19, X25, X3
	setAddress[9] = 32'h00000049; setData[9] = 32'hEA030333; //EOR X19, X25, X3
	setAddress[10] = 32'h0000004A; setData[10] = 32'h17FFFFFA; //B -6
	setAddress[11] = 32'h0000004B; setData[11] = 32'h04040404;
	setAddress[12] = 32'h0000004C; setData[12] = 32'h06060606;
	setAddress[13] = 32'h0000004D; setData[13] = 32'h05050505; 	
	setAddress[14] = 32'h0000004E; setData[14] = 32'h07070707;
	setAddress[15] = 32'h0000004F; setData[15] = 32'h01234567;
end

endmodule
