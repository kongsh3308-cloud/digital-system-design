
`timescale 1ns / 1ps

// 24-bit signed ALU ( +, -, *, / )
//  - 2's complement 음수 지원
//  - overflow는 "진짜" signed overflow만 잡음 (1-3 같은 건 정상)
module alu16_comb(
    input  wire signed [23:0] op1,
    input  wire signed [23:0] op2,
    input  wire [1:0]  operator,   // 00:+, 01:-, 10:*, 11:/
    
    output reg  signed [23:0] result,
    output reg         overflow,
    output reg         div_zero,
    output reg         error
);
    reg signed [24:0] add_tmp;
    reg signed [24:0] sub_tmp;
    reg signed [47:0] mul_tmp;

    reg sign1, sign2, signr;

    always @* begin
        result   = 24'sd0;
        overflow = 1'b0;
        div_zero = 1'b0;

        case (operator)
            2'b00: begin // +
                add_tmp = op1 + op2;
                result  = add_tmp[23:0];

                sign1   = op1[23];
                sign2   = op2[23];
                signr   = result[23];
                // 두 피연산자 부호 같고, 결과 부호가 다르면 overflow
                overflow = (sign1 == sign2) && (signr != sign1);
            end

            2'b01: begin // -
                sub_tmp = op1 - op2;
                result  = sub_tmp[23:0];

                sign1   = op1[23];
                sign2   = op2[23];
                signr   = result[23];
                // 뺄셈 overflow: op1,op2 부호 다르고 결과 부호가 op1과 다를 때
                overflow = (sign1 != sign2) && (signr != sign1);
            end

            2'b10: begin // *
                mul_tmp = op1 * op2;
                result  = mul_tmp[23:0];

                // 상위 비트가 전부 sign-extension이 아니면 overflow
                if (mul_tmp[47:24] != {24{mul_tmp[23]}})
                    overflow = 1'b1;
            end

            2'b11: begin // /
                if (op2 == 24'sd0) begin
                    div_zero = 1'b1;
                    result   = 24'sd0;
                end else begin
                    result   = op1 / op2;
                end
            end

            default: begin
                result = 24'sd0;
            end
        endcase

        error = overflow | div_zero;
    end

endmodule
