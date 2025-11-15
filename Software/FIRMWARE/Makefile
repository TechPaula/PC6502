CL65=/usr/bin/cl65
CA65=/usr/bin/ca65
LD65=/usr/bin/ld65


CLFLAGS=-t none -C osi_bas.cfg
LDFLAGS=-t none -C osi_bas.cfg


SRC = osi_bas.s
OBJ = osi_bas.o

.PHONY: clean default

default: osi_bas.bin

osi_bas.bin: *.s
	$(CL65) $(CLFLAGS) -l osi_bas.lst -o osi_bas.bin $^ 

burn: osi_bas.bin
	minipro -S -p SST39SF010A -w osi_bas.bin

clean:
	rm -f *.lst *.bin *.o

