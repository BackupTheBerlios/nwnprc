//::///////////////////////////////////////////////
//:: OnHeartbeat NPC eventscript
//:: prc_npc_hb
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_prc_npc"
#include "inc_eventhook"
#include "inc_ecl"

void main()
{
    //NPC substiture for OnEquip
    DoEquipTest();
    
    //XP LA
    if(GetPRCSwitch(PRC_XP_GIVE_XP_TO_NPCS))
        ApplyECLToXP(OBJECT_SELF);
    
    // Execute scripts hooked to this event for the NPC triggering it
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_NPC_ONHEARTBEAT);
}