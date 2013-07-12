{$O+}
{$F+}
UNIT DISC;
  INTERFACE
 Uses Memory,Arrais,Dos;
 Const
      FileHeader:Record
               D,C:String[53];
                 End=
   (D:(' The PICD 1.0 Binary Disposition File. Circuit Name: ');
    C:(' The PICD 1.0 Binary Circuit File. Circuit Name: '));
     DiscErrMsg:Array[0..18]Of String[38]=
     ((''),('Can''t Open The File'),
      ('Non Recognizing File Structure.'),
      ('Wrong File Type Status.'),
      ('Can''t Read "BE" Name List.'),
      ('Can''t Read Disposition.'),
      ('Can''t Read "BE" Sign.'),
      ('Can''t Read First "BE" Gabarit List.'),
      ('Can''t Read Second "BE" Gabarit List.'),
      ('Can''t Read Chain Name List.'),
      ('Can''t Read List Of Chains.'),
      ('There''s No Enough Room To Saving'),
      ('Can''t Write "BE" Name List .'),
      ('Can''t Write Disposition.'),
      ('Can''t Write "BE" Sign.'),
      ('Can''t Write First "BE" Gabarit List.'),
      ('Can''t Write Second "BE" Gabarit List.'),
      ('Can''t Write Chain Name List.'),
      ('Can''t Write List Of Chains.'));
Const
 QLib=12;
 ResW:Array[1..6]Of String[7]=
  (('CIRCUIT'),('USES'),('TYPE'),('ELEMENT'),('CHAIN'),('END'));
 ResC:Array[0..13]Of Char=
  (('.'),(','),(';'),(':'),('='),('^'),('/'),
   ('['),(']'),('{'),('}'),('('),(')'),(' '));
 CompErrMsg:Array[1..30]Of String[36]=
  (('Can''t open the file.'),('CIRCUIT expected.'),
   ('Identifier Name is Two Long.'),('Circuit name expected.'),
   ('Unknown identifier.'),('";" expected'),
   ('USES expected'),('ELEMENT expected'),
   ('"}" expected'),('"," expected'),
   ('Library name expected'),('Library Name is Two Long'),
   ('Element name expected'),('Element Name is Two Long'),
   ('":" expected'),('"[" expected'),('"/" expected'),('"]" expected'),
   ('Digit expected'),('CHAIN expected'),
   ('Chain name expected'),('Chain name is two long'),
   ('Unknown element name'),('")" expected'),
   ('"(" expected'),('Duplicated element contact'),
   ('"^" expected'),('Duplicated name of element'),
   ('!!! expected'),('Error In Registrating Of Array')
   );
Type
   Ter=Set of Byte;
Var
  CompErr:Byte;
  CirName:String;
  ExistNumb:Word;
  QEIC:Array[1..1000]Of Word;
  LibName:Array[1..QLib]Of String[8];
  Chains:Array[1..50,1..50]Of Record
                                ElemNumber:Word;
                                ElemCont:Byte;
                              End;
  LineNumber:Word;
  Column:Byte;
  Level:Byte;

 Var F:File;
     Ft:Text;
     Byw:Word;
     CirN:String[12];
     DiscResult:Byte;
Procedure WriteToFile(Mode:byte;s:PathStr);
Procedure ReadFile(Mode:Byte;s:PathStr);
Procedure Compilr(st:pathstr);
 {----------------}
  IMPLEMENTATION
 Var
    i,j,k:word;
    b,v:boolean;
    C:Char;
    Stf:String[65];
    Stp:^String;
Var
  Tf:Text;
  En,Tz,s,Rc,Reserved:String;
  LastLine:Boolean;
  II,Ig,By:Byte;
{----------------------------------}
Procedure WriteToFile(Mode:byte;s:PathStr);
Label Off;
Begin
DiscResult:=0;
 assign(f,s);
 rewrite(f,1);
 If Mode=2 Then Stf:=FileHeader.D+CirN
           Else Stf:=FileHeader.C+CirN;
   Stp:=@Stf;
    {$I-}
 blockwrite(f,Stp^,65);
    {$I+}
if IOResult<>0 Then Begin DiscResult:=11;Exit End;
    PushAr(F,1); If MemResult<>0 Then Begin DiscResult:=12;Goto Off End;
 If Mode=2
  Then
   Begin
    PushAr(F,2); If MemResult<>0 Then Begin DiscResult:=13;Goto Off End;
    PushAr(F,3); If MemResult<>0 Then Begin DiscResult:=14;Goto Off End;
   End;
    PushAr(F,4); If MemResult<>0 Then Begin DiscResult:=15;Goto Off End;
    PushAr(F,5); If MemResult<>0 Then Begin DiscResult:=16;Goto Off End;
    PushAr(F,6); If MemResult<>0 Then Begin DiscResult:=17;Goto Off End;
 For i:=1 To NumberOfChain Do
  Begin
   PushAr(F,10+i);
    If MemResult<>0 Then Begin DiscResult:=18;Goto Off End;
  End;
Off: close(f);
End;
{----------------------------------}
Procedure ReadFile(Mode:Byte;s:PathStr);
Label Off;
Begin
DiscResult:=0;
assign(f,s);
{$I-}
reset(f,1);
{$I+}
if IOResult<>0 Then Begin DiscResult:=1;Exit End;
   Stp:=@Stf;
        {$I-}
    blockread(f,Stp^,65);
        {$I+}
 If IOResult<>0 Then DiscResult:=2;
 If Not(((Pos(FileHeader.D,Stf)<>0)And(Mode=2))OR
        ((Pos(FileHeader.C,Stf)<>0)And(Mode=1)))
      then begin s:='0';DiscResult:=3; exit end;
      s:=Stf;
      Delete(S,1,Pos(': ',S)+1);
      CirN:=s;
    ReadAr(F);  If MemResult<>0 Then Begin DiscResult:=4;Goto Off End;

    NumberOfElem:=LengthOfArray(1) Div DimenOfArray(1);
If Mode=2 then
   Begin
    ReadAr(F);  If MemResult<>0 Then Begin DiscResult:=5;Goto Off End;
    ReadAr(F);  If MemResult<>0 Then Begin DiscResult:=6;Goto Off End;
   End
          Else
   Begin
      OpenArray(NumberOfElem,2);
      OpenArray(NumberOfElem,1);
   End;
    ReadAr(F);  If MemResult<>0 Then Begin DiscResult:=7;Goto Off End;
    ReadAr(F);  If MemResult<>0 Then Begin DiscResult:=8;Goto Off End;
    ReadAr(F);  If MemResult<>0 Then Begin DiscResult:=9;Goto Off End;
   NumberOfChain:=LengthOfArray(6) Div DimenOfArray(6);
       OpenArray(16,2);
       OpenArray(16,2);
       OpenArray(NumberOfElem,6);
       OpenArray(NumberOfElem,2);
 For i:=1 To NumberOfChain Do
    Begin
     ReadAr(F);
      If MemResult<>0 Then Begin DiscResult:=10;Goto Off End;
     End;
Off:  close(f)
End;
{=Compiler--------------------}

Procedure Readlny(Var f:Text;Var S:String);
 Label 5;
 Begin
 If LastLine Then Begin CompErr:=100;Goto 5;End;
  Readln(F,S);
  If Eof(f) Then LastLine:=True;
5:Column:=0;
  Inc(LineNumber);
 End;
{-----------------------------------------------}
Function ProUpCase(S:String):String;
 Begin
     For i:=1 To Length(s) do s[i]:=UpCase(s[i]);
   ProUpCase:=s;
 End;
{-----------------------------------------------}
Procedure Coment;
Var i:Word;
 Begin
    Inc(Column);
  Repeat
     While Rc='' do ReadLny(Tf,Rc);
    i:=1;
     For i:=1 to Length(Rc) Do If Rc[i]<>' ' Then Break;
     Delete(Rc,1,i-1);
   If Rc[1]<>'{' Then Exit;
       Repeat;
        i:=Pos('}',Rc);
        If i<>0 Then Break;
          Readlny(Tf,rc);
            If CompErr<>0 Then
              Begin
               CompErr:=9;
               Exit;
              End;
       Until False;
        Inc(Column,i);
        Delete(Rc,1,i);
  Until False;
 End;
{-----------------------------------------------}
Function PassAllSpaces(S:String):String;
 Begin
    i:=1;
     For i:=1 to Length(s) Do If s[i]<>' ' Then Break;
     Delete(s,1,i-1);
     PassAllSpaces:=s;
     Inc(Column,i-1);
     Coment;
 End;
{-----------------------------------------------}
Function SelectWord:String;
 Var i,j,posy,len:Byte;
     Zp:Array[0..13]Of Byte;
 {-2b--------------------------}
 Function MinN0(St:Ter):Byte;
 Var i:Integer;
  Begin
   For i:=0 to 255 Do If i in st Then If i<>0 Then Break;
   If i=255 Then i:=0;
   MinN0:=i
  End;
 {-2e--------------------------}
 Begin
     Len:=Length(Rc);
     i:=1;
     For i:=1 to Len Do If Rc[i]<>' ' Then Break;
     Delete(Rc,1,i-1);
       Zp[0]:=Length(Rc)+1;
       For j:=1 to 13 do Zp[j]:=Pos(ResC[j],Rc);
       Posy:=MinN0([Zp[1],zp[2],Zp[3],zp[4],Zp[5],zp[6],zp[13],
                    Zp[7],zp[8],Zp[9],zp[10],Zp[11],zp[12],zp[0]]);
       If Posy=1 Then
         begin
          SelectWord:=UpCase(Rc[1]);
          Delete(Rc,1,1);
          Exit;
         end;
       If Posy<>0
        Then
         Begin
          SelectWord:=ProUpCase(Copy(Rc,1,Posy-1));
          Delete(Rc,1,Posy-1)
         End
        Else
         Begin
          Posy:=Length(Rc)+1;
          SelectWord:='';
          rc:='';
         End;
      Inc(Column,Posy+i-2);
 End;
{-----------------------------------------------}
Function TwoLong(s:string;len,Err:Byte):Boolean;
 Begin
  TwoLong:=False;
  If Length(s)>len Then
   Begin
    CompErr:=Err;
    Close(TF);
    TwoLong:=True;
    Dec(Column,Length(s) Div 2);
   End;
 End;
{-----------------------------------------------}
Function UnEqual(S,SC:String;Err:Byte):Boolean;
 Begin
  UnEqual:=False;
  If s=sc Then Exit;
  CompErr:=Err;
  Close(TF);
  Dec(Column,Length(S) Div 2);
  UnEqual:=True;
 End;
{-----------------------------------------------}
Function ReadWord:String;
Begin
   Coment;
   While Rc='' Do
          Begin
            Readlny(Tf,Rc);
            If CompErr<>0 Then Exit;
            Coment;
          End;
   ReadWord:=SelectWord;
End;
{-----------------------------------------------}
Function ErrOcur(Err:Byte;s:String):Boolean;
Begin
 ErrOcur:=True;
 If CompErr=100 Then CompErr:=Err;
 If CompErr=0 Then Begin ErrOcur:=False;Exit;End;
 Dec(Column,Length(S) Div 2);
 Close(TF);
End;
{-----------------------------------------------}
Function NotExist(St:string;Err:Byte):Boolean;
 Var i:Word;
Begin
 For i:=1 to NumberOfElem Do If ElemName(i)=st Then
                Begin
                  ExistNumb:=i;
                  NotExist:=False;
                  Exit;
                End;
 NotExist:=True;
 CompErr:=Err;
 Writeln;
 Writeln(st,'   ',NumberOfElem);
 Dec(Column,Length(St) Div 2);
 Close(TF);
End;
{-----------------------------------------------}
Function Duble(En,Con,Ch,Qe,Err:Word):Boolean;
Var i:Word;
Begin
 For i:=1 To Qe Do If ElemNumber(ch,i)=En Then
                If Chains[ch,i].ElemCont=Con Then
                 Begin
                  CompErr:=Err;
                  Duble:=True;
                  Close(TF);
                  Exit;
                 End;
 Duble:=False;
End;
{-----------------------------------------------}
Function DubleName(Name:String;Qn,Err:Word):Boolean;
Var i:Word;
Begin
 For i:=1 To Qn Do If ElemName(i)=Name Then
               Begin
                  CompErr:=Err;
                  DubleName:=True;
                  Close(TF);
                  Exit;
               End;
 DubleName:=False;
End;
{-----------------------------------------------}
Function NotDigit(S:String;Var B:Byte;Err:Byte):Boolean;
Var e:Integer;
Begin
 NotDigit:=False;
  Val(S,B,E);
  If E=0 Then Exit;
 CompErr:=Err;
 NotDigit:=True;
 Dec(Column,Length(S) Div 2);
 Close(TF);
End;
{-----------------------------------------------}
  Function ArResFail(ALength:LongInt;Dimen:Byte):Boolean;
   Begin
     ArResFail:=True;
     CompErr:=30;
    OpenArray(ALength,Dimen);
    If MemResult=0 Then
     Begin
      ArResFail:=False;
      CompErr:=0;
     End;
   End;
{---------------------------------------------}
Procedure ScanInfo;
Label 1;
Var St:String;
 Begin
  { Processing Of The 1-st Level}
Reserved:=ReadWord;
If ErrOcur(2,Reserved) Then Exit;
If  UnEqual(Reserved,ResW[1],2) Then Exit;
CirName:=ReadWord;
If ErrOcur(4,CirName) Then Exit;
If TwoLong(CirName,8,3) Then Exit;
TZ:=ReadWord;
If ErrOcur(6,Tz) Or UnEqual(Tz,';',6) Then  Exit;
  { Processing Of The 2-nd Level}
Reserved:=ReadWord;
If ErrOcur(7,Reserved) Then Exit;
If UnEqual(Reserved,ResW[2],7) Then Exit;
   For ig:=1 To 50 do
    Begin
     LibName[ig]:=ReadWord;
       If ErrOcur(11,LibName[ig])Or TwoLong(libName[ig],8,12) Then Exit;
     Tz:=ReadWord;
     If ErrOcur(6,Tz) Then Exit;
     If Tz<>','Then Break;
    End;
      If UnEqual(Tz,';',6) Then Exit;
  { Processing Of The 3-rd Level}
  { Processing Of The 4-rd Level}
Reserved:=ReadWord;
If ErrOcur(8,Reserved) Then Exit;
If UnEqual(Reserved,ResW[4],8) Then Exit;
   For ig:=1 To 255 do
    Begin
     St:=ReadWord;
       If ErrOcur(13,St)Then Exit;

   If (St=ResW[5])And(Ig<>1) Then Break;

     Tz:=ReadWord;
     If ErrOcur(15,Tz)Or UnEqual(Tz,':',15) Then Exit;

     Tz:=ReadWord;
     If ErrOcur(16,Tz)Or UnEqual(Tz,'[',16) Then Exit;

     S:=ReadWord;
       If ErrOcur(19,S)Or NotDigit(S,By,19) Then Exit;

     Tz:=ReadWord;
     If ErrOcur(17,Tz)Or UnEqual(Tz,'/',17) Then Exit;

     S:=ReadWord;
       If ErrOcur(19,S)Or NotDigit(S,By,19) Then Exit;

     Tz:=ReadWord;
     If ErrOcur(18,Tz)Or UnEqual(Tz,']',18) Then Exit;

     Tz:=ReadWord;
     If ErrOcur(6,Tz)Or UnEqual(Tz,';',6) Then Exit;

    End;
     NumberOfElem:=Ig;
  If (St<>ResW[5])And(ig=255) Then
      Begin
       CompErr:=20;
       Close(TF);
       Dec(Column,Length(St) Div 2);
       Exit;
      End;
   If ig=1 Then
      Begin
       CompErr:=13;
       Close(TF);
       Dec(Column,Length(St) Div 2);
       Exit;
      End;
  { Processing Of The 5-th Level}
   For ig:=1 To 50 do
    Begin
     St:=ReadWord;
       If ErrOcur(21,St) Then Exit;

   If St=ResW[6] Then Break;

     Tz:=ReadWord;
     If ErrOcur(25,Tz)Or UnEqual(Tz,'(',25) Then Exit;

    For ii:=1 To 50 do
     Begin
        En:=ReadWord;
          If ErrOcur(13,En)Then Exit;

        Tz:=ReadWord;
        If ErrOcur(27,Tz)Or UnEqual(Tz,'^',27) Then Exit;

        S:=ReadWord;
          If ErrOcur(19,S) Then Exit;

        Tz:=ReadWord;
         If ErrOcur(17,Tz) then Exit;
         If Tz=')' Then Break;
         If UnEqual(Tz,',',17) Then Exit;
     End;
      Qeic[ig]:=ii;
     Tz:=ReadWord;
     If ErrOcur(6,Tz)Or UnEqual(Tz,';',6) Then Exit;
    End;
     NumberOfChain:=ig-1;
{------Regisrtrations--------}
   If ArResFail(NumberOfElem,SizeOf(LikeName)) Then Exit;
   If ArResFail(1,1)Then Exit;
   If ArResFail(1,1)Then Exit;
   If ArResFail(NumberOfElem,1) Then Exit;
   If ArResFail(NumberOfElem,1) Then Exit;
   If ArResFail(NumberOfChain,SizeOf(LikeName)) Then Exit;
   If ArResFail(1,1) Then Exit;
   If ArResFail(1,1) Then Exit;
   If ArResFail(1,1) Then Exit;
   If ArResFail(1,1) Then Exit;
   For i:=1 to NumberOfChain do
      If ArResFail(QEIC[i],2) Then Exit;
{----End Of Regisrtrations---}

 End;
{---------------------------------------------}
Procedure Compilr(st:pathstr);
Label 1;
 Begin
  Assign(TF,st);
  {$I-}
  Reset(TF);
  {$I+}
 If IOResult<>0 then Begin CompErr:=1;Exit End;
     LineNumber:=0;
    InitMemory;
    ScanInfo;
    Reset(Tf);
     LastLine:=False;
     LineNumber:=0;
  { Processing Of The 1-st Level}
Reserved:=ReadWord;
If ErrOcur(2,Reserved) Then Exit;
If  UnEqual(Reserved,ResW[1],2) Then Exit;
CirName:=ReadWord;
If ErrOcur(4,CirName) Then Exit;
If TwoLong(CirName,8,3) Then Exit;
TZ:=ReadWord;
If ErrOcur(6,Tz) Or UnEqual(Tz,';',6) Then  Exit;
  { Processing Of The 2-nd Level}
Reserved:=ReadWord;
If ErrOcur(7,Reserved) Then Exit;
If UnEqual(Reserved,ResW[2],7) Then Exit;
   For ig:=1 To QLib do
    Begin
     LibName[ig]:=ReadWord;
       If ErrOcur(11,LibName[ig])Or TwoLong(libName[ig],8,12) Then Exit;
     Tz:=ReadWord;
     If ErrOcur(6,Tz) Then Exit;
     If Tz<>','Then Break;
    End;
      If UnEqual(Tz,';',6) Then Exit;
  { Processing Of The 3-rd Level}
  { Processing Of The 4-rd Level}
Reserved:=ReadWord;

If ErrOcur(8,Reserved) Then Exit;
If UnEqual(Reserved,ResW[4],8) Then Exit;

   For ig:=1 To NumberOfElem*2 do
    Begin
     S:=ReadWord;
   If S=ResW[5] Then Break;
     PutElemName(ig,s);
       If ErrOcur(13,ElemName(ig))Or TwoLong(ElemName(ig),8,14)
          Or DubleName(ElemName(ig),ig-1,28) Then Exit;


     Tz:=ReadWord;
     If ErrOcur(15,Tz)Or UnEqual(Tz,':',15) Then Exit;

     Tz:=ReadWord;
     If ErrOcur(16,Tz)Or UnEqual(Tz,'[',16) Then Exit;

     S:=ReadWord;
       If ErrOcur(19,S)Or NotDigit(S,By,19) Then Exit;
        PutGab(1,Ig,by);

     Tz:=ReadWord;
     If ErrOcur(17,Tz)Or UnEqual(Tz,'/',17) Then Exit;

     S:=ReadWord;
       If ErrOcur(19,S)Or NotDigit(S,By,19) Then Exit;
        PutGab(2,ig,by);

     Tz:=ReadWord;
     If ErrOcur(18,Tz)Or UnEqual(Tz,']',18) Then Exit;

     Tz:=ReadWord;
     If ErrOcur(6,Tz)Or UnEqual(Tz,';',6) Then Exit;

    End;
  If (S<>ResW[5])And(ig=NumberOfElem) Then
      Begin
       CompErr:=20;
       Close(TF);
       Dec(Column,Length(Elemname(ig)) Div 2);
       Exit;
      End;
   If ig=1 Then
      Begin
       CompErr:=13;
       Close(TF);
       Dec(Column,Length(Elemname(ig)) Div 2);
       Exit;
      End;
  { Processing Of The 5-th Level}
   ig:=0;
   Repeat Inc(ig);
     s:=ReadWord;

   If S=ResW[6] Then Break;

     PutChainName(ig,s);
       If ErrOcur(21,S)Or TwoLong(S,8,22) Then Exit;


     Tz:=ReadWord;
     If ErrOcur(25,Tz)Or UnEqual(Tz,'(',25) Then Exit;
     ii:=0;
     Repeat Inc(ii);
        En:=ReadWord;
          If ErrOcur(13,En)Or TwoLong(En,8,14) Then Exit;
          If NotExist(En,23) Then Exit;
           PutElemNumber(ig,ii,ExistNumb);

        Tz:=ReadWord;
        If ErrOcur(27,Tz)Or UnEqual(Tz,'^',27) Then Exit;

        S:=ReadWord;
          If ErrOcur(19,S)Or NotDigit(S,Chains[ig,ii].ElemCont,19) Then Exit;
          If Duble(ExistNumb,Chains[ig,ii].ElemCont,ig,ii-1,26) Then Exit;

        Tz:=ReadWord;
         If ErrOcur(17,Tz) then Exit;
         If Tz=')' Then Break;
         If UnEqual(Tz,',',17) Then Exit;
     Until False;
     Tz:=ReadWord;
     If ErrOcur(6,Tz)Or UnEqual(Tz,';',6) Then Exit;
   Until False;
  Close(TF);
 End;
END.