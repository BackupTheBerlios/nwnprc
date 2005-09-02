//::///////////////////////////////////////////////
//:: Combat Manifestation evaluationscript
//:: psi_combat_manif
//::///////////////////////////////////////////////
/*
    Adds a +4 bonus to concentration. This is not
    quite correct, since the bonus should only apply
    when manifesting defensively.
*/
//:://////////////////////////////////////////////
//:: Modified By: Ornedan
//:: Modified On: 23.03.2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"

void main()
{
    object oPC = OBJECT_SELF;

    if(GetHasFeat(FEAT_COMBAT_MANIFESTATION, oPC))
    {
        object oSkin = GetPCSkin(oPC);
        SetCompositeBonus(oSkin, "Combat_Mani", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_CONCENTRATION);
    }
}