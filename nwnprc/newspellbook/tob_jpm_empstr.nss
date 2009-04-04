#include "prc_sp_func"
#include "prc_alterations"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_jpm_empstr running, event: " + IntToString(nEvent));
    object oInitiator = OBJECT_SELF;
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
    if (GetWeaponRanged(oItem))
    {
        FloatingTextStringOnCreature("You must use a melee weapon for this ability", oInitiator, FALSE);
        return;
    } // Has to be a melee weapon
    // We aren't being called from any event, perform setup
        if(nEvent == FALSE)
        {
            if(!TakeSwiftAction(oInitiator)) return;
            if(GetLocalInt(oInitiator, "JPM_Empowering_Strike_Expended"))
            {
                FloatingTextStringOnCreature("*Empowering Strike Already Expended*", oInitiator, FALSE);
                return;
            }

                if(DEBUG) DoDebug("prc_jpm_empstr: SuddenMetaEmpower: " + IntToString(GetLocalInt(oInitiator, "SuddenMetaEmpower")));

            SetLocalInt(oInitiator, "JPM_Empowering_Strike_Expended", TRUE);
            FloatingTextStringOnCreature("* Empowering Strike Expended *", oInitiator, FALSE);

            // The OnHit
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_jpm_empstr", TRUE, FALSE);
        }
        else if(nEvent == EVENT_ITEM_ONHIT)
        {
            oItem = GetSpellCastItem();
            if (GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
            {
            SetLocalInt(oInitiator, "SuddenMetaEmpower", TRUE);
            FloatingTextStringOnCreature("* Empowering Strike Hit *", oInitiator, FALSE);
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_jpm_empstr", TRUE, FALSE);
        }
    }
}