`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/10 10:28:48
// Design Name: 
// Module Name: pulse_debounce
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


module pulse_debounce(
    input clk, reset,en,
    input button,
    output sig//signal
    );
    reg Q1, Q2, Q3;
    always@(posedge clk, posedge reset)
    if(reset)
        Q1<=0;
    else if(en)
        Q1<=button;
    
    always@(posedge clk, posedge reset)
    if(reset) begin
        Q2<=0;
        Q3<=0;
    end else begin
        Q2<=Q1;
        Q3<=Q2;
    end     
    
    assign sig =~Q3 & Q2;
endmodule
