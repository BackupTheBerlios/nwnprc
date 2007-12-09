/*
   ----------------
   Divine Surge, Greater

   tob_dvsp_dvnsrgg
   ----------------

   05/06/07 by Stratovarius
*/ /** @file

    Divine Surge, Greater

    Devoted Spirit (Strike)
    Level: Crusader 4
    Prerequisite: One Devoted Spirit Maneuver
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    Your body shakes and spasms as unfettered divine energy courses through it.
    This power sparks off your weapon and courses into your foe,
    devastating your enemy but leaving you drained.
    
    You make a single attack against an enemy. If this attack his, you deal 6d8 extra damage.
    For every point of constitution damage voluntarily taken, you gain a +1 bonus to attack and +2d8 damage.
    You can sacrifice a number of con points equal to your initiator level.
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
    	effect eNone = EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST);
    	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
    	int nDam = 6;
    	int nBonus = 0;
    	int nBoost = GetLocalInt(oInitiator, "DVGreaterSurge");
    	// Cap is done here.
    	if (nBoost > move.nInitiatorLevel) nBoost = move.nInitiatorLevel;
    	if (nBoost > 0)
    	{
    		nDam += nBoost * 2;
    		nBonus += nBoost;
    		// Con damage
		ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nBoost, DURATION_TYPE_PERMANENT);  
    	}
	PerformAttack(oTarget, oInitiator, eNone, 0.0, nBonus, d8(nDam), GetWeaponDamageType(oWeap), "Divine Surge, Greater Hit", "Divine Surge, Greater Miss");  
    }
}