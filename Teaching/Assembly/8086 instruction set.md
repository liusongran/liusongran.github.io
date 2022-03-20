# Complete 8086 instruction set
[TOC]

> Operand types:
> - **REG**: AX, BX, CX, DX, AH, AL, BL, BH, CH, CL, DH, DL, DI, SI, BP, SP.
> - **SREG**: DS, ES, SS, and only as second operand: CS.
> - **memory**: [BX], [BX+SI+7], variable, etc...
> - **immediate (idata)**: 5, -24, 3Fh, 10001101b, etc...
## 

### `MOV`
- Description: The `MOV` instruction is the most important command in the 8086 because it moves data from one location to another. It also has the widest variety of parameters; so if the assembler programmer can use `MOV` effectively, the rest of the commands are easier to understand.
- Format: `MOV destination,source`
- Usage:
| destination  | source         | example |
|:-------------|:---------------|:------|
| REG          | idata          | MOV AX, 8  |
| REG          | REG            | MOV AX, BX  |
| REG          | memory         | MOV AX, ES:[BX]   |
| REG          | SREG           | MOV AX, DS   |
| SREG         | REG            | MOV DS, AX |
| ~~SREG~~         | ~~SREG~~           | ~~MOV DS, ES~~ |
| SREG         | memory         | MOV DS, [0] |
| ~~SREG~~         | ~~idata~~          | ~~MOV DS, 10H~~ |
| memory       | REG            | MOV [6], AX |
| memory       | SREG           | MOV [0], CS |
| ~~memory~~       | ~~memory~~         | ~~MOV [0], [6]~~ |
| ~~memory~~       | ~~idata~~          | ~~MOV [BX], 10H~~ |
| ~~idata~~        | ~~REG~~            | |
| ~~idata~~        | ~~SREG~~           | |
| ~~idata~~        | ~~memory~~         | |
| ~~idata~~        | ~~idata~~          | |

- Note: The `MOV` instruction cannot set the value of the CS and IP registers.

