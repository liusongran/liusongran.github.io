DSEG	SEGMENT
STR1	DB	'I  am  a  student',00H
STR2	DB	'I  AM  A  STUDENT',00H
FLAG	DB	?
DSEG	ENDS
CSEG	SEGMENT
		ASSUME  CS:CSEG, DS:DSEG
BSTR:	MOV		AX, DSEG
		MOV		DS, AX
		LEA		SI, STR1
		LEA		BX, STR2
		MOV		FLAG, 0
		MOV		CL, 0
LOP:	XOR		AX, AX
		CMP		[SI], AL
		JZ		DONE1
		MOV		AH, 1
DONE1:	CMP		[BX], CL
		JZ		DONE2
		MOV		AL, 1
DONE2:	OR		AH, AL
		JZ		DONE
		MOV		CH, [SI]
		CMP		CH, [BX]
		JNZ		DONE3
		INC		BX
		INC		SI
		JMP		LOP
DONE3:	JA		DONE4
		DEC		FLAG
		JMP		DONE
DONE4:	INC		FLAG
DONE:	MOV		AH, 4CH
		INT		21H
CSEG	ENDS
		END		BSTR
