module Registers(
input[4:0] reg1, reg2, regW,
input[31:0] wRegData, imm,
input RegWrite, ALUsrc,
output reg[31:0] data1, ALUidata, memWdata
);

reg[31:0] data2, writeReg;
reg en, missFlag;
wire[31:0] muxres;

/*Multiplexers ALUinput(
.opt1 (imm),
.opt2 (data2),
.sel  (ALUsrc),
.enable (en),
.muxout (muxres)
);*/

integer j;
reg [31:0]setAddress[0:15]; //16 lines
reg [31:0]setData[0:15];

function [31:0]signextend(input[4:0]val, sizeofVal, input MSB);
begin	
	for (j = sizeofVal; j < 32; j = j + 1) begin
		val[j] = MSB;
	end
	signextend = val;
end
endfunction

reg [6:0]i, k;

wire [31:0]blockAddress[2:0];
reg [31:0]data[2:0];

assign blockAddress[0] = reg1;
assign blockAddress[1] = reg2;
assign blockAddress[2] = regW;

/*always @(data2) en = 1;
always @(muxres) begin
	en = 0;
	ALUidata = muxres;
end*/

always @(reg1, reg2, imm) begin
	for(i = 0; i < 2; i = i + 1) begin
		for(k = 0; k < 8; k = k + 1) begin
			if(blockAddress[i] == setAddress[k]) begin		 
				data[i] = setData[k];
				missFlag = 0;
				i = i + 1;
				k = -1;
			end //if PC==
			else begin
				missFlag = 1;
				data[i] = 32'bx;
			end	
		end
	end //for

	data1 = data[0];
	data2 = data[1];
	
	ALUidata = (ALUsrc) ? imm : data2;

	memWdata = data2;
	//writeReg = (RegWrite) ? wRegData : 32'bx;
end

always @(wRegData) begin
	for (i = 0; i < 8; i = i + 1) begin
		if (blockAddress[2] == setAddress[i]) begin
			setData[i] = wRegData;
			data[2] = setData[i];
			i = 8;
		end
	end
end

initial begin
	setAddress[0] = 32'h00000001; setData[0] = 32'h02020202; //X1
	setAddress[1] = 32'h00000002; setData[1] = 32'h0000001B; //X2
	setAddress[2] = 32'h00000003; setData[2] = 32'h00000010; //X3
	setAddress[3] = 32'h00000009; setData[3] = 32'h04040404; //X9
	setAddress[4] = 32'h0000000A; setData[4] = 32'h01010101; //X10
	setAddress[5] = 32'h00000013; setData[5] = 32'h03030303; //X19	
	setAddress[6] = 32'h00000014; setData[6] = 32'h00000680; //X20
	setAddress[7] = 32'h00000019; setData[7] = 32'h00000004; //X25
end

endmodule
