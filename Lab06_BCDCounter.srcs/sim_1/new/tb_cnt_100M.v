`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/22 14:44:23
// Design Name: 
// Module Name: tb_cnt_100M
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


module tb_cnt_100M();

    reg clk;
    reg rstn;
    wire eo_100M;
    
    cnt_100M uut( .clk(clk), .rstn(rstn), .eo_100M(eo_100M) );
    
    always #1 clk = ~clk;
    initial begin
        rstn = 0;
        clk = 0;
        #2 rstn = 1;
    end
    
endmodule
