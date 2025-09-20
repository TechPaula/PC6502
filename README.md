# PC6502
My 6502 project in a PC104 like formfactor.  
**This is VERY VERY unstable, I do not know what works and what doesn't, use at your own risk of sanity and wasted money/chips**  

## Status
2025-09-08 - PCBs ordered, Parts ordered.  
2025-09-11 - Edited the firmware based on Grant Searl's code. Created this Repository  
2025-09-20 - Version 1.0 is running with a few modifications, so I've created Version 1.1 of schematics and PCB. I've added some basic examples, currently you have to copy and paste into the serial terminal. Current memory map is the same as Grants;
0000-7FFF 32K RAM
8000-9FFF FREE SPACE (8K)
A000-BFFF SERIAL INTERFACE (minimally decoded)
C000-FFFF 16K ROM (BASIC from C000 TO DED3, serial routines FF00 to FFFF)
It's also not very stable just yet. I do sometimes get corruption in the data to/from the serial console.



## CPU Board
Actual PCB:

![Actual PC6502 CPU board](/Images/PC6502_V100.jpg?raw=true "Actual V1.00 PC6502 CPU board undergoing testing")

Mandlebrot Code:

![Mandlebrot code and run](/Images/ScreenShotV100_MandleCode.png?raw=true "Mandlebrot running on hardware")

Corruption:

![Mandlebrot corruption](/Images/ScreenShotV100_MandleCorrupt.png?raw=true "Mandlebrot showing corruption, top is correct")


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
| 0x0100|0x02FF| 256 | 0x0100 | Stack  | Used by 6502 |
| 0x0200|0x7FFF| 32256 | 0x7E00 | User RAM  | un-allocated RAM |

#### ROM 
| Start | End | Size (Dec) | Size (Hex) | What is it | Notes |
|-------|-----|----|----|----|---------------|
| 0xC000|0xEFFF| 12288 | 0x3000 | MS Basic  | Basic Interpreter |
| 0xF000|0xFDFF| 3584 | 0x0E00 | BIOS  | This is where common things are held, like getting input |
| 0xFE00|0xFFF9| 506 | 0x1FA | Monitor  | Monitor program |
| 0xFFFA|0xFFFF| 6 | 0x0006 | Jump vetors  | Vectors for power on, NMI, etc |

The OS is based on Grant Searle's 6502 computer work - http://searle.x10host.com/6502/Simple6502.html
I've modified this to fit with my memory map, but it's not yet tested.
I do plan to add bits and bobs to it as I need (e.g. LOAD, SAVE, DIR).

#### Peripherals
I expect frequent changes as I add/remove things;

| Address | subAddr | RW | What is it | Notes |
|---------|---------|----|-------|---------------|
| 0xBFFF | n/a | RW | Console Control/Status | 60-fake-50, mostly the same as 6850, but no config |
| 0xBFFE | n/a | RW | Console Control/Status | 60-fake-50, mostly the same as 6850, but no config |
| 0xBFE- | 0 - F | RW | 6522 VIA A | Datasheet - https://eater.net/datasheets/w65c22.pdf |
| 0xBFD- | 0 - F | RW | 6522 VIA A | Datasheet - https://eater.net/datasheets/w65c22.pdf |

## The Future
I have a bunch of things I want to try adding, some ideas I have are below, some may happen, some may not and they're not in any particular order;

* **Power Board**: LAmost certainly will be USB-C PD to 5V, I'm aware that some of the things I want to add can be quite heavy on power consumption, so this seems like a sensible way to future proof it to an extent.
* **RA8875 based display & keyboard interface**: something that can display text and simple graphics and let my type without needing my laptop. I'll probably buy an off the shelf display with this on and memory map it as a peripheral somewhere and it will almost certainly be PS/2 keyboard.
* **RTC & ASCII Display**: Maybe an RTC and an ascii display (I have a couple of QDSP2118 displays somewhere that I'd like to use)
* **A Sound Engine**: I'm thinking of my own simple Wavetable based sound engine, possibly with analogue VCF/VCAs. Some kind of tracker software or even MIDI interface to go with it?
* **Compact Flash / SD Storage**: I'm going to want something in the long run as retyping code is going to get tedious quickly. I have found a 6502 SPI interface here, so that may speed things up - https://sbc.rictor.org/65spi2.html
* **Some kind of HDMI grpahics adapter**: My current thinking is the videobeast (https://feertech.com/microbeast/videobeast.html) but that needs a big hole in RAM.
* **Transputer Link Adapter/Card**: because I still want to use these, but I think having them "speed up" computation on a 6502 is going to have a bigger impact than a 1GHz PC.

