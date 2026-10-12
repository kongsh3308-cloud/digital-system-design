`timescale 1ns/1ps

module tb_scan_to_key_ascii_fixed;

    reg        clk;
    reg        rst;
    reg  [7:0] scancode;
    reg        scan_ready;

    wire [3:0] digit;
    wire       is_digit;
    wire [1:0] op_code;
    wire       is_op;
    wire       is_enter;
    wire       is_clear;
    wire       is_dot;

    // DUT
    scan_to_key_ascii dut (
        .clk        (clk),
        .rst        (rst),
        .scancode   (scancode),
        .scan_ready (scan_ready),
        .digit      (digit),
        .is_digit   (is_digit),
        .op_code    (op_code),
        .is_op      (is_op),
        .is_enter   (is_enter),
        .is_clear   (is_clear),
        .is_dot     (is_dot)
    );

    // 50MHz clock (20ns period)
    initial clk = 1'b0;
    always #10 clk = ~clk;

    // scan_ready를 "posedge를 포함하는" 1펄스로 만들기
    // - negedge에서 scancode/scan_ready를 올림
    // - 다음 negedge에서 scan_ready를 내림 (posedge에서 내리지 않음!)
    task press_ascii;
        input [7:0] ascii;
    begin
        @(negedge clk);
        scancode   <= ascii;
        scan_ready <= 1'b1;

        // posedge를 한번 통과하도록 유지
        @(negedge clk);
        scan_ready <= 1'b0;

        // 관찰 편의상 정리(필수 아님)
        @(negedge clk);
        scancode   <= 8'h00;
    end
    endtask

    function [8*4-1:0] op_name;
        input [1:0] op;
        begin
            case (op)
                2'b00: op_name = "ADD";
                2'b01: op_name = "SUB";
                2'b10: op_name = "MUL";
                2'b11: op_name = "DIV";
            endcase
        end
    endfunction

    // 펄스 확인용 출력 (원하면 scancode/scan_ready도 같이 찍기)
    always @(posedge clk) begin
        if (scan_ready)
            $display("[%0t] scan_ready=1, scancode=0x%02h", $time, scancode);

        if (is_digit)
            $display("[%0t] DIGIT  %0d", $time, digit);
        if (is_op)
            $display("[%0t] OP     %s (op_code=%b)", $time, op_name(op_code), op_code);
        if (is_dot)
            $display("[%0t] DOT    '.'", $time);
        if (is_enter)
            $display("[%0t] ENTER  '='", $time);
        if (is_clear)
            $display("[%0t] CLEAR  'ESC'", $time);
    end

    initial begin
        scancode   = 8'h00;
        scan_ready = 1'b0;

        // reset
        rst = 1'b1;
        repeat(3) @(posedge clk);
        rst = 1'b0;
        repeat(2) @(posedge clk);

        // =========================
        // Case 1) 4 + 5 =
        // =========================
        $display("\n==== Case1: 4 + 5 = ====");
        press_ascii(8'h34); // '4'
        press_ascii(8'h2B); // '+'
        press_ascii(8'h35); // '5'
        press_ascii(8'h0D); // Enter

        repeat(5) @(posedge clk);

        // =========================
        // Case 2) -3.5 + 2.4 =
        // (scan_to_key_ascii 관점에서는 '-'도 그냥 OP로 디코딩됨)
        // =========================
        $display("\n==== Case2: -3.5 + 2.4 = ====");
        press_ascii(8'h2D); // '-'
        press_ascii(8'h33); // '3'
        press_ascii(8'h2E); // '.'
        press_ascii(8'h35); // '5'
        press_ascii(8'h2B); // '+'
        press_ascii(8'h32); // '2'
        press_ascii(8'h2E); // '.'
        press_ascii(8'h34); // '4'
        press_ascii(8'h0D); // Enter

        repeat(10) @(posedge clk);
        $display("\n==== DONE ====");
        $finish;
    end

endmodule
