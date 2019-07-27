module bus (
	//input
	 // from master
	masterAddr_i,
	masterRd_i,
	masterWr_i,
	masterData_i,
	masterByteEnable_i,
	// from controllers
	sramData_i,

	romData_i,

	flashData_i,
	

	uartData_i,
	// TODO: uart, keyboard, VGA, ...

	//output
	// to master
	masterData_o,
	// to controllers
	sramRd_o,
	sramWr_o,
	sramByteEnable_o,
	sramData_o,
	sramAddr_o,

	romAddr_o,

	flashRd_o,
	flashWr_o,
	flashByteEnable_o,
	flashData_o,
	flashAddr_o,

	uartRd_o,
	uartWr_o,
	uartData_o,
	uartAddr_o,
	
	vgaRd_o,
	vgaWr_o,
	vgaData_o,
	vgaAddr_o
);

parameter SRAMADDRLEN = 22; // 2^22 = 4M Bytes
parameter FLASHADDRLEN = 24; // TODO: The actual chip has only 22 address bit ?
parameter VGAADDRLEN = 19;
parameter UARTADDRLEN = 4;
// the lowest addr bit should be added by flash control to choose high/low 8-bit (when 8-bit mode is on)
parameter ROMADDRLEN = 12; // 2 ^12 = 4K Bytes
parameter SRAMHEAD = 10'b0;
parameter FLASHHEAD = 8'b00011110;
parameter ROMHEAD = 20'h1fc00; 
parameter UARTHEAD = 28'h1fd003f;
parameter VGAHEAD = 13'b0001101100000;

input wire[31:0] masterAddr_i;
input wire masterRd_i, masterWr_i;
input wire[3:0] masterByteEnable_i;
input wire[31:0] masterData_i;

input wire[31:0] sramData_i;
input wire[31:0] romData_i;
input wire[31:0] flashData_i;
input wire[31:0] uartData_i;

output reg[31:0] masterData_o;


output reg sramRd_o, sramWr_o;
output reg[3:0] sramByteEnable_o;
output reg[31:0] sramData_o;
output reg[SRAMADDRLEN-1:0] sramAddr_o;

output reg[ROMADDRLEN-1:0] romAddr_o;

output reg flashRd_o, flashWr_o;
output reg[3:0] flashByteEnable_o;
output reg[31:0] flashData_o;
output reg[FLASHADDRLEN-1:0] flashAddr_o;
// the lowest addr bit should be added by flash control to choose high/low 8-bit (when 8-bit mode is on)

output reg uartRd_o, uartWr_o;
output reg[31:0] uartData_o;
output reg[UARTADDRLEN-1:0] uartAddr_o;

output reg vgaRd_o, vgaWr_o;
output reg[31:0] vgaData_o;
output reg[VGAADDRLEN-1:0] vgaAddr_o;

always @(*) begin : proc_
	sramRd_o <= 1'b0;
	sramWr_o <= 1'b0;
	flashRd_o <= 1'b0;
	flashWr_o <= 1'b0;
	uartRd_o <= 1'b0;
	uartWr_o <= 1'b0;
	vgaRd_o <= 1'b0;
	vgaWr_o <= 1'b0;

	masterData_o <= 32'h0;
	
	sramAddr_o <= 22'b0;
	sramData_o <= 32'b0;
	sramByteEnable_o <= 4'b1111;
	flashAddr_o <= 24'b0;
	flashByteEnable_o <= 4'b1111;
	flashData_o <= 32'b0;
	romAddr_o <= 12'b0;
	uartAddr_o <= 4'b0000;
	uartData_o <= 32'b0;
	vgaAddr_o <= 19'b0;
	vgaData_o <= 32'b0;
    if(masterAddr_i[31:SRAMADDRLEN] == SRAMHEAD) begin
	   sramRd_o <= masterRd_i;
 	   sramWr_o <= masterWr_i;
	   sramAddr_o <= masterAddr_i[SRAMADDRLEN-1:0];
	   sramData_o <= masterData_i;
	   sramByteEnable_o <= masterByteEnable_i;
	   masterData_o <= sramData_i;
    end else if(masterAddr_i[31:FLASHADDRLEN] == FLASHHEAD) begin
       flashRd_o <= masterRd_i;
	   flashWr_o <= masterWr_i;
	   flashAddr_o <= masterAddr_i[FLASHADDRLEN-1:0];
	   flashByteEnable_o <= masterByteEnable_i;
       flashData_o <= masterData_i;
	   masterData_o <= flashData_i;
	 end else if(masterAddr_i[31:ROMADDRLEN] == ROMHEAD) begin
	   masterData_o <= romData_i;
	   romAddr_o <= masterAddr_i[ROMADDRLEN-1:0];
	 end else if(masterAddr_i[31:UARTADDRLEN] == UARTHEAD) begin
	   uartRd_o <= masterRd_i;
	   uartWr_o <= masterWr_i;
	   uartAddr_o <= masterAddr_i[UARTADDRLEN-1:0];
	   uartData_o <= masterData_i;
	   masterData_o <= uartData_i;
	 end else if(masterAddr_i[31:VGAADDRLEN] == VGAHEAD) begin
	   vgaRd_o <= masterRd_i;
	   vgaWr_o <= masterWr_i;
	   vgaAddr_o <= masterAddr_i[VGAADDRLEN-1:0];
	   vgaData_o <= masterData_i;
	 end
end


endmodule