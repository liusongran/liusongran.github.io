;*****EXAM7.4*****
DSEG	SEGMENT
DATA	DB		15H,26H,03H,64H
		DB		8AH,0AAH,24H,48H
COUNT	DW		08
ODDSUM	DW		0
EVENSM	DW		0
FORSUM 	DW		0
DSEG 	ENDS

SSEG	SEGMENT STACK
STACK	DB 		20 DUP(0)
SSEG	ENDS

CSEG	SEGMENT
		ASSUME	CS:CSEG, DS:DSEG
		ASSUME	SS:SSEG
FSUM: 	MOV		AX, DSEG		;设置数据段地址
		MOV 	DS, AX 
		MOV 	AX, SSEG		;设置堆栈段地址
		MOV		SS, AX
		MOV 	SP,	SIZE STACK     
		LEA 	SI, DATA		;设置地址指针
		MOV 	CX, COUNT		;计数值送CX
		XOR		AX, AX			;AX清0
		XOR 	BX, BX			;清存和寄存器
		XOR 	DX, DX
		XOR 	DI, DI
AG:		MOV 	AL, [SI]		;取数据
		TEST	AL, 01			;测试最低位
		JZ		EVNS			;偶数,转
		ADD		BX, AX			;奇数,累计和   
		JMP		CHNT
EVNS:	ADD		DX, AX			;偶数,累计和
		TEST 	AL, 03			;能否被4整除
		JNZ 	CHNT			;不能被4整除
		ADD 	DI, AX    		;能,累计和
CHNT:	INC		SI       		;指向下个数据
		LOOP 	AG				;计算完?未完继续
		MOV		ODDSUM, BX		;保存结果 
		MOV 	EVENSM, DX
		MOV 	FORSUM, DI
		MOV 	AH, 4CH
		INT		21H
CSEG	ENDS
END	FSUM
