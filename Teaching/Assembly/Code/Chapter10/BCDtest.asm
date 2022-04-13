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

START:  MOV     AX, SSEG
        MOV     SS, AX
        MOV     SP, SIZE STKTOP
        MOV     AX, DSEG
        MOV     DS, AX
        MOV     AX, 62
        MOV     CL, 5
        DIV     CL
        INT     3
        ; - 组合BCD码的调整指令
        XOR     AX, AX
        MOV     AL, 45H
        ADD     AL, 47H
        DAA                 ;十进制加法调整
        XOR     AX, AX
        MOV     AL, 45H
        SUB     AL, 17H
        DAS                 ;十进制减法调整
        ; - 非组合BCD码的调整指令
        XOR     AX, AX
        MOV     AL, 05H
        ADD     AL, 07H
        AAA                 ;十进制加法调整
        XOR     AX, AX
        MOV     AL, 15H
        SUB     AL, 07
        AAS                 ;十进制减法调整
        ; - 非组合BCD码的调整指令
        MOV     AX, 0905H
        MUL     AH
        AAM
        
        XOR     AX, AX
        MOV     AX, 0405H
        MOV     BL, 08H
        AAD 
        DIV     BL

        MOV     AX,4C00H
        INT     21H
CSEG    ENDS
        END     START  
