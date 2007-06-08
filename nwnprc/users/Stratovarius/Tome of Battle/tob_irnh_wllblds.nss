/*
   ----------------
   Wall of Blades

   tob_irnh_wllblds.nss
   ----------------

    06/06/07 by Stratovarius
*/ /** @file

    Wall of Blades

    Iron Heart (Counter)
    Level: Warblade 2
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: 1 Round

    Your weapon sways back and forth in your hand, ready to block incoming blows.
    With the speed of a thunderbolt, you clash your weapon against your foe's
    blade as he attempts to attack.
    
    You replace the next Reflex save you make this round with a Concentration check.
    The DC of the check is the same as that of the spell.
    A result of 1 on the roll is not an automatic failure.
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
	int nAC = GetDefenderAC(oInitiator, oTarget);
	int nAttack = GetAttackRoll(oTarget, oInitiator, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator));
	// Add bonus if greater
	if (nAttack > nAC)
	{
		int nBonus = nAttack - nAC;
		effect eAC = EffectLinkEffects(EffectACIncrease(nBonus), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eAC), oTarget, 6.0);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AC_BONUS), oTarget);
	}
    }
}