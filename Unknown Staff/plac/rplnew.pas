PROGRAM RPL;
 Uses Mouse,Crt,Dos,Graph,Mem_Disk;
 procedure trip; external;
 {$L trip.obj}
 Const
      pic3:fillpatterntype=
      ($49,$92,$49,$92,$49,$92,$49,$92);
      pic1:fillpatterntype=
      ($55,$55,$55,$55,$55,$55,$55,$55);
      Pic2:Fillpatterntype=
      ($49,$55,$49,$55,$49,$55,$49,$55);
      Pic:fillPatterntype=
      ($55,$AA,$55,$AA,$55,$AA,$55,$AA);
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
     i,j,mn,h            :word;
     Scale,
     QuanFiles,
     k,LitY :byte;
     c,ch:char;
     st:likename;
     FullMask,
     sm:pathstr;
     dx,dy,x,y,mx,my:integer;
     stp,stpD:array[1..100]Of likename;
     Vm:boolean;
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
if korteg(ne)=0 then exit;
  koord(korteg(ne),x1,y1);
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
 setviewport(0,0,lx-qx,ly-qy,true);
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
procedure spfil(s:pathstr);
var dirinfo:SearchRec;
    Sm:pathstr;
    i,j,k:word;
begin
If pos(':',s)<>0 then
Begin
  sm:=copy(s,1,pos(':',s));
 While pos('\',s)<>0 do
 Begin
  s:=copy(s,pos('\',s)+1,length(s)-pos('\',s));
  If Pos('\',s)<>0 then
  sm:=sm+'\'+copy(s,1,pos('\',s)-1);
 End;
 ChDir(sm);
End;
findfirst(s,readonly,dirinfo);
if DosError<>0 then begin QuanFiles:=0;exit end;
i:=0;
while DosError=0 do
begin
   k:=0;
   For j:=1 to length(Dirinfo.name) do
    If dirinfo.name[j]='.' then inc(k);
    If k<>Length(DirInfo.Name) then
    Begin
     inc(i);
     stp[i]:=dirinfo.name;
    End;
   findnext(dirinfo)
end;
sm:=FexPand(stp[i]);
FullMask:=Copy(sm,1,length(sm)-length(stp[i])-1);
QuanFiles:=i;
end;{the end of spfil}
{----------------------------------------------------------}
Function chos(var st:pathstr;var h:byte):integer;
Label 1,2,3,4;
Var n,l,k,qls,i,Qs,dx,Tur,Tdr,myy,y,xl,yl:word;
   xt,yt:integer;
   CaseOff,PgMoveMode,ds:boolean;
   c:char;
  Procedure readPasW(x1,y1:word;c:char);
  Var s:pathstr;
      sc:string[1];
      v:boolean;
   Begin
   settextjustify(0,1);
    setfillpattern(pic3,9);
    s:=st;
    k:=length(s);
    If c in
     [#8,' ','A'..'Z','a'..'z','0'..'9','_','.','*','!','$','?',':','\']
     then s:='';
    v:=False;
    Repeat
     If v then c:=readkey;
     while keypressed do c:=readkey;
     if c in
      [#8,' ','A'..'Z','a'..'z','0'..'9','_','.','*','!','$','?',':','\']
      Then
       Begin
       sc:=c;
       If c=#8 then delete(s,length(s),1)
                else s:=s+c;
        hide;
       Bar(xm+dx,y+lity,xm+3*dx,y+qy+lity);
       moveto(x1,y1-lity);
       SetColor(15);
       Outtext(s);
       moveto(Wherex-k*textwidth('_'),Wherey);
       SetColor(12);
       Outtext('_');
       show;
       End;
       v:=true;
    Until c=#13;
    st:=s;
    If Pos('.',st)=0 then st:=st+'\*.rpl';
    hide;
     settextjustify(1,1);
     Restore(xm,y,xm+dmx,myy,15);
    show;
    End;
   {================}
   Procedure PutMode(v,cr,cf,cs:byte);
    Begin
    setcolor(cr);
    setfillstyle(1,cf);
    Case v Of
   1: Begin
     Bar(xm+dmx div 2,myy-qy+1,xm+3*qx+dmx div 2,myy-1);
     Rectangle(xm+dmx div 2,myy-qy+1,xm+3*qx+dmx div 2,myy-1);
     Setcolor(cs);
     Outtextxy(xm+dmx div 2+3*qx div 2,myy-qy div 2-lity,'PgDn');
      End;
   2: Begin
     Bar(xm+dmx div 2+3*qx+1,myy-qy+1,xm+6*qx+dmx div 2+1,myy-1);
     Rectangle(xm+dmx div 2+3*qx+1,myy-qy+1,xm+6*qx+dmx div 2+1,myy-1);
     Setcolor(cs);
     Outtextxy(xm+dmx div 2+3*qx+3*qx div 2,myy-qy div 2-lity,'PgUp');
      End;
   3: Begin
     Bar(xm+dmx div 2+6*qx+2,myy-qy+1,xm+9*qx+dmx div 2+2,myy-1);
     Rectangle(xm+dmx div 2+6*qx+2,myy-qy+1,xm+9*qx+dmx div 2+2,myy-1);
     Setcolor(cs);
     Outtextxy(xm+dmx div 2+6*qx+3*qx div 2,myy-qy div 2-lity,'Home');
      End;
   4: Begin
     Bar(xm+dmx div 2+9*qx+3,myy-qy+1,xm+12*qx+dmx div 2+3,myy-1);
     Rectangle(xm+dmx div 2+9*qx+3,myy-qy+1,xm+12*qx+dmx div 2+3,myy-1);
     Setcolor(cs);
     Outtextxy(xm+dmx div 2+9*qx+3*qx div 2,myy-qy div 2-lity,'End');
      End;
    End;
      setcolor(15);
   End;
   {===============}
begin
   settextstyle(SmallFont,0,5);
   setusercharsize(645,lx,355,ly);
   CaseOff:=true;
2:  spfil(st);
  Qls:=(quanfiles) div 4+4;
   If QuanFiles>16 then PgMoveMode:=True
                   else PgMoveMode:=false;
  If ly-ym-dmy-qy<qy*4
     then myy:=ym
     else myy:=1;
     If Not PgMoveMode then
                Begin
                 If myy=ym then y:=myy-qy*qls
                 else Begin y:=ym+dmy;myy:=y+qy*qls end;
                 Tdr:=QuanFiles;
                End
              else
               Begin
                If myy=ym then y:=myy-7*qy
                else begin y:=ym+dmy;myy:=y+qy*7 end;
                Tdr:=16;
               End;
      Tur:=1;
   dx:=dmx div 4;
   setfillstyle(1,1);
   setcolor(15);
   hide;
   bar(xm,y,xm+dmx,myy);
   setfillpattern(pic3,9);
   Bar(xm+dx,y+lity,xm+3*dx,y+qy+lity);
   setfillstyle(1,13);
   Outtextxy(xm+dx div 2,y+qy div 2,'Name:');
   Bar(xm+dx,y+Lity,xm+dx+textwidth(st),y+qy+lity);
   Outtextxy(xm+dx+textwidth(st)div 2,y+qy div 2,st);
   outtextxy(xm+dx div 2,y+qy+qy div 2-lity,'Files :');
   If PgMoveMode then
   For i:=1 to 4 do
    PutMode(i,14,3,15);
    Settextjustify(0,1);
    Outtextxy(xm+qx,myy-qy div 2-lity,FullMask);
    Settextjustify(1,1);
   line(xm,y+sy,xm+dmx,y+sy);
   line(xm,myy-qy,xm+dmx,myy-qy);
4:  for i:=1 to 3 do line(xm+dx*i,y+sy,xm+dx*i,myy-qy);
   xt:=xm-dx div 2;
   yt:=y+sy+qy div 2;
   for l:=Tur to Tdr do
   begin
     if ((l-1) mod 4=0)and ((l-1) mod 16<>0) then
      begin inc(yt,qy);xt:=xm-dx div 2 end;
      inc(xt,dx);
      outtextxy(xt,yt-lity,stp[l]);
   end;
   show;
   C:='@';
 If CaseOff Then
 Begin
  Repeat
   GetPos(i,j,k);
   If k=Right then goto 3;
  Until ((k=left)and(i>xm)and(i<xm+dmx)and(j>y+sy)and(J<myy-qy))
        Or keypressed;
    If Keypressed then c:=readkey;
   While keypressed do c:=readkey;
   if ((c<>#13) and (c<>'@'))or(QuanFiles=0)
    Then
     Begin
      ReadPasW(xm+dx,y+qy div 2,c);
      Goto 2;
     End;
 End;
     c:='L';
   xt:=xm-dx div 2+dx*(h mod 4);
   yt:=y+qy+qy div 2+qy*((h-1) div 4+1);
   xl:=xt;
   yl:=yt;
     l:=h;
     n:=l;
   hide;
      setfillstyle(1,10);
       Bar(xt-6*textwidth('_'),yt-qy div 2+1,
           xt+6*textwidth('_'),yt+qy div 2-1);
           setcolor(12);
      outtextxy(xt,yt-lity,stp[Tur-1+n]);
     setcolor(15);
   setfillpattern(pic3,9);
   Bar(xm+dx,y+lity,xm+3*dx,y+qy+lity);
   Outtextxy(xm+dx+textwidth(stp[n])div 2,y+qy div 2,stp[n]);
   show;
   ds:=false;
   CaseOff:=false;
 while c<>#13 do
  begin
      delay(50);
     GetPos(i,k,Qs);
   if keypressed then c:=readkey;
   while keypressed do c:=readkey;
   if (c=#77)and(xt+dx<xm+dmx)and(l<=Tdr-tur) then
    Begin n:=l+1;inc(xt,dx) end else
   if (c=#75)and(xt-dx>xm)and(l>tur) then
    begin n:=l-1;dec(xt,dx) end else
   if (c=#80)and(yt+sy<myy)and(l+4<=tdr) then
    begin n:=l+4;inc(yt,qy) end else
   if (c=#72)and(yt-qy>y+sy)and(l-4>tur) then
    begin n:=l-4;dec(yt,qy) end else
   If (i>xm)and(i<xm+dmx)and(k>y+sy)and(k+qy<myy)and(qs=left)
      and(Tdr>=((k-y-sy)div qy)*4+(i-xm)div dx+1)
    Then
     Begin
     Xt:=xm+dx*((i-xm)div dx+1)-dx div 2;
     Yt:=y+sy+qy*((k-y-sy)div qy+1)-qy div 2;
     n:=((k-y-sy)div qy)*4+(i-xm)div dx+1;
     GetPos(i,k,j);
     If (j=qs)and ds and (l=n) then c:=#13
     else If (j=qs)and(l=n) then ds:=true
                            else ds:=false;
     End
    Else
    If (i>xm+dmx div 2)and(k>myy-qy+1)and(i<xm+3*qx+dmx div 2)and(k<myy-1)
       and(qs=left) And PgMoveMode
     Then
      Begin
      PutMode(1,7,12,15);
      Delay(200);
      If tur+16<QuanFiles then
       Begin
        Inc(tur,16);
        If Tdr+16<QuanFiles Then Inc(tdr,16)
                            Else Tdr:=quanfiles;
       End;
      PutMode(1,14,3,15);
      setfillstyle(1,1);
      Bar(xm,y+sy+1,xm+Dmx,y+(qls-5)*qy-1);
      Goto 4;
      End
    Else
    If (i>xm+dmx div 2+3*qx+1)
    and(i<myy-qy+1)and(k>xm+6*qx+dmx div 2+1)and(k<myy-1)and(qs=left)
       And PgMoveMode
     Then
      Begin
      PutMode(2,7,12,15);
      Delay(50);
      If tur-16>=1 then
       Begin
        dec(tur,16);
        If Tdr-16>1 Then dec(tdr,16)
                    Else Tdr:=1;
       End;
      PutMode(2,14,3,15);
      Bar(xm,y+sy+1,xm+Dmx,y+sy+(qls-4)*qy-1);
      Goto 4;
      End
    Else
    If (i>xm+dmx div 2+6*qx+2)and(i<myy-qy+1)
    and(k>xm+9*qx+dmx div 2+2)and(k<myy-1)and(qs=left)
       And PgMoveMode
     Then
      Begin
      PutMode(3,7,12,15);
      Delay(50);
      Tur:=1;
      Tdr:=16;
      PutMode(3,14,3,15);
      Bar(xm,y+sy+1,xm+Dmx,y+sy+(qls-4)*qy-1);
      Goto 4;
      End
    Else
    If (i>xm+dmx div 2+9*qx+3)and(i<myy-qy+1)
    and(k>xm+12*qx+dmx div 2+3)and(k<myy-1)and(qs=left)
       And PgMoveMode
     Then
      Begin
      PutMode(3,7,12,15);
      Delay(50);
      Tur:=QuanFiles-15;
      Tdr:=QuanFiles;
      PutMode(3,14,3,15);
      Bar(xm,y+sy+1,xm+Dmx,y+sy+(qls-4)*qy-1);
      Goto 4;
      End
    Else
     Begin
           Getpos(i,j,qs);
      If (qs=Right)or(c=#27)  then
                   Begin
                   qs:=quanpresses(right,j,i,k);
                   delay(80);
                    chos:=-1;
                    goto 3;
                   End

      else goto 1;
     end;
   hide;
       setfillstyle(1,1);
       Bar(xl-6*textwidth('_') ,yl-qy div 2+1,
           xl+6*textwidth('_') ,yl+qy div 2-1);
           setcolor(15);
   setfillpattern(pic3,9);
   Bar(xm+dx,y+lity,xm+3*dx,y+qy+lity);
   Outtextxy(xm+dx+textwidth(stp[Tur-1+n])div 2,y+qy div 2,stp[tur-1+n]);
      outtextxy(xl,yl-lity,stp[tur-1+l]);
      setfillstyle(1,10);
       Bar(xt-6*textwidth('_') ,yt-qy div 2+1,
           xt+6*textwidth('_') ,yt+qy div 2-1);
           setcolor(12);
      outtextxy(xt,yt-lity,stp[Tur-1+n]);
   show;
      xl:=xt;
      yl:=yt;
      i:=0;
      k:=0;
      l:=n;
      If c<>#13 then c:=';';
1: end;
  st:=stp[j];
  h:=j;
  chos:=2;
3: hide;
 settextstyle(triplexfont,0,1);
 Restore(xm,y,xm+dmx,myy,15);
 setusercharsize(1,2*lx div 639,1,2*ly div 349);
 show;
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
{   chos(by,d,h,15);
   WriteToFile(d);}
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
       Writeln('Name ',i,' lll ',elemname(i));
       Write('Цепь : ',chainname(i),' Us :',numberofelem,
       ' Число элементов: ',QuanElInChain(i),' номера : ');
       textcolor(14);
       for j:=1 to QuanElInChain(i) do
        write(elemName(ElemNumber(i,j)),' ');
     writeln;
     readln;
     End;
   SetGraphMode(getgraphmode);
for i:=1 to numberofelem do
 if  notcont(i) then putkorteg(i,1)
                else putkorteg(i,0);
   i:=0;v:=true;
     { putrec;}
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
        {  restorecrtmode;}
          Changeznak;
        {  ShowZnak;
         readln;    }
          CreateTracMas;
          sort(t,j);
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
                    { writeln('Min::> ',Elemname(t),' kortmin::> ',Minkorteg,
                     ' Max::> ',elemname(j),' kortmax::> ',maxkorteg);
                     readln;  }
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
{----------------=========------------}
Function Way(cr,cf,ct,cpf,cpt:byte;text:string):boolean;
var x1,y1,x,mx,my,y,j,k:word;
    stkr:string[20];
    v:boolean;c:char;
    n:byte;
    cv:array[1..6]Of byte;
     begin
    n:=6; cv[1]:=3;
          cv[2]:=9;
          cv[3]:=3;
          cv[4]:=1;
          cv[5]:=1;
          cv[6]:=1;
         setfillstyle(1,cf);
         bar(lx div 10,Ly div 10,2*Lx div 3,Ly div 3);
         setcolor(cr);
         rectangle(Lx div 10+1,Ly div 10+1,
         2*lx div 3-1,ly div 3-1);
         rectangle(lx div 10+5,ly div 10+3,
         2*lx div 3-5,ly div 3-3);
          x:=lx div 9;
         mx:=lx div 2-getmaxx div 20;
         y:=ly div 6;
         my:=2*Ly div 7;
         x1:=Lx div 40;
         y1:=Ly div 40;
         settextstyle(0,0,1);
         setcolor(ct);
         outtextxy(Lx div 8+1,Ly div 9+1,
         text);
         k:=Lx div 6;
         setfillstyle(1,cpf);
         x:=x+x1;
         bar(x,y+y1,x+k,my+y1);
         setcolor(1);
         setlinestyle(0,0,2);
         rectangle(x-1,y+y1-1,x+k+1,my+y1+1);
         setcolor(cpt);
         settextstyle(0,0,2);
         stkr:='YES';
         outtextxy(x+10,y+y1+4,stkr);
         v:=true;
         j:=(mx-x);
     repeat
         c:=readkey;
         if c=#0 then c:=readkey;
         if c=#27 then begin Way:=false;exit end;
       if (c<>' ')and(c<>#13) then
        begin
         setcolor(cpf);
         outtextxy(x+10,y+y1+4,stkr);
         setcolor(cf);
         rectangle(x-1,y+y1-1,x+k+1,my+y1+1);
         setlinestyle(0,0,1);
       for i:=y1 downto 1 do
          begin
           setcolor(cpf);
            line (x,y+i-1,x+k,y+i-1);
            setcolor(8);
            line (x,my+i,x+k,my+i);
          end;
          for x:=x downto x-x1 do
          begin
            setcolor(cpf);
            line (x,y,x,my);
            setcolor(8);
            line (x+k,y+y1,x+k,my);
            setcolor(cf);
            line (x+k,y,x+k,y+y1-1);
          end;
             for i:=1 to j do
         begin
          if v then begin dx:=cf;dy:=cf end
               else begin dx:=8 ;dy:=cpf end;
               setcolor(dx);
          line (x+x1,my+1,x+x1,my+y1);
               setcolor(dy);
          line (x,y,x,my);
          if v then begin dx:=cpf;dy:=8 end
               else begin dx:=cf;dy:=cf end;
               setcolor(dy);
          line(x+k+x1,y+y1,x+k+x1,my+y1);
               setcolor(dx);
           if v then line (x+k,y,x+k,my)
                else begin line(x+k,y,x+k,y+y1);
                           setcolor(8);
                           line(x+k,y+y1,x+k,my);
                     end;
        if v then inc(x)
             else x:=x-1;
         end;
        if not v then inc(x)
             else x:=x-1;

       for x:=x to x+x1 do
          begin
            setcolor(cf);
            line (x-1,y,x-1,my);
            setcolor(cpf);
            line (x+k,y,x+k,my);
          end;
       for i:=y to y+y1-1 do
          begin
           setcolor(cpf);
            line (x,my+i-y+1,x+k,my+i-y+1);
            setcolor(cf);
            line (x,i,x+k+1,i);
          end;
          setlinestyle(0,0,2);
         setcolor(1);
         rectangle(x-1,y+y1-1,x+k+1,my+y1+1);
     if not v then stkr:='YES'
              else stkr:='NO';
      repeat
        for i:=1 to n do
        Begin
         delay(150);
         setcolor(cv[i]);
         outtextxy(x+10,y+y1+4,stkr)
        End;
      until keypressed;
       end;          if v then v:=false
            else v:=true;
     until (c=' ')or(c=#13);
     if v then Way:=false
          else Way:=true;
     end;
{----------------------------------------}
 Procedure putstrl(v,x,y,cs,cg,cf,cr:word);
 Var i,j:word;
 Begin
  setfillstyle(1,cf);
  setcolor(cr);
  Bar(x,y,x+sx,y+sy);
  Rectangle(x,y,x+sx,y+sy);
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
Procedure Feel(x,y,xm,ym,s1,s2:word);
Var i,j:word;sc,cp,k:byte;
Begin
For k:=1 to 2 do
 Begin
 If k=1 then Begin
              Sc:=s1;
              cp:=0;
             End
        Else Begin
              Sc:=s2;
              cp:=15;
             End;
 Dx:=4*lx div (15*Sc);
 Dy:=7*ly div (20*Sc);
 N:= lx div dx;
 M:= ly div dy;
 for i:=0 to n do
  for j:=0 to m do
   If (i*dx<x)or(i*dx>xm)or(j*dy<y)or(j*dy>ym)
   Then
   PutPixel(i*dx,j*dy,cp);
 End;
End;
{--------------------------------------------------------}
Procedure WorkState(cp:byte);
Var
  i,j:word;
Begin
 cleardevice;
 sx:=lx-ux;
 sy:=ly-uy;
  Feel(lx+1,ly+1,lx+2,ly+2,scale,scale);;
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
 setviewport(0,0,lx-qx,ly-qy,true);
   show;
End;
{-----------------------------------------------------}
Function Menu(r:boolean;x,y:word):char;
Var i,j,k,l,n,m,z,a:Word;
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
 Procedure PutScale(v:boolean;k:byte);
  Var i:byte;
      s:string[2];
  Begin
  If v
  Then
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
  {  v:=true;
     For i:=0 to qx do
     Begin
     if v then
     line(x+(8+k)*qx+i,y+sy+1,
          x+(8+k)*qx+i,y+sy+qy-1);
      V:=not v
      End; }
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
    End
   Else
    Begin
    setfillpattern(pic,3);
    bar(x+9*qx+1,y+sy+1,x+19*Qx-1,y+3*qy-1);
    setfillPattern(pic2,6);
    Bar(x+(8+k)*qx+1,y+sy+1,x+(9+k)*qx-1,y+sy+qy-1);
    feel(xm,ym,xm+dmx,ym+dmy,scale,k);
    scale:=k;
    End;
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
  If r Then
    Begin
    hide;
    restore(xm,ym,xm+dmx,ym+dmy,15);
    menu:=';';
    vm:=true;
    menu:='n';
    show;
    exit;
    End;
If x>lx-dmx-qx then x:=lx-dmx-qx-5;
If x<qx then x:=qx+5;
If y>ly-dmy-qy then y:=ly-dmy-qy-5;
if y<qy then y:=qy+5;
 Xm:=x;
 Ym:=y;
 If vm
   Then
    Begin
    Vm:=False;
     Hide;
     setfillpattern(pic,15);
     Bar(x,y,x+dmx,y+dmy);
     setcolor(15);
     rectangle(x+1,y+2,x+dmx-1,y+dmy-2);
     rectangle(x+3,y+4,x+dmx-3,y+dmy-4);
     for i:=1 to 4 do
     putdubs(i,0,7,0,3);
     putstrl(1,x+qx,y+qy+sy,7,0,3,0);
     putstrl(2,x+5*qx,y+qy+sy,7,0,3,0);
     putstrl(4,x+3*qx,y+qy,7,0,3,0);
     putstrl(3,x+3*qx,y+5*qy,7,0,3,0);
     puttab(x+qx+sx,y+qy+sy,7,0,3,0);
     setusercharsize(6390,10*lx,3490,10*ly);
     puthelp(7);
     setusercharsize(1,3*lx div 639 ,1,3*ly div 349);
     putScale(true,Scale);
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
     show;
    End;
    c:='l';
     GetPos(i,j,k);
     if keypressed then c:=readkey;
   IF (c=#13) or (k=left)
      Then
       Begin
       If (i>x+27*qx+qx div 2)and(j>y+qy)
        And (i<x+28*qx+qx div 2) and (j<y+6*qy+lity)
       then
         Begin
          hide;
          PutWin(5,10);
          delay(20);
          PutWin(5,7);
          show;
          menu:='p';
         End;
       If (i>x+9*qx)and(j>y+sy)
        And (i<x+19*Qx) and (j<y+3*qy)
       then
         Begin
          hide;
          PutScale(false,(i-x-9*qx) div qx+1);
          show;
         End;
       If (i>x+21*qx)and(j>y+3*sy+2*lity)
        And (i<x+27*qx)and (j<y+4*sy+qy div 2+2*lity)
       then
         Begin
          hide;
          PutWin(3,10);
          delay(20);
          PutWin(3,7);
          show;
          menu:='c';
         End;
       If (i>x+21*qx)and(j>y+4*sy+qy div 2+3*lity)
        And (i<x+27*qx)and (j<y+10*qy+lity)
       then
         Begin
          hide;
          Putwin(4,10);
          show;
          delay(1000);
          closegraph;
          halt;
         End;
       If (i> x+qx)and(j>y+qy)
        And (i<x+qx+sx)and (j<y+qy+sy)
       then
         Begin
          hide;
          Putdubs(1,0,9,0,12);
          delay(200);
          PutDubs(1,0,7,0,3);
          show;
         End;
       If (i>x+qx)and(j>y+5*qy)
        And (i<x+qx+sx)and (j<y+7*qy)
       then
         Begin
          hide;
          Putdubs(2,0,9,0,12);
          delay(200);
          PutDubs(2,0,7,0,3);
          show;
         End;
       If (i>x+5*qx)and(j>y+qy)
        And (i<x+7*qx)and (j<y+qy+sy)
       then
         Begin
          hide;
          Putdubs(3,0,9,0,12);
          delay(200);
          PutDubs(3,0,7,0,3);
          show;
         End;
       If (i>x+5*qx)and(j>y+5*qy)
        And (i<x+7*qx)and (j<y+7*qy)
       then
         Begin
          hide;
          Putdubs(4,0,9,0,12);
          delay(200);
          PutDubs(4,0,7,0,3);
          show;
         End;
       If (i>x+qx)and(j>y+qy+sy)
        And (i<x+sx+qx)and (j<y+2*sy+qy)
       then
         Begin
          hide;
     putstrl(1,x+qx,y+qy+sy,10,0,11,0);
          delay(200);
     putstrl(1,x+qx,y+qy+sy,7,0,3,0);
          show;
         End;
       If (i>x+5*qx)and(j>y+qy+sy)
        And (i<x+sx+5*qx)and (j<y+2*sy+qy)
       then
         Begin
          hide;
     putstrl(2,x+5*qx,y+qy+sy,10,0,11,0);
          delay(200);
     putstrl(2,x+5*qx,y+qy+sy,7,0,3,0);
          show;
         End;
       If (i>x+3*qx)and(j>y+qy)
        And (i<x+sx+3*qx)and (j<y+sy+qy)
       then
         Begin
          hide;
     putstrl(4,x+3*qx,y+qy,10,0,11,0);
          delay(200);
     putstrl(4,x+3*qx,y+qy,7,0,3,0);
          show;
         End;
       If (i>x+3*qx)and(j>y+5*qy)
        And (i<x+sx+3*qx)and (j<y+sy+5*qy)
       then
         Begin
          hide;
     putstrl(3,x+3*qx,y+5*qy,10,0,11,0);
          delay(200);
     putstrl(3,x+3*qx,y+5*qy,7,0,3,0);
          show;
         End;
       If (i>x+qx+sx)and(j>y+qy+sy)
        And (i<x+2*sx+qx)and (j<y+2*sy+qy)
       then
         Begin
          hide;
     puttab(x+qx+sx,y+qy+sy,12,0,2,0);
          delay(200);
     puttab(x+qx+sx,y+qy+sy,7,0,3,0);
          show;
         End;
     End;{if--------}
End;
{-------------------------------------------------------}
BEGIN
    begining;
    dx:=detect;
         initgraph (dx,dy,'');
     dy:=graphresult;
     if dy<>grok then
    begin textcolor(4);
          writeln (grapherrormsg(dy));
           Halt
    end;
  If registerBgiFont (@trip)<0 then halt;
 If not InitMouse(lx) then Halt;
   SetGraphMouse(8,8,PlaceCursor);
 Vm:=true;
    Lx:=GetMaxX;
    Ly:=GetmaxY;
    Ux:=39*lx div 40;
    Uy:=77*ly div 80;
    Scale:=4;
    workState(15);
    ch:='l';
    c:='l';
Repeat
delay(30);
getpos(i,j,mn);
if mn=right
  then c:=menu(not vm,i,j)
 else
 If (mn=left) and not vm then
  Begin
  c:=menu(false,xm,ym);
  if c='c' then
            Begin
             k:=1; sm:='*.rpl';
             if chos(sm,k)=2 then
                Begin
                 c:='l';
                End;
            End;
  End;
Until c='q';
 c:=readkey;
 closeGraph;
End.

