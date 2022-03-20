# Complete 8086 instruction set
* TOC
{:toc}

> **Operand types:**
> - **REG**: AX, BX, CX, DX, AH, AL, BL, BH, CH, CL, DH, DL, DI, SI, BP, SP.
> - **SREG**: DS, ES, SS, and only as second operand: CS.
> - **memory**: [BX], [BX+SI+7], variable, etc...
> - **immediate (idata)**: 5, -24, 3Fh, 10001101b, etc...

> **Basic commands for MASM DEBUG:**
> R - lookup and modify registers
> D - lookup memory cell
> E - modify memory cell
> U - disassembly
> T/P - step in
> G - continuous execution
> A - add assembly code
> Q - quit

### `MOV`
**Description**: The `MOV` instruction is the most important command in the 8086 because it moves data from one location to another. It also has the widest variety of parameters; so if the assembler programmer can use `MOV` effectively, the rest of the commands are easier to understand.

**Format**: `MOV destination,source`

**Usage**:

| Destination | Source     | Example                                                   |
|:------------|:-----------|:----------------------------------------------------------|
| REG         | REG        | MOV AX, BX                                                |
| REG         | SREG       | MOV AX, DS                                                |
| REG         | memory     | MOV AX, ES:[BX]                                           |
| REG         | idata      | MOV AX, 08H                                               |
| SREG        | REG        | MOV DS, AX                                                |
| SREG        | SREG       | MOV DS, ES                                                |
| SREG        | memory     | MOV ES, DS:[0]                                            |
| ~~SREG~~    | ~~memory~~ | ~~MOV ES, [0]~~                                           |
| ~~SREG~~    | ~~idata~~  | ~~MOV DS, 10H~~                                           |
| memory      | REG        | MOV [6], AX                                               |
| memory      | SREG       | MOV [0], CS                                               |
| ~~memory~~  | ~~memory~~ | ~~MOV [0035H], [15H] MOV DS[35H], [35H]~~                 |
| memory      | idata      | ~~MOV [0035H], 35H MOV [BX], 10H~~ MOV BYTE PTR [BX], 10H |

**Note**: The `MOV` instruction cannot set the value of the CS and IP registers.
