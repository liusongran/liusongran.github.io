;;
SSEG	SEGMENT STACK
STACK	DB     	50 DUP(0)
SSEG	ENDS

DSEG	SEGMENT
DATA	DW	1524, 2748, 13, 56, 47, 634
CNT     DW  6
AE      DW  6 DUP(0)
DSEG	ENDS

CSEG    SEGMENT
        ASSUME DS:DSEG, CS:CSEG
        ASSUME SS:SSEG
START:
        MOV     AX, DSEG
        MOV     DS, AX
        MOV     AX, SSEG
        MOV     SS, AX
        MOV     SP, SIZE STACK
        MOV     SI, OFFSET DATA
        ;MOV     AL, 02H
        ;TEST    AL, 01H
        ;JE      AGAIN
        ;MOV     AL, 34H
        ;MOV     BL, 80H
        ;SUB     AL, BL
        ;MOV     AH, 34H
        ;MOV     BH, 80H
        ;NEG     BH
        ;ADD     AH, BH
        MOV     CX, 0
        REP     MOVSB
        ;MOV     CX, [AGAIN]
        MOV     CX, AGAIN
        JMP     CX
        MOV     CX, OFFSET AGAIN
        LEA     DX, AGAIN
        JMP     CX
        XOR     AX, AX
        XOR     DX, DX
AGAIN:  ADD     AX, [SI]
        ADC     DX, 0
        ADD     SI, 2
        DEC     CL
        JNZ     AGAIN
        POP     CX
        DIV     CX
        XOR     BP, BP
PER:
        SUB     SI, 2
        CMP     AX, [SI]
        JNB     NEXT
        MOV     DX, [SI]
        MOV     DS:AE[BP], DX
        ADD     BP, 2
NEXT:
        DEC     CX
        JNZ     PER
        MOV     AH,4CH
        INT     21H
CSEG    ENDS
        END    START
