`timescale 1ns / 1ps

module Datapath (
    input clk,
    input reset,
    input en,
    input [2:0] state,
    output reg dispense,
    output reg remain,
    output reg [7:0] sum
);

    localparam IDLE = 3'b000;
    localparam S_50 = 3'b001;
    localparam S_100 = 3'b010;
    localparam S_150 = 3'b011;
    localparam S_200 = 3'b100;

    always @(posedge clk) begin
        if (reset)
            sum <= 0;
        else if(en) begin
            case (state)
                IDLE: sum <= 0;  
                S_50: sum <= 50;     
                S_100: sum <= 100;    
                S_150: sum <= 150; 
                S_200: sum <= 200; 
                default: sum <= sum;
            endcase
        end
    end

    always @(*) begin
        case (state)
            S_150: begin  
                dispense = 1;
                remain = 0;
            end
            S_200: begin 
                dispense = 1;
                remain = 1;
            end
            default: begin
                dispense = 0;
                remain = 0;
            end
        endcase
    end
endmodule
