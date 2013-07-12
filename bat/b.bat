j:
cd \bpower\exe
pause
unload
pause
Brequest  /d:8192 /s:10 /r:25
pause
iodc
iodc
pause
ADISPLAY /E
pause
DM
pause
INIT
pause
REM SM00
pause
REM SM0C
pause
vee /Ss/T/s:1:..\swap /L BBM000
pause
SMUNLOAD
pause
butil -stop
pause
unload
pause
uninstal
@echo THAT'S ALL FOLKS....
pause
c:
ÿ