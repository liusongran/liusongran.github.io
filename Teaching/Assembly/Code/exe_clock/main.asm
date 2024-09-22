SSEG	SEGMENT		STACK
STKTOP	DB		100 DUP(0)
SSEG	ENDS

CODE   SEGMENT            
    ASSUME   CS: CODE, DS: CODE;伪指令
    ORG  0100H;
START:;
    JMP  MAIN;跳转到MAIN

NEW_08H_SERVICE  PROC     
    PUSH DS
    PUSH AX                
    PUSH BX
    PUSH CX
    PUSH DX;保存现场

    MOV  AX, CODE          
    MOV  DS, AX;给DS赋初值 值为CODE代码段的值

    MOV  AH, 2
    INT  1AH              

    LEA SI,HOUR
    MOV CH,CH
    CALL TRANS
    
    LEA SI,MIN
    MOV CH,CL
    CALL TRANS
    
    LEA SI,SEC
    MOV CH,DH
    CALL TRANS


    MOV AH,03H
    MOV BH,00
    INT 10H 
    PUSH DX 

    CALL PLACE             
    MOV AH,9                
    MOV DX,OFFSET HOUR

    INT 21H
    MOV DX,OFFSET MIN  
    INT 21H 
    MOV DX,OFFSET SEC 
    INT 21H 
    

    MOV       AH,2            
    MOV       DX,1800H
    POP DX 
    MOV       BH,0			
    INT  10H

    POP  DX               
    POP  CX
    POP  BX
    POP  AX
    POP  DS
    JMP  CS: OLD08        

    CURSOR   DW  ?
    such     db   5 dup(0)
    SEC      DB  '00$'
    MIN      DB  '00:$'
    HOUR     DB  '00:$'
    OLD08    DD  ?         
NEW_08H_SERVICE  ENDP



TRANS PROC NEAR
    PUSH CX 
    PUSH DX 
    PUSH BX 

    MOV BH,CH
    AND BH,11110000B
    MOV CL,4
    SHR BH,CL
    ADD BH,30H
    MOV BYTE PTR [SI],BH 
    XOR BH,BH  

    MOV BH,CH
    AND BH,00001111B
    ADD BH,30H
    MOV BYTE PTR [SI+1],BH

    POP BX
    POP DX
    POP CX
    RET 
TRANS ENDP   

PLACE PROC NEAR
    MOV       AH,2		   
    MOV       DH,24
    MOV       DL,50			
    MOV       BH,0			
    INT       10H
    RET 
PLACE ENDP

MAIN:
    MOV  AX, CODE
    MOV  DS, AX
    CLI  
    MOV  AX, 3508H
    INT  21H
    MOV  WORD PTR OLD08, BX
    MOV  WORD PTR OLD08 + 2, ES
    MOV  AX, 2508H
    MOV  DX, OFFSET NEW_08H_SERVICE
    INT  21H
    CLI 
    ;STI
    MOV  DX, OFFSET MAIN   
    INT  27H       
CODE  ENDS
    END  START
