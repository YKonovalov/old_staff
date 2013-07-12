Program PDC;
Uses Memory,Disc;
Var ch:char;
    S,St:string;
    i,j,W:Word;
Const Tex:Array[1..6]Of String=
             ('Error In File Name: ',
              'The Plate Disigner 1.1 Work Tool ',
              ' This program converts',
              ' text circuit file to binary file,',
              ' that may be used in program Plate Disigner 1.1 ',
              ' Sintaxis: PCD <Text File Name> < Circuit File Name >');
{--------------------------------}
 Procedure Sintax(ib,ie:Byte);
 Begin
  For i:=ib to ie do Writeln(Tex[i]);
 End;
 {--------------------}
 Function FileNameErr(s:String):Boolean;
  Begin
  If Pos('.',s)>10 Then
          Begin
           FileNameErr:=True;
           Sintax(1,6);
          End
           Else FileNameErr:=False;
  End;
 {---------------------}
Begin
Writeln('PECD file compiler Version 1.1 Copyright  Ujeen Depth Systems 1994');
If ParamCount<>2 Then
                  Begin
                   Sintax(2,6);
                   Halt;
                  End;
s:=Paramstr(1);
st:=ParamStr(2);
If FileNameErr(s) Then Halt;
If FileNameErr(st) Then Halt;
Write(' Converting. ');
Compilr(S);
If CompErr<>0 Then
 Begin
 Writeln;
 Writeln(' Error ',CompErr,' : ',
        CompErrMsg[CompErr]);
 Writeln(' Line : ',LineNumber);
   Halt;
 End
Else Writeln(LineNumber,' Lines Ok.');
CirN:=CirName;
 WriteToFile(1,St);
If DiscResult<>0 Then
             Begin
            Writeln(DiscErrMsg[DiscResult]);
             Halt;
             End;
Write(' Chacking.');
 DoneMemory;
 InitMemory;
 ReadFile(1,St);
If DiscResult<>0 Then
             Begin
            Writeln(DiscErrMsg[DiscResult]);
             Halt;
             End;
Writeln(' Ok');
Writeln('Compile Successful.');
End.