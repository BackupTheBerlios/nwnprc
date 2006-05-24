//::///////////////////////////////////////////////
//:: Name      Devil Weed
//:: FileName  sp_devilweed.nss 
//:://////////////////////////////////////////////
/** Script for the drug Devil Weed

Author:    Tenjac
Created:   5/23/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	
	//Primary
	ApplyAbilityDamage(oPC, ABILITY_WISDOM, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
	
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eff, oPC);
	
	effect eMind = EffectSavingThrowDecrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMind, oPC, HoursToSeconds(d3()));
	
	effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
	
	//Secondary
	effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH,4);
	
	DelayCommand(60.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStr, oPC, HoursToSeconds(d3(1))));
	
	