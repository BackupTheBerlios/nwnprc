//::///////////////////////////////////////////////
//:: Unicorn Blood Damage 1
//:: ravage_uncrnbld1
//:://////////////////////////////////////////////
/*
    1d3 Str damage
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
	effect eDam = EffectAbilityDecrease(ABILITY_STRENGTH, d3(1) + nExtra);
	effect eVis = GetRavageVFX();
	
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget, 0.0f, FALSE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}