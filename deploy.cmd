@echo off
REM Publish static content to the live IIS folder (run ON the server).
REM The we-the-greeks.world site serves the Democracy.Web backend from
REM C:\inetpub\wwwroot; this script must NEVER touch the root files there
REM (web.config, appsettings*.json, *.dll) - it only mirrors the static
REM subfolders from this git checkout.
set SRC=%~dp0
set DST=C:\inetpub\wwwroot

git -C "%SRC%." pull --ff-only
if errorlevel 1 (
  echo git pull failed - aborting, nothing was copied.
  exit /b 1
)

robocopy "%SRC%presentation" "%DST%\presentation" /MIR /NFL /NDL /NJH
robocopy "%SRC%legal" "%DST%\legal" /MIR /NFL /NDL /NJH
robocopy "%SRC%el" "%DST%\el" /MIR /NFL /NDL /NJH
robocopy "%SRC%en" "%DST%\en" /MIR /NFL /NDL /NJH

echo.
echo Done - static content published to %DST%
