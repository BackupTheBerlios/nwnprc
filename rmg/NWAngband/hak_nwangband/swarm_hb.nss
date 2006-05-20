const int SWARM_MEMBERS = 4;
const string SWARM_RESREF = "rat_swarm_b";
const float SWARM_MONITOR_INTERVAL =1.0;

#include "spawn_inc"

void SwarmPseudoHB(object oHench, object oMaster)
{
    if(GetIsDead(oHench)
        || !GetIsObjectValid(oHench))
        SetLocalInt(oMaster, "SwarmCount",
            GetLocalInt(oMaster, "SwarmCount")-1);
    else
        DelayCommand(SWARM_MONITOR_INTERVAL, SwarmPseudoHB(oHench, oMaster));
}

void DoSwarmMember(object oMaster)
{
    location lSpawn = GetLocation(oMaster);
    lSpawn = GetRandomCircleLocation(GetLocation(oMaster), 2.0);
    string sResRef = GetLocalString(oMaster, "SwarmResRef");
    if(sResRef == "")
        sResRef = SWARM_RESREF;
    float fCR = GetLocalFloat(OBJECT_SELF, "CR");
    object oHench = MyCreateObject(sResRef, lSpawn,fCR);
//    //swarms move through each other
//    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneGhost()), oHench);
    SetLocalInt(oMaster, "SwarmCount",
        GetLocalInt(oMaster, "SwarmCount")+1);
    //start the swarm counter
    DelayCommand(SWARM_MONITOR_INTERVAL, SwarmPseudoHB(oHench, oMaster));
}

void main()
{
SendMessageToPC(GetFirstPC(), "Swarm_hb running");
    //count cohorts
    int nCount = GetLocalInt(OBJECT_SELF, "SwarmCount");
    int nMax = GetLocalInt(OBJECT_SELF, "SwarmMaxCount");
    if(!nMax)
        nMax = SWARM_MEMBERS;
    int nSpawnHP = GetLocalInt(OBJECT_SELF, "SwarmHP");
    if(!nSpawnHP)
        nSpawnHP = 1;
    while(nCount < nMax)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nSpawnHP), OBJECT_SELF);
        DoSwarmMember(OBJECT_SELF);
        nCount++;
    }
}
