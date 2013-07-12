 UNIT MEMORY;
 Interface
  Uses Dos;
  Const
     MaxOfs:Word=65534;
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

 {-----------------------------------------}
  Procedure Begining;
  Procedure PutQuanElInChain(nc,qe:word);
  Procedure    PutElemNumber(nc,nkom,ne:word);
  Procedure PutGab(x:byte;ne:word;gb:byte);
  Procedure      PutElemName(ne:word;name:likename);
  Procedure     PutChainName(nc:word;name:likename);
  Procedure PutZnak(ne:word;ch:char);
  Procedure        PutKorteg(ne,kort:word);
{  Procedure         PutAngle(ne:word;ang:AngleType);}
  Procedure PutSec(q:byte;kom,sec:word);
  Function QuanElInChain(nc:word):word;
  Function ElemNumber(nc,nkom:word):word;
  Function Gab(x:byte;ne:word):word;
  Function   ElemName(ne:word):likename;
  Function  ChainName(nc:word):likename;
  Function       Znak(ne:word):integer;
  Function     Korteg(ne:word):word;
{  Function      Angle(ne:word):AngleType;}
  Function Sec(q:byte;kom:word):word;
       { дополнительные средства }
  Procedure PutElemAmountTrac(ne,q:word;ur:real);
  Function ElemAmountTrac(q:word):real;
  Function TracSatil(q:word):word;
  Function ChainTrac(nc:word):real;
 {------------------------------------------}
Implementation
{---------------------------------}
 Procedure Begining;
  Var i:byte;
 Begin
   If Ofs(HeapPtr^)<>0 then i:=16
                       else i:=0;
   Seg0:=seg(HeapPtr^)+i;
   Ofs0:=0;
 End;
 {-----------------------------------}
 Procedure PutQuanElInChain(nc,qe:word);
 Begin
   p:=ptr(Seg0+16*(nc+5),Ofs0+1);
   new(p);
   dispose(p);
   p:=ptr(Seg0+16*(nc+5),Ofs0+1);
   p^:=qe;
 End;
 {---------------------------------}
 Procedure PutElemNumber(nc,nkom,ne:word);
 Begin
   p:=ptr(Seg0+16*(nc+5),Ofs0+sizeof(word)*(1+nkom));
   new(p);
   dispose(p);
   p:=ptr(Seg0+16*(nc+5),Ofs0+sizeof(word)*(1+nkom));
   p^:=ne;
 End;
{------------------------------------}
 Procedure PutGab(x:byte;ne:word;gb:byte);
 Begin
 If x=1 then
  begin
   pb:=ptr(seg0+64,Ofs0+sizeof(byte)*ne);
   new(pb);
   dispose(pb);
   pb:=ptr(seg0+64,Ofs0+sizeof(byte)*ne);
  End
       else
  begin
   pb:=ptr(seg0+80,Ofs0+sizeof(byte)*ne);
   new(pb);
   dispose(pb);
   pb:=ptr(seg0+80,Ofs0+sizeof(byte)*ne);
  end;
   pb^:=Gb;
 End;
{------------------------------------}
 Procedure PutZnak(ne:word;ch:char);
 Begin
   pc:=ptr(Seg0+48,Ofs0+sizeof(char)*ne);
   new(pc);
   dispose(pc);
   pc:=ptr(Seg0+48,Ofs0+sizeof(char)*ne);
   pc^:=ch;
 End;
{------------------------------------}
 Procedure PutKorteg(ne,kort:word);
 Begin
   p:=ptr(Seg0+32,Ofs0+sizeof(word)*ne);
   new(p);
   dispose(p);
   p:=ptr(Seg0+32,Ofs0+sizeof(word)*ne);
   p^:=kort;
 End;
{------------------------------------}
 Procedure PutElemName(ne:word;name:likename);
 Begin
   ps:=ptr(Seg0+16,Ofs0+sizeof(likename)*ne);
   new(ps);
   dispose(ps);
   ps:=ptr(Seg0+16,Ofs0+sizeof(likename)*ne);
   ps^:=name;
 End;
{------------------------------------}
 Procedure PutChainName(nc:word;name:likename);
 Begin
   ps:=ptr(Seg0,Ofs0+sizeof(likename)*nc);
   new(ps);
   dispose(ps);
   ps:=ptr(Seg0,Ofs0+sizeof(likename)*nc);
   ps^:=name;
 End;
{------------------------------------}
 Procedure PutSec(q:byte;kom,sec:word);
 Begin
   p:=ptr(Seg0+16*(NumberOfChain+5+q),Ofs0+sizeof(word)*kom);
   new(p);
   dispose(p);
   p:=ptr(Seg0+16*(NumberOfChain+5+q),Ofs0+sizeof(word)*kom);
   p^:=sec;
 End;
{------------------------------------}
 Function Sec(q:byte;kom:word):word;
 Begin
   p:=ptr(Seg0+16*(NumberOfChain+5+q),Ofs0+sizeof(word)*kom);
   Sec:=p^;
 End;
{------------------------------------}
 Function ElemNumber(nc,nkom:word):word;
 Begin
   p:=ptr(Seg0+16*(nc+5),Ofs0+sizeof(word)*(1+nkom));
   ElemNumber:=p^;
 End;
{------------------------------------}
 Function QuanElInChain(nc:word):word;
 Begin
    p:=ptr(Seg0+16*(nc+5),Ofs0+1);
    QuanElInChain:=p^;
 End;
{------------------------------------}
 Function Znak(ne:word):integer;
 Begin
   pc:=ptr(Seg0+48,Ofs0+sizeof(char)*ne);
   case pc^ of
   '+':Znak:=1;
   '-':Znak:=-1;
   '^':Znak:=0;
   end;
 End;
{------------------------------------}
 Function Gab(x:byte;ne:word):word;
 Begin
 if x=1 then pb:=ptr(seg0+64,Ofs0+sizeof(byte)*ne)
        else pb:=ptr(seg0+80,Ofs0+sizeof(byte)*ne);
   Gab:=pb^;
 End;
{------------------------------------}
 Function Korteg(ne:word):word;
 Begin
   p:=ptr(Seg0+32,Ofs0+sizeof(word)*ne);
   Korteg:=p^;
 End;
{------------------------------------}
 Function ChainName(nc:word):likeName;
 Begin
   ps:=ptr(Seg0,Ofs0+sizeof(likename)*nc);
   ChainName:=ps^;
 End;
{------------------------------------}
 Function ElemName(ne:word):likeName;
 Begin
   ps:=ptr(Seg0+16,Ofs0+sizeof(likename)*ne);
   ElemName:=ps^;
 End;
{------------------------------------}
 Function ChainTrac(nc:word):real;
 Begin
   ChainTrac:=1/QuanElInChain(nc);
 End;
{------------------------------------}
Function TracSatil(q:word):word;
 Begin
    p:=ptr(Seg0+16*(NumberOfChain+9),Ofs0+sizeof(word)*q);
    TracSatil:=p^;
 End;
{------------------------------------}
 Procedure PutElemAmountTrac(ne,q:word;ur:real);
  Begin
   pr:=ptr(Seg0+16*(NumberOfChain+8),Ofs0+sizeof(real)*q);
   new(pr);
   dispose(pr);
   pr:=ptr(Seg0+16*(NumberOfChain+8),Ofs0+sizeof(real)*q);
   pr^:=ur;
   p:=ptr(Seg0+16*(NumberOfChain+9),Ofs0+sizeof(word)*q);
   new(p);
   dispose(p);
   p:=ptr(Seg0+16*(NumberOfChain+9),Ofs0+sizeof(word)*q);
   p^:=ne;
  End;
{---------------------------}
 Function ElemAmountTrac(q:word):real;
 Begin
   pr:=ptr(Seg0+16*(NumberOfChain+8),Ofs0+sizeof(real)*q);
  ElemAmountTrac:=pr^;
 End;
{------------------------------------}
End.