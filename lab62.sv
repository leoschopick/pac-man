//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab62 (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk, win, lose, stop;
logic [9:0] Ball_X_Motion, Ball_Y_Motion;
logic [3:0] collide;
logic [33:0] eaten;

always_comb begin

	if(eaten == 34'h3FFFFFFFF) begin
		win = 1;
		lose = 0;
		stop = 1;
	end
	else if(collide != 0) begin
		lose = 1;
		win = 0;
		stop = 1;
	end
	else begin
		win = 0;
		lose = 0;
		stop = 0;
	end


end


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig, pel_size, blinkyX, blinkyY, pinkyX, pinkyY, clydeX, clydeY, inkyX, inkyY, pellet0X, pellet0Y, pellet1X, pellet1Y, pellet2X, pellet2Y, pellet3X, pellet3Y, pellet4X, pellet4Y, pellet5X, pellet5Y, pellet6X, pellet6Y, pellet7X, pellet7Y, pellet8X, pellet8Y, pellet9X, pellet9Y, pellet10X, pellet10Y, pellet11X, pellet11Y, pellet12X, pellet12Y, pellet13X, pellet13Y, pellet14X, pellet14Y, pellet15X, pellet15Y, pellet16X, pellet16Y, pellet17X, pellet17Y, pellet18X, pellet18Y, pellet19X, pellet19Y, pellet20X, pellet20Y, pellet21X, pellet21Y, pellet22X, pellet22Y, pellet23X, pellet23Y, pellet24X, pellet24Y, pellet25X, pellet25Y, pellet26X, pellet26Y, pellet27X, pellet27Y, pellet28X, pellet28Y, pellet29X, pellet29Y, pellet30X, pellet30Y, pellet31X, pellet31Y, pellet32X, pellet32Y, pellet33X, pellet33Y;
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	/*HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;*/
	
	//fill in the hundreds digit as well as the negative sign
	//assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	//assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	HexDriver hex5 (.In0({2'b0, ballxsig[9:8]}), .Out0(HEX5[6:0]));
	assign HEX5[7] = 1'b1;
	
	HexDriver hex4 (.In0(ballxsig[7:4]), .Out0(HEX4[6:0]));
	assign HEX4[7] = 1'b1;
	
	HexDriver hex3 (.In0(ballxsig[3:0]), .Out0(HEX3[6:0]));
	assign HEX3[7] = 1'b1;

	HexDriver hex2 (.In0({2'b0, ballysig[9:8]}), .Out0(HEX2[6:0]));
	assign HEX2[7] = 1'b1;
	
	HexDriver hex1 (.In0(ballysig[7:4]), .Out0(HEX1[6:0]));
	assign HEX1[7] = 1'b1;
	
	HexDriver hex0 (.In0(ballysig[3:0]), .Out0(HEX0[6:0]));
	assign HEX0[7] = 1'b1;
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[7:4];
	assign VGA_B = Blue[7:4];
	assign VGA_G = Green[7:4];
	
	
	lab62_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		//.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode)
		
	 );


//instantiate a vga_controller, ball, and color_mapper here with the ports.
	
	vga_controller VGA(.Clk(MAX10_CLK1_50), .Reset(Reset_h), .hs(VGA_HS), .vs(VGA_VS), .pixel_clk(VGA_Clk), .blank(blank), .sync(sync), .DrawX(drawxsig), .DrawY(drawysig));
	ball orange(.Reset(Reset_h), .frame_clk(VGA_VS), .keycode(keycode), .BallX(ballxsig), .BallY(ballysig), .BallS(ballsizesig), .Ball_X_Motion(Ball_X_Motion), .Ball_Y_Motion(Ball_Y_Motion), .stop(stop));
	blinky blink(.Reset(Reset_h), .frame_clk(VGA_VS), .pacX(ballxsig), .pacY(ballysig), .BallX(blinkyX), .BallY(blinkyY), .collide(collide[0]), .stop(stop));
	inky ink(.Reset(Reset_h), .frame_clk(VGA_VS), .BallX(inkyX), .BallY(inkyY), .pacX(ballxsig), .pacY(ballysig), .collide(collide[1]), .stop(stop));
	pinky pink(.Reset(Reset_h), .frame_clk(VGA_VS), .pacXin(ballxsig), .pacYin(ballysig), .BallX(pinkyX), .BallY(pinkyY), .pac_X_Motion(Ball_X_Motion), .pac_Y_Motion(Ball_Y_Motion), .collide(collide[2]), .stop(stop));
	clyde cly(.Reset(Reset_h), .frame_clk(VGA_VS), .pacX(ballxsig), .pacY(ballysig), .BallX(clydeX), .BallY(clydeY), .collide(collide[3]), .stop(stop));
	//pellet p1(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(380), .pelletY(368), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten), .BallX(pelletX), .BallY(pelletY), .BallS(pel_size));
	color_mapper colors(.BallX(ballxsig), .BallY(ballysig), .DrawX(drawxsig), .DrawY(drawysig), .Ball_size(16), .Red(Red), .Green(Green), .Blue(Blue), .pixel_clk(VGA_Clk), .blank(blank), .Ball_X_Motion(Ball_X_Motion), .Ball_Y_Motion(Ball_Y_Motion), .frame_clk(VGA_VS), .Reset(Reset_h), .pellet0X(pellet0X), .pellet0Y(pellet0Y), .pellet1X(pellet1X), .pellet1Y(pellet1Y), .pellet2X(pellet2X), .pellet2Y(pellet2Y), .pellet3X(pellet3X), .pellet3Y(pellet3Y), .pellet4X(pellet4X), .pellet4Y(pellet4Y), .pellet5X(pellet5X), .pellet5Y(pellet5Y), .pellet6X(pellet6X), .pellet6Y(pellet6Y), .pellet7X(pellet7X), .pellet7Y(pellet7Y), .pellet8X(pellet8X), .pellet8Y(pellet8Y), .pellet9X(pellet9X), .pellet9Y(pellet9Y), .pellet10X(pellet10X), .pellet10Y(pellet10Y), .pellet11X(pellet11X), .pellet11Y(pellet11Y), .pellet12X(pellet12X), .pellet12Y(pellet12Y), .pellet13X(pellet13X), .pellet13Y(pellet13Y), .pellet14X(pellet14X), .pellet14Y(pellet14Y), .pellet15X(pellet15X), .pellet15Y(pellet15Y), .pellet16X(pellet16X), .pellet16Y(pellet16Y), .pellet17X(pellet17X), .pellet17Y(pellet17Y), .pellet18X(pellet18X), .pellet18Y(pellet18Y), .pellet19X(pellet19X), .pellet19Y(pellet19Y), .pellet20X(pellet20X), .pellet20Y(pellet20Y), .pellet21X(pellet21X), .pellet21Y(pellet21Y), .pellet22X(pellet22X), .pellet22Y(pellet22Y), .pellet23X(pellet23X), .pellet23Y(pellet23Y), .pellet24X(pellet24X), .pellet24Y(pellet24Y), .pellet25X(pellet25X), .pellet25Y(pellet25Y), .pellet26X(pellet26X), .pellet26Y(pellet26Y), .pellet27X(pellet27X), .pellet27Y(pellet27Y), .pellet28X(pellet28X), .pellet28Y(pellet28Y), .pellet29X(pellet29X), .pellet29Y(pellet29Y), .pellet30X(pellet30X), .pellet30Y(pellet30Y), .pellet31X(pellet31X), .pellet31Y(pellet31Y), .pellet32X(pellet32X), .pellet32Y(pellet32Y), .pellet33X(pellet33X), .pellet33Y(pellet33Y), .pel_size(pel_size), .eaten(eaten), .blinkyX(blinkyX), .blinkyY(blinkyY), .pinkyX(pinkyX), .pinkyY(pinkyY), .clydeX(clydeX), .clydeY(clydeY), .inkyX(inkyX), .inkyY(inkyY), .win(win), .lose(lose));
	//control states(.frame_clk(frame_clk), .Reset(Reset_h), .enter(keycode == 8'h28), .collide(collide), .eaten(eaten), .restart(restart), .win(win), .lose(lose), .playing(playing));

	
pellet p0(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(222), .pelletY(32), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[0]), .BallX(pellet0X), .BallY(pellet0Y), .BallS(pel_size));
pellet p1(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(418), .pelletY(32), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[1]), .BallX(pellet1X), .BallY(pellet1Y), .BallS(pel_size));
pellet p2(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(38), .pelletY(78), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[2]), .BallX(pellet2X), .BallY(pellet2Y), .BallS(pel_size));
pellet p3(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(282), .pelletY(78), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[3]), .BallX(pellet3X), .BallY(pellet3Y), .BallS(pel_size));
pellet p4(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(282), .pelletY(132), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[4]), .BallX(pellet4X), .BallY(pellet4Y), .BallS(pel_size));
pellet p5(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(354), .pelletY(132), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[5]), .BallX(pellet5X), .BallY(pellet5Y), .BallS(pel_size));
pellet p6(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(354), .pelletY(78), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[6]), .BallX(pellet6X), .BallY(pellet6Y), .BallS(pel_size));
pellet p7(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(602), .pelletY(78), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[7]), .BallX(pellet7X), .BallY(pellet7Y), .BallS(pel_size));
pellet p8(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(102), .pelletY(128), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[8]), .BallX(pellet8X), .BallY(pellet8Y), .BallS(pel_size));
pellet p9(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(530), .pelletY(128), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[9]), .BallX(pellet9X), .BallY(pellet9Y), .BallS(pel_size));
pellet p10(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(34), .pelletY(170), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[10]), .BallX(pellet10X), .BallY(pellet10Y), .BallS(pel_size));
pellet p11(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(148), .pelletY(170), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[11]), .BallX(pellet11X), .BallY(pellet11Y), .BallS(pel_size));
pellet p12(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(490), .pelletY(170), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[12]), .BallX(pellet12X), .BallY(pellet12Y), .BallS(pel_size));
pellet p13(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(602), .pelletY(170), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[13]), .BallX(pellet13X), .BallY(pellet13Y), .BallS(pel_size));
pellet p14(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(34), .pelletY(218), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[14]), .BallX(pellet14X), .BallY(pellet14Y), .BallS(pel_size));
pellet p15(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(602), .pelletY(218), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[15]), .BallX(pellet15X), .BallY(pellet15Y), .BallS(pel_size));
pellet p16(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(34), .pelletY(260), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[16]), .BallX(pellet16X), .BallY(pellet16Y), .BallS(pel_size));
pellet p17(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(82), .pelletY(260), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[17]), .BallX(pellet17X), .BallY(pellet17Y), .BallS(pel_size));
pellet p18(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(558), .pelletY(260), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[18]), .BallX(pellet18X), .BallY(pellet18Y), .BallS(pel_size));
pellet p19(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(602), .pelletY(260), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[19]), .BallX(pellet19X), .BallY(pellet19Y), .BallS(pel_size));
pellet p20(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(222), .pelletY(276), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[20]), .BallX(pellet20X), .BallY(pellet20Y), .BallS(pel_size));
pellet p21(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(420), .pelletY(276), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[21]), .BallX(pellet21X), .BallY(pellet21Y), .BallS(pel_size));
pellet p22(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(150), .pelletY(370), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[22]), .BallX(pellet22X), .BallY(pellet22Y), .BallS(pel_size));
pellet p23(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(220), .pelletY(370), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[23]), .BallX(pellet23X), .BallY(pellet23Y), .BallS(pel_size));
pellet p24(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(420), .pelletY(370), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[24]), .BallX(pellet24X), .BallY(pellet24Y), .BallS(pel_size));
pellet p25(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(486), .pelletY(370), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[25]), .BallX(pellet25X), .BallY(pellet25Y), .BallS(pel_size));
pellet p26(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(34), .pelletY(416), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[26]), .BallX(pellet26X), .BallY(pellet26Y), .BallS(pel_size));
pellet p27(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(84), .pelletY(416), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[27]), .BallX(pellet27X), .BallY(pellet27Y), .BallS(pel_size));
pellet p28(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(290), .pelletY(416), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[28]), .BallX(pellet28X), .BallY(pellet28Y), .BallS(pel_size));
pellet p29(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(352), .pelletY(416), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[29]), .BallX(pellet29X), .BallY(pellet29Y), .BallS(pel_size));
pellet p30(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(556), .pelletY(416), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[30]), .BallX(pellet30X), .BallY(pellet30Y), .BallS(pel_size));
pellet p31(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(604), .pelletY(416), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[31]), .BallX(pellet31X), .BallY(pellet31Y), .BallS(pel_size));
pellet p32(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(34), .pelletY(462), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[32]), .BallX(pellet32X), .BallY(pellet32Y), .BallS(pel_size));
pellet p33(.Reset(Reset_h), .frame_clk(VGA_VS), .pelletX(604), .pelletY(462), .pacX(ballxsig), .pacY(ballysig), .eaten(eaten[33]), .BallX(pellet33X), .BallY(pellet33Y), .BallS(pel_size));
endmodule
