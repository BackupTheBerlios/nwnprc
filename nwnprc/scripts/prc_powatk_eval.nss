//::///////////////////////////////////////////////
//:: Power Attack evaluation script
//:: prc_powatk_eval
//::///////////////////////////////////////////////
/** @file
    Ran from EvalPRCFeats(). Checks if the creature
    has Power Attack and gives them the PRC Power
    Attack feats to skin if they do.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_switch"
#include "prc_feat_const"
#include "prc_ipfeat_const"
#include "inc_item_props"

void main()
{
    object oPC = OBJECT_SELF;

    if(GetPRCSwitch(PRC_POWER_ATTACK) == PRC_POWER_ATTACK_DISABLED)
        return;

    if(GetHasFeat(FEAT_POWER_ATTACK) && !GetHasFeat(FEAT_POWER_ATTACK_QUICKS_RADIAL))
    {
        object oSkin = GetPCSkin(oPC);

        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_POWER_ATTACK_SINGLE_RADIAL),     oSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_POWER_ATTACK_FIVES_RADIAL),      oSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_PRC_POWER_ATTACK_QUICKS_RADIAL), oSkin);
    }
}