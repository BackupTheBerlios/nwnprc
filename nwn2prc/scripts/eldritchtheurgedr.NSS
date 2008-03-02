// Draco Rayne 27/09/2007
// Function to check for cold iron damage reduction from warlock levels and increase accordingly
#include "nw_i0_invocatns"

void DoEldritchDamageReduction(object oChar=OBJECT_SELF)
{
	if (GetLocalInt(oChar, "HasDR")==TRUE)
	{
		int Amount=(GetLevelByClass(CLASS_TYPE_ELDRITCHTHEURGE, oChar)+2)/3;
		int WarlockReduction=(GetLevelByClass(CLASS_TYPE_WARLOCK)+1)/4;
		Amount+=WarlockReduction;
		effect eDR = EffectDamageReduction(Amount, GMATERIAL_METAL_COLD_IRON, 0, DR_TYPE_GMATERIAL);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDR, oChar, 6.0);
		DelayCommand(6.0, DoEldritchDamageReduction(oChar));
	}
}

void main()
{
	if (GetLocalInt(OBJECT_SELF, "HasDR")==TRUE) SetLocalInt(OBJECT_SELF, "HasDR", FALSE);
	else
	{
		SetLocalInt(OBJECT_SELF, "HasDR", TRUE);
		DoEldritchDamageReduction();
	}
}