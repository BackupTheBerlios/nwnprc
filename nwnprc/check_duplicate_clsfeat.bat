@echo off

SETLOCAL

FOR %%i IN (.\2das\cls_feat_*.2da) DO (
    java -jar tools\prc.jar dupentries %%i FeatIndex
)

ENDLOCAL
:end