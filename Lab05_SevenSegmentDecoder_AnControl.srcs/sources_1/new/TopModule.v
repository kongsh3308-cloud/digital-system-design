`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/18 09:51:25
// Design Name: 
// Module Name: TopModule
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
    input [3:0] sw,         // 4-bit input from switches
    input [2:0] con,        // An controller
    output reg dp,          // decimal point (if used)
    output reg [6:0] seg,   // 7-segment display (active low)
    output reg [7:0] an     // anode signals (only one digit used here)
);

    // 7-segment decoder logic
    always @(*) begin
        case (sw)
            4'h0: seg = 7'b100_0000; // 0
            4'h1: seg = 7'b111_1001; // 1
            4'h2: seg = 7'b010_0100; // 2
            4'h3: seg = 7'b011_0000; // 3
            4'h4: seg = 7'b001_1001; // 4
            4'h5: seg = 7'b001_0010; // 5
            4'h6: seg = 7'b000_0010; // 6
            4'h7: seg = 7'b111_1000; // 7
            4'h8: seg = 7'b000_0000; // 8
            4'h9: seg = 7'b001_0000; // 9
            4'hA: seg = 7'b000_1000; // A
            4'hB: seg = 7'b000_0011; // B
//            4'hC: seg = 7'b010_0111; // small C (c)
            4'hC: seg = 7'b100_0110; // C
            4'hD: seg = 7'b010_0001; // D
            4'hE: seg = 7'b000_0110; // E
            4'hF: seg = 7'b000_1110; // F
            default: seg = 7'b111_1111; // default blank (all off)
        endcase
    end


    always @(*) begin
        dp = 1'b1;  // Turn off the decimal point (active low)
    end

    // Enable only the first digit of the 7-segment display
    always @(*) begin
        case(con)
    //        3'd0: an = 8'b1111_1111;
            3'd0: an = 8'b1111_1110;  // Enable the first digit (active low)
            3'd1: an = 8'b1111_1101;
            3'd2: an = 8'b1111_1011;
            3'd3: an = 8'b1111_0111;
            3'd4: an = 8'b1110_1111;
            3'd5: an = 8'b1101_1111;
            3'd6: an = 8'b1011_1111;
            3'd7: an = 8'b0111_1111;
        endcase
    end
endmodule

