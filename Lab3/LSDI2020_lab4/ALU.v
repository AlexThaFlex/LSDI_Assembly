`timescale 1ns/1ns

module ALU ( A, B, OPR, R, FLAGS );
input [7:0] A, B;
input [2:0] OPR;
output [7:0] R;
output [3:0] FLAGS;
reg    [7:0] R;
reg          co;
reg          ovfl;

always @*
begin
  case( OPR )
    0: {co, R} = {1'b0, B};  // para garantir a não inferência de latches, evitando os warnings
    1: {co, R} = A - B;
    2: {co, R} = A + B;
    3: {co, R} = {1'b0, A ^ B};           //co=1'b0;end
    4: {co, R} = {1'b0, { A[7], A[7:1]}}; // co=1'b0;end
    5: {co, R} = {1'b0, A << 1}; //co=1'b0;end
    6: {co, R} = {1'b0, A & B}; //co=1'b0;end
    7: {co, R} = {1'b0, A | B}; //co=1'b0;end
  endcase
end
 
assign FLAGS[0] = ~( | R ); // zero
assign FLAGS[1] = R[7]; // sinal
assign FLAGS[2] = (OPR == 1 || OPR == 2) ? co : 1'b0; // carryout
assign FLAGS[3] = ovfl;


always @*
begin
  case ( OPR )
    3'b010: ovfl = (A[7] == B[7]) && (R[7] != A[7]); // adição
    3'b001: ovfl = (A[7] != B[7]) && (R[7] != A[7]); // subtracção
    default: ovfl = 1'b0;
  endcase
end

endmodule
