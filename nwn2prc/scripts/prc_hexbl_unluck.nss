/*
    prc_hexbl_unluck

    Hexblade gains 20% concealment
*/

#include "prc_alterations"

void main()
{
	//Declare major variables
	object oCaster = OBJECT_SELF;    
	int nDuration = 3 + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
	effect eShield =  EffectConcealment(20);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eLink = EffectLinkEffects(eShield, eDur);
	eLink = SupernaturalEffect(eLink);
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, RoundsToSeconds(nDuration));
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
}

