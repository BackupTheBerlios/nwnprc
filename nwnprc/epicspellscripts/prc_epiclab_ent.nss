
#include "prc_inc_switch"
void main()
{

object oPC = GetEnteringObject();

if (!GetIsPC(oPC)) return;

if (GetPRCSwitch(PRC_SPELLSLAB) < 2)
   return;

object oTarget;
oTarget = GetObjectByTag("EpicSpellbookMerchant");

DestroyObject(oTarget, 0.0);

}

