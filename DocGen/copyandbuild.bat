copy ..\prc\2das\*.2da 2da\*.2da
copy ..\prc\race2das\*.2da 2da\*.2da
copy ..\prc\craft2das\*.2da 2da\*.2da
copy ..\prc\tlk\*.tlk tlk\*.tlk
xcopy /iey "Main Manual Files" manual

nmake -NOLOGO

nmake -NOLOGO run_icons
pause