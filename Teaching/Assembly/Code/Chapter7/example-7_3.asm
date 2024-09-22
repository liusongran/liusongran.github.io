;*****EXAM7.3*****
DSEG	SEGMENT
DATA	DW	13924
ROOT	DW	0
TESS 	DB  10, 12
DSEG	ENDS

SSEG	SEGMENT PARA STACK 'SSEG'
STACK	DB	50  DUP(0)
SSEG	ENDS

CSEG	SEGMENT
		ASSUME	CS:CSEG, DS:DSEG
		ASSUME	SS:SSEG
SQRT:	MOV		AX, DSEG		;设置数据段地址
		MOV		DS, AX
		MOV		AX, SSEG		;设置堆栈段地址
		MOV		SS, AX
		MOV		SP, SIZE STACK
		MOV     AL, HIGH 1234
		XOR		CX, CX			;计数器清零
		XOR		AX, AX			;设i的初值为0
		MOV		DX, DATA		;被开方数送DX
		MOV 	BX, DX
		CALL 	[BX]
AG:		AND		DX, DX			;被开方数为零吗
		JZ		LRT				;被开方数为零,转
		MOV		BX, AX			;i值送BX
		SHL		BX, 1			;乘2
		INC		BX				;形成奇数
		SUB		DX, BX			;被开方数减去奇数
		INC		CX				;计数器值增1
		INC		AX				;i值增1
		JMP		AG				;继续工作
LRT:	MOV		ROOT, CX		;保存结果
		MOV		AH, 4CH
		INT		21H
CSEG	ENDS
END	SQRT
