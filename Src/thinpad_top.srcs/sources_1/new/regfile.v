`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 23:46:00
// Design Name: 
// Module Name: regfile
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


module regfile(rst,clk,waddr,wdata,we,raddr1,re1,rdata1,raddr2,re2,rdata2,regcheck,regsum);
    input wire rst,clk,we,re1,re2;
    input wire[4:0] waddr,raddr1,raddr2;
    input wire[31:0] wdata;
    output reg[31:0] rdata1,rdata2;
    output wire[31:0] regcheck,regsum;
    reg[31:0] regs[0:31];
    
    assign regsum = regs[4];
    assign regcheck = regs[19];
    
    always @ (posedge clk) begin
        if (rst == 1'b0) begin
            if ((we == 1'b1) && (waddr != 5'h0)) begin
                regs[waddr] <= wdata;
            end
        end else begin
            regs[0] <= 32'h00000000;
            regs[1] <= 32'h00000000;
            regs[2] <= 32'h00000000;
            regs[3] <= 32'h00000000;
            regs[4] <= 32'h00000000;
            regs[5] <= 32'h00000000;
            regs[6] <= 32'h00000000;
            regs[7] <= 32'h00000000;
            regs[8] <= 32'h00000000;
            regs[9] <= 32'h00000000;
            regs[10] <= 32'h00000000;
            regs[11] <= 32'h00000000;
            regs[12] <= 32'h00000000;
            regs[13] <= 32'h00000000;
            regs[14] <= 32'h00000000;
            regs[15] <= 32'h00000000;
            regs[16] <= 32'h00000000;
            regs[17] <= 32'h00000000;
            regs[18] <= 32'h00000000;
            regs[19] <= 32'h00000000;
            regs[20] <= 32'h00000000;
            regs[21] <= 32'h00000000;
            regs[22] <= 32'h00000000;
            regs[23] <= 32'h00000000;
            regs[24] <= 32'h00000000;
            regs[25] <= 32'h00000000;
            regs[26] <= 32'h00000000;
            regs[27] <= 32'h00000000;
            regs[28] <= 32'h00000000;
            regs[29] <= 32'h00000000;
            regs[30] <= 32'h00000000;
            regs[31] <= 32'h00000000;
        end
    end
        
    always @ (*) begin
        if (rst == 1'b1) begin
            rdata1 <= 32'h00000000;
        end else if (re1 == 1'b0) begin
            rdata1 <= 32'h00000000;
        end else if (raddr1 == 5'h0) begin
            rdata1 <= 32'h00000000;
        end else if ((raddr1 == waddr)&&(we == 1'b1)) begin
            rdata1 <= wdata;
        end else begin
            rdata1 <= regs[raddr1];
        end
    end
    
    always @ (*) begin
        if (rst == 1'b1) begin
            rdata2 <= 32'h00000000;
        end else if (re2 == 1'b0) begin
            rdata2 <= 32'h00000000;
        end else if (raddr2 == 5'h0) begin
            rdata2 <= 32'h00000000;
        end else if ((raddr2 == waddr)&&(we == 1'b1)) begin
            rdata2 <= wdata;
        end else begin
            rdata2 <= regs[raddr2];
        end
    end
endmodule

