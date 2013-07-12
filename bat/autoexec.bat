@ECHO OFF
IF (%CONFIG%) == (NONET) GOTO NONET
IF (%CONFIG%) == (CDROM) GOTO CDROM
IF (%CONFIG%) == (NETX) GOTO NETX

PROMPT $p$g
PATH C:\WINDOWS;C:\DOS;C:\;C:\BAT;C:\QEMM;c:\nwclient;D:\EXEC;D:\NC
path=%path%;c:\windows\nls
set temp=c:\temp
set clatemp=c:\temp
set nc=D:\nc
call c:\nwclient\startnet.bat
REM c:\windows\net start
c:\qemm\loadhi /rf rk1 /r3
c:\qemm\loadhi /rf doskey
c:\qemm\loadhi /rf smartdrv.exe
rem C:\QEMM\LOADHI /RF MSCDEX.EXE /D:$CDROM$ /L:E
call login.bat
call net.bat
ncc /fast
call antivir.bat
GOTO EXIT

:CDROM
PROMPT $p$g
PATH C:\WINDOWS;C:\DOS;C:\;C:\BAT;C:\QEMM;c:\nwclient;D:\EXEC;D:\NC
set temp=c:\temp
set clatemp=c:\temp
set nc=D:\nc
call c:\nwclient\startnet.bat
REM c:\windows\net start
c:\qemm\loadhi /rf rk1 /r3
c:\qemm\loadhi /rf doskey
c:\qemm\loadhi /rf smartdrv.exe
C:\QEMM\LOADHI /RF MSCDEX.EXE /D:$CDROM$ /L:B
call login.bat
call net.bat
ncc /fast
call antivir.bat
GOTO EXIT

:NETX
PROMPT $p$g
PATH C:\WINDOWS;C:\DOS;C:\;C:\BAT;C:\QEMM;c:\nwclient;D:\EXEC;D:\NC
set temp=c:\temp
set clatemp=c:\temp
set nc=D:\nc
call c:\nwclient\startntx.bat
c:\qemm\loadhi /rf rk1 /r3
c:\qemm\loadhi /rf doskey
c:\qemm\loadhi /rf smartdrv.exe
call login.bat
call net.bat
ncc /fast
GOTO EXIT


:NONET
PROMPT $p$g
PATH C:\DOS;C:\;C:\WINDOWS;C:\BAT;C:\QEMM;C:\NWCLIENT;D:\NC;d:\exec
set temp=c:\temp
set clatmp=c:\temp
set nc=c:\norton
c:\qemm\loadhi /rf rk1 /r3
c:\qemm\loadhi /rf smartdrv.exe 2048 768
:EXIT

REM *** BEGIN Intel LANDesk Manager Section ***
REM The following line loads the Btrieve TSR (29kbytes)
REM required by Inventory Manager.
rem brequest /r:26
REM ***   END Intel LANDesk Manager Section ***
