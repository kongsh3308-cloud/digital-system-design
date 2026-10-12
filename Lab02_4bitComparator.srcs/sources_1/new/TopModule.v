`timescale 1ns / 1ps

module TopModule (
    input [7:0] A,          // 8비트 입력 A
    input [7:0] B,          // 8비트 입력 B
    input En,               // Enable 신호
    output reg GT,          // Greater than 신호
    output reg LT,          // Less than 신호
    output reg EQ           // Equal 신호
);
    wire [7:0] D;     // 8비트 차이 (A - B)
    wire Bout;        // 최종 Borrow-out

    // 8비트 Subtractor 인스턴스화
    EightBitSubtractor U1 (
        .A(A),
        .B(B),
        .Bin(1'b0),    // 초기 Borrow-in 값은 0
        .D(D),         // 차이 출력
        .Bout(Bout)    // Borrow-out 출력
    );

   // 비교 연산 수행
    always @(*) begin
        // 디폴트 값 설정
        GT = 1'b0;  // Greater than 기본값
        LT = 1'b0;  // Less than 기본값
        EQ = 1'b0;  // Equal 기본값

        // Enable 신호가 활성화되었을 때만 비교 연산 수행
        if (En == 1'b1) begin
            // EQ 확인 (A == B)
            if (D == 8'b00000000) begin
                EQ = 1'b1;
            end
            // LT 확인 (A < B)
            else if (Bout == 1'b1) begin
                LT = 1'b1;
            end
            // GT 확인 (A > B)
            else begin
                GT = 1'b1;
            end
        end
    end

endmodule
