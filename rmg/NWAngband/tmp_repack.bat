mkdir gfftemp

@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.XmlToGff gfftemp mod_nwangband/*
copy ..\tools\nwnnsscomp.exe gfftemp\nwnnsscomp.exe
cd gfftemp
nwnnsscomp -g -i "C:\Documents and Settings\user\Desktop\PRC Stuff\prc\include" *.nss
del nwnnsscomp.exe
cd..
@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.ModPacker gfftemp nwangband.mod
del /q gfftemp\*.*
copy nwangband.mod "C:\Games\NeverwinterNights\NWN\modules\nwangband.mod"

@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.XmlToGff gfftemp hak_nwangband/*
copy ..\tools\nwnnsscomp.exe gfftemp\nwnnsscomp.exe
cd gfftemp
nwnnsscomp -g -i "C:\Documents and Settings\user\Desktop\PRC Stuff\prc\include" *.nss
del nwnnsscomp.exe
cd..
@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.ModPacker gfftemp nwangband.hak
del /q gfftemp\*.*
copy nwangband.hak "C:\Games\NeverwinterNights\NWN\hak\nwangband.hak"

del /q gfftemp
pause