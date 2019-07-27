`timescale 1ns / 1ps
//
// WIDTH: bits in register hdata & vdata
// HSIZE: horizontal size of visible field 
// HFP: horizontal front of pulse
// HSP: horizontal stop of pulse
// HMAX: horizontal max size of value
// VSIZE: vertical size of visible field 
// VFP: vertical front of pulse
// VSP: vertical stop of pulse
// VMAX: vertical max size of value
// HSPP: horizontal synchro pulse polarity (0 - negative, 1 - positive)
// VSPP: vertical synchro pulse polarity (0 - negative, 1 - positive)
//
module vga
#(parameter WIDTH = 12, HSIZE = 800, HFP = 856, HSP = 976, HMAX = 1040, VSIZE = 600, VFP = 637, VSP = 643, VMAX = 666, HSPP = 1, VSPP = 1)
(
    input wire clk_cpu,
    input wire clk_vga,
    input wire rst,
    
    input wire[18:0] vgaAddr_i,
    input wire[31:0] writeData_i, 
    input wire masterWr_i,
    
    output wire hsync,
    output wire vsync,
    output wire data_enable,
    output reg[7:0] vgaData_o // write to vga
    
    
);
reg [WIDTH - 1:0] hdata, hdata_ahead;

reg [WIDTH - 1:0] vdata, vdata_ahead;
wire[31:0] vgaData_word;
wire[18:0] pixelAddr;
//wire[16:0] offsetTemp;

blk_mem_gen_0 gpuMem (
  .clka(clk_cpu),    // input wire clka
  .ena(masterWr_i),      // input wire ena
  .wea(masterWr_i),      // input wire [0 : 0] wea
  .addra(vgaAddr_i[18:2]),  // input wire [16 : 0] addra
  .dina(writeData_i),    // input wire [31 : 0] dina
  .clkb(clk_vga),    // input wire clkb
  .addrb(pixelAddr[18:2]),  // input wire [16 : 0] addrb
  .doutb(vgaData_word)  // output wire [31 : 0] doutb
);

// hdata vdata
always @ (posedge clk_vga or posedge rst)
begin
    if(rst) begin
        hdata <= 0;
        hdata_ahead <= 1;
        vdata <= 0;
        vdata_ahead <= 0;
    end else 
    begin
        if (hdata == (HMAX - 1)) begin
            hdata <= 0;
            if(vdata == (VMAX - 1)) begin
                vdata <= 0;
            end else begin
                vdata <= vdata + 1;
            end
        end
        else begin
            hdata <= hdata + 1;
        end

        if (hdata_ahead == (HMAX - 1)) begin
            hdata_ahead <= 0;
            if(vdata_ahead == (VMAX - 1)) begin
                vdata_ahead <= 0;
            end else begin
                vdata_ahead <= vdata_ahead + 1;
            end
        end
        else begin
            hdata_ahead <= hdata_ahead + 1;
        end        
        
    end
end



//reg[31:0] vgaData_word_buf;
//always @(posedge clk_vga or posedge rst) begin
//    if(rst) begin
//        vgaData_word_buf <= 32'd0;
//    end else begin
//        if(pixelIndex[1:0] ==2'd3) begin
//            vgaData_word_buf <= vgaData_word;
//        end
//    end
//end


always @(*) begin
    if(hdata[1:0] == 2'd0) begin
        vgaData_o <= vgaData_word[31:24];
    end else if (hdata[1:0] == 2'd1) begin
        vgaData_o <= vgaData_word[23:16];
    end else if (hdata[1:0] == 2'd2) begin
        vgaData_o <= vgaData_word[15:8];
    end else begin
        vgaData_o <= vgaData_word[7:0];
    end
end


// hsync & vsync & blank
assign hsync = ((hdata >= HFP) && (hdata < HSP)) ? HSPP : !HSPP;
assign vsync = ((vdata >= VFP) && (vdata < VSP)) ? VSPP : !VSPP;
assign data_enable = ((hdata < HSIZE) & (vdata < VSIZE));
assign pixelAddr = hdata_ahead + vdata_ahead * HSIZE;



endmodule