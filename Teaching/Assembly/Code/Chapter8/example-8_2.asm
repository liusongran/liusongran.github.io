;*****EXAM8.2*****
SSEG	SEGMENT	STACK
STKTOP	DB		40 DUP(0)
SSEG	ENDS

DSEG	SEGMENT
LIST1	DW    	35, 27, 165, 3, 1825, 603
CNT1 	DW    	6
LIST2	DW    	438, 121, 496, 6321, 28, 17, 2, 105
CNT2 	DW    	8
LIST3   DW    	18, 5, 19, 46, 3725
CNT3    DW    	5
SUM     DW    	0
DSEG 	ENDS

CSEG	SEGMENT
		ASSUME	CS:CSEG, DS:DSEG
		ASSUME	SS:SSEG

FMIN	PROC   	NEAR         	;求数组中最小值
		PUSH   	SI           	;保存数组首址
		MOV    	AX, [SI] 		;取第一个数
		DEC    	CX           	;计数值减1
		JZ     	RETURN       	;计数值为0,转
FMIN2:	INC    	SI           	;修改数组指针
		INC    	SI
		CMP    	AX, [SI]    	;与下一个数比较
		JB     	FMIN1        	;AX中数小,转
		MOV    	AX, [SI]    	;小数取入AX
FMIN1:  LOOP   	FMIN2        	;计数值减1,不为0转
RETURN: POP    	SI           	;恢复数组首值
		RET                 	;返回
FMIN    ENDP

MAIN:	MOV		AX, DSEG
		MOV		DS, AX
		MOV 	AX, SSEG
		MOV 	SS, AX
		MOV     SP, SIZE STKTOP
		MOV  	SI, OFFSET LIST1
		MOV   	CX, CNT1
		CALL	FMIN
		MOV   	BX, AX
		MOV  	SI, OFFSET LIST2
		MOV 	CX, CNT2
		CALL  	FMIN
		ADD  	BX, AX
		MOV  	SI, OFFSET LIST3
		MOV  	CX, CNT3　
		CALL 	FMIN
		ADD  	BX, AX
		MOV 	SUM, BX
		MOV 	AH, 4CH
		INT  	21H
CSEG   	ENDS
END		MAIN

