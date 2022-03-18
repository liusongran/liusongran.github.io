;*****EXAM6.3.2*****
SSEG    SEGMENT	STACK
STK     DB      20  DUP(0)
SSEG    ENDS

DSEG    SEGMENT
ADR     DW      73A5H,924BH
FLAG    DB      ?
DSEG    ENDS

CSEG    SEGMENT
        ASSUME	CS:CSEG, DS:DSEG
        ASSUME	SS:SSEG
START:  MOV	AX, DSEG
        MOV     DS, AX
        MOV     AX, SSEG
        MOV     SS, AX
        MOV     SP, SIZE STK
        MOV	AX, ADR
        XOR     AX, ADR+2       ;两数异或
        MOV     AL, 0           ;同号标志
        JNS     LOAD            ;同号
        DEC     AL              ;异号标志
LOAD:	MOV	FLAG, AL    	;存标志
        MOV	AH,4CH
        INT	21H
CSEG	ENDS
END	START
