@echo off
if p%1 == p goto MISSING
j:
set Par1=BMUSER
set Par2=BMUSER
set ProgDir=\BMPC\REPORTS\

if %1 == br goto BRANCH
if %1 == BR goto BRANCH

goto MISSING

:BRANCH
vidram on
j:
cd \BPOWER\EXE
rem call bbmqemmw.bat
REM call bbmqemm.bat
CALL BBM.BAT
vidram off
goto END

:MISSING
echo Usage: bp in (internal), or
echo        bp ex (external), or
echo        bp bi (bill), or
echo        bp br (branch power), or
echo        bp gim (GIM*Disposal)
:END
C: