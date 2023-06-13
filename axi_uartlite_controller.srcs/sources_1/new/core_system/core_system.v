`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/29 17:55:09
// Design Name: 
// Module Name: core_system
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


module core_system(
    input CLK,
    input RST,
    input RX,
    output TX
    );
    
    wire [31:0]addr_bus;
    wire [7:0]rdata_bus;
    wire [7:0]wdata_bus;
    wire [1:0]cmd_wire;
    wire [1:0]state_wire;
    wire we_wire;
    wire ce_wire;
    wire rst_wire;
    
    chattering chattering(
        .clk_in(CLK),
        .switch_in(RST),
        .switch_out(rst_wire)
    );
    
    axi_uartlite_controller axi_uartlite_controler(
        .CLK(CLK),
        .RST(~rst_wire),      // rst
        .RX(RX),       // from host pc to fpga
        .TX(TX),      // from fpga to host pc
        .READ_DATA(rdata_bus),  // from uart to controller
        .WRITE_DATA(wdata_bus),   // from controller to uart
        .ADDR(addr_bus),
        .CMD(cmd_wire),
        .STATE(state_wire)
    );
    
    cpu_side_io_controller cpu_side_io_controller(
        .ADDR(addr_bus),
        .WE(we_wire),
        .CMD(cmd_wire)
	);
	
	dummy_core dummy_core(
        .CLK(CLK),
        .RST(~rst_wire),
        .CE(ce_wire),
        .RDATA(rdata_bus),
        .WDATA(wdata_bus),
        .ADDR(addr_bus),
        .WE(we_wire)
    );
    
    core_state_machine core_state_machine(
        .CLK(~CLK),  // cpu core ‚Ì”½“]CLK
        .RST(~rst_wire),
        .CMD(cmd_wire),
        .STATE(state_wire),
        .CE(ce_wire)
    );
    
endmodule
