//::///////////////////////////////////////////////
//:: OnDeath NPC eventscript
//:: prc_npc_death
//:://////////////////////////////////////////////

#include "prc_inc_clsfunc"
#include "inc_eventhook"

void main()
{
    ExecuteScript("prc_ondeath", OBJECT_SELF);
    /* Moved to prc_ondeath
    object oKiller = GetLastKiller();

    if(GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE)>4)
    {
        LolthMeat(oKiller);
    }
    */
    
    
    
    // Execute scripts hooked to this event for the NPC triggering it
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_NPC_ONDEATH);
}