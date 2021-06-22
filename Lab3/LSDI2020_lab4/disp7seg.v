module disp7seg(clockscan, areset, clkenable,
                 d7, d6, d5, d4, d3, d2, d1, d0,
                 dp7, dp6, dp5, dp4, dp3, dp2, dp1, dp0,
                 dp, seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g,
                 en_d7, en_d6, en_d5, en_d4, en_d3, en_d2, en_d1, en_d0 );
                 
input       clockscan, areset;
input       clkenable;
input [3:0] d7, d6, d5, d4, d3, d2, d1, d0;
input       dp7, dp6, dp5, dp4, dp3, dp2, dp1, dp0;
output      dp, seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g;
output      en_d7, en_d6, en_d5, en_d4, en_d3, en_d2, en_d1, en_d0;
reg         dp;

reg    [3:0] out_display;
reg    [7:0] en_disp;


reg    [6:0] segments;


assign en_d7 = en_disp[7];
assign en_d6 = en_disp[6];
assign en_d5 = en_disp[5];
assign en_d4 = en_disp[4];
assign en_d3 = en_disp[3];
assign en_d2 = en_disp[2];
assign en_d1 = en_disp[1];
assign en_d0 = en_disp[0];


assign seg_a = ~segments[6];
assign seg_b = ~segments[5];
assign seg_c = ~segments[4];
assign seg_d = ~segments[3];
assign seg_e = ~segments[2];
assign seg_f = ~segments[1];
assign seg_g = ~segments[0];


// hex to 7-segment decoder
always @( out_display )
begin
  case ( out_display )
    4'b0000: begin
               segments = 7'b1111110;
             end
    4'b0001: begin
               segments = 7'b0110000;
             end
    4'b0010: begin
               segments = 7'b1101101;
             end
    4'b0011: begin
               segments = 7'b1111001;
             end
    4'b0100: begin
               segments = 7'b0110011;
             end
    4'b0101: begin
               segments = 7'b1011011;
             end
    4'b0110: begin
               segments = 7'b1011111;
             end
    4'b0111: begin
               segments = 7'b1110000;
             end
    4'b1000: begin
               segments = 7'b1111111;
             end
    4'b1001: begin
               segments = 7'b1111011;
             end             
    4'b1010: begin
               segments = 7'b1110111;
             end
    4'b1011: begin
               segments = 7'b0011111;
             end
    4'b1100: begin
               segments = 7'b0001101;
             end
    4'b1101: begin
               segments = 7'b0111101;
             end
    4'b1110: begin
               segments = 7'b1001111;
             end
    4'b1111: begin
               segments = 7'b1000111;
             end
  endcase
end


// output multiplexer
always @( en_disp or d0 or d1 or d2 or d3 or d4 or d5 or d6 or d7 or dp0 or dp1 or dp2 or dp3 or dp4 or dp5 or dp6 or dp7)
begin
  casex ( en_disp )
    8'b01111111: begin
               out_display = d7;
               dp = ~dp7;
             end
    8'b10111111: begin
               out_display = d6;
               dp = ~dp6;
             end
    8'b11011111: begin
               out_display = d5;
               dp = ~dp5;
             end
    8'b11101111: begin
               out_display = d4;
               dp = ~dp4;
             end
    8'b11110111: begin
               out_display = d3;
               dp = ~dp3;
             end
    8'b11111011: begin
               out_display = d2;
               dp = ~dp2;
             end
    8'b11111101: begin
               out_display = d1;
               dp = ~dp1;
             end
    8'b11111110: begin
               out_display = d0;
               dp = ~dp0;
             end
    default: begin
               out_display = 8'b00000000;
               dp = 1'b1;
             end
  endcase
end


// display scan
always @(posedge clockscan or posedge areset)
begin
  if ( areset )
  begin
    en_disp <= 8'b11111111;    // 0111 !!!
  end
  else
  if ( clkenable )
  begin
    case ( en_disp )
      8'b01111111: en_disp <= 8'b10111111;
      8'b10111111: en_disp <= 8'b11011111;
      8'b11011111: en_disp <= 8'b11101111;
      8'b11101111: en_disp <= 8'b11110111;
      8'b11110111: en_disp <= 8'b11111011;
      8'b11111011: en_disp <= 8'b11111101;
      8'b11111101: en_disp <= 8'b11111110;
      8'b11111110: en_disp <= 8'b01111111;
      default: en_disp <= 8'b01111111;  //4'b0111;
    endcase
  end
end

endmodule
