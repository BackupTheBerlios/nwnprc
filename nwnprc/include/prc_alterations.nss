//
//	This is the original include file for the PRC Spell Engine.
//
//	Various spells, components and designs within this system have
//	been contributed by many individuals within and without the PRC.
//

// Generic includes
#include "x2_inc_switches"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

// PRC Spell Engine Utility Functions
#include "lookup_2da_spell"
#include "prcsp_reputation"
#include "prcsp_archmaginc"
#include "prcsp_spell_adjs"
#include "prcsp_engine"

//function prototypes
int MyPRCGetRacialType(object oTarget);

// Checks if target is a frenzied Bersker with Deathless Frenzy Active
// If so removes imortality flag so that Death Spell can kill them
void DeathlessFrenzyCheck(object oTarget);

const int SAVING_THROW_NONE = 4;

int MyPRCGetRacialType(object oCreature)
{
    if (GetLevelByClass(CLASS_TYPE_LICH,oCreature) >= 4)
        return RACIAL_TYPE_UNDEAD;
    if (GetLevelByClass(CLASS_TYPE_MONK,oCreature) >= 20)
        return RACIAL_TYPE_OUTSIDER;
    if (GetLevelByClass(CLASS_TYPE_OOZEMASTER,oCreature) >= 10)
        return RACIAL_TYPE_OOZE;
    if (GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE,oCreature) >= 10)
        return RACIAL_TYPE_DRAGON;
    if (GetLevelByClass(CLASS_TYPE_ACOLYTE,oCreature) >= 10)
        return RACIAL_TYPE_OUTSIDER;
    if (GetLevelByClass(CLASS_TYPE_ES_FIRE,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_ES_COLD,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_ES_ELEC,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_ES_ACID,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_HEARTWARDER,oCreature) >= 10)
        return RACIAL_TYPE_FEY;
    if (GetLevelByClass(CLASS_TYPE_WEREWOLF,oCreature) >= 10)
        return RACIAL_TYPE_SHAPECHANGER;

    //race pack racial types
    if(GetHasFeat(FEAT_DWARVEN, oCreature))
        return RACIAL_TYPE_DWARF;
    if(GetHasFeat(FEAT_ELVEN, oCreature))
        return RACIAL_TYPE_ELF;
    if(GetHasFeat(FEAT_GNOMISH, oCreature))
        return RACIAL_TYPE_GNOME;
    if(GetHasFeat(FEAT_HALFLING, oCreature))
        return RACIAL_TYPE_HALFLING;
    if(GetHasFeat(FEAT_ORCISH, oCreature))
        return RACIAL_TYPE_HUMANOID_ORC;
    if(GetHasFeat(FEAT_HUMAN, oCreature))
        return RACIAL_TYPE_HUMAN;
    if(GetHasFeat(FEAT_GOBLINOID, oCreature))
        return RACIAL_TYPE_HUMANOID_GOBLINOID;
    if(GetHasFeat(FEAT_REPTILIAN, oCreature))
        return RACIAL_TYPE_HUMANOID_REPTILIAN;
    if(GetHasFeat(FEAT_MONSTEROUS, oCreature))
        return RACIAL_TYPE_HUMANOID_MONSTROUS;
    if(GetHasFeat(FEAT_ELEMENTAL, oCreature))
        return RACIAL_TYPE_ELEMENTAL;
    if(GetHasFeat(FEAT_GIANT, oCreature))
        return RACIAL_TYPE_GIANT;
    if(GetHasFeat(FEAT_FEY, oCreature))
        return RACIAL_TYPE_FEY;
    if(GetHasFeat(FEAT_ABERRATION, oCreature))
        return RACIAL_TYPE_ABERRATION;
    if(GetHasFeat(FEAT_OUTSIDER, oCreature))
        return RACIAL_TYPE_OUTSIDER;

    // check for a local variable that overrides the race
    // the shifter will use this everytime they change
    // the racial types are zero based, use 1 based to ensure the variable is set
    int nRace = GetLocalInt(oCreature,"RACIAL_TYPE");
    if (nRace)
        return (nRace-1);

    return MyPRCGetRacialType(oCreature);
}


// Added by Oni5115
void DeathlessFrenzyCheck(object oTarget)
{
     if(GetHasFeat(FEAT_DEATHLESS_FRENZY, oTarget) && GetHasFeatEffect(FEAT_FRENZY, oTarget) )
     {
          SetImmortal(oTarget, FALSE);
     }
}
