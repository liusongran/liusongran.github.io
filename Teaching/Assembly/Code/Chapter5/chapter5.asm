SSEG    SEGMENT	 STACK       	    ;堆栈段
STK     DB      20 DUP(0)
SSEG    ENDS

DSEG    SEGMENT                     ;数据段
DATA1   DB      35H,26H,03H  	    ;(032635H)
DATA2   DB      3 DUP(0)
DSEG    ENDS

CSEG    SEGMENT                 ;代码段                   
        ASSUME  CS:CSEG, DS:DSEG
        ASSUME  SS:SSEG
START:  MOV     AX, DSEG   	    ;段寄存器初值
        MOV     DS, AX
        MOV     AX, SSEG
        MOV     SS, AX
        MOV     CX, 0
        REP     MOVSB
        MOV     SP, SIZE STK    ;设置堆栈指
        MOV	    AX, OFFSET DATA1    
        LDS     BX, AX


JMTAB   DB      ’YZDMRNHXJLIOQ’
        DB      ’UWACBEGFKPTSV’
        MOV     AX,SEG JMTAB
        MOV     DS,AX
        MOV     BX,OFFSET JMTAB
        MOV     AL,’T’
        SUB     AL,’A’
        XLAT



        MOV     AX, WORD PTR DATA1
        
        MOV     WORD PTR DATA2, AX

;*****EXAM 5.5.1*****
SSEG    SEGMENT	STACK
STK	    DB		20 DUP (0)
SSEG    ENDS

DSEG    SEGMENT
HATAB   DB		30H,31H,32H,33H,34H
        DB		35H,36H,37H,38H,39H
        DB		41H,42H,43H,44H,45H,46H
HEX	    DB		0CH
DSEG    ENDS

CSEG    SEGMENT
        ASSUME	CS:CSEG,DS:DSEG
        ASSUME	ES:DSEG,SS:SSEG
HTOA:   MOV		AX, DSEG
        MOV		DS, AX
        MOV		AX, SSEG
        MOV		SS, AX
        MOV		SP, SIZE STK
        MOV	    AL, HEX
        LEA	    BX, HATAB
        XLAT
        MOV	    DL, AL
        MOV	    AH, 02
        INT		21H
        MOV	    AX, 4C00H
        INT		21H
CSEG    ENDS
        END	    HTOA



;*****EXAM 5.4*****    
SSEG    SEGMENT STACK
STK	    DB	    20  DUP(0)
SSEG    ENDS

DSEG    SEGMENT
ARGX    DB	    15
RLTY    DW		0
DSEG    ENDS

CSEG    SEGMENT
        ASSUME	CS:CSEG,DS:DSEG
        ASSUME	SS:SSEG
CALCU:  MOV		AX,DSEG
        MOV		DS,AX
        MOV		AX,SSEG
        MOV		SS,AX
        MOV		SP,LENGTH STK
        MOV	    AL,ARGX     ;取原始数
        MOV	    BL,05
        MUL	    BL     	    ;计算5x  
        MOV	    BX,08
        ADD	    AX,BX  	    ;再加上8
        MOV	    RLTY,AX     ;保存结果
        MOV	    AX,4C00H
        INT	    21H
CSEG    ENDS
        END	CALCU


;*****EXAM 5.3*****    
SSEG    SEGMENT STACK
STK	    DB	    20 DUP(0)
SSEG    ENDS

DSEG    SEGMENT
HEX	    DB	    0AH,06H
DATA	DB	    0
DSEG    ENDS

CSEG    SEGMENT
        ASSUME  CS:CSEG,DS:DESG
        ASSUME  SS:SSEG
PACK:   MOV	    AX,DSEG
        MOV	    DS,AX
        MOV	    AX,SSEG
        MOV	    SS,AX
        MOV	    SP,SIZE STK
        MOV	    AL,HEX      ;取数据高序位
        MOV	    CL,04
        SHL	    AL,CL	    ;左移4位
        OR	    AL,HEX+1    ;与低4位或
        MOV	    DATA,AL     ;保存结果
        MOV	    AX,4C00H
        INT	    21H
CSEG    ENDS
        END	        PACK



;*****EXAM 5.2*****    
SSEG    SEGMENT STACK
STK	    DB      20 DUP(0)
SSEG	ENDS

DSEG	SEGMENT
DATA	DB	    0B5H
HEX	    DB	    0,0
DSEG	ENDS

CSEG	SEGMENT
        ASSUME  CS:CSEG,DS:DSEG
        ASSUME  SS:SSEG
DISC:   MOV	    AX, DSEG
        MOV	    DS, AX
        MOV	    AX, SSEG
        MOV	    SS, AX
        MOV	    SP, LENGTH STK
        MOV	    AL, DATA        ;取数据
        MOV	    AH, AL          ;保存副本 
        AND	    AL, 0F0H        ;截取高4位
        MOV	    CL, 04        
        SHR	    AL, CL          ;移至低4位
        MOV	    HEX, AL
        AND	    AH, 0FH         ;截取低4位
        MOV	    HEX+1, AH
        MOV	    AX, 4C00H
        INT	    21H
CSEG    ENDS
        END	 DISC



;*****EXAM 5.1.1*****    
SSEG    SEGMENT	 STACK       	    ;堆栈段
STK     DB      20 DUP(0)
SSEG    ENDS

DSEG    SEGMENT                     ;数据段
DATA1   DB      35H,26H,03H  	    ;(032635H)
DATA2   DB      3 DUP(0)
DSEG    ENDS

CSEG    SEGMENT                 ;代码段                   
        ASSUME  CS:CSEG, DS:DSEG
        ASSUME  SS:SSEG
MBNEG:  MOV     AX,DSEG   	    ;段寄存器初值
        MOV     DS,AX
        MOV     AX,SSEG
        MOV     SS,AX
        MOV     SP,SIZE STK     ;设置堆栈指
        MOV	    AL,DATA1     	;读入数据低字节   
        MOV	    AH,DATA1+1   	;读入数据中字节
        MOV	    BL,DATA1+2   	;读入数据高字节 
        NEG	    AL           	;取补低字节
        CMC			            ;进位取反
        NOT	    AH           	;中字节取反
        ADC	    AH,0         	;加进位
        NOT	    BL           	;高字节取反
        ADC	    BL,0         	;加进位     
        MOV	    DATA2,AL     	;保存结果   
        MOV	    DATA2+1,AH
        MOV	    DATA2+2,BL
        MOV	    AX,4C00H
        INT	    21H
CSEG	ENDS
        END	MBNEG







MOV     DL, ”A”
MOV     AH, 02H
INT     21H


DIV     BL
DIV     WORD PTR [BX+DI+1000H]
MOV     AX, 1000H
MOV     CL, 08H
DIV     CL


MUL     BL
MUL     DX
MUL     BYTE PTR [SI+BX+1000H]


ADD     AL, 3               
ADD     GAMA[BP][DI], BL
ADD     [BP+DI+OFFSET GAMA], BL
ADD     CX, MEM_W

DEC     BX
DEC     BYTE PTR [BX+SI+1000H]
DEC     SP


INC     AL
INC     DATA1        
INC     BX
INC     [BX]
INC     WORD PTR[BX]



DATA1   DB      10H
        LEA     BX, DATA1
        MOV     BX, OFFSET DATA1
        MOV     BX, 1000H
        MOV     DI, 2000H
        LEA     AX, [BX+1243H]
        LEA     DX, [BX+SI+1234H]


JMTAB   DB      ’YZDMRNHXJLIOQ’
        DB      ’UWACBEGFKPTSV’

        MOV     AX, SEG JMTAB
        MOV     DS, AX
        MOV     BX, OFFSET JMTAB
        MOV     AL, ’T’
        SUB     AL, ’A’
        MOV     AH, 0
        ADD     BX, AX
        MOV     AL, [BX]

JMTAB
XCHG    AL, BL
XCHG    CL, [BX]
XCHG    BL, [BX+SI+10]
XCHG    AX, AX
XCHG    AL, SI
XCHG    [SI], [BX+10]
XCHG    DX, DS
XCHG    AL, 10


MOV     ALPHA_W, AX
MOV     BETA_B, AL
MOV     AL, ES:[BX+SI+1000H]
MOV     BX, 1000H
MOV     DS, BX
MOV     [BX+10], AL
MOV     BYTE PTR [BX], 10H
MOV     WORD PTR [BX], 10H


MOV     ALPHA_W, AX             ; ALPHA_W <- AL, ALPHA_W <- AH
MOV     BETA_B, AL
MOV     AL, ES:[BX+SI+1000H]
MOV     BX, 1000H
MOV     DS, BX
MOV     [BX+10], AL
MOV     [BX], 10H
MOV     DS, 10H
MOV     CS, AX

