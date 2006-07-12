#include "pnp_shft_main"

void main()
{
    object oPC = GetPCSpeaker();
    SendMessageToPC(oPC, "Running deprecated shifter code, please make a bug report detailing the exact circumstances this happened in");
    DoDebug("Deprecated script 'pnp_shft_sprkbox' run. Please make a bugreport. Objects:\n"
          + "  OBJECT_SELF    = " + DebugObject2Str(OBJECT_SELF)    + "\n"
          + "  GetPCSpeaker() = " + DebugObject2Str(GetPCSpeaker()) + "\n"
            );
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
