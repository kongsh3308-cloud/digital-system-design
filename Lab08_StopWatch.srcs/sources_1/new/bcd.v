`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/30 15:38:50
// Design Name: 
// Module Name: bcd
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


module bcd(
    input clk, reset, inc,
    output TC,
    output reg [3:0]Q
    );
    always@(posedge clk) begin
    if(reset) Q=4'b0000;
    else if(inc) if(Q==9) Q=4'b0000; else Q=Q+1;
    else Q=Q;
    end
    
    assign TC=(inc==1)?((Q==9)? 1:0):0;
endmodule
