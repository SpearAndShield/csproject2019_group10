`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/16 12:52:20
// Design Name: 
// Module Name: ex
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

module ex(rst,alusel_i,aluop_i,reg1_i,reg2_i,wd_i,wreg_i,hi_i,lo_i,inst_i,mem_whio,mem_hi_i,mem_lo_i,int_i,int_o,
          wb_whio,wb_hi_i,wb_lo_i,ret_addr_i,wd_o,wreg_o,wdata_o,whio,hi_o,lo_o,mem_op_o,mem_addr_o,flush_i,flush_o,
          mem_data_o,mem_ce_o,div_start,stall,idstall,div_end,div_data1,div_data2,divres,cp0_data_i,cp0_raddr_o,cp0_rsel_o,
          mem_cp0_we,mem_cp0_addr,mem_cp0_data,wb_cp0_we,wb_cp0_addr,wb_cp0_data,cp0_we_o,cp0_waddr_o,cp0_wdata_o,
          instmiss_i,instinvalid_i,instpermissionDenied_i,instmiss_o,instinvalid_o,instpermissionDenied_o,
          excepttype_i,excepttype_o,pc_i,pc_o,is_in_delayslot_i,is_in_delayslot_o);
    input wire rst,wreg_i,mem_whio,wb_whio,div_end,mem_cp0_we,wb_cp0_we,is_in_delayslot_i;
    input wire[2:0] alusel_i;
    input wire[4:0] wd_i,wb_cp0_addr,mem_cp0_addr;
    input wire[7:0] aluop_i;
    input wire[31:0] reg1_i,reg2_i,hi_i,lo_i,mem_hi_i,mem_lo_i,wb_hi_i,wb_lo_i,ret_addr_i,inst_i;
    input wire[31:0] cp0_data_i,mem_cp0_data,wb_cp0_data,excepttype_i,pc_i;
    input wire[63:0] divres;
    input wire instmiss_i,instinvalid_i,instpermissionDenied_i;
    output wire instmiss_o,instinvalid_o,instpermissionDenied_o;
    output reg wreg_o,whio,mem_ce_o,div_start,stall,cp0_we_o,cp0_rsel_o,idstall;
    output reg[4:0] wd_o,mem_op_o,cp0_waddr_o,cp0_raddr_o;
    output reg[31:0] wdata_o,hi_o,lo_o,mem_addr_o,mem_data_o,div_data1,div_data2;
    output reg[31:0] cp0_wdata_o;
    output wire[31:0] pc_o,excepttype_o;
    output wire is_in_delayslot_o;
    input wire flush_i;
    output wire flush_o;
    input wire[5:0] int_i;
    output wire[5:0] int_o;
    
    reg[31:0] logicout,shiftres,alures;
    reg overflow;

    assign int_o = int_i;
    assign flush_o = flush_i;
    assign pc_o = pc_i;
    assign is_in_delayslot_o = is_in_delayslot_i;
    assign instmiss_o = instmiss_i;
    assign instinvalid_o = instinvalid_i;
    assign instpermissionDenied_o = instpermissionDenied_i;
    
    assign excepttype_o = {excepttype_i[31:11], overflow, excepttype_i[9:0]};
   
    always @ (*) begin
        if (rst == 1'b1) begin
            logicout <= 32'h00000000;
        end else begin
            case (aluop_i)
                `EXE_OR_OP:
                begin
                    logicout <= reg1_i | reg2_i;
                end
                `EXE_AND_OP:
                begin
                    logicout <= reg1_i & reg2_i;
                end
                `EXE_XOR_OP:
                begin
                    logicout <= reg1_i ^ reg2_i;
                end
                `EXE_LUI_OP:
                begin
                    logicout <= {reg1_i[15:0], 16'h0};
                end
                `EXE_NOR_OP:
                begin
                    logicout <= ~(reg1_i | reg2_i);
                end
                default:
                begin
                    logicout <= 32'h00000000;
                end
            endcase
        end
    end
    
    always @ (*) begin
        if (rst == 1'b1) begin
            shiftres <= 32'h00000000;
        end else begin
            case(aluop_i)
                `EXE_SLL_OP:
                begin
                    shiftres <= reg2_i << reg1_i[4:0];
                end
                `EXE_SRL_OP:
                begin
                    shiftres <= reg2_i >> reg1_i[4:0];
                end
                `EXE_SRA_OP:
                begin
                    shiftres <= ({32{reg2_i[31]}} << (6'd32 - {1'b0, reg1_i[4:0]})) | (reg2_i >> reg1_i[4:0]);
                end
                default:
                begin
                    shiftres <= 32'h00000000;
                end
            endcase
        end
    end
    
    wire[31:0] func1,func2,sumres;
    wire compres;
    
    assign func2 = ((aluop_i == `EXE_SUBU_OP)||(aluop_i == `EXE_SLT_OP)) ? ~(reg2_i) + 1 : reg2_i;
    assign sumres = reg1_i + func2;
    assign compres = (aluop_i == `EXE_SLT_OP) ? ((reg1_i[31] && !reg2_i[31])||(reg1_i[31] && reg2_i[31] && sumres[31])||
                      (!reg1_i[31] && !reg2_i[31] && sumres[31])) : (reg1_i < reg2_i);
    
    always @ (*) begin
        if (rst == 1'b1) begin
            overflow <= 1'b0;
        end else begin
            overflow <= 1'b0;
            if (aluop_i == `EXE_ADD_OP) begin
                if ((reg1_i[31] && reg2_i[31] && !sumres[31]) || (!reg1_i[31] && !reg2_i[31] && sumres[31])) begin
                    overflow <= 1'b1;
                end
            end
        end
        
    end
    
    always @ (*) begin
        if (rst == 1'b1) begin
            alures <= 32'h00000000;
        end else begin
            case(aluop_i)
                `EXE_ADD_OP:
                    alures <= sumres;
                `EXE_ADDU_OP:
                    alures <= sumres;
                `EXE_SUBU_OP:
                    alures <= sumres;
                `EXE_SLT_OP:
                    alures <= compres;
                `EXE_SLTU_OP:
                    alures <= compres;
                default:
                    alures <= 32'h00000000;
            endcase
        end
    end
    
    reg[31:0] movres,HI,LO;
    
    always @ (*) begin
        if (rst == 1'b1) begin
            HI <= 32'h00000000;
            LO <= 32'h00000000;
        end else if (mem_whio == 1'b1) begin
            HI <= mem_hi_i;
            LO <= mem_lo_i;
        end else if (wb_whio == 1'b1) begin
            HI <= wb_hi_i;
            LO <= wb_lo_i;
        end else begin
            HI <= hi_i;
            LO <= lo_i;
        end
    end
    
    reg[31:0] cpres;
    
    always @ (*) begin
        if (rst == 1'b1) begin
            cp0_raddr_o <= 5'b00000;
            cp0_rsel_o <= 1'b0;
        end else begin
            cp0_rsel_o <= 1'b0;
            cp0_raddr_o <= 5'b00000;
            if (aluop_i == `EXE_MFC0_OP) begin
                cp0_raddr_o <= inst_i[15:11];
                cp0_rsel_o <= 1'b1;
            end
        end
    end
    
    always @ (*) begin
        if (rst == 1'b1) begin
            cpres <= 32'h00000000;
        end else if (mem_cp0_we == 1'b1 && mem_cp0_addr == inst_i[15:11]) begin
            cpres <= mem_cp0_data;
        end else if (wb_cp0_we == 1'b1 && wb_cp0_addr == inst_i[15:11]) begin
            cpres <= wb_cp0_data;
        end else begin
            cpres <= cp0_data_i;
        end
    end
    
    always @ (*) begin
        if (rst == 1'b1) begin
            movres <= 32'h00000000;
        end else begin
            case (aluop_i)
                `EXE_MFHI_OP:
                    movres <= HI;
                `EXE_MFLO_OP:
                    movres <= LO;
                `EXE_MFC0_OP:
                    movres <= cpres;
                default:
                    movres <= 32'h00000000;
            endcase
        end
    end
 
    always @ (*) begin
        if (rst == 1'b1) begin
            wd_o <= 5'b00000;
            wreg_o <= 1'b0;
            wdata_o <= 32'h00000000;
        end else begin
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            wdata_o <= 32'h00000000;
            case (alusel_i)
                `EXE_RES_LOGIC:
                begin
                    wdata_o <= logicout;
                end
                `EXE_RES_SHIFT:
                begin
                   wdata_o <= shiftres;
                end
                `EXE_RES_ARITHMETIC:
                begin
                    wdata_o <= alures;
                end
                `EXE_RES_MOVE:
                begin
                    wdata_o <= movres;
                end
                `EXE_RES_JB:
                begin
                    wdata_o <= ret_addr_i;
                end
                default:
                begin
                    wdata_o <= 32'h00000000;
                end
            endcase
        end
    end 
    
    wire[31:0] mul1,mul2;
    wire[63:0] tempres,mulres;
    
    assign mul1 = ((aluop_i == `EXE_MULT_OP)&&reg1_i[31]) ? ~(reg1_i)+1 : reg1_i;
    assign mul2 = ((aluop_i == `EXE_MULT_OP)&&reg2_i[31]) ? ~(reg2_i)+1 : reg2_i;
    assign tempres = mul1 * mul2;
    assign mulres = ((reg1_i[31]^reg2_i[31])) ? ~(tempres)+1 : tempres ;
    
    always @ (*) begin
        if (rst == 1'b1) begin
            whio <= 1'b0;
            hi_o <= 32'h00000000;
            lo_o <= 32'h00000000;
        end else if (aluop_i == `EXE_MTHI_OP) begin
            whio <= 1'b1;
            hi_o <= reg1_i;
            lo_o <= LO;
        end else if (aluop_i == `EXE_MTLO_OP) begin
            whio <= 1'b1;
            hi_o <= HI;
            lo_o <= reg1_i;
        end else if (aluop_i == `EXE_MULT_OP) begin
            whio <= 1'b1;
            hi_o <= mulres[63:32];
            lo_o <= mulres[31:0];
        end else if (aluop_i == `EXE_DIVU_OP) begin
            whio <= 1'b1;
            hi_o <= divres[63:32];
            lo_o <= divres[31:0];
        end else begin
            whio <= 1'b1;
            hi_o <= HI;
            lo_o <= LO;
        end
    end
    
    always @ (*) begin
        if (rst == 1'b1) begin
            cp0_we_o <= 1'b0;
            cp0_waddr_o <=5'b00000;
            cp0_wdata_o <= 32'h00000000;
        end else if (aluop_i == `EXE_MTC0_OP) begin
            cp0_we_o <= 1'b1;
            cp0_waddr_o <= inst_i[15:11];
            cp0_wdata_o <= reg1_i;
        end else begin
            cp0_we_o <= 1'b0;
            cp0_waddr_o <= 5'b00000;
            cp0_wdata_o <= 32'h00000000;
        end
    end
    
    reg[31:0] temp_addr;
    reg[3:0] ws;
    
    always @ (*) begin
        if (rst == 1'b1) begin
            idstall <= 1'b0;
            mem_ce_o <= 1'b0;
            mem_op_o <= 5'b00000;
            mem_addr_o <= 32'h00000000;
            mem_data_o <= 32'h00000000;
            temp_addr <= 32'h00000000;
        end else if(alusel_i == `EXE_RES_LS) begin
            idstall <= 1'b0;
            mem_ce_o <= 1'b0;
            mem_op_o <= 5'b00000;
            mem_addr_o <= 32'h00000000;
            mem_data_o <= 32'h00000000;
            temp_addr <= {{16{inst_i[15]}}, inst_i[15:0]};
            case (aluop_i)
                `EXE_LB_OP:
                begin
                    idstall <= 1'b1;
                    mem_ce_o <= 1'b1;
                    mem_op_o <= `MEM_LB;
                    mem_addr_o <= reg1_i + temp_addr;
                end
                `EXE_LBU_OP:
                begin
                    idstall <= 1'b1;
                    mem_ce_o <= 1'b1;
                    mem_op_o <= `MEM_LBU;
                    mem_addr_o <= reg1_i + temp_addr;
                end
                `EXE_LW_OP:
                begin
                    idstall <= 1'b1;
                    mem_ce_o <= 1'b1;
                    mem_op_o <= `MEM_LW;
                    mem_addr_o <= reg1_i + temp_addr;
                end
                `EXE_SB_OP:
                begin
                    idstall <= 1'b1;
                    mem_ce_o <= 1'b1;
                    mem_op_o <= `MEM_SB;
                    mem_addr_o <= reg1_i + temp_addr;
                    mem_data_o <= reg2_i;
                end
                `EXE_SW_OP:
                begin
                    idstall <= 1'b1;
                    mem_ce_o <= 1'b1;
                    mem_op_o <= `MEM_SW;
                    mem_addr_o <= reg1_i + temp_addr;
                    mem_data_o <= reg2_i;
                end
                `EXE_TLBWI_OP:
                begin
                    idstall <= 1'b1;
                    mem_ce_o <= 1'b1;
                    mem_op_o <= `MEM_TLBWI;
                end
                `EXE_TLBWR_OP:
                begin
                    idstall <= 1'b1;
                    mem_ce_o <= 1'b1;
                    mem_op_o <= `MEM_TLBWR;
                end
                default:
                begin
                end
            endcase
        end else begin
            idstall <= 1'b0;
            mem_ce_o <= 1'b0;
            mem_op_o <= 5'b00000;
            mem_addr_o <= 32'h00000000;
            mem_data_o <= 32'h00000000;
            temp_addr <= 32'h00000000;
        end
    end
    
    always @ (*) begin
        div_start <= 1'b0;
        stall <= 1'b0;
        div_data1 <= 32'h00000000;
        div_data2 <= 32'h00000000;
        if (aluop_i == `EXE_DIVU_OP) begin
            div_start <= 1'b1;
            if (div_end == 1'b0) begin
                stall <= 1'b1;
                div_data1 <= reg1_i;
                div_data2 <= reg2_i;
            end else begin
                stall <= 1'b0;
                div_data1 <= 32'h00000000;
                div_data2 <= 32'h00000000;
            end
        end
    end
      
endmodule
