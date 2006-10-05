@echo off
ECHO Updating PRC sources
mkdir prc
xcopy /Q /Y ..\prc\tlk\prc_consortium.tlk prc_consortium.tlk
xcopy /Q /Y ..\prc\2das\*.2da prc\*.2da
xcopy /Q /Y ..\prc\craft2das\*.2da prc\*.2da
xcopy /Q /Y ..\prc\race2das\*.2da prc\*.2da
xcopy /Q /Y ..\prc\tools\prc.jar prc.jar
pause