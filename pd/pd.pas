{$O+}
{$F+}
{$M 16384,0,655360}{38536}
 PROGRAM Plate_Disigner;
 Uses Control,Vision,Disc,Memory,Menus,LayOut,RoutEdit,
      Dos,Crt,Graph,Overlay,Arrais;
 {$O RoutEdit}
 {$O LayOut}
 {$O Vision}
 {$O Disc}
 {$O Menus}
 {$O Dos}
 procedure trip; external;
 {$L trip.obj}
 procedure litt; external;
 {$L litt.obj}
 procedure EgaVga; external;
 {$L EgaVga.obj}
 Var
       SaveOldVec:procedure;
         PC_Mode :Boolean;
     i,j,mn,h    :word;
     k           :byte;
     ch          :char;
     st          :likename;
     sm          :string[79];
{-------------------------------------------}
 Procedure ChangeMousePos;
   Var Control,j,i,P:Byte;
       e,a,FDX,FDY,X,Y:Integer;
  Begin
  strlport;
  Fdx:=1;
  Fdy:=1;
   Control:=Port[$60];
    Case Control Of
    1:LastPress:=1;
    76:LastPress:=2;
   Else LastPress:=0;
    End;
   If Control=56 Then Alt:=True;
   If Control=29 Then Ctrl:=True;
 If (Control in [72,75,77,80,71,73,79,81])And
     Not Caps_Lock
  Then
   Begin
     i:=1;
     x:=FlowX;
     y:=FlowY;
      Case Control Of
       75,77: j:=FlowDx;
       80,72,79,81,71,73: J:=FlowDy;
       End;
    While (Port[$60]=Control)And
      ((Not PC_Mode And(i<Vision.Lx))Or(PC_Mode And(i<J))) do
     Begin
        p:=Port[$60];
         Inline($FA);
         e:=0;a:=0;
      If (p=75) Then Begin e:=-FDX;If FlowX-FDx<9 Then e:=9-FlowX;End
       Else
      If (p=77) Then Begin e:=FDX;If FlowX+fDx>Vision.Lx-9 Then e:=Vision.Lx-9-FlowX;End
       Else
      If (p=80) Then Begin a:=FDY;If FlowY+FDy>Vision.Ly-9 Then a:=Vision.Ly-9-FlowY;End
       Else
      If (p=72) Then Begin a:=-FDY;If FlowY-FDy<9 Then a:=9-FlowY;End
       Else
      If (p=71) Then
                  Begin
                   e:=-FDX;a:=-FDY;
                   If FlowX-FDx<9 Then e:=9-FlowX;
                   If FlowY-FDy<9 Then a:=9-FlowY;
                  End
                Else
      If (p=73) Then
                  Begin
                   e:=FDX;a:=-FDY;
                   If FlowX+fDx>Vision.Lx-9 Then e:=Vision.Lx-9-FlowX;
                   If FlowY-FDy<9 Then a:=9-FlowY;
                  End
                Else
      If (p=79) Then
                  Begin
                   e:=-FDX;a:=FDY;
                   If FlowX-FDx<9    Then e:=9-FlowX;
                   If FlowY+FDy>Vision.Ly-9 Then a:=Vision.Ly-9-FlowY;
                  End
                Else
      If (p=81) Then
                  Begin
                   e:=FDX;a:=FDY;
                   If FlowX+fDx>Vision.Lx-9 Then e:=Vision.Lx-9-FlowX;
                   If FlowY+FDy>Vision.Ly-9 Then a:=Vision.Ly-9-FlowY;
                  End;
         Inc(X,e);Inc(Y,a);
         Inc(FDX);Inc(FDY);
         Inline($FB);
          If MouseInitMode Then DELAY(5);
          SetPos(X,Y);
        Inc(i);
     End;
   End;
   workport;
 End;
{-------------------------------------------}
   {$F+}
  Procedure MyInt_9;InterRupt;
   Var c,Ch:char;s:string;
   Begin
    ChangeMousePos;
    Inline($9C);
    saveOldVec;
   End;
   {$F-}
{--------------------------------------------}
  Procedure Swap9Int;
   Begin
    GetIntVec($9,@SaveOldVec);
    SetIntVec($9,Addr(MyInt_9));
   End;
{--------------------------------------------}
  Procedure Restore9Int;
   Begin
    SetIntVec($9,@SaveOldVec);
   End;
{--------------------------------------------}
BEGIN
randomize;
Writeln('The Plate Disigner  Version 1.0  Copyright (c)  1992,93  Feedback.');
  OvrInit('PD.Ovr');
  OvrInitEMS;
  OvrSetBuf(OvrGetBuf+60000);
   Case Mem[$F000:$FFFE] Of
     $FF,$F9,$FD: PC_Mode:=True;
     $FE,$FC: PC_Mode:=False;
     Else  Halt;
    End;
  If registerBgiFont (@trip)<0 then halt;
  If registerBgiFont (@litt)<0 then Halt;
  If registerBgiDriver (@EgaVga)<0 then Halt;
  InitVision;
  Swap9Int;
  Show;
  InitMemory;
{  show;
  clb; }
  hide;
  Vmenu(1,1,'.');
  PutEdit;
  show;
Repeat
    ch:='.';
     c:='.';
   c:=FullKey(ch,0);
{   If c=#32 then WriteToFile(1,'Fuji.Cir'){Break}
 If ch in ['L','R','I','F','E','D','O',
           'l','r','i','f','e','d','o'] Then VMenu(1,NumberL(ch),#13);
 If (c=#68)And(ch=#0) Then VMenu(1,NumberL(' '),'.');
    getpos(i,j,mn);
 if (mn=right)Or((c in [#77,#80,#75,#72])And Alt)
     then menu(True,not vm,i,j,ch)
     else
 If mn=left  then menu(False,false,xm,ym,CH);
 If (ch='P')And BeginPlaceCode Then CompactPlacing;
 If (ch='R') Then
              Begin
              ShowMessage('','The BORIS Router Solution.');
              If Way(2,15,0,7,8,13,12,'Are You Realy Sure ?')
               Then
                Begin
              StrlPort;
              Hide;
              Restore9Int;
              GetPos(i,j,h);
              SuperRouting(FieldX,FieldY,Vision.Lx-OtsX,Vision.Ly-OtsY);
              Swap9Int;
              Vm:=True;
              VMainMenu:=True;
            {  ClearDevice;}
              SetPos(i,j);
              Hide;
              PutOts;
              Vmenu(1,1,'.');
              PutEdit;
              If BeginPlaceCode Then Begin
                                      WorkList;
                                      Field(xm,ym,xm+dmx,ym+dmy,scale)
                                     End
                                Else NoFile;
              Menu(True,Not Vm,xm,ym,ch);
              SetPos(i,j);
              Hide;
              Show;
               End;
              ShowMessage('','Interactive Mode...');
              End;
  If ch='Q' Then Begin
                  ShowMessage('','If You Wish ,You''ll Return to Dos');
   If Not Way(2,25,0,7,8,4,14,
     'You Want To Break The Program ? Are You Sure ?') Then ch:=' ' else;
                  ShowMessage('','Interactive Mode...');
                 End;
If mn=Right Then Delay(80);
  mn:=center;
  Alt:=False;
Until ch='Q';
  Restore9Int;
  DoneVision;
Gotoxy(1,22);
Writeln('The Plate Disigner  Version 1.0  Copyright (c)  1992,93  Feedback.');
End.


