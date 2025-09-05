SSEG    SEGMENT     STACK
STK     DW 20 DUP(0)
SSEG    ENDS

DSEG    SEGMENT 
A       DB  01100110B
MEN     DB  00000000B
RU      DB  "Please input i: ",0DH,0AH,0DH,0AH,'$'
DSEG ENDS

CSEG SEGMENT
        ASSUME CS:CSEG,DS:DSEG,SS:SSEG
START:  MOV AX, DSEG
        MOV DS,  AX
        MOV AX, SSEG
        MOV SS, AX
        MOV BX, 0106H
        LEA CX, [BX]
        MOV AL, 9BH
        MOV BL, 0AH
        MOV CL, 03H
        NEG AL
        LEA DX, RU
        MOV AH, 09H
        INT 21H

        MOV AH, 01H
        INT 21H

        MOV CL,AL
        SUB CL,48  ;i现在就在bl中
    
        MOV AL, A
        MOV DL, 3
        SHL DL, CL

        NOT DL
        AND MEN,DL 
        NOT DL
        AND DL, AL
        OR MEN, DL
    
        MOV AL,MEN;方便调试时看MEN的值


        MOV AX,4C00H
        INT 21H
CSEG    ENDS
        END     START
