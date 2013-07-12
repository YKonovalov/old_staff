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
