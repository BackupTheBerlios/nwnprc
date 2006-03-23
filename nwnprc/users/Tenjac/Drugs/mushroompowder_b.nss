// Mushroom powder secondary effects

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH,1);
	
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eStr), oPC);
}
