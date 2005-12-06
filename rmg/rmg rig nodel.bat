java -Xmx300m -Xmx300m -classpath .;tools\prc.jar rmg.main -rig
pause
java -cp "tools\modpacker\nwn-tools.jar" org.progeeks.nwn.XmlToGff out in\*
tools\erf -c rig.hak out\*.uti
REM del out\*.uti
REM del in\*.uti.xml