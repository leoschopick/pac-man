//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input logic  [9:0] BallX, BallY, DrawX, DrawY, Ball_size, Ball_X_Motion, Ball_Y_Motion, pel_size, blinkyX, blinkyY, pinkyX, pinkyY, clydeX, clydeY, inkyX, inkyY, pellet0X, pellet0Y, pellet1X, pellet1Y, pellet2X, pellet2Y, pellet3X, pellet3Y, pellet4X, pellet4Y, pellet5X, pellet5Y, pellet6X, pellet6Y, pellet7X, pellet7Y, pellet8X, pellet8Y, pellet9X, pellet9Y, pellet10X, pellet10Y, pellet11X, pellet11Y, pellet12X, pellet12Y, pellet13X, pellet13Y, pellet14X, pellet14Y, pellet15X, pellet15Y, pellet16X, pellet16Y, pellet17X, pellet17Y, pellet18X, pellet18Y, pellet19X, pellet19Y, pellet20X, pellet20Y, pellet21X, pellet21Y, pellet22X, pellet22Y, pellet23X, pellet23Y, pellet24X, pellet24Y, pellet25X, pellet25Y, pellet26X, pellet26Y, pellet27X, pellet27Y, pellet28X, pellet28Y, pellet29X, pellet29Y, pellet30X, pellet30Y, pellet31X, pellet31Y, pellet32X, pellet32Y, pellet33X, pellet33Y,
							  input logic  pixel_clk, blank, frame_clk, Reset, win, lose,
							  input logic [34:0] eaten,
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball_on, pel_0_on, pel_1_on, pel_2_on, pel_3_on, pel_4_on, pel_5_on, pel_6_on, pel_7_on, pel_8_on, pel_9_on, pel_10_on, pel_11_on, pel_12_on, pel_13_on, pel_14_on, pel_15_on, pel_16_on, pel_17_on, pel_18_on, pel_19_on, pel_20_on, pel_21_on, pel_22_on, pel_23_on, pel_24_on, pel_25_on, pel_26_on, pel_27_on, pel_28_on, pel_29_on, pel_30_on, pel_31_on, pel_32_on, pel_33_on, blink_on, pink_on, ink_on, clyde_on, white;
	 logic[7:0] sprite_addr;
	 logic[9:0] closed_addr;
	 logic[0:31] sprite_data, blinky_data, pinky_data, inky_data, clyde_data;
	 logic[1:0] Direction;
	 logic[9:0] long_addr, long_blinky_addr, long_pinky_addr, long_inky_addr, long_clyde_addr;
	 logic [639:0] background_data;
	 logic[5:0] count;
	 logic open;
	 logic[9:0] drawbackX, drawbackY;
	 logic[4:0] blinky_addr, pinky_addr, inky_addr, clyde_addr;
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int DistX, DistY, Size, pel0DistX, pel0DistY, pel1DistX, pel1DistY, pel2DistX, pel2DistY, pel3DistX, pel3DistY, pel4DistX, pel4DistY, pel5DistX, pel5DistY, pel6DistX, pel6DistY, pel7DistX, pel7DistY, pel8DistX, pel8DistY, pel9DistX, pel9DistY, pel10DistX, pel10DistY, pel11DistX, pel11DistY, pel12DistX, pel12DistY, pel13DistX, pel13DistY, pel14DistX, pel14DistY, pel15DistX, pel15DistY, pel16DistX, pel16DistY, pel17DistX, pel17DistY, pel18DistX, pel18DistY, pel19DistX, pel19DistY, pel20DistX, pel20DistY, pel21DistX, pel21DistY, pel22DistX, pel22DistY, pel23DistX, pel23DistY, pel24DistX, pel24DistY, pel25DistX, pel25DistY, pel26DistX, pel26DistY, pel27DistX, pel27DistY, pel28DistX, pel28DistY, pel29DistX, pel29DistY, pel30DistX, pel30DistY, pel31DistX, pel31DistY, pel32DistX, pel32DistY, pel33DistX, pel33DistY, pSize, blinkDistX, blinkDistY, pinkDistX, pinkDistY, clydeDistX, clydeDistY, inkDistX, inkDistY;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
assign pel0DistX = DrawX - pellet0X;
assign pel0DistY = DrawY - pellet0Y;
assign pel1DistX = DrawX - pellet1X;
assign pel1DistY = DrawY - pellet1Y;
assign pel2DistX = DrawX - pellet2X;
assign pel2DistY = DrawY - pellet2Y;
assign pel3DistX = DrawX - pellet3X;
assign pel3DistY = DrawY - pellet3Y;
assign pel4DistX = DrawX - pellet4X;
assign pel4DistY = DrawY - pellet4Y;
assign pel5DistX = DrawX - pellet5X;
assign pel5DistY = DrawY - pellet5Y;
assign pel6DistX = DrawX - pellet6X;
assign pel6DistY = DrawY - pellet6Y;
assign pel7DistX = DrawX - pellet7X;
assign pel7DistY = DrawY - pellet7Y;
assign pel8DistX = DrawX - pellet8X;
assign pel8DistY = DrawY - pellet8Y;
assign pel9DistX = DrawX - pellet9X;
assign pel9DistY = DrawY - pellet9Y;
assign pel10DistX = DrawX - pellet10X;
assign pel10DistY = DrawY - pellet10Y;
assign pel11DistX = DrawX - pellet11X;
assign pel11DistY = DrawY - pellet11Y;
assign pel12DistX = DrawX - pellet12X;
assign pel12DistY = DrawY - pellet12Y;
assign pel13DistX = DrawX - pellet13X;
assign pel13DistY = DrawY - pellet13Y;
assign pel14DistX = DrawX - pellet14X;
assign pel14DistY = DrawY - pellet14Y;
assign pel15DistX = DrawX - pellet15X;
assign pel15DistY = DrawY - pellet15Y;
assign pel16DistX = DrawX - pellet16X;
assign pel16DistY = DrawY - pellet16Y;
assign pel17DistX = DrawX - pellet17X;
assign pel17DistY = DrawY - pellet17Y;
assign pel18DistX = DrawX - pellet18X;
assign pel18DistY = DrawY - pellet18Y;
assign pel19DistX = DrawX - pellet19X;
assign pel19DistY = DrawY - pellet19Y;
assign pel20DistX = DrawX - pellet20X;
assign pel20DistY = DrawY - pellet20Y;
assign pel21DistX = DrawX - pellet21X;
assign pel21DistY = DrawY - pellet21Y;
assign pel22DistX = DrawX - pellet22X;
assign pel22DistY = DrawY - pellet22Y;
assign pel23DistX = DrawX - pellet23X;
assign pel23DistY = DrawY - pellet23Y;
assign pel24DistX = DrawX - pellet24X;
assign pel24DistY = DrawY - pellet24Y;
assign pel25DistX = DrawX - pellet25X;
assign pel25DistY = DrawY - pellet25Y;
assign pel26DistX = DrawX - pellet26X;
assign pel26DistY = DrawY - pellet26Y;
assign pel27DistX = DrawX - pellet27X;
assign pel27DistY = DrawY - pellet27Y;
assign pel28DistX = DrawX - pellet28X;
assign pel28DistY = DrawY - pellet28Y;
assign pel29DistX = DrawX - pellet29X;
assign pel29DistY = DrawY - pellet29Y;
assign pel30DistX = DrawX - pellet30X;
assign pel30DistY = DrawY - pellet30Y;
assign pel31DistX = DrawX - pellet31X;
assign pel31DistY = DrawY - pellet31Y;
assign pel32DistX = DrawX - pellet32X;
assign pel32DistY = DrawY - pellet32Y;
assign pel33DistX = DrawX - pellet33X;
assign pel33DistY = DrawY - pellet33Y;
	 assign blinkDistX = DrawX - blinkyX;
	 assign blinkDistY = DrawY - blinkyY;
	 assign pinkDistX = DrawX - pinkyX;
	 assign pinkDistY = DrawY - pinkyY;
	 assign inkDistX = DrawX - inkyX;
	 assign inkDistY = DrawY - inkyY;
	 assign clydeDistX = DrawX - clydeX;
	 assign clydeDistY = DrawY - clydeY;
    assign Size = Ball_size;
	 assign pSize = pel_size;
	 assign long_addr = (DrawY - BallY + Ball_size + 96 + 32 * Direction);
	 assign closed_addr = (DrawY - BallY + Ball_size + 96 + 32 *4); 
	 assign long_blinky_addr = (DrawY - blinkyY + Ball_size + 96);
	 assign long_pinky_addr = (DrawY - pinkyY + Ball_size + 96);
	 assign long_inky_addr = (DrawY - inkyY + Ball_size + 96);
	 assign long_clyde_addr = (DrawY - clydeY + Ball_size + 96);
	  
    always_comb
    begin:Ball_on_proc
        if ( ( DistX*DistX + DistY*DistY) <= (256) ) begin
				if(open && !win && !lose) 
					sprite_addr = long_addr[7:0];
				else
					sprite_addr = closed_addr[7:0];
            ball_on = 1'b1;
			end
        else begin
				sprite_addr = 8'b0;
            ball_on = 1'b0;
			end
					
     end 
	  
	 always_comb
    begin:Blink_on_proc
        if ( ( blinkDistX*blinkDistX + blinkDistY*blinkDistY) <= (256) ) begin
				blinky_addr = long_blinky_addr[4:0];
            blink_on = 1'b1;
			end
        else begin
				blinky_addr = 8'b0;
            blink_on = 1'b0;
			end
					
     end 
	  
	 always_comb
    begin:Pink_on_proc
        if ( ( pinkDistX*pinkDistX + pinkDistY*pinkDistY) <= (256) ) begin
				pinky_addr = long_pinky_addr[4:0];
            pink_on = 1'b1;
			end
        else begin
				pinky_addr = 8'b0;
            pink_on = 1'b0;
			end
					
     end 
	  
	 always_comb
    begin:Ink_on_proc
        if ( ( inkDistX*inkDistX + inkDistY*inkDistY) <= (256) ) begin
				inky_addr = long_inky_addr[4:0];
            ink_on = 1'b1;
			end
        else begin
				inky_addr = 8'b0;
            ink_on = 1'b0;
			end
					
     end 
	  
	 always_comb
    begin:Clyde_on_proc
        if ( ( clydeDistX*clydeDistX + clydeDistY*clydeDistY) <= (256) ) begin
				clyde_addr = long_clyde_addr[4:0];
            clyde_on = 1'b1;
			end
        else begin
				clyde_addr = 8'b0;
            clyde_on = 1'b0;
			end
					
     end 
	  
always_comb begin
if ( ( pel0DistX*pel0DistX + pel0DistY*pel0DistY) < (4) )
pel_0_on = 1'b1;
else
pel_0_on = 1'b0;

if ( ( pel1DistX*pel1DistX + pel1DistY*pel1DistY) < (4) )
pel_1_on = 1'b1;
else
pel_1_on = 1'b0;

if ( ( pel2DistX*pel2DistX + pel2DistY*pel2DistY) < (4) )
pel_2_on = 1'b1;
else
pel_2_on = 1'b0;

if ( ( pel3DistX*pel3DistX + pel3DistY*pel3DistY) < (4) )
pel_3_on = 1'b1;
else
pel_3_on = 1'b0;

if ( ( pel4DistX*pel4DistX + pel4DistY*pel4DistY) < (4) )
pel_4_on = 1'b1;
else
pel_4_on = 1'b0;

if ( ( pel5DistX*pel5DistX + pel5DistY*pel5DistY) < (4) )
pel_5_on = 1'b1;
else
pel_5_on = 1'b0;

if ( ( pel6DistX*pel6DistX + pel6DistY*pel6DistY) < (4) )
pel_6_on = 1'b1;
else
pel_6_on = 1'b0;

if ( ( pel7DistX*pel7DistX + pel7DistY*pel7DistY) < (4) )
pel_7_on = 1'b1;
else
pel_7_on = 1'b0;

if ( ( pel8DistX*pel8DistX + pel8DistY*pel8DistY) < (4) )
pel_8_on = 1'b1;
else
pel_8_on = 1'b0;

if ( ( pel9DistX*pel9DistX + pel9DistY*pel9DistY) < (4) )
pel_9_on = 1'b1;
else
pel_9_on = 1'b0;

if ( ( pel10DistX*pel10DistX + pel10DistY*pel10DistY) < (4) )
pel_10_on = 1'b1;
else
pel_10_on = 1'b0;

if ( ( pel11DistX*pel11DistX + pel11DistY*pel11DistY) < (4) )
pel_11_on = 1'b1;
else
pel_11_on = 1'b0;

if ( ( pel12DistX*pel12DistX + pel12DistY*pel12DistY) < (4) )
pel_12_on = 1'b1;
else
pel_12_on = 1'b0;

if ( ( pel13DistX*pel13DistX + pel13DistY*pel13DistY) < (4) )
pel_13_on = 1'b1;
else
pel_13_on = 1'b0;

if ( ( pel14DistX*pel14DistX + pel14DistY*pel14DistY) < (4) )
pel_14_on = 1'b1;
else
pel_14_on = 1'b0;

if ( ( pel15DistX*pel15DistX + pel15DistY*pel15DistY) < (4) )
pel_15_on = 1'b1;
else
pel_15_on = 1'b0;

if ( ( pel16DistX*pel16DistX + pel16DistY*pel16DistY) < (4) )
pel_16_on = 1'b1;
else
pel_16_on = 1'b0;

if ( ( pel17DistX*pel17DistX + pel17DistY*pel17DistY) < (4) )
pel_17_on = 1'b1;
else
pel_17_on = 1'b0;

if ( ( pel18DistX*pel18DistX + pel18DistY*pel18DistY) < (4) )
pel_18_on = 1'b1;
else
pel_18_on = 1'b0;

if ( ( pel19DistX*pel19DistX + pel19DistY*pel19DistY) < (4) )
pel_19_on = 1'b1;
else
pel_19_on = 1'b0;

if ( ( pel20DistX*pel20DistX + pel20DistY*pel20DistY) < (4) )
pel_20_on = 1'b1;
else
pel_20_on = 1'b0;

if ( ( pel21DistX*pel21DistX + pel21DistY*pel21DistY) < (4) )
pel_21_on = 1'b1;
else
pel_21_on = 1'b0;

if ( ( pel22DistX*pel22DistX + pel22DistY*pel22DistY) < (4) )
pel_22_on = 1'b1;
else
pel_22_on = 1'b0;

if ( ( pel23DistX*pel23DistX + pel23DistY*pel23DistY) < (4) )
pel_23_on = 1'b1;
else
pel_23_on = 1'b0;

if ( ( pel24DistX*pel24DistX + pel24DistY*pel24DistY) < (4) )
pel_24_on = 1'b1;
else
pel_24_on = 1'b0;

if ( ( pel25DistX*pel25DistX + pel25DistY*pel25DistY) < (4) )
pel_25_on = 1'b1;
else
pel_25_on = 1'b0;

if ( ( pel26DistX*pel26DistX + pel26DistY*pel26DistY) < (4) )
pel_26_on = 1'b1;
else
pel_26_on = 1'b0;

if ( ( pel27DistX*pel27DistX + pel27DistY*pel27DistY) < (4) )
pel_27_on = 1'b1;
else
pel_27_on = 1'b0;

if ( ( pel28DistX*pel28DistX + pel28DistY*pel28DistY) < (4) )
pel_28_on = 1'b1;
else
pel_28_on = 1'b0;

if ( ( pel29DistX*pel29DistX + pel29DistY*pel29DistY) < (4) )
pel_29_on = 1'b1;
else
pel_29_on = 1'b0;

if ( ( pel30DistX*pel30DistX + pel30DistY*pel30DistY) < (4) )
pel_30_on = 1'b1;
else
pel_30_on = 1'b0;

if ( ( pel31DistX*pel31DistX + pel31DistY*pel31DistY) < (4) )
pel_31_on = 1'b1;
else
pel_31_on = 1'b0;

if ( ( pel32DistX*pel32DistX + pel32DistY*pel32DistY) < (4) )
pel_32_on = 1'b1;
else
pel_32_on = 1'b0;

if ( ( pel33DistX*pel33DistX + pel33DistY*pel33DistY) < (4) )
pel_33_on = 1'b1;
else
pel_33_on = 1'b0;
end
	  
	  
       
	 always_ff @(posedge pixel_clk) begin
		if(Ball_X_Motion == 10'b0000000010 && (Ball_Y_Motion == 0))
			Direction <= 2'b00;
		else if((Ball_X_Motion == 10'b1111111110) && (Ball_Y_Motion == 0))
			Direction <= 2'b01;
		else if((Ball_Y_Motion == 10'b1111111110) && (Ball_X_Motion == 0))
			Direction <= 2'b10;
		else
			Direction <= 2'b11;
	 
	 
	 end
	 
	 always_ff@(posedge frame_clk) begin
	 
	 
	 if(count < 6'd30) begin
		open <= 1;
		white <=1;
	end
	 else begin
		open <= 0;
		white <= 0;
	end
	
	count++;
	if(count >= 60)
		count <= 0;
		
	 
	 end
	 
	 
	 
	 
    always_ff @(posedge pixel_clk)
    begin:RGB_Display
		  if(!blank) begin
				Red <= 8'h0;
				Green <= 8'h0;
				Blue <= 8'h0;
		  end
		
        else if ((ball_on == 1'b1) && (sprite_data[DrawX - BallX + Ball_size] == 1'b1))
        begin 
            Red <= 8'hff;
            Green <= 8'hff;
            Blue <= 8'h26;
        end  
		  else if((blink_on == 1'b1) && (blinky_data[DrawX - blinkyX + Ball_size] == 1'b1) && !win) begin
				Red <= 8'hf1;
				Green <= 8'h08;
				Blue <= 8'h08;
		  
		  end
		  	else if((pink_on == 1'b1) && (pinky_data[DrawX - pinkyX + Ball_size] == 1'b1) && !win) begin
				Red <= 8'hff;
				Green <= 8'hb9;
				Blue <= 8'hdf;
		  
		  end
		  	else if((ink_on == 1'b1) && (inky_data[DrawX - inkyX + Ball_size] == 1'b1) && !win) begin
				Red <= 8'h00;
				Green <= 8'hff;
				Blue <= 8'hdf;
		  
		  end
		  	else if((clyde_on == 1'b1) && (clyde_data[DrawX - clydeX + Ball_size] == 1'b1) && !win) begin
				Red <= 8'hfc;
				Green <= 8'ha4;
				Blue <= 8'h04;
		  
		  end
			else if((pel_0_on == 1'b1 && !(eaten[0])) || (pel_1_on == 1'b1 && !(eaten[1])) || (pel_2_on == 1'b1 && !(eaten[2])) || (pel_3_on == 1'b1 && !(eaten[3])) || (pel_4_on == 1'b1 && !(eaten[4])) || (pel_5_on == 1'b1 && !(eaten[5])) || (pel_6_on == 1'b1 && !(eaten[6])) || (pel_7_on == 1'b1 && !(eaten[7])) || (pel_8_on == 1'b1 && !(eaten[8])) || (pel_9_on == 1'b1 && !(eaten[9])) || (pel_10_on == 1'b1 && !(eaten[10])) || (pel_11_on == 1'b1 && !(eaten[11])) || (pel_12_on == 1'b1 && !(eaten[12])) || (pel_13_on == 1'b1 && !(eaten[13])) || (pel_14_on == 1'b1 && !(eaten[14])) || (pel_15_on == 1'b1 && !(eaten[15])) || (pel_16_on == 1'b1 && !(eaten[16])) || (pel_17_on == 1'b1 && !(eaten[17])) || (pel_18_on == 1'b1 && !(eaten[18])) || (pel_19_on == 1'b1 && !(eaten[19])) || (pel_20_on == 1'b1 && !(eaten[20])) || (pel_21_on == 1'b1 && !(eaten[21])) || (pel_22_on == 1'b1 && !(eaten[22])) || (pel_23_on == 1'b1 && !(eaten[23])) || (pel_24_on == 1'b1 && !(eaten[24])) || (pel_25_on == 1'b1 && !(eaten[25])) || (pel_26_on == 1'b1 && !(eaten[26])) || (pel_27_on == 1'b1 && !(eaten[27])) || (pel_28_on == 1'b1 && !(eaten[28])) || (pel_29_on == 1'b1 && !(eaten[29])) || (pel_30_on == 1'b1 && !(eaten[30])) || (pel_31_on == 1'b1 && !(eaten[31])) || (pel_32_on == 1'b1 && !(eaten[32])) || (pel_33_on == 1'b1 && !(eaten[33]))) begin
				Red <= 8'hff;
				Green <= 8'hff;
				Blue <= 8'hff;
			end
			else if(background_data[DrawX] == 1'b1) begin
			if(win) begin
				if(white) begin
					Red <= 8'hff;
					Green <= 8'hff;
					Blue <= 8'hff;
			
				end
				else begin
				Red <= 8'h12;
				Green <= 8'h12;
				Blue <= 8'hBF;
				
				end
			end
			else begin
			
				Red <= 8'h12;
				Green <= 8'h12;
				Blue <= 8'hBF;
			end
			end
        else 
        begin 
				
				if(lose) begin
					Red <= 8'hff;
					Green <= 8'h00;
					Blue <= 8'h00;
				end
				else begin
					Red <= 8'h00; 
					Green <= 8'h00;
					Blue <= 8'h00;
				end
        end      
    end 
	 
	 
	 pacmanfont sprite(.addr(sprite_addr), .data(sprite_data));
	 ghostfont blinky(.addr(blinky_addr), .data(blinky_data));
	 ghostfont pinky(.addr(pinky_addr), .data(pinky_data));
	 ghostfont inky(.addr(inky_addr), .data(inky_data));
	 ghostfont clyde(.addr(clyde_addr), .data(clyde_data));
	 background b1(.addr(DrawY), .data(background_data), .clk(pixel_clk));
	 
	 
endmodule
