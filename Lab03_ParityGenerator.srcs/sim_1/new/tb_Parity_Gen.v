`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/08 11:17:58
// Design Name: 
// Module Name: tb_Parity_Gen
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

module tb_Parity_Gen;  // Testbench      ̸ 

    // DUT    Է°                            ̾      
    reg PRT;  // ¦  (1)  Ǵ  Ȧ  (0)  и Ƽ     
    reg [6:0] data;  // 7  Ʈ         Է 
    wire parity;  //  и Ƽ    

    // DUT  ν  Ͻ ȭ
    Parity_Gen dut (
        .parity(parity),  //         
        .PRT(PRT),  //  Է      
        .data(data)  //  Է      
    );

    //  ׽ Ʈ  ó     
    initial begin
        //  ùķ  ̼         
        $monitor("Time = %0d, PRT = %b, Data = %b, Parity = %b", $time, PRT, data, parity);

        // ¦    и Ƽ  ׽ Ʈ
        PRT = 1;  // ¦    и Ƽ     
        data = 7'b0000000;  //       Ʈ   0      
        #10;
        
        data = 7'b0000001;  // 1       Ʈ   1      
        #10;
        
        data = 7'b0000111;  // 3       Ʈ   1      
        #10;

        data = 7'b1111111;  //       Ʈ   1      
        #10;
        
        // Ȧ    и Ƽ  ׽ Ʈ
        PRT = 0;  // Ȧ    и Ƽ     
        data = 7'b0000000;  //       Ʈ   0      
        #10;
        
        data = 7'b0000001;  // 1       Ʈ   1      
        #10;
        
        data = 7'b0000111;  // 3       Ʈ   1      
        #10;

        data = 7'b1111111;  //       Ʈ   1      
        #10;

        $finish;  //  ùķ  ̼      
    end

endmodule

