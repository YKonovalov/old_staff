@ECHO OFF

REM
REM This batch file can now be passed a parameter.
REM The parameter is only used if the batch file is being run in a unix
REM environment, i.e. if supplied the batch file assumes a unix env.
REM if not supplied, the batch file assumes a dos environment.
REM


if z%1z == zz goto :dos
goto :unix

:dos
j:
cd \bpower\exe
unload
Brequest  /d:8192 /s:10 /r:25
iodc
ADISPLAY /E
DM
INIT
SM00
SM0C
vee /Ss/T/s:1:..\swap /L BBM000
SMUNLOAD
butil -stop
unload
uninstal
goto :exit

:unix
dmunix -h -p
iodc
ADISPLAY /E
INIT
SM00
SM0C
vee /Ss/T/s:1:..\swap /L BBM000
SMUNLOAD
unload
uninstal
goto :exit

:exit
exit
