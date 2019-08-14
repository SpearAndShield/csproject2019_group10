`timescale 1ns / 1ps


module ex_mem(rst,clk,ex_wd,ex_wreg,ex_wdata,
              mem_wd,mem_wreg,mem_wdata);
    input wire rst,clk,ex_wreg;
    input wire[4:0] ex_wd;
    input wire[31:0] ex_wdata;
    output reg mem_wreg;
    output reg[4:0] mem_wd;
    output reg[31:0] mem_wdata;

    always @ (posedge clk) begin
        if (rst == 1'b1) begin
            mem_wd <= 5'b00000;
            mem_wreg <= 1'b0;
            mem_wdata <= 32'h00000000;

        end else begin
            mem_wd <= ex_wd;
            mem_wreg <= ex_wreg;
            mem_wdata <= ex_wdata;
        end
    end
endmodule
