module ROM( endereco, dado );
	input  [4:0] endereco;  // 5 bits para endereçar 4 posições de memória
	output [7:0] dado;      // conteúdos de 8 bits
	reg [7:0] dado;

	always @*
		case (endereco) // Especifique o valor binário (8 bits) a atribuir a 'dado',
                        // usando o formato exemplificado por dado = 8'b11010001.	
			0: dado =  ;  
			1: dado =  ;
			2: dado =  ;
			3: dado =  ;

			default: dado = 8'b000_000_00;
		endcase
endmodule
