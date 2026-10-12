`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/10 10:29:15
// Design Name: 
// Module Name: swatch_control
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


module swatch_control(
    input clk,reset, sw, output en
    );
    localparam S0 =1'b0, S1 = 1'b1;
    reg state;
    reg n_state;
    always@(posedge clk, posedge reset)
        if(reset)
         state = S0;
        else
         state = n_state;
    
    always@*
    case(state)
    S0: if(sw==0) n_state = S0; else n_state = S1;
    S1: if(sw==0) n_state = S1; else n_state = S0;
    endcase
    
    assign en = (state==S0)? 1:0;
    
endmodule
