-- --------------------------------------------------------

-- 
-- Table structure for table `prccache`
-- 

DROP TABLE IF EXISTS `prccache`;
CREATE TABLE `prccache` (
  `ID` int(11) NOT NULL auto_increment,
  `file` varchar(16) NOT NULL default '',
  `row` int(4) default NULL,
  `column` varchar(255) default NULL,
  `data` varchar(255) default NULL,
  PRIMARY KEY  (`ID`),
  KEY `file` (`file`)
) TYPE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `prccache_classes`
-- 

DROP TABLE IF EXISTS `prccache_classes`;
CREATE TABLE `prccache_classes` (
  `row` int(4) NOT NULL default '0',
  `label` varchar(255) default NULL,
  `name` int(4) default NULL,
  `plural` int(4) default NULL,
  `lower` int(4) default NULL,
  `description` int(4) default NULL,
  `icon` varchar(255) default NULL,
  `hitdie` int(1) default NULL,
  `attackbonustable` varchar(16) default NULL,
  `featstable` varchar(16) default NULL,
  `savingthrowtable` varchar(16) default NULL,
  `skillstable` varchar(16) default NULL,
  `bonusfeatstable` varchar(16) default NULL,
  `skillpointbase` int(1) default NULL,
  `spellgaintable` varchar(16) default NULL,
  `spellknowntable` varchar(16) default NULL,
  `playerclass` int(1) NOT NULL default '0',
  `spellcaster` int(1) default NULL,
  `str` int(1) default NULL,
  `dex` int(1) default NULL,
  `con` int(1) default NULL,
  `wis` int(1) default NULL,
  `int` int(1) default NULL,
  `cha` int(1) default NULL,
  `primaryabil` char(3) default NULL,
  `alignrestrict` varchar(4) default NULL,
  `alignrstrcttype` varchar(4) default NULL,
  `invertrestrict` int(1) default NULL,
  `constant` varchar(255) default NULL,
  `effcrlvl01` int(4) default NULL,
  `effcrlvl02` int(4) default NULL,
  `effcrlvl03` int(4) default NULL,
  `effcrlvl04` int(4) default NULL,
  `effcrlvl05` int(4) default NULL,
  `effcrlvl06` int(4) default NULL,
  `effcrlvl07` int(4) default NULL,
  `effcrlvl08` int(4) default NULL,
  `effcrlvl09` int(4) default NULL,
  `effcrlvl10` int(4) default NULL,
  `effcrlvl11` int(4) default NULL,
  `effcrlvl12` int(4) default NULL,
  `effcrlvl13` int(4) default NULL,
  `effcrlvl14` int(4) default NULL,
  `effcrlvl15` int(4) default NULL,
  `effcrlvl16` int(4) default NULL,
  `effcrlvl17` int(4) default NULL,
  `effcrlvl18` int(4) default NULL,
  `effcrlvl19` int(4) default NULL,
  `effcrlvl20` int(4) default NULL,
  `prereqtable` varchar(16) default NULL,
  `maxlevel` int(1) default NULL,
  `xppenalty` int(1) default NULL,
  `arcspelllvlmod` int(1) default NULL,
  `divspelllvlmod` int(1) default NULL,
  `epiclevel` int(1) default NULL,
  `package` int(4) default NULL,
  PRIMARY KEY  (`row`),
  KEY `playerclass` (`playerclass`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `prccache_cls_bfeat`
-- 

DROP TABLE IF EXISTS `prccache_cls_bfeat`;
CREATE TABLE `prccache_cls_bfeat` (
  `ID` int(11) NOT NULL auto_increment,
  `file` varchar(16) NOT NULL default '',
  `row` int(1) default NULL,
  `bonus` int(1) default NULL,
  PRIMARY KEY  (`ID`),
  KEY `file` (`file`)
) TYPE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `prccache_cls_feat`
-- 

DROP TABLE IF EXISTS `prccache_cls_feat`;
CREATE TABLE `prccache_cls_feat` (
  `ID` int(11) NOT NULL auto_increment,
  `file` varchar(16) NOT NULL default '',
  `featindex` int(4) default NULL,
  `list` int(4) default NULL,
  `grantedonlevel` int(1) default NULL,
  `onmenu` int(1) default NULL,
  PRIMARY KEY  (`ID`),
  KEY `file` (`file`)
) TYPE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `prccache_cls_skill`
-- 

DROP TABLE IF EXISTS `prccache_cls_skill`;
CREATE TABLE `prccache_cls_skill` (
  `ID` int(11) NOT NULL auto_increment,
  `file` varchar(16) NOT NULL default '',
  `skillindex` int(4) default NULL,
  `classskill` int(1) default NULL,
  PRIMARY KEY  (`ID`),
  KEY `file` (`file`)
) TYPE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `prccache_feat`
-- 

DROP TABLE IF EXISTS `prccache_feat`;
CREATE TABLE `prccache_feat` (
  `row` int(11) NOT NULL default '0',
  `label` varchar(255) default NULL,
  `feat` int(4) default NULL,
  `description` int(4) default NULL,
  `icon` varchar(255) default NULL,
  `minattackbonus` int(4) default NULL,
  `minstr` int(1) default NULL,
  `mindex` int(1) default NULL,
  `minint` int(1) default NULL,
  `mincon` int(1) default NULL,
  `minwis` int(1) default NULL,
  `mincha` int(1) default NULL,
  `minspelllvl` int(1) default NULL,
  `prereqfeat1` int(4) default NULL,
  `prereqfeat2` int(4) default NULL,
  `gainmultiple` int(1) default NULL,
  `effectsstack` int(1) default NULL,
  `allclassescanuse` int(1) default NULL,
  `category` int(4) default NULL,
  `maxcr` int(1) default NULL,
  `spellid` int(4) default NULL,
  `successor` int(4) default NULL,
  `crvalue` int(11) default NULL,
  `usesperday` int(4) default NULL,
  `masterfeat` int(4) default NULL,
  `targetself` int(1) default NULL,
  `orreqfeat0` int(4) default NULL,
  `orreqfeat1` int(4) default NULL,
  `orreqfeat2` int(4) default NULL,
  `orreqfeat3` int(4) default NULL,
  `orreqfeat4` int(4) default NULL,
  `reqskill` int(4) default NULL,
  `reqskillminranks` int(4) default NULL,
  `reqskill2` int(4) default NULL,
  `reqskillminranks2` int(4) default NULL,
  `constant` varchar(255) default NULL,
  `toolscategories` int(4) default NULL,
  `hostilefeat` int(1) default NULL,
  `minlevel` int(1) default NULL,
  `minlevelclass` int(1) default NULL,
  `maxlevel` int(1) default NULL,
  `minfortsave` int(4) default NULL,
  `prereqepic` int(1) default NULL,
  PRIMARY KEY  (`row`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `prccache_portraits`
-- 

DROP TABLE IF EXISTS `prccache_portraits`;
CREATE TABLE `prccache_portraits` (
  `row` int(4) NOT NULL default '0',
  `baseresref` varchar(16) default NULL,
  `sex` int(1) default NULL,
  `race` int(4) default NULL,
  `inanimatetype` int(4) default NULL,
  `plot` int(1) default NULL,
  `lowgore` varchar(16) default NULL,
  PRIMARY KEY  (`row`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `prccache_race_feat`
-- 

DROP TABLE IF EXISTS `prccache_race_feat`;
CREATE TABLE `prccache_race_feat` (
  `ID` int(11) NOT NULL auto_increment,
  `file` varchar(16) NOT NULL default '',
  `featindex` int(4) default NULL,
  PRIMARY KEY  (`ID`),
  KEY `file` (`file`)
) TYPE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `prccache_racialtypes`
-- 

DROP TABLE IF EXISTS `prccache_racialtypes`;
CREATE TABLE `prccache_racialtypes` (
  `row` int(11) NOT NULL default '0',
  `label` varchar(255) default NULL,
  `abrev` char(2) default NULL,
  `name` int(4) default NULL,
  `convername` int(4) default NULL,
  `convernamelower` int(4) default NULL,
  `nameplural` int(4) default NULL,
  `description` int(4) default NULL,
  `appearance` int(4) default NULL,
  `stradjust` int(1) default NULL,
  `dexadjust` int(1) default NULL,
  `intadjust` int(1) default NULL,
  `chaadjust` int(1) default NULL,
  `wisadjust` int(1) default NULL,
  `conadjust` int(1) default NULL,
  `endurance` int(4) default NULL,
  `favored` int(4) default NULL,
  `featstable` varchar(16) default NULL,
  `biography` int(4) default NULL,
  `playerrace` int(1) NOT NULL default '0',
  `constant` varchar(255) default NULL,
  `age` int(4) default NULL,
  `toolsetdefaultclass` int(4) default NULL,
  `crmodifier` float default NULL,
  PRIMARY KEY  (`row`),
  KEY `playerrace` (`playerrace`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `prccache_reqs`
-- 

DROP TABLE IF EXISTS `prccache_reqs`;
CREATE TABLE `prccache_reqs` (
  `ID` int(11) NOT NULL auto_increment,
  `file` varchar(16) NOT NULL default '',
  `ReqType` varchar(255) default NULL,
  `ReqParam1` varchar(255) default NULL,
  `ReqParam2` varchar(255) default NULL,
  PRIMARY KEY  (`ID`),
  KEY `file` (`file`)
) TYPE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `prccache_soundset`
-- 

DROP TABLE IF EXISTS `prccache_soundset`;
CREATE TABLE `prccache_soundset` (
  `row` int(4) NOT NULL default '0',
  `label` varchar(255) default NULL,
  `resref` varchar(16) default NULL,
  `strref` int(4) default NULL,
  `gender` int(1) default NULL,
  `type` int(1) default NULL,
  PRIMARY KEY  (`row`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `prccache_spells`
-- 

DROP TABLE IF EXISTS `prccache_spells`;
CREATE TABLE `prccache_spells` (
  `row` int(11) NOT NULL default '0',
  `label` varchar(255) default NULL,
  `name` int(4) default NULL,
  `iconresref` varchar(16) default NULL,
  `school` char(1) default NULL,
  `range` char(1) default NULL,
  `vs` char(3) default NULL,
  `metamagic` varchar(4) default NULL,
  `targettype` varchar(4) default NULL,
  `impactscript` varchar(16) default NULL,
  `bard` int(1) default NULL,
  `cleric` int(1) default NULL,
  `druid` int(1) default NULL,
  `paladin` int(1) default NULL,
  `ranger` int(1) default NULL,
  `wiz_sorc` int(1) default NULL,
  `innate` int(1) default NULL,
  `conjtime` int(4) default NULL,
  `conjanim` varchar(4) default NULL,
  `conjheadvisual` varchar(16) default NULL,
  `conjhandvisual` varchar(16) default NULL,
  `conjgrndvisual` varchar(16) default NULL,
  `conjsoundvfx` varchar(16) default NULL,
  `conjsoundmale` varchar(16) default NULL,
  `conjsoundfemale` varchar(16) default NULL,
  `castanim` varchar(16) default NULL,
  `casttime` int(4) default NULL,
  `castheadvisual` varchar(16) default NULL,
  `casthandvisual` varchar(16) default NULL,
  `castgrndvisual` varchar(16) default NULL,
  `castsound` varchar(16) default NULL,
  `proj` int(1) default NULL,
  `projmodel` varchar(16) default NULL,
  `projtype` varchar(16) default NULL,
  `projspwnpoint` varchar(16) default NULL,
  `projsound` varchar(16) default NULL,
  `projorientation` varchar(16) default NULL,
  `immunitytype` varchar(255) default NULL,
  `itemimmunity` int(1) default NULL,
  `subradspell1` int(4) default NULL,
  `subradspell2` int(4) default NULL,
  `subradspell3` int(4) default NULL,
  `subradspell4` int(4) default NULL,
  `subradspell5` int(4) default NULL,
  `category` int(4) default NULL,
  `master` int(4) default NULL,
  `usertype` int(4) default NULL,
  `spelldesc` int(4) default NULL,
  `useconcentration` int(1) default NULL,
  `spontaneouslycast` int(1) default NULL,
  `altmessage` int(4) default NULL,
  `hostilesetting` int(1) default NULL,
  `featid` int(4) default NULL,
  `counter1` int(4) default NULL,
  `counter2` int(4) default NULL,
  `hasprojectile` int(1) default NULL,
  PRIMARY KEY  (`row`)
) TYPE=MyISAM;
