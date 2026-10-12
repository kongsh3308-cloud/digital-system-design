`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/24 09:57:14
// Design Name: 
// Module Name: counter_1to6
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
module counter_1to6(input clk, rst, inc, output reg [2:0] Q, output tc);

always @(posedge clk)
  if(rst)
     Q <= 3'b001;
  else if(inc) begin
     Q <= Q + 1;
     if(Q == 3'b110)
        Q <= 3'b001;
   end
assign tc = (Q == 3'b110 && inc)?1:0;
     
endmodule