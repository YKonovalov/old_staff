Program Redactor;
Uses Crt;
Label 1;
Type
  r=array[1..15,1..100] of string[6];
  chain=array[1..100] of string[6];
  sq=string[6];
Var
  p:r;i,v,j,k:byte;s:array[1..8] of string[2];c:char;
  sr:sq;
  f:file;
  {---------------------------------------}
Procedure SRead(var st:sq;c:char);
var i:integer;
Begin
   st:=c;write(c);
while c<>#13 do
Begin
   c:=readkey;if keypressed then c:=readkey;
  if (length(st)<=5) then
  begin st:=st+c;write(c) end
else if (c=#7)and(length(st)>=1) then
  begin
  gotoxy(wherex-1,wherey);write(' ');
  gotoxy(wherex-1,wherey);
  if length(st)<>1 then st:=copy(st,1,length(st)-1)
else begin st:='0';exit end
  end;
End;
if length(st)<6 then
 for i:=1 to 6-length(st) do write(' ');
End;
{---------------------------------------}
Function Pr(v:sq):sq;
var m:byte;
Begin
m:=1;
while p[i,m]<>'0' do
Begin
if v=p[i,m] then begin
gotoxy(wherex-length(v),wherey);
for m:=1 to length(v) do write(' ');
 pr:='0';exit end;
inc(m);
End;
pr:=v;
End;
{----------------------------------------}
Procedure Remv;
var s:byte;
Begin s:=k+1;
window(wherex-length(p[j,k]),wherey,wherex,20);
 while p[j,s]<>'0' do
 Begin
  p[j,s-1]:=p[j,s];
  write(p[j,s-1]);clreol;
  writeln;
  s:=s+1;
 End;clreol;
window(1,1,80,25);
End;
{----------------------------------------}
Begin textmode(CO80);
 clrscr;
  TextBackGround(2);TextColor(15);
s[1]:='R';s[2]:='C';s[3]:='L';s[4]:='GR';s[5]:='TS';s[6]:='MC';s[7]:='MP';
s[8]:='T';
for i:=1 to 10 do
for j:=1 to 15 do p[i,j]:='0';
  For i:=1 to 58 do
 Begin
   If i=30 then write('EDIT FILE "chim.dat"');
   write(' ')
 End;
  writeln;TextBackGround(0);TextColor(11);
  writeln('C H A I N '' S  N A M B E R :');
  TextColor(14);write(#218);
  For i:=1 to 78 do
  Begin
  if (i+1) mod 10 =0 then write(#194)
  else write(#196);
  End;
   write(#191);
 For i:=0 to 80 do
 if (i-1) mod 10=0 then Begin
                         TextBackGround((i-1) div 10+1);
                         if i>70 then Textbackground(1);
                         if (i=11)or(i=21)or(i=71) then Write(' ');
                        End
Else if i mod 10 =0 then write(#179)
Else if (i+5) mod 10=0 then write(s[(i+5) div 10])
Else Write(' ');
TextBackGround(0); j:=1;
1:Write(#195);
  For i:=1 to 78 do
  Begin
  if (i+1) mod 10 =0 then write(#197)
  else write(#196);
  End;
 write(#180);
 if j=1 then
 Begin
  gotoxy(1,21);j:=5;
  Goto 1;
 End;Writeln;write(#192);
for i:=1 to 78 do
if (i+1) mod 10 =0 then write(#193) else Write(#196);
Write(#217);
 For j:=6 to 20 do
   Begin
      For i:=0 to 8 do
       Begin
         if i=0 then gotoxy(1,j)
         else gotoxy(i*10,j);
         Write(#179);
       End;
   End;
for i:=0 to 8 do
begin
if i=0 then gotoxy(1,22) else gotoxy(i*10,22);
write(#179)
end;
 gotoxy(27,24);
 TextColor(13);Write('S E L E C T  M O D E:');
 gotoxy(13,25);
 Write('B Y  H A N D');gotoxy(50,25);
 TextColor(15);TextBackGround(4);
 Write('A U T O M A T I C');gotoxy(3,6);textbackground(0);
 k:=2;
  Repeat
      c:=readkey;
      if c=#0 then c:=readkey;
     if (c=#75)or(c=#77)then
      Begin
        Textcolor(15);TextBackGround(4);
        if k=2 then Begin gotoxy(13,25);Write('B Y  H A N D') End
        else Begin gotoxy(50,25); write('A U T O M A T I C') End;
       TextColor(13);TextBackGround(0);
       if k=2 then Begin gotoxy(50,25); write('A U T O M A T I C') End
       else Begin gotoxy(13,25);Write('B Y  H A N D') End;
        if k=2 then k:=1 else k:=2;gotoxy(3,6);
      End;
  Until c=#13;
gotoxy(1,24);clreol;gotoxy(1,25);clreol;
gotoxy(3,6);
i:=1;
gotoxy(3,6);textcolor(15);
c:='h';j:=1;k:=1;
if k=2 then i:=0
else i:=0{ ChahgeChain(i)};
While (c<>#82)or(i<>3) do
Begin
  i:=i+1;
  c:=readkey;
  gotoxy(30,2);Sread(sr,c);gotoxy(3,6);
  While c<>#27 do
  Begin
  c:=readkey;if keypressed then c:=readkey;
       v:=j;
      if c=#75 then if j<>1 then j:=j-1 else
 else if c=#77 then if j<>8 then j:=j+1 else
 else if c=#72 then if k<>1 then k:=k-1 else
 else if c=#80 then if (k<>15)and(p[j,k]<>'0') then inc(k) else
{ else if c=#83 then ChangeChain(i)};
     if v<>j then while (p[j,k]='0')and(k>1) do dec(k);
        gotoxy(j*10-7,k+5);
       if (c>=#49)and(c<=#150) then begin SRead(sr,c);
                          if sr<>'0' then
                          Begin
                           p[i,j]:=pr(sr);
                           if (p[j,k]='0')and(p[j,k+1]<>'0') then remv;
                           if (k<>15)and(p[j,k]<>'0') then inc(k);
                           gotoxy(j*10-7,k+5);
                          End;
                    end;
End;
c:=readkey;if keypressed then c:=readkey;
End;
END.

