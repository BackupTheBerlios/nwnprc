//::///////////////////////////////////////////////
//:: Wounding Attack - Ranged spellscript
//:: psi_wound_atk_r
//::///////////////////////////////////////////////
/*
    Performs an attack round with 1 Con damage
    on the first attack.
    Requires that the user is wielding a ranged
    weapon.
    
    Using Wounding Attack requires expending
    psionic focus.
*/
//:://////////////////////////////////////////////
//:: Modified By: Ornedan
//:: Modified On: 23.03.2005
//:://////////////////////////////////////////////

#include "prc_inc_function"
#include "inc_item_props"
#include "prc_feat_const"
#include "prc_inc_combat"
#include "psi_inc_psifunc"


void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, 1);

    if(!UsePsionicFocus(oPC)){
        SendMessageToPC(oPC, "You must be psionically focused to use this feat");
        return;
    }

    if(!GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)))
    {
        SendMessageToPC(oPC, "You must be wielding a ranged weapon while using this feat");
        return;
    }

    PerformAttackRound(oTarget, oPC, eCon, 0.0, 0, 0, 0, FALSE, "Wounding Attack Hit", "Wounding Attack Miss");
}