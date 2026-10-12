`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/14 09:34:58
// Design Name: 
// Module Name: debounce_pulse_gen
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

module Debounce_Pulse_Generator(
    input clk, reset, en,
    input button,
    output x    //signal
    );
    reg Q1, Q2, Q3;

    always @(posedge clk) begin
        if (reset) 
            Q1 <= 0;  
        else if (en) 
            Q1 <= button;
    end

    always @(posedge clk) begin
        if (reset) begin  
            Q2 <= 0;
            Q3 <= 0;
        end else if(en) begin
            Q2 <= Q1;
            Q3 <= Q2;
        end
    end
    
    assign x =~Q3 & Q2;
    
    
endmodule
