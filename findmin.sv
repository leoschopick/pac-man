module findmin(input logic [31:0] val1, val2, val3, val4,
					output logic [1:0] ret);
					
		always_comb begin
		
			if(val1 <= val2 && val1 <= val3 && val1 <= val4)
				ret = 2'b00;
			else if(val2 <= val1 && val2 <= val3 && val2 <= val4)
				ret = 2'b01;
			else if(val3 <= val1 && val3 <= val2 && val3 <= val4)
				ret = 2'b10;
			else
				ret = 2'b11;
		
		end



endmodule
