{$O+}
{$F+}
UNIT PLACE;
 Interface
  Uses Memory,Crt,Graph,Vision;
  Var
     QuanTrac,
     MaxKorteg,
     MinKorteg,
     secmin,
     secmax,
     NumberOfSec :word;
  {--------------------------}
 Procedure CompactPlacing;
  {--------------------------}
  IMPLEMENTATION
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
{---------------------------------}
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
 if Random(7)>3 then
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
{------------------------------------------}
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
ShowMessage('Executing Initial AutoPlacement.'+
   ' Edition Is not Allowed.Wait Or Stoped Process.');
   kortmas;
     y:=0;
     MaxPlateY:=sizeofpl*dy;
     x:=0;
     MaxPlateX:=sizeofpl*dx;
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
{                    DirectVideo:=False;
                    Gotoxy(60,5);
                    Write('Element: #',t);
                    readln;
                    DirectVideo:=True;}
                    PutToScreen(13,15,t);
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
{                DirectVideo:=False;
                    Gotoxy(50,5);
           If Elemname(t)='' then Begin Writeln('Element: #',t);readln;End;
           If Elemname(j)='' then Begin Writeln('Element: #',j);readln;End;
                    DirectVideo:=True;}
                   End;;;
              If keypressed Then If readkey=' ' Then exit;
       Until AllPlacedInSec;
       ClearSec;
              If keypressed Then If readkey=' ' Then exit;
   Until AllPlaced(i);
              If keypressed Then If readkey=' ' Then exit;
 Until I=NumberOfSec;
 For i:=1 to NumberOfElem Do
  puttoscreen(9,15,i);
 PlacingOver:=True;
 ScreenIsDust:=true;
ShowMessage('Interactive Mode...');
End;
END.