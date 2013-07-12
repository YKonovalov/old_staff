Unit Dialogs;
Interface
Uses Graph,PDGraph,Pictures,Crt;
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
 Const
      MaxVis=7;
      MaxHidden=6;
 Type
 MenuStr=String[24];
 MenuArr=Array[1..MaxHidden]Of MenuStr;
 AChArr=Array[1..MaxHidden]Of Byte;
 EnArr=Array[1..MaxHidden]Of Boolean;
   ConfigContents=Record
                   Headline,
                   lineMenu,
                   IconsPad,
                   MessageLine,
                   Arrows      :Boolean
                  End;
      LineType= Record
                 Cat:Byte;
                 Menu:Array[1..MaxVis]Of String[12];
                 Po:Byte;
                 ActChar:Array[1..MaxVis]Of Byte;
                 CallingChar:Array[1..MaxVis]Of Byte;
                End;
     HiddenType=Record
                 Cat:Array[1..MaxVis]Of Byte;
                 Menu:Array[1..MaxVis]Of MenuArr;
                 Po:Array[1..MaxVis]Of Byte;
                 ActChar:Array[1..MaxVis]Of AChArr;
                 Enable:Array[1..MaxVis]Of EnArr;
                 MenuType:Array[1..MaxVis]Of Byte;
                 InfoPart:Array[1..MaxHidden]Of String[12];
                End;
  IconsContents=Record
                 Width:Word;
                 Orientation:Boolean;
                 Quantity:Byte;
                 Distance:Array[1..8]Of Byte;
                 FileName:Array[1..8]Of String[12];
                End;
  XYPoint=Record X,Y:Integer;End;
  VisualContents=Record
                  Headline:string[64];
                  Lin:LineType;
                  Hid:HiddenType;
                  Icons:IconsContents;
                  Config:ConfigContents;
                  MinLength,
                  MinBreadth:Word;
                  UC,LC: XYPoint;
                 End;
  Const
         ConvertorPad:VisualContents=(
                            HeadLine:('The PECD text convertor');
                            Lin:(
                              Cat:6;
                              Menu:('File','Search','Form','Compile','Options','Help','');
                              Po:1;
                              ActChar:(1,1,3,1,1,1,0);
                              CallingChar:(33,31,19,46,24,35,82)
                                  );
                            Hid:(
                              Cat:(4,5,3,3,3,3,5);
                              Menu:(
                                  ('Load','Save','Save as','New','',''),
                                  ('Find...','Replace...','Go to line number','Find Object','Replace Object',''),
                                  ('Text','Table','Schematic','','',''),
                                  ('PECD Compiler','PC-CAPS Convertor','PC-Cards Convertor','','',''),
                                  ('Derectories','Colors','Dialogs','','',''),
                                  ('Contents','Using Help','PECD Language','','',''),
                                  ('Close','Minimize','Maximize','Size','Move','')
                                         );
                              Po:(1,1,1,1,1,1,1);
                              ActChar:((1,1,2,1,0,0),(1,1,1,2,2,0),
                                             (1,2,1,0,0,0),(6,6,6,0,0,0),
                                             (1,1,2,0,0,0),(1,1,6,0,0,0),
                                             (1,1,2,1,2,0));
                              Enable:((True,False,False,True,False,False),(False,False,False,False,False,False),
                                            (True,True,True,False,False,False),(False,False,False,False,False,False),
                                            (True,True,True,False,False,False),(True,True,True,False,False,False),
                                            (True,True,True,True,True,True));
                              MenuType:(1,1,2,1,1,1,1);
                              InfoPart:('','','','','','')
                                       );
                            Icons:(
                                Width:2;
                                Orientation:True;
                                Quantity:8;
                                Distance:(1,2,0,2,0,2,0,0);
                                FileName:('1.GEK','2.GEK','3.GEK',
                                              '7.GEK','4.GEK','6.GEK',
                                              '8.GEK','5.GEK')
                                       );
                            Config:(
                                 Headline:True;
                                 lineMenu:True;
                                 IconsPad:True;
                                 MessageLine:True;
                                 Arrows :True
                                   );
                            MinLength:20;
                            MinBreadth:15;
                            UC:(X:3;Y:3);
                            LC:(X:30;Y:24)
                                     );
    Var BndX,BndY,FieldX,FieldY,
        Lx,Ly,Ux,Uy,Qx,Qy,Sx,Sy:Integer;
        LineStep:Integer;
        MenuReport:Byte;
        Pad:VisualContents;
        c:Char;
       Procedure InitDialogs;
       Procedure OpenPad(P:VisualContents);
       Procedure PutBourder;
       Procedure PutMsgLine;
       Procedure PutHeadLine;
       Procedure PutLineMenu;
       Procedure PutIcon(INum,BkC:Byte);
       Procedure PutIcons;
       Procedure PutArrows;
       Procedure PutField;
       Procedure OpenHeadMenu;
       Procedure Dialog;
  Implementation
  Var FoundLine,MenuX,MenuY,PosX,PosY,LongestLine,j,i:Integer;
{-------------------------------------------}
 Procedure InitDialogs;
  Begin
    Lx:=GetMaxX;
    Ly:=GetmaxY;
    Ux:=Lx-lx div 38-1;
    Uy:=Ly-Ly Div 25;
       sx:=2*(lx-ux);
       sy:=2*(ly-uy);
       qx:=sx div 2;
       qy:=sy div 2;
    SetFillStyle(1,7);
    PDBar(0,0,Lx,Ly);
  End;
{-------------------------------------------}
 Procedure OpenPad(P:VisualContents);
  Begin
  Pad:=P;
  With Pad do
   Begin
   MinLength:=MinLength*Qx;
   MinBreadth:=MinBreadth*Qy;
   UC.X:=UC.X*Qx;
   UC.Y:=UC.Y*Qy;
   LC.X:=LC.X*Qx;
   LC.Y:=LC.Y*Qy;
   BndX:=Qx Div 4;
   BndY:=Qy Div 4;
    If Icons.Orientation Then
           Begin i:=0;j:=2*BndY+Icons.Width*Qy; End
                         Else
           Begin j:=0;i:=2*BndX+Icons.Width*Qx; End;
    FieldX:=UC.X+BndX+i;
    FieldY:=UC.Y+BndY+Qy+Qy+j;
   End;
   PutBourder;
   PutMsgLine;
   PutHeadLine;
   PutLineMenu;
   PutIcons;
   PutArrows;
   PutField;
   Dialog;
  End;
{-------------------------------------------}
 Procedure FRect(x,y,xm,ym:Integer);
  Begin
    PDBar(x+1,y+1,xm-1,ym-1);
    PDRectangle(x,y,xm,ym);
  End;
{-------------------------------------------}
 Procedure Bary(x,y,xm,ym:Word;Mode:Boolean);
 Var i,u,d,Q:Byte;
 Begin
 If Mode Then Begin U:=15;D:=8 End
         Else Begin U:=8;D:=15 End;
{  If ym-y>Qy Then Q:=2;}
q:=2;
  PDBar(x,y,xm,ym);
  For i:=1 to Q do
  Begin
  Setcolor(U);
  PDLine(x+i-1,y+i-1,xm-i+1,y+i-1);
  PDLine(x+i-1,y+i-1,x+i-1,ym-i+1);
  SetColor(D);
  PDLine(xm-i+1,y+i-1,xm-i+1,ym-i+1);
  PDLine(x+i-1,ym-i+1,xm-i+1,ym-i+1);
  End;
  setcolor(0);
 End;
{-------------------------------------}
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
  PDRectangle(x,y,x+sx,y+sy);
  setfillstyle(1,cs);
  setcolor(cg);
  PDfillPoly(3,T);
 End;
{------------------------------------------}
Procedure PutTab(M:boolean;sx,sy,x,y,cf,cr,clf,cl:word);
 Begin
  setfillstyle(1,cf);
  bary(x,y,x+sx,y+sy,M);
  setcolor(cr);
  PDrectangle(x,y,x+sx,y+sy);
  setfillstyle(1,clf);
  PDbar(x+sx div 4,y+sy div 4, x+3*sx div 4,y+ 3*sy div 4);
  PDrectangle(x+sx div 4,y+sy div 4, x+3*sx div 4,y+3*sy div 4);
end;
{--------------------------------------------}
 Procedure PutBourder;
  Begin
   SetFillStyle(1,7);
   SetColor(8);
   With Pad do
    Begin
          PDBar(UC.X+1,UC.Y+1,UC.X+BndX-1,LC.Y-1);
          PDBar(UC.X+1,UC.Y+1,LC.X-1,UC.Y+BndY-1);
          PDBar(LC.X-BndX+1,UC.Y+1,LC.X-1,LC.Y-1);
          PDBar(UC.X+1,LC.Y-BndY+1,LC.X-1,LC.Y-1);
         PDRectangle(UC.X,UC.Y,LC.X,LC.Y);
         PDRectangle(UC.X+BndX,UC.Y+BndY,LC.X-BndX,LC.Y-BndY);
          PDLine(UC.X,UC.Y+Qy+BndY,UC.X+BndX,UC.Y+Qy+BndY);
          PDLine(UC.X,LC.Y-Qy-BndY,UC.X+BndX,LC.Y-Qy-BndY);
          PDLine(UC.X+BndX+Qx,UC.Y,UC.X+BndX+Qx,UC.Y+BndY);
          PDLine(LC.X-BndX-Qx,UC.Y,LC.X-BndX-Qx,UC.Y+BndY);
          PDLine(LC.X,UC.Y+BndY+Qy,LC.X-BndX,UC.Y+BndY+Qy);
          PDLine(LC.X,LC.Y-BndY-Qy,LC.X-BndX,LC.Y-BndY-Qy);
          PDLine(LC.X-BndX-Qx,LC.Y,LC.X-BndX-Qx,LC.Y-BndY);
          PDLine(UC.X+BndX+Qx,LC.Y,UC.X+BndX+Qx,LC.Y-BndY);
    End;
  End;
{-------------------------------------------}
 Procedure PutMsgLine;
  Var XML:Integer;
  Begin
   SetFillStyle(1,7);
   SetColor(8);
   With Pad do
    Begin
     If Icons.Orientation Then XML:=UC.X+BndX
                          Else XML:=UC.X+BndX+Icons.Width;
         FRect(XML,LC.Y-BndY-Qy,LC.X-BndX,LC.Y-BndY);
    End;
  End;
{-------------------------------------------}
 Procedure PutHeadPip(Col:Byte);
  Begin
   With Pad do
    Begin
     SetColor(8);
      SetFillStyle(1,Col);
         FRect(UC.X+BndX,UC.Y+BndY,UC.X+BndX+Qx,UC.Y+BndY+Qy);
      SetFillStyle(1,15);
         FRect(UC.X+BndX+Qx Div 6,UC.Y+BndY+3*Qy Div 7,
               UC.X+BndX+Qx-Qx Div 6,UC.Y+BndY+Qy-3*Qy Div 6);
    End;
  End;
{-------------------------------------------}
 Procedure PutHeadLine;
  Begin
   SetFillStyle(1,1);
   SetColor(8);
   With Pad do
    Begin
         FRect(UC.X+BndX+Qx,UC.Y+BndY,LC.X-BndX,UC.Y+BndY+Qy);
         SetColor(15);
         SetTextJustify(CenterText,CenterText);
         SetTextStyle(7,0,1);
         PDOutTextXY((LC.X+UC.X+Qx)Div 2,UC.Y+BndY+Qy Div 2-1,HeadLine);
         PutHeadPip(7);
    End;
  End;
{-------------------------------------------}
 Procedure PutLineItem(Ln,BkC:Byte);
  Var len,i:Integer;
  Begin
    With Pad Do
     Begin
         Len:=0;
         For i:=1 to Ln-1 do
            Inc(len,TextWidth(Lin.Menu[i]));
      SetFillStyle(1,BkC);
      PDBar(UC.X+BndX+1+LineStep*Ln+Len-LineStep div 2,
          UC.Y+BndY+Qy+1,
          UC.X+BndX+1+LineStep*Ln+Len+LineStep div 2+
                    TextWidth(Lin.Menu[Ln]),
          UC.Y+BndY+Qy+Qy-1);
    MenuX:=UC.X+BndX+1+LineStep*Ln+Len-LineStep div 2;
    MenuY:=UC.Y+BndY+Qy+Qy;
        PDMoveTo(UC.X+BndX+1+LineStep*Ln+Len,UC.Y+Qy+Qy div 2);
        OutText(Copy(Lin.Menu[Ln],1,Lin.ActChar[Ln]-1));
        PDOutTextXY(PDGetX,PDGetY,'_');
        OutText(Copy(Lin.Menu[Ln],Lin.ActChar[Ln],
                Length(Lin.Menu[Ln])-Lin.ActChar[Ln]+1));
    End;
  End;
{-------------------------------------------}
 Procedure PutLineMenu;
 Var Len:Integer;
  Begin
   With Pad do
    Begin
         SetFillStyle(1,7);
         PDBar(UC.X+BndX+1,UC.Y+BndY+Qy+1,LC.X-BndX-1,UC.Y+BndY+Qy+Qy-1);
         SetColor(8);
         SetTextJustify(LeftText,CenterText);
         SetTextStyle(7,0,1);
         Len:=0;
         For i:=1 to Lin.Cat do
            Inc(len,TextWidth(Lin.Menu[i]));
         LineStep:=(LC.X-UC.X-Len-2-2*BndX)Div (Lin.Cat+1);
         If LineStep div Qx >4 Then LineStep:=4;
         For i:=1 to Lin.Cat do  PutLineItem(i,7);
    End;
  End;
{-------------------------------------------}
 Procedure PutIcon(INum,BkC:Byte);
 Var Len,i,x,y:Integer;
     v,b:byte;
 Begin
    SetFillStyle(1,8);
  With Pad Do
  Begin
 If Icons.Orientation Then Begin v:=1;b:=0 End
                          Else Begin v:=0;b:=1 End;
   Len:=0;
  For i:=1 To Inum do
       Inc(Len,Icons.Distance[i]*(BndX*v+BndY*b));
       Len:=Len+Icons.Width*(Qx*v+Qy*b)*(Inum-1);
         x:=UC.X+BndX+1+v*Len+b*BndX;
         y:=UC.Y+BndY+Qy+Qy+1+b*Len+v*BndY;
         Bary(x,y,x+Icons.Width*Qx,y+Icons.Width*Qy,True);
         PDRectangle(x,y,x+Icons.Width*Qx,y+Icons.Width*Qy);
       GekLoad(Icons.FileName[Inum],
             X+2,y+2,Icons.Width*Qx-4,Icons.Width*Qy-4,1);
  End;
 End;
{-------------------------------------------}
 Procedure PutIcons;
 Var IcX,IcY:Integer;
  Begin
   SetFillStyle(1,7);
   SetColor(0);
   With Pad do
    Begin
 If Icons.Orientation Then Begin
                                 IcX:=LC.X-BndX;
                                 IcY:=UC.Y+3*BndY+Qy+Qy+Icons.Width*Qy;
                               End
                          Else Begin
                                 IcX:=UC.X+3*BndX+Icons.Width*Qx;
                                 IcY:=LC.Y-BndY;
                               End;
         FRect(UC.X+BndX,UC.Y+BndY+Qy+Qy,IcX,IcY);
     For i:=1 To Icons.Quantity do PutIcon(i,7);
    End;
  End;
{-------------------------------------------}
 Procedure PutArrows;
  Begin
   SetFillStyle{Pattern(pic}(1,3);
   SetColor(8);
   With pad do
   Begin
   FRect(FieldX,LC.Y-BndY-Qy-Qy,LC.X-BndX,LC.Y-BndY-Qy);
   FRect(LC.X-BndX-Qx,FieldY,LC.X-BndX,LC.Y-BndY-Qy);
   PutStrl(true,Qx,Qy,1,FieldX,LC.Y-BndY-Qy-Qy,1,2,13,10);
   PutStrl(true,Qx,Qy,2,LC.X-BndX-Qx-Qx,LC.Y-BndY-Qy-Qy,1,2,13,10);
   PutStrl(true,Qx,Qy,3,LC.X-BndX-Qx,LC.Y-BndY-Qy-Qy-Qy,1,2,13,10);
   PutStrl(true,Qx,Qy,4,LC.X-BndX-Qx,FieldY,1,2,13,10);
   Puttab(true,Qx,Qy,LC.X-BndX-Qx,LC.Y-BndY-Qy-Qy,7,0,3,0);
   End;
  End;
{-------------------------------------------}
 Procedure PutField;
  Begin
   SetFillStyle(1,15);
   SetColor(8);
   With Pad do
   Begin
   FRect(FieldX,FieldY,
         LC.X-BndX-Qx,LC.Y-BndY-Qy-Qy);
   PDMoveTo(FieldX+Qx,FieldY+3*Qy);
   End;
  End;
{-------------------------------------------}
 Procedure DetectLongestLine(Cat:Byte;M:MenuArr);
  Begin
     LongestLine:=0;
   For i:=1 to Cat Do If TextWidth(M[i])>LongestLine
                       Then LongestLine:=TextWidth(M[i]);
  End;
{-------------------------------------------}
 Procedure OutItem(X,Y:Integer;n,BkC:Byte);
  Begin
     With Pad.Hid Do
     Begin
    If Enable[Pad.Lin.Po,n] Then SetColor(8){SetlineStyle(DottedLn,0,NormWidth)}
                           Else SetColor(1){SetLineStyle(SolidLn,0,NormWidth)};
        SetFillStyle(1,BkC);
        PDBar(X+BndX,Y+Qy*(n-1)+BndY,
         X+BndX+TextWidth(Menu[Pad.Lin.Po,n]),Y+Qy*(n-1)+BndY+Qy);
        MoveTo(X+BndX,Y+Qy*(n-1)+BndY+Qy Div 2-4);
        OutText(Copy(Menu[Pad.Lin.Po,n],1,ActChar[Pad.Lin.Po,n]-1));
        OutTextXY(PDGetX,PDGetY,'_');
        OutText(Copy(Menu[Pad.Lin.Po,n],
                ActChar[Pad.Lin.Po,n],
                Length(Menu[Pad.Lin.Po,n])-ActChar[Pad.Lin.Po,n]+1));
    End;
  End;
{-------------------------------------------}
 Procedure Restore(X,Y,Xm,Ym:Integer);
  Begin
   PDSetViewPort(X,Y,Xm,Ym,True);
   PutBourder;
   PutMsgLine;
   PutHeadLine;
   PutLineMenu;
   PutIcons;
  { PutArrows;}
   PutField;
   PDSetViewPort(0,0,Lx,Ly,False);
  End;
{-------------------------------------------}
      Function EqualChar(c:Char):boolean;
        Begin
           FoundLine:=0;
           With Pad.Hid do
         For i:=1 to Cat[Pad.Lin.Po] do
          If UpCase(Menu[Pad.Lin.Po,i][ActChar[Pad.Lin.Po,i]])=c Then
            Begin FoundLine:=i;EqualChar:=True;Exit End;
           EqualChar:=False;
        End;
{-------------------------------------------}
      Function SameChar(c:Char;Call:Array of Byte;Cat:Byte):boolean;
        Begin
           FoundLine:=0;
         For i:=1 to Cat do
          If Call[i]=Byte(c) Then
            Begin FoundLine:=i;SameChar:=True;Exit End;
           SameChar:=False;
        End;
{-------------------------------------------}
      Function cInCall(c:Char;V,B:Boolean):boolean;
        Begin
           FoundLine:=0;
           With Pad.Lin do
         For i:=1 to Cat+1 do
          If (CallingChar[i]=Byte(c))And (Not V Or(i<>Po)) Then
            Begin
                  FoundLine:=i;
                  If B Then Pad.Lin.Po:=i;
                  cInCall:=True;Exit
            End;
           cInCall:=False;
        End;
{-------------------------------------------}
 Procedure OpenFallingMenu(X,Y:Integer);
   Var NewPo:Byte;
  Begin
  With Pad do
  Begin
  MenuReport:=255;
     SetFillStyle(1,7);
     SetColor(8);
     SetTextJustify(LeftText,CenterText);
     SetTextStyle( 7,0,1);
     DetectLongestLine(Hid.Cat[Lin.Po],Hid.Menu[Lin.Po]);
     If X+Qx+LongestLine>LC.X-BndX Then X:=LC.X-BndX-Qx-LongestLine;
      FRect(X,Y,X+Qx+LongestLine,Y+Qy+Hid.Cat[Lin.Po]*Qy);
      For i:=1 to Hid.Cat[Lin.Po] do
       If i<>Hid.Po[Lin.Po]
          Then OutItem(X,Y,i,7)
          Else OutItem(X,Y,i,3);
          NewPo:=Hid.Po[Lin.Po];
    Repeat

        Repeat c:=Readkey Until (UpCase(c)in[#0,#27,#13,#65..#90]);
       If (UpCase(c) in[#65..#90])And
        EqualChar(UpCase(c))
          Then Begin
                NewPo:=FoundLine;
                Hid.Po[Lin.Po]:=NewPo;
                MenuReport:=1;
                Break;
               End;
       While keyPressed do c:=Readkey;
       Case c Of
       #72:If Hid.Po[Lin.Po]>1 Then NewPo:=Hid.Po[Lin.Po]-1
                   Else NewPo:=Hid.Cat[Lin.Po];
       #80:If Hid.Po[Lin.Po]<Hid.Cat[Lin.Po] Then NewPo:=Hid.Po[Lin.Po]+1
                     Else NewPo:=1;
       #71:NewPo:=1;
       #79:NewPo:=Hid.Cat[Lin.Po];
       #27: MenuReport:=0;
       #13: If Hid.Enable[Lin.Po,Hid.Po[Lin.Po]]
             Then MenuReport:=1;
       #75: MenuReport:=2;
       #77: MenuReport:=3;
       End;
       If cInCall(c,True,False) Then MenuReport:=4;
       If Hid.Po[Lin.Po]<>Newpo Then
         Begin
          OutItem(X,Y,Hid.Po[Lin.Po],7);
          OutItem(X,Y,NewPo,3);
          Hid.Po[Lin.Po]:=NewPo;
         End;
    Until MenuReport in[0..4];
    Restore(X,Y,X+Qx+LongestLine,Y+Qy+Hid.Cat[Lin.Po]*Qy);
   End;
  End;
{-------------------------------------------}
 Procedure OpenHeadMenu;
  Var Po:Byte;
  Begin
   With Pad do
    Begin
      PutHeadPip(15);
      Po:=Lin.Po;
       Lin.Po:=Lin.Cat+1;
      OpenFallingMenu(UC.X+BndX,UC.Y+BndY+Qy);
      Lin.Po:=Po;
      PutHeadPip(7);
    End;
  End;
{-------------------------------------------}
 Procedure OpenLineMenu(Mode:Byte);
 Label Cs,Cal;
 Var OldPo:Byte;s:String;
  Begin
   With Pad do
    Begin
      If Mode=1 Then Goto Cs;
      PutLineItem(Lin.Po,3);
      If Mode=2 Then Goto Cal;
     Repeat
        Repeat c:=Readkey;Until c in [#0,#27,#13];
        While keypressed do c:=ReadKey;
        OldPo:=Lin.Po;
       Case c Of
         #75:If Lin.Po>1 Then Dec(Lin.Po);
         #77:If Lin.Po<Lin.Cat Then Inc(Lin.Po);
         #27:Break;
         #13:Repeat
Cal:             OldPo:=Lin.Po;
               OpenFallingMenu(MenuX,MenuY);
               PutLineItem(Lin.Po,7);
               Case MenuReport Of
                 2:If Lin.Po>1 Then Dec(Lin.Po);
                 3:If Lin.Po<Lin.Cat Then Inc(Lin.Po);
                 4: If FoundLine=Lin.Cat+1
                      Then Goto Cs
                      Else Lin.Po:=FoundLine;
                 0,1:Exit;
               End;
                 If ((MenuReport=2)And(OldPo=1))Or
                    ((MenuReport=3)And(OldPo=Lin.Cat)) Then
                   Begin
Cs:                     PutHeadPip(15);
                     OldPo:=Lin.Po;
                      Lin.Po:=Lin.Cat+1;
                     OpenFallingMenu(UC.X+BndX,UC.Y+BndY+Qy);
                     Lin.Po:=OldPo;
                     PutHeadPip(7);
                      Case MenuReport Of
                      2:Lin.Po:=Lin.Cat;
                      3:Lin.Po:=1;
                      0,1:Begin Lin.Po:=0;Exit End;
                      End;
                   End;
                   PutLineItem(Lin.Po,3);
            Until False;
         End;
       If cInCall(c,True,True)Then
            Begin
             PutLineItem(OldPo,7);
             PutLineItem(Lin.Po,3);
             Goto Cal;
            End;

      If Lin.Po=OldPO Then
           Begin
            PutLineItem(Lin.Po,7);
            PutHeadPip(15);
             Repeat
               c:=Readkey;While KeyPressed do c:=Readkey;
             Until Byte(c) in [13,77,75,27];
            PutHeadPip(7);
             Case c Of
             #75:Lin.Po:=Lin.Cat;
             #77:Lin.Po:=1;
             #13:Goto Cs;
             #27:Break;
             End;
           End;
            PutLineItem(OldPo,7);
            PutLineItem(Lin.Po,3);
     Until c=#27;
      PutLineItem(Lin.Po,7);
    End;
  End;
{-------------------------------------------}
 Procedure Dialog;
  Var Style:Byte;c:char;
  Begin
     PosX:=FieldX+Qx+qx;
     PosY:=FieldY+Qy+Qy;
     Style:=0;
    SetColor(8);
   Repeat
      Repeat c:=Readkey;Until Upcase(c)In [#0,#27,#13,#32..#126];
      If c In [#32..#126]
      Then
        Begin
         PDMoveTo(PosX,PosY);
         Outtext(C); PosX:=GetX;PosY:=GetY;
         Continue;
        End;
      While KeyPressed do c:=Readkey;
    iF C=#13 THEN Begin PosX:=FieldX+Qx+qx;Inc(PosY,Qy);End;
    iF C=#83 THEN Begin Inc(Style);SetTextStyle(Style,Horizdir,1);End;
    If c=#82 Then OpenLineMenu(1)
    Else If (c=#68)Then OpenLineMenu(0)
    Else If cInCall(c,False,True) Then OpenLineMenu(2);
  Until C=#27;
 End;
{-------------------------------------------}
End.