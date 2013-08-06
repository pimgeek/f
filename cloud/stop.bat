@ECHO OFF

REM **
REM ** define PIMHOME_DIR as \pim-wudi
REM ** the dir structure is like:
REM ** %PIMHOME%\_tool\tcrypt
REM ** %PIMHOME%\dropbox\volume.dat
REM **

set PIMHOME_DIR=%CD%
set PIMDRV_LETTER=%CD:~0,2%
set SECDRV1_LETTER=o:
set SECDRV2_LETTER=r:

dir %SECDRV%
IF ERRORLEVEL 0 goto SECPIM-EXTRACT-TEXT
IF ERRORLEVEL 1 goto END

:SECPIM-EXTRACT-TEXT
REM ** 
REM ** switch to sec directory to do file operations
REM ** 
%SECDRV1_LETTER%
cd \
REM ** 
REM ** delete all zim related files (without directories)
REM ** 
del /s /q %SECDRV1_LETTER%\_zim\*.*
cd %SECDRV1_LETTER%\_zim\
REM ** 
REM ** delete all empty directories (this operation is very dangerous!)
REM ** 
for /d %%i in (%SECDRV1_LETTER%\_zim\*.*) do rmdir /s /q %%i
REM ** 
REM ** extract text files from zim-database, including empty directory
REM ** 
xcopy /q /e /y %SECDRV2_LETTER%\_zim\*.txt %SECDRV1_LETTER%\_zim\
REM ** 
REM ** extract zim index files
REM ** 
xcopy /q /y %SECDRV2_LETTER%\_zim\.zim\*.* %SECDRV1_LETTER%\_zim\.zim\
REM ** 
REM ** extract zim notebook config file
REM ** 
xcopy /q /y %SECDRV2_LETTER%\_zim\notebook.zim %SECDRV1_LETTER%\_zim\.zim\

REM shutdown the quick launch tool
taskkill /f /im launchy.exe
taskkill /f /im eyedefender.exe
taskkill /f /im goagent.exe
taskkill /f /im ieproxytoggle.exe

REM close the private, secured knowledge base
%PIMDRV_LETTER%
cd %PIMHOME_DIR%\_tool\tcrypt
start .\truecrypt.exe /d /f /q

d:
cd \to-share
call d:\to-share\killhttpd.bat

:END
