//::///////////////////////////////////////////////
//:: Golden Ice Damage 2
//:: ravage_gldn_ice2
//:://////////////////////////////////////////////
/*
    2d6 Dex damage
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
	effect eDam = EffectAbilityDecrease(ABILITY_DEXTERITY, d6(2) + nExtra);
	effect eVis = GetRavageVFX();
	
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget, 0.0f, FALSE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}