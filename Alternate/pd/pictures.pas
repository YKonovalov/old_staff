{$I-,S-}
{$M 1024,0,0}

{************************************************************************}
{*                                                                      *}
{* Модуль "Pictures"(!) для вывода графических изображений, созданных   *}
{*                    в графическом редакторе GEK.                      *}
{*                       Версия 2.2, Апр 1993.                          *}
{*                         (c) Д.В.Корнилов.                            *}
{* !-Оригинальное название "Gek_u"                                      *}
{* !-коррекция Ю.Д.Коновалова 3.06.93 для "Plate Disigner 1.0"          *}
{************************************************************************}

unit Pictures;
   interface

      uses crt,graph;

      const col:array[0..15] of byte=
         (0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15);
         {Массив цветов, в соответствии с которым производится
          вывод.}

      var gekerror:boolean;
         {<false>, если успех, в обратном случае <true>.}

      procedure gekload(filename:string;
         x00,y00,wmx,wmy,klwm:integer);
      {Процедура вывода картинки. filename - имя файла,
       x00,y00 - позиция вывода, wmx,wmy - размеры окна,
       klwm - ключ,
            = 0 - wmx,wmy - берутся из файла,
            = 1 - wmx,wmy - заданы вами.
       Скорость вывода максимальна, когда адаптер - EGA, VGA и
       wmx,wmy совпадают с внутрифайловыми.}

   implementation

      var f:file;
          buf:array[1..512] of integer;
          colors:array[0..639] of byte;
          prefix:array[0..3] of char;

      procedure line_vm(x1,x2,y:integer;col:byte);
         var pos1,pos2,p1,p2:byte;
         begin(*line_vm*)
            asm
               {установка режима записи}
               mov     dx,3ceh
               mov     al,5
               out     dx,al
               inc     dx
               mov     al,2
               out     dx,al
               {регистр маски карты}
               mov     dx,3c4h
               mov     al,2
               out     dx,al
               inc     dx
               mov     al,0ffh
               out     dx,al
               {начальные параметры}
               mov     ax,5
               mul     y
               add     ax,0a000h
               mov     es,ax
               mov     ax,x1
               mov     pos1,8
               div     pos1
               mov     pos1,ah
               mov     p1,al
               mov     ax,x2
               mov     pos2,8
               div     pos2
               inc     ah
               mov     pos2,ah
               mov     p2,al
               cmp     p1,al
               {когда все в одном байте}
               je      @mp1ep2
               {начало}
               mov     ah,0ffh
               mov     cl,8
               sub     cl,pos1
               shl     ah,cl
               not     ah
               sub     bh,bh
               mov     bl,p1
               {вывод точек}
               mov     dx,3ceh
               mov     al,8
               out     dx,al
               inc     dx
               mov     al,ah
               out     dx,al
               mov     al,es:[bx]
               mov     al,col
               mov     es:[bx],al
               {середина}
               mov     ah,p1
               mov     al,p2
               sub     al,ah
               cmp     al,1
               je      @mnoser
               sub     ah,ah
               mov     cx,ax
               dec     cx
               sub     bh,bh
               mov     bl,p1
               mov     si,1
               mov     dx,3ceh
               mov     al,8
               out     dx,al
               inc     dx
               mov     al,0ffh
               out     dx,al
               {вывод точек}
@m1:           mov     al,es:[bx+si]
               mov     al,col
               mov     es:[bx+si],al
               inc     si
               loop    @m1
               {конец}
@mnoser:       mov     ah,0ffh
               sub     bh,bh
               mov     bl,p2
               mov     cl,pos2
               shr     ah,cl
               not     ah
               {вывод точек}
               mov     dx,3ceh
               mov     al,8
               out     dx,al
               inc     dx
               mov     al,ah
               out     dx,al
               mov     al,es:[bx]
               mov     al,col
               mov     es:[bx],al
               jmp     @mexit
@mp1ep2:       mov     ax,0ffffh
               mov     cl,8
               sub     cl,pos1
               shl     ah,cl
               mov     cl,pos2
               shr     al,cl
               or      ah,al
               not     ah
               {вывод точек}
               sub     bh,bh
               mov     bl,p1
               mov     dx,3ceh
               mov     al,8
               out     dx,al
               inc     dx
               mov     al,ah
               out     dx,al
               mov     al,es:[bx]
               mov     al,col
               mov     es:[bx],al
@mexit:
            end;
         end;(*line_vm*)

      procedure gekload(filename:string;
         x00,y00,wmx,wmy,klwm:integer);
         label endcicl;
         var rab,teky,tekx,sch,res,dx,dy,gd,gm,gmx,gmy:integer;
             gty,col1,col2,drfl,mode:byte;
             lx,ly:real;
             flvm:boolean;
         function prov:boolean;
            begin(*prov*)
               prov:=false;
               if sch=res+1 then
                  begin
                  blockread(f,buf,512,res);
                  if res>0 then
                     sch:=1
                  else
                     prov:=true;
                  end
            end;(*prov*)
         begin(*gekload*)
            gekerror:=true;
            assign(f,filename);
            reset(f,2);
            if ioresult<>0 then
               exit;
            blockread(f,prefix,2);
            if (ioresult<>0) or (prefix<>'GEK0') then
               begin
               close(f);
               exit;
               end;
            blockread(f,dx,1);
            if (ioresult<>0) or (dx<0) then
               begin
               close(f);
               exit;
               end;
            blockread(f,dy,1);
            if (ioresult<>0) or (dy<0) then
               begin
               close(f);
               exit;
               end;
            gmx:=639;
            asm
               mov  ah,0fh
               int  10h
               mov  mode,al
            end;
            if mode=$0e then
               gmy:=199
            else
               if mode=$10 then
                  gmy:=349
               else
                  if mode=$12 then
                     gmy:=479;
            res:=0;
            sch:=1;
            teky:=0;
            tekx:=0;
            if klwm=0 then
               begin
               wmx:=dx;
               wmy:=dy;
               end;
            lx:=wmx/dx;
            ly:=wmy/dy;
            if not((wmx>=0) and (wmy>=0)) then
               begin
               close(f);
               exit;
               end;
            flvm:=((mode=$0e) or (mode=$10) or (mode=$12))
               and (x00+wmx<=gmx) and (y00+wmy<=gmy)
               and (x00>=0) and (y00>=0);
            if ly>1 then
               begin
               if lx>1 then
                  begin
                  drfl:=0;
                  end
               else
                  begin
                  if lx<1 then
                     begin
                     drfl:=20;
                     end
                  else
                     begin
                     drfl:=10;
                     end
                  end
               end
            else
               begin
               if ly<1 then
                  begin
                  if lx>1 then
                     begin
                     if flvm then
                        drfl:=201
                     else
                        drfl:=200;
                     end
                  else
                     begin
                     if lx<1 then
                        begin
                        if flvm then
                           drfl:=221
                        else
                           drfl:=220;
                        end
                     else
                        begin
                        if flvm then
                           drfl:=211
                        else
                           drfl:=210;
                        end
                     end
                  end
               else
                  begin
                  if lx>1 then
                     begin
                     if flvm then
                        drfl:=101
                     else
                        drfl:=100;
                     end
                  else
                     begin
                     if lx<1 then
                        begin
                        if flvm then
                           drfl:=121
                        else
                           drfl:=120;
                        end
                     else
                        begin
                        if flvm then
                           drfl:=111
                        else
                           drfl:=110;
                        end
                     end
                  end
               end;
            if prov then
               goto endcicl;
            repeat
               rab:=buf[sch];
               if rab<0 then
                  begin
                  gty:=(hi(rab) shr 2) and 31;
                  if gty=31 then
                     begin
                     inc(sch);
                     if prov then
                        goto endcicl;
                     inc(teky,buf[sch])
                     end
                  else
                     inc(teky,gty);
                  tekx:=rab and 1023;
                  end
               else
                  begin
                  col1:=hi(rab) shr 2;
                  col2:=col1 and 15;
                  case drfl of
                     0:begin
                       setfillstyle(solidfill,col[col2]);
                       bar(x00+longint(tekx)*wmx div dx,
                          y00+longint(teky)*wmy div dy,
                          x00+longint(rab and 1023)*wmx div dx-1,
                          y00+longint(teky+1)*wmy div dy-1);
                       end;
                    10:begin
                       setfillstyle(solidfill,col[col2]);
                       bar(x00+tekx,
                          y00+longint(teky)*wmy div dy,
                          x00+rab and 1023-1,
                          y00+longint(teky+1)*wmy div dy-1);
                       end;
                    20:begin
                       setfillstyle(solidfill,col[col2]);
                       bar(x00+longint(tekx)*wmx div dx,
                          y00+longint(teky)*wmy div dy,
                          x00+longint(rab and 1023-1)*wmx div dx,
                          y00+longint(teky+1)*wmy div dy-1);
                       end;
                   100:begin
                       setcolor(col[col2]);
                       line(x00+longint(tekx)*wmx div dx,
                          y00+teky,
                          x00+longint(rab and 1023)*wmx div dx-1,
                          y00+teky);
                       end;
                   101:begin
                       line_vm(x00+longint(tekx)*wmx div dx,
                          x00+longint(rab and 1023)*wmx div dx-1,
                          y00+teky,col[col2]);
                       end;
                   110:begin
                       setcolor(col[col2]);
                       line(x00+tekx,
                          y00+teky,
                          x00+rab and 1023-1,
                          y00+teky);
                       end;
                   111:begin
                       line_vm(x00+tekx,
                          x00+rab and 1023-1,
                          y00+teky,col[col2]);
                       end;
                   120:begin
                       setcolor(col[col2]);
                       line(x00+longint(tekx)*wmx div dx,
                          y00+teky,
                          x00+longint(rab and 1023-1)*wmx div dx,
                          y00+teky);
                       end;
                   121:begin
                       line_vm(x00+longint(tekx)*wmx div dx,
                          x00+longint(rab and 1023-1)*wmx div dx,
                          y00+teky,col[col2]);
                       end;
                   200:begin
                       setcolor(col[col2]);
                       line(x00+longint(tekx)*wmx div dx,
                          y00+longint(teky)*wmy div dy,
                          x00+longint(rab and 1023)*wmx div dx-1,
                          y00+longint(teky)*wmy div dy);
                       end;
                   201:begin
                       line_vm(x00+longint(tekx)*wmx div dx,
                          x00+longint(rab and 1023)*wmx div dx-1,
                          y00+longint(teky)*wmy div dy,col[col2]);
                       end;
                   210:begin
                       setcolor(col[col2]);
                       line(x00+tekx,
                          y00+longint(teky)*wmy div dy,
                          x00+rab and 1023-1,
                          y00+longint(teky)*wmy div dy);
                       end;
                   211:begin
                       line_vm(x00+tekx,
                          x00+rab and 1023-1,
                          y00+longint(teky)*wmy div dy,col[col2]);
                       end;
                   220:begin
                       setcolor(col[col2]);
                       line(x00+longint(tekx)*wmx div dx,
                          y00+longint(teky)*wmy div dy,
                          x00+longint(rab and 1023-1)*wmx div dx,
                          y00+longint(teky)*wmy div dy);
                       end;
                   221:begin
                       line_vm(x00+longint(tekx)*wmx div dx,
                          x00+longint(rab and 1023-1)*wmx div dx,
                          y00+longint(teky)*wmy div dy,col[col2]);
                       end;
                  end;
                  tekx:=rab and 1023;
                  if col1<>col2 then
                     begin
                     inc(teky);
                     tekx:=0;
                     end;
                  end;
               inc(sch);
               if prov then
                  goto endcicl;
            until false;
endcicl:    setcolor(white);
            close(f);
            gekerror:=false;
         end;(*gekload*)

   begin(*gek_u*)
   end.(*gek_u*)
