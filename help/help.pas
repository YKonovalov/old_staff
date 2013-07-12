Unit Help;

Interface

   Uses Crt;
Const
    BlockBegin='<#Begin';
    BlockEnd='<#End';
    BlockJump='<#=>';
    BlockSeparator='#:';
    BlockCloser='#>';
Type
   Safe=Array[1..25,1..80]Of Record C,A:Byte End;
   Name=string[12];
   Keys=Set Of Char;

     Procedure PutHelp(fs,OrgStr:string;Exs:Keys;col:Byte;ShCol:Byte);

Implementation
 Var
    i,j,cn0,ck0,
    Pg,Count,MS,Ni,Lni,Nd,Lnd,MaxL,MaxBL,x1,y1,x2,y2:Byte;
    c:char;
    Value,
    Base,Wi,
    OldBase,
    OrginBase,
    BaseEnd,
    Posn,
    Tlines,
    LastWin:Word;
    f:Text;
    Rs,BName,New1,New2,Old1,Old2:String[78];
    P:^Safe;
    V,M:Boolean;
    Vm:Safe Absolute $B800:$0000;
    OPos,Lpos:Array[1..112] Of Word;
    Jump:Array[1..112] Of String[80];
{-----------------------------------------}
Procedure PushWin(x1,y1,x2,y2:Byte);
Begin
 Value:=(x2-x1)*(y2-y1)*2;
 GetMem(P,Value);
  For i:=x1 to x2 do
   For j:=y1 to y2 do
    Begin
      p^[j-y1+1,i-x1+1].A:=Vm[j,i].A;
      p^[j-y1+1,i-x1+1].C:=Vm[j,i].C;
    End;
End;
{-------------------------------------------}
Procedure PullWin(x1,y1,x2,y2:Byte);
Begin
  For i:=x1 to x2 do
   For j:=y1 to y2 do
    Begin
      Vm[j,i].A:=p^[j-y1+1,i-x1+1].A;
      Vm[j,i].C:=p^[j-y1+1,i-x1+1].C;
    End;
 FreeMem(P,Value);
End;
{-------------------------------------------}
Procedure PutGroundColor(x,y,Col:Byte);
Begin
  Vm[y,x].A:=(Vm[y,x].A And $0F+Col Shl 4)And $7F;
End;
{--------------------------------------------}
Procedure PutCharColor(x,y,Col:Byte);
Begin
  Vm[y,x].A:=Vm[y,x].A And $F0+Col;
End;
{--------------------------------------}
Procedure PutChar(x,y,Ch:Byte);
Begin
 Vm[y,x].C:=Ch;
End;
{--------------------------------------}
Procedure PutAtr(x,y,BC,CC:Byte);
Begin
  Vm[y,x].A:=(Vm[y,x].A And $0F+BC Shl 4)And $7F;
  Vm[y,x].A:=Vm[y,x].A And $F0+CC;
End;
{-----------------------------------------------}
   Procedure HideCursor;Assembler;
         asm
            mov ah,3
            int 16
            mov cn0,ch
            mov ck0,cl
            mov ah,1
            mov ch,32
            int 16
         end;
{-----------------------------------------------}
   Procedure ShowCursor; Assembler;
         asm
            mov ah,1
            mov ch,cn0
            mov cl,ck0
            int 16
         end;
{-----------------------------------------------}
Procedure FindBase(Var F:Text;B:Word);
 Begin
  Reset(F);
  For Wi:=1 to b do Readln(F);
 End;
{-----------------------------------------------}
Function FindStr(Var F:Text;Str:String):Word;
 Begin
  Reset(F);
  Wi:=1;
  Repeat
    Readln(F,Rs);
    If Pos(Str,Rs)<>0 Then Break;
    Inc(Wi);
  Until Eof(F);
   FindStr:=Wi;
 End;
{-----------------------------------------------}
Function TotalLines(Var F:Text):Word;
 Begin
  Reset(F);
  Wi:=0;
  Repeat
   Readln(F);inc(Wi);
  Until Eof(F);
  TotalLines:=Wi;
 End;
{--------------------------------------------------}
Function MaxyLength(O,E:Word):Byte;
 Var Bi:Byte;
 Begin
  Reset(F);
  Wi:=0;Bi:=1;
  FindBase(F,O);
   For Wi:=O+1 To E-1 Do
    Begin
     Readln(F,Rs);
     if (Pos(BlockJump,Rs)<>0) Then
     Delete(Rs,Pos(BlockJump,Rs),Pos(BlockSeparator,Rs)-Pos(BlockJump,Rs)+4);
     i:=Length(Rs);
     If Bi<i Then Bi:=i;
    End;
  MaxyLength:=Bi;
 End;
{--------------------------------------------------}
 Procedure WrStr(col:Byte);
 Begin
  If i=0 Then Exit;
  TextColor(10);
  TextBackGround(col);
  For j:=1 to i do
   Begin
   If Count+j=MS Then
    Begin
  TextColor(14);
  TextBackGround(4);
    BName:=Jump[j]{Copy(Rs,Opos[j],Lpos[j]-Opos[j])};
    End;
    Gotoxy(Opos[j],Posn);
    Write(Copy(Rs,Opos[j],Lpos[j]-Opos[j]));
   If Count+j=MS Then
    Begin
  TextColor(10);
  TextBackGround(col);
    End;
   End;
  TextColor(15);
  TextBackGround(Col);
 End;
{---------------------------------------}
Procedure DetermCount;
Begin
 Count:=0;Posn:=1;
Repeat
 ReadLn(F,Rs);
  i:=0;
  While (Pos('<#=>',Rs)<>0) Do
        Begin
          Inc(i);
           OPos[i]:=Pos('<#=>',Rs);
           Delete(Rs,OPos[i],4);
           LPos[i]:=Pos('#>',Rs);
           Delete(Rs,LPos[i],2);
        End;
  If i<>0 Then Begin Ni:=i;New2:=Rs End;
  If (i<>0) And (Count=0) Then Begin Nd:=i;New1:=Rs End;
  Inc(Count,i);
  Inc(Posn);
Until Posn=Pg;
End;
{-----------------------------------------------}
Procedure PutHelp(fs,OrgStr:string;Exs:Keys;col:Byte;ShCol:Byte);
 Label 1,2;
  Var bp,ep:byte;
      max:word;
      st:string;
 Begin
 ShCol:=8;
 Assign(F,Fs);
 {$I-}
  Reset(F);
 {$I+}
 If IoResult<>0 Then Exit;
 Tlines:=TotalLines(F);
 LastWin:=TLines;
1:
   OrginBase:=FindStr(F,'<#Begin'+OrgStr);
   BaseEnd:=FindStr(F,'<#End'+OrgStr);
   If OrginBase=BaseEnd Then
    Begin
      OrginBase:=FindStr(F,'<#Begin');
      BaseEnd:=FindStr(F,'<#End');
    End;
   If OrginBase=BaseEnd Then OrginBase:=1;


  FindBase(F,OrginBase-1);
  Readln(F,st);
  if (Pos('<#Begin',st)<>0)
       Then
         Begin
          bp:=Pos('<#Begin',st);
          ep:=Pos('#:',st);
          Delete(st,bp,ep-bp+2);
          st:=Copy(st,bp,Pos('#>',st)-bp);
         End
       else st:='';
  MaxBl:=Length(St)+6;
  max:=MaxyLength(OrginBase,BaseEnd);
  If MaxBl<max Then MaxBL:=max;

  i:=MaxBl;
2:x1:=(80-MaxBl)Div 2;
  X2:=x1+MaxBL+4;
  Pg:=MaxBL Div 4 -2;
  y1:=(25-Pg-2)Div 2;
  Y2:=y1+Pg+2;
If BaseEnd-OrginBase<=Pg Then
         Begin
           Pg:=BaseEnd-OrginBase;
           y1:=(25-Pg)Div 2;
           Y2:=y1+Pg;
           If MaxBl<>i Then
             Begin
              x1:=(80-I)Div 2;
              X2:=x1+I+4;
             End;
         End
         Else
          Begin
           If MaxBl<39 Then
                        Begin
                         MaxBl:=39;
                         Goto 2;
                        End;
          If BaseEnd-OrginBase<=Pg+2 Then
                   Begin
                     Pg:=BaseEnd-OrginBase;
                     y1:=(25-Pg)Div 2;
                     Y2:=y1+Pg;
                     If MaxBl<>i Then
                       Begin
                        x1:=(80-I)Div 2;
                        X2:=x1+I+4;
                       End;
                   End;
          End;
 Dec(LastWin,Pg-1);
 PushWin(x1,y1,x2+2,y2+1);
HideCursor;
textcolor(14);
  TextBackGround(col);
  Window(x1,y1,x2,y2);
  Clrscr;
  Window(1,1,80,25);
  For i:=x1+2 to x2-2 do PutChar(i,y1,205);
  For i:=x1+2 to x2-2 do PutChar(i,y2,205);
  For i:=y1+1 to y2-1 do PutChar(x1+1,i,186);
  For i:=y1+1 to y2-1 do PutChar(x2-1,i,186);
  gotoxy((x2+x1-Length(st))Div 2,y1);Write(st);
  PutChar(x1+1,y1,201);
  PutChar(x2-1,y1,187);
  PutChar(x1+1,y2,200);
  PutChar(x2-1,y2,188);
  For i:=x1+2 to x2+2 do PutAtr(i,y2+1,0,ShCol);
  For j:=x2+1 to x2+2 do
   For i:=y1+1 to y2+1 Do PutAtr(j,i,0,ShCol);
   TextColor(15);
If BaseEnd-OrginBase<>Pg
 Then
  Begin
  For i:=x1+2 to x2-2 do PutChar(i,y2-2,196);
  PutChar(x1+1,y2-2,199);
  PutChar(x2-1,y2-2,182);
   Gotoxy(x1+2,y2-1);
   Write(' Esc-Выход');
   Gotoxy(x2-30,y2-1);
   Write('['+#24+'] ['+#25+'] и PgUp/PgDn-Просмотр');
    Window(X1+2,y1+1,x2-2,y2-3);
  End
  Else  Window(X1+2,y1+1,x2-2,y2-1);

 If OrginBase<BaseEnd-Pg Then LastWin:=BaseEnd-Pg
                           Else LastWin:=OrginBase;
  Base:=OrginBase;OldBase:=Base+1;
   MS:=1;Count:=0;
Repeat
 If V And(c=#80)And(Base<LastWin) Then Inc(Base) else
 If V And(c=#72)And(Base>OrginBase) Then Dec(Base) else
 If c=#81 Then If Base<LastWin-Pg+1 Then Inc(Base,Pg)
                                    Else Base:=LastWin else
 If c=#73 Then If (Base>Pg+OrginBase)
                 Then Dec(Base,Pg)
                 Else Base:=OrginBase   else
 If c=#71 Then Base:=OrginBase else
 If c=#79 Then Base:=LastWin;
If (Base<>OldBase)Or Not V Then
 Begin
 FindBase(F,Base);
 DetermCount;
 If  V And M then If Old2<>New2 then Ms:=Count-Ni+1 Else Ms:=Count;
 If  V And Not M Then If Old1<>New1 Then Ms:=Nd Else Ms:=1;
 Old1:=New1;Old2:=New2;
 FindBase(F,Base);
 posn:=1;Count:=0;
Repeat
 ReadLn(F,Rs);Gotoxy(1,Posn);
  i:=0;
  While (Pos('<#=>',Rs)<>0) Do
        Begin
          Inc(i);
           OPos[i]:=Pos('<#=>',Rs);
           LPos[i]:=Pos('#:',Rs);
           Jump[i]:=copy(Rs,OPos[i]+4,LPos[i]-OPos[i]-4);
           Delete(Rs,OPos[i],LPos[i]-OPos[i]+2);
           LPos[i]:=Pos('#>',Rs);
           Delete(Rs,LPos[i],2);
        End;
 If Base+Posn<BaseEnd
    Then Begin Write(Rs);ClrEol;End;
  WrStr(col);
  Inc(Count,i);
  Inc(Posn);
Until Posn=Pg;
 End;
 OldBase:=Base;
c:=readkey;While keypressed Do c:=readkey;

If (c=#13) And (Count<>0) Then
                Begin
        OrgStr:=BName;
        window(1,1,80,25);
        PullWin(x1,y1,x2+2,y2+1);
              Goto 1;
                End;
If (c=#80)Then
 If (Ms<Count)Then Begin Inc(MS);V:=False End
              Else Begin M:=True;V:=True End
          Else
If (c=#72) And (Ms>1) Then Begin Dec(MS);V:=False; End
                      Else Begin M:=False;V:=True End;
Until c in Exs;
window(1,1,80,25);
PullWin(x1,y1,x2+2,y2+1);
ShowCursor;
Close(F);
 End;
 {-------------------------------------------------}
End.
