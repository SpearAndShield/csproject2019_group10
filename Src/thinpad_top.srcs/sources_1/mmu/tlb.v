module tlb (
	rst, clk, using_tlb,
	virtAddr,

	refillMessage, 
	tlbwi,

	phyAddr,
	miss,
	dirty,
	valid
);

parameter PHISADDRLEN = 20;
parameter PAGELEN = 12;
parameter VIRTADDRLEN = 31 - PAGELEN;
parameter REFILLMESSAGELEN = (PHISADDRLEN+2)*2 + 31 - PAGELEN;
input wire rst;
input wire clk;
input wire using_tlb;
input wire[31:0] virtAddr;

input wire[REFILLMESSAGELEN+3:0] refillMessage;
input wire tlbwi;

output wire[31:0] phyAddr;
output wire miss;
output wire dirty;
output wire valid;


wire[19:0] PFN;

// related to refill
wire[VIRTADDRLEN-1:0] refillVPN;
wire[PHISADDRLEN-1:0] refillPFN1;
wire refillD1, refillV1;

wire[PHISADDRLEN-1:0] refillPFN2;
wire refillD2, refillV2;
wire[3:0] refillIndex;

assign {refillVPN, refillPFN1, refillD1, refillV1, refillPFN2, refillD2, refillV2, refillIndex} = refillMessage;


reg[REFILLMESSAGELEN-1:0] tlbTable[0:15];
wire[15:0] matched;
reg[3:0] matchIdx;

assign PFN[PHISADDRLEN-1:0] = ~virtAddr[PAGELEN] ? tlbTable[matchIdx][PHISADDRLEN*2+3:PHISADDRLEN+4] : tlbTable[matchIdx][PHISADDRLEN+1:2];
assign miss = matched == 16'b0;
assign dirty = ~virtAddr[PAGELEN] ? tlbTable[matchIdx][PHISADDRLEN+3] : tlbTable[matchIdx][1];
assign valid = ~virtAddr[PAGELEN] ? tlbTable[matchIdx][PHISADDRLEN+2] : tlbTable[matchIdx][0];


assign phyAddr[PAGELEN-1:0] = virtAddr[PAGELEN-1:0];
assign phyAddr[31:PAGELEN] = PFN[31-PAGELEN:0];

generate
	genvar i;
	for(i = 0; i < 16; i = i + 1) begin
		assign matched[i] = tlbTable[i][REFILLMESSAGELEN-1:REFILLMESSAGELEN-VIRTADDRLEN] == virtAddr[31:32-VIRTADDRLEN];
	end // for(i = 0; i < 16; i = i + 1)
endgenerate

always @(*) begin
	if(using_tlb) begin
		if(matched[0]) begin
			matchIdx <= 4'd0;
		end else if(matched[1]) begin
			matchIdx <= 4'd1;
		end else if(matched[2]) begin
			matchIdx <= 4'd2;
		end else if(matched[3]) begin
			matchIdx <= 4'd3;
		end else if(matched[4]) begin
			matchIdx <= 4'd4;
		end else if(matched[5]) begin
			matchIdx <= 4'd5;
		end else if(matched[6]) begin
			matchIdx <= 4'd6;
		end else if(matched[7]) begin
			matchIdx <= 4'd7;
		end else if(matched[8]) begin
			matchIdx <= 4'd8;
		end else if(matched[9]) begin
			matchIdx <= 4'd9;
		end else if(matched[10]) begin
			matchIdx <= 4'd10;
		end else if(matched[11]) begin
			matchIdx <= 4'd11;
		end else if(matched[12]) begin
			matchIdx <= 4'd12;
		end else if(matched[13]) begin
			matchIdx <= 4'd13;
		end else if(matched[14]) begin
			matchIdx <= 4'd14;
		end else if(matched[15]) begin
			matchIdx <= 4'd15;
		end else begin
			matchIdx <= 4'd0;
	    end
	end
end

always @(posedge clk or posedge rst) 
begin
  if (rst) begin
    tlbTable[0] <= 63'b0;
    tlbTable[1] <= 63'b0;
    tlbTable[2] <= 63'b0;
    tlbTable[3] <= 63'b0;
    tlbTable[4] <= 63'b0;
    tlbTable[5] <= 63'b0;
    tlbTable[6] <= 63'b0;
    tlbTable[7] <= 63'b0;
    tlbTable[8] <= 63'b0;
    tlbTable[9] <= 63'b0;
    tlbTable[10] <= 63'b0;
    tlbTable[11] <= 63'b0;
    tlbTable[12] <= 63'b0;
    tlbTable[13] <= 63'b0;
    tlbTable[14] <= 63'b0;
    tlbTable[15] <= 63'b0;
  end else begin
    if (tlbwi) begin
      tlbTable[refillIndex] [REFILLMESSAGELEN-1:0] <= refillMessage[REFILLMESSAGELEN+3:4];
    end
  end
end


endmodule