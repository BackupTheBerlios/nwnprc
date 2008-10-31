#include "tob_inc_recovery"
#include "tob_inc_moveknwn"
#include "prc_inc_combat"

void ApplySuperiorTWF(object oInitiator)
{
     if (GetIsDisciplineWeapon(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator), DISCIPLINE_TIGER_CLAW) && 
         GetIsDisciplineWeapon(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator), DISCIPLINE_TIGER_CLAW))
     {
     	SetCompositeAttackBonus(oInitiator, "SuperiorTWF", 2);
     }
     else if (GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator)) == BASE_ITEM_DAGGER && 
              GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator)) == BASE_ITEM_DAGGER)
     {
     	SetCompositeAttackBonus(oInitiator, "SuperiorTWF", 2);
     }     
}

void RemoveSuperiorTWF(object oInitiator)
{
     if (!GetIsDisciplineWeapon(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator), DISCIPLINE_TIGER_CLAW) ||
         !GetIsDisciplineWeapon(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator), DISCIPLINE_TIGER_CLAW))
     {
     	SetCompositeAttackBonus(oInitiator, "SuperiorTWF", 0);
     }
     else if (GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator)) != BASE_ITEM_DAGGER ||
         GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator)) != BASE_ITEM_DAGGER)
     {
     	SetCompositeAttackBonus(oInitiator, "SuperiorTWF", 0);
     }  
}

void ClawsOfTheBeast(object oInitiator, object oTarget)
{
     // Weapon in the left hand means there has to be a weapon in the right hand
     if (GetIsDisciplineWeapon(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator), DISCIPLINE_TIGER_CLAW))
     {
     	// The +1 is to round up
     	int nStr = (GetAbilityModifier(ABILITY_STRENGTH, oInitiator) + 1) / 2;
     	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nStr), oTarget);
     }
}

void RendingClaws(object oInitiator, object oTarget)
{
    // Expend a maneuver to do the rend, must be shifting
    if(ExpendRandomManeuver(oInitiator, GetFirstBladeMagicClass(oInitiator), DISCIPLINE_TIGER_CLAW) && 
       GetHasSpellEffect(MOVE_BLOODCLAW_SHIFT, oTarget))
    {
    	if (GetIsDisciplineWeapon(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator), DISCIPLINE_TIGER_CLAW) && 
    	    GetIsDisciplineWeapon(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator), DISCIPLINE_TIGER_CLAW))
     	{
     		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(2)), oTarget);
     	}
     	else if (GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator)) == BASE_ITEM_DAGGER && 
     	         GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator)) == BASE_ITEM_DAGGER)
     	{
     		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(2)), oTarget);
     	} 
    }
}	

void Scent(object oInitiator)
{
	effect eScent = EffectLinkEffects(EffectSkillIncrease(SKILL_SPOT, 4), EffectSkillIncrease(SKILL_LISTEN, 4));
	eScent = EffectLinkEffects(eScent, EffectSkillIncrease(SKILL_SEARCH, 4));
	
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eScent, oInitiator);	
}

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("tob_bloodclaw running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oInitiator;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oInitiator = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oInitiator = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oInitiator = GetItemLastUnequippedBy(); break;
        case EVENT_ONHEARTBEAT:         oInitiator = OBJECT_SELF;               break;

        default:
            oInitiator = OBJECT_SELF;
    }

    object oItem;
    int nClass = GetLevelByClass(CLASS_TYPE_BLOODCLAW_MASTER, oInitiator);
    int nMoveTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_MANEUVER);
    int nRdyTotal  = GetReadiedManeuversModifier(oInitiator, nClass);

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events, needed for various abilities
        if(DEBUG) DoDebug("tob_bloodclaw: Adding eventhooks");
        AddEventScript(oInitiator, EVENT_ONPLAYEREQUIPITEM,   "tob_bloodclaw", TRUE, FALSE);
        AddEventScript(oInitiator, EVENT_ONPLAYERUNEQUIPITEM, "tob_bloodclaw", TRUE, FALSE);
        AddEventScript(oInitiator, EVENT_ONHEARTBEAT,         "tob_bloodclaw", TRUE, FALSE);
        
        // Rest of the checks are in the function
        if (nClass >= 2) ApplySuperiorTWF(oInitiator);
        if (nClass >= 5) Scent(oInitiator);
        
        // Allows gaining of maneuvers by prestige classes
        // It's not pretty, but it works
        if (GetLevelByClass(CLASS_TYPE_BLOODCLAW_MASTER,oInitiator) >= 1 &&
           !GetPersistantLocalInt(oInitiator, "ToBBloodclaw1")
            )
        {
            if(DEBUG) DoDebug("tob_bloodclaw: Adding Maneuver 1");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBBloodclaw1", TRUE);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_TIGER_CLAW);
        }  
        
        if (GetLevelByClass(CLASS_TYPE_BLOODCLAW_MASTER,oInitiator) >= 3 &&
           !GetPersistantLocalInt(oInitiator, "ToBBloodclaw3")
            )
        {
            if(DEBUG) DoDebug("tob_bloodclaw: Adding Maneuver 3");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nRdyTotal);
            SetPersistantLocalInt(oInitiator, "ToBBloodclaw3", TRUE);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_TIGER_CLAW);
        } 
        
        if (GetLevelByClass(CLASS_TYPE_BLOODCLAW_MASTER,oInitiator) >= 5 &&
           !GetPersistantLocalInt(oInitiator, "ToBBloodclaw5")
            )
        {
            if(DEBUG) DoDebug("tob_bloodclaw: Adding Maneuver 5");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBBloodclaw5", TRUE);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_TIGER_CLAW);
        }         
        
        // Hook to OnLevelDown to remove the maneuver slots granted here
        AddEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_bloodclaw", TRUE, FALSE);        
    }
    else if(nEvent == EVENT_ONPLAYERLEVELDOWN)
    {
        // Has lost MAneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBBloodclaw1") &&
           GetLevelByClass(CLASS_TYPE_BLOODCLAW_MASTER,oInitiator) < 1
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBBloodclaw1");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
        }
        // Has lost MAneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBBloodclaw3") &&
           GetLevelByClass(CLASS_TYPE_BLOODCLAW_MASTER,oInitiator) < 3
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBBloodclaw3");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nRdyTotal);
        }
        // Has lost MAneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBBloodclaw3") &&
           GetLevelByClass(CLASS_TYPE_BLOODCLAW_MASTER,oInitiator) < 5
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBBloodclaw5");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
        }        

        // Remove eventhook if the character no longer has levels in Bloodclaw
        if(GetLevelByClass(CLASS_TYPE_BLOODCLAW_MASTER,oInitiator) == 0)
            RemoveEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_bloodclaw", TRUE, FALSE);
    }    
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("tob_bloodclaw: OnHit:\n" + "oInitiator = " + DebugObject2Str(oInitiator) + "\n" + "oItem = " + DebugObject2Str(oItem) + "\n" + "oTarget = " + DebugObject2Str(oTarget) + "\n");

        // Only applies to weapons, must be melee
        if(oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator))
        {
		 ClawsOfTheBeast(oInitiator, oTarget);
		 if (nClass >= 5) RendingClaws(oInitiator, oTarget);
        }// end if - Item is a melee weapon
    }// end if - Running OnHit event
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oInitiator's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oInitiator = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("tob_bloodclaw - OnEquip\n" + "oInitiator = " + DebugObject2Str(oInitiator) + "\n" + "oItem = " + DebugObject2Str(oItem) + "\n");
        
        // Rest of the checks are in the function
        if (nClass >= 2) ApplySuperiorTWF(oInitiator);

        // Only applies to weapons
        // IPGetIsMeleeWeapon is bugged and returns true on items it should not
        if(oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator) && !GetIsShield(oItem))
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_bloodclaw", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oInitiator's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oInitiator   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("tob_bloodclaw - OnUnEquip\n" + "oInitiator = " + DebugObject2Str(oInitiator) + "\n" + "oItem = " + DebugObject2Str(oItem) + "\n");
        
        // Rest of the checks are in the function
        if (nClass >= 2) RemoveSuperiorTWF(oInitiator);

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oItem) && !GetIsShield(oItem))
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_bloodclaw", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }
}
