@echo off
if exist f:\login.exe goto OK
if exist f:\login\login.exe goto OK1
echo Вы не можете пользоваться сетью! Обратитесь к Администратору.
goto END

:OK
f:\login.com %1
if exist f:\windows\user.exe goto END
echo.
echo Видимо, Вы набрали неправильный пароль...
echo   - Если Вы не хотите входить в сеть, нажмите Ctrl-C, затем Y
echo   - Если Вы хотите попробовать еще раз, нажмите любую клавишу...
echo.
pause >nul
goto OK

:OK1
f:\login\login.com %1
if exist w:\windows\user.exe goto END
echo.
echo Видимо, Вы набрали неправильный пароль...
echo   - Если Вы не хотите входить в сеть, нажмите Ctrl-C, затем Y
echo   - Если Вы хотите попробовать еще раз, нажмите любую клавишу...
echo.
pause >nul
goto OK1

:END
