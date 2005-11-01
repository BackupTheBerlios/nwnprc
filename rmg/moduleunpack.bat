mkdir mod
copy rmg.mod mod\rmg.mod
copy tools\erf.exe mod\erf.exe
cd mod
mkdir xml
erf -x rmg.mod
cd..
del mod\rmg.mod
del mod\erf.exe
java -cp tools\modpacker\nwn-tools.jar org.progeeks.nwn.GffToXml mod\xml mod\*
pause