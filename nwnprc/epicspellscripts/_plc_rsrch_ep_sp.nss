//:://////////////////////////////////////////////
//:: FileName: "_plc_rsrch_ep_sp"
/*   Purpose: This is the OnDisturbed event handler script for a placeable.
        When an epic spell's book is placed into the inventory, it will search
        and determine validity of the item, and then proceed with the proper
        researching functions.

*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"

// This constant sets who may or may not research spells from the placeable
//      this script is attached to. For example, if you only want arcane casters
//      to be able to research from a lab, and not druids or clerics, you must
//      determine the exclusivity for the placebale with this constant.
//
// You should save the script under a different name once constant is set....
//
// Keywords to use for this constant:
// For CLERICS ONLY ---- "CLERIC"
// For DRUIDS ONLY ---- "DRUID"
// For BOTH DRUIDS AND CLERICS ---- "DIVINE"
// For SORCERERS AND WIZARDS ONLY ---- "ARCANE"
// For EVERYONE ---- "ALL"
string WHO_CAN_RESEARCH = "ALL";

void main()
{
    if (GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_ADDED)
    {
        object oBook = GetInventoryDisturbItem();
        object oPC = GetLastDisturbed();
        if(DEBUG) DoDebug("Player Name: " + GetName(oPC));
        string sBook = GetTag(oBook);
        if(DEBUG) DoDebug("Book Tag: " + sBook);
        //remove the "EPIC_SP_" part
        //sBook = GetStringRight(sBook, GetStringLength(sBook)-8);
        if(DEBUG) DoDebug("Book Tag after Editing: " + sBook);
        int nEpicSpell = GetSpellFromAbrev(sBook);       
        if(DEBUG) DoDebug("SpellID: " + IntToString(nEpicSpell));
        int nDC = GetDCForSpell(nEpicSpell);
        int nIP = GetResearchIPForSpell(nEpicSpell);
        int nFE = GetResearchFeatForSpell(nEpicSpell);
        int nR1 = GetR1ForSpell(nEpicSpell);
        int nR2 = GetR2ForSpell(nEpicSpell);
        int nR3 = GetR3ForSpell(nEpicSpell);
        int nR4 = GetR4ForSpell(nEpicSpell);
        string sSc = GetSchoolForSpell(nEpicSpell);
        // Make sure the player is allowed to research from this placeable.
        int nAllowed = FALSE;
        if (WHO_CAN_RESEARCH == "CLERIC" && GetIsEpicCleric(oPC)) nAllowed = TRUE;
        if (WHO_CAN_RESEARCH == "DRUID" && GetIsEpicDruid(oPC)) nAllowed = TRUE;
        if (WHO_CAN_RESEARCH == "DIVINE" &&
            (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC))) nAllowed = TRUE;
        if (WHO_CAN_RESEARCH == "ARCANE" && GetIsEpicSorcerer(oPC)) nAllowed = TRUE;
        if (WHO_CAN_RESEARCH == "ARCANE" && GetIsEpicWizard(oPC)) nAllowed = TRUE;
        if (WHO_CAN_RESEARCH == "ALL" &&
            (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC) ||
            GetIsEpicSorcerer(oPC) || GetIsEpicWizard(oPC))) nAllowed = TRUE;
        if (nAllowed == TRUE)
        {
            // Make sure the player doesn't already know this spell.
            if (!GetHasFeat(nFE, oPC))
            {
                // If applicable, adjust the spell's DC.
                if (GetPRCSwitch(PRC_EPIC_FOCI_ADJUST_DC) == TRUE)
                    nDC -= GetDCSchoolFocusAdjustment(oPC, sSc);
                // Does the player have enough gold?
                if (GetHasEnoughGoldToResearch(oPC, nDC))
                {
                    // Does the player have enough extra experience?
                    if (GetHasEnoughExperienceToResearch(oPC, nDC))
                    {
                        // Does the player have all of the other requirements?
                        if (GetHasRequiredFeatsForResearch(oPC, nR1, nR2, nR3, nR4))
                        {
                            DoSpellResearch(oPC, nDC, nIP, sSc, oBook);
                            return;
                        }
                        else
                            SendMessageToPC(oPC, MES_NOT_HAVE_REQ_FEATS);
                    }
                    else
                        SendMessageToPC(oPC, MES_NOT_ENOUGH_XP);
                }
                else
                    SendMessageToPC(oPC, MES_NOT_ENOUGH_GOLD);
            }
            else
                SendMessageToPC(oPC, MES_KNOW_SPELL);
        }
        else
            SendMessageToPC(oPC, MES_CANNOT_RESEARCH_HERE);
        //couldnt research, give the book back.
        CopyItem(oBook, oPC, TRUE);
        DestroyObject(oBook);
    }
}
