copy ..\..\..\tools\nwnnsscomp.exe gfftemp\nwnnsscomp.exe
copy module\*.nss gfftemp\*.nss
cd gfftemp
nwnnsscomp -g -i "C:\Documents and Settings\user\Desktop\PRC Stuff\prc\include" *.nss
del nwnnsscomp.exe
cd..
@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.ModPacker gfftemp prctrials.mod
copy prctrials.mod "C:\Games\NeverwinterNights\NWN\modules\prctrials.mod"

pause
cd C:\Games\NeverwinterNights\NWN
nwmain.exe +TestNewModule "prctrials"