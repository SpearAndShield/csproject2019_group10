`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/16 20:48:35
// Design Name: 
// Module Name: inst_rom
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


module inst_rom(ce,addr,inst);
    input wire ce;
    input wire[31:0] addr;
    output reg[31:0] inst;
    
    reg[31:0] inst_mem[0:280000];
    
    //initial $readmemh ("fun.mem", inst_mem);
    
    always @ (*) begin
        if (ce == 1'b0)begin
            inst <= 32'h00000000;
        end else begin
            inst <= inst_mem[addr[31:2]];
        end
    end
    
endmodule
