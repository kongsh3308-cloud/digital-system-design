`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////
// Module Name: tb_adder_full

// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_adder_full(
    );
    
    reg A, B, Cin;
    wire Cout, S;
    adder_full uut1( .A(A), .B(B), .Cin(Cin), .Cout(Cout), .S(S) );
    
    initial begin
        A=0; B=0; Cin=0;
        #100 A=0; B=1;
        #100 A=1; B=0;
        #100 A=1; B=1;
        #100 A=0; B=0; Cin=1;
        #100 A=0; B=1;
        #100 A=1; B=0;
        #100 A=1; B=1;
        #100 $finish;
    end
        
endmodule
