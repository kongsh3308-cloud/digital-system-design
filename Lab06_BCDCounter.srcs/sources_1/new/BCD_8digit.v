`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/22 10:24:03
// Design Name: 
// Module Name: BCD_8digit
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


module BCD_3digit(
    output [3:0] Q0, Q1, Q2,
    output TC,
    input inc, rstn, clk);
    
    wire tc1, tc2;
    
    BCDcnt_cas CNT0(Q0, tc1, inc, rstn, clk);
    BCDcnt_cas CNT1(Q2, tc2, tc1, rstn, clk);
    BCDcnt_cas CNT2(Q2, TC, tc2, rstn, clk);
    
endmodule
