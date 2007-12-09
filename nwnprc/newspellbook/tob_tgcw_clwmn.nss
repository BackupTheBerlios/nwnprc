/*
   ----------------
   Claw at the Moon

   tob_stdr_stnvise.nss
   ----------------

   08/06/07 by Stratovarius
*/ /** @file

    Claw at the Moon

    Tiger Claw (Strike)
    Level: Swordsage 2, Warblade 2
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    You leap into the air, catching your foe off guard as you slice down into him.
    
    Make a jump check with a DC equal to the target's AC. If it succeeds, you deal an extra
    2d6 damage on your attack. If it fails, you deal damage normally.
*/

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
    	int nDamage = 0;
    	int nAC = GetDefenderAC(oTarget, oInitiator);
    	if(GetIsSkillSuccessful(oInitiator, SKILL_JUMP, nAC)) nDamage = d6(2);
    	effect eNone;
    	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, nDamage, GetWeaponDamageType(oWeap), "Claw at the Moon Hit", "Claw at the Moon Miss");
    }
}