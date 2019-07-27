`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/16 14:11:19
// Design Name: 
// Module Name: mem
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

module mem(rst,wd_i,wreg_i,wdata_i,ram_op_i,ram_ce_i,ram_addr_i,ram_data_i,ld_data_i,stall,MasterRd,MasterWr,
           tlbmiss,tlbinvalid,permissionDenied,instmiss,instinvalid,instpermissionDenied,pcreset_i,pcreset_o,
           wd_o,wreg_o,wdata_o,whio_i,hi_i,lo_i,whio_o,hi_o,lo_o,ram_data_o,virtAddr,MasterByteEnable,ram_ce_o,
           cp0_we_i,cp0_waddr_i,cp0_wdata_i,cp0_we_o,cp0_waddr_o,cp0_wdata_o,excepttype_i,pc_i,is_in_delayslot_i,
           excepttype_o,pc_o,is_in_delayslot_o,cp0_epc_i,wb_cp0_we,wb_cp0_waddr,wb_cp0_wdata,cp0_ebase_o,cp0_random_i,int_i,int_o,
           cp0_epc_o,bad_mmu_addr,userMode,tlbwi,refillMessage,cp0_index_i,cp0_entrylo0_i,cp0_entrylo1_i,cp0_entryhi_i,cp0_ebase_i,cp0_cause_i,cp0_status_i);
    input wire rst,wreg_i,whio_i,ram_ce_i,cp0_we_i,is_in_delayslot_i,wb_cp0_we,pcreset_i;
    input wire instinvalid,instmiss,instpermissionDenied,tlbmiss,tlbinvalid,permissionDenied;
    input wire[4:0] wd_i,ram_op_i,cp0_waddr_i,wb_cp0_waddr;
    input wire[31:0] wdata_i,hi_i,lo_i,ram_addr_i,ram_data_i,ld_data_i,cp0_wdata_i,pc_i,excepttype_i;
    input wire[31:0] cp0_epc_i,wb_cp0_wdata,cp0_index_i,cp0_entrylo0_i,cp0_entrylo1_i,cp0_entryhi_i,cp0_ebase_i,cp0_cause_i,cp0_status_i,cp0_random_i;
    output reg wreg_o,whio_o,cp0_we_o,MasterRd,MasterWr,ram_ce_o,stall;
    output reg[3:0] MasterByteEnable;
    output reg[4:0] wd_o,cp0_waddr_o,excepttype_o;
    output reg[31:0] wdata_o,hi_o,lo_o,ram_data_o,cp0_wdata_o,virtAddr,bad_mmu_addr;
    output wire[31:0] pc_o,cp0_epc_o,cp0_ebase_o;
    output wire is_in_delayslot_o,pcreset_o;
    output reg userMode,tlbwi;
    output reg[66:0] refillMessage;
    input wire[5:0] int_i;
    output wire[5:0] int_o;
    
    reg interrupt;

    assign int_o = int_i;
    assign pcreset_o = pcreset_i;
    assign is_in_delayslot_o = is_in_delayslot_i;
    assign pc_o = pc_i;
    
    reg[31:0] cp0_status,cp0_cause,cp0_epc,cp0_index,cp0_entrylo0,cp0_entrylo1,cp0_entryhi,cp0_ebase,cp0_random;
    
    always @ (*) begin
        if (rst == 1'b1) begin
            cp0_random <= 32'h00000000;
        end else if (wb_cp0_we == 1'b1 && wb_cp0_waddr == 5'b00001) begin
            cp0_random <= wb_cp0_wdata;
        end else begin
            cp0_random <= cp0_random_i;
        end
    end

    
    always @ (*) begin
        if (rst == 1'b1) begin
            cp0_cause <= 32'h00000000;
        end else if (wb_cp0_we == 1'b1 && wb_cp0_waddr == 5'b01101) begin
            cp0_cause <= wb_cp0_wdata;
        end else begin
            cp0_cause <= {cp0_cause_i[31:16], int_i, cp0_cause_i[9:0]};
        end
    end
   
    always @ (*) begin
        if (rst == 1'b1) begin
            cp0_status <= 32'h00000000;
        end else if (wb_cp0_we == 1'b1 && wb_cp0_waddr == 5'b01100) begin
            cp0_status <= wb_cp0_wdata;
        end else begin
            cp0_status <= cp0_status_i;
        end
    end
    
    always @ (*) begin
        if (rst == 1'b1) begin
            cp0_index <= 32'h00000000;
        end else if (wb_cp0_we == 1'b1 && wb_cp0_waddr == 5'b00000) begin
            cp0_index <= wb_cp0_wdata;
        end else begin
            cp0_index <= cp0_index_i;
        end
    end

    always @ (*) begin
        if (rst == 1'b1) begin
            cp0_entrylo0 <= 32'h00000000;
        end else if (wb_cp0_we == 1'b1 && wb_cp0_waddr == 5'b00010) begin
            cp0_entrylo0 <= wb_cp0_wdata;
        end else begin
            cp0_entrylo0 <= cp0_entrylo0_i;
        end
    end
 
    always @ (*) begin
        if (rst == 1'b1) begin
            cp0_entrylo1 <= 32'h00000000;
        end else if (wb_cp0_we == 1'b1 && wb_cp0_waddr == 5'b00011) begin
            cp0_entrylo1 <= wb_cp0_wdata;
        end else begin
            cp0_entrylo1 <= cp0_entrylo1_i;
        end
    end

    always @ (*) begin
        if (rst == 1'b1) begin
            cp0_entryhi <= 32'h00000000;
        end else if (wb_cp0_we == 1'b1 && wb_cp0_waddr == 5'b01010) begin
            cp0_entryhi <= wb_cp0_wdata;
        end else begin
            cp0_entryhi <= cp0_entryhi_i;
        end
    end
        
    always @ (*) begin
        if (rst == 1'b1) begin
            cp0_epc <= 32'h00000000;
        end else if (wb_cp0_we == 1'b1 && wb_cp0_waddr == 5'b01110) begin
            cp0_epc <= wb_cp0_wdata;
        end else begin
            cp0_epc <= cp0_epc_i;
        end
    end

    always @ (*) begin
        if (rst == 1'b1) begin
            cp0_ebase <= 32'h00000000;
        end else if (wb_cp0_we == 1'b1 && wb_cp0_waddr == 5'b01111) begin
            cp0_ebase <= wb_cp0_wdata;
        end else begin
            cp0_ebase <= cp0_ebase_i;
        end
    end
    
    assign cp0_epc_o = cp0_epc;
    assign cp0_ebase_o = cp0_ebase;
    
    reg[3:0] ws;
    
    wire[31:0] excepttype,excepttype_puin;
    wire lder;
    reg swer,ereter,ldmemer,tlblder,tlbswer;
    
    assign excepttype_puin = {excepttype_i[31:6], swer, lder, excepttype_i[3:0]};
    assign excepttype = {excepttype_i[31:6], swer, lder, tlbswer, tlblder, excepttype_i[1:0]};
    assign lder = ldmemer || ereter;    
    
    always @ (*) begin
        if (rst == 1'b1) begin
            excepttype_o <= 5'b00000;
            interrupt <= 1'b0;
        end else begin
            interrupt <= 1'b0;
            excepttype_o <= 5'b00000;
            if ( (cp0_cause[15:8] & cp0_status[15:8]) != 8'h0 && cp0_status[0] == 1'b1 && cp0_status[1] == 1'b0 ) begin
                excepttype_o <= 5'b00001;
                interrupt <= 1'b1;
            end else if (excepttype[2] == 1'b1) begin
                excepttype_o <= 5'b00010;
            end else if (excepttype[3] == 1'b1) begin
                excepttype_o <= 5'b00011;
            end else if (excepttype[4] == 1'b1) begin
                excepttype_o <= 5'b00100;
            end else if (excepttype[5] == 1'b1) begin
                excepttype_o <= 5'b00101;
            end else if (excepttype[8] == 1'b1) begin
                excepttype_o <= 5'b01000;
            end else if (excepttype[9] == 1'b1) begin
                excepttype_o <= 5'b01010;
            end else if (excepttype[10] == 1'b1) begin
                excepttype_o <= 5'b01100;
            end else if (excepttype[11] == 1'b1) begin
                excepttype_o <= 5'b01001;
            end else if (excepttype[12] == 1'b1) begin
                excepttype_o <= 5'b01110;
            end
        end
    end
    
    always @ (*) begin
        if (rst == 1'b1) begin
            ereter <= 1'b0;
            ldmemer <= 1'b0;
            swer <= 1'b0;
            tlblder <= 1'b0;
            tlbswer <= 1'b0;
            wreg_o <= 1'b0;
            wd_o <= 5'b00000;
            wdata_o <= 32'h00000000;
            whio_o <= 1'b0;
            hi_o <= 32'h00000000;
            lo_o <= 32'h00000000;
            MasterRd <= 1'b0;
            MasterWr <= 1'b0;
            MasterByteEnable <= 4'b1111;
            ram_data_o <= 32'h00000000;
            virtAddr <= 32'h00000000;
            ram_ce_o <= 1'b0;
            cp0_we_o <= 1'b0;
            cp0_waddr_o <= 5'b00000;
            cp0_wdata_o <= 32'h00000000;
            bad_mmu_addr <= 32'h00000000;
            userMode <= 1'b1;
            tlbwi <= 1'b0;
            refillMessage <= 67'b0;
            stall <= 1'b0;
        end else if (ram_ce_i == 1'b1) begin
            ldmemer <= 1'b0;
            swer <= 1'b0;
            ereter <= 1'b0;
            tlblder <= 1'b0;
            tlbswer <= 1'b0;
            wreg_o <= wreg_i;
            wd_o <= wd_i;
            wdata_o <= wdata_i;
            whio_o <= whio_i;
            hi_o <= hi_i;
            lo_o <= lo_i;
            MasterRd <= 1'b0;
            MasterWr <= 1'b0;
            MasterByteEnable <= 4'b1111;
            ram_data_o <= 32'h00000000;
            virtAddr <= 32'h00000000;
            ram_ce_o <= 1'b0;
            cp0_we_o <= cp0_we_i;
            cp0_waddr_o <= cp0_waddr_i;
            cp0_wdata_o <= cp0_wdata_i;
            bad_mmu_addr <= 32'h00000000;
            userMode <= cp0_status[4] & (!cp0_status[1]);
            tlbwi <= 1'b0;
            refillMessage <= 67'b0;
            stall <= 1'b0;
            if (interrupt == 1'b0 && excepttype_i == 32'h00000000) begin
                case (ram_op_i)
                    `MEM_LB:
                    begin
                        stall <= 1'b1;
                        ram_ce_o <= 1'b1;
                        MasterRd <= 1'b1;
                        MasterWr <= 1'b0;
                        MasterByteEnable <= 4'b0000;
                        virtAddr <= {ram_addr_i[31:2], 2'b00};
                        ram_data_o <= ram_data_i;
                        if (ram_addr_i[1:0] == 2'b0) begin
                            wdata_o <= {{24{ld_data_i[7]}}, ld_data_i[7:0]};
                        end else if (ram_addr_i[1:0] == 2'b01) begin
                            wdata_o <= {{24{ld_data_i[15]}}, ld_data_i[15:8]};
                        end else if (ram_addr_i[1:0] == 2'b10) begin
                            wdata_o <= {{24{ld_data_i[23]}}, ld_data_i[23:16]};
                        end else if (ram_addr_i[1:0] == 2'b11) begin
                            wdata_o <= {{24{ld_data_i[31]}}, ld_data_i[31:24]};
                        end
                        if (permissionDenied == 1'b1) begin
                            ldmemer <= 1'b1;
                            bad_mmu_addr <= ram_addr_i;
                        end
                        if (tlbmiss == 1'b1 || tlbinvalid == 1'b1) begin
                            tlblder <= 1'b1;
                            bad_mmu_addr <= ram_addr_i;
                        end
                    end
                    `MEM_LBU:
                    begin
                        stall <= 1'b1;
                        ram_ce_o <= 1'b1;
                        MasterRd <= 1'b1;
                        MasterWr <= 1'b0;
                        MasterByteEnable <= 4'b0000;
                        virtAddr <= {ram_addr_i[31:2], 2'b00};
                        ram_data_o <= ram_data_i;
                        if (ram_addr_i[1:0] == 2'b0) begin
                            wdata_o <= {24'b0, ld_data_i[7:0]};
                        end else if (ram_addr_i[1:0] == 2'b01) begin
                            wdata_o <= {24'b0, ld_data_i[15:8]};
                        end else if (ram_addr_i[1:0] == 2'b10) begin
                            wdata_o <= {24'b0, ld_data_i[23:16]};
                        end else if (ram_addr_i[1:0] == 2'b11) begin
                            wdata_o <= {24'b0, ld_data_i[31:24]};
                        end
                        if (permissionDenied == 1'b1) begin
                            ldmemer <= 1'b1;
                            bad_mmu_addr <= ram_addr_i;
                        end
                        if (tlbmiss == 1'b1 || tlbinvalid == 1'b1) begin
                            tlblder <= 1'b1;
                            bad_mmu_addr <= ram_addr_i;
                        end
                    end
                    `MEM_LW:
                    begin
                        stall <= 1'b1;
                        ram_ce_o <= 1'b1;
                        MasterRd <= 1'b1;
                        MasterWr <= 1'b0;
                        MasterByteEnable <= 4'b0000;
                        virtAddr <= ram_addr_i;
                        ram_data_o <= ram_data_i;
                        wdata_o <= ld_data_i;
                        if (ram_addr_i[1:0] != 2'b00) begin
                            ldmemer <= 1'b1;
                            bad_mmu_addr <= ram_addr_i;
                            MasterRd <= 1'b0;
                            MasterWr <= 1'b0;
                            MasterByteEnable <= 4'b1111;
                        end
                        if (permissionDenied == 1'b1) begin
                            ldmemer <= 1'b1;
                            bad_mmu_addr <= ram_addr_i;
                        end
                        if (tlbmiss == 1'b1 || tlbinvalid == 1'b1) begin
                            tlblder <= 1'b1;
                            bad_mmu_addr <= ram_addr_i;
                        end
                    end
                    `MEM_SB:
                    begin
                        stall <= 1'b1;
                        ram_ce_o <= 1'b1;
                        MasterRd <= 1'b0;
                        MasterWr <= 1'b1;
                        if (ram_addr_i[1:0] == 2'b00) begin
                            MasterByteEnable <= 4'b1110;
                            ram_data_o <= {8'h00, 8'h00, 8'h00, ram_data_i[7:0]};
                        end else if (ram_addr_i[1:0] == 2'b01) begin
                            MasterByteEnable <= 4'b1101;
                            ram_data_o <= {8'h00, 8'h00, ram_data_i[7:0], 8'h00};
                        end else if (ram_addr_i[1:0] == 2'b10) begin
                            MasterByteEnable <= 4'b1011;
                            ram_data_o <= {8'h00, ram_data_i[7:0], 8'h00, 8'h00};
                        end else if (ram_addr_i[1:0] == 2'b11) begin
                            MasterByteEnable <= 4'b0111;
                            ram_data_o <= {ram_data_i[7:0], 8'h00, 8'h00, 8'h00};
                        end
                        virtAddr <= ram_addr_i;
                        if (permissionDenied == 1'b1) begin
                            swer <= 1'b1;
                            bad_mmu_addr <= ram_addr_i;
                        end
                        if (tlbmiss == 1'b1 || tlbinvalid == 1'b1) begin
                            tlbswer <= 1'b1;
                            bad_mmu_addr <= ram_addr_i;
                        end
                    end
                    `MEM_SW:
                    begin
                        stall <= 1'b1;
                        ram_ce_o <= 1'b1;
                        MasterRd <= 1'b0;
                        MasterWr <= 1'b1;
                        MasterByteEnable <= 4'b0000;
                        virtAddr <= ram_addr_i;
                        ram_data_o <= ram_data_i;
                        if (ram_addr_i[1:0] != 2'b00) begin
                            swer <= 1'b1;
                            bad_mmu_addr <= ram_addr_i;
                            MasterRd <= 1'b0;
                            MasterWr <= 1'b0;
                            MasterByteEnable <= 4'b1111;
                        end
                        if (permissionDenied == 1'b1) begin
                            swer <= 1'b1;
                            bad_mmu_addr <= ram_data_i;
                        end
                        if (tlbmiss == 1'b1 || tlbinvalid == 1'b1) begin
                            tlbswer <= 1'b1;
                            bad_mmu_addr <= ram_addr_i;
                        end
                    end
                    `MEM_TLBWI:
                    begin
                        stall <= 1'b1;
                        ram_ce_o <= 1'b1;
                        MasterRd <= 1'b0;
                        MasterWr <= 1'b0;
                        MasterByteEnable <= 4'b1111;
                        tlbwi <= 1'b1;
                        refillMessage <= {cp0_entryhi[31:13], cp0_entrylo0[25:6], cp0_entrylo0[2:1], cp0_entrylo1[25:6], cp0_entrylo1[2:1], cp0_index[3:0]};
                    end
                    `MEM_TLBWR:
                    begin
                        stall <= 1'b1;
                        ram_ce_o <= 1'b1;
                        MasterRd <= 1'b0;
                        MasterWr <= 1'b0;
                        MasterByteEnable <= 4'b1111;
                        tlbwi <= 1'b1;
                        refillMessage <= {cp0_entryhi[31:13], cp0_entrylo0[25:6],  cp0_entrylo0[2:1], cp0_entrylo1[25:6], cp0_entrylo1[2:1], cp0_random[3:0]};
                    end
                    default:
                    begin
                    end
                endcase
            end
        end else begin
            ldmemer <= 1'b0;
            swer <= 1'b0;
            tlblder <= 1'b0;
            tlbswer <= 1'b0;
            wreg_o <= wreg_i;
            wd_o <= wd_i;
            wdata_o <= wdata_i;
            whio_o <= whio_i;
            hi_o <= hi_i;
            lo_o <= lo_i;
            MasterRd <= 1'b0;
            MasterWr <= 1'b0;
            MasterByteEnable <= 4'b1111;
            ram_data_o <= 32'h00000000;
            ram_ce_o <= 1'b0;
            virtAddr <= 32'h00000000;
            cp0_we_o <= cp0_we_i;
            cp0_waddr_o <= cp0_waddr_i;
            cp0_wdata_o <= cp0_wdata_i;
            bad_mmu_addr <= 32'h00000000;
            ereter <= 1'b0;
            stall <= 1'b0;
            userMode <= 1'b1;
            tlbwi <= 1'b0;
            refillMessage <= 67'b0;
            if (excepttype_i[12] == 1'b1) begin
                if (cp0_epc_o[1:0] != 2'b00) begin
                    ereter <= 1'b1;
                    bad_mmu_addr <= cp0_epc_o;
                end
            end
            if (instinvalid == 1'b1 || instmiss == 1'b1) begin
                tlblder <= 1'b1;
                bad_mmu_addr <= pc_i;
            end
            if (instpermissionDenied == 1'b1) begin
                ldmemer <= 1'b1;
                bad_mmu_addr <= pc_i;
            end
        end
    end
    
endmodule
