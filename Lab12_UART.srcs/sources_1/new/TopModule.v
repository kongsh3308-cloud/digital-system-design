`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/10 13:16:26
// Design Name: 
// Module Name: UART_top
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
    input RxD,
    input clk,
    input rst,
    output [7:0] AN,
    output CA, CB, CC, CD, CE, CF, CG,
    output DP,
    output TxD
//    output error
    );
    wire error;
    wire [7:0] V;
    wire [3:0] GND;
    assign V='b00000111;
    assign ground='b000;
    wire [7:0] line;
    wire new;
    
    UART_top u1 (
    .clk(clk),
    .rst(rst),
    .datain_ext(line), // TxD         ۽     Data
    .dataout_ext(line), // RxD           ŵ  Data
    .new_in(new), // UART      ο  data       
    .new_out(new), // PC     UART           ο       Ͱ      
    .error(error),
    .RxD(RxD),
    .TxD(TxD)
    );
    
    ss_drive u2 (
    .clk(clk),
    .rst(rst),
    .data7(GND),
    .data6(GND),
    .data5(GND),
    .data4(GND),
    .data3(GND),
    .data2(GND),
    .data1(line[7:4]),
    .data0(line[3:0]),
	.mask(V),
    .ssA(CA),
    .ssB(CB),
    .ssC(CC),
    .ssD(CD),
    .ssE(CE),
    .ssF(CF),
    .ssG(CG),
    .ssDP(DP),
    .AN7(AN[7]),
    .AN6(AN[6]),
    .AN5(AN[5]),
    .AN4(AN[4]),
    .AN3(AN[3]),
    .AN2(AN[2]),
    .AN1(AN[1]),
    .AN0(AN[0])
    );
    
endmodule