//::///////////////////////////////////////////////
//:: OnSpawn NPC eventscript
//:: prc_npc_spawn
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    if(MyPRCGetRacialType(OBJECT_SELF)==RACIAL_TYPE_UNDEAD)
    {
        object oMaster = GetMaster();
        if(GetIsObjectValid(oMaster))
        {
            CorpseCrafter(oMaster, OBJECT_SELF);
        }
    }    
}