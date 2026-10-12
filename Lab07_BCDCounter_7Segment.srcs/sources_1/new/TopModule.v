`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/29 10:03:47
// Design Name: 
// Module Name: top_7seg_demo
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
    input CLK100MHZ, reset, 
    output CA, CB, CC, CD, CE, CF, CG, DP, 
    output [7:0] AN);
    
    wire en;
    wire [3:0] D0, D1, D2, D3, D4, D5, D6, D7;
                
    seven_segment_8_drv u0(.clk(CLK100MHZ), .reset(reset), .D0(D0), .D1(D1), .D2(D2), .D3(D3), .D4(D4), .D5(D5), .D6(D6), .D7(D7), 
                    .a(CA), .b(CB), .c(CC), .d(CD), .e(CE), .f(CF), .g(CG), .AN(AN) );

    BCDcnt_cas cnt(.Q(D0), .TC(), .inc(en), .reset(reset), .clk(CLK100MHZ) );
    
    cnt_100M div(.clk(CLK100MHZ), .reset(reset), .eo_100M(en) );
    
    assign D1 = D0+1;
    assign D2 = D0+2;
    assign D3 = D0+3;
    assign D4 = D0+4;
    assign D5 = D0+5;
    assign D6 = D0+6;
    assign D7 = D0+7;
    assign DP = 1'b1;
    
endmodule
