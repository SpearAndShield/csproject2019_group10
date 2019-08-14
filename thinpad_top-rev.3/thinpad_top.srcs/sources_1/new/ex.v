`timescale 1ns / 1ps
`include "defines.v"

module ex(rst,alusel_i,aluop_i,reg1_i,reg2_i,wd_i,wreg_i,wd_o,wreg_o,wdata_o);
    input wire rst,wreg_i;
    input wire[2:0] alusel_i;
    input wire[4:0] wd_i;
    input wire[7:0] aluop_i;
    input wire[31:0] reg1_i,reg2_i;
    output reg wreg_o;
    output reg[4:0] wd_o;
    output reg[31:0] wdata_o;
    
    reg[31:0] logicout;
  
    always @ (*) begin
        if (rst == 1'b1) begin
            logicout <= 32'h00000000;
        end else begin
            case (aluop_i)
                `EXE_OR_OP:
                begin
                    logicout <= reg1_i | reg2_i;
                end
                default: begin
                    logicout <= 32'h00000000;
                end
            endcase
        end
    end

    always @ (*) begin
    wd_o <= wd_i;
    wreg_o <= wreg_i;
    case(alusel_i)
        'EXE_RES_LOGIC:
            wdata_o <= logicout;
        end
        default:
            wdata_o <= 32'h00000000;
        end
    endcase
    end
endmodule
