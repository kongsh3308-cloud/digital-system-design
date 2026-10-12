`timescale 1ns / 1ps

module vga_expr_line(
    input  wire       clk_pix,   // 25MHz
    input  wire       video_on,
    input  wire [9:0] x,
    input  wire [9:0] y,

    input  wire       op1_neg,
    input  wire       op2_neg,
    input  wire       res_neg,

    input  wire [2:0] op1_dp,
    input  wire [2:0] op2_dp,
    input  wire [2:0] res_dp,

    input  wire [3:0] op1_b0, op1_b1, op1_b2, op1_b3, op1_b4,
    input  wire [3:0] op2_b0, op2_b1, op2_b2, op2_b3, op2_b4,
    input  wire [3:0] res_b0, res_b1, res_b2, res_b3, res_b4,

    input  wire [1:0] operator,
    input  wire       error,

    output reg  [3:0] vga_r,
    output reg  [3:0] vga_g,
    output reg  [3:0] vga_b
);

    // ==========================
    // 문자/간격
    // ==========================
    localparam CHAR_W = 24;    // 숫자 폭
    localparam H      = 64;    // 숫자 높이
    localparam GAP    = 6;     // 간격 (소수점 위치)
    localparam CELL_W = CHAR_W + GAP;   // 30px
    localparam TOTAL  = 20;    // [부호 + 숫자 5] *3 + 연산자 + '='

    // 화면 가운데 오도록 배치
    localparam START_X = (640 - TOTAL*CELL_W)/2;  // 약 20
    localparam START_Y = 200;

    integer idx;
    integer cell_x;
    integer local_x;
    integer local_y;

    reg [3:0] cur_digit;
    reg [6:0] seg_bits;

    // 소수점 위치
    reg [4:0] op1_dp_cell;  
    reg [4:0] op2_dp_cell;
    reg [4:0] res_dp_cell;

    // 7세그 패턴
    function [6:0] seg_pattern(input [3:0] d);
        begin
            case (d)
                4'd0: seg_pattern = 7'b0111111;
                4'd1: seg_pattern = 7'b0000110;
                4'd2: seg_pattern = 7'b1011011;
                4'd3: seg_pattern = 7'b1001111;
                4'd4: seg_pattern = 7'b1100110;
                4'd5: seg_pattern = 7'b1101101;
                4'd6: seg_pattern = 7'b1111101;
                4'd7: seg_pattern = 7'b0000111;
                4'd8: seg_pattern = 7'b1111111;
                4'd9: seg_pattern = 7'b1101111;
                default: seg_pattern = 7'b0000000;
            endcase
        end
    endfunction

    // ================================
    // index → BCD (부호칸은 빈칸)
    // ================================
    function [3:0] get_digit(input integer i);
        begin
            case(i)

                // op1 digits  (1~5)
                1: get_digit = op1_b4;
                2: get_digit = op1_b3;
                3: get_digit = op1_b2;
                4: get_digit = op1_b1;
                5: get_digit = op1_b0;

                // operator
                6: get_digit = 4'hF;

                // op2 digits (8~12)
                8:  get_digit = op2_b4;
                9:  get_digit = op2_b3;
                10: get_digit = op2_b2;
                11: get_digit = op2_b1;
                12: get_digit = op2_b0;

                // '='
                13: get_digit = 4'hE;

                // result digits (15~19)
                15: get_digit = res_b4;
                16: get_digit = res_b3;
                17: get_digit = res_b2;
                18: get_digit = res_b1;
                19: get_digit = res_b0;

                // sign cells & unused cells → 빈칸
                default: get_digit = 4'hF;
            endcase
        end
    endfunction

    // ================================
    // 메인 출력
    // ================================
    always @* begin
        vga_r = 0; vga_g = 0; vga_b = 0;

        // 소수점 셀 계산  (부호칸 건너뛰기!)
        op1_dp_cell = 5'd31;
        op2_dp_cell = 5'd31;
        res_dp_cell = 5'd31;

        // op1 숫자 셀: idx 1~5
        if (op1_dp != 0 && op1_dp <= 5)
            op1_dp_cell = 1 + (4 - op1_dp);

        // op2 숫자 셀: idx 8~12
        if (op2_dp != 0 && op2_dp <= 5)
            op2_dp_cell = 8 + (4 - op2_dp);

        // res 숫자 셀: idx 15~19
        if (res_dp != 0 && res_dp <= 5)
            res_dp_cell = 15 + (4 - res_dp);

        if (!video_on)
            ; // 화면 밖
        else if (error) begin
            vga_r = 4'hF;
            vga_g = 4'h0;
            vga_b = 4'h0;
        end
        else if ( (y>=START_Y) && (y<START_Y+H)
               && (x>=START_X) && (x<START_X+TOTAL*CELL_W) ) begin

            cell_x  = x - START_X;
            local_y = y - START_Y;

            idx     = cell_x / CELL_W;   // 0~19
            local_x = cell_x % CELL_W;

            cur_digit = get_digit(idx);

            // -----------------------------
            // 왼쪽 CHAR_W: 글자 그리는 영역
            // -----------------------------
            if (local_x < CHAR_W) begin

                // ===== 부호 셀 =====
                if ((idx==0  && op1_neg) ||
                    (idx==7  && op2_neg) ||
                    (idx==14 && res_neg)) begin

                    if (local_y>H/2-2 && local_y<H/2+2 &&
                        local_x>3      && local_x<CHAR_W-3)
                        {vga_r,vga_g,vga_b} = 12'hFFF;
                end

                // ===== 숫자 =====
                else if (cur_digit <= 9) begin
                    seg_bits = seg_pattern(cur_digit);

                    // a
                    if(seg_bits[0] && local_y<5 && local_x>3 && local_x<CHAR_W-3)
                        {vga_r,vga_g,vga_b} = 12'hFFF;
                    // d
                    else if(seg_bits[6] && local_y>=H/2-3 && local_y<H/2+3 && local_x>3 && local_x<CHAR_W-3)
                        {vga_r,vga_g,vga_b} = 12'hFFF;
                    // g
                    else if(seg_bits[3] && local_y>=H-5 && local_x>3 && local_x<CHAR_W-3)
                        {vga_r,vga_g,vga_b} = 12'hFFF;
                    // b
                    else if(seg_bits[1] && local_x>=CHAR_W-5 && local_y>3 && local_y<H/2-3)
                        {vga_r,vga_g,vga_b} = 12'hFFF;
                    // c
                    else if(seg_bits[2] && local_x>=CHAR_W-5 && local_y>H/2+3 && local_y<H-3)
                        {vga_r,vga_g,vga_b} = 12'hFFF;
                    // e
                    else if(seg_bits[4] && local_x<5 && local_y>H/2+3 && local_y<H-3)
                        {vga_r,vga_g,vga_b} = 12'hFFF;
                    // f
                    else if(seg_bits[5] && local_x<5 && local_y>3 && local_y<H/2-3)
                        {vga_r,vga_g,vga_b} = 12'hFFF;
                end

                // ===== 연산자 ===== (idx 6)
                else if (idx == 6) begin
                    case (operator)
                        2'b00: begin // +
                            if ((local_x>CHAR_W/2-1 && local_x<CHAR_W/2+1) ||
                                (local_y>H/2-2 && local_y<H/2+2))
                                {vga_r,vga_g,vga_b} = 12'hFFF;
                        end
                        2'b01: begin // -
                            if (local_y>H/2-2 && local_y<H/2+2)
                                {vga_r,vga_g,vga_b} = 12'hFFF;
                        end
                        2'b10: begin // *
                            if (local_x == local_y/2 ||
                                local_x == (CHAR_W - local_y/2))
                                {vga_r,vga_g,vga_b} = 12'hFFF;
                        end
                        2'b11: begin // /
                            if (local_x == (CHAR_W - local_y/2))
                                {vga_r,vga_g,vga_b} = 12'hFFF;
                        end
                    endcase
                end

                // ===== '=' ===== (idx 13)
                else if (idx == 13) begin
                    if ((local_y>H/2-9 && local_y<H/2-5) ||
                        (local_y>H/2+5 && local_y<H/2+9))
                        {vga_r,vga_g,vga_b} = 12'hFFF;
                end
            end

            // -----------------------------
            // 오른쪽 GAP ? 소수점
            // -----------------------------
            else begin
                if ((idx == op1_dp_cell) ||
                    (idx == op2_dp_cell) ||
                    (idx == res_dp_cell)) begin

                    if (local_x > CHAR_W+1 && local_x < CHAR_W+4 &&
                        local_y > H-10      && local_y < H-6)
                        {vga_r,vga_g,vga_b} = 12'hFFF;
                end
            end
        end
    end

endmodule
