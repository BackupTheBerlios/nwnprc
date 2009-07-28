@ECHO off
ECHO Running %OUTPUT%
del /q %OUTPUT%
mkdir %OUTPUT%
java -Xmx100m -jar prc.jar 2damerge %SOURCE% %MERGE% %OUTPUT% -> %NAME%.log
xcopy /Q %NAME%.n* %OUTPUT%\hakmarker.n*
if %CEP%==cep xcopy /Q /y overwrite2das\racialtypes.2* %OUTPUT%
if %CEP%==cep xcopy /Q /y overwrite2das\phenotype.2* %OUTPUT%
if %CEP%==cep xcopy /Q /y overwrite2das\basetypes.2* %OUTPUT%
erf -c %NAME%.hak %OUTPUT%\*.*
exit