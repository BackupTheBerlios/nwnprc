@ECHO off
ECHO copying files to output directory
REM An attempt to reproduce copyhak.bat as it's not in CVS

REM Copy all haks to output
xcopy /q /y *.hak output

REM Copy all hifs to output
xcopy /q /y *.hif output

REM And the tlk
xcopy /q /y prccep.tlk output

REM Copy readme and credits
xcopy /q /y prc*_readme.txt output

REM Make rar
rar.exe a -ep -inul prccep1_merge.rar output\prc*1*
rar.exe a -ep -inul prccep1_merge.rar output\prccep.tlk

rar.exe a -ep -inul prccep2_merge.rar output\prc*2*
rar.exe a -ep -inul prccep2_merge.rar output\prccep.tlk

pause
exit
