`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/29 10:36:20
// Design Name: 
// Module Name: cnt3
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


module cnt3(
    input clk, reset, en,
    output reg [2:0] Q);
    
    always @(posedge clk)
        if(reset)
            Q <= 3'd0;
        else if(en)
            Q <= Q+1;
endmodule
