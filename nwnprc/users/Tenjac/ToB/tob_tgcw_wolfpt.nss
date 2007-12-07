//////////////////////////////////////////////////
// Wolf Pack Tactics
// tob_tgcw_wolfpt.nss
// Tenjac     12/6/07
//////////////////////////////////////////////////
/** @file Wolf Pack Tactics
Tiger Claw (Stance)
Level: Swordsage 8, warblade 8
Prerequisite: Two Tiger Claw maneuvers
Initiation Action: 1 swift action
Range: Personal
Target: You
Duration: Stance

With each stinging attack that connects against a foe, you slip arround him, using
the distraction provided by your attacks to prevent him from hindering your 
movement.

For the next round, each successful hit increases your movement speed next round by 5 feet.

*/
void DoSpeedBoost(object oInitiator);

#include "tob_inc_tobfunc"
#include "tob_movehook"
#include "prc_alterations"

void main()
{
        if (!PreManeuverCastCode())
        {
                // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
                return;
        }
        
        // End of Spell Cast Hook
        
        object oInitiator    = OBJECT_SELF;
        object oTarget       = PRCGetSpellTargetObject();
        struct maneuver move = EvaluateManeuver(oInitiator, oTarget);
        
        
        if(move.bCanManeuver)
        {
                 object oWeap1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
                 object oWeap2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator);
                 
                 //Add spellhook
                 itemproperty ipHook = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
                 
                 IPSafeAddItemProperty(oWeap1, ipHook, RoundsToSeconds(1));
                 AddEventScript(oWeap1, EVENT_ITEM_ONHIT, "tob_event_wolfpt", TRUE, FALSE);
                 DelayCommand(RoundsToSeconds(1), RemoveEventScript(oWeap1, EVEN_ITEM_ONHIT, "tob_event_wolfpt"));
                 
                 //Weapon 2 if present
                 if(IPGetIsMeleeWeapon(oWeap2))
                 {
                         IPSafeAddItemProperty(oWeap2, ipHook, RoundsToSeconds(1));
                         AddEventScript(oWeap2, EVENT_ITEM_ONHIT, "tob_event_wolfpt", TRUE, FALSE);
                         DelayCommand(RoundsToSeconds(1), RemoveEventScript(oWeap2, EVEN_ITEM_ONHIT, "tob_event_wolfpt"));
                 }
                 
                 DelayCommand(RoundsToSeconds(1), DoSpeedBoost(oInitiator));
                 AddEventScript(oInitiator, EVENT_ONHEARTBEAT, "tob_tgcw_wolfpt", TRUE, FALSE);
         }
 }

void DoSpeedBoost(object oInitiator)
{
        int nHits = PRCGetLocalInt(oInititaor, "PRC_WOLF_PACT_TACTICS_HITS");
        
        int nBoost = nHits * 17;
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedIncrease(nBoost), oInitiator, RoundsToSeconds(1));
        DeleteLocalInt(oInitiator, "PRC_WOLF_PACT_TACTICS_HITS");
}