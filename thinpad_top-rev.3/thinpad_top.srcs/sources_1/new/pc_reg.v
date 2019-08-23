`include "defines.v"

module pc_reg(

	input	wire										clk,
	input wire										rst,

	input wire[5:0]               stall,
	input wire                    flush,
	input wire[`RegBus]           new_pc,

	input wire                    branch_flag_i,
	input wire[`RegBus]           branch_target_address_i,
	
	output reg[`InstAddrBus]			pc,//要读取的指令地址
	output reg                    ce //指令存储器使能信号
	
);

	always @ (posedge clk) begin
		if (ce == `ChipDisable) begin //指令储存器禁用
			pc <= 32'h00000000; //pc为0
		end else begin
			if(flush == 1'b1) begin //flush为1，异常发生，从CRTL模块给出异常处理
				pc <= new_pc;//从例程入口地址取指
			end else if(stall[0] == `NoStop) begin //stall[0]为NoStop时，pc加4否则不变
				if(branch_flag_i == `Branch) begin
					pc <= branch_target_address_i;
				end else begin
		  		pc <= pc + 4'h4; //PC值时钟周期加4
		  	end
			end
		end
	end

	always @ (posedge clk) begin
		if (rst == `RstEnable) begin //复位
			ce <= `ChipDisable; //指令储存器禁用
		end else begin
			ce <= `ChipEnable;
		end
	end

endmodule