;*****EXAM7.1*****
DSEG    SEGMENT
DATA	DB	-1,3,-5,....
COUNT	DW	50
RLT	DW	0
DSEG	ENDS

CSEG	SEGMENT
        ASSUME CS:CSEG, DS:DSEG
START:  MOV	AX, DSEG
	MOV	DS, AX
	MOV	BX, OFFSET DATA	
	MOV	CX, COUNT	
	MOV	DX, 0		
AG1:	MOV	AL,[BX]
	AND	AL, AL
	JNS	PLUS
	INC	DX
PLUS:	INC	BX
	DEC	CX
	JNZ	AG1
	MOV	RLT, DX
	MOV	AH, 4CH
	INT	21H
CSEG	ENDS
END	START
