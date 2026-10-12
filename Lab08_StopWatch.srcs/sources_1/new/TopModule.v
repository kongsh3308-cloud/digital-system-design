`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/10 09:48:15
// Design Name: 
// Module Name: stopwatch
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


module TopModule(
    input CLK100MHZ, BTNC, BTND,
    output CA,
    output CB,
    output CC,
    output CD,
    output CE,
    output CF,
    output CG,
    output DP,
    output reg [7:0]AN
    );
    wire en,sw;
    wire [3:0] data0;
    wire [3:0] data1;
    wire [3:0] data2;
    wire [3:0] data3;
    wire [3:0] data4;
    wire [3:0] data5;
    wire [3:0] data6;
    wire [3:0] data7;
    wire [3:0] data8;
    wire [3:0] data9;
    
	reg [2:0]sel;
	reg [3:0] data;
	wire enable_bcd;
	wire enable_clock;
	wire bcd_cnt_en;
	count_1M(CLK100MHZ, BTNC, enable_bcd);//24'd10_000_000;
	enable_clock u9(CLK100MHZ, BTNC, enable_clock);
	assign bcd_cnt_en=enable_bcd&en;
	always@(posedge CLK100MHZ)
        if(BTNC)
            sel <=2'b000;
        else if (enable_clock)
            sel = sel+1;
    
	always @(*)//8:1 Mux
		case(sel)
		3'b000: data=data2;
		3'b001: data=data3;
		3'b010: data=data4;
		3'b011: data=data5;
		3'b100: data=data6;
		3'b101: data=data7;
		3'b110: data=data8;
		default: data=data9;
		endcase
    
    always@(*)begin//3:8decoder
        AN=8'b1111_1111;
        case(sel)
        3'b000: AN[0]=0;
		3'b001: AN[1]=0;
		3'b010: AN[2]=0;
		3'b011: AN[3]=0;
		3'b100: AN[4]=0;
		3'b101: AN[5]=0;
		3'b110: AN[6]=0;
		default: AN[7]=0;
		endcase
		end
	
	ss_decoder data_decode (
    .Din(data), 
    .a(CA), 
    .b(CB), 
    .c(CC), 
    .d(CD), 
    .e(CE), 
    .f(CF), 
    .g(CG), 
    .dp(DP)
    );
    wire [8:0] tc;
    bcd uu0( CLK100MHZ, BTNC, bcd_cnt_en, tc[0], data0);//bcd 0.01
    bcd uu1( CLK100MHZ, BTNC, tc[0], tc[1], data1);//bcd 0.1
    bcd uu2( CLK100MHZ, BTNC, tc[1], tc[2], data2);//bcd
    count6 uu3( CLK100MHZ, BTNC, tc[2], tc[3], data3);//count6
    bcd uu4( CLK100MHZ, BTNC, tc[3], tc[4], data4);//bcd
    count6 uu5( CLK100MHZ, BTNC, tc[4], tc[5], data5);//count6
    bcd uu6( CLK100MHZ, BTNC, tc[5], tc[6], data6);//bcd
    bcd uu7( CLK100MHZ, BTNC, tc[6], tc[7], data7);//bcd
    bcd uu8( CLK100MHZ, BTNC, tc[7], tc[8], data8);//bcd
    bcd uu9( CLK100MHZ, BTNC, tc[8], TC_1M, data9);//bcd
  
    swatch_control u15 (.clk(CLK100MHZ), .reset(BTNC), .sw(sw), .en(en));
    pulse_debounce u16 (.clk(CLK100MHZ), .reset(BTNC), .button(BTND), .en(enable_bcd), .sig(sw));

endmodule