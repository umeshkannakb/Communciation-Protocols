module baudgen #(
 parameter baud_rate = 9600,       // baud rate of 9600
 parameter clock_freq = 50000000   // freqency of 50Mhz
 ) (
     input clk,rst,
	 output reg baud_tick
);

//oversampling factor - UART typically uses 16x oversampling 

localparam ticks = clock_freq/ (baud_rate * 16);  //((50mhz )/9600*16) = 325 cycles 

//counter width is dynamically calculated to hold values up to 'ticks' 
//using $clog2 ensures the counter always has enough bits

reg [$clog2(ticks)-1:0] baud_counter;

   always @(posedge clk or posedge rst) begin
        if(rst) begin
          baud_counter <=0;
		  baud_tick    <=0;
        end else begin
            if(baud_counter == ticks-1) begin  // here ticks is taking care og oversapling rate already
               baud_counter <=0;
			   baud_tick    <=1;
			end else begin
                baud_counter <=baud_counter +1;
				baud_tick    <=0;
			end
		end
    end
endmodule
     
