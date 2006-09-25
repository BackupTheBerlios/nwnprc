#include "prc_alterations"

int SkirmishDamage(object oPC, object oTarget, int nClass)
{
	int nDamage = 0;
	// Only works on non-crit immune and they're within 30 feet
	if (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT) && FeetToMeters(30.0) > GetDistanceBetween(oPC, oTarget))
	{
		// Increased Dice every 4 levels (1, 5, 9 and so on)
		int nDice = (nClass + 3) / 4;
		nDamage = d6(nDice);
	}
	
	return nDamage;
}

// This is only called if you have Skirmished successfully
void SkirmishAC(object oPC, int nClass)
{
	// Increased Dice every 4 levels (3, 7, 11 and so on)
	int nDice = (nClass + 1) / 4;
	effect eAC = ExtraordinaryEffect(EffectACIncrease(nDice));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0);
}

void BattleFortitude(object oPC, int nClass)
{
	// Don't need to do this all the time
	if (!GetLocalInt(oPC, "ScoutBattleFort"))
	{
		int nFort;
		// Increased Fort every 9 levels (2, 11, 20 and so on)
		if (nClass >= 38)      nFort = 5;
		else if (nClass >= 29) nFort = 4;
		else if (nClass >= 20) nFort = 3;
		else if (nClass >= 11) nFort = 2;
		else if (nClass >= 2)  nFort = 1;
		effect eFort = ExtraordinaryEffect(EffectSavingThrowIncrease(SAVING_THROW_FORT, nFort));
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFort, oPC);
		
		SetLocalInt(oPC, "ScoutBattleFort", TRUE);
	}
}

// Permanent Freedom of movement spell
void FreeMovement(object oPC, int nClass)
{
	if (nClass >= 18 && !GetLocalInt(oPC, "ScoutFreeMove"))
	{
		effect eParal = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
		effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
		effect eSlow = EffectImmunity(IMMUNITY_TYPE_SLOW);
		effect eMove = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);

		//Link effects
		effect eLink = EffectLinkEffects(eParal, eEntangle);
		eLink = EffectLinkEffects(eLink, eSlow);
		eLink = EffectLinkEffects(eLink, eMove);

		ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eLink), oPC);
		SetLocalInt(oPC, "ScoutFreeMove", TRUE);
	}
}

void FastMovement(object oPC, int nClass)
{
	// Don't need to do this all the time
	if (!GetLocalInt(oPC, "ScoutFastMove"))
	{
		// Speed bonus. +20 feet at level 11, +10 feet at level 3
		// In NWN this is +66% and +33% (Assume 30 feet as base speed)
		if (nClass >= 11) ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectMovementSpeedIncrease(66)), oPC);
		else if (nClass >= 3) ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectMovementSpeedIncrease(33)), oPC);
		
		SetLocalInt(oPC, "ScoutFastMove", TRUE);
	}
}

void BlindSight(object oPC, int nClass)
{
	// Don't need to do this all the time
	if (!GetLocalInt(oPC, "ScoutBlindsight"))
	{
		// Blindsense -> Darkvis
		// Blindsight - True Seeing
		if (nClass >= 20) ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectUltravision()), oPC);
		else if (nClass >= 10) ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectTrueSeeing()), oPC);
		
		SetLocalInt(oPC, "ScoutBlindsight", TRUE);
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oItem;
	object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	object oAmmo;
    	int nClass = GetLevelByClass(CLASS_TYPE_SCOUT, oPC);
    	int nEvent = GetRunningEvent();	
    	int nArmour = GetBaseAC(oArmour);
    	
    	if(DEBUG) DoDebug("prc_scout running, event: " + IntToString(nEvent));
	
	// Light armour only
	if (3 >= nArmour)
	{
		FastMovement(oPC, nClass);
		BattleFortitude(oPC, nClass);
		FreeMovement(oPC, nClass);
	}
	// Doesn't depend on light armour
	BlindSight(oPC, nClass);
	
	// We aren't being called from any event, instead from EvalPRCFeats, so set up the eventhooks
	// Don't start doing this until the scout is level 2
	if(nEvent == FALSE && nClass >= 6)
	{
		if(DEBUG) DoDebug("prc_scout: Adding eventhooks");

		AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_scout", TRUE, FALSE);
		AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_scout", TRUE, FALSE);
		AddEventScript(oPC, EVENT_ONHEARTBEAT,         "prc_scout", TRUE, FALSE);
	}
	// We're being called from the OnHit eventhook, so deal the damage
	// Light armour only
	else if(nEvent == EVENT_ITEM_ONHIT && 3 >= nArmour)
	{
		oItem          = GetSpellCastItem();
		object oTarget = PRCGetSpellTargetObject();
		if(DEBUG) DoDebug("prc_scout: OnHit:\n"
		                + "oPC = " + DebugObject2Str(oPC) + "\n"
		                + "oItem = " + DebugObject2Str(oItem) + "\n"
		                + "oTarget = " + DebugObject2Str(oTarget) + "\n"
		                  );

		// Only applies to weapons, and the Scout must have moved this round.
        	if((IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem)) && GetLocalInt(oPC, "ScoutSkirmish"))
		{
			// Calculate Skirmish damage and apply
			int nDamageType = GetWeaponDamageType(oItem);
			effect eDam = EffectDamage(SkirmishDamage(oPC, oTarget, nClass), nDamageType);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		}// end if - Item is a melee weapon
	}// end if - Running OnHit event 	
	// We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
	else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
	{
		oPC   = GetItemLastEquippedBy();
		oItem = GetItemLastEquipped();
		if(DEBUG) DoDebug("prc_scout - OnEquip");

       		// Only applies to weapons
        	if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))
        	{
            		// Add eventhook to the item
            		AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_scout", TRUE, FALSE);

            		// Add the OnHitCastSpell: Unique needed to trigger the event
            		// Makes sure to get ammo if its a ranged weapon
            		IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            		
            		oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
            		IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

            		oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
            		IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

            		oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);            
            		IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        	}
	}
	// We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
	else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
	{
		oPC   = GetItemLastUnequippedBy();
		oItem = GetItemLastUnequipped();
		if(DEBUG) DoDebug("prc_scout - OnUnEquip");

        	// Only applies to weapons
        	if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))
        	{
            		// Add eventhook to the item
            		RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_scout", TRUE, FALSE);

            		// Remove the temporary OnHitCastSpell: Unique
            		// Makes sure to get ammo if its a ranged weapon
            		RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
            
            		oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
            		RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
		
            		oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
            		RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
	
            		oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);            
            		RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);            
        	}
	}
	// This is used to determine the Scout's AC bonus for skirmishing
	// Light armour only
	else if(nEvent == EVENT_ONHEARTBEAT && 3 >= nArmour)
	{
		// Check to see if the WP is valid
		object oTestWP = GetWaypointByTag(GetName(oPC));
		if (!GetIsObjectValid(oTestWP))
		{
			// Create waypoint for the movement
        		CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oPC), FALSE, GetName(oPC));
        	}
        	else // We have a test waypoint, now to check the distance
        	{
        		// Distance moved in the last round
        		float fDist = GetDistanceBetween(oPC, oTestWP);
        		// Distance needed to move
        		float fCheck = FeetToMeters(10.0);
        		
        		// Now clean up the WP and create a new one for next round's check
        		DestroyObject(oTestWP);
        		CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oPC), FALSE, GetName(oPC));
        		
        		// Moved the distance
        		if (fDist > fCheck)
        		{
        			// We have Skirmished
        			SetLocalInt(oPC, "ScoutSkirmish", TRUE);
        			// Only lasts for a round
        			DelayCommand(6.0, DeleteLocalInt(oPC, "ScoutSkirmish"));
        			// Give the AC bonus
        			SkirmishAC(oPC, nClass);
        		}
        	}
	}
}
