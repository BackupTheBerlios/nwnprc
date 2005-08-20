//real power spell constants

// Metapsionics
const int METAPSIONIC_NONE          = 0x0;
const int METAPSIONIC_CHAIN         = 0x2;
const int METAPSIONIC_EMPOWER       = 0x4;
const int METAPSIONIC_EXTEND        = 0x8;
const int METAPSIONIC_MAXIMIZE      = 0x10;
const int METAPSIONIC_SPLIT         = 0x20;
const int METAPSIONIC_TWIN          = 0x40;
const int METAPSIONIC_WIDEN         = 0x80;

/// A constant with value equal to the lowest metapsionic constant. Used when looping over metapsionic flag variables
const int METAPSIONIC_MIN           = 0x2;
/// A constant with value equal to the highest metapsionic constant. Used when looping over metapsionic flag variables
const int METAPSIONIC_MAX           = 0x80;

// Psionic Disciplines
const int DISCIPLINE_PSYCHOMETABOLISM = 1;
const int DISCIPLINE_PSYCHOKINESIS    = 2;
const int DISCIPLINE_PSYCHOPORTATION  = 3;
const int DISCIPLINE_CLAIRSENTIENCE   = 4;
const int DISCIPLINE_METACREATIVITY   = 5;
const int DISCIPLINE_TELEPATHY        = 6;


//Psionic VFX Persistent
const int AOE_PER_PSIGREASE         = 131;
const int AOE_PER_SHAMBLER          = 132;
const int AOE_MOB_ENERGYWALL        = 133;
const int AOE_MOB_CATAPSI           = 134;

// Level 1 Powers
const int POWER_BOLT                        = 14001;
const int POWER_CALLTOMIND                  = 14002;
const int POWER_CHARMPERSON                 = 14003;
const int POWER_CRYSTALSHARD                = 14004;
const int POWER_DAZE                        = 14005;
const int POWER_DECELERATION                = 14006;
const int POWER_DEFPRECOG                   = 14007;
const int POWER_DEMORALIZE                  = 14008;
const int POWER_DISABLE                     = 14009;
const int POWER_DISSIPATINGTOUCH            = 14010;
const int POWER_DISTRACT                    = 14011;
const int POWER_EMPTYMIND                   = 14012;
const int POWER_CONCEALTHOUGHT              = 14013;
const int POWER_ENERGYRAY_COLD              = 14014;
const int POWER_ENERGYRAY_ELEC              = 14015;
const int POWER_ENERGYRAY_FIRE              = 14016;
const int POWER_ENERGYRAY_SONIC             = 14017;
const int POWER_ENTANGLE                    = 14018;
const int POWER_FORCESCREEN                 = 14019;
const int POWER_GREASE                      = 14020;
const int POWER_HAMMER                      = 14021;
const int POWER_INERTIALARMOUR              = 14022;
const int POWER_MINDTHRUST                  = 14023;
const int POWER_MYLIGHT                     = 14024;
const int POWER_OFFPRECOG                   = 14025;
const int POWER_OFFPRESC                    = 14026;
const int POWER_STOMP                       = 14027;
const int POWER_SYNESTHETE                  = 14028;
const int POWER_THICKSKIN                   = 14029;
const int POWER_VIGOR                       = 14030;
const int POWER_EMPATHY                     = 14031;
const int POWER_FARHAND                     = 14032;
const int POWER_MATTERAGITATION             = 14033;
const int POWER_SKATE                       = 14034;
const int POWER_TELEMPATHICPRO              = 14035;
const int POWER_ASTRALCONSTRUCT_SLOT1       = 14036;
const int POWER_ASTRALCONSTRUCT_SLOT2       = 14037;
const int POWER_ASTRALCONSTRUCT_SLOT3       = 14038;
const int POWER_ASTRALCONSTRUCT_SLOT4       = 14039;
const int POWER_CREATESOUND                 = 14040;
const int POWER_BURST                       = 14041;
const int POWER_DESTINYDISSONANCE           = 14042;
const int POWER_PRECOGNITION                = 14043;

// Level 2 Powers
const int POWER_BESTOWPOWER                 = 14051;
const int POWER_BIOFEEDBACK                 = 14052;
const int POWER_BRAINLOCK                   = 14053;
const int POWER_CONCBLAST                   = 14054;
const int POWER_CONCEALAMORPHA              = 14055;
const int POWER_CRYSTALSWARM                = 14056;
const int POWER_DISSOLVINGTOUCH             = 14057;
const int POWER_EGOWHIP                     = 14058;
const int POWER_ELFSIGHT                    = 14059;
const int POWER_ENERGYADAPTACID             = 14060;
const int POWER_ENERGYADAPTCOLD             = 14061;
const int POWER_ENERGYADAPTELEC             = 14062;
const int POWER_ENERGYADAPTFIRE             = 14063;
const int POWER_ENERGYADAPTSONIC            = 14064;
const int POWER_BODYEQUILIBRIUM             = 14065;
const int POWER_SWARMCRYSTALS               = 14066;
const int POWER_ENERGYPUSH_COLD             = 14067;
const int POWER_ENERGYPUSH_ELEC             = 14068;
const int POWER_ENERGYPUSH_FIRE             = 14069;
const int POWER_ENERGYPUSH_SONIC            = 14070;
const int POWER_LOCK                        = 14071;
const int POWER_ENERGYSTUN_COLD             = 14072;
const int POWER_ENERGYSTUN_ELEC             = 14073;
const int POWER_ENERGYSTUN_FIRE             = 14074;
const int POWER_ENERGYSTUN_SONIC            = 14075;
const int POWER_IDENTIFY                    = 14076;
const int POWER_IDINSINUATION               = 14077;
const int POWER_INFLICTPAIN                 = 14078;
const int POWER_KNOCK                       = 14079;
const int POWER_MINDDISRUPT                 = 14080;
const int POWER_RECALLAGONY                 = 14081;
const int POWER_THOUGHTSHIELD               = 14082;
const int POWER_DISSOLVEWEAP                = 14083;
const int POWER_SHAREPAIN                   = 14084;
const int POWER_CONTROLAIR                  = 14085;
const int POWER_CONTROLSOUND                = 14086;
const int POWER_REPAIRDAMAGE                = 14087;
const int POWER_AVERSION                    = 14088;

// Level 3 Powers
const int POWER_BODYADJUST                  = 14101;
const int POWER_GREATAMORPHA                = 14102;
const int POWER_DARKVISION                  = 14103;
const int POWER_PSIBLAST                    = 14104;
const int POWER_DANGERSENSE                 = 14105;
const int POWER_ENERGYBOLT_COLD             = 14106;
const int POWER_ENERGYBOLT_ELEC             = 14107;
const int POWER_ENERGYBOLT_FIRE             = 14108;
const int POWER_ENERGYBOLT_SONIC            = 14109;
const int POWER_ENERGYBURST_COLD            = 14110;
const int POWER_ENERGYBURST_ELEC            = 14111;
const int POWER_ENERGYBURST_FIRE            = 14112;
const int POWER_ENERGYBURST_SONIC           = 14113;
const int POWER_ENERGYRETORT_COLD           = 14114;
const int POWER_ENERGYRETORT_ELEC           = 14115;
const int POWER_ENERGYRETORT_FIRE           = 14116;
const int POWER_ENERGYRETORT_SONIC          = 14117;
const int POWER_EXHALEBLACKDRAG             = 14118;
const int POWER_ERADICATEINVIS              = 14119;
const int POWER_SHAREPAINFORCED             = 14120;
const int POWER_KEENEDGE                    = 14121;
const int POWER_MENTALBARRIER               = 14122;
const int POWER_MINDTRAP                    = 14123;
const int POWER_TOUCHSIGHT                  = 14124;
const int POWER_BODYPURIFICATION            = 14125;
const int POWER_DISPELPSIONICS              = 14126;
const int POWER_ENERGYWALL_COLD             = 14127;
const int POWER_ENERGYWALL_ELEC             = 14128;
const int POWER_ENERGYWALL_FIRE             = 14129;
const int POWER_ENERGYWALL_SONIC            = 14130;
const int POWER_HUSTLE                      = 14131;
const int POWER_TIMEHOP                     = 14132;
const int POWER_UBIQVISION                  = 14133;
const int POWER_ECTOCOCOON                  = 14134;
const int POWER_CRISISBREATH                = 14135;
const int POWER_EMPATHICTRANSFERHOSTILE     = 14136;


// Level 4 Powers
const int POWER_INERTBARRIER                = 14151;
const int POWER_STEADFASTPERCEP             = 14152;
const int POWER_EMPATHICFEEDBACK            = 14154;
const int POWER_ENERGYADAPTION              = 14155;
const int POWER_FREEDOM                     = 14156;
const int POWER_MINDWIPE                    = 14157;
const int POWER_POWERLEECH                  = 14158;
const int POWER_PSYCHICREFORMATION          = 14159;
const int POWER_TELEKINETICMANEUVER         = 14160;
const int POWER_DIMENSIONALANCHOR           = 14161;
const int POWER_DISMISSAL                   = 14162;
const int POWER_DIMENSIONDOOR_SELFONLY      = 14163;
const int POWER_DIMENSIONDOOR_PARTY         = 14164;
const int POWER_DIMENSIONDOOR_SELFONLY_DIRDIST  = 14167;
const int POWER_DIMENSIONDOOR_PARTY_DIRDIST     = 14168;
const int POWER_DOMINATE                    = 14165;
const int POWER_FATELINK                    = 14166;

// Level 5 Powers
const int POWER_BALEFULTEL                  = 14191;
const int POWER_ECTOSHAMBLER                = 14192;
const int POWER_POWERRESISTANCE             = 14193;
const int POWER_PSYCHICCRUSH                = 14194;
const int POWER_TOWERIRONWILL               = 14195;
const int POWER_TRUESEEING                  = 14196;
const int POWER_CATAPSI                     = 14197;
const int POWER_SHATTERMINDBLANK            = 14198;
const int POWER_HAILCRYSTALS                = 14199;
const int POWER_SECONDCHANCE                = 14200;

// Level 6 Powers
const int POWER_BREATHBLACKDRAGON           = 14231;
const int POWER_DISINTEGRATE                = 14232;
const int POWER_CRYSTALLIZE                 = 14233;
const int POWER_FUSEFLESH                   = 14234;
const int POWER_RETRIEVE                    = 14235;
const int POWER_TEMPORALACCELERATION        = 14236;
const int POWER_BANISHMENT                  = 14237;
const int POWER_GREATERPRECOGNITION         = 14238;

// Level 7 Powers
const int POWER_CRISISLIFE                  = 14271;
const int POWER_DECEREBRATE                 = 14272;
const int POWER_ENERGYWAVE_COLD             = 14273;
const int POWER_ENERGYWAVE_ELEC             = 14274;
const int POWER_ENERGYWAVE_FIRE             = 14275;
const int POWER_ENERGYWAVE_SONIC            = 14276;
const int POWER_INSANITY                    = 14277;
const int POWER_MINDBLANKPERSONAL           = 14278;
const int POWER_OAKBODY                     = 14279;
const int POWER_ULTRABLAST                  = 14280;
const int POWER_EVADEBURST                  = 14281;
const int POWER_MOMENTOFPRESCIENCEATTACK    = 14282;
const int POWER_MOMENTOFPRESCIENCEARMOUR    = 14283;
const int POWER_MOMENTOFPRESCIENCESAVES     = 14284;
const int POWER_MOMENTOFPRESCIENCESKILLS    = 14285;
const int POWER_ECTOCOCOONMASS              = 14286;
const int POWER_ETHEREALJAUNT               = 14287;

// Level 8 Powers
const int POWER_RECALLDEATH                 = 14301;
const int POWER_IRONBODY                    = 14302;
const int POWER_PSIMINDBLANK                = 14303;
const int POWER_TRUEMETABOLISM              = 14304;
const int POWER_SHADOWBODY                  = 14305;
const int POWER_ASTRALSEED                  = 14306;
const int POWER_TIMEHOPMASS                 = 14307;
const int POWER_HYPERCOGNITION              = 14308;

// Level 9 Powers
const int POWER_ASSIMILATE                  = 14331;
const int POWER_ETHEREALNESS                = 14332;
const int POWER_MICROCOSM                   = 14333;
const int POWER_TIMELESSBODY                = 14334;
const int POWER_GENESIS                     = 14335;
const int POWER_PSYCHICCHIR                 = 14336;