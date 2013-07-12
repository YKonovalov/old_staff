uses Graph,YK_fonts,CRT,Vision;
   Var Gd,Gm:integer;
      J,I:word;
      c:char;
Begin
  initFont(0,255);
    Gd:=detect;
         initgraph (Gd,Gm,'');
     Gd:=graphresult;
     if Gd<>grok then
    begin
     textcolor(4);
     writeln (grapherrormsg(Gd));
     Halt
    end;
     Lx:=GetMaxX;
  for i:=0 to 79 do
   for j:=0 to 24 do  YK_OutChar(@font[j*80+i],i*8,j*16,14,16);
    C:=readkey;
  closegraph;
End.
