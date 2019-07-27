`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/05 19:44:21
// Design Name: 
// Module Name: cp0_reg
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


module cp0_reg(rst,clk,we_i,waddr_i,wdata_i,raddr_i,int_i,data_o,rsel_i,badaddr_i,pcreset_i,random_o,
               epc_o,ebase_o,index_o,entrylo0_o,entrylo1_o,entryhi_o,cause_o,status_o,timer_int_o,
               excepttype_i,pc_i,is_in_delayslot_i);
    input wire rst,clk,we_i,is_in_delayslot_i,rsel_i,pcreset_i;
    input wire[4:0] raddr_i,waddr_i,excepttype_i;
    input wire[5:0] int_i;
    input wire[31:0] wdata_i,pc_i,badaddr_i;
    output reg timer_int_o;
    output reg[31:0] data_o,ebase_o,index_o,entrylo0_o,entrylo1_o,entryhi_o,cause_o,status_o,random_o;
    output reg[31:0] epc_o;

     reg[31:0] compare,count,badaddr,pagemask,watchlo,watchhi;
    
    always @ (posedge clk) begin
        if (rst == 1'b1) begin
            count <= 32'h00000000;
            compare <= 32'h00000000;
            status_o <= 32'h10000000;
            cause_o <= 32'h00000000;
            epc_o <= 32'h00000000;
            ebase_o <= 32'h00000000;
            badaddr <= 32'h00000000;
            index_o <= 32'h00000000;
            entrylo0_o <= 32'h00000000;
            entrylo1_o <= 32'h00000000;
            entryhi_o <= 32'h00000000;
            pagemask <= 32'h00000000;
            watchlo <= 32'h00000000;
            watchhi <= 32'h00000000;
            random_o <= 32'h00000000;
            timer_int_o <= 1'b0;
        end else begin
            count <= count + 1;
            cause_o[15:10] <= int_i;
            if (compare != 32'h00000000 && compare == count) begin
                timer_int_o <= 1'b1;
            end
            if (we_i == 1'b1) begin
                case (waddr_i)
                    5'b00000:
                        index_o <= wdata_i;
                    5'b00001:
                        random_o <= wdata_i;
                    5'b00010:
                        entrylo0_o <= wdata_i;
                    5'b00011:
                        entrylo1_o <= wdata_i;
                    5'b00101:
                        pagemask <= wdata_i;
                    5'b01000:
                        badaddr <= wdata_i;
                    5'b01001:
                        count <= wdata_i;
                    5'b01010:
                        entryhi_o <= wdata_i;
                    5'b01011:
                    begin
                        compare <= wdata_i;
                        timer_int_o <= 1'b0;
                    end
                    5'b01100:
                        status_o <= wdata_i;
                    5'b01101:
                    begin
                        cause_o <= wdata_i;
                    end
                    5'b01110:
                        epc_o <= wdata_i;
                    5'b01111:
                        ebase_o <= wdata_i;
                    5'b10010:
                        watchlo <= wdata_i;
                    5'b10011:
                        watchhi <= wdata_i;
                    default:
                    begin
                    end
                endcase
            end
            
            if (excepttype_i != 5'b00000) begin
                if (excepttype_i == 5'b01110) begin
                    status_o[1] <= 1'b0;
                end else begin
                    if (status_o[1] == 1'b0) begin
                        status_o[1] <= 1'b1;
                        if (is_in_delayslot_i == 1'b1) begin
                            epc_o <= pc_i - 4;
                            cause_o[31] <= 1'b1;
                        end else begin
                            epc_o <= pc_i;
                            cause_o[31] <= 1'b0;
                        end
                    end
                    if (excepttype_i == 5'b00001) begin
                        cause_o[6:2] <= 5'b00000;
                    end else begin
                        cause_o[6:2] <= excepttype_i;
                    end
                    if (excepttype_i == 5'b00010 || excepttype_i == 5'b00011 || excepttype_i == 5'b00100 || excepttype_i == 5'b00101) begin
                        badaddr <= badaddr_i;
                    end
                end
            end
        end
    end

    always @ (*) begin
        if (rst == 1'b1) begin
            data_o <= 32'h00000000;
        end else begin
            data_o <= 32'h00000000;
            if (rsel_i) begin
                case (raddr_i)
                    5'b00000:
                        data_o <= index_o;
                    5'b00001:
                        data_o <= random_o;
                    5'b00010:
                        data_o <= entrylo0_o;
                    5'b00011:
                        data_o <= entrylo1_o;
                    5'b00101:
                        data_o <= pagemask;
                    5'b01000:
                        data_o <= badaddr;
                    5'b01001:
                        data_o <= count;
                    5'b01010:
                        data_o <= entryhi_o;
                    5'b01011:
                        data_o <= compare;
                    5'b01100:
                        data_o <= status_o;
                    5'b01101:
                        data_o <= cause_o;
                    5'b01110:
                        data_o <= epc_o;
                    5'b01111:
                        data_o <= ebase_o;
                    5'b10010:
                        data_o <= watchlo;
                    5'b10011:
                        data_o <= watchhi;
                    default:
                    begin
                    end
                endcase
            end
        end
    end

endmodule