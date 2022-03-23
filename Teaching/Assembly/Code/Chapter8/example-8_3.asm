;*****EXAM8.3*****
		PUBLIC	PMZN
CSEG	SEGMENT
		ASSUME  CS:CSEG
PMZN    PROC    FAR 			
		PUSH    SI        			;保存数组首址
		PUSH    CX        			;保存数据个数
		XOR     AX,AX          		;清计数器
		XOR     BX,BX
		XOR     DX,DX
PMZN0:  TEST    WORD PTR[SI],0FFFFH	;测试数据
		JS      MINUS 				;负转
		JNZ     PLUS 				;非0转
		INC     DX              	;为0,0计数器加1
		JMP     PMZN1
PLUS:   INC     AX              	;正数计数器加1
		JMP     PMZN1
MINUS:  INC     BX               	;负数计数器加1
PMZN1:  ADD     SI,2            	;指向下一个数据
		LOOP    PMZN0             	;循环计数减1,非0转
		POP     CX               	;恢复CX
		POP     SI               	;恢复SI
		RET
PMZN    ENDP
CSEG    ENDS
		END

EXTRN	PMZN:FAR
SSEG    SEGMENT	STACK
SKTOP   DB		50 DUP(0)
SSEG    ENDS

DSEG    SEGMENT
ARRY1   DW  	15,-5,1,5,0,123,964,-327,0
CNT1    DW  	9
ARRY2   DW   	103,4,-8,-23,0,827,-936,0,0,18
CNT2    DW   	10
ARRY3   DW   	-29,-137,-23,0,4,0   
CNT3    DW   	6
PCOUNT  DW   	0             		;保存结果单元
MCOUNT  DW    	0
ZCOUNT  DW  	0
ADR     DW 		OFFSET ARRY1, OFFSET CNT1
		DW   	OFFSET ARRY2, OFFSET CNT2
		DW   	OFFSET ARRY3, OFFSET CNT3
DSEG    ENDS

CSEG    SEGMENT
		ASSUME	CS:CSEG, DS:DSEG
		ASSUME	SS:SSEG
START:  MOV  	AX, DSEG
		MOV  	DS, AX
		MOV   	AX, SSEG
		MOV  	SS, AX
		MOV  	SP, LENGTH SKTOP      
		LEA  	DI, ADR
		MOV 	CX, 03 
AGAIN:  MOV  	SI, [DI] 		;取数组首址→SI
		MOV 	BX, [DI+2]		;取数组数据个数首址 
		PUSH 	CX 				;保存CX中的循环计数值
		MOV   	CX, [BX   		;取数组数据个数→CX
		CALL  	FAR PTR PMZN
		ADD   	PCOUNT, AX  	;累加结果
		ADD  	MCOUNT, BX
		ADD  	ZCOUNT, DX
		ADD  	DI, 4 			;修改指针指向下一数组
		POP  	CX 				;恢复CX中循环计数
		LOOP  	AGAIN 			;CX计数值减1,非0转
		MOV  	AH, 4CH
		INT  	21H
CSEG    END
		END 	START

