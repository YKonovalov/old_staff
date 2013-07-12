
//*************************************//
// ������樨 ��� ����� ALG.CPP.      //
// ����� 1.4, ���. 1994.              //
// (c) Copyright ����਩ �. ��୨���,  //
//               �਩    �. �����᪨�, //
//               Feedback corp.        //
//*************************************//

// �㬥��� :
//    �����       -  �� 1 �� maxtasks
//    �����஢ -  �� 1 �� maxprocs
//    ⠪⮢      -  �� 1 �� maxtimes
//    ���ਥ�   -  �� 1 �� maxcrits

typedef unsigned char UCHAR;
typedef unsigned int UINT;

struct task { // �⤥�쭠� �����.
   UINT weight;         // ��� �����
   UCHAR cnttie;         // �᫮ ��᫥����� �����
   UCHAR far* posttasks; // 㪠��⥫� �� ᯨ᮪ ��᫥����� �����
   };

const UCHAR
   maxtasks=250, // ���ᨬ��쭮� �᫮ �����
   maxprocs=250, // ���ᨬ��쭮� �᫮ �����஢
   maxcrits=6;   // ���ᨬ��쭮� �᫮ ���ਥ�

const UINT
   maxtimes=65000; // ���ᨬ��쭮� �᫮ ⠪⮢ ࠡ���

typedef task tasklist[maxtasks+1]; // ⨯ ���ᨢ �����
typedef int criterionslist[maxcrits+1];
   // ⨯ ���ᨢ ���ਥ�.
   // �᫨ ���਩ ����⨢��, � ����� ���ᨢ� ࠢ�� crit_off,
   // ���� �� ࠢ�� �ਮ���� �����.
   // �ਮ���� �㬥������ �� 1 �� �᫠_��⨢���_���ਥ�.
   // ���ᨬ���� �ਮ��� = 1

const char
   crit_off=0x00; // ����⠭� ��� ������� ����⨢���� �����
		  // � ���ᨢ� ⨯� tasklist

const UINT
   gotoend=maxtimes+1, // ����⠭� ��� GoToTime.
		       // �᫨ ����室��� �믮����� ������ �� ����,
		       // �  desttime = gotoend
   test_error=0;       // ����⠭� ��� ���祭��, �����頥����
		       // �㭪樥� TestGraph

const UINT // ����⠭�� ��� ��६����� chargetype.
   charge_max=0,    // ���ᨬ��쭠� ����㦥������
   charge_equal=1,  // ࠢ����ୠ� ����㦥������
   charge_random=2; // ��砩��� ����㦥������

const int // ��᪨ ��� ��६�����, �����頥���
	  // �㭪�ﬨ FirstStep, NextStep, GoToTime.
   ex_nochange=0x0000, // �� ������ ⠪� �� ���������� ���ﭨ� �� ������
		       // ������ (� ᫥�., � �����)
   ex_end=0x0001,      // ����� ࠡ��� �����⬠
   ex_change=0x0002,   // �� ������ ⠪� ���������� ���ﭨ� ��� �� ������
		       // ������ (� ᫥�., � �����)
   ex_overflow=0x0004, // ����� ⠪� ࠡ��� > maxtimes
   ex_error=0x0008;    // �訡�� � ࠡ��

struct proc { // �⤥��� ������.
   UCHAR status;      // �����
   UCHAR tasknum;    // ����� �믮��塞�� �����
   UINT releasetime; // ⠪� �᢮�������� ������
   UINT chargetime;  // �㬬�୮� �६� ࠡ���
   };

const UCHAR // ��᪨ ��� ��६����� proc.status.
   proc_free=0x00,    // ������ ᢮����� � ������ ⠪�
   proc_busy=0x01,    // ������ ����� � ������ ⠪�
   proc_seize=0x02,   // ������ ����㧨��� � ������ ⠪�
   proc_release=0x04, // ������ �᢮������� � ������ ⠪�
   proc_maybeuse=0x08;// ����७��� ����⠭� ��� task_maybesolve
const UCHAR
   io_ok=0x0000,
   io_error=0xFFFF;
struct taskstatus { // ����� �����.
   UCHAR procnumber;   // ����� ������, �� ���஬ ��� �蠫���(����)
   UINT begtime;       // ⠪� ���⠭���� �� �믮������
   UINT readytime;     // ⠪� ��⮢���� �����
   };

const UINT // ����⠭�� ��� taskstatus.
   task_nosolved=0x0000,   // ����⠭� ��� taskstatus.procnumber.
			   // ����� �� �襭�
   task_ready=0xFFFF,      // ����⠭� ��� taskstatus.begtime,
			   // �᫨ taskstatus.proc=task_nosolved.
			   // ����� ��⮢� � �襭��
   task_notready=0x0000,   // ����⠭� ��� taskstatus.begtime,
			   // �᫨ taskstatus.proc=task_nosolved.
			   // ����� �� ��⮢� � �襭��
   task_maybesolve=0xFFFE; // ����७��� ����⠭�
			   // ����⠭� ��� taskstatus.begtime,
			   // �᫨ taskstatus.proc=task_nosolved.
			   // ����� �������� �㤥� ������

class Algoritms
   { // ������ �����
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
   int alg0(void); // ���਩ �� ������� ������
		   // �믮������ �ᥣ��
		   // � ���� �� �뢮�����
   int alg1(void); // ���਩ �� ��砩���� ������� �����
   int alg2(void); // ���਩ �� ���ᨬ�� ��� �����
   int alg3(void); // ���਩ �� ������� ��� �����
   int alg4(void); // ���਩ �� ���ᨬ�� �吝��� �����
   int alg5(void); // ���਩ �� ࠭��� ��⮢���� �����
   int alg6(void); // ���਩ �� ������� ��⮢���� �����
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
   { // �ந������ �����
   void setreadytasks(UCHAR num);
public:
   AlgBase(void){};
   ~AlgBase(void){};
   UINT TestGraph(task far* tasklistptr, UCHAR cntoftasks);
      // ��� ���.
      // ����室��� ��뢠�� ⮫쪮 ���� ࠧ � ��砫� ࠡ���.
      // � ��砥 �訡�� �����頥� test_error,
      // ���� ����� ����᪮�� ���
   void InitAlg(task far* tasklistptr,
		int far* criterionslistptr,
		UCHAR cntofprocs,
		UCHAR cntoftasks,
		UCHAR cntofcrits,
		int chargetype);
      // ���樠������ �����⬠.
      // ��뢠���� � ��砥 ������� ������ ��⠢���� �����.
      // tasklistptr - ���� ᯨ᪠ �����
      // ctiterionslistptr - ���� ᯨ᪠ ���ਥ�
      // cntofprocs - �᫮ �����஢
      // cntoftasks - �᫮ �����
      // cntofcrits - �᫮ ���ਥ�
      // chargetype - ���਩ ����㦥����� �����஢
   int ExecuteOneTime(void);
      // �믮���� ���� 蠣 �����⬠
      // �����頥� ����� ��ࠡ�⠭���� 蠣� � 䫠�����,
      // ��।�����묨 ex_********
   int GoToTime(UINT desttime);
      // �믮����� ������ �� ⠪� desttime, ������ ���.
      // �����頥� ����� ��ࠡ�⠭���� 蠣� � 䫠�����,
      // ��।�����묨 ex_********
   UINT GetCurrentTime(void);
      // ������� ����� ⥪�饣� ⠪�
   proc GetProcState(UCHAR procnumber, UINT timenumber);
      // �����頥� ���ﭨ� ������ procnumber
      // �� ⠪� timenumber.
      // !!! ����� ��� �� �� ��ࠡ�⠭���� ⠪�
      // !!! ����� �ਢ��� � ���।᪠�㥬� ��᫥��⢨�
   taskstatus GetTaskState(UCHAR tasknumber, UINT timenumber);
      // �����頥� ���ﭨ� ����� tasknumber
      // �� ⠪� timenumber.
      // !!! ����� ��� �� �� ��ࠡ�⠭���� ⠪�
      // !!! ����� �ਢ��� � ���।᪠�㥬� ��᫥��⢨�
   };
