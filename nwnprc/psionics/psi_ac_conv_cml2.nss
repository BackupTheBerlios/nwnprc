// Checks whether the PC can manifest an AC of level 2

#include "psi_inc_ac_const"
#include "psi_inc_psifunc"


const int nCost = 3;

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	
	// Set the manifester class to be psion for the check
	SetLocalInt(oPC, "ManifestingClass", CLASS_TYPE_PSION);

	return GetManifesterLevel(oPC) >= nCost;
}