Uses PdArr,crt,Graph,Dos;
Label 1;
Type mr=Array[1..12000] Of Word;
Var j,i,N,M,Lty,T,Ty,Mem:longint;po,pm:pointer;
   H,min,sec,d,l:Byte;
   B:Word;
  grDriver,GrMode,ErrCode: Integer;
     Count:longint absolute 0:$046c;
     S,St,Stk:String;
     V:Boolean;
     Mrs:^Mr;
 Procedure EgaVga;External;
  {$L EgaVga.Obj}
  Procedure Decode(Count:LongInt;Var h,m,s:byte);
   Var TinS,hh,mm,ss:LongInt;
   Begin
    TinS:=Round( Count/18.2 );
    hh:=Trunc( TinS/3600 );
    mm:=(TinS-hh*3600)div 60 ;
    ss:=TinS-hh*3600-mm*60;
    h:=hh;
    m:=mm;
    s:=ss;
   End;
Begin
n:=6000;
m:=12;
l:=2;
If RegisterBgiDriver(@EgaVga)<0 Then Halt;
  grDriver := Detect;
  InitGraph(grDriver, grMode,'');
  ErrCode := GraphResult;
  if ErrCode <> grOk then
    Begin
     TextColor(14);
     Writeln('Graphics error:', GraphErrorMsg(ErrCode));
    repeat until keypressed;
     DoneMemory;
    Halt;
    End;
InitMemory;
setColor(12);
OuttextXy(1,8,'Testing program for unit Arrais.Copyright (C) Yury Konovalov Moscow,RASSIA 1992'+s);
setColor(3);
Mem:=MaxMemory;
Str(Mem,s);
OuttextXy(40,20,'Available Memory: '+s);
MoveTo(0,GetMaxY);
For j:=1 to M do
Begin
OpenArray(N,l);
 If MemResult=1 Then
    Begin
     Outtextxy(40,30,'There''s No Enough Memory To Work.');
     DoneMemory;
     repeat until keypressed;
     CloseGraph;
     Halt;
    End;
End;
SetColor(4);
Line(30,30,30,GetMaxY-30);
Line(GetMaxX,GetMaxY-30,30,GetMaxY-30);
SetColor(14);
b:=3;
V:=True;
1:Lty:=0;
MoveTo(31,GetMaxY-31);
T:=Count;
For j:=1 to M do
Begin
MarkArray(j,j);
Ty:=Count;
 If V Then   For i:=1 to N do PutMCmplx(j,i,@j)
      Else   For i:=1 to N do PutCmplx(j,i,@j);
{      Begin
       GetMem(Mrs,n);
        For i:=1 to N do Mrs^[i]:=b;
       FreeMem(Mrs,n);
      End;}
Ty:=Count-Ty;
If Ty>lTy Then lTy:=Ty;
    LineTo(30+((GetMaxX-30)*(j-1)) Div M+1,GetMaxY-30-Ty);
End;
T:=Count-T;
Decode(T,h,min,sec);
Str(H,s);Str(Min,st);Str(sec,stk);
s:=s+':'+St+':'+Stk;
If v Then d:=0 Else d:=200;
OuttextXy(40+d,40,'Spended Time : '+s);
Mem:=BookedMem;
Str(Mem,s);
OuttextXy(40+d,30,'Booked Memory: '+s);
SetLineStyle(UserBitLn,$C3,3);
SetColor(11);
Line(30,GetMaxY-30-lTy,GetMaxX,GetMaxY-30-lTy);
SetColor(13);
SetLineStyle(0,0,1);
If V Then Begin V:=False;DoneMemory; Goto 1;End;
Setcolor(10);
  Outtextxy(200,GetMaxY-20,'Press Any Key.');
repeat until keypressed;
CloseGraph;
End.
