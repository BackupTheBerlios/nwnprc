//true form shifter class feat script
#include "pnp_shft_main"

void main()
{
	if (CanShift(OBJECT_SELF))
	{
		//unshift
		SetShiftTrueForm(OBJECT_SELF);
		ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_POLYMORPH),OBJECT_SELF);

		// Reset any PRC feats that might have been lost from the shift
		DelayCommand(1.0, EvalPRCFeats(OBJECT_SELF));
		//clean up
		DeleteLocalInt(OBJECT_SELF, "shifting");
		DelayCommand(1.5, ClearShifterItems(OBJECT_SELF));
	}

}
