

SET PATH=D:\Program Files\Java\jdk1.5.0\bin

jar cvfm CC.jar cc.mf CharacterCreator/*.class
jar uvf CC.jar CharacterCreator/bic/*.class
jar uvf CC.jar CharacterCreator/defs/*.class
jar uvf CC.jar CharacterCreator/doc/
jar uvf CC.jar CharacterCreator/io/*.class
jar uvf CC.jar CharacterCreator/key/*.class
jar uvf CC.jar CharacterCreator/resource/
jar uvf CC.jar CharacterCreator/util/*.class

PAUSE