/////////////////////////////////////////////////
// ACP_S3_diffstyle
// Author: Ariel Kaiser
// Creation Date: 13 May 2005
////////////////////////////////////////////////
/*
  In combination with the right feat.2da and spells.2da entries, this script
  allows a player (or possessed NPC with the right feat, I guess) to change
  their fighting style and trade it for different animations. Part of the ACP pack.
*/

#include "prc_alterations"

void main()
{
    if (GetLocalInt(OBJECT_SELF, sLock)) //Feat is still locked? Bad user!
    {
        SendMessageToPC(OBJECT_SELF, "You need to wait at least 90 seconds before using this feat again.");
        return;
    }

    if (GetSpellId() == 2282) // Normal/Reset
        ResetFightingStyle();

    else if (GetSpellId() == 2278) // Kensai
        SetCustomFightingStyle(5);
    else if (GetSpellId() == 2279) // Assassin
        SetCustomFightingStyle(6);
    else if (GetSpellId() == 2280) // Heavy
        SetCustomFightingStyle(7);
    else if (GetSpellId() == 2281) // Fencing
        SetCustomFightingStyle(8);
}
