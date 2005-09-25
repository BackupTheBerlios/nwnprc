@if exist CC.jar del CC.jar

jar cvfm CC.jar cc.mf CharacterCreator/*.*
jar uvf CC.jar CharacterCreator/bic/*.*
jar uvf CC.jar CharacterCreator/defs/*.*
jar uvf CC.jar CharacterCreator/doc/
jar uvf CC.jar CharacterCreator/io/*.*
jar uvf CC.jar CharacterCreator/key/*.*
jar uvf CC.jar CharacterCreator/resource/
jar uvf CC.jar CharacterCreator/util/*.*


jar -xf NativeFmodRuntime/lib/NativeFmodApi_v3.11.jar Music
jar -uvf CC.jar Music
rmdir /s /q Music


mkdir nativemodules
copy NativeFmodRuntime\lib\* nativemodules
del nativemodules\NativeFmodApi_v3.11.jar
jar -uvf CC.jar -C nativemodules nativemodules/*
rmdir /s /q nativemodules

@PAUSE