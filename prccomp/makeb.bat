@ECHO off
ECHO Running %OUTPUT%
del /q %OUTPUT%
mkdir %OUTPUT%
java -Xmx100m -jar prc.jar 2damerge %SOURCE% %MERGE% %OUTPUT% -> %NAME%.log
xcopy /Q %NAME%.n* %OUTPUT%\hakmarker.n*
erf -c %NAME%.hak %OUTPUT%\*.*
exit