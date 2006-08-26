//mimic shifter class feat script

#include "prc_alterations"

void main()
{
	StoreAppearance(OBJECT_SELF);
	if (CanShift(OBJECT_SELF))
	{
		object oTarget = GetSpellTargetObject();
		if (GetValidShift(OBJECT_SELF,oTarget))
		{
			SetShiftEpic(OBJECT_SELF,oTarget);
			RecognizeCreature( OBJECT_SELF, GetResRef(oTarget), GetName(oTarget) ); //recognize now takes the name of oTarget as well as the resref
		}
		else
			IncrementRemainingFeatUses(OBJECT_SELF,FEAT_PRESTIGE_SHIFTER_EGWSHAPE_1); // only uses a feat if they shift
	}
	else
	{
		IncrementRemainingFeatUses(OBJECT_SELF,FEAT_PRESTIGE_SHIFTER_EGWSHAPE_1); // only uses a feat if they shift
	}
}



