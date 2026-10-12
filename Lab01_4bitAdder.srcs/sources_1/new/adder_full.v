module adder_full(
    input A,
    input B,
    input Cin,
    output Cout,
    output S
    );
    
//    wire w1, w2, w3;
    
//    adder_half h1( .A(A), .B(B), .Cout(w2), .S(w1) );
//    adder_half h2( .A(w1), .B(Cin), .Cout(w3), .S(S) );
    
    assign {Cout, S} = (A + B + Cin);
    
endmodule