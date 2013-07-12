UNIT DISK;
  INTERFACE
 Uses Memory,Dos;
Procedure WriteToFile(Mode:byte;s:PathStr);
Function ReadFile(Mode:Byte;s:PathStr):Integer;
 {----------------}
  IMPLEMENTATION
{-----------------------------------------}
Procedure WriteToFile(Mode:byte;s:PathStr);
Var
 f:file;
 i,j,g,k:word;
 c:char;
Begin
 {$I-}
 assign(f,s);
 rewrite(f,1);
 {$I+}
 seek(f,0);
 c:='b';
 blockwrite(f,c,1);
 blockwrite(f,numberOfElem,2);
for i:=1 to NumberOfElem do
 Begin
  s:=elemname(i);
  j:=length(s);
  blockwrite(f,s,j+1);
  j:=Gab(1,i);
  blockwrite(f,j,1);
  j:=Gab(2,j);
  blockwrite(f,j,1)
 End;
  blockwrite(f,NumberOfChain,2);
for i:=1 to NumberOfChain do
 Begin
   k:=QuanElInChain(i);
   blockwrite(f,k,2);
        s:=chainname(i);
        j:=length(s);
     blockwrite(f,s,j+1);
   For j:=1 to k do
   begin g:=ElemNumber(i,j);
   blockwrite(f,g,2);
   end;
 End;
If mode=2 Then
    For i:=1 to NumberOfElem Do
     Begin
       g:=Korteg(i);
       BlockWrite(f,g,2);
     End;
 close(f);
End;
{----------------------------------}
Function ReadFile(Mode:Byte;s:PathStr):Integer;
Var
 f:file;
 i,j,b,k,l:word;
 ncr,c:char;
Begin
assign(f,s);
{$I-}
reset(f,1);
{$I+}
if IOResult=0
 then
  begin
  If memavail<FileSize(f) Then
  Begin
   ReadFile:=2;
   Close(f);
   Exit
  End;
    j:=0;
    seek(f,0);
    blockread(f,c,1);
    blockread(f,ncr,1);seek(f,filepos(f)-1);
    if (c<>'b')or(ncr=' ') then begin s:='0'; exit end;
    blockread(f,numberOfElem,2);
    for i:=1 to NumberOfElem do
     Begin
      blockread(f,j,1);
      Seek(f,FilePos(f)-1);
      blockread(f,s,j+1);
      PutElemName(i,s);
      Blockread(f,j,1);
      PutGab(1,i,j);
      Blockread(f,j,1);
      PutGab(2,i,j);
     End;
    blockread(f,NumberOfChain,2);
    for i:=1 to NumberOfChain do
     Begin
      blockread(f,k,2);
      PutQuanElInChain(i,k);
      l:=0;
      blockread(f,l,1);
      Seek(f,FilePos(f)-1);
      blockread(f,s,l+1);
      Putchainname(i,s);
      For j:=1 to k do
       Begin
        blockread(f,b,2);
        PutElemNumber(i,j,b);
       End;
    End;
        If Mode=2 Then
            For i:=1 to NumberOfElem Do
           Begin
            {$I-}
            BlockRead(f,b,2);
            {$I+}
             If IOResult<>0 Then
                             Begin
                              ReadFile:=2;
                              Close(f);
                              Exit;
                             End;
             PutKorteg(i,b);
           End;
    ReadFile:=0;
    close(f)
   end
   else
     ReadFile:=1;
End;
{---------------------------------}
END.