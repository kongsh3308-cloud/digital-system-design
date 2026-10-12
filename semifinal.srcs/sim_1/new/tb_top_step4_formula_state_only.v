`timescale 1ns/1ps

module tb_top_step4_formula_state_only;

    reg        clk;     // top 입력 (형식상)
    reg        rst;
    reg [15:0] SW;

    wire [7:0] an;
    wire [6:0] seg;
    wire       dp;
    wire [3:0] VGA_R, VGA_G, VGA_B;
    wire       VGA_HS, VGA_VS;
    wire [6:0] led;

    // DUT
    top_step4_formula dut (
        .clk     (clk),
        .rst     (rst),
        .ps2clk  (1'b1),
        .ps2data (1'b1),
        .SW      (SW),
        .an      (an),
        .seg     (seg),
        .dp      (dp),
        .VGA_R   (VGA_R),
        .VGA_G   (VGA_G),
        .VGA_B   (VGA_B),
        .VGA_HS  (VGA_HS),
        .VGA_VS  (VGA_VS),
        .led     (led)
    );

    // 시뮬레이션용 50MHz (FSM 기준 클럭)
    reg clk50_sim;
    initial clk50_sim = 0;
    always #10 clk50_sim = ~clk50_sim; // 20ns period

    // top 내부 클럭/리셋 우회
    initial begin
        force dut.clk_50   = clk50_sim;
        force dut.locked   = 1'b1;
        force dut.rst_sync = rst;
    end

    // 형식상 clk(100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // state code
    localparam S_OP1    = 2'd0;
    localparam S_OP2    = 2'd1;
    localparam S_RESULT = 2'd2;

    // operator code
    localparam OP_ADD = 2'b00;
    localparam OP_SUB = 2'b01; // '-' (상황에 따라 sign toggle로도 사용)
    localparam OP_MUL = 2'b10;
    localparam OP_DIV = 2'b11;

    // -------------------------
    // state 출력만 하는 함수들
    // -------------------------
    task show_state;
        input [8*40-1:0] tag;
    begin
        $display("[%0t] %s  state=%0d", $time, tag, dut.state);
    end
    endtask

    task expect_state;
        input [1:0] exp;
        input [8*40-1:0] tag;
    begin
        if (dut.state !== exp)
            $display("  FAIL: %s  got=%0d expected=%0d", tag, dut.state, exp);
        else
            $display("  OK  : %s  state=%0d", tag, dut.state);
    end
    endtask

    // -------------------------
    // 키 입력 이벤트 주입(task)
    // -------------------------
    task press_digit;
        input [3:0] d;
    begin
        @(negedge clk50_sim);
        force dut.digit    = d;
        force dut.is_digit = 1'b1;
        @(posedge clk50_sim);
        release dut.digit;
        release dut.is_digit;
        @(posedge clk50_sim);
        show_state({"digit ", 8'h30 + d});
    end
    endtask

    task press_op;
        input [1:0] op;
        input [8*10-1:0] name; // "+", "-", "*", "/"
    begin
        @(negedge clk50_sim);
        force dut.op_code = op;
        force dut.is_op   = 1'b1;
        @(posedge clk50_sim);
        release dut.op_code;
        release dut.is_op;
        @(posedge clk50_sim);
        show_state({"op ", name});
    end
    endtask

    task press_enter;
    begin
        @(negedge clk50_sim);
        force dut.is_enter = 1'b1;
        @(posedge clk50_sim);
        release dut.is_enter;
        @(posedge clk50_sim);
        show_state("ENTER (=)");
    end
    endtask

    task press_clear;
    begin
        @(negedge clk50_sim);
        force dut.is_clear = 1'b1;
        @(posedge clk50_sim);
        release dut.is_clear;
        @(posedge clk50_sim);
        show_state("ESC(clear)");
    end
    endtask

    // '-'를 sign toggle로 쓰고 싶을 때:
    // (started=0,value=0,frac_mode=0) 조건에서 OP_SUB를 누르면 sign 토글로 해석되는 구조 가정
    task toggle_sign;
        input [8*12-1:0] who; // "op1" or "op2"
    begin
        press_op(OP_SUB, "-(sign)");
        show_state({"toggle sign ", who});
    end
    endtask

    // -------------------------
    // Test sequences
    // -------------------------
    initial begin
        SW  = 16'd0;
        rst = 1'b1;
        repeat(5) @(posedge clk50_sim);
        rst = 1'b0;

        show_state("after reset");
        expect_state(S_OP1, "reset -> S_OP1");

        // =====================================================
        // Case 1) 4 + 5 =
        // 기대 state 흐름:
        // S_OP1 (digit 4) -> S_OP1
        // '+' 입력 -> S_OP2
        // (digit 5) -> S_OP2
        // Enter -> S_RESULT
        // =====================================================
        $display("\n==== Case1: 4 + 5 = ====");
        press_clear();
        expect_state(S_OP1, "clear -> S_OP1");

        press_digit(4);
        expect_state(S_OP1, "after digit 4 (stay OP1)");

        press_op(OP_ADD, "+");
        expect_state(S_OP2, "after '+' (OP2)");

        press_digit(5);
        expect_state(S_OP2, "after digit 5 (stay OP2)");

        press_enter();
        expect_state(S_RESULT, "after ENTER (RESULT)");

        // =====================================================
        // Case 2) -4 * -5 =
        // 기대 state 흐름:
        // clear -> S_OP1
        // '-'(sign toggle) -> S_OP1 유지
        // digit 4 -> S_OP1 유지
        // '*' -> S_OP2
        // '-'(sign toggle) -> S_OP2 유지 (op2 시작 전이면)
        // digit 5 -> S_OP2 유지
        // Enter -> S_RESULT
        // =====================================================
        $display("\n==== Case2: -4 * -5 = ====");
        press_clear();
        expect_state(S_OP1, "clear -> S_OP1");

        toggle_sign("op1");          // op1 음수 토글
        expect_state(S_OP1, "after op1 sign toggle (stay OP1)");

        press_digit(4);
        expect_state(S_OP1, "after digit 4 (stay OP1)");

        press_op(OP_MUL, "*");
        expect_state(S_OP2, "after '*' (OP2)");

        toggle_sign("op2");          // op2 음수 토글( op2_started=0일 때만 의미있음 )
        expect_state(S_OP2, "after op2 sign toggle (stay OP2)");

        press_digit(5);
        expect_state(S_OP2, "after digit 5 (stay OP2)");

        press_enter();
        expect_state(S_RESULT, "after ENTER (RESULT)");

        $display("\n==== DONE ====");
        #100;
        $finish;
    end

endmodule
