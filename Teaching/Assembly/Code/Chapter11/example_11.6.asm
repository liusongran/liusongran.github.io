DSEG	SEGMENT
LIST	DB		25,57,48,37,14
LLNT	DB		5
DSEG	ENDS
SSEG	SEGMENT   STACK
STK		DB		20  DUP  (0)
SSEG	ENDS

CSEG	SEGMENT
		ASSUME	CS:CSEG
		ASSUME	DS:DSEG
		ASSUME	SS:SSEG
START:	MOV		AX,DSEG
		MOV		DS,AX
		MOV		AX,SSEG
		MOV		SS,AX
		MOV		SP,SIZE  STK
		LEA		SI,LIST
		MOV		DI,SI
		INC		DI
		MOV		BL,LLNT
		DEC		BL
		XOR		CL,CL
INSRT1:	INC		CL
		PUSH	CX
		PUSH	SI
		PUSH	DI
INSRT2:	MOV		AL,[DI]
		CMP		AL,[SI]
		JAE		NEXT
		MOV		AH,[SI]
		MOV		[DI],AH
		MOV		[SI],AL	
		DEC		SI
		DEC		DI
		DEC		CL
		JNZ		INSRT2
NEXT:	POP    	DI
		POP    	SI
		POP    	CX
		INC 	SI
		INC 	DI
		DEC    	BL
		JNZ 	INSRT1
		MOV   	AH,4CH
		INT  	21H
CSEG	ENDS
		END 	START
