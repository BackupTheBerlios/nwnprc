java -Xmx300m -Xmx300m -classpath .;tools\prc.jar rmg.Main -rwg
pause
tools\i_view32 *.bmp /convert=c:\*.tga
copy c:\*.tga *.tga
del c:\*.tga
del *.bmp
mkdir xml
mkdir out
copy *.xml xml\*.xml
java -cp "tools\modpacker\nwn-tools.jar" org.progeeks.nwn.XmlToGff out xml\*
copy out\*.* *.*
copy *.tga worldmap\*.tga
copy *.mdl worldmap\*.mdl
copy *.wok worldmap\*.wok
copy *.set worldmap\*.set
copy *.itp worldmap\*.itp
copy *.are worldmap\*.are
copy *.gic worldmap\*.gic
copy *.git worldmap\*.git
copy *.xml worldmap\*.xml
del worldmap.hak
tools\erf -c worldmap.hak *.tga *.mdl *.wok *.set *.itp
tools\erf -c worldmap.erf *.are *.git *.gic 
copy worldmap.hak C:\Games\NeverwinterNights\NWN\hak\worldmap.hak
copy worldmap.erf C:\Games\NeverwinterNights\NWN\erf\worldmap.erf
del *.tga 
del *.mdl 
del *.wok 
del *.are
del *.gic 
del *.git
del *.set
del *.xml
del xml
del out
del worldmap.hak
del worldmap.erf
del System.out
pause