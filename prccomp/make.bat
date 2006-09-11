@ECHO off

del /q *.hak
del /q *.log
mkdir output

ECHO Assembling PRC Companion hak
erf -c prccomp.hak companion\2da\*.*
erf -u prccomp.hak companion\data\*.*

ECHO copying the prc companion 2das somewhere to be merged
mkdir prccc
copy companion\2da\*.2da prccc\*.2da

ECHO Merging tlk xml files
tlktools tlkmerge.xml

ECHO Compiling marker scripts
nwnnsscomp -g *.nss

REM SOURCE is the name of the directory to take from
REM MERGE is the name of the directory to add from
REM note merge has priority over source
REM OUTPUT name of the directory to put it into
REM NAME is the name of the files to make

REM prc  = PRC
REM prcc = PRC including Companion
REM c2   = CEP2 (2.0b2)
REM c1   = CEP1 (1.68)

REM Merge PRC & Companion
REM put this in its own dir for later
SET SOURCE=companion\2da
SET MERGE=prc
SET OUTPUT=prcc
SET NAME=prcc
start /B /wAIT makeb.bat
pause

REM Merge CEP 2 & PRC Companion
REM put this in its own dir for later
SET SOURCE=cep2
SET MERGE=prcc
SET OUTPUT=prcccep2
SET NAME=prccc2
start /B /wAIT makeb.bat
 
REM Merge CEP 1 & PRC Companion
REM put this in its own dir for later
SET SOURCE=cep1
SET MERGE=prcc
SET OUTPUT=prcccep1
SET NAME=prccc1
start /B /wAIT makeb.bat

REM Merge CEP 2 & PRC
REM put this in its own dir for later
SET SOURCE=cep2
SET MERGE=prc
SET OUTPUT=prccep2
SET NAME=prcc2
start /B /wAIT makeb.bat

REM Merge CEP 1 & PRC
REM put this in its own dir for later
SET SOURCE=cep1
SET MERGE=prc
SET OUTPUT=prccep1
SET NAME=prcc1
start /B /wAIT makeb.bat


start /B copyhak.bat
pause
exit