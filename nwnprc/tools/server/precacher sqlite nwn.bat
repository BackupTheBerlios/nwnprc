del precacher2das\*.2da
mkdir precacher2das
7za x bioware2das.7z -oprecacher2das
del sqlite.db
java -Xmx100m -jar prc.jar 2datosql precacher2das
sqlite sqlite.db ".read out.sql"
del out.sql