`default_nettype none

 module dice_core (input wire clk, rst, roll, 
              output wire win, lose, DP,
              output wire [6:0] sseg,
              output wire [7:0] AN);
 
 wire loadP, inc, D6, D7, D11, eq, roll_clean;
 wire [2:0] data7, data6, data5, data4, data3, data2, data1, dice1, dice2;
 wire ssA, ssB, ssC, ssD, ssE, ssF, ssG, ssDP, AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0;

 
datapath u0 (clk, rst, inc, loadP, D6, D7, D11,eq, dice1, dice2);
controller u1 (clk, rst, roll_clean, D6, D7, D11, eq, win, lose, inc, loadP);
debounce_sync u2 (.clk(clk), .ext_in(roll), .sig(roll_clean));

ss_drive u3 (.clk(clk), .rst(rst), .data7(), .data6(), .data5(), .data4(), .data3(), .data2(loadP),
    .data1(dice1), .data0(dice2), .mask(8'b00000011),
    .ssA(sseg[0]), .ssB(sseg[1]), .ssC(sseg[2]), .ssD(sseg[3]), .ssE(sseg[4]),
    .ssF(sseg[5]), .ssG(sseg[6]), .ssDP(DP),
    .AN7(AN[7]), .AN6(AN[6]), .AN5(AN[5]), .AN4(AN[4]), .AN3(AN[3]), .AN2(AN[2]), .AN1(AN[1]), .AN0(AN[0]));
    
endmodule