#include "prc_inc_function"
#include "inc_item_props"
#include "prc_feat_const"
#include "prc_inc_combat"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oTarget  = GetSpellTargetObject();
    effect eDummy;

    if (GetLocalInt(oSkin, "PsionicFocus") == 0)
    {
        SendMessageToPC(oPC, "You must be psionically focused to use this feat");
        return;
    }
    
    if ((GetItemInSlot(INVENTORY_SLOT_RIGHTHAND) == OBJECT_INVALID) || (!GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND))))
    {
        SendMessageToPC(oPC, "You must be wielding a ranged weapon to use this feat");
        return;
    }
    
    PerformAttackRound(oTarget, oPC, eDummy, 0.0, 0, d6(4), DAMAGE_TYPE_MAGICAL, FALSE, "Greater Psionic Shot Hit", "Greater Psionic Shot Miss");
    
    SetLocalInt(oSkin, "PsionicFocus", 0);
}