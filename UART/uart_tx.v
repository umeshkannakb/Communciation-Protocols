//sample uart transmitter
//sends 8-bit data serially : sart bit (0), 8 data bits (LSB first), stop bit (1)//uses a baud_tick from an external generator for timing (16x oversampling);meaning for every data bit, there are 16 clock pulses from baud_tick).
//FSM states : idle , start, data, stop
//tx_done goes high when transmission is complete

module uart_tx(

  input [7:0] data_in,
  input clk,rst,start_tx,baud_tick,
  output reg tx_done,
  output reg tx_line 
);

  //FSM states - one hot encoding

  parameter [3:0] idle   = 4'b0001,
                  start  = 4'b0010,
				  data   = 4'b0100,
				  stop   = 4'b1000;

  reg [3:0] ps, ns;          // Present state & next state
  reg [3:0] tick_counter;    // Counts 0–15 (oversampling)
  reg [2:0] bit_index;       // Counts which data bit is being sent (0–7)
  reg [7:0] tx_data;         // Holds the byte being transmitted 

  
  // sequential logic - for state updates and counter management

  always @ (posedge clk or posedge rst) begin
       if(rst) begin
          ps <= idle;
		  tick_counter <=0;
		  bit_index <=0;
	   end  else begin
           ps<=ns;
	   end
  end

  //combinational for next state logic and determines state transitions

  always @(*) begin
     case (ps)
          idle: begin
              if (start_tx) begin
                 ns=start;
			  end else begin
                 ns=idle;
			  end
		  end

		  start : begin
              if(baud_tick) begin
                 ns=data;
			  end else begin
                 ns=start;
			  end
		  end

		  data: begin
              if(baud_tick) begin
                 if(bit_index==7)begin
                    ns=stop;
				 end else begin
                    ns=data;
				 end
			  end
		  end

		  stop: begin
              if(baud_tick && tx_done) begin
			    ns=idle;
			  end else begin
                ns=stop;
			  end
		  end
		  default :ns=ps;
	 endcase
  end


  //output logic - determines module outputs based on current state
  always @ (posedge clk) begin
    case(ps)
//idle: keep tx_line = 1 (idle high). If start_tx asserted, load tx_data and clear tx_done.	
	    idle : begin          
		   tx_line <= 1;
		   if (start_tx)begin
               tx_done<=0;
			   tx_data<=data_in;
		   end else begin
               tx_done<=0;
			   //tx_data<='bz;
		   end          
		end

 //drive start bit tx_line = 0, clear bit_index.

		start : begin         
		   tx_done<=0;
		   tx_line<=0;
		   bit_index<=0;
		end

//data: on every baud_tick step send the current data bit (LSB first) and use tick_counter to hold each bit for 16 baud_ticks. After 16 ticks, advance bit_index.

		data : begin                         
		 if(baud_tick) begin
		    if(tick_counter==0) begin
              tx_line <= tx_data[bit_index];  //put current bit on the line
			  tick_counter <= tick_counter+1;
			end else begin
               if(tick_counter==15)begin
                 bit_index <= bit_index+1;
				 tick_counter <=0;
			   end else begin
			      tick_counter <=tick_counter+1;
               end
			end
		  end
		  end
		  
		  stop: begin                    //stop: on each baud_tick drive tx_line = 1; after 16 ticks assert tx_done.
             if(baud_tick) begin
               tx_line <=1;
			    if(tick_counter==15)begin
                   tx_done <=1;
				   tick_counter<=0;
				end else begin
				   tick_counter <= tick_counter+1;
			 end
		  end
		end
        default : begin
           tx_done <=1;
		   tx_line <=1;
		   bit_index <=0;
		   tick_counter <=0;
		end
	endcase	
  end
endmodule
