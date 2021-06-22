/*

  debounce

  V1.0 Dez 2005

  This module implements a digital debounce for a push-button. Output is synchronous
  with the master clock and is activated only when the input signal is high for
  at least 100ms (sampled at 10 points separeated by 10ms). 

------------------------------------------------------------

  Revision history:

  - Dec 21, 2005 - First release, jca (jca@fe.up.pt)
  - Jul 25, 2017 - Master clock changed to 100MHz, AJA
  - Nov 13, 2017 - Only one in/out signal, AJA
------------------------------------------------------------
  
*/
`timescale 1ns/100ps

module debounce(clock,  // master clock (100MHz)
                reset,  // master reset, assynchronous, active high
		          clken100hz,  // clock enable output, 100Hz
                key0in, // connects to external key input
                key0out // output signal
                );

parameter    TIME_BASE   = 999999;  // 100000000Hz / 100Hz - 1

input        clock, reset;
output       clken100hz;
input        key0in; 
output       key0out; 
reg          key0out; 

wire         key0outi;  

// local signals:
reg  [19:0]  clkdiv;  // clock divider counter (100MHz / 1000000 = 100Hz = 1/10ms)

reg  [5:0]  key0sr;


// clock divider counter:
always @(posedge clock or posedge reset)
begin
  if ( reset )
  begin
    clkdiv <= 0;
  end
  else
  begin
    if ( clkdiv == TIME_BASE )		
	   clkdiv <= 0;
    else
	   clkdiv <= clkdiv + 1'b1;
  end
end


// clock enable 100Hz
assign clken100hz = ( clkdiv == TIME_BASE ); 

// 2-stage input synchronizer and 
// 4-stage debounce shift register:
always @(posedge clock or posedge reset)
begin
  if ( reset )
  begin
    key0sr <= 0;
  end
  else
  begin
    if ( clken100hz )	  // shift right and load input key
	 begin
      key0sr <= (key0sr >> 1) | {key0in, 5'b0}; 
	 end
  end
end

// debounced key output:
// key0out is activated only when input is high for more than 40ms
assign key0outi = & key0sr[3:0];

// Additional output register to eliminate glitches:
always @(posedge clock or posedge reset)
begin
  if ( reset )
  begin
    key0out <= 0;
  end
  else
  begin
    key0out <= key0outi;
  end
end

endmodule

