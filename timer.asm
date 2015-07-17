#Outside device
	j	reset
	j	inter	#zhongduan
	jr	$26	#yichang
	
reset:	lui	$a0,	16384
	addiu	$a0,	$a0,	8
	sw	$zero,	0($a0)	#TCON = 0
	lui	$t1,	-1
	addiu	$t1,	$t1,	15535	#TH = 0xFFFF3CAF
	lui	$t2,	-1
	addiu	$t2,	$t2,	-1	#TL = 0xFFFFFFFF
	addi	$t0,	$zero,	3
	sw	$t0,	0($a0)	#TCON = 3

inter:
	lw	$t0,	0($a0)
	andi	$t0,	$t0,	-7	#TCON &= 0xfffffff9
	
reset:	lui	$a0,	16384
	addiu	$a0,	$a0,	8
	sw	$zero,	0($a0)	#TCON = 0
	lui	$t1,	-1
	addiu	$t1,	$t1,	15535	#TH = 0xFFFF3CAF
	lui	$t2,	-1
	addiu	$t2,	$t2,	-1	#TL = 0xFFFFFFFF
	addi	$t0,	$zero,	3
	sw	$t0,	0($a0)	#TCON = 3
	
	lui	$a1,	16384
	addiu	$a1,	$a1,	20
	
	
###############################################################
main:	#li 	$v0,	5	#the greatest divider begins
	#syscall
	#addi	$s0,	$v0,	0	#$s0 = m
	#li	$v0,	5
	#syscall
	#add	$s1,	$v0,	0	#$s1 = n
	lui	$t2,	16384
	addiu	$t2,	$t2,	28
	lw	$t7,	0($t2)
	andi	$t7,	$t7,	255
	lw	$s0,	1($t2)
	andi	$s0,	$s0,	255
	sll	$t7,	$t7,	8
	addu	$s0,	$s0,	$t7	#(t7 << 8) + s0 = s0
	lw	$t7,	2($t2)
	andi	$t7,	$t7,	255
	lw	$s1,	3($t2)
	andi	$s1,	$s1,	255
	sll	$t7,	$t7,	8
	addu	$s1,	$s1,	$t7	#(t7 << 8) + s1 = s1

	beq	$s0,	$zero,	b1	#if (m == 0) out = n
	beq	$s1,	$zero,	b2	#if (n == 0) out = m
	blt	$s0,	$s1,	exchange	#if (m < n) exchange(m, n)
	
test:	bne	$s1,	$zero,	loop	#if (n != 0) zhanzhuanxiangchu
	addi	$a3,	$s0,	0	#cout << a3
	addiu	$t2,	$t2,	0
	lui	$t2,	16384
	addiu	$t2,	$t2,	24
	move	$t3,	$a3
	sw	$t3,	0($t2)
	srl	$t3,	$t3,	8	#t3 >> 8
	sw	$t3,	1($t2)
	srl	$t3,	$t3,	8	#t3 >> 8
	sw	$t3,	2($t2)
	srl	$t3,	$t3,	8	#t3 >> 8
	sw	$t3,	3($t2)
	#qiduanyima
	jr	endinter
		
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
	j	test			#the greatest devider ends
###################################################################

endinter:
	lw	$t0,	0($a0)
	ori	$t0,	$t0,	2
	jr	$26
