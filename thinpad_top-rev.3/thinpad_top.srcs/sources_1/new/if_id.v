
`include "defines.v"

module if_id(

	input	wire										clk,
	input wire										rst,

	input wire[5:0]               stall,	
	input wire                    flush,
	//取指阶段的信号
	input wire[`InstAddrBus]			if_pc,
	input wire[`InstBus]          if_inst,
	//译码阶段的信号
	output reg[`InstAddrBus]      id_pc,
	output reg[`InstBus]          id_inst  
	
);

	always @ (posedge clk) begin
		if (rst == `RstEnable) begin //复位时pc为0，指令为空指令
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
		end else if(flush == 1'b1 ) begin 
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;					
		end else if(stall[1] == `Stop && stall[2] == `NoStop) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;	
	  end else if(stall[1] == `NoStop) begin
		  id_pc <= if_pc;
		  id_inst <= if_inst;
		end
	end

endmodule