java -Xmx300m -Xmx300m -jar rmg.jar -rwg
pause
@ECHO OFF
tools\i_view32 *.bmp /convert=c:\*.tga
copy c:\*.tga *.tga
del c:\*.tga
del *.bmp
mkdir in
mkdir out

copy *.tga in\*.tga
tools\dds\processtextures in out
del in\*.tga
copy out\*.dds *.dds
del out\*.dds
REM out the following line if you want to keep TGA textures
del *.tga

REM These control the model compiler
REM probably a good idea for final distributions
REM but very slow for test runs
REM copy *.mdl in\*.mdl
REM del *.mdl
REM tools\nwnmdlcomp -c in\*.mdl 
REM copy in\*.mdl *.mdl
REM del in\*.mdl

copy *.xml in\*.xml
java -cp "tools\modpacker\nwn-tools.jar" org.progeeks.nwn.XmlToGff out in\*
copy out\*.* *.*
del /Q out\*.*
del in\*.xml
tools\erf -c worldmap.hak *.tga *.mdl *.wok *.set *.itp *.dds
tools\erf -c worldmap.erf *.are *.git *.gic 
REM del *.tga 
REM del *.mdl 
REM del *.wok 
REM del *.are
REM del *.gic 
REM del *.git
REM del *.set
REM del *.xml
REM del *.dds
del System.out
del processtextures.log