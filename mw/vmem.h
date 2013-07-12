 /************************************************************/
 /*  This code was made to give you a powerful tool          */
 /*    to make your work with TextScreen interfase           */
 /*	    really easy                                      */
 /*	  Version 1.0                                        */
 /*	    (c) copyright Depth Corp.  1994.                 */
 /************************************************************/
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <dos.h>
#include <mem.h>
#include <string.h>
			 struct element {
					 char Chr;
					 char Atr;
					};
			 typedef element (far *scrp)[80];
			 typedef element screen[25][80];
			 struct adr {
				 unsigned Seg;
				 unsigned Ofs;
				    };
			 adr VMEMADR={0xB800,0x0000};
			 unsigned VMEMSIZE=80*25*2;
			 screen SCRC;
			 unsigned long VADR=0xB8000000;
			 scrp SCR;
    element CurShape;
/*------------------------------------------------------------------*/
void VMputXYB(int x,int y,char col,char bkcol,
	      char *s)
 {
   char i,n;
	   n=strlen(s);
      for (i=x-1;i<=x+n-2;i++)
	 {
	  SCR[y-1][i].Chr=*s++;
	  SCR[y-1][i].Atr=col|bkcol<<4;
	 }
 }
/*------------------------------------------------------------------*/
void VMputXY(int x,int y,char col,
	      char *s)
 {
   char i,n;
	n=strlen(s);
      for (i=x-1;i<=x+n-2;i++)
	 {
	  SCR[y-1][i].Chr=*s++;
	  SCR[y-1][i].Atr=SCR[y-1][i].Atr&0xF0|col;
	 }
 }
/*------------------------------------------------------------------*/
void VMgetfXY(int x,int y,char col,char F,
		float min,float max,char &EX,float &Old)
 {
   char i,n,ch;
   static char s[80],st[80];
   int dec,sign;
   float fl;

     EX=0;
Repeat:
;
       for(i=0;i<=79;i++) {s[i]=0;st[i]=0;}
    if (Old) {strcat(s,gcvt(Old,F,st));i=strlen(s);
	      VMputXY(x,y,col,s);
	      for(n=0;n<=79;n++) st[n]=0;
	     }
    else i=0;
       gotoxy(x+i,y);
    do
     {
       ch=getch();
       while (kbhit()) ch=getch();

       if ((((ch>47)&&(ch<58))||(ch==46)||(ch==45)||(ch==69))&&(i<F))
	{
	  SCR[y-1][i+x-1].Chr=ch;
	  SCR[y-1][i+x-1].Atr=SCR[y-1][i+x-1].Atr&0xF0|col;
	  s[i]=ch;
	  i++;
	  gotoxy(x+i,y);
	}
       if ((ch==8)&&(i>0))
	{  i--;
	   s[i]=0;
	   SCR[y-1][i+x-1].Chr=0;
	   SCR[y-1][i+x-1].Atr=SCR[y-1][i+x-1].Atr&0xF0|col;
	   gotoxy(x+i,y);
	}
	if (ch==27) {EX=66;goto Exit;}
     }
    while ((ch!=13)&&(ch!=9));
    fl=atof(s);
    if ((fl<min)||(fl>max))
	  {
	   strcat(st,"Значение вне допустимого диапазона [");
	   strcat(st,gcvt(min,F,s));
	   strcat(st,"..");
	   strcat(st,gcvt(max,F,s));
	   strcat(st,"]");
	   VMputXY(13,24,12,st);
	   ch=getch();
  VMputXY(12,24,4,"                                                    ");
	   for (i=0;i<F;i++)
		 {
		  SCR[y-1][i+x-1].Chr=0;
		  SCR[y-1][i+x-1].Atr=SCR[y-1][i+x-1].Atr&0xF0|col;
		 };
	   goto Repeat;
	  }
Old=fl;
if (ch==9) EX=1;
Exit:
;
}
/*------------------------------------------------------------------*/
void VMgetflXY(int x,int y,char col,char F,
		float min,float max,char &EX,float &Old)
 {
   char i,n,ch;
   static char s[80],st[80];
   int dec,sign;
   float fl;

     EX=0;
Repeat:
;
       for(i=0;i<=79;i++) {s[i]=0;st[i]=0;}
    if (Old) {strcat(s,gcvt(Old,F,st));i=strlen(s);
	      VMputXY(x,y,col,s);
	      for(n=0;n<=79;n++) st[n]=0;
	     }
    else i=0;
       gotoxy(x+i,y);
    do
     { n=0;
       ch=getch();
       while (kbhit()) {if (ch) ch=getch(); else n=getch();}
	if (n==80) {EX=80;goto Exit;}

       if ((((ch>47)&&(ch<58))||(ch==46)||(ch==45)||(ch==69))&&(i<F))
	{
	  SCR[y-1][i+x-1].Chr=ch;
	  SCR[y-1][i+x-1].Atr=SCR[y-1][i+x-1].Atr&0xF0|col;
	  s[i]=ch;
	  i++;
	  gotoxy(x+i,y);
	}
       if ((ch==8)&&(i>0))
	{  i--;
	   s[i]=0;
	   SCR[y-1][i+x-1].Chr=0;
	   SCR[y-1][i+x-1].Atr=SCR[y-1][i+x-1].Atr&0xF0|col;
	   gotoxy(x+i,y);
	}
	if (ch==27) {EX=66;goto Exit;}
     }
    while ((ch!=13)&&(ch!=9));
    fl=atof(s);
    if ((fl<min)||(fl>max))
	  {
	   strcat(st,"Значение вне допустимого диапазона [");
	   strcat(st,gcvt(min,F,s));
	   strcat(st,"..");
	   strcat(st,gcvt(max,F,s));
	   strcat(st,"]");
	   VMputXY(13,24,12,st);
	   ch=getch();
  VMputXY(12,24,4,"                                                    ");
	   for (i=0;i<F;i++)
		 {
		  SCR[y-1][i+x-1].Chr=0;
		  SCR[y-1][i+x-1].Atr=SCR[y-1][i+x-1].Atr&0xF0|col;
		 };
	   goto Repeat;
	  }
Old=fl;
if (ch==9) EX=1;
Exit:
;

 }
/*-----------------------------------------------------*/
void VMgetsXY(int x,int y,char col,char F,
	       char &EX,char *Old)
 {
   char i,n,ch;
   static char s[80];
   int dec,sign;

     EX=0;
    if (*Old) {
	       strcpy(s,Old);i=strlen(s);
	       VMputXY(x,y,col,s);
	      }
    else i=0;
       gotoxy(x+i,y);
    do
     { n=0;
       ch=getch();
       while (kbhit()) {if (ch) ch=getch(); else n=getch();}
	if (n==80) {EX=80;goto Exit;}

       if ((i<F)&&(((ch>=' ')&&(ch<='z'))||((ch>='А')&&(ch<='я'))))
	{
	  SCR[y-1][i+x-1].Chr=ch;
	  SCR[y-1][i+x-1].Atr=SCR[y-1][i+x-1].Atr&0xF0|col;
	  s[i]=ch;
	  i++;
	  gotoxy(x+i,y);
	}
       if ((ch==8)&&(i>0))
	{  i--;
	   s[i]=0;
	   SCR[y-1][i+x-1].Chr=0;
	   SCR[y-1][i+x-1].Atr=SCR[y-1][i+x-1].Atr&0xF0|col;
	   gotoxy(x+i,y);
	}
	if (ch==27) {EX=66;goto Exit;}
     }
    while ((ch!=13)&&(ch!=9));
    s[i]=0;
strcpy(Old,s);
if (ch==9) EX=1;
Exit:
;
 }
/*------------------------------------------------------------------*/
void pushwin()
 {
   movedata(VMEMADR.Seg,VMEMADR.Ofs,_DS,(unsigned)SCRC,VMEMSIZE);
 }
/*------------------------------------------------------------------*/
void pullwin()
 {
   movedata(_DS,(unsigned)SCRC,VMEMADR.Seg,VMEMADR.Ofs,VMEMSIZE);
 }
/*------------------------------------------------------------------*/
void textbar(int x0,int y0,int x1,int y1,
	     char Col,char Chcol,char Bound,char *s)
 {
  char i,j;
   for (i=x0;i<=x1;i++)
    for (j=y0;j<=y1;j++)
       {
	SCR[j-1][i-1].Atr=SCR[j-1][i-1].Atr&0x0F|Col<<4;
	SCR[j-1][i-1].Chr=0;
       }
    if (Bound!=0)
      {
       for (i=x0;i<=x1-2;i++)
	 {
	  SCR[y0-1][i].Chr=205;
	  SCR[y1-1][i].Chr=205;
	  SCR[y0-1][i].Atr=SCR[y0-1][i].Atr&0xF0|Chcol;
	  SCR[y1-1][i].Atr=SCR[y1-1][i].Atr&0xF0|Chcol;
	  SCR[y1][i+1].Atr=0x07;
	 }
       for (j=y0;j<=y1-2;j++)
	 {
	  SCR[j][x0-1].Chr=186;
	  SCR[j][x1-1].Chr=186;
	  SCR[j][x0-1].Atr=SCR[j][x0-1].Atr&0xF0|Chcol;
	  SCR[j][x1-1].Atr=SCR[j][x1-1].Atr&0xF0|Chcol;
	  SCR[j][x1].Atr=0x07;
	  SCR[j][x1+1].Atr=0x07;
	 }
	  SCR[y1-1][x1].Atr=0x07;
	  SCR[y1-1][x1+1].Atr=0x07;
	  SCR[y1][x1].Atr=0x07;
	  SCR[y1][x1+1].Atr=0x07;
       SCR[y0-1][x0-1].Chr=201;
       SCR[y1-1][x0-1].Chr=200;
       SCR[y0-1][x1-1].Chr=187;
       SCR[y1-1][x1-1].Chr=188;
       SCR[y0-1][x0-1].Atr=SCR[y0-1][x0-1].Atr&0xF0|Chcol;
       SCR[y1-1][x0-1].Atr=SCR[y1-1][x0-1].Atr&0xF0|Chcol;
       SCR[y0-1][x1-1].Atr=SCR[y0-1][x1-1].Atr&0xF0|Chcol;
       SCR[y1-1][x1-1].Atr=SCR[y1-1][x1-1].Atr&0xF0|Chcol;
       VMputXY((x0+x1-strlen(s))/2, y0,Chcol,s);
      }
 }
/*----------------------------------------------------*/
void tbar(int x0,int y0,int x1,int y1,
	     char Col,char Chcol)
 {
  char i,j;
   for (i=x0;i<=x1;i++)
    for (j=y0;j<=y1;j++)
       {
	SCR[j-1][i-1].Atr=SCR[j-1][i-1].Atr&0x00|Col<<4|Chcol;
       }
 }
/*------------------------------------------------------------------*/
void textrect(int x0,int y0,int x1,int y1,
	      char col,char *s)
 {
  char i;
       for (i=x0;i<=x1-2;i++)
	 {
	  SCR[y0-1][i].Chr=196;
	  SCR[y1-1][i].Chr=196;
	  SCR[y0-1][i].Atr=SCR[y0-1][i].Atr&0xF0|col;
	  SCR[y1-1][i].Atr=SCR[y1-1][i].Atr&0xF0|col;
	 }
       for (i=y0;i<=y1-2;i++)
	 {
	  SCR[i][x0-1].Chr=179;
	  SCR[i][x1-1].Chr=179;
	  SCR[i][x0-1].Atr=SCR[i][x0-1].Atr&0xF0|col;
	  SCR[i][x1-1].Atr=SCR[i][x1-1].Atr&0xF0|col;
	 }
       SCR[y0-1][x0-1].Chr=218;
       SCR[y1-1][x0-1].Chr=192;
       SCR[y0-1][x1-1].Chr=191;
       SCR[y1-1][x1-1].Chr=217;
       SCR[y0-1][x0-1].Atr=SCR[y0-1][x0-1].Atr&0xF0|col;
       SCR[y1-1][x0-1].Atr=SCR[y1-1][x0-1].Atr&0xF0|col;
       SCR[y0-1][x1-1].Atr=SCR[y0-1][x1-1].Atr&0xF0|col;
       SCR[y1-1][x1-1].Atr=SCR[y1-1][x1-1].Atr&0xF0|col;

       VMputXY((x0+x1-strlen(s))/2, y0,col,s);
 }
/*------------------------------------------------------------------*/
void textweb(int x,int y,int x1,char num,char col)
 {
  unsigned i,j;
    for (j=y-1;j<=y+2*num-2;j+=2)
      for (i=x-1;i<=x1-1;i++)
       {
	SCR[j][i].Atr=SCR[j][i].Atr&0x0F|col<<4;
	SCR[j][i].Chr=0;
       }
 }
/*------------------------------------------------------------------*/
void SetLightBG()
 {
  _AH=0x10;
  _AL=3;
  _BL=0;
  geninterrupt(0x10);
 }
/*-------------------------------------------------*/
void SetNormBG()
 {
  _AH=0x10;
  _AL=3;
  _BL=1;
  geninterrupt(0x10);
 }
/*-------------------------------------------------*/
void initVMEM()
 {
     (unsigned long)SCR=VADR;
     clrscr();
 }
/*-------------------------------------------------*/
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
/*-------------------------------------------------*/
void ShowCur(char col)
 {
  _AH=0x01;
  _CH=CurShape.Chr;
  _CL=CurShape.Atr;
  geninterrupt(0x10);
  textbackground(0);
  textcolor(col);
  window(1,2,1,2);
  clrscr();
  window(1,1,80,25);
 }
/*=======================================================*/