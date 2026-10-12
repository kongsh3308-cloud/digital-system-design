module datapath(input wire clk, rst, inc, loadP, output wire D6, D7,D11,eq, 
                output wire [2:0] dice1, dice2);

wire tc;
wire [3:0] sum;
reg [3:0] point;

counter_1to6 d1 (.clk(clk), .rst(rst), .inc(inc), .Q(dice1), .tc(tc));
counter_1to6 d2 (.clk(clk), .rst(rst), .inc(tc), .Q(dice2), .tc());

assign sum = dice1+dice2;

always @(posedge clk)
  if(rst) point <= 4'd0;
  else if(loadP) point <= sum;
assign D6 = (sum == 4'b0110)?1:0;
assign D7 = (sum == 4'b0111)?1:0;
assign D11 = (sum == 4'd11)?1:0;
assign eq = (sum == point)?1:0;
  
endmodule
