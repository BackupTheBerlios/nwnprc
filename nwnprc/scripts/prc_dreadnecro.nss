// Dread Necromancer passive abilities.

#include "prc_inc_function"

void DNDamageResist(object oPC, object oSkin, int nLevel)
{
    if(GetLocalInt(oSkin, "DNDamageResist") == TRUE) return;
    
    int nDR;
    if (nLevel >= 15)      nDR = IP_CONST_DAMAGERESIST_8;
    else if (nLevel >= 11) nDR = IP_CONST_DAMAGERESIST_6;
    else if (nLevel >= 7)  nDR = IP_CONST_DAMAGERESIST_4;
    else if (nLevel >= 2)  nDR = IP_CONST_DAMAGERESIST_2;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PIERCING, nDR), oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SLASHING, nDR), oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_BLUDGEONING, nDR), oSkin);
    SetLocalInt(oSkin, "DNDamageResist", TRUE);
}

void main()
{
        //Declare main variables.
        object oPC = OBJECT_SELF;
        object oSkin = GetPCSkin(oPC);
        int nClass = GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oPC);
        
        if(nClass >= 2) DNDamageResist(oPC, oSkin, nClass);
}
