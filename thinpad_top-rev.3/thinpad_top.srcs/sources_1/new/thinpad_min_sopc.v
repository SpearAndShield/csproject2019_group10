`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/17 01:06:07
// Design Name: 
// Module Name: thinpad_min_sopc
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


module thinpad_min_sopc(

	input	wire										clk,
	input wire										rst
	
);

  //Á¬½ÓÖ¸Áî´æ´¢Æ÷
  wire[`InstAddrBus] inst_addr;
  wire[`InstBus] inst;
  wire rom_ce;
 

 thinpad_top thinpad_top0(
		.clk(clk),
		.rst(rst),
	
		.rom_addr_o(inst_addr),
		.rom_data_i(inst),
		.rom_ce_o(rom_ce)
	
	);
	
	inst_rom inst_rom0(
		.addr(inst_addr),
		.inst(inst),
		.ce(rom_ce)	
	);


endmodule