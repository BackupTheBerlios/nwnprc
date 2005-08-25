//::///////////////////////////////////////////////
//:: OnPlayerDeath eventscript
//:: prc_ondeath
//:://////////////////////////////////////////////
/*
    This is also triggered by the NPC OnDeath event.
*/

#include "inc_eventhook"
#include "prc_inc_clsfunc"
#include "psi_inc_psifunc"
#include "inc_ecl"
#include "inc_2dacache"

void main()
{
    // Unsummon the bonded summoner familiar
    //not needed now that its a summon (hopefully!)
    object oPlayer = GetLastBeingDied();
    /*object Asso = GetLocalObject(oPlayer, "BONDED");
    if (GetIsObjectValid(Asso))
    {
        effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetLocation(Asso));
        DestroyObject(Asso);
    }*/

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
            GiveXPRewardToParty(oKiller, oPlayer);
            //bypass bioware XP system
            AssignCommand(oPlayer, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPlayer));
            //AssignCommand(oPlayer, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(10000, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY), oPlayer));
            AssignCommand(oPlayer, ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), oPlayer));
        }
    }


    if(GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oPlayer))
        SetPersistantLocalInt(oPlayer, "persist_dead", TRUE);

    if (GetLocalInt(oPlayer, "AstralSeed"))
    {
        AstralSeedRespawn(oPlayer);
    }
    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPlayer, EVENT_ONPLAYERDEATH);
}

