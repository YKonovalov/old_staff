/****************************************************************************/
/*               The Alternate Text Screen Interface Unit                   */
/*      allows you to provide Windows similar environment using text        */
/*       mode. It's ment that you don't need specific grafic images,etc.    */
/*       Actualy,you can make something like Exell view.                    */
/*                          version 1.0                                     */
/****************************************************************************/
#include <conio.h>
#include <string.h>
#include <dos.h>
#include "twin.h"



 int i,j;

/*--------------------------------------------------------------------------*/
void SetLightBG()
{
  _AH=0x10;
  _AL=3;
  _BL=0;
  geninterrupt(0x10);
}
/*--------------------------------------------------------------------------*/
void SetNormBG()
{
  _AH=0x10;
  _AL=3;
  _BL=1;
  geninterrupt(0x10);
}
/*--------------------------------------------------------------------------*/
void HideCur()
{
  _AH=0x03;
  _BH=0x00;
  geninterrupt(0x10);
  CurShape.Chr=_CH;
  CurShape.Atr=_CL;

  _AH=0x01;
  _CH=0x20;
  geninterrupt(0x10);
}
/*--------------------------------------------------------------------------*/
void ShowCur()
{
  _AH=0x01;
  _CH=CurShape.Chr;
  _CL=CurShape.Atr;
  geninterrupt(0x10);
}
/*--------------------------------------------------------------------------*/
void TestKey(byte& C,byte& Ch)
{
      C=0;Ch=0;
    if (kbhit())
     {
      C=getch();
      while (kbhit()) Ch=getch();
     }
}
/*--------------------------------------------------------------------------*/
void ReadKey(byte& C,byte& Ch)
{
      C=0;Ch=0;
      C=getch();
      while (kbhit()) Ch=getch();
}
/*--------------------------------------------------------------------------*/
void InitTWin(void)
{
	 (unsigned long)SCR=VADR;
	 clrscr();
};
/*--------------------------------------------------------------------------*/
void Bar(int x=1,int y=1,int xl=1,int yl=1,byte Bcol=1)
{
	  for (i=x;i<=xl;i++)
	   for (j=y;j<=yl;j++)
	    SCR[j][i].Atr=SCR[j][i].Atr&0x0F|Bcol<<4;
};
/*--------------------------------------------------------------------------*/
void PutEl(byte CR=0,int x=0,int y=0,byte Col=0,byte Bcol=7)
{
	  SCR[y][x].Atr=Col|Bcol<<4;
	  SCR[y][x].Chr=CR;
};
/*--------------------------------------------------------------------------*/
void PutSt(char *S,int x=0,int y=0,byte Col=0,byte Bcol=7)
{
	  for (i=x;i<=x+strlen(S);i++)
	  {
	   SCR[y][i].Atr=Col|Bcol<<4;
	   SCR[y][i].Chr=S[i-x];
	  }
};
/*--------------------------------------------------------------------------*/
void Button:: PutName(char *S,int Ox=1,int Oy=1,byte Col=0,byte Bcol=7)
{
	 PutSt(S,x1+Ox,y1+Oy,Col,Bcol);
};
/*--------------------------------------------------------------------------*/
Button::Button(char *S,int x,int y,int xl,
	       byte Bcol=7,byte Col=0,byte Ocol=1,
	       byte Size=btDemSize)
{
	  if (Size==btStrSize) xl=x+strlen(S)+1;
	  Bar(x,y,xl,y,Bcol);
	  OCol=Ocol;
	  x1=x;
	  x2=xl;
	  y1=y;
	  BCol=Col;
	  for (i=x+1;i<=xl+1;i++)
	  {
	   SCR[y+1][i].Atr=OCol<<4;
	   SCR[y+1][i].Chr=Shadow.Under;
	  }
	   SCR[y][xl+1].Atr=OCol<<4;
	   SCR[y][xl+1].Chr=Shadow.Left;
	  PutName(S,(xl+1-x-strlen(S))/2,0,Col,Bcol);
};
/*--------------------------------------------------------------------------*/
void Button::Press(void)
{
	  for (i=x2;i>=x1;i--)
	  {
	   SCR[y1][i+1].Atr=SCR[y1][i].Atr;
	   SCR[y1][i+1].Chr=SCR[y1][i].Chr;
	  }
	  SCR[y1][x1].Atr=OCol<<4;
	  SCR[y1][x1].Chr=0;
	  for (i=x1+1;i<=x2+1;i++)
	  {
	   SCR[y1+1][i].Chr=0;
	  }
};
/*--------------------------------------------------------------------------*/
void Button::Depress(void)
{
	  for (i=x1;i<=x2;i++)
	  {
	   SCR[y1][i].Atr=SCR[y1][i+1].Atr;
	   SCR[y1][i].Chr=SCR[y1][i+1].Chr;
	  }
	  for (i=x1+1;i<=x2+1;i++)
	  {
	   SCR[y1+1][i].Atr=OCol<<4;
	   SCR[y1+1][i].Chr=Shadow.Under;
	  }
	   SCR[y1][x2+1].Atr=OCol<<4;
	   SCR[y1][x2+1].Chr=Shadow.Left;
};
/*--------------------------------------------------------------------------*/
HotKeys  Button::ListenKey(void)
{
	 byte c,ch;
	 do
	 {
	  ReadKey(c,ch);
	   switch (c)
	   {
	    case 13 : Press();
		      delay(100);
		      Depress();
		      return Pressed;
	    case 27 : return Concel;
	    case 9  : return Tab;
	   };
	 }
	 while (1);
};
/*-END---------------------------------------------------------------------*/