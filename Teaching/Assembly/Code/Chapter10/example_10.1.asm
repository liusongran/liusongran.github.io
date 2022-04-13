DSEG	SEGMENT
DATA1	DB		85H,27H,4AH;（4A2785H）
DATA2	DB		93H,87H,65H;（658793H）
LEGH	DW		3
SUM	    DB		3  DUP(0)
DSEG	ENDS
CSEG	SEGMENT
        ASSUME	CS:CSEG,DS:DSEG
START:  MOV		AX,DSEG
        MOV		DS,AX
        LEA		SI,DATA1
        LEA		BX,DATA2
        LEA		DI,SUM
        MOV		CX,LEGH
        CLC
AGAIN:  MOV		AL,[SI]
        ADC		AL,[BX]
        MOV		[DI],AL
        INC		SI
        INC		BX
        INC		DI
        LOOP		AGAIN
        MOV		AH,4CH
        INT		21H
CSEG    ENDS
        END		START



MUL8    PROC
		XOR	    AH,AH
		XOR	    DX,DX
MUL80:	OR	    BL,BL
		JNZ	    MUL81
		RET
MUL81:	SHR	    BL,1
		JNC	    MUL82
		ADD	    DX,AX
MUL82:	SHL	    AX,1
		JMP	    MUL80
MUL8    ENDP

DATBIN  PROC
        PUSH	BX
        XOR	    CX,CX
GETA:   MOV	    AL,[SI]
        CMP     AL,'0'
        JB	    RETURN
        CMP     AL,'9'
        JA	    RETURN
        SUB     AL,'0'
        XOR	    AH,AH
        MOV	    BX,CX
        SHL	    CX,1
        SHL	    CX,1
        ADD	    CX,BX
        SHL	    CX,1
        ADD	    CX,AX
        INC	    SI
        JMP	    GETA
RETURN: POP     BX
        RET
DATBIN  ENDP


DSEG    SEGMENT
BUFF    DB		10H DUP (0)
BIN		DW		?
DSEG    ENDS
CSEG    SEGMENT
		ASSUME	CS:CSEG,DS:DSEG
DTB:    MOV     AX,DSEG
        MOV     DS,AX
        MOV     ES,AX
        LEA     DI,BUFF
AG:     MOV     AH,1
        INT     21H
        STOSB
        CMP     AL,0DH
        JNE     AG
        CALL    DATBIN
        MOV     BIN,CX
        MOV     AH,4CH
        INT     21H
CSEG    ENDS
END     DTB
