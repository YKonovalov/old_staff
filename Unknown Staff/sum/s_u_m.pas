{                                N      N        N             1
  Эта программа вычисляет сумму Є      Є   .....Є     ───────────────────
                               i(1)=1 i(2)=1   i(N)=1   i(1)+i(2)+...i(N)
    Задача решается за N^N итераций.
 Отдельные элементы суммы получаются двумя способами :
 1.
   В каждой итерации программа обращается к рекурсивной
   процедуре GetAr ,которая изменяет один или несколько
   элементов глабального массива P ,элементы которого
   содержут значения счетчиков (i(1),i(2),...,i(N)).
   Затем они суммируются и берется обратная величина.
 2.
   Объявляется переменная X , равная в каждой итерации
   сумме : i(1)+i(2)+...+i(N).
   Ясно что в начале X равна N.
   В каждой итерации к X прибавляется значение функции DX,
   и берется обратная величина.

 Таким образом вычисляется отдельный элемент суммы.
 В каждой итерации вычисленный элемент суммы прибавляется
 к предыдущему.
}
Program UDS;
Uses Crt,Dos;
Label 1;
const null=-2147483647;
    v1=' Первый Метод  ';
    v2=' Второй Метод  ';
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
write(' Для выхода из программы нажмите-Esc ');
write('       Возврат в начало-TAB ');
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
 TextColor(13);Write('В Ы Б Е Р И Т Е  М Е Т О Д :');
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
  write(' В Ы Ч И С Л Е Н И Е  С У М М Ы ');
  gotoxy(30,2);textbackground(5);textcolor(14);
  if v then writeln(v1) else writeln(v2);
textbackground(1);
  for i:=1 to 80 do write(#196);
  window(1,25,80,25);
  textbackground(7);
  textcolor(4);
  clrscr;
  e[1]:='  Esc';
  o[1]:='-Выход    ';
  e[2]:='Esc-TAB';
  o[2]:='-В начало  ';
  e[3]:='[+]';
  o[3]:='-Смена метода';
  for i:=1 to 3 do
  begin
   textcolor(4);
   write (e[i]);
   textcolor(0);
   write (o[i]);
  end;write('  (действует только в начале)');
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
  writeln('Введите число вложенности (2..10)');
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
                writeln('Изменить точность (Y/..)?'+
                '(По умолчанию "&.XXX")');
                opr;
                if (c='y')or(c='Y') then
                begin
       writeln('Укажите число значищих цифр после запятой (0..11) : ');
             repeat
                gotoxy(55,3);clreol;
                readln(st);
                val(st,d,x)
             until (x=0)and((d>=0)and(d<=11));
                end;
  writeln('Выводить промежуточные результаты (Y/..)?');
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
                     write (' Произведено      вычислений ');
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
   write(' Нажмите любую клавишу ');
                c:=readkey
             end;
    textbackground(1);
   clrscr;
   gotoxy(1,2);
    write('С У М М А ');
           writeln('ў ',s:0:d);writeln;
           writeln('Число вложенности :',n);
           writeln('Количество итераций :',q-null);
           gettime(a,f,t,y);
           if t>=sec then sec:=t-sec
                     else begin sec:=60-sec+t;f:=f-1 end;
           if f>=m   then m:=f-m
                    else m:=60-m+f;
           write('Затраченное время : ',m,' мин ',sec,' сек ');
           textbackground(4);
           gotoxy(20,22);
 write(' повторить-TAB    Выход - любая клавиша');
   c:=readkey;
 if c=#9 then goto 1;
 cl;
END.

