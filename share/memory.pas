 UNIT Memory;
 Interface
  Uses Arrais;
  Type
   Likename=string[12];
   AngleType=0..3;
  Var
     NumberOfChain,
     NumberOfElem :Word;
     p:^word;
     pb:^byte;
     pc:^char;
     pr:^real;
     ps:^likename;

     Seg0,Ofs0,
     SegT,OfsT: Word;
     Stl:LikeName;

     BVar:Byte;
     WVar:Word;
     RVar:Real;
     I:LongInt;
 {-----------------------------------------}
 Procedure InitMemory;
 Procedure DoneMemory;
 Procedure OpenAll;
 Function NotCont(ne:word):boolean;
  Procedure PutElemName(ne:word;name:likename);
  Function   ElemName(ne:word):likename;
  Procedure PutKorteg(ne,kort:word);
  Function   Korteg(ne:word):word;
  Procedure PutZnak(ne:word;B:byte);
  Function   Znak(ne:word):Byte;
  Procedure PutGab(x:byte;ne:word;gb:byte);
  Function   Gab(x:byte;ne:word):Byte;
  Procedure PutChainName(nc:word;name:likename);
  Function   ChainName(nc:word):likename;
  Procedure PutSec(q:byte;kom,sec:word);
  Function   Sec(q:byte;kom:word):word;
  Procedure PutElemNumber(nc,nkom,ne:word);
  Function   ElemNumber(nc,nkom:word):word;
{  Procedure PutQuanElInChain(nc,qe:word);}
  Function   QuanElInChain(nc:word):word;
{  Procedure         PutAngle(ne:word;ang:AngleType);}
{  Function      Angle(ne:word):AngleType;}
       { дополнительные средства }
  Procedure PutElemAmountTrac(ne,q:word;ur:real);
  Function  ElemAmountTrac(q:word):real;
  Function  TracSatil(q:word):word;
  Function  ChainTrac(nc:word):real;
 {------------------------------------------}


Implementation

{-------------------------------------------}
Procedure initMemory;
Begin
InitArrais;
End;
{-------------------------------------------}
Procedure DoneMemory;
Begin
DoneArrais;
End;
{-------------------------------------------}
Procedure OpenAll;
 Begin
  OpenArray(NumberOfElem,SizeOf(LikeName));
  OpenArray(NumberOfElem,2);
  OpenArray(NumberOfElem,1);
  OpenArray(NumberOfElem,1);
  OpenArray(NumberOfElem,1);
  OpenArray(NumberOfElem,SizeOf(LikeName));
  OpenArray(NumberOfElem,2);
  OpenArray(NumberOfElem,6);
  OpenArray(NumberOfElem,2);
 End;
{------------------------------------}
 Procedure PutElemName(ne:word;name:likename);
 Begin
 Stl:=Name;
   PutCmplx(1,ne,@Stl);
 End;
{------------------------------------}
 Function ElemName(ne:word):likeName;
 Begin
  GetCmplx(1,ne,@Stl);
  ElemName:=Stl;
 End;
{------------------------------------}
 Procedure PutKorteg(ne,kort:word);
 Begin
 WVar:=Kort;
   PutCmplx(2,ne,@WVar);
 End;
{------------------------------------}
 Function Korteg(ne:word):word;
 Begin
  GetCmplx(2,ne,@WVar);
   Korteg:=WVar;
 End;
{------------------------------------}
 Procedure PutZnak(ne:word;B:Byte);
 Begin
 BVar:=b;
   PutCmplx(3,ne,@BVar);
 End;
{------------------------------------}
 Function Znak(ne:word):Byte;
 Begin
   GetCmplx(3,ne,@BVar);
    Znak:=BVar;
 End;
{------------------------------------}
 Procedure PutGab(x:byte;ne:word;gb:byte);
 Begin
 BVar:=Gb;
 If x=1 then PutCmplx(4,ne,@BVar)
        else PutCmplx(5,ne,@BVar);
 End;
{------------------------------------}
 Function Gab(x:byte;ne:word):Byte;
 Begin
 if x=1 then GetCmplx(4,ne,@BVar)
        else GetCmplx(5,ne,@BVar);
   Gab:=BVar;
 End;
 {-----------------------------------}
 Procedure PutChainName(nc:word;name:likename);
 Begin
 Stl:=Name;
   PutCmplx(6,nc,@Stl);
 End;
{------------------------------------}
 Function ChainName(nc:word):likeName;
 Begin
  GetCmplx(6,nc,@Stl);
  ChainName:=Stl;
 End;
{------------------------------------}
 Procedure PutSec(q:byte;kom,sec:word);
 Begin
 WVar:=Sec;
 IF Q=1 Then i:=7 Else i:=8;
  PutCmplx(i,Kom,@WVar);
 End;
{------------------------------------}
 Function Sec(q:byte;kom:word):word;
 Begin
 IF Q=1 Then i:=7 Else i:=8;
   GetCmplx(i,Kom,@WVar);
   Sec:=WVar;
 End;
{------------------------------------}
 Procedure PutElemAmountTrac(ne,q:word;ur:real);
  Begin
  RVar:=Ur;
  WVar:=q;
   PutCmplx(9,Q,@RVar);
   PutCmplx(10,Q,@WVar);
  End;
{---------------------------}
 Function ElemAmountTrac(q:word):real;
 Begin
   GetCmplx(9,q,@RVar);
 ElemAmountTrac:=RVar;
 End;
{------------------------------------}
Function TracSatil(q:word):word;
 Begin
  GetCmplx(10,q,@WVar);
  TracSatil:=WVar;
 End;
{------------------------------------}
 Procedure PutElemNumber(nc,nkom,ne:word);
 Begin
  WVar:=ne;
   PutCmplx(nc+10,nkom,@Wvar);
 End;
{------------------------------------}
 Function ElemNumber(nc,nkom:word):word;
 Begin
   GetCmplx(nc+10,nKom,@WVar);
   ElemNumber:=WVar;
 End;
{------------------------------------}
{ Procedure PutQuanElInChain(nc,qe:word);
 Begin
   PutALength(nc+9,qe);
 End;
{------------------------------------}
 Function QuanElInChain(nc:word):word;
 Begin
    QuanElInChain:=LengthOfArray(nc+10)Div DimenOfArray(nc+10);
 End;
 {---------------------------------}
 Function ChainTrac(nc:word):real;
 Begin
   ChainTrac:=1/QuanElInChain(nc);
 End;
{------------------------------------}
 Function NotCont(ne:word):boolean;
 Begin
    if pos('^',ElemName(ne))=0 then
     begin
      NotCont:=true;
      exit
     end;
  NotCont:=false;
 End;
 {=====================================}
End.