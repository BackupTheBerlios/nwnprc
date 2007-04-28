/*
   ----------------
   Hunter's Sense
   
   tob_tgcw_hntsns.nss
   ----------------

    27/04/07 by Stratovarius
*/ /** @file

    Hunter's Sense

    Tiger Claw (Stance)
    Level: Swordsage 1, Warblade 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Stance.

    You sniff at the air like a hunting animal. After you focus your mind,
    an array of scents that normally eludes your awareness becomes clear to you.
    
    You gain the scent ability.
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
    	// What we use to replace scent
	effect eScent = EffectLinkEffect(EffectSkillIncrease(SKILL_SPOT, 4), EffectSkillIncrease(SKILL_LISTEN, 4));
	eScent = EffectLinkEffect(eScent, EffectSkillIncrease(SKILL_SEARCH, 4));
	eScent = EffectLinkEffect(eScent, EffectVisualEffect(VFX_DUR_FREEDOM_MOVEMENT));
	eScent = ExtraordinaryEffect(eScent);
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eScent, oTarget);
    }
}