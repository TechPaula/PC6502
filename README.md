# PC6502
![PC6502 CPU board](/Images/FullStack.jpg?raw=true "The PC6502 Stack, work in progess")

My 6502 project in a PC104 like form factor.  
**This is unstable, some things work and and some don't, use at your own risk of sanity and wasted money/chips**  

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

2025-10-11 - Power board built, works great, however the switch is inadequate, so I've hard wired it

2025-10-14 - CPLD code for the CPU PCB updated, with help from Shonky it now runs at up to the full 14MHz and also will do clock stretching when using SLOW1 line. The SLOW0 line is still bring problematic.

2025-10-16 - SPEECH synthesis chip working fine after a couple of extra wires on V1.0 of the PCB, V1.1 has been updated with these. The OPL3 (YMF262) is reading and writing, but not yet making sound.

2025-10-19 - Dual SPI board confirmed working!
It looks like my Apple II slots might be bacwards, I need to do more checking to confirm one way or the other.
The Compact Flash Storage board is also working, at least as far as raw byte reads and reads are concerned.

2025-10-23 - OPL3 Now working! I've made a change to the PCB and Schematics to fix the problem.
The CPU Board has also had a change this allows Clock stretching to be added. Currently only the SLOW1 input is working, but I will add the other later.
CPLD code for the compact flash board, updated VIA CPLD code and updated CPU CPLD code are now in.

2025-11-02 - Finished the Rev 1.0 keyboard and interface cards, I also made a simple 5V PMOD level shifter. these have been ordered.
Still testing the AII SLOT PCB, I'm unsure if it is working 100% or not, needs more time and ideally an apple II card to test with.

2025-11-12 - Working on KeyBed code.

2025-11-15 - Updated the KeyTFT board to Rev 1.1, removed the ATMEGA644, replaced it with a W65C51, as it'll only really be receiving from the keyboard I'm hoping the bug won't be a problem. The display is also now parallel rather than SPI.
Addtionally I've tweaked the CPU board to revision 1.4, this connects A15 direct to the RAM, so in theory getting more than 32K should be quicker and just require a change in the CPLD.
Keybed code working, aside from caps lock. Waiting for the full keyset and stabalisers to arrive before doing more.


## CPU Board
Actual PCB:

![PC6502 CPU board](/Images/PC6502_CPU_V11.jpg?raw=true "A V1.1 PC6502 CPU board undergoing testing")

Mandlebrot Code:

![Mandlebrot code and run](/Images/ScreenShotV100_MandleCode.png?raw=true "Mandlebrot running on hardware")


This board has a 6502, RAM and ROM on board, along with an ATF1502 for address decoding. There is also an FT245R which is pretending to be a 68B50 with USB. 
The CPLD code and .JED files are in /Software/CPLD


## VIA Board
This board has a single 6522 VIA and an ATF1502 for address decoding, The VIA outputs are brought out to PMOD style headers (though are 5V)
The CPLD code and .JED files are in /Software/CPLD

![PC6502 VIA board](/Images/PC6502_VIA_V11.jpg?raw=true "V1.1 PC6502 VIA board undergoing testing")


## Dual SPI board
Featuring two SPI interfaces, based on https://sbc.rictor.org/65spi2.html.
This uses two ATF1504AS and a single ATF1502AS.
(Note: in the picture I'm using the wrong ATF1504s, oops)

![PC6502 VIA board](/Images/PC6502_DualSPI.jpg?raw=true "Dual SPI board")


## Compact Flash board
A Very simple board in terms of electronics. Reading and Writing raw bytes is working!.

![PC6502 VIA board](/Images/PC6502_Storage.jpg?raw=true "Compact Flash storage card")


## FM(OPL3) and SPEECH card
So far the speech engine is working great, and I can read/write from/to the OPL3, I can't seem to get any sound from the OPL3 yet.

![PC6502 VIA board](/Images/PC6502_FM_Speech.jpg?raw=true "FM and speech card")


## Keybed
I kind of wanted to make my own keyboard rather than using a PS/2 keyboard, it just felt right to me.
I also had an old QDSP2118 display around, so I figured I'd pop that on there too.

![PC6502 KeyBed](/Images/Keybed.jpeg?raw=true "KeyBed without keys")


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
| 0xA010 | 0 - 1 | RW | Keyboard iterface | a simple TTL Serial port |
| 0xA020 | 0 - 1 | RW | Serial port Control/Data | Future serial port, possibly MIDI? |
| 0xA08- | 0 - F | RW | 6522 VIA A | One of four locations |
| 0xA09- | 0 - F | RW | 6522 VIA B | Datasheet - https://eater.net/datasheets/w65c22.pdf |
| 0xA0A- | 0 - F | RW | 6522 VIA C |  |
| 0xA0B- | 0 - F | RW | 6522 VIA D |  |
| 0xA0C- | 0 - 3 | RW | SPI 0 | (shared PCB with SPI1)  |
| 0xA0D- | 0 - 3 | RW | SPI 1 | (shared PCB with SPI0)  |
| 0xA10- | 0     | W  | SP0256 speech synth | (shared PCB with OPL3) | 
| 0xA10- | 1     | RW | SP0256 speech synth status/reset || 
| 0xA11- | 0 - 3 | RW | OPL3 Chip - YM262 | (shared PCB with SP0256) | 
| 0xA20- | 0 - 7 | RW | Compact Flash |  | 
| 0xA30- | 0 - F | RW | AII SLOT 0 |  | 
| 0xA31- | 0 - F | RW | AII SLOT 1 |  | 




### Things in build & test
* **Dual Slot Apple II board**: A board that hosts Slot0 and Slot1 from an apple II, it only has the 5V rail though.
    testing is going slowly, I'm not convinced it's correct yet and I doubt it'll be 100% Apple II card compatible.

### PCBs Ordered
* **RA8875 based display & keyboard interface**: something that can display text and simple graphics and let my type without needing my laptop. I'll probably buy an off the shelf display with this on and memory map it as a peripheral somewhere. I'm hoping to use this in parallel with the USB Serial. I also decided to make my own keyboard, just because :)


## The Future
I have a bunch of things I want to try adding, some ideas I have are below, some may happen, some may not and they're not in any particular order;

* **RTC & ASCII Display**: Maybe an RTC and an ascii display (I have a couple of QDSP2118 displays somewhere that I'd like to use)
* **A Complex Sound Engine**: I'm thinking of my own simple Wavetable based sound engine, possibly with analogue VCF/VCAs. Some kind of tracker software or even MIDI interface to go with it?
* **SD Storage**: I'm going to want something in the long run as retyping code is going to get tedious quickly. I have found a 6502 SPI interface here, so that may speed things up - https://sbc.rictor.org/65spi2.html
* **Some kind of HDMI grpahics adapter**: My current thinking is the videobeast (https://feertech.com/microbeast/videobeast.html) but that needs a big hole in RAM.
* **Transputer Link Adapter/Card**: because I still want to use these, but I think having them "speed up" computation on a 6502 is going to have a bigger impact than a 1GHz PC.

