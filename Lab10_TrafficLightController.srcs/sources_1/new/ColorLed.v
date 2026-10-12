`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/14 10:02:55
// Design Name: 
// Module Name: ColorLed
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

`define YELLOW 2'd0
`define RED 2'd1
`define GREEN 2'd2

module ColorLedDriver(
    output reg LED_R, LED_G, LED_B,
    input [1:0] color
);

always @(color) begin
    case(color)
        `YELLOW: begin
            LED_B = 1'b0;
            LED_G = 1'b1;
            LED_R = 1'b1;
        end
        `RED: begin
            LED_B = 1'b0;
            LED_G = 1'b0;
            LED_R = 1'b1;
        end
        `GREEN: begin
            LED_B = 1'b0;
            LED_G = 1'b1;
            LED_R = 1'b0;
        end
        default: begin
            LED_B = 1'b0;
            LED_G = 1'b0;
            LED_R = 1'b0;
        end
    endcase
end

endmodule



