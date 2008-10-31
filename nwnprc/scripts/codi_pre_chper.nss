//::///////////////////////////////////////////////
//:: codi_pre_chper
//:://////////////////////////////////////////////
/*
     Ocular Adept - Charm Person
*/
//:://////////////////////////////////////////////
//:: Created By: James Stoneburner
//:: Created On: 2003-11-29
//:://////////////////////////////////////////////
#include "prc_inc_sp_tch"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_OCULAR);
    if (DEBUG) FloatingTextStringOnCreature("Your Ocular Adept class level is: " + IntToString(nLevel), OBJECT_SELF);
    int nDC = 10 + (nLevel/2) + GetAbilityModifier(ABILITY_CHARISMA);
    if (DEBUG) FloatingTextStringOnCreature("Your Ocular Adept DC is: " + IntToString(nDC), OBJECT_SELF);
    DoSpellRay(SPELL_CHARM_PERSON, nLevel, nDC);
}
