@ECHO off

del /q *.hak
del /q *.log
mkdir output

ECHO Merging tlk xml files
tlktools tlkmerge.xml

ECHO Compiling marker scripts
nwnnsscomp -g *.nss

REM Merge CEP 2 & PRC
REM put this in its own dir for later
SET SOURCE=cep2
SET MERGE=prc
SET OUTPUT=prccep2
SET NAME=prccep2
start /B /wAIT makeb.bat

REM Merge CEP 153 & PRC
REM put this in its own dir for later
SET SOURCE=cep153
SET MERGE=prc
SET OUTPUT=prccep153
SET NAME=prccep153
start /B /wAIT makeb.bat

REM merge in dynamic cloaks with PRC
SET SOURCE=prc
SET MERGE=dyncloak
SET OUTPUT=output
SET NAME=prc168c
start /B /wAIT makeb.bat

REM merge in dynamic cloaks with PRC&CEP2
SET SOURCE=prccep2
SET MERGE=dyncloak
SET OUTPUT=output
SET NAME=prccep2168c
start /B /wAIT makeb.bat

REM merge in dynamic cloaks with PRC&CEP153
SET SOURCE=prccep153
SET MERGE=dyncloak
SET OUTPUT=output
SET NAME=prccep153168c
start /B /wAIT makeb.bat

pause