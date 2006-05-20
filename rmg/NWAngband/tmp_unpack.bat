mkdir mod_nwangband
mkdir hak_nwangband
mkdir xmltemp

copy "C:\Games\NeverwinterNights\NWN\modules\nwangband.mod" nwangband.mod
@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.ModReader nwangband.mod xmltemp
@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.GffToXml mod_nwangband xmltemp/*  
del /q mod_nwangband\*.ncs
del /q xmltemp\*.*

copy "C:\Games\NeverwinterNights\NWN\hak\nwangband.hak"     nwangband.hak
@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.ModReader nwangband.hak xmltemp
@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.GffToXml hak_nwangband xmltemp/*
del /q hak_nwangband\*.ncs
del /q xmltemp\*.*

del /q xmltemp

copy "C:\Games\NeverwinterNights\NWN\tlk\nwangband.tlk"     nwangband.tlk
..\tools\tlktools\tlk2xml nwangband.tlk nwangband.xml

pause