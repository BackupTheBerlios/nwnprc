// Checks whether the PC can manifest an AC of level 9

#include "psi_inc_ac_const"
#include "psi_inc_psifunc"


const int nCost = 17;

int StartingConditional()
{
	object oPC = GetPCSpeaker();

	return GetManifesterLevel(oPC) >= nCost;
}