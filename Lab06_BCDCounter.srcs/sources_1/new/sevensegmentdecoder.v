`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/22 11:21:58
// Design Name: 
// Module Name: sevensegmentdecoder
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


module sevensegmentdecoder(
    output reg a,b,c,d,e,f,g,
    input [3:0] data);
        
    always @(*)
    case (data)
        4'b0000: {a,b,c,d,e,f,g} = 7'b000_0001;     //0
        4'b0001: {a,b,c,d,e,f,g} = 7'b100_1111;     //1 
        4'b0010: {a,b,c,d,e,f,g} = 7'b001_0010;     //2 
        4'b0011: {a,b,c,d,e,f,g} = 7'b000_0110;     //3
        4'b0100: {a,b,c,d,e,f,g} = 7'b100_1100;     //4 
        4'b0101: {a,b,c,d,e,f,g} = 7'b010_0100;     //5 
        4'b0110: {a,b,c,d,e,f,g} = 7'b010_0000;     //6 
        4'b0111: {a,b,c,d,e,f,g} = 7'b000_1111;     //7 
        4'b1000: {a,b,c,d,e,f,g} = 7'b000_0000;     //8
        4'b1001: {a,b,c,d,e,f,g} = 7'b000_0100;     //9
        4'b1010: {a,b,c,d,e,f,g} = 7'b000_1000;     //10(a)
        4'b1011: {a,b,c,d,e,f,g} = 7'b110_0000;     //11(b)
        4'b1100: {a,b,c,d,e,f,g} = 7'b011_0001;     //12(c)
        4'b1101: {a,b,c,d,e,f,g} = 7'b100_0010;     //13(d)
        4'b1110: {a,b,c,d,e,f,g} = 7'b011_0000;     //14(e)
        4'b1111: {a,b,c,d,e,f,g} = 7'b011_1000;     //15(f)
        default: {a,b,c,d,e,f,g} = 7'b111_1111;     
    endcase
endmodule
