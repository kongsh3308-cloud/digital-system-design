`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/17 03:06:27
// Design Name: 
// Module Name: VGA_controller
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
    input CLK100MHZ, reset,
    output VGA_HS, VGA_VS,
    output [11:0] vga
    );
    
    localparam COLOR_WHITE  = 12'b1111_1111_1111;
    localparam COLOR_RED = 12'b0000_0000_1111;
    localparam COLOR_GREEN = 12'b0000_1111_0000;
    localparam COLOR_BLUE = 12'b1111_0000_0000;
    localparam COLOR_YELLOW = 12'b0000_1111_1111;
    localparam COLOR_BLACK  = 12'b0000_0000_0000;
    
    localparam BLOCK_WIDTH  = 50;
    localparam BLOCK_HEIGHT = 50;
    localparam BLUE_BLOCK_WIDTH = 30;
    localparam BLUE_BLOCK_HEIGHT = 400;
    
    localparam RED_BLOCK_X    = 50;
    localparam RED_BLOCK_Y    = 50;
    localparam BLUE_BLOCK1_X    = 200;
    localparam BLUE_BLOCK1_Y    = 0;
    localparam BLUE_BLOCK2_X    = 400;
    localparam BLUE_BLOCK2_Y    = 100;
    localparam YELLOW_BLOCK_X = 500;
    localparam YELLOW_BLOCK_Y = 300;
    
    wire video_on, red_block, blue_block1, blue_block2, yellow_block;
    wire pixel_clk;

    wire [9:0] pixel_x, pixel_y;

    reg [11:0] vga_next, vga_reg;
    
    VGA_controller VGA_controller_1(
        .clk(CLK100MHZ), .reset(reset),
        .hsync(VGA_HS), .vsync(VGA_VS),
        .video_on(video_on), .pixel_clk(pixel_clk),
        .pixel_x(pixel_x), .pixel_y(pixel_y)
    );

    always @(posedge CLK100MHZ, posedge reset)
    begin
        if(reset)
            vga_reg <= 12'd0;
        else
            if(pixel_clk)
                vga_reg <= vga_next;
    end

    always @*
    begin
        vga_next = vga_reg;
        if (~video_on)
            vga_next = COLOR_BLACK;
        else
        begin
            vga_next = COLOR_GREEN; 
            if (red_block)
                vga_next = COLOR_RED; 
            if (blue_block1)
                vga_next = COLOR_BLUE; 
            if (blue_block2)
                vga_next = COLOR_BLUE; 
            if (yellow_block)
                vga_next = COLOR_YELLOW; 
        end
    end
    
    assign red_block = (RED_BLOCK_X <= pixel_x ) && (pixel_x < RED_BLOCK_X + BLOCK_WIDTH) && (RED_BLOCK_Y <= pixel_y) && (pixel_y < RED_BLOCK_Y + BLOCK_HEIGHT);        
    assign blue_block1 = (BLUE_BLOCK1_X <= pixel_x ) && (pixel_x < BLUE_BLOCK1_X + BLUE_BLOCK_WIDTH) && (BLUE_BLOCK1_Y <= pixel_y) && (pixel_y < BLUE_BLOCK1_Y + BLUE_BLOCK_HEIGHT);        
    assign blue_block2 = (BLUE_BLOCK2_X <= pixel_x ) && (pixel_x < BLUE_BLOCK2_X + BLUE_BLOCK_WIDTH) && (BLUE_BLOCK2_Y <= pixel_y) && (pixel_y < BLUE_BLOCK2_Y + BLUE_BLOCK_HEIGHT);        
    assign yellow_block = (YELLOW_BLOCK_X <= pixel_x ) && (pixel_x < YELLOW_BLOCK_X + BLOCK_WIDTH) && (YELLOW_BLOCK_Y <= pixel_y) && (pixel_y < YELLOW_BLOCK_Y + BLOCK_HEIGHT);        

    assign vga = vga_reg;

endmodule