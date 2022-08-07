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


module  pellet ( input logic Reset, frame_clk,
						input logic [9:0] pelletX, pelletY, pacX, pacY,
               output logic [9:0]  BallX, BallY, BallS,
						output logic eaten);
    
    logic [9:0] Ball_X_Pos, Ball_Y_Pos, Ball_Size;
	 
    logic [9:0] Ball_X_Center;  // Center position on the X axis
    logic [9:0] Ball_Y_Center;  // Center position on the Y axis
	 logic[9:0] dis2;
	 logic Xrange, Yrange;

    assign Ball_Size = 2;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign Ball_X_Center = pelletX;
	 assign Ball_Y_Center = pelletY;
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
				Ball_Y_Pos <= pelletY;
				Ball_X_Pos <= pelletX;
				eaten <= 0;
        end
		  
		  //else if( (pacX == pelletX) && (pacY[9:4] == pelletY[9:4]) ) 
		  //else if( (!dis2[9]) && (dis2 <= 16) && (dis2 > 0))
		  else if( Xrange && Yrange)
				eaten <= 1;
			else
				eaten <= eaten;
           
    end
       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
	 
	 assign Xrange = ((pelletX >= (pacX - 10)) && (pelletX <= (pacX + 10)));
	 
	 assign Yrange = ((pelletY >= (pacY - 10)) && (pelletY <= (pacY + 10)));
	 
	 //assign Xrange = (((pacX + 10) == pelletX) | ((pacX + 9) == pelletX) | ((pacX + 8) == pelletX) | ((pacX + 7) == pelletX) | ((pacX + 6) == pelletX) | ((pacX + 5) == pelletX) | ((pacX + 4) == pelletX) | ((pacX + 3) == pelletX) | ((pacX + 2) == pelletX) | ((pacX + 1) == pelletX) | ((pacX) == pelletX) | ((pacX - 10) == pelletX) | ((pacX - 9) == pelletX) | ((pacX - 8) == pelletX) | ((pacX - 7) == pelletX) | ((pacX - 6) == pelletX) | ((pacX - 5) == pelletX) | ((pacX - 4) == pelletX) | ((pacX - 3) == pelletX) | ((pacX - 2) == pelletX) | ((pacX - 1) == pelletX));
	 
	 //assign Yrange = (((pacY + 10) == pelletY) | ((pacY + 9) == pelletY) | ((pacY + 8) == pelletY) | ((pacY + 7) == pelletY) | ((pacY + 6) == pelletY) | ((pacY + 5) == pelletY) | ((pacY + 4) == pelletY) | ((pacY + 3) == pelletY) | ((pacY + 2) == pelletY) | ((pacY + 1) == pelletY) | ((pacY) == pelletY) | ((pacY - 10) == pelletY) | ((pacY - 9) == pelletY) | ((pacY - 8) == pelletY) | ((pacY - 7) == pelletY) | ((pacY - 6) == pelletY) | ((pacY - 5) == pelletY) | ((pacY - 4) == pelletY) | ((pacY - 3) == pelletY) | ((pacY - 2) == pelletY) | ((pacY - 1) == pelletY));
	 
	 //distance pacdis(.X1({22'b0, pelletX}), .Y1({22'b0, pelletY}), .X2({22'b0, pacX}), .Y2({22'b0, pacY}), .dis2(dis2));
    

endmodule
