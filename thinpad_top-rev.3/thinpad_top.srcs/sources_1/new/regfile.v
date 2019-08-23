//////////////////////////////////////////////////////////////////////
`include "defines.v"

module regfile(

	input	wire										clk,
	input wire										rst,
	
	//写端口
	input wire										we,
	input wire[`RegAddrBus]				waddr,
	input wire[`RegBus]						wdata,
	
	//读端口1
	input wire										re1,
	input wire[`RegAddrBus]			  raddr1,
	output reg[`RegBus]           rdata1,
	
	//读端口2
	input wire										re2,
	input wire[`RegAddrBus]			  raddr2,
	output reg[`RegBus]           rdata2
	
);
    //32个32位寄存器
	reg[`RegBus]  regs[0:`RegNum-1];
	//写操作
	always @ (posedge clk) begin
		if (rst == `RstDisable) begin //复位信号无效
			if((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin
			//写使能信号有效 寄存器不等于0
				regs[waddr] <= wdata;//写入数据保存到目的寄存器
			end
		end
	end
	//读端口1的读操作
	always @ (*) begin
		if(rst == `RstEnable) begin //复位时，第一个读寄存器端口的输出始终为0
			  rdata1 <= `ZeroWord;
	  end else if(raddr1 == `RegNumLog2'h0) begin//复位信号无效时，读到0，则给出0
	  		rdata1 <= `ZeroWord;
	  end else if((raddr1 == waddr) && (we == `WriteEnable) 
	  	            && (re1 == `ReadEnable)) begin
	 //读入寄存器端口和要读区的目标寄存器是同一个，则直接写入
	  	  rdata1 <= wdata;
	  end else if(re1 == `ReadEnable) begin
	  //否则将第一个读寄存器端口要读取的目的寄存器的地址写入
	      rdata1 <= regs[raddr1];
	  end else begin
	  //如果读寄存器端口不能使用，就输出0
	      rdata1 <= `ZeroWord;
	  end
	end
	//读端口2的操作
	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata2 <= `ZeroWord;
	  end else if(raddr2 == `RegNumLog2'h0) begin
	  		rdata2 <= `ZeroWord;
	  end else if((raddr2 == waddr) && (we == `WriteEnable) 
	  	            && (re2 == `ReadEnable)) begin
	  	  rdata2 <= wdata;
	  end else if(re2 == `ReadEnable) begin
	      rdata2 <= regs[raddr2];
	  end else begin
	      rdata2 <= `ZeroWord;
	  end
	end

endmodule