`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/16 00:08:07
// Design Name: 
// Module Name: id
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

module id(clk,rst,pc_i,inst_i,reg1_data_i,reg2_data_i,ex_wdata_i,ex_wd_i,
          ex_wreg_i,mem_wdata_i,mem_wd_i,mem_wreg_i,reg1_re_o,int_i,int_o,
          reg2_re_o,reg1_addr_o,reg2_addr_o,alu_op_o,alu_sel_o,
          reg1_o,reg2_o,wd_o,wreg_o,jr_o,jr_addr,ret_addr,inst_o,
          next_in_delayslot,is_in_delayslot_o,is_in_delayslot_i,
          instmiss_i,instinvalid_i,instpermissionDenied_i,
          instmiss_o,instinvalid_o,instpermissionDenied_o,
          excepttype_o,pc_o,flush_i,flush_o);
    input wire clk,rst,ex_wreg_i,mem_wreg_i,is_in_delayslot_i;
    input wire[4:0] ex_wd_i,mem_wd_i;
    input wire[31:0] pc_i,inst_i,reg1_data_i,reg2_data_i,ex_wdata_i,mem_wdata_i;
    input wire instmiss_i,instinvalid_i,instpermissionDenied_i;
    output wire instmiss_o,instinvalid_o,instpermissionDenied_o;
    output reg reg1_re_o,reg2_re_o,wreg_o,jr_o,is_in_delayslot_o,next_in_delayslot;
    output reg[4:0] reg1_addr_o,reg2_addr_o,wd_o;
    output reg[31:0] reg1_o,reg2_o,jr_addr,ret_addr,inst_o,pc_o;
    output reg[7:0] alu_op_o;
    output reg[2:0] alu_sel_o;
    output wire[31:0] excepttype_o;
    input wire flush_i;
    output wire flush_o;
    input wire[5:0] int_i;
    output wire[5:0] int_o;
    
    wire[5:0] op = inst_i[31:26];
    wire[4:0] op2 = inst_i[10:6];
    wire[5:0] op3 = inst_i[5:0];
    wire[4:0] op4 = inst_i[20:16];
        
    reg[31:0] imm;
    
    reg instinvalid,issyscall,iseret,isbreak;
    wire[31:0] pc_4,offset;
    assign flush_o = flush_i;
    assign pc_4 = pc_i + 4;
    assign offset = {{14{inst_i[15]}}, inst_i[15:0], 2'b00};
    assign excepttype_o = {19'b0, iseret, isbreak, 1'b0, instinvalid, issyscall, 8'b0};
    assign instmiss_o = instmiss_i;
    assign instinvalid_o = instinvalid_i;
    assign instpermissionDenied_o = instpermissionDenied_i;
    assign int_o = int_i;
   
    always @ (*) begin
        if (rst == 1'b1) begin
            alu_op_o <= 8'b00000000;
            alu_sel_o <= 3'b000;
            wd_o <= 5'b00000;
            wreg_o <= 1'b0;
            reg1_re_o <= 1'b0;
            reg2_re_o <= 1'b0;
            reg1_addr_o <= 5'b00000;
            reg2_addr_o <= 5'b00000;
            imm <= 32'h0;
            jr_o <= 1'b0;
            jr_addr <= 32'h00000000;
            ret_addr <= 32'h00000000;
            inst_o <= 32'h00000000;
            next_in_delayslot <= 1'b0;
            is_in_delayslot_o <= 1'b0;
            pc_o <= 32'h00000000;
            instinvalid <= 1'b0;
            isbreak <= 1'b0;
            issyscall <= 1'b0;
            iseret <= 1'b0;
        end else begin
            alu_op_o <= 8'b00000000;
            alu_sel_o <= 3'b000;
            wd_o <= inst_i[15:11];
            wreg_o <= 1'b0;
            reg1_re_o <= 1'b0;
            reg2_re_o <= 1'b0;
            reg1_addr_o <= inst_i[25:21];
            reg2_addr_o <= inst_i[20:16];
            inst_o <= inst_i;
            imm <= 32'h00000000;
            jr_o <= 1'b0;
            jr_addr <= 32'h00000000;
            ret_addr <= 32'h00000000;
            next_in_delayslot <= 1'b0;
            is_in_delayslot_o <= is_in_delayslot_i;
            pc_o <= pc_i;
            instinvalid <= 1'b1;
            issyscall <= 1'b0;
            iseret <= 1'b0;
            isbreak <= 1'b0;
            case (op)
                `EXE_ORI:
                begin
                    instinvalid <= 1'b0;
                    wreg_o <= 1'b1;
                    alu_op_o <= `EXE_OR_OP;
                    alu_sel_o <= `EXE_RES_LOGIC;
                    reg1_re_o <= 1'b1;
                    reg2_re_o <= 1'b0;
                    imm <= {16'h0, inst_i[15:0]};
                    wd_o <= inst_i[20:16];
                end
                `EXE_ANDI:
                begin
                    instinvalid <= 1'b0;
                    wreg_o <= 1'b1;
                    alu_op_o <= `EXE_AND_OP;
                    alu_sel_o <= `EXE_RES_LOGIC;
                    reg1_re_o <= 1'b1;
                    reg2_re_o <= 1'b0;
                    imm <= {16'h0, inst_i[15:0]};
                    wd_o <= inst_i[20:16];
                end
                `EXE_XORI:
                begin
                    instinvalid <= 1'b0;
                    wreg_o <= 1'b1;
                    alu_op_o <= `EXE_XOR_OP;
                    alu_sel_o <= `EXE_RES_LOGIC;
                    reg1_re_o <= 1'b1;
                    reg2_re_o <= 1'b0;
                    imm <= {16'h0, inst_i[15:0]};
                    wd_o <= inst_i[20:16];
                end
                `EXE_LUI:
                begin
                    if (inst_i[25:21] == 5'b00000) begin
                        instinvalid <= 1'b0;
                        wreg_o <= 1'b1;
                        alu_op_o <= `EXE_LUI_OP;
                        alu_sel_o <= `EXE_RES_LOGIC;
                        reg1_re_o <= 1'b0;
                        reg2_re_o <= 1'b0;
                        imm <= {16'h0, inst_i[15:0]};
                        wd_o <= inst_i[20:16];
                    end
                end
                `EXE_ADDI:
                begin
                    instinvalid <= 1'b0;
                    wreg_o <= 1'b1;
                    alu_op_o <= `EXE_ADD_OP;
                    alu_sel_o <= `EXE_RES_ARITHMETIC;
                    reg1_re_o <= 1'b1;
                    reg2_re_o <= 1'b0;
                    wd_o <= inst_i[20:16];
                    imm <= {{16{inst_i[15]}}, inst_i[15:0]};
                end
                `EXE_ADDIU:
                begin
                    instinvalid <= 1'b0;
                    wreg_o <= 1'b1;
                    alu_op_o <= `EXE_ADDU_OP;
                    alu_sel_o <= `EXE_RES_ARITHMETIC;
                    reg1_re_o <= 1'b1;
                    reg2_re_o <= 1'b0;
                    imm <= {{16{inst_i[15]}}, inst_i[15:0]};
                    wd_o <= inst_i[20:16];
                end
                `EXE_SLTI:
                begin
                    instinvalid <= 1'b0;
                    wreg_o <= 1'b1;
                    alu_op_o <= `EXE_SLT_OP;
                    alu_sel_o <= `EXE_RES_ARITHMETIC;
                    reg1_re_o <= 1'b1;
                    reg2_re_o <= 1'b0;
                    imm <= {{16{inst_i[15]}}, inst_i[15:0]};
                    wd_o <= inst_i[20:16];
                end
                `EXE_SLTIU:
                begin
                    instinvalid <= 1'b0;
                    wreg_o <= 1'b1;
                    alu_op_o <= `EXE_SLTU_OP;
                    alu_sel_o <= `EXE_RES_ARITHMETIC;
                    reg1_re_o <= 1'b1;
                    reg2_re_o <= 1'b0;
                    imm <= {{16{inst_i[15]}}, inst_i[15:0]};
                    wd_o <= inst_i[20:16];
                end
                `EXE_BEQ:
                begin
                    instinvalid <= 1'b0;
                    wreg_o <= 1'b0;
                    alu_op_o <= `EXE_BEQ_OP;
                    alu_sel_o <= `EXE_RES_JB;
                    reg1_re_o <= 1'b1;
                    reg2_re_o <= 1'b1;
                    if (reg1_o == reg2_o) begin
                        jr_o <= 1'b1;
                        jr_addr <= pc_i + 4'h4 + offset;
                    end
                    next_in_delayslot <= 1'b1;
                end
                `EXE_BGTZ:
                begin
                    if (op4 == 5'b00000) begin
                        instinvalid <= 1'b0;
                        wreg_o <= 1'b0;
                        alu_op_o <= `EXE_BGTZ_OP;
                        alu_sel_o <= `EXE_RES_JB;
                        reg1_re_o <= 1'b1;
                        reg2_re_o <= 1'b0;
                        if (!reg1_o[31] && reg1_o != 32'h00000000) begin
                            jr_o <= 1'b1;
                            jr_addr <= pc_i + 4'h4 + offset;
                        end
                        next_in_delayslot <= 1'b1;
                    end
                end
                `EXE_BLEZ:
                begin
                    if (op4 == 5'b00000) begin
                        instinvalid <= 1'b0;
                        wreg_o <= 1'b0;
                        alu_op_o <= `EXE_BLEZ_OP;
                        alu_sel_o <= `EXE_RES_JB;
                        reg1_re_o <= 1'b1;
                        reg2_re_o <= 1'b0;
                        if (reg1_o[31] || reg1_o == 32'h00000000) begin
                            jr_o <= 1'b1;
                            jr_addr <= pc_i + 4'h4 + offset;
                        end
                        next_in_delayslot <= 1'b1;
                    end
                end
                `EXE_BNE:
                begin
                    instinvalid <= 1'b0;
                    wreg_o <= 1'b0;
                    alu_op_o <= `EXE_BNE_OP;
                    alu_sel_o <= `EXE_RES_JB;
                    reg1_re_o <= 1'b1;
                    reg2_re_o <= 1'b1;
                    if (reg1_o != reg2_o) begin
                        jr_o <= 1'b1;
                        jr_addr <= pc_i + 4'h4 + offset;
                    end
                    next_in_delayslot <= 1'b1;
                end
                `EXE_J:
                begin
                    instinvalid <= 1'b0;
                    wreg_o <= 1'b0;
                    alu_op_o <= `EXE_J_OP;
                    alu_sel_o <= `EXE_RES_JB;
                    reg1_re_o <= 1'b0;
                    reg2_re_o <= 1'b0;
                    jr_o <= 1'b1;
                    jr_addr <= {pc_4[31:28], inst_i[25:0], 2'b00};
                    next_in_delayslot <= 1'b1;
                end
                `EXE_JAL:
                begin
                    instinvalid <= 1'b0;
                    wreg_o <= 1'b1;
                    wd_o <= 5'b11111;
                    ret_addr <= pc_i + 4'h8;
                    alu_op_o <= `EXE_JAL_OP;
                    alu_sel_o <= `EXE_RES_JB;
                    reg1_re_o <= 1'b0;
                    reg2_re_o <= 1'b0;
                    jr_o <= 1'b1;
                    jr_addr <= {pc_4[31:28], inst_i[25:0], 2'b00};
                    next_in_delayslot <= 1'b1;
                end
                `EXE_LB:
                begin
                    instinvalid <= 1'b0;
                    wreg_o <= 1'b1;
                    wd_o <= inst_i[20:16];
                    reg1_re_o <= 1'b1;
                    reg2_re_o <= 1'b0;
                    alu_op_o <= `EXE_LB_OP;
                    alu_sel_o <= `EXE_RES_LS;
                end
                `EXE_LBU:
                begin
                    instinvalid <= 1'b0;
                    wreg_o <= 1'b1;
                    wd_o <= inst_i[20:16];
                    reg1_re_o <= 1'b1;
                    reg2_re_o <= 1'b0;
                    alu_op_o <= `EXE_LBU_OP;
                    alu_sel_o <= `EXE_RES_LS;
                end
                `EXE_LW:
                begin
                    instinvalid <= 1'b0;
                    wreg_o <= 1'b1;
                    wd_o <= inst_i[20:16];
                    reg1_re_o <= 1'b1;
                    reg2_re_o <= 1'b0;
                    alu_op_o <= `EXE_LW_OP;
                    alu_sel_o <= `EXE_RES_LS;
                end
                `EXE_SB:
                begin
                    instinvalid <= 1'b0;
                    wreg_o <= 1'b0;
                    reg1_re_o <= 1'b1;
                    reg2_re_o <= 1'b1;
                    alu_op_o <= `EXE_SB_OP;
                    alu_sel_o <= `EXE_RES_LS;
                end
                `EXE_SW:
                begin
                    instinvalid <= 1'b0;
                    wreg_o <= 1'b0;
                    reg1_re_o <= 1'b1;
                    reg2_re_o <= 1'b1;
                    alu_op_o <= `EXE_SW_OP;
                    alu_sel_o <= `EXE_RES_LS;
                end
                `EXE_CP0_INST:
                begin
                    if (inst_i[10:3] == 8'b00000000000 && (inst_i[2:0] == 3'b000 || inst_i[2:0] == 3'b001)) begin
                        if (inst_i[25:21] == 5'b00000) begin
                            instinvalid <= 1'b0;
                            alu_op_o <= `EXE_MFC0_OP;
                            alu_sel_o <= `EXE_RES_MOVE;
                            wreg_o <= 1'b1;
                            wd_o <= inst_i[20:16];
                            reg1_re_o <= 1'b0;
                            reg2_re_o <= 1'b0;
                        end else if (inst_i[25:21] == 5'b00100) begin
                            if ((inst_i[2:0] == 3'b000 && inst_i[15:11] != 5'b01111)|| (inst_i[2:0] == 3'b001 && inst_i[15:11] == 5'b01111)) begin
                                instinvalid <= 1'b0;
                                alu_op_o <= `EXE_MTC0_OP;
                                alu_sel_o <= `EXE_RES_MOVE;
                                wreg_o <= 1'b0;
                                reg1_re_o <= 1'b1;
                                reg2_re_o <= 1'b0;
                                reg1_addr_o <= inst_i[20:16];
                            end
                        end
                    end else if (inst_i[25:24] == 2'b10 && inst_i[23:0] == 6'h000002) begin
                        instinvalid <= 1'b0;
                        alu_op_o <= `EXE_TLBWI_OP;
                        alu_sel_o <= `EXE_RES_LS;
                        wreg_o <= 1'b0;
                        reg1_re_o <= 1'b0;
                        reg2_re_o <= 1'b0;
                    end else if (inst_i[25:24] == 2'b10 && inst_i[23:0] == 6'h000006) begin
                        instinvalid <= 1'b0;
                        alu_op_o <= `EXE_TLBWR_OP;
                        alu_sel_o <= `EXE_RES_LS;
                        wreg_o <= 1'b0;
                        reg1_re_o <= 1'b0;
                        reg2_re_o <= 1'b0;
                    end else if (op3 == `EXE_ERET) begin
                        if (inst_i[25:6] == 20'h80000) begin
                            instinvalid <= 1'b0;
                            alu_op_o <= `EXE_ERET_OP;
                            iseret <= 1'b1;
                            wreg_o <= 1'b0;
                            reg1_re_o <= 1'b0;
                            reg2_re_o <= 1'b0;
                        end
                    end
                end
                `EXE_REGIMM_INST:
                begin
                    if (op4 == 5'b00001) begin
                        instinvalid <= 1'b0;
                        wreg_o <= 1'b0;
                        alu_op_o <= `EXE_BGEZ_OP;
                        alu_sel_o <= `EXE_RES_JB;
                        reg1_re_o <= 1'b1;
                        reg2_re_o <= 1'b0;
                        if (!reg1_o[31] || reg1_o == 32'h00000000) begin
                            jr_o <= 1'b1;
                            jr_addr <= pc_i + 4'h4 + offset;
                        end
                        next_in_delayslot <= 1'b1;
                    end else if (op4 == 5'b00000)begin
                        instinvalid <= 1'b0;
                        wreg_o <= 1'b0;
                        alu_op_o <= `EXE_BLTZ_OP;
                        alu_sel_o <= `EXE_RES_JB;
                        reg1_re_o <= 1'b1;
                        reg2_re_o <= 1'b0;
                        if (reg1_o[31]) begin
                            jr_o <= 1'b1;
                            jr_addr <= pc_i + 4'h4 + offset;
                        end
                        next_in_delayslot <= 1'b1;
                    end
                end
                `EXE_SPECIAL_INST:
                begin
                    case (op3)
                        `EXE_AND:
                        begin
                            if (op2 == 5'b00000) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_AND_OP;
                                alu_sel_o <= `EXE_RES_LOGIC;
                                reg1_re_o <= 1'b1;
                                reg2_re_o <= 1'b1;
                            end
                        end
                        `EXE_OR:
                        begin
                            if (op2 == 5'b00000) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_OR_OP;
                                alu_sel_o <= `EXE_RES_LOGIC;
                                reg1_re_o <= 1'b1;
                                reg2_re_o <= 1'b1;
                            end
                        end
                        `EXE_XOR:
                        begin
                            if (op2 == 5'b00000) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_XOR_OP;
                                alu_sel_o <= `EXE_RES_LOGIC;
                                reg1_re_o <= 1'b1;
                                reg2_re_o <= 1'b1;
                            end
                        end
                        `EXE_NOR:
                        begin
                            if (op2 == 5'b00000) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_NOR_OP;
                                alu_sel_o <= `EXE_RES_LOGIC;
                                reg1_re_o <= 1'b1;
                                reg2_re_o <= 1'b1;
                            end
                        end
                        `EXE_SLL:
                        begin
                            if (inst_i[25:21] == 5'b00000) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_SLL_OP;
                                alu_sel_o <= `EXE_RES_SHIFT;
                                reg2_re_o <= 1'b1;
                                reg1_re_o <= 1'b0;
                                imm[4:0] <= inst_i[10:6];
                            end
                        end
                        `EXE_SLLV:
                        begin
                            if (op2 == 5'b00000) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_SLL_OP;
                                alu_sel_o <= `EXE_RES_SHIFT;
                                reg2_re_o <= 1'b1;
                                reg1_re_o <= 1'b1;
                            end
                        end
                        `EXE_SRL:
                        begin
                            if (inst_i[25:21] == 5'b00000) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_SRL_OP;
                                alu_sel_o <= `EXE_RES_SHIFT;
                                reg2_re_o <= 1'b1;
                                reg1_re_o <= 1'b0;
                                imm[4:0] <= inst_i[10:6];
                            end
                        end
                        `EXE_SRLV:
                        begin
                            if (op2 == 5'b00000) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_SRL_OP;
                                alu_sel_o <= `EXE_RES_SHIFT;
                                reg2_re_o <= 1'b1;
                                reg1_re_o <= 1'b1;
                            end
                        end
                        `EXE_SRA:
                        begin
                            if (inst_i[25:21] == 5'b00000) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_SRA_OP;
                                alu_sel_o <= `EXE_RES_SHIFT;
                                reg2_re_o <= 1'b1;
                                reg1_re_o <= 1'b0;
                                imm[4:0] <= inst_i[10:6];
                            end
                        end
                        `EXE_SRAV:
                        begin
                            if (op2 == 5'b00000) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_SRA_OP;
                                alu_sel_o <= `EXE_RES_SHIFT;
                                reg2_re_o <= 1'b1;
                                reg1_re_o <= 1'b1;
                            end
                        end
                        `EXE_ADD:
                        begin
                            if (op2 == 5'b00000) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_ADD_OP;
                                alu_sel_o <= `EXE_RES_ARITHMETIC;
                                reg2_re_o <= 1'b1;
                                reg1_re_o <= 1'b1;
                            end
                        end
                        `EXE_ADDU:
                        begin
                            if (op2 == 5'b00000) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_ADDU_OP;
                                alu_sel_o <= `EXE_RES_ARITHMETIC;
                                reg2_re_o <= 1'b1;
                                reg1_re_o <= 1'b1;
                            end
                        end
                        `EXE_SLT:
                        begin
                            if (op2 == 5'b00000) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_SLT_OP;
                                alu_sel_o <= `EXE_RES_ARITHMETIC;
                                reg2_re_o <= 1'b1;
                                reg1_re_o <= 1'b1;
                            end
                        end
                        `EXE_SLTU:
                        begin
                            if (op2 == 5'b00000) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_SLTU_OP;
                                alu_sel_o <= `EXE_RES_ARITHMETIC;
                                reg2_re_o <= 1'b1;
                                reg1_re_o <= 1'b1;
                            end
                        end
                        `EXE_SUBU:
                        begin
                            if (op2 == 5'b00000) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_SUBU_OP;
                                alu_sel_o <= `EXE_RES_ARITHMETIC;
                                reg2_re_o <= 1'b1;
                                reg1_re_o <= 1'b1;
                            end
                        end
                        `EXE_MFHI:
                        begin
                            if ((op2 == 5'b00000)&&(inst_i[25:16] == 10'b0000000000)) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_MFHI_OP;
                                alu_sel_o <= `EXE_RES_MOVE;
                                reg1_re_o <= 1'b0;
                                reg2_re_o <= 1'b0;
                            end
                        end
                        `EXE_MFLO:
                        begin
                            if ((op2 == 5'b00000)&&(inst_i[25:16] == 10'b0000000000)) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_MFLO_OP;
                                alu_sel_o <= `EXE_RES_MOVE;
                                reg1_re_o <= 1'b0;
                                reg2_re_o <= 1'b0;
                            end
                        end
                        `EXE_MTHI:
                        begin
                            if ((op4 == 5'b00000)&&(inst_i[15:6] == 10'b0000000000)) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b0;
                                alu_op_o <= `EXE_MTHI_OP;
                                alu_sel_o <= `EXE_RES_MOVE;
                                reg1_re_o <= 1'b1;
                                reg2_re_o <= 1'b0;
                            end
                        end
                        `EXE_MTLO:
                        begin
                            if ((op4 == 5'b00000)&&(inst_i[15:6] == 10'b0000000000)) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b0;
                                alu_op_o <= `EXE_MTLO_OP;
                                alu_sel_o <= `EXE_RES_MOVE;
                                reg1_re_o <= 1'b1;
                                reg2_re_o <= 1'b0;
                            end
                        end
                        `EXE_MULT:
                        begin
                            if (inst_i[15:6] == 10'b0000000000) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b0;
                                alu_op_o <= `EXE_MULT_OP;
                                alu_sel_o <= `EXE_RES_MUL;
                                reg1_re_o <= 1'b1;
                                reg2_re_o <= 1'b1;
                            end
                        end
                        `EXE_JALR:
                        begin
                            if (op4 == 5'b00000&&op2 == 5'b00000)begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b1;
                                alu_op_o <= `EXE_JALR_OP;
                                alu_sel_o <= `EXE_RES_JB;
                                reg1_re_o <= 1'b1;
                                reg2_re_o <= 1'b0;
                                ret_addr <= pc_i + 4'h8;
                                jr_o <= 1'b1;
                                jr_addr <= reg1_o;
                                next_in_delayslot <= 1'b1;
                            end
                        end
                        `EXE_JR:
                        begin
                            if (inst_i[20:6] == 15'b000000000000000) begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b0;
                                alu_op_o <= `EXE_JR_OP;
                                alu_sel_o <= `EXE_RES_JB;
                                reg1_re_o <= 1'b1;
                                reg2_re_o <= 1'b0;
                                jr_o <= 1'b1;
                                jr_addr <= reg1_o;
                                next_in_delayslot <= 1'b1;
                            end
                        end
                        `EXE_DIVU:
                        begin
                            if (inst_i[15:6] == 10'b0000000000)begin
                                instinvalid <= 1'b0;
                                wreg_o <= 1'b0;
                                alu_op_o <= `EXE_DIVU_OP;
                                reg1_re_o <= 1'b1;
                                reg2_re_o <= 1'b1;
                            end
                        end
                        `EXE_SYSCALL:
                        begin
                            instinvalid <= 1'b0;
                            wreg_o <= 1'b0;
                            issyscall <= 1'b1;
                            reg1_re_o <= 1'b0;
                            reg2_re_o <= 1'b0;
                            alu_op_o <= `EXE_SYSCALL_OP;
                        end
                        `EXE_BREAK:
                        begin
                            instinvalid <= 1'b0;
                            wreg_o <= 1'b0;
                            isbreak <= 1'b1;
                            reg1_re_o <= 1'b0;
                            reg2_re_o <= 1'b0;
                            alu_op_o <= `EXE_BREAK_OP;
                        end
                        default:
                        begin
                        end
                    endcase
                end
                default:
                begin
                end
            endcase
        end
    end
    
    always @ (*) begin
        if (rst == 1'b1) begin
            reg1_o <= 32'h00000000;
        end else if ((reg1_re_o == 1'b1)&&(reg1_addr_o == ex_wd_i)&&(ex_wreg_i == 1'b1)) begin
            reg1_o <= ex_wdata_i;
        end else if ((reg1_re_o == 1'b1)&&(reg1_addr_o == mem_wd_i)&&(mem_wreg_i == 1'b1)) begin
            reg1_o <= mem_wdata_i;
        end else if (reg1_re_o == 1'b1) begin
            reg1_o <= reg1_data_i;
        end else if (reg1_re_o == 1'b0) begin
            reg1_o <= imm;
        end else begin
            reg1_o <= 32'h00000000;
        end
    end
    
    always @ (*) begin
        if (rst == 1'b1) begin
            reg2_o <= 32'h00000000;
        end else if ((reg2_re_o == 1'b1)&&(reg2_addr_o == ex_wd_i)&&(ex_wreg_i == 1'b1))begin
            reg2_o <= ex_wdata_i;
        end else if ((reg2_re_o == 1'b1)&&(reg2_addr_o == mem_wd_i)&&(mem_wreg_i == 1'b1))begin
            reg2_o <= mem_wdata_i;
        end else if (reg2_re_o == 1'b1) begin
            reg2_o <= reg2_data_i;
        end else if (reg2_re_o == 1'b0) begin
            reg2_o <= imm;
        end else begin
            reg2_o <= 32'h00000000;
        end
    end
endmodule