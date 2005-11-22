del temp\*.uti
del temp\*.uti.xml
java -cp "tools\modpacker\nwn-tools.jar" org.progeeks.nwn.XmlToGff temp2 temp\*
tools\erf -c rig.hak temp2\*.uti
del temp\*.uti
del temp\*.uti.xml
pause