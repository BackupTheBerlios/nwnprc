/*
    Psionic OnHit.
    This scripts holds all functions used for psionics on hit powers and abilities.

    Stratovarius
*/

// Include Files:
#include "psi_inc_psifunc"
#include "X0_I0_SPELLS"
#include "psi_inc_pwresist"
#include "prc_inc_combat"


// Swings at the target closest to the one hit
void SweepingStrike(object oCaster, object oTarget);

// ---------------
// BEGIN FUNCTIONS
// ---------------

void SweepingStrike(object oCaster, object oTarget)
{
	int nValidTarget = FALSE;
	location lTarget = GetLocation(oTarget);
	// Use the function to get the closest creature as a target
        object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oAreaTarget) && !nValidTarget && !GetLocalInt(oCaster, "SweepingStrikeDelay"))
        {
            // Don't hit yourself
            // Make sure the target is both next to the one struck and within melee range of the caster
            // Don't hit the one already struck
            if(oAreaTarget != oCaster &&
               GetIsInMeleeRange(oAreaTarget, oCaster) &&
               GetIsInMeleeRange(oAreaTarget, oTarget) &&
               oAreaTarget != oTarget)
            {
                // Perform the Attack
 		effect eVis = EffectVisualEffect(VFX_IMP_STUN);
		PerformAttack(oAreaTarget, oCaster, eVis, 0.0, 0, 0, 0, "Sweeping Strike Hit", "Sweeping Strike Miss");

		// End the loop
		nValidTarget = TRUE;
            }

            //Select the next target within the spell shape.
            oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }// end while - Target loop
}
