Unit Arrais;
 Interface
 Uses Dos;

{#I++++++++++++++++++++++++++++++++}
  Const
     MemErrMsg:Array[0..4]Of String=
     ('','Array Read Error.','Array Write Error.',
       'Error In Registrating Array ',
       'There''s No Enough Memory To Open Array');
     MAdrSize=256;
     SegLng=65536;{ The Max Length Of Segment }
     HeaderSize=5; {sizeof(LongInt)+1}
     Soli=4;       {sizeof(LongInt)}

   Var QuanArrais :LongInt;
       MemResult  :Byte;

       Remaider:Word;
       CurrCount:Longint;
       CurrPart:LongInt;
       CurrOfs:Word;

{#I--------------------------------}
   Procedure InitArrais;
   Procedure DoneArrais;
   Procedure OpenArray(ALength:LongInt;Dimen:Byte);
   Procedure Closearray(ArN:LongInt);
   Procedure MarkArray(ArN:LongInt;Mn:Byte);
   Procedure PutLengthOfArray(ArN:LongInt;Size:LongInt);
   Procedure PutDimenOfArray(ArN:LongInt;Dim:Byte);
   Function  MaxMemory:LongInt;
   Function  BookedMem:LongInt;
   Function  DimenOfArray(ArN:LongInt):Byte;
   Function  LengthOfArray(ArN:LongInt):LongInt;
  Function HeaderAdr(ArN:LongInt):Pointer;
  Function ChangeOfs(P:pointer;N:longint):Pointer;

   Procedure PutItem(Arn,ItemN:LongInt;By:Byte);
   Function  GetItem(Arn,ItemN:LongInt):Byte;
   Procedure PutMItem(Mn:Byte;ItemN:LongInt;By:Byte);
   Function  GetMItem(Mn:Byte;ItemN:LongInt):Byte;
   Procedure PutCmplx(Arn,ItemN:LongInt;Pr:Pointer);
   Procedure GetCmplx(Arn,ItemN:LongInt;Pr:Pointer);
   Procedure PutMCmplx(Mn:Byte;ItemN:LongInt;Pr:Pointer);
   Procedure GetMCmplx(Mn:Byte;ItemN:LongInt;Pr:Pointer);


   Procedure InitParter(Q:LongInt;P:Pointer);
   Procedure Parting;

   Procedure PushAr(Var F:file;ArN:LongInt);
   Procedure ReadAr(Var F:file);

   Procedure GimmeInfo;

 Implementation
  Var
     OrginPtr,
     EmptyPtr,
     P,RWPtr        :Pointer;
     B,D,Dim     :Byte;
     W:Word;
     LI,N,MaxM :LongInt;
      Cmp:String;
      FLength,Count,i:LongInt;
      Ar:^Byte;
      Final:Boolean;
     MarkedAdr:Array[1..MAdrSize] Of Pointer;
     MarkedDimen:Array[1..MAdrSize] Of Byte;
{**************************************************}
{    Aids For Organizing Read/Write Operations     }
{**************************************************}
 Procedure PutByte (P:pointer;b:Byte);
   Begin
    Asm
     Push ES
     Push DI
     Push Ax

     Mov Di,Word Ptr P
     Mov Es,Word Ptr P+2
     Mov al,b
     Mov Es:Byte ptr [Di],Al

     Pop Ax
     Pop DI
     Pop ES
    End;
   End;
{-----------------------------------------------}
  Function GetByte (P:pointer):Byte;
   Begin
    Asm
     Push ES
     Push DI

     Mov Di,Word Ptr P
     Mov Es,Word Ptr P+2

     Mov Al,Es:Byte Ptr [DI]
     Mov Byte Ptr B,Al

     Pop DI
     Pop ES
    End;
     GetByte:=B;
   End;
{-----------------------------------------------}
  Procedure PutLI (P:pointer;LI:LongInt);
   Label A,B,C;
   Begin
    Asm
     Push ES
     Push DI

     Mov Di,Word Ptr P
     Mov Es,Word Ptr P+2

     Mov Ax,Word Ptr Li
     Mov Bx,Word Ptr Li+2

     Mov Es:Byte Ptr [Di]  ,Al
      Inc DI
      Jnc A
      Mov Dx,Es
      Add Dh,16
      Mov Es,Dx
 A:  Mov Es:Byte Ptr [Di],Ah
      Inc DI
      Jnc B
      Mov Dx,Es
      Add Dh,16
      Mov Es,Dx
 B:  Mov Es:Byte Ptr [Di],Bl
      Inc DI
      Jnc C
      Mov Dx,Es
      Add Dh,16
      Mov Es,Dx
 C:  Mov Es:Byte Ptr [Di],Bh

     Pop DI
     Pop ES
    End;
   End;
{-----------------------------------------------}
  Function GetLI (P:pointer):LongInt;
  Label A,B,C;
   Begin
    Asm
     Push ES
     Push DI

     Mov Di,Word Ptr P
     Mov Es,Word Ptr P+2

     Mov Al,Es:Byte Ptr [Di]
     Inc DI
     Jnc A
     Mov Dx,Es
     Add Dh,16
     Mov Es,Dx
A:   Mov Ah,Es:Byte Ptr [Di]
     Inc DI
     Jnc B
     Mov Dx,Es
     Add Dh,16
     Mov Es,Dx
B:   Mov Bl,Es:Byte Ptr [Di]
     Inc DI
     Jnc C
     Mov Dx,Es
     Add Dh,16
     Mov Es,Dx
C:   Mov Bh,Es:Byte Ptr [Di]

     Mov Cx,Seg Li
     Mov Es,Cx
     Mov Di,Offset Li

     Mov Es:Word Ptr [Di]  ,Ax
     Mov Es:Word Ptr [Di+2],Bx

     Pop DI
     Pop ES
    End;
     GetLi:=Li;
   End;
{*****************************************************}
{  Internal Aids For Memory Controling                }
{*****************************************************}
  Function ChangeOfs(P:pointer;N:longint):Pointer;
  Label C;
 Begin
   Asm
     Mov Ax,Word Ptr P
     Mov Bx,Word Ptr P+2
     Mov Dx,Word Ptr N+2
     Mov cl,4
     Shl Dx,cl
     Mov Cx,Word Ptr N

     Add Ax,Cx
     Jnc C
     Add Bh,16
C:   Add Bh,Dl

     Mov Word Ptr P,Ax
     Mov Word Ptr P+2,Bx
   End;
  ChangeOfs:=P
 End;
{-----------------------------------------------}
  Function HeaderAdr(ArN:LongInt):Pointer;
  Label C1,C2,C3,A,B,C,Beg,Cont,Exit;
   Begin
      Dec(ArN);
      Li:=0;
      Asm
       Mov Ax,Word Ptr OrginPtr
       Mov Bx,Word Ptr OrginPtr+2
       Xor Cx,Cx
       Xor Dx,Dx
 Beg:
        Push Ax
         Mov Ax,Word Ptr ArN
         Cmp Word Ptr LI,Ax    { Exit Comparings}
        Pop Ax
         Jne Cont
        Push Ax
         Mov Ax,Word Ptr ArN+2
         Cmp Word Ptr Li+2,Ax
        Pop Ax
         Je  Exit
   Cont:
         Add Word Ptr Li,1     {>Inc Li}
         Jnc C1
         Inc Word Ptr Li+2     {<}
C1:
                     Mov Di,Ax
                     Mov Es,Bx
                    Push Bx
                     Mov Cl,Es:Byte Ptr [Di]
                     Inc DI
                     Jnc A
                     Mov Bx,Es
                     Add Bh,16
                     Mov Es,Bx
                A:   Mov Ch,Es:Byte Ptr [Di]
                     Inc DI
                     Jnc B
                     Mov Bx,Es
                     Add Bh,16
                     Mov Es,Bx
                B:   Mov Dl,Es:Byte Ptr [Di]
                     Inc DI
                     Jnc C
                     Mov Bx,Es
                     Add Bh,16
                     Mov Es,Bx
                C:   Mov Dh,Es:Byte Ptr [Di]

                   Pop Bx
                 {GetLi Cx:Dx}

         Add Cx,HeaderSize {  Dx.Cx+HeaderSize}
         Jnc C2
         Inc Dx

C2:             Push cx  {>  Offset Changing }
                Mov cl,4
                Shl Dx,cl
                Pop cx
            Add Ax,Cx
            Jnc C3
            Add Bh,16
C3:        Add Bh,Dl     {<}

   Jmp Beg

Exit:  Mov Word Ptr p  ,Ax
       Mov Word Ptr p+2,Bx
  End;
     HeaderAdr:=P;
End;
{=Byte=================================================}
  Procedure PutItem(Arn,ItemN:LongInt;By:Byte);
   Label c;
   Begin
    P:=HeaderAdr(Arn);
    N:=HeaderSize+ItemN-1;
    Asm
     Push ES
     Push DI

         Mov Ax,Word Ptr P
         Mov Bx,Word Ptr P+2
         Mov Cx,Word Ptr N
         Mov Dx,Word Ptr N+2
     Push cx
     Mov cl,4
     Shl Dx,cl
     Pop cx

         Add Ax,Cx
         Jnc C
         Add Bh,16
    C:   Add Bh,Dl

     Mov Di,Ax
     Mov Es,Bx
     Mov al,by
     Mov Es:Byte ptr [Di],Al

     Pop DI
     Pop ES
    End;
   End;
{-----------------------------------------------}
  Function GetItem(Arn,ItemN:LongInt):Byte;
  Label c;
   Begin
    P:=HeaderAdr(Arn);
    N:=HeaderSize+ItemN-1;
    Asm
     Push ES
     Push DI
         Mov Ax,Word Ptr P
         Mov Bx,Word Ptr P+2
         Mov Cx,Word Ptr N
         Mov Dx,Word Ptr N+2
     Push cx
     Mov cl,4
     Shl Dx,cl
     Pop cx

         Add Ax,Cx
         Jnc C
         Add Bh,16
    C:   Add Bh,Dl

     Mov Di,Ax
     Mov Es,Bx
     Mov Al,Es:Byte Ptr [DI]
     Mov Byte Ptr B,Al
   End;
   GetItem:=b;
  End;
{-------------------------------------------------------------}
  Procedure PutMItem(Mn:Byte;ItemN:LongInt;By:Byte);
   Label c;
   Begin
    P:=MarkedAdr[Mn]{HeaderAdr(Arn)};
    N:=HeaderSize+ItemN-1;
    Asm
     Push ES
     Push DI

         Mov Ax,Word Ptr P
         Mov Bx,Word Ptr P+2
         Mov Cx,Word Ptr N
         Mov Dx,Word Ptr N+2
     Push cx
     Mov cl,4
     Shl Dx,cl
     Pop cx

         Add Ax,Cx
         Jnc C
         Add Bh,16
    C:   Add Bh,Dl

     Mov Di,Ax
     Mov Es,Bx
     Mov al,by
     Mov Es:Byte ptr [Di],Al

     Pop DI
     Pop ES
    End;
   End;
{-----------------------------------------------}
  Function GetMItem(Mn:Byte;ItemN:LongInt):Byte;
  Label c;
   Begin
    P:=MarkedAdr[Mn]{HeaderAdr(Arn)};
    N:=HeaderSize+ItemN-1;
    Asm
     Push ES
     Push DI
         Mov Ax,Word Ptr P
         Mov Bx,Word Ptr P+2
         Mov Cx,Word Ptr N
         Mov Dx,Word Ptr N+2
     Push cx
     Mov cl,4
     Shl Dx,cl
     Pop cx

         Add Ax,Cx
         Jnc C
         Add Bh,16
    C:   Add Bh,Dl

     Mov Di,Ax
     Mov Es,Bx
     Mov Al,Es:Byte Ptr [DI]
     Mov Byte Ptr B,Al
   End;
   GetMItem:=b;
  End;
{=Complex=======================================================}
  Procedure PutCmplx(Arn,ItemN:LongInt;Pr:Pointer);
   Label Beg,C0,C,C1,C2;
   Begin
    Asm
     Push AX
     Push bX
     Push cX
     Push dX
     Push Di
     Push Si
     Push Es
     Push Ds
    End;
    P:=HeaderAdr(ArN);
     Asm
     Mov Di,Word Ptr P
     Mov Ax,Word Ptr P+2
     Add Di,4
     Jnc C0
     Add Ah,16
C0:  Mov Es,Ax
      Mov Bl,Es:[DI]
      Mov B,Bl
     End;
    N:=HeaderSize+(ItemN-1)*B;
    Asm
         Mov Si,Word Ptr Pr
         Mov Ds,Word Ptr Pr+2
         Mov Di,Word Ptr P         {P=>Es:Di }
         Mov Ax,Word Ptr P+2      {Pr=>Ds:Si }
         Mov Dx,Word Ptr N+2
           Mov cl,4
           Shl Dx,cl
         Mov Cx,Word Ptr N
           Add Di,Cx
           Jnc C
           Add Ah,16
      C:   Add Ah,Dl
           Mov Es,Ax
           Mov Bx,Ds
   Xor Ch,Ch
   Mov Dh,B
Beg:
     Mov Cl,Ds:[Si]
     Mov Es:[Di],Cl
         Add Di,1
         Jnc C1
         Add Ah,16
    C1:  Mov Es,Ax

         Add Si,1
         Jnc C2
         Add Bh,16
    C2:  Mov Ds,Bx
  Inc Ch
  Cmp Ch,Dh
Jnz Beg
     Pop Ds
     Pop Es
     Pop Si
     Pop Di
     Pop dX
     Pop cX
     Pop bX
     Pop AX
    End;
   End;
{-----------------------------------------------}
  Procedure GetCmplx(Arn,ItemN:LongInt;Pr:Pointer);
   Label Beg,C0,C,C1,C2;
   Begin
    Asm
     Push AX
     Push bX
     Push cX
     Push dX
     Push Di
     Push Si
     Push Es
     Push Ds
    End;
    P:=HeaderAdr(ArN);
     Asm
     Mov Di,Word Ptr P
     Mov Ax,Word Ptr P+2
     Add Di,4
     Jnc C0
     Add Ah,16
C0:  Mov Es,Ax
      Mov Bl,Es:[DI]
      Mov B,Bl
     End;
    N:=HeaderSize+(ItemN-1)*B;
    Asm
         Mov Si,Word Ptr Pr
         Mov Di,Word Ptr P         {P=>Es:Di }
         Mov Ds,Word Ptr Pr+2
         Mov Ax,Word Ptr P+2      {Pr=>Ds:Si }
         Mov Dx,Word Ptr N+2
           Mov cl,4
           Shl Dx,cl
         Mov Cx,Word Ptr N
           Add Di,Cx
           Jnc C
           Add Ah,16
      C:   Add Ah,Dl
           Mov Es,Ax
           Mov Bx,Ds
   Xor Ch,Ch
   Mov Dh,B
Beg:
     Mov Cl,Es:[Di]
     Mov Ds:[Si],Cl
         Add Di,1
         Jnc C1
         Add Ah,16
    C1:  Mov Es,Ax

         Add Si,1
         Jnc C2
         Add Bh,16
    C2:  Mov Ds,Bx
  Inc Ch
  Cmp Ch,Dh
Jnz Beg
     Pop Ds
     Pop Es
     Pop Si
     Pop Di
     Pop dX
     Pop cX
     Pop bX
     Pop AX
    End;
   End;
{-----------------------------------------------}
  Procedure PutMCmplx(Mn:Byte;ItemN:LongInt;Pr:Pointer);
   Label Beg,C0,C,C1,C2;
   Begin
    P:=MarkedAdr[Mn];
    B:=MarkedDimen[Mn];
    N:=HeaderSize+(ItemN-1)*B;
    Asm
         Mov Si,Word Ptr Pr
         Mov Ds,Word Ptr Pr+2
         Mov Di,Word Ptr P         {P=>Es:Di }
         Mov Ax,Word Ptr P+2      {Pr=>Ds:Si }
         Mov Dx,Word Ptr N+2
           Mov cl,4
           Shl Dx,cl
         Mov Cx,Word Ptr N
           Add Di,Cx
           Jnc C
           Add Ah,16
      C:   Add Ah,Dl
           Mov Es,Ax
           Mov Bx,Ds
   Xor Ch,Ch
   Mov Dh,B
Beg:
     Mov Cl,Ds:[Si]
     Mov Es:[Di],Cl
         Add Di,1
         Jnc C1
         Add Ah,16
    C1:  Mov Es,Ax

         Add Si,1
         Jnc C2
         Add Bh,16
    C2:  Mov Ds,Bx
  Inc Ch
  Cmp Ch,Dh
Jnz Beg
    End;
   End;
{-----------------------------------------------}
  Procedure GetMCmplx(Mn:Byte;ItemN:LongInt;Pr:Pointer);
   Label Beg,C0,C,C1,C2;
   Begin
    P:=MarkedAdr[Mn];
    B:=MarkedDimen[Mn];
    N:=HeaderSize+(ItemN-1)*B;
    Asm
         Mov Si,Word Ptr Pr
         Mov Di,Word Ptr P         {P=>Es:Di }
         Mov Ds,Word Ptr Pr+2
         Mov Ax,Word Ptr P+2      {Pr=>Ds:Si }
         Mov Dx,Word Ptr N+2
           Mov cl,4
           Shl Dx,cl
         Mov Cx,Word Ptr N
           Add Di,Cx
           Jnc C
           Add Ah,16
      C:   Add Ah,Dl
           Mov Es,Ax
           Mov Bx,Ds
   Xor Ch,Ch
   Mov Dh,B
Beg:
     Mov Cl,Es:[Di]
     Mov Ds:[Si],Cl
         Add Di,1
         Jnc C1
         Add Ah,16
    C1:  Mov Es,Ax

         Add Si,1
         Jnc C2
         Add Bh,16
    C2:  Mov Ds,Bx
  Inc Ch
  Cmp Ch,Dh
Jnz Beg
    End;
   End;
{-----------------------------------------------}
   Function QuanBytes(P1,P2:Pointer):LongInt;
   Var l:LongInt;
    Begin
     l:=(hi(Seg(p2^)) Shr 4-hi(Seg(p1^)) Shr 4)*SegLng;
     QuanBytes:=l+Ofs(p2^)-Ofs(p1^)+1;
    End;
   {------------------------------------------------}
  Procedure Carry(BPtr,EPtr:Pointer;N:LongInt);
   Var d:longInt;
   Begin
    D:=QuanBytes(BPtr,EPtr);
    For Li:=0 to N do
     Begin
      RWPtr:=ChangeOfs(Bptr,Li);
      p:=ChangeOfs(EPtr,Li);
      PutByte(RWPtr,GetByte(p));
     End;
   End;
{-----------------------------------------------}
  Procedure EraseArray(ArN:LongInt);
   Begin
    p:=HeaderAdr(ArN+1);
    Carry(HeaderAdr(ArN),p,
          QuanBytes(p,EmptyPtr));
   End;
{================================}
  Procedure InitArrais;
   Begin
    OrginPtr:=HeapPtr;
    EmptyPtr:=OrginPtr;
{    MarkedAdr[1]:=OrginPtr;}
    QuanArrais:=0;
    MaxM:=MemAvail;
    MemResult:=0;
   End;
{-----------------------------------------------}
  Procedure DoneArrais;
   Begin
    Mark(OrginPtr);
    Release(OrginPtr);
   End;
{-----------------------------------------------}
  Function MaxMemory:LongInt;
   Begin
    MaxMemory:=MaxM-QuanBytes(OrginPtr,EmptyPtr)-1;
   End;
{-----------------------------------------------}
  Function BookedMem:LongInt;
   Begin
    BookedMem:=QuanBytes(OrginPtr,EmptyPtr)-1;
   End;
{-----------------------------------------------}
  Function DimenOfArray(ArN:LongInt):Byte;
  Begin
   DimenOfArray:=GetByte(ChangeOfs(HeaderAdr(ArN),Soli));
  End;
{-----------------------------------------------}
 Procedure PutDimenOfArray(ArN:LongInt;Dim:Byte);
  Begin
   PutByte(ChangeOfs(HeaderAdr(ArN),Soli),Dim);
  End;
{-----------------------------------------------}
 Procedure PutLengthOfArray(ArN:LongInt;Size:LongInt);
   Begin
    PutLi(HeaderAdr(Arn),Size);
   End;
{-------------------------------------------------}
  Function LengthOfArray(ArN:LongInt):Longint;
  Begin
   LengthOfArray:=Getli(HeaderAdr(ArN));
  End;
{-----------------------------------------------}
 Procedure MarkArray(ArN:LongInt;Mn:Byte);
  Begin
   MarkedAdr[Mn]:=HeaderAdr(ArN);
   MarkedDimen[Mn]:=GetByte(ChangeOfs(MarkedAdr[Mn],Soli));
  End;
{-----------------------------------------------}
  Procedure OpenArray(ALength:LongInt;Dimen:Byte);
   Begin
   If (Alength=0)Or(Dimen=0) Then
                  Begin
                   MemResult:=3;
                   Exit;
                  End;
   If Alength*Dimen+HeaderSize>MaxMemory Then
                                    Begin
                                     MemResult:=4;
                                     Exit;
                                    End;
     GetMem(p,Alength*Dimen+HeaderSize);
     Inc(QuanArrais);
     PutLI(EmptyPtr,Alength*Dimen);
     EmptyPtr:=ChangeOfs(EmptyPtr,Soli);
     PutByte(EmptyPtr,Dimen);
     EmptyPtr:=ChangeOfs(EmptyPtr,Alength*Dimen+1);
     MemResult:=0;
   End;
{---------------------------------------------}
  Procedure Closearray(ArN:LongInt);
   Begin
    EraseArray(ArN);
    Dec(QuanArrais);
   End;
{==Parter====================================}
   Procedure InitParter(Q:LongInt;P:Pointer);
    Begin
     CurrCount:=Q;
     CurrOfs:=Ofs(p^);
    End;
 {-------------------------------------------}
   Procedure Parting;
    Begin
    If CurrOfs=0 Then W:=1
                 Else W:=Not CurrOfs+1;
     Remaider:=W;{65535-CurrOfs;{Not CurrOfs+1}
     If CurrCount>Remaider Then CurrPart:=Remaider
                           Else CurrPart:=CurrCount;
     Dec(CurrCount,CurrPart);
     W:=CurrPart;
     Inc(CurrOfs,W);
    End;
{====================================================}
Procedure PushAr(Var F:file;ArN:LongInt);
Begin
  Ar:=HeaderAdr(Arn);
 Count:=LengthOfArray(Arn);
  InitParter(Count+HeaderSize,Ar);
  Repeat
       Parting;
     {$I-}
    BlockWrite(F,Ar^,CurrPart);
     {$I+}
    If IoResult<>0 Then Begin MemResult:=2;Exit End;
     Ar:=ChangeOfs(Ar,CurrPart);
  Until CurrCount=0;
   MemResult:=0;
End;
{---------------------------------------------------}
Procedure ReadAr(Var F:file);
Begin
     {$I-}
   BlockRead(F,Count,4);
   BlockRead(F,Dim,1);
     {$I+}
    If (IoResult<>0)Or(Dim=0) Then Begin MemResult:=1;Exit End;
   OpenArray(Count Div Dim,Dim);
    If MemResult<>0 Then Exit;
   Seek(F,FilePos(F)-HeaderSize);
  Ar:=HeaderAdr(QuanArrais);
  InitParter(Count+HeaderSize,Ar);
  Repeat
       Parting;
     {$I-}
    BlockRead(F,Ar^,CurrPart);
     {$I+}
    If IoResult<>0 Then Begin MemResult:=1;Exit End;
     Ar:=ChangeOfs(Ar,CurrPart);
  Until CurrCount=0;
   MemResult:=0;
End;
{--------------------------------------------------------------------}
Procedure GimmeInfo;
 Var AdrWr:Pointer;
 Begin
  Writeln('Available Memory : ',MaxMemory);
  Writeln('Booked Memory : ',BookedMem);
  Writeln('Quantity Of Arrais : ',QuanArrais);
   For i:=1 to QuanArrais Do
   Begin
   If i Mod 20=0 Then Readln;
   Adrwr:=HeaderAdr(i);
  Writeln('Arrais Number : ',i,
          'Length : ',LengthOfArray(i) Div DimenOfArray(i),
          'Item Dimention : ',DimenOfArray(i),'   ',
           Seg(Adrwr^),':',Ofs(AdrWr^));
   End;
 End;
End.{\\\\\\\\\\\\\\T h e  E n d  O f  A R R A I S///////////////////}
