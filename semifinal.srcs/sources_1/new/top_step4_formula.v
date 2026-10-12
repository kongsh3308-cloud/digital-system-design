`timescale 1ns / 1ps

module top_step4_formula(
    input  wire       clk,       // 100MHz
    input  wire       rst,       // BTN (active-high)

    input  wire       ps2clk,
    input  wire       ps2data,
    
    input  wire [15:0] SW,       // SW[15]: 배경 모드 선택

    // 7-SEG
    output wire [7:0] an,
    output wire [6:0] seg,
    output wire       dp,

    // VGA
    output wire [3:0] VGA_R,
    output wire [3:0] VGA_G,
    output wire [3:0] VGA_B,
    output wire       VGA_HS,
    output wire       VGA_VS,
    output wire [6:0] led
);
    //========================
    // 1. Clock Wizard
    //========================
    wire clk_100, clk_50, clk_25, locked;

    clk_wiz_0 clk_core(
        .clk_in1 (clk),
        .reset   (rst),
        .clk_out1(clk_100),
        .clk_out2(clk_50),
        .clk_out3(clk_25),
        .locked  (locked)
    );

    wire rst_sync = rst | ~locked;

    //========================
    // 2. PS2 키보드
    //========================
    wire [7:0] scancode;
    wire       Released;
    wire       kb_err;

    ps2_kbd_top ps2_kbd (
        .clk      (clk_50),
        .rst      (rst_sync),
        .ps2clk   (ps2clk),
        .ps2data  (ps2data),
        .scancode (scancode),
        .Released (Released),
        .err_ind  (kb_err)
    );

    //========================
    // 3. 키 해석
    //========================
    wire [3:0] digit;
    wire       is_digit;
    wire [1:0] op_code;
    wire       is_op;
    wire       is_enter;
    wire       is_clear;
    wire       is_dot;

    wire signed [4:0] sdigit = {1'b0, digit};
    scan_to_key_ascii decode (
        .clk        (clk_50),
        .rst        (rst_sync),
        .scancode   (scancode),
        .scan_ready (Released),

        .digit      (digit),
        .is_digit   (is_digit),
        .op_code    (op_code),
        .is_op      (is_op),
        .is_enter   (is_enter),
        .is_clear   (is_clear),
        .is_dot     (is_dot)
    );

    //========================
    // 4. FSM + ALU
    //========================
    localparam S_OP1    = 2'd0;
    localparam S_OP2    = 2'd1;
    localparam S_RESULT = 2'd2;

    reg [1:0]  state;

    // 24-bit signed 정수 (또는 "소수까지 이어붙인 정수")
    reg signed [23:0] op1;
    reg signed [23:0] op2;
    reg [1:0]         operator;
    reg signed [23:0] result_reg;
    
    reg op1_sign;
    reg op2_sign;
    reg op1_started;
    reg op2_started;

    // 각 피연산자의 소수점 자리수 정보 (0이면 정수)
    reg        op1_frac_mode;
    reg [2:0]  op1_frac_digits;
    reg        op2_frac_mode;
    reg [2:0]  op2_frac_digits;
    reg [2:0]  result_frac_digits;

    reg        input_overflow;
    reg        error_flag;

    // 정수 ALU (24-bit signed)
    wire signed [23:0] alu_result;
    wire        alu_overflow;
    wire        alu_div_zero;
    wire        alu_error;

    alu16_comb alu_inst (
        .op1      (op1),
        .op2      (op2),
        .operator (operator),
        .result   (alu_result),
        .overflow (alu_overflow),
        .div_zero (alu_div_zero),
        .error    (alu_error)
    );

    // 부동소수(+/-) ALU
    wire signed [23:0] float_result;
    wire [2:0]         float_res_dp;
    wire               float_overflow;

    float_addsub_dec24 float_alu (
        .op1     (op1),
        .op2     (op2),
        .dp1     (op1_frac_digits),
        .dp2     (op2_frac_digits),
        .sub     (operator == 2'b01), // 0:+, 1:-
        .result  (float_result),
        .res_dp  (float_res_dp),
        .overflow(float_overflow)
    );

    // 24비트 입력용 임시 값
    reg signed [24:0] next_val;
    reg [24:0]        next_abs;
    reg signed [24:0] res_check_val;
    reg [24:0]        res_check_abs;

    wire float_expr =
        (op1_frac_digits != 3'd0) || (op2_frac_digits != 3'd0);

    wire signed [23:0] value_24 =
        error_flag        ? 24'sd0 :
        (state==S_OP2)    ? op2    :
        (state==S_RESULT) ? result_reg :
                            op1;
                            
    wire        is_neg  = (value_24 < 0);
    wire [23:0] abs_val = is_neg ? -value_24 : value_24;
    wire [23:0] clip_val = (abs_val > 24'd99999) ? 24'd99999 : abs_val;

    // 7-seg에서 사용할 소수 자리
    wire [2:0] cur_frac_digits =
        (state == S_RESULT) ? result_frac_digits :
        (state == S_OP2)    ? op2_frac_digits    :
                              op1_frac_digits;

    // 7-seg, BCD 변환용 (0~99999)
    wire [16:0] value_for_7seg = clip_val[16:0];

    // FSM
    always @(posedge clk_50 or posedge rst_sync) begin
        if (rst_sync) begin
            state               <= S_OP1;
            op1                 <= 24'sd0;
            op2                 <= 24'sd0;
            operator            <= 2'b00;
            result_reg          <= 24'sd0;
            input_overflow      <= 1'b0;
            error_flag          <= 1'b0;
            op1_frac_mode       <= 1'b0;
            op2_frac_mode       <= 1'b0;
            op1_frac_digits     <= 3'd0;
            op2_frac_digits     <= 3'd0;
            result_frac_digits  <= 3'd0;
            op1_sign            <= 1'b0;
            op2_sign            <= 1'b0;
            op1_started         <= 1'b0;
            op2_started         <= 1'b0;
        end else begin
            if (is_clear) begin
                // ESC → 전체 초기화
                state               <= S_OP1;
                op1                 <= 24'sd0;
                op2                 <= 24'sd0;
                operator            <= 2'b00;
                result_reg          <= 24'sd0;
                input_overflow      <= 1'b0;
                error_flag          <= 1'b0;
                op1_frac_mode       <= 1'b0;
                op2_frac_mode       <= 1'b0;
                op1_frac_digits     <= 3'd0;
                op2_frac_digits     <= 3'd0;
                result_frac_digits  <= 3'd0;
                op1_sign            <= 1'b0;
                op2_sign            <= 1'b0;
                op1_started         <= 1'b0;
                op2_started         <= 1'b0;
            end else begin
                case (state)
                    //--------------------------------
                    // 첫 번째 피연산자 입력
                    //--------------------------------
                    S_OP1: begin
                        if (is_dot && !op1_frac_mode && !error_flag && !input_overflow) begin
                            op1_frac_mode   <= 1'b1;
                            op1_frac_digits <= 3'd0;
                        end

                        if (is_digit && !input_overflow && !error_flag) begin
                            if (!op1_sign)
                                next_val = op1 * 10 + sdigit;
                            else
                                next_val = op1 * 10 - sdigit;

                            next_abs = (next_val < 0) ? -next_val : next_val;
                            if (next_abs > 25'd99999) begin
                                input_overflow <= 1'b1;
                                error_flag     <= 1'b1;
                            end else begin
                                op1         <= next_val[23:0];
                                op1_started <= 1'b1;
                                if (op1_frac_mode && op1_frac_digits < 3'd4)
                                    op1_frac_digits <= op1_frac_digits + 1'b1;
                            end
                        end

                        if (is_op && !error_flag) begin
                            // 아직 숫자 안 친 상태 + '-'면 부호 토글
                            if (op_code == 2'b01 && !op1_started &&
                                !op1_frac_mode && op1 == 24'sd0) begin
                                op1_sign <= ~op1_sign;
                            end else begin
                                operator          <= op_code;
                                state             <= S_OP2;

                                op2               <= 24'sd0;
                                op2_sign          <= 1'b0;
                                op2_started       <= 1'b0;
                                op2_frac_mode     <= 1'b0;
                                op2_frac_digits   <= 3'd0;
                            end
                        end
                    end

                    //--------------------------------
                    // 두 번째 피연산자 입력
                    //--------------------------------
                    S_OP2: begin
                        if (is_dot && !op2_frac_mode && !error_flag && !input_overflow) begin
                            op2_frac_mode   <= 1'b1;
                            op2_frac_digits <= 3'd0;
                        end

                        if (is_digit && !input_overflow && !error_flag) begin
                            if (!op2_sign)
                                next_val = op2 * 10 + sdigit;
                            else
                                next_val = op2 * 10 - sdigit;

                            next_abs = (next_val < 0) ? -next_val : next_val;
                            if (next_abs > 25'd99999) begin
                                input_overflow <= 1'b1;
                                error_flag     <= 1'b1;
                            end else begin
                                op2         <= next_val[23:0];
                                op2_started <= 1'b1;
                                if (op2_frac_mode && op2_frac_digits < 3'd4)
                                    op2_frac_digits <= op2_frac_digits + 1'b1;
                            end
                        end

                        if (is_op && !error_flag) begin
                            if (op_code == 2'b01 && !op2_started &&
                                !op2_frac_mode && op2 == 24'sd0) begin
                                op2_sign <= ~op2_sign;
                            end
                        end

                        // Enter
                        if (is_enter && !error_flag) begin
                            if (float_expr &&
                                (operator == 2'b00 || operator == 2'b01)) begin
                                // 소수 포함 +, -
                                res_check_val = {float_result[23], float_result};
                                res_check_abs = (res_check_val < 0) ? -res_check_val : res_check_val;

                                if (float_overflow || (res_check_abs > 25'd99999)) begin
                                    error_flag         <= 1'b1;
                                    result_reg         <= 24'sd0;
                                    result_frac_digits <= 3'd0;
                                end else begin
                                    result_reg         <= float_result;
                                    result_frac_digits <= float_res_dp;
                                end
                            end else begin
                                // 정수 ALU
                                res_check_val = {alu_result[23], alu_result};
                                res_check_abs = (res_check_val < 0) ? -res_check_val : res_check_val;

                                if (alu_error || (res_check_abs > 25'd99999)) begin
                                    error_flag         <= 1'b1;
                                    result_reg         <= 24'sd0;
                                    result_frac_digits <= 3'd0;
                                end else begin
                                    result_reg         <= alu_result;
                                    result_frac_digits <= 3'd0;
                                end
                            end

                            state <= S_RESULT;
                        end
                    end

                    //--------------------------------
                    // 결과 상태
                    //--------------------------------
                    S_RESULT: begin
                        if (is_digit) begin
                            op1                <= {{20{1'b0}}, digit};
                            op2                <= 24'sd0;
                            operator           <= 2'b00;
                            result_reg         <= 24'sd0;
                            input_overflow     <= 1'b0;
                            error_flag         <= 1'b0;
                            state              <= S_OP1;

                            op1_frac_mode      <= 1'b0;
                            op2_frac_mode      <= 1'b0;
                            op1_frac_digits    <= 3'd0;
                            op2_frac_digits    <= 3'd0;
                            result_frac_digits <= 3'd0;

                            op1_sign           <= 1'b0;
                            op2_sign           <= 1'b0;
                            op1_started        <= 1'b1;
                            op2_started        <= 1'b0;
                        end
                    end

                    default: state <= S_OP1;
                endcase
            end
        end
    end

    //========================
    // 5. 7-SEG 표시
    //========================
    wire [3:0] bcd0, bcd1, bcd2, bcd3, bcd4;

    bin_to_bcd_16 b2bcd_for_seg (
        .bin (value_for_7seg),
        .bcd0(bcd0),
        .bcd1(bcd1),
        .bcd2(bcd2),
        .bcd3(bcd3),
        .bcd4(bcd4)
    );

    sevenseg_driver_5digit segdrv (
        .clk   (clk_100),
        .rst   (rst_sync),
        .error (error_flag),
        .bcd0  (bcd0),
        .bcd1  (bcd1),
        .bcd2  (bcd2),
        .bcd3  (bcd3),
        .bcd4  (bcd4),
        .an    (an),
        .sign  (is_neg),           // A안 드라이버에서는 내부에서 무시
        .frac_digits(cur_frac_digits),
        .seg   (seg),
        .dp    (dp)
    );

    //========================
    // 6. op1 / op2 / result BCD (VGA용)
    //========================
    wire        op1_neg = (op1 < 0);
    wire        op2_neg = (op2 < 0);
    wire        res_neg = (result_reg < 0);

    wire [23:0] op1_abs = op1_neg ? -op1 : op1;
    wire [23:0] op2_abs = op2_neg ? -op2 : op2;
    wire [23:0] res_abs = res_neg ? -result_reg : result_reg;

    wire [23:0] op1_clip = (op1_abs > 24'd99999) ? 24'd99999 : op1_abs;
    wire [23:0] op2_clip = (op2_abs > 24'd99999) ? 24'd99999 : op2_abs;
    wire [23:0] res_clip = (res_abs > 24'd99999) ? 24'd99999 : res_abs;

    wire [3:0] op1_b0, op1_b1, op1_b2, op1_b3, op1_b4;
    wire [3:0] op2_b0, op2_b1, op2_b2, op2_b3, op2_b4;
    wire [3:0] res_b0, res_b1, res_b2, res_b3, res_b4;

    bin_to_bcd_16 bcd_op1(
        .bin (op1_clip[16:0]),
        .bcd0(op1_b0),
        .bcd1(op1_b1),
        .bcd2(op1_b2),
        .bcd3(op1_b3),
        .bcd4(op1_b4)
    );

    bin_to_bcd_16 bcd_op2(
        .bin (op2_clip[16:0]),
        .bcd0(op2_b0),
        .bcd1(op2_b1),
        .bcd2(op2_b2),
        .bcd3(op2_b3),
        .bcd4(op2_b4)
    );

    bin_to_bcd_16 bcd_res(
        .bin (res_clip[16:0]),
        .bcd0(res_b0),
        .bcd1(res_b1),
        .bcd2(res_b2),
        .bcd3(res_b3),
        .bcd4(res_b4)
    );

    //========================
    // 7. VGA 타이밍
    //========================
    wire [9:0] pix_x, pix_y;
    wire       video_on;

    vga_sync_640x480 vga_sync (
        .clk     (clk_25),
        .rst     (rst_sync),
        .x       (pix_x),
        .y       (pix_y),
        .hsync   (VGA_HS),
        .vsync   (VGA_VS),
        .video_on(video_on)
    );

    //========================
    // 8. 수식(전경, FG)
    //========================
    wire [3:0] expr_r_raw, expr_g_raw, expr_b_raw;

    vga_expr_line expr (
        .clk_pix (clk_25),
        .video_on(video_on),
        .x       (pix_x),
        .y       (pix_y),

        .op1_b0  (op1_b0), .op1_b1(op1_b1), .op1_b2(op1_b2), .op1_b3(op1_b3), .op1_b4(op1_b4),
        .op2_b0  (op2_b0), .op2_b1(op2_b1), .op2_b2(op2_b2), .op2_b3(op2_b3), .op2_b4(op2_b4),
        .res_b0  (res_b0), .res_b1(res_b1), .res_b2(res_b2), .res_b3(res_b3), .res_b4(res_b4),

        .operator(operator),
        .error   (error_flag),
        .op1_neg (op1_neg),
        .op2_neg (op2_neg),
        .res_neg (res_neg),

        .op1_dp  (op1_frac_digits),
        .op2_dp  (op2_frac_digits),
        .res_dp  (result_frac_digits),

        .vga_r   (expr_r_raw),
        .vga_g   (expr_g_raw),
        .vga_b   (expr_b_raw)
    );

    // BRAM 딜레이(1클럭)와 맞추기 위해 expr도 1클럭 레지스터
    reg [3:0] expr_r, expr_g, expr_b;
    always @(posedge clk_25) begin
        expr_r <= expr_r_raw;
        expr_g <= expr_g_raw;
        expr_b <= expr_b_raw;
    end

    //========================
    // 9. BRAM 배경(BG)
    //========================
    wire [3:0] bg_r, bg_g, bg_b;

    vga_bram_bg bg_inst (
        .clk_pix (clk_25),
        .video_on(video_on),
        .x       (pix_x),
        .y       (pix_y),
        .r       (bg_r),
        .g       (bg_g),
        .b       (bg_b)
    );

    //========================
    // 10. FG + BG 합치기, SW[15]로 모드 선택
    //========================
    // 전경(수식) 픽셀이 있는지 여부
    wire fg_on = |{expr_r, expr_g, expr_b};

    // 배경 위에 수식 오버레이
    wire [3:0] overlay_r = fg_on ? expr_r : bg_r;
    wire [3:0] overlay_g = fg_on ? expr_g : bg_g;
    wire [3:0] overlay_b = fg_on ? expr_b : bg_b;

    // 최종 VGA 출력
    // SW[15] = 0 → 기존 수식 화면 (검정 배경)
    // SW[15] = 1 → 배경 이미지 + 수식 오버레이
    assign VGA_R = SW[15] ? overlay_r : expr_r;
    assign VGA_G = SW[15] ? overlay_g : expr_g;
    assign VGA_B = SW[15] ? overlay_b : expr_b;

    //========================
    // 11. LED 상태 표시
    //========================
    assign led[0] = op1_sign;                             // op1 부호 설정
    assign led[1] = op1_started;                          // op1 입력됨
    assign led[2] = (state == S_OP2) | (state == S_RESULT); // 연산자까지 입력
    assign led[3] = op2_sign;                             // op2 부호 설정
    assign led[4] = op2_started;                          // op2 입력됨
    assign led[6] = (state == S_RESULT);                  // 결과 나왔을 때
    assign led[5] = (state == S_RESULT) && res_neg;       // 결과가 음수일 때만

endmodule
