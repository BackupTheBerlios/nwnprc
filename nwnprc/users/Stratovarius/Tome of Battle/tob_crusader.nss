#include "prc_alterations"
#include "tob_inc_tobfunc"

int LevelToDelayedDamage(int nLevel)
{
	int nDelayedDamage = -1;
	
	if (nLevel == 20) nDelayedDamage = 30;
	else if (nLevel >= 16) nDelayedDamage = 25;
	else if (nLevel >= 12) nDelayedDamage = 20;
	else if (nLevel >= 8) nDelayedDamage = 15;
	else if (nLevel >= 4) nDelayedDamage = 10;
	else if (nLevel >= 1) nDelayedDamage = 5;
	
	return nDelayedDamage;
}

void IndomitableSoul(object oPC)
{
        int nSave = GetAbilityModifier(ABILITY_CHARISMA, oPC);
        // Charisma to saves
        effect eFort = ExtraordinaryEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, nSave));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFort, oPC);
        if (DEBUG) DoDebug("Indomitable Soul applied.");
}

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_crusader running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;
        case EVENT_ONHEARTBEAT:         oPC = OBJECT_SELF;               break;

        default:
            oPC = OBJECT_SELF;
    }

    object oItem;
    object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    object oHand   = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int nClass = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);
    int nArmour = GetBaseAC(oArmour);


    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
    	// Saving throw bonus, charisma, does not stack with paladin
    	if (nClass >= 2 && GetLevelByClass(CLASS_TYPE_PALADIN, oPC) == 0)IndomitableSoul(oPC);
        // Hook in the events, needed from level 1 for Steely Resolve
        if(DEBUG) DoDebug("prc_crusader: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_crusader", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_crusader", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONHEARTBEAT,         "prc_crusader", TRUE, FALSE);
    }
    // Damage reduction from Steely Resolve
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("prc_crusader: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Only applies to armours
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
        	// Check current delayed damage pool and max delayed
		int nDelayedPool = GetLocalInt(oPC, "DelayedDamage");
		int nMaxDelayed = LevelToDelayedDamage(nClass);
		
		// If there is space left
		if (nMaxDelayed > nDelayedPool)
		{
			// Amount remaining
			int nRemainingPool = nMaxDelayed - nDelayedPool;
			// Damage dealt
			int nDamageTaken = GetTotalDamageDealt();
     			int nHeal = 0;
			// Prevents player from regaining more HP than damage taken
			if(nDamageTaken >= nRemainingPool)
			{
				nHeal = nRemainingPool;
			}
			else
			{
				nHeal = nDamageTaken;
			}
          		// Heal them the Delayed Damage
			effect eHeal = EffectHeal(nHeal);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
			
			// Mark the Local Int with current damage plus whatever else was healed
			SetLocalInt(oPC, "DelayedDamage", nDelayedPool + nHeal);
		}           
        }// end if - Item is an armour
    }// end if - Running OnHit event    
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's armour
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("prc_crusader - OnEquip");

        // Only applies to armours
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_crusader", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's armour
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("prc_crusader - OnUnEquip");

        // Only applies to armours
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_crusader", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
        }
    }
    // This is used to determine the bonus from Furious Counterstrike
    else if(nEvent == EVENT_ONHEARTBEAT)
    {
    	// Get the amount of damage prevented
	int nDelayedPool = GetLocalInt(oPC, "DelayedDamage");
	if (DEBUG) DoDebug("Your delayed damage pool: " + IntToString(nDelayedPool));
	if (nDelayedPool > 0)
	{
		// Furious counterstrike is delayed damage / 5
		int nBonus = nDelayedPool / 5;
		// Minimum of one if you have delayed damage
		if (nBonus == 0 && nDelayedPool > 0) nBonus = 1;
		if (DEBUG) DoDebug("Your furious counterstrike: " + IntToString(nBonus));
    		// Calculate damage type and apply
        	int nDamageType = GetWeaponDamageType(oHand);
		effect eLink = EffectLinkEffects(EffectAttackIncrease(nBonus), EffectDamageIncrease(GetIntToDamage(nBonus), nDamageType));
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oPC, 6.0);
		// Visuals
		effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
		
		// Now apply the delayed damage
		effect eDam = EffectDamage(nDelayedPool);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
	}	
	// Clean up local int for this round
	DeleteLocalInt(oPC, "DelayedDamage");
    }
}