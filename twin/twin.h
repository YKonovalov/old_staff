/****************************************************************************/
/*               The Alternate Text Screen Interface Unit                   */
/*       allows you to provide Windows similar environment using text       */
/*       mode. It's ment that you don't need specific grafic images,etc.    */
/*            Actualy,you can make something like Exell view.               */
/*           Copyright (C) Yury Konovalov 9.02.95  Version 1.0              */
/****************************************************************************/

typedef unsigned char byte;
typedef int Err;
typedef byte HotKeys;

unsigned long VADR=0xB8000000;
struct Shad
	{
	 byte Under,Left;
	};
const Shad Shadow = {223,220};

const byte btDemSize=2;
const byte btStrSize=2;

const byte Concel=1;
const byte Pressed=2;
const byte Tab=2;





  struct element {
		  char Chr;
		  char Atr;
		 };
  typedef element (far *scrp)[80];
//  unsigned VMEMSIZE=80*25*2;
  scrp SCR;
  element CurShape;





void InitTWin();
void SetLightBG();
void SetNormBG();
void HideCur();
void ShowCur();

	void Bar(int,int,int,int,byte);
	void PutEl(byte,int,int,byte,byte);
	void PutSt(char *,int,int,byte,byte);

 class Button
       {
    protected:
	byte OCol;
	int x1,y1,x2,i,j;
	byte BCol;
    public:
	Button(char *,int,int,int,byte,byte,byte,byte);
	void PutName(char *,int,int,byte,byte);
	void Press(void);
	void Depress(void);
	HotKeys ListenKey(void);
       };
/*-#END---------------------------------------------------------------------*/
