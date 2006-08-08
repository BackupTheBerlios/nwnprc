del /q *.hak
del /q *.log
mkdir output

REM make sure the source prc files are up to date
copy ..\prc\tlk\prc_consortium.tlk.xml prc_consortium.tlk.xml
copy ..\prc\2das\*.2da prc\*.2da
copy ..\prc\craft2das\*.2da prc\*.2da
copy ..\prc\race2das\*.2da prc\*.2da

REM convert any tlk files to xml
tlk2xml cep.tlk cep.tlk.xml

REM run the tlk tools to actually do the merge
tlktools tlkmerge.xml

REM put this in its own dir for later
del /q prccep2
mkdir prccep2
java -Xmx100m -jar prc.jar 2damerge cep2 prc prccep2 -> prccep2.log
erf -c prccep2.hak prccep2\*.2da

REM put this in its own dir for later
del /q prccep153
mkdir prccep153
java -Xmx100m -jar prc.jar 2damerge cep153 prc prccep153 -> prccep153.log
erf -c prccep153.hak prccep153\*.2da

REM merge in dynamic cloaks with PRC
del /q output\*.*
java -Xmx100m -jar prc.jar 2damerge prc dyncloak output -> prc168c.log
erf -c prc168c.hak output\*.2da

REM merge in dynamic cloaks with PRC&CEP2
del /q output\*.*
java -Xmx100m -jar prc.jar 2damerge prccep2 dyncloak output -> prccep2168c.log
erf -c prccep2168c.hak output\*.2da

REM merge in dynamic cloaks with PRC&CEP153
del /q output\*.*
java -Xmx100m -jar prc.jar 2damerge prccep153 dyncloak output -> prccep153168c.log
erf -c prccep153168c.hak output\*.2da

pause