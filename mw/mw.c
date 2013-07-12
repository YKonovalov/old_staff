 /************************************************************/
 /*  This program is the most powerful aid                   */
 /*    to make your Course project culculations              */
 /*	    really easy                                      */
 /*	  Version 1.0                                        */
 /*	    (c) copyright Depth Corp.  1994.                 */
 /************************************************************/
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <dos.h>
#include <math.h>
#include "vmem.h"

typedef char *string;
typedef float *vect;
 vect printvect[60];
 string CopyRight[2]={"Все расчеты вылолнены программой MicroWork  версия 1.0",
		      " (C) copyright Yury Konovalov 1994.MAI,RUSSIA"};

 string ElemType[5]={"Прямоугольный тонкопленочный конденсатор",
		     "Прецизионный тонкопленочный конденсатор ",
		      "","",""};
 string EName[5]={"Конденсатор прямоугольный ",
		  "Конденсатор прецизионный","","",""};
 int ETypeNum=0;
 string DocSource[5]={"SC$$$&&&.SRC","PC$$$&&&.SRC","","",""};
 int MaxETNum=1;
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
    float     Deltaly=0.005,DeltaL=0.002,DeltaB=0.002;
    float     Deltah=0.002,Deltab=0.002;
    float     htex=0.01,btex=0.01;
    string    MatName[6]={"БКО.028.004","ЕТО.021.014",
			  "ЕТО.035.015","С-41-1 НПО.027.600","ЭХА","                         "};
    int       QuanCo[5]={2,3,4,4,3};
    float     Co[6][4]={{5000,10000,0,0},
			{5000,10000,15000,0},
			{2500,5000,10000,15000},
			{15000,20000,30000,40000},
			{60000,100000,200000,0},
			{0,0,0,0}};
    float     GammaCo[6]={3,3,3,3,3,0};
    float     eps[6]={5,12,4,5.2,23,0};
    float     Enp[6]={2,1,3,3,2,0};
    string    ElName[5]={"NoName","NoName","","",""};
    int       MatNum=0;
    int       CoNum=0;
/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
/*!! Прямоугольный конденсатор !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

/*---INPUT variables <default initialized>--------*/
    float     Kf=1.,Kz=4.,Kf_ob=1.;
    float     GammaCdop,Up,C;
/*-------------------------------------------------*/
    float     S,dmin,GammaSdop,Co_toch_max,Co_np_max,
	      Co_webr,dreal,L2,B2,L1,B1,Ld,Bd,
	      GammaS;
/*-------------------------------------------------------------------*/
/*!! Прецизионный конденсатор !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

/*---INPUT variables <default initialized>--------*/
    float      PKf=1,PKf_ob=1,PKf_c=1,PKz=4;
    float      PGammaCdop,PUp,PC;
/*-------------------------------------------------*/
float    Pdmin,Co_np,Ccek,Gamma_cek_t,Ccek_p,Co_tex_cek,
	 Co_wbr,PGammaS,GammaC,Cocn,Socn,Scek,b,h,Gamma_cek,
	 Ccek_pac,Scek_pac,bpac,hpac,Gamma_cek_pac,n,
	 Locn,Bocn,PL2,PB2,PL1,PB1,PLd,PBd,nb,nl,
	 tl,tb,lcl,lcb,PS;

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
   char ch,Ex,chr;
   char computingOn[5]={0,0,0,0,0};
/*-------------------------------------------------*/
void GetLine(FILE *F,char *line)
{
 char ch;
 int i=0;
 while (((ch=getc(F))!='\n')&&(ch!=EOF)) {line[i]=ch;i++;};
   line[i]=ch;
}
/*-------------------------------------------------*/
int FillFile(char *s,char *sout)
{
 FILE *In,*Out;
 char *P1,*P2;
 static char Index[80],st[80];
 int dec,sign,F;
 int Line=1,Ind,i;
 float fl;


 if ((In=fopen(s,"r"))==NULL){ return(-1);}
 if ((Out=fopen(sout,"w"))==NULL){fclose(In);return(-2);}

   do
   {
    for (i=0;i<80;i++) st[i]=0;
    GetLine(In,st);
    while ((P1=strstr(st,"|^"))!=0)
    {
     P2=strstr(st,"~");
     strcpy(Index,P1+2);
     if(P2<P1) {fclose(In);fclose(Out);return(Line);};
     F=P2-P1-1;
     for (i=0;i<F;i++) Index[i]=*(P1+2+i);
     Index[F-1]=0;
     Ind=atoi(Index);
     if (Ind==0) {fclose(In);fclose(Out);return(Line);};
     if (Ind>2) gcvt(*printvect[Ind],F,Index);
     for (i=0;i<F+2;i++) *(P1+i)=32;
     if (Ind==1)
	      {
	       if (F>strlen(ElName[ETypeNum])) F=strlen(ElName[ETypeNum]);
	       for(i=0;i<F;i++) Index[i]=ElName[ETypeNum][i];
	       Index[F]=0;
	      };
     if (Ind==2)
	      {
	       if (F>strlen(MatName[MatNum])) F=strlen(MatName[MatNum]);
	       for(i=0;i<F;i++) Index[i]=MatName[MatNum][i];
	       Index[F]=0;
	      };
     for (i=0;i<strlen(Index);i++) *(P1+1+i)=Index[i];
    }
    fprintf(Out,"%s",st);
    Line++;
    Index[0]=EOF;Index[1]=0;
   }
   while (strstr(st,Index)==NULL);
   fclose(In);
    fprintf(Out,"%s\n",CopyRight[0]);
    fprintf(Out,"%s\n",CopyRight[1]);
   fclose(Out);
   return(0);
}
/*-------------------------------------------------*/

float min(float f1, float f2, float f3)
 {
  float m;

  if (f1<f2)  m=f1; else m=f2;
  if (f3<m) m=f3;
  return(m);
 }
/*-------------------------------------------------*/
double round(double f,double R)
 {
  return(R*ceil(f/R));
 }
/*-------------------------------------------------*/
void GetMatS()
{
   VMgetfXY(43,6,14,6,5000,200000,Ex,Co[MatNum][CoNum]);   if(Ex==66) return;
   VMgetfXY(43,8,14,2,1,25,Ex,eps[MatNum]);         if(Ex==66) return;
   VMgetfXY(43,10,14,1,1,5,Ex,Enp[MatNum]);         if(Ex==66) return;
   VMgetfXY(43,12,14,3,1,100,Ex,GammaCo[MatNum]);   if(Ex==66) return;
}
/*-------------------------------------------------*/
int ParamS()
{
   int i,j;
   char str[80];
   float fl;

param:
;
   textbar(2,3,78,21,15,1,1," Исходные данные ");

   textweb(18,4,49,1,6);
   VMputXY(4,4,0,"Материал (ТУ)");

   textweb(69,4,76,1,4);
   VMputXY(52,4,0,"Имя элемента");

   textrect(3,5,50,13,0," Параметры диэлектрика ");
   textweb(42,6,49,4,1);
   VMputXY(4,6,0,"Удельная емкость Co пФ/см¤");
   VMputXY(4,8,0,"Диэлектрическая проницаемость eps");
   VMputXY(4,10,0,"Электрическая прочность Eпр*10^-6,B/см");
   VMputXY(4,12,0,"Допуск на удельную емкость GammaCo,%");
   textrect(3,14,50,20,0," Данные о конденсаторе ");
   textweb(42,15,49,3,1);
   VMputXY(4,15,0,"Номинальная емкость C,пФ");
   VMputXY(4,17,0,"Рабочее напряжение Up,B");
   VMputXY(4,19,0,"Допуск на емкость GammaCдоп,%");

   textrect(51,5,77,11,0," Коэффициенты ");
   textweb(69,6,76,3,3);
   VMputXY(52,6,0,"Кфф.формы Кф");
   VMputXY(52,8,0,"Кф.вeрхн.обкл.");
   VMputXY(52,10,0,"Кфф. запаса Kз");

   textrect(51,12,77,18,0," Постоянные ");
   textweb(69,13,76,3,2);
   VMputXY(52,13,0,"Delta.L,см");
   VMputXY(52,15,0,"Delta.B,см");
   VMputXY(52,17,0,"Delta.lу,см");

	  VMputXY(19,4,14,MatName[MatNum]);
	  VMputXY(70,4,14,ElName[ETypeNum]);
   if(Kf) VMputXY(70,6,14,gcvt(Kf,6,str));
   if(Kf_ob) VMputXY(70,8,14,gcvt(Kf_ob,6,str));
   if(Kz) VMputXY(70,10,14,gcvt(Kz,6,str));
   if(DeltaL) VMputXY(70,13,14,gcvt(DeltaL,6,str));
   if(DeltaB) VMputXY(70,15,14,gcvt(DeltaB,6,str));
   if(Deltaly) VMputXY(70,17,14,gcvt(Deltaly,6,str));

   if(C) VMputXY(43,15,14,gcvt(C,6,str));
   if(Up) VMputXY(43,17,14,gcvt(Up,6,str));
   if(GammaCdop) VMputXY(43,19,14,gcvt(GammaCdop,6,str));
Redraw:
;

   if(Co[MatNum][CoNum]) VMputXY(43,6,14,gcvt(Co[MatNum][CoNum],6,str));
   if(eps[MatNum]) VMputXY(43,8,14,gcvt(eps[MatNum],6,str));
   if(Enp[MatNum]) VMputXY(43,10,14,gcvt(Enp[MatNum],6,str));
   if(GammaCo[MatNum]) VMputXY(43,12,14,gcvt(GammaCo[MatNum],6,str));
     str[0]=25;str[1]=0;
   VMputXYB(49,4,1,10,str);
   if(MatNum!=5) VMputXYB(41,6,1,10,str);

 ShowCur(10);

 do
  {
   strcpy(str,MatName[MatNum]);
   VMgetsXY(19,4,14,20,Ex,str);         if(Ex==66) return(-1);
     if (Ex==80) {
		   pushwin();
		   HideCur();
		   textbar(17,4,49,11,1,15,1,"");
		   for(i=0;i<=4;i++) VMputXY(18,5+i,15,MatName[i]);
		   i=0;
		   do
		    {
		     tbar(18,5+i,48,5+i,2,11);
		     j=i;
		     ch=getch();while(kbhit()) ch=getch();
		     if((ch==80)&&(i<4)) i++;
		     if((ch==72)&&(i>0)) i--;
		     if(i!=j) tbar(18,5+j,48,5+j,1,15);
		    }
		   while ((ch!=13)&&(ch!=27));
		   pullwin();
		   if(ch==13) {
			       MatNum=i;
			       textweb(18,4,49,1,6);
			       goto Redraw;
			      }
		   ShowCur(10);
		 }
     if (strcmp(str,MatName[MatNum]))
	 {
	  MatNum=5;CoNum=1;
	  strcpy(MatName[MatNum],str);
	  textweb(42,6,49,4,1);
	  textweb(41,6,41,1,15);
	 };
 if (MatNum==5){GetMatS();if(Ex==66) return(-1);}
CoGet:
;
if (!(MatNum==5))
 {
    fl=Co[MatNum][CoNum];
   VMgetflXY(43,6,14,6,Co[MatNum][0],
    Co[MatNum][QuanCo[MatNum]-1],Ex,fl);   if(Ex==66) return(-1);
     if (Ex==80) {
		   pushwin();
		   HideCur();
		   textbar(41,6,54,12,1,15,1,"");
		   for(i=0;i<QuanCo[MatNum];i++)
		    VMputXY(44,7+i,15,gcvt(Co[MatNum][i],6,str));
		   i=0;
		   do
		    {
		     tbar(42,7+i,53,7+i,2,11);
		     j=i;
		     ch=getch();while(kbhit()) ch=getch();
		     if((ch==80)&&(i<(QuanCo[MatNum])-1)) i++;
		     if((ch==72)&&(i>0)) i--;
		     if(i!=j) tbar(42,7+j,53,7+j,1,15);
		    }
		   while ((ch!=13)&&(ch!=27));
		   pullwin();
		   ShowCur(10);
		   if(ch==13) {
			       CoNum=i;
			       textweb(42,6,49,1,1);
			       goto CoGet;
			      }
		 }
		 j=166;
     for (i=0;i<QuanCo[MatNum];i++)
      { if (fl==Co[MatNum][i]) j=i;}

     if (j!=166) CoNum=j;
     else {
	   VMputXY(13,24,12,
	   "Этот материал не применяется с таким значением Co");
	   ch=getch();
	   VMputXY(13,24,4,
	   "                                                 ");
	   goto CoGet;
	  };
 }
   VMgetfXY(43,15,14,5,1,10000,Ex,C);       if(Ex==66) return(-1);
   VMgetfXY(43,17,14,4,0.5,60,Ex,Up);       if(Ex==66) return(-1);
   VMgetfXY(43,19,14,3,1,100,Ex,GammaCdop); if(Ex==66) return(-1);
   if (Ex==1)
    {
   do{
   VMgetsXY(70,4,14,4,Ex,ElName[ETypeNum]);                 if(Ex==66) return(-1);
     }while (Ex==80);
     VMgetfXY(70,6,14,6,0.1,10,Ex,Kf);               if(Ex==66) return(-1);
     VMgetfXY(70,8,14,6,0.1,10,Ex,Kf_ob);            if(Ex==66) return(-1);
     VMgetfXY(70,10,14,6,2,4,Ex,Kz);                 if(Ex==66) return(-1);
     if (Ex==1)
     {
      VMgetfXY(70,13,14,6,0.001,1,Ex,DeltaL);         if(Ex==66) return(-1);
      VMgetfXY(70,15,14,6,0.001,1,Ex,DeltaB);         if(Ex==66) return(-1);
      VMgetfXY(70,17,14,6,0.001,1,Ex,Deltaly);        if(Ex==66) return(-1);
     }
    }
  }
 while (Ex==1);
HideCur();
return(0);
}
/*-------------------------------------------------*/
void CalcS()
{
  /*1*/ S=C/Co[MatNum][CoNum];
  /*2*/ dmin=(Up*Kz)/(Enp[MatNum]*1000000);
  /*3*/ Co_np_max=0.0885*(eps[MatNum]/dmin);
  /*4*/ GammaSdop=sqrt(pow(GammaCdop/100,2)-pow(GammaCo[MatNum]/100,2))*100;
  /*5*/ Co_toch_max=C*(pow((GammaSdop/100)/DeltaL,2))*(Kf_ob/pow(1+Kf_ob,2));
  /*6*/ Co_webr=min(Co_np_max,Co_toch_max,Co[MatNum][CoNum]);
  /*7*/ dreal=(0.0085*(eps[MatNum]/Co_webr))*10000;
  /*8*/ L2=sqrt(Kf_ob*S);
	B2=sqrt(S/Kf_ob);
	L1=L2+2*(DeltaL+Deltaly);
	B1=B2+2*(DeltaB+Deltaly);
  /*9*/ Ld=L1+(DeltaL+Deltaly);
	Bd=B1+(DeltaB+Deltaly);
 /*10*/ GammaS=(DeltaL/L2+DeltaB/B2)*100;
	  computingOn[ETypeNum]=1;
    printvect[3]=&Co[MatNum][CoNum];
    printvect[4]=&eps[MatNum];
    printvect[5]=&Enp[MatNum];
    printvect[6]=&GammaCo[MatNum];
    printvect[7]=&C;
    printvect[8]=&Up;
    printvect[9]=&GammaCdop;
    printvect[10]=&Kf;
    printvect[11]=&Kf_ob;
    printvect[12]=&Co_np_max;
    printvect[13]=&DeltaL;
    printvect[14]=&DeltaB;
    printvect[15]=&Deltaly;
    printvect[16]=&S;
    printvect[17]=&dmin;
    printvect[18]=&GammaSdop;
    printvect[19]=&Co_toch_max;
    printvect[20]=&Co_webr;
    printvect[21]=&dreal;
    printvect[22]=&L1;
    printvect[23]=&B1;
    printvect[24]=&L2;
    printvect[25]=&B2;
    printvect[26]=&Ld;
    printvect[27]=&Bd;
    printvect[28]=&GammaS;
    printvect[29]=&Kz;


 textbar(2,4,52,17,9,15,1," Результаты ");
 window(4,5,75,19);
 textbackground(1);
 textcolor(10+BLINK);
    cprintf("1. S= %f см¤\n\r",S);
    cprintf("2. dmin= %f см\n\r",dmin);
    cprintf("3. Co.пр.max= %f пФ/см\n\r",Co_np_max);
    cprintf("4. GammaSdop= %f %\n\r",GammaSdop);
    cprintf("5. Co.точн.max= %f пФ/см\n\r",Co_toch_max);
    cprintf("6. Co.выбр= %f пФ/см\n\r",Co_webr);
    cprintf("7. dреал= %f см\n\r",dreal);
    cprintf("8. L2= %f см; B2= %f см\n\r",L2,B2);
    cprintf("   L1= %f см; B1= %f см\n\r",L1,B1);
    cprintf("9. Lд= %f см; Bд= %f см\n\r",Ld,Bd);
    cprintf("10. GammaSдоп>=GammaS= %f %\n\r",GammaS);
 /*11*/ if (GammaS<=GammaSdop)
	 cprintf("Топология соответствует заданному допуску.\n\r");
	else
	 cprintf("Топология НЕ соответствует заданному допуску !!!\n\r");
}
/*-------------------------------------------------*/
void GetMatP()
{
   VMgetfXY(43,6,14,6,5000,200000,Ex,Co[MatNum][CoNum]);   if(Ex==66) return;
   VMgetfXY(43,6,14,6,5000,200000,Ex,Co[MatNum][QuanCo[MatNum]-1]);
	   if(Ex==66) return;
   VMgetfXY(43,6,14,6,5000,200000,Ex,Co[MatNum][0]);   if(Ex==66) return;
   VMgetfXY(43,8,14,2,1,25,Ex,eps[MatNum]);         if(Ex==66) return;
   VMgetfXY(43,10,14,1,1,5,Ex,Enp[MatNum]);         if(Ex==66) return;
   VMgetfXY(43,12,14,3,1,100,Ex,GammaCo[MatNum]);   if(Ex==66) return;
}
/*-------------------------------------------------*/
int ParamP()
{
   int i,j;
   char str[80];
   float fl;

param:
;
   textbar(2,3,78,21,15,1,1," Исходные данные ");

   textweb(18,4,49,1,6);
   VMputXY(4,4,0,"Материал (ТУ)");

   textweb(69,4,76,1,4);
   VMputXY(54,4,0,"Имя элемента");

   textrect(3,5,30,17,0," Параметры диэлектрика ");
   textweb(22,6,29,6,1);
   VMputXY(4,6,0,"Co пФ/см¤");
   VMputXY(4,8,0,"Co.max пФ/см¤");
   VMputXY(4,10,0,"Co.min пФ/см¤");
   VMputXY(4,12,0,"eps");
   VMputXY(4,14,0,"Eпр*10^-6,B/см");
   VMputXY(4,16,0,"GammaCo,%");

   textrect(31,5,53,11,0," Данные ");
   textweb(45,6,52,3,1);
   VMputXY(33,6,0,"C,пФ");
   VMputXY(33,8,0,"Up,B");
   VMputXY(33,10,0,"GammaCдоп,%");

   textrect(31,12,53,20,0," Коэффициенты ");
   textweb(45,13,52,4,3);
   VMputXY(33,13,0,"Кф");
   VMputXY(33,15,0,"Кф.об");
   VMputXY(33,17,0,"Кф.с");
   VMputXY(33,19,0,"Кз");

   textrect(54,5,77,19,0," Постоянные ");
   textweb(69,6,76,7,2);
   VMputXY(55,6,0,"Delta.L,см");
   VMputXY(55,8,0,"Delta.B,см");
   VMputXY(55,10,0,"Delta.lу,см");
   VMputXY(55,12,0,"Delta.h,см");
   VMputXY(55,14,0,"Delta.b,см");
   VMputXY(55,16,0,"h.техн,см");
   VMputXY(55,18,0,"b.техн,см");

	  VMputXY(19,4,14,MatName[MatNum]);
	  VMputXY(70,4,14,ElName[ETypeNum]);
   if(PC) VMputXY(46,6,14,gcvt(PC,6,str));
   if(PUp) VMputXY(46,8,14,gcvt(PUp,6,str));
   if(PGammaCdop) VMputXY(46,10,14,gcvt(PGammaCdop,6,str));
   if(PKf) VMputXY(46,13,14,gcvt(PKf,6,str));
   if(PKf_ob) VMputXY(46,15,14,gcvt(PKf_ob,6,str));
   if(PKf_c) VMputXY(46,17,14,gcvt(PKf_c,6,str));
   if(PKz) VMputXY(46,19,14,gcvt(PKz,6,str));
   if(DeltaL) VMputXY(70,6,14,gcvt(DeltaL,6,str));
   if(DeltaB) VMputXY(70,8,14,gcvt(DeltaB,6,str));
   if(Deltaly) VMputXY(70,10,14,gcvt(Deltaly,6,str));
   if(Deltah) VMputXY(70,12,14,gcvt(Deltah,6,str));
   if(Deltab) VMputXY(70,14,14,gcvt(Deltab,6,str));
   if(htex) VMputXY(70,16,14,gcvt(htex,6,str));
   if(btex) VMputXY(70,18,14,gcvt(btex,6,str));

Redraw:
;

   if(Co[MatNum][CoNum]) VMputXY(23,6,14,gcvt(Co[MatNum][CoNum],6,str));
   if(Co[MatNum][QuanCo[MatNum]-1])
	      VMputXY(23,8,14,gcvt(Co[MatNum][QuanCo[MatNum]-1],6,str));
   if(Co[MatNum][0]) VMputXY(23,10,14,gcvt(Co[MatNum][0],6,str));
   if(eps[MatNum]) VMputXY(23,12,14,gcvt(eps[MatNum],6,str));
   if(Enp[MatNum]) VMputXY(23,14,14,gcvt(Enp[MatNum],6,str));
   if(GammaCo[MatNum]) VMputXY(23,16,14,gcvt(GammaCo[MatNum],6,str));
     str[0]=25;str[1]=0;
   VMputXYB(49,4,1,10,str);
   if(MatNum!=5) VMputXYB(21,6,1,10,str);

 ShowCur(10);

 do
  {
   strcpy(str,MatName[MatNum]);
   VMgetsXY(19,4,14,20,Ex,str);         if(Ex==66) return(-1);
     if (Ex==80) {
		   pushwin();
		   HideCur();
		   textbar(17,4,49,11,1,15,1,"");
		   for(i=0;i<=4;i++) VMputXY(18,5+i,15,MatName[i]);
		   i=0;
		   do
		    {
		     tbar(18,5+i,48,5+i,2,11);
		     j=i;
		     ch=getch();while(kbhit()) ch=getch();
		     if((ch==80)&&(i<4)) i++;
		     if((ch==72)&&(i>0)) i--;
		     if(i!=j) tbar(18,5+j,48,5+j,1,15);
		    }
		   while ((ch!=13)&&(ch!=27));
		   pullwin();
		   if(ch==13) {
			       MatNum=i;
			       textweb(18,4,49,1,6);
			       goto Redraw;
			      }
		   ShowCur(10);
		 }
     if (strcmp(str,MatName[MatNum]))
	 {
	  MatNum=5;CoNum=1;
	  strcpy(MatName[MatNum],str);
	  textweb(22,6,29,6,1);
	  textweb(21,6,21,1,15);
	 };
 if (MatNum==5){GetMatP();if(Ex==66) return(-1);}
CoGet:
;
if (!(MatNum==5))
 {
    fl=Co[MatNum][CoNum];
   VMgetflXY(23,6,14,6,Co[MatNum][0],
    Co[MatNum][QuanCo[MatNum]-1],Ex,fl);   if(Ex==66) return(-1);
     if (Ex==80) {
		   pushwin();
		   HideCur();
		   textbar(21,6,34,12,1,15,1,"");
		   for(i=0;i<QuanCo[MatNum];i++)
		    VMputXY(24,7+i,15,gcvt(Co[MatNum][i],6,str));
		   i=0;
		   do
		    {
		     tbar(22,7+i,33,7+i,2,11);
		     j=i;
		     ch=getch();while(kbhit()) ch=getch();
		     if((ch==80)&&(i<(QuanCo[MatNum])-1)) i++;
		     if((ch==72)&&(i>0)) i--;
		     if(i!=j) tbar(22,7+j,33,7+j,1,15);
		    }
		   while ((ch!=13)&&(ch!=27));
		   pullwin();
		   ShowCur(10);
		   if(ch==13) {
			       CoNum=i;
			       textweb(22,6,29,1,1);
			       goto CoGet;
			      }
		 }
		 j=166;
     for (i=0;i<QuanCo[MatNum];i++)
      { if (fl==Co[MatNum][i]) j=i;}

     if (j!=166) CoNum=j;
     else {
	   VMputXY(13,24,12,
	   "Этот материал не применяется с таким значением Co");
	   ch=getch();
	   VMputXY(13,24,4,
	   "                                                 ");
	   goto CoGet;
	  };
 }
   VMgetfXY(46,6,14,5,1,10000,Ex,PC);       if(Ex==66) return(-1);
   VMgetfXY(46,8,14,4,0.5,60,Ex,PUp);       if(Ex==66) return(-1);
   VMgetfXY(46,10,14,3,1,100,Ex,PGammaCdop); if(Ex==66) return(-1);
   if (Ex==1)
    {
     VMgetfXY(46,13,14,6,0.1,10,Ex,PKf);               if(Ex==66) return(-1);
     VMgetfXY(46,15,14,6,0.1,10,Ex,PKf_ob);            if(Ex==66) return(-1);
     VMgetfXY(46,17,14,6,0.1,10,Ex,PKf_c);            if(Ex==66) return(-1);
     VMgetfXY(46,19,14,6,2,4,Ex,PKz);                 if(Ex==66) return(-1);
    if(Ex==1)
     {
       do{
       VMgetsXY(70,4,14,4,Ex,ElName[ETypeNum]);          if(Ex==66) return(-1);
	 }while (Ex==80);
      VMgetfXY(70,6,14,6,0.001,1,Ex,DeltaL);         if(Ex==66) return(-1);
      VMgetfXY(70,8,14,6,0.001,1,Ex,DeltaB);         if(Ex==66) return(-1);
      VMgetfXY(70,10,14,6,0.001,1,Ex,Deltaly);        if(Ex==66) return(-1);
      VMgetfXY(70,12,14,6,0.001,1,Ex,Deltah);        if(Ex==66) return(-1);
      VMgetfXY(70,14,14,6,0.001,1,Ex,Deltab);        if(Ex==66) return(-1);
      VMgetfXY(70,16,14,6,0.001,1,Ex,htex);        if(Ex==66) return(-1);
      VMgetfXY(70,18,14,6,0.001,1,Ex,btex);        if(Ex==66) return(-1);
     }
    }
  }
 while (Ex==1);
HideCur();
return(0);
}
/*-------------------------------------------------*/
int CalcP()
{
  /*1*/ Pdmin=(PUp*PKz)/(Enp[MatNum]*1000000);
  /*2*/ Co_np=0.0885*(eps[MatNum]/Pdmin);
  /*3*/ Ccek=PC*((2*PGammaCdop)/100);
	Gamma_cek_t=100*sqrt(pow(GammaCo[MatNum]/100,2)+pow(Deltah/htex,2)+
			     pow(Deltab/btex,2));
	Ccek_p=Ccek/(1+Gamma_cek_t/100);
  /*4*/ Co_tex_cek=Ccek_p/(btex*htex);
	Co_wbr=min(Co_np,Co[MatNum][QuanCo[MatNum]-1],Co_tex_cek);
	if (Co_wbr<Co[MatNum][0]) Co_wbr=Co[MatNum][0];

  /*5*/ PS=PC/Co_wbr;
	PGammaS=((DeltaL/sqrt(PS))*((1+PKf_ob)/sqrt(PKf_ob)))*100;
	GammaC=sqrt(pow(PGammaS/100,2)+pow(GammaCo[MatNum]/100,2))*100;
	if (GammaC<=PGammaCdop) return(3);

  /*6*/ Cocn=PC*((1+PGammaCdop/100)/(1+GammaC/100));
	Socn=Cocn/Co_wbr;

  /*7*/ Scek=Ccek_p/Co_wbr;
	b=sqrt(PKf_c*Scek);
	h=sqrt(Scek/PKf_c);
	Gamma_cek=sqrt(pow(GammaCo[MatNum]/100,2)+pow(Deltah/h,2)+
		       pow(Deltab/b,2))*100;

  /*8*/ Ccek_pac=Ccek_p/(1+Gamma_cek/100);
	Scek_pac=round(Ccek_pac/Co[MatNum][CoNum],0.000001);
	bpac=round(sqrt(PKf_c*Scek_pac),0.001);
	hpac=round(sqrt(Scek_pac/PKf_c),0.001);
	Gamma_cek_pac=sqrt(pow(GammaCo[MatNum]/100,2)+pow(Deltah/hpac,2)+
			   pow(Deltab/bpac,2))*100;
  /*9*/ n=ceil((PC*(1-PGammaCdop/100)-Cocn*(1-GammaC/100))/
	     (Ccek_pac*(1-Gamma_cek_pac/100)));
 /*10*/ Locn=sqrt(Kf_ob*Socn);
	Bocn=sqrt(Socn/Kf_ob);
 /*11*/ PL2=Locn+h;
	PB2=Bocn+h;
 /*12*/ PL1=PL2+2*(DeltaL+Deltaly);
	PB1=PB2+2*(DeltaB+Deltaly);
	PLd=PL1+2*(DeltaL+Deltaly);
	PBd=PB1+2*(DeltaB+Deltaly);
 /*13*/ if(n>=2) nb=n/2;else nb=n;
	nl=n-nb;
	if(nl) tl=Locn/nl;
	if(nb) tb=Locn/nb;
 /*14*/ if(tl) lcl=tl-b;
	if(tb) lcb=tb-b;
	computingOn[ETypeNum]=1;
    printvect[3]=&Co[MatNum][CoNum];
    printvect[4]=&eps[MatNum];
    printvect[5]=&Enp[MatNum];
    printvect[6]=&GammaCo[MatNum];
    printvect[7]=&PC;
    printvect[8]=&PUp;
    printvect[9]=&PGammaCdop;
    printvect[10]=&PKf;
    printvect[11]=&PKf_ob;
    printvect[12]=&PKf_c;
    printvect[13]=&PKz;
    printvect[14]=&Co[MatNum][0];
    printvect[15]=&Co[MatNum][QuanCo[MatNum]-1];
    printvect[16]=&DeltaL;
    printvect[17]=&DeltaB;
    printvect[18]=&Deltaly;
    printvect[19]=&Deltah;
    printvect[20]=&Deltab;
    printvect[21]=&htex;
    printvect[22]=&btex;
    printvect[23]=&Pdmin;
    printvect[24]=&Co_np;
    printvect[25]=&Ccek;
    printvect[26]=&Gamma_cek_t;
    printvect[27]=&Ccek_p;
    printvect[28]=&Co_tex_cek;
    printvect[29]=&Co_wbr;
    printvect[30]=&PGammaS;
    printvect[31]=&GammaC;
    printvect[32]=&Cocn;
    printvect[33]=&Socn;
    printvect[34]=&Scek;
    printvect[35]=&b;
    printvect[36]=&h;
    printvect[37]=&Gamma_cek;
    printvect[38]=&Ccek_pac;
    printvect[39]=&Scek_pac;
    printvect[40]=&bpac;
    printvect[41]=&hpac;
    printvect[42]=&Gamma_cek_pac;
    printvect[43]=&n;
    printvect[44]=&Locn;
    printvect[45]=&Bocn;
    printvect[46]=&PL2;
    printvect[47]=&PB2;
    printvect[48]=&PL1;
    printvect[49]=&PB1;
    printvect[50]=&PLd;
    printvect[51]=&PBd;
    printvect[52]=&nb;
    printvect[53]=&nl;
    printvect[54]=&tl;
    printvect[55]=&tb;
    printvect[56]=&lcl;
    printvect[57]=&lcb;
    printvect[58]=&PS;

 textbar(2,4,78,21,9,15,1," Результаты ");
 window(4,5,40,21);      textbackground(1);
 textcolor(10+BLINK);
    cprintf("1. dmin= %f см¤\n\r",Pdmin);
    cprintf("2. Co.пр= %f пФ/см\n\r",Co_np);
    cprintf("3. Ccek= %f пФ\n\r",Ccek);
    cprintf("   Gamma_cek_t= %f %\n\r",Gamma_cek_t);
    cprintf("   Ccek_p= %f пФ\n\r",Ccek_p);
    cprintf("4. Co.техн.секц= %f пФ/см\n\r",Co_tex_cek);
    cprintf("   Co.выбр= %f пФ/см\n\r",Co_wbr);
    cprintf("5. GammaS= %f %\n\r",PGammaS);
    cprintf("   GammaC= %f %\n\r",GammaC);
    cprintf("6. Cocn= %f пФ\n\r",Cocn);
    cprintf("   Socn= %f см¤\n\r",Socn);
    cprintf("7. Scek= %f см¤\n\r",Scek);
    cprintf("   b= %f см\n\r",b);
    cprintf("   h= %f см\n\r",h);
    cprintf("   Gamma_cek= %f %\n\r",Gamma_cek);
  window(41,5,80,21);

    cprintf("8. Ccek_pac= %f пФ\n\r",Ccek_pac);
    cprintf("   Scek_pac= %f см¤\n\r",Scek_pac);
    cprintf("   bpac= %f см\n\r",bpac);
    cprintf("   hpac= %f см\n\r",hpac);
    cprintf("   Gamma_cek_pac= %f %\n\r",Gamma_cek_pac);
    cprintf("9. n= %5.1f \n\r",n);
    cprintf("10. Locn= %6.4f см\n\r",Locn);
    cprintf("    Bocn= %6.4f см\n\r",Bocn);
    cprintf("11. L2= %6.4f см; B2= %6.4f см\n\r",PL2,PB2);
    cprintf("12. L1= %6.4f см; B1= %6.4f см\n\r",PL1,PB1);
    cprintf("    Lд= %6.4f см; Bд= %6.4f см\n\r",PLd,PBd);
    cprintf("13. nb= %7.3f ; nl= %7.3f \n\r",nb,nl);
    cprintf("    tb= %5.3f см; tl= %5.3f см\n\r",tb,tl);
    cprintf("    lcb= %5.3f см; lcl= %5.3f см\n\r",lcb,lcl);
  return(0);
}
/*-------------------------------------------------*/
void Close()
{
   HideCur();
   window(1,1,80,25);
   textbar(1,3,80,23,7,1,0,"");
}
/*-------------------------------------------------*/
void main()
 {
   char buf[80],mstr[80];
   int i,j;

  initVMEM();
 SetLightBG();
 HideCur();
 textbackground(7);
 textcolor(0+BLINK);
 textbar(1,2,80,24,7,1,0,"");
 textbar(1,1,80,1,15,1,0,"");
 textbar(1,2,80,2,5,1,0,"");
 textbar(1,25,80,25,15,1,0,"");
 textbar(1,24,80,24,8,1,0,"");
 VMputXY(6,1,0,"MicroWork  версия 1.0 (c) copyright Yury Konovalov 1994 MAI,RUSSIA");
 VMputXYB(1,2,15,0," Элемент: ");
 VMputXY(2,25,4,"F1");
 VMputXY(5,25,0,"Параметры");
 VMputXY(17,25,4,"F2");
 VMputXY(21,25,0,"Создать документ");
 VMputXY(40,25,4,"F3");
 VMputXY(43,25,0,"Выбрать элемент");
 VMputXY(70,25,4,"Esc");
 VMputXY(75,25,0,"Выход");
 VMputXYB(1,24,15,3," Сообщение:");
 VMputXY(12,2,15,ElemType[ETypeNum]);

   do
    {
     ch=getch();
     while (kbhit()) ch=getch();
Event:
;
     if (ch==59)
	       {
		switch (ETypeNum)
		 {
		case 0: if (!ParamS()) {CalcS(); ch=getch();} break;
		case 1: if (!ParamP())
		  {
		   i=CalcP();
		   ch=getch();} break;
		 }
	     ShowCur(10);
	     Close();
	     ch=0;
	       };
     if ((ch==60)&&computingOn[ETypeNum])
	{
	 pushwin();
	 ShowCur(10);
	 textbar(20,10,70,12,1,10,1,"");
	 tbar(34,11,68,11,2,15);
	 VMputXY(22,11,14,"Имя файла:");
	 mstr[0]=0;
	 VMgetsXY(35,11,15,33,Ex,mstr);
	  if (Ex!=66)
	   {
	 i=FillFile(DocSource[ETypeNum],mstr);
	 if (i==-1)
	      {
	       VMputXY(13,24,12,
	       "Невозможно открыть служебный файл.Документ не создан!!!!!");
	       ch=getch();
	      };
	 if (i==-2)
	      {
	       VMputXY(13,24,12,
	       "Невозможно создать документ.Вероятно нет места на диске!");
	       ch=getch();
	      };
	 if (i>0)
	      {
	       strcpy(mstr,"Документ не создан-ошибка в служебном файле.Строка :");
	       VMputXY(13,24,12,mstr);
	       ch=getch();
	      };
	   }
	 pullwin();
	 HideCur();
	  if(ch==27) ch=0;
	      ch=getch();
	      while (kbhit()) ch=getch();
	 ShowCur(10);
	  if (ch==27) {Close();ch=0;}
	     else goto Event;
	}
     if (ch==61)
	{
	 pushwin();
	  textbar(6,2,46,8,11,0,1,"");
	  for(i=0;i<=MaxETNum;i++) VMputXY(8,3+i,0,EName[i]);
	  i=0;
	  do
	   {
	    tbar(7,3+i,45,3+i,1,12);
	    j=i;
	    ch=getch();while(kbhit()) ch=getch();
	    if((ch==80)&&(i<MaxETNum)) i++;
	    if((ch==72)&&(i>0)) i--;
	    if(i!=j) tbar(7,3+j,45,3+j,11,0);
	   }
	  while ((ch!=13)&&(ch!=27));
	  pullwin();
	  if(ch==13) {
		      ETypeNum=i;
		      VMputXY(12,2,15,ElemType[ETypeNum]);
		     }
	     ch=0;
	}
      }
   while (ch!=27);
   SetNormBG();
   textbackground(0);
   clrscr();
   ShowCur(7);
 }
