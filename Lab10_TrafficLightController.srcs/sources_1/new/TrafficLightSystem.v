//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 2025/10/16 03:24:05
//// Design Name: 
//// Module Name: TrafficLightSystem
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


//module TrafficLightSystem(
//    input clk, reset,         // Ŭ           Է 
//    input button,               // BTND   ư (               )
//    output LED16_B, LED16_G, LED16_R, 
//    output LED17_B, LED17_G, LED17_R
//);

//    wire x;          //   ٿ     ư   ȣ
//    wire en10Hz, en_10MHz, en_100MHz;     // 10Hz Ŭ    ο  ̺  (  ȣ   ȯ  ӵ      )
//    wire [1:0] hwy, fwy;  //        ȣ     

//    // 10Hz   ȣ      (ClockEnableGenerator    )
//    ClockEnableGenerator clk_gen (
//        .clk(clk), 
//        .reset(reset), 
//        .eo_10Hz(en_10Hz), 
//        .eo_100Hz(), .eo_1kHz(), .eo_10kHz(), .eo_100kHz(), 
//        .eo_1MHz(), .eo_10MHz(en_10MHz), .eo_100MHz(en_100MHz)
//    );
    
//    //   ư   ȣ     ȭ
//    reg button_sync1, button_sync2;
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            button_sync1 <= 0;
//            button_sync2 <= 0;
//        end else begin
//            button_sync1 <= button;
//            button_sync2 <= button_sync1;
//        end
//    end
    
//    wire button_stable = button_sync2;

//    //   ư  Է    ٿ ó       ޽      
//    Debounce_Pulse_Generator debounce (
//        .clk(clk), 
//        .reset(reset), 
//        .en(en_10Hz),  // 10Hz     ư  Է  Ȯ  
//        .button(button_stable), 
//        .x(x)
//    );

//    //        ȣ      FSM
//    TLC_FSM traffic_fsm (
//        .hwy(hwy), 
//        .fwy(fwy), 
//        .x(x), 
//        .clk(clk), 
//        .reset(reset), 
//        .en(en_10Hz)  // 10Hz  ֱ          ȯ
//    );
    
//    assign LED16_R = x;  //   ư         Ȯ ο     


////     LED      :   ӵ      ȣ   °      
////    ColorLedDriver led_hwy (
////        .LED_R(LED17_R), 
////        .LED_G(LED17_G), 
////        .LED_B(LED17_B), 
////        .color(hwy)  //   ӵ      ȣ        LED          
////    );
    
////    ColorLedDriver led_fwy (
////        .LED_R(LED16_R), 
////        .LED_G(LED16_G), 
////        .LED_B(LED16_B), 
////        .color(fwy)  //       ȣ        LED          
////    );

//endmodule

