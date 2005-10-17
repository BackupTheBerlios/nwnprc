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
#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_OCULAR);
    int nDC = 10 + (nLevel/2) + GetAbilityModifier(ABILITY_CHARISMA);
    DoSpellRay(SPELL_CHARM_PERSON, nLevel, nDC);
}
