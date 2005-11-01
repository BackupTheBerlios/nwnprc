javac -Xlint:all -g -source 1.5 -target 1.5 -extdirs "tools" rmg\*.java
pause
jar -cvfm rmg.jar rmg\rmg.mf rmg\*
pause