#include "tob_inc_moveknwn"
#include "tob_inc_recovery"
#include "prc_craft_inc"

/*void ArmouredStealth(object oInitiator)
{
	object oHide = GetPCSkin(oInitiator);
	int nHide = GetItemArmourCheckPenalty(GetItemInSlot(INVENTORY_SLOT_CHEST, oInitiator));
	SetCompositeBonus(oHide, "ArmouredStealth", nHide, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
}*/

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("tob_jadephoenix running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oInitiator = OBJECT_SELF;
    /*switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oInitiator = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oInitiator = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oInitiator = GetItemLastUnequippedBy(); break;
        case EVENT_ONHEARTBEAT:         oInitiator = OBJECT_SELF;               break;

        default:
            oInitiator = OBJECT_SELF;
    }

    object oItem;*/
    int nClass = GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oInitiator);
    int nMoveTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_MANEUVER);
    int nStncTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_STANCE);
    int nRdyTotal  = GetReadiedManeuversModifier(oInitiator, nClass);

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events, needed for various abilities
        if(DEBUG) DoDebug("tob_jadephoenix: Adding eventhooks");
        //AddEventScript(oInitiator, EVENT_ONHEARTBEAT,         "tob_jadephoenix", TRUE, FALSE);
        
        // Allows gaining of maneuvers by prestige classes
        // It's not pretty, but it works
        if (GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE,oInitiator) >= 1 &&
           !GetPersistantLocalInt(oInitiator, "ToBJadePhoenix1")
            )
        {
            if(DEBUG) DoDebug("tob_jadephoenix: Adding Maneuver 1");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBJadePhoenix1", TRUE);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DESERT_WIND);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_DEVOTED_SPIRIT);
        }       
        
        if (GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE,oInitiator) >= 3 &&
           !GetPersistantLocalInt(oInitiator, "ToBJadePhoenix3")
            )
        {
            if(DEBUG) DoDebug("tob_jadephoenix: Adding Maneuver 3");
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nRdyTotal);
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
	    SetPersistantLocalInt(oInitiator, "ToBJadePhoenix3", TRUE);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DESERT_WIND);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_DEVOTED_SPIRIT);
        } 
        
        if (GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE,oInitiator) >= 5 &&
           !GetPersistantLocalInt(oInitiator, "ToBJadePhoenix5")
            )
        {
            if(DEBUG) DoDebug("tob_jadephoenix: Adding Maneuver 5");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nStncTotal, MANEUVER_TYPE_STANCE);
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBJadePhoenix5", TRUE);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DESERT_WIND);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_DEVOTED_SPIRIT);
        }          
        
        if (GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE,oInitiator) >= 6 &&
           !GetPersistantLocalInt(oInitiator, "ToBJadePhoenix6")
            )
        {
            if(DEBUG) DoDebug("tob_jadephoenix: Adding Maneuver 6");
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nRdyTotal);
            SetPersistantLocalInt(oInitiator, "ToBJadePhoenix6", TRUE);
        } 
        
        if (GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE,oInitiator) >= 7 &&
           !GetPersistantLocalInt(oInitiator, "ToBJadePhoenix7")
            )
        {
            if(DEBUG) DoDebug("tob_jadephoenix: Adding Maneuver 7");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBJadePhoenix7", TRUE);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DESERT_WIND);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_DEVOTED_SPIRIT);
        } 
        
        if (GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE,oInitiator) >= 9 &&
           !GetPersistantLocalInt(oInitiator, "ToBJadePhoenix9")
            )
        {
            if(DEBUG) DoDebug("tob_jadephoenix: Adding Maneuver 9");
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nRdyTotal);
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBJadePhoenix9", TRUE);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline1", DISCIPLINE_DESERT_WIND);
            SetPersistantLocalInt(oInitiator, "RestrictedDiscipline2", DISCIPLINE_DEVOTED_SPIRIT);
        }          
        
        // Hook to OnLevelDown to remove the maneuver slots granted here
        AddEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_jadephoenix", TRUE, FALSE);        
    }
    else if(nEvent == EVENT_ONPLAYERLEVELDOWN)
    {   
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBJadePhoenix1") &&
           GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE,oInitiator) < 1
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBJadePhoenix1");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
        }    
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBJadePhoenix3") &&
           GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE,oInitiator) < 3
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBJadePhoenix3");
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nRdyTotal);
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
        }
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBJadePhoenix5") &&
           GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE,oInitiator) < 5
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBJadePhoenix5");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nStncTotal, MANEUVER_TYPE_STANCE);
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
        }
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBJadePhoenix6") &&
           GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE,oInitiator) < 6
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBJadePhoenix6");
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nRdyTotal);
        }        
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBJadePhoenix7") &&
           GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE,oInitiator) < 7
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBJadePhoenix7");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
        }
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBJadePhoenix9") &&
           GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE,oInitiator) < 9
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBJadePhoenix9");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nRdyTotal);
        }
     
        // Remove eventhook if the character no longer has levels in Jade Phoenix
        if(GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE,oInitiator) == 0)
            RemoveEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_jadephoenix", TRUE, FALSE);
    }
}