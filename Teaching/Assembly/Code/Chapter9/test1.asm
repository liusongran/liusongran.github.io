
BLMOV   MACRO   SRC, DST, CNT   ;宏定义
        LEA     SI, SRC
        LEA     DI, DST 
        MOV     CX, CNT 
        CLD 
        REP     MOVSB
        ENDM                    ;宏结束

CLEAR   MACRO   DIR, DST, CNT
        DIR
        LEA     DI, DST 
        MOV     CX, CNT
        XOR     AL, AL 
        REP     STOSB 
        ENDM 

RLS     MACRO   DIR, REG, CNT 
        MOV     CL, CNT
        RO&DIR  REG, CL 
        ENDM 

;定义两个多精度数据求和的宏指令
MADD1   MACRO   LAB, SRC, DST, LEN, SUN
        LEA     SI, SRC 
        LEA     DI, DST 
        MOV     DX, LEN
        LEA     BX, SUN 
        CLC 
LAB:    MOV     AL, [SI]
        ADC     AL, [DI]
        MOV     [BX], AL
        INC     SI 
        INC     DI 
        INC     BX 
        LOOP    LAB 
        ENDM 

;定义求三个寄存器中最小数的宏指令
FMIN    MACRO   REG1, REG2, REG3
        LOCAL   NEXT1, NEXT2
        CMP     REG1, REG2
        JNA     NEXT1
        MOV     REG1, REG2
NEXT1:  CMP     REG1, REG3
        JNA     NEXT2
        MOV     REG1, REG3 
NEXT2:  NOP 
        ENDM

BHTOA2: MACRO 
        PUSH    CX
        MOV     CH, AL
        MOV     CL, 04
        SHR     AL, CL
        HTOA            ;宏调用
        MOV     AH, AL
        MOV     AL, CH 
        AND     AL, 0FH
        HTOA            ;宏调用
        POP     CX 
        ENDM 
HTOA    MACRO 
        LOCAL   HTOA1
        AND     AL, 0FH 
        CMP     AL, 10
        JC      HTOA1 
        ADD     AL, 07
HTOA1:  ADD     AL, 20H 
        ENDM

;宏调用
        ...
        MOV     AL, 05
        HTOA 
        ... 
        MOV     AL, 47H 
        BHTOA2
        ... 

