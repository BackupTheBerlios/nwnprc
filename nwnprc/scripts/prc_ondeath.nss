//::///////////////////////////////////////////////
//:: OnPlayerDeath eventscript
//:: prc_ondeath
//:://////////////////////////////////////////////
/*
    This is also triggered by the NPC OnDeath event.
*/

#include "inc_eventhook"
#include "prc_inc_clsfunc"

void main()
{
    // Unsummon the bonded summoner familiar
    object oPlayer = GetLastBeingDied();
    object Asso = GetLocalObject(oPlayer, "BONDED");
    if (GetIsObjectValid(Asso))
    {
        effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetLocation(Asso));
        DestroyObject(Asso);
    }

    // Do Lolth's Meat for the killer
    object oKiller = MyGetLastKiller();
    if(GetAbilityScore(oPlayer, ABILITY_INTELLIGENCE)>4)
    {
        LolthMeat(oKiller);
    }

    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPlayer, EVENT_ONPLAYERDEATH);
}
