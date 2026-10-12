`timescale 1ns / 1ps

module vga_display(
    input wire clk,
    input wire clk_en,
    input wire rst,
    output reg [9:0] hcnt,
    output reg [9:0] vcnt,
    output reg hsyncb,
    output reg vsyncb,
	output wire detect_neg_vsyncb,
	output reg video_off
    //input wire en,
	//input wire en2
    );

reg vsyncb_1, vsyncb_2, vsyncb_3, vsyncb_4, vsyncb_5;
reg hsyncb_1, hsyncb_2, hsyncb_3, hsyncb_4, hsyncb_5;



localparam [9:0] ACTIVE_VIDEO_TIC = 640;
localparam [9:0] FRONT_PORCH_TIC = 16;
localparam [9:0] HRZ_SYNC_TIC = 96;
localparam [9:0] BACK_PORCH_TIC = 48;

localparam [9:0] ACTIVE_VERT_LINE = 480;
localparam [9:0] FRONT_PORCH_LINE = 10;
localparam [9:0] VERT_SYNC_LINE = 2;
localparam [9:0] BACK_PORCH_LINE = 29;

localparam [9:0] SCAN_LINE_TIME_MAX_TIC = ACTIVE_VIDEO_TIC+FRONT_PORCH_TIC+HRZ_SYNC_TIC+BACK_PORCH_TIC;
localparam [9:0] LINE_NUM_LIM = 521;// 524

reg buf_hsyncb, buf_vsyncb;

always @(posedge clk, posedge rst)
	if (rst)
		hcnt <= 'b0;
	else if(clk_en) begin
            if (hcnt == SCAN_LINE_TIME_MAX_TIC-1 )		// 799-48
                hcnt <= 0;
            else 
                hcnt <= hcnt + 1;
	end
	
always @( posedge clk, posedge rst)
	if (rst)
		buf_hsyncb <= 'b1;
	else if(clk_en)
		buf_hsyncb <= hsyncb;

// hsyncb의 rising edge를 detect한다.		
//assign detect_hsyncb = ( hsyncb & ~buf_hsyncb);

always @(posedge clk, posedge rst)
	if (rst)
		vcnt <= 'b0;
	else if(clk_en) begin
        if (hcnt == SCAN_LINE_TIME_MAX_TIC-1) begin
            if ( vcnt == LINE_NUM_LIM-1)
                vcnt <= 0;
            else
                vcnt <= vcnt + 1;
        end
     end	
       
//  for centering the horiz position hsyncb should be asserted at the time 
//   +   640 <=  real display period
//   +   16 <= FRONT_PORCH_TIC
//   = 640 + 16 = 656

always @(posedge clk, posedge rst)
	if (rst) begin 
		hsyncb <= 1;
    end
	else if(clk_en) begin
            if ((hcnt >= 655+BACK_PORCH_TIC ) && (hcnt < 655+BACK_PORCH_TIC+HRZ_SYNC_TIC))	//96
//            if ((hcnt >= 655) && (hcnt < 655+HRZ_SYNC_TIC))
                hsyncb <= 'b0;
            else
                hsyncb <= 'b1;
    end

// for centering the vertical  position hsyncb should be asserted at the time 
  //   +   480 <=  real  display period
  //   +   10 <= FRONT_PORCH_LINE
  //   =   480 + 10 = 490 line
  
always @(posedge clk, posedge rst)
	if (rst) begin 
		vsyncb <= 1;
	end	
	else if(clk_en) begin
	 // if ((vcnt >= BACK_PORCH_LINE+490) && (vcnt < BACK_PORCH_LINE+490 + VERT_SYNC_LINE))//492
	  if ((vcnt >= 489) && (vcnt < 489 + VERT_SYNC_LINE))//492
		  vsyncb <= 'b0;
	   else
		  vsyncb <= 'b1;
     end

always @(posedge clk, posedge rst) begin
     if(rst)
        buf_vsyncb <= 1;
      else if (clk_en)
        buf_vsyncb <= vsyncb;
end

assign detect_neg_vsyncb = (buf_vsyncb & ~vsyncb);
    
always @(posedge clk, posedge rst) begin
	if(rst)
		video_off <= 1;
	else begin if(clk_en)
	   //if( (vcnt < BACK_PORCH_LINE) || (vcnt > (480+BACK_PORCH_LINE-1) && (vcnt < LINE_NUM_LIM)))
	   if( vcnt > 480 && vcnt < LINE_NUM_LIM)
		  video_off <= 1;
    	else
	      video_off <= 0;
    end
end

endmodule
