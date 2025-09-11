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

#### High Level
| Start | End | Size (Dec) | Size (Hex) | What is it | Notes |
|-------|-----|----|----|----|---------------|
| 0x0000|0x7FFF| 32768 | 0x8000 | RAM  | This is devided into sub parts below |
| 0x8000|0xBFFF| 16384 | 0x4000 | Peripherals | See table below for more info |
| 0xC000|0xFFFF| 16384 | 0x4000 | ROM | More info below |

#### RAM 
| Start | End | Size (Dec) | Size (Hex) | What is it | Notes |
|-------|-----|----|----|----|---------------|
| 0x0000|0x00FF| 256 | 0x0100 | Zero Page  | Used by the 6502 |
| 0x0100|0x02FF| 512 | 0x0200 | Stack  | I think this is the stack |
| 0x0300|0x03FF| 256 | 0x0100 | Input buffer  | used by Basic/Wozmon |
| 0x0400|0x7FFF| 31744 | 0x7C00 | User RAM  | un-allocated RAM |

#### ROM 
| Start | End | Size (Dec) | Size (Hex) | What is it | Notes |
|-------|-----|----|----|----|---------------|
| 0xC000|0xEFFF| 12288 | 0x3000 | MS Basic  | Basic Interpreter |
| 0xF000|0xFDFF| 3584 | 0x0E00 | BIOS  | This is where common things are held, like getting input |
| 0xFE00|0xFFF9| 506 | 0x1FA | WozMon  | Monitor program |
| 0xFFFA|0xFFFF| 6 | 0x0006 | Jump vetors  | Vectors for power on, NMI, etc |

#### Peripherals
I expect frequent changes as I add/remove things;

| Address | subAddr | RW | What is it | Notes |
|---------|---------|----|-------|---------------|
| 0xBFFF | n/a | RW | Console Control/Status | 60-fake-50, mostly the same as 6850, but no config |
| 0xBFFE | n/a | RW | Console Control/Status | 60-fake-50, mostly the same as 6850, but no config |
| 0xBFE- | 0 - F | RW | 6522 VIA A | Datasheet - https://eater.net/datasheets/w65c22.pdf |
| 0xBFD- | 0 - F | RW | 6522 VIA A | Datasheet - https://eater.net/datasheets/w65c22.pdf |


