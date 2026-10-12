`timescale 1ns / 1ps

module vga_data(
    input wire clk,
    input wire clk_en,
    input wire rst,
	input wire [9:0] imageWidth,
	input wire [8:0] imageHeight,
    input wire [9:0] hcnt,
    input wire [9:0] vcnt,
	input wire [7:0] data,
	input wire [9:0] Xposition1,
	input wire [8:0] Yposition1,
	input wire detect_neg_vsyncb,
	output reg [18:0] addr,
    output reg [7:0] rgb
    );
localparam [9:0] BACK_PORCH_TIC = 48;

reg [1:0] cnt2;
wire [9:0]  Xposition2, Yposition2;
wire inXrange, inYrange;
reg [7:0] rgb_buffer;
reg buff;
wire screen_on;
wire plus_addr;

//localparam Xposition1 = 0;
//localparam Yposition1 = 0;
assign Xposition2 = ((Xposition1 + imageWidth)> 640) ? 640:(Xposition1 + imageWidth);
assign Yposition2 = ((Yposition1 + imageHeight)>480)? 480:(Yposition1 + imageHeight);

assign inYrange = ((vcnt >= Yposition1) && (vcnt < Yposition2)) ? 'b1 : 'b0;
assign inXrange = ((hcnt >= (Xposition1 + BACK_PORCH_TIC)) && (hcnt < (Xposition2 + BACK_PORCH_TIC))) ? 'b1 : 'b0; 

assign screen_on = (inXrange & inYrange) ;

always @(posedge clk, posedge rst) // pixel data를 update 해주는 부분
	if (rst) begin
		rgb_buffer <= 0;
		rgb <= 0;
	end 
	else if(clk_en) begin
	       if ((screen_on) || ((hcnt == Xposition2+BACK_PORCH_TIC) && inYrange)) begin
                // if (cnt2 == 2'b10 || cnt2 == 2'b00) begin
                    rgb <= data[7:0];
                //  end
            end
            else begin
                rgb <= 0;
            end
       end
       
//always @(posedge clk, posedge rst)
//	if (rst)
//		cnt2 <= 0;
//	else if (clk_en) begin
//        if (screen_on) begin
//            cnt2 <= cnt2 + 1;
//            if(cnt2 == 3)
//                cnt2 <= 0;			 
//        end
//    end
                
// assign plus_addr = ((cnt2 == 2'b10 || cnt2 == 2'b00) && screen_on)? 'b1 : 'b0;
assign plus_addr = screen_on;

always @(posedge clk, posedge rst)
	if (rst) begin
		addr <= 'b0;
	//	buff <= 'b0;
		end
	else if(clk_en) begin
        if (detect_neg_vsyncb == 'b1) begin
            addr <= 'b0;
           // buff <= 'b0;
            end
        else if (plus_addr == 'b1) begin
                addr <= addr + 1;
            end
    end
	
endmodule
