//::///////////////////////////////////////////////
//:: Name      Baccaran  
//:: FileName  sp_baccaran.nss 
//:://////////////////////////////////////////////
/** Script for the drug Baccaran

Author:    Tenjac
Created:   5/18/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	effect eMind = EffectSavingThrowDecrease(SAVING_THROW_WILL,2,SAVING_THROW_TYPE_MIND_SPELLS);
	effect eWis = EffectAbilityIncrease(ABILITY_WISDOM,d6()+1);
	effect eDam = EffectDamage(d6(2));

	//Primary
	ApplyAbilityDamage(oPC, ABILITY_STRENGTH, 4, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMind, oPC, HoursToSeconds(d4(2)));
	
	//Secondary - 1 minute after primary
	DelayCommand(60.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWis, oPC, HoursToSeconds(d2())));
	
	//Overdose
	if(GetHasSpellEffect(SPELL_BACCARAN, oPC))
	{
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMind, oPC, HoursToSeconds(d4(2)));
	}
}
		