//::///////////////////////////////////////////////
//:: Rapid Metabolism evaluation and execution script
//:: prc_rapid_metab
//:://////////////////////////////////////////////
/*
    Heals the possessor by 1 + ConMod HP every
    turn, or HD + ConMod per day if the PnP
    version is active.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 24.03.2005
//:://////////////////////////////////////////////

#include "prc_inc_switch"
#include "inc_threads"

void main()
{
    object oCreature = OBJECT_SELF;
    int bPnP = GetPRCSwitch(PRC_PNP_RAPID_METABOLISM);
    
    if(GetCurrentThread() == "")
    {
        if(GetThreadState("RapidMetabolism", oCreature) == THREAD_STATE_DEAD)
            if(!SpawnNewThread("RapidMetabolism", "prc_rapid_metab", bPnP ? HoursToSeconds(24) : TurnsToSeconds(1), oCreature))
                WriteTimestampedLogEntry("Failed to spawn thread for Rapid Metabolism on " + GetName(oCreature));
    }
    else
    {
        effect eHeal = EffectHeal((bPnP ? GetHitDice(oCreature) : 1) + GetAbilityModifier(ABILITY_CONSTITUTION, oCreature));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCreature);
    }
}