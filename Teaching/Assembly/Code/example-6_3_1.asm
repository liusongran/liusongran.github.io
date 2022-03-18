;*****EXAM6.3.1*****
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
        AND	AX, AX          ;置标志
        JNS	PLUS	        ;正转
        MOV	AX, ADR+2
        AND	AX, AX	        ;第2个数置标志
        JS	SAME	        ;同为负
USAM:   MOV	AL, 0FFH        ;异号标志
        JMP	LOAD
PLUS:   TEST	ADR+2, 8000H    ;第2个数置标志
        JS	USAM            ;异号
SAME:   XOR	AL, AL          ;同号标志
LOAD:   MOV	FLAG, AL        ;存标志
        MOV	AH, 4CH
        INT	21H
CSEG ENDS
END	START
