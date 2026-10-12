`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/15 21:58:42
// Design Name: 
// Module Name: tb_TrafficLightController
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


module tb_TrafficLightController();
    // Testbench             ȣ     
    reg clk;
    reg reset;
    reg button;
    wire LED16_R, LED16_G, LED16_B;  // fwy      LED    
    wire LED17_R, LED17_G, LED17_B;  // hwy      LED    

    // DUT (Device Under Test)  ν  Ͻ ȭ
    TrafficLightController uut (
        .LED16_R(LED16_R), .LED16_G(LED16_G), .LED16_B(LED16_B),
        .LED17_R(LED17_R), .LED17_G(LED17_G), .LED17_B(LED17_B),
        .reset(reset), .clk(clk), .button(button)
    );

    // 10ns  ֱ    Ŭ        (100MHz)
    always #5 clk = ~clk;

    //  ʱ           ׽ Ʈ  ó       ۼ 
    initial begin
        //  ʱ    ȣ       
        clk = 0;
        reset = 1;
        button = 0;

        // 1. Reset   ȣ  ׽ Ʈ:  ʱ ȭ    ¿    LED           ʱ ȭ Ǵ    Ȯ  
        #20 reset = 0;  //          

        // 2.   ư       ׽ Ʈ (  ư                 ȭ     )
        #30 button = 1;  //   ư     
        #10 button = 0;  //   ư   

        // 3.       ð      ٽ    ư       ׽ Ʈ
        #100 button = 1;
        #10 button = 0;

        // 4.             ư   ȣ  Է  (         Ȳ  ùķ  ̼ )
        #50 button = 1;
        #5 button = 0;
        #5 button = 1;
        #5 button = 0;

        // 5.  ùķ  ̼      
        #500 $finish;
    end

    //     ͸ :  ֿ    ȣ      
    initial begin
        $monitor("Time = %0t | LED16_R = %b | LED16_G = %b | LED16_B = %b | LED17_R = %b | LED17_G = %b | LED17_B = %b", 
                  $time, LED16_R, LED16_G, LED16_B, LED17_R, LED17_G, LED17_B);
    end
endmodule
