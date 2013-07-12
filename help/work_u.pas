{$I-}

Unit Work_U;

Interface

   Uses Crt,Rel_U,help;

{===========================================}
type readstrtype=record
      s:string[80];
      x,y,n,cb,cf,cfk,cbk:byte;
      esc:boolean;
      end;
type arrtype=Array[1..10] of byte;
type  frmtype=record
                num:byte;
                typ,sbtyp:byte;
                name:string[14];
                nkf:byte;
                PNA:arrtype;
                PA:Array[1..10] of real;
                IO:Real;
                NO:Real;
                NoKf:Boolean;
             end;
      frrtype=record
                 kh:byte;
             end;
      baziktype=record
                A0:real;
                nkf:byte;
                Namekf:arrtype;
             end;
      bazatype=array[1..10,1..15] of baziktype;
Var frm:file of frmtype;
    frr:file of frrtype;
    baza:bazatype;
    KonfBaza:Array[1..10]Of Byte;
    Tip,SizeOfBaza:Byte;
    ww:readstrtype;
    filename:string[7];
    nofiler,nofilem:boolean;
    m1s,r1s,i,j:word;
    srab:string;
    gm:frmtype;
    gr:frrtype;
    r:char;
    rl:real;
    kf:array[1..20] of string[10];
    Limkf:array[1..20,1..2] of Real;
PROCEDURE ModNO;
PROCEDURE REGIM;
PROCEDURE MAIN;
PROCEDURE DISK;
PROCEDURE Perform;
PROCEDURE READSTR(var w:readstrtype);
PROCEDURE Visfrm(fpos:word;ScrPos:Byte;tt:tabtype);
PROCEDURE INITBAZA;
PROCEDURE GETKF(filepos:Word);

{===========================================}

Implementation


{-------------------------------------------}

Procedure ModNO;
  Begin
  gm.NO:=gm.num*gm.IO;
  For i:=1 to gm.nkf do
     gm.NO:=gm.NO*gm.pa[i];
  End;

{-------------------------------------------------}

PROCEDURE REGIM;
var t:tabtype;
    SR:SelectType;
    i:byte;
begin
 with t do
  begin
  name:='      Таблица режимов всей группы элементов';
  x:=5; y:=1;
  dlx:=71; dly:=23;
  nx:=7; ny:=3;
  lx[1]:=1; lx[2]:=5; lx[3]:=14; lx[4]:=29;
  lx[5]:=43; lx[6]:=58; lx[7]:=72;
  ly[1]:=2; ly[2]:=4;  ly[3]:=24;
  np:=6;
  for i:=0 to np do punkt[i]:='';
  punkt[1]:=' N';
  punkt[2]:=' '+#30+'t,мес'; punkt[3]:=' Тип апаратуры';
  punkt[4]:=' Амортизация'; punkt[5]:=' Обслуживание';
  punkt[6]:=' Температура';
  lc:=lightgray; fc:=blue; nc:=7; pc:= 12;
  end;
 tab(t);
 With SR do
    Begin
    viz:=true;
    clr:=false;
    ocf:=1;
    ocb:=white;
    cf:=green;
    cb:=0;
    cfk:=5;
    cbk:=14;
    nx:=5;
    ny:=19;
    kx:=1; ky:=1;
    s1:=#27;
    s2:='';
    For i:=1 to ny do
       Begin
       y[i].na:=i+t.y+3;
       y[i].ko:=y[i].na;
       End;
    For i:=1 to nx do
       Begin
       x[i].na:=t.lx[i+1]+t.x;
       x[i].ko:=t.lx[i+2]+t.x-2;
       End;
    End;
 repeat
  Select(SR);
  with sr do
   begin
   viz:=false;
   case vr1 of
    #13: ;
    end;
   case vr2 of
    #80: ;
    #83: ;
    end;
   end;
 until sr.vr1=#27;
 sr.clr:=true;
 select(SR);
end;

{-------------------------------------------}

PROCEDURE MAIN;
label MSupBeg;
var t:tabtype;
    SR:selecttype;
   PROCEDURE InsStrM(fpos:word);
      Begin
         For i:=(filesize(frm)-fpos) downto 1 do
            Begin
            Seek(frm,i+fpos-1);
            Read(frm,gm);
            Write(frm,gm);
            End;
      End;
   PROCEDURE DelStrM(fpos:word);
      Begin
         For i:=fpos+1 to filesize(frm)-1 do
            Begin
            Seek(frm,i);
            Read(frm,gm);
            Seek(frm,i-1);
            Write(frm,gm);
            End;
         Truncate(frm);
      End;
begin
 with t do
  begin
  name:='                   Cписок элементов прибора';
  x:=1; y:=1;
  dlx:=79; dly:=23;
  nx:=9; ny:=3;
  lx[1]:=1; lx[2]:=5; lx[3]:=9; lx[4]:=15; lx[5]:=24;
  lx[6]:=39; lx[7]:=54; lx[8]:=68;lx[9]:=80;
  ly[1]:=2; ly[2]:=4;  ly[3]:=24;
  np:=8;
  for i:=0 to np do punkt[i]:='';
  punkt[1]:=' N '; punkt[2]:='Кол'; punkt[3]:=' Тип'; punkt[4]:=' Подтип';
  punkt[5]:=' Имя'; punkt[6]:=' Коэффициенты'; punkt[7]:=' Инт. отказ.';
  punkt[8]:='Экспл. и.о.';
  lc:=lightgray; fc:=blue; nc:=15; pc:= 12;
  end;
 with SR do
  begin
  kx:=1;
  ky:=1;
  end;
 MSupBeg: tab(t);
     For i:=m1s to filesize(frm) do
         Begin
            If (i-m1s+1)>t.dly-4 then
               break
            else
               visfrm(i,i-m1s+1,t);
         End;
 With SR do
    Begin
    viz:=true;
    clr:=false;
    cf:=green;
    cb:=0;
    cfk:=5;
    cbk:=11;
    nx:=6;
    ny:=filesize(frm)-m1s+1;
    if ny>19 then
       ny:=19;
    s1:=#27+#13+#9;
    s2:=#80+#83+#82+#72;
    For i:=1 to ny do
       Begin
       y[i].na:=i+t.y+3;
       y[i].ko:=y[i].na;
       End;
    For i:=1 to nx do
       Begin
       x[i].na:=t.lx[i+1]+t.x;
       x[i].ko:=t.lx[i+2]+t.x-2;
       End;
    End;
 repeat
  Select(SR);
  with sr do
   begin
   viz:=false;
   case vr1 of
    #9: case kx of
         1: PutHelp('Help.rel',' Число элементов ',[#27],1,7);
         2: PutHelp('Help.rel',' Тип элемента ',[#27],1,7);
         3:Begin
           seek(frm,m1s+ky-2);
           Read(frm,gm);
           Str(gm.typ,srab);
           PutHelp('Help.rel',' Подтип элемента '+srab+' ',[#27],1,8);
           End;
         4: PutHelp('Help.rel',' Имя элемента ',[#27],1,7);
         5: PutHelp('Help.rel',' Ввод коэффициентов ',[#27],1,7);
         6: PutHelp('Help.rel',' Интенсивность отказов ',[#27],1,7);
        end;
    #13: case kx of
          1: Begin
             With ww do
                Begin
                x:=sr.x[kx].na;
                y:=sr.y[ky].na;
                n:=3;
                s:='   ';
                cf:=0;
                cb:=15;
                cfk:=15;
                cbk:=0;
                End;
             ReadStr(ww);
             If not(ww.esc) then
                Begin
                val(ww.s,i,j);
                If j=0 then
                   Begin
                   seek(frm,m1s+ky-2);
                   Read(frm,gm);
                   gm.num:=i;
                   ModNO;
                   seek(frm,m1s+ky-2);
                   Write(frm,gm);
                   goto MSupBeg;
                   End;
                End;
             End;
          2: begin
             With ww do
                Begin
                x:=sr.x[kx].na;
                y:=sr.y[ky].na;
                n:=5;
                s:='     ';
                cf:=0;
                cb:=15;
                cfk:=15;
                cbk:=0;
                End;
             ReadStr(ww);
             If not(ww.esc) then
                Begin
                val(ww.s,i,j);
                If (j=0) and (i in [1..SizeOfBaza]) then
                   Begin
                   seek(frm,m1s+ky-2);
                   Read(frm,gm);
                   gm.typ:=i;
                   GM.Sbtyp:=1;
                   ModNO;
                   gm.nokf:=true;
                   With baza[gm.typ,gm.sbtyp] do
                      begin
                      gm.nkf:=nkf;
                      gm.IO:=A0;
                      gm.pna:=namekf;
                      for i:=1 to nkf do
                         gm.PA[i]:=0;
                      end;
                   seek(frm,m1s+ky-2);
                   Write(frm,gm);
                   goto MsupBeg;
                   End;
                End;
             End;
          3: begin
             With ww do
                Begin
                x:=sr.x[kx].na;
                y:=sr.y[ky].na;
                n:=8;
                s:='        ';
                cf:=0;
                cb:=15;
                cfk:=15;
                cbk:=0;
                End;
             ReadStr(ww);
             If not(ww.esc) then
                Begin
                val(ww.s,i,j);
                   seek(frm,m1s+SR.ky-2);
                   Read(frm,gm);
                   Tip:=Gm.typ;
                If (j=0) and (i in [1..KonfBaza[Tip]]) then
                   Begin
                   seek(frm,m1s+ky-2);
                   Read(frm,gm);
                   gm.sbtyp:=i;
                   gm.nokf:=true;
                   ModNO;
                   With baza[gm.typ,gm.sbtyp] do
                      begin
                      gm.nkf:=nkf;
                      gm.IO:=A0;
                      gm.pna:=namekf;
                      for i:=1 to nkf do
                         gm.PA[i]:=0;
                      end;
                   seek(frm,m1s+ky-2);
                   Write(frm,gm);
                   goto MSupBeg;
                   End;
                End;
             End;
          4: begin
             With ww do
                Begin
                x:=sr.x[kx].na;
                y:=sr.y[ky].na;
                n:=14;
                s:='              ';
                cf:=0;
                cb:=15;
                cfk:=15;
                cbk:=0;
                End;
             ReadStr(ww);
             If not(ww.esc) then
                Begin
                   seek(frm,m1s+ky-2);
                   Read(frm,gm);
                   gm.name:=ww.s;
                   seek(frm,m1s+ky-2);
                   Write(frm,gm);
                   goto MSupBeg;
                End;
             End;
          5: Begin
             GetKf(m1s+ky-2);
             Goto MSupBeg;
             End;
          6: begin
             With ww do
                Begin
                x:=sr.x[kx].na;
                y:=sr.y[ky].na;
                n:=13;
                s:='             ';
                cf:=0;
                cb:=15;
                cfk:=15;
                cbk:=0;
                End;
             ReadStr(ww);
             If not(ww.esc) then
                Begin
                val(ww.s,rl,j);
                If j=0 then
                   Begin
                   seek(frm,m1s+ky-2);
                   Read(frm,gm);
                   gm.io:=rl;
                   ModNO;
                   seek(frm,m1s+ky-2);
                   Write(frm,gm);
                   goto MSupBeg;
                   End;
                End;
             End;
          end;
    end;
   case vr2 of
    #80: Begin
         If m1s+ny<filesize(frm) Then
            Begin
            Inc(m1s);
            GoTo MSupBeg;
            End;
         End;
    #72: Begin
         If m1s>1 Then
            Begin
            Dec(m1s);
            GoTo MSupBeg;
            End;
         End;
    #83: If Filesize(frm)>1 then
         begin
         DelStrM(m1s+ky-2);
         GoTo MSupBeg;
         end;
    #82: Begin
         InsStrM(m1s+ky-2);
         GoTo MSupBeg;
         End;
    end;
   end;
 until sr.vr1=#27;
 sr.clr:=true;
 select(SR);
end;

{-------------------------------------------}

PROCEDURE DISK;
var m:menutype;
    vrr:frrtype;
    vrm:frmtype;
   begin
   with m do
    begin
    x:=20;
    y:=10;
    {a[*]:='   Загрузить таблицу режимов с диска.   ';}
    a[1]:='   Загрузить таблицу элементов с диска. ';
{    a[*]:='   Создать новую таблицу режимов.       ';  }
    a[2]:='   Создать новую таблицу элементов.     ';
    n:=2;
    k:=1;
    esc:=true;
    cb:=white;
    cf:=black;
    end;
   repeat
    menu(m);
    If m.v then
    Case m.k of
{       1:Begin
         With ww do
            Begin
            x:=12;
            y:=7;
            n:=12;
            s:='noname  .dar';
            cf:=0;
            cb:=15;
            cfk:=15;
            cbk:=0;
            End;
         ReadStr(ww);
         If not(ww.esc) then
            Begin
            Close(frr);
            If IoResult<>0 Then
               begin
               end;
            Assign(frr,ww.s);
            Reset(frr);
            If IoResult<>0 Then
               Begin
               Nofiler:=true;
               End
            else
               begin
               nofiler:=false;
               r1s:=1;
               End;
            End;
         End; }
       1:Begin
         With ww do
            Begin
            x:=12;
            y:=7;
            n:=12;
            s:='noname  .dam';
            cf:=0;
            cb:=15;
            cfk:=15;
            cbk:=0;
            End;
         ReadStr(ww);
         If not(ww.esc) then
            Begin
            Close(frm);
            If IoResult<>0 Then;
            Assign(frm,ww.s);
            Reset(frm);
            If IoResult<>0 Then
               Begin
               Nofilem:=true;
               End
            Else
               begin
               Nofilem:=false;
               m1s:=1;
               end;
            End;
         End;
     {3:Begin
         With ww do
            Begin
            x:=12;
            y:=7;
            n:=12;
            s:='noname  .dar';
            cf:=0;
            cb:=15;
            cfk:=15;
            cbk:=0;
            End;
         ReadStr(ww);
         If not(ww.esc) then
            Begin
            Close(frr);
            If IoResult<>0 Then;
            Assign(frr,ww.s);
            Rewrite(frr);
            If IoResult<>0 Then
               Begin
               Nofiler:=true;
               End
            else
               Begin
               nofiler:=false;
               with vrr do
                  begin
                  kh:=13;
                  end;
               write(frr,vrr);
               r1s:=1;
               End;
            End;
         End;}
       2:Begin
         With ww do
            Begin
            x:=12;
            y:=7;
            n:=12;
            s:='noname  .dam';
            cf:=0;
            cb:=15;
            cfk:=15;
            cbk:=0;
            End;
         ReadStr(ww);
         If not(ww.esc) then
            Begin
            Close(frm);
            If IoResult<>0 Then;
            Assign(frm,ww.s);
            Rewrite(frm);
            If IoResult<>0 Then
               Begin
               Nofilem:=true;
               End
            else
               Begin
               nofilem:=false;
               with vrm do
                  begin
                  num:=1;
                  typ:=1;sbtyp:=1;
                  name:='Не задано';
                  nkf:=baza[1,1].nkf;
                  IO:=baza[1,1].A0;
                  pna:=baza[1,1].namekf;
                  for i:=1 to nkf do
                      PA[i]:=0;
                  NoKf:=True;
                  NO:=0;
                  end;
               write(frm,vrm);
               m1s:=1;
               End;
            End;
         End;
    End;
   until m.v=false;
  end;

{-------------------------------------------------}

procedure perform;
   var IOS:Real;
       dd:Word;
   begin
      WriteXYR(20,12,' Пожалуйста, подождите... ',red,yellow);
      Seek(frm,0);
      IOS:=0;
      dd:=0;
      For i:=1 to filesize(frm) do
         begin
         Read(frm,gm);
         If gm.NO=0 then
            inc(dd);
         IOS:=IOS+gm.NO;
         end;
      Delay(1000);
      Writexyr(20,12,' Суммарная интенсивность отказов :',green,yellow);
      TextAttr:=LightMagenta;
      Gotoxy(55,12);
      Write(IOS);
      str(dd,srab);
      If dd>0 then
         Writexyr(20,13,' Нет информации по '+
            srab+' элементам.',black,lightcyan);
      TextAttr:=White;
      while keypressed do
         r:=readkey;
      r:=readkey;
   end;

{-------------------------------------------------}

PROCEDURE READSTR(var w:readstrtype);
var m:array[1..1000]of byte;
    r1,r2:char;
    k:byte;

procedure sets(s:string; x,y,n1,n2,cf,cb,cfk,cbk,k:byte);
var i:byte;
begin
 for i:=n1 to n2 do
  begin
  if i=k then writexyR(x+i-1,y,s[i],cfk,cbk)
         else writexyR(x+i-1,y,s[i],cf,cb);
  end;
end;

BEGIN
 while keypressed do r1:=readkey;
 r1:=#0; r2:=r1;
 k:=1;
 with w do
  begin
  esc:=false;
  SAVEWINDOW(x,y,x+n,y,addr(m));
  sets(s,x,y,1,n,cf,cb,cfk,cbk,k);
  repeat
   r1:=#0; r2:=#0;
   r1:=readkey;
   if r1=#0 then r2:=readkey;
   if ((r1>#96)and(r1<#123))or((r1>#64)and(r1<#91))
      or((r1>='0')and(r1<='9'))or(r1=' ')or(r1='_')
      or (r1='.') or (r1='-')then
    begin
    s[k]:=r1;
    sets(s,x,y,k,k,cf,cb,cfk,cbk,k);
    r2:=#77;
    end;
   if (r2=#77)and(k<n) then
    begin
    inc(k);
    sets(s,x,y,k-1,k,cf,cb,cfk,cbk,k);
    end;
   if (r2=#75)and(k>1) then
    begin
    dec(k);
    sets(s,x,y,k,k+1,cf,cb,cfk,cbk,k);
    end;
  until(r1=#13)or(r1=#27);
  if r1=#27 then esc:=true;
  LOADWINDOW(x,y,x+n,y,addr(m));
  For i:=length(s) downto 1 do
     begin
     If s[i]=' ' then
        s[0]:=char(length(s)-1)
     else
        break;
     end;
  end;
END;

{-------------------------------------------------}

PROCEDURE Visfrm(fpos:word;ScrPos:Byte;tt:tabtype);
   Var qq:FrmType;
   Begin
      Seek(frm,Fpos-1);
      Read(frm,qq);
      With tt do
         Begin
         str(fpos:3,srab);
         WriteXYR(lx[1]+x,y+ly[2]+scrpos-1,srab,blue,white);
         str(qq.num:3,srab);
         WriteXYR(lx[2]+x,y+ly[2]+scrpos-1,srab,blue,white);
         str(qq.typ:5,srab);
         WriteXYR(lx[3]+x,y+ly[2]+scrpos-1,srab,blue,white);
         str(qq.sbtyp:8,srab);
         WriteXYR(lx[4]+x,y+ly[2]+scrpos-1,srab,blue,white);
         WriteXYR(lx[5]+x,y+ly[2]+scrpos-1,qq.name,blue,white);
         If qq.NoKf Then
            srab:='Не введены.'
                    Else
            srab:='Введены.';
         WriteXYR(lx[6]+x,y+ly[2]+scrpos-1,srab,blue,white);
         str(qq.IO:13,srab);
         WriteXYR(lx[7]+x,y+ly[2]+scrpos-1,srab,blue,white);
         str(qq.NO:11,srab);
         WriteXYR(lx[8]+x,y+ly[2]+scrpos-1,srab,blue,white);
         End;
   End;

{-------------------------------------------------}

PROCEDURE INITBAZA;

BEGIN
kf[1]:='К(р)';
kf[2]:='К(t)';
kf[3]:='К(э)';
kf[4]:='К(ам)';
kf[5]:='К(к.обсл)';
kf[6]:='К(сл)';
kf[7]:='К(попр)';
kf[8]:='К(ф)';
kf[9]:='К(д.н)';
kf[10]:='К(S1)';
kf[11]:='К(f)';
kf[12]:='К(с)';
kf[13]:='К(п.с)';
kf[14]:='К(R)';
kf[15]:='К(м)';
kf[16]:='К(к.к)';
kf[17]:='К(к.с)';
kf[18]:='К(сум.)';
kf[19]:='***';
kf[20]:='***';

Limkf[1,1]:=0.003;
Limkf[1,2]:=120.72;
limkf[2,1]:=0.1;
limkf[2,2]:=40;
limkf[3,1]:=1;
limkf[3,2]:=2;
limkf[4,1]:=0;
limkf[4,2]:=0;
limkf[5,1]:=0;
limkf[5,2]:=0;
limkf[6,1]:=1;
limkf[6,2]:=3;
limkf[7,1]:=0.2;
limkf[7,2]:=0.7;
limkf[8,1]:=0.25;
limkf[8,2]:=15;
limkf[9,1]:=0.5;
limkf[9,2]:=10;
limkf[10,1]:=0.5;
limkf[10,2]:=3;
limkf[11,1]:=1;
limkf[11,2]:=30;
limkf[12,1]:=0.4;
limkf[12,2]:=2.65;
limkf[13,1]:=1;
limkf[13,2]:=5;
limkf[14,1]:=0.3;
limkf[14,2]:=2;
limkf[15,1]:=0.7;
limkf[15,2]:=4.5;
limkf[16,1]:=0.25;
limkf[16,2]:=100;
limkf[17,1]:=0.39;
limkf[17,2]:=1;
limkf[18,1]:=0.001;
limkf[18,2]:=1000;
limkf[19,1]:=0;
limkf[19,2]:=0;
limkf[20,1]:=0;
limkf[20,2]:=0;
for i:=1 to 10 do
 for j:=1 to 15 do
  with baza[i,j] do
   begin;
   a0:=0;
   nkf:=0;
   end;
SizeOfBaza:=10;
KonfBaza[1]:=3;
KonfBaza[2]:=12;
KonfBaza[3]:=5;
KonfBaza[4]:=11;
KonfBaza[5]:=8;
KonfBaza[6]:=3;
KonfBaza[7]:=3;
KonfBaza[8]:=8;
KonfBaza[9]:=3;
KonfBaza[10]:=1;

with baza[1,1] do  {ИС п/п анал}
 begin
 a0:=0.22E6;
 nkf:=3;
 namekf[1]:=6;
 namekf[2]:=3;
 namekf[3]:=7;
 end;

 with baza[1,2] do  {ИС п/п цифр}
 begin
 a0:=0.21E6;
 nkf:=3;
 namekf[1]:=6;
 namekf[2]:=3;
 namekf[3]:=7;
 end;

 with baza[1,3] do  {ИС гибр}
 begin
 a0:=0.42E6;
 nkf:=3;
 namekf[1]:=6;
 namekf[2]:=3;
 namekf[3]:=7;
 end;

with baza[2,1] do  {диоды выпрям}
 begin
 a0:=0.09e6;
 nkf:=5;
 namekf[1]:=1;
 namekf[2]:=8;
 namekf[3]:=9;
 namekf[4]:=10;
 namekf[5]:=3;
 end;

with baza[2,2] do  {диоды универ}
 begin
 a0:=0.1e6;
 nkf:=5;
 namekf[1]:=1;
 namekf[2]:=8;
 namekf[3]:=9;
 namekf[4]:=10;
 namekf[5]:=3;
 end;

with baza[2,3] do  {диоды импуль}
 begin
 a0:=0.045e6;
 nkf:=5;
 namekf[1]:=1;
 namekf[2]:=8;
 namekf[3]:=9;
 namekf[4]:=10;
 namekf[5]:=3;
 end;

with baza[2,4] do  {столбы выпрям}
 begin
 a0:=0.7e6;
 nkf:=5;
 namekf[1]:=1;
 namekf[2]:=8;
 namekf[3]:=9;
 namekf[4]:=10;
 namekf[5]:=3;
 end;

with baza[2,5] do  {варикапы подстр}
 begin
 a0:=0.1e6;
 nkf:=5;
 namekf[1]:=1;
 namekf[2]:=8;
 namekf[3]:=9;
 namekf[4]:=10;
 namekf[5]:=3;
 end;

with baza[2,6] do  {диодные сборки}
 begin
 a0:=0.05e6;
 nkf:=5;
 namekf[1]:=1;
 namekf[2]:=8;
 namekf[3]:=9;
 namekf[4]:=10;
 namekf[5]:=3;
 end;

with baza[2,7] do  {стабилитроны}
 begin
 a0:=0.07e6;
 nkf:=2;
 namekf[1]:=1;
 namekf[2]:=3;
 end;

with baza[2,8] do  {СВЧ смесительные}
 begin
 a0:=1.45e6;
 nkf:=2;
 namekf[1]:=1;
 namekf[2]:=3;
 end;

with baza[2,9] do  {СВЧ парам}
 begin
 a0:=0.56e6;
 nkf:=2;
 namekf[1]:=1;
 namekf[2]:=3;
 end;

with baza[2,10] do  {СВЧ переключ и огр}
 begin
 a0:=0.35e6;
 nkf:=2;
 namekf[1]:=1;
 namekf[2]:=3;
 end;

with baza[2,11] do  {СВЧ умнож и настр}
 begin
 a0:=1.5e6;
 nkf:=2;
 namekf[1]:=1;
 namekf[2]:=3;
 end;

with baza[2,12] do  {СВЧ генерат}
 begin
 a0:=0.31e6;
 nkf:=2;
 namekf[1]:=1;
 namekf[2]:=3;
 end;

with baza[3,1] do {транз бипол кроме мощн СВЧ}
 begin
 a0:=0.29e6;
 nkf:=5;
 namekf[1]:=1;
 namekf[2]:=8;
 namekf[3]:=9;
 namekf[4]:=10;
 namekf[5]:=3;
 end;

with baza[3,2] do {транз бипол мощн СВЧ}
 begin
 a0:=0.4e6;
 nkf:=4;
 namekf[1]:=8;
 namekf[2]:=2;
 namekf[3]:=11;
 namekf[4]:=3;
 end;

with baza[3,3] do {транз сборки}
 begin
 a0:=0.3e6;
 nkf:=5;
 namekf[1]:=1;
 namekf[2]:=8;
 namekf[3]:=9;
 namekf[4]:=10;
 namekf[5]:=3;
 end;

with baza[3,4] do {транз полев}
 begin
 a0:=0.3e6;
 nkf:=3;
 namekf[1]:=1;
 namekf[2]:=8;
 namekf[3]:=3;
 end;

with baza[3,5] do {тиристоры}
 begin
 a0:=0.45e6;
 nkf:=3;
 namekf[1]:=1;
 namekf[2]:=9;
 namekf[3]:=3;
 end;

with baza[4,1] do {керамические (U < 1600 B)}
 begin
 a0:=0.012e6;
 nkf:=3;
 namekf[1]:=1;
 namekf[2]:=3;
 namekf[3]:=12;
 end;

with baza[4,2] do {керамические (U > 1600 B)}
 begin
 a0:=0.15e6;
 nkf:=3;
 namekf[1]:=1;
 namekf[2]:=3;
 namekf[3]:=12;
 end;

with baza[4,3] do {тонкопленочные с
                   неорганическим диэлектриком}
 begin
 a0:=0.02e6;
 nkf:=2;
 namekf[1]:=1;
 namekf[2]:=3;
 end;

with baza[4,4] do {стеклокерамические}
 begin
 a0:=0.02e6;
 nkf:=3;
 namekf[1]:=1;
 namekf[2]:=3;
 namekf[3]:=12;
 end;

with baza[4,5] do {слюдяные}
 begin
 a0:=0.01e6;
 nkf:=3;
 namekf[1]:=1;
 namekf[2]:=3;
 namekf[3]:=12;
 end;

with baza[4,6] do {оксид-э-электролитические алюминиевые}
 begin
 a0:=0.05e6;
 nkf:=3;
 namekf[1]:=1;
 namekf[2]:=3;
 namekf[3]:=12;
 end;

with baza[4,7] do {оксидно-п/п}
 begin
 a0:=0.02e6;
 nkf:=4;
 namekf[1]:=1;
 namekf[2]:=3;
 namekf[3]:=12;
 namekf[4]:=13;
 end;

with baza[4,8] do {с органическим синтетическим диэлектриком
                   низковольтные}
 begin
 a0:=0.01e6;
 nkf:=3;
 namekf[1]:=1;
 namekf[2]:=3;
 namekf[3]:=12;
 end;

with baza[4,9] do {с органическим синтетическим диэлектриком
                   высоковольтные}
 begin
 a0:=0.5e6;
 nkf:=3;
 namekf[1]:=1;
 namekf[2]:=3;
 namekf[3]:=12;
 end;

with baza[4,10] do {бумажные}
 begin
 a0:=0.005e6;
 nkf:=3;
 namekf[1]:=1;
 namekf[2]:=3;
 namekf[3]:=12;
 end;

with baza[4,11] do {подстроечные с твердым диэлектриком}
 begin
 a0:=0.02e6;
 nkf:=2;
 namekf[1]:=1;
 namekf[2]:=3;
 end;

with baza[5,1] do {постоянные непроволочные металло диэлектрические}
 begin
 a0:=0.01e6;
 nkf:=4;
 namekf[1]:=1;
 namekf[2]:=3;
 namekf[3]:=14;
 namekf[4]:=15;
 end;

with baza[5,2] do {постоянные непроволочные углеродистые}
 begin
 a0:=0.01e6;
 nkf:=3;
 namekf[1]:=1;
 namekf[2]:=3;
 namekf[3]:=14;
 end;

with baza[5,3] do {постоянные проволочные и металлофальговые}
 begin
 a0:=0.02e6;
 nkf:=3;
 namekf[1]:=1;
 namekf[2]:=3;
 namekf[3]:=14;
 end;

with baza[5,4] do {переменные проволочные}
 begin
 a0:=0.03e6;
 nkf:=3;
 namekf[1]:=1;
 namekf[2]:=3;
 namekf[3]:=14;
 end;

with baza[5,5] do {переменные непроволочные}
 begin
 a0:=0.01e6;
 nkf:=4;
 namekf[1]:=1;
 namekf[2]:=3;
 namekf[3]:=14;
 namekf[4]:=10;
 end;

with baza[5,6] do {резистивные микросхемы}
 begin
 a0:=0.01e6;
 nkf:=2;
 namekf[1]:=1;
 namekf[2]:=3;
 end;

with baza[5,7] do { наборы резисторов}
 begin
 a0:=0.02e6;
 nkf:=3;
 namekf[1]:=1;
 namekf[2]:=3;
 namekf[3]:=14;
 end;

with baza[5,8] do { термо резисторы}
 begin
 a0:=0.02e6;
 nkf:=1;
 namekf[1]:=3;
 end;

with baza[6,1] do { переключатели и тумблеры}
 begin
 a0:=0.07e6;
 nkf:=3;
 namekf[1]:=1;
 namekf[2]:=3;
 namekf[3]:=16;
 end;

with baza[6,2] do { магнитно управляемые контакты}
 begin
 a0:=5.5e9;
 nkf:=1;
 namekf[1]:=3;
 end;

with baza[6,3] do { предохранители}
 begin
 a0:=0.16e6;
 nkf:=2;
 namekf[1]:=2;
 namekf[2]:=3;
 end;

with baza[7,1] do { силовые трансформаторы}
 begin
 a0:=1.7e6;
 nkf:=2;
 namekf[1]:=2;
 namekf[2]:=3;
 end;

with baza[7,2] do { выходные строчные трансформаторы}
 begin
 a0:=3e6;
 nkf:=2;
 namekf[1]:=2;
 namekf[2]:=3;
 end;

with baza[7,3] do { межкаскадные строчные трансформаторы}
 begin
 a0:=0.11e6;
 nkf:=2;
 namekf[1]:=2;
 namekf[2]:=3;
 end;

with baza[8,1] do { НЧ соединители цилиндрические нормальных габаритов}
 begin
 a0:=0.0067e6;
 nkf:=4;
 namekf[1]:=1;
 namekf[2]:=16;
 namekf[3]:=17;
 namekf[4]:=3;
 end;

with baza[8,2] do { НЧ соединители цилиндрические малогабаритные}
 begin            { для об'емного монтажа}
 a0:=0.0013e6;
 nkf:=4;
 namekf[1]:=1;
 namekf[2]:=16;
 namekf[3]:=17;
 namekf[4]:=3;
 end;

with baza[8,3] do { НЧ соединители цилиндрические малогабаритные}
 begin            { для печатного монтажа}
 a0:=0.0017e6;
 nkf:=4;
 namekf[1]:=1;
 namekf[2]:=16;
 namekf[3]:=17;
 namekf[4]:=3;
 end;

with baza[8,4] do { НЧ соединители прямоугольные номальных габаритов}
 begin            { для об'емного монтажа}
 a0:=0.005e6;
 nkf:=4;
 namekf[1]:=1;
 namekf[2]:=16;
 namekf[3]:=17;
 namekf[4]:=3;
 end;

with baza[8,5] do { НЧ соединители прямоугольные номальных габаритов}
 begin            { для печатного монтажа}
 a0:=0.0009e6;
 nkf:=4;
 namekf[1]:=1;
 namekf[2]:=16;
 namekf[3]:=17;
 namekf[4]:=3;
 end;

with baza[8,6] do { НЧ соединители прямоугольные малогабаритные}
 begin            { для об'емного монтажа}
 a0:=0.01e6;
 nkf:=4;
 namekf[1]:=1;
 namekf[2]:=16;
 namekf[3]:=17;
 namekf[4]:=3;
 end;

with baza[8,7] do { НЧ соединители прямоугольные малогабаритные}
 begin            { для печатного монтажа}
 a0:=0.006e6;
 nkf:=4;
 namekf[1]:=1;
 namekf[2]:=16;
 namekf[3]:=17;
 namekf[4]:=3;
 end;

with baza[8,8] do { НЧ соединители прямоугольные малогабаритные}
 begin            { для печатного и об'емного монтажа}
 a0:=0.022e6;
 nkf:=4;
 namekf[1]:=1;
 namekf[2]:=16;
 namekf[3]:=17;
 namekf[4]:=3;
 end;

with baza[9,1] do { Пайка }
 begin
 a0:=0.022e6;
 nkf:=1;
 namekf[1]:=3;
 end;

with baza[9,2] do { Сварка}
begin
 a0:=0.022e6;
 nkf:=1;
 namekf[1]:=3;
 end;

with baza[9,3] do { Клепка}
 begin
 a0:=0.022e6;
 nkf:=1;
 namekf[1]:=3;
 end;
with baza[10,1] do { Неопределенный тип}
 begin
 a0:=0;
 nkf:=1;
 namekf[1]:=18;
 end;
END;

{-------------------------------------------------}

PROCEDURE GETKF(filepos:Word);
label mlbeg;
var t:tabtype;
    sr:selecttype;
    buf:array[1..4000]of byte;
 Begin
 sr.kx:=1; sr.ky:=1;
mlbeg:Seek(frm,filepos);
 Read(frm,gm);
 If gm.nkf=0 then
    exit;
 with t do
  begin
  name:=' Ввод значений коэффициeнтов';
  x:=2; y:=5;
  dlx:=36; dly:=gm.nkf+4;
  savewindow(x,y,x+dlx,y+dly,addr(buf));
  nx:=3; ny:=3;
  lx[1]:=1; lx[2]:=19; lx[3]:=dlx+1;
  ly[1]:=2; ly[2]:=4;  ly[3]:=dly+1;
  np:=2;
  for i:=0 to np do punkt[i]:='';
  punkt[1]:='  Коэф-т';
  punkt[2]:='    Значение';
  lc:=lightgray; fc:=0; nc:=7; pc:= 12;
  end;
 tab(t);
 For i:=1 to gm.nkf do
    begin
    writexyr(t.x+t.lx[1],t.y+t.ly[1]+i+1,kf[gm.pna[i]],0,15);
    str(gm.pa[i],srab);
    writexyr(t.x+t.lx[2],t.y+t.ly[1]+i+1,srab,0,15);
    End;
 With SR do
    Begin
    viz:=true;
    clr:=false;
    ocf:=1;
    ocb:=white;
    cf:=green;
    cb:=0;
    cfk:=5;
    cbk:=14;
    nx:=1;
    ny:=gm.nkf;
    s1:=#27+#13+#9;
    s2:='';
    For i:=1 to ny do
       Begin
       y[i].na:=i+t.y+3;
       y[i].ko:=y[i].na;
       End;
    For i:=1 to nx do
       Begin
       x[i].na:=t.lx[i+1]+t.x;
       x[i].ko:=t.lx[i+2]+t.x-2;
       End;
    End;
 repeat
  Select(SR);
  with sr do
   begin
   viz:=false;
   case vr1 of
       #9: begin
           PutHelp('Help.rel',' '+kf[gm.pna[ky]]+' ',[#27],1,8);
           end;
      #13: Begin
           With ww do
              Begin
              x:=sr.x[kx].na;
              y:=sr.y[ky].na;
              n:=17;
              s:='                 ';
              cf:=0;
              cb:=15;
              cfk:=15;
              cbk:=0;
              End;
           ReadStr(ww);
           If not(ww.esc) then
              Begin
              val(ww.s,rl,j);
              If j=0 then
                 Begin
                If (rl>=limkf[gm.PNA[ky],1])And
                   (rl<=limkf[gm.PNA[ky],2])
                 Then
                  Begin
                 gm.pa[ky]:=rl;
                 seek(frm,filepos);
                 Write(frm,gm);
                 goto MlBeg;
                  End
                 Else PutHelp('Help.Rel',' Вне границы ',[#27],4,8);
                 End
                 Else PutHelp('Help.Rel',' Маразм ',[#27],4,8);
              End;
           End;
    end;
   end;
 until sr.vr1=#27;
 sr.clr:=true;
 select(SR);
 gm.nokf:=false;
 For I:=1 to gm.nkf do
    If gm.pa[i]=0 then
       begin
       gm.nokf:=true;
       break;
       end;
  ModNO;
  seek(frm,filepos);
  Write(frm,gm);
  with t do
   loadwindow2(x,y,x+dlx,y+dly,addr(buf),true);
end;

END.