//::///////////////////////////////////////////////
//:: Ironmind
//:: psi_ironmind.nss
//:://////////////////////////////////////////////
//:: Applies the passive bonuses from Ironmind
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Dec 15, 2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_onhit"

void IronMind_DR(object oPC, object oSkin, int nLevel)
{
    if(GetLocalInt(oSkin, "IronMind_DR") == TRUE) return;
    
    int nDR;
    if (nLevel >= 9) nDR = IP_CONST_DAMAGERESIST_3;
    else if (nLevel >= 6) nDR = IP_CONST_DAMAGERESIST_2;
    else { nDR = IP_CONST_DAMAGERESIST_1; }

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PIERCING, nDR), oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SLASHING, nDR), oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_BLUDGEONING, nDR), oSkin);
    SetLocalInt(oSkin, "IronMind_DR", TRUE);
}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nIron = GetLevelByClass(CLASS_TYPE_IRONMIND, oPC);
    object oWeap = GetItemLastEquipped();
    object oUnequip = GetItemLastUnequipped();
    int iEquip = GetLocalInt(oPC, "ONEQUIP");
    

    if(nIron >= 2) IronMind_DR(oPC, oSkin, nIron);
}
