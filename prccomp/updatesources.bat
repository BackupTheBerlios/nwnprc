@echo off
ECHO Updating PRC sources
mkdir prc
xcopy /Q ..\prc\tlk\prc_consortium.tlk.xml prc_consortium.tlk.xml
xcopy /Q ..\prc\2das\*.2da prc\*.2da
xcopy /Q ..\prc\craft2das\*.2da prc\*.2da
xcopy /Q ..\prc\race2das\*.2da prc\*.2da
xcopy /Q ..\prc\tools\prc.jar prc.jar

ECHO Converting tlk files to xml
tlk2xml cep.tlk cep.tlk.xml