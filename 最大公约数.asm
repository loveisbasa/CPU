#To calculate the greatest common divisor

.text
main:	li 	$v0,	5
	syscall
	addi	$s0,	$v0,	0	#$s0 = m
	li	$v0,	5
	syscall
	add	$s1,	$v0,	0	#$s1 = n
	beq	$s0,	$zero,	b1	#if (m == 0) out = n
	beq	$s1,	$zero,	b2	#if (n == 0) out = m
	blt	$s0,	$s1,	exchange	#if (m < n) exchange(m, n)
	
test:	bne	$s1,	$zero,	loop	#if (n != 0) zhanzhuanxiangchu
	addi	$a3,	$s0,	0
	li	$v0,	1	#cout << $a3
	addi	$a0,	$a3,	0
	syscall
	li	$v0,	10
	syscall
		
b1:	addi	$a3,	$s1,	0

b2:	addi	$a3,	$s0,	0

exchange:
	addi	$t0,	$s0,	0
	addi	$s0,	$s1,	0
	addi	$s1,	$t0,	0
	
loop:	addi	$t1,	$s0,	0	
loop1:	sub	$t1,	$t1,	$s1
	bge	$t1,	$s1,	loop1	#$t1 = m % n
	addi	$s0,	$s1,	0
	addi	$s1,	$t1,	0
	j	test
	