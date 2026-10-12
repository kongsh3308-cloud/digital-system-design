`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/14 18:48:55
// Design Name: 
// Module Name: tb_TLC_FSM
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
`define YELLOW 2'd0
`define RED 2'd1
`define GREEN 2'd2

// state assignment defintion
`define s0 2'b00
`define s1 2'b01
`define s2 2'b10
`define s3 2'b11

module tb_TLC_FSM( );
    reg clk=0;
    reg reset, x;
    wire en;
    wire [1:0] hwy, fwy;
    
    TLC_FSM tlc(.hwy(hwy), .fwy(fwy), .x(x), .clk(clk), .reset(reset), .en(en) );
    initial forever #5 clk = ~clk;
    assign en = 1'b1;
    initial begin
        reset = 1;
        #10 reset = 0; x = 1;
        #40 x = 0;
        #20 x =1;
        #10 reset = 1;
        #10 reset = 0;
        #20 $stop;
    end
endmodule
