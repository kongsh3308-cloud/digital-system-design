`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/24 09:51:36
// Design Name: 
// Module Name: ps2_example
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

module TopModule (
	input         clk,
	input         rst,
	input         ps2clk,
	input         ps2data,
	output [6:0] sseg,
	output        ssDP,
	output [7:0] AN
	);
		
wire [7:0] scancode;
wire err_ind;
wire clk_50;
wire clk_100;

ps2_kbd_top ps2_kbd (
    .clk(clk_50), 
    .rst(rst), 
    .ps2clk(ps2clk), 
    .ps2data(ps2data), 
    .scancode(scancode), 
    .Released(Released), 
    .err_ind(err_ind)
    );
	 
ss_drive ss_drive (
    .clk(clk_100), 
    .rst(rst), 
    .data7(), 
    .data6(), 
    .data5(),
    .data4(),
    .data3(),
    .data2(),
    .data1(scancode[7:4]), 
    .data0(scancode[3:0]), 
    .mask(8'b0000_0011), 
    .ssA(sseg[0]), 
    .ssB(sseg[1]), 
    .ssC(sseg[2]), 
    .ssD(sseg[3]), 
    .ssE(sseg[4]), 
    .ssF(sseg[5]),  
    .ssG(sseg[6]), 
    .ssDP(ssDP), 
    .AN7(AN[7]), 
    .AN6(AN[6]), 
    .AN5(AN[5]), 
    .AN4(AN[4]),
    .AN3(AN[3]), 
    .AN2(AN[2]), 
    .AN1(AN[1]), 
    .AN0(AN[0])
    );
    
    
    
    clk_wiz_0 clk_core
   (
    // Clock out ports
    .clk_out1(clk_100),     // output clk_out1
    .clk_out2(clk_50),     // output clk_out2
    // Status and control signals
    .reset(rst), // input reset
    .locked(),       // output locked
   // Clock in ports
    .clk_in1(clk));      // input clk_in1
    
endmodule

