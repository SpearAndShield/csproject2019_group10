`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 23:05:50
// Design Name: 
// Module Name: pc_reg
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


module pc_reg(clk,rst,stall,jr_o,jr_addr,pc,ce,flush,new_pc);
    input wire clk,rst,jr_o,flush;
    input wire[5:0] stall;
    input wire[31:0] jr_addr,new_pc;
    output reg[31:0] pc;
    output reg ce;
    
    always @ (clk,rst,stall) begin
        ce <= (~rst) && (~stall[0]);
    end
        
    always @ (posedge clk) begin
        if (rst == 1'b1) begin
            pc <= 32'hbfc00000;
        end else begin
            if (flush == 1'b1) begin
                pc <= new_pc;
            end else if (stall[0] == 1'b1) begin
            end else if (jr_o == 1'b1) begin
                pc <= jr_addr;
            end else begin
                pc <= pc + 4'h4;
            end
        end
    end
endmodule
