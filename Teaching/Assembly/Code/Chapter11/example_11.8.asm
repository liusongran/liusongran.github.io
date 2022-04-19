DSEG	SEGMENT
LIST	DB		3,7,17,27,37,47,57,67,77,97
LLNT	DW		10
ADR		DW		0
KEY		DB		57
DSEG	ENDS
CSEG	SEGMENT
		ASSUME  CS:CSEG,DS:DSEG
START:	MOV		AX,DSEG
		MOV		DS,AX
		MOV		AL,KEY	
		LEA		SI,LIST 
		MOV		DI,SI
		CMP		AL,[SI]
		JZ		SUCC
		JC		FAIL
		ADD		DI,LLNT
		DEC		DI
		CMP		AL,[DI]
		JZ		SUCC
		JNC		FAIL
BIN1:	MOV		DX,DI
		SUB		DI,SI
		SHR		DI,1
		JZ		FAIL
BIN2:	ADD		DI,SI
		CMP		AL,[DI]
		JZ		SUCC
		JC		BIN1
		MOV		SI,DI
		MOV		DI,DX
		JMP		BIN1
FAIL:	MOV		DI,0FFFFH
SUCC:	MOV		ADR,DI
		MOV		AH,4CH
		INT		21H
CSEG	ENDS
		END		START
