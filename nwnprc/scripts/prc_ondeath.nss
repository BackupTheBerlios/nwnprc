//::///////////////////////////////////////////////
//:: OnPlayerDeath eventscript
//:: prc_ondeath
//:://////////////////////////////////////////////

#include "inc_eventhook"

void main()
{
   // Unsummon the bonded summoner familiar
   object oPlayer = GetLastPlayerDied();
   object Asso = GetLocalObject(oPlayer, "BONDED");
   if (GetIsObjectValid(Asso))
   {
     effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
     ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetLocation(Asso));
     DestroyObject(Asso);
   }
   
   // Execute scripts hooked to this event for the player triggering it
   ExecuteAllScriptsHookedToEvent(oPlayer, EVENT_ONPLAYERDEATH);
}
