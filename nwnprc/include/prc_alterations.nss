//
//   This is the original include file for the PRC Spell Engine.
//
//   Various spells, components and designs within this system have
//   been contributed by many individuals within and without the PRC.
//

// Generic includes
#include "x2_inc_switches"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "prc_racial_const"

// PRC Spell Engine Utility Functions
#include "lookup_2da_spell"
#include "prcsp_reputation"
#include "prcsp_archmaginc"
#include "prcsp_spell_adjs"
#include "prcsp_engine"
#include "prc_inc_racial"


// Checks if target is a frenzied Bersker with Deathless Frenzy Active
// If so removes imortality flag so that Death Spell can kill them
void DeathlessFrenzyCheck(object oTarget);

const int SAVING_THROW_NONE = 4;

// Added by Oni5115
void DeathlessFrenzyCheck(object oTarget)
{
     if(GetHasFeat(FEAT_DEATHLESS_FRENZY, oTarget) && GetHasFeatEffect(FEAT_FRENZY, oTarget) )
     {
          SetImmortal(oTarget, FALSE);
     }
}


// Added by Primogenitor
// part of the replacement for GetClassByPosition and GetLevelByPosition
// since those always return CLASS_TYPE_INVALID for non-bioware classes
void SetupPRCGetClassByPosition(object oCreature)
{
    int i;
    int nCounter = 1;
    //set to defaults, including the +1 for 1start not 0 start
    SetLocalInt(oCreature, "PRC_ClassInPos1", CLASS_TYPE_INVALID+1);
    SetLocalInt(oCreature, "PRC_ClassInPos2", CLASS_TYPE_INVALID+1);
    SetLocalInt(oCreature, "PRC_ClassInPos3", CLASS_TYPE_INVALID+1);
    SetLocalInt(oCreature, "PRC_ClassLevelInPos1", 0+1);
    SetLocalInt(oCreature, "PRC_ClassLevelInPos2", 0+1);
    SetLocalInt(oCreature, "PRC_ClassLevelInPos3", 0+1);
    for(i=0;i<256;i++)
    {
        if(GetLevelByClass(i, oCreature))
        {
            // set to values, including the +1 for 1start not 0 start
            SetLocalInt(oCreature, "PRC_ClassInPos"+IntToString(nCounter), i+1);
            SetLocalInt(oCreature, "PRC_ClassLevelInPos"+IntToString(nCounter),
                GetLevelByClass(i, oCreature)+1);
            nCounter++;
            if(nCounter >= 4)
                i = 999; // end loop now
        }
    }
}

// Added by Primogenitor
// replacement for GetClassByPosition since that always returns
// CLASS_TYPE_INVALID for non-bioware classes
//
// A creature can have up to three classes.  This function determines the
// creature's class (CLASS_TYPE_*) based on nClassPosition.
// - nClassPosition: 1, 2 or 3
// - oCreature
// * Returns CLASS_TYPE_INVALID if the oCreature does not have a class in
//   nClassPosition (i.e. a single-class creature will only have a value in
//   nClassLocation=1) or if oCreature is not a valid creature.
int PRCGetClassByPosition(int nClassPosition, object oCreature=OBJECT_SELF)
{
    if(!GetIsObjectValid(oCreature) || GetObjectType(oCreature) != OBJECT_TYPE_CREATURE)
        return CLASS_TYPE_INVALID;
    int nClass = GetLocalInt(oCreature, "PRC_ClassInPos"+IntToString(nClassPosition));
    if(nClass == 0)
    {
        SetupPRCGetClassByPosition(oCreature);
        nClass = GetLocalInt(oCreature, "PRC_ClassInPos"+IntToString(nClassPosition));
    }
    //correct for 1 start not 0 start
    nClass--;
    return nClass;
}

// Added by Primogenitor
// replacement for GetLevelByPosition since GetClassByPosition always returns
// CLASS_TYPE_INVALID for non-bioware classes, so the PRC order may not be the
// same as the bioware order for the classes
//
// A creature can have up to three classes.  This function determines the
// creature's class level based on nClass Position.
// - nClassPosition: 1, 2 or 3
// - oCreature
// * Returns 0 if oCreature does not have a class in nClassPosition
//   (i.e. a single-class creature will only have a value in nClassLocation=1)
//   or if oCreature is not a valid creature.
int PRCGetLevelByPosition(int nClassPosition, object oCreature=OBJECT_SELF)
{
    if(!GetIsObjectValid(oCreature) || GetObjectType(oCreature) != OBJECT_TYPE_CREATURE)
        return 0;
    int nClass = GetLocalInt(oCreature, "PRC_ClassLevelInPos"+IntToString(nClassPosition));
    if(nClass == 0)
    {
        SetupPRCGetClassByPosition(oCreature);
        nClass = GetLocalInt(oCreature, "PRC_ClassLevelInPos"+IntToString(nClassPosition));
    }
    //correct for 1 start not 0 start
    nClass--;
    return nClass;
}