	asect	0x00
	# WRITE YOUR CODE HERE

	##square X
	ldi r0,x
	ld r0,r0
	jsr square16bit
	ldi r2,xsq
	st r2,r1
	inc r2
	st r2,r0
	
	move r0,r2
	move r1,r3

	##square Y
	ldi r0,y
	ld r0,r0
	jsr square16bit
	
	add r0,r2
	addc r1,r3
	push r3
	push r2
	#stack: (x^2+y^2)low,high
	
	ldi r2,ysq
	st r2,r1
	inc r2
	st r2,r0
	
	##square Z
	ldi r0,z
	ld r0,r0
	jsr square16bit
	ldi r2,zsq
	st r2,r1
	inc r2
	st r2,r0
		
	pop r2
	pop r3
	if
		cmp r0,r2
	is eq
		if
			cmp r1,r3
		is eq
			ldi r0,pyth
			ldi r1,0
			st r0,r1
		else
			ldi r0,pyth
			ldi r1,-1
			st r0,r1
		fi
	else
		ldi r0,pyth
		ldi r1,-1
		st r0,r1
	fi


	# at this point 'res' has the answer
	ldi   r0,res
	halt

##in: 1x8bit number in r0
##out 2x8bit numbers in r0,r1 (little)
square16bit:
	push r3
	push r2
	## r0 -- a
	## r1 -- 
	## r2 -- 
	## r3 -- 
	
	##clear r1 and c flag
	ldi r1,0
	shla r1
	
	##Split a into 2x4bit
	shr r0
	shr r1
	shr r0
	shr r1
	shr r0
	shr r1
	shr r0
	shr r1
	shr r1
	shr r1
	shr r1
	shr r1

	## r0 -- aHi
	## r1 -- aLo
	## r2 -- 
	## r3 -- 
	push r0
	push r1
	move r0,r1
	
	## r0 -- aHi
	## r1 -- aHi
	## r2 -- 
	## r3 -- 
	# Stack: aLo,aHi

	##calc aHi*aHi*256
	jsr mult8bit
	move r1,r3
	## r0 -- 
	## r1 -- 
	## r2 -- 
	## r3 -- resHi
	# Stack: aLo,aHi

	##calc aLo*aLo
	pop r0
	push r0
	move r0,r1
	jsr mult8bit
	move r1,r2
	## r0 -- 
	## r1 -- 
	## r2 -- resLow
	## r3 -- resHi
	# Stack: aLo,aHi


	##calc aHi*aLo*32
	pop r0
	pop r1
	## r0 -- aLo
	## r1 -- aHi

	jsr mult8bit
	ldi r0,0
	## r0 -- 0
	## r1 -- resMed
	## r2 -- resLow
	## r3 -- resHi
	
	
	##multiply by 32
	shla r1
	shl r0
	
	shla r1
	shl r0
		
	shla r1
	shl r0
		
	shla r1
	shl r0
			
	shla r1
	shl r0
	
	## r0 -- middleUpper
	## r1 -- middleLower
	## r2 -- resLow
	## r3 -- resHi

	##add together using 16 bits
	## R0: (r2+r1)
	## R1: C + (r3+r0)
	add r2,r1
	addc r0,r3
	move r1,r0
	move r3,r1
	

	pop r2
	pop r3
	rts

##in: 2x4 bit numbers in r0 and r1
#out: r0*r1 in r1
mult8bit:
	push r3
	push r2
	## r0 -- a
	## r1 -- b
	## r2 -- tmp
	## r3 -- 
	
	ldi r2,0
	loop1:
		if
			tst r1
		is z
			br loop1end
		fi
		
		add r0,r2
		dec r1
		br loop1
	loop1end:
	move r2,r1
	pop r2
	pop r3
	rts



inputs>
x:	dc 30	# replace 30 by your choice of x for testing
y:	dc 40	# replace 40 by your choice of y for testing
z:	dc 50	# replace 50 by your choice of z for testing
endinputs>
res:
xsq:	ds 2
ysq:	ds 2
zsq:	ds 2
pyth:	ds 1
        end

