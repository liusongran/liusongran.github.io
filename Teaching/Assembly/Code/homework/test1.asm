DATA SEGMENT
TIRM DW  8
    DW  ?
    DW  8   DUP(0)

BIG DW ?

DATA   ENDS

SSEG   SEGMENT   STACK 
       DW     640     DUP(0)
SSEG   ENDS
;bx cx dx
CSEG   SEGMENT
       ASSUME SS:SSEG,CS:CSEG,DS:DATA
FF     PROC   NEAR 

       CMP CX,1
       JE EXIT1
       CMP CX,2
       JE EXIT1

       PUSH AX
       PUSH BX
       ;PUSH DX
       MOV BX,CX
       SUB CX,1
       CALL FF
       ;MOV BX,CX
       
       MOV CX,BX
       SUB CX,2
       CALL FF
       ;MOV AX,CX

       ;MOV CX,BX 
       ;ADD CX,AX  

       ;POP DX
       POP BX 
       POP AX
       RET

EXIT1: 
       JMP EXIT 

EXIT:
       ADD DX,1
       RET

FF     ENDP

BEGIN PROC NEAR

       INC CX
       PUSH CX
       XOR DX,DX
       XOR AX,AX
       XOR BX,BX 
       CALL FF
       POP CX
       CMP DX,0064H
       JB BEGIN 
       CMP DX,01F4H
       JA EXIT2 
       MOV TIRM[SI],DX
       ADD SI,2
       CALL BEGIN
       JMP EXIT2
EXIT2:
       RET
BEGIN ENDP
START:
       MOV AX,SSEG
       MOV SS,AX
       MOV SP,640
       MOV AX,DATA
       MOV DS,AX
       XOR CX,CX 
       XOR BX,BX
       XOR AX,AX
       XOR DX,DX 
       MOV SI,0
       ;MOV CX,5
       ;CALL FF
       CALL BEGIN
       MOV AX,4C00H
       INT 21H
CSEG   ENDS
END    START  
