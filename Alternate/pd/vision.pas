{$O+}
{$F+}
  Unit Vision;
 Interface
  Uses Dos,Crt,Graph,Disc,Memory,Control;
 Const
      Pic:fillPatterntype=
           ($55,$AA,$55,$AA,$55,$AA,$55,$AA);
      Pic1:fillpatterntype=
           ($55,$55,$55,$55,$55,$55,$55,$55);
      Pic2:Fillpatterntype=
           ($49,$55,$49,$55,$49,$55,$49,$55);
      Pic3:fillpatterntype=
           ($49,$92,$49,$92,$49,$92,$49,$92);
      Pic4:fillpatternType=
           ($24,$24,$db,$24,$23,$bd,$24,$24);
  Var
   Xm,Ym,Dmx,Dmy,Lx,Ly,Ux,Uy,
   Qx,Qy,Sx,Sy,N,M,
   LitY,X,Y,MaxPlateX,MaxPlateY,
             MaxPage,
             PageX,PageY,
             LenX,LenY,
               Dx,Dy     :Integer;
               QuanFiles,
               FieldX,
               FieldY,
               OtsX,OtsY,
               Scale     :Byte;
               SizeOfPl,SizeOfRad:Word;
             ScreenIsDust,
             BeginPlaceCode,
             PlacingOver,
                Vm,VMainMenu     :Boolean;
                C,ch     :Char;
            FlowerMessage,FullMask,Ext :Pathstr;
      Param:Record
             CurrentOpt:Byte;
             OptSet:Array[1..7]Of Byte;
             Sett:Array[1..7]Of Byte;
            End;
   Const
                   Tripl:Array[1..3,1..3,1..4] Of Byte
                      =(((10,14,10,25),
                         (1,3,10,47),
                         (1,2,10,40)),
                        ((10,14,10,14),
                         (1,3,1,3),
                         (1,2,1,2)),
                        ((10,14,10,13),
                         (1,3,10,25),
                         (1,2,10,18)));
                     Littl:Array[1..3,1..4] Of Byte
                          =((12,10,10,12),
                            (12,10,12,10),
                            (12,10,12,8));
   Var
        STP  :Array[1..100] Of LikeName;
  TextScale:Record
        Trp:Array[1..3,1..4] Of Byte;
        Sml:Array[1..4] Of Byte;
      End;
{==========================================}
 Procedure InitVision;
 Procedure DoneVision;
 Procedure Restore(xv,yv,xv1,yv1,cp:word);
 Procedure putstrl(M:boolean;sx,sy,v,x,y,cs,cg,cf,cr:word);
 Procedure PutTab(M:boolean;sx,sy,x,y,cf,cr,clf,cl:word);
 Procedure Field(x,y,xm,ym,OldScale:word);
 Procedure Bary(x,y,xm,ym:Word;Mode:Boolean);
 Procedure SetlittMode;
 Procedure SetPage(dx,dy:integer);
 Procedure PutToScreen(cf,cb:byte;ne:word);
 Procedure RadSize;
 Function StrlScorePos(v:byte;Npq:Word):Word;
 Procedure FindXY(Ne:word;Var x1,y1:Word);
 Procedure PutStrlScore(M:Boolean;Npx,Npy:Word);
 Procedure StrlPort;
 Procedure WorkPort;
 Procedure WorkList;
 Procedure ClearDeskTop;
 Procedure PutOts;
 Procedure NoFile;
 Function Way(qs,qc,cr,cf,ct,cpf,cpt:byte;text:string):boolean;
 Procedure ShowMessage(ErrS,s:Pathstr);
 Procedure UtTextXY(x,y:Word;text:string);
 Procedure UtText(text:string);
{==========================================}
Implementation
{==========================================}
 Procedure InitVision;
  Var Gd,Gm:integer;
      I:word;
  Begin
    Gd:=detect;
         initgraph (Gd,Gm,'');
     Gd:=graphresult;
     if Gd<>grok then
    begin
     textcolor(4);
     writeln (grapherrormsg(Gd));
     Halt
    end;
    InitMouse(i);
    With PlaceCur Do
    SetGraphMouse(OfsX,OfsY,CurForm);
     DetectGraph(Gd,Gm);
    If (Gd=Ega)Or(Gd=Ega64)
        Or(Gd=IBM8514)Or(Gd=Vga)
        Then
   Case GetGraphMode Of
     0: i:=1;
     1: i:=2;
     2: i:=3;
     Else Halt;
   End
       Else
        Begin
          CloseGraph;
          Window(1,20,37,25);
          textcolor(14);
          TextBackGround(4);
          clrscr;
          Writeln;
        Writeln (' Demanding to Hardware:');
        Writeln ('   EGA,VGA or SpVGA monitor');
        Writeln ('   5 M Bytes Free space on Hard Disk');
        Writeln ('   1 M Bytes Main Memory');
            Delay(1000);
             Halt;
        end;
             For gd:=1 to 4 do
              Begin
               TextScale.Sml[gd]:=Littl[i,gd];
               For gm:=1 to 3 do
               TextScale.Trp[gm,gd]:=Tripl[i,gm,gd];
              End;
    Ext:='*.*';
    Lx:=GetMaxX;
    Ly:=GetmaxY;
    If i<>1 Then litY:=Ly div 170
            Else LitY:=0;
    Ux:=Lx-lx div 38-1;
    Uy:=Ly-Ly Div 25;
    ScreenIsDust:=false;
    BeginPlaceCode:=False;
    PlacingOver:=false;
    Vm:=True;
    VMainMenu:=True;
    ShowMode:=False;
    Scale:=4;
    With Param Do
     Begin
    CurrentOpt:=1;
    For i:=1 to 5 Do OptSet[i]:=2;
      OptSet[6]:=1;OptSet[7]:=1;
    Sett[1]:=2;Sett[2]:=2;Sett[3]:=0;
    Sett[4]:=0;Sett[5]:=2;Sett[6]:=0;Sett[7]:=0;
     End;
        cleardevice;
       sx:=2*(lx-ux);
       sy:=2*(ly-uy);
       qx:=sx div 2;
       qy:=sy div 2;
        SetPos(8*qx,5*Qy);
       FieldX:=3*qx+5;
       FieldY:=Qy+1;
      FlowDX:=Qx div 2;
      FlowDy:=Qy div 2;
       Dmx:=15*sx;
       Dmy:=11*qy;
    OtsX:=Qx Div 3;
    OtsY:=Qy div 3+qy;
       PutOts;
       NoFile;
 FlowerMessage:='Restore Configuration File...';
     ShowMessage('',FlowerMessage);
     ShowMessage('','Interactive Mode...');
     SetXLimit(9,Lx-9);
     SetYLimit(9,Ly-9);
        Settextstyle(Triplexfont,0,1);
        settextjustify(1,1);
  End;
{-------------------------------------}
 Procedure DoneVision;
 Begin
  closeGraph;
  DoneCaps_Lock;
 End;
{------------------------------------}
Procedure SetlittMode;
 Begin
   settextstyle(SmallFont,0,5);
   settextjustify(0,1);
   setusercharsize(TextScale.Sml[1],TextScale.Sml[2],
                   TextScale.Sml[3],TextScale.Sml[4]);
 End;
{-------------------------------------}
 Procedure WorkList;
 Begin
    Hide;
        PageX:=2;PageY:=2;
        PutStrlScore(true,1,1);
        PageX:=1;PageY:=1;
        StrlPort;
        putstrl(true,qx,qy,1,3*qx+5,Uy-OtsY,1,2,13,10);
        putstrl(true,qx,qy,2,ux-Qx-OtsX-1,uy-OtsY,1,2,13,10);
        putstrl(true,qx,qy,3,ux-OtsX,Uy-Qy-OtsY-1,1,2,13,10);
        putstrl(true,Qx,Qy,4,ux-OtsX,Qy,1,2,13,10);
        Puttab(true,qx,qy,ux-OtsX,uy-OtsY,7,0,3,0);
        WorkPort;
   Show;
End;
{------------------------------}
Procedure PutOts;
Begin
       setfillstyle(1,7);
       Bar(3*qx+5,ly-otsY,lx,ly);
       Bar(lx-OtsX,qy,lx,ly-otsy);
       SetColor(0);
       Rectangle(3*qx+5,ly-otsY+1,lx-Otsx,ly-Otsy+qy+1);
End;
{------------------------------}
Procedure NoFile;
Begin
Hide;
 SetFillPattern(Pic,7);
 strlport;
 If Vm Then Bar(FieldX,Qy,Lx-OtsX,ly-OtsY)
       Else
        Begin
         Bar(FieldX,QY,Lx-OtsX,ym);
         Bar(FieldX,ym,xm,Ly-OtsY);
         Bar(xm+dmx,ym,Lx-OtsX,Ly-OtsY);
         Bar(xm,ym+dmy,xm+dmx,Ly-OtsY);
        End;
 WorkPort;
Show;
End;
{-----------------------------}
Procedure ClearDeskTop;
Begin
Hide;
 SetViewPort(FieldX,Qy,lx-OtsX,ym,true);
 clearViewPort;
 SetViewPort(FieldX,ym,xm,ly-OtsY,true);
 clearViewPort;
 SetViewPort(xm+dmx,ym,lx-OtsX,Ly-OtsY,true);
 clearViewPort;
 SetViewPort(xm,ym+dmy,xm+dmx,Ly-OtsY,true);
 clearViewPort;
 WorkPort;
Show;
End;
{-------------------------------------}
Procedure DoneStrl;
Begin
 strlport;
 setfillpattern(pic,7);
 Bar(3*qx+5,uy,lx,ly);
 Bar(Ux,0,lx,Uy);
 workPort;
 DoneCaps_Lock;
End;
{-------------------------------------}
 Procedure Bary(x,y,xm,ym:Word;Mode:Boolean);
 Var i,u,d,Q:Byte;
 Begin
 If Mode Then Begin U:=15;D:=8 End
         Else Begin U:=8;D:=15 End;
{  If ym-y>Qy Then Q:=2;}
q:=2;
  Bar(x,y,xm,ym);
  For i:=1 to Q do
  Begin
  Setcolor(U);
  Line(x+i-1,y+i-1,xm-i+1,y+i-1);
  Line(x+i-1,y+i-1,x+i-1,ym-i+1);
  SetColor(D);
  Line(xm-i+1,y+i-1,xm-i+1,ym-i+1);
  Line(x+i-1,ym-i+1,xm-i+1,ym-i+1);
  End;
  setcolor(0);
 End;
{-------------------------------------}
   Function fn(Arg,ArgMax,df:word):word;
   Begin
    While Arg<ArgMax Do Inc(Arg,df);
    fn:=Arg;
   End;
{----------------------------------------------}
Procedure Restore(xv,yv,xv1,yv1,cp:word);
Var
   i,d,b,j,x,y,x1,y1:Word;
Begin
If not BeginPlaceCode Then
                       Begin
                        SetFillPattern(pic,7);
                        Bar(xv,yv,xv1,yv1);
                        Exit;
                       End;
 setviewport(xv,yv,xv1,yv1,true);
 clearviewport;
 x:=fn(FieldX,xv,dx);
 y:=fn(FieldY,yv,dy);
 x1:=fn(FieldX,xv1,dx);
 y1:=fn(FieldY,yv1,dy);
 d:=(x1-x) div dx;
 b:=(y1-y) div dy;
 For i:=0 to d+1 do
  for j:=0 to b+1 do
   If (x+i*dx<=FieldX+(MaxPage+2)*dx)And(y+j*dy<=FieldY+(MaxPage+2)*dy)
    Then  Putpixel (x+i*dx-xv,y+j*dy-yv,cp);
 WorkPort;
 If PlacingOver then
 For i:=1 to NumberOfElem do
  Begin
  FindXY(i,x,y);
  If (x+LenX>xv)and(x<xv1)
  and(y>yv)and(y-LenY<yv1)
   Then PuttoScreen(9,15,i);
  End;
End;
{-------------------------------}
Procedure StrlPort;
 Begin
  setViewPort(0,0,lx,ly,true);
 End;
{-------------------------------}
Procedure WorkPort;
 Begin
  setViewPort(0,0,Ux-1-OtsX,Uy-1-OtsY,true);
 End;
{----------------------------------}
 Procedure putstrl(M:Boolean;sx,sy,v,x,y,cs,cg,cf,cr:word);
 Var i,j:word;T:array[1..3]Of PointType;
 Begin
 case v of
 1: Begin
     T[1].X:=x+sx div 10;
     T[1].Y:=y+sy div 2;
     T[2].X:=x+9*sx div 10;
     T[2].Y:=y+sy div 10;
     T[3].X:=x+9*sx div 10;
     T[3].Y:=y+9*sy div 10;
    End;
 2: Begin
     T[1].X:=x+sx div 10;
     T[1].Y:=y+sy div 10;
     T[2].X:=x+sx div 10;
     T[2].Y:=y+9*sy div 10;
     T[3].X:=x+9*sx div 10;
     T[3].Y:=y+sy div 2;
    End;
 3: Begin
     T[1].X:=x+sx div 10;
     T[1].Y:=y+sy-9*sy div 10;
     T[2].X:=x+9*sx div 10;
     T[2].Y:=T[1].Y;
     T[3].X:=x+sx div 2;
     T[3].Y:=y+9*sy div 10;
    End;
 4: Begin
     T[1].X:=x+sx div 10;
     T[1].Y:=y+9*sy div 10;
     T[2].X:=x+9*sx div 10;
     T[2].Y:=T[1].Y;
     T[3].X:=x+sx div 2;
     T[3].Y:=y+sy div 10;
    End;
 End;
  setfillstyle(1,cf);
  setcolor(cr);
  Bary(x,y,x+sx,y+sy,M);
  Rectangle(x,y,x+sx,y+sy);
  setfillstyle(1,cs);
  setcolor(cg);
  fillPoly(3,T);
 End;
{------------------------------------------}
Procedure PutTab(M:boolean;sx,sy,x,y,cf,cr,clf,cl:word);
 Begin
  setfillstyle(1,cf);
  bary(x,y,x+sx,y+sy,M);
  setcolor(cr);
  rectangle(x,y,x+sx,y+sy);
  setfillstyle(1,clf);
  bar(x+sx div 4,y+sy div 4, x+3*sx div 4,y+ 3*sy div 4);
  rectangle(x+sx div 4,y+sy div 4, x+3*sx div 4,y+3*sy div 4);
end;
{--------------------------------------------}
Function StrlScorePos(v:byte;Npq:Word):Word;
 Begin
  Case v Of
  1: StrlScorePos:=Round(((Npq-1)*(lx-sx-sx-qx*3-9-OtsX))/(MaxPage-N+1))+4*Qx+6;
  2: StrlScorePos:=Round(((Npq-1)*(ly-sy-sy-qy-3-OtsY))/(MaxPage-M+1))+Sy+1;
  End;
 End;
{----------------------------------------}
Procedure Field(x,y,xm,ym,OldScale:word);
Var i,j,l,w,px,py:word;sc,cp,k:byte;
Begin
 If ScreenIsDust then
 Begin
 For i:=1 to NumberOfElem do
  Begin
  FindXY(i,j,l);
  If (j>0)and(j<ux)and(l>0)and(l<ux)
   Then PuttoScreen(0,0,i);
  End;
  ScreenIsDust:=False;
 End;
For k:=1 to 2 do
 Begin
 If k=1 then Begin
              Sc:=OldScale;
              cp:=0;
             End
        Else Begin
              Sc:=Scale;
       If not PlacingOver and not BeginPlaceCode
           then exit;
              cp:=15;
             End;
 Dx:=4*lx div (15*Sc);
 Dy:=7*ly div (20*Sc);
 LenX:=Dx-4;
 LenY:=Dy-4;
 N:= lx div dx-1;
 M:= ly div dy-1;
 w:=N+1; l:=M+1;
   Px:=PageX;
   Py:=PageY;
 If M>=maxPage+2 Then Begin l:=maxpage+2;PY:=1;M:=l End
                 Else If PageY>MaxPage+2-M Then PY:=MaxPage+2-M;
 If N>=MaxPage+2 Then Begin w:=maxpage+2;PX:=1;N:=w End
                 Else If PageX>MaxPage+2-N Then PX:=MaxPage+2-N;
  PutStrlScore(true,Px,Py);
   PageX:=Px;
   PageY:=Py;
 for i:=0 to w do
  for j:=0 to l do
   If  (FieldX+i*dx<x)Or(FieldX+i*dx>Xm)Or
       (FieldY+j*dy<y)Or(FieldY+j*dy>Ym)
   Then
   PutPixel(FieldX+i*dx,FieldY+j*dy,cp);
 End;
 If PlacingOver and BeginPlaceCode then
 Begin
 For i:=1 to NumberOfElem do
  Begin
  FindXY(i,x,y);
  If (x>0)and(x<ux)and(y>0)and(y<ux)
   Then PuttoScreen(9,15,i);
  End;
  ScreenIsDust:=true;
 End;
End;
{----------------------------------------------}
 Procedure FindXY(Ne:word;Var x1,y1:Word);
  Var
   i,kr:word;
   q,g,v,b:boolean;
   k,l,x,y:integer;
  Begin
    x:=2;y:=-1;
    kr:=korteg(Ne);
    for i:=1 to kr do
    Begin
     q:= i<>1;
     g:=((i-1) mod (2*sizeofpl)=0)and q;
     b:=((i-1) mod 4=0)and q;
     v:=((i-1) mod 2=0)and q;
    if g  then begin k:=-sizeofpl+1;l:=1 end
     else
     if b then begin k:=1;l:=-1 end
      else
       if v then
             begin k:=-1;l:=1 end
            else
             begin k:=1;l:=0 end;
     x:=x+l;
     y:=y+k
    End;
     dec(x,pageX-1);
     x1:=FieldX+(x-1)*dx+2;
     y1:=FieldY+(MaxPage-pageY-y+2)*dy-2;
  End;
{---------------------------------------}
Procedure PutToScreen(cf,cb:byte;ne:word);
Var wx,wy,wmx,wmy:word;
    x1,y1:Word;
Begin
if korteg(ne)=0 then exit;
  FindXY(ne,x1,y1);
If (x1<=FieldX)Or(Y1<=FieldY) Then Exit;
   setcolor(cb);
   settextstyle(SmallFont,0,5);
   setusercharsize(TextScale.Sml[1],TextScale.Sml[2]+Scale,
                   TextScale.Sml[3],TextScale.Sml[4]+2*Scale);
  setfillstyle(1,cf);
If (x1+LenX>=xm)and(x1<=xm+dmx)
   and(y1>=ym)and(y1-LenY<=ym+dmy)And not vm
   And (x1>FieldX)And(Y1>FieldY)
  Then
 Begin
   wx:=0;
   wy:=0;
   wmx:=ux-1-OtsX;
   wmy:=uy-1-OtsY;
  If ((xm<=x1+LenX)and(ym<=y1)
  And(xm>=x1)and(ym>=y1-LenY))
   Then
   Begin
   wmx:=xm-1;
   wmy:=ym-1;
   End
 Else
  If ((xm<=x1+LenX)and(y1-LenY>=ym)
  And(xm>=x1)and(y1<=ym+dmy))
   Then
   Begin
   wmx:=xm-1;
   wmy:=1;
   End
  else
  If ((x1>=xm)and(y1-LenY>=ym)
  And(x1+LenX<=xm+dmx)and(y1<=ym+dmy))
   Then
   Begin
   wmx:=1;
   wmy:=1;
   End
  Else
  If ((x1+LenX<=xm+dmx)and(ym>=y1-LenY)
  And(x1>=xm)and(ym<=y1))
   Then
   Begin
   wmx:=1;
   wmy:=ym-1;
   End
  else
  If ((x1+LenX<=xm+dmx)and(ym+dmy>=y1-LenY)
  And(x1>=xm)and(ym+dmy<=y1))
   Then
   Begin
   wmx:=1;
   wy:=ym+dmy+1;
   End
  else
  If ((xm+dmx<=x1+LenX)and(ym<=y1)
   And(xm+dmx>=x1)and(ym>=y1-LenY))
   Then
   Begin
   wx:=xm+dmx+1;
   wmy:=ym-1;
   End
  else
  If ((xm<=x1+LenX)and(ym+dmy<=y1)
  And(xm>=x1)and(ym+dmy>=y1-LenY))
   Then
   Begin
   wmx:=xm-1;
   wy:=ym+dmy+1;
   End
  else
  If ((xm+dmx<=x1+LenX)and(y1-LenY>=ym)
  And(xm+dmx>=x1)and(y1<=ym+dmy))
   Then
    Begin
     wx:=xm+dmx+1;
     wmy:=1;
    End
  else
  If ((xm+dmx<=x1+LenX)and(ym+dmy<=y1)
  And(xm+dmx>=x1)and(ym+dmy>=y1-LenY))
     Then
   Begin
   wx:=xm+dmx+1;
   wy:=ym+dmy+1;
   End;
  setviewport(wx,0,wmx,Uy-1-OtsY,true);
   Hide;
   bar(x1-wx,y1-LenY,x1+LenX-wx,y1);
   uttextxy(x1+lenX div 2-wx,y1-lenY div 2,elemname(ne));
  setviewport(0,wy,Ux-1-OtsX,wmy,true);
   bar(x1,y1-wy-LenY,x1+LenX,y1-wy);
   uttextxy(x1+lenX div 2,y1-lenY div 2-wy,elemname(ne));
   Show;
   WorkPort;
 End
 Else
  Begin
   Hide;
  bar(x1,y1-LenY,x1+LenX,y1);
  uttextxy(x1+LenX div 2,y1-lenY div 2,elemname(ne));
   Show;
  End;
End;
{----------------------------------------}
 Procedure PutStrlScore(M:boolean;Npx,Npy:Word);
  Var
    X,Y:Word;
  Begin
   StrlPort;
   Hide;
   If Npx<>PageX
    Then
     Begin
        setfillpattern(pic,3);
        bar(Qx*4+6,Uy+1-OtsY,Ux-Qx-2-OtsX,ly-OtsY);
        Setfillstyle(1,13);
        SetColor(5);
        X:=StrlScorePos(1,NpX);
        Bary(X,Uy+1-OtsY,X+Qx,Ly-OtsY,M);
        Rectangle(X,Uy+1-OtsY,X+Qx,Ly-OtsY);
     End;
   If Npy<>PageY
    Then
     Begin
        setfillpattern(pic,3);
        bar(Ux+1-OtsX,Sy+1,lx-OtsX,Uy-Qy-2-OtsY);
        Setfillstyle(1,13);
        SetColor(5);
        Y:=StrlScorePos(2,NpY);
        Bary(Ux+1-OtsX,Y,Lx-OtsX,Y+Qy,M);
        Rectangle(Ux+1-OtsX,Y,Lx-OtsX,Y+Qy);
     End;
    Show;
    WorkPort;
End;
{--------------------------------------------------------}
Procedure SetPage(dx,dy:integer);
 Var i,j,l:word;
 Begin
  If PlacingOver then
  For i:=1 to NumberOfElem do
   Begin
    FindXY(i,j,l);
    If (j>0)and(j<ux)and(l>0)and(l<ux)
     Then PuttoScreen(0,0,i);
   End;
    PutStrlScore(true,PageX+Dx,PageY+Dy);
    Inc(pageX,dx);
    Inc(pageY,dy);
  If PlacingOver then
  For i:=1 to NumberOfElem do
   Begin
    FindXY(i,j,l);
    If (j>0)and(j<ux)and(l>0)and(l<ux)
     Then PuttoScreen(9,15,i);
   End;
 End;
{------------------------------------}
 Procedure RadSize;
 Var
    s,s1,s2:word;
  function Find(s:word):word;
  Var
     i:byte;
     m:real;
  begin
     i:=1;
     repeat
      m:=exp(2*ln(exp(i*ln(2))));
      if m>=s
       then begin Find:=round(m);Exit end;
      inc(i)
     until m>s;
  end;
 Begin
     s:=0;
    for s1:=1 to NumberOfElem do s:=s{+sq(s1)};
    s1:=round(s*100/70);
    s1:=find(s1);
    SizeOfRad:=round(exp(0.5*ln(s1)));
    s1:=find(numberofelem);
    SizeOfPl:=round(exp(0.5*ln(s1)));
    maxPage:=SizeOfPl;
 End;
{----------------=========------------}
Function Way(qs,qc,cr,cf,ct,cpf,cpt:byte;text:string):boolean;
var x1,y1,x,mx,my,y,by,dx,dy,i,j,k,a,b,key:word;
    stkr:string[20];
    v:boolean;
{=================================}
  Procedure Exite(m:byte);
   Begin
              Hide;
     Restore(xm,by,xm+qc*qx,by+(qs+3)*qy,15);
              Show;
              DoneCaps_Lock;
   If m<>0 Then
     if Not v then Way:=false
              else Way:=true;
              Delay(50);
   End;
{=================================}
begin
    settextstyle(triplexfont,0,1);
    setusercharsize(textscale.Trp[3,1],textscale.Trp[3,2],
                    textscale.Trp[3,3],textscale.Trp[3,4]);
  If ly-ym-dmy-qy-OtsY-1<(Qs+3)*qy
     then by:=ym-(qs+3)*qy-1
     else by:=ym+dmy+1;
          Hide;
         x:=xm+qx;
         mx:=x+(qc-7)*qx;
         y:=by+(Qs-1)*qy+Qy div 2;
         my:=y+2*qy;
         x1:=qx;
         y1:=qy;
         k:=4*Qx;
         v:=true;
         j:=(mx-x-x1);
         ActivisionCaps_Lock;
         setfillstyle(1,cf);
         bar(xm,by,xm+qc*qx,by+(qs+3)*qy);
         setcolor(cr);
         rectangle(xm+2,by+2,xm+qc*qx-2,by+(qs+3)*qy-2);
         rectangle(xm+4,by+4,xm+qc*qx-4,by+(qs+3)*qy-4);
         setcolor(ct);
         uttextxy(xm+qc*qx div 2,by+4+qy div 2,text);
         setfillstyle(1,cpf);
         bar(x+x1,y+y1,x+x1+k,my+y1);
         setcolor(1);
         setlinestyle(0,0,2);
         rectangle(x+x1-1,y+y1-1,x+x1+k+1,my+y1+1);
         x:=x+x1;
         setcolor(cpt);
       settextstyle(triplexfont,0,1);
       setusercharsize(textScale.Trp[1,1],textScale.Trp[1,2],
                       textScale.Trp[1,3],textScale.Trp[1,4]);
                       Stkr:='YES';
         uttextxy(x+k div 2,y+y1+qy,stkr);
         uttextxy(mx+k div 2,y+y1+qy,'NO');
          Show;
     repeat
         c:=' ';
        Repeat
         If keypressed Then c:=readkey;
         GetPos(a,b,key);
          If (a>x)And(a<x+k)And(b>y+y1)And(b<my+y1)And(key=Left)
           Then Begin Exite(1);Exit;End;
           If key=Right Then Begin Way:=False;exite(0);exit end;
          If Not((a>xm+qx+x1)And(a<mx+k)
              And(b>y+y1)And(b<my+y1)And(key=Left))
           Then key:=0;
           c:=Fullkey(ch,0);
        Until (((c=#75)Or(c=#77))And(ch<>c)) Or (c=#13) Or (key=Left);
         If key=Left Then c:=#75;
       if c<>#13 then
        begin
         Hide;
         setcolor(cpf);
         uttextxy(x+k div 2,y+y1+qy,stkr);
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
          SetColor(cpt);
         If stkr='YES' Then i:=xm+qx+x1 Else i:=mx;
         uttextxy(i+k div 2,y+y1+qy,stkr);
     if not v then stkr:='YES'
              else stkr:='NO';
         uttextxy(x+k div 2,y+y1+qy,stkr);
       if v then v:=false
            else v:=true;
           Show;
       end;
     until c=#13;
     Exite(1);
     end;
{----------------------------------------}
 Procedure ShowMessage(ErrS,s:Pathstr);
 Var j:byte;
  Begin
   SetLittMode;
   setfillstyle(1,7);
   strlPort;
    j:=getColor;
   Hide;
   Bar(4*qx+6,ly-otsY+2,4*qx+6+TextWidth(FlowerMessage),ly-Otsy+qy);
    Setcolor(4);
   uttextxy(4*qx+6,ly-OtsY+(Qy+2)Div 2,ErrS);
    Setcolor(0);
   uttextxy(4*qx+6+TextWidth(ErrS),ly-OtsY+(Qy+2)Div 2,s);
   Show;
   FlowerMessage:=s;
    SetColor(j);
   WorkPort;
   SettextJustify(1,1);
  End;
{--------------------------------------------}
 Procedure UtTextXY(X,Y:Word;Text:String);
  Begin
   Inline($FA);
   outtextxy(x,y,text);
   Inline($FB);
  End;
{--------------------------------------------------------}
 Procedure UtText(Text:String);
  Begin
   Inline($FA);
   Outtext(text);
   Inline($FB);
  End;
{/////The End Of Unit 'V I S I O N'\\\\\\}
End.