;*****EXAM5.0*****
;Test 8086 instructions  
SSEG		SEGMENT	 STACK       	;堆栈段
STK          	DB      20 DUP(0)
SSEG        	ENDS

DSEG       	SEGMENT                 ;数据段
DATA1     	DB      35H,26H,03H  	;(032635H)
DATA2     	DB      3  DUP(0)
DSEG       	ENDS

CSEG       	SEGMENT                 ;代码段                   
                ASSUME  CS:CSEG, DS:DSEG
                ASSUME  SS:SSEG
MBNEG: 	        MOV     AX, DSEG   	;段寄存器初值
                MOV     DS, AX
                MOV     AX, SSEG
                MOV     SS, AX
                MOV     SP, SIZE STK  	;设置堆栈指

                ;srliu:mov data to SREG 
                MOV     DS, AX          ;SREG <- REG
                ;MOV     ES, DS          ;SREG <- SREG NOTE:invalid!
                ;MOV     DS, 10H         ;SREG <- idata NOTE:invalid!
                ;MOV     ES, [0]         ;SREG <- memory NOTE: invalid!
                MOV     ES, DS:[0]      ;SREG <- memory
                
                ;LEA     AX, DATA1

                ;srliu:mov data to memory
                MOV     AL, 35H
                MOV     DATA2, AL       ;memory <- REG
                MOV     DATA2, 35H      ;memory <- idata
                ;MOV     DS:[0000H], 35H    ;memory <- idata NOTE:invalid!
                ;MOV     [0035H], 35H
                MOV     [BX+10H], AL
                ;MOV     [BX], 35H
                MOV     WORD PTR DS:[BX+SI], 35H
                ;MOV     DATA2, DS       ;memory <- SREG
                ;MOV     DATA2, DATA1    ;memory <- memory NOTE: invalid
                

                ;srliu: XCHG test
                ;XCHG    AX, 3435H       ;idata NOTE: invalid
                ;XCHG    AX, BX
                ;XCHG    DS, ES          ;SREG NOTE: invalid
                ;XCHG    DS, AX          
                ;XCHG    [BX], [BX+10]   ;memory NOTE: invalid
                XCHG    AX, SI
                ;XCHG    AL, SI           ;memory NOTE: warning
                
                MOV	AL, DATA1     	;读入数据低字节   
                MOV	AH, DATA1+1   	;读入数据中字节
                MOV	BL, DATA1+2   	;读入数据高字节 
                NEG	AL           	;取补低字节
                CMC			;进位取反
                NOT	AH           	;中字节取反
                ADC	AH, 0         	;加进位
                NOT	BL           	;高字节取反
                ADC	BL, 0         	;加进位     
                MOV	DATA2, AL     	;保存结果   
                MOV	DATA2+1, AH
                MOV	DATA2+2, BL
                MOV	AX, 4C00H
                INT	21H
                
CSEG	        ENDS
                END	MBNEG
