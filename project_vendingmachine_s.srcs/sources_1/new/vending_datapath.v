module vending_datapath(
    input  wire clk, rst,
    input  wire p_sense, coin10_sel,   // coin10_sel=1이면 10원, 0이면 5원
    input  wire p_item1, p_item2, p_buy, p_cancel,
    input  wire ld_sel, do_buy, do_cancel,    // controller에서 한클럭
    // led표시
    output wire [3:0] in_h,in_t,in_o,         // 입력금액 BCD (3자리)
    output wire [3:0] sel_h,sel_t,sel_o,      // 선택금액 BCD (3자리)
    output wire [3:0] chg_h,chg_t,chg_o,      // 거스름돈 BCD (3자리)
    output wire [1:0] led
);
    localparam ITEM1 = 10'd20;
    localparam ITEM2 = 10'd100;

    wire add10 = p_sense &  coin10_sel;
    wire add5  = p_sense & ~coin10_sel;

    // 누적 금액
    wire [9:0] total;
    // 구매/취소 시 표시/누적 모두 0으로
    wire clr_all = do_buy | do_cancel;
    money_counter u_cnt(.clk(clk), .rst(rst), .add5(add5), .add10(add10), .clr(clr_all), .total(total));

    // 선택 금액 latch
    reg [9:0] sel_amt;
    always @(posedge clk) begin
        if (rst)          sel_amt <= 10'd0;
        else if (clr_all) sel_amt <= 10'd0;
        else if (ld_sel) begin
            if (p_item1) sel_amt <= ITEM1;
            if (p_item2) sel_amt <= ITEM2;
        end
    end

    // 거스름돈
    // 구매/취소 시 0으로 초기화
    wire [9:0] change_now = (total >= sel_amt)? (total - sel_amt) : 10'd0;
    reg  [9:0] change_disp;
    always @(posedge clk) begin
        if (rst)          change_disp <= 10'd0;
        else if (clr_all) change_disp <= 10'd0;
        else              change_disp <= change_now;
    end

    // 구매 LED: 구매 순간 ON, 다음 p_sense가 들어오면 OFF
    reg [1:0] led_latch;
    always @(posedge clk) begin
        if (rst)             led_latch <= 2'b00;
        else if (p_sense)    led_latch <= 2'b00;
        else if (do_buy) begin
            led_latch <= (sel_amt==ITEM1) ? 2'b01 :
                         (sel_amt==ITEM2) ? 2'b10 : 2'b00;
        end
    end
    assign led = led_latch;

    bcd_converter u_in  (.val(total     ), .hundreds(in_h ), .tens(in_t ), .ones(in_o ));
    bcd_converter u_sel (.val(sel_amt   ), .hundreds(sel_h), .tens(sel_t), .ones(sel_o));
    bcd_converter u_chg (.val(change_disp), .hundreds(chg_h), .tens(chg_t), .ones(chg_o));
endmodule
