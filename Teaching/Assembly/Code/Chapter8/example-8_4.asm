;*****EXAM8.3*****
HTOA	PROC	NEAR
		AND   	AL, 0FH
		CMP   	AL, 10
		JC    	HTOA1
		ADD   	AL, 07
HTOA1:	ADD   	AL, 30H
		RET
HTOA  	ENDP


BHTOA	PROC
		PUSH	CX
		MOV		CH, AL
		MOV  	CL, 04
		SHR  	AL, CL
		CALL 	HTOA
		MOV  	AH, AL
		MOV  	AL, CH
		CALL  	HTOA
		POP  	CX
		RET
BHTOA	ENDP

DSEG	SEGMENT
DATA	DB		4CH
DSEG	ENDS

CSEG	SEGMENT
		ASSUME	CS:CSEG, DS:DSEG
START:	MOV		AX,DSEG
		MOV		DS, AX
		MOV		AL, DATA
		CALL	BHTOA
		PUSH	AX
		MOV		DL, AH
		MOV		AH, 2
		INT		21H
		POP		DX
		INT		21H
		MOV		AX, 4C00H
		INT		21H
CSEG	ENDS
END		START
