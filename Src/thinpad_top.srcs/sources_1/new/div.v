`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/04 16:32:47
// Design Name: 
// Module Name: div
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

`include "defines.v"

module div(rst,clk,div,divinterrupt,data1,data2,result,fin);
    input wire rst,clk,div,divinterrupt;
    input wire[31:0] data1,data2;
    output reg[63:0] result;
    output reg fin;
    
    reg[5:0] cnt;
    reg[1:0] state;
    reg[64:0] divtemp;
    reg[32:0] temp2; 
    wire[32:0] divcheck;
    
    assign divcheck = {1'b0,divtemp[63:32]} + temp2;
    
    always @ (posedge clk) begin
        if (rst == 1'b1) begin
            state <= `DivFree;
            fin <= 1'b0;
            result <= 64'h0000000000000000;
        end else begin
            if (state == `DivFree) begin
                if (div == 1'b1) begin
                    if (data2 == 32'h00000000) begin
                        state <= `DivByZero;
                    end else begin
                        state <= `DivOn;
                        cnt <= 6'b000000;
                        temp2 <= {1'b1,~(data2)} + 1;
                        divtemp <= {32'h00000000, data1, 1'b0};
                    end
                    fin <= 1'b0;
                end else begin
                    fin <= 1'b0;
                    result <= 64'h0000000000000000;
                end
            end else if (state == `DivByZero) begin
                state <= `DivEnd;
                result <= 64'h0000000000000000;
                fin <= 1'b0;
            end else if (state == `DivOn) begin
                if (divinterrupt == 1'b0) begin
                    fin <= 1'b0;
                    if (cnt != 6'b100000) begin
                        if (divcheck[32]) begin
                            divtemp <= {divtemp[63:0], 1'b0};
                        end else begin
                            divtemp <= {divcheck[31:0], divtemp[31:0], 1'b1};
                        end
                        cnt <= cnt + 1;
                    end else begin
                        result <= {divtemp[64:33], divtemp[31:0]};
                        state <= `DivEnd;
                        cnt <= 0;
                    end
                end else begin
                    state <= `DivFree;
                end
            end else if (state == `DivEnd) begin
                fin <= 1'b1;
                state <= `DivFree;
            end
        end
    end
    
endmodule
