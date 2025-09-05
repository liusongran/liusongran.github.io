DATA    SEGMENT
MSEG1   DB  'Calculate X^n with Recursion Programming.$'
MSEG2   DB  'Input X: $'
MSEG3   DB  'Input n: $'
DATA    ENDS

SSEG    SEGMENT STACK
STKTOP  DW      64  DUP(0)
SSEG    ENDS

CSEG    SEGMENT 
        ASSUME SS:SSEG, CS:CSEG, DS:DATA

;Sub-function: PRINTF
PRINTF  PROC    NEAR
        MOV     AH, 09H
        INT     21h
        MOV     DX, 0AH
        MOV     AH, 02H
        INT     21H
        RET 
PRINTF  ENDP
;Sub-function: X^n
;Input: BL --> X, BH --> n
;Output: AX
POWER   PROC    NEAR 
        AND     BH, BH
        JZ      EXIT0
        DEC     BH
        CALL    POWER
        MUL     BL
        RET
EXIT0:  MOV     AL, 1
        RET
POWER   ENDP


;Entry of MAIN
MAIN:   MOV     AX, DATA              
        MOV     DS, AX    
        MOV     AX, SSEG
        MOV     SS, AX
        MOV     SP, SIZE STKTOP
        MOV     AX, CS
        MOV     CS, AX
        LEA     DX, MSEG1
        CALL    PRINTF
        LEA     DX, MSEG2
        CALL    PRINTF
        MOV     AH, 01H
        INT     21H
        MOV     BL, AL      ;X in BL
        SUB     BL, '0'
        MOV     DX, 0AH
        MOV     AH, 02H
        INT     21H
        LEA     DX, MSEG3
        CALL    PRINTF 
        MOV     AH, 01H
        INT     21H
        MOV     BH, AL      ;n in BH
        SUB     BH, '0'

        CALL    POWER
        INT     3

        MOV     AX, 4C00H
        INT     21H
CSEG    ENDS
        END     MAIN