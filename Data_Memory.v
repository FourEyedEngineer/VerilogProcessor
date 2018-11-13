module Data_Memory( //8-way s.a., 2 sets
input[31:0] addr, wData,
input memr, memw, mem2reg,
output reg[31:0] dataMemOut
);

reg[31:0] memData;
reg en, missFlag;
wire[31:0] muxresult;

Multiplexers MemOutput(
.opt1 (memData),
.opt2 (addr),
.sel  (mem2reg),
.enable (en),
.muxout (muxresult)
);

always @(memData, addr) en = 1;
always @(muxresult) begin
	en = 0;
	dataMemOut = muxresult;
end

reg [28:0]set0Address[0:7];
reg [31:0]set0Data[0:7];
reg [28:0]set1Address[0:7];
reg [31:0]set1Data[0:7];

reg [6:0]i;
wire [28:0]blockAddress = addr[31:3]; //tag and index
wire setID = blockAddress % 2;

always@(addr, blockAddress, setID) begin : search
	if(setID) begin //set 1
		for(i = 0; i < 8; i = i + 1) begin //how many lines there are
			if(blockAddress == set1Address[i]) begin
				if(memr) memData = set1Data[i];
				else if(memw) begin
					set1Data[i] = wData;
					memData = set1Data[i];
				end //else
			
				missFlag = 0;
				disable search;
			end 
			else begin
				missFlag = 1;
				memData = 32'bx;
			end
		end //for
	end //if
	else begin //set 0
		for(i = 0; i < 8; i = i + 1)
			if(blockAddress == set0Address[i]) begin
				if(memr) memData = set0Data[i];
				else if (memw) begin
					set0Data[i] = wData;
					memData = set0Data[i];
				end //else
			
				missFlag = 0;
				disable search;
			end //if PC==
			else begin
				missFlag = 1;
				memData = 32'bx;
			end //else
		end //for
end

initial begin
	set0Address[0] = 29'h000000CE; set0Data[0] = 32'h01010101;
	set0Address[1] = 29'h000000D0; set0Data[1] = 32'h02020202;
	set0Address[2] = 29'h000000D2; set0Data[2] = 32'h03030303;
	set0Address[3] = 29'h000000D4; set0Data[3] = 32'h04040404;
	set0Address[4] = 29'h000000D6; set0Data[4] = 32'h05050505;
	set0Address[5] = 29'h000000D8; set0Data[5] = 32'h06060606;
	set0Address[6] = 29'h000000DA; set0Data[6] = 32'h07070707;
	set0Address[7] = 29'h000000DC; set0Data[7] = 32'h08080808;

	set1Address[0] = 29'h000000CF; set1Data[0] = 32'h99999999;
	set1Address[1] = 29'h000000D1; set1Data[1] = 32'hAAAAAAAA;
	set1Address[2] = 29'h000000D3; set1Data[2] = 32'hBBBBBBBB;
	set1Address[3] = 29'h000000D5; set1Data[3] = 32'hCCCCCCCC;
	set1Address[4] = 29'h000000D7; set1Data[4] = 32'hDDDDDDDD;
	set1Address[5] = 29'h000000D9; set1Data[5] = 32'hEEEEEEEE;
	set1Address[6] = 29'h000000DB; set1Data[6] = 32'hFFFFFFFF;
	set1Address[7] = 29'h000000DD; set1Data[7] = 32'h01234567;
end

endmodule
