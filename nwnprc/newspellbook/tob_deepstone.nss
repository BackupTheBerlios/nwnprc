#include "prc_alterations"
#include "prc_inc_sneak"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("tob_deepstone running, event: " + IntToString(nEvent));

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
    int nClass = GetLevelByClass(CLASS_TYPE_DEEPSTONE_SENTINEL, oInitiator);
    int nMoveTotal = GetKnownManeuversModifier(oPC, nClass);

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events, needed from level 4 for Stone Curse
        if(DEBUG) DoDebug("tob_deepstone: Adding eventhooks");
        AddEventScript(oInitiator, EVENT_ONPLAYEREQUIPITEM,   "tob_deepstone", TRUE, FALSE);
        AddEventScript(oInitiator, EVENT_ONPLAYERUNEQUIPITEM, "tob_deepstone", TRUE, FALSE);
        AddEventScript(oInitiator, EVENT_ONHEARTBEAT,         "tob_deepstone", TRUE, FALSE);
        
        // Allows gaining of maneuvers by prestige classes
        // It's not pretty, but it works
        if (GetLevelByClass(CLASS_TYPE_DEEPSTONE_SENTINEL,oPC) >= 1 &&
           !GetPersistantLocalInt(oPC, "ToBDeepstone1")
            )
        {
            if(DEBUG) DoDebug("tob_deepstone: Adding Maneuver 1");
            SetKnownManeuversModifier(oPC, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal);
            SetPersistantLocalInt(oPC, "ToBDeepstone1", TRUE);
            SetPersistantLocalInt(oPC, "RestrictedDiscipline1", DISCIPLINE_STONE_DRAGON);
        }  
        
        if (GetLevelByClass(CLASS_TYPE_DEEPSTONE_SENTINEL,oPC) >= 3 &&
           !GetPersistantLocalInt(oPC, "ToBDeepstone3")
            )
        {
            if(DEBUG) DoDebug("tob_deepstone: Adding Maneuver 3");
            SetKnownManeuversModifier(oPC, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal);
            SetPersistantLocalInt(oPC, "ToBDeepstone3", TRUE);
            SetPersistantLocalInt(oPC, "RestrictedDiscipline1", DISCIPLINE_STONE_DRAGON);
        } 
        
        if (GetLevelByClass(CLASS_TYPE_DEEPSTONE_SENTINEL,oPC) >= 5 &&
           !GetPersistantLocalInt(oPC, "ToBDeepstone5")
            )
        {
            if(DEBUG) DoDebug("tob_deepstone: Adding Maneuver 5");
            SetKnownManeuversModifier(oPC, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal);
            SetPersistantLocalInt(oPC, "ToBDeepstone5", TRUE);
            SetPersistantLocalInt(oPC, "RestrictedDiscipline1", DISCIPLINE_STONE_DRAGON);
        }         
        
        // Hook to OnLevelDown to remove the maneuver slots granted here
        AddEventScript(oPC, EVENT_ONPLAYERLEVELDOWN, "tob_deepstone", TRUE, FALSE);        
    }
    else if(nEvent == EVENT_ONPLAYERLEVELDOWN)
    {
        // Has lost MAneuver, but the slot is still present
        if(GetPersistantLocalInt(oPC, "ToBDeepstone1") &&
           GetLevelByClass(CLASS_TYPE_DEEPSTONE_SENTINEL,oPC) < 1
           )
        {
            DeletePersistantLocalInt(oPC, "PRC_Thrallherd_CharmGained");
            SetKnownManeuversModifier(oPC, nClass, --nMoveTotal);
        }
        // Has lost MAneuver, but the slot is still present
        if(GetPersistantLocalInt(oPC, "ToBDeepstone3") &&
           GetLevelByClass(CLASS_TYPE_DEEPSTONE_SENTINEL,oPC) < 3
           )
        {
            DeletePersistantLocalInt(oPC, "ToBDeepstone3");
            SetKnownManeuversModifier(oPC, nClass, --nMoveTotal);
        }
        // Has lost MAneuver, but the slot is still present
        if(GetPersistantLocalInt(oPC, "ToBDeepstone3") &&
           GetLevelByClass(CLASS_TYPE_DEEPSTONE_SENTINEL,oPC) < 5
           )
        {
            DeletePersistantLocalInt(oPC, "ToBDeepstone5");
            SetKnownManeuversModifier(oPC, nClass, --nMoveTotal);
        }        

        // Remove eventhook if the character no longer has levels in Deepstone
        if(GetLevelByClass(CLASS_TYPE_DEEPSTONE_SENTINEL,oPC) == 0)
            RemoveEventScript(oPC, EVENT_ONPLAYERLEVELDOWN, "tob_deepstone", TRUE, FALSE);
    }    
    else if(nEvent == EVENT_ITEM_ONHIT && nClass >= 4)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("tob_deepstone: OnHit:\n"
                        + "oInitiator = " + DebugObject2Str(oInitiator) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Only applies to weapons, must be melee
        if(oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator))
        {
		// Saving Throw
		if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (10 + GetHitDice(oIniatitor)/2 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator))))
		{
			effect eLink = ExtraordinaryEffect(EffectLinkEffects(EffectCutsceneImmobilize(), EffectVisualEffect(VFX_IMP_DOOM)));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
		}		
        }// end if - Item is a melee weapon
    }// end if - Running OnHit event
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oInitiator's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM && nClass >= 4)
    {
        oInitiator   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("tob_deepstone - OnEquip\n"
                        + "oInitiator = " + DebugObject2Str(oInitiator) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        // IPGetIsMeleeWeapon is bugged and returns true on items it should not
        if(oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator) || 
           (oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator) && !GetIsShield(oItem)))
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_deepstone", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oInitiator's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM && nClass >= 4)
    {
        oInitiator   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("tob_deepstone - OnUnEquip\n"
                        + "oInitiator = " + DebugObject2Str(oInitiator) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oItem))
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_deepstone", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }
}
