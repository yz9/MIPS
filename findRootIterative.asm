#Yuan Zhang
#260685242

# -----------------   findRoot  ----------------------------- 

#  arguments:
#  a       in $f12
#  c       in $f13
#  epsilon in $f14

#  returns result in $f0

findRoot:
	addi	$sp, $sp, -12
	s.s	$f20, 0($sp)
	s.s	$f22, 4($sp)
	s.s	$f24, 8($sp)				

	
	j while					#call the while loop 

	
while:	
#	sub.s  $f10, $f13, $f12			#b-a
#	c.lt.s $f14, $f10			#while (b-a) > epsilon  
	######################### 
	#while (true)
	add.s	$f4, $f12, $f13			#f4=f12+f13=a+c
	
	addi    $t2, $0, 2
	mtc1    $t2, $f6
	cvt.s.w $f6, $f6 			#f6=2
	div.s	$f20, $f4, $f6                  #f20=f4/f6=(a+c)/2=b  
	mov.s	$f22, $f12			#f22=a
	mov.s	$f24, $f13			#f24=c
	mov.s	$f12, $f20			#f22=a, f24=c, f20=b
	sw	$ra, 0($sp)
	addi	$sp, $sp, -4
	jal	evaluate			#p(b)
	addi	$sp, $sp, 4
	lw	$ra, 0($sp)
	addi    $t2, $0, 0
	mtc1    $t2, $f5
	cvt.s.w $f5, $f5 			#f5=0
	c.eq.s	$f5, $f0			#p(b)=f0
	mov.s	$f2, $f0			# f2 = p(b)
	mov.s	$f0, $f20			#put b to f0
	bc1t	return				#if p(b) ==  0 -> return b f0
	sub.s	$f4, $f22, $f24			#f4=a-c
	abs.s	$f4, $f4			#|a-c|
	c.lt.s	$f4, $f14			#F14=EPSILON   |a-c|<epsilon 
	bc1t	return				#|a-c| <epsilon -> return b
	mov.s	$f12, $f22			#put a to f12
	sw	$ra, 0($sp)
	addi	$sp, $sp, -4
	jal	evaluate			#p(a)
	addi	$sp, $sp, 4
	lw	$ra, 0($sp)
	mul.s	$f6, $f2, $f0			#f6=p(a)*p(b)
	c.lt.s	$f5, $f6			# f5=0, 0<p(a)*p(b)
	bc1t	sameSign
	bc1f	oppsiteSign
	
	sameSign:
	mov.s	$f12, $f20			#f12=a =b (f20=b)
	mov.s	$f13, $f24			#f13=c =c
	j	while 	
	
	oppsiteSign:
	mov.s	$f12, $f22			#f12=a =a (f22=a)#
	mov.s	$f13, $f20			#f13=c =b  (f20=b)	
	j	while 		
	
	return:					#return b

	l.s	$f20, 0($sp)
	l.s	$f22, 4($sp)
	l.s	$f24, 8($sp)
	addi	$sp, $sp, 12
	jr	$ra
