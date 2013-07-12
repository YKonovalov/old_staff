{$O+}
{$F+}
{$M 64384,0,655360}
PROGRAM StartUpMenu;
 Uses Dos,Crt,Graph,
      Controls,YK_Fonts,Menus,Dialogs,SyFields,Fields;
{>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
  Const

 MyCopyRight:string = (' Y-Start Up menu Tool 1.0  Copyright (c) Yury Konovalov 1996');

            MainPad:VisualContents=(
                            HeadLine:('Выбор системной конфигурации');
                            Lin:(
                              Cat:5;
                              Menu:('','','','','','','');
                              Po:1;
                              ActChar:(1,1,1,3,2,0,0);
                              CallingChar:(32,34,36,47,31,0,255)
                                  );
                            Hid:(
                              Cat:(1,3,2,3,2,5,0);
                              Menu:(
                                  ('Редактировать','Загрузить','Сохранить как...','','',''),
                                  ('Гистограма','Полином','Совмещение','','',''),
                                  ('Таблица результатов','Создать отчет','','','',''),
                                  ('Содержание','Индексный поиск','Использование =помощи=','','',''),
                                  ('Выход с сохранением','Выход без сохранения','','','',''),
                                  ('Закрыть','Минимизировать','Растянуть','Размер','Переместить',''),
                                  ('','','','','','')
                                         );
                              Po:(1,1,1,1,1,1,1);
                              ActChar:((1,1,1,11,0,0),(1,1,1,0,0,0),
                                             (9,9,0,0,0,0),(1,1,16,0,0,0),
                                             (8,7,0,0,0,0),(1,1,1,3,1,0),
                                             (0,0,0,0,0,0));
                              Enable:((True,True,True,True,False,False),(True,True,True,False,False,False),
                                            (True,True,True,False,False,False),(True,True,True,False,False,False),
                                            (True,True,True,False,False,False),(True,False,False,False,False,False),
                                            (True,True,True,False,True,True));
                              MenuType:(1,1,2,1,1,1,1);
                              InfoPart:('','','','','','');
                              BndWidth:0
                                  );
                            Icons:(
                                Width:2;
                                Orientation:True;
                                Cat:3;
                                Distance:(1,1,1,0,2,2,2,0,6,6);
                                FileName:'GAIL.SXS'
                                       );
                            Field:(
                                Length:0;
                                Width :0;
                                Wx:0;
                                Wy:0);
                            Info:(
                                Msg:'';
                                Col:6);
                            Config:(
                                 Headline:True;
                                 lineMenu:False;
                                 Icons:True;
                                 MessageLine:False;
                                 Arrow1 :False;
                                 Arrow2 :False;
                                 Bnd:True
                                   );
                            MinLength:24;
                            MinBreadth:8;
                            UC:(X:5;Y:5);
                            LC:(X:18;Y:18);
                               MainCol  :0;
                               MainBCol :7;
                               FieldBCol:15;
                               FieldCol :8;
                               BounderBCol :7;
                               LineACol :15;
                               LineABCol:1;
                               LineBCol :7;
                               LineCol  :0;
                               MenuACol :15;
                               MenuABCol:1;
                               MenuBCol :7;
                               MenuCol  :0;
                               IconACol :10;
                               IconBCol :7;
                               HLBACol:1;
                               HLACol:15;
                               HLBCol:7;
                               HLCol:0

                                     );

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<}


 Var
     i,j,mn,h    :word;
     ch          :char;
     OldPath:PathStr;
     FontFile:pathstr;
     SafeHalting:boolean;
     GAILSysDir,GAILDrvDir,GAILFont,GAILVideoDrv:string;
     GAILVideoMode:integer;
{-------------------------------------------------------}
Procedure AskForFontFile;
 var c:char;
 begin
 textcolor(7);
   If Not LoadFromFile(GAILFont) then
      Begin
      Writeln;
      Writeln;
      Writeln;
      Writeln('File ',GAILFont,' was not found or there was error reading.');
      Writeln(' Press [N] to return to DOS and correct problem imidiatly,');
      Writeln('or press [Y] to proceed with automatic Font generation...');
      repeat
       c:=readkey;
      until c in ['Y','N','y','n'];
      if c in ['n','N'] Then
             begin
              textcolor(12);
              writeln('Can''t proceed with no Font available .');
              textcolor(3);
              writeln('Hope you''ll correct this problem ...  Bye !');
              TEXTCOLOR(7);writeln(' ');
              halt;
             end;
      Writeln;
      Writeln;
      Write('Trying Initialize Your System Character Table Font...');
       InitFont(0,255);
       PushToFile('System.YKF');
      delay(1000);
      writeln('done');
      Writeln;
      writeln;
      delay(500);
      Writeln('Notice: If You will not see Cyrillic Fonts - try to install it from DOS');
      Writeln('         And don''t forget to delete file System.YKF to reinitialize Font');
      Writeln;
      Write('      Press any key...    ');
       c:=readkey;
      writeln;writeln;
      End;
 end;
{------------------------------------------------------}
Function ReadCfgFile(FileName:pathstr):boolean;

 const
    MaxRW:byte=6;
    ResWord:array[1..6]of string[34]=
        ('SYSDIR','DRVDIR','SYSFONT','VIDEODRV','VIDEOMODE','MAXCHOISES');
 var
  F: Text;
  value,st:string;i,l,e:integer;
  HookIt:boolean;
 begin
  GAILSYSDIR:='C:\_System.!#!\StartUp';
  GAILDRVDIR:='C:\_System.!#!\StartUp\Drv';
  GAILFONT:='system.ykf';
  GAILVideoDrv:='egavga';
  GAILVideoMode:=2;

 ReadCfgFile:=TRue;
  {$I-}
  Assign(F, FileName);
  FileMode := 0;  { Set file access to read only }
  Reset(F);
  {$I+}
  If IOResult<>0 then
    begin
      ReadCfgFile:=False;
      exit;
    end;
  repeat
   ReadLn(F,st);
   HookIt:=False;
   for i:=1 to MaxRW do
   If System.Pos('#',st)=1 then HookIt:=True
   else
    If System.Pos(ResWord[i],st)<>0 then
        begin
         HookIt:=true;
         l:=System.Pos(ResWord[i],st);
         delete(st,1,l+length(ResWord[i])-1);
         if System.Pos('=',st)<>1 then
           writeln('Error in CFG file... Value:',ResWord[i])
         else
          begin
           value:=copy(st,2,length(st)-1);
           writeln(ResWord[i],' : ',value);
           case i of
           1: GAILSysDir:=value;
           2: GAILDrvDir:=value;
           3: GAILFONT:=value;
           4: GAILVideoDrv:=value;
           5: begin val(value,GAILVideoMode,e);
              if e<>0 then writeln('Error: Invalid VideoMode Value..!');end;
           end
          end;
        end;
     if (i=MaxRW)and Not HookIt then
        writeln ('Error: Unknown configuration identifier: ',st);

  until EOF(F);
  {Close(F);}
 end;
{------------------------------------------------------}
Procedure AskForUseDef;
begin
textcolor(4);
writeln;
 writeln('  Error finding or reading coniguration file ...');
 textcolor(3);
  write('   Solution: ');
 textcolor(7);
  write('...');
 sound(1000);
 delay(1000);
 nosound;
textcolor(7);
 delay(2000);
  gotoxy(wherex-3,wherey);
  writeln('System will use default values.');
  writeln;
 writeln ('   Press any key To continue ...');
 readkey;
end;
{-------------------------------------------------------}
{+MAIN++++++++==========================================}
BEGIN
Writeln(MyCopyRight);
  SysPath:='\_System.!#!\StartUp.YK';
If NOT ReadCfgFile(SysPath+'GAIL.CFG') Then AskForUseDef;
  AskForFontFile;

  SysPath:='\_System.!#!\StartUp.YK';
  Getdir(0,OldPath);
  {$I-}
  chdir(SysPath);
  {$I+}
  if IOResult <> 0 then
    begin
     Writeln('System directory not found: ',SysPath);
     {$I-}
     chdir(OldPath);
     {$I+} If IOResult<> 0 then
           begin Writeln('Unknown disk Error. Decision: Halt');
            HALT
           end;
     Getdir(0,SysPath);
     Writeln('Using current directory as System : ',SysPath);
     Writeln('Press any key...');
     readkey;
    end;
  IconsPath:=SysPath;

  SysVidDRV:=GAILVideoDrv;
  SysVidMODE:=GAILVideoMode;
  SysDrvDIR:=GAILDrvDir;

SafeHalting:=FALSE;

  InitDialogs;
    FieldPointer:=@WallField;
    OpenPad(NulPad,Init);
  showPad;
   Show;
Repeat
  FieldPointer:=@MainField;
  OpenPad(MainPad,Init);
  ShowPad;

 While PipEvent<>CLOSE do
 Begin
  If ChoosenEv(ICON,1,0)Or ChoosenEv(Menu,1,1) then
            begin
                            FieldPointer:=@MessageField;
                            Message:='Предупреждение://Не надо нервничать !';
                            MessButs[1]:='Все стереть';MessButs[2]:='Отменить';
                            MaxMessButs:=2;
                            OpenPad(MessagePad,Init);
                            ShowPad;
                            Repeat Until PipEvent=CLOSE;
                            if MessBut=1 then FieldEvent(w,ClearTable,Nil);
            end;

  If ChoosenEv(ICON,2,0)Or ChoosenEv(Menu,2,1)  then
             begin
                            Ext:='*.GTB';
                            FieldPointer:=@FileNameField;
                            OpenPad(FileNamePad,Init);
                            ShowPad;
                            Repeat Until PipEvent=CLOSE;
                            If FNReport.ExCode=Choosen then
                              begin
                               FieldEvent(Fwin,loadTable,Nil);
                               if TableExCode<>Ok then
                                begin
                                 FieldPointer:=@MessageField;
                                Message:='Ошибка: Невозможно загрузить //'+
                                         'таблицу из '+ FNReport.FN;
                                 MessButs[1]:='Закрыть';
                                 MaxMessButs:=1;
                                 OpenPad(MessagePad,Init);
                                 ShowPad;
                                 Repeat Until PipEvent=CLOSE;
                                end;
                              end;
                    End;
  If ChoosenEv(ICON,3,0)Or ChoosenEv(Menu,2,2)  then
             begin
                            If CurrTabFile<>DefTabFile then
                             FieldEvent(Fwin,SaveTable,Nil)
                             else
                              begin
                               Ext:='*.GTB';
                               FieldPointer:=@FileNameField;
                               OpenPad(FileNamePad,Init);
                               ShowPad;
                               Repeat Until PipEvent=CLOSE;
                             If FNReport.ExCode=Choosen then
                                   FieldEvent(Fwin,SaveTableAs,Nil);
                              end;
             end;

 If ChoosenEv(ICON,4,0)Or ChoosenEv(MENU,5,2)  then
         begin
          FieldPointer:=@MessageField;
          Message:='(!) Предупреждение: Все несохраненные данные//будут ПОТЕРЯНЫ.';
          MessButs[1]:='Отменить';MessButs[2]:='Выйти без сохранения';
          MaxMessButs:=2;
          OpenPad(MessagePad,Init);
          ShowPad;
          Repeat Until PipEvent=CLOSE;
          if MessBut=2 then begin SafeHalting:=TRUE;Break;end;
         end;
 If ChoosenEv(ICON,5,0)Or ChoosenEv(MENU,5,1) then
         begin
          FieldPointer:=@MessageField;
          Message:=' На этом ваша работа с Y-Start будет закончена.';
          MessButs[1]:='Выйти с сохранением';MessButs[2]:='Отменить';
          MaxMessButs:=2;
          OpenPad(MessagePad,Init);
          ShowPad;
          Repeat Until PipEvent=CLOSE;
          if MessBut=1 then begin SafeHalting:=TRUE;Break;end;
         end;

 End;

 IF not SafeHalting then
  begin
   FieldPointer:=@MessageField;
   Message:='ВНИМАНИЕ! Система готова к выгрузке//'+
            'Причина : No active PADs           ';
   MessButs[1]:='Отменить';MessButs[2]:='Выгрузить';
   MaxMessButs:=2;
   OpenPad(MessagePad,Init);
   Pad.HeadLine:='СИСТЕМНОЕ сообщение !';
   Pad.Hid.Enable[1,1]:=False;
   Pad.HLBACol:=4;
   ShowPad;
   Repeat Until PipEvent=CLOSE;
   if MessBut=2 then Break;
  end else break;
Until False;
 DoneDialogs;
Gotoxy(1,22);
Writeln(MyCopyRight);
 Chdir(OldPath);
End.


