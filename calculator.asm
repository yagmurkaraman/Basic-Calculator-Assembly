
.data


int1: .asciiz "Enter before from dot of first number: "
int2: .asciiz "Enter after from dot of first number: "
op: .asciiz "Enter an op(+,-,*): "
int3: .asciiz "\nEnter before from dot of second number: "
int4: .asciiz "Enter after from dot of second number: "
result: .asciiz "The result is: "
zero: .asciiz "0"
negative: .asciiz "-"
dot: .asciiz "."

.globl main

.text
main:

#read first number
li $v0, 4
la $a0, int1
syscall

li $v0, 5
syscall
move $s0, $v0 #first number loaded s0

#read second number
li $v0, 4
la $a0, int2
syscall

li $v0, 5
syscall
move $s1, $v0 #second number loaded s1

#read operand
li $v0, 4
la $a0, op
syscall

li $v0, 12
syscall
la $a1, ($v0) #operand loaded a1

#read third number
li $v0, 4
la $a0, int3
syscall

li $v0, 5
syscall
move $s2, $v0 #third number loaded s2

#read forth number
li $v0, 4
la $a0, int4
syscall

li $v0, 5
syscall
move $s3, $v0 #forth number loaded s3 


move $s6, $s1 #s1 moved to s6 for temp
move $s7, $s3 #s3 moved to s7 for temp
move $k0, $s0 #s0 moved to k0 for temp
move $k1, $s2 #s2 moved to k1 for temp
 
digitsFirstNumber: 

	div $s4, $s1, 10  #divide s1 to 10 and result moved s4
	move $s1, $s4 #result is new s1 content
	addi $t2, $t2, 1 #t2 is count for number of digits of s1
	bne $s1, $zero, digitsFirstNumber #until s1 is not 0
	j digitsSecondNumber #jump other procedure

digitsSecondNumber: 

	div $s4, $s3, 10 #divide s3 to 10 and result moved s4
	move $s3, $s4 #result is new s3 content
	addi $t3, $t3, 1 #t3 is count for number of digits of s3
	bne $s3, $zero, digitsSecondNumber #until s3 is not 0
	j controlEqu #jump other procedure

controlEqu:

	li $t1, 10 #load 10 to t1
	beq $t2, $t3, newFormatFirst #compare digits of s1 and s3
	bgt $t2, $t3, bigFirst #t2>t3
	blt $t2, $t3, bigSecond #t2<t3
	
bigFirst:
	
	mult $s7, $t1 #multiply s7 with 10 until t2 equal t3
	mflo $s7 #assign the result to s7
	addi $t3, $t3, 1 #increment t3 value
	bne $t2, $t3, bigFirst #compare t2 and t3
	j newFormatFirst #jump other procedure

bigSecond:
	
	mult $s6, $t1 #multiply s6 with 10 until t2 equal t3
	mflo $s6 #assign the result to s6
	addi $t2, $t2, 1 #increment t2 value
	bne $t2, $t3, bigSecond #compare t2 and t3
	j newFormatFirst #jump other procedure

newFormatFirst:

	mult $k0, $t1 #expand value of k0 with product 10
	mflo $k0 #assign the result to k0
	addi $s4, $s4, 1 #increment s4 value
	beq $t2, $s4, newFormatSecond #compare t2 and t4 equal
	bne $t2, $s4, newFormatFirst #compare t2 and s4 not equal

newFormatSecond:

	mult $k1, $t1 #expand value of k1 with product 10
	mflo $k1 #assign the result to k1
	addi $t8, $t8, 1 #increment t8 value
	bne $t2, $t8, newFormatSecond #compare t2 and t8 equal
	
	beq $a1, '+', sumAllT  #addition
	beq $a1, '-', subAllS  #subtraction
	beq $a1, '*', multAllM #multiply

sumAllT:

	add $s6, $s6, $k0 #merge first number, move s6
	add $s7, $s7, $k1 #merge second number, move s7
	add $s1, $s6, $s7 #add s6 and s7, t0 s1
	add $s6, $s6, $s7 #add s6 and s7, t0 s6
	add $t0, $t0, $s6 #add s6 with t0 for temp
	j countTotalT     #jump other procedure	

subAllS:

	add $s6, $s6, $k0 #merge first number, move s6
	add $s7, $s7, $k1 #merge second number, move s7
	sub $s1, $s6, $s7 #sub s6 and s7, to s1
	sub $s6, $s6, $s7 #sub s6 and s7, to s6
	add $t0, $t0, $s6 #add s6 with t0 for temp
	j countTotalS     #jump other procedure

multAllM:

	add $s6, $s6, $k0 #merge first number, move s6
	add $s7, $s7, $k1 #merge second number, move s7
	mult $s6, $s7 #mult s6 and s7, to s6
	mflo $s6 #assign result to s6
	add $s1, $s1, $s6 #add s6 and s1, to s1
	add $t0, $t0, $s6 #add s6 with t0 for temp
	j countTotalM #jump other procedure

countTotalT:

	div $t5, $s6, 10 #divide s6 to 10 and result moved t5
	move $s6, $t5 #result is new s6 content
	addi $t4, $t4, 1 #increment number of digits of s6 
	bne $s6, $zero, countTotalT #compare s6 and zero
	add $s0, $s0, $s2 #add s0 to s2 and result added s0
	j countNewFirst #jump other procedure

countTotalS:

	div $t5, $s6, 10 #divide s6 to 10 and result moved t5
	move $s6, $t5 #result is new s6 content
	addi $t4, $t4, 1 #increment number of digits of s6 
	bne $s6, $zero, countTotalS #compare s6 and zero
	sub $s0, $s0, $s2 #sub s2 from s0 and result added s0
	beq $s0, $zero, resultS2 #compare s0 and zero
	j countNewFirst #jump other procedure

countTotalM:

	div $t5, $s6, 10 #divide s6 to 10 and result moved t5
	move $s6, $t5 #result is new s6 content
	addi $t4, $t4, 1 #increment number of digits of s6 
	bne $s6, $zero, countTotalM #compare s6 and zero
	mult $s0, $s2 #mult s0 with s2 
	mflo $s0 #result added s0
	beq $s0, $zero, resultS2 #compare s0 and zero
	j countNewFirst #jump other procedure

countNewFirst:
	
	div $t5, $s0, 10 #divide s0 to 10 and result moved t5
	move $s0, $t5 #result is new s0 content
	addi $t6, $t6, 1 #increment number of digits of s0
	bne $s0, $zero, countNewFirst #compare s0 and zero
	j subtCount #jump other procedure

subtCount:

	sub $t4, $t4, $t6 #sub t6 from t4 and assign t4
	addi $t5, $t5, 1 #add 1 to t5
	li $t1, 10	#load 10 to t1
	j divFloat #jump other procedure

divFloat:
	
	mult $t5, $t1 #mult t5 with t1
	mflo $t5 #assign result to t5
	addi $t7, $t7, 1 #add 1 to t7
	bne $t7, $t4, divFloat #compare t7 and t4
	beq $a1, '+', resultT #addition
	beq $a1, '-', resultS #subtraction
	beq $a1, '*', resultM #multiply

resultT:

	div $s0, $t0, $t5 #divide t0 to t5
	mflo $s0 #result moved s0
	mfhi $s1 #remain moved s1
	li $v0, 4 
	la $a0, result
	syscall #print result string to console
	j Exit #Exit from program
	# first s0
	# second s1

resultS:

	div $s0, $t0, $t5 #divide t0 to t5
	mflo $s0 #result moved s0
	mfhi $s1 #remain moved s1 
	blt $s1, $zero, bePositive #compare s1 is negative
	li $v0, 4 
	la $a0, result
	syscall #print result string to console
	j Exit #Exit from console

resultS2:

	blt $s1, $zero, removeNegative #compare s1 less than zero
	li $v0, 4 
	la $a0, result
	syscall #print result string to console
	j Exit #Exit from program

removeNegative:
	
	addi $s3, $s3, -1 #add -1 to s3
	mult $s1, $s3 #mult s1 with s3
	mflo $s1 #result assigned to s1
	li $v0, 4
	la $a0, result
	syscall #print result string to console
	li $v0, 4
	la $a0, negative
	syscall #print - to console
	j Exit #Exit from program
	

resultM:

	div $s0, $t0, $t5 #divide t0 to t5
	mflo $s0 #result assign to s0
	mfhi $s1 #remain assign s1
	blt $s1, $zero, bePositive #compare s1 less than zero
	li $v0, 4
	la $a0, result
	syscall #print result string to console
	j Exit #Exit from program

bePositive:
	
	addi $s3, $s3, -1 #add -1 to s3
	mult $s1, $s3 #mult s1 and s3, after from dot
	mflo $s1 #result assign to s1
	li $v0, 4
	la $a0, result
	syscall #print result string to console
	j Exit #Exit from program
	# first s0
	# second s1

Exit:	
	
	li $v0, 1
	move $a0, $s0
	syscall #print s0 content to console, before dot	
	####
	li $v0, 4
	la $a0, dot
	syscall #print dot string to console
	####	
	li $v0, 1
	move $a0, $s1
	syscall #print s1 content to console, after dot

	
