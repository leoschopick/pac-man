module testbench2 ();

timeunit 10ns;

timeprecision 1ns;

logic frame_clk;
logic [1:0] ret;

always begin : CLOCK_GENERATION
#1 frame_clk = ~frame_clk;
end

initial begin: CLOCK_INITIALIZATION
    frame_clk = 0;
end 

initial begin: TEST
integer i;
for(i = 0; i < 100; i++) begin

	#1 ret = $urandom();
	end



end
	

	

endmodule
