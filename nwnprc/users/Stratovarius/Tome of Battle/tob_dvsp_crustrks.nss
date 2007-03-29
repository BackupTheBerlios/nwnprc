/*
   ----------------
   Crusader's Strike

   tob_dvsp_crustrk
   ----------------

   28/03/07 by Stratovarius
*/ /** @file

    Crusader's Strike

    Devoted Spirit (Strike)
    Level: Crusader 1
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    Divine power surrounds your weapon as you strike, 
    This power washes over you as your weapon finds its mark,
    mending your wounds and giving you the strength to fight on.
    
    You make a single attack against an enemy who's alignment has at least one component
    different from yours. If you hit, you or an ally with 10 feet is healed 1d6 + 1 per
    initiator level (max of +5).
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
    	effect eNone;
	PerformAttack(oTarget, oInitiator, eNone);
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
    		if (GetAlignmentGoodEvil(oInitiator) != GetAlignmentGoodEvil(oTarget) || 
    		    GetAlignmentLawChaos(oInitiator) != GetAlignmentLawChaos(oTarget))
    		{
    			int nHeal = d6() + min(move.oInitiator, 5);
    			object oHeal = GetCrusaderHealTarget(oPC);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oHeal);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_L_LAW), oHeal);
        	}
        }
    }
}

// Return an ALIGNMENT_* constant to represent oCreature's good/evil alignment
// * Return value if oCreature is not a valid creature: -1
int GetAlignmentGoodEvil(object oCreature);

// Return an ALIGNMENT_* constant to represent oCreature's law/chaos alignment
// * Return value if oCreature is not a valid creature: -1
int GetAlignmentLawChaos(object oCreature);