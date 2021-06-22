/*

  autorepeat

  V1.0 Dez 2005

  This module implements the autorepeat function with 500ms initial time to start the repeat 
  function and	300ms repeat interval. Time is counted in units of the period of clken100hz
  signal.       

------------------------------------------------------------

  Revision history:

  - Dec 21, 2005 - First release, jca (jca@fe.up.pt)
  - Jul 27. 2017 - Master clock changed to 100MHz, AJA
------------------------------------------------------------

*/
`timescale 1ns/100ps

module autorepeat
              ( clock,  // master clock (100MHz)
                reset,  // master reset, assynchronous, active high
					 clken,  // clock enable signal, 100Hz, used as time base
					 rpten,  // enable repeat function
                keyin,  // connects to the debounced key input
                keyout  // output signal with autorepeat
              );

// *2 pq clock tem agora o dobro da frequência...
parameter    START_TIME  = 2*600/10*3, // miliseconds / 10ms (mul by 3 for clkenable = 250Hz )
             REPEAT_TIME = 2*200/10*3;



input        clock, reset;
input        rpten;
input        clken;
input        keyin;
output       keyout;
reg          keyout;


// timer for the autorepeat function: counting is enabled by clken100hz
reg  [7:0]   timer;

// state for the autorepeat FSM
reg  [2:0]  state;

reg         resettimer;
reg         keypressed;



// control FSM:
always @(posedge clock or posedge reset)
begin
  if ( reset )
  begin
    state = 0;
    keypressed = 0;
    resettimer = 0;
	 keyout = 0;
  end
  else
  begin
    keyout = 0;
    resettimer = 0;
    case ( state )
    0: begin    // startup state: wait any key and reset timer
         resettimer = 1;
         if ( keyin )		 // key after debounce
           state = 1;
         else
           state = 0;
       end
    1: begin
         keyout = 1;
         state = 2;  
       end
       
     2: begin
          keyout = 0;
          if ( keyin )
			 begin
			   if ( rpten )
            begin
              if ( keypressed ? (timer==REPEAT_TIME) : (timer==START_TIME) )
              begin
				    keypressed = 1;
                state = 0;
              end
              else
              begin
                state = 2;
              end
            end
				else
				  state = 2; // keep here until key is released
          end
          else
          begin
            keypressed = 0;
            state = 0;
          end
        end
        
     default: state = 0;   
     
    endcase
  end
end


// timer for autorepeat function: counts units of 10ms
always @(posedge clock or posedge reset)
begin
  if ( reset )
    timer = 0;
  else
  begin
	 begin
      if ( resettimer )
      begin
        timer = 0;
      end
      else
      begin
		  if ( clken )
          timer = timer + 1'b1;
      end
	 end
  end
end

endmodule

