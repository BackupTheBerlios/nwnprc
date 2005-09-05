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
    int nDC, nFE, nIP, nXX, nAllowed;

    if (sBook == "EPIC_SD_AFFLICT")
    {
        nDC = AFFLICT_DC;
        nFE = AFFLICT_FE;
        nIP = AFFLICT_IP;
        nXX = AFFLICT_XX;
    }
    if (sBook == "EPIC_SD_ANIMATE")
    {
        nDC = ANIMATE_DC;
        nFE = ANIMATE_FE;
        nIP = ANIMATE_IP;
        nXX = ANIMATE_XX;
    }
    if (sBook == "EPIC_SD_ANIMDEAD")
    {
        nDC = ANIDEAD_DC;
        nFE = ANIDEAD_FE;
        nIP = ANIDEAD_IP;
        nXX = ANIDEAD_XX;
    }
    if (sBook == "EPIC_SD_ARMOR")
    {
        nDC = ARMOR_DC;
        nFE = ARMOR_FE;
        nIP = ARMOR_IP;
        nXX = ARMOR_XX;
    }
    if (sBook == "EPIC_SD_BANISH")
    {
        nDC = BANISH_DC;
        nFE = BANISH_FE;
        nIP = BANISH_IP;
        nXX = BANISH_XX;
    }
    if (sBook == "EPIC_SD_COMPEL")
    {
        nDC = COMPEL_DC;
        nFE = COMPEL_FE;
        nIP = COMPEL_IP;
        nXX = COMPEL_XX;
    }
    if (sBook == "EPIC_SD_CONCEAL")
    {
        nDC = CONCEAL_DC;
        nFE = CONCEAL_FE;
        nIP = CONCEAL_IP;
        nXX = CONCEAL_XX;
    }
    if (sBook == "EPIC_SD_CONJURE")
    {
        nDC = CONJURE_DC;
        nFE = CONJURE_FE;
        nIP = CONJURE_IP;
        nXX = CONJURE_XX;
    }
    if (sBook == "EPIC_SD_CONTACT")
    {
        nDC = CONTACT_DC;
        nFE = CONTACT_FE;
        nIP = CONTACT_IP;
        nXX = CONTACT_XX;
    }
    if (sBook == "EPIC_SD_DELUDE")
    {
        nDC = DELUDE_DC;
        nFE = DELUDE_FE;
        nIP = DELUDE_IP;
        nXX = DELUDE_XX;
    }
    if (sBook == "EPIC_SD_DESTROY")
    {
        nDC = DESTROY_DC;
        nFE = DESTROY_FE;
        nIP = DESTROY_IP;
        nXX = DESTROY_XX;
    }
    if (sBook == "EPIC_SD_DISPEL")
    {
        nDC = DISPEL_DC;
        nFE = DISPEL_FE;
        nIP = DISPEL_IP;
        nXX = DISPEL_XX;
    }
    if (sBook == "EPIC_SD_ENERGY")
    {
        nDC = ENERGY_DC;
        nFE = ENERGY_FE;
        nIP = ENERGY_IP;
        nXX = ENERGY_XX;
    }
    if (sBook == "EPIC_SD_FORESEE")
    {
        nDC = FORESEE_DC;
        nFE = FORESEE_FE;
        nIP = FORESEE_IP;
        nXX = FORESEE_XX;
    }
    if (sBook == "EPIC_SD_FORTIFY")
    {
        nDC = FORTIFY_DC;
        nFE = FORTIFY_FE;
        nIP = FORTIFY_IP;
        nXX = FORTIFY_XX;
    }
    if (sBook == "EPIC_SD_HEAL")
    {
        nDC = HEAL_DC;
        nFE = HEAL_FE;
        nIP = HEAL_IP;
        nXX = HEAL_XX;
    }
    if (sBook == "EPIC_SD_LIFE")
    {
        nDC = LIFE_DC;
        nFE = LIFE_FE;
        nIP = LIFE_IP;
        nXX = LIFE_XX;
    }
    if (sBook == "EPIC_SD_LIGHT")
    {
        nDC = LIGHT_DC;
        nFE = LIGHT_FE;
        nIP = LIGHT_IP;
        nXX = LIGHT_XX;
    }
    if (sBook == "EPIC_SD_OPPOS")
    {
        nDC = OPPOSIT_DC;
        nFE = OPPOSIT_FE;
        nIP = OPPOSIT_IP;
        nXX = OPPOSIT_XX;
    }
    if (sBook == "EPIC_SD_REFLECT")
    {
        nDC = REFLECT_DC;
        nFE = REFLECT_FE;
        nIP = REFLECT_IP;
        nXX = REFLECT_XX;
    }
    if (sBook == "EPIC_SD_REVEAL")
    {
        nDC = REVEAL_DC;
        nFE = REVEAL_FE;
        nIP = REVEAL_IP;
        nXX = REVEAL_XX;
    }
    if (sBook == "EPIC_SD_SHADOW")
    {
        nDC = SHADOW_DC;
        nFE = SHADOW_FE;
        nIP = SHADOW_IP;
        nXX = SHADOW_XX;
    }
    if (sBook == "EPIC_SD_SLAY")
    {
        nDC = SLAY_DC;
        nFE = SLAY_FE;
        nIP = SLAY_IP;
        nXX = SLAY_XX;
    }
    if (sBook == "EPIC_SD_SUMMON")
    {
        nDC = SUMMON_DC;
        nFE = SUMMON_FE;
        nIP = SUMMON_IP;
        nXX = SUMMON_XX;
    }
    if (sBook == "EPIC_SD_TIME")
    {
        nDC = TIME_DC;
        nFE = TIME_FE;
        nIP = TIME_IP;
        nXX = TIME_XX;
    }
    if (sBook == "EPIC_SD_TRANSFRM")
    {
        nDC = TRANSFO_DC;
        nFE = TRANSFO_FE;
        nIP = TRANSFO_IP;
        nXX = TRANSFO_XX;
    }
    if (sBook == "EPIC_SD_TRANSPRT")
    {
        nDC = TRANSPO_DC;
        nFE = TRANSPO_FE;
        nIP = TRANSPO_IP;
        nXX = TRANSPO_XX;
    }
    if (sBook == "EPIC_SD_WARD")
    {
        nDC = WARD_DC;
        nFE = WARD_FE;
        nIP = WARD_IP;
        nXX = WARD_XX;
    }
    // Is the player's class allowed to learn the seed?
    nAllowed = FALSE;
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
