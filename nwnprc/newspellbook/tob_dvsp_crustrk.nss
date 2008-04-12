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
    if(DEBUG) DoDebug("tob_dvsp_crustrk: EvaluateManeuver");

    if(move.bCanManeuver)
    {
    	if(DEBUG) DoDebug("tob_dvsp_crustrk: Can Maneuver");
    	effect eNone;
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Crusader's Strike Hit", "Crusader's Strike Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
    		if(DEBUG) DoDebug("tob_dvsp_crustrk: Attack Hit");
    		if (GetAlignmentGoodEvil(oInitiator) != GetAlignmentGoodEvil(oTarget) || 
    		    GetAlignmentLawChaos(oInitiator) != GetAlignmentLawChaos(oTarget))
    		{
    			if(DEBUG) DoDebug("tob_dvsp_crustrk: Alignment Different");
    			int nHeal = d6() + min(move.nInitiatorLevel, 5);
    			object oHeal = GetCrusaderHealTarget(oTarget, 10.0);
    			if(DEBUG) DoDebug("tob_dvsp_crustrk: GetCrusaderHealTarget");
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oHeal);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_L_LAW), oHeal);
        	}
        }
    }
    if(DEBUG) DoDebug("tob_dvsp_crustrk: Exit");
}