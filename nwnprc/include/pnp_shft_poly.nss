
#include "pnp_shft_main"

void ShifterCheck(object oPC)
{
	if (!GetIsPC(oPC))
		return;
	int iShifterLevels = GetLevelByClass(CLASS_TYPE_PNP_SHIFTER,oPC);
	if (iShifterLevels>0)
	{
	    object oHidePC = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
	    int iTemp = GetLocalInt(oHidePC,"nPCShifted");

	    if (iTemp)
	    {
		SetShiftTrueForm(oPC);
	    }
	    //by adding this var the shifter will unpolymorph before shapeshifting
	    SetLocalInt(oHidePC,"nPCShifted",TRUE);
	}
}
