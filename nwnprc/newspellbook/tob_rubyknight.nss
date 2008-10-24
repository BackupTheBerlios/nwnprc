#include "tob_inc_moveknwn"
#include "tob_inc_recovery"
#include "prc_craft_inc"

void ArmouredStealth(object oInitiator)
{
	object oHide = GetPCSkin(oInitiator);
	int nHide = GetItemArmourCheckPenalty(GetItemInSlot(INVENTORY_SLOT_CHEST, oInitiator));
	SetCompositeBonus(oHide, "ArmouredStealth", nHide, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
}

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("tob_rubyknight running, event: " + IntToString(nEvent));

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
    int nClass = GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR, oInitiator);
    int nMoveTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_MANEUVER);
    int nStncTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_STANCE);
    int nRdyTotal  = GetReadiedManeuversModifier(oInitiator, nClass);

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events, needed for various abilities
        if(DEBUG) DoDebug("tob_rubyknight: Adding eventhooks");
        AddEventScript(oInitiator, EVENT_ONPLAYEREQUIPITEM,   "tob_rubyknight", TRUE, FALSE);
        AddEventScript(oInitiator, EVENT_ONPLAYERUNEQUIPITEM, "tob_rubyknight", TRUE, FALSE);
        AddEventScript(oInitiator, EVENT_ONHEARTBEAT,         "tob_rubyknight", TRUE, FALSE);
        
        // Rest of the checks are in the function
        if (nClass >= 5) ArmouredStealth(oInitiator);
        
        // Allows gaining of maneuvers by prestige classes
        // It's not pretty, but it works
        if (GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,oInitiator) >= 1 &&
           !GetPersistantLocalInt(oInitiator, "ToBRubyKnight1")
            )
        {
            if(DEBUG) DoDebug("tob_rubyknight: Adding Maneuver 1");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nStncTotal, MANEUVER_TYPE_STANCE);
            SetPersistantLocalInt(oInitiator, "ToBRubyKnight1", TRUE);
        }          
        
        if (GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,oInitiator) >= 2 &&
           !GetPersistantLocalInt(oInitiator, "ToBRubyKnight2")
            )
        {
            if(DEBUG) DoDebug("tob_rubyknight: Adding Maneuver 2");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBRubyKnight2", TRUE);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DEVOTED_SPIRIT);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_SHADOW_HAND);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline3", DISCIPLINE_STONE_DRAGON);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline4", DISCIPLINE_WHITE_RAVEN);
        }  
        
        if (GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,oInitiator) >= 4 &&
           !GetPersistantLocalInt(oInitiator, "ToBRubyKnight4")
            )
        {
            if(DEBUG) DoDebug("tob_rubyknight: Adding Maneuver 4");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBRubyKnight4", TRUE);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DEVOTED_SPIRIT);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_SHADOW_HAND);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline3", DISCIPLINE_STONE_DRAGON);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline4", DISCIPLINE_WHITE_RAVEN);
        } 
        
        if (GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,oInitiator) >= 5 &&
           !GetPersistantLocalInt(oInitiator, "ToBRubyKnight5")
            )
        {
            if(DEBUG) DoDebug("tob_rubyknight: Adding Maneuver 5");
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nRdyTotal);
            SetPersistantLocalInt(oInitiator, "ToBRubyKnight5", TRUE);
        }          
        
        if (GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,oInitiator) >= 6 &&
           !GetPersistantLocalInt(oInitiator, "ToBRubyKnight6")
            )
        {
            if(DEBUG) DoDebug("tob_rubyknight: Adding Maneuver 6");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nStncTotal, MANEUVER_TYPE_STANCE);
            SetPersistantLocalInt(oInitiator, "ToBRubyKnight6", TRUE);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DEVOTED_SPIRIT);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_SHADOW_HAND);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline3", DISCIPLINE_STONE_DRAGON);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline4", DISCIPLINE_WHITE_RAVEN);
        } 
        
        if (GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,oInitiator) >= 8 &&
           !GetPersistantLocalInt(oInitiator, "ToBRubyKnight8")
            )
        {
            if(DEBUG) DoDebug("tob_rubyknight: Adding Maneuver 8");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBRubyKnight8", TRUE);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DEVOTED_SPIRIT);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_SHADOW_HAND);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline3", DISCIPLINE_STONE_DRAGON);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline4", DISCIPLINE_WHITE_RAVEN);
        } 
        
        if (GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,oInitiator) >= 9 &&
           !GetPersistantLocalInt(oInitiator, "ToBRubyKnight9")
            )
        {
            if(DEBUG) DoDebug("tob_rubyknight: Adding Maneuver 9");
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nRdyTotal);
            SetPersistantLocalInt(oInitiator, "ToBRubyKnight9", TRUE);
        }          
        
        if (GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,oInitiator) >= 10 &&
           !GetPersistantLocalInt(oInitiator, "ToBRubyKnight10")
            )
        {
            if(DEBUG) DoDebug("tob_rubyknight: Adding Maneuver 10");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBRubyKnight10", TRUE);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DEVOTED_SPIRIT);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_SHADOW_HAND);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline3", DISCIPLINE_STONE_DRAGON);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline4", DISCIPLINE_WHITE_RAVEN);
        }         
        
        // Hook to OnLevelDown to remove the maneuver slots granted here
        AddEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_rubyknight", TRUE, FALSE);        
    }
    else if(nEvent == EVENT_ONPLAYERLEVELDOWN)
    {
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBRubyKnight1") &&
           GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,oInitiator) < 1
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBRubyKnight1");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nStncTotal, MANEUVER_TYPE_STANCE);
        }    
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBRubyKnight2") &&
           GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,oInitiator) < 2
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBRubyKnight2");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
        }
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBRubyKnight4") &&
           GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,oInitiator) < 4
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBRubyKnight4");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
        }
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBRubyKnight5") &&
           GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,oInitiator) < 5
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBRubyKnight5");
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nRdyTotal);
        }        
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBRubyKnight6") &&
           GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,oInitiator) < 6
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBRubyKnight6");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nStncTotal, MANEUVER_TYPE_STANCE);
        }
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBRubyKnight8") &&
           GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,oInitiator) < 8
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBRubyKnight8");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
        }
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBRubyKnight9") &&
           GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,oInitiator) < 9
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBRubyKnight9");
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nRdyTotal);
        }        
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBRubyKnight10") &&
           GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,oInitiator) < 10
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBRubyKnight10");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
        }        
      

        // Remove eventhook if the character no longer has levels in Ruby Knight
        if(GetLevelByClass(CLASS_TYPE_RUBY_VINDICATOR,oInitiator) == 0)
            RemoveEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_rubyknight", TRUE, FALSE);
    }    
    // We are called from the OnPlayerEquipItem eventhook. 
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM && nClass >= 5)
    {
        oInitiator = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("tob_rubyknight - OnEquip\n" + "oInitiator = " + DebugObject2Str(oInitiator) + "\n" + "oItem = " + DebugObject2Str(oItem) + "\n");
        
        ArmouredStealth(oInitiator);
    }
    // We are called from the OnPlayerUnEquipItem eventhook. 
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM && nClass >= 5)
    {
        oInitiator   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("tob_rubyknight - OnUnEquip\n" + "oInitiator = " + DebugObject2Str(oInitiator) + "\n" + "oItem = " + DebugObject2Str(oItem) + "\n");
	
	ArmouredStealth(oInitiator);
    }
}
