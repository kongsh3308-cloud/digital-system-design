`timescale 1ns/1ps

module tb_float_addsub_dec24_1;

    // inputs
    reg  signed [23:0] op1, op2;
    reg  [2:0]         dp1, dp2;
    reg                sub;

    // outputs
    wire signed [23:0] result;
    wire [2:0]         res_dp;
    wire               overflow;

    // DUT
    float_addsub_dec24 dut (
        .op1(op1), .op2(op2),
        .dp1(dp1), .dp2(dp2),
        .sub(sub),
        .result(result),
        .res_dp(res_dp),
        .overflow(overflow)
    );

    // 10^d (d<=4) 계산용
    function integer pow10;
        input integer d;
        begin
            case (d)
                0: pow10 = 1;
                1: pow10 = 10;
                2: pow10 = 100;
                3: pow10 = 1000;
                4: pow10 = 10000;
                default: pow10 = 1;
            endcase
        end
    endfunction

    // 결과를 사람이 보기 좋게 출력
    task show;
        input [8*40-1:0] tag;
        integer scale;
        integer int_part;
        integer frac_part;
        integer abs_val;
        begin
            scale   = pow10(res_dp);
            abs_val = (result < 0) ? -result : result;
            int_part  = abs_val / scale;
            frac_part = abs_val % scale;

            $display("--------------------------------------------------");
            $display("%s", tag);
            $display(" op1=%0d dp1=%0d   op2=%0d dp2=%0d   sub=%0d", op1, dp1, op2, dp2, sub);
            $display(" => result(raw)=%0d  res_dp=%0d  overflow=%b", result, res_dp, overflow);

            // 소수부 자릿수 맞춰서 출력 (res_dp=0이면 정수)
            if (res_dp == 0) begin
                $display(" => value = %0d", result);
            end else begin
                if (result < 0)
                    $write(" => value = -%0d.", int_part);
                else
                    $write(" => value = %0d.", int_part);

                // res_dp 자리수만큼 0 padding
                case (res_dp)
                    1: $display("%01d", frac_part);
                    2: $display("%02d", frac_part);
                    3: $display("%03d", frac_part);
                    4: $display("%04d", frac_part);
                    default: $display("%0d", frac_part);
                endcase
            end
        end
    endtask

    initial begin
        // -------------------------
        // Case 1) 2.4 - 3.5 = -1.1
        // op = value * 10^{-dp}
        // 2.4  -> op1=24,  dp1=1
        // 3.5  -> op2=35,  dp2=1
        // -------------------------
        op1 = 24;   dp1 = 1;
        op2 = 35;   dp2 = 1;
        sub = 1'b1; // op1 - op2
        #1;         // 조합회로 안정화 시간
        show("Case1: 2.4 - 3.5 (expect -1.1)");

        // -------------------------
        // Case 2) 2.1234 - 1.1234 = 1.0000 -> normalize -> 1
        // 2.1234 -> op1=21234, dp1=4
        // 1.1234 -> op2=11234, dp2=4
        // -------------------------
        op1 = 21234; dp1 = 4;
        op2 = 11234; dp2 = 4;
        sub = 1'b1;
        #1;
        show("Case2: 2.1234 - 1.1234 (expect 1)");

        $display("==================================================");
        $display("DONE");
        $finish;
    end

endmodule
