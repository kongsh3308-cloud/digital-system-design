module controller (input wire clk, rst, roll, D6, D7, D11, eq,
        output wire win, lose, inc, loadP);
        
localparam [2:0] S0 = 3'd0, S1 = 3'd1, S2 = 3'd2,
                 S3 = 3'd3, S4 = 3'd4, S5 = 3'd5;
reg [2:0] state, next_st;

always  @(posedge clk)
    if(rst)
        state <= S0;
    else
        state <= next_st;
        
always @*
    case (state)
    S0: if(roll == 0) next_st = S0; else next_st = S1;
    S1: if(roll) next_st = S1;
        else if(D7|D11) next_st = S2; //win
        else if(D6) next_st = S3; // lose
        else next_st = S4; //2nd try
    S2: next_st = S2;
    S3: next_st = S3;
    S4: if(roll == 0) next_st = S4; else next_st = S5;
    S5: if(roll) next_st = S5;
        else if(D7|D6) next_st = S3; // lose
        else if(eq) next_st = S2; //win
        else next_st = S4; //3nd try
    default: next_st = S0;
    endcase

assign win = (state == S2)?1:0;
assign lose = (state == S3)? 1:0;
assign inc = (state == S1 && roll) || (state == S5 && roll)?1:0;
assign loadP = (state == S1 && ~(roll|D7|D11|D6))?1:0;

    
endmodule