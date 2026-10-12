`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/9
// Design Name: 
// Module Name: watchcore
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Core logic of the stopwatch, handling counts of seconds and minutes.
// 
//////////////////////////////////////////////////////////////////////////////////

module WatchCore(
    input clk, reset, inc,  // inc is the enable signal from pulse generator
    output reg [3:0] sec_ones, sec_tens, min
    );

    wire tc_sec_ones, tc_sec_tens;

    BCDcnt_cas sec_ones_cnt(
        .Q(sec_ones),
        .TC(tc_sec_ones),
        .inc(inc),
        .reset(reset),
        .clk(clk)
    );

    BCDcnt_cas sec_tens_cnt(
        .Q(sec_tens),
        .TC(tc_sec_tens),
        .inc(tc_sec_ones),
        .reset(reset),
        .clk(clk)
    );

    BCDcnt_cas min_cnt(
        .Q(min),
        .TC(),
        .inc(tc_sec_tens),
        .reset(reset),
        .clk(clk)
    );
endmodule
