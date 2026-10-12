`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/15 20:38:57
// Design Name: 
// Module Name: tb_Debounce_Pulse_Generator
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

module tb_Debounce_Pulse_Generator();

    // Testbench             ȣ     
    reg clk;
    reg reset;
    reg en;
    reg button;
    wire x;

    // DUT (Device Under Test)  ν  Ͻ ȭ
    Debounce_Pulse_Generator uut (
        .clk(clk),
        .reset(reset),
        .en(en),
        .button(button),
        .x(x)
    );

    // 10ns  ֱ    Ŭ        (100MHz)
    always #5 clk = ~clk;

    //  ʱ           ׽ Ʈ  ó       ۼ 
    initial begin
        //  ʱ    ȣ     
        clk = 0;
        reset = 1;
        en = 0;
        button = 0;

        // 1. Reset   ȣ  ׽ Ʈ
        #20 reset = 0;  //          
        #10 en = 1;     // Enable   ȣ Ȱ  ȭ

        // 2.   ư       ùķ  ̼ 
        #30 button = 1;  //   ư      (button = 1)
        #20 button = 0;  //   ư      (button = 0)

        // 3.         ׽ Ʈ (ª    ð                  /    )
        #15 button = 1;
        #5 button = 0;
        #5 button = 1;
        #10 button = 0;

        // 4.  ٽ    ư       ׽ Ʈ
        #50 button = 1;
        #30 button = 0;

        // 5.  ùķ  ̼      
        #100 $finish;
    end

    //     ͸ :  ߿      ȣ     ȭ    ð     Բ     
    initial begin
        $monitor("Time = %0t | clk = %b | reset = %b | en = %b | button = %b | x = %b", 
                  $time, clk, reset, en, button, x);
    end

endmodule

