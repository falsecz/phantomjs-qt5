@echo off
set ROOT_SRC_DIR=%CD%

set BUILD_TYPE=release
if /i "%1" == "debug" (
    SET BUILD_TYPE=debug
)

set _3RDPARTY=%ROOT_SRC_DIR%\src\qt\3rdparty

:: OpenSSL
set LIB=%ROOT_SRC_DIR%\src\qt\3rdparty\openssl\lib;%LIB%
set INCLUDE=%ROOT_SRC_DIR%\src\qt\3rdparty\openssl\include;%INCLUDE%

:: libicu
set LIB=%ROOT_SRC_DIR%\src\qt\3rdparty\libicu\lib;%LIB%
set INCLUDE=%ROOT_SRC_DIR%\src\qt\3rdparty\libicu\include;%INCLUDE%

:: libxml
set LIB=%ROOT_SRC_DIR%\src\qt\3rdparty\libxml\lib;%LIB%
set INCLUDE=%ROOT_SRC_DIR%\src\qt\3rdparty\libxml\include;%INCLUDE%

:: sqlite
set SQLITE3SRCDIR=%ROOT_SRC_DIR%\src\qt\qtbase\src\3rdparty\sqlite

:: 3rd party binaries (flex, bison, etc.)
set PATH=%ROOT_SRC_DIR%\src\qt\3rdparty\gnuwin32\bin;%PATH%

:: make tool
for %%X in (jom.exe) do (set JOMFOUND=%%~$PATH:X)
if defined JOMFOUND (
    set MAKE_TOOL=jom
) else (
    set MAKE_TOOL=nmake
)

echo ---------   LIB   ------------
echo %LIB%
echo --------- INCLUDE ------------
echo %INCLUDE%
echo ---------  PATH  -------------
echo %PATH%
echo
EXIT /b
