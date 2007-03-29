/*
   ----------------
   Flame's Blessing

   tob_dw_flmblssng.nss
   ----------------

    28/03/07 by Stratovarius
*/ /** @file

    Flame's Blessing

    Desert Wind (Stance) [Fire]
    Level: Swordsage 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You
    Duration: Stance.

    Fire is not your enemy, and it does not harm you.
    
    You gain fire resistance depending on your tumble ranks.
    Tumble 4-8  : Fire Resist 5.
    Tumble 9-13 : Fire Resist 10.
    Tumble 14-18: Fire Resist 20.
    Tumble 19   : Fire Immunity.
    This is a supernatural maneuver.
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
    	int nSkill = GetSkillRank(SKILL_TUMBLE, oInitiator);
    	effect eResist;	
    	if (nSkill >= 4 && nSkill <= 8) eResist = EffectDamageResistance(DAMAGE_TYPE_FIRE, 5);
    	else if (nSkill >= 9 && nSkill <= 13) eResist = EffectDamageResistance(DAMAGE_TYPE_FIRE, 10);
    	else if (nSkill >= 14 && nSkill <= 18) eResist = EffectDamageResistance(DAMAGE_TYPE_FIRE, 20);
    	else if (nSkill >= 19) eResist = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 100);
    	effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
    	effect eLink = EffectLinkEffects(eResist, eDur);
    	       eLink = SupernaturalEffect(eLink);
    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oInitiator);
    }
}