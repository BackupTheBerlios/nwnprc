//:://////////////////////////////////////////////
//:: FileName: "ss_ep_transvital"
/*   Purpose: Transcendent Vitality - the target permanently gains 5 CON,
        immunity to poisons and disease, and regeneration.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 13, 2004
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_epicspells"

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, TRANVIT_DC, TRANVIT_S, TRANVIT_XP))
    {
        object oTarget = GetSpellTargetObject();
        EnsurePCHasSkin(oTarget);
        object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
        itemproperty ipCON = ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 5);
        itemproperty ipDis = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE);
        itemproperty ipPoi = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);
        itemproperty ipReg = ItemPropertyRegeneration(1);

        IPSafeAddItemProperty(oSkin, ipCON, 0.0f,
            X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE);
        IPSafeAddItemProperty(oSkin, ipDis, 0.0f,
            X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE);
        IPSafeAddItemProperty(oSkin, ipPoi, 0.0f,
            X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE);
        IPSafeAddItemProperty(oSkin, ipReg, 0.0f,
            X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE);
    }
}

