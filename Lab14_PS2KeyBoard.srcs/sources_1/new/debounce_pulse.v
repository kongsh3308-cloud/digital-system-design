`timescale 1ns / 1ps

module debounce_pulse(
    input wire clk,
    input wire rst,
    input wire Din,
    output wire Dout
    );
	 wire A;
	 reg B,C;
	 integer cnt;
	 
	 assign A = Din;
	 
	 always @(posedge clk)
		if(rst==1) begin
			B <= 0;
			C <= 0;
		end
		else begin
			B <= A;
			C <= B;
		end
		
		assign Dout = (~C & B);

endmodule
