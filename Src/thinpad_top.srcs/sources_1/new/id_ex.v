`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/16 12:45:40
// Design Name: 
// Module Name: id_ex
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


module id_ex(rst,clk,id_alusel,id_aluop,id_reg1,id_reg2,id_wd,id_wreg,id_ret_addr,id_inst,
             ex_alusel,ex_aluop,ex_reg1,ex_reg2,ex_wd,ex_wreg,ex_ret_addr,ex_inst,stall,
             next_in_delayslot_i,is_in_delayslot_o,id_is_in_delayslot,ex_is_in_delayslot,
             id_instmiss,id_instinvalid,id_instpermissionDenied,id_int,ex_int,
             ex_instmiss,ex_instinvalid,ex_instpermissionDenied,id_flush,ex_flush,
             flush,id_excepttype,ex_excepttype,id_pc,ex_pc);
    input wire rst,clk,id_wreg,next_in_delayslot_i,id_is_in_delayslot,flush;
    input wire[2:0] id_alusel;
    input wire[4:0] id_wd;
    input wire[5:0] stall;
    input wire[7:0] id_aluop;
    input wire[31:0] id_reg1,id_reg2,id_ret_addr,id_inst,id_excepttype,id_pc;
    input wire id_instmiss,id_instinvalid,id_instpermissionDenied;
    output reg ex_instmiss,ex_instinvalid,ex_instpermissionDenied;
    output reg ex_wreg,is_in_delayslot_o,ex_is_in_delayslot;
    output reg[2:0] ex_alusel;
    output reg[4:0] ex_wd;
    output reg[7:0] ex_aluop;
    output reg[31:0] ex_reg1,ex_reg2,ex_ret_addr,ex_inst,ex_excepttype,ex_pc;
    input wire id_flush;
    output reg ex_flush;
    input wire[5:0] id_int;
    output reg[5:0] ex_int;
    
    always @ (posedge clk) begin
        if (rst == 1'b1) begin
            ex_aluop <= 8'b00000000;
            ex_alusel <= 3'b000;
            ex_reg1 <= 32'h00000000;
            ex_reg2 <= 32'h00000000;
            ex_wd <= 5'b00000;
            ex_wreg <= 1'b0;
            ex_ret_addr <= 32'h00000000;
            ex_inst <= 32'h00000000;
            ex_is_in_delayslot <= 1'b0;
            is_in_delayslot_o <= 1'b0;
            ex_excepttype <= 32'h00000000;
            ex_pc <= 32'h00000000;
            ex_instmiss <= 1'b0;
            ex_instinvalid <= 1'b0;
            ex_instpermissionDenied <= 1'b0;
            ex_flush <= 1'b0;
            ex_int <= 6'b000000;
        end else if (flush == 1'b1) begin
            ex_aluop <= 8'b00000000;
            ex_alusel <= 3'b000;
            ex_reg1 <= 32'h00000000;
            ex_reg2 <= 32'h00000000;
            ex_wd <= 5'b00000;
            ex_wreg <= 1'b0;
            ex_ret_addr <= 32'h00000000;
            ex_inst <= 32'h00000000;
            ex_is_in_delayslot <= 1'b0;
            is_in_delayslot_o <= 1'b0;
            ex_excepttype <= 32'h00000000;
            ex_pc <= 32'h00000000;
            ex_instmiss <= 1'b0;
            ex_instinvalid <= 1'b0;
            ex_instpermissionDenied <= 1'b0;
            ex_flush <= 1'b1;
            ex_int <= 6'b000000;
        end else if (stall[2] == 1'b1 && stall[3] == 1'b0) begin
            ex_aluop <= 8'b00000000;
            ex_alusel <= 3'b000;
            ex_reg1 <= 32'h00000000;
            ex_reg2 <= 32'h00000000;
            ex_wd <= 5'b00000;
            ex_wreg <= 1'b0;
            ex_ret_addr <= 32'h00000000;
            ex_inst <= 32'h00000000;
            ex_is_in_delayslot <= id_is_in_delayslot;
            is_in_delayslot_o <= 1'b0;
            ex_excepttype <= 32'h00000000;
            ex_pc <= id_pc;
            ex_instmiss <= 1'b0;
            ex_instinvalid <= 1'b0;
            ex_instpermissionDenied <= 1'b0;
            ex_flush <= 1'b0;
            ex_int <= 6'b000000;
        end else if (stall[2] == 1'b0) begin
            ex_aluop <= id_aluop;
            ex_alusel <= id_alusel;
            ex_reg1 <= id_reg1;
            ex_reg2 <= id_reg2;
            ex_wd <= id_wd;
            ex_wreg <= id_wreg;
            ex_ret_addr <= id_ret_addr;
            ex_inst <= id_inst;
            ex_is_in_delayslot <= id_is_in_delayslot;
            is_in_delayslot_o <= next_in_delayslot_i;
            ex_excepttype <= id_excepttype;
            ex_pc <= id_pc;
            ex_instmiss <= id_instmiss;
            ex_instinvalid <= id_instinvalid;
            ex_instpermissionDenied <= id_instpermissionDenied;
            ex_flush <= id_flush;
            ex_int <= id_int;
        end
    end
endmodule
