module mmu_interface (
	// input 
	clk, rst, en, userMode,
	virtAddr,
	refillMessage,
	tlbwi,
    MasterRd,
    MasterWr,
    MasterByteEnable,
	//output
	physAddr,
	permissionDenied,
	miss,
	dirty,
	invalid,
	BusRd,
	BusWr,
	BusByteEnable
);
parameter PHISADDRLEN = 20;
parameter PAGELEN = 12;
parameter VIRTADDRLEN = 31 - PAGELEN;
parameter REFILLMESSAGELEN = (PHISADDRLEN+2)*2 + 31 - PAGELEN;
input wire clk, rst;
input wire en, userMode;
input wire[31:0] virtAddr;
input wire[REFILLMESSAGELEN+3:0] refillMessage;
input wire tlbwi;
input wire MasterRd,MasterWr;
input wire[3:0] MasterByteEnable;

output wire[31:0] physAddr;
output wire permissionDenied;
output wire miss;
output wire invalid;
output wire dirty;
output wire BusRd,BusWr;
output wire[3:0] BusByteEnable;

wire bus_enable;
reg usingTLB;
reg[31:0] calcAddr;
always @(*) begin
    usingTLB <= 1'b0;
    calcAddr <= 32'b0;
    if (en) begin
        case(virtAddr[31:29])
	        3'b110,         //kseg2
	        3'b111,         //kseg3
	        3'b000,
			3'b001,
			3'b010,
			3'b011: begin   //useg
	            usingTLB <= 1'b1;
	        end
	        3'b100: begin   //kseg0
	            calcAddr <= {3'b0, virtAddr[28:0]};
	        end
	        3'b101: begin   //kseg1
	            calcAddr <= {3'b0, virtAddr[28:0]};
	        end
        endcase
    end
end



wire[31:0] tlbAddr;
wire tlbMiss, tlbDirty, tlbValid;
tlb tlb0(
	.rst          (rst),
	.clk          (clk),
	.using_tlb    (usingTLB),
	.virtAddr     (virtAddr),
	

	.refillMessage(refillMessage),
	.tlbwi        (tlbwi),

	.phyAddr     (tlbAddr),
	.miss         (tlbMiss),
	.dirty        (tlbDirty),
	.valid        (tlbValid)

	);


assign permissionDenied = (en && userMode && virtAddr[31]);
assign physAddr = (usingTLB ? tlbAddr : calcAddr);
assign miss = (usingTLB && tlbMiss);
assign dirty = (~usingTLB || tlbDirty);
assign invalid = (usingTLB && ~tlbValid);
assign bus_enable = ~(permissionDenied || miss || invalid);
assign BusRd = MasterRd & bus_enable;
assign BusWr = MasterWr & bus_enable;
assign BusByteEnable = (bus_enable ? MasterByteEnable : 4'b1111);

endmodule