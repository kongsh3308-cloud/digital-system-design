`timescale 1ns / 1ps

// 24-bit "decimal floating" add/sub
// op1 = value1 * 10^{-dp1}, op2 = value2 * 10^{-dp2}
// sub = 0 : op1 + op2
// sub = 1 : op1 - op2
module float_addsub_dec24(
    input  wire signed [23:0] op1,
    input  wire signed [23:0] op2,
    input  wire [2:0]         dp1,   // op1 소수자리 수 (0~3 정도)
    input  wire [2:0]         dp2,   // op2 소수자리 수
    input  wire               sub,   // 0: +, 1: -

    output reg  signed [23:0] result,
    output reg  [2:0]         res_dp,
    output reg                overflow
);
    integer i;
    reg signed [31:0] v1, v2, sum;
    reg signed [31:0] tmp;
    reg [2:0]         s;    // 공통 소수 자리수
    reg [2:0]         d1, d2;
    reg [2:0]         dp;

    // v * 10^d (d = 0,1,2,3)
    function signed [31:0] scale10;
        input signed [23:0] v;
        input [2:0] d;
        reg signed [31:0] tmpv;
        begin
            tmpv = v;
            case (d)
                3'd0: scale10 = tmpv;
                3'd1: scale10 = tmpv * 10;
                3'd2: scale10 = tmpv * 100;
                3'd3: scale10 = tmpv * 1000;
                3'd4: scale10 = tmpv *10000;
                default: scale10 = 32'sd0;
            endcase
        end
    endfunction

    always @* begin
        overflow = 1'b0;
        result   = 24'sd0;
        res_dp   = 3'd0;

        // 둘 다 정수이면 그냥 정수 덧셈/뺄셈 모드
        if (dp1 == 3'd0 && dp2 == 3'd0) begin
            sum    = sub ? (op1 - op2) : (op1 + op2);
            if (sum > 32'sd8388607 || sum < -32'sd8388608) begin
                overflow = 1'b1;
                result   = 24'sd0;
                res_dp   = 3'd0;
            end else begin
                result = sum[23:0];
                res_dp = 3'd0;
            end
        end else begin
            // 공통 소수 자리수 = max(dp1, dp2)
            s  = (dp1 > dp2) ? dp1 : dp2;
            d1 = s - dp1;
            d2 = s - dp2;

            v1 = scale10(op1, d1);
            v2 = scale10(op2, d2);
            if (sub)
                v2 = -v2;

            sum = v1 + v2;

            // 24-bit signed 범위 체크
            if (sum > 32'sd8388607 || sum < -32'sd8388608) begin
                overflow = 1'b1;
                result   = 24'sd0;
                res_dp   = 3'd0;
            end else begin
                // 뒤에 0 많이 붙으면 나눠서 정규화 (최대 3번)
                tmp = sum;
                dp  = s;
                for (i = 0; i < 4; i = i+1) begin
                    if ((tmp % 10 == 0) && (dp > 0)) begin
                        tmp = tmp / 10;
                        dp  = dp - 1;
                    end
                end

                if (tmp > 32'sd8388607 || tmp < -32'sd8388608) begin
                    overflow = 1'b1;
                    result   = 24'sd0;
                    res_dp   = 3'd0;
                end else begin
                    result = tmp[23:0];
                    res_dp = dp;
                end
            end
        end
    end

endmodule
