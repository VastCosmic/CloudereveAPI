@echo off
set FRPC_PATH=%~dp0frpc.exe
set CLOUDREVE_PATH=G:\cloudreve\cloudreve.exe

echo --- >> log.txt
echo [%date% %time%] Started... >> log.txt

:retry
start /B "" "%FRPC_PATH%" -c "%~dp0frpc.toml

timeout /t 15 >nul
tasklist | find /i "frpc.exe" >nul
if %errorlevel% neq 0 (
    echo [%date% %time%] frpc NOT RUNNING. >> log.txt
    timeout /t 1 >nul
    goto retry
) else (
    echo [%date% %time%] frpc RUNNING. >> log.txt
)


:startCloudreve
start /B "" "%CLOUDREVE_PATH%"

timeout /t 15 >nul
tasklist | find /i "cloudreve.exe" >nul
if %errorlevel% neq 0 (
    echo [%date% %time%] Cloudreve NOT RUNNING. >> log.txt
    timeout /t 1 >nul
    goto startCloudreve
) else (
    echo [%date% %time%] Cloudreve RUNNING. >> log.txt
)

