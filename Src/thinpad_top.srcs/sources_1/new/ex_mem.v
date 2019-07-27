`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/16 13:51:47
// Design Name: 
// Module Name: ex_mem
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


module ex_mem(rst,clk,ex_wd,ex_wreg,ex_wdata,ex_memop,ex_memaddr,ex_memdata,ex_memce,ex_whio,ex_hi,ex_lo,
              mem_wd,mem_wreg,mem_wdata,mem_whio,mem_hi,mem_lo,mem_ce,mem_op,mem_addr,mem_data,stall,
              ex_cp0_we,ex_cp0_waddr,ex_cp0_wdata,mem_cp0_we,mem_cp0_waddr,mem_cp0_wdata,flush,ex_flush,
              ex_excepttype,ex_pc,mem_excepttype,mem_pc,ex_is_in_delayslot,mem_is_in_delayslot,mem_flush,
              ex_instmiss,ex_instinvalid,ex_instpermissionDenied,ex_int,mem_int,
              mem_instmiss,mem_instinvalid,mem_instpermissionDenied);
    input wire rst,clk,ex_wreg,ex_whio,ex_memce,ex_cp0_we,flush,ex_is_in_delayslot;
    input wire[4:0] ex_wd,ex_memop,ex_cp0_waddr;
    input wire[5:0] stall;
    input wire[31:0] ex_wdata,ex_hi,ex_lo,ex_memaddr,ex_memdata,ex_cp0_wdata,ex_excepttype,ex_pc;
    input wire ex_instmiss,ex_instinvalid,ex_instpermissionDenied;
    output reg mem_instmiss,mem_instinvalid,mem_instpermissionDenied;
    output reg mem_wreg,mem_whio,mem_ce,mem_cp0_we,mem_is_in_delayslot;
    output reg[4:0] mem_wd,mem_op,mem_cp0_waddr;
    output reg[31:0] mem_wdata,mem_hi,mem_lo,mem_addr,mem_data,mem_cp0_wdata,mem_excepttype,mem_pc;
    input wire ex_flush;
    output reg mem_flush;
    input wire[5:0] ex_int;
    output reg[5:0] mem_int;
    
    always @ (posedge clk) begin
        if (rst == 1'b1) begin
            mem_wd <= 5'b00000;
            mem_wreg <= 1'b0;
            mem_wdata <= 32'h00000000;
            mem_whio <= 1'b0;
            mem_hi <= 32'h00000000;
            mem_lo <= 32'h00000000;
            mem_ce <= 1'b0;
            mem_op <= 5'b00000;
            mem_addr <= 32'h00000000;
            mem_data <= 32'h00000000;
            mem_cp0_we <= 1'b0;
            mem_cp0_waddr <= 5'b00000;
            mem_cp0_wdata <= 32'h00000000;
            mem_pc <= 32'h00000000;
            mem_excepttype <= 32'h00000000;
            mem_instmiss <= 1'b0;
            mem_instinvalid <= 1'b0;
            mem_instpermissionDenied <= 1'b0;
            mem_flush <= 1'b0;
            mem_int <= 6'b000000;
        end else if (flush == 1'b1) begin
            mem_wd <= 5'b00000;
            mem_wreg <= 1'b0;
            mem_wdata <= 32'h00000000;
            mem_whio <= 1'b0;
            mem_hi <= 32'h00000000;
            mem_lo <= 32'h00000000;
            mem_ce <= 1'b0;
            mem_op <= 5'b00000;
            mem_addr <= 32'h00000000;
            mem_data <= 32'h00000000;
            mem_cp0_we <= 1'b0;
            mem_cp0_waddr <= 5'b00000;
            mem_cp0_wdata <= 32'h00000000;
            mem_pc <= 32'h00000000;
            mem_excepttype <= 32'h00000000;
            mem_is_in_delayslot <= 1'b0;
            mem_instmiss <= 1'b0;
            mem_instinvalid <= 1'b0;
            mem_instpermissionDenied <= 1'b0;
            mem_flush <= 1'b1;
            mem_int <= 6'b000000;
        end else if(stall[3] == 1'b1 && stall[4] == 1'b0) begin
            mem_wd <= 5'b00000;
            mem_wreg <= 1'b0;
            mem_wdata <= 32'h00000000;
            mem_whio <= 1'b0;
            mem_hi <= 32'h00000000;
            mem_lo <= 32'h00000000;
            mem_ce <= 1'b0;
            mem_op <= 5'b00000;
            mem_addr <= 32'h00000000;
            mem_data <= 32'h00000000;
            mem_cp0_we <= 1'b0;
            mem_cp0_waddr <= 5'b00000;
            mem_cp0_wdata <= 32'h00000000;
            mem_pc <= ex_pc;
            mem_excepttype <= 32'h00000000;
            mem_is_in_delayslot <= ex_is_in_delayslot;
            mem_instmiss <= 1'b0;
            mem_instinvalid <= 1'b0;
            mem_instpermissionDenied <= 1'b0;
            mem_flush <= 1'b0;
            mem_int <= 6'b000000;
        end else if(stall[3] == 1'b0) begin
            mem_wd <= ex_wd;
            mem_wreg <= ex_wreg;
            mem_wdata <= ex_wdata;
            mem_whio <= ex_whio;
            mem_hi <= ex_hi;
            mem_lo <= ex_lo;
            mem_ce <= ex_memce;
            mem_op <= ex_memop;
            mem_addr <= ex_memaddr;
            mem_data <= ex_memdata;
            mem_cp0_we <= ex_cp0_we;
            mem_cp0_waddr <= ex_cp0_waddr;
            mem_cp0_wdata <= ex_cp0_wdata;
            mem_pc <= ex_pc;
            mem_excepttype <= ex_excepttype;
            mem_is_in_delayslot <= ex_is_in_delayslot;
            mem_instmiss <= ex_instmiss;
            mem_instinvalid <= ex_instinvalid;
            mem_instpermissionDenied <= ex_instpermissionDenied;
            mem_flush <= ex_flush;
            mem_int <= ex_int;
        end
    end
endmodule
