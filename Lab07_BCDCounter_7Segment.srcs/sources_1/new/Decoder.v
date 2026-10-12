`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/29 09:40:24
// Design Name: 
// Module Name: Decoder
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


module Decoder( input [2:0] Q, output reg [7:0] enable);

//always @* begin
//    case(Q)
//        3'b000: enable = -8'b0000_0001;
//        3'b001: enable = -8'b0000_0010;
//        3'b010: enable = -8'b0000_0100;
//        3'b011: enable = -8'b0000_1000;
//        3'b100: enable = -8'b0001_0000;
//        3'b101: enable = -8'b0010_0000;
//        3'b110: enable = -8'b0100_0000;
//        default: enable = -8'b1000_0000;        // 3'd7   default
//    endcase
//end

always @* begin
    case(Q)
        3'b000: enable = 8'b1111_1110;  
        3'b001: enable = 8'b1111_1101;  
        3'b010: enable = 8'b1111_1011;  
        3'b011: enable = 8'b1111_0111;  
        3'b100: enable = 8'b1110_1111;  
        3'b101: enable = 8'b1101_1111;  
        3'b110: enable = 8'b1011_1111;  
        default: enable = 8'b0111_1111; 
    endcase
end
endmodule
