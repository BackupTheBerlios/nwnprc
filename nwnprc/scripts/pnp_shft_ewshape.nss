//mimic shifter class feat script

#include "pnp_shft_main"

void main()
{
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
		SendMessageToPC(OBJECT_SELF, "Your inventory is to full to allow you to shift.");
		SendMessageToPC(OBJECT_SELF, "Please make room enough for an armour sized item and then try again.");
		IncrementRemainingFeatUses(OBJECT_SELF,FEAT_PRESTIGE_SHIFTER_EGWSHAPE_1); // only uses a feat if they shift
	}
}



