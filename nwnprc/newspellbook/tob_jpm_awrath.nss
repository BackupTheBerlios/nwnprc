#include "prc_sp_func"
#include "prc_alterations"
#include "inc_addragebonus"

void main()
{
	int nLevel;
    	int nEvent          = GetRunningEvent();
    	if(DEBUG) DoDebug("prc_jpm_awrath running, event: " + IntToString(nEvent));
	object oInitiator   = OBJECT_SELF;
	object oItem        = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator); 
	if (GetWeaponRanged(oItem))
	{
		FloatingTextStringOnCreature("You must use a melee weapon for this ability", oInitiator, FALSE);
		return;
	} // Has to be a melee weapon
	int nSpellId 	     = GetLocalInt(oInitiator, "JPM_SPELL_CURRENT");
	int nRealSpellId     = (UseNewSpellBook(oInitiator)) ? GetLocalInt(oInitiator, "JPM_REAL_SPELL_CURRENT") : nSpellId;
	// We aren't being called from any event, perform setup
    	if(nEvent == FALSE)
    	{
		if(PRCGetSpellUsesLeft(nRealSpellId, oInitiator) < 1)
		{
			FloatingTextStringOnCreature("You have no more uses of the chosen spell", oInitiator, FALSE);
			return;
		}
		// if we'rehere, they can cast
		if(UseNewSpellBook(oInitiator))
		{
			int nClass  = GetFirstArcaneClass(oInitiator);
			    nLevel  = GetSpellLevel(oInitiator , nSpellId, nClass);
			if(DEBUG) DoDebug("RemoveSpellUse nSpellId: " + IntToString(nSpellId) + " class: " + IntToString(nClass));
			RemoveSpellUse(oInitiator, nSpellId, nClass);
			SetLocalInt(oInitiator, "ArcaneWrath", nLevel);
		}
		else
		{
			nLevel = PRCGetSpellLevel(oInitiator, nSpellId);
			if(DEBUG) DoDebug("nSpellId: " + IntToString(nSpellId));
			if(DEBUG) DoDebug("Spell Level from PRCGetSpellLevel: " + IntToString(nLevel));
			PRCDecrementRemainingSpellUses(oInitiator, nSpellId);			
			SetLocalInt(oInitiator, "ArcaneWrath", nLevel);
			if(DEBUG) DoDebug("ArcaneWrath local Int: " + IntToString(GetLocalInt(oInitiator, "ArcaneWrath")));
			
		}
		
		// Attack bonus for one round
		effect eAtk = EffectAttackIncrease(4);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAtk, oInitiator, 6.0);
		
		// The OnHit
		IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
		AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_jpm_awrath", TRUE, FALSE);
	}
    	// We're being called from the OnHit eventhook, so deal the damage    
    	else if(nEvent == EVENT_ITEM_ONHIT)
    	{
        	oItem = GetSpellCastItem();
        	if (GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
        	{
        		object oTarget = PRCGetSpellTargetObject();
        		int nDamageType = GetDamageTypeOfWeapon(INVENTORY_SLOT_RIGHTHAND, oInitiator);
			effect eDam = EffectDamage(d10(GetLocalInt(oInitiator, "ArcaneWrath")), nDamageType);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			
			// Cleaning
			RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
			DeleteLocalInt(oInitiator, "ArcaneWrath");
			RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_jpm_awrath", TRUE, FALSE);
			PRCRemoveEffectsFromSpell(oInitiator, JPM_SPELL_ARCANE_WRATH);
		}
	}
}