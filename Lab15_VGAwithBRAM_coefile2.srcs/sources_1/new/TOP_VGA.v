`timescale 1ns / 1ps

module TOP_VGA #(
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 19
 )(
	input wire clk, // 25MHz
//	input wire clk2x, // 50MHz
	input wire rst,
	input wire clk_en,
	/* Block ram interface */
	input wire [DATA_WIDTH-1:0] din,
    output wire WES,
//    output reg [DATA_WIDTH-1:0] dout,
    output wire [ADDR_WIDTH-1:0] addr,
    /* VGA interface*/
    output wire [11:0] bgr,
    output wire hsyncb,
	output wire vsyncb,
	input wire [3:0] Yoffset_top
    );
    
/* display config */
wire [9:0] Xoffset;
wire [8:0] Yoffset;
wire video_off;


/* sample ram */
wire [DATA_WIDTH-1:0] Wdata;
wire [ADDR_WIDTH-1:0] Waddr;
wire [DATA_WIDTH-1:0] Rdata;
wire [ADDR_WIDTH-1:0] raddr;

wire [3:0] X_OFFSET = 4'b0000;
wire [3:0] Y_OFFSET = Yoffset_top; // or 4'b0000


wire [DATA_WIDTH-1:0] rgb8;

assign Xoffset = {X_OFFSET,6'd00};
assign Yoffset = {Y_OFFSET,5'd00};

localparam XRES = 10'd640;
localparam YRES = 9'd427;

assign bgr = { rgb8[7:6],2'b00, rgb8[5:3],1'b0, rgb8[2:0], 1'b0};

assign Rdata = din;
assign addr = raddr;
assign WES = 1'b0;

VGA_module vga (
    .clk(clk), 
   // .clk2x(clk2x),
    .rst(rst), 
    .clk_en(clk_en),
    .data(Rdata),  // input
    .hsyncb(hsyncb),  // output
    .vsyncb(vsyncb),   // output
	.Xoffset(Xoffset),  //input
	.Yoffset(Yoffset),  // input
	.imageWidth(XRES),  // input
    .imageHeight(YRES), // input
    .addr(raddr),       // output
	.video_off(video_off), // output
    .rgb(rgb8)  // output
    );
	 
endmodule
