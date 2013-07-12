 /************************************************************/
 /*  PARALEL PROCESSOR  S C H E D U L E R                    */
 /*	                                                     */
 /*  This program is to optimize the work of                 */
 /*  multyprocessor system                                   */
 /*	                                                     */
 /*  Version 1.2                                             */
 /*  (c) copyright Feedback.        1995.Moscow, RUSSIA      */
 /************************************************************/
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <dos.h>
#include <math.h>
#include "yk_video.h"

typedef float *vect;
 vect printvect[60];
 char Feedback[8]={NumberOFS,NumberOFS+1,NumberOFS+2,
		   NumberOFS+3,NumberOFS+4,NumberOFS+5};
IMAGE FB[6]={
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
	     0x00,0x00,0x00,0x00,0x00,0x00,0xff,0x00}};
Menu PPSline=
    { 5,
      0,
     {5,2,1,3,6},
     {0,0,0,0,0},
     {"Граф","Расписание","Синтез","Процессор","Задача"},
     {1,1,1,1,1},
     {{"Создать","Редактировать","Загрузить","Сохранить","Выход  Alt-F4"},
      {"Подготовить отчет","Число процессоров"},
      {"Однократно","Автомат","Пошаговое"},
      {"Максимальная загрузка","Равномерная загрузка",
       "Случайная загрузка"},
      {"по случайному индексу задачи",
       "по максимуму веса задачи","по минимуму веса задачи",
       "по максимуму связности задачи",
       "по ранней готовности задачи","по поздней готовности задачи"}},
     {{1,1,1,2,1},{1,1},{1,1,1},
      {1,1,1},{4,4,5,5,14,4}},
     {22,35,46,34,25,68},
     {0,0,0,1,2},
     {{0},{0},{0},{1},{0,0,0,0,0,0}},
     {15,0,12,0,15,15,0,12,0,15}
   };
Exell PPSExell=
      {6,4,
       0,15,
       100,
       40,
       1,1,0,1,
       10,
       16,
       3
      };
Epur PPSEpur=
      {6,4,
       0,15,
       1,1,
       1,1,
       10,12,
       3
      };
FileName PPSFN=
      {6,4,
       0,15,
       0,0,
       0,0,
       14,
      };
TReport MenuReport;
string s="       ";
int n,i,j,t,r;
char  ch,c,Ex;
int GRAFtest;
char Path[80];
/*-------------------------------------------------------*/

/*-------------------------------------------------------*/
/*\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/
void main()
 {
   char buf[80],mstr[80];
   int i,j;

while (kbhit()) getch();

 initVMEM(PPSline);
 SetLightBG();
 HideCur();

 GetPath(Path);

 textbackground(7);
 textcolor(0+BLINK);
 cbar(1,2,80,24,0,7,222);
 textbar(1,25,80,25,15,0,0,0,"");
 VMputXY(2,25,0,"Сообщение│");
 DrawMenu();

       pushwin();
       LoadFont();
       LoadSide();
       textbar(20,6,61,18,7,0,3,7,"");
       VMputXY(22,8,12,  "      PARALEL PROCESSOR SCHEDULER");
       VMputXY(22,10,10, "             Version 1.2");

       VMput(21,12,"Copyright (c) Feedback. MAI, RUSSIA 1995");
       VMputXY(31,12,15,"(c)");
       VMput(26,13,"Feedback :");
       VMput(36,14,"Ю.Д.Коновалов");
       VMput(36,15,"Д.В.Корнилов");
       VMput(36,16,"Ю.И.Ровенский");
       VMput(36,17,"Б.Н.Михайлов");
getch();
       pullwin();





   do
    {
LOOP:
;
     MenuReport.Line=-1;
     ch=0;c=0;
     c=getch();
     while (kbhit()) ch=getch();
   /*  if (n==-1) MenuReport=MenuEvent(5);*/
     if ((n=WakeUpMenu(ch))>=0) MenuReport=MenuEvent(n);

     if ((MenuReport.Line==0)&&(MenuReport.PopUp==1))
	       {
EXELL:
;
	       do
	       {
		pushwin();
		initExell(PPSExell);
		DrawExell(" Таблица Графа ","Tasks","Times");
		ExellEvent();
		GRAFtest=0;
		GRAFtest=TESTgraf(t,r);
		pullwin();
		  i=0;
		if (GRAFtest)
		 {
		  LoadSide();
		  RestASCII(220,221);
		  RestASCII(223,224);
		  i=PutErrWin(GRAFtest,"Исправить","Не надо",t,r,"Ошибка");
		  if(i)
		   {
		      if (!t) t=1;
		      j=r-PPSExell.WinColumn/2;
		    if(j<=0)
		      {
		      PPSExell.Column=r;
		      PPSExell.OrgColumn=1;
		      }
		    else
		      {
		      PPSExell.OrgColumn=j;
		      PPSExell.Column=PPSExell.WinColumn/2;
		      }
		      j=t-PPSExell.WinRow/2;
		    if(j<=0)
		      {
		      PPSExell.Row=t;
		      PPSExell.OrgRow=1;
		      }
		    else
		      {
		      PPSExell.OrgRow=j;
		      PPSExell.Row=PPSExell.WinRow/2+1;
		      }
		   }
		  pullwin();
		 }
	       }
	       while (i);
		LoadSide();
	       }
     if ((MenuReport.Line==0)&&(MenuReport.PopUp==0))
	       {
		pushwin();
		  LoadSide();
		  RestASCII(220,221);
		  RestASCII(223,224);
		if (!GrafEmpty())
		 if (!PutErrWin(12,"Удалить","Не удалять",0,0,
		     "Предупреждение"))
		   {
		    pullwin();
		    goto LOOP;
		   }
		   pullwin();

		initExell(PPSExell);


		 for (i=0;i<=maxtasks+1;i++)
		  for (j=0;j<100;j++)
		   Graf[j][i]=0;
		 CurrMaxRow=0;
		 PPSExell.Column=0;
		 PPSExell.Row=1;
		 PPSExell.OrgColumn=1;
		 PPSExell.OrgRow=1;


		DrawExell(" Новый Граф ","Tasks","Times");
		ExellEvent();

		GRAFtest=0;
		GRAFtest=TESTgraf(t,r);
		pullwin();
		  i=0;
		if (GRAFtest)
		 {
		  LoadSide();
		  RestASCII(220,221);
		  RestASCII(223,224);
		  i=PutErrWin(GRAFtest,"Исправить","Не надо",t,r,"Ошибка");
		  if(i)
		   {
		      if (!t) t=1;
		      j=r-PPSExell.WinColumn/2;
		    if(j<=0)
		      {
		      PPSExell.Column=r;
		      PPSExell.OrgColumn=1;
		      }
		    else
		      {
		      PPSExell.OrgColumn=j;
		      PPSExell.Column=PPSExell.WinColumn/2;
		      }
		      j=t-PPSExell.WinRow/2;
		    if(j<=0)
		      {
		      PPSExell.Row=t;
		      PPSExell.OrgRow=1;
		      }
		    else
		      {
		      PPSExell.OrgRow=j;
		      PPSExell.Row=PPSExell.WinRow/2+1;
		      }
		   }
		  pullwin();
		 }
	       MenuReport.Line=-1;
	       if (i) goto EXELL;
		pullwin();
		LoadSide();
	       }
     if ((MenuReport.Line==2)&&(MenuReport.PopUp==0))
	       {
		pushwin();
		if (GRAFtest)
		  {
		   RestASCII(220,221);
		   RestASCII(223,224);
		   PutSysMsg(SysMsg[14],0,0);
		   i=0;
		   i=PutErrWin(GRAFtest,"Исправить","Не надо",t,r,"Ошибка");
		   PutSysMsg(SysMsg[0],0,0);
		   pullwin();
		   if (i) goto EXELL;
		    else goto LOOP;
		  }
		pullwin();
		initEpur(PPSEpur);
		DrawEpur("Эпюры Расписаний","Процессор");
		EpurEvent();
		pullwin();
		LoadSide();
	       }
     if ((MenuReport.Line==1)&&(MenuReport.PopUp==1))
	       {
		pushwin();
		LoadSide();
		ShowCur();
		PutWin(2,4,38,12,7,0,1,15,15,"Число процессоров...");
		VMput(6,7,"Текущее число процессоров :");
		VMput(6,9,"Новое число процессоров");
		textbar(31,9,36,9,9,15,0,0,"");
		itoa(QuanPr,s,10);
		VMput(33,7,s);
		i=QuanPr;
		s[0]=0;
		do
		{
		if(i) itoa(i,s,10);else s[0]=0;
		VMgetsXY(32,9,15,3,Ex,s);
		if (Ex==66) goto Pull;
		i=atoi(s);
		if ((i<1)||(i>maxprocs))
		 {
		  PutSysMsg(SysMsg[1],1,maxprocs);
		  i=0;
		  getch();
		  cbar(32,9,35,9,9,15,0);
		  PutSysMsg(SysMsg[0],0,0);
		 }
		}
		while (!i);
		QuanPr=i;
Pull:
;
		HideCur();
		pullwin();
	       }
     if ((MenuReport.Line==0)&&(MenuReport.PopUp==3))
	       {
		pushwin();
		  LoadSide();
		  RestASCII(220,221);
		  RestASCII(223,224);
		if (GrafEmpty())
		 if (!PutErrWin(10,"Все же создать","Игнорировать",0,0,
		     "Предупреждение"))
		   {
		    pullwin();
		    goto LOOP;
		   }
		   pullwin();
		InitFN(PPSFN);
		strcpy(Path,GetFileName("*.grf","Граф записать в файл..."));
		if (Path[0])
		{
		 Ex=PushGraf(Path);
		 if (Ex)
		 {
		   PutSysMsg(SysMsg[Ex],0,0);
		   getch();
		   PutSysMsg(SysMsg[0],0,0);
		 }
		}

		pullwin();
	       }
     if ((MenuReport.Line==0)&&(MenuReport.PopUp==2))
	       {
		pushwin();
		LoadSide();
		InitFN(PPSFN);
	      strcpy(Path,GetFileName("*.grf","Граф загрузить из файла..."));
		  LoadSide();
		  RestASCII(220,221);
		  RestASCII(223,224);
		if (!GrafEmpty())
		 if (!PutErrWin(12,"Удалить","Не удалять",0,0,
		     "Предупреждение"))
		   {
		    pullwin();
		    goto LOOP;
		   }
		  pullwin();
		if (Path[0])
		{
		 Ex=PullGraf(Path);
		 if (Ex)
		 {
		   PutSysMsg(SysMsg[Ex],0,0);
		   getch();
		   PutSysMsg(SysMsg[0],0,0);
		 }
		 else
		 {
		GRAFtest=0;
		GRAFtest=TESTgraf(t,r);
		pullwin();
		  i=0;
		if (GRAFtest)
		 {
		  LoadSide();
		  RestASCII(220,221);
		  RestASCII(223,224);
		  i=PutErrWin(GRAFtest,"Исправить","Не надо",t,r,"Ошибка");
		  if(i)
		   {
		      if (!t) t=1;
		      j=r-PPSExell.WinColumn/2;
		    if(j<=0)
		      {
		      PPSExell.Column=r;
		      PPSExell.OrgColumn=1;
		      }
		    else
		      {
		      PPSExell.OrgColumn=j;
		      PPSExell.Column=PPSExell.WinColumn/2;
		      }
		      j=t-PPSExell.WinRow/2;
		    if(j<=0)
		      {
		      PPSExell.Row=t;
		      PPSExell.OrgRow=1;
		      }
		    else
		      {
		      PPSExell.OrgRow=j;
		      PPSExell.Row=PPSExell.WinRow/2+1;
		      }
		   }
		  pullwin();
		 }
	       MenuReport.Line=-1;
	       if(i) goto EXELL;
		 }
		}
		pullwin();
	       }
     if ((MenuReport.Line==1)&&(MenuReport.PopUp==0))
	       {
		pushwin();
		LoadSide();
		if (!Model.GetCurrentTime())
		   {
		   PutSysMsg(SysMsg[18],0,0);
		   getch();
		   PutSysMsg(SysMsg[0],0,0);
		   goto LOOP;
		   }
		InitFN(PPSFN);
		strcpy(Path,GetFileName("*.sdl","Файл для записи отчета"));
		TASK=ConvertInit();
		if (Model.SaveStates(Path,PPSline.ItemName[4],
		       PPSline.ItemName[3],TASK))
		 {
		   PutSysMsg(SysMsg[17],0,0);
		   getch();
		   PutSysMsg(SysMsg[0],0,0);
		 }
		ConvertDone(TASK);

		pullwin();
	       }
     if (((MenuReport.Line==0)&&(MenuReport.PopUp==4))||(ch==107))
	       {
		pushwin();
		  LoadSide();
		  RestASCII(220,221);
		  RestASCII(223,224);
	      if (PutErrWin(14,"Выйти","Отмена",0,0,
		     "Внимание !"))    ch=107; else ch=0;
		pullwin();
	       }
    }
   while (ch!=107);
   chdir(Path);
   SetNormBG();
   RestVmode();
   textbackground(0);
   textcolor(7);
   clrscr();
   ShowCur();
 }
/*== Creatin' THE program ain't easy.And it's been no bed of roses ==*/