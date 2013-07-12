Uses PdArr,crt;
Var j,i,N,M:longint;po,pm:pointer;B,d,l:Byte;
Begin
TextBackGround(0);
clrscr;textcolor(7);
n:=12000;
m:=6;
l:=1;
InitMemory;
Writeln('Available Memory: ',MaxMemory,' ',Memavail);
Gotoxy(1,2);
For j:=1 to M do
Begin
OpenArray(N,l);
 If MemResult=1 Then
    Begin
     Writeln;
     Writeln('There''s No Enough Memory To Work.');
     DoneMemory;
     repeat until keypressed;
     Halt;
    End;
    Write('o');
End;
Gotoxy(1,2);
For j:=1 to M do
Begin
MarkArray(j);
    For i:=1 to N do PutMCx(i,@j);
    Write(':');
End;
Writeln;
For j:=1 to QuanArrais Do
 Begin
 MarkArray(j);
 GetMCx(1,@b);
 GetMCx(n,@d);
 Writeln(' Size: ',SizeOfArray(j),
         ' Dimention: ',DimenOfArray(j),
         ' ',b,':',d);
 End;
Writeln('Available Memory: ',MaxMemory,' ',memavail,' Booked memory: ',BookedMem);
repeat until keypressed;
DoneMemory;
End.
