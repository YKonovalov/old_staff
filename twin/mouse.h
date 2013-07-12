/***************************************************************************/
/*  Extended Unit for mouse control                                        */
/***************************************************************************/
#include <Dos.h>
#include <graphics.h>
typedef unsigned char byte;
//#include <os.h>
   //{---Маски кнопок---*/
const  Left=0x0001;
const  Right=0x0002;
const  Center=0x0004;
   //{--Маски состояний кнопок----*/
const  PosGenged=0x0001,
       LeftPress=0x0002,
       LeftRel=0x0004,
       RightPress=0x0008,
       RightRel=0x0010,
       CenterPress=0x0020,
       CenterRel=0x0040;
/*------------------------------------------------------*/
typedef unsigned MaskType[2][16];
struct CurInfo
	{
	 MaskType CurForm;
	 unsigned char OfsX,OfsY;
	};
const  unsigned Bits[16]=
	{0x8000,0x4000,0x2000,0x1000,0x0800,0x0400,0x0200,0x0100,
	 0x0080,0x0040,0x0020,0x0010,0x0008,0x0004,0x0002,0x0001};
CurInfo  PlaceCur=
			    {{{0xfc3f,0xfc3f,0xfc3f,0xfc3f,
			       0xfc3f,0xfc3f,0x0000,0x0180,
			       0x0180,0x0000,0xfc3f,0xfc3f,
			       0xfc3f,0xfc3f,0xfc3f,0xfc3f},
			     {0x0000,0x0180,0x0180,0x0180,
			      0x0180,0x0180,0x0240,0x7c3e,
			      0x7c3e,0x0240,0x0180,0x0180,
			      0x0180,0x0180,0x0180,0x0000}},
			      8,8};
CurInfo  MenuCur =
			    {{{0x3fff,0x0fff,0x83ff,0x80ff,
			       0xc03f,0xc01f,0xe03f,0xe03f,
			       0xf01f,0xf00f,0xfb07,0xff83,
			       0xffc1,0xffe0,0xfff1,0xfffb},
			     {0x0000,0x4000,0x3000,0x3c00,
			      0x1f00,0x1fc0,0x0f80,0x0f80,
			      0x07c0,0x04e0,0x0070,0x0038,
			      0x001c,0x000e,0x0004,0x0000}},
			      0,0};

/*--------------------------------*/
byte	 MouseInitMode,ShowMode;
CurInfo	 FlowCur;
int	 FlowX,FlowY;
byte     FlowDx,FlowDy,LastPress;
void*    Point;
byte     Alt,Ctrl;
int      dxh,dyh;
/*-------------------------------------*/
   void InitMouse(unsigned& QB);
   void Show();
   void Hide();
   void GetPos(unsigned& x,unsigned& y,unsigned& b);
   void SetPos(unsigned x,unsigned y);
/*   void SetXLimit(unsigned Min,unsigned Max);
   void SetYLimit(unsigned Min,unsigned Max);
   void SetGraphMouse(unsigned Dxx,unsigned Dyy,MaskType* Image);
   byte Caps_Lock();
    void ActivisionCaps_Lock();
    void DoneCaps_Lock();
    void Clb();
    /*-I--*/
/*//    void Pix_Vm(int x1,int y,byte Col);
/*<> Video Memory Pixel Procedure,Copyright (C) 1993 Dmitriy Kornilov-I--*/
/**********************************************************/
   const G=0x33;
/**********************************************************/
   void InitMouse(unsigned& QB)
    {
     _AX=0;
     asm int 0x33
    if (!_AX)   {
		  QB=0;
		  MouseInitMode=0;
		 /*  closeGraph;
		   textcolor(12);
		   DirectVideo:=False;
		   Writeln (' Mouse Driver Is Not Instaled ..');
		   Writeln (' Please Instal Mouse From Dos . ');
		   DirectVideo:=True;
		 /* delay(5000);
		   halt;           */
		}
		else
		 {
		  QB=_BX;
		  MouseInitMode=0xFF;
		 };
   };
/*---------------------------------------------------------*/
   void Show()
   {
       _AX=1;
       asm int G;
   };
/*---------------------------------------------------------*/
   void Hide()
   {
       _AX=2;
       asm int G;
   };
/*---------------------------------------------------------*/
   void GetPos(unsigned& x,unsigned& y,unsigned& b)
   {
       _AX=3;
       int G; /* X,Y:положение мыши*/
       x=_CX;   /* b:статус нажатия клавиши*/
       y=_DX;
       FlowX=x;
       FlowY=y;
       b=_BX;
   };
/*---------------------------------------------------------*/
   void SetPos(unsigned x,unsigned y)
   {
       _AX=4;
       _CX=x;
       _DX=y;
       asm int G; /* X,Y: новое положение мыши*/
   };
/*---------------------------------------------------------*/
/*   void SetXLimit(Min,Max:word);
   {
     Reg.AX:=7;
     Reg.CX:=Min;
     Reg.DX:=Max;
     Intr(G,Reg);
   };
/*---------------------------------------------------------*/
/*   void SetYLimit(Min,Max:word);
   {
     Reg.AX:=8;
     Reg.CX:=Min;
     Reg.DX:=Max;
     Intr(G,Reg);
   };
/*---------------------------------------------------------*/
/*   void SetGraphMouse(Dxx,Dyy:word;Var image:MaskType);
   {
    If MouseInitMode
     Then
      {
       Inline(0xFA);
       Reg.AX:=9;
       Reg.BX:=Dxx;
       Reg.CX:=Dyy;
       Reg.DX:=Ofs(image);
       Reg.ES:=Seg(image);
       Inline(0xFB);
       Intr(G,Reg);
      }
     Else
       With FlowCur Do
	 {
          CurForm:=Image;
          OfsX:=Dxx;
          OfsY:=Dyy;
	 };
   };
/*--<<<<<<<<<<<<<<< Extended Procedures And Functions >>>>>>>>>>>>>>>--*/
/*  Function Caps_Lock :boolean;
   {
    If (Mem[0:1047] and 64)=0
     Then Caps_Lock:=false
     Else Caps_Lock:=True;
   };
/*-------------------------------*/
/*  void ActivisionCaps_Lock;
   {
	inline(0xFA);
    Mem[0:1047]:=Mem[0:1047] Or 64;
    Mem[0:1048]:=Mem[0:1048] Or 64;
	inline(0xFB);
   };
/*------------------------------------------------------*/
/*  void DoneCaps_Lock;
   {
	inline(0xFA);
    Mem[0:1047]:=Mem[0:1047] And 191;
    Mem[0:1048]:=Mem[0:1048] And 191;
	inline(0xFB);
   };
/*--Z-----------------------------------------------------------*/
/*void Clb;
 {
	inline(0xFA);
	     MemW[0:0x41A]:=MemW[0:0x41C];
	inline(0xFB);
 };
/*----------------------------------------------------*/
/*      void pix_vm(x1,y:integer;col:byte);
	 var pos1,p1:byte;
	 begin(*pix_vm*)
	    asm
	       /*установка режима записи*/
  /*	       mov     dx,3ceh
	       mov     al,5
	       out     dx,al
	       inc     dx
	       mov     al,2
	       out     dx,al
	       /*регистр маски карты*/
  /*	       mov     dx,3c4h
	       mov     al,2
	       out     dx,al
	       inc     dx
	       mov     al,0ffh
	       out     dx,al
	       /*начальные параметры*/
    /*	       mov     ax,5
	       mul     y
	       add     ax,0a000h
	       mov     es,ax
	       mov     ax,x1
	       mov     pos1,8
	       div     pos1
	       mov     pos1,ah
	       mov     p1,al
	       mov     ax,0ffffh
	       mov     cl,8
	       sub     cl,pos1
	       shl     ah,cl
	       not     ah
	       /*вывод точек*/
      /*	       sub     bh,bh
	       mov     bl,p1
	       mov     dx,3ceh
	       mov     al,8
	       out     dx,al
	       inc     dx
	       mov     al,ah
	       out     dx,al
	       mov     al,es:[bx]
	       mov     al,col
	       mov     es:[bx],al
	    end;
	 end;(*pix_vm*)
/*\\\\\\ T h e  E n d  o f  M O U S E //////////*/

