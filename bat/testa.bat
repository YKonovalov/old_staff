@echo off
cls
:START
aidstest a: /f/g/b
IF NOT ERRORLEVEL 0 GOTO VIRUS
drweb a: /AL /AR /CL /LN /NM /OF /QU /TDC:
IF NOT ERRORLEVEL 0 GOTO VIRUS
GOTO NOVIRUS
:VIRUS
ECHO ********************************************************
ECHO *                                                      *
ECHO *        THIS DISKETTE CONTAINS A VIRUS !!!            *
ECHO *                                                      *
ECHO *            CALL SYSTEM ADMINISTRATOR !!!             * 
ECHO *                                                      *
ECHO ********************************************************
PAUSE
C:
GOTO END
:NOVIRUS
ECHO ********************************************************
ECHO *        OOOOOOOOOO         KKK     KKK      !!!       *
ECHO *      OOO        OOO       KKK   KKK        !!!       *
ECHO *      OOO        OOO       KKKKKKK          !!!       *
ECHO *      OOO        OOO       KKK   KKK                  * 
ECHO *        OOOOOOOOOO         KKK     KKK      !!!       *
ECHO ********************************************************
choice /tn,10 "Test another disk "
IF ERRORLEVEL 2 GOTO END
:ANOTHER
ECHO Insert another disk and
PAUSE
GOTO START
C:
GOTO END
:END

