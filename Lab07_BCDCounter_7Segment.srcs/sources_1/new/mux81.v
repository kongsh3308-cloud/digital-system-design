`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/29 10:38:58
// Design Name: 
// Module Name: mux81
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


module mux81(
    input [3:0] D0, D1, D2, D3, D4, D5, D6, D7,
    input [2:0] sel,
    output reg [3:0] Y);
    
    always @(*)
        case(sel)
            3'd0: Y=D0;
            3'd1: Y=D1;
            3'd2: Y=D2;
            3'd3: Y=D3;
            3'd4: Y=D4;
            3'd5: Y=D5;
            3'd6: Y=D6;
            default: Y=D7;
        endcase
endmodule
