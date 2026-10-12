`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/10 10:19:53
// Design Name: 
// Module Name: count_1M
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


module count_1M(
input clk, reset,
    output TC_1M
    );
    wire [4:0] tc;
    
    bcd u0( clk, reset, 1'b1, tc[0], );
    bcd u1( clk, reset, tc[0], tc[1], );
    bcd u2( clk, reset, tc[1], tc[2], );
    bcd u3( clk, reset, tc[2], tc[3], );
    bcd u4( clk, reset, tc[3], tc[4], );
    bcd u5( clk, reset, tc[4], TC_1M, );
   
endmodule