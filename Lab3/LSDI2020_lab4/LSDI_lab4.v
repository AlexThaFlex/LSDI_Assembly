`timescale 1ns/100ps

module LSDI_lab4( 		//------------------------------------------------------------------
                        // main clock sources:
                        clock100MHz,	// master clock input (external oscillator 100MHz)

                        // push buttons: button down = logic 1 (no debouncing hw)
							   btnu,  // reset
							   btnc,  // clock enable
								btnd,  // debug

								//------------------------------------------------------------------
								// LEDs: logic 1 lights the LED
								// ld15-ld8 show the {OPR, SEL, CE} values as defined by the 8-leftmost switches
								ld15,
								ld14,
								ld13,
								ld12,
								ld11,
								ld10,
								ld9,
								ld8,
								// The 4-rightmost are drived by FLAGS output of datapath
								ld3,
								ld2,
								ld1,
								ld0,			// LED 0 (rightmost)

								//------------------------------------------------------------------
								// Slide switches: UP position generates a logic 1
								//// OPR, defines the operation
								//sw15,			// switch 15 (leftmost)
								//sw14,
								//sw13,
								//// SEL, defines the operand (B)
								//sw12,
								//sw11,
								//sw10,
								//// CE, defines where the result is written
								//sw9,
								//sw8,
								// 8-bit input port (X)
								sw7,			
								sw6,
								sw5,
								sw4,
								sw3,
								sw2,
								sw1,
								sw0,			// switch 0 (rightmost)

								//------------------------------------------------------------------
								// Seven segment display: logic 0 lights the segment LED
								//                        logic 0 enables each display
								sega,			// segment a
								segb,
								segc,
								segd,
								sege,
								segf,
								segg,
								dp,			// decimal point
								an7,        // display enable (leftmost digit)
								an6,
								an5,
								an4,
								an3,
								an2,
								an1,
								an0			// display enable (rightmost digit)
                        );

// clocks:
input				clock100MHz;
 
// buttons and switches:
input			btnu, btnc, btnd,   
//				sw15, sw14, sw13,                        // OPR (código da operaçao)
//				sw12, sw11, sw10,                        // SEL (seleção do operando B)
//				sw9, sw8,                                // CE  (registo onde guarda resultado)
				sw7, sw6, sw5, sw4, sw3, sw2, sw1, sw0;  // Operando A

output 		ld15, ld14, ld13, ld12, ld11, ld10, ld9, ld8, // código da instrução (OPR, SEL, CE)
            ld3, ld2, ld1, ld0;                      // FLAGS (OVFL, CARRY, SINAL, ZERO)

// 7-segment displays:
output		sega, segb, segc, segd, sege, segf, segg, dp,
				an7, an6, an5, an4,an3, an2, an1, an0;

// Reset assíncrono atuado pelo botão de pressão BTNU
wire reset = btnu;              

// Modo debug - permite ver conteúdo dos registos nos displays (por omissão mostram R, A, B)
wire debug = btnd;

// Sinal de clock enable para o display de 7 segmentos:
wire 	clken250hz;

//-------------------------------------------------------------------------------
//###############################################################################   
// Add additional wires here:

wire       en_clock, en_clocki;
wire       clken100hz;
wire [2:0] OPR, SEL;
wire [1:0] CE;
wire [7:0] R, A, B, R1, R2, R3;
wire [7:0] X = {sw7, sw6, sw5, sw4, sw3, sw2, sw1, sw0};    // porta de entrada
wire [4:0] endereco;

wire [7:0] disp10, disp32, disp54, disp76;


//-------------------------------------------------------------------------------
//###############################################################################
// Add your circuit here:

// module datapath( clock, reset, X, A, B, R1, R2, R3, FLAGS, endereco, dados);

datapath_ROM datapath_ROM_1(.clock(en_clocki),   //clock100MHz ),
						  .reset(reset),
						  .X(X),
                    .R(R),
                    .A(A),
                    .B(B),
                    .R1(R1),
                    .R2(R2),
                    .R3(R3),
						  .FLAGS({ld3, ld2, ld1, ld0}),  // O,C,S,Z
                    .endereco(endereco),
                    .dados({ld15, ld14, ld13, ld12, ld11, ld10, ld9, ld8})  // OPR, SEL, CE
						  );

// Valores multiplexados nos displays:
// Modo normal (btnd=0): valores atuais de E, R, A, B   (E=endereco)
// Modo debug (btnd=1): valores atuais dos registos A, R1, R2, R3
assign disp10 = debug ? R3 : B;
assign disp32 = debug ? R2 : A;
assign disp54 = debug ? R1 : R;
assign disp76 = debug ? A : {3'b0, endereco};
	
//-------------------------------------------------------------------------------
//###############################################################################
// IO interface with your circuit

disp7seg d7seg(.clockscan(clock100MHz),
               .areset(reset),
					.clkenable(clken250hz),

               .d7(disp76[7:4]),
					.d6(disp76[3:0]),
					.d5(disp54[7:4]),
					.d4(disp54[3:0]),
               .d3(disp32[7:4]),
					.d2(disp32[3:0]),
					.d1(disp10[7:4]),
					.d0(disp10[3:0]),
						  
               .dp7(1'b0), 
					.dp6(1'b0), 
					.dp5(1'b0), 
					.dp4(1'b0),
               .dp3(1'b0), 
					.dp2(1'b0), 
					.dp1(1'b0), 
					.dp0(1'b0),

               .dp(dp), 
					.seg_a(sega), 
					.seg_b(segb), 
					.seg_c(segc), 
					.seg_d(segd),
					.seg_e(sege),
					.seg_f(segf),
					.seg_g(segg),

					.en_d7(an7),
					.en_d6(an6),
					.en_d5(an5),
					.en_d4(an4),
					.en_d3(an3),
					.en_d2(an2),
					.en_d1(an1),
					.en_d0(an0)
					);

disp7seg_clockgen  disp7seg_clockgen_1(.clock(clock100MHz), 
													.reset(reset), 
													.clocken(clken250hz)
												   );

debounce debounce_1(.clock( clock100MHz ),     // master clock (100MHz)
                    .reset( 1'b0 ),            // master reset, assynchronous, active high
					     .clken100hz( clken100hz ), // clock enable output, ...
                    .key0in( btnc ),           // connects to external key input
                    .key0out( en_clocki )      // output signal (the only that is used)
                    );
								 
autorepeat autorepeat_1(.clock( clock100MHz ), // master clock (100MHz)
                        .reset( 1'b0 ),        // master reset, assynchronous, active high
				            .clken( clken100hz ),  // clock enable signal, ...
				            .rpten( 1'b0 ),        // enable repeat function
                        .keyin( en_clocki ),   // connects to the debounced key input
                        .keyout( en_clock )    // output signal with autorepeat
                        );				  

endmodule

