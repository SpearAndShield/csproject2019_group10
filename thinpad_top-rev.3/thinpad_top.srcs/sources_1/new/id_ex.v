`timescale 1ns / 1ps

module id_ex(rst,clk,id_alusel,id_aluop,id_reg1,id_reg2,id_wd,id_wreg,
             ex_alusel,ex_aluop,ex_reg1,ex_reg2,ex_wd,ex_wreg);
    input wire rst,clk,id_wreg;
    input wire[2:0] id_alusel;
    input wire[4:0] id_wd;
    input wire[7:0] id_aluop;
    input wire[31:0] id_reg1,id_reg2;
    output reg ex_wreg;
    output reg[2:0] ex_alusel;
    output reg[4:0] ex_wd;
    output reg[7:0] ex_aluop;
    output reg[31:0] ex_reg1,ex_reg2;
    
    always @ (posedge clk) begin
        if (rst == 1'b1) begin
            ex_aluop <= 8'b00000000;
            ex_alusel <= 3'b000;
            ex_reg1 <= 32'h00000000;
            ex_reg2 <= 32'h00000000;
            ex_wd <= 5'b00000;
            ex_wreg <= 1'b0;
        end else begin
            ex_aluop <= id_aluop;
            ex_alusel <= id_alusel;
            ex_reg1 <= id_reg1;
            ex_reg2 <= id_reg2;
            ex_wd <= id_wd;
            ex_wreg <= id_wreg;
        end
    end
endmodule
