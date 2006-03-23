// Mushroom powder initial effects and side effects

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	// Initial effect
	effect eLink = EffectAbilityIncrease(ABILITY_INTELLIGENCE,2);
	eLink = EffectLinkEffects(EffectAbilityIncrease(ABILITY_CHARISMA,2), eLink);
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,SupernaturalEffect(eLink), oPC, HoursToSeconds(1));
	
	// Side effects
	eWis = EffectAbilityDecrease(ABILITY_WISDOM,2);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,SupernaturalEffect(eWis), oPC, HoursToSeconds(d4()));
	
	effect eLink2 = EffectAbilityDecrease(ABILITY_STRENGTH,2);
	
	eLink2 = EffectLinkEffects(EffectAbilityDecrease(ABILITY_CONSTITUTION,2),eLink2);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,SupernaturalEffect(eLink2), oPC, HoursToSeconds(d4(2)));
}
