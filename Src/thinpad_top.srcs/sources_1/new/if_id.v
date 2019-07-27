`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 23:36:33
// Design Name: 
// Module Name: if_id
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


module if_id(clk,rst,if_pc,if_inst,stall,id_pc,id_inst,flush,id_flush,id_int,if_int,
             if_instmiss,if_instinvalid,if_instpermissionDenied,
             id_instmiss,id_instinvalid,id_instpermissionDenied);
    input wire clk,rst,flush;
    input wire[5:0] stall;
    input wire[31:0] if_pc,if_inst;
    input wire if_instmiss,if_instinvalid,if_instpermissionDenied;
    output reg id_instmiss,id_instinvalid,id_instpermissionDenied,id_flush;
    output reg[31:0] id_pc,id_inst;
    input wire[5:0] if_int;
    output reg[5:0] id_int;
    always @ (posedge clk) begin
        if (rst == 1'b1) begin
            id_pc <= 32'h00000000;
            id_inst <= 32'h00000000;
            id_instmiss <= 1'b0;
            id_instinvalid <= 1'b0;
            id_instpermissionDenied <= 1'b0;
            id_flush <= 1'b0;
            id_int <= 6'b000000;
        end else if (flush == 1'b1) begin
            id_pc <= 32'h00000000;
            id_inst <= 32'h00000000;
            id_instmiss <= 1'b0;
            id_instinvalid <= 1'b0;
            id_instpermissionDenied <= 1'b0;
            id_flush <= 1'b1;
            id_int <= 6'b000000;
        end else if (stall[1] == 1'b1 && stall[2] == 1'b0) begin
            id_pc <= 32'h00000000;
            id_inst <= 32'h00000000;
            id_instmiss <= 1'b0;
            id_instinvalid <= 1'b0;
            id_instpermissionDenied <= 1'b0;
            id_flush <= 1'b1;
            id_int <= 6'b000000;
        end else if(stall[1] == 1'b0) begin
            id_pc <= if_pc;
            id_inst <= if_inst;
            id_instmiss <= if_instmiss;
            id_instinvalid <= if_instinvalid;
            id_instpermissionDenied <= if_instpermissionDenied;
            id_flush <= 1'b0;
            id_int <= if_int;
        end
    end
endmodule

