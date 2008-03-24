//Handles awakening by damage from Painful Sleep of the Ages

#include "prc_alterations"

void main()
{
    int nEvent = GetRunningEvent();

    // Init the PC.
    object oPC = OBJECT_SELF;    
    
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events
        if(DEBUG) DoDebug("inv_painsleep: Adding eventhooks to " + DebugObject2Str(oPC));
        AddEventScript(oPC, EVENT_ONHEARTBEAT, "inv_painsleep", FALSE, FALSE);
    }
    
    else if(nEvent == EVENT_ONHEARTBEAT)
    {
        if(!GetHasSpellEffect(INVOKE_PAINFUL_SLUMBER_OF_AGES, oPC))
        {
            if(DEBUG) DoDebug("inv_painsleep: Target awakened unnaturally");
            effect eSleepDam = EffectDamage(GetLocalInt(oPC, "PainfulSleep"), DAMAGE_TYPE_MAGICAL);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eSleepDam, oPC);
            DeleteLocalInt(oPC, "PainfulSleep");
            int nSleepCheck = GetLocalInt(oPC, "nSleepCheck");
            SetLocalInt(oPC, "nSleepCheck", nSleepCheck + 1);
        }
    }
}