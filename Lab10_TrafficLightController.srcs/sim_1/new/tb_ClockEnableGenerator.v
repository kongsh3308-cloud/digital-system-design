`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/15 20:30:27
// Design Name: 
// Module Name: tb_ClockEnableGenerator
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

module tb_ClockEnableGenerator();

    // Testbench             ȣ     
    reg clk;
    reg reset;
    wire eo_10Hz, eo_100Hz, eo_1KHz, eo_10KHz, eo_100KHz, eo_1MHz, eo_10MHz, eo_100MHz;

    // DUT (Device Under Test)  ν  Ͻ ȭ
    ClockEnableGenerator uut (
        .clk(clk),
        .reset(reset),
        .eo_10Hz(eo_10Hz),
        .eo_100Hz(eo_100Hz),
        .eo_1KHz(eo_1KHz),
        .eo_10KHz(eo_10KHz),
        .eo_100KHz(eo_100KHz),
        .eo_1MHz(eo_1MHz),
        .eo_10MHz(eo_10MHz),  
        .eo_100MHz(eo_100MHz)
    );

    // Ŭ       : 10ns  ֱ    Ŭ   (100MHz Ŭ  )
    always #5 clk = ~clk;

    //  ʱ           ׽ Ʈ  ó       ۼ 
    initial begin
        //  ʱ    ȣ       
        clk = 0;
        reset = 1;  //  ʱ ȭ     
        #20;        //        ȣ     

        reset = 0;  //          
        #100000;    //        ð        ùķ  ̼      

        $finish;    //  ùķ  ̼      
    end

    //          ȣ       ͸  Ͽ    ȭ       
    initial begin
        $monitor("Time = %0t | eo_10Hz = %b | eo_100Hz = %b | eo_1KHz = %b | eo_10KHz = %b | eo_100KHz = %b | eo_1MHz = %b | eo_10MHz = %b | eo_100MHz = %b", 
                  $time, eo_10Hz, eo_100Hz, eo_1KHz, eo_10KHz, eo_100KHz, eo_1MHz, eo_10MHz, eo_100MHz);
    end

endmodule

