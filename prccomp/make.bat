REM @ECHO off

del /q *.hak
del /q *.log
mkdir output

ECHO Compiling marker scripts
nwnnsscomp -g *.nss

REM SOURCE is the name of the directory to take from
REM MERGE is the name of the directory to add from
REM note merge has priority over source
REM OUTPUT name of the directory to put it into
REM NAME is the name of the files to make

REM prc  = PRC
REM prcc = PRC including Companion
REM c2   = CEP2 (2.1c)
REM c1   = CEP1 (1.69)

REM Merge CEP 2 & PRC
REM put this in its own dir for later
SET SOURCE=cep2
SET MERGE=prc
SET OUTPUT=prccep2
SET NAME=prcc2
SET CEP=cep
start /B /wAIT makeb.bat

REM Merge CEP 1 & PRC
REM put this in its own dir for later
SET SOURCE=cep1
SET MERGE=prc
SET OUTPUT=prccep1
SET NAME=prcc1
SET CEP=cep
start /B /wAIT makeb.bat


ECHO Merging tlk xml files
tlktools tlkmerge.xml

start /B copyhak.bat
pause
exit