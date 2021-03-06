;*****EXAM6.2*****
SSEG	SEGMENT	STACK
STK	DB      20	DUP(0)
SSEG	ENDS

DSEG	SEGMENT
ARG	DW      7138H,84A6H,29EH
MAXDW	?
DSEG	ENDS

CSEG	SEGMENT
        ASSUME	CS:CSEG, DS:DSEG
        ASSUME	SS:SSEG
FMAX:   MOV     AX, DSEG
        MOV     DS, AX
	MOV     AX, SSEG
	MOV     SS, AX
	MOV     SP, SIZE STK
        LEA     SI, ARG	        ;取数据首址
        MOV     AX, [SI]        ;取第1个数
        MOV     BX, [SI+2]      ;取第2个数
        CMP     AX, BX		;两数比较
        JAE     FMAX1	        ;AX中的数大
        MOV     AX, BX		;大数送AX
FMAX1:  CMP     AX, [SI+4]	;大数与第3个数比较
        JAE     FMAX2	        ;AX中的数大
        MOV     AX, [SI+4]	;第3个数大大值
FMAX2:  MOV     MAX,AX	        ;保存最大值
        MOV	 AH,4CH
        INT	 21H
CSEG   ENDS
ENDF MAX
