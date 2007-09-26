#include "x2_inc_itemprop"

void main()
{
    object oCaster = OBJECT_SELF;
    SetLocalInt(oCaster, "ShadowMindStab", TRUE);
    FloatingTextStringOnCreature("Mind Stab Activated", oCaster, FALSE);
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
    IPSafeAddItemProperty(oWeapon, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    // Clean up
    DelayCommand(6.0, DeleteLocalInt(oCaster, "ShadowMindStab"));
    DelayCommand(6.0, FloatingTextStringOnCreature("Mind Stab Deactivated", oCaster, FALSE));
}