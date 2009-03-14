#include "prc_sp_func"
#include "prc_alterations"

void main()
{
    	int nEvent = GetRunningEvent();
    	if(DEBUG) DoDebug("prc_jpn running, event: " + IntToString(nEvent));
	object oInitiator = OBJECT_SELF;
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	if (GetWeaponRanged(oItem))
	{
		FloatingTextStringOnCreature("You must use a melee weapon for this ability", oInitiator, FALSE);
		return;
	} // Has to be a melee weapon
	int nSpellId = GetLocalInt(oInitiator, "JPM_SPELL_CURRENT");
	int nRealSpellId     = (UseNewSpellBook(oInitiator)) ? GetLocalInt(oInitiator, "JPM_REAL_SPELL_CURRENT") : nSpellId;
	// We aren't being called from any event, perform setup
    	if(nEvent == FALSE)
    	{
		if(DEBUG) DoDebug("PRCGetSpellUsesLeft: " + IntToString(PRCGetSpellUsesLeft(nSpellId, oInitiator)));
		if(PRCGetSpellUsesLeft(nRealSpellId, oInitiator) >= 1)
		{
			if(PRCGetSpellLevel(oInitiator, nRealSpellId) >= 6)
			{
				FloatingTextStringOnCreature("You can only use Quickening Strike with level 5 or lower spells.", oInitiator, FALSE);
				return;
			}
			if(GetLocalInt(oInitiator, "JPM_Quickening_Strike_Expended"))
			{
				FloatingTextStringOnCreature("*Quickening Strike Already Expended*", oInitiator, FALSE);
				return;
			}
			// Expend class ability
			SetLocalInt(oInitiator, "JPM_Quickening_Strike_Expended", TRUE);
			FloatingTextStringOnCreature("* Quickening Strike Expended *", oInitiator, FALSE);

			SetLocalInt(oInitiator, "QuickeningStrike", nSpellId);
		}
		else
		{
			FloatingTextStringOnCreature("You have no more uses of the chosen spell", oInitiator, FALSE);
			return;
		}

        	if(DEBUG) DoDebug("prc_jpm_qckstr: set. nSpellId = " + IntToString(GetLocalInt(oInitiator, "QuickeningStrike")));

		// The OnHit
		IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
		AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_jpm_qukstr", TRUE, FALSE);
	}
    	// We're being called from the OnHit eventhook, so deal the damage
    	else if(nEvent == EVENT_ITEM_ONHIT)
    	{

        	oItem = GetSpellCastItem();
        	if (GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
        	{
        		int nCast = GetLocalInt(oInitiator, "QuickeningStrike");
        		if(DEBUG) DoDebug("prc_jpm_qckstr: onhit. nSpellId = " + IntToString(GetLocalInt(oInitiator, "QuickeningStrike")));

			// Need not expend the spell beforehand because ActionCastSpell() does it for us
			//It would appear this only happens for newspellbook users, therefore:
			if(!UseNewSpellBook(oInitiator)) PRCDecrementRemainingSpellUses(oInitiator, nCast);
        		ActionCastSpell(nCast,0, 0, 0,METAMAGIC_QUICKEN);
			// Cleaning
			RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
			DeleteLocalInt(oInitiator, "QuickeningStrike");
			RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_jpm_qukstr", TRUE, FALSE);
		}
	}
}