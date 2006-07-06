mkdir 2da
mkdir tlk
copy ..\prc\2das\*.2da 2da\*.2da
copy ..\prc\race2das\*.2da 2da\*.2da
copy ..\prc\craft2das\*.2da 2da\*.2da
..\prc\tools\xml2tlk.exe ..\prc\tlk\prc_consortium.tlk.xml ..\prc\tlk\prc_consortium.tlk
copy ..\prc\tlk\*.tlk tlk\*.tlk
xcopy /iey "Main Manual Files" manual

nmake -NOLOGO

nmake -NOLOGO run_icons
pause