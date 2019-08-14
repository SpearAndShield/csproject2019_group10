`timescale 1ns / 1ps


module mem_wb(rst,clk,mem_wd,mem_wreg,mem_wdata,wb_wd,wb_wreg,wb_wdata);
    input wire rst,clk,mem_wreg;
    input wire[4:0] mem_wd;
    input wire[31:0] mem_wdata;
    output reg wb_wreg;
    output reg[4:0] wb_wd;
    output reg[31:0] wb_wdata;
    
    always @ (posedge clk) begin
        if (rst == 1'b1)begin
            wb_wreg <= 1'b0;
            wb_wd <= 5'b00000;
            wb_wdata <= 32'h00000000;
        end else begin
            wb_wd <= mem_wd;
            wb_wreg <= mem_wreg;
            wb_wdata <= mem_wdata;
        end
    end
    
endmodule
