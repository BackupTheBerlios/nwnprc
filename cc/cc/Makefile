JAVASRCS = 										\
	CharacterCreator\AbilitiesMenu.java			\
	CharacterCreator\AlignmentMenu.java			\
	CharacterCreator\BonusFeatMenu.java			\
	CharacterCreator\ClassMenu.java				\
	CharacterCreator\ColorSelect.java			\
	CharacterCreator\CompanionMenu.java			\
	CharacterCreator\CreateMenu.java			\
	CharacterCreator\CreditsMenu.java			\
	CharacterCreator\CustomizeMenu1.java		\
	CharacterCreator\CustomizeMenu2.java		\
	CharacterCreator\DeityMenu.java				\
	CharacterCreator\DomainMenu.java			\
	CharacterCreator\FamiliarMenu.java			\
	CharacterCreator\Feat.java					\
	CharacterCreator\FeatButton.java			\
	CharacterCreator\FeatMenu.java				\
	CharacterCreator\FeatMap.java				\
	CharacterCreator\FinalizeChar.java			\
	CharacterCreator\FinalizeCharByHand.java	\
	CharacterCreator\MainMenu.java				\
	CharacterCreator\PackageHandler.java		\
	CharacterCreator\PackagesMenu.java			\
	CharacterCreator\PortraitMenu.java			\
	CharacterCreator\ProgressBar.java			\
	CharacterCreator\RaceMenu.java				\
	CharacterCreator\ResourceFactory.java		\
	CharacterCreator\ResVer.java				\
	CharacterCreator\SchoolMenu.java			\
	CharacterCreator\SettingsMenu.java			\
	CharacterCreator\SexMenu.java				\
	CharacterCreator\Skill.java					\
	CharacterCreator\SkillMap.java				\
	CharacterCreator\SkillMenu.java				\
	CharacterCreator\Spell.java					\
	CharacterCreator\SpellMap.java				\
	CharacterCreator\SpellMenu.java				\
	CharacterCreator\SwingWorker.java			\
	CharacterCreator\TargaImage.java			\
	CharacterCreator\TattooMenu.java			\
	CharacterCreator\TLKFactory.java			\
	CharacterCreator\Win32.java					\
	CharacterCreator\WindowBlocker.java			\
	CharacterCreator\WordWrap.java				\
	CharacterCreator\bic\BICElement.java		\
	CharacterCreator\bic\BICEntry.java			\
	CharacterCreator\bic\BICFile.java			\
	CharacterCreator\defs\app.java				\
	CharacterCreator\defs\classes.java			\
	CharacterCreator\defs\clsfeat.java			\
	CharacterCreator\defs\clsskill.java			\
	CharacterCreator\defs\dom.java				\
	CharacterCreator\defs\feat.java				\
	CharacterCreator\defs\packages.java			\
	CharacterCreator\defs\racefeat.java			\
	CharacterCreator\defs\racialtypes.java		\
	CharacterCreator\defs\skills.java			\
	CharacterCreator\defs\spells.java			\
	CharacterCreator\defs\spkn.java				\
	CharacterCreator\defs\svthrow.java			\
	CharacterCreator\io\ArrayUtil.java			\
	CharacterCreator\io\Byteconvert.java		\
	CharacterCreator\io\Charconvert.java		\
	CharacterCreator\io\Filereader.java			\
	CharacterCreator\key\BIFFile.java			\
	CharacterCreator\key\HakFile.java			\
	CharacterCreator\key\HakResource.java		\
	CharacterCreator\key\KeyFile.java			\
	CharacterCreator\key\PatchKeyFile.java		\
	CharacterCreator\key\ResourceFile.java		\
	CharacterCreator\key\XP1KeyFile.java		\
	CharacterCreator\key\XP1PatchKeyFile.java	\
	CharacterCreator\key\XP2KeyFile.java		\
	CharacterCreator\key\XP2PatchKeyFile.java	\
	CharacterCreator\util\ChkHex.java			\
	CharacterCreator\util\CKSum.java			\

.SUFFIXES: .java .class

all: classes

.java.class:
	$(JAVA_BIN)\javac.exe -g $<

classes: $(JAVASRCS:.java=.class)

run: classes
	$(JAVA_BIN)\java.exe CharacterCreator.MainMenu

jar: classes
	@if exist jar_build rmdir /q /s jar_build
	@if exist cc.jar del cc.jar
	@mkdir jar_build
	@mkdir jar_build\CharacterCreator
	xcopy CharacterCreator jar_build\CharacterCreator /E /S
	$(JAVA_BIN)\jar cfm CC.jar manifest.mf -C jar_build CharacterCreator

clean:
	@if exist CharacterCreator\*.class del CharacterCreator\*.class
	@if exist CharacterCreator\bic\*.class del CharacterCreator\bic\*.class
	@if exist CharacterCreator\defs\*.class del CharacterCreator\defs\*.class
	@if exist CharacterCreator\io\*.class del CharacterCreator\io\*.class
	@if exist CharacterCreator\key\*.class del CharacterCreator\key\*.class
	@if exist CharacterCreator\util\*.class del CharacterCreator\util\*.class
	@if exist *.jar del *.jar
	@if exist jar_build rmdir /q /s jar_build
