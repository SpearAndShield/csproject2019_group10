module uart_control (
  clk_cpu,
  masterRd_i, masterWr_i, // from bus
  writeData_i, uartAddr_i, // from bus
  rxd,  
  debug, debugData,       

  uartData_o,       // to bus
  interrupt,        // to cpu
  txd
);
parameter ClkFrequency = 50000000;  // 50MHz
parameter Baud = 115200;

input wire clk_cpu;
input wire masterRd_i;
input wire masterWr_i;
input wire[31:0] writeData_i;
input wire[3:0] uartAddr_i;
input wire rxd;
input wire debug;
input wire[7:0] debugData;

output reg[31:0] uartData_o;
output wire interrupt;
output wire txd;

reg debugWr;
always @(posedge clk_cpu)begin
  if(debug && ~ext_uart_busy) begin
      debugWr <= 1;
  end else begin
      debugWr <= 0;
  end

end // always @(posedge clk_cpu)

wire ext_uart_busy;
reg ext_uart_start;
reg[7:0] ext_uart_tx;

always @(*) begin
   if(masterWr_i && uartAddr_i == 4'h8) begin
       ext_uart_start <= 1'b1;
       ext_uart_tx <= writeData_i[7:0];
   end else if(debugWr) begin
       ext_uart_start <= 1'b1;
       ext_uart_tx <= debugData;
   end else begin
       ext_uart_start <= 1'b0;
       ext_uart_tx <= 8'bz;
   end
end


async_transmitter #(.ClkFrequency(ClkFrequency),.Baud(Baud)) 
   ext_uart_t(
       .clk(clk_cpu),                
       .TxD(txd),                      
       .TxD_busy(ext_uart_busy),      
       .TxD_start(ext_uart_start),   
       .TxD_data(ext_uart_tx)        
   );



wire ext_uart_ready;
wire ext_uart_clear;
wire[7:0] ext_uart_rx;

assign ext_uart_clear = masterRd_i && uartAddr_i == 4'h8; 
assign interrupt = ext_uart_ready;

async_receiver #(.ClkFrequency(ClkFrequency),.Baud(Baud))
   ext_uart_r(
       .clk(clk_cpu),                     
       .RxD(rxd),                          
       .RxD_data_ready(ext_uart_ready),  
       .RxD_clear(ext_uart_clear),      
       .RxD_data(ext_uart_rx)            
   );

always @(*) begin : proc_
    if(masterRd_i) begin
        if(uartAddr_i == 4'h8) begin
            uartData_o <= {24'b0, ext_uart_rx};
        end else if(uartAddr_i == 4'hc) begin
            uartData_o <= {30'b0, ext_uart_ready, ~ext_uart_busy};
        end else begin 
            uartData_o <= 32'b0;
        end
    end else begin 
        uartData_o <= 32'b0;
    end
end

endmodule