//https://stackoverflow.com/questions/757151/random-number-generation-on-spartan-3e


module random(
	input logic frame_clk, Reset, en,
	output logic[3:0] ret);
	
	logic[7:0] q;
	
	always_ff @ (posedge frame_clk or posedge Reset) begin
	
		if(Reset)
			q <= 8'd1;
		else if(en)
			q <= {q[6:0], q[7] ^ q[5] ^ q[4] ^ q[3]}; // polynomial for maximal LFSR
	
	end
	
	assign ret = q[3:0];
	
	
	
endmodule
