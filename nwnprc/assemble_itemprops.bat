@echo on

java -Xmx200m -jar tools\prc.jar itempropmaker
pause
tools\modpacker\XmlToGff others xml_temp\*
del xml_temp

:end
