#include "pnp_shft_main"

void main()
{
    object oPC = GetPCSpeaker();
    if (CanShift(oPC))
    {
		object oSpark = GetItemPossessedBy(oPC, "sparkoflife");
		object oCont = CreateItemOnObject("pnp_shft_sprkbox", oPC);
		AssignCommand(oPC, ActionGiveItem(oSpark, oCont));
		ExportSingleCharacter(oPC);
		DelayCommand(0.3, AssignCommand(oPC, ActionTakeItem(oSpark, oCont)));
		DestroyObject(oCont, 0.7);
    }
}
