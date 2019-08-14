`timescale 1ns / 1ps

`include "defines.v"

module mem(rst,wd_i,wreg_i,wdata_i,
           wd_o,wreg_o,wdata_o);
    input wire rst,wreg_i;
    input wire[4:0] wd_i;
    input wire[31:0] wdata_i;
    output reg wreg_o;
    output reg[4:0] wd_o;
    output reg[31:0] wdata_o;


    always @ (*) begin
        if (rst == 1'b1) begin
            wd_o <= 5'b00000;
            wreg_o <= 1'b0;
            wdata_o <= 32'h00000000;
        end else begin
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            wdata_o <= wdata_i;
        end
    end
  endmodule