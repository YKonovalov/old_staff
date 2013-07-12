Unit PDGraph;
Interface
uses Graph,YK_Fonts;
 Var PortX,PortY:Integer;
  Procedure PDBar(X,Y,X1,Y1:Integer);
  Procedure PDLine(X,Y,X1,Y1:Integer);
  Procedure PDRectangle(X,Y,X1,Y1:Integer);
  Procedure PDFillPoly(N:Word;Pl:Array Of PointType);
  Procedure PDSetViewPort(X,Y,X1,Y1:Integer;Clip:Boolean);
  Procedure PDOuttextxy(X,Y:Integer;Text:String);
  Procedure PDMoveTo(X,Y:Integer);
  Function PDGetX:Integer;
  Function PDGetY:Integer;
Implementation

  Procedure PDBar(X,Y,X1,Y1:Integer);
   Begin
    Dec(X,PortX);
    Dec(X1,PortX);
    Dec(Y,PortY);
    Dec(Y1,PortY);
    Bar(X,Y,X1,Y1);
   End;

  Procedure PDLine(X,Y,X1,Y1:Integer);
   Begin
    Dec(X,PortX);
    Dec(X1,PortX);
    Dec(Y,PortY);
    Dec(Y1,PortY);
    Line(X,Y,X1,Y1);
   End;

  Procedure PDRectangle(X,Y,X1,Y1:Integer);
   Begin
    Dec(X,PortX);
    Dec(X1,PortX);
    Dec(Y,PortY);
    Dec(Y1,PortY);
    Rectangle(X,Y,X1,Y1);
   End;

  Procedure PDFillPoly(N:Word;Pl:Array Of PointType);
   Var i:integer;
   Begin
    For i:=1 to N do
     Begin
      Dec(Pl[i].X,PortX);
      Dec(Pl[i].Y,PortY);
     End;
    FillPoly(N,Pl);
   End;

  Procedure PDSetViewPort(X,Y,X1,Y1:Integer;Clip:Boolean);
   Begin
    PortX:=X;
    PortY:=Y;
    SetViewPort(X,Y,X1,Y1,Clip);
   End;

  Procedure PDOuttextXY(X,Y:Integer;Text:string);
   Begin
    Dec(X,PortX);
    Dec(Y,PortY);
    YK_OutTextXy(X,Y,Text);
   End;

  Procedure PDMoveTo(X,Y:Integer);
   Begin
    Dec(X,PortX);
    Dec(Y,PortY);
    MoveTo(X,Y);
   End;

  Function PDGetX:Integer;
   Var x:Integer;
   Begin
    X:=GetX;
    Inc(X,PortX);
    PDGetX:=X;
   End;

  Function PDGetY:Integer;
   Var y:integer;
   Begin
    Y:=GetY;
    Inc(Y,PortY);
    PDGetY:=Y;
   End;
End.