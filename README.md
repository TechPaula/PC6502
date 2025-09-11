# PC6502
My 6502 project in a PC104 like formfactor

This is VERY VERY unstable, I do not know what works and what doesn't.

## CPU Board
![Render of PC6502 CPU board](/Images/PC6502_CPU_Render.png?raw=true "Render of the PC6502 CPU board")

This board has a 6502, RAM and ROM on board, along with an ATF1502 for address decoding. There is also a 60-fake-50 (instaled of 6850) which is not my design but emulates the 6850 with USB.
The CPLD code and .JED files are in /Software/CPLD

## VIA Board
![Render of PC6502 VIA board](/Images/PC6502_VIA_Render.png?raw=true "Render of the PC6502 VIA board")

This board has two 6522 VIAs and an ATF1502 for address decoding, The VIA outputs are brought out to PMOD style headers (though are 5V)
The CPLD code and .JED files are in /Software/CPLD

### Memory Map
The memory map is subject to change in some parts, though I expect the RAM, ROM and Peripheral blocks to stay the same.

| Start | End | Size (Dec) | Size (Hex) | What is it | Notes |
|-------|-----|----|----|----|---------------|
| 0x0000|0x7FFF| 32768 | 0x8000 | RAM  | This is devided into sub parts below |

