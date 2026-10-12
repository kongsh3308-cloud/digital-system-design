`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////
// Module Name: 4bitComparator
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module EightbitComparator(
    input [7:0] A, 
    input [7:0] B,
    output reg GT,
    output reg LT,
    output reg EQ
    );
    
    // Solution1: Compare A and B
    always @(*) begin
        if(A>B) begin
            GT = 1; LT=0; EQ=0; end
      
        else if(A<B) begin
            GT = 0; LT=1; EQ=0; end
            
        else begin
            GT = 0; LT=0; EQ=1; end            
     end    
    
    // Solution2: A-B ?
    wire [7:0] D;     // Difference result
    wire borrow_out;  // Borrow output from subtraction

    // Subtract B from A
    assign {borrow_out, D} = A - B;

    always @(*) begin
        // Check if A > B, A < B, or A == B based on subtraction result
        if (D == 8'b00000000) begin
            EQ = 1;   // A == B
            GT = 0;
            LT = 0;
        end else if (borrow_out == 1) begin
            EQ = 0;
            GT = 0;
            LT = 1;   // A < B
        end else begin
            EQ = 0;
            GT = 1;   // A > B
            LT = 0;
        end
    end
    
endmodule
