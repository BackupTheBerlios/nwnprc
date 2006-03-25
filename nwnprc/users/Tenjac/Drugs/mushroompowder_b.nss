// Mushroom powder secondary effects

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	
	ApplyAbilityDamage(oPC, ABILITY_STRENGTH, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
}