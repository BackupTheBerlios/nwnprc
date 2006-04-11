@echo on

java -Xmx200m -jar tools\prc.jar itempropmaker
pause
mkdir xml_temp
java -cp tools\modpacker\nwn-tools.jar org.progeeks.nwn.XmlToGff others xml_temp\*
pause
:end
