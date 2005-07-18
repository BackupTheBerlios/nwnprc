//::///////////////////////////////////////////////
//:: [Fast Healing Feats]
//:: [prc_bld_arch.nss]
//:://////////////////////////////////////////////
//:: Grants a creature with the fast Healing feats 
//:: the appropriate regeneration.
//:://////////////////////////////////////////////
//:: Created By: Silver
//:: Created On: June 8, 2005
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_feat_const"

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
 
    int epHeal = GetHasFeat(FAST_HEALING_3,oPC) ? 9 :
                 GetHasFeat(FAST_HEALING_2,oPC) ? 6 :
                 GetHasFeat(FAST_HEALING_1,oPC) ? 3 :
                 -1;
 
    SetCompositeBonus(oSkin, "FastHealing", epHeal, ITEM_PROPERTY_REGENERATION);
}