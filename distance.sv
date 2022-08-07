module distance(
	input logic [31:0] X1, Y1, X2, Y2,
	input logic frame_clk,
	output logic [31:0] dis2


);

	logic [31:0] x_diff, y_diff;
	logic [31:0] x_sq, y_sq;
	always_ff @ (posedge frame_clk) begin
	
		x_diff <= X1 -  X2;
		y_diff <= Y1 -  Y2;
		
		x_sq <= x_diff * x_diff;
		y_sq <= y_diff * y_diff;
		
		dis2 <= x_sq + y_sq;
		
	
	
	end
	

	//assign dis2 = ((X2 - X1) * (X2 - X1)) + ((Y2 - Y1) * (X2 - X1));
	
	
endmodule
