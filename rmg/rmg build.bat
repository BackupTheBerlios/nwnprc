del rmg\*.class
del rmg\rig\*.class
javac -Xlint:all -g -classpath .;tools\prc.jar rmg\*.java
pause
jar -cvfm rmg.jar rmg\rmg.mf rmg\*.class rmg\rig\*.class
pause