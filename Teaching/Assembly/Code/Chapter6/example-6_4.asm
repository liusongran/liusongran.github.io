;*****EXAM6.4*****
SSEG    SEGMENT	STACK
STK     DB      20  DUP(0)
SSEG    ENDS

DSEG    SEGMENT
ASC     DB      'AC'
DSEG    ENDS

CSEG    SEGMENT
        ASSUME	CS:CSEG, DS:DSEG
        ASSUME	SS:SSEG
START:  MOV	AX, DSEG
        MOV     DS, AX
        MOV     AX, SSEG
        MOV     SS, AX
        MOV     SP, SIZE STK
        MOV	AX, WORD PTR ASC;取两字符
        AND	AL, AL          ;置奇偶标志
        JPO     NEXT            ;奇转
        OR      AL, 80H         ;配为奇性  
NEXT:   AND	AH, AH          ;置奇偶标志
        JPO     LOAD            ;奇转      
        OR      AH,80H          ;配为奇性  
LOAD:   MOV	WORD PTR ASC, AX
        MOV	AH, 4CH
        INT	21H
CSEG	ENDS
END	START
