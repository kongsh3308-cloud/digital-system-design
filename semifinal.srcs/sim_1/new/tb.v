`timescale 1ns/1ps

module tb;

    reg clk_pix;
    reg video_on;
    reg [9:0] x, y;

    reg       op1_neg, op2_neg, res_neg;
    reg [2:0] op1_dp, op2_dp, res_dp;

    reg [3:0] op1_b0, op1_b1, op1_b2, op1_b3, op1_b4;
    reg [3:0] op2_b0, op2_b1, op2_b2, op2_b3, op2_b4;
    reg [3:0] res_b0, res_b1, res_b2, res_b3, res_b4;

    reg [1:0] operator;
    reg       error;

    wire [3:0] r, g, b;

    // DUT
    vga_expr_line dut(
        .clk_pix(clk_pix),
        .video_on(video_on),
        .x(x),
        .y(y),

        .op1_neg(op1_neg),
        .op2_neg(op2_neg),
        .res_neg(res_neg),

        .op1_dp(op1_dp),
        .op2_dp(op2_dp),
        .res_dp(res_dp),

        .op1_b0(op1_b0), .op1_b1(op1_b1), .op1_b2(op1_b2), .op1_b3(op1_b3), .op1_b4(op1_b4),
        .op2_b0(op2_b0), .op2_b1(op2_b1), .op2_b2(op2_b2), .op2_b3(op2_b3), .op2_b4(op2_b4),
        .res_b0(res_b0), .res_b1(res_b1), .res_b2(res_b2), .res_b3(res_b3), .res_b4(res_b4),

        .operator(operator),
        .error(error),

        .vga_r(r),
        .vga_g(g),
        .vga_b(b)
    );

    // create 25MHz pixel clock
    initial clk_pix = 0;
    always #20 clk_pix = ~clk_pix;

    // -----------------------------
    // TASK ? print RGB at a location
    // -----------------------------
    task show_pixel(input [9:0] px, input [9:0] py);
    begin
        x = px; y = py;
        #1;
        $display("x=%d y=%d  RGB=%d%d%d", px, py, r, g, b);
    end
    endtask

    initial begin
        // 기본 환경 설정
        video_on = 1;

        // Test Vector 1 : "-12345 + 67.89 = -12277"
        op1_neg = 1;
        op1_b4 = 1; op1_b3=2; op1_b2=3; op1_b1=4; op1_b0=5;
        op1_dp = 0;

        op2_neg = 0;
        op2_b4=0; op2_b3=0; op2_b2=6; op2_b1=7; op2_b0=8;
        op2_dp = 2;     // 67.8"

        res_neg = 1;
        res_b4=1; res_b3=2; res_b2=2; res_b1=7; res_b0=7;
        res_dp = 0;

        operator = 2'b00;   // '+'
        error = 0;

        #100;

        // ------------------------------
        // 샘플 좌표 테스트
        // ------------------------------
        $display("=== SIGN TEST ===");
        show_pixel(30, 210);     // op1 '-' 위치
        show_pixel(100,210);     // op1 첫 글자
        show_pixel(220,210);     // operator '+'

        $display("=== DECIMAL TEST ===");
        show_pixel(300,250);     // op2 소수점 위치
        show_pixel(330,250);     // op2 실제 숫자 뒤

        $display("=== RESULT SIGN ===");
        show_pixel(500, 210);    // result '-' 위치

        $display("=== RESULT LAST DIGIT ===");
        show_pixel(600,240);     // 마지막 픽셀 근처

        #100;

        // Test Vector 2 : "1.12 * 9.3 = 10.416"
        op1_neg = 0;
        op1_b4=0; op1_b3=0; op1_b2=0; op1_b1=1; op1_b0=2;
        op1_dp = 2;     // 1.12

        op2_neg = 0;
        op2_b4=0; op2_b3=0; op2_b2=0; op2_b1=9; op2_b0=3;
        op2_dp = 1;     // 9.3

        operator = 2'b10;   // '*'
        res_neg = 0;
        res_dp  = 3;

        #100;

        $display("=== DECIMAL ALIGN CHECK ===");
        show_pixel(150,250); // 1.12 점 위치
        show_pixel(340,250); // 9.3 점 위치

        #200;
        $finish;
    end

endmodule
