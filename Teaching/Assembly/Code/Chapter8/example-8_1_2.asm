;*****EXAM8.1.2*****
SSEG	SEGMENT		STACK
STKTOP	DB		20 DUP(0)
SSEG	ENDS

DSEG	SEGMENT
PX		DW		12345
PY		DW		2469
RLT		DW		0
ARGX 	DW		0
ROOT 	DW 		0
DSEG 	ENDS

CSEG	SEGMENT
		ASSUME	CS:CSEG, DS:DSEG
		ASSUME	SS:SSEG

SQROOT2	PROC	NEAR
		MOV 	DX, ARGX
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
SQRT2:	MOV		ROOT, AX		;DX←平方根
		RET					;返回
SQROOT2	ENDP

MAIN1:	MOV		AX, DSEG
		MOV		DS, AX
		MOV 	AX, SSEG
		MOV 	SS, AX
		MOV     SP,SIZE STKTOP
		MOV		DX, PX			;取X
		ADD		DX, DX			;计算2X
		MOV 	ARGX, DX 		;存储至ARGX内存单元
		CALL	SQROOT2			;调用开平方子程序
		PUSH	ROOT			;暂存结果√2X
		MOV		DX, PY			;取Y
		MOV		AX, DX			;计算3Y
		ADD		DX, DX
		ADD		DX, AX
		MOV 	ARGX, DX 		;存储至ARGX内存单元
		CALL	SQROOT2			;调用开平方子程序
		POP		AX				;取出√2X
		ADD		AX, ROOT		;计算√2X+√3Y
		PUSH	AX				;暂存结果
		MOV		ARGX, 150
		CALL	SQROOT2
		POP		AX				;取出中间结果
		ADD		AX, ROOT		;计算最终结果
		MOV		RLT, AX			;保存结果
		MOV		AH, 4CH
		INT		21H
CSEG	ENDS
		END		MAIN1
