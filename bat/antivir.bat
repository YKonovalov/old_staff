if exist s:\public\map.exe goto logged
goto attached
:LOGGED
s:
goto next
:ATTACHED
f:
:NEXT
if exist f:\login.exe goto VLM
if exist f:\login\login.exe goto netx
:VLM
cd \antivir
awk antivir.awk c:\virus.log
c:
goto end:
:NETX
cd \login\antivir
awk antivir.awk c:\virus.log
c:
:END