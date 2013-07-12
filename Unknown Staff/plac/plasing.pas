 PROGRAM PLASING;
   USES CRT,GRAPH,DOS;
 Label 1;
TYPE
  stef=string[5];
  kor= 1..100;
  nt=array[1..100,1..100] of integer;
  korso=array[1..100] of kor;
  korsom=array[1..2,1..100] of kor;
  nam=array[1..100] of integer;
  unt=array[1..100] of real;
  two=array[1..30,1..30] of string[5];
  jh=array[1..1000] of integer;
  jk=array[1..100] of string[5];
  tras=array[1..30,1..30] of real;
  dec=array[1..1000] of integer;
  ch=0..2;
  rec=record
         namechain:jk;
         nameelem:two;
         quanchains:byte;
         traction:tras;
         quanelem:jh;
         s:integer
      end;
  VAR
       fiil:file of rec;
       a:rec;
  st,stp:array[1..30]of string;
               korteg:korsom;
                   ne:NT;
                  bol,v:boolean;
     mx,my,x,x1,y1,y,e,quankort,n,
        dg,lg,p,l,ug,pg,kol,dlx,dly,k,
          dx,dy,ol,ot,
          error,errow:integer;
          nex,ney:dec;
              newchse:jh;
         namberOFelem:nam;
              unitrac:unt;
                 kort:jh;
     newchoise,choise:jk;
              choisen:ch;
                q,i,j:byte;
               chains:longint;
       stkr, stchains:string;
                   b,c:char;
                 poin:pointer;
{------------------------------------------------------------}
      PROCEDURE SORT(M:UNT;VAR T:JK;V,N,Z:INTEGER);
      LABEL 1;
      TYPE AR1=ARRAY[0..100] OF INTEGER;
           AR2=ARRAY[1..100,1..2] OF INTEGER;
      VAR A:AR1;X:AR2;
          I,Q,G,GG,GGG,W,WW,HG,BG,P,K:INTEGER;
          S:REAL;
      PROCEDURE PR (BG,HG,K:INTEGER;VAR A:AR1;VAR T:JK;VAR P:INTEGER);
      LABEL 1,2;
      VAR I,J,C:INTEGER; B:STRING[8];
      BEGIN I:=BG; J:=HG;
2:     IF I<>J THEN
        BEGIN
        IF K*A[I]>0 THEN GOTO 1;
        I:=I+1; GOTO 2;
        END ;
1:     IF J<>I THEN
        BEGIN
        IF K*A[J]<0 THEN
         BEGIN
         C:=A[I];A[I]:=A[J];A[J]:=C;
         B:=T[I];T[I]:=T[J];T[J]:=B;
         GOTO 2;
         END;
        J:=J-1;GOTO 1;
        END ;
       IF K*A[I]>0 THEN P:=I-1
                   ELSE P:=I;
       END;
       BEGIN; S:=0.000000001;
       FOR I:=V TO N DO IF ABS(M[I])>S THEN S:=ABS(M[I]);
       FOR I:=V TO N DO
        BEGIN
        A[I]:=ROUND(M[I]*32760/S);
        IF A[I]=0 THEN A[I]:=1;
        END;
       K:=Z ; X[1,1]:=V-1; X[1,2]:=V-1 ; X[2,1]:=N ; G:=1 ; GG:=2;
       FOR Q:=1 TO 8 DO
        BEGIN W:=1;WW:=1; HG:=0;
        WHILE HG<N DO
         BEGIN BG:=X[W,G]+1;HG:=X[W+1,G];W:=W+1;
         IF BG=HG THEN GOTO 1 ;
         PR (BG,HG,K,A,T,P);K:=(-1)*Z;
         IF P=BG-1 THEN GOTO 1;IF P=HG THEN GOTO 1;
         WW:=WW+1;X[WW,GG]:=P;
 1:      WW:=WW+1;X[WW,GG]:=HG;
         END;
        GGG:=GG;GG:=G;G:=GGG;HG:=0;
        FOR I:=1 TO N DO A[I]:=A[I] SHL 1;
        END;
      END;
{------------------------------------------------------------}
 PROCEDURE spel(n:two;VAR c:jk;
                max:byte;maxy:jh;VAR q:byte);
       LABEL 1;
       VAR h,k,s,i,j:byte;
       BEGIN
            for h:=1 to maxy[1] do
            c[h]:=n[1,h];
            for i:=2 to max do
         begin
             for j:=1 to maxy[i] do
           begin
                for k:=1 to i-1 do
              begin
                   for s:=1 to maxy[k] do
                   if n[k,s]=n[i,j] then goto 1;
              end;
              h:=h+1;choise[h]:=n[i,j];
        1:;end;
          j:=1;
        end;
       q:=h;
      END; {the end of SPEL}
{-------------------------------------}
procedure nambkor(s:byte;var m:nt);
 var ri,rj,n,w,x,y:integer;
 begin
 m[1,1]:=1;m[s,s]:=s*s;
 ri:=s;rj:=s;
 n:=round(ln(a.s)/ln(2));
 for w:=1 to n*2 do
  begin x:=1; y:=1;
  while (x+ri-1)<=s do
   begin
   while (y+ri-1)<=s do
    begin
    if ri=rj then
     begin
     m[x+(ri div 2)-1,y+rj-1]:=m[x,y]+((ri*rj) div 2)-1;
     m[x+(ri div 2),y]:=m[x,y]+(ri*rj) div 2;
     nex[m[x,y]+((ri*rj) div 2)-1]:=x+(ri div 2)-1;
     ney[m[x,y]+((ri*rj) div 2)-1]:=y+rj-1;
     nex[m[x,y]+(ri*rj) div 2]:=x+(ri div 2);
     ney[m[x,y]+(ri*rj) div 2]:=y;
     end;
    if ri*2=rj then
     begin
     m[x,y+(rj div 2)]:=m[x,y]+(ri*rj) div 2;
     m[x+ri-1,y+(rj div 2)-1]:=m[x,y]+((ri*rj) div 2)-1;
     nex[m[x,y]+(ri*rj) div 2]:=x;
     ney[m[x,y]+(ri*rj) div 2]:=y+(rj div 2);
     nex[m[x,y]+((ri*rj) div 2)-1]:=x+ri-1;
     ney[m[x,y]+((ri*rj) div 2)-1]:=y+(rj div 2)-1
     end;
    y:=y+rj;
    end;
   x:=x+ri;y:=1;
   end;
  if ri=rj then ri:=ri div 2
           else rj:=rj div 2;
  end;
 end;
 {------------------------------------------------------}
PROCEDURE ZNAK (min1,max1,min2,max2:integer;
                 VAR trac:tras;VAR kol:integer;VAR newch:jk;
                 VAR namberfelem:nam);
LABEL 1;
TYPE vb=-1..1 ;
 VAR p:vb;i,s,k:integer;
function fil(c:stef):integer;
LABEL 1;
VAR i:integer;
begin
            for i:=1 to q do
          begin
             if c=choise[i] then begin
                             fil:=kort[i];
                             goto 1
                             end;
          end;
1:end;
 BEGIN { begin of ZNAK}
      kol:=0;
      for i:=1 to q do
    begin
           s:=fil(choise[i]);
        if (s<=max1) and (s>=min1) then p:=1
                                   else
          if (s<=max2) and (s>=min2) then p:=-1
                                     else goto 1;
        kol:=kol+1;
         newchoise[kol]:=choise[i];
         namberofelem[kol]:=i;
        for s:=1 to a.quanchains do
           for k:=1 to a.quanelem[s] do
             if choise[i]=a.nameelem[s,k]
              then
              a.traction[s,k]:=p*a.traction[s,k];
 1: end
 END; {the end ZNAK}
{-------------------------------------------------------------------}
PROCEDURE TRAC (VAR tu:unt);
LABEL 1;
VAR i,j,k,s:integer;
BEGIN
      FOR k:=1 to kol do
    begin      tu[k]:=0;
         for i:=1 to a.quanchains do
       begin
            for j:=1 to a.quanelem[i] do
              if newchoise[k]=a.nameelem[i,j]
               then
                 begin
                     for s:=1 to a.quanelem[i] do
                      tu[k]:=tu[k]+a.traction[i,s];
                       tu[k]:=tu[k]-a.traction[i,j];
                       goto 1
                 end;
   1:;end
   end
END;{the end of TRAC}
{-------------------------------------------------------------------}
PROCEDURE INSERT;
VAR i:byte;
    begin
         for i:=1 to kol do choise[namberofelem[i]]:=newchoise[i];
    end;
{-------------------------------------------------------------------}
PROCEDURE KORTX (s:integer;VAR m:korsom;VAR j:integer);
      LABEL 1;
      VAR K,n,i:INTEGER;
BEGIN
       K:=1;n:=s;
              FOR I:=1 TO 1000 DO
  BEGIN
            M[1,I]:=K;
            M[2,I]:=K-1+n;
            j:=i;
        IF M[2,I]>=s
         THEN
           BEGIN
            K:=1;
            n:=n DIV 2;
           END
        ELSE K:=K+n;
        IF n<=1 THEN GOTO 1
  END;
1:END;{ the end of  KORTX }
{------------------------------------------------------------}
PROCEDURE SORTIS (VAR a:jk;b:jh;min,max:byte);
      LABEL 1,99;
      VAR I,K,FL:INTEGER;r2:string[8];R1:byte;
BEGIN
       FOR K:=min TO max-1 DO
    BEGIN
                FL:=0;
         FOR I:=max DOWNTO min+1 DO
       BEGIN
                 IF (B[I]>=B[I-1]) THEN GOTO 1;
                 R1:=B[I];R2:=A[I];
                 B[I]:=B[I-1];A[I]:=A[I-1];
                 B[I-1]:=R1;A[I-1]:=R2;
                 FL:=1;
1:     END;
         IF (FL=0) THEN GOTO 99;
    END;
99:END;    { the end of SORTIS }
{----------------------------------------------------------------}
{$I plasing.plu}
BEGIN  {  M A I N ---> "  P L A C I N G "  }
  b:='0';
    ot:=detect;
         initgraph (OT,OL,'');
     e:=graphresult;
     if e<>grok then
    begin textcolor(4);
          writeln (grapherrormsg(e));
           bol:=false;exit
    end;
   { unarc('color16.dat');}
    repeat until keypressed;
1:  Main(b);
  if not bol then begin closeGraph; Halt end;
  sortis(choise,kort,1,q);
  vcom;
  kortx(a.s*a.s,korteg,quankort);
  br;
  setfillstyle(1,4);
  setcolor(14);
 for i:=1 to quankort do
begin
  znak(korteg[1,2*i],korteg[2,2*i],korteg[1,2*i+1],korteg[2,2*i+1],
      a.traction,kol,newchoise,namberofelem);
  trac(unitrac);
  sort(unitrac,newchoise,1,kol,-1);
  insert;
  if keypressed then control;
  for j:=1 to q do  outinfo;
   n:=n+j;
end;
repeat
 c:=vmenu(b);
if (c='L')or(c='N')or(c='A') then begin b:=c;goto 1 end
else if(c='H')or(b=#59) then help;
b:=c
until (c='Q');
clb;CloseGraph;
END.  { T H E  E N D  O F  M A I N  P R O G R A M }
