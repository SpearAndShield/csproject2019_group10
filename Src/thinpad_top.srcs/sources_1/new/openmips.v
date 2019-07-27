`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/16 19:36:53
// Design Name: 
// Module Name: openmips
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


           module openmips(rst, clk, rom_data_i, rom_ce_o, rom_addr_o, ram_data_i, ram_ce_o, ram_data_o, regcheck, regsum,
                MasterRd, MasterWr, MasterByteEnable, virtAddr, userMode, tlbwi, refillMessage,
                mem_miss, mem_invalid, mem_permissionDenied, cpu_stall,
                pc_miss, pc_invalid, pc_permissionDenied, debugger, timer_int_o, int_i);
    input wire rst,clk;
    input wire mem_miss,mem_invalid,mem_permissionDenied,cpu_stall;
    input wire pc_miss,pc_invalid,pc_permissionDenied;
    input wire[31:0] rom_data_i,ram_data_i;
    output wire rom_ce_o,ram_ce_o;
    output wire[31:0] rom_addr_o,ram_data_o;
    output wire[31:0] regcheck,virtAddr,regsum;
    
    input wire[5:0] int_i;
    output wire timer_int_o;
    
    output wire MasterRd,MasterWr;
    output wire[3:0] MasterByteEnable;
    
    output wire userMode,tlbwi;
    output wire[66:0] refillMessage;
    output wire[63:0] debugger;

    wire flush;
    wire[31:0] new_pc;
    
    wire[31:0] pc;
    
    wire ex_stall,ex_idstall,mem_idstall;
    wire[5:0] stall;
    
    wire div_start,div_end;
    wire[31:0] div_data1,div_data2;
    wire[63:0] divres;
    
    wire[31:0] reg1_data,reg2_data;
    wire[4:0] reg1_addr,reg2_addr;
    wire reg1_read,reg2_read;

    wire[31:0] id_pc_i,id_inst_i;
    wire id_instmiss_i,id_instinvalid_i,id_instpermissionDenied_i;
    wire id_instmiss_o,id_instinvalid_o,id_instpermissionDenied_o;
    wire[7:0] id_aluop_o;
    wire[2:0] id_alusel_o;
    wire[4:0] id_wd_o;
    wire id_wreg_o,id_next_in_delayslot_o,id_is_in_delayslot_i,id_is_in_delayslot_o,id_jr_o;
    wire[31:0] id_reg1_o,id_reg2_o,id_jr_addr_o,id_ret_addr_o,id_inst_o,id_excepttype_o,id_pc_o;
    
    wire[7:0] ex_aluop_i;
    wire[2:0] ex_alusel_i;
    wire ex_wreg_i,ex_is_in_delayslot_i;
    wire[4:0] ex_wd_i;
    wire[31:0] ex_reg1_i,ex_reg2_i,ex_ret_addr_i,ex_inst_i,ex_excepttype_i,ex_pc_i;
    wire[31:0] ex_cp0_data_i;
    
    wire ex_instmiss_i,ex_instinvalid_i,ex_instpermissionDenied_i;
    wire ex_instmiss_o,ex_instinvalid_o,ex_instpermissionDenied_o;
    
    wire[4:0] ex_wd_o,ex_memop_o;
    wire[31:0] ex_wdata_o,ex_hi_o,ex_lo_o,ex_memaddr_o,ex_memdata_o,ex_excepttype_o,ex_pc_o;
    wire ex_wreg_o,ex_whio_o,ex_memce_o,ex_cp0_we_o,ex_is_in_delayslot_o,ex_cp0_rsel_o;
    wire[4:0] ex_cp0_waddr_o,ex_cp0_raddr_o;
    wire[31:0] ex_cp0_wdata_o;

    wire mem_instmiss_i,mem_instinvalid_i,mem_instpermissionDenied_i;
    wire[4:0] mem_wd_i,mem_op_i;
    wire[31:0] mem_wdata_i,mem_hi_i,mem_lo_i,mem_addr_i,mem_data_i,mem_excepttype_i,mem_pc_i;
    wire mem_wreg_i,mem_whio_i,mem_ce_i,mem_is_in_delayslot_i;
    wire mem_cp0_we_i;
    wire[4:0] mem_cp0_waddr_i;
    wire[31:0] mem_cp0_wdata_i;
    wire mem_pcreset_i;
       
    wire[4:0] mem_wd_o,mem_cp0_waddr_o,mem_excepttype_o;
    wire[31:0] mem_wdata_o,mem_hi_o,mem_lo_o,mem_cp0_wdata_o,mem_pc_o,mem_cp0_epc_o,mem_cp0_ebase_o;
    wire mem_wreg_o,mem_whio_o,mem_cp0_we_o;
    wire mem_is_in_delayslot_o;
    wire mem_pcreset_o;

    wire[4:0] wb_wd_i,wb_cp0_waddr_i;
    wire[31:0] wb_wdata_i,wb_hi_i,wb_lo_i,wb_cp0_wdata_i;
    wire wb_wreg_i,wb_whio_i,wb_cp0_we_i;
    
    wire[31:0] wb_hi_o,wb_lo_o; 
    
    wire[31:0] cp0_epc,cp0_ebase,cp0_badaddr,cp0_index,cp0_entrylo0,cp0_entrylo1,cp0_entryhi,cp0_cause,cp0_status,cp0_random;

    wire id_pcreset_i,id_pcreset_o,ex_pcreset_i,ex_pcreset_o;
    wire[5:0] id_int_i,id_int_o,ex_int_i,ex_int_o,mem_int_i,mem_int_o;

    
    ctrl ctrl0(
        .rst(rst),.mem_idstall(mem_idstall),.ex_stall(ex_stall),.ex_idstall(ex_idstall),.stall(stall),.flash_stall(cpu_stall),
        .flush(flush),.new_pc(new_pc),.excepttype_i(mem_excepttype_o),.cp0_epc_i(mem_cp0_epc_o),.cp0_ebase_i(mem_cp0_ebase_o)
    );

    pc_reg pc_reg0(
        .clk(clk),.rst(rst),.pc(pc),.ce(rom_ce_o),.jr_o(id_jr_o),.jr_addr(id_jr_addr_o),.stall(stall),.flush(flush),.new_pc(new_pc)
    );
    
    assign rom_addr_o = pc;
    
    if_id if_id0(
        .clk(clk),.rst(rst),.if_pc(pc),.if_inst(rom_data_i),
        .if_instmiss(pc_miss),.if_instinvalid(pc_invalid),.if_instpermissionDenied(pc_permissionDenied),
        .id_instmiss(id_instmiss_i),.id_instinvalid(id_instinvalid_i),.id_instpermissionDenied(id_instpermissionDenied_i),
        .id_pc(id_pc_i),.id_inst(id_inst_i),.stall(stall),.flush(flush),.id_flush(id_pcreset_i),
        .if_int(int_i),.id_int(id_int_i)
    );
    
    id id0(
        .clk(clk), .rst(rst), .pc_i(id_pc_i), .inst_i(id_inst_i),
        .reg1_data_i(reg1_data),.reg2_data_i(reg2_data),
        .reg1_re_o(reg1_read),.reg2_re_o(reg2_read),
        .reg1_addr_o(reg1_addr),.reg2_addr_o(reg2_addr),
        .alu_op_o(id_aluop_o),.alu_sel_o(id_alusel_o),
        .reg1_o(id_reg1_o),.reg2_o(id_reg2_o),
        .wd_o(id_wd_o),.wreg_o(id_wreg_o),
        .ex_wd_i(ex_wd_o),.ex_wreg_i(ex_wreg_o),.ex_wdata_i(ex_wdata_o),
        .mem_wd_i(mem_wd_o),.mem_wreg_i(mem_wreg_o),.mem_wdata_i(mem_wdata_o),
        .jr_o(id_jr_o),.jr_addr(id_jr_addr_o),.ret_addr(id_ret_addr_o),.inst_o(id_inst_o),
        .next_in_delayslot(id_next_in_delayslot_o),
        .is_in_delayslot_i(id_is_in_delayslot_i),.is_in_delayslot_o(id_is_in_delayslot_o),
        .instmiss_i(id_instmiss_i),.instinvalid_i(id_instinvalid_i),.instpermissionDenied_i(id_instpermissionDenied_i),
        .instmiss_o(id_instmiss_o),.instinvalid_o(id_instinvalid_o),.instpermissionDenied_o(id_instpermissionDenied_o),
        .excepttype_o(id_excepttype_o),.pc_o(id_pc_o),
        .flush_i(id_pcreset_i),.flush_o(id_pcreset_o),
        .int_i(id_int_i),.int_o(id_int_o)
    );  
        
    id_ex id_ex0(
        .rst(rst),.clk(clk),
        .id_alusel(id_alusel_o),.id_aluop(id_aluop_o),.id_ret_addr(id_ret_addr_o),
        .id_reg1(id_reg1_o),.id_reg2(id_reg2_o),.id_wd(id_wd_o),.id_wreg(id_wreg_o),.id_inst(id_inst_o),
        .ex_alusel(ex_alusel_i),.ex_aluop(ex_aluop_i),.ex_ret_addr(ex_ret_addr_i),
        .ex_reg1(ex_reg1_i),.ex_reg2(ex_reg2_i),.ex_wd(ex_wd_i),.ex_wreg(ex_wreg_i),.ex_inst(ex_inst_i),
        .id_is_in_delayslot(id_is_in_delayslot_o),.ex_is_in_delayslot(ex_is_in_delayslot_i),
        .next_in_delayslot_i(id_next_in_delayslot_o),.is_in_delayslot_o(id_is_in_delayslot_i),
        .id_pc(id_pc_o),.ex_pc(ex_pc_i),.id_excepttype(id_excepttype_o),.ex_excepttype(ex_excepttype_i),
        .id_instmiss(id_instmiss_o),.id_instinvalid(id_instinvalid_o),.id_instpermissionDenied(id_instpermissionDenied_o),
        .ex_instmiss(ex_instmiss_i),.ex_instinvalid(ex_instinvalid_i),.ex_instpermissionDenied(ex_instpermissionDenied_i),
        .stall(stall),.flush(flush),.id_flush(id_pcreset_o),.ex_flush(ex_pcreset_i),
        .id_int(id_int_o),.ex_int(ex_int_i)
    );
   
    div div0(
        .rst(rst),.clk(clk),.div(div_start),.data1(div_data1),.data2(div_data2),.fin(div_end),.result(divres),.divinterrupt(flush)
    );
    
    ex ex0(
        .rst(rst),.aluop_i(ex_aluop_i),.alusel_i(ex_alusel_i),.ret_addr_i(ex_ret_addr_i),
        .reg1_i(ex_reg1_i),.reg2_i(ex_reg2_i),.wd_i(ex_wd_i),.wreg_i(ex_wreg_i),
        .wd_o(ex_wd_o),.wreg_o(ex_wreg_o),.wdata_o(ex_wdata_o),
        .hi_i(wb_hi_o),.lo_i(wb_lo_o),.inst_i(ex_inst_i),
        .mem_whio(mem_whio_o),.mem_hi_i(mem_hi_o),.mem_lo_i(mem_lo_o),
        .wb_whio(wb_whio_i),.wb_hi_i(wb_hi_i),.wb_lo_i(wb_lo_i),
        .whio(ex_whio_o),.hi_o(ex_hi_o),.lo_o(ex_lo_o),
        .mem_ce_o(ex_memce_o),.mem_op_o(ex_memop_o),.mem_addr_o(ex_memaddr_o),.mem_data_o(ex_memdata_o),
        .stall(ex_stall),.idstall(ex_idstall),
        .div_start(div_start),.div_end(div_end),.div_data1(div_data1),.div_data2(div_data2),.divres(divres),
        .cp0_data_i(ex_cp0_data_i),.cp0_raddr_o(ex_cp0_raddr_o),.cp0_rsel_o(ex_cp0_rsel_o),
        .cp0_we_o(ex_cp0_we_o),.cp0_waddr_o(ex_cp0_waddr_o),.cp0_wdata_o(ex_cp0_wdata_o),
        .mem_cp0_we(mem_cp0_we_o),.mem_cp0_addr(mem_cp0_waddr_o),.mem_cp0_data(mem_cp0_wdata_o),
        .wb_cp0_we(wb_cp0_we_i),.wb_cp0_addr(wb_cp0_waddr_i),.wb_cp0_data(wb_cp0_wdata_i),
        .excepttype_i(ex_excepttype_i),.excepttype_o(ex_excepttype_o),.pc_i(ex_pc_i),.pc_o(ex_pc_o),
        .instmiss_i(ex_instmiss_i),.instinvalid_i(ex_instinvalid_i),.instpermissionDenied_i(ex_instpermissionDenied_i),
        .instmiss_o(ex_instmiss_o),.instinvalid_o(ex_instinvalid_o),.instpermissionDenied_o(ex_instpermissionDenied_o),
        .is_in_delayslot_i(ex_is_in_delayslot_i),.is_in_delayslot_o(ex_is_in_delayslot_o),
        .flush_i(ex_pcreset_i),.flush_o(ex_pcreset_o),
        .int_i(ex_int_i),.int_o(ex_int_o)
    );
    
    ex_mem ex_mem0(
        .rst(rst),.clk(clk),
        .ex_wd(ex_wd_o),.ex_wreg(ex_wreg_o),.ex_wdata(ex_wdata_o),
        .ex_whio(ex_whio_o),.ex_hi(ex_hi_o),.ex_lo(ex_lo_o),
        .ex_memce(ex_memce_o),.ex_memop(ex_memop_o),.ex_memaddr(ex_memaddr_o),.ex_memdata(ex_memdata_o),
        .ex_cp0_we(ex_cp0_we_o),.ex_cp0_waddr(ex_cp0_waddr_o),.ex_cp0_wdata(ex_cp0_wdata_o),
        .mem_wd(mem_wd_i),.mem_wreg(mem_wreg_i),.mem_wdata(mem_wdata_i),
        .mem_whio(mem_whio_i),.mem_hi(mem_hi_i),.mem_lo(mem_lo_i),
        .mem_ce(mem_ce_i),.mem_op(mem_op_i),.mem_addr(mem_addr_i),.mem_data(mem_data_i),
        .mem_cp0_we(mem_cp0_we_i),.mem_cp0_waddr(mem_cp0_waddr_i),.mem_cp0_wdata(mem_cp0_wdata_i),
        .ex_pc(ex_pc_o),.mem_pc(mem_pc_i),.ex_excepttype(ex_excepttype_o),.mem_excepttype(mem_excepttype_i),
        .ex_instmiss(ex_instmiss_o),.ex_instinvalid(ex_instinvalid_o),.ex_instpermissionDenied(ex_instpermissionDenied_o),
        .mem_instmiss(mem_instmiss_i),.mem_instinvalid(mem_instinvalid_i),.mem_instpermissionDenied(mem_instpermissionDenied_i),
        .ex_is_in_delayslot(ex_is_in_delayslot_o),.mem_is_in_delayslot(mem_is_in_delayslot_i),
        .stall(stall),.flush(flush),.ex_flush(ex_pcreset_o),.mem_flush(mem_pcreset_i),
        .ex_int(ex_int_o),.mem_int(mem_int_i)
    );
        
    mem mem0(
        .rst(rst),
        .ram_ce_i(mem_ce_i),.ram_op_i(mem_op_i),.ram_addr_i(mem_addr_i),.ram_data_i(mem_data_i),.ld_data_i(ram_data_i),
        .wd_i(mem_wd_i),.wdata_i(mem_wdata_i),.wreg_i(mem_wreg_i),
        .whio_i(mem_whio_i),.hi_i(mem_hi_i),.lo_i(mem_lo_i),
        .wd_o(mem_wd_o),.wdata_o(mem_wdata_o),.wreg_o(mem_wreg_o),
        .whio_o(mem_whio_o),.hi_o(mem_hi_o),.lo_o(mem_lo_o),
        .virtAddr(virtAddr),.ram_data_o(ram_data_o),.ram_ce_o(ram_ce_o),.bad_mmu_addr(cp0_badaddr),
        .MasterRd(MasterRd),.MasterWr(MasterWr),.MasterByteEnable(MasterByteEnable),
        .cp0_we_i(mem_cp0_we_i),.cp0_waddr_i(mem_cp0_waddr_i),.cp0_wdata_i(mem_cp0_wdata_i),
        .cp0_we_o(mem_cp0_we_o),.cp0_waddr_o(mem_cp0_waddr_o),.cp0_wdata_o(mem_cp0_wdata_o),
        .excepttype_i(mem_excepttype_i),.pc_i(mem_pc_i),.is_in_delayslot_i(mem_is_in_delayslot_i),
        .wb_cp0_we(wb_cp0_we_i),.wb_cp0_waddr(wb_cp0_waddr_i),.wb_cp0_wdata(wb_cp0_wdata_i),
        .excepttype_o(mem_excepttype_o),.pc_o(mem_pc_o),.is_in_delayslot_o(mem_is_in_delayslot_o),
        .cp0_epc_o(mem_cp0_epc_o),.cp0_epc_i(cp0_epc),.cp0_cause_i(cp0_cause),.cp0_status_i(cp0_status),.cp0_random_i(cp0_random),
        .cp0_ebase_i(cp0_ebase),.cp0_ebase_o(mem_cp0_ebase_o),
        .userMode(userMode),.tlbwi(tlbwi),.refillMessage(refillMessage),
        .tlbmiss(mem_miss),.tlbinvalid(mem_invalid),.permissionDenied(mem_permissionDenied),
        .instmiss(mem_instmiss_i),.instinvalid(mem_instinvalid_i),.instpermissionDenied(mem_instpermissionDenied_i),
        .cp0_index_i(cp0_index),.cp0_entrylo0_i(cp0_entrylo0),.cp0_entrylo1_i(cp0_entrylo1),.cp0_entryhi_i(cp0_entryhi),
        .pcreset_i(mem_pcreset_i),.pcreset_o(mem_pcreset_o),
        .int_i(mem_int_i),.int_o(mem_int_o),
        .stall(mem_idstall)
    );
        
    mem_wb mem_wb0(
        .rst(rst),.clk(clk),
        .mem_wd(mem_wd_o),.mem_wreg(mem_wreg_o),.mem_wdata(mem_wdata_o),
        .mem_whio(mem_whio_o),.mem_hi(mem_hi_o),.mem_lo(mem_lo_o),
        .mem_cp0_we(mem_cp0_we_o),.mem_cp0_waddr(mem_cp0_waddr_o),.mem_cp0_wdata(mem_cp0_wdata_o),
        .wb_wd(wb_wd_i),.wb_wreg(wb_wreg_i),.wb_wdata(wb_wdata_i),
        .wb_whio(wb_whio_i),.wb_hi(wb_hi_i),.wb_lo(wb_lo_i),
        .wb_cp0_we(wb_cp0_we_i),.wb_cp0_waddr(wb_cp0_waddr_i),.wb_cp0_wdata(wb_cp0_wdata_i),
        .flush(flush),.stall(stall)
    );
    
    cp0_reg cp0_reg0(
        .rst(rst),.clk(clk),
        .raddr_i(ex_cp0_raddr_o),.rsel_i(ex_cp0_rsel_o),.badaddr_i(cp0_badaddr),
        .waddr_i(wb_cp0_waddr_i),.we_i(wb_cp0_we_i),.wdata_i(wb_cp0_wdata_i),
        .data_o(ex_cp0_data_i),
        .epc_o(cp0_epc),.ebase_o(cp0_ebase),.cause_o(cp0_cause),.status_o(cp0_status),.random_o(cp0_random),
        .index_o(cp0_index),.entrylo0_o(cp0_entrylo0),.entrylo1_o(cp0_entrylo1),.entryhi_o(cp0_entryhi),
        .excepttype_i(mem_excepttype_o),.pc_i(mem_pc_o),.is_in_delayslot_i(mem_is_in_delayslot_o),.pcreset_i(mem_pcreset_o),
        .int_i(mem_int_o), .timer_int_o(timer_int_o)
    );
    
    hilo_reg hilo_reg0(
        .rst(rst),.clk(clk),
        .we(wb_whio_i),.hi_i(wb_hi_i),.lo_i(wb_lo_i),
        .hi_o(wb_hi_o),.lo_o(wb_lo_o)
    );
    
    regfile regfile0(
        .rst(rst),.clk(clk),
        .we(wb_wreg_i),.wdata(wb_wdata_i),.waddr(wb_wd_i),
        .re1(reg1_read),.raddr1(reg1_addr),.rdata1(reg1_data),
        .re2(reg2_read),.raddr2(reg2_addr),.rdata2(reg2_data),
        .regcheck(regcheck),.regsum(regsum)
    );
    //  assign regcheck = id_pc_i;
    //  assign regsum = id_inst_i;
        
    assign debugger = {id_inst_i,MasterByteEnable[3:0], id_pc_i[27:0]};
endmodule
