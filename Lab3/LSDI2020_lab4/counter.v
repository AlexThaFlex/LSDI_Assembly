module counter ( ck, reset, load, I, Q );
	input ck, reset, load;
	input [4:0] I;
	output [4:0] Q;
	
	reg [4:0] Q;

	always @(posedge ck or posedge reset)
		if (reset)
			Q <= 5'd0;
		else
			if (load)
				Q <= I;
			else
				Q <= Q + 5'b1; // to avoid warning message (Result of 6-bit expression is 
				               // truncated to fit in 5-bit target)
endmodule