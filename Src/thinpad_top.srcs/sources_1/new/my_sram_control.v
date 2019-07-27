`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/06 08:32:59
// Design Name: 
// Module Name: my_sram_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module my_sram_control(

	clk2x, rst,
	masterRd_i, masterWr_i, // from bus
	byteEnable_i,
	writeData_i, ramAddr_i, // from bus
	ramData_bus, //  sram bus io

	ramAddr_o, // to sram
	sramEnable_n_o, writeEnable_n_o, readEnable_n_o, // to sram 
	byteEnable_o,
	ramData_o // to bus

	);
// if read write at the same time, default write
input wire clk2x, rst;
input wire masterRd_i, masterWr_i;
input wire[3:0] byteEnable_i;
input wire[31:0] writeData_i;
input wire[21:0] ramAddr_i;
inout wire[31:0] ramData_bus;

output reg[19:0] ramAddr_o;
output reg sramEnable_n_o, writeEnable_n_o, readEnable_n_o; 
output reg[3:0] byteEnable_o;
output reg[31:0] ramData_o;

reg[31:0] wrbuf;
parameter IDLE = 3'b000;
parameter READ1 = 3'b001;
parameter READ2 = 3'b010;
parameter WRITE1 = 3'b011;
parameter WRITE2 = 3'b100;
reg[2:0] state = IDLE;


assign ramData_bus = wrbuf;

always @(*) begin
	if(rst) begin
		sramEnable_n_o <= 1'b1;
		readEnable_n_o <= 1'b1;
		writeEnable_n_o <= 1'b1;
		byteEnable_o <= 4'b1111;
		wrbuf <= 32'bz; // to activate the sram and record the last write time....
		ramAddr_o <= 20'habcde;
	end else begin
	case(state)
		IDLE: begin
			sramEnable_n_o <= 1'b1;
			readEnable_n_o <= 1'b1;
			writeEnable_n_o <= 1'b1;
			byteEnable_o <= 4'b1111;
			wrbuf <= 32'bz; // to activate the sram and record the last write time....
			ramAddr_o <= 20'habcde;

		end
		READ1: begin
		    wrbuf <= 32'bz;
			ramAddr_o <= ramAddr_i[21:2];
			sramEnable_n_o <= 1'b0;
			readEnable_n_o <= 1'b0;
			writeEnable_n_o <= 1'b1;
		    byteEnable_o <= byteEnable_i;
            ramData_o <= ramData_bus; 
		end // READ1:
		READ2: begin
			// TO-DO : what if the delay ?? here CPU may be next period!!!
			// byteEnable_o <= byteEnable_i;
         //   ramData_o <= ramData_bus; 
		end // READ2:
		WRITE1: begin

			wrbuf <= writeData_i;
			ramAddr_o <= ramAddr_i[21:2];
			sramEnable_n_o <= 1'b0;
			readEnable_n_o <= 1'b1;
			writeEnable_n_o <= 1'b0;
			byteEnable_o <= byteEnable_i;
		end // WRITE1:
		WRITE2: begin
			//sramEnable_n_o <= 1'b1;
			//readEnable_n_o <= 1'b1;
			writeEnable_n_o <= 1'b1;
		end // WRITE2:
	endcase // state
	end
end // always @(*)



always @(posedge clk2x or posedge rst) begin
	if(rst) begin
		state <= IDLE;
	end
	else begin
		case(state)
			READ1: 
				state = READ2;
			WRITE1:
				state = WRITE2;

			default:begin
				// if read write at the same time, default write
				if(masterWr_i) begin
					state <= WRITE1;
				end else if(masterRd_i) begin
					state <= READ1;
				end else begin
					state <= IDLE;
				end // end else

			end // default:
		endcase
	end // else
end // always @(posedge clk2x or posedge rst)




// always @(posedge clk2x or posedge rst) begin
// 	if(rst) begin
// 		state <= IDLE;
// 		sramEnable_n_o <= 1'b1;
// 		readEnable_n_o <= 1'b1;
// 		writeEnable_n_o <= 1'b1;
// 		byteEnable_o <= 4'b0;
// 		wrbuf <= 32'bz; // to activate the sram and record the last write time....
// 		ramAddr_o <= 20'b0;
// 	end
// 	else begin
// 		case(state)
// 			READ1: 
// 				state = READ2;
// 			WRITE1:begin
// 				state = WRITE2;
// 				writeEnable_n_o <= 1'b1;
// 			end
// 			default:begin
// 				// if read write at the same time, default write
// 				if(masterWr_i) begin
// 					state <= WRITE1;
// 					wrbuf <= writeData_i;
// 					ramAddr_o <= ramAddr_i[21:2];
// 					sramEnable_n_o <= 1'b0;
// 					readEnable_n_o <= 1'b1;
// 					writeEnable_n_o <= 1'b0;
// 					byteEnable_o <= byteEnable_i;
// 				end else if(masterRd_i) begin
// 					state <= READ1;
// 					 wrbuf <= 32'bz;
// 					ramAddr_o <= ramAddr_i[21:2];
// 					sramEnable_n_o <= 1'b0;
// 					readEnable_n_o <= 1'b0;
// 					writeEnable_n_o <= 1'b1;
// 				    byteEnable_o <= byteEnable_i;
// 		            ramData_o <= ramData_bus; 
// 				end else begin
// 					state <= IDLE;
// 					sramEnable_n_o <= 1'b1;
// 					readEnable_n_o <= 1'b1;
// 					writeEnable_n_o <= 1'b1;
// 					byteEnable_o <= 4'b0;
// 					wrbuf <= 32'bz; // to activate the sram and record the last write time....
// 					ramAddr_o <= 20'b0;
// 				end // end else

// 			end // default:
// 		endcase
// 	end // else
// end // always @(posedge clk2x or posedge rst)

endmodule // my_sram_control

