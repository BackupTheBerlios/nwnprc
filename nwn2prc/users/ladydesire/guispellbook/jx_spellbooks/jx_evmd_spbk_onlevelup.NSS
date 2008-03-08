#include "jx_inc_spbk_process_spsel"


void main()
{
	object oPC = GetPCLevellingUp();

	// Update the spellbooks for the PC if necessary
	JXCheckSpellbooksToUpdate(oPC);
}