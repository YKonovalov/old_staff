@echo off
if exist f:\login.exe goto OK
if exist f:\login\login.exe goto OK1
echo �� �� ����� ���짮������ ����! ������� � ������������.
goto END

:OK
f:\login.com %1
if exist f:\windows\user.exe goto END
echo.
echo ������, �� ���ࠫ� ���ࠢ���� ��஫�...
echo   - �᫨ �� �� ��� �室��� � ���, ������ Ctrl-C, ��⥬ Y
echo   - �᫨ �� ��� ���஡����� �� ࠧ, ������ ���� �������...
echo.
pause >nul
goto OK

:OK1
f:\login\login.com %1
if exist w:\windows\user.exe goto END
echo.
echo ������, �� ���ࠫ� ���ࠢ���� ��஫�...
echo   - �᫨ �� �� ��� �室��� � ���, ������ Ctrl-C, ��⥬ Y
echo   - �᫨ �� ��� ���஡����� �� ࠧ, ������ ���� �������...
echo.
pause >nul
goto OK1

:END
