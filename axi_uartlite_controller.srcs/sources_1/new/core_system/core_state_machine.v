`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/27 18:29:48
// Design Name: 
// Module Name: core_state_machine
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
`include "memory_map.vh"
`include "cpu_state.vh"
`include "io_simplebus.vh"

module core_state_machine(
    input CLK,  // cpu core ‚Ì”½“]CLK
    input RST,
    input [1:0]CMD,
    input [1:0]STATE,
    output CE
    );
    
    reg [1:0]cpu_state;
    
    assign CE = cpu_state[1];
    
    always @(posedge CLK) begin
        if(RST == 0)
            cpu_state = `CPU_IDLE;
        else if(CMD == `READ && STATE != `READ_DONE)
            cpu_state =`CPU_READ_WAIT;
        else if(CMD == `WRITE && STATE != `WRITE_DONE)
            cpu_state = `CPU_WRITE_WAIT;
        else
            cpu_state = `CPU_ACTIVE;
    end
            
endmodule
