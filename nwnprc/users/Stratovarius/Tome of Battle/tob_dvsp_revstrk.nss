/*
   ----------------
   Revitalizing Strike

   tob_dvsp_revstrk
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Revitalizing Strike

    Devoted Spirit (Strike)
    Level: Crusader 3
    Prerequisite: One Devoted Spirit maneuver.
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    As you rear back to strike your foe, an aura of divine energy surrounds you.
    As your attack slams home, this aura dissipates in a flash, knitting your wounds
    as it discharges.
    
    You make a single attack against an enemy who's alignment has at least one component
    different from yours. If you hit, you or an ally with 10 feet is healed 3d6 + 1 per
    initiator level (max of +10).
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
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Revitalizing Strike Hit", "Revitalizing Strike Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
    		if (GetAlignmentGoodEvil(oInitiator) != GetAlignmentGoodEvil(oTarget) || 
    		    GetAlignmentLawChaos(oInitiator) != GetAlignmentLawChaos(oTarget))
    		{
    			int nHeal = d6(3) + min(move.nInitiatorLevel, 10);
    			object oHeal = GetCrusaderHealTarget(oPC, 10.0);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oHeal);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_L_LAW), oHeal);
        	}
        }
    }
}