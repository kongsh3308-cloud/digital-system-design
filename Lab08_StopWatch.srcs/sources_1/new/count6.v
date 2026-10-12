`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/10 09:50:06
// Design Name: 
// Module Name: count6
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


module count6(
    input clk, reset, inc,
    output TC,
    output reg [2:0]Q
    );
    always@(posedge clk) begin
    if(reset) Q=3'b000;
    else if(inc) if(Q==5) Q=4'b000; else Q=Q+1;
    else Q=Q;
    end
    
    assign TC=(inc==1)?((Q==5)? 1:0):0;
endmodule
