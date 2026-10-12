`timescale 1ns / 1ps

module ClockEnableGenerator(
    input clk, reset,
    output eo_1Hz, eo_10Hz, eo_100Hz, eo_1kHz,eo_10kHz, eo_100kHz,eo_1MHz, eo_10MHz, eo_100MHz);
    
    wire tc0, tc1, tc2, tc3, tc4, tc5, tc6, tc7;
    wire [3:0] Q100M;
    
    BCDcnt_cas u0 (.TC(tc0), .inc(1'b1), .reset(reset), .clk(clk) ); //10MHz
    BCDcnt_cas u1 (.TC(tc1), .inc(tc0), .reset(reset), .clk(clk) ); //1MHz
    BCDcnt_cas u2 (.TC(tc2), .inc(tc1), .reset(reset), .clk(clk) ); //100kHz
    BCDcnt_cas u3 (.TC(tc3), .inc(tc2), .reset(reset), .clk(clk) ); //10kHz
    BCDcnt_cas u4 (.TC(tc4), .inc(tc3), .reset(reset), .clk(clk) ); //1kHz
    BCDcnt_cas u5 (.TC(tc5), .inc(tc4), .reset(reset), .clk(clk) ); //100Hz
    BCDcnt_cas u6 (.TC(tc6), .inc(tc5), .reset(reset), .clk(clk) ); //10Hz
    BCDcnt_cas u7 (.Q(Q100M), . TC(tc7), .inc(tc6), .reset(reset), .clk(clk) ); //1Hz
    
    
    assign eo_10MHz = tc0;
    assign eo_1MHz = tc1;
    assign eo_100kHz = tc2;
    assign eo_10kHz = tc3;
    assign eo_1kHz = tc4;
    assign eo_100Hz = tc5;
    assign eo_10Hz = tc6;
    assign eo_1Hz = tc7;
    
endmodule
