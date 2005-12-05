del temp\*.uti
del temp\*.uti.xml
copy rig.2da temp\rig.2da
copy rig_ip.2da temp\rig_ip.2da
java -Xmx300m -Xmx300m -classpath .;tools\prc.jar rmg.Main -rig
java -cp "tools\modpacker\nwn-tools.jar" org.progeeks.nwn.XmlToGff temp temp\*
tools\erf -c rig.hak temp\*.uti
del temp\*.uti
del temp\*.uti.xml
pause