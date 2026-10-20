@echo off
rem Clean-isolated launcher for penrose-room.html
rem Auto-detects Edge / Chrome / Firefox (first found wins), launches with an
rem isolated profile: no extensions, separate process tree / GPU process.
rem Chromium browsers start fullscreen. Firefox has no fullscreen flag - press
rem F11 once, Firefox remembers it for that profile.

set "PAGE=file:///%~dp0penrose-room.html"

if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" goto edge
if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" goto edge
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" goto chrome
if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" goto chrome
if exist "%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe" goto chrome
if exist "%ProgramFiles%\Mozilla Firefox\firefox.exe" goto firefox
if exist "%ProgramFiles(x86)%\Mozilla Firefox\firefox.exe" goto firefox
goto nobrowser

:edge
set "EXE=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" set "EXE=%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
goto chromium

:chrome
set "EXE=%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe"
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "EXE=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" set "EXE=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
goto chromium

:chromium
set "CLEANPROFILE=%LOCALAPPDATA%\PenroseRoom.Profile"
start "" "%EXE%" --user-data-dir="%CLEANPROFILE%" --no-first-run --no-default-browser-check --disable-extensions --start-fullscreen --start-maximized "%PAGE%"
exit /b 0

:firefox
set "EXE=%ProgramFiles%\Mozilla Firefox\firefox.exe"
if exist "%ProgramFiles(x86)%\Mozilla Firefox\firefox.exe" set "EXE=%ProgramFiles(x86)%\Mozilla Firefox\firefox.exe"
start "" "%EXE%" -profile "%LOCALAPPDATA%\PenroseRoom.Profile.FF" -no-remote -new-window "%PAGE%"
exit /b 0

:nobrowser
echo No supported browser found. Please install Edge, Chrome or Firefox.
pause
exit /b 1
