/*
   ----------------
   Strike of Righteous Vitality

   tob_dvsp_rghtvt
   ----------------

   29/09/07 by Stratovarius
*/ /** @file

    Strike of Righteous Vitality

    Devoted Spirit (Strike)
    Level: Crusader 9
    Prerequisite: Three Devoted Spirit maneuvers
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    As your enemy reels from your mighty blow, an ally nearby is simultaneously healed
    and cleansed of its wounds by the power of your faith.
    
    You make a single attack against an enemy who's alignment has at least one component
    different from yours. If you hit, you or an ally with 10 feet is healed, as per the heal spell.
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
    	effect eNone;
	DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Strike of Righteous Vitality Hit", "Strike of Righteous Vitality Miss"));
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
    		if (GetAlignmentGoodEvil(oInitiator) != GetAlignmentGoodEvil(oTarget) || 
    		    GetAlignmentLawChaos(oInitiator) != GetAlignmentLawChaos(oTarget))
    		{
    			int nHeal = 10 * move.nInitiatorLevel;
    			// Max for the spell
    			if (nHeal > 150) nHeal = 150;
    			object oHeal = GetCrusaderHealTarget(oTarget, 10.0);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oHeal);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X_LAW), oHeal);
        	}
        }
    }
}