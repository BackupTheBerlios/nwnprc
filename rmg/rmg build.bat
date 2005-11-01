javac -Xlint:all -g -classpath .;tools\prc.jar rmg\*.java
pause
jar -cvfm rmg.jar rmg\rmg.mf rmg\*
pause