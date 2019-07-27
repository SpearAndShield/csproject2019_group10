module flash_control (
	// input
	clk, rst,
	masterRd_i, masterWr_i, // from bus
	byteEnable_i,
	writeData_i, flashAddr_i, // from bus

	// inout
	flashData_bus, //  flash bus io

	// output 
	flashAddr_o, // to flash
	flashEnable_n_o, writeEnable_n_o, readEnable_n_o, // to flash
	lowBitMode_n_o,
	flashData_o, // to bus
	flashStall_o
);

input wire clk, rst;
input wire masterRd_i, masterWr_i;
input wire[3:0] byteEnable_i;
input wire[31:0] writeData_i;
input wire[23:0] flashAddr_i;

inout wire[15:0] flashData_bus;

output reg[22:0] flashAddr_o;
output reg flashEnable_n_o, writeEnable_n_o, readEnable_n_o;
output reg lowBitMode_n_o;
output reg[31:0] flashData_o;
output reg flashStall_o;

parameter IDLE = 3'b000;
parameter READ1 = 3'b001;
parameter READ2 = 3'b010;
parameter READ3 = 3'b011;
parameter READ4 = 3'b100;
parameter READ5 = 3'b101;
parameter READ6 = 3'b110;

reg[3:0] state = IDLE;

reg[15:0] iobuf;
assign flashData_bus = iobuf;

always @(*) begin
	if(rst) begin
		flashEnable_n_o <= 1'b1;
		writeEnable_n_o <= 1'b1;
		readEnable_n_o <= 1'b1;
		flashAddr_o <= 23'b0;
		lowBitMode_n_o <= 1'b1;
		iobuf <= 16'bz;
		//flashData_o <= 32'bz;
		flashStall_o <= 1'b0;
	end else begin
	case (state)
		IDLE: begin
			flashEnable_n_o <= 1'b1;
			writeEnable_n_o <= 1'b1;
			readEnable_n_o <= 1'b1;
			flashAddr_o <= 23'b0;
			//lowBitMode_o <= 
			iobuf <= 16'bz;
			//flashData_o <= 32'bz;
			flashStall_o <= 1'b0;

		end // IDLE:
		READ1:begin
			flashEnable_n_o <= 1'b0;
			writeEnable_n_o <= 1'b0;
			readEnable_n_o <= 1'b1;
			flashAddr_o <= flashAddr_i[23:1];
			lowBitMode_n_o <= 1'b1;
			iobuf <= 16'hff;
			//flashData_o <= 32'bz;
			flashStall_o <= 1'b1;
		end
		READ2:begin
			flashEnable_n_o <= 1'b0;
			writeEnable_n_o <= 1'b1;
			readEnable_n_o <= 1'b1;
			flashAddr_o <= flashAddr_i[23:1];
			lowBitMode_n_o <= 1'b1;
			iobuf <= 16'hff;
			//flashData_o <= 32'bz;
			flashStall_o <= 1'b1;
		end // READ2:
		READ3:begin
			flashEnable_n_o <= 1'b0;
			writeEnable_n_o <= 1'b1;
			readEnable_n_o <= 1'b0;
			flashAddr_o <= {flashAddr_i[23:2], byteEnable_i[0]};
			lowBitMode_n_o <= ~byteEnable_i[0] && ~byteEnable_i[1];
			iobuf <= 16'bz;
			flashData_o <= {16'b0, flashData_bus};
			flashStall_o <= 1'b1;
		end // READ3
		READ4:begin
			flashEnable_n_o <= 1'b0;
			writeEnable_n_o <= 1'b1;
			readEnable_n_o <= 1'b0;
			flashAddr_o <= {flashAddr_i[23:2], byteEnable_i[0]};
			lowBitMode_n_o <= ~byteEnable_i[0] && ~byteEnable_i[1];
			iobuf <= 16'bz;
			flashData_o <= {16'b0, flashData_bus};
			flashStall_o <= 1'b1;
		end
		READ5:begin
			flashEnable_n_o <= 1'b0;
			writeEnable_n_o <= 1'b1;
			readEnable_n_o <= 1'b0;
			flashAddr_o <= {flashAddr_i[23:2], byteEnable_i[0]};
			lowBitMode_n_o <= ~byteEnable_i[0] && ~byteEnable_i[1];
			iobuf <= 16'bz;
			flashData_o <= {16'b0, flashData_bus};
			flashStall_o <= 1'b1;
		end
		READ6:begin
			flashEnable_n_o <= 1'b1;
			writeEnable_n_o <= 1'b1;
			readEnable_n_o <= 1'b1;
			//flashData_o <= {flashData_bus, flashData_bus};
			flashStall_o <= 1'b0;
		end
		default : /* default */;
	endcase
	end
end

always @(posedge clk or posedge rst) begin
	if(rst) begin
		state <= IDLE;
	end else begin
		case(state)
			IDLE:begin
				if(masterRd_i) begin
					state <= READ1;
				end
			end // IDLE:
			READ1:begin
				state <= READ2;
				end
			READ2:begin
				state <= READ3;
				end
			READ3:begin
				state <= READ4;
				end
			READ4:begin
				state <= READ5;
			end
			READ5:begin
				state <= READ6;
			end
			READ6:begin
				if(masterRd_i) begin
					state <= READ1;
				end else begin
					state <= IDLE;
				end // end else
			end // READ4:

		endcase // state
	end
end // always @(posedge clk or posedge rst)
endmodule