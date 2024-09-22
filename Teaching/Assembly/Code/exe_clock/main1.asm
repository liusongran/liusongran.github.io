SSEG	SEGMENT		STACK
STKTOP	DB		100 DUP(0)
SSEG	ENDS

CODE   SEGMENT             ;代码段.
    ASSUME   CS: CODE, DS: CODE
    ORG  0100H
START:
    JMP  MAIN
;----------------------------------------------
NEW_08H_SERVICE  PROC      ;每隔55ms执行一次.
    PUSH DS                ;保护现场.
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
;--------------------------
    MOV  AX, CODE          ;重新给DS段赋值.
    MOV  DS, AX
;--------------------------
    MOV  AH, 2
    INT  1AH               ;读出系统时间.
    CMP  DH, SEC
    JZ   E_NEW_08
    MOV  HOUR, CH
    MOV  MIN,  CL
    MOV  SEC,  DH
;--------------------------
    MOV  AH, 3             ;取出当前光标位置.
    MOV  BL, 0
    INT  10H
    PUSH DX
;--------------------------
    MOV  CURSOR, 0047H     ;第0行、71列.
    CALL SET_CURSOR
    MOV  AL, HOUR
    CALL W_2_CHAR
    MOV  AL, ':' - 30H
    CALL W_1_CHAR
    MOV  AL, MIN
    CALL W_2_CHAR
    MOV  AL, ':' - 30H
    CALL W_1_CHAR
    MOV  AL, SEC
    CALL W_2_CHAR
;--------------------------
    MOV  AH, 2             ;恢复光标位置.
    POP  DX
    INT  10H
;--------------------------
E_NEW_08:
    POP  DX                ;恢复现场.
    POP  CX
    POP  BX
    POP  AX
    POP  DS
    JMP  CS: OLD08         ;转去执行原来的中断服务程序.
;--------------------------;下面是代码段中的变量区
    CURSOR   DW  ?
    SEC      DB  ?
    MIN      DB  ?
    HOUR     DB  ?
    OLD08    DD  ?         ;用于存放原来的08H中断向量.
NEW_08H_SERVICE  ENDP
;----------------------------------------------
SET_CURSOR  PROC           ;设定光标位置.
    MOV  DX, CURSOR
    INC  DX
    MOV  CURSOR, DX
    MOV  AH, 2
    INT  10H
    RET
SET_CURSOR  ENDP
;----------------------------------------------
W_2_CHAR  PROC
    PUSH AX
    MOV  CL, 4
    SHR  AL, CL
    AND  AL, 0FH
    CALL W_1_CHAR
    POP  AX
    AND  AL, 0FH
    CALL W_1_CHAR
    RET
W_2_CHAR  ENDP
;----------------------------------------------
W_1_CHAR  PROC             ;显示1个字符.
    MOV  AH, 9 
    ADD  AL, 30H           ;AL中的数字，变成ASCII
;    MOV  BL, 1EH           ;蓝色背景、黄色字符.
    MOV  BL, 2FH           ;绿色背景、白色字符.
    MOV  CX, 1             ;显示一个字符.
    INT  10H
    CALL SET_CURSOR        ;显示后，移动一次光标
    RET
W_1_CHAR  ENDP
;===============以上内容驻留内存，每隔55ms执行一次
MAIN:
    MOV  AX, CODE
    MOV  DS, AX
    CLI                    ;关中断
    MOV  AX, 3508H         ;读出原来的08H中断向量到OLD08
    INT  21H
    MOV  WORD PTR OLD08, BX 
    MOV  WORD PTR OLD08 + 2, ES
;--------------
    MOV  AX, 2508H         ;把NEW_08H_SERVICE写人中断向量表.
    MOV  DX, OFFSET NEW_08H_SERVICE
    INT  21H
    STI                    ;开中断.
    MOV  DX, OFFSET MAIN   ;设置驻留程序的末尾位置
    INT  27H               ;驻留并退出
;----------------------------------------------
CODE  ENDS
    END  START 