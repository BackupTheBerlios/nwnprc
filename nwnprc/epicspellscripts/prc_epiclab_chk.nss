
#include "prc_inc_switch"
int StartingConditional()
{
object oPC = GetPCSpeaker();
int iCondition = GetPRCSwitch(PRC_SPELLSLAB);
object oArea = GetArea(oPC);

// If teleportation to the Epic Lab is not allowed by the builder, do not show this.
if (iCondition > 2) return FALSE;

// If you're already in the Epic Lab, do NOT show this.
if (GetLocalInt(oArea,"IN_THE_LAB") == 1) return FALSE;

// If you're not an Epic Character, do NOT show this
// Would prefer to check to see if the character is capable of casting epic spells.
if (GetHitDice(oPC) < 21) return FALSE;

return TRUE;
}
