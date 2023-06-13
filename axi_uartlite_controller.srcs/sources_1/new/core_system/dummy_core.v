`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/26 14:29:03
// Design Name: 
// Module Name: dummy_core
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
`include "core_inst.vh"
`include "memory_map.vh"

module dummy_core(
    input CLK,
    input RST,
    input CE,
    input [7:0]RDATA,
    output [7:0]WDATA,
    output [31:0]ADDR,
    output WE
    
    );
    
    reg [1:0]prog_stat;
    reg [31:0]addr;
    reg [31:0]data;
    reg we;
    
    assign ADDR = addr;
    assign WDATA = data;
    assign WE = we;
    
    always @(posedge CLK)begin
        if(RST == 0)begin
            prog_stat <= `READ_RX_FIFO_STATE;
            addr <= `UART_STAT_REG;
            data <= 0;
            we <= 0;
        end
        else if(CE == 1)begin
            case(prog_stat)
                `READ_RX_FIFO_STATE : begin
                    if (RDATA[0] ==1)begin      // Rx_FIFO receive valid data
                        addr <= `UART_READ_FIFO;
                        prog_stat <= `READ_RX_FIFO;
                    end
                end
                `READ_RX_FIFO : begin
                    addr <= `UART_STAT_REG;
                    prog_stat <= `READ_TX_FIFO_STATE;
                    data <= RDATA;
                end
                `READ_TX_FIFO_STATE : begin
                    if (RDATA[3] != 1)begin     // Tx_FIFO is not full
                        addr <= `UART_WRITE_FIFO;
                        prog_stat <= `WRITE_TX_FIFO;
                        we <= 1;
                    end
                end
                `WRITE_TX_FIFO : begin
                    prog_stat <= `READ_RX_FIFO_STATE;
                    addr <= `UART_STAT_REG;
                    we <= 0;
                end
            endcase 
        end
    end
endmodule
