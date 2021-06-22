#---------------------------------------------------------------------
# LSDI 2020/21 - FEUP
# Lab 5 (Jan. 2021) - parte II (opera��es com 2 vetores)
# Ver. 2.3
#---------------------------------------------------------------------

	.data
Nmax:	.word	100
N:      .word	10   
array1:	.word   0 : 100
array2:	.word   0 : 100
strSumV:.asciiz "Sequ�ncia soma = "
strPint:.asciiz "Produto interno = "
strMaxM:.asciiz "Maior m�dia = "
strNigs:.asciiz "N� de elementos comuns = "
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
	jal fillV1
	jal printV1
	j   main

main2:  bne $v0, 3, main3
	jal fillV2
	jal printV2
	j   main

main3:  bne $v0, 4, main4
	jal printV1
	j   main

main4:  bne $v0, 5, main5
	la  $a0, N
	lw  $a0, ($a0)
	la  $a1, array1
	la  $a2, array2

	jal sumV

	jal printV1

	j   main

main5:  bne $v0, 6, main6
	la  $a0, N
	lw  $a0, ($a0)
	la  $a1, array1
	la  $a2, array2
	
	jal prodInt

	move $a0, $v0
	la  $v0, strPint
	jal result

	j   main

main6:  bne $v0, 7, main7
	la  $a0, N
	lw  $a0, ($a0)
	la  $a1, array1
	la  $a2, array2

	jal maxMed

	move $a0, $v0
	la  $v0, strMaxM
	jal result

	j   main

main7:  bne $v0, 8, main9    # v2
	la  $a0, N
	lw  $a0, ($a0)
	la  $a1, array1
	la  $a2, array2

	jal com

	move $a0, $v0
	la  $v0, strNigs
	jal result
	
	j   main


main9:  beq $v0, 0, main10
	jal err
	j   main	

main10: li  $v0, 10
	syscall

#===================================================================================================
	.data
menu0:	.asciiz	"-------------------------------- MENU v2 ------------------------------------\n"
menu1:	.asciiz	"  Sequ�ncia: 1-Dimens�o  2-Preenche S1      3-Preenche S2  4-Imprimir S1\n"
menu2:	.asciiz	"  Opera��es: 5-Soma      6-Produto interno  7-Maior m�dia  8-Elementos iguais\n"
menu3:	.asciiz	"                                                           0-Terminar\n"
menu4:	.asciiz	"Introduza a sua op��o: "
#===================================================================================================

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
askN:	.asciiz	"Introduza o n�mero de elementos das sequ�ncias: "
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
strB1:	.asciiz "� elemento da sequ�ncia 1 = "
	.text
fillV1: la   $t2, array1
	la   $t0, N
	lw   $t0, ($t0)
	li   $t1, 0
fill2:  beq  $t0, $t1, fill1
	addi $t1, $t1, 1
	li   $v0, 1
	move $a0, $t1
	syscall

	li   $v0, 4
	la   $a0, strB1
	syscall

	li   $v0, 5
	syscall
	sw   $v0, ($t2)
		
	addi $t2, $t2, 4

	j    fill2

fill1:  jr   $ra

#---------------------------------------------------------------------
	.data
strB2:	.asciiz "� elemento da sequ�ncia 2 = "
	.text
fillV2: la   $t2, array2
	la   $t0, N
	lw   $t0, ($t0)
	li   $t1, 0
fill4:  beq  $t0, $t1, fill3
	addi $t1, $t1, 1
	li   $v0, 1
	move $a0, $t1
	syscall

	li   $v0, 4
	la   $a0, strB2
	syscall

	li   $v0, 5
	syscall
	sw   $v0, ($t2)
		
	addi $t2, $t2, 4

	j    fill4

fill3:  jr   $ra


#---------------------------------------------------------------------
	.data
strA1:	.asciiz "Sequ�ncia 1 = "
	.text
printV1:li  $v0, 4
	la  $a0, strA1
	syscall

	la  $t2, array1

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
strA2:	.asciiz "Sequ�ncia 2 = "
	.text
printV2:li  $v0, 4
	la  $a0, strA2
	syscall

	la  $t2, array2

	la  $t0, N
	lw  $t0, ($t0)
	li  $t1, 0
print4: beq $t0, $t1, print3
	li  $v0, 1
	lw  $a0, ($t2)
	syscall

	li  $v0, 4
	la  $a0, space
	syscall
		
	addi $t2, $t2, 4
	addi $t1, $t1, 1

	j    print4

print3: li  $v0, 4
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
# sumV - calcula a soma (vetorial) de duas sequ�ncias
#
# Argumentos:
#	$a0 - dimens�o das sequ�ncias
#	$a1 - endere�o base da sequ�ncia 1
#	$a2 - endere�o base da sequ�ncia 2
# Valor retornado
#	nenhum: ap�s a opera��o, $a1 tem o endere�o base da sequ�ncia 
#               resultante (a sequ�ncia 1 original � perdida)
#---------------------------------------------------------------------

sumV:	# coloque o seu c�digo a partir daqui...
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2
	
sumV_cycle:
	blez $t0, sumV_end
	
	lw $t3, 0($t1)
	lw $t4, 0($t2)
	add $t3, $t3, $t4
	sw $t3, 0($t1)
	
	subi $t0, $t0, 1
	addi $t1, $t1, 4
	addi $t2, $t2, 4
	j sumV_cycle
sumV_end:
	jr  $ra    # para retornar ao programa que chamou esta rotina


#---------------------------------------------------------------------
# prodInt - calcula o produto interno de dois vetores (sequ�ncias)
#
# Argumentos:
#	$a0 - dimens�o das sequ�ncias
#	$a1 - endere�o base da sequ�ncia 1
#	$a2 - endere�o base da sequ�ncia 2
# Valor retornado
#	$v0 - produto interno
#---------------------------------------------------------------------

prodInt:	# coloque o seu c�digo a partir daqui...
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2
	li $v0, 0

#neste exercício vou fazer outra opção para o ciclo (a maneira usada nos exercícios antiores está comentada)
# esta forma de fazer ciclos é a análoga ao "do-while" em C
	blez $t0, sumV_end #verifico se o array não está vazio. se estiver, salta logo para o fim

prodInt_cycle:
#	blez $t0, sumV_end
	lw $t3, 0($t1)
	lw $t4, 0($t2)
	mul $t3, $t3, $t4
	add $v0, $v0, $t3

	subi $t0, $t0, 1
	addi $t1, $t1, 4
	addi $t2, $t2, 4

	bgtz $t0, prodInt_cycle #só volta para o ciclo se ainda não estiver no fim
#	j prodInt_cycle
prodInt_end:
	jr $ra


#---------------------------------------------------------------------
# maxMed - calcula a m�dia das sequ�ncias e determina a maior das duas
#
# Argumentos:
#	$a0 - dimens�o das sequ�ncias
#	$a1 - endere�o base da sequ�ncia 1
#	$a2 - endere�o base da sequ�ncia 2
# Valor retornado
#	$v0 - valor da maior m�dia
#---------------------------------------------------------------------

maxMed:	# coloque o seu c�digo a partir daqui...
	li $v0, 0 #soma da sequência 1
	blez $a0, maxMed_end #se não houver elementos nos arrays, retorna logo
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2
	li $t3, 0 #soma da sequêcia 2

maxMed_cycle:
	blez $t0, maxMed_comparar
	
	lw $t4, 0($t1)
	add $v0, $v0, $t4
	lw $t4, 0($t2)
	add $t3, $t3, $t4

	subi $t0, $t0, 1
	addi $t1, $t1, 4
	addi $t2, $t2, 4
	
	j maxMed_cycle
maxMed_comparar:
	blt $t3, $v0, maxMed_calc_med #se $t3<$v0 não há necessidade de alterar o valor de $v0 pois já contém o maior valor
	move $v0, $t3
maxMed_calc_med:
#nesta altura temos a maior soma em $v0
	div $v0, $a0
	mflo $v0
#nesta implementação estou a retornar o valor truncado (apenas o quociente; o equivalente a um cast para int em C) em vez de arredondado,
# por exemplo, 8/3=2 em vez do valor arrendondado (que seria 3)
#se quiserem arredondar, podem adicionar aqui a lógica para arredondar que está no exercício "avg" no ficheiro "progLab5.asm.asm"
maxMed_end:
	jr $ra


#---------------------------------------------------------------------
# com - determina o n�mero de elementos comuns �s sequ�ncias
#
# Argumentos:
#	$a0 - dimens�o das sequ�ncias
#	$a1 - endere�o base da sequ�ncia 1
#	$a2 - endere�o base da sequ�ncia 2
# Valor retornado
#	$v0 - n�mero de elementos
#---------------------------------------------------------------------

com:	# coloque o seu c�digo a partir daqui...
	li  $v0, 0
	move $t0, $a0 #começa ciclo 1 com o contador $t0 igual ao número de elementos
	move $t1, $a1 #começa ciclo 1 com o contador $t1 igual ao apontador para a sequência 1
com_cycle_1:
	blez $t0, com_end #quando chegar ao final da sequência 1 (e por consequência, da sequência 2 porque elas têm o mesmo tamanho), salta para o fim

	move $t2, $a0 #começa o ciclo 2 com o contador $t2 igual ao número de elementos
	move $t3, $a2 #começa o ciclo 2 com o contador $t3 igual ao apontador para a sequência 2
	lw $t4, 0($t1) #começa o ciclo 2 com $t4 igual ao valor actual da sequência 1
com_cycle_2:
	blez $t2, com_cycle_1_next_iter
	
	lw $t5, 0($t3)
	bne $t4, $t5, com_cycle_2_next_iter
	
	#só chega a esta linha se $t4==$t5, ou seja se encontrou um número em comum
	addi $v0, $v0, 1 #por isso incrementa por 1 o retorno
	j com_cycle_1_next_iter # avança para o próximo elemento da sequência 1
	
com_cycle_2_next_iter:
	subi $t2, $t2, 1
	addi $t3, $t3, 4
	j com_cycle_2
com_cycle_1_next_iter:
	subi $t0, $t0, 1
	addi $t1, $t1, 4
	j com_cycle_1

com_end:
	jr $ra

#---------------------------------------------------------------------
