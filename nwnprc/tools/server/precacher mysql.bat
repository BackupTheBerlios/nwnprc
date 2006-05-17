del precacher2das\*.2da
mkdir precacher2das
7za x bioware2das.7z -oprecacher2das
erf -x hak\prc_2das.hak 
erf -x hak\prc_race.hak 
copy *.2da precacher2das\*.2da
del *.2da
del *.nss
del *.ncs
java -Xmx100m -jar prc.jar 2datosql precacher2das MySQL