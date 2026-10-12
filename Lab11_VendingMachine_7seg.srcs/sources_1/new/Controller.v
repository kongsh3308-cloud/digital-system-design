`timescale 1ns / 1ps

module Controller (
    input clk,
    input reset,
    input en,
    input coin_50_pulse,
    input coin_100_pulse,
    output reg [2:0] state
);

    localparam IDLE = 3'b000;
    localparam S_50 = 3'b001;
    localparam S_100 = 3'b010;
    localparam S_150 = 3'b011;
    localparam S_200 = 3'b100;

    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else if (en) begin
            case (state)
                IDLE: begin
                    if (coin_50_pulse)
                        state <= S_50;
                    else if (coin_100_pulse)
                        state <= S_100;
                end
                S_50: begin
                    if (coin_50_pulse)
                        state <= S_100;
                    else if (coin_100_pulse)
                        state <= S_150;
                end
                S_100: begin
                    if (coin_50_pulse)
                        state <= S_150;
                    else if (coin_100_pulse)
                        state <= S_200;
                end
                S_150: state <= IDLE;  // dispense = 1, remain = 0
                S_200: state <= IDLE;  // dispense = 1, remain = 1
                default: state <= IDLE;
            endcase
        end
    end
endmodule

