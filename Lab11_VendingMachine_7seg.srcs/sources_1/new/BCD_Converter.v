`timescale 1ns / 1ps

module BCD_Converter (
    input [7:0] binary,
    output reg [3:0] hundreds,
    output reg [3:0] tens,
    output reg [3:0] ones
);
    integer i;
    always @(binary) begin
        // Initialize BCD digits
        hundreds = 4'd0;
        tens = 4'd0;
        ones = 4'd0;

        // Binary to BCD conversion by shifting and adding
        for (i = 7; i >= 0; i = i - 1) begin
            // Shift the digits left by 1
            if (hundreds >= 5) hundreds = hundreds + 3;
            if (tens >= 5) tens = tens + 3;
            if (ones >= 5) ones = ones + 3;

            // Shift the binary input into ones place
            hundreds = hundreds << 1;
            hundreds[0] = tens[3];
            tens = tens << 1;
            tens[0] = ones[3];
            ones = ones << 1;
            ones[0] = binary[i];
        end
    end
endmodule

