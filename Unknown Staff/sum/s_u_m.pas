{                                N      N        N             1
  �� �ணࠬ�� ������ �㬬� �      �   .....�     �������������������
                               i(1)=1 i(2)=1   i(N)=1   i(1)+i(2)+...i(N)
    ����� �蠥��� �� N^N ���権.
 �⤥��� ������ �㬬� ��������� ���� ᯮᮡ��� :
 1.
   � ������ ���樨 �ணࠬ�� ���頥��� � ४��ᨢ���
   ��楤�� GetAr ,����� ������� ���� ��� ��᪮�쪮
   ����⮢ ������쭮�� ���ᨢ� P ,������ ���ண�
   ᮤ���� ���祭�� ���稪�� (i(1),i(2),...,i(N)).
   ��⥬ ��� �㬬������� � ������ ���⭠� ����稭�.
 2.
   ������� ��६����� X , ࠢ��� � ������ ���樨
   �㬬� : i(1)+i(2)+...+i(N).
   �᭮ �� � ��砫� X ࠢ�� N.
   � ������ ���樨 � X �ਡ������� ���祭�� �㭪樨 DX,
   � ������ ���⭠� ����稭�.

 ����� ��ࠧ�� �������� �⤥��� ����� �㬬�.
 � ������ ���樨 ���᫥��� ����� �㬬� �ਡ�������
 � �।��饬�.
}
Program UDS;
Uses Crt,Dos;
Label 1;
const null=-2147483647;
    v1=' ���� ��⮤  ';
    v2=' ��ன ��⮤  ';
Var
  P:array[1..255] of byte;
  r,v,b:boolean;
  x,zn,ch:integer;
  e,o:array[1..3] of string[20];
  q,i:longint;
  h,m,sec,sec100,a,f,t,y:word;
  s:real;
  mas:array[1..10] of integer;
  gr,d,w,u,j,n:byte;
  st:string[8];
  c:char;
{--Z-----------------------------------------------------------}
procedure clb;
begin
     inline($FA);
          MemW[0:$41A]:=MemW[0:$41C];
     inline($FB);
end;
{-----------------------------------------}
Procedure GetAr(k:byte;Var Full:boolean);
Begin
 if k<=n then
   Begin
      GetAr(k+1,Full);
      if Full then
               if p[k]<n then
                          begin
                            p[k]:=p[k]+1;
                            full:=false;
                            Exit
                          End
                         else
                          if k<>1 then p[k]:=1
                                  else;
  End
         else
            Full:=true;
End;
{------------------------------------------------}
Function DX:integer;
var v:boolean;j:byte;
Begin
  v:=true;
  j:=2;
 if (i-null) mod n <>0 then dx:=1
 else
     While v do
      if (i-null) mod round(exp(j*ln(n))) <>0 then
      begin DX:=mas[j-1];v:=false end
      else inc(j);
End;
{------------------------------------------------}
Function quit(x,y,gr:byte):char;
begin
textbackground(4);
window(39,21,76,22);
clrscr;
gotoxy(2,2);
write(' ��� ��室� �� �ணࠬ�� ������-Esc ');
write('       ������ � ��砫�-TAB ');
quit:=readkey;
textbackground(1);
clrscr;
window(1,4,80,24);
gotoxy(x,y);
textbackground(gr);
end;
{---------------------------------------------------}
procedure cl;
begin
textbackground(0);
 window(1,1,80,25);
 clrscr
end;
{-------------------------------------}
Procedure ver;
var k:1..2;c:char;
Begin
cl;
 gotoxy(27,24);
 TextColor(13);Write('� � � � � � � �  � � � � � :');
 gotoxy(13,25);
 Write(v1);gotoxy(50,25);
 TextColor(15);TextBackGround(4);
 Write(v2);gotoxy(1,1);textbackground(0);
 k:=2;
  Repeat
      c:=readkey;
      if c=#0 then c:=readkey;
     if (c=#75)or(c=#77)then
      Begin
        Textcolor(15);TextBackGround(4);
        if k=2 then Begin gotoxy(13,25);Write(v1) End
        else Begin gotoxy(50,25); write(v2) End;
       TextColor(13);TextBackGround(0);
       if k=2 then Begin gotoxy(50,25); write(v2) End
       else Begin gotoxy(13,25);Write(v1) End;
        if k=2 then k:=1 else k:=2;gotoxy(1,1);
      End;
  Until c=#13;
  if k=1 then v:=true else v:=false;
  textbackground(3);
  textcolor(5);
  clrscr;
  gotoxy(21,1);
  textbackground(2);
  write(' � � � � � � � � � �  � � � � � ');
  gotoxy(30,2);textbackground(5);textcolor(14);
  if v then writeln(v1) else writeln(v2);
textbackground(1);
  for i:=1 to 80 do write(#196);
  window(1,25,80,25);
  textbackground(7);
  textcolor(4);
  clrscr;
  e[1]:='  Esc';
  o[1]:='-��室    ';
  e[2]:='Esc-TAB';
  o[2]:='-� ��砫�  ';
  e[3]:='[+]';
  o[3]:='-����� ��⮤�';
  for i:=1 to 3 do
  begin
   textcolor(4);
   write (e[i]);
   textcolor(0);
   write (o[i]);
  end;write('  (������� ⮫쪮 � ��砫�)');
  window(1,4,80,24);
End;
{------------------------------------------------}
Procedure nc;
Begin
repeat
if c=#27 then
  begin
   c:=quit(wherex,wherey,1);
   if c=#27 then begin cl;halt end;
  end;
 clb; c:=readkey;
 until c<>#27;
End;
{--------------------------------------------}
Procedure opr;
Begin
    repeat
    c:=readkey;
    if c=#27 then nc;
    until c<>#27;
End;
{--------------------------------------------}
BEGIN
  ver;
1: textbackground(1);
  clrscr;
  textcolor(14);
  gotoxy(1,1);
  writeln('������ �᫮ ���������� (2..10)');
  repeat
  c:=readkey;
  nc;
  if c='+' then begin ver; goto 1 end;
     gotoxy(40,1);clreol;
     readln(st);
     val(st,n,x)
  until (x=0)and((n>1)and(n<=9));
  if not v then
 for i:=1 to n-1 do mas[i]:=-i*(n-1)+1;
  d:=3;
                writeln('�������� �筮��� (Y/..)?'+
                '(�� 㬮�砭�� "&.XXX")');
                opr;
                if (c='y')or(c='Y') then
                begin
       writeln('������ �᫮ ������ ��� ��᫥ ����⮩ (0..11) : ');
             repeat
                gotoxy(55,3);clreol;
                readln(st);
                val(st,d,x)
             until (x=0)and((d>=0)and(d<=11));
                end;
  writeln('�뢮���� �஬������ १����� (Y/..)?');
  c:=readkey;
  if (c='y')or(c='Y') then r:=true
                     else r:=false;
   for i:=1 to n-1 do p[i]:=1;
  p[n]:=1;
  x:=n;
  s:=1/x;
  q:=round(exp(n*ln(n))+null);
  gettime(h,m,sec,sec100);
   clrscr;
  if not r then
                    begin
                    textbackground(5);
                    gotoxy(10,10);
                     write (' �ந�������      ���᫥��� ');
                    end;
if r then gr:=1
     else gr:=5;
     if r and v then
     begin for j:=1 to n do write('  1');writeln(' x=',x) end;
  For i:=null+1 to q-1 do
   Begin
   if v then
    begin
     GetAr(1,b);
     x:=0;
     for j:=1 to n do
       begin
         x:=x+p[j];
       if r then write(p[j]:3);
       end;
    end
        else
    begin
             zn:=DX;
            x:=x+zn;
            if r then write(' dx=',zn);
    end;
             s:=s+1/x;
 if r then  writeln('   x=',x)
else begin u:= round(abs((i+null)/(q+null))*100);
 if w<>u then begin gotoxy(23,10);w:=u;write(w,'%')end else
  end;
     if keypressed then
          begin
          c:=readkey;
          if c=#27 then begin
            c:=quit(wherex,wherey,gr);
          if c=#27 then begin cl; halt end
          else if c=#9 then goto 1;
                        end;
          end;
   End;
   if r then begin
    textbackground(6);
   write(' ������ ���� ������� ');
                c:=readkey
             end;
    textbackground(1);
   clrscr;
   gotoxy(1,2);
    write('� � � � � ');
           writeln('� ',s:0:d);writeln;
           writeln('��᫮ ���������� :',n);
           writeln('������⢮ ���権 :',q-null);
           gettime(a,f,t,y);
           if t>=sec then sec:=t-sec
                     else begin sec:=60-sec+t;f:=f-1 end;
           if f>=m   then m:=f-m
                    else m:=60-m+f;
           write('����祭��� �६� : ',m,' ��� ',sec,' ᥪ ');
           textbackground(4);
           gotoxy(20,22);
 write(' �������-TAB    ��室 - �� ������');
   c:=readkey;
 if c=#9 then goto 1;
 cl;
END.

