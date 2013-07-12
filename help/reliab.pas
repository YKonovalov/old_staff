{$I-}
Program Reliab;

Uses Rel_U,Crt,Work_U,Help;

Var n:byte;

BEGIN
  TextMode(co80);
  hidecursor;
  initbaza;
  zast;
  n:=4;  {начальная позиция}
  nofilem:=true;
  nofiler:=true;
  repeat
   glawmenu(n);
   case n of
    1: PutHelp('Help.rel',' Help ',[#27,'a'..'z'],1,8);
    {*: If not(nofiler) then
          regim;}
    2: If not(nofilem) then
          main;
    3: If not(nofilem) then
          Perform;
    4: disk;
    5: konec;
    end;
  until (false);
END.
