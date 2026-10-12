`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/08 10:31:48
// Design Name: 
// Module Name: Parity_Gen
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


module TopModule(
    output wire [7:0] Result, 
    input wire PRT,             // PRT  Է : ¦    и Ƽ(1)  Ǵ  Ȧ    и Ƽ(0)
    input wire [6:0] data       // 7  Ʈ         Է 
);

    // 7  Ʈ          XOR             
    wire res;
    assign res = ^data;
    
    wire parity = (PRT == 0)? res : ~res;
    
    assign Result[7:1] = data; //      7  Ʈ   data  Ҵ 
    assign Result[0] = parity;    //      1  Ʈ   parity  Ҵ 

endmodule

