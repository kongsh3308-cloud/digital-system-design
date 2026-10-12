module money_counter(
    input  wire clk, rst,
    input  wire add5, add10,
    input  wire clr,
    output wire [9:0] total
);
    reg [9:0] sum;
    always @(posedge clk) begin
        if (rst)      sum <= 10'd0;
        else if (clr) sum <= 10'd0;
        else if (add5)  sum <= (sum+10'd5  > 10'd995)? 10'd995 : sum+10'd5;
        else if (add10) sum <= (sum+10'd10 > 10'd995)? 10'd995 : sum+10'd10;
    end
    assign total = sum;
endmodule
