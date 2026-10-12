`timescale 1ns / 1ps

module vga_sync_640x480(
    input  wire       clk,       // 25 MHz
    input  wire       rst,
    output reg  [9:0] x,         // 0..639
    output reg  [9:0] y,         // 0..479
    output wire       hsync,
    output wire       vsync,
    output wire       video_on
);

    // 타이밍 파라미터 (픽셀 단위)
    localparam H_VISIBLE  = 640;
    localparam H_FRONT    = 16;
    localparam H_SYNC     = 96;
    localparam H_BACK     = 48;
    localparam H_TOTAL    = H_VISIBLE + H_FRONT + H_SYNC + H_BACK;

    localparam V_VISIBLE  = 480;
    localparam V_FRONT    = 10;
    localparam V_SYNC     = 2;
    localparam V_BACK     = 33;
    localparam V_TOTAL    = V_VISIBLE + V_FRONT + V_SYNC + V_BACK;

    reg [9:0] h_count;
    reg [9:0] v_count;

    // 수평 카운터
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h_count <= 0;
        end else if (h_count == H_TOTAL-1) begin
            h_count <= 0;
        end else begin
            h_count <= h_count + 1;
        end
    end

    // 수직 카운터
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            v_count <= 0;
        end else if (h_count == H_TOTAL-1) begin
            if (v_count == V_TOTAL-1)
                v_count <= 0;
            else
                v_count <= v_count + 1;
        end
    end

    // 현재 픽셀 좌표 (보이는 영역 0..639, 0..479)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= 0;
            y <= 0;
        end else begin
            x <= h_count;
            y <= v_count;
        end
    end

    // 동기 신호 (active low)
    assign hsync = ~((h_count >= H_VISIBLE + H_FRONT) &&
                     (h_count <  H_VISIBLE + H_FRONT + H_SYNC));

    assign vsync = ~((v_count >= V_VISIBLE + V_FRONT) &&
                     (v_count <  V_VISIBLE + V_FRONT + V_SYNC));

    // 보이는 구간
    assign video_on = (h_count < H_VISIBLE) && (v_count < V_VISIBLE);

endmodule
