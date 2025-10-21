`timescale 1ns/1ps;
`include "baudgen.v"

module baudgen_tb;
   localparam BAUD_RATE = 9600;
   localparam CLOCK_FREQ = 50000000;

   reg clk;
   reg rst;

   wire baud_tick;
   
   //instatiate DUT
   baudgen #(.baud_rate(BAUD_RATE),.clock_freq(CLOCK_FREQ)) dut (.clk(clk),.rst(rst),.baud_tick(baud_tick));

   //clock generation: 50MHz = 20ns period
   always #10 clk=~clk;

   initial begin
     clk=0;
	 rst=1;
	 #100;
	 rst=0;
	 #10000;
	 $finish; // ends the simulation 

   end


endmodule 
