@echo off
ECHO Updating PRC sources
mkdir prc
xcopy /Q /Y ..\nwnprc\tlk\prc_consortium.tlk prc_consortium.tlk
xcopy /Q /Y ..\nwnprc\2das\*.2da prc\*.2da
xcopy /Q /Y ..\nwnprc\craft2das\*.2da prc\*.2da
xcopy /Q /Y ..\nwnprc\race2das\*.2da prc\*.2da
xcopy /Q /Y ..\nwnprc\tools\prc.jar prc.jar
xcopy /Q /Y ..\nwnprc\tools\rar.exe rar.exe
pause