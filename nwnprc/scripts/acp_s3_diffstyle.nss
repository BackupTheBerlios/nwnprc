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
//object oPC = OBJECT_SELF; //this script is always called by one person.
string sLock = "acp_fightingstyle_lock";

/* This creates a LocalInt - a "lock" - ..we check further down if it exists...
 * if it does, we don't allow phenotype changing. To prevent lag spam. */
void LockThisFeat()
{
    SetLocalInt(OBJECT_SELF, sLock, TRUE);
    float fDelay = IntToFloat(GetPRCSwitch(PRC_ACP_DELAY))*60.0;
    if(fDelay == 0.0)
        fDelay = 90.0;
    if(fDelay == -60.0)
        fDelay = 0.0;
    DelayCommand(fDelay, DeleteLocalInt(OBJECT_SELF, sLock)); //Lock persists 1 min times switchval
}

void ResetFightingStyle() //Resets the character phenotype to 0
{
    //If we are at phenotype 5,6,7 or 8 we want to reset it to neutral.
    if (GetPhenoType(OBJECT_SELF) == 5 || GetPhenoType(OBJECT_SELF) == 6 ||
        GetPhenoType(OBJECT_SELF) == 7 || GetPhenoType(OBJECT_SELF) == 8)
    {
        SetPhenoType(0, OBJECT_SELF);
        LockThisFeat(); // Lock use!
    }

    //else if we are at phenotype 0 or 2, we do nothing. Tell the player that.
    else if (GetPhenoType(OBJECT_SELF) == 0 || GetPhenoType(OBJECT_SELF) == 2)
        SendMessageToPC(OBJECT_SELF, "Your fighting style is already neutral.");

    //else, warn that the player doesn't have a phenotype which can be reset right now
    else
        SendMessageToPC(OBJECT_SELF, "Your phenotype is non-standard and cannot be reset this way.");

}

void SetCustomFightingStyle(int iStyle) //Sets character phenotype to 5,6,7 or 8
{
    //Maybe we're already using this fighting style? Just warn the player.
    if (GetPhenoType(OBJECT_SELF) == iStyle)
        SendMessageToPC(OBJECT_SELF, "You're already using this fighting style!");

    //If we are at phenotype 0 or one of the styles themselves, we go ahead
    //and set the creature's phenotype accordingly! (safe thanks to previous 'if')
    else if (GetPhenoType(OBJECT_SELF) == 0 
        || GetPhenoType(OBJECT_SELF) == 5 
        || GetPhenoType(OBJECT_SELF) == 6 
        || GetPhenoType(OBJECT_SELF) == 7 
        || GetPhenoType(OBJECT_SELF) == 8)
    {
        SetPhenoType(iStyle, OBJECT_SELF);
        LockThisFeat(); // Lock use!
    }

    //At phenotype 2? Tell the player they're too fat!
    else if (GetPhenoType(OBJECT_SELF) == 2)
        SendMessageToPC(OBJECT_SELF, "You're too fat to use a different fighting style!");

    //...we didn't fulfil the above conditions? Warn the player.
    else
        SendMessageToPC(OBJECT_SELF, "Your phenotype is non-standard / Unable to change style");

}

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
