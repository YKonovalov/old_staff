
 PROGRAM RPL;
 Uses Control,Vision,Disk,Memory,Menus,
      Dos,Crt,Graph;
 procedure trip; external;
 {$L trip.obj}
 procedure litt; external;
 {$L litt.obj}
 procedure EgaVga; external;
 {$L EgaVga.obj}
 Var
    SaveOldVec:procedure;
     QuanTrac,
     MaxKorteg,
     MinKorteg,
     secmin,
     secmax,
     NumberOfSec,
     i,j,mn,h    :word;
     k           :byte;
     ch          :char;
     st          :likename;
     sm          :string[79];
     PC_Mode :Boolean;
{-------------------------------------------}
 Procedure ChangeMousePos;
   Var Control,j,i,P:Byte;
       X,Y:Word;
  Begin
   Control:=Port[$60];
   FlowerNumber:=Control;
    Case Control Of
    1:LastPress:=1;
    76:LastPress:=2;
   Else LastPress:=0;
    End;
 If (Control in [72,75,77,80])And Not Caps_Lock And Not Alt And Not Ctrl
  Then
   Begin
     i:=1;
     x:=FlowX;
     y:=FlowY;
      Case Control Of
       75,77: j:=FlowDx;
       80,72: J:=FlowDy;
       End;
    While (Port[$60]=Control)And
      ((Not PC_Mode And(i<Lx))Or(PC_Mode And(i<J))) do
     Begin
        p:=Port[$60];
         Inline($FA);
      If (p=75) And (FlowX-FlowDx>=0) Then Dec(X)
       Else
      If (p=77) And (FlowX+flowDx<=Lx) Then Inc(X)
       Else
      If (p=80) And (FlowY+FlowDy<=Ly) Then Inc(Y)
       Else
      If (p=72) And (FlowY-FlowDy>=0) Then Dec(Y);
         Inline($FB);
          SetPos(X,Y);
          DELAY(5);
        Inc(i);
     End;
   End;
 End;
{-------------------------------------------}
   {$F+}
  Procedure MyInt_9;InterRupt;
   Var c,Ch:char;s:string;
   Begin
    ChangeMousePos;
    Inline($9C);
    saveOldVec;
   End;
   {$F-}
{--------------------------------------------}
  Procedure Swap9Int;
   Begin
    GetIntVec($9,@SaveOldVec);
    SetIntVec($9,Addr(MyInt_9));
   End;
{--------------------------------------------}
  Procedure Restore9Int;
   Begin
    SetIntVec($9,@SaveOldVec);
   End;
{<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>}
 Function NotCont(ne:word):boolean;
 Begin
    if pos('^',ElemName(ne))=0 then
     begin
      NotCont:=true;
      exit
     end;
  NotCont:=false;
 End;
{------------------------------------}
Function FindElInChain(ne,nc:word):boolean;
 Var
   q,i:word;
 Begin
  q:=QuanElInChain(nc);
  For i:=1 to q do
   if Elemnumber(nc,i)=ne
    then
     begin
      FindElInChain:=true;
      Exit
     End;
  FindElInChain:=false;
 End;
{------------------------------------}
 Procedure FindElemAmountTrac(ne,q:word);
 Var
    i,j,e,g:word;
    ur,f,r:real;
 Begin
     ur:=0;
    For i:=1 to NumberOfChain do
     Begin
       r:=0;
       f:=ChainTrac(i);
       g:=QuanElInChain(i);
      If FindElInChain(ne,i)
       Then
        Begin
         For j:=1 to g do
          Begin
           e:=ElemNumber(i,j);
           r:=r+Znak(e)*f;
          End;
         ur:=ur+r;
        End;
     End;
   PutElemAmountTrac(ne,q,ur);
 End;
{------------------------------------}
Procedure ChangeZnakMode(g:boolean);
 Var
   i:word;
   v,b:boolean;
 Begin
  For i:=1 to NumberOfElem do
   Begin
    If g Then
           Begin
            v:=Pos('^1',ElemName(i))<>0;
            b:=Pos('^4',ElemName(i))<>0
           End
         Else
           Begin
            v:=Pos('^2',ElemName(i))<>0;
            b:=Pos('^3',ElemName(i))<>0
           End;
    if v Then
           PutZnak(i,'+')
         Else
           If b Then
                  PutZnak(i,'-')
                Else
                  PutZnak(i,'^');
   End;
 End;
{---------------------------}
Function BallToSec(ne:word):boolean;
 Begin
 if (korteg(ne)>=secmin)and(korteg(ne)<=secmax)
  Then BallToSec:=true
  Else ballToSec:=false;
 End;
{---------------------------}
Procedure CreateTracMas;
 Var
  i,j,k,g,q,en:word;
  {=========================}
  Function GetPast(ne,q:word):boolean;
  Var i:word;
  Begin
   if q<>0 then
   for i:=1 to q do
   if tracsatil(i)=ne
    then
     Begin
     getpast:=false;
     exit
     End;
   getpast:=true;
  End;
  {===========================}
 Begin
  q:=0;
  For i:=1 to NumberOfElem do
   Begin
    If Znak(i)<>0
     Then
      For k:=1 to NumberOfChain do
       If FindElInChain(i,k)
        Then
         Begin
          g:=QuanElInChain(k);
          for j:=1 to g do
           Begin
           en:=ElemNumber(k,j);
           if (en<>i)and
           NotCont(en)
           and GetPast(en,q)
           and BallToSec(en)
           and (znak(en)=0)
            Then
             Begin
              inc(q);
              FindElemAmountTrac(ElemNumber(k,j),q);
{  writeln(tracSatil(q),' <><><>  ',elemamounttrac(q));
              readln; }
             End;
           End;
         End;
   End;
  QuanTrac:=q;
 End;
{------------------------------------}
 Function Duble(name:likeName;nc,nkom:word):boolean;
 var i:word;
 Begin
   For i:=nkom-1 downto 1 do
    If name=elemname(elemNumber(nc,i))
     then
      Begin
       Duble:=true;exit
      End;
   Duble:=false;
 End;
{----------------------------------}
 Procedure Und(name:likeName;ne:word;var n:word);
 Var i:word;
 Begin
  If ne=1 then Begin n:=0;Exit End;
  For i:=ne-1 Downto 1 do
   if name=elemName(i)
    then
     Begin
      n:=i;Exit
     End;
  n:=0;
 End;
{-------------------------------------------------------------------}
Procedure Kortmas;
      Var K,n,i:word;
Begin
       K:=1;
       i:=0;
       n:=sqr(SizeOfPl);
    Repeat
           inc(i);
            Putsec(1,i,k);
            Putsec(2,i,k-1+n);
        IF sec(2,i)>=sqr(SizeOfPl)
         then
           begin
            K:=1;
            n:=n DIV 2;
           end
         else K:=K+n;
    Until n<=1;
    NumberOfSec:=i;
End;
{-----------------------------------------}
PROCEDURE Sort (VAR min,max:word);
  VAR I,K,FL,r2:word;r1:real;
BEGIN
If QuanTrac=1 then
 if ElemAmountTrac(1)>0 then
     Begin
      min:=tracsatil(1);
      max:=0;exit
     End
                        else
     Begin
      max:=tracsatil(1);
      min:=0;exit
     End;;
       K:=1;
    Repeat
                FL:=0;
         For I:=Quantrac DownTo 2 do
            IF (ElemAmountTrac(I)>ElemAmountTrac(I-1))
             Then
              Begin
            R1:=ElemAmountTrac(I);
            R2:=TracSatil(i);
            PutElemAmountTrac(TracSatil(I-1),i,ElemAmountTrac(I-1));
            PutElemAmountTrac(r2,i-1,r1);
            FL:=1;
              End;
        Inc(k)
    Until (k>QuanTrac-1)Or(Fl=0);
   min:=TracSatil(1);
   max:=TracSatil(QuanTrac);
END;
{----------------------------------------}
   procedure Readbyte(x,y:integer;var j:byte);
   var
      e:integer;
      s:string[3];
      h:integer;
   begin
    repeat
     gotoxy(x,y);
     clreol;
     readln(s);
     val(s,h,e);
    until (e=0)and(h>0)and(h<200);
    j:=h;
    gotoxy(x+length(s)+2,y);
    clreol;
   end;
{---------------------------------}
 Procedure EnterCir;
 Label 1;
 Var
    i,j,k,n:word;
    rc:string;
    h,by:byte;
    c:char;
    d:likeName;
    b,v:boolean;
Begin
restorecrtMode;
textbackGround(0);
 c:='?';
 i:=1;j:=1;
 randomize;
 While c<>#27 do
  Begin
     Textcolor(random(6)+1);
   Repeat
     v:=true;
    GoToxy(1,1);clreol;
    Writeln('введите кол-во :');
    readbyte(17,1,h); k:=h;
     PutQuanElInChain(i,k);Delline;
    Write('Вводите ',i:2,'-ую цепь : ');
    c:=readkey;
    If c=#27 then v:=true
             else
     Begin
      readln(rc);
      If (pos('(',rc)>=2)and(pos(',',rc)>=4)and
         (pos(')',rc)>=6)and(pos(',',rc)<pos(')',rc))and
         (pos('(',rc)<pos(')',rc))and
         (pos('(',rc)<pos(',',rc))
       then
        Begin
         PutChainName(i,copy(rc,1,pos('(',rc)-1));
         d:=copy(rc,pos('(',rc)+1,pos(',',rc)-pos('(',rc)-1);
         Und(d,j,n);
         if n=0 then
                 Begin
                  PutElemName(j,d);
                  n:=j;
                  inc(j)
                 End;
         PutElemNumber(i,1,n);
         rc:=Copy(rc,pos(',',rc)+1,pos(')',rc)-pos(',',rc));
         k:=2;
         While pos(',',rc)<>0 do
          Begin
           d:=copy(rc,1,pos(',',rc)-1);
           If Duble(d,i,k) then
            Begin
             V:=false;
             GoTo 1
            End;
           Und(d,j,n);
           if n=0 then
                   Begin
                    PutElemName(j,d);
                    n:=j;
                    inc(j)
                   End;
           PutElemNumber(i,k,n);
           rc:=Copy(rc,pos(',',rc)+1,pos(')',rc)-pos(',',rc));
           inc(k);
          End;
          d:=copy(rc,1,pos(')',rc)-1);
          If Duble(d,i,k) then
           Begin
            V:=false;
            GoTo 1
           End;
          Und(d,j,n);
          if n=0 then
                  Begin
                   PutElemName(j,d);
                 n:=j;
                   inc(j)
                  End;
          PutElemNumber(i,k,n);
         End
        else v:=false;
     End;
1: Until v;
   inc(i)
  End;
  NumberOfChain:=i-2;
  NumberOfElem:=j-1;
   GoToxy(1,1);
   textcolor(10);
    Writeln('Имена элементов :');
   For i:=1 to NumberOfElem do
    Begin
    write(ElemName(i),':::> ');
    textcolor(random(6)+1);
    If not NotCont(i) then
     begin
      Writeln('   <===-Это контакт');
      putGab(1,i,0);
      putgab(2,i,0);
    end
                   else
     begin
      write('    Укажите габариты этого элемента {a,b} :');
      readbyte(wherex,wherey,by);
      putGab(1,i,by);
      readByte(wherex,wherey,by);
      putGab(2,i,by);
      writeln;
     end;
   End;
setgraphmode(getgraphmode);
   h:=1;
End;
{----------------------------------}
Procedure ClearSec;
 Var i:word;
 Begin
  for i:=1 to NumberOfElem do
   if NotCont(i) and (Znak(i)<>0) then PutZnak(i,'^');
 End;
{----------------------------------}
Function AllPlaced(i:word):boolean;
 Begin
  if (sec(2,i+1)-sec(1,i+1))<>(Sec(2,i)-Sec(1,i))
   Then AllPlaced:=true
   Else AllPlaced:=false;
  if i=numberofsec then Allplaced:=true
 End;
{-----------------------------------}
Function AllPlacedInSec:boolean;
 Var i:word;
Begin
  For i:=1 To NumberOfElem do
   if NotCont(i) and BallToSec(i)
    Then
     if Znak(i)=0 then
      Begin
       AllPlacedInSec:=false;
       Exit
      End;
  AllPlacedInSec:=True;
End;
{-----------------------------------}
Procedure ShowZnak;
Var i:word;
Begin
 for i:=1 to NumberOfElem do
 Writeln(ElemName(i),':::::> ',Znak(i));
End;
{---------------------------------}
Procedure ChangeZnak;
Var
 i,g,q:word;
 r:integer;
Begin
 If secmax-secmin=3 then
  Begin
   for i:=1 to NumberOfElem do
    if NotCont(i) and Not BallToSec(i)
     Then
      Begin
       r:=korteg(i);
       g:=(((sqr(sizeofpl)-secmax) div 4 ) mod (sizeofpl div 2))*4;
       q:=((secmin div 4) mod (sizeofpl div 2))*4;
       If (r>SecMax+g)
        Then PutZnak(i,'-')
        Else If r<SecMin-q then PutZnak(i,'+')
                           Else
                  If (r<Secmin)
                   Then
                  if ((SecMin-r) mod 4=0) or ((SecMin-r+1) mod 4=0)
                    Then PutZnak(i,'+')
                    Else PutZnak(i,'-');

      End;
  End;
End;
{---------------------------------}
Function QuanElInSec:boolean;
Var i,j:word;
Begin
j:=0;
    For i:=1 to NumberOfElem do
    if BallToSec(i) Then
    Begin
     inc(j);
      If j>1 then Begin
                 QuanElInSec:=True;
                 Exit
                  end;
    End;
QuanElInSec:=False;
End;
{--------------------------------}
Procedure ClearScrSec;
Var i:word;
Begin
 for i:=1 to NumberOfElem do
 If ballToSec(i) then PutToScreen(0,0,i);
End;
{---------------------------------}
 Procedure CompactPlacing;
 Var
   i,t,j:word;
   k,h:byte;
   c:char;
   v:boolean;
   s:string[20];
   st:likename;
 Begin
If not BeginPlaceCode Or PlacingOver Then Exit;
   kortmas;
     y:=0;
     my:=sizeofpl*dy;
     x:=0;
     mx:=sizeofpl*dx;
for i:=1 to numberofelem do
 if  notcont(i) then putkorteg(i,1)
                else putkorteg(i,0);
   i:=0;v:=true;
 Repeat
   ChangeZnakMode(v);
   v:=not v;
   Repeat
       Inc(i);
       SecMin:=Sec(1,i);
       SecMax:=Sec(2,i);
       MaxKorteg:=SecMax+1;
       MinKorteg:=SecMin-1;
       ClearScrSec;
    If QuanElInSec
      Then
       Repeat
          Changeznak;
          CreateTracMas;
          sort(t,j);
      if (t<>0)or(j<>0)
       Then
        IF j=0 then
                   Begin
                    inc(MinKorteg);
                    putkorteg(t,minkorteg);
                    Putznak(t,'+');
                    PutToScreen(13,15,t)
                   End
                 Else
           if t=0 then
                   Begin
                    Dec(MaxKorteg);
                    putkorteg(j,maxkorteg);
                    Putznak(j,'-');
                    PutToScreen(13,15,j)
                   End
                  else
                   Begin
                     Inc(Minkorteg);
                     Dec(MaxKorteg);
                     putkorteg(t,Minkorteg);
                     putKorteg(j,MaxKorteg);
                     putznak(t,'+');
                     putZnak(j,'-');
                     puttoscreen(3,14,t);
                     puttoscreen(3,14,j);
                   End;;;
{                         getpos(i,j,mn);
                      If keyPressed Then ch:=readKey;
                      While KeyPressed Do ch:=ReadKey;
                       c:=ch;
                      if (mn=right)Or(ch=#27)
                          then menu(not vm,i,j,ch)
                          else
                      If ((mn=left)Or(ch=#13))
                         and not vm then menu(false,xm,ym,CH);}
       Until AllPlacedInSec;
       ClearSec;
   Until AllPlaced(i);
 Until I=NumberOfSec;
 For i:=1 to NumberOfElem Do
  puttoscreen(9,15,i);
 PlacingOver:=True;
 ScreenIsDust:=true;
End;
{----------------=========------------}
BEGIN
   Case Mem[$F000:$FFFE] Of
     $FF,$F9,$FD: PC_Mode:=True;
     $FE,$FC: PC_Mode:=False;
     Else Begin
           Writeln('Good Lack...... Find Another Computer !!');
           Halt;
          End;
    End;
  If registerBgiFont (@trip)<0 then halt;
  If registerBgiFont (@litt)<0 then Halt;
  If registerBgiDriver (@EgaVga)<0 then Halt;
  InitVision;
  Swap9Int;
  Show;
  clb;
  hide;
  PutEdit;
  show;
  Vmenu(1,1);
  hide;
  show;
Repeat
  ch:='k';
   If KeyPressed Then c:=readkey;
   While KeyPressed Do c:=readkey;
    getpos(i,j,mn);
 if mn=right then menu(True,not vm,i,j,ch)
     else
 If mn=left  then menu(False,false,xm,ym,CH);
 If (ch='P')And BeginPlaceCode Then CompactPlacing;
 If c in ['L','R','I','F','E','D','O',' ',
          'l','r','i','f','e','d','o'] Then VMenu(1,NumberL(c));
  mn:=center;
Until ch='q';
  DoneVision;
  Restore9Int;
End.


