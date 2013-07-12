PROGRAM RPL;
 Uses Mouse_u,Crt,Dos,Graph;
 procedure trip; external;
 {$L trip.obj}
 Const
      pic:fillpatterntype=
      ($49,$92,$49,$92,$49,$92,$49,$92);
      pic1:fillpatterntype=
      ($55,$55,$55,$55,$55,$55,$55,$55);
      Pic2:Fillpatterntype=
      ($49,$55,$49,$55,$49,$55,$49,$55);
 Type
      likename=string[12];

 Var
     NumberOfChain,
     NumberOfElem,
     QuanTrac,
     SizeOfPl,
     SizeOfRad,
     MaxKorteg,
     MinKorteg,
     Lx,Ly,
     Uy,Ux,
     Sx,Sy,
     Dmx,Dmy,
     Qx,Qy,
     Xm,Ym,
     secmin,
     secmax,
     M,N,
     NumberOfSec,
     Seg0,Ofs0,
     SegT,OfsT,
     i             :word;
     pn:^likename;
     p:^word;
     pc:^char;
     pq:^byte;
     pr:^real;
     ch,c:char;
     Scale,
     h,k,LitY :byte;
     st:likename;
     dx,dy,x,y,mx,my:integer;
     stp:array[1..1]Of likename;
     Vm:boolean;
{---------------------------------}
 Procedure Begining;
 Begin
   If Ofs(HeapPtr^)<>0 then i:=16
                       else i:=0;
   Seg0:=seg(HeapPtr^)+i;
   Ofs0:=0;
 End;
 {-----------------------------------}
 Procedure PutQuanElInChain(nc,qe:word);
 Begin
   p:=ptr(Seg0+16*(nc+5),Ofs0+1);
   new(p);
   dispose(p);
   p:=ptr(Seg0+16*(nc+5),Ofs0+1);
   p^:=qe;
 End;
 {---------------------------------}
 Procedure PutElemNumber(nc,nkom,ne:word);
 Begin
   p:=ptr(Seg0+16*(nc+5),Ofs0+sizeof(word)*(1+nkom));
   new(p);
   dispose(p);
   p:=ptr(Seg0+16*(nc+5),Ofs0+sizeof(word)*(1+nkom));
   p^:=ne;
 End;
{------------------------------------}
 Procedure PutGab(x:byte;ne:word;gb:byte);
 Begin
 If x=1 then
  begin
   pq:=ptr(seg0+64,Ofs0+sizeof(byte)*ne);
   new(pq);
   dispose(pq);
   pq:=ptr(seg0+64,Ofs0+sizeof(byte)*ne);
  End
       else
  begin
   pq:=ptr(seg0+80,Ofs0+sizeof(byte)*ne);
   new(pq);
   dispose(pq);
   pq:=ptr(seg0+80,Ofs0+sizeof(byte)*ne);
  end;
   pq^:=Gb;
 End;
{------------------------------------}
 Procedure PutZnak(ne:word;ch:char);
 Begin
   pc:=ptr(Seg0+48,Ofs0+sizeof(char)*ne);
   new(pc);
   dispose(pc);
   pc:=ptr(Seg0+48,Ofs0+sizeof(char)*ne);
   pc^:=ch;
 End;
{------------------------------------}
 Procedure PutKorteg(ne,kort:word);
 Begin
   p:=ptr(Seg0+32,Ofs0+sizeof(word)*ne);
   new(p);
   dispose(p);
   p:=ptr(Seg0+32,Ofs0+sizeof(word)*ne);
   p^:=kort;
 End;
{------------------------------------}
 Procedure PutElemName(ne:word;name:likename);
 Begin
   pn:=ptr(Seg0+16,Ofs0+sizeof(likename)*ne);
   new(pn);
   dispose(pn);
   pn:=ptr(Seg0+16,Ofs0+sizeof(likename)*ne);
   pn^:=name;
 End;
{------------------------------------}
 Procedure PutChainName(nc:word;name:likename);
 Begin
   pn:=ptr(Seg0,Ofs0+sizeof(likename)*nc);
   new(pn);
   dispose(pn);
   pn:=ptr(Seg0,Ofs0+sizeof(likename)*nc);
   pn^:=name;
 End;
{------------------------------------}
 Procedure PutSec(q:byte;kom,sec:word);
 Begin
   p:=ptr(Seg0+16*(NumberOfChain+5+q),Ofs0+sizeof(word)*kom);
   new(p);
   dispose(p);
   p:=ptr(Seg0+16*(NumberOfChain+5+q),Ofs0+sizeof(word)*kom);
   p^:=sec;
 End;
{------------------------------------}
 Function Sec(q:byte;kom:word):word;
 Begin
   p:=ptr(Seg0+16*(NumberOfChain+5+q),Ofs0+sizeof(word)*kom);
   Sec:=p^;
 End;
{------------------------------------}
 Function ElemNumber(nc,nkom:word):word;
 Begin
   p:=ptr(Seg0+16*(nc+5),Ofs0+sizeof(word)*(1+nkom));
   ElemNumber:=p^;
 End;
{------------------------------------}
 Function QuanElInChain(nc:word):word;
 Begin
    p:=ptr(Seg0+16*(nc+5),Ofs0+1);
    QuanElInChain:=p^;
 End;
{------------------------------------}
 Function ElemZnak(ne:word):integer;
 Begin
   pc:=ptr(Seg0+48,Ofs0+sizeof(char)*ne);
   case pc^ of
   '+':ElemZnak:=1;
   '-':ElemZnak:=-1;
   '^':ElemZnak:=0;
   end;
 End;
{------------------------------------}
 Function Gab(x:byte;ne:word):word;
 Begin
 if x=1 then pq:=ptr(seg0+64,Ofs0+sizeof(byte)*ne)
        else pq:=ptr(seg0+80,Ofs0+sizeof(byte)*ne);
   Gab:=pq^;
 End;
{------------------------------------}
 Function ElemKorteg(ne:word):word;
 Begin
   p:=ptr(Seg0+32,Ofs0+sizeof(word)*ne);
   ElemKorteg:=p^;
 End;
{------------------------------------}
 Function ChainName(nc:word):likeName;
 Begin
   pn:=ptr(Seg0,Ofs0+sizeof(likename)*nc);
   ChainName:=pn^;
 End;
{------------------------------------}
 Function ElemName(ne:word):likeName;
 Begin
   pn:=ptr(Seg0+16,Ofs0+sizeof(likename)*ne);
   ElemName:=pn^;
 End;
{------------------------------------}
 Function ChainTrac(nc:word):real;
 Begin
   ChainTrac:=1/QuanElInChain(nc);
 End;
{------------------------------------}
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
 Procedure RadSize;
 Var
    s,s1,s2:word;
  function Find(s:word):word;
  Var
     i:byte;
     m:real;
  begin
     i:=1;
     repeat
      m:=exp(2*ln(exp(i*ln(2))));
      if m>=s
       then begin Find:=round(m);Exit end;
      inc(i)
     until m>s;
  end;
 Begin
     s:=0;
    for s1:=1 to NumberOfElem do s:=s{+sq(s1)};
    s1:=round(s*100/70);
    s1:=find(s1);
    SizeOfRad:=round(exp(0.5*ln(s1)));
    s1:=find(numberofelem);
    SizeOfPl:=round(exp(0.5*ln(s1)));
 End;
{------------------------------------}
 Function ElemAmountTrac(q:word):real;
 Begin
   pr:=ptr(Seg0+16*(NumberOfChain+8),Ofs0+sizeof(real)*q);
  ElemAmountTrac:=pr^;
 End;
{------------------------------------}
 Procedure PutElemAmountTrac(ne,q:word;ur:real);
  Begin
   pr:=ptr(Seg0+16*(NumberOfChain+8),Ofs0+sizeof(real)*q);
   new(pr);
   dispose(pr);
   pr:=ptr(Seg0+16*(NumberOfChain+8),Ofs0+sizeof(real)*q);
   pr^:=ur;
   p:=ptr(Seg0+16*(NumberOfChain+9),Ofs0+sizeof(word)*q);
   new(p);
   dispose(p);
   p:=ptr(Seg0+16*(NumberOfChain+9),Ofs0+sizeof(word)*q);
   p^:=ne;
  End;
{---------------------------}
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
           r:=r+ElemZnak(e)*f;
          End;
         ur:=ur+r;
        End;
     End;
   PutElemAmountTrac(ne,q,ur);
 End;
{------------------------------------}
Function TracSatil(q:word):word;
 Begin
    p:=ptr(Seg0+16*(NumberOfChain+9),Ofs0+sizeof(word)*q);
    TracSatil:=p^;
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
 if (elemkorteg(ne)>=secmin)and(elemkorteg(ne)<=secmax)
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
    If ElemZnak(i)<>0
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
           and (elemznak(en)=0)
            Then
             Begin
              inc(q);
              FindElemAmountTrac(ElemNumber(k,j),q);
{        writeln(elemname(elemnumber(k,j)),'        ',elemamounttrac(q));
              readln;}
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
{----------------------------------}
Procedure PutToScreen(cf,cb:byte;ne:word);
Var x1,y1:word;
 Procedure Koord (kr:word;Var x1,y1:word);
  Var
   i:word;
   q,g,v,b:boolean;
   k,l:integer;
  Begin
    x1:=1;y1:=0;
    for i:=1 to kr do
    Begin
     q:= i<>1;
     g:=((i-1) mod (2*sizeofpl)=0)and q;
     b:=((i-1) mod 4=0)and q;
     v:=((i-1) mod 2=0)and q;
    if g  then begin k:=-sizeofpl+1;l:=1 end
     else
     if b then begin k:=1;l:=-1 end
      else
       if v then
             begin k:=-1;l:=1 end
            else
             begin k:=1;l:=0 end;
     x1:=x1+l;
     y1:=y1+k
    End;
     x1:=x1*dx+x-dx div 2;
     y1:=y+(sizeofpl-y1+1)*dy-dy div 2;
  End;
  {=====-----======}
Begin
if elemkorteg(ne)=0 then exit;
  koord(elemkorteg(ne),x1,y1);
  setfillstyle(1,cf);
  bar(x1-dx div 2+1,y1-dy div 2+1,
      x1+dx div 2-2,y1+dy div 2-1);
  setcolor(cb);
  settextstyle(smallfont,0,2);
  outtextxy(x1-textwidth(elemname(ne)) div 2,y1-2,elemname(ne));
  settextstyle(triplexfont,0,1);
End;
{------------------------------------}
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
{---------------------------------------------}
   Function fn(c,xv,mx,v:word):word;
   Begin
   if c=1 then begin x:=0; repeat x:=x+v until x>=xv end
          else begin x:=mx;repeat x:=x-v until x<=xv end;
    fn:=x;
   End;
{----------------------------------------------}
Procedure Restore(xv,yv,xv1,yv1,cp:word);
Var
   i,d,b,j,x,y,x1,y1:word;
Begin
 setviewport(xv,yv,xv1,yv1,true);
 clearviewport;
 setviewport(0,0,lx,ly,true);
 x:=fn(1,xv,0,dx);
 y:=fn(1,yv,0,dy);
 x1:=fn(2,xv1,n*dx,dx);
 y1:=fn(2,yv1,m*dy,dy);
 d:=(x1-x) div dx;
 b:=(y1-y) div dy;
 For i:=0 to d do
  for j:=0 to b do
   Putpixel (x+i*dx,y+dy*j,cp);
End;
{------------------------------------------------}
procedure spfil(var i:byte);
var dirinfo:SearchRec;
begin
findfirst('*.dat',anyfile,dirinfo);
if DosError<>0 then begin i:=0;exit end;
i:=0;
while DosError=0 do
begin
   inc(i);
   stp[i]:=dirinfo.name;
   findnext(dirinfo)
end;
end;{the end of spfil}
{----------------------------------------------------------}
Procedure chos(k:integer;var st:likename;var h:byte;cp:word);
Label 1;
Var r:real;pg,n,dg,i,dx,x,y,j,lg,l:integer;
v:boolean;
c:char;
begin
  settextstyle(0,0,1);
  settextjustify(0,2);
   pg:=26*lx div 40;
   dg:=26*ly div 40;
   dx:=pg div 4;
   setfillstyle(1,1);
   bar(lx div 10,ly div 10,3*lx div 4,3*ly div 4);
   setviewport(lx div 10,ly div 10,
   3*lx div 4,3*ly div 4,false);
   setcolor(15);
    y:=textheight('l')+2;
   outtextxy(pg DIV 5,1,'S E L E C T  F I L E  N A M E :');
   for i:=1 to 3 do line(dx*i,dg,dx*i,y);
   line(0,y,pg,y);
     x:=0;y:=0;
     lg:=dg div (2*textheight('k'))-1;
   for j:=1 to k do
   begin
     if ((j-1) mod lg=0)and (j<>1) then begin x:=x+dx;y:=0 end;
      y:=y+2*textheight('l');
      if j=h then setcolor(2) else setcolor(15);
      outtextxy(x+3,y,stp[j]);
   end;   l:=h;c:='L';j:=h;x:=0;y:=0;i:=k;
  while (c<>#13)and(c<>' ') do
  begin
   c:=readkey;
   while keypressed do c:=readkey;
   if c=#80 then if j+1<=i then
                begin inc(j);k:=-1 end else
   else
   if c=#72 then if j-1>=1 then
                begin dec(j);k:= 1 end else;
 {  if c=#27 then begin v:=false;goto 1 end;}
   n:=l;
   l:=j-lg*((j-1) div lg);
   setcolor(15);
   if n<>l then
      outtextxy(x+3,y+2*textheight('l')*n,stp[j+k]);
      if (((j mod lg=0) and (k=1))
      or (((j-1) mod lg =0) and (k=-1))) and not((j=i)and(l=n))
       then x:=x-k*dx;
   setcolor(2);
      outtextxy(x+3,y+2*textheight('l')*l,stp[j]);
  end;
1: setviewport(0,0,lx,ly,true);
  st:=stp[j];
  h:=j;
  settextstyle(triplexfont,0,1);
  settextjustify(1,1);
 Restore(lx div 10,ly div 10,3*lx div 4,3*ly div 4,cp);
end;{the end of chos}
{----------------------------------}
Procedure PutRec;
Var
   x1,y1,k:integer;
Begin
     setgraphmode(getgraphmode);
     setlinestyle(0,0,1);
     cleardevice;
     setcolor(9);
     setwritemode(0);
     y:=ly div 20;
     my:=getmaxy-y;
     x:=(getmaxx div 16)*3;
     mx:=x+10*getmaxx div 16;
     dx:=(mx-x) div sizeofpl;
     dy:=(my-y) div sizeofpl;
     my:=my-(my-y) mod sizeofpl;
     mx:=mx-(mx-x) mod sizeofpl;
     x1:=x;y1:=y;
     setcolor(10);
     for k:=1 to sizeofpl+1 do
   begin
       setlinestyle(0,0,1);
       line (x,y1,mx,y1);
       y1:=y1+dy;
       setlinestyle(0,0,3);
       line(x1,y,x1,my);
       x1:=x1+dx
   end;
End;
   {===========================}
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
   {=============================}
Procedure WriteToFile( s:likename);
Var
 f:file;
 i,j,g,k:word;
Begin
 {$I-}
 assign(f,'nonane.dat');
 rewrite(f,1);
 {$I+}
 seek(f,0);
 c:='b';
 blockwrite(f,c,1);
 blockwrite(f,numberOfElem,2);
for i:=1 to NumberOfElem do
 Begin
  s:=elemname(i);
  j:=length(s);
  blockwrite(f,s,j+1);
  j:=Gab(1,i);
  blockwrite(f,j,1);
  j:=Gab(2,j);
  blockwrite(f,j,1)
 End;
  blockwrite(f,NumberOfChain,2);
for i:=1 to NumberOfChain do
 Begin
   k:=QuanElInChain(i);
   blockwrite(f,k,2);
        s:=chainname(i);
        j:=length(s);
     blockwrite(f,s,j+1);
   For j:=1 to k do
   begin g:=ElemNumber(i,j);
   blockwrite(f,g,2);
   end;
 End;
 close(f);
End;
{----------------------------------}
Procedure Worning(x,y:byte;s:string);
Var j:byte;
Begin
 DirectVideo:=false;
 clrscr;
 repeat
 j:=random(35)+1;
 gotoxy(x+j-1,y);
 textcolor(random(15)+1);
 If j<=length(s) then write(s[j]);
 Until keypressed;
End;
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
          PutQuanElInChain(i,k);
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
   spfil(by);
   if by=0 then
            begin
            worning (35,13,'File !.dat Is not Exist');
            exit;
            End;
setgraphmode(getgraphmode);
   h:=1;
   chos(by,d,h,15);
   WriteToFile(d);
End;
{----------------------------------}
Procedure ClearSec;
 Var i:word;
 Begin
  for i:=1 to NumberOfElem do
   if NotCont(i) and (ElemZnak(i)<>0) then PutZnak(i,'^');
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
     if ElemZnak(i)=0 then
      Begin
       AllPlacedInSec:=false;
       Exit
      End;
  AllPlacedInSec:=True;
End;
{-----------------------------------}
Procedure ReadFile(var s:likename);
Var
 f:file;
 i,j,b,k,l:word;
 ncr:char;
Begin
assign(f,s);
{$I-}
reset(f,1);
{$I+}
if IOResult=0
 then
  begin
  j:=0;
    seek(f,0);
    blockread(f,c,1);
    blockread(f,ncr,1);seek(f,filepos(f)-1);
    if (c<>'b')or(ncr=' ') then begin s:='0'; exit end;
    blockread(f,numberOfElem,2);
    for i:=1 to NumberOfElem do
     Begin
      blockread(f,j,1);
      Seek(f,FilePos(f)-1);
      blockread(f,s,j+1);
      PutElemName(i,s);
      Blockread(f,j,1);
      PutGab(1,i,j);
      Blockread(f,j,1);
      PutGab(2,i,j);
     End;
    blockread(f,NumberOfChain,2);
    for i:=1 to NumberOfChain do
     Begin
      blockread(f,k,2);
      PutQuanElInChain(i,k);
      l:=0;
      blockread(f,l,1);
      Seek(f,FilePos(f)-1);
      blockread(f,s,l+1);
      Putchainname(i,s);
      For j:=1 to k do
       Begin
        blockread(f,b,2);
        PutElemNumber(i,j,b);
       End;
    End;
    close(f)
   end
   else
   worning(1,1,'file not open');
End;
{---------------------------------}
Procedure ShowZnak;
Var i:word;
Begin
 for i:=1 to NumberOfElem do
 Writeln(ElemName(i),':::::> ',ElemZnak(i));
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
       r:=Elemkorteg(i);
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
 Procedure Out;
 Var
   i,t,j:word;
   k,h:byte;
   c:char;
   v:boolean;
   s:string[20];
   st:likename;
 Begin
   RadSize;
   kortmas;
     y:=0;
     my:=sizeofpl*dy;
     x:=0;
     mx:=sizeofpl*dx;
   restorecrtmode;
   textcolor(13);
   writeln('Матрица связей');
   For i:=1 to NumberOfChain do
    Begin
       textcolor(4);
       Write('Цепь : ',chainname(i),
        'Число элементов: ',QuanElInChain(i),' номера : ');
       textcolor(14);
       for j:=1 to QuanElInChain(i) do
        write(elemName(ElemNumber(i,j)),' ');
     writeln;
     readln;
     End;
        setgraphmode(getgraphmode);
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
          restorecrtmode;
          Changeznak;
          ShowZnak;
         readln;
          CreateTracMas;
          sort(t,j);
        setgraphmode(getgraphmode);
      if (t<>0)or(j<>0)
       Then
        IF j=0 then
                   Begin
                    inc(MinKorteg);
                    putkorteg(t,minkorteg);
                    Putznak(t,'+');
                  {  putrec;}
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
                     writeln('Min::> ',Elemname(t),' kortmin::> ',Minkorteg,
                     ' Max::> ',elemname(j),' kortmax::> ',maxkorteg);
                     readln;  
      setgraphmode(getgraphmode);
                     putkorteg(t,Minkorteg);
                     putKorteg(j,MaxKorteg);
                     putznak(t,'+');
                     putZnak(j,'-');
                   {  Putrec;}
                     puttoscreen(3,14,t);
                     puttoscreen(3,14,j);
                   End;;;
       Until AllPlacedInSec;
       ClearSec;
   Until AllPlaced(i);
 Until I=NumberOfSec;
 For i:=1 to numberofelem do
 PuttoScreen(12,14,i);
 c:=readkey;
 End;
{----------------------------------------}
 Procedure putstrl(v,x,y,cs,cg,cf,cr:word);
 Var i,j:word;
 Begin
  setfillstyle(1,cf);
  setcolor(cr);
  Rectangle(x,y,x+sx,y+sy);
  Floodfill(x+sx div 2,y+sy div 2,cr);
  setfillstyle(1,cs);
  setcolor(cg);
 case v of
 1: Begin
     moveto(x+sx div 10,y+sy div 2);
     lineto(x+9*sx div 10,y+sy div 10);
     linerel(0,8*sy div 10);
     lineto(x+sx div 10,y+sy div 2)
    End;
 2: Begin
     moveto(x+sx div 10,y+sy div 10);
     linerel(0,8*sy div 10);
     lineto(x+9*sx div 10,y+sy div 2);
     lineto(x+sx div 10,y+sy div 10)
    End;
 3: Begin
     moveto(x+sx div 10,y+sy div 10);
     linerel(8*sx div 10,0);
     lineto(x+sx div 2,y+9*sy div 10);
     lineto(x+sx div 10,y+sy div 10)
    End;
 4: Begin
     moveto(x+sx div 10,y+9*sy div 10);
     linerel(8*sx div 10,0);
     lineto(x+sx div 2,y+sy div 10);
     lineto(x+sx div 10,y+9*sy div 10)
    End;
 End;
  Floodfill(x+sx div 2,y+sy div 2,cg);
 End;
{------------------------------------------}
Procedure PutTab(x,y,cf,cr,clf,cl:word);
 Begin
  setfillstyle(1,cf);
  bar(x,y,x+sx,y+sy);
  setcolor(cr);
  rectangle(x,y,x+sx,y+sy);
  setfillstyle(1,clf);
  bar(x+sx div 4,y+sy div 4, x+3*sx div 4,y+ 3*sy div 4);
  rectangle(x+sx div 4,y+sy div 4, x+3*sx div 4,y+3*sy div 4);
end;
{--------------------------------------------------------}
Procedure WorkState(cp:byte);
Var
  i,j:word;
Begin
 Dx:=4*lx div (15*Scale);
 Dy:=7*ly div (20*Scale);
 cleardevice;
 N:= lx div dx;
 M:= (19*ly div 20) div dy;
 sx:=lx-ux;
 sy:=ly-uy;
 for i:=0 to n do
  for j:=0 to m do
   PutPixel(i*dx,j*dy,cp);
  setfillpattern(pic,3);
  bar(0,Uy,Ux,ly);
  bar(Ux,0,lx,Uy);
  putstrl(1,0,Uy,1,2,13,10);
  putstrl(2,ux-lx+ux,uy,1,2,13,10);
  putstrl(3,ux,Uy-ly+uy,1,2,13,10);
  putstrl(4,ux,0,1,2,13,10);
  Puttab(ux,uy,7,0,3,0);
  Settextstyle(Triplexfont,0,1);
  settextjustify(1,1);
 sx:=2*sx;
 sy:=2*sy;
 qx:=sx div 2;
 qy:=sy div 2;
 Dmx:=15*sx;
 Dmy:=11*qy;
 litY:=lY div 170;
   OpenMouse;
End;
{-----------------------------------------------------}
Function Menu(x,y:word):char;
Var i,j,k,l,n,m,z,a:integer;
    v,b:boolean;
  Procedure Putdubs(v,cr,cf,cl,clf:byte);
   Var i,j,k,l:word;
   begin
    setfillstyle(1,cf);
    setcolor(cr);
    Case v of
  1: Begin
     Bar(x+qx,y+qy,x+qx+sx,y+qy+sy);
     Rectangle(x+qx,y+qy,x+qx+sx,y+qy+sy);
     moveto(x+qx+sx div 5,y+sy);
     lineto(x+sx,y+qy+sy div 5);
     linerel(0,3*sy div 5);
     lineto(x+qx+sx div 5,y+sy);
     moveto(x+qx+sx div 2,y+sy);
     lineto(x+qx+4*sx div 5,y+qy+sy div 5);
     linerel(0,3*sy div 5);
     lineto(x+qx+sx div 2,y+2*qy);
     i:=x+qx+qx div 2;j:=y+sy;
     k:=x+qx+3*sx div 4;l:=j;
     end;
  2: Begin
     Bar(x+qx,y+5*qy,x+qx+sx,y+7*qy);
     Rectangle(x+qx,y+5*qy,x+qx+sx,y+7*qy);
     moveto(x+qx+sx div 5,y+5*qy+sy div 5);
     lineto(x+sx,y+3*sy);
     lineto(x+qx+sx div 5,y+5*qy+4*sy div 5);
     linerel(0,-3*sy div 5);
     moveto(x+sx,y+5*qy+sy div 5);
     lineto(x+qx+4*sx div 5,y+3*sy);
     lineto(x+sx,y+5*qy+4*sy div 5);
     linerel(0,-3*sy div 5);
     i:=x+qx+qx div 2;j:=y+3*sy;
     k:=x+qx+3*sx div 4;l:=j;
     End;
  3: Begin
     Bar(x+5*qx,y+qy,x+7*qx,y+qy+sy);
     Rectangle(x+5*qx,y+qy,x+7*qx,y+qy+sy);
     moveto(x+3*sx,y+qy+sy div 5);
     lineto(x+5*qx+sx div 5,y+sy);
     linerel(3*sx div 5,0);
     lineto(x+3*sx,y+qy+sy div 5);
     moveto(x+3*sx,y+sy);
     lineto(x+5*qx+sx div 5,y+qy+4*sy div 5);
     linerel(3*sx div 5,0);
     lineto(x+3*sx,y+sy);
     i:=x+3*sx;j:=y+qy+qy div 2;
     k:=i;l:=y+sy+qy div 2;
     End;
  4: Begin
     Bar(x+5*qx,y+5*qy,x+7*qx,y+7*qy);
     Rectangle(x+5*qx,y+5*qy,x+7*qx,y+7*qy);
     moveto(x+5*qx+sx div 5,y+5*qy+sy div 5);
     linerel(3*sx div 5,0);
     lineto(x+3*sx,y+3*sy);
     lineto(x+5*qx+sx div 5,y+5*qy+sy div 5);
     moveto(x+5*qx+sx div 5,y+3*sy);
     linerel(3*sx div 5,0);
     lineto(x+3*sx,y+5*qy+4*sy div 5);
     lineto(x+5*qx+sx div 5,y+3*sy);
     i:=x+3*sx;j:=y+5*qy+qy div 2;
     k:=i;l:=y+3*sy+qy div 2;
     End;
  End;
  setfillstyle(1,clf);
  floodfill(i,j,cl);
  floodfill(k,l,cl);
 End;
 {==============================================}
 Procedure puthelp(cf:byte);
 Begin
  setfillstyle(1,cf);
  Bar(x+qx,y+7*qy+qy div 2,x+7*qx,y+9*qy);
  setcolor(0);
  Rectangle(x+qx,y+7*qy+qy div 2,x+7*qx,y+9*qy);
  Outtextxy(x+2*sx,y+8*qy,'H E L P');
 End;
 {==============================================}
 Procedure PutScale(k:byte);
  Var i:byte; v:boolean;
      s:string[2];
  Begin
   setfillstyle(1,7);
   bar(x+4*sx,y+qx,x+10*sx,y+2*sy);
   setcolor(0);
   Rectangle(x+4*sx,y+qx,x+10*sx,y+2*sy);
   setfillpattern(pic,3);
   bar(x+9*qx,y+sy,x+19*Qx,y+3*qy);
   rectangle(x+9*qx,y+sy,x+19*qx,y+3*qy);
   For i:=1 to 10 do
    Begin
     str(i,s);
     outtextxy(x+(8+i)*qx+Qx div 2,y+qy+11*qy div 20,s);
    End;
    setfillPattern(pic2,6);
    Bar(x+(8+k)*qx+1,y+sy+1,x+(9+k)*qx-1,y+sy+qy-1);
    setcolor(8);
    v:=true;
     For i:=0 to qx do
     Begin
     if v then
     line(x+(8+k)*qx+i,y+sy+1,
          x+(8+k)*qx+i,y+sy+qy-1);
      V:=not v
      End;
     Outtextxy(x+14*qx,y+sy+qy+qy div 2,'D I M I N I S H');
      line(x+9*qx,y+sy+qy+qy div 2,x+11*qx,y+sy+qy+qy div 2);
      line(x+17*qx,y+sy+qy+qy div 2,x+18*qx,y+sy+qy+qy div 2);
      moveto(x+19*qx,y+sy+qy+qy div 2);
      setcolor(0);
      linerel(-qx,2*lity);
      linerel(0,-4*lity);
      linerel(qx,2*lity);
      setfillstyle(1,10);
      floodfill(x+18*qx+qx div 2,y+sy+qy+qy div 2,0);
  End;
  {===============================================}
  Procedure putPblock;
  Begin
   setfillstyle(1,3);
   Bar(x+4*sx,y+2*sy+qy div 2,x+10*sx,y+9*qy+qy div 2);
   setcolor(0);
   rectangle(x+4*sx,y+2*sy+qy div 2,x+10*sx,y+9*qy+qy div 2);
  End;
  {=============================================}
  Procedure PutBlock(cf:byte);
  Begin
    setfillstyle(1,cf);
    Bar(x+5*sx+qx,y+2*sy+qy div 2 +lity,
        x+8*sx+qx,y+5*qy+qy div 2+lity);
        setcolor(0);
    rectangle(x+5*sx+qx,y+2*sy+qy div 2 +lity,
        x+8*sx+qx,y+5*qy+qy div 2+lity);
    Outtextxy(x+14*qx,y+5*qy,'B L O C K');
  End;
  {==============================================}
  procedure PutTurn(cf:byte);
   begin
    setfillstyle(1,cf);
    Bar(x+4*sx+qx div 2,y+5*Qy+qy div 2 +2*lity,
        x+13*qx+qx div 2,y+6*qy+qy div 2+2*lity);
        setcolor(0);
    rectangle(x+4*sx+qx div 2,y+5*Qy+qy div 2 +2*lity,
        x+13*qx+qx div 2,y+6*qy+qy div 2+2*lity);
    Outtextxy(x+5*Sx+qx,y+6*qy+lity,'T U R N');
  End;
  {==============================================}
  procedure PutRead(cf:byte);
   begin
    setfillstyle(1,cf);
    Bar(x+7*sx+qx div 2,y+5*Qy+qy div 2 +2*lity,
        x+19*qx+qx div 2,y+6*qy+qy div 2+2*lity);
        setcolor(0);
    rectangle(x+7*sx+qx div 2,y+5*Qy+qy div 2 +2*lity,
        x+19*qx+qx div 2,y+6*qy+qy div 2+2*lity);
    Outtextxy(x+16*Qx+qx,y+6*qy+lity,'R E A D');
  End;
  {==============================================}
  procedure PutWr(cf:byte);
   begin
    setfillstyle(1,cf);
    Bar(x+7*sx+qx div 2,y+6*Qy+qy div 2 +3*lity,
        x+19*qx+qx div 2,y+7*qy+qy div 2+3*lity);
        setcolor(0);
    rectangle(x+7*sx+qx div 2,y+6*Qy+qy div 2 +3*lity,
        x+19*qx+qx div 2,y+7*qy+qy div 2+3*lity);
    Outtextxy(x+16*Qx+qx,y+7*qy+2*lity,'W R I T E');
  End;
  {==============================================}
  procedure PutRep(cf:byte);
   begin
    setfillstyle(1,cf);
    Bar(x+4*sx+qx div 2,y+6*Qy+qy div 2 +3*lity,
        x+13*qx+qx div 2,y+7*qy+qy div 2+3*lity);
        setcolor(0);
    rectangle(x+4*sx+qx div 2,y+6*Qy+qy div 2 +3*lity,
        x+13*qx+qx div 2,y+7*qy+qy div 2+3*lity);
    Outtextxy(x+5*Sx+qx,y+7*qy+2*lity,'REPLASE');
  End;
  {==============================================}
  procedure PutCopy(cf:byte);
   begin
    setfillstyle(1,cf);
    Bar(x+4*sx+qx div 2,y+7*Qy+qy div 2 +4*lity,
        x+13*qx+qx div 2,y+8*qy+qy div 2+4*lity);
        setcolor(0);
    rectangle(x+4*sx+qx div 2,y+7*Qy+qy div 2 +4*lity,
        x+13*qx+qx div 2,y+8*qy+qy div 2+4*lity);
    Outtextxy(x+5*Sx+qx,y+8*qy+3*lity,'C O P Y');
  End;
  {==============================================}
  procedure PutRes(cf:byte);
   begin
    setfillstyle(1,cf);
    Bar(x+7*sx+qx div 2,y+7*Qy+qy div 2 +4*lity,
        x+19*qx+qx div 2,y+8*qy+qy div 2+4*lity);
        setcolor(0);
    rectangle(x+7*sx+qx div 2,y+7*Qy+qy div 2 +4*lity,
        x+19*qx+qx div 2,y+8*qy+qy div 2+4*lity);
    Outtextxy(x+16*Qx+qx,y+8*qy+3*lity,'RESTORE');
  End;
  {==============================================}
   Procedure PutWin(v,cf:byte);
    var i:byte; s:string[5];
   Begin
    setfillstyle(1,cf);
    setcolor(0);
    case v of
   1: begin
       Bar(x+21*qx,y+qy,x+27*qx,y+3*qy+qy div 2);
       Rectangle(x+21*qx,y+qy,x+27*qx,y+3*qy+qy div 2);
       Outtextxy(x+24*qx,y+qy+qy div 2,'S A V E');
       Outtextxy(x+24*qx,y+sy+qy div 2,'Disposition');
      End;
   2: begin
       Bar(x+21*qx,y+3*qy+qy div 2+lity,x+27*qx,y+3*sy+lity);
       Rectangle(x+21*qx,y+3*qy+qy div 2+2,x+27*qx,y+3*sy+lity);
       Outtextxy(x+24*qx,y+2*sy+lity,'L O A D');
       Outtextxy(x+24*qx,y+5*qy+lity,'Disposition');
      End;
   3: begin
       Bar(x+21*qx,y+3*sy+2*lity,x+27*qx,y+4*sy+qy div 2+2*lity);
       Rectangle(x+21*qx,y+3*sy+2*lity,x+27*qx,y+4*sy+qy div 2+2*lity);
       Outtextxy(x+24*qx,y+3*sy+qy div 2+2*lity,'L O A D');
       Outtextxy(x+24*qx,y+7*qy+qy div 2+2*lity,'Circuit');
      End;
   4: begin
       Bar(x+21*qx,y+4*sy+qy div 2+3*lity,x+27*qx,y+10*qy+lity);
       Rectangle(x+21*qx,y+4*sy+qy div 2+3*lity,x+27*qx,y+10*qy+lity);
       Outtextxy(x+24*qx,y+9*qy+3*lity,'Q U I T');
      End;
   5: begin
       Bar(x+27*qx+qx div 2,y+qy,x+28*qx+qx div 2,y+6*qy+lity);
       Rectangle(x+27*qx+qx div 2,y+qy,x+28*qx+qx div 2,y+6*qy+lity);
       s:='PLACE';
       for i:=1 to 5 do
       Outtextxy(x+28*qx,y+qy div 2+i*qy,s[i]);
      End;
   6: begin
       Bar(x+27*qx+qx div 2,y+6*qy+2*lity,x+28*qx+qx div 2,y+10*qy+2*lity);
       Rectangle(x+27*qx+qx div 2,y+6*qy+2*lity,x+28*qx+qx div 2,y+10*qy+2*lity);
       s:='STOP';
       for i:=1 to 4 do
       Outtextxy(x+28*qx,y+5*qy+qy div 2+lity+i*qy,s[i]);
      End;
    End;
 End;
 {=================================================}
Begin
 Vm:=true{Not Vm};
 Xm:=x;
 Ym:=y;
 If vm
   Then
    Begin
     Hidemouse;
     setfillpattern(pic,15);
     Bar(x,y,x+dmx,y+dmy);
     setcolor(15);
     rectangle(x+1,y+2,x+dmx-1,y+dmy-2);
     rectangle(x+3,y+4,x+dmx-3,y+dmy-4);
     for i:=1 to 4 do
     putdubs(i,8,7,8,3);
     putstrl(1,x+qx,y+qy+sy,7,8,3,8);
     putstrl(2,x+5*qx,y+qy+sy,7,8,3,8);
     putstrl(4,x+3*qx,y+qy,7,8,3,8);
     putstrl(3,x+3*qx,y+5*qy,7,8,3,8);
     puttab(x+qx+sx,y+qy+sy,7,0,3,0);
     setusercharsize(6390,10*lx,3490,10*ly);
     puthelp(7);
     setusercharsize(1,3*lx div 639 ,1,3*ly div 349);
     putScale(Scale);
     settextstyle(triplexfont,0,1);
     setusercharsize(1,2*lx div 639,1,2*ly div 349);
     PutpBlock;
     putblock(7);
     Putturn(7);
     putread(7);
     putWr(7);
     putrep(7);
     putcopy(7);
     Putres(7);
     for i:=1 to 6 do putwin(i,7);
     OpenMouse;
     vm:=false;c:='l';
    repeat
     repeat
     Aboutmouse(i,j,l,k,m,n,a,z,v,b);
     until b or v or keypressed;
     if keypressed then c:=readkey
     else
       If v and(i+8>x+27*qx+qx div 2)and(j+8>y+qy)
        And (i+8<x+28*qx+qx div 2) and (j+8<y+6*qy+lity)
       then
         Begin
          hidemouse;
          PutWin(5,10);
          openmouse;
          vm:=true;
          menu:='p';
         End;
       If v and (i+8>x+21*qx)and(j+8>y+3*sy+2*lity)
        And (i+8<x+27*qx)and (j+8<y+4*sy+qy div 2+2*lity)
       then
         Begin
          hidemouse;
          PutWin(3,10);
          openmouse;
          vm:=true;
          menu:='c';
         End;
       If v and(i+8>x+21*qx)and(j+8>y+4*sy+qy div 2+3*lity)
        And (i+8<x+27*qx)and (j+8<y+10*qy+lity)
       then
         Begin
          hidemouse;
          Putwin(4,10);
          openmouse;
          delay(1000);
          closegraph;
          halt;
         End;
       If b and (i+8>x+qx)and(j+8>y+7*qy+qy div 2)
        And (i+8<x+7*qx)and (j+8<y+9*qy)
       then
         Begin
          hidemouse;
          Puthelp(10);
          openmouse;
          menu:='h';
         End;
    Until vm or b or (c=#27);
       End
   Else
    Begin
    restore(x,y,x+dmx,y+dmy,15);
    menu:=';';
    End;
End;
{-------------------------------------------------------}
BEGIN
  If memavail div 6553<=9 Then
  Begin
   worning(10,10,'Not Memory to Load Datas Files');
   Halt
  End;
   InitMouse(10,12,1);
    dx:=detect;
         initgraph (dx,dy,'');
     dy:=graphresult;
     if dy<>grok then
    begin textcolor(4);
          writeln (grapherrormsg(dy));
           Halt
    end;
  If registerBgiFont (@trip)<0 then halt;
   GraphMouse(const1);
    Lx:=GetMaxX;
    Ly:=GetmaxY;
    Ux:=39*lx div 40;
    Uy:=77*ly div 80;
    begining;
    Scale:=4;
    workState(15);
    ch:='l';
    vm:=true;
Repeat
repeat
  c:=menu(100,100);
 if c='c' then
                        Begin
                        spfil(k);
                    if k=0 then
                             begin
                             worning (35,13,'File !.dat Is not Exist');
                             halt;
                             End;
                    h:=1;
                    ch:='c';
                    hidemouse;
                  repeat
                    chos(k,st,h,15);
                    readfile(st);
                  until st<>'0';
                    openmouse;
                        End
   Else
    If (c='p')and((ch='c')or(ch='h')) Then begin
                                           hidemouse;
                                           restore(xm,ym,xm+dmx,ym+dmy,15);
                                           out;
                                           openmouse;
                                           ch:='p'
                                           end
                          else
      if (c='h') then begin ch:='h';Entercir;end;
 Until ch='p';
Until menu(100,100)='q';
 c:=readkey;
 closeGraph;
End.

