UNIT Control;
 Interface
  Uses Dos,crt,Graph;
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
   CurInfo=Record
            CurForm:MaskType;
            OfsX,OfsY:Byte;
           End;
 Const
       Bits:Array[1..16] Of Word =
        ($8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,
         $0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001);
       PlaceCur :CurInfo=
                (Curform:
                             (($fc3f,$fc3f,$fc3f,$fc3f,
                               $fc3f,$fc3f,$0000,$0180,
                               $0180,$0000,$fc3f,$fc3f,
                               $fc3f,$fc3f,$fc3f,$fc3f),
                             ($0000,$0180,$0180,$0180,
                              $0180,$0180,$0240,$7c3e,
                              $7c3e,$0240,$0180,$0180,
                              $0180,$0180,$0180,$0000));
                OfsX:8;
                OfsY:8);
      MenuCur :CurInfo=
                (Curform:
                             (($3fff,$0fff,$83ff,$80ff,
                               $c03f,$c01f,$e03f,$e03f,
                               $f01f,$f00f,$fb07,$ff83,
                               $ffc1,$ffe0,$fff1,$fffb),
                             ($0000,$4000,$3000,$3c00,
                              $1f00,$1fc0,$0f80,$0f80,
                              $07c0,$04e0,$0070,$0038,
                              $001c,$000e,$0004,$0000));
                OfsX:0;
                OfsY:0);

 {--------------------------------}
  Var    MouseInitMode,
         ShowMode:boolean;
         FlowCur:CurInfo;
         FlowX,FlowY:Word;
         FlowDx,FlowDy,LastPress:Byte;
         Point:Pointer;
{-------------------------------------}
   Procedure InitMouse(var QB:word);
   Procedure Show;
   Procedure Hide;
   Procedure GetPos(Var x,y,b:word);
   Procedure SetPos(x,y:word);
   Procedure SetXLimit(Min,Max:word);
   Procedure SetYLimit(Min,Max:word);
   Procedure SetGraphMouse(Dxx,Dyy:word; Var Image:MaskType);
    Function Caps_Lock :boolean;
    Function Alt:Boolean;
    Function Ctrl:boolean;
    Procedure ActivisionCaps_Lock;
    Procedure DoneCaps_Lock;
    Procedure Clb;
    Function FullKey(var ch:char):char;
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
                   closeGraph;
                   textcolor(12);
                   Writeln (' Mouse Driver Is Not Instaled ..');
                   Writeln (' Please Instal Mouse From Dos . ');
                  delay(5000);
                   halt;
                 End
                Else
                 Begin
                  DirectVideo:=true;
                  QB:=Reg.BX;
                  MouseInitMode:=True;
                 End;
   End;
{---------------------------------------------------------}
   Procedure Show;
    Var i,j,z,k:Byte;
   Begin
    If MouseInitMode
     Then
      Begin
       Reg.AX:=1;
       Intr(G,Reg);
      End
    Else
     Begin
     With FlowCur Do
      Begin
      GetMem(Point,ImageSize(FlowX-OfsX,FlowY-OfsY,
                   FlowX-OfsX+16,FlowY-OfsY+16));
      GetImage(FlowX-OfsX,FlowY-OfsY,FlowX-OfsX+16,FlowY-OfsY+16,Point^);
      For I:=1 to 16 do
       For j:=1 To 16 do
       Begin
        IF CurForm[1,i] AND Bits[j]=0  Then z:=0
                                       Else z:=15;
        IF CurForm[2,i] AND Bits[j]=Bits[j]  Then k:=15
                                             Else k:=0;
        PutPixel(FlowX-OfsX+J,FlowY-OfsY+i,
         (GetPixel(FlowX-OfsX+j,FlowY-OfsY+i) AND Z) XOR k);
       End;
      End;
     End;
    ShowMode:=True;
   End;
{---------------------------------------------------------}
   Procedure Hide;
    Var i,j,k,z:Byte;
   Begin
    If MouseInitMode
     Then
      Begin
       Reg.AX:=2;
       Intr(G,Reg);
      End
    Else
     If ShowMode Then
      With FlowCur Do
       Begin
      PutImage(FlowX-OfsX,FlowY-OfsY,Point^,normalput);
      FreeMem(Point,ImageSize(FlowX-OfsX,FlowY-OfsY,
              FlowX-OfsX+16,FlowY-OfsY+16));
       End;
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
        Else If MouseInitMode Then B:=Reg.BX
                              Else b:=0;
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
    Else
     If ShowMode Then Hide;
      FlowX:=X;
      FlowY:=Y;
       Show;
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
   Procedure SetGraphMouse(Dxx,Dyy:word;Var image:MaskType);
   Begin
    If MouseInitMode
     Then
      Begin
       Inline($FA);
       Reg.AX:=9;
       Reg.BX:=Dxx;
       Reg.CX:=Dyy;
       Reg.DX:=Ofs(image);
       Reg.ES:=Seg(image);
       Inline($FB);
       Intr(G,Reg);
      End
     Else
       With FlowCur Do
         Begin
          CurForm:=Image;
          OfsX:=Dxx;
          OfsY:=Dyy;
         End;
   End;
{---------------------------------------------------------}
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
{-------------------------------}
  Function Alt:boolean;
   Begin
    If (Mem[0:1047] and 16)=0
     Then Alt:=false
     Else Alt:=True;
   End;
{-------------------------------}
  Function Ctrl:boolean;
   Begin
    If (Mem[0:1047] and 32)=0
     Then Ctrl:=false
     Else Ctrl:=True;
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
{\\\\\\ T h e  E n d  o f  M O U S E //////////}
End.