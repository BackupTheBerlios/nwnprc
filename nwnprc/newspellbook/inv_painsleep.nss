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
        if(DEBUG) DoDebug("inv_painsleep: Adding eventhooks");
        AddEventScript(oPC, EVENT_VIRTUAL_ONDAMAGED, "inv_painsleep", FALSE, FALSE);
    }
    
    else if(nEvent == EVENT_VIRTUAL_ONDAMAGED)
    {
        if(DEBUG) DoDebug("inv_painsleep: OnDamaged Event Firing");
        effect eSleepDam = EffectDamage(GetLocalInt(oPC, "PainfulSleep"), DAMAGE_TYPE_MAGICAL);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSleepDam, oPC);
        DeleteLocalInt(oPC, "PainfulSleep");
    }
}