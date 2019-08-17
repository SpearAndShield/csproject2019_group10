`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/17 01:10:56
// Design Name: 
// Module Name: thinpad_min_sopc_tb
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


module thinpad_min_sopc_tb(

    );
    reg     CLOCK_50;
  reg     rst;
  
       
  initial begin
    CLOCK_50 = 1'b0;
    forever #10 CLOCK_50 = ~CLOCK_50;
  end
      
  initial begin
    rst = 1'b1;
    #195 rst= 1'b0;
    #1000 $stop;
  end
       
  thinpad_min_sopc thinpad_min_sopc0(
		.clk(CLOCK_50),
		.rst(rst)	
	);
endmodule

