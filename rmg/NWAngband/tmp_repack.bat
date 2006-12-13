mkdir gfftempmod
mkdir gfftemphak

@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.XmlToGff gfftempmod mod_nwangband/*
@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.XmlToGff gfftemphak hak_nwangband/*

copy ..\tools\nwnnsscomp.exe gfftempmod\nwnnsscomp.exe
copy ..\tools\nwnnsscomp.exe gfftemphak\nwnnsscomp.exe

cd gfftempmod
nwnnsscomp -g -i "C:\Documents and Settings\user\Desktop\PRC Stuff\prc\include" -i "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\NWAngband\hak_nwangband" *.nss
del nwnnsscomp.exe
cd..

cd gfftemphak
nwnnsscomp -g -i "C:\Documents and Settings\user\Desktop\PRC Stuff\prc\include" *.nss
del nwnnsscomp.exe
cd..

pause

@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.ModPacker gfftempmod nwangband.mod
@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.ModPacker gfftemphak nwangband.hak

del /q gfftempmod\*.*
del /q gfftemphak\*.*

copy nwangband.mod "C:\Games\NeverwinterNights\NWN\modules\nwangband.mod"
copy nwangband.hak "C:\Games\NeverwinterNights\NWN\hak\nwangband.hak"


del /q gfftemp
pause