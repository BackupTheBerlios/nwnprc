//::///////////////////////////////////////////////
//:: codi_nwscript
//:: Central nwscript include file
//:://////////////////////////////////////////////
/*
    This file should be the EXACT SAME for ALL CODI
    releases.

    Version 1.1 - 12-31-2003
    -Added all of the prcs, to get everything in line
    -Added all racial constants

*/
//:://////////////////////////////////////////////
//:: Created By: James Stoneburner
//:: Created On: 2003-11-30
//:://////////////////////////////////////////////

const int SPELLABILITY_NS_MEDIUM                 = 1500;
const int SPELLABILITY_NS_SMALL                  = 1501;
const int SPELLABILITY_NS_DWARF                  = 1502;
const int SPELLABILITY_NS_ELF                    = 1503;
const int SPELLABILITY_NS_HALF_ELF               = 1504;
const int SPELLABILITY_NS_HALF_ORC               = 1505;
const int SPELLABILITY_NS_HUMAN                  = 1506;
const int SPELLABILITY_NS_GNOME                  = 1507;
const int SPELLABILITY_NS_HALFLING               = 1508;
const int SPELLABILITY_NS_OFF                    = 1509;

const int SPELLABILITY_OA_CHPERRAY               = 1510;
const int SPELLABILITY_OA_SLEEPRAY               = 1511;
const int SPELLABILITY_OA_INFRAY                 = 1512;
const int SPELLABILITY_OA_SLOWRAY                = 1513;
const int SPELLABILITY_OA_FEARRAY                = 1514;
const int SPELLABILITY_OA_CHMONRAY               = 1515;
const int SPELLABILITY_OA_TELERAY                = 1516;
const int SPELLABILITY_OA_PETRAY                 = 1517;
const int SPELLABILITY_OA_DISRAY                 = 1518;
const int SPELLABILITY_OA_DEATHRAY               = 1519;

const int SPELLABILITY_SM_ANCESTDAISHO           = 1520;

const int SPELLABILITY_WP_RALLY                  = 1521;
const int SPELLABILITY_WP_INFLAME                = 1522;
const int SPELLABILITY_WP_IMPLACABLE_FOE         = 1523;

const int SPELL_BLUR                             = 1600;
const int SPELL_FAERIE_FIRE                      = 1601;

const int FEAT_1000FACES_MEDIUM                  = 3000;
const int FEAT_1000FACES_SMALL                   = 3001;
const int FEAT_1000FACES_OFF                     = 3002;

const int FEAT_CHPERRAY                          = 3003;
const int FEAT_SLEEPRAY                          = 3004;
const int FEAT_INFRAY                            = 3005;
const int FEAT_SLOWRAY                           = 3006;
const int FEAT_FEARRAY                           = 3007;
const int FEAT_CHMONRAY                          = 3008;
const int FEAT_TELERAY                           = 3009;
const int FEAT_PETRAY                            = 3010;
const int FEAT_DISRAY                            = 3011;
const int FEAT_DEATHRAY                          = 3012;

const int FEAT_BATTLE_RAGE1                      = 3013;
const int FEAT_BATTLE_RAGE2                      = 3014;
const int FEAT_BATTLE_RAGE3                      = 3015;

const int FEAT_ANCESTRAL_DAISHO                  = 3017;

const int FEAT_RALLY                             = 3018;
const int FEAT_INFLAME                           = 3019;
const int FEAT_IMPLACABLE_FOE                    = 3020;
const int FEAT_HEALING_CIRCLE                    = 3021;
const int FEAT_FEAR_AURA                         = 3022;
const int FEAT_MASS_HASTE                        = 3023;
const int FEAT_MASS_HEAL                         = 3024;

const int FEAT_EPIC_SAMURAI                      = 3016;
const int FEAT_EPIC_OCULAR                       = 3025;
const int FEAT_EPIC_NINJA                        = 3026;
const int FEAT_EPIC_THEURGE                      = 3027;
const int FEAT_EPIC_WARPRIEST                    = 3028;

const int CLASS_TYPE_OCULAR                      = 51;
const int CLASS_TYPE_BATTLERAGER                 = 52;
const int CLASS_TYPE_MYSTIC_THEURGE              = 53;
const int CLASS_TYPE_NINJA_SPY                   = 54;
const int CLASS_TYPE_SAMURAI                     = 55;
const int CLASS_TYPE_WARPRIEST                   = 56;

const int RACIAL_TYPE_TIEFLING                   = 51;
const int RACIAL_TYPE_DROW                       = 52;
const int RACIAL_TYPE_GNOLL                      = 53;
const int RACIAL_TYPE_KOBOLD                     = 54;
const int RACIAL_TYPE_SUNELF                     = 55;
const int RACIAL_TYPE_GOLDDWARF                  = 56;
const int RACIAL_TYPE_WOODELF                    = 57;
const int RACIAL_TYPE_DEEPGNOME                  = 58;
const int RACIAL_TYPE_HALFDROW                   = 59;
const int RACIAL_TYPE_GHOSTWISEHALFLING          = 60;
const int RACIAL_TYPE_STRONGHEARTHALFLING        = 61;
const int RACIAL_TYPE_AASIMAR                    = 62;
const int RACIAL_TYPE_DUERGAR                    = 63;
const int RACIAL_TYPE_WILDELF                    = 64;


