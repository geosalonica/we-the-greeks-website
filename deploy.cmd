@echo off
REM Publish static content to the live IIS folder (run ON the server).
REM The we-the-greeks.world site serves the Democracy.Web backend from
REM C:\inetpub\wwwroot; this script must NEVER touch the root files there
REM (web.config, appsettings*.json, *.dll) - it only mirrors the static
REM subfolders from this git checkout.
REM Democracy.Web serves static files ONLY from its web root, the wwwroot
REM SUBFOLDER (app.UseStaticFiles() with default WebRootPath) - files at
REM C:\inetpub\wwwroot top level are invisible to it (ANCM path="*").
set SRC=%~dp0
set DST=C:\inetpub\wwwroot\wwwroot

git -C "%SRC%." pull --ff-only
if errorlevel 1 (
  echo git pull failed - aborting, nothing was copied.
  exit /b 1
)

set FAILED=0
call :mirror presentation
call :mirror legal
call :mirror el
call :mirror en

copy /Y "%SRC%index.html" "%DST%\index.html" >nul
if errorlevel 1 (
  echo ERROR publishing index.html
  set FAILED=1
)

echo.
if %FAILED%==0 (
  echo Done - static content published to %DST%
) else (
  echo FAILED - one or more folders were NOT published. Run this script
  echo from an elevated command prompt ^(Run as administrator^).
  exit /b 1
)
goto :eof

:mirror
robocopy "%SRC%%~1" "%DST%\%~1" /MIR /NFL /NDL /NJH
REM robocopy exit codes 0-7 mean success; 8+ means at least one failure
if errorlevel 8 (
  echo ERROR publishing %~1
  set FAILED=1
)
goto :eof
