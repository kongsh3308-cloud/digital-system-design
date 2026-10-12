module vga_bram_bg(
    input  wire       clk_pix,   // 25MHz
    input  wire       video_on,
    input  wire [9:0] x,
    input  wire [9:0] y,
    output reg  [3:0] r,
    output reg  [3:0] g,
    output reg  [3:0] b
);
    // 640*480 = 307200 → 19bit
    reg  [18:0] addr;
    wire [7:0]  dout;
    reg         video_on_d;

    // 주소 계산 + video_on 1클럭 딜레이
    always @(posedge clk_pix) begin
        addr       <= (y << 9) + (y << 7) + x;  // y*640 + x
        video_on_d <= video_on;
    end

    // ★ RAM IP 인스턴스 (wea=0, dina=0 → 읽기만)
    blk_mem_gen_0 img_ram (
        .clka  (clk_pix),
        .wea   (1'b0),
        .addra (addr),
        .dina  (8'd0),
        .douta (dout)
    );

    // 8bit → 4:4:4 RGB (그레이스케일 예시)
    always @(posedge clk_pix) begin
        if (!video_on_d) begin
            r <= 4'd0;
            g <= 4'd0;
            b <= 4'd0;
        end else begin
            r <= dout[7:4];
            g <= dout[7:4];
            b <= dout[7:4];
        end
    end
endmodule
