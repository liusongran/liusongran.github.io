DSEG	SEGMENT
LIST	DW		35,26,7,165,47,396,47,8,105
LLNT	DW		8
AGE		DW		47
ADR		DW		?
DSEG	ENDS
CSEG	SEGMENT
		ASSUME	CS:CSEG,DS:DSEG
START:	MOV		AX,DSEG
		MOV		DS,AX
		LEA		DI,LIST		
		MOV		CX,LLNT 	
		MOV		AX,AGE
SEQ2:	CMP		AX,[DI]
		JZ		SEQ1
		ADD		DI,2
		LOOP	SEQ2
		OR		DI,0FFFFH
SEQ1:	MOV		ADR,DI
		MOV		AH,4CH
		INT		21H
CSEG	ENDS
		END		START