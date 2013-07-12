{$O+}
{$F+}
UNIT MENUS;
 INTERFACE
 Uses Vision,Crt,Graph,Memory,Control,Disc,Dos,Pictures;

  Var FlowerName:Pathstr;
  {---------------------------------}
   Procedure Menu(Clear,r:boolean;x,y:word;Var c:Char);
   Procedure PutEditValue(v,cf:Byte);
   Procedure PutEdit;
   Procedure Vmenu(v:Byte;d:Integer;ch:char);
   Function  Chos:PathStr;
   Function NumberL(c:char):Byte;
  {---------------------------------}
 IMPLEMENTATION
{--------------------------------------------------------}
Procedure Menu(Clear,r:boolean;x,y:word;Var c:Char);
Var i,j,k,l,z,a:Word;
    v,b:boolean;            s:PathStr;
  Procedure Putdubs(M:boolean;v,cr,cf,cl,clf:byte);
   Var T:Array[1..3]Of PointType;
       B:Array[1..3]Of PointType;
       I,j,k,l:Word;
   begin
    Case v of
  1: Begin
     i:=x+qx; j:=y+qy; k:=x+qx+sx; l:=y+qy+sy;
     T[1].X:=x+qx+sx div 5;
     T[1].Y:=y+sy;
     T[2].X:=x+sx;
     T[2].Y:=y+qy+sy div 5;
     T[3].X:=X+sx;
     T[3].Y:=y+qy+4*sy div 5;
     B[1].X:=x+qx+sx div 2;
     B[1].Y:=y+sy;
     B[2].X:=x+qx+4*sx div 5;
     B[2].Y:=y+qy+sy div 5;
     B[3].X:=B[2].X;
     B[3].Y:=y+qy+4*sy div 5;
     end;
  2: Begin
     i:=x+qx; j:=y+5*qy; k:=x+qx+sx; l:=y+7*qy;
     T[1].X:=x+qx+sx div 5;
     T[1].Y:=y+5*qy+sy div 5;
     T[2].X:=x+sx;
     T[2].Y:=y+3*sy;
     T[3].X:=x+qx+sx div 5;
     T[3].Y:=y+5*qy+4*sy div 5;
     B[1].X:=x+sx;
     B[1].Y:=y+5*qy+sy div 5;
     B[2].X:=x+qx+4*sx div 5;
     B[2].Y:=y+3*sy;
     B[3].X:=x+sx;
     B[3].Y:=y+5*qy+4*sy div 5;
     End;
  3: Begin
     i:=x+5*qx; j:=y+qy; k:=x+7*qx; l:=y+qy+sy;
     T[1].X:=x+3*sx;
     T[1].Y:=y+qy+sy div 5;
     T[2].X:=x+5*qx+sx div 5;
     T[2].Y:=y+sy;
     T[3].X:=x+5*qx+4*sx div 5;
     T[3].Y:=y+sy;
     B[1].X:=x+3*sx;
     B[1].Y:=y+sy;
     B[2].X:=x+5*qx+sx div 5;
     B[2].Y:=y+qy+4*sy div 5;
     B[3].X:=x+5*qx+4*sx div 5;
     B[3].Y:=y+qy+4*sy div 5;
     End;
  4: Begin
     i:=x+5*qx; j:=y+5*qy; k:=x+7*qx; l:=y+7*qy;
     T[1].X:=x+5*qx+sx div 5;
     T[1].Y:=y+5*qy+sy div 5;
     T[2].X:=x+5*qx+4*sx div 5;
     T[2].Y:=y+5*qy+sy div 5;
     T[3].X:=x+3*sx;
     T[3].Y:=y+3*sy;
     B[1].X:=x+5*qx+sx div 5;
     B[1].Y:=y+3*sy;
     B[2].X:=x+5*qx+4*sx div 5;
     B[2].Y:=y+3*sy;
     B[3].X:=x+3*sx;
     B[3].Y:=y+5*qy+4*sy div 5;
     End;
  End;
    setfillstyle(1,cf);
    setcolor(cr);
    Bary(i,j,k,l,M);
    Rectangle(i,j,k,l);
    setfillstyle(1,clf);
    FillPoly(3,T);
    FillPoly(3,B);
 End;
 {==============================================}
 Procedure puthelp(cf:byte;v:boolean);
 Begin
  settextstyle(triplexfont,0,1);
  setusercharsize(textScale.Trp[1,1],textScale.Trp[1,2],
                  textScale.Trp[1,3],textScale.Trp[1,4]);
  setfillstyle(1,cf);
  Bary(x+qx,y+7*qy+qy div 2,x+7*qx,y+9*qy,v);
  setcolor(0);
  Rectangle(x+qx,y+7*qy+qy div 2,x+7*qx,y+9*qy);
  uttextxy(x+2*sx,y+8*qy,'H E L P');
  setusercharsize(textscale.Trp[3,1],textscale.Trp[3,2],
                  textscale.Trp[3,3],textscale.Trp[3,4]);
 End;
 {==============================================}
 Procedure PutScale(v:boolean;k:byte);
  Var i:byte;
      s:string[2];
  Begin
 If v
  Then
  Begin
     setusercharsize(textScale.Trp[2,1],textScale.Trp[2,2],
                     textScale.Trp[2,3],textScale.Trp[2,4]);
   setfillstyle(1,7);
   bar(x+4*sx,y+qy,x+10*sx,y+2*sy);
   setcolor(0);
   Rectangle(x+4*sx,y+qy,x+10*sx,y+2*sy);
   setfillpattern(pic,3);
   bar(x+9*qx,y+sy,x+19*Qx,y+3*qy);
   rectangle(x+9*qx,y+sy,x+19*qx,y+3*qy);
   For i:=1 to 10 do
    Begin
     str(i,s);
     uttextxy(x+(8+i)*qx+Qx div 2,y+qy+11*qy div 20,s);
    End;
    setfillPattern(pic2,6);
    Bar(x+(8+k)*qx+1,y+sy+1,x+(9+k)*qx-1,y+sy+qy-1);
    setcolor(8);
     uttextxy(x+14*qx,y+sy+qy+qy div 2,'D I M I N I S H');
      line(x+9*qx,y+sy+qy+qy div 2,x+11*qx,y+sy+qy+qy div 2);
      line(x+17*qx,y+sy+qy+qy div 2,x+18*qx,y+sy+qy+qy div 2);
      moveto(x+19*qx,y+sy+qy+qy div 2);
      setcolor(0);
      linerel(-qx,2*lity);
      linerel(0,-4*lity);
      linerel(qx,2*lity);
      setfillstyle(1,10);
      floodfill(x+18*qx+qx div 2,y+sy+qy+qy div 2,0);
 End
  Else
    Begin
     setfillpattern(pic,3);
     bar(x+9*qx+1,y+sy+1,x+19*Qx-1,y+3*qy-1);
     setfillPattern(pic2,6);
     Bar(x+(8+k)*qx+1,y+sy+1,x+(9+k)*qx-1,y+sy+qy-1);
     i:=scale;
     scale:=k;
    If BeginplaceCode Then field(xm,ym,xm+dmx,ym+dmy,i);
    End;
  End;
  {===============================================}
  Procedure putPblock;
  Begin
   setfillpattern(Pic4,10);
   Bar(x+4*sx,y+2*sy+qy div 2,x+10*sx,y+9*qy+qy div 2);
   setcolor(13);
   rectangle(x+4*sx,y+2*sy+qy div 2,x+10*sx,y+9*qy+qy div 2);
  End;
  {=============================================}
  Procedure PutBlock(cf:byte);
  Begin
    setfillstyle(1,cf);
    Bar(x+5*sx+qx,y+2*sy+qy div 2 +lity,
        x+8*sx+qx,y+5*qy+qy div 2+lity);
        setcolor(0);
    rectangle(x+5*sx+qx,y+2*sy+qy div 2 +lity,
        x+8*sx+qx,y+5*qy+qy div 2+lity);
    uttextxy(x+14*qx,y+5*qy,'B L O C K');
  End;
  {==============================================}
  procedure PutTurn(cf:byte);
   begin
    setfillstyle(1,cf);
    Bar(x+4*sx+qx div 2,y+5*Qy+qy div 2 +2*lity,
        x+13*qx+qx div 2,y+6*qy+qy div 2+2*lity);
        setcolor(0);
    rectangle(x+4*sx+qx div 2,y+5*Qy+qy div 2 +2*lity,
        x+13*qx+qx div 2,y+6*qy+qy div 2+2*lity);
    uttextxy(x+5*Sx+qx,y+6*qy+lity,'T U R N');
  End;
  {==============================================}
  procedure PutRead(cf:byte);
   begin
    setfillstyle(1,cf);
    Bar(x+7*sx+qx div 2,y+5*Qy+qy div 2 +2*lity,
        x+19*qx+qx div 2,y+6*qy+qy div 2+2*lity);
        setcolor(0);
    rectangle(x+7*sx+qx div 2,y+5*Qy+qy div 2 +2*lity,
        x+19*qx+qx div 2,y+6*qy+qy div 2+2*lity);
    uttextxy(x+16*Qx+qx,y+6*qy+lity,'R E A D');
  End;
  {==============================================}
  procedure PutWr(cf:byte);
   begin
    setfillstyle(1,cf);
    Bar(x+7*sx+qx div 2,y+6*Qy+qy div 2 +3*lity,
        x+19*qx+qx div 2,y+7*qy+qy div 2+3*lity);
        setcolor(0);
    rectangle(x+7*sx+qx div 2,y+6*Qy+qy div 2 +3*lity,
        x+19*qx+qx div 2,y+7*qy+qy div 2+3*lity);
    uttextxy(x+16*Qx+qx,y+7*qy+2*lity,'W R I T E');
  End;
  {==============================================}
  procedure PutRep(cf:byte);
   begin
    setfillstyle(1,cf);
    Bar(x+4*sx+qx div 2,y+6*Qy+qy div 2 +3*lity,
        x+13*qx+qx div 2,y+7*qy+qy div 2+3*lity);
        setcolor(0);
    rectangle(x+4*sx+qx div 2,y+6*Qy+qy div 2 +3*lity,
        x+13*qx+qx div 2,y+7*qy+qy div 2+3*lity);
    uttextxy(x+5*Sx+qx,y+7*qy+2*lity,'REPLACE');
  End;
  {==============================================}
  procedure PutCopy(cf:byte);
   begin
    setfillstyle(1,cf);
    Bar(x+4*sx+qx div 2,y+7*Qy+qy div 2 +4*lity,
        x+13*qx+qx div 2,y+8*qy+qy div 2+4*lity);
        setcolor(0);
    rectangle(x+4*sx+qx div 2,y+7*Qy+qy div 2 +4*lity,
        x+13*qx+qx div 2,y+8*qy+qy div 2+4*lity);
    uttextxy(x+5*Sx+qx,y+8*qy+3*lity,'C O P Y');
  End;
  {==============================================}
  procedure PutRes(cf:byte);
   begin
    setfillstyle(1,cf);
    Bar(x+7*sx+qx div 2,y+7*Qy+qy div 2 +4*lity,
        x+19*qx+qx div 2,y+8*qy+qy div 2+4*lity);
        setcolor(0);
    rectangle(x+7*sx+qx div 2,y+7*Qy+qy div 2 +4*lity,
        x+19*qx+qx div 2,y+8*qy+qy div 2+4*lity);
    uttextxy(x+16*Qx+qx,y+8*qy+3*lity,'RESTORE');
  End;
  {==============================================}
   Procedure PutWin(v,cf:byte;M:boolean);
    var i:byte; s:string[5];
   Begin
    settextstyle(triplexfont,0,1);
    setusercharsize(textscale.Trp[3,1],textscale.Trp[3,2],
                    textscale.Trp[3,3],textscale.Trp[3,4]);
    setfillstyle(1,cf);
    setcolor(0);
    case v of
   1: begin
       Bary(x+21*qx,y+qy,x+27*qx,y+3*qy+qy div 2,m);
       Rectangle(x+21*qx,y+qy,x+27*qx,y+3*qy+qy div 2);
       uttextxy(x+24*qx,y+qy+qy div 2,'S A V E');
       uttextxy(x+24*qx,y+sy+qy div 2,'DISPOSITION');
      End;
   2: begin
       Bary(x+21*qx,y+3*qy+qy div 2+lity,x+27*qx,y+3*sy+lity,m);
       Rectangle(x+21*qx,y+3*qy+qy div 2+lity,x+27*qx,y+3*sy+lity);
       uttextxy(x+24*qx,y+2*sy+lity,'L O A D');
       uttextxy(x+24*qx,y+5*qy+lity,'DISPOSITION');
      End;
   3: begin
       Bary(x+21*qx,y+3*sy+2*lity,x+27*qx,y+4*sy+qy div 2+2*lity,m);
       Rectangle(x+21*qx,y+3*sy+2*lity,x+27*qx,y+4*sy+qy div 2+2*lity);
       uttextxy(x+24*qx,y+3*sy+qy div 2+2*lity,'L O A D');
       uttextxy(x+24*qx,y+7*qy+qy div 2+2*lity,'CIRCUIT');
      End;
   4: begin
       Bary(x+21*qx,y+4*sy+qy div 2+3*lity,x+27*qx,y+10*qy+lity,m);
       Rectangle(x+21*qx,y+4*sy+qy div 2+3*lity,x+27*qx,y+10*qy+lity);
       uttextxy(x+24*qx,y+9*qy+3*lity,'Q U I T');
      End;
   5: begin
       Bary(x+27*qx+qx div 2,y+qy,x+28*qx+qx div 2,y+6*qy+lity,m);
       Rectangle(x+27*qx+qx div 2,y+qy,x+28*qx+qx div 2,y+6*qy+lity);
       s:='PLACE';
       for i:=1 to 5 do
       uttextxy(x+28*qx,y+qy div 2+i*qy,s[i]);
      End;
   6: begin
    Bary(x+27*qx+qx div 2,y+6*qy+2*lity,x+28*qx+qx div 2,y+10*qy+2*lity,m);
    Rectangle(x+27*qx+qx div 2,y+6*qy+2*lity,x+28*qx+qx div 2,y+10*qy+2*lity);
       s:='ROUT';
       for i:=1 to 4 do
       uttextxy(x+28*qx,y+5*qy+qy div 2+lity+i*qy,s[i]);
      End;
    End;
 End;
 {=================================================}
Begin
  If r Then
    Begin
    hide;
    vm:=true;
    restore(xm,ym,xm+dmx,ym+dmy+1,15);
    show;
    exit;
    End;
If x>lx-dmx-qx-OtsX-1 then x:=lx-dmx-qx-OtsX-2;
If x<FieldX then x:=FieldX;
If y>ly-dmy-qy-OtsY-2 then y:=ly-dmy-qy-OtsY-3;
if y<FieldY then y:=FieldY;
 Xm:=x;
 Ym:=y;
 If vm And Clear
   Then
    Begin
    Vm:=False;
     Hide;
     Inline($FA);
     setfillpattern(pic,15);
     Bar(x,y,x+dmx,y+dmy);
     setcolor(15);
     rectangle(x+1,y+2,x+dmx-1,y+dmy-2);
     rectangle(x+3,y+4,x+dmx-3,y+dmy-4);
     for i:=1 to 4 do
     putdubs(true,i,0,7,0,3);
     putstrl(true,sx,sy,1,x+qx,y+qy+sy,7,0,3,0);
     putstrl(true,sx,sy,2,x+5*qx,y+qy+sy,7,0,3,0);
     putstrl(true,sx,sy,4,x+3*qx,y+qy,7,0,3,0);
     putstrl(true,sx,sy,3,x+3*qx,y+5*qy,7,0,3,0);
      puttab(true,sx,sy,x+qx+sx,y+qy+sy,7,0,3,0);
     puthelp(7,true);
     putScale(true,Scale);
     for i:=1 to 6 do putwin(i,7,True);
   {  PutpBlock;
     putblock(7);
     Putturn(7);
     putread(7);
     putWr(7);
     putrep(7);
     putcopy(7);
     Putres(7); }
    Inline($FB);
     show;
    End;
     GetPos(i,j,k);
     If Keypressed Then c:=readkey;
     While KeyPressed Do c:=readkey;
   IF (k=left)And Not Vm
      Then
       Begin
       If (i>x+27*qx+qx div 2)and(j>y+qy)
        And (i<x+28*qx+qx div 2) and (j<y+6*qy+lity)
       then
         Begin
          hide;
          PutWin(5,10,False);
          delay(20);
          c:='P';
          PutWin(5,7,true);
          show;
         End
         Else
       If (i>x+27*qx+qx div 2)and(j>y+6*qy+2*lity)
        And (i<x+28*qx+qx div 2) and (j<y+10*qy+2*lity)
       then
         Begin
          hide;
          PutWin(6,10,False);
          delay(20);
          c:='R';
          PutWin(6,7,true);
          show;
         End
         Else
       If (i>x+21*qx)and(j>y+3*qy+qy div 2+lity)
        And (i<x+27*qx) and (j<y+3*sy+lity)
       then
         Begin
          hide;
          PutWin(2,10,False);
          show;
           Ext:='*.DSP';
           s:=chos;
           FlowerName:=s;
           If s<>'' Then
           ReadFile(2,s);
          If DiscResult<>0
           Then
            Begin
             BeginPlaceCode:=False;
             PlacingOver:=False;
             NoFile;
        ShowMessage('Error : ',DiscErrMsg[DiscResult]);
            End
           Else
            Begin
             radsize;
             BeginPlaceCode:=True;
             PlacingOver:=True;
             ClearDeskTop;
             WorkList;
             Field(xm,ym,xm+dmx,ym+dmy,scale);
            End;
          ShowMessage('','Interactive Mode...');
          hide;
          PutWin(2,7,true);
          show;
         End
         Else
       If (i>x+21*qx)and(j>y+qy)
        And (i<x+27*qx) and (j<y+3*qy+qy div 2)
       then
         Begin
          hide;
          PutWin(1,10,false);
          show;
           If PlacingOver
          Then
          Begin
           Ext:='*.DSP';
           s:=chos;
           If s<>'' Then WriteToFile(2,s); {Wr}
          End;
          hide;
          PutWin(1,7,true);
          show;
         End
         Else
       If (i>x+9*qx)and(j>y+sy)
        And (i<x+19*Qx) and (j<y+3*qy)
       then
         Begin
          hide;
          If Scale<>(i-x-9*qx)Div qx+1 Then
          PutScale(false,(i-x-9*qx) div qx+1);
          show;
         End
         Else
       If (i>x+21*qx)and(j>y+3*sy+2*lity)
        And (i<x+27*qx)and (j<y+4*sy+qy div 2+2*lity)
       then
         Begin
          hide;
          PutWin(3,10,false);
          show;
           Ext:='*.CIR';
           s:=chos;
           FlowerName:=s;
          If s<>'' then
              Begin
           ReadFile(1,s);
          If DiscResult<>0
           Then
            Begin
             BeginPlaceCode:=False;
             PlacingOver:=False;
             Field(xm,ym,xm+dmx,ym+dmy,scale);
             NoFile;
             ShowMessage('Error : ',DiscErrMsg[DiscResult]);
            End
           Else
            Begin
             radsize;
             BeginPlaceCode:=True;
             PlacingOver:=False;
             ClearDeskTop;
             WorkList;
             Field(xm,ym,xm+dmx,ym+dmy,scale);
            End;
              End;
          hide;
          PutWin(3,7,true);
          show;
         End
         Else
       If (i>x+21*qx)and(j>y+4*sy+qy div 2+3*lity)
        And (i<x+27*qx)and (j<y+10*qy+lity)
       then
         Begin
          hide;
          Putwin(4,10,false);
          delay(200);
          Putwin(4,7,true);
          show;
          c:='Q';
         End
         Else
       If (i>x+qx)and(j>y+7*qy+qy div 2)
        And (i<x+7*qx)and (j<y+9*qy)
       then
         Begin
          hide;
          PutHelp(10,False);
{          If GetBkColor<15 Then SetBkColor(GetBkColor+1)
                           Else SetBkColor(0);}
          delay(200);
          PutHelp(7,true);
          show;
         End
         Else
          If BeginPlaceCode Then
       If (i> x+qx)and(j>y+qy)
        And (i<x+qx+sx)and (j<y+qy+sy)
       then
         Begin
          hide;
          Putdubs(False,1,0,9,0,12);
          If (PageX-N-1<=0)and(pagex<>1) then  SetPage(-(pageX-1),0);
          If pageX-N-1>0 Then SetPage(-N-1,0);
          PutDubs(TRue,1,0,7,0,3);
          show;
         End
         Else
       If (i>x+qx)and(j>y+5*qy)
        And (i<x+qx+sx)and (j<y+7*qy)
       then
         Begin
          hide;
          Putdubs(False,2,0,9,0,12);
          If (PageX+N+1>=MaxPage-N+2)and(pageX<>MaxPage-N+2)and(maxpage>n)
           then  SetPage(Maxpage-2*N+4-pageX,0);
          If pageX+N+1<MaxPage-N+2 Then SetPage(N+1,0);
          PutDubs(True,2,0,7,0,3);
          show;
         End
         Else
       If (i>x+5*qx)and(j>y+qy)
        And (i<x+7*qx)and (j<y+qy+sy)
       then
         Begin
          hide;
          Putdubs(False,3,0,9,0,12);
          If (PageY-M-1<=0)and(pageY>1) then  SetPage(0,-(pagey-1));
          If pageY-M-1>0 Then SetPage(0,-M-1);
          PutDubs(True,3,0,7,0,3);
          show;
         End
         Else
       If (i>x+5*qx)and(j>y+5*qy)
        And (i<x+7*qx)and (j<y+7*qy)
       then
         Begin
          hide;
          Putdubs(False,4,0,9,0,12);
          If (PageY+M+1>=MaxPage-M+2)and(pageY<>MaxPage-M+2)and(maxpage>m)
           then  SetPage(0,maxpage-2*M+3-pageY);
          If pageY+M+1<MaxPage-M+2 Then SetPage(0,M+1);
          PutDubs(True,4,0,7,0,3);
          show;
         End
         Else
       If (i>x+qx)and(j>y+qy+sy)
        And (i<x+sx+qx)and (j<y+2*sy+qy)
          then
         Begin
          hide;
        putstrl(False,sx,sy,1,x+qx,y+qy+sy,10,0,11,0);
          If pageX-1>0 Then SetPage(-1,0);
        putstrl(True,sx,sy,1,x+qx,y+qy+sy,7,0,3,0);
          show;
         End
         Else
       If (i>x+5*qx)and(j>y+qy+sy)
        And (i<x+sx+5*qx)and (j<y+2*sy+qy)
       then
         Begin
          hide;
     putstrl(False,sx,sy,2,x+5*qx,y+qy+sy,10,0,11,0);
          If pageX<MaxPage-N+2 Then SetPage(1,0);
     putstrl(True,sx,sy,2,x+5*qx,y+qy+sy,7,0,3,0);
          show;
         End
         Else
       If (i>x+3*qx)and(j>y+qy)
        And (i<x+sx+3*qx)and (j<y+sy+qy)
       then
         Begin
          hide;
     putstrl(False,sx,sy,4,x+3*qx,y+qy,10,0,11,0);
          If PageY-1>0 Then SetPage(0,-1);
     putstrl(True,sx,sy,4,x+3*qx,y+qy,7,0,3,0);
          show;
         End
         Else
       If (i>x+3*qx)and(j>y+5*qy)
        And (i<x+sx+3*qx)and (j<y+sy+5*qy)
       then
         Begin
          hide;
     putstrl(False,sx,sy,3,x+3*qx,y+5*qy,10,0,11,0);
          If pageY<MaxPage-M+2 Then SetPage(0,1);
     putstrl(true,sx,sy,3,x+3*qx,y+5*qy,7,0,3,0);
          show;
         End
        Else
       If (i>x+qx+sx)and(j>y+qy+sy)
        And (i<x+2*sx+qx)and (j<y+2*sy+qy)
       then
         Begin
          hide;
     puttab(False,sx,sy,x+qx+sx,y+qy+sy,12,0,2,0);
          If PageX+PageY<>2 Then SetPage(-PageX+1,-PageY+1);
     puttab(True,sx,sy,x+qx+sx,y+qy+sy,7,0,3,0);
          show;
         End
         Else;
     End;
                             {if--------}
    If (((j>Uy+1-OtsY)And(j<Ly-OtsY)And(i>3*qx+5)And(i<Lx-OtsX))
    Or((i>Ux+1-OtsX)And(i<Lx-OtsX)And(j>qy)And(j<Ly-OtsY)))
      And BeginPlaceCode
    Then
    BEGIN
      If (i>3*qx+5)and(j>Uy-OtsY)
        And (i<4*qx+5)and (j<Ly-OtsY)
       then
         Begin
         StrlPort;
          hide;
        putstrl(false,qx,qy,1,3*qx+5,Uy-OtsY,10,0,11,1);
         WorkPort;
          If pageX-1>0 Then SetPage(-1,0);
          StrlPort;
        putstrl(True,qx,qy,1,3*qx+5,Uy-otsY,1,2,13,10);
          show;
          WorkPort;
         End
         Else
       If (i>ux-qx-OtsX)and(j>uy-OtsY)
        And (i<ux-OtsX)and (j<ly-OtsY)
       then
         Begin
          StrlPort;
          hide;
        putstrl(False,qx,qy,2,ux-Qx-1-OtsX,uy-otsY,10,0,11,0);
          WorkPort;
          If pageX<MaxPage-N+2 Then SetPage(1,0);
          StrlPort;
        putstrl(True,qx,qy,2,ux-Qx-1-OtsX,uy-otsY,1,2,13,10);
          show;
          WorkPort;
         End
         Else
       If (i>ux-OtsX)and(j>Qy)
        And (i<lx-OtsX)and (j<sy)
       then
         Begin
          StrlPort;
          hide;
        putstrl(False,Qx,Qy,4,ux-OtsX,Qy,10,0,11,0);
          WorkPort;
          If PageY-1>0 Then SetPage(0,-1);
          StrlPort;
        putstrl(true,Qx,Qy,4,ux-OtsX,Qy,1,2,13,10);
          show;
          WorkPort;
         End
         Else
       If (i>Ux-OtsX)and(j>Uy-qy-1-OtsY)
        And (i<Lx-OtsX)and (j<Uy-1-OtsY)
       then
         Begin
          StrlPort;
          hide;
        putstrl(False,qx,qy,3,ux-OtsX,Uy-Qy-1-otsY,10,0,11,0);
          WorkPort;
          If pageY<MaxPage-M+2 Then SetPage(0,1);
          StrlPort;
        putstrl(True,qx,qy,3,ux-OtsX,Uy-Qy-1-OtsY,1,2,13,10);
          show;
          WorkPort;
         End
         Else
       If (i>Ux-OtsX)and(j>Uy-OtsY)
        And (i<Lx-OtsX)and (j<Ly-OtsY)
        then
         Begin
          StrlPort;
          hide;
        Puttab(False,qx,qy,ux-OtsX,uy-OtsY,12,0,2,0);
          WorkPort;
          If PageX+PageY<>2 Then SetPage(-PageX+1,-PageY+1);
          StrlPort;
        Puttab(True,qx,qy,ux-OtsX,uy-OtsY,7,0,3,0);
          show;
          WorkPort;
         End
         Else
       If (i<StrlScorePos(1,PageX))and(j>Uy+1-OtsY)And(j<Ly-OtsY)
          And(i>4*Qx+6)
       then
         Begin
          If (PageX-N-1<=0)and(pagex<>1) then  SetPage(-(pageX-1),0);
          If pageX-N-1>0 Then SetPage(-N-1,0);
         End
         Else
       If (i>StrlScorePos(1,PageX)+Qx)and(j>Uy+1-OtsY)and(j<Ly-OtsY)
          And(i<Ux-Qx-1-OtsX)
       then
         Begin
          If (PageX+N+1>=MaxPage-N+2)and(pageX<>MaxPage-N+2)and(maxpage>n)
           then  SetPage(Maxpage-2*N+4-pageX,0);
          If pageX+N+1<MaxPage-N+2 Then SetPage(N+1,0);
         End
         Else
       If (i>Ux+1-OtsX)and(j<StrlScorePos(2,PageY))And (i<Lx-OtsX)
          And(j>Qy+1)
       then
         Begin
          If (PageY-M-1<=0)and(pageY>1) then  SetPage(0,-(pagey-1));
          If pageY-M-1>0 Then SetPage(0,-M-1);
         End
         Else
       If (i>Ux+1-OtsX)and(j>StrlScorePos(2,PageY)+Qy)
          And(i<Lx-OtsX)And(j<Uy-Qy-1)
       then
         Begin
          If (PageY+M+1>=MaxPage-M+2)and(pageY<>MaxPage-M+2)and(maxpage>m)
           then  SetPage(0,maxpage-2*M+3-pageY);
          If pageY+M+1<MaxPage-M+2 Then SetPage(0,M+1);
         End;
     END;
     If (j>0)and(j<qy)And(k=Left) Then Vmenu(0,i,#13);
End;
{---------------------------------------}
Procedure Vmenu(v:Byte;d:Integer;ch:char);
 Label 1,2;
Var mn:array[1..7] of string[12];
x,i,y,l,g,Qu:integer;
z,u,key:Word;
 {=====================}
Procedure OutOpt(x,y:integer;s:string);
begin
   setcolor(0);
   uttextxy(x,y-1,s);
   setcolor(12);
   uttextxy(x,y-1,s[1]);
End;
 {=======================}
Function FindNewPos(no:byte;l:Word):Word;
 Var i:byte;
     x:Word;
 Begin
   x:=l;
  for i:=1 to no-1 do
   Begin
    x:=x+textwidth(mn[i])+l;
   End;
   FindNewPos:=x;
 End;
{=====================================}
 Function OpenWindow(w:Byte;l:Word;Var v:Byte):Byte;
  Type
    WinType=Record
             k1,k2,l,Mind:Byte;
             sw:Array[1..10] Of string[29];
            End;
  Const
   DataArray:Array[1..6] Of WinType=
                               ((k1:3;k2:4;L:12;Mind:1;
                            Sw:('Initial Placement:',' Compact <Auto>',
                                ' Manual','Konstructive Placement:',
                                ' Min-Cut',' Aria-Specific',' Vertual',
                                '','','')),
                               (k1:7;k2:0;L:10;Mind:1;
                            Sw:('Router Methods:',' Boris <Auto>',
                                ' Alternate',' PolyLevels',
                                ' Heliatine',' Local',' Step Over',
                                '','','')),
                               (k1:8;k2:0;L:18;Mind:2;
                            Sw:('Memory Size:','Free Memory:',
                                'Current Drive:',
                                'Space on Drive:','Free on Drive:',
                                'Current File:',
                                'Size Of Current File:',
                                'Size Of Field:',
                                '','')),
                               (k1:7;k2:0;L:11;Mind:3;
                            Sw:('Colors Of:',' Main Menu',
                                ' Selector',' Flower Menu',
                                'BackGround:',' Field',
                                ' Menu',
                                '','','')),
                               (k1:7;k2:0;L:13;Mind:1;
                            Sw:('File''s Format:',
                                ' Plate Disigner',
                                ' P-Cad',
                                ' PSpice',
                                ' Or-Cad',
                                ' Micro-Cap III',
                                ' Micro-Logic II',
                                '','','')),
                               (k1:7;k2:0;L:10;Mind:0;
                            Sw:(' Paste Element',' View Element',
                                ' Get Parameters',
                                ' Simulations',
                                ' Inside Structure',
                                ' Masking',
                                ' Aplear Field',
                                '','','')));
  Var WindowRec:WinType;
      X,xt,yt,h,u,k:Word;Last,n:byte;i:Integer;Qw:Boolean;
  Label 1;
      {=2=======================}
   Procedure OutParam(x,y:Word;s:Pathstr);
    Begin
     setcolor(0);
     uttextxy(x,y,s);
     If pos(':',s)=0 Then Begin
                           setcolor(12);
                           uttextxy(x+textWidth(' '),y,s[2]);
                          End;
    End;
     {=2========================}
   Procedure OutInfo(x,y,i:Word);
    Var g:Word;
        s:string[20];
        nam:Namestr;extn:ExtStr;dir:Dirstr;
    Begin
     s:='';
     setcolor(0);
     Case i Of
     1: Begin
        Asm
         Int 12h
         mov G,AX
        End;
         str(g,s);
         s:=s+' kb';
        End;
     2: Begin
         str((MemAvail/1024):4:3,s);
         s:=s+' kb'
        End;
     3: Begin
         Getdir(0,s);
         s:=copy(s,1,1);
        End;
     4: Begin
         str((DiskSize(0)/1024):4:3,s);
         s:=s+' kb';
        End;
     5: Begin
         str((DiskFree(0)/1024):4:3,s);
         s:=s+' kb';
        End;
     6: Begin
        Fsplit(FlowerName,dir,nam,extn);
         s:=nam+extn;
        If not(BeginPlaceCode Or PlacingOver) Then s:='No File';
        End;
     7: Begin
        IF BeginPlaceCode Or PlacingOver Then
                                          Begin
                                           Assign(F,FlowerName);
                                           Reset(F);
                                          str((FileSize(F)/1024):4:3,s);
                                           Close(f);
                                          End
                                         Else s:='0';
          s:=s+' kb';
        End;
     8: Begin
         str(MaxPage,s);
         s:=s+' x '+s;
        End;
     End;
     uttextxy(x,y,s);
    End;
     {=2========================}
  Begin
  iF w=7 Then
       Begin
      Repeat
       GetPos(u,z,k);
       If Keypressed Then c:=readkey;
       While KeyPressed Do C:=readkey;
    If c=#75 Then Begin Dec(Param.CurrentOpt);c:='^';Exit End;
    If c=#77 Then Begin Param.CurrentOpt:=1;c:='^';Exit End
      Until (k=Left)Or(k=Right);
      Exit;
       End;
   If Not Vm Then Begin
                   Vm:=true;
                    hide;
                   Restore(xm,ym,xm+dmx,ym+dmy,15);
                    show;
                  End;
   setlittMode;
   c:='.';
    X:=FindNewPos(w,l);
    If w=1 Then X:=FieldX+1;
    If w=7 Then X:=ux-Otsx-15*qx;
   WindowRec:=DataArray[w];
   setfillstyle(1,7);
   Setcolor(0);
   With WindowRec Do
    Begin
    Hide;
    Last:=Param.Optset[w];
    n:=Last;
    Qw:=Pos(':',Sw[1])<>0;
    If Pos(':',Sw[Last])<>0 Then Inc(Last);
   Bar(X,FieldY,X+l*Qx,FieldY+(k1+k2)*Qy+2*qy div 3);
   setfillstyle(1,11);
If Mind<>2 Then Bar (x+qx,Last*qy+qy div 3+2,
   x+l*qx-qx,Last*qy+qy div 3+qy);
   Rectangle(X+qx div 3,FieldY+Qy div 3,
   X+l*Qx-qx div 3,FieldY+(k1+k2)*Qy+1+Qy div 3);
   Rectangle(X+Qx div 3,FieldY+Qy div 3,
   X+l*Qx-qx div 3,FieldY+(k1)*Qy+1+qy div 3);
   For i:=1 To k1+k2 Do
     OutParam(x+qx,i*qy+Qy Div 3+Qy Div 2+1,Sw[i]);
   If w=3 Then For i:=1 To k1+k2 Do
                OutInfo(x+(l-7)*qx,i*qy+Qy Div 3+Qy Div 2+1,i);
If Mind=1 Then
           Begin
     SetColor(0);
    uttextxy(x+L*qx-sx,Param.Sett[w]*qy+Qy Div 3+Qy Div 2+1,'*');
           End;
     Show;
     i:=0;
If Mind<>2 Then
 Repeat
      delay(50);
       GetPos(h,u,k);
       c:='.';
       if keypressed then c:=readkey;
       while keypressed do c:=readkey;
   if (c=#80)and(last+1<=k1+k2) then
           If Pos(':',Sw[Last+1])=0 Then n:=last+1 else n:=Last+2
        Else
   If (c=#80)And(last+1>k1+k2) Then If Qw Then n:=2
                                          Else n:=1
                               Else
   If (c=#72)And( ((Last-1<1)And Not Qw ) Or (Qw And(Last-1<2)) )
            Then n:=k1+k2
            Else
   if (c=#72)and(last-1>=1) then
           If Pos(':',Sw[Last-1])=0 Then n:=last-1 else
                       If Last-2>=1 Then n:=Last-2 else
                            Else
    If (h>x)and(h<x+l*qx)and
        (u>qy+qy div 3+3)and(u<FieldY+(k1+k2)*Qy+qy div 3)
      and(k=left) Then
                    Begin
                   n:=(u-qy-qy div 3-1) Div Qy+1;
                   If Pos(':',sw[n])<>0 Then  Begin N:=Last;Dec(i) End;
                    End
    Else
    If (c=#77)And(Param.CurrentOpt<7) Then
       Begin Inc(Param.CurrentOpt);c:='^';Goto 1;V:=1 End
    Else
    If c=#75 Then Begin
                   If (Param.CurrentOpt>1) Then Dec(Param.CurrentOpt)
                                           Else Param.CurrentOpt:=7;
                   c:='^';Goto 1;V:=1
                  End
    Else  Goto 1;
     If last<>n Then
      Begin
       Hide;
      setFillStyle(1,7);
      Bar (x+qx,Last*qy+qy div 3+2,
      x+l*qx-qx,Last*qy+qy div 3+qy);
      OutParam(x+qx,Last*qy+Qy Div 3+Qy Div 2+1,Sw[Last]);
If (Mind=1)And(Last=Param.Sett[w]) Then
           Begin
     SetColor(0);
    uttextxy(x+L*qx-sx,Param.Sett[w]*qy+Qy Div 3+Qy Div 2+1,'*');
           End;
      SetFillStyle(1,11);
      Bar (x+qx,n*qy+qy div 3+2,
      x+l*qx-qx,n*qy+qy div 3+qy);
      OutParam(x+qx,n*qy+Qy Div 3+Qy Div 2+1,Sw[n]);
If (Mind=1)And(n=Param.Sett[w]) Then
           Begin
     SetColor(0);
    uttextxy(x+L*qx-sx,Param.Sett[w]*qy+Qy Div 3+Qy Div 2+1,'*');
           End;
       Show;
      Last:=n;
      i:=0;
     End
      Else Begin Inc(i); Delay(50) End;
1:  Until (c=#13)Or(k=Right)Or(c='^')Or(i=2)Or((k=left)And
          Not((h>x)and(h<x+l*qx)and
        (u>qy+qy div 3+3)and(u<FieldY+(k1+k2)*Qy+qy div 3)))
Else Begin
     Repeat
      GetPos(h,u,k);
     Until (k<>0)Or keypressed;
     If KeyPressed then c:=readkey;
     While KeyPressed Do c:=readkey;
    If (c=#77)And(Param.CurrentOpt<7) Then
       Begin Inc(Param.CurrentOpt);c:='^' End
    Else
    If (c=#75)And(Param.CurrentOpt>1) Then
       Begin Dec(Param.CurrentOpt);c:='^' End;
       V:=1;
     End;
If (Mind=1)And((c=#13)Or(i=2))
        Then
           Begin
     SetColor(0);
    uttextxy(x+L*qx-sx,n*qy+Qy Div 3+Qy Div 2+1,'*');
     Param.Sett[w]:=n;
           End;
    hide;
   Restore(X,FieldY,X+l*Qx,FieldY+(k1+k2)*Qy+2*qy div 3,15);
    show;
   End;
   Param.Optset[w]:=n;
   If (c='^')Or(k=Right) Then OpenWindow:=0
                         Else OpenWindow:=n;
  End;
 {=======================}
Procedure Exiting;
Begin
 settextstyle(triplexfont,0,1);
 settextjustify(1,1);
 setusercharsize(textscale.Trp[3,1],textscale.Trp[3,2],
                 textscale.Trp[3,3],textscale.Trp[3,4]);
 DoneCaps_Lock;
 c:='.';
End;
 {======================}
Function RetriveNumber(x:Integer;Var no:integer):Boolean;
Begin
   g:=0;
    Repeat
     Inc(g);
     x:=FindnewPos(g,l);
     IF (d>=x)and(d<=x+textWidth(mn[g])) Then No:=g;
     If (g=7)And(No<>g) Then Begin RetriveNumber:=False;exit; End;
    Until No=g;
   RetriveNumber:=True;
End;
 {=====================}
 Procedure Res;
  Begin
   setfillstyle(1,7);
     Hide;
    bar(x-1,0,x+textwidth(mn[i])+1,Qy-1);
    outopt(x,Qy div 2,mn[i]);
     Show;
  End;
 {========================}

begin
mn[1]:='New Project';mn[2]:='Gistogram';mn[3]:='Information';
mn[4]:='Options'; mn[5]:='Format';mn[6]:='Databases';
mn[7]:='Edit';
   setlittmode;
   ActivisionCaps_Lock;
   l:=Lx div 20;
   If v=0 Then If Not RetriveNumber(d,d) Then Begin Exiting;Exit End;
2: g:=l;
   for i:=1 to d-1 do
   g:=g+textwidth(mn[i])+l;
   x:=l;
   Hide;
 If VMainMenu Then
    Begin
   setfillstyle(1,7);
     strlPort;
     bar(0,0,Lx,Qy-1);
     WorkPort;
      for i:=1 to 7 do
       Begin
        outopt(x,Qy div 2,mn[i]);
        x:=x+textwidth(mn[i])+l;
       End;
       VMainMenu:=False;
       Show;
       Exiting;
       Exit;
    End
     Else
      Begin
       setfillstyle(1,14);
       bar(g-1,0,g+textwidth(mn[d])+1,qy-1);
       OutOpt(FindNewPos(d,l),Qy Div 2,mn[d]);
      End;
   Show;
 x:=g;
 i:=d;
 if v<>0 then
repeat
   c:=ch;
    Delay(80);
   GetPos(z,u,key);
   If KeyPressed Then c:=readkey;
   g:=0;
   while keypressed do c:=readkey;
     If Key=Right Then
      Begin Res;Exiting;Param.CurrentOpt:=i;Delay(80);exit end;
     If Key=Left Then Begin Res;Exiting;Exit end;
     if c=#77 then If i+1>7 Then Begin g:=-i+1;d:=-x+l End
                            Else Begin g:=1;d:=l+textwidth(mn[i]) end
else if c=#75 then If i-1<1 Then Begin g:=-i+7;d:=-x+FindNewPos(7,l) End
                            Else Begin g:=-1;d:=-l-textwidth(mn[i-1]) end
   else d:=0;
   i:=i+g;
  if (i>=1)and(i<=7)and(d<>0) then
  begin
   x:=x+d;
     setfillstyle(1,7);
     Hide;
    bar(x-d-1,0,x-d+textwidth(mn[i-g])+1,Qy-1);
    outopt(x-d,Qy div 2,mn[i-g]);
    setfillstyle(1,14);
    bar(x-1,0,x+textwidth(mn[i])+1,Qy-1);
    outopt(x,Qy div 2,mn[i]);
     Show;
  end
  else if d<>0 then i:=i-g;
until c=#13;
 c:='.';
   Param.CurrentOpt:=i;
   If OpenWindow(i,l,v)=1 then;
    If c='^' Then Begin setlittmode;Res;d:=param.currentopt;ch:=#13;
                  Goto 2 End;
    SetLittMode;
    Res;
    Exiting;
{vmenu:=mn[i][1];}
End;
{-------------------------------------------}
Procedure PutEditValue(v,cf:Byte);
 Var s:string;
 Begin
{   SetFillStyle(1,cf);}
setcolor(0);
  Case v Of
   1: s:='1.gek';
   2: s:='2.gek';
   3: s:='3.gek';
   4: s:='4.gek';
   5: s:='5.gek';
   6: s:='6.gek';
   7: s:='7.gek';
   8: s:='8.Gek';
   End;
Rectangle(3,FieldY+(v-1)*3*Qy-v+1,3+3*qx,FieldY+v*3*Qy-v+1);
GekLoad(s,4,FieldY+(v-1)*3*Qy-v+2,3*Qx-2,3*Qy-2,1);
End;
{--------------------------------------------}
Procedure PutEdit;
 var i:Byte;
 Begin
  SetFillStyle(1,7);
  strlport;
   Bar(0,qy,3*qx+4,Lx);
   SetfillStyle(1,0);
{   Bar(3,FieldY,3+3*qx,FieldY+24*qy-8+1);}
 For i:=1 to 8 do
 PutEditValue(i,7);
  WorkPort;
 End;
{-------------------------------}
procedure spfil(Var s,ext:pathstr);
Label 1,2;
var dirinfo:SearchRec;
    Sm:pathstr;
    i,j,k,m:word;
begin
1:
 If (pos(':',s)<>0)Or(pos('\',s)<>0) then
Begin
  If pos(':',s)<>0 Then sm:=copy(s,1,pos(':',s))
                   Else sm:='';
 While pos('\',s)<>0 do
 Begin
  s:=copy(s,pos('\',s)+1,length(s)-pos('\',s));
  If Pos('\',s)<>0 then
  sm:=sm+'\'+copy(s,1,pos('\',s)-1);
 End;
 If pos(':',sm)=length(sm) Then Sm:=sm+'\';
 {$I-}
 ChDir(sm);
 {$I+}
 If IOResult <>0 Then
                  Begin
                   S:=ext;
                   sm:=fullmask;
                   ChDir(sm);
                   Goto 1;
                  End;
End;
If (Pos('.',s)>1)and(length(s)>pos('.',s))
   And(length(s)<=12)
Then Ext:=copy(s,1,Length(s));

     findfirst('*.*',anyfile,dirinfo);
     if DosError<>0 then begin QuanFiles:=0;exit end;
     i:=0;m:=0;
     while DosError=0 do
      begin
       If (DirInfo.Attr=Directory)And(DirInfo.Name<>'.')
        Then Begin Inc(i);Stp[i]:=DirInfo.Name+'\';End;
       findnext(dirinfo)
      end;
findfirst(ext,anyfile,dirinfo);
if DosError<>0 then Goto 2;
while DosError=0 do
 begin
    If Not(DirInfo.Attr=Directory)
     Then
      Begin
       Inc(i);
       Stp[i]:=DirInfo.Name;
      End;
    findnext(dirinfo)
 end;
2: GetDir(0,sm);
   FullMask:=sm;
   QuanFiles:=i;
end;{the end of spfil}
{----------------------------------------------------------}
Function chos:PathStr;
Label 1,2,3,4;
Var n,l,k,qls,lu,i,j,Qs,dx,myy,y,xl,yl:word;
   Tur,tdr:integer;
   xt,yt:integer;
   sm,st:pathstr;
   Ch:char;
   CaseOff,PgMoveMode,ds:boolean;

  Procedure readPasW(x1,y1:word;c,ch:char);
  Var s:string[33];
      sc:string[1];
      v:boolean;
      k,i:byte;
   Begin
   settextjustify(0,1);
    setfillpattern(pic3,9);
    s:=st;
    k:=length(s);
    If c in ['A'..'Z','a'..'z','0'..'9','_','.','*','!','$','?',':','\']
    then s:='';
    v:=False;
     clb;
     k:=length(s);
    Repeat
     If v then c:=Fullkey(ch,1);
     if c in
      [#7,#8,' ','A'..'Z','a'..'z','0'..'9','_','.','*','!','$','?',':','\']
      Then
       Begin
       If c=ch
       Then
        Begin
       sc:=UpCase(c);
        If c=#8 then
                 Begin
                  delete(s,k,1);
                  If k>0 then Dec(k);
                 End
                else
                 Begin
                  Insert(sc,s,k+1);
                  Inc(k);
                 End;
        End
       Else
        If (c=#75)and(k>0) Then dec(k)
        else If (c=#77)and(k<length(s)) then Inc(k)
        else If c=#79 then k:=length(s)
        Else If c=#71 then k:=0
        Else
           If c=#83 Then Delete(s,k+1,1);
        hide;
       Bar(xm+dx,y+lity,xm+3*dx,y+qy+lity);
       moveto(x1+textwidth(copy(s,1,k))-1,y1);
       SetColor(12);
       uttext(#219);
       moveto(x1,y1);
       SetColor(15);
       uttext(s);
       show;
       End;
       v:=true;
    Until c=#13;
    st:=s;
    If (Pos('.',st)=0)And(st[length(st)]<>'\')  then
       St:=st+Copy(ext,2,length(ext)-1);
     hide;
     settextjustify(1,1);
     Restore(xm,y,xm+dmx,myy,15);
     show;
    End;
   {================}
   Procedure PutMode(v,cr,cf,cs:byte);
    Begin
    setcolor(cr);
    setfillstyle(1,cf);
    Case v Of
   1: Begin
     Bar(xm+dmx div 2,myy-qy+1,xm+3*qx+dmx div 2,myy-1);
     Rectangle(xm+dmx div 2,myy-qy+1,xm+3*qx+dmx div 2,myy-1);
     Setcolor(cs);
     uttextxy(xm+dmx div 2+3*qx div 2,myy-qy div 2-lity,'PgDn');
      End;
   2: Begin
     Bar(xm+dmx div 2+3*qx+1,myy-qy+1,xm+6*qx+dmx div 2+1,myy-1);
     Rectangle(xm+dmx div 2+3*qx+1,myy-qy+1,xm+6*qx+dmx div 2+1,myy-1);
     Setcolor(cs);
     uttextxy(xm+dmx div 2+3*qx+3*qx div 2,myy-qy div 2-lity,'PgUp');
      End;
   3: Begin
     Bar(xm+dmx div 2+6*qx+2,myy-qy+1,xm+9*qx+dmx div 2+2,myy-1);
     Rectangle(xm+dmx div 2+6*qx+2,myy-qy+1,xm+9*qx+dmx div 2+2,myy-1);
     Setcolor(cs);
     uttextxy(xm+dmx div 2+6*qx+3*qx div 2,myy-qy div 2-lity,'Home');
      End;
   4: Begin
     Bar(xm+dmx div 2+9*qx+3,myy-qy+1,xm+12*qx+dmx div 2+3,myy-1);
     Rectangle(xm+dmx div 2+9*qx+3,myy-qy+1,xm+12*qx+dmx div 2+3,myy-1);
     Setcolor(cs);
     uttextxy(xm+dmx div 2+9*qx+3*qx div 2,myy-qy div 2-lity,'End');
      End;
    End;
      setcolor(15);
   End;
   {===============}
begin
   ActivisionCaps_Lock;
   showMessage('','Please Write Or Select File Name.');
   settextstyle(SmallFont,0,5);
   CaseOff:=true;
    St:=ext;
2:  spfil(st,ext);
   setusercharsize(TextScale.Sml[1],TextScale.Sml[2],
                   TextScale.Sml[3],TextScale.Sml[4]);
   If QuanFiles>12 then PgMoveMode:=True
                   else PgMoveMode:=false;
   If PgMoveMode Then Qls:=6
                 Else
                  Begin
                   Qls:=QuanFiles Div 4+3;
                   If Quanfiles Mod 4<>0 Then Inc(qls);
                  End;
  If ly-ym-dmy-qy<qy*6
     then myy:=ym
     else myy:=1;
     If Not PgMoveMode then
                Begin
                 If myy=ym then y:=myy-qy*qls
                 else Begin y:=ym+dmy;myy:=y+qy*qls end;
                 Tdr:=QuanFiles;
                End
              else
               Begin
                If myy=ym then y:=myy-6*qy
                else begin y:=ym+dmy;myy:=y+qy*6 end;
                Tdr:=12;
               End;
      Tur:=1;
   dx:=dmx div 4;
   setfillstyle(1,1);
   setcolor(15);
   hide;
   bar(xm,y,xm+dmx,myy);
   setfillpattern(pic3,9);
   Bar(xm+dx,y+lity,xm+3*dx,y+qy+lity);
   setfillstyle(1,13);
   uttextxy(xm+dx div 2,y+qy div 2,'Name:');
   Bar(xm+dx,y+Lity,xm+dx+textwidth(st),y+qy+lity);
   uttextxy(xm+dx+textwidth(st)div 2,y+qy div 2,st);
   uttextxy(xm+dx div 2,y+qy+qy div 2-lity,'Files :');
   If PgMoveMode then
   For i:=1 to 4 do
    PutMode(i,14,3,0);
    Settextjustify(0,1);
    uttextxy(xm+qx,myy-qy div 2-lity,FullMask);
    Settextjustify(1,1);
   line(xm,y+sy,xm+dmx,y+sy);
   line(xm,myy-qy,xm+dmx,myy-qy);
   show;
4: Hide;
   for i:=1 to 3 do line(xm+dx*i,y+sy,xm+dx*i,myy-qy);
   xt:=xm-dx div 2;
   yt:=y+sy+qy div 2;
   for l:=1 to Tdr-Tur+1 do
   begin
     if ((l-1) mod 4=0)and ((l-1) mod 12<>0) then
      begin inc(yt,qy);xt:=xm-dx div 2 end;
      inc(xt,dx);
      uttextxy(xt,yt-lity,stp[l+tur-1]);
   end;
   Lu:=tur;
   show;
   C:='@';
 If CaseOff Then
 Begin
  Repeat
   c:=Fullkey(ch,0);
   GetPos(i,j,k);
   If k=Right then Begin Chos:='';goto 3 End;
  Until ((k=left)and(i>xm)and(i<xm+dmx)and(j>y+sy)and(J<myy-qy))
        Or (c<>'@');
   if ((c<>#13) and (c<>'@'))or(QuanFiles=0)
    Then
     Begin
      ReadPasW(xm+dx+2,y+qy div 2,c,ch);
      If (Pos('.',st)>1)and(length(st)>pos('.',st)+1)
         And(pos('*',st)=0)
       Then
        Begin
         chos:=st;
         hide;
         Restore(xm,y,xm+dmx,myy,15);
         show;
         DoneCaps_Lock;
         Exit
        End;

      Goto 2;
     End;
 End;
     c:='L';
     l:=1;
     n:=l;
   xt:=xm-dx div 2+dx*(n mod 4);
   yt:=y+qy+qy div 2+qy*((n-1) div 4+1);
   xl:=xt;
   yl:=yt;
   hide;
      setfillstyle(1,10);
       Bar(xt-6*textwidth('_'),yt-qy div 2+1,
           xt+6*textwidth('_'),yt+qy div 2);
           setcolor(12);
      uttextxy(xt,yt-lity,stp[Tur-1+n]);
     setcolor(15);
   setfillpattern(pic3,9);
   Bar(xm+dx,y+lity,xm+3*dx,y+qy+lity);
   if pos('\',stp[n+tur-1])<>0 then st:=stp[n+tur-1]+ext
                               else st:=stp[n+tur-1];
   uttextxy(xm+dx+textwidth(st)div 2,y+qy div 2,st);
   show;
   ds:=false;
   CaseOff:=false;
 while c<>#13 do
  begin
      delay(50);
     GetPos(i,k,Qs);
   if keypressed then c:=readkey;
   while keypressed do c:=readkey;
   if (c=#77)and(xt+dx<xm+dmx)and(l+1<=Tdr-tur+1) then
    Begin n:=l+1;inc(xt,dx) end else
   if (c=#75)and(xt-dx>xm)and(l-1>=1) then
    begin n:=l-1;dec(xt,dx) end else
   if (c=#80)and(yt+sy<myy)and(l+4<=tdr-tur+1) then
    begin n:=l+4;inc(yt,qy) end else
   if (c=#72)and(yt-qy>y+sy)and(l-4>=1) then
    begin n:=l-4;dec(yt,qy) end else
   If (i>xm)and(i<xm+dmx)and(k>y+sy)and(k+qy<myy)and(qs=left)
      and(Tdr>=((k-y-sy)div qy)*4+(i-xm)div dx+1)
    Then
     Begin
     Xt:=xm+dx*((i-xm)div dx+1)-dx div 2;
     Yt:=y+sy+qy*((k-y-sy)div qy+1)-qy div 2-1;
     n:=((k-y-sy)div qy)*4+(i-xm)div dx+1;
     GetPos(i,k,j);
     If (j=qs)and ds and (l=n) then c:=#13
     else If (j=qs)and(l=n) then ds:=true
                            else ds:=false;
     End
    Else
     If ((i>xm+dx)and(k>y+lity)and(i<xm+3*dx)and(k<y+qy+lity)
       and(qs=left))Or(c=#9) Then
                    Begin
                     CaseOff:=True;
                      hide;
                      st:=fullMask+'\'+ext;
                      Restore(xm,y,xm+dmx,myy,15);
                      show;
                     Goto 2;
                    End
    Else
    If (((i>xm+dmx div 2)and(k>myy-qy+1)and(i<xm+3*qx+dmx div 2)and(k<myy-1)
       and(qs=left))Or(c=#81)) And PgMoveMode and(lu<>QuanFiles-11)
     Then
      Begin
      hide;
      PutMode(1,7,12,15);
      Delay(200);
      If tur+11<QuanFiles then
       Begin
        If Tdr+12<QuanFiles Then Inc(tdr,12)
                            Else Tdr:=quanfiles;
       Tur:=tdr-11;
       End;
      PutMode(1,14,3,0);
      setfillstyle(1,1);
      Bar(xm,y+sy+1,xm+Dmx,y+(qls-1)*qy-1);
      show;
      Goto 4;
      End
    Else
    If (((i>xm+dmx div 2+3*qx+1)
    and(k>myy-qy+1)and(i<xm+6*qx+dmx div 2+1)and(k<myy-1)and(qs=left))
      Or(c=#73))
       And PgMoveMode and(lu<>1)
     Then
      Begin
      Hide;
      PutMode(2,7,12,15);
      Delay(50);
      If tur-12>=1 then
       Begin
        Dec(Tur,12);
        dec(tdr,12)
       End
                  Else
       Begin
        Tur:=1;
        Tdr:=12;
       End;
      PutMode(2,14,3,0);
      setfillstyle(1,1);
      Bar(xm,y+sy+1,xm+Dmx,y+(qls-1)*qy-1);
      show;
      Goto 4;
      End
    Else
    If (((i>xm+dmx div 2+6*qx+2)and(k>myy-qy+1)
    and(i<xm+9*qx+dmx div 2+2)and(k<myy-1)and(qs=left))
       Or(c=#71))
       And PgMoveMode and (lu<>1)
     Then
      Begin
      Hide;
      PutMode(3,7,12,15);
      Delay(50);
      Tur:=1;
      Tdr:=12;
      PutMode(3,14,3,0);
      setfillstyle(1,1);
      Bar(xm,y+sy+1,xm+Dmx,y+(qls-1)*qy-1);
      show;
      Goto 4;
      End
    Else
    If (((i>xm+dmx div 2+9*qx+3)and(k>myy-qy+1)
    and(i<xm+12*qx+dmx div 2+3)and(k<myy-1)and(qs=left))
      Or(c=#79))
       And PgMoveMode And(lu<>QuanFiles-11)
     Then
      Begin
      Hide;
      PutMode(4,7,12,15);
      Delay(100);
      Tur:=QuanFiles-11;
      Tdr:=QuanFiles;
      PutMode(4,14,3,0);
      setfillstyle(1,1);
      Bar(xm,y+sy+1,xm+Dmx,y+(qls-1)*qy-1);
      show;
      Goto 4;
      End
    Else
     Begin
           Getpos(i,j,qs);
      If qs=Right then
                   Begin
                   delay(80);
                    chos:='';
                    goto 3;
                   End

      else goto 1;
     end;
   hide;
       setfillstyle(1,1);
       Bar(xl-6*textwidth('_') ,yl-qy div 2+1,
           xl+6*textwidth('_') ,yl+qy div 2{-1});
           setcolor(15);
   setfillpattern(pic3,9);
   Bar(xm+dx,y+lity,xm+3*dx,y+qy+lity);
   If pos('\',stp[tur+n-1])<>0 then st:=stp[tur+n-1]+ext
                               else st:=stp[tur+n-1];
   uttextxy(xm+dx+textwidth(st)div 2,y+qy div 2,st);
      uttextxy(xl,yl-lity,stp[tur+l-1]);
      setfillstyle(1,10);
       Bar(xt-6*textwidth('_') ,yt-qy div 2+1,
           xt+6*textwidth('_') ,yt+qy div 2);
           setcolor(12);
      uttextxy(xt,yt-lity,stp[Tur+n-1]);
   show;
      xl:=xt;
      yl:=yt;
      i:=0;
      k:=0;
      l:=n;
      If c<>#13 then c:=';';
1: end;
  st:=stp[n+tur-1];
  sm:=fullmask;
  If Pos('\',st)<>0 then
    Begin
        If pos('..\',st)<>0 then
        Begin
          SM:=copy(sm,1,length(sm)-1);
          st:=copy(sm,1,pos('\',sm)-1);
         While pos('\',sm)<>0 do
         Begin
          sm:=copy(sm,pos('\',sm)+1,length(sm)-pos('\',sm));
          If Pos('\',sm)<>0 then
          st:=st+'\'+copy(sm,1,pos('\',sm)-1);
         End;
        End
                          else
         Begin
         If Pos(':\',sm)<>Length(sm)-1 Then sm:=sm+'\';
         St:=sm+copy(st,1,pos('\',st)-1);
         End;
     st:=st+'\'+ext;
     hide;
     Restore(xm,y,xm+dmx,myy,15);
     show;
    Goto 2;
    End;
  chos:=sm+'\'+st;
3: hide;
 settextstyle(triplexfont,0,1);
 Restore(xm,y,xm+dmx,myy,15);
 setusercharsize(textscale.Trp[3,1],textscale.Trp[3,2],
                 textscale.Trp[3,3],textscale.Trp[3,4]);
 show;
 DoneCaps_Lock;
   showMessage('','Interactive Mode...');
end;{the end of chos}
{--------------------------------------------}
Function NumberL(c:char):Byte;
 Begin
  Case c Of
  'L','l':NumberL:=1;
  'R','r':NumberL:=2;
  'I','i':NumberL:=3;
  'O','o':NumberL:=4;
  'F','f':NumberL:=5;
  'D','d':NumberL:=6;
  'E','e':NumberL:=7;
   ' ':NumberL:=Param.CurrentOpt;
  else numberL:=1;
  End;
 End;
{----------------------------------------------}
END.