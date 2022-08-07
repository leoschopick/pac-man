module testbench ();

timeunit 10ns;

timeprecision 1ns;

logic Reset, frame_clk;
logic [9:0] pacX, pacY;
logic [9:0]  BallX, BallY, BallS, Ball_X_Motion, Ball_Y_Motion;



always begin : CLOCK_GENERATION
#1 frame_clk = ~frame_clk;
end

initial begin: CLOCK_INITIALIZATION
    frame_clk = 0;
end 

initial begin: TEST
#2 Reset = 0;
#2 Reset = 1;
   pacX = 350;
	pacY = 368;
#2 Reset = 0;
	

end
	

endmodule
