# FPGA, but the P is Pac-Man

A recreation of the 1980 arcade classic Pac-Man written in SystemVerilog and C.

This was mine and Abigail Kokal's final project for [ECE 385 - Digital Systems Laboratory](https://ece.illinois.edu/academics/courses/ece385) at the University of Illinois Urbana-Champaign from Spring 2022. It was designed to run on a [Terasic DE10-Lite](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=1021).

### Materials Needed
USB Keyboard

A way to display a VGA signal

### How to Run
1. Set top level to lab62.sv
2. Generate HDL on Platform Designer using the .qsys file
3. Compile
4. Program FPGA
5. In Eclipse, Generate BSP (on usb_kb_bsp), Build All, and Run

### Controls
W - Up

A - Left

S - Down

D - Right

KEY0 (on FPGA) - Reset

### How to Play
Eat all pellets to win
If you hit a ghost, you lose
Press reset after winning or losing to play again

### Sources
* Movement of Pac-Man and ghosts was adapted from lab 6.2
* VGA drawing was adapted from labs 6 and 7
* Distance calculation was adapted from https://www.jasonpenningtonphd.com/euclidean-distance-calculation-vhdl-example/
* Psuedo-random number generation was adapted from https://stackoverflow.com/questions/757151/random-number-generation-on-spartan-3e
* Pac-Man and Ghost sprites were adapted from https://github.com/shounak102/pacman-ece385/blob/master/spriteData.sv
* Map image: http://drapak.ca/cpg/img/MsPacManScreen-empty.jpg
* Website used to convert maps into binary: https://www.dcode.fr/binary-image

**ALL OTHER CODE IS OUR OWN**
