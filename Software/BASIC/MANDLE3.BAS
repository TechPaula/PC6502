1 REM ******************************************************
2 REM * TERMINAL SHOULD BE SET TO 100+ CHARACTERS WIDE     *
3 REM ******************************************************


10 FOR Y=-40 TO 40
20 FOR X=-80 TO 0
30 CA= X*0.02611
40 CB= Y*0.03411
50 A=CA
60 B=CB

70 FOR I=0 TO 15
80 T=A*A-B*B+CA
90 B=2*A*B+CB
100 A=T
110 IF (A*A+B*B)>4 THEN GOTO 200
120 NEXT I
130 PRINT " ";
140 GOTO 210
200 IF I>9 THEN I=I+7
205 PRINT CHR$(48+I);
210 NEXT X
220 PRINT
230 NEXT Y
