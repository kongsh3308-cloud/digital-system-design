`timescale 1ns / 1ps
// Module Name: FullSubtractor
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module FullSubtractor (
    input A,       // Minuend
    input B,       // Subtrahend
    input Bin,     // Borrow-in
    output D,      // Difference
    output Bout    // Borrow-out
);
    assign D = A ^ B ^ Bin;                     //         
    assign Bout = (~A & (B ^ Bin)) | (B & Bin); // Borrow-out    
    
endmodule

