#include "tob_inc_moveknwn"
#include "tob_inc_recovery"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("tob_masterofnine running, event: " + IntToString(nEvent));

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
    int nClass = GetLevelByClass(CLASS_TYPE_MASTER_OF_NINE, oInitiator);
    int nMoveTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_MANEUVER);
    int nStncTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_STANCE);
    int nRdyTotal  = GetReadiedManeuversModifier(oInitiator, nClass);

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events, needed for various abilities
        if(DEBUG) DoDebug("tob_masterofnine: Adding eventhooks");
        AddEventScript(oInitiator, EVENT_ONPLAYEREQUIPITEM,   "tob_masterofnine", TRUE, FALSE);
        AddEventScript(oInitiator, EVENT_ONPLAYERUNEQUIPITEM, "tob_masterofnine", TRUE, FALSE);
        AddEventScript(oInitiator, EVENT_ONHEARTBEAT,         "tob_masterofnine", TRUE, FALSE);
        
        // Allows gaining of maneuvers by prestige classes
        // It's not pretty, but it works
        if (GetLevelByClass(CLASS_TYPE_MASTER_OF_NINE,oInitiator) >= 1 &&
           !GetPersistantLocalInt(oInitiator, "ToBMasterOfNine1")
            )
        {
            if(DEBUG) DoDebug("tob_masterofnine: Adding Maneuver 1");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), nMoveTotal + 2, MANEUVER_TYPE_MANEUVER);
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nRdyTotal);
            SetPersistantLocalInt(oInitiator, "ToBMasterOfNine1", TRUE);
        }          
        
        if (GetLevelByClass(CLASS_TYPE_MASTER_OF_NINE,oInitiator) >= 2 &&
           !GetPersistantLocalInt(oInitiator, "ToBMasterOfNine2")
            )
        {
            if(DEBUG) DoDebug("tob_masterofnine: Adding Maneuver 2");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nStncTotal, MANEUVER_TYPE_STANCE);
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nRdyTotal);
            SetPersistantLocalInt(oInitiator, "ToBMasterOfNine2", TRUE);
        }  
        
        if (GetLevelByClass(CLASS_TYPE_MASTER_OF_NINE,oInitiator) >= 3 &&
           !GetPersistantLocalInt(oInitiator, "ToBMasterOfNine3")
            )
        {
            if(DEBUG) DoDebug("tob_masterofnine: Adding Maneuver 3");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), nMoveTotal + 2, MANEUVER_TYPE_MANEUVER);
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nRdyTotal);
            SetPersistantLocalInt(oInitiator, "ToBMasterOfNine3", TRUE);
        } 
        
        if (GetLevelByClass(CLASS_TYPE_MASTER_OF_NINE,oInitiator) >= 4 &&
           !GetPersistantLocalInt(oInitiator, "ToBMasterOfNine4")
            )
        {
            if(DEBUG) DoDebug("tob_masterofnine: Adding Maneuver 4");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nStncTotal, MANEUVER_TYPE_STANCE);
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nRdyTotal);
            SetPersistantLocalInt(oInitiator, "ToBMasterOfNine4", TRUE);
        }          
        
        if (GetLevelByClass(CLASS_TYPE_MASTER_OF_NINE,oInitiator) >= 5 &&
           !GetPersistantLocalInt(oInitiator, "ToBMasterOfNine5")
            )
        {
            if(DEBUG) DoDebug("tob_masterofnine: Adding Maneuver 5");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), nMoveTotal + 2, MANEUVER_TYPE_MANEUVER);
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), ++nRdyTotal);
            SetPersistantLocalInt(oInitiator, "ToBMasterOfNine5", TRUE);
        } 
        
        // Hook to OnLevelDown to remove the maneuver slots granted here
        AddEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_masterofnine", TRUE, FALSE);        
    }
    else if(nEvent == EVENT_ONPLAYERLEVELDOWN)
    {
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBMasterOfNine1") &&
           GetLevelByClass(CLASS_TYPE_MASTER_OF_NINE,oInitiator) < 1
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBMasterOfNine1");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), nMoveTotal - 2, MANEUVER_TYPE_MANEUVER);
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nRdyTotal);
        }    
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBMasterOfNine2") &&
           GetLevelByClass(CLASS_TYPE_MASTER_OF_NINE,oInitiator) < 2
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBMasterOfNine2");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nStncTotal, MANEUVER_TYPE_STANCE);
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nRdyTotal);
        }
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBMasterOfNine3") &&
           GetLevelByClass(CLASS_TYPE_MASTER_OF_NINE,oInitiator) < 3
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBMasterOfNine3");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), nMoveTotal - 2, MANEUVER_TYPE_MANEUVER);
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nRdyTotal);
        }
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBMasterOfNine4") &&
           GetLevelByClass(CLASS_TYPE_MASTER_OF_NINE,oInitiator) < 4
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBMasterOfNine4");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nMoveTotal, MANEUVER_TYPE_MANEUVER);
	    SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nStncTotal, MANEUVER_TYPE_STANCE);
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nRdyTotal);
        }        
        // Has lost Maneuver, but the slot is still present
        if(GetPersistantLocalInt(oInitiator, "ToBMasterOfNine5") &&
           GetLevelByClass(CLASS_TYPE_MASTER_OF_NINE,oInitiator) < 5
           )
        {
            DeletePersistantLocalInt(oInitiator, "ToBMasterOfNine5");
            SetKnownManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), nMoveTotal - 2, MANEUVER_TYPE_MANEUVER);
            SetReadiedManeuversModifier(oInitiator, GetFirstBladeMagicClass(oInitiator), --nRdyTotal);
        }

        // Remove eventhook if the character no longer has levels in Ruby Knight
        if(GetLevelByClass(CLASS_TYPE_MASTER_OF_NINE, oInitiator) == 0)
            RemoveEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_masterofnine", TRUE, FALSE);
    }    
}
