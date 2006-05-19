mkdir gfftemp

@java -cp "C:\NeverwinterNights\prc\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.XmlToGff gfftemp mod_nwangband/*
@java -cp "C:\NeverwinterNights\prc\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.ModPacker gfftemp nwangband.mod
del /q gfftemp\*.*
@java -cp "C:\NeverwinterNights\prc\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.XmlToGff gfftemp hak_nwangband/*
@java -cp "C:\NeverwinterNights\prc\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.ModPacker gfftemp nwangband.hak
del /q gfftemp\*.*

copy nwangband.mod "c:\NeverwinterNights\NWN\modules\nwangband.mod"
copy nwangband.hak "c:\NeverwinterNights\NWN\hak\nwangband.hak"
del /q gfftemp
pause