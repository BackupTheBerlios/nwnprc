copy "c:\NeverwinterNights\NWN\modules\nwangband.mod" nwangband.mod 
copy "c:\NeverwinterNights\NWN\hak\nwangband.hak"     nwangband.hak
@java -cp "C:\NeverwinterNights\prc\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.ModReader nwangband.mod mod_nwangband
@java -cp "C:\NeverwinterNights\prc\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.ModReader nwangband.hak hak_nwangband
pause