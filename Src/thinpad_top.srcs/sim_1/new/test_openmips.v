`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/16 21:55:34
// Design Name: 
// Module Name: test_openmips
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


module test_openmips();
    reg clk,rst,clk_in,clk2x;
    
    initial begin
        clk_in = 1'b0;
        forever #10 clk_in = ~clk_in;
    end
    
        
    initial begin
        rst = 1'b1;
        #100 rst = 1'b0;
        #1000 $stop;
    end
    
    wire out;
    

endmodule
