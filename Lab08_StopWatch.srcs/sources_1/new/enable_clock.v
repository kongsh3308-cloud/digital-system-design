`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/10 10:21:25
// Design Name: 
// Module Name: enable_clock
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


module enable_clock(
    input clk, reset,
    output TC_1M
    );
    wire [2:0] tc;
    bcd u0( clk, reset, 1'b1, tc[0], );
    bcd u1( clk, reset, tc[0], tc[1], );
    bcd u2( clk, reset, tc[1], tc[2], );
    bcd u3( clk, reset, tc[2], TC_1M, );
endmodule