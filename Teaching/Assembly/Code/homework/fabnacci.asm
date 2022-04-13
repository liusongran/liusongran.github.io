DSEG    SEGMENT
ITER    DW  10
FABNS   DW  20  DUP(0)
TIRM    DW  5   DUP(0)
DSEG    ENDS
SSEG    SEGMENT STACK 
STKTOP  DW      100     DUP(0)
SSEG    ENDS

CSEG    SEGMENT
        ASSUME  SS:SSEG, CS:CSEG, DS:DSEG
;NOTE:  - input: CX <-- N
;       - output: FABNS, Fabnacci series
FAB     PROC    NEAR 
        CMP     CX, 1
        JNA     FABS0_1
        DEC     CX
        CALL    FAB
        JMP     EXITX

FABS0_1:XOR     DX, DX
        XOR     DI, DI
        MOV     WORD PTR FABNS[DI+2], 1
        MOV     WORD PTR FABNS[DI], 0
        ADD     DI, 4
        RET
EXITX:  MOV     CX, FABNS[DI-2]
        ADD     CX, FABNS[DI-4]
        MOV     FABNS[DI], CX
        INC     DI
        INC     DI
        RET
FAB     ENDP

START:
        MOV     AX, SSEG
        MOV     SS, AX
        MOV     SP, SIZE STKTOP
        MOV     AX, DSEG
        MOV     DS, AX
        ; generate Fabnacci series
        XOR     CX, CX
        MOV     CX, ITER
        CALL    FAB
        ;TODO: add code to find the number in interval [100, 500]
        INT     3
        MOV     AX,4C00H
        INT     21H
CSEG    ENDS
        END     START  
