mkdir mod_nwangband
mkdir hak_nwangband
mkdir xmltemp

copy "C:\Games\NeverwinterNights\NWN\modules\nwangband.mod" nwangband.mod
@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.ModReader nwangband.mod xmltemp
@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.GffToXml mod_nwangband xmltemp/*  
del /q mod_nwangband\*.ncs
del /q xmltemp\*.*

REM No need to unpack the hak!
REM copy "C:\Games\NeverwinterNights\NWN\hak\nwangband.hak"     nwangband.hak
REM @java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.ModReader nwangband.hak xmltemp
REM @java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.GffToXml hak_nwangband xmltemp/*
REM del /q hak_nwangband\*.ncs
REM del /q xmltemp\*.*

del /q xmltemp

REM No need to unpack the tlk!
REM copy "C:\Games\NeverwinterNights\NWN\tlk\nwangband.tlk"     nwangband.tlk
REM ..\tools\tlktools\tlk2xml nwangband.tlk nwangband.xml

pause