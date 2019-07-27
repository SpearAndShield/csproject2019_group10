`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/06 08:31:37
// Design Name: 
// Module Name: my_fake_sram
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


module my_fake_sram(
    clk,
	addr_i,
	en_i,
	we_i,
	ce_i,
   	lowbyte_i,
	data_i, data_o
	);
input wire[19:0] addr_i;
input wire en_i, we_i, ce_i, lowbyte_i;
input wire [31:0] data_i;
output reg [31:0] data_o;
input wire clk;
reg[31:0] ram[0:20];
always @(posedge clk) begin
	if(ce_i) begin
	    data_o <= 32'hzzzzzzzz;
	    if(we_i) begin
	    	if(lowbyte_i) begin
	    		ram[addr_i][7:0] <= data_i[7:0];
	    	end
	    	else
	    		ram[addr_i] <= data_i;
	    end
	    else if (en_i) begin
	    	data_o <= ram[addr_i];
	    end
	end // if(ce_i)
end

endmodule