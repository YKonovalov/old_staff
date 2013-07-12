#include "mouse.h"
#include "twin.cpp"

Button *Pop;
Button *Pop2;
Button *Pop3;
unsigned int h;

void main()
{
 InitTWin();
 SetLightBG();
 InitMouse(h);
 Show();
 Bar(6,6,79,22,1);
 Pop= new Button("We gonna ring the bell",
		  12,8,60,7,12,1,btStrSize);
 Pop->ListenKey();
 Pop2= new Button("We gotta get outa here now !",
		  12,10,70,15,12,1,btDemSize);
 Pop2->ListenKey();
 Pop3= new Button("A new Control unit will be created",
		  12,12,60,9,13,1,btStrSize);
 Pop3->ListenKey();
 delete Pop;
 delete Pop2;
 delete Pop3;
 DoneTWin();
}
