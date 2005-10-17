//::///////////////////////////////////////////////
//:: codi_pre_infw
//:://////////////////////////////////////////////
/*

    Ocular Adept - Inflict Moderate Wounds

*/
//:://////////////////////////////////////////////
//:: Created By: James Stoneburner
//:: Created On: 2003-11-30
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_OCULAR);
    int nDC = 10 + (nLevel/2) + GetAbilityModifier(ABILITY_CHARISMA);
    DoSpellRay(SPELL_INFLICT_MODERATE_WOUNDS, nLevel, nDC);
}