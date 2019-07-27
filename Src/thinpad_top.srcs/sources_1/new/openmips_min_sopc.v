`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/16 21:08:02
// Design Name: 
// Module Name: openmips_min_sopc
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


module openmips_min_sopc(clk, rst, mmu_data_i, cpu_stall, regcheck, regsum, virtAddr, masterRd, masterWr, mmu_data_o, masterByteEnable,
                         userMode, tlbwi, refillMessage, mmu_miss, mmu_invalid, mmu_permissionDenied, uart_int_i, debugger);
    input wire clk,rst;
    input wire[31:0] mmu_data_i;
    input wire cpu_stall,uart_int_i;
    input wire mmu_miss,mmu_invalid,mmu_permissionDenied;

    output wire[31:0] regcheck,regsum;
    output wire[31:0] virtAddr;
    output wire masterRd, masterWr, userMode, tlbwi;
    output wire[31:0] mmu_data_o;
    output wire[3:0] masterByteEnable; 
    output wire[66:0] refillMessage;
    output wire[63:0] debugger;
    wire pc_e,mem_ce,mem_MasterRd,mem_MasterWr;
    wire[3:0] mem_MasterByteEnable;
    wire[31:0] inst_addr,mem_addr,mem_data_o,inst,mem_data_i;
    wire mem_userMode,mem_tlbwi,mem_miss,mem_invalid,mem_permissionDenied;
    wire pc_permissionDenied,pc_miss,pc_invalid;
    wire[66:0] mem_refillMessage;
    
    wire[63:0] tempdebug;

    wire timer_int_o;
    wire[5:0] int_i;
    
    assign int_i = {timer_int_o, 2'b00, uart_int_i, 2'b00};
    
    openmips openmips0(
        .rst(rst),.clk(clk),
        .rom_data_i(inst),.rom_ce_o(pc_e),.rom_addr_o(inst_addr),
        .ram_data_i(mem_data_i),.ram_data_o(mem_data_o),.ram_ce_o(mem_ce),
        .virtAddr(mem_addr),.MasterRd(mem_MasterRd),.MasterWr(mem_MasterWr),.MasterByteEnable(mem_MasterByteEnable),
        .userMode(mem_userMode),.tlbwi(mem_tlbwi),.refillMessage(mem_refillMessage),
        .mem_miss(mem_miss),.mem_invalid(mem_invalid),.mem_permissionDenied(mem_permissionDenied),
        .pc_miss(pc_miss),.pc_invalid(pc_invalid),.pc_permissionDenied(pc_permissionDenied),
        .regcheck(regcheck),.regsum(regsum), .debugger        (tempdebug),
        .int_i(int_i), .timer_int_o(timer_int_o), .cpu_stall(cpu_stall)
    );

    assign debugger = {tempdebug[63:28], masterByteEnable, tempdebug[23:0]};

    mux_for_pc_mem mux_for_pc_mem0(
        .rst(rst),
        .pc_addr(inst_addr),.pc_e(pc_e),
        .mem_ce(mem_ce),.mem_addr(mem_addr),.mem_data_i(mem_data_o),
        .mem_MasterRd(mem_MasterRd),.mem_MasterWr(mem_MasterWr),.mem_MasterByteEnable(mem_MasterByteEnable),
        .mem_userMode(mem_userMode),.mem_tlbwi(mem_tlbwi),.mem_refillMessage(mem_refillMessage),
        
        .mmu_MasterRd(masterRd),.mmu_MasterWr(masterWr),.mmu_MasterByteEnable(masterByteEnable),
        .mmu_addr(virtAddr),.mmu_data_o(mmu_data_o),
        .userMode(userMode),.tlbwi(tlbwi),.refillMessage(refillMessage),
        
        .mmu_data_i(mmu_data_i),.mmu_miss(mmu_miss),.mmu_invalid(mmu_invalid),.mmu_permissionDenied(mmu_permissionDenied),
        .mem_miss(mem_miss),.mem_invalid(mem_invalid),.mem_permissionDenied(mem_permissionDenied),
        .pc_miss(pc_miss),.pc_invalid(pc_invalid),.pc_permissionDenied(pc_permissionDenied),
        .pc_inst(inst),.mem_data_o(mem_data_i)
    );    
    
    
endmodule