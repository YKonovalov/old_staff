/************************************************************/
/*  This code was made to give you a powerful tool          */
/*  to make your work with TextScreen interfase really easy */
/*                                                          */
/*  Version 2.1   { last edition 27.02.95 }                  */
/*  (c) copyright Yury Konovalov.  1995. Moscow, RUSSIA     */
/************************************************************/
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <dos.h>
#include <io.h>
#include <fcntl.h>
#include <sys\stat.h>
#include <dir.h>
#include <mem.h>
#include <string.h>
#include "alg.h"
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
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
/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
typedef char *string;
typedef char Fname[13];

     const int MenuSize=5;
     const int ItemSize=6;
     const FNmax=100;
     const AttrMax=10;
string SysMsg[19]={"                                                      ",
		   "Неприемлимое число процессоров",
		   "Недозволенный символ в имени",
		   "Идентификатор диска должен быть длинною в один символ",
		   "Устройство не указанно !",
		   "Неправельная позиция символа '\\'",
		   "Отсутствует имя файла",
		   "Слишком длинное имя файла",
		   "Слишком длинное расширение имени файла ",
		   "'*','?': Таких устройств не найдено",
		   "Вы используете символы '*' и '?' совершенно неуместно",
		   "Слишком ДЛИННОЕ имя",
		   "Невозможно открыть файл для записи",
		   "Невозможно открыть файл для чтения",
		   "Синтез невозможен.",
		   "Несоответствие формата файла",
		   "Неверная внутренная структура файла",
		   "Невозможно записать в файл",
		   "Результаты синтеза неготовы"};

struct TReport{int Line;int PopUp;};
struct Menu
    {
     int MaxMenuP;
     int MenuP;
     int MaxItemP[MenuSize];
     int ItemP[MenuSize];
     string MenuName[MenuSize];
     int MenuAct[MenuSize];
     string ItemName[MenuSize][ItemSize];
     int ItemAct[MenuSize][ItemSize];
     char WUch[MenuSize+1];
     int MenuType[MenuSize];
     int ItemValue[MenuSize][ItemSize];
     int C[10]; // Array of COLOURS;
	       // 0-Line back ground;
	       // 1-Line original chars;
	       // 2-Line active chars;
	       //  Line marker
	       // 3- back ground;
	       // 4- chars;
	       // 5-PopUp back ground;
	       // 6-PopUp original chars;
	       // 7-PopUp active chars;
	       //  PopUp marker
	       // 8- back ground;
	       // 9- chars;
    };
 Menu M;
 typedef unsigned char byte;
 typedef byte IMAGE[16];
       // Alternate Table addr: C0h-DFh {192-223}
IMAGE image={0x00,0x00,0x00,0x81,0x5A,0x24,0x42,0x81,
	     0x42,0x24,0x5A,0x81,0x00,0x00,0x00,0x00};
IMAGE
  font[10]={
	    {0xff,0x80,0x80,0x80,0x80,0x80,0x80,0x87,
	     0x87,0x80,0x80,0x80,0x80,0x80,0x80,0xff},
	    {0xff,0x01,0x01,0x01,0x01,0x01,0x01,0xe1,
	     0xe1,0x01,0x01,0x01,0x01,0x01,0x01,0xff},
	    {0xff,0x80,0x80,0x80,0x80,0x80,0x80,0x80,
	     0x80,0x80,0x80,0x80,0x80,0x80,0x80,0xff},
	    {0xff,0x01,0x01,0x01,0x01,0x01,0x01,0x01,
	     0x01,0x01,0x01,0x01,0x01,0x01,0x01,0xff},
	    {0xff,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
	     0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff},
	    {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
	     0x00,0x00,0x00,0x00,0x00,0x00,0xff,0x00},
	    {0x00,0xff,0x00,0x00,0x00,0x00,0x00,0x00,
	     0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00},
	    {0x00,0xff,0x80,0x80,0x80,0x80,0x80,0x80,
	     0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x00},
	    {0x00,0xff,0x01,0x01,0x01,0x01,0x01,0x01,
	     0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x00},
	    {0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,
	     0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00}};
IMAGE
  SideF[8]={{0xe0,0xe0,0xe0,0xe0,0xe0,0xe0,0xe0,0xe0,
	     0xe0,0xe0,0xe0,0xe0,0xe0,0xe0,0xe0,0xe0},
	    {0x07,0x07,0x07,0x07,0x07,0x07,0x07,0x07,
	     0x07,0x07,0x07,0x07,0x07,0x07,0x07,0x07},
	    {0xff,0xff,0xff,0x00,0x00,0x00,0x00,0x00,
	     0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00},
	    {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
	     0x00,0x00,0x00,0x00,0x00,0xff,0xff,0xff},
	    {0xff,0xff,0xff,0xe0,0xe0,0xe0,0xe0,0xe0,
	     0xe0,0xe0,0xe0,0xe0,0xe0,0xe0,0xe0,0xe0},
	    {0xff,0xff,0xff,0x07,0x07,0x07,0x07,0x07,
	     0x07,0x07,0x07,0x07,0x07,0x07,0x07,0x07},
	    {0xe0,0xe0,0xe0,0xe0,0xe0,0xe0,0xe0,0xe0,
	     0xe0,0xe0,0xe0,0xe0,0xe0,0xff,0xff,0xff},
	    {0x07,0x07,0x07,0x07,0x07,0x07,0x07,0x07,
	     0x07,0x07,0x07,0x07,0x07,0xff,0xff,0xff}};
struct Exell
    {
     int x,y;
     char Col,Bcol;
     int MaxColumn;
     int MaxRow;
     int OrgColumn;
     int OrgRow;
     int Column;
     int Row;
     int WinColumn;
     int WinRow;
     int Format;
    };
 Exell E;
byte CurrMaxRow=0;
string ExellErrMsg[6]=
       {"                                         ",
	"Число вне допустимого диапазона",
	"Дублирование номера задачи",
	"Двойная связь недопустима",
	"Неопределенный список",
	"Разорванный список"};
string DlgErrMsg[16]=
       {"Ошибка(и) в графе",
	"",
	"Список последующих вершин",
	"содержит неописанные вершины",
	"Отсутствует номер задачи",
	"",
	"Не задан вес задачи",
	"",
	"Ошибка в графе",
	"Вероятно имеются петли",
	"Нечего сохранять",
	"Граф пуст",
	"Текущий граф будет",
	"уничтожен",
	"На этом сеанс работы ",
	"с PPS будет закончен"
	};

struct Epur
    {
     int x,y;
     char Col,Bcol;
     int OrgTakt;
     int OrgPr;
     int Takt;
     int Pr;
     int WinTakt;
     int WinPr;
     int Format;
    };
 Epur S;
struct FileName
    {
     int x,y;
     char Col,Bcol;
     int Orgf;
     int Orgd;
     int f;
     int d;
     int WinF;
    };
 FileName F;
struct ErrorWin
    {
     int x,y;
     char Col,Bcol;
     int WinF;
    };
ErrorWin W=
   {20,10,0,7,20};
task far *TASK;
AlgBase Model;
UINT SchEnd;
proc Schedule;

 const byte FontOFS=192;
 const byte SideFOFS=194;
 const byte NumberOFS=202-48;
 const byte SNumberOFS=180-48;
 const byte BufOFS=212;

static char Graf[100][maxtasks+2];
Fname FN[FNmax][AttrMax];
unsigned FNmaxFile[30]={0};
const int CRQ=40;
const string CR=   "PARALEL PROCESSOR SCHEDULER Version 1.2 ";
const string CNTRL="I'm the creator of this program PPS0001 ";
const char FBROW[CRQ]={3,7,13,28,32,36,7,9,5,2,
		       1,21,24,18,1,2,3,4,5,6,
		       7,8,9,10,11,12,13,14,15,16,
		       6,6,6,6,12,18,18,12,24,30};

 int QuanPr=2;

 int Sp,L;
 static char Buf[80];
/*------------------------------------------------------------------*/
task far *ConvertInit()
 {
 int i;
 task far *Task=new task[maxtasks];
      for (i=1;i<=CurrMaxRow;i++)
	 {
	  Task[Graf[i][0]].weight=Graf[i][1];
	  Task[Graf[i][0]].cnttie=Graf[i][maxtasks+1];
	  Task[Graf[i][0]].posttasks=&Graf[i][2];
	 }
  return Task;
 }
/*------------------------------------------------------------------*/
void ConvertDone(task far *T)
 {
 delete T ;
 }
/*----------------------------------------------------*/
int AttrIndex(int Attr)
 {
  switch (Attr)
  {
   case FA_ARCH : return 1;
   case FA_DIREC: return 2;
  };
  return 0;
 }
/*------------------------------------------------------------------*/
void cbar(int x0,int y0,int x1,int y1,
	     char Col,char Bcol,char Ch)
 {
  char i,j;
   for (i=x0;i<=x1;i++)
    for (j=y0;j<=y1;j++)
       {
	SCR[j-1][i-1].Atr=Bcol|Col<<4;
	SCR[j-1][i-1].Chr=Ch;
       }
 }
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
void VMput(int x,int y,char *s)
 {
   char i,n;
	n=strlen(s);
      for (i=x-1;i<=x+n-2;i++)
	 {
	  SCR[y-1][i].Chr=*s++;
	 }
 }
/*------------------------------------------------------------------*/
void VMputXYFofs(int x,int y,int F,int ofs,
	      char *s)
 {
   char i,n;
	n=strlen(s);
	if (n>F) n=F;
      for (i=x-1;i<=x+n-2;i++)
	 {
	  SCR[y-1][i].Chr=(*s++)+ofs;
	 }
 }
/*------------------------------------------------------------------*/
void VMputcXYB(int x,int y,char col,char bkcol,
	      char c)
 {
	  SCR[y-1][x-1].Chr=c;
	  SCR[y-1][x-1].Atr=col|bkcol<<4;
 }
/*------------------------------------------------------------------*/
void VMputcXY(int x,int y,char col,
	      char c)
 {
	  SCR[y-1][x-1].Chr=c;
	  SCR[y-1][x-1].Atr=SCR[y-1][x-1].Atr&0xF0|col;
 }
/*------------------------------------------------------------------*/
void VMputc(int x,int y,char c)
 {
	  SCR[y-1][x-1].Chr=c;
 }
/*------------------------------------------------------------------*/
void VMsetAttrXY(int x,int y,char col,char Bc)
 {
	  SCR[y-1][x-1].Atr=col|Bc<<4;
 }
/*------------------------------------------------------------------*/
void VMgetiXYFofs(int x,int y,char F,char ofs,
		  int min,int max,char &EX,char &Old,int H)
 {
   char c,ch;
   static char s[80],st[80];
   int i,n,dec,sign;
   int il=0;

Repeat:
;
  VMputXY(E.x+11,E.y+E.WinRow+1,12,ExellErrMsg[0]);
if (H)  VMputXY(E.x+11,E.y+E.WinRow+1,12,ExellErrMsg[H]);
  for(i=0;i<=79;i++) {s[i]=0;st[i]=0;}
     EX=0;
    c=0;ch=0;
    if (Old) {itoa(Old,s,10);
		 i=strlen(s);
	     }
    else i=0;
       gotoxy(x+i,y);
    do
     {
       c=getch();
       while (kbhit()) ch=getch();
 if(H==0)
      {
       if ((((c>48)&&(c<58))||((c=='0')&&(i!=0)))&&(i<F))
	{
	  SCR[y-1][i+x-1].Chr=c+ofs;
	  s[i]=c;
	  i++;
	  gotoxy(x+i,y);
	}
       if ((c==8)&&(i>0))
	{  i--;
	   s[i]=0;
	   SCR[y-1][i+x-1].Chr=FontOFS+4;
	   gotoxy(x+i,y);
	}
      }
     }
    while ((c!=13)&&(ch!=75)&&(ch!=77)&&(ch!=72)&&(ch!=80)&&(c!=25)
	   &&(ch!=71)&&(ch!=79)&&(ch!=83)&&(ch!=81)&&(ch!=73)&&(c!=27));

    il=atoi(s);
    if ((il<min)||(il>max))
	  {
	   strcat(st,ExellErrMsg[1]);
	   strcat(st,"[");
	   itoa(min,s,10);
	   strcat(st,s);
	   strcat(st,"..");
	   itoa(max,s,10);
	   strcat(st,s);
	   strcat(st,"]");
	   VMputXY(E.x+11,E.y+E.WinRow+1,12,st);
	   ch=getch();
	   for (i=0;i<F;i++)
		 {
		  SCR[y-1][i+x-1].Chr=FontOFS+4;
		 };
	    Old=0;
	   goto Repeat;
	  }

    if (il==0) for (i=0;i<F;i++) SCR[y-1][i+x-1].Chr=FontOFS+4;

Old=il;
if(c!=0) EX=c; else EX=ch;
Exit:
;
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
   int dec,sign,in;

     EX=0;
    if (*Old) {
	       strcpy(s,Old);i=strlen(s);
	       VMputXY(x,y,col,s);
	      }
    else i=0;
       gotoxy(x+i,y);

       ch=getch();
       while (kbhit()) {if (ch) ch=getch(); else n=getch();}
       if (!((ch==8)||(ch==27)||(n==75)||(n==77)||(ch==13)||(ch==9)))
       {
	s[0]=0;
	for (i=0;i<F;i++) VMputc(x+i,y,0);
	i=0;
	gotoxy(x,y);
       };
      goto fil;

    do
     { n=0;
       ch=getch();
       while (kbhit()) {if (ch) ch=getch(); else n=getch();}
	if (n==80) {EX=80;goto Exit;}
fil:
;
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
	if (ch==9) {EX=67;goto Exit;}
     }
    while (ch!=13);
    EX=0;
    s[i]=0;
strcpy(Old,s);
if (ch==9) EX=1;
Exit:
;
 }
/*-----------------------------------------------------*/
void VMgetslXY(int x,int y,char col,char F,
	       char &EX,char *Old)
 {
   char i,n,ch;
   static char s[80];
   int dec,sign,in;

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
fil:
;
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
    while (ch!=13);
    EX=0;
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
	     char Col,char Chcol,char Bound,char col,char *s)
 {
  char i,j;
  char ch[4][8]={{205,205,186,186,201,200,187,188},
		 {223,220,219,219,219,219,219,219},
		 {SideFOFS+2,SideFOFS+3,SideFOFS,SideFOFS+1,
		  SideFOFS+4,SideFOFS+6,SideFOFS+5,SideFOFS+7},
		 {196,196,179,179,218,192,191,217}};
   for (i=x0;i<=x1;i++)
    for (j=y0;j<=y1;j++)
       {
	SCR[j-1][i-1].Atr=Chcol|Col<<4;
	SCR[j-1][i-1].Chr=0;
       }
    if (Bound!=0)
      {
       for (i=x0;i<=x1-2;i++)
	 {
	  SCR[y0-1][i].Chr=ch[Bound-1][0];
	  SCR[y1-1][i].Chr=ch[Bound-1][1];
	  SCR[y0-1][i].Atr=SCR[y0-1][i].Atr&0xF0|Chcol;
	  SCR[y1-1][i].Atr=SCR[y1-1][i].Atr&0xF0|Chcol;
	  SCR[y1][i+1].Atr=col;
	 }
       for (j=y0;j<=y1-2;j++)
	 {
	  SCR[j][x0-1].Chr=ch[Bound-1][2];
	  SCR[j][x1-1].Chr=ch[Bound-1][3];
	  SCR[j][x0-1].Atr=SCR[j][x0-1].Atr&0xF0|Chcol;
	  SCR[j][x1-1].Atr=SCR[j][x1-1].Atr&0xF0|Chcol;
	  SCR[j][x1].Atr=col;
	  SCR[j][x1+1].Atr=col;
	 }
	  SCR[y1-1][x1].Atr=col;
	  SCR[y1-1][x1+1].Atr=col;
	  SCR[y1][x1].Atr=col;
	  SCR[y1][x1+1].Atr=col;
       SCR[y0-1][x0-1].Chr=ch[Bound-1][4];
       SCR[y1-1][x0-1].Chr=ch[Bound-1][5];
       SCR[y0-1][x1-1].Chr=ch[Bound-1][6];
       SCR[y1-1][x1-1].Chr=ch[Bound-1][7];
       SCR[y0-1][x0-1].Atr=SCR[y0-1][x0-1].Atr&0xF0|Chcol;
       SCR[y1-1][x0-1].Atr=SCR[y1-1][x0-1].Atr&0xF0|Chcol;
       SCR[y0-1][x1-1].Atr=SCR[y0-1][x1-1].Atr&0xF0|Chcol;
       SCR[y1-1][x1-1].Atr=SCR[y1-1][x1-1].Atr&0xF0|Chcol;
       VMputXY((x0+x1-strlen(s))/2, y0,Chcol,s);
      }
 }
/*----------------------------------------------------*/
void shadow(int x0,int y0,int x1,int y1,char col)
 {
  char i,j;
       for (i=x0;i<=x1-2;i++) SCR[y1][i+1].Atr=col;
       for (j=y0;j<=y1-2;j++)
	 {
	  SCR[j][x1].Atr=col;
	  SCR[j][x1+1].Atr=col;
	 }
	  SCR[y1-1][x1].Atr=col;
	  SCR[y1-1][x1+1].Atr=col;
	  SCR[y1][x1].Atr=col;
	  SCR[y1][x1+1].Atr=col;
 }
/*----------------------------------------------------*/
void tbar(int x0,int y0,int x1,int y1,
	     char Col)
 {
  char i,j;
   for (i=x0;i<=x1;i++)
    for (j=y0;j<=y1;j++)
       {
	SCR[j-1][i-1].Atr=SCR[j-1][i-1].Atr&0x0F|Col<<4;
       }
 }
/*----------------------------------------------------*/
void tbarB(int x0,int y0,int x1,int y1,
	     char Col,char Bcol)
 {
  char i,j;
   for (i=x0;i<=x1;i++)
    for (j=y0;j<=y1;j++)
       {
	SCR[j-1][i-1].Atr=Bcol|Col<<4;
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
void textrectB(int x0,int y0,int x1,int y1,
	      char col,char Bcol,char *s)
 {
  char i;
       for (i=x0;i<=x1-2;i++)
	 {
	  SCR[y0-1][i].Chr=196;
	  SCR[y1-1][i].Chr=196;
	  SCR[y0-1][i].Atr=col|Bcol<<4;
	  SCR[y1-1][i].Atr=col|Bcol<<4;
	 }
       for (i=y0;i<=y1-2;i++)
	 {
	  SCR[i][x0-1].Chr=179;
	  SCR[i][x1-1].Chr=179;
	  SCR[i][x0-1].Atr=col|Bcol<<4;
	  SCR[i][x1-1].Atr=col|Bcol<<4;
	 }
       SCR[y0-1][x0-1].Chr=218;
       SCR[y1-1][x0-1].Chr=192;
       SCR[y0-1][x1-1].Chr=191;
       SCR[y1-1][x1-1].Chr=217;
       SCR[y0-1][x0-1].Atr=col|Bcol<<4;
       SCR[y1-1][x0-1].Atr=col|Bcol<<4;
       SCR[y0-1][x1-1].Atr=col|Bcol<<4;
       SCR[y1-1][x1-1].Atr=col|Bcol<<4;

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
void ShowCur()
 {
  _AH=0x01;
  _CH=CurShape.Chr;
  _CL=CurShape.Atr;
  geninterrupt(0x10);
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
void SetFLA()
 {
  _AH=0x11;
  _AL=3;
  _BL=4;
  geninterrupt(0x10);
 }
/*-------------------------------------------------*/
void SetFont(unsigned int code,IMAGE im,byte Block)
{
 _AH=0x11;
 _AL=0;
 _DX=code;
 _CX=1;
 _BH=16;
 _BL=Block;
 _ES=FP_SEG(im);
 _BP=FP_OFF(im);
  geninterrupt(0x10);
}
/*-------------------------------------------------*/
void GetFont(unsigned int code,IMAGE im)
{
 _DI=_BP;
 _AH=0x11;
 _AL=0x30;
 _BH=6;
  geninterrupt(0x10);
 _SI=_BP;
 _BP=_DI;
 _SI=_SI+code*_CX;
  movedata(_ES,_SI,_DS,(unsigned)im,_CX);
}
/*-------------------------------------------------*/
void RestASCII(int bc,int ec)
{
int i;
 for(i=bc;i<=ec;i++)
 {
 GetFont(i,image);
 SetFont(i,image,0);
 }
}
/*-------------------------------------------------*/
void LoadSide()
{
int i;
// for (i=3;i<5;i++) SetFont(FontOFS+i,font[i],0);
 for (i=0;i<8;i++) SetFont(SideFOFS+i,SideF[i],0);

// RestASCII(192,FontOFS-1);
// RestASCII(FontOFS+5,223);
}
/*-------------------------------------------------*/
void LoadFont()
{
int i;
 for (i=0;i<9;i++) SetFont(FontOFS+i,font[i],0);
// for (i=0;i<8;i++) SetFont(SideFOFS+i,SideF[i],0);

// RestASCII(192,FontOFS-1);
// RestASCII(FontOFS+5,223);
}
/*-------------------------------------------------*/
void RestVmode()
{
 _AH=0;
  geninterrupt(0x10);
}
/*-------------------------------------------------*/
void OrFont(IMAGE im1,IMAGE im2)
{
int i;
for (i=0;i<16;i++) im1[i]=im1[i]|im2[i];
}
/*-------------------------------------------------*/
void MakeUpFont(int ofs,string s,int F)
{
int i,k;
for (i=0;i<F+2;i++)
 {
 if (s[i]==0) break;
   if (i==0) k=2;else
    if (i==F+1) k=3;else k=4;
  GetFont(s[i],image);
  OrFont(image,font[k]);
  SetFont(BufOFS+i+ofs,image,0);
 }
}
/*-------------------------------------------------*/
void CopyTo1(int b,int e)
{
int i;
 for (i=b;i<=e;i++)
  {
   GetFont(i,image);
   SetFont(i,image,1);
  }
}
/*-------------------------------------------------*/
void PutHeadLine(int x,int y,int x1,char lBc,char lCol,string s)
{
string st="   ";
 textbar(x+2,y,x1,y,lBc,lCol,0,0,"");
 VMputXYB((x+x1)/2-(strlen(s)/2),y,lCol,lBc,s);
 st[0]=FontOFS;
 st[1]=FontOFS+1;
 st[2]=0;
 VMputXYB(x,y,0,15,st);
}
/*-------------------------------------------------*/
void PutWin(int x,int y,int x1,int y1,char Bc,char Col,
	    char lBc,char lCol,char Scol,string s)
{
string st="   ";
 textbar(x,y,x1,y1,Bc,Scol,3,8,"");
 textbar(x+1,y+1,x1-1,y1-1,Bc,Col,0,0,"");
 textbar(x+2,y,x1,y,lBc,lCol,0,0,"");
 shadow(x,y,x1,y1,8);
 VMputXYB((x+x1)/2-(strlen(s)/2),y,lCol,lBc,s);
 st[0]=FontOFS;
 st[1]=FontOFS+1;
 st[2]=0;
 VMputXYB(x,y,0,15,st);
}
/*-------------------------------------------------*/
void PutLtShad(int x,int y,int x1,char bc, char sc)
{
 VMputcXY(x1+1,y,sc,220);
 cbar(x+1,y+1,x1+1,y+1,bc,sc,223);
}
/*-------------------------------------------------*/
int PutErrWin(byte er, string BT1, string BT2,int rw,int clmn,string Head)
{
string s="     ";
string st=" Номер Задачи : ";
string sr=" Индекс списка: ";
char sg[30]={0};
char c,Sc;
int i,n,Ok,k;
n=strlen(DlgErrMsg[er]);
i=strlen(DlgErrMsg[er+1]);
k=30;
if(n<i) n=i;
if(n<k) n=k;
k=strlen(BT1);
i=strlen(BT2);
k=k+(i+11);
if(n<k) n=k;

PutWin(W.x,W.y,W.x+n+4,W.y+9,7,0,1,15,1,Head);
VMputXY(W.x+2+(n-strlen(DlgErrMsg[er]))/2,W.y+2,12,DlgErrMsg[er]);
VMputXY(W.x+2+(n-strlen(DlgErrMsg[er+1]))/2,W.y+3,12,DlgErrMsg[er+1]);
if (rw>0)
 {
 itoa(rw,s,10);
 strcat(sg,st);
 strcat(sg,s);
 VMputXY(W.x+2,W.y+4,0,sg);
 }
if (clmn>1)
 {
 sg[0]=0;
 itoa(clmn,s,10);
 strcat(sg,sr);
 strcat(sg,s);
 VMputXY(W.x+2,W.y+5,0,sg);
 }
n=strlen(BT1);
i=strlen(BT2);
cbar(W.x+3,W.y+7,W.x+4+n,W.y+7,15,0,0);
cbar(W.x+8+n,W.y+7,W.x+9+n+i,W.y+7,2,14,0);
PutLtShad(W.x+3,W.y+7,W.x+4+n,7,8);
PutLtShad(W.x+8+n,W.y+7,W.x+9+n+i,7,8);
VMput(W.x+4,W.y+7,BT1);
VMput(W.x+9+n,W.y+7,BT2);
Ok=1;
do
{
c=0;
Sc=0;
c=getch();
while(kbhit()) Sc=getch();
if ((c==9)||(Sc==75)||(Sc==77))
  {
   if (Ok)
    {
     Ok=0;
     tbarB(W.x+3,W.y+7,W.x+4+n,W.y+7,2,14);
     tbarB(W.x+8+n,W.y+7,W.x+9+n+i,W.y+7,15,0);
    }
  else
    {
     Ok=1;
     tbarB(W.x+3,W.y+7,W.x+4+n,W.y+7,15,0);
     tbarB(W.x+8+n,W.y+7,W.x+9+n+i,W.y+7,2,14);
    }
  }
if (c==27) return 0;
}
while (c!=13);
   if (Ok)
    {
     PutLtShad(W.x+3,W.y+7,W.x+4+n,7,7);
     cbar(W.x+4,W.y+7,W.x+5+n,W.y+7,0,15,0);
     VMputcXYB(W.x+3,W.y+7,0,7,0);
     tbarB(W.x+4,W.y+7,W.x+5+n,W.y+7,15,0);
     VMput(W.x+5,W.y+7,BT1);
    }
  else
    {
     PutLtShad(W.x+8+n,W.y+7,W.x+9+n+i,7,7);
     cbar(W.x+9+n,W.y+7,W.x+10+n+i,W.y+7,0,15,0);
     VMputcXYB(W.x+8+n,W.y+7,0,7,0);
     tbarB(W.x+9+n,W.y+7,W.x+10+n+i,W.y+7,15,0);
     VMput(W.x+10+n,W.y+7,BT2);
    }
return (Ok);
}
/*-------------------------------------------------*/
void SetFView(int cl,int rw,char Bc,char Col)
{
int i;
for (i=0;i<E.Format+2;i++)
 VMsetAttrXY(E.x+cl*(E.Format+2)+i,E.y+rw,Col,Bc);
}
/*-------------------------------------------------*/
void initExell(Exell Ex)
 {
 int i,j;
     E=Ex;
     E.Column++;
 for (i=0;i<10;i++)
  {
   GetFont(48+i,image);
   OrFont(image,font[4]);
   SetFont(48+NumberOFS+i,image,0);
  }

 for (i=0;i<5;i++) SetFont(FontOFS+i,font[i],0);

// for (i=0;i<100;i++)
//  for (j=0;j<100;j++) Graf[j][i]=0;
 }
/*-------------------------------------------------*/
void SetToCell(int cl,int rw,int Num)
{
int i,n;
string st="       ";
 if (Num) itoa(Num,st,10);else st[0]=0;
  n=strlen(st);
  for (i=n;i<E.Format;i++) st[i]=FontOFS-NumberOFS+4;
  st[E.Format]=0;

  VMputXYFofs(E.x+cl*(E.Format+2)+1,E.y+rw,E.Format,NumberOFS,st);
}
/*-------------------------------------------------*/
void RedrawIndex()
{
 int i;
 for (i=0;i<E.WinColumn;i++)
       {
	SetToCell(2+i,0,E.OrgColumn+i);
	SetFView(2+i,0,2,15);
       }
}
/*-------------------------------------------------*/
void RedrawCells()
{
 int i,j;
 char c;
  RedrawIndex();
  for (i=0;i<E.WinColumn;i++)
    for (j=0;j<E.WinRow;j++)
     SetToCell(i+2,1+j,Graf[j+E.OrgRow][i+1+E.OrgColumn]);
  for (i=0;i<2;i++)
    for (j=0;j<E.WinRow;j++)
     SetToCell(i,1+j,Graf[j+E.OrgRow][i]);
}
/*-------------------------------------------------*/
void DrawExell(string s,string task,string time)
{
 int i,j,k,ix,ex;
 char c;
 PutHeadLine(E.x,E.y-1,(E.WinColumn+2)*(E.Format+2)+E.x-1,1,15,s);
 shadow(E.x,E.y-1,(E.WinColumn+2)*(E.Format+2)+E.x-1,E.y+E.WinRow+1,8);
 MakeUpFont(0,task,E.Format);
 MakeUpFont(5,time,E.Format);
 for (j=0;j<=E.WinRow;j++)
 {ix=E.x;
 for (i=0;i<=E.WinColumn+1;i++)
  {
  VMputcXYB(ix,E.y+j,E.Col,E.Bcol,FontOFS+2);ix++;
   for (k=0;k<E.Format;k++)
     { VMputcXYB(ix,E.y+j,E.Col,E.Bcol,FontOFS+4);
       ix++;
     }
  VMputcXYB(ix,E.y+j,E.Col,E.Bcol,FontOFS+3);ix++;
  }
 }

 for (i=1;i<=E.WinRow;i++) SetFView(0,i,11,0);
 for (i=1;i<=E.WinRow;i++) SetFView(1,i,14,0);

 for (i=0;i<(2*E.Format+4);i++)
 VMputcXYB(E.x+i,E.y,15,1,BufOFS+i);
 RedrawIndex();
 SetFView(E.Column,E.Row,3,12);
 textbar(E.x,E.y+E.WinRow+1,(E.WinColumn+2)*(E.Format+2)+E.x-1,
	 E.y+E.WinRow+1,7,12,0,0,"");
 VMputXYB(E.x,E.y+E.WinRow+1,15,1,"Сообщение:");
 RedrawCells();
}
/*-------------------------------------------------*/
void DeleteItem()
{
int i;
for (i=E.Column+E.OrgColumn-1;i<1+Graf[E.Row+E.OrgRow-1][maxtasks+1];i++)
     Graf[E.Row+E.OrgRow-1][i]=Graf[E.Row+E.OrgRow-1][i+1];
     Graf[E.Row+E.OrgRow-1][1+Graf[E.Row+E.OrgRow-1][maxtasks+1]]=0;
     Graf[E.Row+E.OrgRow-1][maxtasks+1]--;
     RedrawCells();
}
/*-------------------------------------------------*/
void DeleteList()
{
int i,j;
for (j=E.OrgRow+E.Row-1;j<=CurrMaxRow;j++)
for (i=0;i<=maxtasks+1;i++) Graf[j][i]=Graf[j+1][i];
     if(CurrMaxRow)CurrMaxRow--;
     RedrawCells();
}
/*-------------------------------------------------*/
int DoubleTask()
{
int i;
for (i=1;i<1+CurrMaxRow;i++)
 if ((Graf[E.OrgRow+E.Row-1][0]==Graf[i][0])
     &&(E.Row+E.OrgRow-1!=i))
      {
       VMputXY(E.x+11,E.y+E.WinRow+1,12,ExellErrMsg[2]);
	do{}while (!kbhit());
       VMputXY(E.x+11,E.y+E.WinRow+1,12,ExellErrMsg[0]);
       return(1);
      }
 return(0);
}
/*-------------------------------------------------*/
int DoubleItem()
{
int i;
for (i=2;i<2+Graf[E.Row+E.OrgRow-1][maxtasks+1];i++)
 if ((Graf[E.Row+E.OrgRow-1][E.Column+E.OrgColumn-1]==
     Graf[E.Row+E.OrgRow-1][i])&&(E.Column+E.OrgColumn-1!=i))
      {
       VMputXY(E.x+11,E.y+E.WinRow+1,12,ExellErrMsg[3]);
	do{}while (!kbhit());
       VMputXY(E.x+11,E.y+E.WinRow+1,12,ExellErrMsg[0]);
       return(1);
      }
 return(0);
}
/*-------------------------------------------------*/
void ExellEvent()
{
int i,li,j,lj,oi,oj,Hide;
char Ex,gr;
 oi=E.OrgColumn;
 oj=E.OrgRow;
    do
     {
      li=E.Column;
      lj=E.Row;
      oi=E.OrgColumn;
      oj=E.OrgRow;
 Hide=0;Ex=0;
 if (E.Row+E.OrgRow-2>CurrMaxRow) Hide=4;
 else if ((E.OrgColumn+E.Column-2>Graf[E.Row+E.OrgRow-1][maxtasks+1]+1)&&
	 (E.Column>1)) Hide=5;


     switch (E.Column){
       case 0: gr=Graf[E.OrgRow+E.Row-1][0];
	       do
	       {
		VMgetiXYFofs(E.x+E.Column*(E.Format+2)+1,E.y+E.Row,
			    E.Format,NumberOFS,0,maxtasks,Ex,
			    Graf[E.OrgRow+E.Row-1][0],Hide);
	       }
	       while (DoubleTask());
		if ((Graf[E.OrgRow+E.Row-1][0])&&(gr==0)) CurrMaxRow++;
			    break;

       case 1: VMgetiXYFofs(E.x+E.Column*(E.Format+2)+1,E.y+E.Row,
			    E.Format,NumberOFS,0,255,Ex,
			    Graf[E.OrgRow+E.Row-1][1],Hide);break;

       default: gr=Graf[E.Row+E.OrgRow-1][E.Column+E.OrgColumn-1];
		do
	      {
		VMgetiXYFofs(E.x+E.Column*(E.Format+2)+1,E.y+E.Row,
			     E.Format,NumberOFS,0,maxtasks,Ex,
		Graf[E.Row+E.OrgRow-1][E.Column+E.OrgColumn-1],Hide);
		if((Graf[E.Row+E.OrgRow-1][E.Column+E.OrgColumn-1]==0)&&
		   (gr!=0)) {DeleteItem();break;}
	       }
	       while (DoubleItem());
		if ((Graf[E.Row+E.OrgRow-1][E.Column+E.OrgColumn-1])&&(gr==0))
			    Graf[E.Row+E.OrgRow-1][maxtasks+1]++;
		      }



      if (Ex==77){ if (E.Column<E.WinColumn+1) E.Column++;
		   else
		    if (E.Column+E.OrgColumn<E.MaxColumn+2) E.OrgColumn++;
		 }
      if (Ex==75){ if (E.Column>0) E.Column--;
		   else
		    if (E.OrgColumn>1) E.OrgColumn--;
		 }
      if (Ex==80){ if (E.Row<E.WinRow) E.Row++;
		   else
		    if (E.Row+E.OrgRow<=E.MaxRow) E.OrgRow++;
		 }
      if (Ex==72){ if (E.Row>1) E.Row--;
		   else
		    if (E.OrgRow>1) E.OrgRow--;
		 }
      if (Ex==81){ if (E.OrgRow+E.Row<E.MaxRow-E.WinRow)
			E.OrgRow+=E.WinRow;
		   else {E.OrgRow=E.MaxRow-E.WinRow;E.Row=E.WinRow;}
		 }
      if (Ex==73){ if (E.OrgRow-E.WinRow>1)
			 E.OrgRow-=E.WinRow;
		   else {E.OrgRow=1;E.Row=1;}
		 }
      if (Ex==71){ E.Column=2;
		   E.OrgColumn=1;
		 }
//      if (Ex==79){ E.Column=E.WinColumn+1;
//		   E.OrgColumn=E.MaxColumn-E.WinColumn+1;
//		 }
      if (Ex==79){ E.OrgColumn=Graf[E.Row+E.OrgRow-1][maxtasks+1]+2-E.WinColumn;
		   if (E.OrgColumn<1) E.OrgColumn=1;
		   E.Column=Graf[E.Row+E.OrgRow-1][maxtasks+1]-
			    E.OrgColumn+3;
		 }
      if ((Ex==83)&&(E.Column>1)&&
	  (E.OrgColumn+E.Column-2<=Graf[E.Row+E.OrgRow-1][maxtasks+1]))
	   DeleteItem();
      if (Ex==25) DeleteList();

      if ((oi!=E.OrgColumn)||(oj!=E.OrgRow))
		 RedrawCells();

      if ((E.Column!=li)||(E.Row!=lj))
		{
		 if (li==0) SetFView(li,lj,11,0);
		 else if (li==1) SetFView(li,lj,14,0);
			   else  SetFView(li,lj,15,0);
		 SetFView(E.Column,E.Row,3,12);
		}
    }
    while(Ex!=27);
}
/*-------------------------------------------------*/
void initVMEM(Menu Mn)
 {
 int i;
     (unsigned long)SCR=VADR;
     clrscr();
     M=Mn;
 LoadFont();
 LoadSide();
 SetFont(222,font[9],0);
 }
/*-------------------------------------------------*/
int UpCase(int c)
{
int i;
i=c;
 if ((i>96)&&(i<123)) i=i-32;
 if ((i>159)&&(i<176)) i=i-32;
 if ((i>223)&&(i<240)) i=i-80;
 return(i);
}
/*-------------------------------------------------*/
int FindMax(int N,int Mas[])
{
int i,p=0;
for (i=0;i<N;i++) if(Mas[i]>p) p=Mas[i];
return(p);
}
/*-------------------------------------------------*/
int ItemPos(int num)
 {
 int p,i;
  p=Sp;
  for (i=0;i<num;i++) p=p+Sp+strlen(M.MenuName[i]);
  return(p);
 }
/*-------------------------------------------------*/
int WakeUpMenu(char c)
{
int i;
 for (i=0;i<=M.MaxMenuP;i++) if (c==M.WUch[i]) return(i);
 return(-1);
}
/*-------------------------------------------------*/
void DrawItem(int num,char col)
 {
 int i,p;
  p=ItemPos(num);
  VMputXY(p,1,col,M.MenuName[num]);
  if (M.MenuAct[num])
       { Buf[0]=M.MenuName[num][M.MenuAct[num]-1];
	 Buf[1]=0;
	 VMputXY(p+M.MenuAct[num]-1,1,M.C[2],Buf);
       }
  for (i=0;i<80;i++) Buf[i]=0;
 }
/*-------------------------------------------------*/
void DrawMenu()
 {
 int i,n=0;
  for (i=0;i<M.MaxMenuP;i++) n=n+strlen(M.MenuName[i]);
  Sp=(80-n)/(M.MaxMenuP+1);
  tbar(1,1,80,1,M.C[0]);
  for (i=0;i<M.MaxMenuP;i++) DrawItem(i,M.C[1]);
 }
/*-------------------------------------------------*/
void DrawSubItem(int x,int y,int fnum,int num,char col)
 {
 int i;
  VMputXY(x,y,col,M.ItemName[fnum][num]);
  if (M.ItemAct[num])
       { Buf[0]=M.ItemName[fnum][num][M.ItemAct[fnum][num]-1];
	 Buf[1]=0;
	 VMputXY(x+M.ItemAct[fnum][num]-1,y,M.C[7],Buf);
       }
 }
/*-------------------------------------------------*/
void PutLab(int x)
{
int j,i;
string s="   ";

  for (i=0;i<M.MaxItemP[M.MenuP];i++)
     {
     if ((j=M.ItemValue[M.MenuP][i])>0)
	  if (M.MenuType[M.MenuP]==1) s[0]='\x4'; else itoa(j,s,10);
     else if (M.MenuType[M.MenuP]==1) s[0]=' '; else s[0]='\x17';
     s[1]=0;
     strcpy(Buf,"( )");
     VMput(x,3+i,Buf);
     VMput(x+1,3+i,s);
     for (j=0;j<80;j++) Buf[j]=0;
     }
}
/*-------------------------------------------------*/
int EventSubMenu(char Hide)
 {
  char ch,c;
 int p;
 int j,k,li,i,n=0;
 if (Hide==0)
 {
  for (i=0;i<M.MaxItemP[M.MenuP];i++)
    if (n<strlen(M.ItemName[M.MenuP][i]))
	n=strlen(M.ItemName[M.MenuP][i]);
    n=n+3;
    if(M.MenuType[M.MenuP]!=0) n=n+3;
    p=ItemPos(M.MenuP)-1;
    if (p+n+2>80) p=80-2-n;
  textbar(p,2,p+n,3+M.MaxItemP[M.MenuP],M.C[5],M.C[6],3,8,"");
  for (i=0;i<M.MaxItemP[M.MenuP];i++)
     DrawSubItem(p+2,3+i,M.MenuP,i,M.C[6]);

 if(M.MenuType[M.MenuP]!=0) PutLab(p+n-3);
  i=M.ItemP[M.MenuP];
  tbarB(p+1,3+i,p+n-1,3+i,M.C[8],M.C[9]);
  DrawSubItem(p+2,3+i,M.MenuP,i,M.C[9]);
 }
    do
     {
      ch=0;c=0;
      li=i;
      c=getch();
      while (kbhit()) ch=getch();
     if (Hide==0)
     {
      if (ch==80) if (i<M.MaxItemP[M.MenuP]-1) i++; else i=0;
      if (ch==72) if (i>0) i--; else i=M.MaxItemP[M.MenuP]-1;

C32:
;     if (c==32)
	 switch (M.MenuType[M.MenuP]){
	  case 1: for (j=0;j<ItemSize;j++) M.ItemValue[M.MenuP][j]=0;
		  M.ItemValue[M.MenuP][i]=1;
		  PutLab(p+n-3);
		  break;
	  case 2: if (M.ItemValue[M.MenuP][i]==0)
		  M.ItemValue[M.MenuP][i]=
		    FindMax(M.MaxItemP[M.MenuP],M.ItemValue[M.MenuP])+1;
		  PutLab(p+n-3);
		  break;
				     }

     if ((ch==83)&&(M.MenuType[M.MenuP]==2)&&((k=M.ItemValue[M.MenuP][i])!=0))
	  {
	   M.ItemValue[M.MenuP][i]=0;
	  for (j=0;j<M.MaxItemP[M.MenuP];j++)
		if (M.ItemValue[M.MenuP][j]>k) M.ItemValue[M.MenuP][j]--;
	  PutLab(p+n-3);
	  }

      for (j=0;j<M.MaxItemP[M.MenuP];j++)
      if (UpCase(c)==UpCase(M.ItemName[M.MenuP][j]
	       [M.ItemAct[M.MenuP][j]-1]))
	      {i=j;
	       if (M.MenuType[M.MenuP]) {c=32;goto C32;}
		  else {M.ItemP[M.MenuP]=i;return(-5);}}
      if (i!=li)
		{
		 tbarB(p+1,3+i,p+n-1,3+i,M.C[8],M.C[9]);
		 DrawSubItem(p+2,3+i,M.MenuP,i,M.C[9]);
		 tbarB(p+1,3+li,p+n-1,3+li,M.C[5],M.C[6]);
		 DrawSubItem(p+2,3+li,M.MenuP,li,M.C[6]);
		 M.ItemP[M.MenuP]=i;
		}
     }
      switch (ch) {
      case 77: return(-2);
      case 75: return(-3);
		  }
      switch (c) {
      case 27: return(-4);
      case 13: return(-5);
		  }
    }
    while((j=WakeUpMenu(ch))<0);
    return(j);
 }
/*-------------------------------------------------*/
TReport MenuEvent(int num)
{
int H,E,x,xx;
TReport R,NoneR={-1,-1};
 if (num>=M.MaxMenuP) H=1;else {M.MenuP=num;H=0;};
 do
 {
  pushwin();
  x=ItemPos(M.MenuP)-1;
  xx=x+strlen(M.MenuName[M.MenuP])+1;
  tbarB(x,1,xx,1,M.C[3],M.C[4]);
  DrawItem(M.MenuP,M.C[4]);
  E=EventSubMenu(H);
  switch (E)
   {
   case -2: if (M.MenuP<M.MaxMenuP-1) M.MenuP++;else M.MenuP=0; break;
   case -3: if (M.MenuP>0) M.MenuP--;else M.MenuP=M.MaxMenuP-1; break;
   case -4: pullwin(); return(NoneR);
   case -5: if (H==0) {pullwin();
			R.Line=M.MenuP;
			R.PopUp=M.ItemP[M.MenuP];
			return(R);} H=0; break;
   }
   if (E>=0) M.MenuP=E;
   pullwin();
 }
 while (1);
}
/*-------------------------------------------------*/
void initEpur(Epur Sc)
 {
 int i,j;
     S=Sc;
 for (i=0;i<10;i++)
  {
   GetFont(48+i,image);
   OrFont(image,font[4]);
   SetFont(48+NumberOFS+i,image,0);
  }
 for (i=0;i<10;i++)
  {
   GetFont(48+i,image);
   OrFont(image,font[6]);
   SetFont(48+SNumberOFS+i,image,0);
  }

 for (i=0;i<9;i++) SetFont(FontOFS+i,font[i],0);
// for (i=0;i<8;i++) SetFont(SideFOFS+i,SideF[i],0);
 }
/*-------------------------------------------------*/
void SetSFView(int cl,int rw,char Bc,char Col)
{
int i;
for (i=0;i<S.Format+2;i++)
 VMsetAttrXY(S.x+(cl-1)*(S.Format+2)+L+i,S.y+rw+1,Col,Bc);
}
/*-------------------------------------------------*/
void SetToSCell(int cl,int rw,int Num,int OFS,int Space)
{
int i,n,k;
string st="       ";
 if (Num) itoa(Num,st,10);else st[0]=0;
  n=strlen(st);
  for (i=n;i<S.Format;i++) st[i]=FontOFS-OFS+Space;
  st[S.Format]=0;
    if(!cl) {k=0;n=0;} else {k=L;n=cl-1;};
  VMputXYFofs(S.x+n*(S.Format+2)+k+1,S.y+rw,S.Format,OFS,st);
}
/*-------------------------------------------------*/
void RedrawSIndex()
{
 int i;
 for (i=1;i<=S.WinTakt;i++)
       {
	SetToSCell(i,1,S.OrgTakt+i-1,NumberOFS,4);
       }
 for (i=0;i<S.WinPr;i++)
       {
	SetToSCell(0,i+2,S.OrgPr+i,NumberOFS,4);
       }
}
/*-------------------------------------------------*/
void SetSstate(int x,int y,int t,int p)
{
 int i,j;
 char c[10];
 proc PR;
 taskstatus ts;

  PR=Model.GetProcState(p,t);
    switch (PR.status)
      {
    case proc_seize|proc_release|proc_busy :
			 c[0]=FontOFS+7;
			 for(j=1;j<=S.Format;j++) c[j]=FontOFS+6;
			 c[S.Format+1]=FontOFS+8;
			 break;
    case proc_seize|proc_busy: c[0]=FontOFS+7;
		       for(j=1;j<=S.Format+1;j++) c[j]=FontOFS+6;break;
    case proc_release|proc_busy: c[S.Format+1]=FontOFS+8;
		       for(j=0;j<=S.Format;j++) c[j]=FontOFS+6;break;
    case proc_busy   : for(j=0;j<=S.Format+1;j++) c[j]=FontOFS+6;break;
    case proc_free   : for(j=0;j<=S.Format+1;j++) c[j]=FontOFS+5;break;
      }

  for (i=0;i<=S.Format+1;i++) VMputcXYB(x+i,y,S.Col,S.Bcol,c[i]);

     ts=Model.GetTaskState(PR.tasknum,t);
     if (ts.begtime+(TASK[PR.tasknum].weight/2)==t)
	SetToSCell(t-S.OrgTakt+1,p+1-S.OrgPr+1,PR.tasknum,SNumberOFS,6);



}
/*-------------------------------------------------*/
void RedrawEpurs()
{
 int i,j;
 char c;
  RedrawSIndex();
   for (j=0;j<S.WinPr;j++)
    for (i=0;i<S.WinTakt;i++)
     SetSstate(S.x+L+i*(S.Format+2),S.y+2+j,S.OrgTakt+i,S.OrgPr+j);
}
/*-------------------------------------------------*/
void DrawEpur(string s,string pr)
{
 int i,j,k,ix,ex;
 string st;
 char c;
     L=strlen(pr);
 PutHeadLine(S.x,S.y-1,(S.WinTakt)*(S.Format+2)+L+S.x-1,1,15,s);
 shadow(S.x,S.y-1,(S.WinTakt)*(S.Format+2)+L+S.x-1,S.y+S.WinPr+2,8);
 textbar(S.x,S.y,(S.WinTakt)*(S.Format+2)+L+S.x-1,
	 S.y,15,0,0,0,"");
 VMputXY(S.x+3,S.y,0,"Время Выполнения:      Загруженность:");
 MakeUpFont(0,pr,L-2);
     for(i=0;i<4;i++) if (M.ItemValue[3][i]) break;
     k=0;
     for(j=0;j<6;j++) if (M.ItemValue[4][j]) k++;
 TASK=ConvertInit();
 Model.InitAlg(TASK,&M.ItemValue[4][0]-1,QuanPr,
	       CurrMaxRow,k,i);
     Model.GoToTime(gotoend);
     SchEnd=Model.GetCurrentTime();
     itoa(SchEnd-1,st,10);
 VMputXY(S.x+21,S.y,13,st);
     {
     proc PR;
     string Time;
     PR=Model.GetProcState(S.OrgPr+S.Pr-1,S.OrgTakt+S.Takt-1);
     itoa(PR.chargetime,Time,10);
     VMputXY(S.x+41,S.y,13,Time);
     }
  ix=S.x+L;
 for (i=0;i<S.WinTakt;i++)
  {
  VMputcXYB(ix,S.y+1,0,2,FontOFS+2);ix++;
   for (k=0;k<S.Format;k++)
     { VMputcXYB(ix,S.y+1,0,2,FontOFS+4);
       ix++;
     }
  VMputcXYB(ix,S.y+1,0,2,FontOFS+3);ix++;
  }
 for (j=1;j<=S.WinPr+1;j++)
  {
  ix=S.x;
  VMputcXYB(ix,S.y+j,0,11,FontOFS+2);ix++;
   for (k=0;k<L-2;k++)
     { VMputcXYB(ix,S.y+j,0,11,FontOFS+4);
       ix++;
     }
  VMputcXYB(ix,S.y+j,0,11,FontOFS+3);
  }


 for (i=0;i<L;i++)
 VMputcXYB(S.x+i,S.y+1,15,1,BufOFS+i);

 textbar(S.x,S.y+S.WinPr+2,(S.WinTakt)*(S.Format+2)+L+S.x-1,
	 S.y+S.WinPr+2,7,12,0,0,"");
 VMputXYB(S.x,S.y+S.WinPr+2,15,1,"Сообщение:");
 RedrawEpurs();
 SetSFView(S.Takt,S.Pr,9,14);
 RedrawSIndex();
}
/*-------------------------------------------------*/
void EpurEvent()
{
int i,li,j,lj,oi,oj;
char Sx,gr,clg;
string st;
proc PR;
 oi=S.OrgTakt;
 oj=S.OrgPr;
    do
     {
      li=S.Takt;
      lj=S.Pr;
      oi=S.OrgTakt;
      oj=S.OrgPr;
      Sx=0;
       clg=getch();
       while(kbhit()) Sx=getch();
      if (Sx==77){ if (S.Takt<S.WinTakt) S.Takt++;
		   else
		    if (S.Takt+S.OrgTakt<=SchEnd) S.OrgTakt++;
		 }
      if (Sx==75){ if (S.Takt>1) S.Takt--;
		   else
		    if (S.OrgTakt>1) S.OrgTakt--;
		 }
      if (Sx==80){ if (S.Pr<S.WinPr) S.Pr++;
		   else
		    if (S.Pr+S.OrgPr<=QuanPr) S.OrgPr++;
		 }
      if (Sx==72){ if (S.Pr>1) S.Pr--;
		   else
		    if (S.OrgPr>1) S.OrgPr--;
		 }
      if (Sx==81){ if (S.OrgPr+S.WinPr<QuanPr)
			S.OrgPr+=S.WinPr;
		   else {S.Pr=QuanPr-S.OrgPr+1;}
		 }
      if (Sx==73){ if (S.OrgPr-S.WinPr>1)
			 S.OrgPr-=S.WinPr;
		   else {S.OrgPr=1;S.Pr=1;}
		 }
      if (Sx==71){ S.Takt=1;
		   S.OrgTakt=1;
		 }
      if (Sx==79){ if(S.OrgTakt+S.Takt+S.WinTakt<SchEnd)
			    {
			      S.Takt=S.WinTakt;
			      S.OrgTakt=SchEnd-S.WinTakt+1;
			    }
		   else       S.Takt=SchEnd-S.OrgTakt+1;

		 }

      if ((oi!=S.OrgTakt)||(oj!=S.OrgPr))
	   {
		 RedrawEpurs();
		 SetSFView(S.Takt,S.Pr,9,14);
		 {
		 proc PR;
		 string Time;
		 PR=Model.GetProcState(S.OrgPr+S.Pr-1,S.OrgTakt+S.Takt-1);
		 itoa(PR.chargetime,Time,10);

		 VMputXY(S.x+41,S.y,13,Time);
		 }
	   }

      if ((S.Takt!=li)||(S.Pr!=lj))
		{
//		 if (li==0) SetSFView(li,lj,11,0);
//		 else if (li==1) SetSFView(li,lj,14,0);
//			   else
		 SetSFView(li,lj,S.Bcol,S.Col);
		 SetSFView(S.Takt,S.Pr,9,14);
		 PR=Model.GetProcState(S.Pr+S.OrgPr-1,S.Takt+S.OrgTakt-1);

		 itoa(PR.chargetime,st,10);
		 cbar(S.x+41,S.y,S.x+41+S.Format,S.y,15,13,0);
		 VMput(S.x+41,S.y,st);
		}
    }
    while(clg!=27);
ConvertDone(TASK);
}
/*-----------------------------------------------*/
void PutSysMsg(string SM,int min,int max)
{
int i;
char st[80]={0,0,0,0};
char s[80]={0};
	   strcat(st,SM);
     if ((min)||(max))
	 {
	   strcat(st,"[");
	   itoa(min,s,10);
	   strcat(st,s);
	   strcat(st,"..");
	   itoa(max,s,10);
	   strcat(st,s);
	   strcat(st,"]");
	 }
	   VMputXY(12,25,12,st);
}
/*-----------------------------------------------*/
void FillFN(string ext,int attr)
{
int i=0;
struct find_t found;
unsigned done;

//Constant  │ Description
//══════════╪═════════════════════
//FA_RDONLY │ Read-only attribute
//FA_HIDDEN │ Hidden file
//FA_SYSTEM │ System file
//FA_LABEL  │ Volume label
//FA_DIREC  │ Directory
//FA_ARCH   │ Archive

done=_dos_findfirst(ext,attr,&found);
while(!done)
{
 if ((found.attrib==attr)&&
     (strcmp(found.name,".")))
  { strcpy(FN[i][AttrIndex(attr)],found.name);i++;}
done=_dos_findnext(&found);
}
FNmaxFile[AttrIndex(attr)]=i;
}
/*-----------------------------------------------*/
void InitFN(FileName FNT)
{
F=FNT;
}
/*-----------------------------------------------*/
void RedrawFN(int n)
{
unsigned mi,mj,i,j;

mi=FNmaxFile[AttrIndex(FA_ARCH)];
mj=FNmaxFile[AttrIndex(FA_DIREC)];
if(mi>F.WinF) mi=F.WinF;
if(mj>F.WinF) mj=F.WinF;
if(n)
   {
    cbar(F.x+1,F.y+5,F.x+15,F.y+F.WinF+4,15,0,0);
    for(i=0;i<mi;i++)
     VMputXY(F.x+3,F.y+5+i,0,FN[i+F.Orgf][AttrIndex(FA_ARCH)]);
   }
else
   {
    cbar(F.x+18,F.y+5,F.x+32,F.y+F.WinF+4,15,0,0);
    for(j=0;j<mj;j++)
     VMputXY(F.x+19,F.y+5+j,0,FN[j+F.Orgd][AttrIndex(FA_DIREC)]);
   }
}
/*-----------------------------------------------*/
int TreatPath(string s)
{
 char Allowed;
 int Disc=0,Dir=0,Name=0,Ext=0,WildCards=0,DT=0;
 byte i,n;

 n=strlen(s);
 for (i=0;i<n;i++)
  {
   Allowed=((s[i]>='A')&&(s[i]<='Z'))||((s[i]>='a')&&(s[i]<='z'))
	  ||((s[i]>='0')&&(s[i]<='9'))||(s[i]=='.')
	  ||(s[i]=='*')||(s[i]=='?')
	  ||(s[i]=='_')||(s[i]==':')||(s[i]=='\\');
  if (! Allowed) return(-1);
   switch (s[i])
    {

    case ':': if ((! Disc)||(i!=1)) return(-2);
	      else if(WildCards) return(-8);
		   else {Name=0;DT=i;break;}
    case '\\':if (! DT) return(-3);
	      else if((! Name)&&(i!=2)) return(-4);
		   else if (WildCards) return (-9);
			else
			 if (i-Dir+1>10) return(-10);
			 else {Dir=i+1;Name=0;break;}
    case '.': if (! Name) return(-5);
	       if (Name-Dir>8) return(-6);
	       Ext=i+1;
	       Name=i+1;
	       break;
    case '*': ;
    case '?': WildCards=16;
    default:  if ((! Name)&&(! Disc)) {Disc=1;Name=1;}
	      else
	       if (Ext) Ext=i+1;
	       else Name=i+1;
    }
  }

 if ((! Ext)&&(Name-Dir>8)) return(-6);
 if(Ext-Name>3) return(-7);

 if (DT!=1) Disc=0;

 if(Disc) Disc=1;
 if(Dir) Dir=2;
 if(Name) Name=4;
 if(Ext) Ext=8;

 return (Disc|Dir|Name|Ext|WildCards);
}
/*-----------------------------------------------*/
void GetPath(string Path)
{
  strcpy(Path,"X:\\");
  Path[0] = 'A' + getdisk();
  getcurdir(0, Path+3);
}
/*-----------------------------------------------*/
string GetFileName(string EXT,string Head)
{
unsigned mi,mj,i,j,Mf,Md;
char st[80]={0};
char s[80]={0};
char Ext[80]={0};
char Ex,Tab,Ch,Sx;
int li,lj,oj,oi,Tp;

PutWin(F.x,F.y,F.x+46,F.y+F.WinF+5,7,0,1,15,2,Head);
tbar(F.x+2,F.y+2,F.x+15,F.y+2,15);
tbar(F.x+1,F.y+5,F.x+32,F.y+F.WinF+4,15);
for(i=0;i<=F.WinF;i++) VMputc(F.x+16,F.y+4+i,SideFOFS+1);
tbar(F.x+1,F.y+4,F.x+32,F.y+4,12);
textbar(F.x+16,F.y+2,F.x+40,F.y+2,1,14,0,0,"");
VMput(F.x+3,F.y+2,"Имя файла:");
VMput(F.x+3,F.y+3,"Путь:");
VMput(F.x+5,F.y+4,"Файлы:");
VMput(F.x+18,F.y+4,"Директории:");
	strcpy(st,"X:\\");
	st[0] = 'A' + getdisk();
	getcurdir(0, st+3);
	VMput(F.x+9,F.y+3,st);
strcpy(Ext,EXT);
strcpy(s,EXT);
do
{
FillFN("*.*",FA_DIREC);
FillFN(Ext,FA_ARCH);
RedrawFN(1);
RedrawFN(0);
strcpy(st,s);
Ext:
;
ShowCur();
VMgetsXY(F.x+17,F.y+2,14,20,Ex,s);
HideCur();
if(Ex==67) goto NX;
if(Ex==66) return ("");

Tp=TreatPath(s);

 if (Tp>=0)
  {
   if (Tp & 16) strcpy(Ext,s);
   else
   {
   if ((Tp & 4)&&(!(Tp & 8))) return (strcat(s,EXT+1));
   if (Tp & (4|8)) return (s);
   if (!(Tp & 4))
     {
      PutSysMsg(SysMsg[6],0,0);
      getch();
      PutSysMsg(SysMsg[0],0,0);
      strcpy(st,"─╣");
     }
   }
  }
else
 {
  PutSysMsg(SysMsg[0-Tp+1],0,0);
  getch();
  PutSysMsg(SysMsg[0],0,0);
  strcpy(st,"─╣");
 }
}
while (strcmp(s,st));
NX:
;
 tbarB(F.x+2,F.y+5+F.f,F.x+15,F.y+5+F.f,1,15);
 if (FNmaxFile[AttrIndex(FA_ARCH)])
 VMput(F.x+17,F.y+2,FN[F.f+F.Orgf][AttrIndex(FA_ARCH)]);

Tab=1;
    do
     {
      li=F.f;
      lj=F.d;
      oi=F.Orgf;
      oj=F.Orgd;
      Sx=0;
      Mf=FNmaxFile[AttrIndex(FA_ARCH)];
      if(Mf>F.WinF) Mf=F.WinF;
      Md=FNmaxFile[AttrIndex(FA_DIREC)];
      if(Md>F.WinF) Md=F.WinF;
       Ch=getch();
       while(kbhit()) Sx=getch();
      if (Sx==80){
		  if(Tab)
		  {
		  if (F.f<Mf-1) F.f++;
		   else
		    if (F.f+F.Orgf<FNmaxFile[AttrIndex(FA_ARCH)]-1) F.Orgf++;
		  }
		  else
		  {
		  if (F.d<Md-1) F.d++;
		   else
		    if (F.d+F.Orgd<FNmaxFile[AttrIndex(FA_DIREC)]-1) F.Orgd++;
		  }
		 }
      if (Sx==72){
		  if(Tab)
		   {
		   if (F.f>0) F.f--;
		   else
		    if (F.Orgf>0) F.Orgf--;
		   }
		  else
		   {
		   if (F.d>0) F.d--;
		   else
		    if (F.Orgd>0) F.Orgd--;
		   }
		 }
      if (Ch==9){ if (Tab)
		      {
		       tbarB(F.x+2,F.y+5+li,F.x+15,F.y+5+li,15,0);
		       tbarB(F.x+18,F.y+5+F.d,F.x+31,F.y+5+F.d,1,15);
		       Tab=0;
		      }
		  else
		   {
		    tbarB(F.x+18,F.y+5+F.d,F.x+31,F.y+5+F.d,15,0);
		   if (FNmaxFile[AttrIndex(FA_ARCH)])
		     strcpy(s,FN[F.f+F.Orgf][AttrIndex(FA_ARCH)]);
		   else s[0]=0;
		   oi=0;
		   oj=0;
		   li=0;
		   lj=0;
		   F.Orgd=0;
		   F.d=0;
		   F.Orgf=0;
		   F.f=0;
		    goto Ext;
		   }
		 }
      if (Ch==13){if(Tab) return(FN[F.f][AttrIndex(FA_ARCH)]);
		  else
		   {
		   GetPath(st);
		   if(st[strlen(st)-1]!='\\') strcat(st,"\\");
		   strcat(st,FN[F.d+F.Orgd][AttrIndex(FA_DIREC)]);
		   chdir(st);
		   oi=0;
		   oj=0;
		   li=0;
		   lj=0;
		   F.Orgd=0;
		   F.d=0;
		   F.Orgf=0;
		   F.f=0;
		   GetPath(st);
		   cbar(F.x+9,F.y+3,F.x+40,F.y+3,7,0,0);
		   VMput(F.x+9,F.y+3,st);
		   FillFN("*.*",FA_DIREC);
		   FillFN(Ext,FA_ARCH);
		   RedrawFN(1);
		   RedrawFN(0);
		   tbarB(F.x+18,F.y+5+F.d,F.x+31,F.y+5+F.d,1,15);
		   }
		 }

      if (oi!=F.Orgf)
	   {
		 RedrawFN(1);
		 tbarB(F.x+2,F.y+5+F.f,F.x+15,F.y+5+F.f,1,15);
	   }
      if (oj!=F.Orgd)
	   {
		 RedrawFN(0);
		 tbarB(F.x+18,F.y+5+F.d,F.x+31,F.y+5+F.d,1,15);
	   }

      if (F.f!=li)
		{
		 tbarB(F.x+2,F.y+5+F.f,F.x+15,F.y+5+F.f,1,15);
		 tbarB(F.x+2,F.y+5+li,F.x+15,F.y+5+li,15,0);
		}
      if (F.d!=lj)
		{
		 tbarB(F.x+18,F.y+5+F.d,F.x+31,F.y+5+F.d,1,15);
		 tbarB(F.x+18,F.y+5+lj,F.x+31,F.y+5+lj,15,0);
		}

	 cbar(F.x+17,F.y+2,F.x+40,F.y+2,1,14,0);
	 if (FNmaxFile[AttrIndex(FA_ARCH)])
	 VMput(F.x+17,F.y+2,FN[F.f+F.Orgf][AttrIndex(FA_ARCH)]);


    }
    while(Ch!=27);
return ("");
}
/*-----------------------------------------------*/
int PushGraf(string name)
{
int handle;
int i;
string CRC="                                             ";

//──────────────┬───────────────────────────────────────────────────────────
//  O_RDONLY    │ Open for reading only
//  O_WRONLY    │ Open for writing only
//  O_RDWR      │ Open for reading and writing
//──────────────┴───────────────────────────────────────────────────────────
// Other access flags (Used by open and sopen)
//──────────────┬───────────────────────────────────────────────────────────
//  O_NDELAY    │ Not used; for UNIX compatibility.
//  O_APPEND    │ Append to end of file
//              │   If set, the file pointer is set to the end of the file
//              │   prior to each write.
//  O_CREAT     │ Create and open file
//              │   If the file already exists, has no effect.
//              │   If the file does not exist, the file is created.
//  O_EXCL      │ Exclusive open: Used only with O_CREAT.
//              │   If the file already exists, an error is returned.
//  O_TRUNC     │ Open with truncation
//              │   If the file already exists, its length is truncated to 0.
//              │   The file attributes remain unchanged.
//──────────────┴───────────────────────────────────────────────────────────
// Binary-mode/Text-mode flags (Used by fdopen, fopen, freopen, _fsopen,
//                              open and sopen)
//──────────────┬───────────────────────────────────────────────────────────
//  O_BINARY    │ No translation
//              │   Explicitly opens the file in binary mode
//  O_TEXT      │ CR-LF translation
//              │   Explicitly opens the file in text mode
//──────────────┴────────────────────────────────────────────────────────────

if ((handle = open(name,O_CREAT|O_TRUNC|O_BINARY|O_RDWR,S_IREAD|S_IWRITE)) == -1)
{
   return 12;
}
write(handle,CR,CRQ);
strcpy(CRC,CNTRL);
for(i=0;i<CRQ;i++) CRC[i]=CRC[i]+FBROW[i];
write(handle,CRC,CRQ);

write(handle,&CurrMaxRow,1);
for (i=1;i<=CurrMaxRow;i++)
 {
  write(handle,&Graf[i][maxtasks+1],1);
  write(handle,&Graf[i][0],Graf[i][maxtasks+1]+2);
 }
close(handle);
return 0;
}
/*-----------------------------------------------*/
int PullGraf(string name)
{
int handle;
int i,j;
string CRC="                                             ";


if ((handle = open(name,O_RDWR | O_BINARY)) == -1)
{
   return 13;
}
for (i=0;i<CRQ;i++) CRC[i]=0;
read(handle,CRC,CRQ);
CRC[CRQ]=0;
if (strcmp(CRC,CR))
  {
   close(handle);
   return 15;
  }
read(handle,CRC,CRQ);
CRC[CRQ]=0;
for(i=0;i<CRQ;i++) CRC[i]=CRC[i]-FBROW[i];
if (strcmp(CRC,CNTRL))
  {
   close(handle);
   return 16;
  }

for (i=0;i<maxtasks+1;i++)
 for (j=0;j<100;j++)
  Graf[j][i]=0;

read(handle,&CurrMaxRow,1);
for (i=1;i<=CurrMaxRow;i++)
 {
  read(handle,&Graf[i][maxtasks+1],1);
  read(handle,&Graf[i][0],Graf[i][maxtasks+1]+2);
 }
close(handle);
 return 0;
}
/*-----------------------------------------------*/
int GrafEmpty()
{
int i,j;

for (i=1;i<=CurrMaxRow;i++)
   for (j=0;j<Graf[i][maxtasks+1]+2;j++)
	if(Graf[i][j]!=0) return(0);
return 1;
}
/*-----------------------------------------------*/
int TESTgraf(int &task,int &row)
{
int i,j,Ok,k;
for (i=1;i<=CurrMaxRow;i++)
   for (j=2;j<Graf[i][maxtasks+1]+2;j++)
    {
	  Ok=0;
     for (k=1;k<=CurrMaxRow;k++)
	if(Graf[k][0]==Graf[i][j]) Ok=1;
     if (!Ok)
	{
	 task=i;
	 row=j;
	 return (2);
	}

    }
for (k=1;k<=CurrMaxRow;k++)
{
 Ok=1;
 if(Graf[k][1]==0) Ok=0;
  if (!Ok)
  {
   task=Graf[k][0];
   row=0;
   return (6);
  }
}
if (!GrafEmpty())
 {
TASK=ConvertInit();
i=Model.TestGraph(TASK,CurrMaxRow);
ConvertDone(TASK);
task=0;
row=0;
if (!i) return 8;
 }

 return 0;
}
/*----------------------------------------------------------------*/
//<<<<<<<<<<<<<<< E N D >>>>>>>>>>>>>>>>>>>>>>>*/
//(c)1994 Yury Konovalov. Moscow, RUSSIA.