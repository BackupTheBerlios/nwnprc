//::///////////////////////////////////////////////
//:: OnPlayerDeath eventscript
//:: prc_ondeath
//:://////////////////////////////////////////////
/*
    This is also triggered by the NPC OnDeath event.
*/
#include "prc_alterations"
#include "prc_inc_clsfunc"
#include "psi_inc_psifunc"
#include "prc_inc_death"
#include "inc_ecl"

void main()
{
    object oDead   = GetLastBeingDied();
    object oKiller = MyGetLastKiller();

    // Unsummon the bonded summoner familiar
    //not needed now that its a summon (hopefully!)
    /*object Asso = GetLocalObject(oDead, "BONDED");
    if (GetIsObjectValid(Asso))
    {
        effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetLocation(Asso));
        DestroyObject(Asso);
    }*/

    // Clear a damage tracking variable. Oni's stuff uses this
    SetLocalInt(oDead, "PC_Damage", 0);

    // Do Lolth's Meat for the killer
    if(GetAbilityScore(oDead, ABILITY_INTELLIGENCE)>4)
    {
        LolthMeat(oKiller);
    }

    if(GetPRCSwitch(PRC_XP_USE_PNP_XP))
    {
        if(GetObjectType(oKiller) == OBJECT_TYPE_TRIGGER)
            oKiller = GetTrapCreator(oKiller);
        if(oKiller != oDead
            && !GetLocalInt(oDead, "PRC_PNP_XP_DEATH")
            && GetIsObjectValid(oKiller)
            && !GetIsFriend(oKiller, oDead)
            && (GetIsObjectValid(GetFirstFactionMember(oKiller, TRUE))
                || GetPRCSwitch(PRC_XP_GIVE_XP_TO_NON_PC_FACTIONS)))
        {
            GiveXPRewardToParty(oKiller, oDead);
            //bypass bioware XP system
            AssignCommand(oDead, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oDead));
            SetLocalInt(oDead, "PRC_PNP_XP_DEATH", 1);
            //AssignCommand(oDead, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(10000, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY), oDead));
            AssignCommand(oDead, ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), oDead));
        }
    }
    
    //Prey on the Weak
    object oPrey = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(oDead), FALSE, OBJECT_TYPE_CREATURE);
    
    while(GetIsObjectValid(oPrey))
    {
            if(!GetIsReactionTypeFriendly(oPrey, oDead))
            {
                    if(GetHasSpellEffect(MOVE_TC_PREY_ON_THE_WEAK, oPrey))
                    {
                            if(!GetLocalInt(oPrey, "PRC_POTW_HAS_ATTACKED"))
                            {                             
                                    //GetNearestEnemy
                                    object oAoOTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(5.0), GetLocation(oPrey), TRUE, OBJECT_TYPE_CREATURE);
                                    
                                    while(GetIsObjectValid(oAoOTarget))
                                    {
                                            if(!GetIsReactionTypeFriendly(oAoOTarget))
                                            {
                                                    if(!GetIsDead(oAoOTarget))
                                                    {
                                                            effect eNone;
                                                            object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPrey);
                                                            //SetLocalInt
                                                            SetLocalInt(oPrey, "PRC_POTW_HAS_ATTACKED", 1);
                                                            
                                                            PerformAttack(oAoOTarget, oPrey, eNone, 0.0, 0, 0, GetWeaponDamageType(oWeap), "Prey on the Weak Hit", "Prey on the Weak Miss");
                                                            
                                                            //Set up removal
                                                            DelayCommand(RoundsToSeconds(1), DeleteLocalInt(oPrey, "PRC_POTW_HAS_ATTACKED"));
                                                            
                                                            continue();
                                                    }
                                            }
                                            oAoOTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(5.0), GetLocation(oPrey), TRUE, OBJECT_TYPE_CREATURE);
                                    }                               
                            }
                    }
            }
            oPrey = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(oDead), FALSE, OBJECT_TYPE_CREATURE);
    }//End Prey on the Weak

    if(GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oDead))
        SetPersistantLocalInt(oDead, "persist_dead", TRUE);

    // Psionic creatures lose all PP on death
    if(GetIsPsionicCharacter(oDead))
        LoseAllPowerPoints(oDead, TRUE);

    DoDied(OBJECT_SELF, TRUE);

    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oDead, EVENT_ONPLAYERDEATH);
}

