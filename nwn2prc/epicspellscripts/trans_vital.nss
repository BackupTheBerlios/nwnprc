#include "prc_alterations"

void main()
{
        //Declare major variables
        object oTarget = OBJECT_SELF;
        object oSkin;
        oSkin = GetPCSkin(oTarget);
        //itemproperty ipCON = ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 5);
        itemproperty ipDis = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE);
        itemproperty ipPoi = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);
        //itemproperty ipReg = ItemPropertyRegeneration(1);

        //IPSafeAddItemProperty(oSkin, ipCON, 0.0f,
        //    X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE);
        IPSafeAddItemProperty(oSkin, ipDis, 0.0f,
            X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE);
        IPSafeAddItemProperty(oSkin, ipPoi, 0.0f,
            X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE);
        //IPSafeAddItemProperty(oSkin, ipReg, 0.0f,
        //    X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE);
        SetCompositeBonus(oSkin, "TransVitalCon", 5, ITEM_PROPERTY_ABILITY_BONUS, ABILITY_CONSTITUTION);
        SetCompositeBonus(oSkin, "TransVitalRegen", 1, ITEM_PROPERTY_REGENERATION);
}

