@echo off
set ROOT_SRC_DIR=%CD%

set _3RDPARTY=%ROOT_SRC_DIR%\src\qt\3rdparty

:: OpenSSL
set LIB=%ROOT_SRC_DIR%\src\qt\3rdparty\openssl\lib;%LIB%
set INCLUDE=%ROOT_SRC_DIR%\src\qt\3rdparty\openssl\include;%INCLUDE%

:: libicu
set LIB=%ROOT_SRC_DIR%\src\qt\3rdparty\libicu\lib;%LIB%
set INCLUDE=%ROOT_SRC_DIR%\src\qt\3rdparty\libicu\include;%INCLUDE%

:: libxml
set LIB=%ROOT_SRC_DIR%\src\qt\3rdparty\libxml\lib;%LIB%
set INCLUDE=%ROOT_SRC_DIR%\src\qt\3rdparty\libxml\include\libxml2;%INCLUDE%

:: sqlite
set SQLITE3SRCDIR=%ROOT_SRC_DIR%\src\qt\qtbase\src\3rdparty\sqlite

:: 3rd party binaries (flex, bison, etc.)
set PATH=%ROOT_SRC_DIR%\src\qt\3rdparty\gnuwin32\bin;%PATH%

echo ---------   LIB   ------------
echo %LIB%
echo --------- INCLUDE ------------
echo %INCLUDE%
echo ---------  PATH  -------------
echo %PATH%
echo
EXIT /b
