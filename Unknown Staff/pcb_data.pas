Unit PCB_data;      {$DEFINE BigModel}
interface
  uses Graph;
  Const     MaxCmpSelect = 100; PGLB : boolean = true;
     HRecSize = 674;         HRecs = 1;              LaTabRecs = 127;

  {$IFNDEF BigModel}
     Nn           =  50 ;
     KD           =  50 ;
     MaxElTabRecs =  50 ;
     MaxKoTabRecs =  30 ;
     MaxVaCatRecs = 240 ;
     MaxNeTabRecs =  30 ;
  {$ENDIF}
  {$IFDEF BigModel}
     Nn           =  200 ;
     KD           =  50 ;
     MaxElTabRecs =  300 ;
     MaxKoTabRecs =  300 ;
     MaxVaCatRecs =  2000;
     MaxNeTabRecs =  420;
  {$ENDIF}
     MaxCoTabRecs = 2000;     MaxWaridRecs = 4000;
     DETL = $1D6;            SYMB = $0D7;            PCB  = $14;
     SCH  = $0A;             DelRec:integer = -1;        MaxBufSize = 50;

     MaxWaBufs = 800; { не менять !!!! }
     WaBufSize = 4000; { 65535;}  { не менять !!!}

 Type
       TStatType = record Ts:Word;      { Text Size }
                     Tj:string[2]; { Text justify }
                     Tr: byte;     { Text rotation }
                     Tm: char;     { Text Mirror }
              end;
        WordRec = record Lo, Hi : byte; end;
        LongRec = record Low, High : word; end;
        st80 =  string [80];  BinFile = File; {  of Byte; }
        st12  =  string [12];  st6 = string [6]; st4 = string [4];
        st8   = string [8];
        BY80 = array [ 0..79 ] of Char;
        VisitCardType = array [ 0..3 ] of BY80;
        DBvrevType    = array [ 0..1 ] of Word;
        H144Type      = array [ 0..5 ] of Word;
        H150Type      = array [ 0..2 ] of Word;
        H156Type      = array [ 0..2 ] of Word;
        RecsType      = record RecsElTab, RecsKoTab, RecsVaCat,
                               RecsVaCat1, RecsNeTab, RecsCoTab, RecsCoTab1 : Word;
                        end;
        MaxRecsType    = record  Emax, Kmax, Nmax, Cmax, CmaxBuf, Vmax,
                                 VmaxBuf,  WmaxBuf : Word;
                         end;
        HA17Type = array [0..2 ] of Word;
        GrModeType = record   Mode, CurLy, UserLaTabLy : Word; end;
        SettingsType = record Lty, Lfo, Lwd, Sx, Sy, C1, C2, Gds, Mds : Word; end;
        H198Type   = array [ 0..8 ] of  Word;
        H1AAType   = record Xs, Ys : integer; C1, C2, DB, Nlc : Word; end;
        H1B6Type   = record Th : integer; Tjy, Tjx, Tr, Tm : Word; end;
        H1C0Type   = array [ 0.. ($22A - $1C0 - 1)] of byte;
        H22AType   = record  Rtn, Pit, Apr : Word; end;
        H230Type   = array [ 0.. ($2a2 - $230 - 1) ] of byte;

        BufType = array [ 0..MaxBufSize ] of byte;

   HeaderType = record
                  VisitCard : VisitCardType;    DBvrev    : DBvrevType;
                  H144      : H144Type;         H150      : H150Type;
                  H156      : H156Type;         Recs      : RecsType;
                  MaxRecs   : MaxRecsType;      HA17      : HA17Type;
                  GrMode    : GrModeType;       Settings  : SettingsType;
                  H198      : H198Type;         H1AA      : H1AAType;
                  H1B6      : H1B6Type;         H1C0      : H1C0Type;
                  H22A      : H22AType;         H230      : H230Type;
                end;
   HBufType = array [0 .. (HRecSize - 1)] of Byte;

   LaTabRec = record Ly : array [0..5] of Char; C1, Color, C2, Stat,C3,C4 : byte; end;
   LaTabBuf = array [ 0..((SizeOf(LaTabRec)*LaTabRecs) -1) ] of byte;
   LaTabType = array [0..LaTabRecs] of LaTabRec;

   ElTabRec = record Va_ElName, Ko : Integer; x1, y1, xh, yh: integer; Par: Word; Co, Va_attr, X : Integer;   end;
   ElTabType = array [ 0.. (MaxElTabRecs - 1) ] of ElTabRec;
   ElBufType = array [ 0.. ((SizeOf(ElTabRec)*MaxElTabRecs) - 1) ] of byte;

   KoTabRec  = record  Ty,Cw1, Cw2 : integer;  Par: Word; Va_load, Va_defin, Va_logic: Integer; Xb,Yb, X: Integer;end;
   KoTabType = array [ 0..(MaxKoTabRecs -1) ] of KoTabRec;
   KoBufType = array [ 0..((SizeOf(KoTabRec)*MaxKoTabRecs) -1) ] of byte;

   VaCatRec  = record   Base: Word; Wa_Pos: LongInt; Lay,Typ: byte; Fragm, Nrec: Word; Va_Next,Num : Integer; end;
   VaCatType = array [ 0..(MaxVaCatRecs -1) ] of VaCatRec;
   VaBufType = array [ 0..((SizeOf(VaCatRec)*MaxVaCatRecs) -1) ] of byte;

   NeTabRec = record Nn : array [0..7] of Char; Glob: Word;  Va, Co : integer; x1, y1, xh, yh: integer; Cw,X: Integer; end;
   NeTabType = array [ 0.. (MaxNeTabRecs - 1) ] of NeTabRec;
   NeBufType = array [ 0.. ((SizeOf(NeTabRec)*MaxNetabRecs) - 1) ] of byte;

   CoTabRec = record Name : array [0..7] of Char; dx, dy: integer; tr,C1,tor,lay : byte;
                      equ: Word;  Ne, NextCoOfNe, El, NextCoOfEl, C2, Num : Integer; end;
   CoTabType = array [ 0.. (MaxCoTabRecs - 1) ] of CoTabRec;
   CoBufType = array [ 0.. ((SizeOf(CoTabRec)*MaxCotabRecs) - 1) ] of byte;

   WaridRec  = record B1, B2, B3, B4 : byte; end;
   WaridBuffer = array [ 0..(WaBufSize -1) ] of byte; { не менять размер буфера !!! }
   WaridType = array [ 0.. (MaxWaridRecs - 1) ] of WaridRec;
   WaBufType = array [ 0.. ((SizeOf(WaridRec)*MaxWaridRecs) - 1) ] of byte;

   CadrType=(NONE,   FRAGM,  EFr,   EFRAGM, COUNT, PVOID,  CVOID, EOPOLY,
             REFDES, ELOGIC, PNUMS, KLOGIC, FLASH, ELNAME, WIRE,  NETNAME,
             C143,   LOAD,   VIA,    TXT,  POLY,   ARC,   CIRC,   FRECT, RECT,
             LINE,   ATTR,   OVER,  CATPAD, LPARS, UnDefined, UnKnown);
   PointType = record X,Y : integer; end;
   LParsType = array [ 0..130 ] of WaridRec;
   CatPadType= array [ 0..100 ] of WaridRec;
   OverType  = array [ 0..10 ] of WaridRec;
     Var   Header, HeaderW  : ^HeaderType;  HBuf : ^HBufType;   HAddrR,  HAddrW  : Longint;
           LaTab   : ^LaTabType;   LBuf : ^LaTabBuf;   LaAddrR, LaAddrW : LongInt;
           ElTab   : ^ElTabType;   ElBuf: ^ElBufType;  ElAddrR, ElAddrW : LongInt;
           KoTab   : ^KoTabType;   KoBuf: ^KoBufType;  KoAddrR, KoAddrW : LongInt;
           VaCat   : ^VaCatType;   VaBuf: ^VaBufType;  VaAddrR, VaAddrW : LongInt;
           NeTab   : ^NeTabType;   NeBuf: ^NeBufType;  NeAddrR, NeAddrW : LongInt;
           CoTab   : ^CoTabType;   CoBuf: ^CoBufType;  CoAddrR, CoAddrW : LongInt;
           Warid   : WaridRec {^WaridType};   {WaBuf: ^WaBufType;}  WaAddrR, WaAddrW : Longint;
           WaList  : Array [ 0..MaxWaBufs ] of ^WaridBuffer;

           ElRec   : ElTabRec;     KoRec: KoTabRec;    BufPtr: ^BufType;
           RecsWaridR, RecsWaridW : LongInt;    CoRec: CoTabRec;
           RecsW   : RecsType;
           DB, DBout : BinFile;     DBName  : string;  DBNameWasEntered : boolean;
           InputFile:String; SymGlob:Char;
           { Wa_pos : Word; }
           TotalRecsInFRAGM, Va_Ref    : longint; NameGLB: st12;
           TsGLB, TrGLB : word;    TjGLB : string[2];  TmGLB : Char;  LsGLB,WGLB : byte;
           TStatGLB : TStatType;  PCB_Was_Loaded,InStatGLB : boolean;  HLightGLB, RatsGLB: boolean;
           CmpGLB, CmpGLB1, CmpGLB2 : integer;       CounterGLB: integer; BarTypGLB: st6; GridGLB: boolean;
           CmpSet : array [1..MaxCmpSelect ] of integer;
            LyGLB  : byte; PinGLB, NetGLB : integer;

   function  MyGetColor( Ly : Byte ) : byte;
   function  VisibleLy ( Ly : Byte ) : boolean;
   function  LyExist   ( LyNam: string): integer;
   function  AddNewLy  ( NewLy: string; Col, State: byte): integer;
   function  FlipLy    ( Var NLy: byte): boolean;

IMPLEMENTATION

 function FlipLy( Var NLy: byte) : boolean; Var LName: st6; Ok: boolean; i:integer;
 begin Ok:=FALSE;
  if (NLy > 0) and (NLy < 255) then
  begin  LName:='';
      for i:= 0 to 5 do LName:= LName + LaTab^[NLy].Ly[i];
      if Pos('TOP',LName) > 0 then
      begin  Delete(LName,Pos('TOP',LName),3); LName:=LName+'BOT';
             if LyExist(LName) > 0 then
             begin  Ok:=TRUE; NLy:=LyExist(LName); end;
      end else
      if Pos('BOT',LName) > 0 then
      begin  Delete(LName,Pos('BOT',LName),3); LName:=LName+'BOT';
             if LyExist(LName) > 0 then
             begin  Ok:=TRUE; NLy:=LyExist(LName); end;
      end else
      if ( LName[ Length(LName) ] = 'P' ) and ( LName[ Length(LName)-1 ] = 'T' ) then
      begin  Delete(LName, Length(LName)-1,2); LName:=LName+'BT';
             if LyExist(LName) > 0 then
             begin  Ok:=TRUE; NLy:=LyExist(LName); end;
      end else
      if ( LName[ Length(LName) ] = 'T' ) and ( LName[ Length(LName)-1 ] = 'B' ) then
      begin  Delete(LName, Length(LName)-1,2); LName:=LName+'TP';
             if LyExist(LName) > 0 then
             begin  Ok:=TRUE; NLy:=LyExist(LName); end;
      end;
   end;
      FlipLy:=Ok;
 end;

   function LyExist( LyNam: string): integer; Var i,j,m: integer; Ok: boolean;
   begin  m:=-1;
      for i:=0  to (Header^.GrMode.UserLaTabLy -1) do
      begin  Ok:=TRUE;
             with LaTab^[i] do
             begin  for j:=0 to 5 do if Ly[j] <> LyNam[j+1] then Ok:=FALSE;
                if Ok then m:=i;
             end;
      end;  LyExist:=m;
   end;

   function  AddNewLy ( NewLy : string; Col, State: byte) : integer; Var j: integer;
   begin
     Inc( Header^.GrMode.UserLaTabLy);
     with LaTab^[Header^.GrMode.UserLaTabLy - 1] do
     begin
        for j:=0 to 5 do Ly[j]:=' ';
        for j:=1 to Length( NewLy) do Ly[ j-1]:=NewLy[j];
        Color:=Col; Stat:=State;  C1:=0; C2:=0; C3:=0; C4:=0;
     end;
     AddNewLy:=Header^.GrMode.UserLaTabLy-1;
   end;

   function MyGetColor( Ly : Byte ) : byte;
   begin if HLightGLB then MyGetColor:=White else
         begin
         if Ly in [ 250..255] then MyGetColor:= White else
          begin
            case  LaTab^[Ly].Color of
               1: MyGetColor:=LightGreen;
               2: MyGetColor:=Red;
               3: MyGetColor:=Yellow;
               4: MyGetColor:=Blue;
               5: MyGetColor:=LightBlue;
               6: MyGetColor:=LightMagenta;
               7: MyGetColor:=DarkGray;
               8: MyGetColor:=Green;
               9: MyGetColor:= Brown;
               10: MyGetColor:=Brown;
               11: MyGetColor:=LightBlue;
               12: MyGetColor:=LightRed;
               13: MyGetColor:=Magenta;
               14: MyGetColor:=LightGray;
               15: MyGetColor:=Green
               else MyGetColor:=White;
          end; end;  end;
   end;

   function VisibleLy( Ly : Byte ) : boolean;
   begin if Ly in [250 ..255] then VisibleLy:=TRUE else
   if LaTab^[Ly].Stat in [ 1..2 ] then VisibleLy:=TRUE else VisibleLy:=FALSE;
   end;

end.