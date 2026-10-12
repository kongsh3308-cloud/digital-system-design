`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/22 14:38:01
// Design Name: 
// Module Name: cnt_100M
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


module cnt_100M(
    input clk, reset,
    output eo_100M);
    
    wire tc0, tc1, tc2, tc3, tc4, tc5, tc6, tc7;
    wire [3:0] Q100M;
    
    BCDcnt_cas u0 (.TC(tc0), .inc(1'b1), .reset(reset), .clk(clk) );
    BCDcnt_cas u1 (.TC(tc1), .inc(tc0), .reset(reset), .clk(clk) );
    BCDcnt_cas u2 (.TC(tc2), .inc(tc1), .reset(reset), .clk(clk) );
    BCDcnt_cas u3 (.TC(tc3), .inc(tc2), .reset(reset), .clk(clk) );
    BCDcnt_cas u4 (.TC(tc4), .inc(tc3), .reset(reset), .clk(clk) );
    BCDcnt_cas u5 (.TC(tc5), .inc(tc4), .reset(reset), .clk(clk) );
    BCDcnt_cas u6 (.TC(tc6), .inc(tc5), .reset(reset), .clk(clk) );
    BCDcnt_cas u7 (.Q(Q100M), . TC(tc7), .inc(tc6), .reset(reset), .clk(clk) );
    
    
    assign eo_100M = tc7;
    
endmodule
