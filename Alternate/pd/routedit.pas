{$O+}
unit routedit;
interface
uses crt,graph,univer,trassir;
type typ1=record
        pix:array[1..5]of pointtype;
        cf,cl,np:byte;
        end;
     typmas=array[1..60]of typ1;
     typokn=array[1..125,1..75]of word;
VAR mas:^typmas;
    okn:^typokn;
    xs,ys,lx,ly,nc:word;
    m,sby,lby,lbx,mh,fr,frh,xx,yy,vv,ll,kx,ky:byte;
    pozah:array[1..8]of word;
    edit,routing,graf,nevdan:boolean;

{-----------------------------------------------------------------}

procedure OPENMAS(i:byte;new:boolean;cln,cfn:byte);
procedure INITMAS(a1,b1,a2,b2:word);
procedure ZAKRPLT(var rsl:byte);
procedure OTKRPLT(var rsl:byte;var exi:boolean);
function  MESTO(n:byte):boolean;
procedure VIZELEMENT(x,y:byte);
procedure POZA;
procedure VIZOKN;
procedure MOVEOKN(xi,yj:integer);
procedure SETONPLT(dirka:boolean;i,j,nc:word);
procedure SETPOINT;
procedure SUPERROUTING(a1,b1,a2,b2:word);
procedure save(name:string);
procedure load(name:string);

{=================================================================}
implementation
{=================================================================}

procedure OPENMAS(i:byte;new:boolean;cln,cfn:byte);
begin
  with mas^[i] do
   begin
   if not(new) then
    begin
    cln:=cl;
        cfn:=cf;
    end;
   setcolor(cln);
   setfillstyle(1,cfn);
   fillpoly(np,pix);
   end;
end;

{-------------------------------------------------}

procedure initmas(a1,b1,a2,b2:word);
var gx,gy:word;
    i,j:byte;
begin
 gx:=abs(a2-a1);
 gy:=abs(b2-b1);
 with mas^[1] do
  begin {весь экран}
  cl:=white; cf:=darkgray; np:=4;
  pix[1].x:=0;
  pix[1].y:=0;
  pix[2].x:=gx;
  pix[2].y:=0;
  pix[3].x:=gx;
  pix[3].y:=gy;
  pix[4].x:=0;
  pix[4].y:=gy;
  end;
 with mas^[2] do
  begin {окно платы}
  cl:=white; cf:=0; np:=4;
  pix[1].x:=gx div 8-1;
  pix[1].y:=gy div 6-1;
  pix[2].x:=gx-gx div 8+1;
  pix[2].y:=gy div 6-1;
  pix[3].x:=gx-gx div 8+1;
  pix[3].y:=gy-gy div 6+1;
  pix[4].x:=gx div 8-1;
  pix[4].y:=gy-gy div 6+1;
  end;
 with mas^[3] do
  begin {настройка трассировки}
  cl:=3; cf:=1; np:=4;
  pix[1].x:=gx div 64;
  pix[1].y:=gy-12*gy div 48;
  pix[2].x:=7*gx div 64;
  pix[2].y:=gy-12*gy div 48;
  pix[3].x:=7*gx div 64;
  pix[3].y:=gy-9*gy div 48;
  pix[4].x:=gx div 64;
  pix[4].y:=gy-9*gy div 48;
  end;
 with mas^[4] do
  begin {сохранение}
  cl:=3; cf:=1; np:=4;
  pix[1].x:=gx div 64;
  pix[1].y:=gy div 48;
  pix[2].x:=7*gx div 64;
  pix[2].y:=gy div 48;
  pix[3].x:=7*gx div 64;
  pix[3].y:=4*gy div 48;
  pix[4].x:=gx div 64;
  pix[4].y:=4*gy div 48;
  end;
 with mas^[5] do
  begin {загрузка}
  cl:=3; cf:=1; np:=4;
  pix[1].x:=gx div 64;
  pix[1].y:=5*gy div 48;
  pix[2].x:=7*gx div 64;
  pix[2].y:=5*gy div 48;
  pix[3].x:=7*gx div 64;
  pix[3].y:=8*gy div 48;
  pix[4].x:=gx div 64;
  pix[4].y:=8*gy div 48;
  end;
 with mas^[6] do
  begin {поводок вертикальный}
  cl:=3; cf:=2; np:=4;
  pix[1].x:=gx-7*gx div 64;
  pix[1].y:=13*gy div 48;
  pix[2].x:=gx-5*gx div 64;
  pix[2].y:=13*gy div 48;
  pix[3].x:=gx-5*gx div 64;
  pix[3].y:=gy-13*gy div 48;
  pix[4].x:=gx-7*gx div 64;
  pix[4].y:=gy-13*gy div 48;
  end;
 with mas^[7] do
  begin {слои}
  cl:=white; cf:=blue; np:=4;
  pix[1].x:=gx div 64;
  pix[1].y:=14*gy div 48;
  pix[2].x:=6*gx div 64;
  pix[2].y:=14*gy div 48;
  pix[3].x:=6*gx div 64;
  pix[3].y:=gy-14*gy div 48;
  pix[4].x:=gx div 64;
  pix[4].y:=gy-14*gy div 48;
  end;
 with mas^[8] do
  begin  {поводок горизонтальный}
  cl:=3; cf:=2; np:=4;
  pix[1].x:=13*gx div 64;
  pix[1].y:=gy-7*gy div 48;
  pix[2].x:=gx-13*gx div 64;
  pix[2].y:=gy-7*gy div 48;
  pix[3].x:=gx-13*gx div 64;
  pix[3].y:=gy-5*gy div 48;
  pix[4].x:=13*gx div 64;
  pix[4].y:=gy-5*gy div 48;
  end;
 with mas^[9] do
  begin {столбец}
  cl:=white; cf:=6; np:=4;
  pix[1].x:=9*gx div 64;
  pix[1].y:=gy-4*gy div 48;
  pix[2].x:=23*gx div 64;
  pix[2].y:=gy-4*gy div 48;
  pix[3].x:=23*gx div 64;
  pix[3].y:=gy-gy div 48;
  pix[4].x:=9*gx div 64;
  pix[4].y:=gy-gy div 48;
  end;
 with mas^[10] do
  begin {строка}
  cl:=white; cf:=6; np:=4;
  pix[1].x:=25*gx div 64;
  pix[1].y:=gy-4*gy div 48;
  pix[2].x:=gx-25*gx div 64;
  pix[2].y:=gy-4*gy div 48;
  pix[3].x:=gx-25*gx div 64;
  pix[3].y:=gy-gy div 48;
  pix[4].x:=25*gx div 64;
  pix[4].y:=gy-gy div 48;
  end;
 with mas^[11] do
  begin {цепь}
  cl:=white; cf:=6; np:=4;
  pix[1].x:=gx-23*gx div 64;
  pix[1].y:=gy-4*gy div 48;
  pix[2].x:=gx-9*gx div 64;
  pix[2].y:=gy-4*gy div 48;
  pix[3].x:=gx-9*gx div 64;
  pix[3].y:=gy-gy div 48;
  pix[4].x:=gx-23*gx div 64;
  pix[4].y:=gy-gy div 48;
  end;
 with mas^[12] do
  begin {маштаб}
  cl:=white; cf:=blue; np:=4;
  pix[1].x:=9*gx div 64;
  pix[1].y:=gy div 48;
  pix[2].x:=23*gx div 64;
  pix[2].y:=gy div 48;
  pix[3].x:=23*gx div 64;
  pix[3].y:=6*gy div 48;
  pix[4].x:=9*gx div 64;
  pix[4].y:=6*gy div 48;
  end;
 with mas^[13] do
  begin {имя}
  cl:=white; cf:=0; np:=4;
  pix[1].x:=25*gx div 64;
  pix[1].y:=gy div 48;
  pix[2].x:=gx-25*gx div 64;
  pix[2].y:=gy div 48;
  pix[3].x:=gx-25*gx div 64;
  pix[3].y:=6*gy div 48;
  pix[4].x:=25*gx div 64;
  pix[4].y:=6*gy div 48;
  end;
 with mas^[14] do
  begin {способ показа}
  cl:=white; cf:=blue; np:=4;
  pix[1].x:=gx-23*gx div 64;
  pix[1].y:=gy div 48;
  pix[2].x:=gx-9*gx div 64;
  pix[2].y:=gy div 48;
  pix[3].x:=gx-9*gx div 64;
  pix[3].y:=6*gy div 48;
  pix[4].x:=gx-23*gx div 64;
  pix[4].y:=6*gy div 48;
  end;
 with mas^[15] do
  begin {место для эмблемы}
  cl:=2; cf:=7; np:=4;
  pix[1].x:=gx-7*gx div 64;
  pix[1].y:=gy div 48;
  pix[2].x:=gx-gx div 64;
  pix[2].y:=gy div 48;
  pix[3].x:=gx-gx div 64;
  pix[3].y:=7*gy div 48;
  pix[4].x:=gx-7*gx div 64;
  pix[4].y:=7*gy div 48;
  end;
 with mas^[16] do
  begin {выход из программы}
  cl:=3; cf:=9; np:=4;
  pix[1].x:=gx-7*gx div 64;
  pix[1].y:=gy-7*gy div 48;
  pix[2].x:=gx-gx div 64;
  pix[2].y:=gy-7*gy div 48;
  pix[3].x:=gx-gx div 64;
  pix[3].y:=gy-gy div 48;
  pix[4].x:=gx-7*gx div 64;
  pix[4].y:=gy-gy div 48;
  end;
 with mas^[17] do
  begin {поле одинарной стрелки вверх}
  cl:=15; cf:=9; np:=4;
  pix[1].x:=gx-7*gx div 64;
  pix[1].y:=9*gy div 48;
  pix[2].x:=gx-5*gx div 64;
  pix[2].y:=9*gy div 48;
  pix[3].x:=gx-5*gx div 64;
  pix[3].y:=11*gy div 48;
  pix[4].x:=gx-7*gx div 64;
  pix[4].y:=11*gy div 48;
  end;
 with mas^[18] do
  begin {поле двойной стрелки вверх}
  cl:=15; cf:=9; np:=4;
  pix[1].x:=gx-7*gx div 64;
  pix[1].y:=11*gy div 48;
  pix[2].x:=gx-5*gx div 64;
  pix[2].y:=11*gy div 48;
  pix[3].x:=gx-5*gx div 64;
  pix[3].y:=13*gy div 48;
  pix[4].x:=gx-7*gx div 64;
  pix[4].y:=13*gy div 48;
  end;
 with mas^[19] do
  begin {поле одинарной стрелки вниз}
  cl:=15; cf:=9; np:=4;
  pix[1].x:=gx-7*gx div 64;
  pix[1].y:=gy-11*gy div 48;
  pix[2].x:=gx-5*gx div 64;
  pix[2].y:=gy-11*gy div 48;
  pix[3].x:=gx-5*gx div 64;
  pix[3].y:=gy-9*gy div 48;
  pix[4].x:=gx-7*gx div 64;
  pix[4].y:=gy-9*gy div 48;
  end;
 with mas^[20] do
  begin {поле двойной стрелки вниз}
  cl:=15; cf:=9; np:=4;
  pix[1].x:=gx-7*gx div 64;
  pix[1].y:=gy-13*gy div 48;
  pix[2].x:=gx-5*gx div 64;
  pix[2].y:=gy-13*gy div 48;
  pix[3].x:=gx-5*gx div 64;
  pix[3].y:=gy-11*gy div 48;
  pix[4].x:=gx-7*gx div 64;
  pix[4].y:=gy-11*gy div 48;
  end;
 with mas^[21] do
  begin {поле одинарной стрелки влево}
  cl:=15; cf:=9; np:=4;
  pix[1].x:=9*gx div 64;
  pix[1].y:=gy-7*gy div 48;
  pix[2].x:=11*gx div 64;
  pix[2].y:=gy-7*gy div 48;
  pix[3].x:=11*gx div 64;
  pix[3].y:=gy-5*gy div 48;
  pix[4].x:=9*gx div 64;
  pix[4].y:=gy-5*gy div 48;
  end;
 with mas^[22] do
  begin {поле двойной стрелки влево}
  cl:=15; cf:=9; np:=4;
  pix[1].x:=11*gx div 64;
  pix[1].y:=gy-7*gy div 48;
  pix[2].x:=13*gx div 64;
  pix[2].y:=gy-7*gy div 48;
  pix[3].x:=13*gx div 64;
  pix[3].y:=gy-5*gy div 48;
  pix[4].x:=11*gx div 64;
  pix[4].y:=gy-5*gy div 48;
  end;
 with mas^[23] do
  begin {поле одинарной стрелки вправо}
  cl:=15; cf:=9; np:=4;
  pix[1].x:=gx-11*gx div 64;
  pix[1].y:=gy-7*gy div 48;
  pix[2].x:=gx-9*gx div 64;
  pix[2].y:=gy-7*gy div 48;
  pix[3].x:=gx-9*gx div 64;
  pix[3].y:=gy-5*gy div 48;
  pix[4].x:=gx-11*gx div 64;
  pix[4].y:=gy-5*gy div 48;
  end;
 with mas^[24] do
  begin {поле двойной стрелки вправо}
  cl:=15; cf:=9; np:=4;
  pix[1].x:=gx-13*gx div 64;
  pix[1].y:=gy-7*gy div 48;
  pix[2].x:=gx-11*gx div 64;
  pix[2].y:=gy-7*gy div 48;
  pix[3].x:=gx-11*gx div 64;
  pix[3].y:=gy-5*gy div 48;
  pix[4].x:=gx-13*gx div 64;
  pix[4].y:=gy-5*gy div 48;
  end;
 with mas^[25] do
  begin {одинарная стрелка вверх}
  cl:=15; cf:=5; np:=3;
  pix[1].x:=gx-6*gx div 64;
  pix[1].y:=9*gy div 48;
  pix[2].x:=gx-5*gx div 64;
  pix[2].y:=11*gy div 48;
  pix[3].x:=gx-7*gx div 64;
  pix[3].y:=11*gy div 48;
  end;
 with mas^[26] do
  begin {двойная стрелка вверх}
  cl:=15; cf:=5; np:=5;
  pix[1].x:=gx-13*gx div 128;
  pix[1].y:=11*gy div 48;
  pix[2].x:=gx-6*gx div 64;
  pix[2].y:=12*gy div 48;
  pix[3].x:=gx-11*gx div 128;
  pix[3].y:=11*gy div 48;
  pix[4].x:=gx-5*gx div 64;
  pix[4].y:=13*gy div 48;
  pix[5].x:=gx-7*gx div 64;
  pix[5].y:=13*gy div 48;
  end;
 with mas^[27] do
  begin {одинарная стрелка вниз}
  cl:=15; cf:=5; np:=3;
  pix[1].x:=gx-6*gx div 64;
  pix[1].y:=gy-9*gy div 48;
  pix[2].x:=gx-5*gx div 64;
  pix[2].y:=gy-11*gy div 48;
  pix[3].x:=gx-7*gx div 64;
  pix[3].y:=gy-11*gy div 48;
  end;
 with mas^[28] do
  begin {двойная стрелка вниз}
  cl:=15; cf:=5; np:=5;
  pix[1].x:=gx-13*gx div 128;
  pix[1].y:=gy-11*gy div 48;
  pix[2].x:=gx-6*gx div 64;
  pix[2].y:=gy-12*gy div 48;
  pix[3].x:=gx-11*gx div 128;
  pix[3].y:=gy-11*gy div 48;
  pix[4].x:=gx-5*gx div 64;
  pix[4].y:=gy-13*gy div 48;
  pix[5].x:=gx-7*gx div 64;
  pix[5].y:=gy-13*gy div 48;
  end;
 with mas^[29] do
  begin {одинарная стрелка влево}
  cl:=15; cf:=5; np:=3;
  pix[1].x:=9*gx div 64;
  pix[1].y:=gy-6*gy div 48;
  pix[2].x:=11*gx div 64;
  pix[2].y:=gy-7*gy div 48;
  pix[3].x:=11*gx div 64;
  pix[3].y:=gy-5*gy div 48;
  end;
 with mas^[30] do
  begin {двойная стрелка влево}
  cl:=15; cf:=5; np:=5;
  pix[1].x:=11*gx div 64;
  pix[1].y:=gy-11*gy div 96;
  pix[2].x:=12*gx div 64;
  pix[2].y:=gy-6*gy div 48;
  pix[3].x:=11*gx div 64;
  pix[3].y:=gy-13*gy div 96;
  pix[4].x:=13*gx div 64;
  pix[4].y:=gy-7*gy div 48;
  pix[5].x:=13*gx div 64;
  pix[5].y:=gy-5*gy div 48;
  end;
 with mas^[31] do
  begin {одинарная стрелка вправо}
  cl:=15; cf:=5; np:=3;
  pix[1].x:=gx-9*gx div 64;
  pix[1].y:=gy-6*gy div 48;
  pix[2].x:=gx-11*gx div 64;
  pix[2].y:=gy-7*gy div 48;
  pix[3].x:=gx-11*gx div 64;
  pix[3].y:=gy-5*gy div 48;
  end;
 with mas^[32] do
  begin {двойная стрелка вправо}
  cl:=15; cf:=5; np:=5;
  pix[1].x:=gx-11*gx div 64;
  pix[1].y:=gy-11*gy div 96;
  pix[2].x:=gx-12*gx div 64;
  pix[2].y:=gy-6*gy div 48;
  pix[3].x:=gx-11*gx div 64;
  pix[3].y:=gy-13*gy div 96;
  pix[4].x:=gx-13*gx div 64;
  pix[4].y:=gy-7*gy div 48;
  pix[5].x:=gx-13*gx div 64;
  pix[5].y:=gy-5*gy div 48;
  end;
 with mas^[33] do
  begin {маштаб номер 1}
  cl:=14; cf:=2; np:=4;
  pix[1].x:=5*gx div 32;
  pix[1].y:=2*gy div 24;
  pix[2].x:=6*gx div 32;
  pix[2].y:=2*gy div 24;
  pix[3].x:=6*gx div 32;
  pix[3].y:=7*gy div 48;
  pix[4].x:=5*gx div 32;
  pix[4].y:=7*gy div 48;
  end;
 with mas^[34] do
  begin {маштаб номер 2}
  cl:=14; cf:=2; np:=4;
  pix[1].x:=6*gx div 32;
  pix[1].y:=2*gy div 24;
  pix[2].x:=7*gx div 32;
  pix[2].y:=2*gy div 24;
  pix[3].x:=7*gx div 32;
  pix[3].y:=7*gy div 48;
  pix[4].x:=6*gx div 32;
  pix[4].y:=7*gy div 48;
  end;
 with mas^[35] do
  begin {маштаб номер 3}
  cl:=14; cf:=2; np:=4;
  pix[1].x:=7*gx div 32;
  pix[1].y:=2*gy div 24;
  pix[2].x:=8*gx div 32;
  pix[2].y:=2*gy div 24;
  pix[3].x:=8*gx div 32;
  pix[3].y:=7*gy div 48;
  pix[4].x:=7*gx div 32;
  pix[4].y:=7*gy div 48;
  end;
 with mas^[36] do
  begin {маштаб номер 4}
  cl:=14; cf:=2; np:=4;
  pix[1].x:=8*gx div 32;
  pix[1].y:=2*gy div 24;
  pix[2].x:=9*gx div 32;
  pix[2].y:=2*gy div 24;
  pix[3].x:=9*gx div 32;
  pix[3].y:=7*gy div 48;
  pix[4].x:=8*gx div 32;
  pix[4].y:=7*gy div 48;
  end;
 with mas^[37] do
  begin {маштаб номер 5}
  cl:=14; cf:=2; np:=4;
  pix[1].x:=9*gx div 32;
  pix[1].y:=2*gy div 24;
  pix[2].x:=10*gx div 32;
  pix[2].y:=2*gy div 24;
  pix[3].x:=10*gx div 32;
  pix[3].y:=7*gy div 48;
  pix[4].x:=9*gx div 32;
  pix[4].y:=7*gy div 48;
  end;
 with mas^[38] do
  begin {маштаб номер 6}
  cl:=14; cf:=2; np:=4;
  pix[1].x:=10*gx div 32;
  pix[1].y:=2*gy div 24;
  pix[2].x:=11*gx div 32;
  pix[2].y:=2*gy div 24;
  pix[3].x:=11*gx div 32;
  pix[3].y:=7*gy div 48;
  pix[4].x:=10*gx div 32;
  pix[4].y:=7*gy div 48;
  end;
 with mas^[39] do
  begin {слой номер 1}
  cl:=15; cf:=3; np:=4;
  pix[1].x:=2*gx div 32;
  pix[1].y:=8*gy div 24;
  pix[2].x:=7*gx div 64;
  pix[2].y:=8*gy div 24;
  pix[3].x:=7*gx div 64;
  pix[3].y:=9*gy div 24;
  pix[4].x:=2*gx div 32;
  pix[4].y:=9*gy div 24;
  end;
 with mas^[40] do
  begin {слой номер 2}
  cl:=15; cf:=3; np:=4;
  pix[1].x:=2*gx div 32;
  pix[1].y:=9*gy div 24;
  pix[2].x:=7*gx div 64;
  pix[2].y:=9*gy div 24;
  pix[3].x:=7*gx div 64;
  pix[3].y:=10*gy div 24;
  pix[4].x:=2*gx div 32;
  pix[4].y:=10*gy div 24;
  end;
 with mas^[41] do
  begin {слой номер 3}
  cl:=15; cf:=3; np:=4;
  pix[1].x:=2*gx div 32;
  pix[1].y:=10*gy div 24;
  pix[2].x:=7*gx div 64;
  pix[2].y:=10*gy div 24;
  pix[3].x:=7*gx div 64;
  pix[3].y:=11*gy div 24;
  pix[4].x:=2*gx div 32;
  pix[4].y:=11*gy div 24;
  end;
 with mas^[42] do
  begin {слой номер 4}
  cl:=15; cf:=3; np:=4;
  pix[1].x:=2*gx div 32;
  pix[1].y:=11*gy div 24;
  pix[2].x:=7*gx div 64;
  pix[2].y:=11*gy div 24;
  pix[3].x:=7*gx div 64;
  pix[3].y:=12*gy div 24;
  pix[4].x:=2*gx div 32;
  pix[4].y:=12*gy div 24;
  end;
 with mas^[43] do
  begin {слой номер 5}
  cl:=15; cf:=3; np:=4;
  pix[1].x:=2*gx div 32;
  pix[1].y:=12*gy div 24;
  pix[2].x:=7*gx div 64;
  pix[2].y:=12*gy div 24;
  pix[3].x:=7*gx div 64;
  pix[3].y:=13*gy div 24;
  pix[4].x:=2*gx div 32;
  pix[4].y:=13*gy div 24;
  end;
 with mas^[44] do
  begin {слой номер 6}
  cl:=15; cf:=3; np:=4;
  pix[1].x:=2*gx div 32;
  pix[1].y:=13*gy div 24;
  pix[2].x:=7*gx div 64;
  pix[2].y:=13*gy div 24;
  pix[3].x:=7*gx div 64;
  pix[3].y:=14*gy div 24;
  pix[4].x:=2*gx div 32;
  pix[4].y:=14*gy div 24;
  end;
 with mas^[45] do
  begin {слой номер 7}
  cl:=15; cf:=3; np:=4;
  pix[1].x:=2*gx div 32;
  pix[1].y:=14*gy div 24;
  pix[2].x:=7*gx div 64;
  pix[2].y:=14*gy div 24;
  pix[3].x:=7*gx div 64;
  pix[3].y:=15*gy div 24;
  pix[4].x:=2*gx div 32;
  pix[4].y:=15*gy div 24;
  end;
 with mas^[46] do
  begin {слой номер 8}
  cl:=15; cf:=3; np:=4;
  pix[1].x:=2*gx div 32;
  pix[1].y:=15*gy div 24;
  pix[2].x:=7*gx div 64;
  pix[2].y:=15*gy div 24;
  pix[3].x:=7*gx div 64;
  pix[3].y:=16*gy div 24;
  pix[4].x:=2*gx div 32;
  pix[4].y:=16*gy div 24;
  end;
 with mas^[47] do
  begin { меню }
  cl:=3; cf:=1; np:=4;
  pix[1].x:=gx div 64;
  pix[1].y:=9*gy div 48;
  pix[2].x:=7*gx div 64;
  pix[2].y:=9*gy div 48;
  pix[3].x:=7*gx div 64;
  pix[3].y:=12*gy div 48;
  pix[4].x:=gx div 64;
  pix[4].y:=12*gy div 48;
  end;
 with mas^[48] do
  begin { уменьшение слоев }
  cl:=14; cf:=4; np:=4;
  pix[1].x:=2*gx div 64;
  pix[1].y:=13*gy div 48;
  pix[2].x:=4*gx div 64;
  pix[2].y:=13*gy div 48;
  pix[3].x:=4*gx div 64;
  pix[3].y:=15*gy div 48;
  pix[4].x:=2*gx div 64;
  pix[4].y:=15*gy div 48;
  end;
 with mas^[49] do
  begin { Увеличение слоев }
  cl:=14; cf:=4; np:=4;
  pix[1].x:=2*gx div 64;
  pix[1].y:=gy-15*gy div 48;
  pix[2].x:=4*gx div 64;
  pix[2].y:=gy-15*gy div 48;
  pix[3].x:=4*gx div 64;
  pix[3].y:=gy-13*gy div 48;
  pix[4].x:=2*gx div 64;
  pix[4].y:=gy-13*gy div 48;
  end;
 with mas^[50] do
  begin {процент трассировки}
  cl:=14; cf:=8; np:=4;
  pix[1].x:=gx-4*gx div 64;
  pix[1].y:=9*gy div 48;
  pix[2].x:=gx-3*gx div 64;
  pix[2].y:=9*gy div 48;
  pix[3].x:=gx-3*gx div 64;
  pix[3].y:=gy-9*gy div 48;
  pix[4].x:=gx-4*gx div 64;
  pix[4].y:=gy-9*gy div 48;
  end;
 with mas^[51] do
  begin {надпись активного трассировщика}
  cl:=14; cf:=8; np:=4;
  pix[1].x:=gx-3*gx div 64;
  pix[1].y:=9*gy div 48;
  pix[2].x:=gx-gx div 64;
  pix[2].y:=9*gy div 48;
  pix[3].x:=gx-gx div 64;
  pix[3].y:=gy-9*gy div 48;
  pix[4].x:=gx-3*gx div 64;
  pix[4].y:=gy-9*gy div 48;
  end;
 with mas^[52] do
  begin {надпись пасивного трассировщика}
  cl:=14; cf:=8; np:=4;
  pix[1].x:=gx-4*gx div 64;
  pix[1].y:=9*gy div 48;
  pix[2].x:=gx-gx div 64;
  pix[2].y:=9*gy div 48;
  pix[3].x:=gx-gx div 64;
  pix[3].y:=gy-9*gy div 48;
  pix[4].x:=gx-4*gx div 64;
  pix[4].y:=gy-9*gy div 48;
  end;
 with mas^[53] do
  begin {работа}
  cl:=3; cf:=1; np:=4;
  pix[1].x:=gx div 64;
  pix[1].y:=gy-8*gy div 48;
  pix[2].x:=7*gx div 64;
  pix[2].y:=gy-8*gy div 48;
  pix[3].x:=7*gx div 64;
  pix[3].y:=gy-5*gy div 48;
  pix[4].x:=gx div 64;
  pix[4].y:=gy-5*gy div 48;
  end;
 with mas^[54] do
  begin {помощь по программе}
  cl:=3; cf:=1; np:=4;
  pix[1].x:=gx div 64;
  pix[1].y:=gy-4*gy div 48;
  pix[2].x:=7*gx div 64;
  pix[2].y:=gy-4*gy div 48;
  pix[3].x:=7*gx div 64;
  pix[3].y:=gy-gy div 48;
  pix[4].x:=gx div 64;
  pix[4].y:=gy-gy div 48;
  end;
 with mas^[55] do
  begin {текущее имя файла}
  cl:=white; cf:=2; np:=4;
  pix[1].x:=26*gx div 64;
  pix[1].y:=4*gy div 48;
  pix[2].x:=gx-26*gx div 64;
  pix[2].y:=4*gy div 48;
  pix[3].x:=gx-26*gx div 64;
  pix[3].y:=7*gy div 48;
  pix[4].x:=26*gx div 64;
  pix[4].y:=7*gy div 48;
  end;
 with mas^[56] do
  begin {поле способа показа изображения}
  cl:=white; cf:=4; np:=4;
  pix[1].x:=gx-22*gx div 64;
  pix[1].y:=4*gy div 48;
  pix[2].x:=gx-10*gx div 64;
  pix[2].y:=4*gy div 48;
  pix[3].x:=gx-10*gx div 64;
  pix[3].y:=7*gy div 48;
  pix[4].x:=gx-22*gx div 64;
  pix[4].y:=7*gy div 48;
  end;
 for i:=1 to 56 do
  with mas^[i] do
   for j:=1 to np do
    begin
    inc(pix[j].x,a1);
    inc(pix[j].y,b1);
    end;
 for i:=1 to 56 do openmas(i,false,1,1);
end;

{---------------------------------------------}

procedure ZAKRPLT(var rsl:byte);
 Var i:Word;
begin
 dispose(mas);
 dispose(tex);
 dispose(okn);
 dispose(dir);
 if rsl=0 then exit;
 for i:=1 to rsl do
  begin
  if i=1 then dispose(plt1);
  if i=2 then dispose(plt2);
  if i=3 then dispose(plt3);
  if i=4 then dispose(plt4);
  if i=5 then dispose(plt5);
  if i=6 then dispose(plt6);
  if i=7 then dispose(plt7);
  if i=8 then dispose(plt8);
  end;
 rsl:=0;
end;

{-------------------------------------------------------}

procedure OTKRPLT(var rsl:byte;var exi:boolean);
var i,j,k:byte;
begin
 rsl:=0;
 exi:=true;
 k:=0;
 if (maxavail>sizeof(typtex)) then
  begin
  k:=1;
  new(tex);
  end;
 if k=0 then exit;
 k:=0;
 if (maxavail>sizeof(typmas)) then
  begin
  k:=1;
  new(mas);
  end;
 if k=0 then
  begin
  dispose(tex);
  exit;
  end;
 k:=0;
 if (maxavail>sizeof(typokn)) then
  begin
  k:=1;
  new(okn);
  for i:=1 to 125 do
   for j:=1 to 75 do
    okn^[i,j]:=0;
  end;
 if k=0 then
  begin
  dispose(tex);
  dispose(mas);
  exit;
  end;
 k:=0;
 if (maxavail>sizeof(typdir)) then
  begin
  k:=1;
  new(dir);
  for i:=1 to mx do
   for j:=1 to my do
    dir^[i,j]:=2;
  end;
 if k=0 then
  begin
  dispose(tex);
  dispose(mas);
  dispose(okn);
  exit;
  end;
 exi:=false;
 while (maxavail>sizeof(typplt))and(rsl<8)and(k>0) do
  begin
  inc(rsl);
  if rsl=1 then
   begin
   new(plt1);
   for i:=1 to mx do
    for j:=1 to my do
     plt1^[i,j]:=65535;
   end;
  if rsl=2 then
   begin
   new(plt2);
   for i:=1 to mx do
    for j:=1 to my do
     plt2^[i,j]:=65535;
   end;
  if rsl=3 then
   begin
   new(plt3);
   for i:=1 to mx do
    for j:=1 to my do
     plt3^[i,j]:=65535;
   end;
  if rsl=4 then
   begin
   new(plt4);
   for i:=1 to mx do
    for j:=1 to my do
     plt4^[i,j]:=65535;
   end;
  if rsl=5 then
   begin
   new(plt5);
   for i:=1 to mx do
    for j:=1 to my do
     plt5^[i,j]:=65535;
   end;
  if rsl=6 then
   begin
   new(plt6);
   for i:=1 to mx do
    for j:=1 to my do
     plt6^[i,j]:=65535;
   end;
  if rsl=7 then
   begin
   new(plt7);
   for i:=1 to mx do
    for j:=1 to my do
     plt7^[i,j]:=65535;
   end;
  if rsl=8 then
   begin
   new(plt8);
   for i:=1 to mx do
    for j:=1 to my do
     plt8^[i,j]:=65535;
   end;
  end;
end;

{----------------------------------------------------}

function MESTO(n:byte):boolean;
begin
with mas^[n] do
 if (pix[1].x<xs)
    and(pix[3].x>xs)
    and(pix[1].y<ys)
    and(pix[3].y>ys)
      then mesto:=true
      else mesto:=false;
end;

{-----------------------------------------------------}

procedure VIZELEMENT(x,y:byte);
var i,il,ip,j,jl,jp:integer;
    du,z:byte;
    hp,us,pw,un,sd,ht,ut,hc,uc:word;
    hpg,usg:boolean;
    dirka:boolean;
    q:array[1..3,1..3]of word;
    s:string[4];
begin
il:=x;ip:=x;
jl:=y;jp:=y;
if graf then
 begin
 il:=x-1;ip:=x+1;
 jl:=y-1;jp:=y+1;
 end;
for i:=il to ip do
 for j:=jl to jp do
  begin
  q[i-x+2,j-y+2]:=65535;
  if (fr=1)and(ll+i-1>0)and(ll+i-1<mx+1)and(vv+j-1>0)and(vv+j-1<my+1) then
     q[i-x+2,j-y+2]:=plt1^[ll+i-1,vv+j-1];
  if (fr=2)and(ll+i-1>0)and(ll+i-1<mx+1)and(vv+j-1>0)and(vv+j-1<my+1) then
     q[i-x+2,j-y+2]:=plt2^[ll+i-1,vv+j-1];
  if (fr=3)and(ll+i-1>0)and(ll+i-1<mx+1)and(vv+j-1>0)and(vv+j-1<my+1) then
     q[i-x+2,j-y+2]:=plt3^[ll+i-1,vv+j-1];
  if (fr=4)and(ll+i-1>0)and(ll+i-1<mx+1)and(vv+j-1>0)and(vv+j-1<my+1) then
     q[i-x+2,j-y+2]:=plt4^[ll+i-1,vv+j-1];
  if (fr=5)and(ll+i-1>0)and(ll+i-1<mx+1)and(vv+j-1>0)and(vv+j-1<my+1) then
     q[i-x+2,j-y+2]:=plt5^[ll+i-1,vv+j-1];
  if (fr=6)and(ll+i-1>0)and(ll+i-1<mx+1)and(vv+j-1>0)and(vv+j-1<my+1) then
     q[i-x+2,j-y+2]:=plt6^[ll+i-1,vv+j-1];
  if (fr=7)and(ll+i-1>0)and(ll+i-1<mx+1)and(vv+j-1>0)and(vv+j-1<my+1) then
     q[i-x+2,j-y+2]:=plt7^[ll+i-1,vv+j-1];
  if (fr=8)and(ll+i-1>0)and(ll+i-1<mx+1)and(vv+j-1>0)and(vv+j-1<my+1) then
     q[i-x+2,j-y+2]:=plt8^[ll+i-1,vv+j-1];
  if q[i-x+2,j-y+2]>2047 then q[i-x+2,j-y+2]:=65535;
  end;

 if (dir^[ll+x-1,vv+y-1] and 1)=1 then dirka:=true
                                  else dirka:=false;
 if not(graf) then
  begin
  if q[2,2]>2047 then hp:=0
               else if dirka then hp:=q[2,2] or 53248{11010000.00000000}
                             else hp:=q[2,2] or 51200{11001000.00000000};
  end
               else
  begin
  hp:=0;
  if q[2,2]<2047 then
   if dirka then hp:=hp or 16384
            else hp:=hp or 32768;
  if q[2,2]<2047 then
   begin
   if q[2,2]=q[2,1] then hp:=hp or 8192;
   if q[2,2]=q[3,2] then hp:=hp or 4096;
   if q[2,2]=q[2,3] then hp:=hp or 2048;
   if q[2,2]=q[1,2] then hp:=hp or 1024;
   if (q[2,2]=q[3,1])and(((q[2,2]<>q[2,1])and(q[2,2]<>q[3,2]))
                        or(q[2,1]=q[3,2])) then hp:=hp or 512;
   if (q[2,2]=q[3,3])and(((q[2,2]<>q[3,2])and(q[2,2]<>q[2,3]))
                        or(q[3,2]=q[2,3])) then hp:=hp or 256;
   if (q[2,2]=q[1,3])and(((q[2,2]<>q[2,3])and(q[2,2]<>q[1,2]))
                        or(q[2,3]=q[1,2])) then hp:=hp or 128;
   if (q[2,2]=q[1,1])and(((q[2,2]<>q[1,2])and(q[2,2]<>q[2,1]))
                        or(q[1,2]=q[2,1])) then hp:=hp or 64;
   end;
  if (q[2,1]=q[3,2])and(q[2,1]<2047)
     and(q[2,2]<>q[3,2])and(q[3,1]<>q[3,2])
     then hp:=hp or 32;
  if (q[3,2]=q[2,3])and(q[3,2]<2047)
     and(q[2,2]<>q[2,3])and(q[3,3]<>q[2,3])
     then hp:=hp or 16;
  if (q[2,3]=q[1,2])and(q[2,3]<2047)
     and(q[2,2]<>q[1,2])and(q[1,3]<>q[1,2])
     then hp:=hp or 8;
  if (q[1,2]=q[2,1])and(q[1,2]<2047)
     and(q[2,2]<>q[2,1])and(q[1,1]<>q[2,1])
     then hp:=hp or 4;
  end;
 if (hp<>okn^[x,y]) then
  begin
  setviewport(mas^[2].pix[1].x+1,mas^[2].pix[1].y+1,mas^[2].pix[3].x-1,mas^[2].pix[3].y-1,true);
  us:=okn^[x,y];
  if (hp)and(49152{11000000.00000000})=49152 then hpg:=false
                                             else hpg:=true;
  if (us)and(49152{11000000.00000000})=49152 then usg:=false
                                             else usg:=true;
  if (hpg) then
   begin
   if (usg)then
    begin
    un:=(us)and(not(hp));
    pw:=0;
    if (un)and(16384{01000000.00000000})=16384 then
     pw:=(pw)or(16320{00111111.11000000});
    if (un)and(8192{00100000.00000000})=8192 then
     pw:=(pw)or(22080{01010110.01000000});
    if (un)and(4096{00010000.00000000})=4096 then
     pw:=(pw)or(27392{01101011.00000000});
    if (un)and(2048{00001000.00000000})=2048 then
     pw:=(pw)or(21888{01010101.10000000});
    if (un)and(1024{00000100.00000000})=1024 then
     pw:=(pw)or(26816{01101000.11000000});
    if (un)and(512{00000010.00000000})=512 then
     pw:=(pw)or(28992{01110001.01000000});
    if (un)and(256{00000001.00000000})=256 then
     pw:=(pw)or(23168{01011010.10000000});
    if (un)and(128{00000000.10000000})=128 then
     pw:=(pw)or(19776{01001101.01000000});
    if (un)and(64{00000000.01000000})=64 then
     pw:=(pw)or(26240{01100110.10000000});
    sd:=(hp)and((not(us))or(pw));
    if (un>0) then
     for i:=0 to 15 do
      begin
      if (un)and(1)=1 then
       posttext((x-1)*lx,(y-1)*ly,lx,ly,250-i,0,0);
      un:=un shr 1;
      end;
    end
           else
    begin
    setfillstyle(1,0);
    bar((x-1)*lx+1,(y-1)*ly+1,x*lx-1,y*ly-1);
    sd:=hp;
    end;
   if (sd)>0 then
    for i:=0 to 15 do
     begin
     if (sd)and(1)=1 then
      posttext((x-1)*lx,(y-1)*ly,lx,ly,250-i,1,0);
     sd:=sd shr 1;
     end;
   end
       else
   begin
   hc:=((hp)and(14336{00111000.00000000}))shr 11;
   ht:=(hp)and(2047{00000111.11111111});
   if (usg)then
    begin
    if (us>0) then
     begin
     setfillstyle(1,0);
     bar((x-1)*lx,(y-1)*ly,x*lx,y*ly);
     end;
    uc:=hc+1;
    ut:=ht+1;
    end
              else
    begin
    uc:=((us)and(14336{00111000.00000000}))shr 11;
    ut:=(us)and(2047{00000111.11111111});
    if (hc=uc)and(ht<>ut) then
     begin
     str(ut,s);
     for i:=1 to length(s) do
      posttext((x-1)*lx+(i-1)*lbx+1,(y-1)*ly+sby+1,lbx,lby,byte(s[i]),hc,0);
     end;
    end;
   if (hc<>uc) then
    begin
    setfillstyle(1,hc);
    bar((x-1)*lx+1,(y-1)*ly+1,x*lx-1,y*ly-1);
    ut:=ht+1;
    end;
   if (ht<>ut) then
    begin
    str(ht,s);
    for i:=1 to length(s) do
     posttext((x-1)*lx+(i-1)*lbx+1,(y-1)*ly+sby+1,lbx,lby,byte(s[i]),white,0);
    end;
   end;
  okn^[x,y]:=hp;
  setviewport(0,0,getmaxx,getmaxy,false);
  end;
end;

{---------------------------------------------------------}

procedure POZA;
begin
setfillstyle(1,2);
bar(pozah[1],pozah[2],pozah[3],pozah[4]);
bar(pozah[5],pozah[6],pozah[7],pozah[8]);
with mas^[6] do
 begin
 pozah[1]:=pix[1].x+1;
 pozah[2]:=pix[1].y+longint(pix[3].y-pix[1].y)*vv div my;
 if pozah[2]<=pix[1].y then pozah[2]:=pix[1].y+1;
 pozah[3]:=pix[3].x-1;
 pozah[4]:=pix[3].y-longint(pix[3].y-pix[1].y)*(my-vv-ky) div my;
 if pozah[4]>=pix[3].y then pozah[4]:=pix[3].y-1;
 end;
with mas^[8] do
 begin
 pozah[5]:=pix[1].x+longint(pix[3].x-pix[1].x)*ll div mx;
 if pozah[5]<=pix[1].x then pozah[5]:=pix[1].x+1;
 pozah[6]:=pix[1].y+1;
 pozah[7]:=pix[3].x-longint(pix[3].x-pix[1].x)*(mx-ll-kx) div mx;
 if pozah[7]>=pix[3].x then pozah[7]:=pix[3].x-1;
 pozah[8]:=pix[3].y-1;
 end;
setfillstyle(1,14);
bar(pozah[1],pozah[2],pozah[3],pozah[4]);
bar(pozah[5],pozah[6],pozah[7],pozah[8]);
end;

{----------------------------------------------------------}

procedure VIZOKN;
var i,j:byte;
begin
 for i:=1 to kx do
  for j:=1 to ky do
   vizelement(i,j);
end;

{-------------------------------------------------------}

procedure MOVEOKN(xi,yj:integer);
begin
if ((yj+ky)<my)and(yj>0) then vv:=yj
                          else if (yj+ky)>my-1 then vv:=(my-ky-1)
                                               else vv:=1;
if ((xi+kx)<mx)and(xi>0) then ll:=xi
                         else if (xi+kx)>mx-1 then ll:=(mx-kx-1)
                                              else ll:=1;
end;

{------------------------------------------------}

procedure SETONPLT(dirka:boolean;i,j,nc:word);
var z,fr1,fr2,il,ip,jv,jn,x,y:byte;
begin
 if not(edit) then exit;
 nevdan:=true;
 if dirka then
  begin
  fr1:=1;
  fr2:=rsl;
  if nc<>65535 then
   dir^[ll+i-1,j+vv-1]:=dir^[ll+i-1,j+vv-1] or 1
             else
   begin
   dir^[ll+i-1,j+vv-1]:=dir^[ll+i-1,j+vv-1] or 1;
   dir^[ll+i-1,j+vv-1]:=dir^[ll+i-1,j+vv-1] or 2;
   dir^[ll+i-1,j+vv-1]:=dir^[ll+i-1,j+vv-1]-1;
   end;
  end
          else
  begin
  fr1:=fr;
  fr2:=fr;
  end;
 for z:=fr1 to fr2 do
  begin
  if z=1 then plt1^[ll+i-1,j+vv-1]:=nc;
  if z=2 then plt2^[ll+i-1,j+vv-1]:=nc;
  if z=3 then plt3^[ll+i-1,j+vv-1]:=nc;
  if z=4 then plt4^[ll+i-1,j+vv-1]:=nc;
  if z=5 then plt5^[ll+i-1,j+vv-1]:=nc;
  if z=6 then plt6^[ll+i-1,j+vv-1]:=nc;
  if z=7 then plt7^[ll+i-1,j+vv-1]:=nc;
  if z=8 then plt8^[ll+i-1,j+vv-1]:=nc;
  end;
 il:=i; ip:=i;
 jv:=j; jn:=j;
 if graf then
  begin
  if i>1 then il:=i-1;
  if i<kx then ip:=i+1;
  if j>1 then jv:=j-1;
  if j<ky then jn:=j+1;
  end;
 for x:=il to ip do
  for y:=jv to jn do
   vizelement(x,y);
end;

{----------------------------------------------------------}

procedure SETPOINT;
var kxh,kyh,mm,i,j:word;
begin
 openmas(32+mh,false,1,1);
 openmas(32+m,true,14,5);
 mm:=1;
 for i:=2 to m do mm:=mm*2;
 with mas^[1] do
  begin
  lx:=(pix[3].x-pix[1].x)div (4*mm);
  ly:=(pix[3].y-pix[1].y)div (3*mm);
  sby:=(ly-2)div 4;
  lby:=(ly-2)div 2;
  lbx:=(lx-2)div 4;
  kxh:=kx; kyh:=ky;
  kx:=(3*(pix[3].x-pix[1].x) div 4)div lx;
  ky:=(2*(pix[3].y-pix[1].y) div 3)div ly;
  end;
 moveokn(ll+kxh div 2-kx div 2,vv+kyh div 2-ky div 2);
 for i:=1 to 100 do
  for j:=1 to 70 do
   okn^[i,j]:=0;
 setviewport(mas^[2].pix[1].x+1,mas^[2].pix[1].y+1,
             mas^[2].pix[3].x-1,mas^[2].pix[3].y-1,true);
 clearviewport;
 if (m<5) then
  for i:=0 to kx do
   for j:=0 to ky do
    putpixel(i*lx,j*ly,white);
 setviewport(0,0,getmaxx,getmaxy,false);
 vizokn;
 poza;
end;

{----------------------------------------------------------}

procedure SUPERROUTING(a1,b1,a2,b2:word);
var   r1,r2:char;
      dx,dy:integer;
      it,jt,kod,i,nk,cs:byte;
      t:pointer;
      exi:boolean;
      ss0,ss1,ss2,ss3:string;

BEGIN
   it:=1; jt:=1;
   cs:=white;
   nc:=1;
   m:=3;
   otkrplt(rsl,exi);
   if exi then exit;
   if rsl=0 then
    begin
    zakrplt(rsl);
    exit;
    end;
   inittext;
   initmas(a1,b1,a2,b2);
   with mas^[2] do
    begin
    xs:=(pix[3].x+pix[1].x)div 2;
    ys:=(pix[3].y+pix[1].y)div 2;
    end;
   zamstr(mas^[12].pix[1].x+1,mas^[12].pix[1].y+1,
         mas^[12].pix[3].x-1,
         (mas^[12].pix[3].y-mas^[12].pix[1].y)div 2+mas^[12].pix[1].y,
          '**','SCALE',0,12,0,4);
   zamstr(mas^[7].pix[1].x+1,mas^[7].pix[1].y+1,
         (mas^[7].pix[3].x-mas^[7].pix[1].x)div 2+mas^[7].pix[1].x-1,
         mas^[7].pix[3].y-1,
          '**','  LAYER  ',0,12,0,5);
   ss1:='COLUMN:   ';
   zamstr(mas^[9].pix[1].x+1,mas^[9].pix[1].y+1,
         mas^[9].pix[3].x-1,mas^[9].pix[3].y-1,
          '**',ss1,6,14,0,12);
   ss2:=' LINE:    ';
   zamstr(mas^[10].pix[1].x+1,mas^[10].pix[1].y+1,
         mas^[10].pix[3].x-1,mas^[10].pix[3].y-1,
          '**',ss2,6,14,0,12);
   ss3:='CHAIN:0   ';
   zamstr(mas^[11].pix[1].x+1,mas^[11].pix[1].y+1,
         mas^[11].pix[3].x-1,mas^[11].pix[3].y-1,
          '**',ss3,6,14,0,12);
   zamstr(mas^[4].pix[1].x+1,mas^[4].pix[1].y+1,
         mas^[4].pix[3].x-1,mas^[4].pix[3].y-1,
          '**','SAVE',0,15,0,4);
   zamstr(mas^[5].pix[1].x+1,mas^[5].pix[1].y+1,
         mas^[5].pix[3].x-1,mas^[5].pix[3].y-1,
          '**','LOAD',0,15,0,4);
   zamstr(mas^[47].pix[1].x+1,mas^[47].pix[1].y+1,
         mas^[47].pix[3].x-1,mas^[47].pix[3].y-1,
          '**','MENU',0,15,0,4);
   zamstr(mas^[3].pix[1].x+1,mas^[3].pix[1].y+1,
         mas^[3].pix[3].x-1,mas^[3].pix[3].y-1,
          '**','TUNE',0,15,0,4);
   zamstr(mas^[53].pix[1].x+1,mas^[53].pix[1].y+1,
         mas^[53].pix[3].x-1,mas^[53].pix[3].y-1,
          '**','MAKE',0,15,0,4);
   zamstr(mas^[54].pix[1].x+1,mas^[54].pix[1].y+1,
         mas^[54].pix[3].x-1,mas^[54].pix[3].y-1,
          '**','HELP',0,15,0,4);
   zamstr(mas^[13].pix[1].x+1,mas^[13].pix[1].y+1,mas^[13].pix[3].x-1,
          mas^[13].pix[1].y+(mas^[13].pix[3].y-mas^[13].pix[1].y)div 2,
          '**',' EDIT ',0,5,0,4);
   zamstr(mas^[14].pix[1].x+1,mas^[14].pix[1].y+1,mas^[14].pix[3].x-1,
          mas^[14].pix[1].y+(mas^[14].pix[3].y-mas^[14].pix[1].y)div 2,
          '**',' MODE ',0,10,0,4);
   zamstr(mas^[52].pix[1].x+1,mas^[52].pix[1].y+1,
          mas^[52].pix[3].x-1,mas^[52].pix[3].y,
          '**',' ROUTER NO ACTIV  ',0,2,0,5);
   zamstr(mas^[15].pix[1].x+1,mas^[15].pix[1].y+1,
          mas^[15].pix[3].x-1,mas^[15].pix[3].y,
          '**',#0,0,12,0,0);
   zamstr(mas^[16].pix[1].x+1,mas^[16].pix[1].y+(mas^[16].pix[3].y-mas^[16].pix[1].y+1)div 4,
          mas^[16].pix[3].x-1,mas^[16].pix[3].y-(mas^[16].pix[3].y-mas^[16].pix[1].y+1)div 4,
          '**','EXIT',0,0,0,0);
   mh:=m;
   fr:=1;frh:=1;
   edit:=true;
   routing:=false;
   graf:=false;
   nevdan:=true;
   for i:=1 to 8 do
    pozah[i]:=getmaxx+10;
   vv:=1; ll:=1;

   setpoint;
   openmas(38+fr,true,15,5);
   settextjustify(centertext,centertext);
   alt:=false;
   ctrl:=false;
   repeat
    repeat
     if not(mesto(2)) then
      begin
      getmem(t,imagesize(xs,ys,xs+10,ys+10));
      getimage(xs,ys,xs+10,ys+10,t^);
      setcolor(cs);
      for i:=1 to 4 do
       line(xs,ys,xs+10-i,ys+5+i);
      setcolor(cs+1);
      for i:=0 to 1 do
       line(xs,ys,xs+10-i*5,ys+5+i*5);
      end
                      else
      begin
      xx:=(xs-mas^[2].pix[1].x)div lx+1;
      if xx>kx then xx:=kx;
      str(xx+ll-1,ss0);
      strplus(ss0,3);
      ss0:='COLUMN:'+ss0;
      zamstr(mas^[9].pix[1].x+1,mas^[9].pix[1].y+1,
            mas^[9].pix[3].x-1,mas^[9].pix[3].y-1,
             ss1,ss0,6,14,0,12);
      ss1:=ss0;
      yy:=(ys-mas^[2].pix[1].y)div ly+1;
      if yy>ky then yy:=ky;
      str(yy+vv-1,ss0);
      strplus(ss0,4);
      ss0:=' LINE:'+ss0;
      zamstr(mas^[10].pix[1].x+1,mas^[10].pix[1].y+1,
             mas^[10].pix[3].x-1,mas^[10].pix[3].y-1,
             ss2,ss0,6,14,0,12);
      ss2:=ss0;
      setwritemode(xorput);
      setcolor(14);
      with mas^[2] do
       rectangle(pix[1].x+(xx-1)*lx+1,pix[1].y+(yy-1)*ly+1,pix[1].x+xx*lx+1,pix[1].y+yy*ly+1);
      end;
     kod:=0;
     if routing then TRASSIRS(it,jt,kod);

     READKEYMOUS(not(routing),r1,r2,dx,dy,nk);

     if not(mesto(2)) then
      begin
      putimage(xs,ys,t^,normalput);
      freemem(t,imagesize(xs,ys,xs+10,ys+10));
      end
                       else
      begin
      with mas^[2] do
       rectangle(pix[1].x+(xx-1)*lx+1,pix[1].y+(yy-1)*ly+1,pix[1].x+xx*lx+1,pix[1].y+yy*ly+1);
      setwritemode(normalput);
      end;
     with mas^[1] do
      begin
      if (((xs+dx)>=pix[1].x)and((xs+dx)<=pix[3].x-10)) then xs:=xs+dx;
      if (((ys+dy)>=pix[1].y)and((ys+dy)<=pix[3].y-10)) then ys:=ys+dy;
      end;
     if kod<>0 then vizokn;
    until ((r1<>#0)or(r2<>#0)or(nk>0));


               {-------------------------------}
               {--------обработка клавиш-------}
               {-------------------------------}



                        {смена маштаба}

    if (r1=#43)and(m<6) then
     begin
     mh:=m;
     if (ctrl) then m:=6
               else inc(m);
     setpoint;
     end;
    if (r1=#45)and(m>1) then
     begin
     mh:=m;
     if (ctrl) then m:=1
               else dec(m);
     setpoint;
     end;
    for i:=1 to 6 do
     if (nk>0)and(mesto(32+i)) then
      begin
      mh:=m;
      m:=i;
      if (m<>mh) then
       setpoint;
      end;

                          {переход на другой слой}

    if (r2>#58)and(r2<#67)and(byte(r2)-58<=rsl) then
     begin
     frh:=fr;
     fr:=byte(r2)-58;
     if fr<>frh then
      begin
      openmas(38+frh,false,1,1);
      openmas(38+fr,true,15,5);
      vizokn;
      end;
     end;
    for i:=1 to 8 do
     if (nk>0)and(mesto(38+i))and(i<=rsl) then
      begin
      frh:=fr;
      fr:=i;
      if fr<>frh then
       begin
       openmas(38+frh,false,1,1);
       openmas(38+fr,true,15,5);
       vizokn;
       end;
      end;

                        {установка на экран элемента}

    if ((nk=1)or((r1=#13)and(not(alt))))and(mesto(2)) then
     begin
     setonplt(false,xx,yy,nc);
     end;
    if ((nk=3)or((r1=#13)and(alt)))and(mesto(2)) then
     begin
     setonplt(true,xx,yy,nc);
     end;
    if ((nk=2)or((r2=#83)and(not(alt))))and(mesto(2)) then
     begin
     setonplt(false,xx,yy,65535);
     end;
    if ((nk=4)or((r2=#83)and(alt)))and(mesto(2)) then
     begin
     setonplt(true,xx,yy,65535);
     end;

                  {скролинг по диагоналли на единицу}

    if (mesto(2))and(r2=#71)and(vv<>1)and(ll<>1)
       and(((alt)and(not(ctrl)))or(xx=1)or(yy=1))
       then
     begin
     dec(vv);
     dec(ll);
     vizokn;
     poza;
     end;
    if (mesto(2))and(r2=#73)and(vv<>1)and(ll<>mx-kx)
       and(((alt)and(not(ctrl)))or(xx=kx)or(yy=1))
       then
     begin
     dec(vv);
     inc(ll);
     vizokn;
     poza;
     end;
    if (mesto(2))and(r2=#79)and(vv<>my-ky)and(ll<>1)
       and(((alt)and(not(ctrl)))or(xx=1)or(yy=ky))
       then
     begin
     inc(vv);
     dec(ll);
     vizokn;
     poza;
     end;
    if (mesto(2))and(r2=#81)and(vv<>my-ky)and(ll<>mx-kx)
       and(((alt)and(not(ctrl)))or(xx=kx)or(yy=ky))
       then
     begin
     inc(vv);
     inc(ll);
     vizokn;
     poza;
     end;

                    {движение курсора по диагонали}

    if (r2=#71)and(not(alt))and(not(ctrl))and(xx<>1)and(yy<>1)and(mesto(2)) then
     begin
     dec(xx);
     dec(yy);
     xs:=mas^[2].pix[1].x+lx*xx-lx div 2;
     ys:=mas^[2].pix[1].y+ly*yy-ly div 2;
     end;
    if (r2=#73)and(not(alt))and(not(ctrl))and(xx<>kx)and(yy<>1)and(mesto(2)) then
     begin
     inc(xx);
     dec(yy);
     xs:=mas^[2].pix[1].x+lx*xx-lx div 2;
     ys:=mas^[2].pix[1].y+ly*yy-ly div 2;
     end;
    if (r2=#79)and(not(alt))and(not(ctrl))and(xx<>1)and(yy<>ky)and(mesto(2)) then
     begin
     dec(xx);
     inc(yy);
     xs:=mas^[2].pix[1].x+lx*xx-lx div 2;
     ys:=mas^[2].pix[1].y+ly*yy-ly div 2;
     end;
    if (r2=#81)and(not(alt))and(not(ctrl))and(xx<>kx)and(yy<>ky)and(mesto(2)) then
     begin
     inc(xx);
     inc(yy);
     xs:=mas^[2].pix[1].x+lx*xx-lx div 2;
     ys:=mas^[2].pix[1].y+ly*yy-ly div 2;
     end;

                         {скролинг экрана на единицу}

    if (vv>1)and(((nk>0)and(mesto(17)))
                 or((alt)and(not(ctrl))and(r2=#72))
                 or(not(alt))and(not(ctrl))and(yy=1)and(r2=#72)and(mesto(2)))
                 then
     begin
     dec(vv);
     vizokn;
     poza;
     end;
    if (vv+ky-1<my)and(((nk>0)and(mesto(19)))
                       or((alt)and(not(ctrl))and(r2=#80))
                       or(not(alt))and(not(ctrl))and(yy=ky)and(r2=#80)and(mesto(2)))
                       then
     begin
     inc(vv);
     vizokn;
     poza;
     end;
    if (ll>1)and(((nk>0)and(mesto(21)))
                 or((alt)and(not(ctrl))and(r2=#75))
                 or(not(alt))and(not(ctrl))and(xx=1)and(r2=#75)and(mesto(2)))
                 then
     begin
     dec(ll);
     vizokn;
     poza;
     end;
    if (ll+kx-1<mx)and(((nk>0)and(mesto(23)))
                       or((alt)and(not(ctrl))and(r2=#77))
                       or(not(alt))and(not(ctrl))and(xx=kx)and(r2=#77)and(mesto(2)))
                       then
     begin
     inc(ll);
     vizokn;
     poza;
     end;

                  {клавишное движение курсора}

    if (mesto(2))and(not(alt))and(not(ctrl))and(xx<kx)
       and((r2=#77)
           or((r2=#81)and(yy=ky)and(vv=my-ky))
           or((r2=#73)and(yy=1)and(vv=1)))
           then
     begin
     inc(xx);
     xs:=mas^[2].pix[1].x+lx*xx-lx div 2;
     end;
    if (mesto(2))and(not(alt))and(not(ctrl))and(xx>1)
       and((r2=#75)
           or((r2=#79)and(yy=ky)and(vv=my-ky))
           or((r2=#71)and(yy=1)and(vv=1)))
           then
     begin
     dec(xx);
     xs:=mas^[2].pix[1].x+lx*xx-lx div 2;
     end;
    if (mesto(2))and(not(alt))and(not(ctrl))and(yy<ky)
        and((r2=#80)
            or((r2=#79)and(xx=1)and(ll=1))
            or((r2=#81)and(xx=kx)and(ll=mx-kx)))
            then
     begin
     inc(yy);
     ys:=mas^[2].pix[1].y+ly*yy-ly div 2;
     end;
    if (mesto(2))and(not(alt))and(not(ctrl))and(yy>1)
        and((r2=#72)
            or((r2=#71)and(xx=1)and(ll=1))
            or((r2=#73)and(xx=kx)and(ll=mx-kx)))
            then
     begin
     dec(yy);
     ys:=mas^[2].pix[1].y+ly*yy-ly div 2;
     end;

                         {скролинг экрана на страницу}

    if (vv>1)and(((nk>0)and(mesto(18)))
                 or((ctrl)and(not(alt))and(r2=#72)))
                 then
     begin
     if (vv-ky>1) then dec(vv,ky)
                  else vv:=1;
     vizokn;
     poza;
     end;
    if (vv+ky-1<my)and(((nk>0)and(mesto(20)))
                       or((ctrl)and(not(alt))and(r2=#80)))
                       then
     begin
     if (vv+ky-1+ky<my) then inc(vv,ky)
                        else vv:=my+1-ky;
     vizokn;
     poza;
     end;
    if (ll>1)and(((nk>0)and(mesto(22)))
                 or((ctrl)and(not(alt))and(r2=#75))
                 or(r2=#115))
                 then
     begin
     if (ll-kx>1) then dec(ll,kx)
                  else ll:=1;
     vizokn;
     poza;
     end;
    if (ll+kx-1<mx+1)and(((nk>0)and(mesto(24)))
                         or((ctrl)and(not(alt))and(r2=#77))
                         or(r2=#116))
                         then
     begin
     if (ll+kx-1+kx<mx) then inc(ll,kx)
                        else ll:=mx+1-kx;
     vizokn;
     poza;
     end;

              {мышиное координатное перемещение экрана}

    if (nk>0)and(mesto(6)) then
     begin
     moveokn(ll,((longint(ys-mas^[6].pix[1].y)*my)div longint(mas^[6].pix[3].y-mas^[6].pix[1].y))-ky div 2);
     vizokn;
     poza;
     end;
    if (nk>0)and(mesto(8)) then
     begin
     moveokn(((longint(xs-mas^[8].pix[1].x)*mx)div longint(mas^[8].pix[3].x-mas^[8].pix[1].x))-kx div 2,vv);
     vizokn;
     poza;
     end;
    if (r1=#9)or((nk>0)and(mesto(56))) then
     begin
     if graf then
      begin
      graf:=false;
      openmas(56,false,1,1);
      end
             else
      begin
      graf:=true;
      openmas(56,true,14,2);
      end;
     vizokn;
     end;
    if ((r1='z')or((nk>0)and(mesto(9))))and(nc>0) then
     begin
     dec(nc);
     str(nc,ss0);
     strplus(ss0,4);
     ss0:='CHAIN:'+ss0;
     zamstr(mas^[11].pix[1].x+1,mas^[11].pix[1].y+1,
           mas^[11].pix[3].x-1,mas^[11].pix[3].y-1,
            ss3,ss0,6,14,0,12);
     ss3:=ss0;
     end;
    if ((r1='x')or((nk>0)and(mesto(10))))and(nc<2047) then
     begin
     inc(nc);
     str(nc,ss0);
     strplus(ss0,4);
     ss0:='CHAIN:'+ss0;
     zamstr(mas^[11].pix[1].x+1,mas^[11].pix[1].y+1,
           mas^[11].pix[3].x-1,mas^[11].pix[3].y-1,
            ss3,ss0,6,14,0,12);
     ss3:=ss0;
     end;
    if (r2=#82)or((nk>0)and(mesto(55))) then
     if edit then
      begin
      edit:=false;
      zamstr(mas^[13].pix[1].x+1,mas^[13].pix[1].y+1,mas^[13].pix[3].x-1,
             mas^[13].pix[1].y+(mas^[13].pix[3].y-mas^[13].pix[1].y)div 2,
             ' EDIT ',' VIEU ',0,5,0,12);
      end
             else
      begin
      edit:=true;
      zamstr(mas^[13].pix[1].x+1,mas^[13].pix[1].y+1,mas^[13].pix[3].x-1,
             mas^[13].pix[1].y+(mas^[13].pix[3].y-mas^[13].pix[1].y)div 2,
             ' VIEU ',' EDIT ',0,5,0,12);
      end;
    if (r1='r')or((nk>0)and(mesto(52))) then
     if routing then
      begin
      routing:=false;
      openmas(52,false,1,1);
      zamstr(mas^[52].pix[1].x+1,mas^[52].pix[1].y+1,
             mas^[52].pix[3].x-1,mas^[52].pix[3].y-1,
             '**',' ROUTER NO ACTIV  ',0,2,0,5);
      end
             else
      begin
      routing:=true;
      openmas(50,false,1,1);
      openmas(51,false,1,1);
      setfillstyle(1,red);
      zamstr(mas^[51].pix[1].x+1,mas^[51].pix[1].y+1,
             mas^[51].pix[3].x-1,mas^[51].pix[3].y-1,
             '**','  ROUTER  ACTIV   ',0,14,0,5);
      end;
      if (r1='s')or((nk>0)and(mesto(4))) then save('router.dat');
      if (r1='l')or((nk>0)and(mesto(5))) then load('router.dat');
      alt:=false; ctrl:=false;
   until (r1=#27)or((nk>2)and(mesto(16)));
   setfillstyle(1,0);
   bar(a1,b1,a2,b2);
   zakrplt(rsl);
end;

{--------------------------------------------------}

procedure save(name:string);
begin
end;

{--------------------------------------------------}

procedure load(name:string);
begin
end;

{-------------------------------------------------}
   END.
