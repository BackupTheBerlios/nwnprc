//::///////////////////////////////////////////////
//:: Jade Water Damage 2
//:: ravage_jade_wtr2
//:://////////////////////////////////////////////
/*
    1d4 Int damage and 1d4 Wis damage
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 10.01.2005
//:://////////////////////////////////////////////


#include "spinc_common"
#include "inc_ravage"

void main()
{
	object oTarget = OBJECT_SELF;
	// Ravages only affect evil creatures
	if (GetAlignmentGoodEvil(oTarget)!=ALIGNMENT_EVIL) return;
	int nExtra = GetRavageExtraDamage(oTarget);
	effect eDam = EffectAbilityDecrease(ABILITY_WISDOM, d4(1) + nExtra);
	effect eDam2 = EffectAbilityDecrease(ABILITY_INTELLIGENCE, d4(1) + nExtra);
	effect eLink = EffectLinkEffects(eDam, eDam2);
	effect eVis = GetRavageVFX();
	
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, FALSE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}