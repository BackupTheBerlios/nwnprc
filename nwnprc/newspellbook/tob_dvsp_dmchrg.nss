/*
   ----------------
   Doom Charge

   tob_dvsp_dmchrg.nss
   ----------------

    31/08/07 by Stratovarius
*/ /** @file

    Doom Charge

    Devoted Spirit (Strike) [Evil]
    Level: Crusader 5
    Prerequisite: One Devoted Spirit maneuver
    Initiation Action: 1 Full-round action
    Range: Melee
    Target: One creature
    Duration: 1 round

    You cloak yourself in a black, terrible aura of contempt and spite.
    
    You make a charge attack. If the target is good aligned, you gain 6d6 damage on the attack,
    and damage reduction of 10/- for one round.
*/

#include "tob_inc_move"
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
    	int nDam = 0;
    	if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD)
    	{
    		nDam = d6(6);
    	}
    	
    	// Now the Charge
	int nSucceed = DoCharge(oInitiator, oTarget, TRUE, TRUE, nDam, DAMAGE_TYPE_DIVINE);
	if (nSucceed)
	{
		effect eLink = EffectVisualEffect(VFX_DUR_ROOTED_TO_SPOT);
		eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 10));
		eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING,    10));
                eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING,    10));
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oInitiator, 6.0);
	}
    }
}