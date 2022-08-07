module pellet_font ( input [1:0]	addr,
						output [3:0]	data
					 );

	parameter ADDR_WIDTH = 2;
   parameter DATA_WIDTH =  4;
	logic [ADDR_WIDTH-1:0] addr_reg;

	// ROM definition
	parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] ROM = {

		4'b 0110,
		4'b 1111,
		4'b 1111,
		4'b 0110
		
	};

	assign data = ROM[addr];

endmodule