@echo off
if %1p==p goto noparm
rem userlist /a |awk -f userlist.awk -v br=%1
userlist /a |awk -f userlist.awk -v br=%1 > %1
goto out
:noparm
echo Branch name is needed !
echo.
echo Example: usr_adr Baum
:out