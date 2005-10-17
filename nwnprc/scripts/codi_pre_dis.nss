//::///////////////////////////////////////////////
//:: codi_pre_dis
//:://////////////////////////////////////////////
/*
     Ocular Adept: Disintegrate
*/
//:://////////////////////////////////////////////
//:: Created By: James Stoneburner
//:: Created On: 2003-11-30
//:: Modified By: Ornedan
//:: Modified On: 30.03.2005
//:: Modfication: Changed to work as the spell Disintegrate
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_OCULAR);
    int nDC = 10 + (nLevel/2) + GetAbilityModifier(ABILITY_CHARISMA);
    DoSpellRay(SPELL_DISINTEGRATE, nLevel, nDC);
}