module sevenseg_driver_5digit(
    input  wire       clk,
    input  wire       rst,
    input  wire       error,
    input  wire [3:0] bcd0,  // 1의 자리
    input  wire [3:0] bcd1,  // 10
    input  wire [3:0] bcd2,  // 100
    input  wire [3:0] bcd3,  // 1000
    input  wire [3:0] bcd4,  // 10000
    input  wire       sign,          // A안에서는 사용하지 않음 (그냥 무시)
    input  wire [2:0] frac_digits,   // 소수 자리수 (0~3)
    output reg  [7:0] an,
    output reg  [6:0] seg,
    output reg        dp
);

    reg [2:0] digit_sel;
    reg [3:0] cur_bcd;

    // 간단한 분주기 (자리 스캔용)
    reg [15:0] cnt;
    always @(posedge clk or posedge rst) begin
        if (rst)
            cnt <= 16'd0;
        else
            cnt <= cnt + 16'd1;
    end

    // cnt가 한 바퀴 돌 때마다 다음 자리 선택
    always @(posedge clk or posedge rst) begin
        if (rst)
            digit_sel <= 3'd0;
        else if (cnt == 16'd0)
            digit_sel <= digit_sel + 3'd1;
    end

    always @(*) begin
        // 기본값
        an      = 8'b1111_1111; // 모두 off (active-low)
        seg     = 7'b1111111;   // blank
        dp      = 1'b1;         // 소수점 off (common anode 기준)
        cur_bcd = 4'd0;

        //=============== 에러 표시 우선 ===============
        if (error) begin
            // 에러면 an0 자리에만 'E' 표시
            an  = 8'b1111_1110;   // an0 on
            seg = 7'b0000110;     // 'E'
            dp  = 1'b1;
        end
        //============== 정상 동작 =====================
        else begin
            // 1) 어떤 자리(an)와 현재 BCD 선택
            case (digit_sel)
                3'd0: begin
                    an      = 8'b1111_1110; // an0 (가장 오른쪽)
                    cur_bcd = bcd0;
                end
                3'd1: begin
                    an      = 8'b1111_1101; // an1
                    cur_bcd = bcd1;
                end
                3'd2: begin
                    an      = 8'b1111_1011; // an2
                    cur_bcd = bcd2;
                end
                3'd3: begin
                    an      = 8'b1111_0111; // an3
                    cur_bcd = bcd3;
                end
                3'd4: begin
                    an      = 8'b1110_1111; // an4 (다섯 번째 자리)
                    cur_bcd = bcd4;         // ★ 더 이상 부호 처리 안 함, 그냥 숫자
                end
                default: begin
                    an      = 8'b1111_1111; // 나머지 자리 off
                    cur_bcd = 4'd0;
                end
            endcase

            // 2) BCD → 7세그 패턴 변환
            case (cur_bcd)
                4'd0: seg = 7'b1000000;
                4'd1: seg = 7'b1111001;
                4'd2: seg = 7'b0100100;
                4'd3: seg = 7'b0110000;
                4'd4: seg = 7'b0011001;
                4'd5: seg = 7'b0010010;
                4'd6: seg = 7'b0000010;
                4'd7: seg = 7'b1111000;
                4'd8: seg = 7'b0000000;
                4'd9: seg = 7'b0010000;
                default: seg = 7'b1111111; // blank
            endcase

            // 3) 소수점 위치 결정
            dp = 1'b1; // 기본 off
            if (frac_digits != 3'd0 && digit_sel == frac_digits)
                dp = 1'b0; // 해당 자리 dp on (common anode 기준)
        end
    end

endmodule
