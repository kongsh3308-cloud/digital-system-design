`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/14 10:51:34
// Design Name: 
// Module Name: TrafficLightController
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
    output LED16_B, LED16_G, LED16_R , 
    output LED17_B, LED17_G, LED17_R,
    input reset, clk, button);
    
    wire x;
    wire en_10MHz, en_100MHz;
    wire [1:0] hwy, fwy;
    
    ClockEnableGenerator c0( .clk(clk), .reset(reset), .eo_10MHz(en_10MHz), .eo_100MHz(en_100MHz) );
    Debounce_Pulse_Generator d0( .clk(clk), .reset(reset), .en(en_10MHz), .button(button), .x(x) );
    TLC_FSM t0( .hwy(hwy), .fwy(fwy), .x(x), .clk(clk), .en(en_10MHz), .reset(reset) );
    ColorLedDriver f0( .LED_R(LED16_R), .LED_G(LED16_G), .LED_B(LED16_B), .color(fwy) );  //fwy
    ColorLedDriver h0( .LED_R(LED17_R), .LED_G(LED17_G), .LED_B(LED17_B), .color(hwy) );  //hwy
    
endmodule
