;*****EXAM8.1.3*****
SSEG	SEGMENT	STACK
STKTOP	DB		20 DUP(0)
SSEG	ENDS

DSEG	SEGMENT
PX		DW		12345
PY		DW		2469
RLT		DW		0
DSEG 	ENDS

CSEG	SEGMENT
		ASSUME	CS:CSEG, DS:DSEG
		ASSUME	SS:SSEG

SQROOT3	PROC	NEAR
		INC 	SP
		INC 	SP
		POP 	DX
		XOR		AX, AX		;i←0
		AND		DX, DX		;测试被开方数
		JZ		SQRT2		;被开方数为0
SQRT1:	MOV		BX, AX		;形成奇数
		SHL		BX, 1
		INC		BX
		SUB		DX, BX		;被开方数减去奇数
		JC		SQRT2		;不够减
		INC		AX			;够减,i增1
		JMP		SQRT1		;继续
SQRT2:	PUSH	AX			;DX←平方根
		DEC 	SP
		DEC 	SP
		RET					;返回
SQROOT3	ENDP

MAIN1:	MOV		AX, DSEG
		MOV		DS, AX
		MOV 	AX, SSEG
		MOV 	SS, AX
		MOV     SP, SIZE STKTOP
		MOV		DX, PX			;取X
		ADD		DX, DX			;计算2X
		PUSH 	DX 				;NOTE:
		CALL	SQROOT3			;调用开平方子程序
		MOV		DX, PY			;取Y
		MOV		AX, DX			;计算3Y
		ADD		DX, DX
		ADD		DX, AX
		PUSH 	DX 	 			;NOTE:
		CALL	SQROOT3			;调用开平方子程序
		POP		DX				;NOTE:
		POP 	AX				;NOTE:
		ADD		AX, DX			;计算√2X+√3Y
		PUSH	AX				;暂存结果
		MOV		DX, 150
		PUSH 	DX				;NOTE:
		CALL	SQROOT3
		POP		DX				;取出中间结果
		POP 	AX
		ADD		AX, DX		;计算最终结果
		MOV		RLT, AX			;保存结果
		MOV		AH, 4CH
		INT		21H
CSEG	ENDS
		END		MAIN1
