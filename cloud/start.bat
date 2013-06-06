@ECHO OFF
REM ECHO Starting PHP FastCGI...

REM set PIMHOME to \pim-xxx\
REM the dir structure is like:
REM %PIMHOME%\_tool\tcrypt
REM %PIMHOME%\dropbox\tc-files
set PIMHOME=%CD%
set PIMDRV=%CD:~0,2%
set SECDRV=o:

REM booting the sec drive at start (REM tao starts from 9 REM)
REM open a private, secured knowledge base
cd %PIMHOME%\_tool\tcrypt
start .\truecrypt.exe /v %PIMHOME%\dropbox\flow-pim-idx-dpbox-20120826-64mb.tcd /m rm /l o /q
start .\truecrypt.exe /v %PIMHOME%\dropbox\ext\flow-pim-ext-dpbox-20120828-1gb.tcd /m rm /l r /q
pause

dir %SECDRV%
IF ERRORLEVEL 0 goto SECPIM
IF ERRORLEVEL 1 goto END

:SECPIM
r:
cd \
REM open a quick launch tool
cd r:\_tool\launchy
start /min .\launchy.exe

d:
cd \to-share
call d:\to-share\httpd.bat

:END
