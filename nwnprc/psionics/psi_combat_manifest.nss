#include "prc_inc_function"
#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    if(GetHasFeat(FEAT_COMBAT_MANIFESTATION))
    {
        SetCompositeBonus(oSkin, "Combat_Mani", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_CONCENTRATION);
    }
}