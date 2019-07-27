`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/23 14:07:25
// Design Name: 
// Module Name: hilo_reg
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


module hilo_reg(rst,clk,we,hi_i,lo_i,hi_o,lo_o);
    input wire we,rst,clk;
    input wire[31:0] hi_i,lo_i;
    output reg[31:0] hi_o,lo_o;
    
    always @ (posedge clk) begin
        if (rst == 1'b1)begin
            hi_o <= 32'h00000000;
            lo_o <= 32'h00000000;
        end else if (we == 1'b1) begin
            hi_o <= hi_i;
            lo_o <= lo_i;
        end
    end
    
endmodule
