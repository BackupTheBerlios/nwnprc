//::///////////////////////////////////////////////
//:: OnHeartbeat NPC eventscript
//:: prc_npc_hb
//:://////////////////////////////////////////////
#include "inc_prc_npc"
#include "prc_inc_death"
#include "inc_epicspellai"

void main()
{
    
    //NPC substiture for OnEquip
    DoEquipTest();


    if(DoEpicSpells())
    {
        ActionDoCommand(SetCommandable(TRUE));
        SetCommandable(FALSE);
    }
    
    if(DoDeadHealingAI())
    {
        ActionDoCommand(SetCommandable(TRUE));
        SetCommandable(FALSE);
    }

    //run the individual HB event script
    ExecuteScript("prc_onhb_indiv", OBJECT_SELF);
}