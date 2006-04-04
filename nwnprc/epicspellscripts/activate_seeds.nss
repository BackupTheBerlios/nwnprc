//:://////////////////////////////////////////////
//:: FileName: "activate_seeds"
/*   Purpose: This is the script that gets called by the OnItemActivated event
        when the item is one of the Epic Spell Seed books.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_epicspells"
void main()
{
    object oBook = GetItemActivated();
    string sBook = GetTag(oBook);
    int nSeed = GetSeedFromAbrev(sBook);
    int nDC = GetDCForSeed(nSeed);
    int nFE = GetFeatForSeed(nSeed);
    int nIP = GetIPForSeed(nSeed);
    int nXX = GetClassForSeed(nSeed);

    // Is the player's class allowed to learn the seed?
    int nAllowed = FALSE;
    if (nXX == 1 && GetIsEpicCleric(OBJECT_SELF)) nAllowed = TRUE;
    if (nXX == 2 && GetIsEpicDruid(OBJECT_SELF)) nAllowed = TRUE;
    if (nXX == 3 && (GetIsEpicCleric(OBJECT_SELF) ||
                    GetIsEpicDruid(OBJECT_SELF))) nAllowed = TRUE;
    if (nXX == 4 && GetIsEpicSorcerer(OBJECT_SELF)) nAllowed = TRUE;
    if (nXX == 5 && (GetIsEpicCleric(OBJECT_SELF) ||
                    GetIsEpicSorcerer(OBJECT_SELF))) nAllowed = TRUE;
    if (nXX == 6 && (GetIsEpicDruid(OBJECT_SELF) ||
                    GetIsEpicSorcerer(OBJECT_SELF))) nAllowed = TRUE;
    if (nXX == 7 && (GetIsEpicCleric(OBJECT_SELF) ||
                    GetIsEpicDruid(OBJECT_SELF) ||
                    GetIsEpicSorcerer(OBJECT_SELF))) nAllowed = TRUE;
    if (nXX == 8 && GetIsEpicWizard(OBJECT_SELF)) nAllowed = TRUE;
    if (nXX == 9 && (GetIsEpicCleric(OBJECT_SELF) ||
                    GetIsEpicWizard(OBJECT_SELF))) nAllowed = TRUE;
    if (nXX == 10 && (GetIsEpicDruid(OBJECT_SELF) ||
                    GetIsEpicWizard(OBJECT_SELF))) nAllowed = TRUE;
    if (nXX == 11 && (GetIsEpicCleric(OBJECT_SELF) ||
                    GetIsEpicDruid(OBJECT_SELF) ||
                    GetIsEpicWizard(OBJECT_SELF))) nAllowed = TRUE;
    if (nXX == 12 && (GetIsEpicSorcerer(OBJECT_SELF) ||
                    GetIsEpicWizard(OBJECT_SELF))) nAllowed = TRUE;
    if (nXX == 13 && (GetIsEpicCleric(OBJECT_SELF) ||
                    GetIsEpicSorcerer(OBJECT_SELF) ||
                    GetIsEpicWizard(OBJECT_SELF))) nAllowed = TRUE;
    if (nXX == 14 && (GetIsEpicDruid(OBJECT_SELF) ||
                    GetIsEpicSorcerer(OBJECT_SELF) ||
                    GetIsEpicWizard(OBJECT_SELF))) nAllowed = TRUE;
    if (nXX == 15 && (GetIsEpicCleric(OBJECT_SELF) ||
                    GetIsEpicDruid(OBJECT_SELF) ||
                    GetIsEpicSorcerer(OBJECT_SELF) ||
                    GetIsEpicWizard(OBJECT_SELF))) nAllowed = TRUE;
    // Give the seed if the player is able to comprehend it, doesn't already
    // have it, and is allowed to learn it.
    if (nAllowed == TRUE)
    {
        if (!GetHasFeat(nFE, OBJECT_SELF))
        {
            if (GetSpellcraftSkill(OBJECT_SELF) >= nDC)
            {
                if (PLAY_SPELLSEED_CUT == TRUE)
                    ExecuteScript(SPELLSEEDS_CUT, OBJECT_SELF);
                GiveFeat(OBJECT_SELF, nIP);
                SendMessageToPC(OBJECT_SELF, MES_LEARN_SEED);
                DoBookDecay(oBook, OBJECT_SELF);
            }
            else
            {
                SendMessageToPC(OBJECT_SELF, MES_NOT_ENOUGH_SKILL);
                SendMessageToPC(OBJECT_SELF, "You need a spellcraft skill of " +
                    IntToString(nDC) + " or greater.");
            }
        }
        else
        {
            SendMessageToPC(OBJECT_SELF, MES_KNOW_SEED);
        }
    }
    else
    {
        SendMessageToPC(OBJECT_SELF, MES_CLASS_NOT_ALLOWED);
    }
}
