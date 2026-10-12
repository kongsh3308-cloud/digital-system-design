`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/14 09:48:25
// Design Name: 
// Module Name: TLC_FSM
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

// traffic light definition
`define YELLOW 2'd0
`define RED 2'd1
`define GREEN 2'd2

// state assignment defintion
`define s0 2'b00
`define s1 2'b01
`define s2 2'b10
`define s3 2'b11

module TLC_FSM( output reg [1:0] hwy, fwy,
    input x, clk, reset, en);
    
    reg [1:0] c_state, n_state; // state variable
    
    // asynchronous version
    always @(posedge clk) begin
        if (reset) 
            c_state = `s0;
        else if(en)
            c_state = n_state;
    end
        
     always @(c_state or x) begin
        case(c_state)
            `s0: if(x) n_state = `s1; else n_state = `s0;
            `s1: n_state = `s2;
            `s2: if(x) n_state = `s3; else n_state = `s2;
            `s3: n_state = `s0;
            default: n_state = `s0;
        endcase
    end
       
    always @(c_state) begin
        case(c_state)
            `s0: begin hwy = `GREEN; fwy = `RED; end
            `s1: begin hwy = `YELLOW; fwy = `RED; end
            `s2: begin hwy = `RED; fwy = `GREEN; end
            `s3: begin hwy = `RED; fwy = `YELLOW; end
        endcase
    end
endmodule
