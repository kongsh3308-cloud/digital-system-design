module vending_controller(
    input  wire clk, rst,
    input  wire p_sense, p_item1, p_item2, p_buy, p_cancel,
    output wire ld_sel,      // 선택금액 래치
    output wire do_buy,      // 구매확정
    output wire do_cancel    // 취소
);
    localparam [2:0] S0=3'd0, S1=3'd1, S2=3'd2, S3=3'd3, S4=3'd4;
    reg [2:0] st, nx;
    always @(posedge clk) st <= rst ? S0 : nx;

    always @* begin
        nx = st;
        case(st)
            S0: begin
                if (p_sense)          nx = S1;
                else if (p_item1|p_item2) nx = S2;
            end
            S1: begin // 동전 계속 입력 가능, 선택/취소로 이동
                if (p_item1|p_item2) nx = S2;
                else if (p_cancel)   nx = S4;
                else                 nx = S1;
            end
            S2: begin // 선택상태: 더 넣으려면 S1로, 구매/취소 처리
                if (p_buy)           nx = S3;
                else if (p_cancel)   nx = S4;
                else if (p_sense)    nx = S1;
                else                 nx = S2;
            end
            S3: nx = S0; // 구매 확정 후 표시 지우고 대기
            S4: nx = S0; // 취소 후 표시 지움
            default: nx = S0;
        endcase
    end

    assign ld_sel   = (st==S2) && (p_item1|p_item2);
    assign do_buy   = (st==S2) && p_buy;
    assign do_cancel= ((st==S1)||(st==S2)) && p_cancel;
endmodule
