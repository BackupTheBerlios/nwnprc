#include "prc_alterations"
#include "inc_utility"

void main()
{
    ExecuteScript("nw_ch_ac1", OBJECT_SELF);
    //NPC substiture for OnEquip
    DoEquipTest();

    //XP LA
    if(GetPRCSwitch(PRC_XP_GIVE_XP_TO_NPCS))
        ApplyECLToXP(OBJECT_SELF);

    // Execute scripts hooked to this event for the NPC triggering it
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_NPC_ONHEARTBEAT);
}