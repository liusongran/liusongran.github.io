DSEG	SEGMENT
LLNT	DB	6
ETN		DW	60
LIST	DW	13,28,37,71,100,1011
		DW	128  DUP(0)
DSEG	ENDS

CSEG	SEGMENT
		ASSUME  CS:CSEG,DS:DSEG
		ASSUME  ES:DSEG
START:	MOV		AX,DSEG
		MOV		DS,AX
		MOV		ES,AX
		LEA		SI,LIST
		MOV		AL,LLNT
		MOV		CX,ETN
INST1:	CMP		CX,[SI]
		JZ		INST4
		JC		INST2
		ADD		SI,2
		DEC		AL
		JNZ		INST1
		MOV		[SI],CX
		JMP		INST3	
INST2:	MOV		DX,CX
		MOV		CL,AL
		MOV		BL,2
		MUL		BL
		ADD		SI,AX
		MOV		DI,SI
		SUB		SI,2
		XOR		CH,CH
		STD
		REP		MOVSW
		MOV		[SI+2],DX
INST3:	INC		LLNT
INST4:	MOV		AH,4CH
		INT		21H
CSEG	ENDS
		END		START