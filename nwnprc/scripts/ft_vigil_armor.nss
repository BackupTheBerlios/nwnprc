#include "x0_i0_petrify"
#include "prc_feat_const"
#include "inc_item_props"

void main()
{
	object oPC = OBJECT_SELF;
	if (GetHasFeat(FEAT_VIGIL_ARMOR)) {
		object oSkin = GetPCSkin(oPC);

		// This appears to be the simplest way to ensure the effect
		// is active only once.
		RemoveEffectOfType(oSkin, EFFECT_TYPE_AC_INCREASE);

		ApplyEffectToObject(DURATION_TYPE_PERMANENT,
				EffectACIncrease(2, AC_NATURAL_BONUS), oSkin);
	}
}
