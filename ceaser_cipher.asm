#Caesar Cipher
#Jeremy Chaney
	.text
funct:	la $a0,function			#determine whether encoding or decoding
	li $v0,4
	syscall
	li $v0,5
	syscall
	li $s0,0
	li $s1,1
	beq,$v0,$s1,encode
	beq,$v0,$s0,decode
	
encode:	li $s6,1			#shift multiplier for encoding
	j rules

decode:	li $s6,-1			#shift multiplier for decoding
	j rules
	
rules:	la $a0,rule			#determine shift amount
	li $v0,4
	syscall
	li $v0,5
	syscall
	move $s5,$v0
	mul,$s7,$s5,$s6
	bgt $s7,26,hshift
	blt $s7,-26,lshift
	j main
	
hshift:	sub $s7,$s7,26			#make necessary shift adjustments
	blt $s7,26,main
	beq $s7,26,main
	j hshift
	
lshift:	add $s7,$s7,26			#make necessary shift adjustments
	bgt $s7,-26,main
	beq $s7,-26,main
	j lshift
	
main:	la $a0,prompt			#load the word
	li $v0,4
	syscall
	li $a1,20
	li $v0,8
	syscall
	move $t0,$a0
	la $a0,ans
	li $v0, 4
	syscall
	j loop
	
loop:	lb $t1,0($t0)
	beq $t1,0x20,space
	beqz $t1,check
	blt $t1,0x61,ucase
	bgt $t1,0x7a,wrong
	add $t1,$t1,$s7
	blt $t1,0x61,less
	bgt $t1,0x7a,more
	j valid
	
space:	move $a0,$t1
	li $v0,11
	syscall
	addi $t0,$t0,1
	j loop
	
more:	sub $t1,$t1,26			#adjust if over the highest letter
	j valid

less:	addi $t1,$t1,26			#adjust if under the lowest letter
	j valid
	
valid:	move $a0,$t1			#print individual letters if ready to be printed
	li $v0,11
	syscall
	addi $t0,$t0,1
	j loop
	
ucase:	blt $t1,0x41,wrong		#Uppercase Stuff
	bgt $t1,0x5a,wrong
	add $t1,$t1,$s7
	blt $t1,0x41,less
	bgt $t1,0x5a,more
	j valid

wrong:	la $a0,no			#something is wrong
	li $v0,4
	syscall
	j check
	
check:	la $a0,again			#ask for a second word under same rules
	li $v0,4
	syscall
	li $v0,11
	li $a0,0x0a
	syscall
	li $v0,12
	syscall
	beq $v0,0x79,main
	j checks
	
checks:	la $a0,change			#option to change rules
	li $v0,4
	syscall
	li $v0,11
	li $a0,0x0a
	syscall
	li $v0,12
	syscall
	beq $v0,0x79,funct
	j done
	
done:	li $v0,10			#check pulse to make sure you survived this hell
	syscall
	
		.data
prompt: 	.asciiz "Enter word to be encrypted (only lower case letters): "
ans:		.asciiz "Your answer is: "
again:		.asciiz " Another word? (y/n) "
rule:		.asciiz "enter number of places to move: "
change:		.asciiz "\nchoose another number of places to move? (y/n)"
no:		.asciiz ". The word entered is not within the perameters of this program."
function:	.asciiz "\nSelect '1' for encoding and '0' for decoding: "
