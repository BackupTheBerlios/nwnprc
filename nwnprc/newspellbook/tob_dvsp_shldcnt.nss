/*
   ----------------
   Shield Counter

   tob_dvsp_shldcnt
   ----------------

    27/09/07 by Stratovarius
*/ /** @file

    Shield Counter

    Devoted Spirit (Counter)
    Level: Crusader 2
    Prerequisite: 2 Devoted Spirit maneuvers
    Initiation Action: 1 Swift Action
    Range: Melee Attack
    Target: One Creature

    As your opponent prepares to make his attack, you bash him with your shield and disrupt his attempt.
    
    You make a single attack against an enemy at a -2 penalty. If this attack hits, your opponent takes a -20 penalty on his next strike.
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
    	effect eNone = EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST);
	DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, -2, 0, 0, "Shield Counter Hit", "Shield Counter Miss"));
        if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
        {
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectAttackDecrease(20)), oTarget, 3.0);
        }	
    }
}