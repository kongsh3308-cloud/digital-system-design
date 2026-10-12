`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/09
// Design Name: 
// Module Name: ss_displaydriver (Top Module)
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Drives a 7-segment display for the stopwatch and instantiates
//              the watchcore to count time.
// 
//////////////////////////////////////////////////////////////////////////////////

module ss_displaydriver(
    input clk, reset, btn_in,
    output reg [6:0] seg,    // a-g segments of 7-segment display
    output reg [7:0] an     // 8-digit anodes
    );

    wire [3:0] sec_ones, sec_tens, min;
    wire pulse_out;

    // Debounce and Pulse Generation for button input
    wire btn_debounced;

    debounce u_debounce (
        .clk(clk),
        .reset(reset),
        .btn_in(btn_in),
        .btn_out(btn_debounced)
    );

    pulse_generator u_pulse_gen (
        .clk(clk),
        .reset(reset),
        .btn_in(btn_debounced),
        .pulse_out(pulse_out)
    );

    // Instantiate the watchcore
    WatchCore u_WatchCore (
        .clk(clk),
        .reset(reset),
        .inc(pulse_out),
        .sec_ones(sec_ones),
        .sec_tens(sec_tens),
        .min(min)
    );

    reg [3:0] current_digit;
    reg [2:0] digit_select; // Selects which digit to display

    // Select current digit to display
    always @(*) begin
        case (digit_select)
            3'b000: current_digit = sec_ones;
            3'b001: current_digit = sec_tens;
            3'b010: current_digit = min;
            default: current_digit = 4'd0;
        endcase
    end

    // BCD to 7-segment conversion
    always @(*) begin
        case (current_digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0010000;
            default: seg = 7'b1111111;
        endcase
    end

    // 7-segment digit selection
    always @(posedge clk) begin
        if (reset)
            digit_select <= 3'b000;
        else
            digit_select <= digit_select + 1;

        an <= 8'b11111111;
        an[digit_select] <= 0; // Activate the current digit's anode
    end
endmodule
