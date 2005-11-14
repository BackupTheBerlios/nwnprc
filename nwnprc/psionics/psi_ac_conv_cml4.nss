// Checks whether the PC can manifest an AC of level 4

#include "psi_inc_ac_const"
#include "psi_inc_psifunc"


const int nCost = 7;

int StartingConditional()
{
	object oPC = GetPCSpeaker();

	return GetManifesterLevel(oPC, CLASS_TYPE_PSION) >= nCost;
}