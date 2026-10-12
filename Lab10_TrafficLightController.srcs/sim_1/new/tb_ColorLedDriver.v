`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/15 21:22:08
// Design Name: 
// Module Name: tb_ColorLedDriver
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

module tb_ColorLedDriver();
    // Testbench             ȣ     
    reg [1:0] color;        //  Է :             ȣ
    wire LED_R, LED_G, LED_B;  //    : LED     

    // DUT (Device Under Test)  ν  Ͻ ȭ
    ColorLedDriver uut (
        .LED_R(LED_R),
        .LED_G(LED_G),
        .LED_B(LED_B),
        .color(color)
    );

    //  ׽ Ʈ  ó       ۼ 
    initial begin
        // 1. YELLOW  ׽ Ʈ (`color = 2'd0`)
        color = `YELLOW;
        #10;  // 10ns    
        
        // 2. RED  ׽ Ʈ (`color = 2'd1`)
        color = `RED;
        #10;  // 10ns    

        // 3. GREEN  ׽ Ʈ (`color = 2'd2`)
        color = `GREEN;
        #10;  // 10ns    

        // 4.  ùķ  ̼      
        $finish;
    end

    //     ͸ :  ֿ    ȣ        
    initial begin
        $monitor("Time = %0t | Color = %b | LED_R = %b | LED_G = %b | LED_B = %b", 
                  $time, color, LED_R, LED_G, LED_B);
    end
endmodule
