`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/22 11:11:37
// Design Name: 
// Module Name: watch_1Mz
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


module TopModule(
    output CA, CB, CC, CD, CE, CF, CG, DP,
    output [7:0] AN,
    input clk, reset);
    
    wire en;
    wire [3:0] Q;
    wire a,b,c,d,e,f,g;
    
    BCDcnt_cas cnt(.Q(Q), .TC(), .inc(en), .reset(reset), .clk(clk) );
    cnt_100M div(.clk(clk), .reset(reset), .eo_100M(en) );
    
    assign AN = 8'b1111_1110;
    assign DP = 1'b1;
    
    sevensegmentdecoder ssd(.a(CA), .b(CB), .c(CC), .d(CD), .e(CE), .f(CF), .g(CG), .data(Q) );
    
endmodule
