#!/bin/sh
ca65 osi_bas.s -o osi_bas.o -l osi_bas.lst
ld65 -C osi_bas.cfg osi_bas.o -o osi_bas.bin -Ln osi_bas.lbl

