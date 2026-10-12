`timescale 1ns / 1ps

module VGA_module(
    input wire clk, // 25MHz clock
  //  input wire clk2x,// 50MHz
    input wire clk_en,
    input wire rst,
	input wire [7:0] data,
	input wire [9:0] Xoffset,
	input wire [8:0] Yoffset,
    input wire [9:0] imageWidth,
    input wire [8:0] imageHeight, 
	output wire hsyncb,
	output wire vsyncb,
	output wire [18:0] addr,
	output wire video_off,
    output wire [7:0] rgb
    );
	
wire [9:0] hcnt, vcnt;	
wire detect_neg_vsyncb;

vga_display VGAdisp (
    .clk(clk), 
    .rst(rst), 
    .clk_en(clk_en),
    .hcnt(hcnt), 
    .vcnt(vcnt), 
    .hsyncb(hsyncb), 
    .vsyncb(vsyncb),
	.detect_neg_vsyncb(detect_neg_vsyncb),
   // .en(1'b1),
	.video_off(video_off)
	//.en2(en25Mhz)
    );

vga_data VGAdata (
    .clk(clk),
    .rst(rst), 
    .clk_en(clk_en),
    .hcnt(hcnt), 
    .vcnt(vcnt), 
	.Xposition1(Xoffset),
	.Yposition1(Yoffset),
	.imageWidth(imageWidth), 
    .imageHeight(imageHeight), 
    .data(data), 
    .addr(addr),
	.detect_neg_vsyncb(detect_neg_vsyncb),
    .rgb(rgb)
    );
	 
endmodule
