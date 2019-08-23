
`include "defines.v"

module div(

	input	wire										clk,
	input wire										rst,
	
	input wire                    signed_div_i,
	input wire[31:0]              opdata1_i,
	input wire[31:0]		   				opdata2_i,
	input wire                    start_i,
	input wire                    annul_i,
	
	output reg[63:0]             result_o,
	output reg			             ready_o
);

	wire[32:0] div_temp;//保存结果
	reg[5:0] cnt; //记录商法轮数，32时结束
	reg[64:0] dividend;//低32位是被除数，中间结果。第k次迭代结束时[k:0]就是中间结果
	//[31:0]是没参与运算的数据。
	//高32位时每次迭代的被减数
	reg[1:0] state;
	reg[31:0] divisor;	 
	reg[31:0] temp_op1;
	reg[31:0] temp_op2;
	
	assign div_temp = {1'b0,dividend[63:32]} - {1'b0,divisor};

	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			state <= `DivFree;
			ready_o <= `DivResultNotReady;
			result_o <= {`ZeroWord,`ZeroWord};
		end else begin
		  case (state)
		  //DivFree状态
		  	`DivFree:			begin               //DivFree״̬
		  		if(start_i == `DivStart && annul_i == 1'b0) begin
		  			if(opdata2_i == `ZeroWord) begin
		  				state <= `DivByZero;//除数为0
		  			end else begin//除数不为0
		  				state <= `DivOn;
		  				cnt <= 6'b000000;
		  				if(signed_div_i == 1'b1 && opdata1_i[31] == 1'b1 ) begin //被除数为负数
		  					temp_op1 = ~opdata1_i + 1;//被除数取补码
		  				end else begin
		  					temp_op1 = opdata1_i;
		  				end
		  				if(signed_div_i == 1'b1 && opdata2_i[31] == 1'b1 ) begin//除数为负数
		  					temp_op2 = ~opdata2_i + 1;//除数取补码
		  				end else begin
		  					temp_op2 = opdata2_i;
		  				end
		  				dividend <= {`ZeroWord,`ZeroWord};
              dividend[32:1] <= temp_op1;
              divisor <= temp_op2;
             end
          end else begin 
						ready_o <= `DivResultNotReady;//没有开始
						result_o <= {`ZeroWord,`ZeroWord};
				  end          	
		  	end
		  	`DivByZero:		begin               //DivByZero״̬
         	dividend <= {`ZeroWord,`ZeroWord};
          state <= `DivEnd;		 		
		  	end
		  	`DivOn:				begin               //DivOn״̬
		  		if(annul_i == 1'b0) begin
		  			if(cnt != 6'b100000) begin
               if(div_temp[32] == 1'b1) begin //表示（minuend-n）结果小于0
                  dividend <= {dividend[63:0] , 1'b0}; //左一一位
               end else begin//表示（minuend-n）结果大于等于0
                  dividend <= {div_temp[31:0] , dividend[31:0] , 1'b1};
				  //将减法的结果与被除数还没有参与运算的最高位加入下一次迭代，更新中间结果
               end
               cnt <= cnt + 1;
             end else begin //试商法结束
               if((signed_div_i == 1'b1) && ((opdata1_i[31] ^ opdata2_i[31]) == 1'b1)) begin
                  dividend[31:0] <= (~dividend[31:0] + 1);//如果两者有一个负数求补码
               end
               if((signed_div_i == 1'b1) && ((opdata1_i[31] ^ dividend[64]) == 1'b1)) begin              
                  dividend[64:33] <= (~dividend[64:33] + 1);
               end
               state <= `DivEnd; //结束状态
               cnt <= 6'b000000;   //清零         	
             end
		  		end else begin
		  			state <= `DivFree;
		  		end	
		  	end
		  	`DivEnd:			begin               //DivEnd״̬
        	result_o <= {dividend[64:33], dividend[31:0]};  //存入余数和商
          ready_o <= `DivResultReady; 
          if(start_i == `DivStop) begin
          	state <= `DivFree;
						ready_o <= `DivResultNotReady; 
						result_o <= {`ZeroWord,`ZeroWord};       	
          end		  	
		  	end
		  endcase
		end
	end

endmodule