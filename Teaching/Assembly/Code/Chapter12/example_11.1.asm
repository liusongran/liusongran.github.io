MOV		AL, 13H		;8259A单独使用,边缘检测,不需要ICW3
OUT		20H, AL	
MOV		AL, 08H		;IR0~IR7八个输入端的中断方式码分别为08H~0FH
OUT		21H, AL
MOV		AL, 09H		;使用缓冲方式和EOI方式
OUT		21H, AL

;初始化主8259A
MOV		AL, 11H		;8259A级连使用,边缘检测,需要ICW3
OUT		20H, AL	
MOV		AL, 08H		;IR0~IR7八个输入端的中断方式码分别为08H~0FH
OUT		21H, AL
MOV		AL, 04H		;在IR2端接有一从属8259A
OUT		21H, AL
MOV		AL, 11H		;使用特殊完全嵌套方式、非缓冲方式和EOI方式
OUT		21H, AL

;初始化从8259A
MOV		AL, 11H		;8259A级连使用,边缘检测,需要ICW3
OUT		0A0H, AL	
MOV		AL, 70H		;IR0~IR7八个输入端的中断方式码分别为70H~77H
OUT		0A1H, AL
MOV		AL, 02H		;从属8259A连接在主8259A的IR2端
OUT		0A1H, AL
MOV		AL, 01H		;使用非缓冲方式和EOI方式
OUT		0A1H, AL

MOV		AH, 0		;功能号为0
INT		16H     	;执行后, AH是按键的扫描码, AL是按键的ASCII码

MOV 	AH, 0EH		;功能号为14
MOV 	AL, 'A' 	;欲显示的字符
INT 	10H 

