module sync_pulse(
    input  wire clk, rst,
    input  wire din,
    output reg  pulse
);
    reg a, y, b;
    always @(posedge clk) begin
        if (rst) begin a<=0; y<=0; b<=0; pulse<=0; end
        else begin
            a <= din;       // 1
            y <= a;         // 2
            b <= y;         // 이전 y 보관
            pulse <= y & ~b; 
        end
    end
endmodule
