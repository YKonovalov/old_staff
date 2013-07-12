{$O+}
unit trassir;
interface
uses crt,univer;
  const mx=130{220};
        my=80{145};
  type typplt=array[1..mx,1..my]of word;
       typdir=array[1..mx,1..my]of word;
  var dir:^typdir;
      plt1:^typplt;
      plt2:^typplt;
      plt3:^typplt;
      plt4:^typplt;
      plt5:^typplt;
      plt6:^typplt;
      plt7:^typplt;
      plt8:^typplt;
      rsl:byte;
{-----------------------------------------------------------------}
procedure TRASSIRS(var it,jt,k:byte);
{=================================================================}
implementation
{=================================================================}
procedure TRASSIRS(var it,jt,k:byte);
begin
 repeat
  plt1^[it,jt]:=65535;
  if rsl>1 then plt2^[it,jt]:=it+jt;
  inc(it);
  if it>mx then
   begin
   it:=1;
   inc(jt);
   end;
  if jt>=my then jt:=1;
 until (it=1)or(keypressed)or(mousepressed);
 k:=1;
end;

{----------------------------------------------------}
END.
