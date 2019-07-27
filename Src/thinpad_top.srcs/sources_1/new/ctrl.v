`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/04 15:39:18
// Design Name: 
// Module Name: ctrl
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


module ctrl(rst,mem_idstall,ex_stall,ex_idstall,stall,flash_stall,cp0_epc_i,cp0_ebase_i,excepttype_i,flush,new_pc);
    input wire rst,mem_idstall,ex_stall,ex_idstall,flash_stall;
    input wire[4:0] excepttype_i;
    input wire[31:0] cp0_epc_i,cp0_ebase_i;
    output reg flush;
    output reg[5:0] stall;
    output reg[31:0] new_pc;
    
    always @ (*) begin
        if (rst == 1'b1) begin
            flush <= 1'b0;
            new_pc <= 32'h00000000;            
            stall <= 6'b000000;
        end else if (excepttype_i != 5'b00000) begin
            flush <= 1'b1;
            stall <= 6'b000000;
            if (excepttype_i == 5'b01110) begin
                new_pc <= cp0_epc_i;
            end else begin
                new_pc <= cp0_ebase_i;
            end
        end else if (flash_stall == 1'b1) begin
            stall <= 6'b011111;
            flush <= 1'b0;
            new_pc <= 32'h00000000;
        end else if (ex_stall == 1'b1) begin
            stall <= 6'b001111;
            flush <= 1'b0;
            new_pc <= 32'h00000000;
        end else if (ex_idstall == 1'b1) begin
            stall <= 6'b000111;
            flush <= 1'b0;
            new_pc <= 32'h00000000;
      /*  end else if (mem_idstall == 1'b1) begin
            stall <= 6'b000111;
            flush <= 1'b0;
            new_pc <= 32'h00000000;*/
        end else begin
            stall <= 6'b000000;
            flush <= 1'b0;
            new_pc <= 32'h00000000;
        end
    end
    
endmodule
