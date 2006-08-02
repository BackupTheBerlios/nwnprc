mkdir output
tlktools tlkmerge.xml
2daMerge -c -ooffsets.txt -rreferences.txt -S cep2\baseitems.2da cep2\itempropdef.2da cep2\itemprops.2da cep2\traps.2da cep2\vfx_persistent.2da -M prc\baseitems.2da prc\itempropdef.2da prc\itemprops.2da prc\traps.2da prc\vfx_persistent.2da -O output\baseitems.2da output\itempropdef.2da output\itemprops.2da output\traps.2da output\vfx_persistent.2da
erf -c prccep2.hak output\*.2da
pause