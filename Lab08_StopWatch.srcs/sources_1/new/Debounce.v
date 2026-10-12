`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/9
// Design Name: 
// Module Name: debounce
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Removes chattering from the button signal
// 
//////////////////////////////////////////////////////////////////////////////////

module debounce(
    input clk, reset, btn_in,
    output reg btn_out
    );
    
    reg [15:0] debounce_counter;
    reg btn_sync;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            debounce_counter <= 0;
            btn_sync <= 0;
            btn_out <= 0;
        end else if (btn_in != btn_sync) begin
            btn_sync <= btn_in;
            debounce_counter <= 0;
        end else if (debounce_counter < 16'hFFFF) begin
            debounce_counter <= debounce_counter + 1;
        end else begin
            btn_out <= btn_sync;
        end
    end
endmodule
