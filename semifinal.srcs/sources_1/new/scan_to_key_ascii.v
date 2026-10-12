`timescale 1ns / 1ps

module scan_to_key_ascii(
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] scancode,    // ps2_kbd_new에서 나온 ASCII 스타일 코드
    input  wire       scan_ready,  // Released 펄스

    output reg  [3:0] digit,
    output reg        is_digit,

    output reg  [1:0] op_code,     // 00:+, 01:-, 10:*, 11:/
    output reg        is_op,

    output reg        is_enter,
    output reg        is_clear,
    output reg        is_dot       // '.' 눌렸을 때 1클럭 pulse
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            digit    <= 4'd0;
            is_digit <= 1'b0;
            op_code  <= 2'b00;
            is_op    <= 1'b0;
            is_enter <= 1'b0;
            is_clear <= 1'b0;
            is_dot   <= 1'b0;
        end else begin
            // 기본 0으로 클리어
            is_digit <= 1'b0;
            is_op    <= 1'b0;
            is_enter <= 1'b0;
            is_clear <= 1'b0;
            is_dot   <= 1'b0;

            if (scan_ready) begin
                case (scancode)
                    // '0' ~ '9'
                    8'h30: begin digit <= 4'd0; is_digit <= 1'b1; end
                    8'h31: begin digit <= 4'd1; is_digit <= 1'b1; end
                    8'h32: begin digit <= 4'd2; is_digit <= 1'b1; end
                    8'h33: begin digit <= 4'd3; is_digit <= 1'b1; end
                    8'h34: begin digit <= 4'd4; is_digit <= 1'b1; end
                    8'h35: begin digit <= 4'd5; is_digit <= 1'b1; end
                    8'h36: begin digit <= 4'd6; is_digit <= 1'b1; end
                    8'h37: begin digit <= 4'd7; is_digit <= 1'b1; end
                    8'h38: begin digit <= 4'd8; is_digit <= 1'b1; end
                    8'h39: begin digit <= 4'd9; is_digit <= 1'b1; end

                    // 연산자들 (ASCII 값)
                    8'h2B: begin op_code <= 2'b00; is_op <= 1'b1; end // '+'
                    8'h2D: begin op_code <= 2'b01; is_op <= 1'b1; end // '-'
                    8'h2A: begin op_code <= 2'b10; is_op <= 1'b1; end // '*'
                    8'h2F: begin op_code <= 2'b11; is_op <= 1'b1; end // '/'

                    // Enter
                    8'h0D: begin is_enter <= 1'b1; end

                    // ESC → 전체 Clear
                    8'h1B: begin is_clear <= 1'b1; end

                    // '.' (메인 키보드 / 넘패드 둘 다 ASCII 0x2E로 들어옴)
                    8'h2E: begin is_dot <= 1'b1; end

                    default: ; // 나머지는 무시
                endcase
            end
        end
    end

endmodule
