// Written by Stratovarius
// Ends scrying.

#include "prc_inc_scry"

void main()
{
	object oPC = OBJECT_SELF;
	// Cancel out if the PC isn't scrying.
	if (!GetIsScrying(oPC)) return;
	FloatingTextStringOnCreature("Ending All Scrying Spells", oPC, FALSE);
	if (DEBUG) DoDebug("prc_scry_end: End Scry SpellId: " + IntToString(PRCGetSpellId()));
	ScryMain(oPC, oPC);
}