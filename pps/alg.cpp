
//*************************************//
// Дефиниции для модуля ALG.CPP.       //
// Версия 1.4, Дек. 1994.              //
// (c) Copyright Дмитрий В. Корнилов,  //
//               Юрий    И. Ровенский, //
//               Feedback corp.        //
//*************************************//

#include <stdlib.h>
#include <dos.h>
#include <io.h>
#include <string.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "alg.h"

int Algoritms::alg0(void) // критерий по минимуму индекса
			  // выполняется всегда
			  // в меню не выводится
   {
   UCHAR tmp=0;
   for (int i=cnttasks; i>=1; i--)
      if (taskstate[i].begtime==task_maybesolve)
	 {
	 tmp=i;
	 taskstate[i].begtime=task_ready;
	 }
   return tmp;
   };

int Algoritms::alg1(void) // критерий по случайному индексу задачи
   {
   UCHAR ctask=0,
	 tmp=0;
   for (int i=1; i<=cnttasks; i++)
      if (taskstate[i].begtime==task_maybesolve)
	 ctask++;
   tmp=random(ctask)+1;
   for (i=1; i<=cnttasks; i++)
      if (taskstate[i].begtime==task_maybesolve)
	 if (!(--tmp))
	    {
	    tmp=i;
	    break;
	    }
   for (i=1; i<=cnttasks; i++)
      {
      if ((taskstate[i].begtime==task_maybesolve)&&
	  (i!=tmp))
	       taskstate[i].begtime=task_ready;
      }
   return tmp;
   };

int Algoritms::alg2(void) // критерий по максимуму веса задачи
   {
   UCHAR ctask=0,
	 counter=0;
   for (int i=1; i<=cnttasks; i++)
      if (taskstate[i].begtime==task_maybesolve)
	 {
	 ctask=i;
	 break;
	 }
   for (i=ctask+1; i<=cnttasks; i++)
      {
      if (taskstate[i].begtime==task_maybesolve)
	 {
	 if (tasks[i].weight>tasks[ctask].weight)
	    {
	    ctask=i;
	    counter=0;
	    }
	 else
	    if (tasks[i].weight==tasks[ctask].weight)
	       counter++;
	 }
      }
   for (i=1; i<=cnttasks; i++)
      {
      if (taskstate[i].begtime==task_maybesolve)
	 {
	 if (tasks[i].weight!=tasks[ctask].weight)
	    {
	    taskstate[i].begtime=task_ready;
	    }
	 }
      }
   if (counter) return 0;
   return ctask;
   };

int Algoritms::alg3(void) // критерий по минимуму веса задачи
   {
   UCHAR ctask=0,
	 counter=0;
   for (int i=1; i<=cnttasks; i++)
      if (taskstate[i].begtime==task_maybesolve)
	 {
	 ctask=i;
	 break;
	 }
   for (i=ctask+1; i<=cnttasks; i++)
      {
      if (taskstate[i].begtime==task_maybesolve)
	 {
	 if (tasks[i].weight<tasks[ctask].weight)
	    {
	    ctask=i;
	    counter=0;
	    }
	 else
	    if (tasks[i].weight==tasks[ctask].weight)
	       counter++;
	 }
      }
   for (i=1; i<=cnttasks; i++)
      {
      if (taskstate[i].begtime==task_maybesolve)
	 {
	 if (tasks[i].weight!=tasks[ctask].weight)
	    {
	    taskstate[i].begtime=task_ready;
	    }
	 }
      }
   if (counter) return 0;
   return ctask;
   };

int Algoritms::alg4(void) // критерий по максимуму связности задачи
   {
   UCHAR ctask=0,
	 counter=0;
   for (int i=1; i<=cnttasks; i++)
      if (taskstate[i].begtime==task_maybesolve)
	 {
	 ctask=i;
	 break;
	 }
   for (i=ctask+1; i<=cnttasks; i++)
      {
      if (taskstate[i].begtime==task_maybesolve)
	 {
	 if (tasks[i].cnttie>tasks[ctask].cnttie)
	    {
	    ctask=i;
	    counter=0;
	    }
	 else
	    if (tasks[i].cnttie==tasks[ctask].cnttie)
	       counter++;
	 }
      }
   for (i=1; i<=cnttasks; i++)
      {
      if (taskstate[i].begtime==task_maybesolve)
	 {
	 if (tasks[i].cnttie!=tasks[ctask].cnttie)
	    {
	    taskstate[i].begtime=task_ready;
	    }
	 }
      }
   if (counter) return 0;
   return ctask;
   };

int Algoritms::alg5(void) // критерий по ранней готовности задачи
   {
   UCHAR ctask=0,
	 counter=0;
   for (int i=1; i<=cnttasks; i++)
      if (taskstate[i].begtime==task_maybesolve)
	 {
	 ctask=i;
	 break;
	 }
   for (i=ctask+1; i<=cnttasks; i++)
      {
      if (taskstate[i].begtime==task_maybesolve)
	 {
	 if (taskstate[i].readytime<taskstate[ctask].readytime)
	    {
	    ctask=i;
	    counter=0;
	    }
	 else
	    if (taskstate[i].readytime==taskstate[ctask].readytime)
	       counter++;
	 }
      }
   for (i=1; i<=cnttasks; i++)
      {
      if (taskstate[i].begtime==task_maybesolve)
	 {
	 if (taskstate[i].readytime!=taskstate[ctask].readytime)
	    taskstate[i].begtime=task_ready;
	 }
      }
   if (counter) return 0;
   return ctask;
   };

int Algoritms::alg6(void) // критерий по поздней готовности задачи
   {
   UCHAR ctask=0,
	 counter=0;
   for (int i=1; i<=cnttasks; i++)
      if (taskstate[i].begtime==task_maybesolve)
	 {
	 ctask=i;
	 break;
	 }
   for (i=ctask+1; i<=cnttasks; i++)
      {
      if (taskstate[i].begtime==task_maybesolve)
	 {
	 if (taskstate[i].readytime>taskstate[ctask].readytime)
	    {
	    ctask=i;
	    counter=0;
	    }
	 else
	    if (taskstate[i].readytime==taskstate[ctask].readytime)
	       counter++;
	 }
      }
   for (i=1; i<=cnttasks; i++)
      {
      if (taskstate[i].begtime==task_maybesolve)
	 {
	 if (taskstate[i].readytime!=taskstate[ctask].readytime)
	    taskstate[i].begtime=task_ready;
	 }
      }
   if (counter) return 0;
   return ctask;
   };

//-----------------------------------------------

Algoritms::Algoritms(void)
   {
   critprocs[0]=&Algoritms::alg0;
   critprocs[1]=&Algoritms::alg1;
   critprocs[2]=&Algoritms::alg2;
   critprocs[3]=&Algoritms::alg3;
   critprocs[4]=&Algoritms::alg4;
   critprocs[5]=&Algoritms::alg5;
   critprocs[6]=&Algoritms::alg6;
   time=0;
   }

UCHAR Algoritms::maxchargecase(void)
   {
   UCHAR processor=0,
	 counter=0;
   for (int i=1; i<=cntprocs; i++)
      if (procs[i].status==proc_maybeuse)
	 {
	 processor=i;
	 break;
	 }
   for (i=processor+1; i<=cntprocs; i++)
      {
      if (procs[i].status==proc_maybeuse)
	 {
	 if (procs[i].chargetime>procs[processor].chargetime)
	    {
	    counter=0;
	    processor=i;
	    }
	 else
	    {
	    if (procs[i].chargetime==procs[processor].chargetime)
	       counter++;
	    }
	 }
      }
   for (i=1; i<=cntprocs; i++)
      if ((procs[i].status==proc_maybeuse)&&
	 (procs[i].chargetime<procs[processor].chargetime))
	 procs[i].status=proc_free;
   if (counter) return 0;
   return processor;
   }

UCHAR Algoritms::equalchargecase(void)
   {
   UCHAR processor=0,
	 counter=0;
   for (int i=1; i<=cntprocs; i++)
      if (procs[i].status==proc_maybeuse)
	 {
	 processor=i;
	 break;
	 }
   for (i=processor+1; i<=cntprocs; i++)
      {
      if (procs[i].status==proc_maybeuse)
	 {
	 if (procs[i].chargetime<procs[processor].chargetime)
	    {
	    counter=0;
	    processor=i;
	    }
	 else
	    {
	    if (procs[i].chargetime==procs[processor].chargetime)
	       counter++;
	    }
	 }
      }
   for (i=1; i<=cntprocs; i++)
      if ((procs[i].status==proc_maybeuse)&&
	 (procs[i].chargetime>procs[processor].chargetime))
	 procs[i].status=proc_free;
   if (counter) return 0;
   return processor;
   }

UCHAR Algoritms::randomchargecase(void)
   {
   UCHAR counter,
	 tmp;
   for (int i=1; i<=cntprocs; i++)
      if (procs[i].status==proc_maybeuse)
	 counter++;
   tmp=random(counter)+1;
   for (i=1; i<=cntprocs; i++)
      if (procs[i].status==proc_maybeuse)
	 if (!(--tmp))
	    {
	    for (int j=1; j<=cntprocs; j++)
	       if ((procs[j].status==proc_maybeuse)&&
		  (j!=i))
		  procs[j].status=proc_free;
	    return i;
	    }
   return 0;
   }

UCHAR Algoritms::minindexcase(void)
   {
   for (int i=1; i<=cntprocs; i++)
      if (procs[i].status==proc_maybeuse)
	 return i;
   return 0;
   }

UCHAR Algoritms::procalg(void)
   {
   UCHAR tmp;
   for (int i=1; i<=cntprocs; i++)
      if (procs[i].status==proc_free)
	  procs[i].status=proc_maybeuse;
   switch (charge)
      {
      case charge_max:
	 {
	 tmp=maxchargecase();
	 break;
	 }
      case charge_equal:
	 {
	 tmp=equalchargecase();
	 break;
	 }
      case charge_random:
	 tmp=randomchargecase();
      }
   if (tmp==0) tmp=minindexcase();
   for (i=1; i<=cntprocs; i++)
      if (procs[i].status==proc_maybeuse)
	  procs[i].status=proc_free;
   return tmp;
   }

UCHAR Algoritms::taskalg(void)
   {
   int tmp;
   for (int i=1; i<=cnttasks; i++)
      if (taskstate[i].begtime==task_ready)
	 taskstate[i].begtime=task_maybesolve;
   for (i=1; i<=cntcrits+1; i++)
      if ((tmp=(this->*critprocs[critslist[i]])())!=0)
	 return tmp;
   return 0;
   }

int Algoritms::SaveStates(char *name,char *AlgTaskName[maxcrits],
			  char *AlgProcName[3],task far* tasklistptr)
   {
   int handle,retvalue;
   UINT MaxLgTakt,MaxLgProc,MaxLgTask;
   UCHAR NumbTask=0,NumbProc=0;
   char *CopyRight=
" ╔════════════════════════════════════════════════════════════════════════════╗\n"
" ║                      PARALLEL    PROCESSOR   SCHEDULER                     ║\n"
" ║                                 Version 1.1                                ║\n"
" ║                                (C)  Feedback                               ║\n"
" ╚════════════════════════════════════════════════════════════════════════════╝\n\n";
   char *value=
      "                                                                      \n";
   char *AlgTaskMsg=
      " Алгоритм выбора задач:                                               \n";
   char *AlgProcMsg=
      "    - по минимуму индекса                                             \n"
      " Алгоритм выбора процессоров:                                         \n"
      "    -                                                                 \n"
      "    - по минимуму индекса                                             \n";
   char *TitleMessage=
      " Число Задач:        Число процессоров:        Критический путь:      \n"
      " ┌─────────────┬────────────┬───────────────────┬─────────────────┐   \n"
      " │    Номер    │   Номер    │ Время постановки  │ Время окончания │   \n"
      " │    задачи   │ процессора │   на выполнение   │     решения     │   \n"
      " ├─────────────┼────────────┼───────────────────┼─────────────────┤   \n";
   char *Mesg=
      " │             │            │                   │                 │   \n";
   char *TitleDone=
      " └─────────────┴────────────┴───────────────────┴─────────────────┘   \n"
      " Время решения =>                                                     \n"
      " Коэффициенты загруженности процессоров :                             \n";
   char *Charge=
      "    Процессор    :    Время работы =>       Загруженность => 0.       \n";
   char *Str=
      "\n────────────────────────────────────────────────────────────────────────────────\n\n";
   tasks=tasklistptr;
   itoa(time,value,10);
   MaxLgTakt=strlen(value);
   itoa(cntprocs,value,10);
   MaxLgProc=strlen(value);
   itoa(cnttasks,value,10);
   MaxLgTask=strlen(value);
   if ((handle=
      open(name,O_APPEND|O_TEXT|O_RDWR,S_IREAD|S_IWRITE))==-1)
      {
      if ((handle=
	 open(name,O_CREAT|O_APPEND|O_TEXT|O_RDWR,S_IREAD|S_IWRITE))==-1)
	 return io_error;
      if (write(handle,CopyRight,80*5+1)!=80*5+1)
	 {
	 close(handle);
	 return io_error;
	 }
      }
   if (write(handle,AlgTaskMsg,71)!=71)
      {
      close(handle);
      return io_error;
      }
   for (int i=1; i<=cntcrits; i++)
      {
      strcpy(value,"    - ");
      strcpy(&value[6],AlgTaskName[critslist[i]-1]);
      if (write(handle,value,71)!=71)
	 {
	 close(handle);
	 return io_error;
	 }
      }
   strcpy(&AlgProcMsg[71*2+6],AlgProcName[charge]);
   if (write(handle,AlgProcMsg,71*4)!=71*4)
      {
      close(handle);
      return io_error;
      }
   strcpy(value,AlgTaskName[critslist[i]-1]);
   itoa(cnttasks,value,10);
   strcpy(&TitleMessage[15],value);
   itoa(cntprocs,value,10);
   strcpy(&TitleMessage[41],value);
   itoa(critway,value,10);
   strcpy(&TitleMessage[66],value);
   if (write(handle,TitleMessage,71*5)!=71*5)
      {
      close(handle);
      return io_error;
      }
   while (++NumbTask<=cnttasks)
      {
      itoa(NumbTask,value,10);
      strcpy(&Mesg[7+MaxLgTask-strlen(value)],value);
      itoa(taskstate[NumbTask].procnumber,value,10);
      strcpy(&Mesg[21+MaxLgProc-strlen(value)],value);
      itoa(taskstate[NumbTask].begtime,value,10);
      strcpy(&Mesg[37+MaxLgTakt-strlen(value)],value);
      itoa(taskstate[NumbTask].begtime+tasks[NumbTask].weight-1,value,10);
      strcpy(&Mesg[56+MaxLgTakt-strlen(value)],value);
      if (write(handle,Mesg,71)!=71)
	 {
	 close(handle);
	 return io_error;
	 }
      strcpy(&Mesg[7],"     ");
      strcpy(&Mesg[21],"     ");
      strcpy(&Mesg[37],"     ");
      strcpy(&Mesg[56],"     ");
      }
   itoa(time-1,value,10);
   strcpy(&TitleDone[89],value);
   if (write(handle,TitleDone,71*3)!=71*3)
      {
      close(handle);
      return io_error;
      }
   while (++NumbProc<=cntprocs)
      {
      int dec,sign;
      double kfc;
      itoa(NumbProc,value,10);
      strcpy(&Charge[14+MaxLgProc-strlen(value)],value);
      itoa(procs[NumbProc].chargetime,value,10);
      strcpy(&Charge[38+MaxLgTakt-strlen(value)],value);
      kfc=((float)procs[NumbProc].chargetime)/((float)(time-1));
      value=fcvt(kfc,5,&dec,&sign);
      if (procs[NumbProc].chargetime!=time-1) strcpy(&Charge[63],value);
	 else
	    strcpy(&Charge[61],"1.00000");
      if (write(handle,Charge,71)!=71)
	 {
	 close(handle);
	 return io_error;
	 }
      strcpy(&Charge[14],"   :");
      if (procs[NumbProc].chargetime!=time-1) strcpy(&Charge[63],"     ");
	 else
	    strcpy(&Charge[61],"0.    ");
      }
   write(handle,Str,82);
   close(handle);
   return io_ok;
   }
//-----------------------------------------------

UINT AlgBase::TestGraph(task far* tasklistptr, UCHAR cntoftasks)
   // тест графа.
   {
   InitAlg(tasklistptr,NULL,cntoftasks,cntoftasks,0,charge_max);
   if (GoToTime(gotoend)==ex_end) return critway=time-1;
   return test_error;
   }

void AlgBase::InitAlg(task far* tasklistptr,
		      int far* criterionslistptr,
		      UCHAR cntofprocs,
		      UCHAR cntoftasks,
		      UCHAR cntofcrits,
		      int chargetype)
   // инициализация алгоритма.
   {
   tasks=tasklistptr;
   criterions=criterionslistptr;
   cntprocs=cntofprocs;
   cnttasks=cntoftasks;
   cntcrits=cntofcrits;
   charge=chargetype;
   time=0;
   randomize();
   for (int i=0; i<=cntprocs; i++)
      {
      procs[i].status=proc_free;
      procs[i].tasknum=0;
      procs[i].releasetime=0;
      procs[i].chargetime=0;
      }
   for (i=0; i<=cnttasks; i++)
      {
      taskstate[i].procnumber=task_nosolved;
      taskstate[i].begtime=task_ready;
      taskstate[i].readytime=0;
      }
   for (i=1; i<=cnttasks; i++)
      {
      for (int j=0; j<tasks[i].cnttie; j++)
	 {
	 UCHAR uc;
	 uc=tasks[i].posttasks[j];
	 taskstate[uc].begtime=task_notready;
	 }
      }
   if (cntcrits)
      for (i=1; i<=maxcrits; i++)
	 critslist[criterions[i]]=i;
   critslist[cntcrits+1]=0;
   }

void AlgBase::setreadytasks(UCHAR num)
   {
   for (int i=1; i<=cnttasks; i++)
      {
      for (int j=0; j<tasks[i].cnttie; j++)
	 {
	 if ((tasks[i].posttasks[j]==num)&&
	     ((taskstate[i].procnumber==task_nosolved)||
	      (taskstate[i].begtime+tasks[i].weight-1>time)))
	    return;
	 }
      }
   taskstate[num].begtime=task_ready;
   taskstate[num].readytime=time+1;
   }

int AlgBase::ExecuteOneTime(void)
   // выполняет один шаг алгоритма
   {
   UCHAR cntreadytasks=0;
   UCHAR cntfreeprocs=0;
   UCHAR cntnosolvedtasks=0;
   UCHAR procfind;
   UCHAR taskfind;
   int exitcode=0;
   for (int i=1; i<=cntprocs; i++)
      {
      if (procs[i].status&proc_release)
	 {
	 procs[i].status=proc_free;
	 procs[i].tasknum=0;
	 }
      else
	 if (procs[i].status&proc_seize) procs[i].status=proc_busy;
      if (procs[i].status==proc_free) cntfreeprocs++;
      }
   for (i=1; i<=cnttasks; i++)
      {
      if (taskstate[i].procnumber!=0)
	 {
	 if ((taskstate[i].begtime+tasks[i].weight-1)==time)
	    for (int j=0; j<tasks[i].cnttie; j++)
	       setreadytasks(tasks[i].posttasks[j]);
	 }
      }
   for (i=1; i<=cnttasks; i++)
      {
      if (taskstate[i].begtime==task_ready) cntreadytasks++;
      if (taskstate[i].procnumber==task_nosolved) cntnosolvedtasks++;
      }
   time++;
   if ((cntfreeprocs==cntprocs)&&(cntnosolvedtasks==0))
      return (ex_end);
   if ((cntfreeprocs==cntprocs)&&(cntreadytasks==0))
      return (ex_error);
   if ((time==maxtimes)&&(cntnosolvedtasks!=0))
      return (ex_overflow);
   time--;
   while (cntfreeprocs)
      {
      if (cntnosolvedtasks==0) break;
      if (cntreadytasks==0) break;
      procfind=procalg();
      taskfind=taskalg();
      taskstate[taskfind].procnumber=procfind;
      taskstate[taskfind].begtime=time+1;
      procs[procfind].status=proc_busy|proc_seize;
      procs[procfind].tasknum=taskfind;
      procs[procfind].releasetime=tasks[taskfind].weight+time;
      exitcode=ex_change;
      cntnosolvedtasks--;
      cntreadytasks--;
      cntfreeprocs--;
      }
   for (i=1; i<=cntprocs; i++)
      {
      if (procs[i].releasetime==time+1)
	 {
	 exitcode=ex_change;
	 procs[i].status|=proc_release;
	 }
      if (procs[i].status&proc_busy) procs[i].chargetime++;
      }
   time++;
   return exitcode;
   }

int AlgBase::GoToTime(UINT desttime)
   // выполнить алгоритм до такта desttime, включая его
   {
   int exitcode=0;
   while (desttime>time)
      {
      exitcode=ExecuteOneTime();
      if (exitcode&(ex_end|ex_overflow|ex_error))
	 break;
      if (exitcode==ex_nochange)
	 {
	 UCHAR procfind=1;
	 UINT oldtime=time,
	      deltatime=0;
	 for (int i=1; i<=cntprocs; i++)
	    if (procs[i].status!=proc_free)
	       {
	       procfind=i;
	       break;
	       }
	 for (i=procfind; i<=cntprocs; i++)
	    if ((procs[i].releasetime>time)&&
	       (procs[i].releasetime<procs[procfind].releasetime))
	       procfind=i;
	 if ((time=procs[procfind].releasetime-1)>desttime)
	    time=desttime;
	 if ((deltatime=(time-oldtime))!=0)
	    for (int g=1; g<=cntprocs; g++)
	       if (procs[g].status!=proc_free)
		  procs[g].chargetime+=deltatime;
	 }
      }
   return exitcode;
   }

UINT AlgBase::GetCurrentTime(void)
   // получить номер текущего такта
   {
   return time;
   }

proc AlgBase::GetProcState(UCHAR procnumber, UINT timenumber)
   // возвращает состояние процессора procnumber
   // на такте timenumber
   {
   proc work=
      {proc_free, 0, 0, 0};
   UINT ui=0;
   if (timenumber==time)
      return procs[procnumber];
   else
      {
      for (UCHAR i=1; i<=cnttasks; i++)
	 {
	   if (taskstate[i].procnumber==procnumber)
	     {
	     ui=taskstate[i].begtime+tasks[i].weight-1;
	     if ((ui<=timenumber)&&(ui>work.releasetime))
		work.releasetime=ui;
	     if ((ui>=timenumber)&&(taskstate[i].begtime<=timenumber))
		{
		work.tasknum=i;
		work.status=proc_busy;
		if (taskstate[i].begtime==timenumber)
		   work.status|=proc_seize;
		if (work.releasetime==timenumber)
		   work.status|=proc_release;
		work.releasetime=ui;
		break;
		}
	     }
	 }
      for (i=1; i<=cnttasks; i++)
	 if ((taskstate[i].procnumber==procnumber)&&
	     (taskstate[i].begtime<=timenumber))
	    {
	    if (taskstate[i].begtime+tasks[i].weight-1>timenumber)
	       work.chargetime+=timenumber-taskstate[i].begtime+1;
	    else
	       work.chargetime+=tasks[i].weight;
	    }
      return work;
      }
   }

taskstatus AlgBase::GetTaskState(UCHAR tasknumber, UINT timenumber)
   // возвращает состояние задачи tasknumber
   // на такте timenumber
   {
   taskstatus work=
      {task_nosolved, task_notready, 0};
   if ((timenumber==time)||(timenumber>=taskstate[tasknumber].begtime))
      return taskstate[tasknumber];
   if (timenumber>=taskstate[timenumber].readytime)
      {
      work.begtime=task_ready;
      work.readytime=taskstate[timenumber].readytime;
      }
   return work;
   }
