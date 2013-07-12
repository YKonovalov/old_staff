{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+,Y+}
{$M 4096,0,4096}
uses help;
var FileN,Block:string;
    Col,ShadCol:Byte;
    Err:integer;
{------------------------------------------------------------------}
function FileExists(FileName: String): Boolean;
{ Boolean function that returns True if the file exists;otherwise,
 it returns False. Closes the file if it exists. }
var
 F: file;
begin
 {$I-}
 Assign(F, FileName);
 FileMode := 0;  { Set file access to read only }
 Reset(F);
 Close(F);
 {$I+}
 FileExists := (IOResult = 0) and (FileName <> '');
end;  { FileExists }
{---------------------------------------------------------------------------}
Begin
 FileN:='Relem.Hlp';
 Block:=' Содержание ';
 Col:=1;ShadCol:=8;

 if(paramcount>0)and(paramstr(1)='SomeFolks')
 then
 begin
  if paramcount>=2 then FileN:=paramstr(2);
  if paramcount>=3 then Block:=paramstr(3);
  if paramcount>=4 then
       begin
        val(paramstr(4),Col,Err);
        if (Err<>0)or(Col>15) then halt(2);
       end;
  if paramcount>=5 then
       begin
        val(paramstr(5),ShadCol,Err);
        if (Err<>0)or(ShadCol>15) then halt(3);
       end;
 if Not FileExists(FileN) then halt(4);

 PutHelp(FileN,Block,[#27],Col,ShadCol);
 end else halt(1);
 halt(0);
End.