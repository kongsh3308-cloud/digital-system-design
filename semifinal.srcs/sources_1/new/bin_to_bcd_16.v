module bin_to_bcd_16(
    input  wire [16:0] bin,   // 0 ~ 99999 (17bit)
    output reg  [3:0]  bcd0,
    output reg  [3:0]  bcd1,
    output reg  [3:0]  bcd2,
    output reg  [3:0]  bcd3,
    output reg  [3:0]  bcd4
);
    reg [16:0] tmp;

    always @(*) begin
        tmp  = bin;

        bcd0 = tmp % 10;
        tmp  = tmp / 10;
        bcd1 = tmp % 10;
        tmp  = tmp / 10;
        bcd2 = tmp % 10;
        tmp  = tmp / 10;
        bcd3 = tmp % 10;
        tmp  = tmp / 10;
        bcd4 = tmp % 10;
    end
endmodule
