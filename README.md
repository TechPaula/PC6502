# PC6502
My 6502 project in a PC104 like form factor.  
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
2025-09-21 - Version 1.1 Schematic and PCB uploaded. A lot of changes and simplicifcation in some ways, A simpler CPU board (direct link to FT245R, 74161 removed and some tidying of tracks). Fixed a couple of floating inputs to RAM/ROM
VIA is much simpler, having just the one VIA chip. POWER board has USB-PD and a 24VDC input for higher power stuff in the future. These three PCBs have been orderred.
2025-10-02 - V1.1 CPU board needed a couple of mods, I forgot that one of the pins that I used as input before had become output but the CPLD could not support that. New CPLD code done. **Now runs with a 12MHz clock (6MHz CPU speed)**, I found without the VIA it ran with a 16MHz clock fine, but would not run with a 20MHz clock, I suspect this is down to the FT245. This may get resolved when I add clock stretching to the CPLD. **VIA V1.1 working fine!** CPU board modded and Schematics and PCB updated, CPLD code for VIA and CPU updated. Updated memory map below


## CPU Board
Actual PCB:

![PC6502 CPU board](/Images/PC6502_CPU_V11.jpg?raw=true "AV1.1 PC6502 CPU board undergoing testing")

Mandlebrot Code:

![Mandlebrot code and run](/Images/ScreenShotV100_MandleCode.png?raw=true "Mandlebrot running on hardware")


This board has a 6502, RAM and ROM on board, along with an ATF1502 for address decoding. There is also an FT245R which is pretending to be a 68B50 with USB. 
The CPLD code and .JED files are in /Software/CPLD

## VIA Board
This board has a single 6522 VIA and an ATF1502 for address decoding, The VIA outputs are brought out to PMOD style headers (though are 5V)
The CPLD code and .JED files are in /Software/CPLD

![PC6502 VIA board](/Images/PC6502_VIA_V11.jpg?raw=true "V1.1 PC6502 VIA board undergoing testing")


### Memory Map
The memory map is subject to change in some parts, though I expect the RAM, ROM and Peripheral blocks to stay the same.

#### High Level
| Start | End | Size (Dec) | Size (Hex) | What is it | Notes |
|-------|-----|----|----|----|---------------|
| 0x0000|0x7FFF| 32768 | 0x8000 | RAM  | This is devided into sub parts below |
| 0x8000|0x9FFF|  8192 | 0x2000 | not used yet |
| 0xA000|0xBFFF|  8192 | 0x2000 | Peripherals | See table below for more info |
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
| 0xC000|0xFEFF| 12288 | 0x3000 | MS Basic  | Basic Interpreter |
| 0xFF00|0xFFF9| 3584 | 0x0E00 | IO handler  | This is where common things are held, like getting input |
| 0xFFFA|0xFFFF| 6 | 0x0006 | Jump vetors  | Vectors for power on, NMI, etc |

The OS is based on Grant Searle's 6502 computer work - http://searle.x10host.com/6502/Simple6502.html
I've modified this to fit with my memory map, but it's not yet tested.
I do plan to add bits and bobs to it as I need (e.g. LOAD, SAVE, DIR).

#### Peripherals
I expect frequent changes as I add/remove things. Everything should have at least 16 bytes of address space

| Address | subAddr | RW | What is it | Notes |
|---------|---------|----|-------|---------------|
| 0xA000 | 0 - 1 | RW | Console Control/Data | 60-fake-50, mostly the same as 6850, but no config options|
| 0xA010 | 0 - 1 | RW | Serial port Control/Data | Future serial port, possibly MIDI? |
| 0xA08- | 0 - F | RW | 6522 VIA A | One of four locations |
| 0xA09- | 0 - F | RW | 6522 VIA B | Datasheet - https://eater.net/datasheets/w65c22.pdf |
| 0xA0A- | 0 - F | RW | 6522 VIA C |  |
| 0xA0B- | 0 - F | RW | 6522 VIA D |  |


### Things to build
* **Power Board**: This is currently on rev 1.0, it has a USB PD Chip (ST4500) and also a 24V DC input, the idea behind this is that if I want to run some heavy power things (e.g. transputers) then I'll need more than the 4W you get from a regular USB connection.

### Things in progresss
* **FM & SPEECH Board**: Featuring a YM262 and DAC (I have a couple of spares) and an SP0256-AL2 chip, just because, why not?

## The Future
I have a bunch of things I want to try adding, some ideas I have are below, some may happen, some may not and they're not in any particular order;

* **RA8875 based display & keyboard interface**: something that can display text and simple graphics and let my type without needing my laptop. I'll probably buy an off the shelf display with this on and memory map it as a peripheral somewhere and it will almost certainly be PS/2 keyboard.
* **RTC & ASCII Display**: Maybe an RTC and an ascii display (I have a couple of QDSP2118 displays somewhere that I'd like to use)
* **A Sound Engine**: I'm thinking of my own simple Wavetable based sound engine, possibly with analogue VCF/VCAs. Some kind of tracker software or even MIDI interface to go with it?
* **Compact Flash / SD Storage**: I'm going to want something in the long run as retyping code is going to get tedious quickly. I have found a 6502 SPI interface here, so that may speed things up - https://sbc.rictor.org/65spi2.html
* **Some kind of HDMI grpahics adapter**: My current thinking is the videobeast (https://feertech.com/microbeast/videobeast.html) but that needs a big hole in RAM.
* **Transputer Link Adapter/Card**: because I still want to use these, but I think having them "speed up" computation on a 6502 is going to have a bigger impact than a 1GHz PC.

