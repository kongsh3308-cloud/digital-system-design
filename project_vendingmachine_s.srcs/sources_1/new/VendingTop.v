`default_nettype none
module VendingTop(
    input  wire clk,
    input  wire rst_n, 
    input  wire btn_sense,      // 동전 입력
    input  wire sw_coin10,      // 1:10원, 0:5원
    input  wire btn_item1, btn_item2,  // 상품 선택 버튼
    input  wire btn_buy, btn_cancel,   // 구매/취소 버튼
    output wire [1:0] led,
    output wire [6:0] sseg,
    output wire [7:0] AN,
    output wire DP
);

    wire rst = ~rst_n;

    // 버튼 입력 → 동기화 및 펄스화
    wire p_sense, p_item1, p_item2, p_buy, p_cancel;
    sync_pulse u0(.clk(clk), .rst(rst), .din(btn_sense),  .pulse(p_sense));
    sync_pulse u1(.clk(clk), .rst(rst), .din(btn_item1),  .pulse(p_item1));
    sync_pulse u2(.clk(clk), .rst(rst), .din(btn_item2),  .pulse(p_item2));
    sync_pulse u3(.clk(clk), .rst(rst), .din(btn_buy),    .pulse(p_buy));
    sync_pulse u4(.clk(clk), .rst(rst), .din(btn_cancel), .pulse(p_cancel));

    // 컨트롤러
    wire ld_sel, do_buy, do_cancel;
    vending_controller Uctl(
        .clk(clk), .rst(rst),
        .p_sense(p_sense), .p_item1(p_item1), .p_item2(p_item2),
        .p_buy(p_buy), .p_cancel(p_cancel),
        .ld_sel(ld_sel), .do_buy(do_buy), .do_cancel(do_cancel)
    );
    // 데이터패스
    wire [3:0] in_h,in_t,in_o;
    wire [3:0] sel_h,sel_t,sel_o;
    wire [3:0] chg_h,chg_t,chg_o;

    vending_datapath Udp(
        .clk(clk), .rst(rst),
        .p_sense(p_sense), .coin10_sel(sw_coin10),
        .p_item1(p_item1), .p_item2(p_item2),
        .p_buy(p_buy), .p_cancel(p_cancel),
        .ld_sel(ld_sel), .do_buy(do_buy), .do_cancel(do_cancel),
        .in_h(in_h), .in_t(in_t), .in_o(in_o),
        .sel_h(sel_h), .sel_t(sel_t), .sel_o(sel_o),
        .chg_h(chg_h), .chg_t(chg_t), .chg_o(chg_o),
        .led(led)
    );

    // 7-세그먼트 표시
    reg show_input;
    always @(posedge clk) begin
        if (rst)
            show_input <= 1'b0;
        else if (p_sense)
            show_input <= 1'b1;        // 동전 입력 시
        else if (p_item1 | p_item2)
            show_input <= 1'b0;        // 상품 선택 시
        else if (do_buy | do_cancel)
            show_input <= 1'b0;        // 초기화
    end

    wire [3:0] L3 = show_input ? 4'd0 : sel_h;
    wire [3:0] L2 = show_input ? 4'd0 : sel_t;
    wire [3:0] L1 = show_input ? 4'd0 : sel_o;
    wire [3:0] L0 = 4'd0;

    wire [3:0] R3 = show_input ? in_h  : chg_h;
    wire [3:0] R2 = show_input ? in_t  : chg_t;
    wire [3:0] R1 = show_input ? in_o  : chg_o;
    wire [3:0] R0 = 4'd0;

    ss_drive disp(
        .clk(clk), .rst(rst),
        .data7(L3), .data6(L2), .data5(L1), .data4(L0),
        .data3(R3), .data2(R2), .data1(R1), .data0(R0),
        .mask(8'b1111_1111),
        .ssA(sseg[0]), .ssB(sseg[1]), .ssC(sseg[2]), .ssD(sseg[3]),
        .ssE(sseg[4]), .ssF(sseg[5]), .ssG(sseg[6]), .ssDP(DP),
        .AN7(AN[7]), .AN6(AN[6]), .AN5(AN[5]), .AN4(AN[4]),
        .AN3(AN[3]), .AN2(AN[2]), .AN1(AN[1]), .AN0(AN[0])
    );
endmodule