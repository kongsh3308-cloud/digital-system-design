`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/24 10:25:45
// Design Name: 
// Module Name: tb_dice_core
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


module tb_dice_core();
    
reg clk, rst, roll;
wire win, lose;
wire [2:0] dice1, dice2;
 
dice_core uut (clk, rst, roll, win, lose, dice1, dice2);
 initial begin
 clk = 0;
 rst = 1;
 roll = 0;
 #2 rst = 0;
 roll = 1;
 #(2*6) roll = 0;
 #4 if(win|lose) rst =1;
 #2 rst = 0; roll = 1;
 #(2*6) roll = 0;
 #4 if(win|lose) rst = 1;
 #2 rst = 0; roll = 1;
 #(2*10) roll = 0;
 #2 rst = 0; roll = 1;
 #(2*6) roll = 0;
 #4 $finish;
 end
 always #1 clk = ~clk;
 
 
endmodule
