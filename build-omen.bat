@echo off
setlocal EnableExtensions EnableDelayedExpansion
rem Build Omen. Run this file from the Omen folder.
rem The firmware tree is the sibling folder omen-src (the one that contains fbt.cmd).
rem
rem   build-omen.bat
rem   build-omen.bat nosync
rem   build-omen.bat base
rem
rem Default build includes the extra app pack.
rem base skips it. nosync skips git submodules.
rem The .tgz is written next to this script, in Omen v1.0.0.X.
rem The last number grows when that folder already has a package.

set "OMEN=%~dp0"
if "%OMEN:~-1%"=="\" set "OMEN=%OMEN:~0,-1%"
set "VERFILE=%OMEN%\version.txt"
set "PACK=extra"
set "MAPPED="

if /I "%~1"=="base" set "PACK=base"
if /I "%~2"=="base" set "PACK=base"
if /I "%~1"=="nosync" set "FBT_NO_SYNC=1"
if /I "%~2"=="nosync" set "FBT_NO_SYNC=1"

set "SRC="
if exist "%OMEN%\..\omen-src\fbt.cmd" set "SRC=%OMEN%\..\omen-src"
if not defined SRC if exist "%OMEN%\omen-src\fbt.cmd" set "SRC=%OMEN%\omen-src"
if not defined SRC (
    echo Put the firmware tree in a folder named omen-src next to this script.
    exit /b 1
)
for %%I in ("%SRC%") do set "SRC=%%~fI"

rem The packager splits arguments on spaces. Map a free drive letter when needed.
set "BUILD=%SRC%"
echo %SRC% | find " " >nul
if not errorlevel 1 (
    set "LETTER="
    for %%L in (O P Q R S T U V) do (
        if not defined LETTER if not exist %%L:\ set "LETTER=%%L"
    )
    if not defined LETTER (
        echo No free drive letter to map the firmware path.
        exit /b 1
    )
    subst !LETTER!: "%SRC%"
    if errorlevel 1 exit /b 1
    set "BUILD=!LETTER!:"
    set "MAPPED=!LETTER!:"
)

if not exist "%VERFILE%" echo 1.0.0.0>"%VERFILE%"
set /p VER=<"%VERFILE%"
set "OUT=%OMEN%\Omen v%VER%"
if exist "%OUT%\*.tgz" (
    for /f "usebackq delims=" %%V in (`powershell -NoProfile -Command "$p=(Get-Content -Raw '%VERFILE%').Trim().Split('.'); $p[3]=[int]$p[3]+1; $p -join '.'"`) do set "VER=%%V"
    >"%VERFILE%" echo !VER!
    set "OUT=%OMEN%\Omen v!VER!"
)
if not exist "!OUT!" mkdir "!OUT!"

cd /d "!BUILD!"
if /I "%PACK%"=="extra" (
    echo Fetching extra apps
    set "PACKDIR=%TEMP%\omen-packs"
    if not exist "!PACKDIR!" mkdir "!PACKDIR!"
    gh release download --repo xMasterX/all-the-plugins --pattern "all-the-apps-extra.zip" --dir "!PACKDIR!" --clobber
    if errorlevel 1 (
        echo Could not fetch the extra app pack.
        if defined MAPPED subst !MAPPED! /d >nul
        exit /b 1
    )
    if not exist "assets\resources\apps" mkdir "assets\resources\apps"
    powershell -NoProfile -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; $zip=[System.IO.Compression.ZipFile]::OpenRead((Join-Path $env:TEMP 'omen-packs\all-the-apps-extra.zip')); $root='extra_pack_build/artifacts-extra/'; $dest=Join-Path (Get-Location) 'assets\resources\apps'; foreach($e in $zip.Entries){ if($e.FullName.StartsWith($root) -and -not $e.FullName.EndsWith('/')){ $rel=$e.FullName.Substring($root.Length); $out=Join-Path $dest $rel; $dir=Split-Path $out; if(-not (Test-Path $dir)){ New-Item -ItemType Directory -Force -Path $dir | Out-Null }; [System.IO.Compression.ZipFileExtensions]::ExtractToFile($e,$out,$true) } }; $zip.Dispose()"
    if errorlevel 1 (
        echo Could not unpack extra apps.
        if defined MAPPED subst !MAPPED! /d >nul
        exit /b 1
    )
)

echo Building Omen v!VER! ^(%PACK%^)
set "DIST_SUFFIX=omen"
set "FORCE_NO_DIRTY=yes"
call fbt.cmd COMPACT=1 DEBUG=0 updater_package
if errorlevel 1 (
    echo Build failed.
    if defined MAPPED subst !MAPPED! /d >nul
    exit /b 1
)

set "COPIED="
for /r "!BUILD!\dist" %%F in (*.tgz) do (
    echo %%~nxF | findstr /i /b "flipper-z-f7-update-" >nul
    if not errorlevel 1 (
        copy /Y "%%~fF" "!OUT!\" >nul
        set "COPIED=%%~nxF"
    )
)
if defined MAPPED subst !MAPPED! /d >nul
if not defined COPIED (
    echo No update package was produced.
    exit /b 1
)

echo.
echo !OUT!\!COPIED!
echo Install that .tgz with qFlipper or the Flipper mobile app, channel Custom.
echo Or unpack it and open update\f7-update-omen\update.fuf on the device.
exit /b 0
