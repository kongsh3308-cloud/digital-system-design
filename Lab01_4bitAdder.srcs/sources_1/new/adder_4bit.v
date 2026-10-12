`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////
// Module Name: adder_4bit

// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module adder_4bit(
    input [3:0] A,
    input [3:0] B,
    output Cout,
    output [3:0] S
    );
    
    wire c1, c2, c3;
    
    adder_full f1( .A(A[0]), .B(B[0]), .Cin(1'b0), .Cout(c1), .S(S[0]) );
    adder_full f2( .A(A[1]), .B(B[1]), .Cin(c1), .Cout(c2), .S(S[1]) );
    adder_full f3( .A(A[2]), .B(B[2]), .Cin(c2), .Cout(c3), .S(S[2]) );
    adder_full f4( .A(A[3]), .B(B[3]), .Cin(c3), .Cout(Cout), .S(S[3]) );
 
    
endmodule
