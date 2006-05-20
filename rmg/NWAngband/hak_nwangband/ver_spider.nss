//::///////////////////////////////////////////////
//:: Name       Monsterous Spider setup
//:: FileName   ver_spider
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Attack: Bite +4 melee (1d8+3 plus poison)
    Monstrous Spider Poison
    Size        Fort DC     Damage
    Tiny        10          1d2 Str
    Small       10          1d3 Str
    Medium      12          1d4 Str
    Large       13          1d6 Str
    Huge        16          1d8 Str
    Gargantuan  20          2d6 Str
    Colossal    28          2d8 Str

*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 05/05/06
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prs_inc"

void main()
{
    if(GetLocalInt(OBJECT_SELF, "Spawned")) return;
    SetLocalInt(OBJECT_SELF, "Spawned", TRUE);

    float fCR = GetLocalFloat(OBJECT_SELF, "CR");
    int nHD = FloatToInt(fCR);
    //minimum 5, max 15
    if(nHD < 5)
    {
        //at low CR, random chance not to have this spawn
        if(Random(5)+1 > nHD)
            DestroyObject(OBJECT_SELF);
        nHD = 5;
    }
    if(nHD > 15)
        nHD = 15;
    int i;
    for(i=1;i<nHD;i++)
    {
        LevelUpHenchman(OBJECT_SELF, CLASS_TYPE_INVALID, TRUE);
    }

    //attatch prc_ai_mob_* scripts via eventhook
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONPHYSICALATTACKED,   "prc_ai_mob_attck", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONBLOCKED,            "prc_ai_mob_block", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONCOMBATROUNDEND,     "prc_ai_mob_combt", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONCONVERSATION,       "prc_ai_mob_conv",  TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONDAMAGED,            "prc_ai_mob_damag", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONDISTURBED,          "prc_ai_mob_distb", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONPERCEPTION,         "prc_ai_mob_percp", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONSPAWNED,            "prc_ai_mob_spawn", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONSPELLCASTAT,        "prc_ai_mob_spell", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONDEATH,              "prc_ai_mob_death", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONRESTED,             "prc_ai_mob_rest",  TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONUSERDEFINED,        "prc_ai_mob_userd", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONHEARTBEAT,          "prc_ai_mob_heart", TRUE, FALSE);
    //attatch prs_onpercieve script via eventhook
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONPERCEPTION,         "prs_onpercieve", TRUE, FALSE);
    //attach spider movement script via eventhook
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONHEARTBEAT,          "ver_spider_hb", TRUE, FALSE);

    //sets up the faction
    PRS_DoSpawn();
    //set destroyable
    SetIsDestroyable(FALSE, TRUE, TRUE);
    //set lootable
    SetLootable(OBJECT_SELF, TRUE);

    //setup bite
    object oBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B);
    int nSize = GetCreatureSize(OBJECT_SELF);
    itemproperty ipIP;
    switch(nSize)
    {
        //large size
        case CREATURE_SIZE_LARGE:
            //1d8 damage
            ipIP = ItemPropertyMonsterDamage(IP_CONST_MONSTERDAMAGE_1d8);
            IPSafeAddItemProperty(oBite, ipIP);
            //poison DC 13 1d6 Str
            //closest is DC 14 1d6 Str
            ipIP = ItemPropertyOnMonsterHitProperties(IP_CONST_ONMONSTERHIT_POISON,
                POISON_MEDIUM_SPIDER_VENOM);
            IPSafeAddItemProperty(oBite, ipIP);
            break;
    }
}
