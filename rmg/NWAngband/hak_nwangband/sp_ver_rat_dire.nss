//::///////////////////////////////////////////////
//:: Name       Spawn Vermin Dire Rat Swarm
//:: FileName   sp_ver_rat
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Handle dire rat swarm spawning and maintenence
*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 05/05/06
//:://////////////////////////////////////////////

#include "reg_inc"
#include "spawn_inc"
#include "amb_inc"

void main()
{
    if(!REG_CheckSpawningClear(GetLocation(OBJECT_SELF), 40.0))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    float fCR = GetLocalFloat(OBJECT_SELF, "CR");
    int nCR = FloatToInt(fCR);
    //mark it as spawning rats
    SetLocalString(OBJECT_SELF, "SwarmResRef",  "ver_rat_dire");
    //set the maximuim number at once
    //assume a party of 4
    //1 per player, +1 per 6 levels
    SetLocalInt(   OBJECT_SELF, "SwarmMaxCount", (1+(nCR/6))*4);
    //set the number of HP each rat "costs"
    SetLocalInt(   OBJECT_SELF, "SwarmHP", 5);
    //total HP of swarm
    //2 per player, +1 per 3 levels
    int nMaxHP = ((2+(nCR/3))*4)*5;
    //reduce placeable down to this
    int nDam = GetCurrentHitPoints()-nMaxHP;
    if(nDam > 0)
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam), OBJECT_SELF);

    //attach swarm script
    AddEventScript(OBJECT_SELF, EVENT_PLACEABLE_ONHEARTBEAT, "swarm_hb", TRUE, FALSE);
                    
    string sResRef;
    switch(Random(8))
    {
        case 0: sResRef = "as_an_ratsqueak1"; break;
        case 1: sResRef = "as_an_ratsqueak2"; break;
        case 2: sResRef = "as_an_ratsqueak3"; break;
        case 3: sResRef = "as_an_ratssqueak1"; break;
        case 4: sResRef = "as_an_ratssqueak2"; break;
        case 5: sResRef = "as_an_ratssqueak3"; break;
        case 6: sResRef = "as_an_ratsdie1"; break;
        case 7: sResRef = "as_an_ratsdie2"; break;
    }
    CreateDescriptiveSound(sResRef, 
        "Rodents scratching around.", 
        GetLocation(OBJECT_SELF),
        10,
        TRUE,
        20.0);
}
