del out\*.uti
del in\*.uti.xml
java -Xmx300m -Xmx300m -jar rmg.jar -rig
pause
java -cp "tools\modpacker\nwn-tools.jar" org.progeeks.nwn.XmlToGff out in\*
copy rig*.2da out\rig*.2da
java -cp "tools\modpacker\nwn-tools.jar" org.progeeks.nwn.ModPacker out rig.hak
del out\*.uti
del in\*.uti.xml