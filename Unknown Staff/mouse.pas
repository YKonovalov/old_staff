UNIT Mouse;
 Interface
  Uses Dos,crt;
  Const
   {---Маски кнопок---}
   Left=$0001;
   Right=$0002;
   Center=$0004;
   {--Маски состояний кнопок----}
   PosGenged=$0001;
   LeftPress=$0002;
   LeftRel=$0004;
   RightPress=$0008;
   RightRel=$0010;
   CenterPress=$0020;
   CenterRel=$0040;
 {------------------------------------------------------}
 Type
   MaskType=Array[1..2,1..16] Of word;
 Const
       PlaceCursor:masktype=
                             (($fc3f,$fc3f,$fc3f,$fc3f,
                               $fc3f,$fc3f,$0000,$0180,
                               $0180,$0000,$fc3f,$fc3f,
                               $fc3f,$fc3f,$fc3f,$fc3f),
                             ($0000,$0180,$0180,$0180,
                              $0180,$0180,$0240,$7c3e,
                              $7c3e,$0240,$0180,$0180,
                              $0180,$0180,$0180,$0000));
        PlaceCur_A:masktype=
                            (($fe7f,$fe7f,$fe7f,$fe7f,
                              $fe7f,$fe7f,$fdbf,$03c0,
                              $03c0,$fdbf,$fe7f,$fe7f,
                              $fe7f,$fe7f,$fe7f,$fe7f),
                             ($0180,$0180,$0180,$0180,
                              $0180,$0180,$0240,$fc3f,
                              $fc3f,$0240,$0180,$0180,
                              $0180,$0180,$0180,$0180));
 {--------------------------------}
  Var    MouseInitMode,
         ShowMode:boolean;
         FlowX,FlowY:Word;
         FlowDx,FlowDy,LastPress:Byte;
  {-------------------------------------}
   Procedure InitMouse(var QB:word);
   Procedure Show;
   Procedure Hide;
   Procedure GetPos(Var x,y,b:word);
   Procedure SetPos(x,y:word);
   Procedure GetDfPos(Var Dxx,Dyy:word);
   Procedure SetXLimit(Min,Max:word);
   Procedure SetYLimit(Min,Max:word);
   Procedure SetGraphMouse(Dxx,Dyy:word; Var Image);
   Procedure PutNewImage(x,y:word);
   Procedure SetDfScale(XScale,YScale:word);
   Procedure SetLevel2Speed(Level:word);
   Procedure SetRoutine(Cm:word;Sub:pointer);
   Procedure SwapRoutine(Cm:word;Sub:pointer;
                 Var LCm:word; Var LSub:pointer);
   Function QuanPresses(B:word; Var Con,LastX,LastY:word):word;
   Function QuanReleases(B:word; Var Con,LastX,LastY:word):word;
    Function Caps_Lock :boolean;
    Procedure ActivisionCaps_Lock;
    Procedure DoneCaps_Lock;
    Procedure Clb;
    Function FullKey(var ch:char):char;
    Function MyKeyPressed:boolean;
    Procedure DosComand(st:pathstr);
  {********************************************************}
 Implementation
   Const
      G=$33;
   Var
      Reg:Registers;
  {********************************************************}
   Procedure InitMouse(var QB:word);
    Begin
     Reg.AX:=0;
     Intr(G,Reg);
    If Reg.AX=0 Then
                 Begin
                  QB:=0;
                  MouseInitMode:=False;
                 End
                Else
                 Begin
                  QB:=Reg.BX;
                  MouseInitMode:=True;
                 End;
   End;
  {---------------------------------------------------------}
   Procedure Show;
   Begin
    If MouseInitMode
     Then
      Begin
       Reg.AX:=1;
       Intr(G,Reg);
      End
    Else PutNewImage(FlowX,FlowY);
    ShowMode:=True;
   End;
  {---------------------------------------------------------}
   Procedure Hide;
   Begin
    If MouseInitMode
     Then
      Begin
       Reg.AX:=2;
       Intr(G,Reg);
      End
    Else PutNewImage(FlowX,FlowY);
    ShowMode:=False;
    End;
  {---------------------------------------------------------}
   Procedure GetPos(Var x,y,b:word);
   Begin
    If MouseInitMode
     Then
      Begin
       Reg.AX:=3;
       Intr(G,Reg); { X,Y:положение мыши}
       X:=Reg.CX;   { b:статус нажатия клавиши}
       Y:=Reg.Dx;
       B:=Reg.Bx;
       FlowX:=X;
       FlowY:=Y;
      End
     Else
      Begin
       x:=FlowX;
       y:=FlowY;
      End;
       Case LastPress Of
        1: b:=Right;
        2: b:=Left;
       End;
   End;
  {---------------------------------------------------------}
   Procedure SetPos(x,y:word);
   Begin
    If MouseInitMode
     Then
      Begin
       Reg.AX:=4;
       Reg.CX:=x;
       Reg.DX:=Y;
       Intr(G,Reg); { X,Y: новое положение мыши}
      End
    Else If ShowMode Then PutNewImage(x,y);
      FlowX:=X;
      FlowY:=Y;
   End;
  {---------------------------------------------------------}
   Function QuanPresses(b:word; Var Con,LastX,LastY:word):Word;
   Begin
     Reg.AX:=5;
     Reg.CX:=B;
     Intr(G,Reg);
     Con:=Reg.AX;
     LastX:=Reg.CX;
     LastY:=Reg.DX;
     QuanPresses:=Reg.BX;
   End;
  {---------------------------------------------------------}
   Function QuanReleases(b:word; Var Con,LastX,LastY:word):Word;
   Begin
     Reg.AX:=6;
     Reg.CX:=B;
     Intr(G,Reg);
     Con:=Reg.AX;
     LastX:=Reg.CX;
     LastY:=Reg.DX;
     QuanReleases:=Reg.BX;
   End;
  {---------------------------------------------------------}
   Procedure SetXLimit(Min,Max:word);
   Begin
     Reg.AX:=7;
     Reg.CX:=Min;
     Reg.DX:=Max;
     Intr(G,Reg);
   End;
  {---------------------------------------------------------}
   Procedure SetYLimit(Min,Max:word);
   Begin
     Reg.AX:=8;
     Reg.CX:=Min;
     Reg.DX:=Max;
     Intr(G,Reg);
   End;
  {---------------------------------------------------------}
   Procedure SetGraphMouse(Dxx,Dyy:word;Var image);
   Begin
    If MouseInitMode
     Then
      Begin
       Reg.AX:=9;
       Reg.BX:=Dxx;
       Reg.CX:=Dyy;
       Reg.DX:=Ofs(image);
       Reg.ES:=Seg(image);
       Intr(G,Reg);
      End
     Else
      Begin
      End;
   End;
  {---------------------------------------------------------}
     Procedure PutNewImage(x,y:word);
     Begin
     End;
  {---------------------------------------------------------}
   Procedure GetDfPos(Var Dxx,Dyy:word);
   Begin
     Reg.AX:=11;
     Intr(G,Reg);
     Dxx:=Reg.CX;
     Dyy:=Reg.DX;
   End;
  {---------------------------------------------------------}
   Procedure SetRoutine(Cm:word;Sub:pointer);
   Begin
     Reg.AX:=12;       { Cm: 0-вызов при перемещении}
     Reg.CX:=Cm;       {     1-при нажатии левой кнопки}
     Reg.DX:=Ofs(Sub^);{     2-при отпускании левой кнопки}
     Reg.ES:=Seg(Sub^);{     3-при Н.П.К;4-При О.П.К }
     Intr(G,Reg);      {     5-при Н.С.К;6-при О.С.К }
   End;
  {---------------------------------------------------------}
   Procedure SwapRoutine(Cm:word;Sub:pointer;
                 Var LCm:word; Var LSub:pointer);
   Begin
     Reg.AX:=20;       { Cm: 0-вызов при перемещении}
     Reg.CX:=Cm;       {     1-при нажатии левой кнопки}
     Reg.DX:=Ofs(Sub^);{     2-при отпускании левой кнопки}
     Reg.ES:=Seg(Sub^);{     3-при Н.П.К;4-При О.П.К }
     Intr(G,Reg);      {     5-при Н.С.К;6-при О.С.К }
     LCm:=Reg.CX;
     LSub:=Ptr(Reg.ES,Reg.DX);
   End;
  {---------------------------------------------------------}
   Procedure SetLevel2Speed(Level:word);
   Begin
     Reg.AX:=19;
     Reg.DX:=Level;
     Intr(G,Reg);
   End;
  {---------------------------------------------------------}
   Procedure SetDfScale(XScale,YScale:word);
   Begin
     If (XScale>=1)and(XScale<=32767)
     and(YScale>=1)and(YScale<=32767)
       Then
        Begin
         Reg.AX:=15;
         Reg.CX:=XScale;
         Reg.DX:=YScale;
         Intr(G,Reg);
        End;
   End;
{-----------------------------------------------------}
Function FullKey(var ch:char):char;
Begin
 Ch:=readkey;
 Fullkey:=ch;
 While keypressed do Fullkey:=readkey;
End;
{-------------------------------}
  Function Caps_Lock :boolean;
   Begin
    If (Mem[0:1047] and 64)=0
     Then Caps_Lock:=false
     Else Caps_Lock:=True;
   End;
{------------------------------------------------------}
  Procedure ActivisionCaps_Lock;
   Begin
        inline($FA);
    Mem[0:1047]:=Mem[0:1047] Or 64;
    Mem[0:1048]:=Mem[0:1048] Or 64;
        inline($FB);
   End;
{------------------------------------------------------}
  Procedure DoneCaps_Lock;
   Begin
        inline($FA);
    Mem[0:1047]:=Mem[0:1047] And 191;
    Mem[0:1048]:=Mem[0:1048] And 191;
        inline($FB);
   End;
{--Z-----------------------------------------------------------}
Procedure Clb;
 Begin
        inline($FA);
             MemW[0:$41A]:=MemW[0:$41C];
        inline($FB);
 End;
{---------------------------------------------}
  Function MyKeyPressed:boolean;
   Begin
    If MemW[0:$41A]<>MemW[0:$41C]
     Then MyKeyPressed:=true
     Else MyKeypressed:=false;
   End;
{-------------------------------------}
   Procedure DosComand(st:pathstr);
    Begin
     st:='/C'+st;
     SwapVectors;
     Exec(GetEnv('Comspec'),st);
     SwapVectors;
    End;
{\\\\\\ T h e  E n d  o f  M O U S E //////////}
End.