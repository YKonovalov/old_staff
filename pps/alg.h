
//*************************************//
// Декларации для модуля ALG.CPP.      //
// Версия 1.4, Дек. 1994.              //
// (c) Copyright Дмитрий В. Корнилов,  //
//               Юрий    И. Ровенский, //
//               Feedback corp.        //
//*************************************//

// Нумерация :
//    задач       -  от 1 до maxtasks
//    процессоров -  от 1 до maxprocs
//    тактов      -  от 1 до maxtimes
//    критериев   -  от 1 до maxcrits

typedef unsigned char UCHAR;
typedef unsigned int UINT;

struct task { // отдельная задача.
   UINT weight;         // вес задачи
   UCHAR cnttie;         // число последующих задач
   UCHAR far* posttasks; // указатель на список последующих задач
   };

const UCHAR
   maxtasks=250, // максимальное число задач
   maxprocs=250, // максимальное число процессоров
   maxcrits=6;   // максимальное число критериев

const UINT
   maxtimes=65000; // максимальное число тактов работы

typedef task tasklist[maxtasks+1]; // тип массив задач
typedef int criterionslist[maxcrits+1];
   // тип массив критериев.
   // если критерий неактивен, то элемент массива равен crit_off,
   // иначе он равен приоритету критерия.
   // приоритеты нумеруются от 1 до числа_активных_критериев.
   // максимальный приоритет = 1

const char
   crit_off=0x00; // константа для задания неактивности критерия
		  // в массиве типа tasklist

const UINT
   gotoend=maxtimes+1, // константа для GoToTime.
		       // если необходимо выполнить алгоритм до конца,
		       // то  desttime = gotoend
   test_error=0;       // константа для значения, возвращаемого
		       // функцией TestGraph

const UINT // константы для переменной chargetype.
   charge_max=0,    // максимальная загруженность
   charge_equal=1,  // равномерная загруженность
   charge_random=2; // случайная загруженность

const int // маски для переменной, возвращаемой
	  // функциями FirstStep, NextStep, GoToTime.
   ex_nochange=0x0000, // на данном такте не изменилось состояние ни одного
		       // процессора (а след., и задачи)
   ex_end=0x0001,      // конец работы алгоритма
   ex_change=0x0002,   // на данном такте изменилось состояние хотя бы одного
		       // процессора (а след., и задачи)
   ex_overflow=0x0004, // номер такта работы > maxtimes
   ex_error=0x0008;    // ошибка в работе

struct proc { // отдельный процессор.
   UCHAR status;      // статус
   UCHAR tasknum;    // номер выполняемой задачи
   UINT releasetime; // такт освобождения процессора
   UINT chargetime;  // суммарное время работы
   };

const UCHAR // маски для переменной proc.status.
   proc_free=0x00,    // процессор свободен в данном такте
   proc_busy=0x01,    // процессор занят в данном такте
   proc_seize=0x02,   // процессор загрузился в данном такте
   proc_release=0x04, // процессор освободился в данном такте
   proc_maybeuse=0x08;// внутренняя константа как task_maybesolve
const UCHAR
   io_ok=0x0000,
   io_error=0xFFFF;
struct taskstatus { // статус задачи.
   UCHAR procnumber;   // номер процессора, на котором она решалась(ется)
   UINT begtime;       // такт постановки на выполнение
   UINT readytime;     // такт готовности задачи
   };

const UINT // константы для taskstatus.
   task_nosolved=0x0000,   // константа для taskstatus.procnumber.
			   // задача не решена
   task_ready=0xFFFF,      // константа для taskstatus.begtime,
			   // если taskstatus.proc=task_nosolved.
			   // задача готова к решению
   task_notready=0x0000,   // константа для taskstatus.begtime,
			   // если taskstatus.proc=task_nosolved.
			   // задача не готова к решению
   task_maybesolve=0xFFFE; // внутренняя константа
			   // константа для taskstatus.begtime,
			   // если taskstatus.proc=task_nosolved.
			   // задача возможно будет решаться

class Algoritms
   { // базовый класс
   typedef int (Algoritms::*critproc)(void);
   friend AlgBase;
   task far* tasks;
   int far* criterions;
   proc procs[maxprocs+1];
   taskstatus taskstate[maxtasks+1];
   int critslist[maxcrits+2];
   critproc critprocs[maxcrits+2];
   UCHAR cntprocs;
   UCHAR cnttasks;
   UCHAR cntcrits;
   UINT critway;
   UINT time;
   int charge;
   Algoritms(void);
   ~Algoritms(void){};
   int alg0(void); // критерий по минимуму индекса
		   // выполняется всегда
		   // в меню не выводится
   int alg1(void); // критерий по случайному индексу задачи
   int alg2(void); // критерий по максимуму веса задачи
   int alg3(void); // критерий по минимуму веса задачи
   int alg4(void); // критерий по максимуму связности задачи
   int alg5(void); // критерий по ранней готовности задачи
   int alg6(void); // критерий по поздней готовности задачи
   UCHAR procalg(void);
   UCHAR taskalg(void);
   UCHAR maxchargecase(void);
   UCHAR equalchargecase(void);
   UCHAR randomchargecase(void);
   UCHAR minindexcase(void);
public:
   int SaveStates(char *name,char *AlgTaskName[6],char *AlgProcName[3],
		  task far* tasklistptr);
   };

class AlgBase:public Algoritms
   { // производный класс
   void setreadytasks(UCHAR num);
public:
   AlgBase(void){};
   ~AlgBase(void){};
   UINT TestGraph(task far* tasklistptr, UCHAR cntoftasks);
      // тест графа.
      // необходимо вызывать только один раз в начале работы.
      // в случае ошибки возвращает test_error,
      // иначе длину критического пути
   void InitAlg(task far* tasklistptr,
		int far* criterionslistptr,
		UCHAR cntofprocs,
		UCHAR cntoftasks,
		UCHAR cntofcrits,
		int chargetype);
      // инициализация алгоритма.
      // вызывается в случае задания нового составного критерия.
      // tasklistptr - адрес списка задач
      // ctiterionslistptr - адрес списка критериев
      // cntofprocs - число процессоров
      // cntoftasks - число задач
      // cntofcrits - число критериев
      // chargetype - критерий загруженности процессоров
   int ExecuteOneTime(void);
      // выполняет один шаг алгоритма
      // возвращает статус отработанного шага с флажками,
      // определенными ex_********
   int GoToTime(UINT desttime);
      // выполнить алгоритм до такта desttime, включая его.
      // возвращает статус отработанного шага с флажками,
      // определенными ex_********
   UINT GetCurrentTime(void);
      // получить номер текущего такта
   proc GetProcState(UCHAR procnumber, UINT timenumber);
      // возвращает состояние процессора procnumber
      // на такте timenumber.
      // !!! запрос для еще не отработанного такта
      // !!! может привести к непредсказуемым последствиям
   taskstatus GetTaskState(UCHAR tasknumber, UINT timenumber);
      // возвращает состояние задачи tasknumber
      // на такте timenumber.
      // !!! запрос для еще не отработанного такта
      // !!! может привести к непредсказуемым последствиям
   };
