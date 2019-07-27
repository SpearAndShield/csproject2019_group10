`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/21 23:37:17
// Design Name: 
// Module Name: mux_for_pc_mem
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


module mux_for_pc_mem(rst,pc_addr,pc_e,
                      mem_userMode,mem_tlbwi,mem_refillMessage,mem_miss,mem_invalid,
                      userMode,tlbwi,refillMessage,mmu_miss,mmu_invalid,mmu_permissionDenied,mem_permissionDenied,
                      mem_ce,mem_addr,mem_data_i,mem_MasterRd,mem_MasterWr,mem_MasterByteEnable,
                      mmu_MasterRd,mmu_MasterWr,mmu_MasterByteEnable,mmu_addr,mmu_data_o,
                      mmu_data_i,pc_inst,mem_data_o,pc_permissionDenied,pc_miss,pc_invalid);
    input wire rst,mem_ce,pc_e,mem_MasterRd,mem_MasterWr;
    input wire[3:0] mem_MasterByteEnable;
    input wire[31:0] pc_addr,mem_addr,mem_data_i,mmu_data_i;
    input wire mem_userMode,mem_tlbwi,mmu_miss,mmu_invalid,mmu_permissionDenied;
    input wire[66:0] mem_refillMessage;
    
    output reg userMode,tlbwi,mem_miss,mem_invalid,mem_permissionDenied;
    output reg pc_permissionDenied,pc_miss,pc_invalid;
    output reg[66:0] refillMessage;
    output reg mmu_MasterRd,mmu_MasterWr;
    output reg[3:0] mmu_MasterByteEnable;
    output reg[31:0] mmu_addr,mmu_data_o,pc_inst,mem_data_o;
        
    always @ (*) begin
        if (rst == 1'b1) begin
            mem_data_o <= 32'h00000000;
            pc_inst <= 32'h00000000;
            mem_miss <= 1'b0;
            mem_invalid <= 1'b0;
            mem_permissionDenied <= 1'b0;
            pc_miss <= 1'b0;
            pc_invalid <= 1'b0;
            pc_permissionDenied <= 1'b0;
        end else if (mem_ce == 1'b1) begin
            mem_data_o <= mmu_data_i;
            mem_miss <= mmu_miss;
            mem_invalid <= mmu_invalid;
            mem_permissionDenied <= mmu_permissionDenied;
        end else begin
            mem_miss <= 1'b0;
            mem_invalid <= 1'b0;
            mem_permissionDenied <= 1'b0;
            pc_permissionDenied <= mmu_permissionDenied;
            pc_miss <= mmu_miss;
            pc_invalid <= mmu_invalid;
            pc_inst <= 32'h00000000;
            if (mmu_permissionDenied == 1'b0 && mmu_miss == 1'b0 && mmu_invalid == 1'b0)begin
                pc_inst <= mmu_data_i;
            end
        end
    end
    
    always @ (*) begin
        if (mem_ce == 1'b1) begin
            mmu_MasterRd <= mem_MasterRd;
            mmu_MasterWr <= mem_MasterWr;
            mmu_MasterByteEnable <= mem_MasterByteEnable;
            mmu_addr <= mem_addr;
            mmu_data_o <= mem_data_i;
            userMode <= mem_userMode;
            tlbwi <= mem_tlbwi;
            refillMessage <= mem_refillMessage;
        end else begin
            mmu_MasterRd <= 1'b1;
            mmu_MasterWr <= 1'b0;
            mmu_MasterByteEnable <= 4'b0000;
            mmu_addr <= pc_addr;
            mmu_data_o <= 32'h00000000;
            userMode <= 1'b0;
            tlbwi <= 1'b0;
            refillMessage <= 67'b0;
        end
    end
    
endmodule
