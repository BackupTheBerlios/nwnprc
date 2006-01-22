java -cp tools\modpacker\nwn-tools.jar org.progeeks.nwn.XmlToGff mod\xml mod\*
copy tools\erf.exe mod\erf.exe
cd mod
erf -c rmg.mod *.*
cd..
copy mod\rmg.mod rmg.mod
del mod\rmg.mod
del mod\erf.exe
del System.out
pause