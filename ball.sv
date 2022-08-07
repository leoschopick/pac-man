//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input logic Reset, frame_clk, stop,
					input logic [7:0] keycode,
               output logic [9:0]  BallX, BallY, BallS, Ball_X_Motion, Ball_Y_Motion );
    
    logic [9:0] Ball_X_Pos, Ball_Y_Pos, Ball_Size;
	 logic [639:0] pac_line, above_line, below_line;
	 logic bounce_back;
	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=368;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=2;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=2;      // Step size on the Y axis

    assign Ball_Size = 8;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
				bounce_back <= 0;
        end
           
        else 
        begin 
				 if ( below_line[BallX] && (!bounce_back) ) begin // Ball is at the bottom edge, STOP!
					  Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);
						bounce_back <= 1;// 2's complement.
				end
					  
				 else if ( above_line[BallX] && (!bounce_back) ) begin // Ball is at the top edge, STOP!
					  Ball_Y_Motion <= Ball_Y_Step;
					  bounce_back <= 1;
				end
					  
				  else if ( pac_line[BallX + Ball_Size] && (!bounce_back) ) begin // Ball is at the Right edge, Wrap around
					  Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);
						bounce_back <= 1;// 2's complement.
					end
					  
				 else if ( pac_line[BallX - Ball_Size] && (!bounce_back) ) begin // Ball is at the Left edge, Wrap around
					   Ball_X_Motion <= Ball_X_Step;
						bounce_back <= 1;
					end
						
					  
				 else begin
					  Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
				 
				 case (keycode)
					8'h04 : begin

								Ball_X_Motion <= -2;//A
								Ball_Y_Motion <= 0;
							  end
					        
					8'h07 : begin
								
					        Ball_X_Motion <= 2;//D
							  Ball_Y_Motion <= 0;
							  end
							  
					8'h16 : begin

					        Ball_Y_Motion <= 2;//S
							  Ball_X_Motion <= 0;
							 end
							  
					8'h1A : begin
					
					        Ball_Y_Motion <= -2;//W
							  Ball_X_Motion <= 0;
							 end	
							 
					8'h2C : begin
					
							  Ball_Y_Motion <= 0;//Space FOR DEBUGGING
							  Ball_X_Motion <= 0;
							 end
					
					default: ;
			   endcase
				
				if (Ball_X_Motion != 0 && Ball_Y_Motion != 0) begin
					Ball_Y_Motion <= Ball_Y_Motion;
					Ball_X_Motion <= 0;
				end
				
				if(bounce_back) begin
					Ball_Y_Motion <= 0;
					Ball_X_Motion <= 0;
					bounce_back <= 0;
				end
				
				if(stop) begin
					Ball_Y_Motion <= 0;
					Ball_X_Motion <= 0;
				
				end
				
				
				/*if (pac_line[BallX] && (Ball_X_Motion != 0 || Ball_Y_Motion != 0) 
				&& (keycode == 8'h04 || keycode == 8'h07 || keycode == 8'h16
				|| keycode == 8'h1A || (keycode == 8'h00))
				) begin
					prevY <= Ball_Y_Motion;
					prevX <= Ball_X_Motion;
					Ball_Y_Motion <= 0;
					Ball_X_Motion <= 0;
				
				end
				
				if(((keycode == 8'h04) || (keycode == 8'h16) || (keycode == 8'h1A)) && prevX == 10'b1111111110
					&& (Ball_X_Motion == 0) && (Ball_Y_Motion == 0)) begin
					Ball_X_Motion <= 0;
					Ball_Y_Motion <= 0;
				end
				if(((keycode == 8'h07) || (keycode == 8'h16) || (keycode == 8'h1A)) && prevX == 10'b0000000010
					&& (Ball_X_Motion == 0) && (Ball_Y_Motion == 0)) begin
					Ball_X_Motion <= 0;
					Ball_Y_Motion <= 0;
				end
				if(((keycode == 8'h04) || (keycode == 8'h07) || (keycode == 8'h1A)) && prevY == 10'b0000000010
					&& (Ball_X_Motion == 0) && (Ball_Y_Motion == 0)) begin
					Ball_X_Motion <= 0;
					Ball_Y_Motion <= 0;
				end
				if(((keycode == 8'h04) || (keycode == 8'h07) || (keycode == 8'h16)) && prevY == 10'b1111111110
					&& (Ball_X_Motion == 0) && (Ball_Y_Motion == 0)) begin
					Ball_X_Motion <= 0;
					Ball_Y_Motion <= 0;
				end*/
					
				
				end
				 
				 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
				 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
			
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
    end
       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
	 
	 background pac(.addr(BallY), .data(pac_line), .clk(frame_clk));
	 background pac_below(.addr(BallY + Ball_Size), .data(below_line), .clk(frame_clk));
	 background pac_above(.addr(BallY - Ball_Size), .data(above_line), .clk(frame_clk));
    

endmodule
