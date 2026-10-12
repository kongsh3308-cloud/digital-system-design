`timescale 1ns / 1ps

module debounce_pulse (
    input clk,
    input reset,
    input btn,
    input en,
    output reg pulse
);
    reg [2:0] shift_reg;
    
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 3'b000;
        else if(en)
            shift_reg <= {shift_reg[1:0], btn};
    end
    
    always @(posedge clk) begin
        if (reset)
            pulse <= 0;
        else
            pulse <= (shift_reg[2:1] == 2'b01);
    end
endmodule
