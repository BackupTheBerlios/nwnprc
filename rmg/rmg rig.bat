del out\*.uti
del in\*.uti.xml
java -Xmx300m -Xmx300m -jar rmg.jar -rig
pause
java -cp "tools\modpacker\nwn-tools.jar" org.progeeks.nwn.XmlToGff out in\*
tools\erf -c rig.hak out\*.uti