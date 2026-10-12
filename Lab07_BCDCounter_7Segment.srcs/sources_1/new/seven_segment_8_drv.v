`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/29 10:01:46
// Design Name: 
// Module Name: seven_segment_8_drv
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


module seven_segment_8_drv(
    input [3:0] D0, D1, D2, D3, D4, D5, D6, D7,
    input clk, reset,
    output a,b,c,d,e,f,g,
    output [7:0] AN);
    
    wire [3:0] Y;
    wire [2:0] sel;
    wire en_cnt3;

    mux81 seg_u0 (.D0(D0), .D1(D1), .D2(D2), .D3(D3), .D4(D4), .D5(D5), .D6(D6), .D7(D7), .sel(sel), .Y(Y) ); 
    cnt3 seg_u1 (.clk(clk), .reset(reset), .en(en_cnt3), .Q(sel) );
    sevensegmentdecoder seg_u2 (.a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .data(Y) );
    Decoder seg_u3 (.Q(sel), .enable(AN) );
    cnt_100M seg_u4 (.clk(clk), .reset(reset), .eo_1K(), .eo_100K(en_cnt3), .eo_100M() );
    
endmodule
