`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/15 20:23:50
// Design Name: 
// Module Name: tb_BCDcnt_cas
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_BCDcnt_cas_();

    // Testbench             ȣ     
    reg clk;
    reg reset;
    reg inc;
    wire [3:0] Q;
    wire TC;

    // DUT (Device Under Test)  ν  Ͻ ȭ
    BCDcnt_cas uut (
        .Q(Q),
        .TC(TC),
        .inc(inc),
        .reset(reset),
        .clk(clk)
    );

    // 10ns  ֱ    Ŭ       
    always #5 clk = ~clk;

    // Test  ó       ۼ 
    initial begin
        //  ʱ    ȣ     
        clk = 0;
        reset = 0;
        inc = 0;

        // 1. Reset  ׽ Ʈ:         Q   0     Ȯ  
        reset = 1;
        #10;  //           10ns    
        reset = 0;

        // 2. Increment  ׽ Ʈ: Q   0     9          ϴ    Ȯ  
        inc = 1;
        #100;  // 10     Ŭ    ֱ             Ű  

        // 3. TC (Terminal Count)  ׽ Ʈ: Q   9     0        µǴ    Ȯ  
        #10;  //  ߰  Ŭ    ֱ      (Q   9     0        ư     )
        
        // 4. Increment       ׽ Ʈ: inc = 0      Q        Ǵ    Ȯ  
        inc = 0;
        #50;  // 5     Ŭ    ֱ     

        // 5.  ٽ  Increment  ׽ Ʈ: Q               ٽ       ϴ    Ȯ  
        inc = 1;
        #50;

        // 6. Test  Ϸ ,  ùķ  ̼      
        $finish;
    end

    // Q   TC     ȭ       ͸ 
    initial begin
        $monitor("Time = %0t | Q = %0d | TC = %b | Reset = %b | Inc = %b", 
                  $time, Q, TC, reset, inc);
    end

endmodule
