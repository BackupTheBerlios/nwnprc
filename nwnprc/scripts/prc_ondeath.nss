//::///////////////////////////////////////////////
//:: OnPlayerDeath eventscript
//:: prc_ondeath
//:://////////////////////////////////////////////
/*
    This is also triggered by the NPC OnDeath event.
*/

#include "inc_eventhook"
#include "prc_inc_clsfunc"
#include "inc_ecl"

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
    
    if(GetPRCSwitch(PRC_XP_USE_PNP_XP))
        {
            if(GetObjectType(oKiller) == OBJECT_TYPE_TRIGGER)
                oKiller = GetTrapCreator(oKiller);
            if(oKiller != oPlayer
                && GetIsObjectValid(oKiller)
                && !GetIsFriend(oKiller, oPlayer)
                && (GetIsObjectValid(GetFirstFactionMember(oKiller, TRUE))
                    || GetPRCSwitch(PRC_XP_GIVE_XP_TO_NON_PC_FACTIONS)))
            {
                object oTest = GetFirstFactionMember(oKiller, !GetPRCSwitch(PRC_XP_GIVE_XP_TO_NPCS));
                while(GetIsObjectValid(oTest))
                {
                    float fDistance = GetDistanceToObject(oTest);
                    int nLevelDist = abs(GetECL(oTest)-GetECL(oKiller));
                    int bAward = TRUE;
                    if(fDistance < 0.0 && GetPRCSwitch(PRC_XP_MUST_BE_IN_AREA))
                        bAward = FALSE;
                    if(fDistance > IntToFloat(GetPRCSwitch(PRC_XP_MAX_PHYSICAL_DISTANCE)))
                        bAward = FALSE;
                    if(nLevelDist > GetPRCSwitch(PRC_XP_MAX_LEVEL_DIFF) 
                        && GetPRCSwitch(PRC_XP_MAX_LEVEL_DIFF))
                        bAward = FALSE;
                        
                    if(bAward)
                        GiveXPReward(oTest, oPlayer);
                        
                    oTest = GetNextFactionMember(oKiller, !GetPRCSwitch(PRC_XP_GIVE_XP_TO_NPCS));
                }
                //bypass bioware XP system
                AssignCommand(oPlayer, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPlayer));
                AssignCommand(oPlayer, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(10000, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY), oPlayer));
            }
    }

    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPlayer, EVENT_ONPLAYERDEATH);
}
