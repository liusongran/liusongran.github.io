;*****EXAM6.1*****
SSEG    SEGMENT STACK
STK     DB      50DUP(0)
SSEG    ENDS

DSEG    SEGMENT
ARGX	DB      -5
RLT     DB      ?
DSEG    ENDS

CSEG    SEGMENT
        ASSUME  CS:CSEG, DS:DSEG
        ASSUME	SS:SSEG
BEGIN:	MOV     AX, DSEG
        MOV     DS, AX
        MOV     AX, SSEG
        MOV	SS, AX
        MOV     SP, SIZE STK
        MOV     AL, ARGX        ;取X
        AND	AL, AL	        ;置标志位
        JS      ABSL            ;X<0转
        JZ      MOVE	        ;X=0转
        CMP     AL, 8	        ;X≤8?
        JLE     ONE	        ;是,转
        CMP     AL, 15	        ;X≥15?
        JGE     MOVE	        ;是,转
        SAL     AL, 1	        ;计算5X-2
        SAL     AL, 1
        ADD     AL, ARGX
        SUB     AL, 2
        JMP     MOVE
ONE:	ADD     AL, 10	        ;X≤8,计算X+10
        JMP     MOVE
ABSL:	NEG     AL	        ;取补
MOVE:   MOV     RLT, AL	        ;保存结果
        MOV     AH, 4CH
        INT	21H
CSEG	ENDS
END	BEGIN
