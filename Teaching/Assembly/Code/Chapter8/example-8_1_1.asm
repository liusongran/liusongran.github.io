;*****EXAM8.1.1*****
SSEG	SEGMENT		STACK
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

SQROOT1	PROC	NEAR
		XOR	AX, AX		;i←0
		AND	DX, DX		;测试被开方数
		JZ	SQRT2		;被开方数为0
SQRT1:	MOV	BX, AX		;形成奇数
		SHL	BX, 1
		INC	BX
		SUB	DX, BX		;被开方数减去奇数
		JC	SQRT2		;不够减
		INC	AX			;够减,i增1
		JMP	SQRT1		;继续
SQRT2:	MOV	DX, AX		;DX←平方根
		RET				;返回
SQROOT1	ENDP

MAIN1:	MOV		AX, DSEG
		MOV		DS, AX
		MOV 	AX, SSEG
		MOV 	SS, AX
		MOV     SP,SIZE STKTOP
		MOV		DX, PX			;取X
		ADD		DX, DX			;计算2X
		CALL	SQROOT1			;调用开平方子程序
		PUSH	DX				;暂存结果√2X
		MOV		DX, PY			;取Y
		MOV		AX, DX			;计算3Y
		ADD		DX, DX
		ADD		DX, AX
		CALL	SQROOT1			;调用开平方子程序
		POP		AX				;取出√2X
		ADD		AX, DX			;计算√2X+
		PUSH	AX				;暂存结果
		MOV		DX, 150
		CALL	SQROOT1
		POP		AX				;取出中间结果
		ADD		AX, DX			;计算最终结果
		MOV		RLT, AX			;保存结果
		MOV		AH, 4CH
		INT		21H
CSEG	ENDS
		END		MAIN1
