`default_nettype none

module thinpad_top(
    input wire clk_50M,           //50MHz æ—¶é�?�Ÿè¾�?�å�?��?
    input wire clk_11M0592,       //11.0592MHz æ—¶é�?�Ÿè¾�?�å�?��?

    input wire clock_btn,         //BTN5æ‰�?�åŠ¨æ�?�¶é�?�ŸæŒ�?�é�?�®å�??å…³ï¼Œå¸¦æ¶ˆæŠ�?�ç�?�µè·¯ï¼ŒæŒ�?�ä¸�?�æ�?�¶ä¸�?1
    input wire reset_btn,         //BTN6æ‰�?�åŠ¨å¤ä½æŒ�?�é�?�®å�??å…³ï¼Œå¸¦æ¶ˆæŠ�?�ç�?�µè·¯ï¼ŒæŒ�?�ä¸�?�æ�?�¶ä¸�?1

    input  wire[3:0]  touch_btn,  //BTN1~BTN4ï¼ŒæŒ‰é�?�®å¼€å…³ï¼ŒæŒ�?�ä¸�?�æ�?�¶ä¸�?1
    input  wire[31:0] dip_sw,     //32ä½æ‹¨ç å¼€å…³ï¼Œæ�?�¨åˆ°â€œONâ€æ�?�¶ä�??1
    output wire[15:0] leds,       //16ä½LEDï¼Œè¾“å�?�ºæ�?��?1ç‚¹äº�?
    output wire[7:0]  dpy0,       //æ•°ç ç®¡ä½Žä½ä¿¡å·ï¼ŒåŒ�?�æ�?�¬å°æ�?�°ç�?�¹ï¼Œè¾�?�å�?��?1ç‚¹äº�?
    output wire[7:0]  dpy1,       //æ•°ç ç®¡é«˜ä½ä¿¡å·ï¼ŒåŒ�?�æ�?�¬å°æ�?�°ç�?�¹ï¼Œè¾�?�å�?��?1ç‚¹äº�?

    //CPLDä¸²å£æŽ§åˆ¶å™¨ä¿¡å�??
    output wire uart_rdn,         //è¯»ä¸²å£ä¿¡å·ï¼Œä½Žæœ‰æ�???
    output wire uart_wrn,         //å†™ä¸²å£ä¿¡å·ï¼Œä½Žæœ‰æ�???
    input wire uart_dataready,    //ä¸²å£æ•°æ®å�?��?�å¤�?�å�??
    input wire uart_tbre,         //å‘�??æ•°æ®æ �?�å�??
    input wire uart_tsre,         //æ•°æ®å�?��??å®Œæ¯•æ �?�å�??

    //BaseRAMä¿¡å·
    inout wire[31:0] base_ram_data,  //BaseRAMæ•°æ®ï¼Œä½�?8ä½ä¸ŽCPLDä¸²å£æŽ§åˆ¶å™¨å�?�±ä�??
    output wire[19:0] base_ram_addr, //BaseRAMåœ°å�?
    output wire[3:0] base_ram_be_n,  //BaseRAMå­—èŠ�?�ä½¿èƒ½ï¼Œä½Žæœ�?�æ�?�ˆã€‚å¦�?�æžœä¸ä½¿ç�?�¨å­�?�èŠ�?�ä½¿èƒ½ï¼Œè¯·ä¿æŒä�??0
    output wire base_ram_ce_n,       //BaseRAMç‰�?��??‰ï¼Œä½Žæœ�?�æ�???
    output wire base_ram_oe_n,       //BaseRAMè¯»ä½¿èƒ½ï¼Œä½Žæœ‰æ�???
    output wire base_ram_we_n,       //BaseRAMå†™ä½¿èƒ½ï¼Œä½Žæœ‰æ�???

    //ExtRAMä¿¡å·
    inout wire[31:0] ext_ram_data,  //ExtRAMæ•°æ�?
    output wire[19:0] ext_ram_addr, //ExtRAMåœ°å�?
    output wire[3:0] ext_ram_be_n,  //ExtRAMå­—èŠ�?�ä½¿èƒ½ï¼Œä½Žæœ�?�æ�?�ˆã€‚å¦�?�æžœä¸ä½¿ç�?�¨å­�?�èŠ�?�ä½¿èƒ½ï¼Œè¯·ä¿æŒä�??0
    output wire ext_ram_ce_n,       //ExtRAMç‰�?��??‰ï¼Œä½Žæœ�?�æ�???
    output wire ext_ram_oe_n,       //ExtRAMè¯»ä½¿èƒ½ï¼Œä½Žæœ‰æ�???
    output wire ext_ram_we_n,       //ExtRAMå†™ä½¿èƒ½ï¼Œä½Žæœ‰æ�???

    //ç›´è¿žä¸²å£ä¿¡å�?
    output wire txd,  //ç›´è¿žä¸²å£å�?��??ç«¯
    input  wire rxd,  //ç›´è¿žä¸²å£æŽ¥æ�?�¶ç�??

    //Flashå­˜å‚¨å™¨ä¿¡å·ï¼Œå‚�??? JS28F640 èŠ¯ç‰�?�æ�?��?�å�?��?
    output wire [22:0]flash_a,      //Flashåœ°å€ï¼Œa0ä»…åœ�?8bitæ¨¡å¼æœ‰æ�?�ˆï�??16bitæ¨¡å¼æ— æ�?�ä�??
    inout  wire [15:0]flash_d,      //Flashæ•°æ�?
    output wire flash_rp_n,         //Flashå¤ä½ä¿¡å·ï¼Œä½Žæœ‰æ�?��?
    output wire flash_vpen,         //Flashå†™ä¿æŠ¤ä¿¡å·ï¼Œä½Žç”µå¹³æ�?�¶ä¸èƒ½æ�?�¦é™¤ã€çƒ§å�???
    output wire flash_ce_n,         //Flashç‰�?��??‰ä¿¡å·ï¼Œä½Žæœ�?�æ�???
    output wire flash_oe_n,         //Flashè¯»ä½¿èƒ½ä¿¡å·ï¼Œä½Žæœ‰æ�???
    output wire flash_we_n,         //Flashå†™ä½¿èƒ½ä¿¡å·ï¼Œä½Žæœ‰æ�???
    output wire flash_byte_n,       //Flash 8bitæ¨¡å¼é€�?�æ�?�©ï¼Œä½Žæœ�?�æ�?�ˆã€‚åœ¨ä½¿ç�?�¨flashçš?16ä½æ¨¡å¼æ—¶è¯·è®¾ä�??1

    //USB æŽ§åˆ¶å™¨ä¿¡å·ï¼Œå�?��??? SL811 èŠ¯ç‰�?�æ�?��?�å�?��?
    output wire sl811_a0,
    inout  wire[7:0] sl811_d,
    output wire sl811_wr_n,
    output wire sl811_rd_n,
    output wire sl811_cs_n,
    output wire sl811_rst_n,
    output wire sl811_dack_n,
    input  wire sl811_intrq,
    input  wire sl811_drq_n,

    //ç½‘ç»œæŽ§åˆ¶å™¨ä¿¡å·ï¼Œå‚�??? DM9000A èŠ¯ç‰�?�æ�?��?�å�?��?
    output wire dm9k_cmd,
    inout  wire[15:0] dm9k_sd,
    output wire dm9k_iow_n,
    output wire dm9k_ior_n,
    output wire dm9k_cs_n,
    output wire dm9k_pwrst_n,
    input  wire dm9k_int,

    //å›¾åƒè¾�?�å�?�ºä¿¡å�?
    output wire[2:0] video_red,    //çº¢è‰²åƒç´ ï�??3ä½?
    output wire[2:0] video_green,  //ç»¿è‰²åƒç´ ï�??3ä½?
    output wire[1:0] video_blue,   //è“è�?�²åƒç´ ï�??2ä½?
    output wire video_hsync,       //è¡ŒåŒæ­¥ï¼ˆæ°´å¹³åŒæ­¥ï¼‰ä¿¡å�??
    output wire video_vsync,       //åœºåŒæ­¥ï¼ˆåž‚ç�?�´åŒæ­¥ï¼�?�ä¿¡å�??
    output wire video_clk,         //åƒç´ æ—¶é�?�Ÿè¾�?�å�?��?
    output wire video_de          //è¡Œæ•°æ®æœ�?�æ�?�ˆä¿¡å·ï¼Œç�?�¨äºŽåŒºåˆ�?�æ¶ˆéšå�??
 
);
parameter ClkFrequency = 25000000;

/* =========== Demo code begin =========== */

// PLLåˆ†é¢�?�ç¤ºä¾�??
wire locked, clk_10M, clk_20M, flash_clk, vga_read_clk;
pll_example clock_gen 
 (
  // Clock out ports
  .clk_out1(clk_10M), // æ—¶é�?�Ÿè¾�?�å�?��?1ï¼Œé¢‘çŽ�?�åœ¨IPé…ç½®ç�?�Œé¢ä¸­è®¾ç�??
  .clk_out2(clk_20M), // æ—¶é�?�Ÿè¾�?�å�?��?2ï¼Œé¢‘çŽ�?�åœ¨IPé…ç½®ç�?�Œé¢ä¸­è®¾ç�??
  .clk_out3(flash_clk),
  .clk_out4(vga_read_clk),
  // Status and control signals
  .reset(reset_btn), // PLLå¤ä½è¾“å�?��?
  .locked(locked), // é”å®šè¾�?�å�?�ºï�??"1"è¡¨ç¤ºæ—¶é�?�Ÿç¨³å®šï¼Œå¯ä½œä¸ºåŽçº§ç�?�µè·¯å¤ä½�?
 // Clock in ports
  .clk_in1(clk_50M) // å¤–éƒ¨æ�?�¶é�?�Ÿè¾�?�å�?��?
 );

reg reset_of_clk10M;
// å¼‚æ­¥å¤ä½ï¼ŒåŒæ­¥é�?�Šæ�???
always@(posedge clk_10M or negedge locked) begin
    if(~locked) reset_of_clk10M <= 1'b1;
    else        reset_of_clk10M <= 1'b0;
end

always@(posedge clk_10M or posedge reset_of_clk10M) begin
    if(reset_of_clk10M)begin
        // Your Code
    end
    else begin
        // Your Code
    end
end

wire[31:0] regcheck,regsum;

openmips_min_sopc cpu(
    // input
    .clk(clk_10M),.rst(reset_of_clk10M),
    .mmu_data_i         (masterReadData),
    .mmu_miss         (tlbmiss),
    .mmu_invalid      (tlbinvalid),
    .mmu_permissionDenied(permissionDenied),
    .cpu_stall        (flashStall),
    .uart_int_i       (uartinterrupt),

    // output
    .regcheck         (regcheck),
    .regsum           (regsum),
    .virtAddr         (virtAddr),
    .masterRd         (masterRd),
    .masterWr         (masterWr),
    .mmu_data_o         (masterWriteData),
    .masterByteEnable (masterByteEnable),
    .userMode         (userMode),
    .tlbwi            (tlbwi),
    .refillMessage    (refillMessage),
    .debugger         (debugger)
    
);
wire[63:0] debugger;
wire[31:0] virtAddr;

wire debug;
assign debug = 1'b0;
wire[63:0] debugaddr;
assign debugaddr = debugger;
mmu_interface mmu(

    // input 
    .clk             (clk_10M),
    .rst             (reset_of_clk10M),
    .en              (masterRd | masterWr),
    .userMode        (userMode),
    .virtAddr        (virtAddr),
    .permissionDenied(permissionDenied),
    .refillMessage   (refillMessage),
    .tlbwi           (tlbwi),
    .MasterRd        (masterRd),
    .MasterWr        (masterWr),
    .MasterByteEnable(masterByteEnable),

    // output
     .physAddr        (physAddr),
     .miss            (tlbmiss),
     .invalid         (tlbinvalid),
     .BusRd           (busRd),
     .BusWr           (busWr),
     .BusByteEnable   (busByteEnable)

    );
wire[31:0] physAddr;
wire masterRd, masterWr;
wire[3:0] masterByteEnable;
wire[31:0] masterWriteData;
wire userMode,tlbwi,permissionDenied;
wire tlbmiss,tlbinvalid;
wire[66:0] refillMessage;

wire[31:0] masterReadData;
wire busRd,busWr;
wire[3:0] busByteEnable;

 bus bus0(
     // input

     .masterAddr_i      (physAddr),
     .masterRd_i        (busRd),
     .masterWr_i        (busWr),
     .masterByteEnable_i(busByteEnable),
     .masterData_i      (masterWriteData),
     .sramData_i        (sramReadData),
     .romData_i         (romData),
     .flashData_i       (flashReadData),
     .uartData_i        (uartReadData),
    // output 
     .masterData_o      (masterReadData),
     .sramRd_o          (sramRd),
     .sramWr_o          (sramWr),
     .sramByteEnable_o  (sramByteEnable),
     .sramData_o        (sramWriteData),
     .sramAddr_o        (sramAddr),
     
    .romAddr_o          (romAddr),
    
    .flashRd_o(flashRd),
    .flashWr_o(),
    .flashByteEnable_o(flashByteEnable),
    .flashData_o(),
    .flashAddr_o(flashAddr),
    
    
    .uartRd_o          (uartRd),
    .uartWr_o          (uartWr),
    .uartData_o        (uartWriteData),
    .uartAddr_o        (uartAddr),
    
    .vgaRd_o           (),
    .vgaWr_o           (vgaWr),
    .vgaData_o         (vgaWriteData),
    .vgaAddr_o         (vgaAddr)
    );
wire[11:0] romAddr;
wire[31:0] romData;
// dist_mem_gen_0 rom(
 //   .a(romAddr[8:2]),
  //  .spo(romData)
 //);
    
    
 wire sramRd, sramWr;
 wire[3:0] sramByteEnable;
 wire[31:0] sramWriteData;
 wire[21:0] sramAddr;

 wire[31:0] sramReadData;
 my_sram_control sram_controller(
     // input
     .clk2x          (clk_20M),
     .rst            (reset_of_clk10M),
     .masterRd_i     (sramRd),
     .masterWr_i     (sramWr),
     .byteEnable_i   (sramByteEnable),
     .writeData_i    (sramWriteData),
     .ramAddr_i      (sramAddr),
     .ramData_bus      (ext_ram_data),
//     // output

     .ramAddr_o      (ext_ram_addr),
     .sramEnable_n_o (ext_ram_ce_n),
     .writeEnable_n_o(ext_ram_we_n),
     .readEnable_n_o (ext_ram_oe_n),
     .byteEnable_o   (ext_ram_be_n),
     .ramData_o      (sramReadData)



     );
wire flashRd;
wire flashStall;
wire[31:0] flashReadData;
wire[3:0] flashByteEnable;
wire[23:0] flashAddr;

assign flash_vpen = 1'b1;
assign flash_rp_n = ~reset_of_clk10M;
flash_control flash_controler(
    .clk(flash_clk), .rst(reset_of_clk10M),
    .masterRd_i(flashRd), .masterWr_i(1'b0),
    .byteEnable_i(flashByteEnable),
    .writeData_i(32'b0),
    .flashAddr_i(flashAddr),
    .flashData_bus(flash_d),
    .flashAddr_o    (flash_a),
    .flashEnable_n_o(flash_ce_n),
    .writeEnable_n_o(flash_we_n),
    .readEnable_n_o (flash_oe_n),
    .lowBitMode_n_o (flash_byte_n),
    .flashData_o    (flashReadData),
    .flashStall_o   (flashStall)
);

wire uartinterrupt;
 wire uartRd, uartWr;
 wire[31:0] uartWriteData;
 wire[3:0] uartAddr;

 wire[31:0] uartReadData;

reg[7:0] uartchoice;
wire[2:0] statee;
assign statee = dip_sw[2:0];
always @(*) begin
    case(statee) 
        3'd0:
            uartchoice <= debugaddr[7:0];
        3'd1:
            uartchoice <= debugaddr[15:8];
        3'd2:
            uartchoice <= debugaddr[23:16];
        3'd3:
            uartchoice <= debugaddr[31:24];
        3'd4:
            uartchoice <= debugaddr[39:32];
        3'd5:
            uartchoice <= debugaddr[47:40];
        3'd6:
            uartchoice <= debugaddr[55:48];
        3'd7:
            uartchoice <= debugaddr[63:56];
    endcase
end 
uart_control #(.ClkFrequency(ClkFrequency),.Baud(115200)) 
     uart_controller(
    .clk_cpu    (clk_10M),
    .masterRd_i (uartRd),
    .masterWr_i (uartWr),
    .writeData_i(uartWriteData),
    .uartAddr_i (uartAddr),
    .rxd        (rxd),
    .debug      (debug),
    .debugData  (uartchoice),

    .uartData_o (uartReadData),
    .interrupt  (uartinterrupt),
    .txd        (txd)

    );



// æ•°ç ç®¡è¿žæŽ¥å�?�³ç³»ç¤ºæ�?�å�?�¾ï¼Œdpy1åŒç�?
// p=dpy0[0] // ---a---
// c=dpy0[1] // |     |
// d=dpy0[2] // f     b
// e=dpy0[3] // |     |
// b=dpy0[4] // ---g---
// a=dpy0[5] // |     |
// f=dpy0[6] // e     c
// g=dpy0[7] // |     |
//           // ---d---  p

// 7æ®µæ•°ç ç®¡è¯�?�ç å™¨æ¼”ç¤ºï¼Œå°�?�numberç�??16è¿›åˆ¶æ˜¾ç¤ºåœ¨æ�?�°ç ç®¡ä¸Šé�?
wire[7:0] number;
assign number = regcheck[7:0];
SEG7_LUT segL(.oSEG1(dpy0), .iDIG(number[3:0])); //dpy0æ˜¯ä½Žä½æ•°ç ç®�?
SEG7_LUT segH(.oSEG1(dpy1), .iDIG(number[7:4])); //dpy1æ˜¯é«˜ä½æ•°ç ç®�?

reg[15:0] led_bits;
assign leds = regsum[15:0];

// always@(posedge clock_btn or posedge reset_btn) begin
//     if(reset_btn)begin //å¤ä½æŒ‰ä¸�?�ï¼Œè®¾ç½®LEDå’Œæ�?�°ç ç®¡ä¸ºåˆå§�?��???
//         led_bits <= 16'h1;
//     end
//     else begin //æ¯æ¬¡æŒ‰ä¸�?�æ�?�¶é�?�ŸæŒ�?�é�?�®ï¼Œæ�?�°ç ç®¡æ˜¾ç¤ºå€¼åŠ 1ï¼ŒLEDå¾ªçŽ¯å·¦ç§»
//         led_bits <= {led_bits[14:0],led_bits[15]};
//     end
// end



//å›¾åƒè¾�?�å�?�ºæ¼�?�ç¤ºï¼Œåˆ�?�è¾¨çŽ�??800x600@75Hzï¼Œåƒç´ æ—¶é�?�Ÿä¸�?50MHz
assign video_clk = vga_read_clk;

wire[18:0] vgaAddr;
wire vgaWr;
wire[31:0] vgaWriteData;
vga #(12, 800, 856, 976, 1040, 600, 637, 643, 666, 1, 1) vga800x600at75 (
    .clk_vga(vga_read_clk), 
    .clk_cpu(flash_clk),
    .rst(reset_of_clk10M),
    
    .vgaAddr_i(vgaAddr),
    .writeData_i(vgaWriteData),
    .masterWr_i(vgaWr),
    
    
    .hsync(video_hsync),
    .vsync(video_vsync),
    .data_enable(video_de),
    .vgaData_o({video_red, video_green, video_blue})
);

endmodule
