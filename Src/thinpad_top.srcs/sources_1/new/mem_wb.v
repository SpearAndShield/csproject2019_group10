`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/16 14:17:49
// Design Name: 
// Module Name: mem_wb
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


module mem_wb(rst,clk,mem_wd,mem_wreg,mem_wdata,wb_wd,wb_wreg,wb_wdata,
              mem_whio,mem_hi,mem_lo,wb_whio,wb_hi,wb_lo,flush,stall,
              mem_cp0_we,mem_cp0_waddr,mem_cp0_wdata,wb_cp0_we,wb_cp0_waddr,wb_cp0_wdata);
    input wire rst,clk,mem_wreg,mem_whio,mem_cp0_we,flush;
    input wire[4:0] mem_wd,mem_cp0_waddr;
    input wire[5:0] stall;
    input wire[31:0] mem_wdata,mem_hi,mem_lo,mem_cp0_wdata;
    output reg wb_wreg,wb_whio,wb_cp0_we;
    output reg[4:0] wb_wd,wb_cp0_waddr;
    output reg[31:0] wb_wdata,wb_hi,wb_lo,wb_cp0_wdata;
    
    always @ (posedge clk) begin
        if (rst == 1'b1)begin
            wb_wreg <= 1'b0;
            wb_wd <= 5'b00000;
            wb_wdata <= 32'h00000000;
            wb_whio <= 1'b0;
            wb_hi <= 32'h00000000;
            wb_lo <= 32'h00000000;
            wb_cp0_we <= 1'b0;
            wb_cp0_waddr <= 5'b00000;
            wb_cp0_wdata <= 32'h00000000;
        end else if (flush == 1'b1) begin
            wb_wreg <= 1'b0;
            wb_wd <= 5'b00000;
            wb_wdata <= 32'h00000000;
            wb_whio <= 1'b0;
            wb_hi <= 32'h00000000;
            wb_lo <= 32'h00000000;
            wb_cp0_we <= 1'b0;
            wb_cp0_waddr <= 5'b00000;
            wb_cp0_wdata <= 32'h00000000;
        end else if (stall[4] == 1'b1 && stall[5] == 1'b0) begin
            wb_wreg <= 1'b0;
            wb_wd <= 5'b00000;
            wb_wdata <= 32'h00000000;
            wb_whio <= 1'b0;
            wb_hi <= 32'h00000000;
            wb_lo <= 32'h00000000;
            wb_cp0_we <= 1'b0;
            wb_cp0_waddr <= 5'b00000;
            wb_cp0_wdata <= 32'h00000000;
        end else if (stall[4] == 1'b0) begin
            wb_wd <= mem_wd;
            wb_wreg <= mem_wreg;
            wb_wdata <= mem_wdata;
            wb_whio <= mem_whio;
            wb_hi <= mem_hi;
            wb_lo <= mem_lo;
            wb_cp0_we <= mem_cp0_we;
            wb_cp0_waddr <= mem_cp0_waddr;
            wb_cp0_wdata <= mem_cp0_wdata;
        end
    end
    
endmodule
