@echo off
setlocal EnableExtensions EnableDelayedExpansion
rem Build Omen from D:\omen-src and put flipper-z-f7-update-omen.tgz
rem into D:\Flipper Zero\Omen\Omen v1.0.0.X
rem The last number grows when that folder already contains a package.
rem
rem   build-omen.bat
rem   build-omen.bat nosync
rem   build-omen.bat base
rem
rem Default build includes the Unleashed extra app pack.
rem "base" builds firmware only. "nosync" skips git submodules.

set "SRC=D:\omen-src"
set "OMEN=D:\Flipper Zero\Omen"
set "VERFILE=%OMEN%\version.txt"
set "PACK=extra"

if /I "%~1"=="base" set "PACK=base"
if /I "%~2"=="base" set "PACK=base"
if /I "%~1"=="nosync" set "FBT_NO_SYNC=1"
if /I "%~2"=="nosync" set "FBT_NO_SYNC=1"

if not exist "%SRC%\fbt.cmd" (
    echo Missing %SRC%
    echo The firmware tree must live at D:\omen-src so the build path has no spaces.
    exit /b 1
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

cd /d "%SRC%"
if /I "%PACK%"=="extra" (
    echo Fetching extra apps
    if not exist "D:\_packs" mkdir "D:\_packs"
    gh release download --repo xMasterX/all-the-plugins --pattern "all-the-apps-extra.zip" --dir "D:\_packs" --clobber
    if errorlevel 1 (
        echo Could not fetch the extra app pack.
        exit /b 1
    )
    if not exist "assets\resources\apps" mkdir "assets\resources\apps"
    powershell -NoProfile -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; $zip=[System.IO.Compression.ZipFile]::OpenRead('D:\_packs\all-the-apps-extra.zip'); $root='extra_pack_build/artifacts-extra/'; $dest=Join-Path (Get-Location) 'assets\resources\apps'; foreach($e in $zip.Entries){ if($e.FullName.StartsWith($root) -and -not $e.FullName.EndsWith('/')){ $rel=$e.FullName.Substring($root.Length); $out=Join-Path $dest $rel; $dir=Split-Path $out; if(-not (Test-Path $dir)){ New-Item -ItemType Directory -Force -Path $dir | Out-Null }; [System.IO.Compression.ZipFileExtensions]::ExtractToFile($e,$out,$true) } }; $zip.Dispose()"
    if errorlevel 1 (
        echo Could not unpack extra apps.
        exit /b 1
    )
)

echo Building Omen v!VER! ^(%PACK%^)
set "DIST_SUFFIX=omen"
set "FORCE_NO_DIRTY=yes"
call fbt.cmd COMPACT=1 DEBUG=0 updater_package
if errorlevel 1 (
    echo Build failed.
    exit /b 1
)

set "COPIED="
for /r "%SRC%\dist" %%F in (flipper-z-f7-update-*.tgz) do (
    copy /Y "%%~fF" "!OUT!\" >nul
    set "COPIED=%%~nxF"
)
if not defined COPIED (
    echo No update package was produced.
    exit /b 1
)

echo.
echo !OUT!\!COPIED!
echo Install that .tgz with qFlipper or the Flipper mobile app, channel Custom.
echo Or unpack it and open update\f7-update-omen\update.fuf on the device.
exit /b 0
