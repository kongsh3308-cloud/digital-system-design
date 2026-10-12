`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/01 14:09:57
// Design Name: 
// Module Name: VGA_mem_top
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
    input            clk,            // Clock input 100MHZ
    input            rst,            // Active HIGH reset
    input       [3:0] SW,            // input Y_offset switch    
    output   [3:0] VGA_R, VGA_G, VGA_B,
    output            hsyncb,
    output            vsyncb    
);

    wire [11:0] bgr;    
    wire clk_100, clk_50, clk_25;
    wire [18:0] address;
    wire [7:0] data1, data2; // Two data outputs for two .coe files
    wire [7:0] data;         // Selected data based on SW[0]
    
    // Clock core
    clk_wiz_0 clk_inst (
        .clk_out1(clk_100),
        .clk_out2(clk_50),
        .clk_out3(clk_25),
        .reset(rst), 
        .locked(),
        .clk_in1(clk)
    );
    
    // Frame buffer for .coe file 1
    blk_mem_gen_0 frame_buffer_1 (
        .clka(clk_50),    
        .wea(1'b0),        // Read-only
        .addra(address),   
        .dina(8'd0),       
        .douta(data1)      
    );        
    
    // Frame buffer for .coe file 2
    blk_mem_gen_1 frame_buffer_2 (
        .clka(clk_50),    
        .wea(1'b0),        // Read-only
        .addra(address),   
        .dina(8'd0),       
        .douta(data2)      
    );        
    
    // Select data based on SW[0]
    assign data = (SW[0]) ? data2 : data1;
    
    // VGA Signal Assignment
    assign {VGA_B, VGA_G, VGA_R} = bgr;
    
    TOP_VGA vga (
        .clk(clk_25),
        .clk_en(1'b1),    // Enables VGA
        .rst(rst),
        .din(data),
        .WES(),
        .addr(address),
        .bgr(bgr),
        .hsyncb(hsyncb),
        .vsyncb(vsyncb),
        .Yoffset_top({1'b0,SW[3:1]})
    );

endmodule
