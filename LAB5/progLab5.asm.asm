#---------------------------------------------------------------------
# LSDI 2020/21 - FEUP
# Lab 5 (Jan. 2021) - parte I (opera��es com 1 vetor)
# Ver. 2.3
#---------------------------------------------------------------------

	.data
Nmax:	.word	100
N:      .word	10   
array:	.word   0 : 100
strSum: .asciiz "Somat�rio = "
strAvg: .asciiz "M�dia = "
strMinL:.asciiz "N� de m�nimos locais = "
space:	.asciiz " "
crlf:	.asciiz "\n"

	.text
main:   li  $v0, 40	# set seed
	li  $a0, 0
	syscall

loop:   jal menu
	bne $v0, 1, main1
	jal readN
	j   loop

main1:  bne $v0, 2, main2
	jal fill
	jal print
	j   main

main2:  bne $v0, 3, main3
	jal rnd
	jal print
	j   main

main3:  bne $v0, 4, main4
	jal print
	j   main

main4:  bne $v0, 5, main5
	la  $a0, N
	lw  $a0, ($a0)
	la  $a1, array

	jal sum

	move $a0, $v0
	la  $v0, strSum
	jal result

	j   main

main5:  bne $v0, 6, main6
	la  $a0, N
	lw  $a0, ($a0)
	la  $a1, array

	jal avg

	move $a0, $v0
	la  $v0, strAvg
	jal result

	j   main

main6:  bne $v0, 7, main7
	la  $a0, N
	lw  $a0, ($a0)
	la  $a1, array

	jal minL

	move $a0, $v0
	la  $v0, strMinL
	jal result

	j   main

main7:  bne $v0, 8, main8
	la  $a0, N
	lw  $a0, ($a0)
	la  $a1, array

	jal inv    # N�o imprime resultado

	j   main

main8:  beq $v0, 0, main10
	jal err
	j   main	

main10:  li  $v0, 10
	syscall

#==========================================================================================
	.data
menu0:	.asciiz	"-------------------------------- MENU ---------------------------------\n"
menu1:	.asciiz	"  Sequ�ncia: 1-Dimens�o     2-Preencher    3-Aleat�rio       4-Imprimir\n"
menu2:	.asciiz	"  Opera��es: 5-Somat�rio    6-M�dia        7-M�nimos locais  8-Inverter\n"
menu3:	.asciiz	"                                                             0-Terminar\n"
menu4:	.asciiz	"Introduza a sua op��o: "
#==========================================================================================

	.text
menu:   li  $v0, 4
	la  $a0, menu0
	syscall
	la  $a0, menu1
	syscall
	la  $a0, menu2
	syscall
	la  $a0, menu3
	syscall
	la  $a0, menu4
	syscall

	li  $v0, 5
	syscall

	jr  $ra

#---------------------------------------------------------------------
	.data
askN:	.asciiz	"Introduza o n�mero de elementos da sequ�ncia: "
	.text
readN:  li  $v0, 4
	la  $a0, askN
	syscall

	li  $v0, 5
	syscall
	sw  $v0, N

	jr  $ra

#---------------------------------------------------------------------

result: move $t0, $a0
	move $a0, $v0
	li   $v0, 4
	syscall

	li   $v0, 1
	move $a0, $t0
	syscall

	li   $v0, 4
	la   $a0, crlf
	syscall

	jr   $ra

#---------------------------------------------------------------------
	.data
strB:	.asciiz "� elemento da sequ�ncia = "
	.text
fill:   la   $t2, array
	la   $t0, N
	lw   $t0, ($t0)
	li   $t1, 0
fill2:  beq  $t0, $t1, fill1
	addi $t1, $t1, 1
	li   $v0, 1
	move $a0, $t1
	syscall

	li   $v0, 4
	la   $a0, strB
	syscall

	li   $v0, 5
	syscall
	sw   $v0, ($t2)
		
	addi $t2, $t2, 4

	j    fill2

fill1:  jr   $ra

#---------------------------------------------------------------------

rnd:    la  $t2, array
	la  $t0, N
	lw  $t0, ($t0)
	li  $t1, 0

rnd2:   beq $t0, $t1, rnd1
	li  $v0, 42
	li  $a0, 0
	li  $a1, 100
	syscall

	sw  $a0, ($t2)
		
	addi $t2, $t2, 4
	addi $t1, $t1, 1

	j    rnd2

rnd1:   jr   $ra

#---------------------------------------------------------------------
	.data
strA:	.asciiz "Sequ�ncia = "
	.text
print:  li  $v0, 4
	la  $a0, strA
	syscall

	la  $t2, array

	la  $t0, N
	lw  $t0, ($t0)
	li  $t1, 0
print2: beq $t0, $t1, print1
	li  $v0, 1
	lw  $a0, ($t2)
	syscall

	li  $v0, 4
	la  $a0, space
	syscall
		
	addi $t2, $t2, 4
	addi $t1, $t1, 1

	j    print2

print1: li  $v0, 4
	la  $a0, crlf
	syscall

	jr  $ra

#---------------------------------------------------------------------

	.data
errStr:	.asciiz "Op��o inv�lida!\n"
	.text
err:    li  $v0, 4
	la  $a0, errStr
	syscall

	jr  $ra

#---------------------------------------------------------------------
# sum - calcula o somat�rio dos elementos de uma sequ�ncia
#
# Argumentos:
#	$a0 - dimens�o da sequ�ncia (const)
#	$a1 - endere�o base da sequ�ncia (const)
# Vars tempor�rias:
#	$t0, $t1, $t2
# Valor retornado:
#	$v0 - somat�rio
#---------------------------------------------------------------------

sum:	# coloque o seu c�digo a partir daqui...
	li $v0, 0      #ou "add $v0, $0, $0"
	move $t0, $a0  #ou "add $t0, $a0, $0"
	move $t1, $a1  #ou "add $t1, $a1, $0"
sum_cycle:
	blez $t0, sum_end
	lw  $t2, 0($t1)
	add $v0, $v0, $t2
	subi $t0, $t0, 1
	addi $t1, $t1, 4 #soma-se 4 ao endereço pois cada word tem 4 bytes, ou seja, a word seguinte está 4 bytes a seguir
	j sum_cycle
sum_end:
	jr  $ra    # para retornar ao programa que chamou esta rotina


#---------------------------------------------------------------------
# avg - calcula a m�dia aritm�tica dos elementos de uma sequ�ncia
#
# Argumentos:
#	$a0 - dimens�o da sequ�ncia (const)
#	$a1 - endere�o base da sequ�ncia (const)
# Vars tempor�rias:
#	$t0, $t1, $t2, $t3
# Valor retornado:
#	$v0 - m�dia
# Nota: A m�dia dever� ser arredondada para o inteiro mais pr�ximo
#---------------------------------------------------------------------

avg:	# coloque o seu c�digo a partir daqui...
	move $t3, $ra         #guardamos o endereço da linha para onde devemos saltar depois de terminarmos a rotina "avg"
	jal sum               #saltamos para a rotina "sum" de forma a calcular a soma dos elementos (esta operação altera
	                      # o $ra para o endereço da próxima linha para que o sum saiba para onde deve voltar, daí ser
	                      # importante guardar o $ra original antes desta linha)
	move $ra, $t3         #restauramos o endereço da linha para onde devemos saltar depois de terminarmos a rotina "avg"
	div $v0, $a0
	mflo $v0
	mfhi $t0
	
	li $t1, 2             #$t1 = 2
	div $a0, $t1          #calcula N/2
	mfhi $t1              #N%2
	mflo $t2              #(int)(N/2)
	add $t1, $t1, $t2     #t1 = (int)(N/2) + N%2
	
	blt $t0, $t1, avg_end #se o resto da visião da soma da sequência pelo número de elementos ($t0: resto do cálculo da média) for maior ou igual que
	                      # metade de N mais o resto da divisão de N por 2 ($t1: 1 quando o número de elementos é ímpar ou 0 se for par),
	                      # soma 1 ao resultado, ou seja, arredonda para cima. Se $t0 não for maior ou igual que $t1, ou dito de outra forma, se $t0 for menor
	                      # que $t1, não se soma nada (arrendonda para baixo).
	                      
	                      #Exemplo 1: Se N=5 (ímpar), e a soma dos números da sequência for 11, 11/5=2.2, ou seja o quociente é 2 e o resto é 1.
	                      # Como 1 é menor que 3 ( (int)(5/2)+(5%2) = 2+1 = 3 ), não se soma nada ao resultado. Assim, $v0 fica 2.
	                      
	                      #Exemplo 2: Se N=5 (ímpar), e a soma dos números da sequência for 13, 13/5=2.6, ou seja o quociente é 2 e o resto é 3.
	                      # Como 3 não é menor que 3 ( (int)(5/2)+(5%2) = 2+1 = 3 ), soma-se 1 ao resultado. Assim, $v0 fica 3.
	                      
	                      #Exemplo 3: Se N=4 (par), e a soma dos números da sequência for 9, 9/4=2.25 ou seja o quociente é 2 e o resto é 1.
	                      # Como 1 é menor que 2 ( (int)(4/2)+(4%2) = 2+0 = 2 ), não se soma nada ao resultado. Assim, $v0 fica 2.
	                      
	                      #Exemplo 4: Se N=4 (par), e a soma dos números da sequência for 10, 10/5=2.5, ou seja o quociente é 2 e o resto é 2.
	                      # Como 2 não é menor que 2 ( (int)(4/2)+(4%2) = 2+0 = 2 ), soma-se 1 ao resultado. Assim, $v0 fica 3.
	addi $v0, $v0, 1
avg_end:
	jr $ra    # para retornar ao programa que chamou esta rotina


#---------------------------------------------------------------------
# minL - determina o n�mero de m�nimos locais de uma sequ�ncia
#
# Argumentos:
#	$a0 - dimens�o da sequ�ncia
#	$a1 - endere�o base da sequ�ncia
# Valor retornado
#	$v0 - n�mero de m�nimos locais
#---------------------------------------------------------------------

minL:	# coloque o seu c�digo a partir daqui...
	li $v0, 0              #ou "add $v0, $0, $0"
	li $t0, 3              #ou "addi $t0, $0, 3"
	blt $a0, $t0, minL_end #se o número de elementos na sequência for menor que 

	subi $t0, $a0, 2       #iniciamos o contador com o número de elementos menos 2 pois os extremos não podem se mínimos locais
	move $t1, $a1
minL_cycle:
	blez $t0, minL_end
	lw $t2 4($t1) #$t2 = elemento actual
	lw $t3 0($t1) #$t3 = elemento da esquesrda
	
	ble $t3, $t2, minL_cycle_end
	
	lw $t3 8($t1) #$t3 = elemento da direita
	ble $t3, $t2, minL_cycle_end
	
	addi $v0, $v0, 1 #o programa só chega a esta linha se o elemento for menor que os da sua esquerda e direita, o que significa que é um mínimo local
minL_cycle_end:
	addi $t1, $t1, 4 #avançamos o endereço
	subi $t0, $t0, 1 #diminuimos o contador
	j minL_cycle
minL_end:
	jr $ra


#---------------------------------------------------------------------
# inv - inverte a ordem dos elementos de uma sequ�ncia
#
# Argumentos:
#	$a0 - dimens�o da sequ�ncia
#	$a1 - endere�o base da sequ�ncia
# Valor retornado
#	nenhum (ap�s a opera��o, $a1 tem o endere�o base da sequ�ncia modificada)
#---------------------------------------------------------------------

inv:	# coloque o seu c�digo a partir daqui...
	
	#$t0 é o apontador da esquerda e o $t1 é o da direita
	move $t0, $a1
	subi $t1, $a0, 1
	sll $t1, $t1, 2 #multiplica (número de elementos-1) por 4
	add $t1, $a1, $t1 #coloca em $t1 o endereço do último elemento da sequência ($a1 + ($a0 - 1)*4)
inv_cycle:
	bge $t0, $t1, inv_end #quando o endereço no $t0 fica maior ou igual que $t1 significa que já trocámos todos os elementos
	
	#troca os conteúdos dos apontadores
	lw $t2, 0($t0)
	lw $t3, 0($t1)
	sw $t3, 0($t0)
	sw $t2, 0($t1)
	
	addi $t0, $t0, 4 #move o apontador da esquerda 4 bytes para a direita
	subi $t1, $t1, 4 #move o apontador da direita 4 bytes para a esquerda
	
	j inv_cycle
inv_end:
	jr $ra

#---------------------------------------------------------------------
