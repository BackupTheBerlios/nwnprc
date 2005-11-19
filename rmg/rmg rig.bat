del temp\*.uti
del temp\*.uti.xml
java -Xmx300m -Xmx300m -classpath .;tools\prc.jar rmg.Main -rig
java -cp "tools\modpacker\nwn-tools.jar" org.progeeks.nwn.XmlToGff temp temp\*
tools\erf -c rig.hak temp\*.uti
del temp\*.uti
del temp\*.uti.xml
pause