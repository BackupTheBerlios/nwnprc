//::///////////////////////////////////////////////
//:: OnHeartbeat NPC eventscript
//:: prc_npc_hb
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_utility"

void main()
{
    
    //NPC substiture for OnEquip
    DoEquipTest();

    //run the individual HB event script
    ExecuteScript("prc_onhb_indiv", OBJECT_SELF);
}