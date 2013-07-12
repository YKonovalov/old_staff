{$I-}
Unit Rel_U;

interface
{===============================================}
   Type MENUTYPE=record
      x,y:byte;
      a:array[1..20]of string[50];
      n,k:byte;
      v:boolean;
      cb,cf:byte;
      esc:boolean;
      end;
     TABTYPE=Record
      Nx,Ny,Np:Byte;
      Name:String[80];
      Punkt:array[0..20] Of String[20];
      Lx,Ly:Array[1..20] Of Byte;
      Lc,Fc,Pc,Nc:Byte;
      X,Y,Dlx,Dly:Byte;
      end;
   Type SelectType=Record
                   X,Y:Array[1..20] of Record
                                          Na,Ko:Byte;
                                       End;
                   ocf,ocb,cf,cb,cfk,cbk,kx,ky:Byte;
                   s1,s2:String[50];
                   vr1,vr2:char;
                   nx,ny:byte;
                   viz,clr:boolean;
                End;
   Var VM:Array[1..25,1..80] Of Record
                                   c:Char;
                                   a:Byte;
                                End Absolute $B800:$0000;

   PROCEDURE SAVEWINDOW(X1,Y1,X2,Y2:byte; P:Pointer);
   PROCEDURE LOADWINDOW(X1,Y1,X2,Y2:byte; P:Pointer);
   PROCEDURE LOADWINDOW2(X1,Y1,X2,Y2:byte; P:Pointer; raz:boolean);
   PROCEDURE HIDECURSOR;
   PROCEDURE OPENCURSOR;
   PROCEDURE SVM(F:Byte;C:Byte);
   PROCEDURE SPECBAR(x1,y1,x2,y2,cf,cb:Byte);
   PROCEDURE RAMKA(x1,y1,x2,y2,c:byte);
   PROCEDURE TEXTBAR(x1,y1,x2,y2,cf,cb:byte; r:char);
   PROCEDURE ZAST;
   PROCEDURE WRITEXYR(x,y:byte; s:string; cf,cb:byte);
   PROCEDURE TAB(T:TabType);
   PROCEDURE MENU(var m:menutype);
   PROCEDURE GLAWMENU(var nn:byte);
   PROCEDURE KONEC;
   PROCEDURE SELECT(Var SR:SelectType);
{===============================================}
implementation

   uses crt,work_u;
   Var cn0,ck0:byte;

{-----------------------------------------------}

   PROCEDURE SAVEWINDOW(X1,Y1,X2,Y2:byte; P:Pointer);
   var d1,d2,dlx:word;
       y:byte;
   Begin
    dlx:=(x2-x1+1)*2;
    d1:=(x1-1)*2+(y1-1)*160;
    d2:=0;
    for y:=y1 to y2 do
     begin
     move(ptr($B800,d1)^,ptr(seg(p^),ofs(p^)+d2)^,dlx);
     inc(d1,160);
     inc(d2,dlx);
     end;
   End;

   {-------------------------------------------------}

   PROCEDURE LOADWINDOW(X1,Y1,X2,Y2:byte; P:Pointer);
   var d1,d2,dlx:word;
       y:byte;
   Begin
    dlx:=(x2-x1+1)*2;
    d1:=(x1-1)*2+(y1-1)*160;
    d2:=0;
    for y:=y1 to y2 do
     begin
     move(ptr(seg(p^),ofs(p^)+d2)^,ptr($B800,d1)^,dlx);
     inc(d1,160);
     inc(d2,dlx);
     end;
   End;
   {-------------------------------------------------}
   PROCEDURE LOADWINDOW2(X1,Y1,X2,Y2:byte; P:Pointer; raz:boolean);
   var d1,d2,dlx:word;
       y,i,k1,k2:byte;
       buf:array[1..4000]of byte;
   Begin
    dlx:=(x2-x1+1)*2;
    d1:=(x1-1)*2+(y1-1)*160;
    d2:=0;
    k1:=y1; k2:=y1;
    for y:=y1 to y2 do
         begin
         if raz then
              begin
              for i:=k2 downto k1 do
                  begin
                  savewindow(X1,i,X2,i,addr(buf));
                  loadwindow(X1,i+1,X2,i+1,addr(buf));
                  end;
              k1:=k1+1; k2:=k2+2;
              if k1>=y2-1 then raz:=false;
              if k2>=y2-1 then k2:=k1;
              end;
         move(ptr(seg(p^),ofs(p^)+d2)^,ptr($B800,d1)^,dlx);
         delay(100);
         inc(d1,160);
         inc(d2,dlx);
         end;
   End;
   {-------------------------------------------------}
   PROCEDURE HIDECURSOR;
      begin(*hidecursor*)
         asm
            mov ah,3
            int 16
            mov cn0,ch
            mov ck0,cl
            mov ah,1
            mov ch,32
            int 16
         end;
      end;(*hidecursor*)

   PROCEDURE OPENCURSOR;
      begin(*opencursor*)
         asm
            mov ah,1
            mov ch,cn0
            mov cl,ck0
            int 16
         end;
      end;(*opencursor*)
{-----------------------------------------------}

   PROCEDURE SVM(F:Byte;C:Byte);
      Begin
         F:=F And $07;
         TextAttr:=F shl 4 or c;
      End;

{-----------------------------------------------}

Procedure SpecBar(x1,y1,x2,y2,cf,cb:Byte);
   Var x,y:byte;
   Begin
      For y:=y1 to y2 do
         For x:=x1 to x2 do
            VM[y,x].a:=cf shl 4 or cb;
   End;

{-------------------------------------------------}

   PROCEDURE RAMKA(x1,y1,x2,y2,c:byte);
   var r:char;
       n,x,y:byte;
       m:array[1..8,1..3]of byte;

   procedure initM;
   var cc:byte;
   begin
   cc:=c+8;
   m[1,1]:=219; m[1,2]:=cc; m[1,3]:=c;
   m[2,1]:=178; m[2,2]:=cc; m[2,3]:=c;
   m[3,1]:=177; m[3,2]:=cc; m[3,3]:=c;
   m[4,1]:=176; m[4,2]:=cc; m[4,3]:=c;
   m[5,1]:=176; m[5,2]:=c; m[5,3]:=c;
   m[6,1]:=176; m[6,2]:=0; m[6,3]:=c;
   m[7,1]:=177; m[7,2]:=0; m[7,3]:=c;
   m[8,1]:=178; m[8,2]:=0; m[8,3]:=c;
   end;

   procedure setcolor(c:byte);
    begin
    textcolor(m[c,2]);
    textbackground(m[c,3]);
    r:=char(m[c,1]);
    end;

   BEGIN
    initM;
    for n:=1 to 8 do
     begin
     setcolor(n);
     for x:=x1+n-1 to x2+1-n do
       begin
       gotoxy(x,n+y1-1);
       write(r);
       end;
     for y:=y1+n to y2+1-n do
       begin
       gotoxy(x2+1-n,y);
       write(r);
       end;
     for x:=x2-n downto n+x1-1 do
       begin
       gotoxy(x,y2+1-n);
       write(r);
       end;
     for y:=y2-n downto n+y1 do
       begin
       gotoxy(n+x1-1,y);
       write(r);
       end;
     end;
   textcolor(white);
   textbackground(0);
   end;

{-----------------------------------------------}

   PROCEDURE TEXTBAR(x1,y1,x2,y2,cf,cb:byte; r:char);
   var s:string[81];
       n:byte;
   begin
    hidecursor;
    s:='';
    for n:=0 to (x2-x1) do
     insert(r,s,1);
    svm(cf,cb);
    for n:=y1 to y2 do
      begin
      gotoxy(x1,n);
      write(s);
      end;
   end;
{-----------------------------------------------}

   PROCEDURE ZAST;
   var r:char;
    buf:array[1..5000]of byte;
   begin;
   TextAttr:=White;
   clrscr;
   savewindow(1,1,80,23,addr(buf));
   gotoxy(20,10);
   write(' Программа расчета надежности элементов');
   gotoxy(20,12);
   write('      радио-электронной аппаратуры.');
   gotoxy(20,14);
   write('         Михайлов Б.В.');
   gotoxy(20,15);
   write('         Корнилов Д.В.');
   Gotoxy(20,16);
   write('         Коновалов Ю.Д.');
   ramka(1,1,80,24,Blue);
   for i:=1 to 50 do
    begin
    delay(100);
    if keypressed then
     begin
     r:=readkey;
     break;
     end;
    end;
   loadwindow2(1,1,80,23,addr(buf),true);
   TextAttr:=White;
   clrscr;
   end;

{-----------------------------------------------}

   PROCEDURE WRITEXYR(x,y:byte; s:string; cf,cb:byte);
   var m:array[1..5]of string;
       n,i:byte;
   begin
    n:=1;
    m[1]:=s;
    i:=pos('@',s);
    while (i<>0) do
     begin
     m[n]:=copy(s,0,i-1);
     delete(s,0,i);
     i:=pos('@',s);
     inc(n);
     m[n]:=s;
     end;
     svm(cf,cb);
    for i:=1 to n do
     begin
     gotoxy(x,y-1+i);
     write(m[i]);
     end;
   end;

   {-------------------------------------------}

   PROCEDURE TAB(T:TabType);
   var x1,y1,x2,y2,i,j,dy:byte;
       s:string[85];
       r:char;
   begin
    hidecursor;
    with t do
     begin
     x1:=x; y1:=y;
     x2:=x+dlx; y2:=y+dly;
     if (name='') then dy:=0
                  else dy:=1;
     textbar(x1,y1,x2,y2,fc,lc,' ');
     svm(fc,nc);
     gotoxy(x1,y1); write(name);
     for j:=1 to ny do
      begin
      textbar(x1,y1+ly[j]-1,x2,y1+ly[j]-1,fc,lc,#196);
      end;
     for i:=1 to nx do
      begin
      textbar(x1+lx[i]-1,y1+dy,x1+lx[i]-1 ,y2,fc,lc,#179);
      end;
     for i:=1 to nx do
      for j:=1 to ny do
       begin
       r:=#197;
       if (lx[i]=1) then
        if (ly[j]=1+dy) then r:=#218
         else if (ly[j]=y2-y1+1) then r:=#192
          else r:=#195;
       if (lx[i]=x2-x1+1) then
        if (ly[j]=1+dy) then r:=#191
         else if (ly[j]=y2-y1+1) then r:=#217
          else r:=#180;
       if (lx[i]<>1)and(lx[i]<>x2-x1+1) then
        begin
        if (ly[j]=1+dy) then r:=#194;
        if (ly[j]=y2-y1+1) then r:=#193;
        end;
       gotoxy(x1+lx[i]-1,y1+ly[j]-1);
       svm(fc,lc);
       write(r);
       end;
     writexyR(x+0,y+ly[1],punkt[0],fc,pc);
     for i:=1 to np do
      begin
      writexyR(x+lx[i],y+ly[1],punkt[i],fc,pc);
      end;
     end;
   end;

   {-------------------------------------------}

   PROCEDURE MENU(var m:menutype);
   label 1;
   var i,j,l,n1,n2:byte;
       r:char;
   begin
   with m do
    begin
      l:=0;
      for i:=1 to n do
       if length(a[i])>l then l:=length(a[i]);
      SVM(0,white);
      clrscr;
      n1:=1; n2:=n;

   1: for i:=n1 to n2 do
       begin
       if i=k then
        SVM(cb,cf)
              else
        SVM(cf,cb);
       gotoxy(x,y+i-1);
       write(a[i]);
       end;
       repeat
        Hidecursor;
        r:=readkey;
        if r=#0 then r:=readkey;
        if (r=#80)and(k<n) then
         begin
         inc(k);
         n1:=k-1; n2:=k;
         goto 1;
         end;
        if (r=#72)and(k>1) then
         begin
         dec(k);
         n1:=k; n2:=k+1;
         goto 1;
         end;
       until (r=#13)or((r=#27)and(esc));
      if r=#13 then v:=true else v:=false;
    end;
   SVM(0,15);
   clrscr;
   end;

{-------------------------------------------}
    PROCEDURE GLAWMENU(var nn:byte);
    var m:menutype;
    begin
    with m do
     begin
     x:=25;
     y:=10;
     a[1]:='     Помощь по программе    ';
          {a[*]:='Задание интервалов и режимов';}
     a[2]:='   Обрабатываемая таблица   ';
     a[3]:='         Обработка          ';
     a[4]:='      Дисковые операции     ';
     a[5]:='           Выход            ';
     n:=5;
     k:=nn;
     cb:=Yellow;
     cf:=blue;
     esc:=false;
     end;
      menu(m);
      nn:=m.k;
      TextAttr:=0;
      ClrScr;
    end;

{---------------------------------------------}

PROCEDURE KONEC;
var m:menutype;
   begin
{   TextColor(7);
   halt;}
   with m do
    begin
    x:=25;
    y:=15;
    a[1]:='  Вы передумали и хотите назад. ';
    a[2]:='    Вы уверены что выходите!    ';
    n:=2;
    k:=1;
    esc:=true;
    cb:=white;
    cf:=black;
    end;
   menu(m);
   if (m.v=true)and(m.k=2) then
      begin
      Close(frm);
      If IOResult<>0 then;
      Close(frr);
      If IOResult<>0 Then;
      OpenCursor;
      TextAttr:=Lightgray;
      TextMode(Co80);
      halt;
      end;
   end;

{---------------------------------------------------}

PROCEDURE Select(Var SR:SelectType);
label 99;
var i,j:byte;
    xs,ys,xn,yn:byte;
    r1,r2:char;
    izm,qu:boolean;

procedure setSB(i,j,f,b:byte);
begin
 with SR do
  SpecBar(x[i].na,y[j].na,x[i].ko,y[j].ko,f,b);
end;

BEGIN
while keypressed do r1:=readkey;
r1:=#0; r2:=r1;
with SR do
 begin
 xs:=kx; ys:=ky;
 xn:=kx; yn:=ky;
 vr1:=#0;vr2:=#0;
 if viz then
  For i:=1 to nx do
      For j:=1 to ny do
          if (i=xn)and(j=yn) then setSB(i,j,cfk,cbk)
                             else setSB(i,j,cf,cb);
 setSB(kx,ky,cfk,cbk);
 if (not(viz))and(clr) then goto 99;
 repeat
  r2:=#0;
  r1:=readkey;
  if r1=#0 then r2:=readkey;
  izm:=false; qu:=false;
  if (r2=#77)and(xs<nx) then
   begin
   inc(xn);
   izm:=true;
   r2:=#0;
   end;
  if (r2=#80)and(ys<ny) then
   begin
   inc(yn);
   izm:=true;
   r2:=#0;
   end;
  if (r2=#75)and(xs>1) then
   begin
   dec(xn);
   izm:=true;
   r2:=#0;
   end;
  if (r2=#72)and(ys>1) then
   begin
   dec(yn);
   izm:=true;
   r2:=#0;
   end;
  for i:=1 to length(s1) do
   if s1[i]=r1 then
    begin
    qu:=true;
    izm:=false;
    vr1:=r1;
    end;
  for i:=1 to length(s2) do
   if (s2[i]=r2) then
    begin
    qu:=true;
    izm:=false;
    vr2:=r2;
    end;
  if izm then
   begin
   setSB(xs,ys,cf,cb);
   setSB(xn,yn,cfk,cbk);
   xs:=xn; ys:=yn;
   end
         else
   begin
   xn:=xs; yn:=ys;
   end;
 until qu;
 kx:=xn;
 ky:=yn;
99:if clr then
  For i:=1 to nx do
     For j:=1 to ny do
        setSB(i,j,ocf,ocb);
 end;
end;

{-------------------------------------------------}

END.