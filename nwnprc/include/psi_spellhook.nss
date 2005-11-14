//::///////////////////////////////////////////////
//:: Spell Hook Include File
//:: prc_psi_splhook
//:://////////////////////////////////////////////
/*

    This file acts as a hub for all code that
    is hooked into the psionic spellscripts

*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 20-10-2004
//:://////////////////////////////////////////////

#include "x2_inc_craft"
#include "prc_inc_spells"
#include "inc_utility"
#include "prc_inc_itmrstr"
#include "psi_inc_psifunc"


// This function holds all functions that are supposed to run before the actual
// spellscript gets run. If this functions returns FALSE, the spell is aborted
// and the spellscript will not run
int PsiPrePowerCastCode();


//------------------------------------------------------------------------------
// if FALSE is returned by this function, the spell will not be cast
// the order in which the functions are called here DOES MATTER, changing it
// WILL break the crafting subsystems
//------------------------------------------------------------------------------
int PsiPrePowerCastCode()
{
    object oManifester = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nContinue;

    DeleteLocalInt(oManifester, "SpellConc");
    nContinue = !ExecuteScriptAndReturnInt("prespellcode",oManifester);

    //---------------------------------------------------------------------------
    // This stuff is only interesting for player characters we assume that use
    // magic device always works and NPCs don't use the crafting feats or
    // sequencers anyway. Thus, any NON PC spellcaster always exits this script
    // with TRUE (unless they are DM possessed or in the Wild Magic Area in
    // Chapter 2 of Hordes of the Underdark.
    //---------------------------------------------------------------------------
    if(!GetIsPC(oManifester)
    && !GetPRCSwitch(PRC_NPC_HAS_PC_SPELLCASTING))
    {
        if(!GetIsDMPossessed(oManifester) && !GetLocalInt(GetArea(oManifester), "X2_L_WILD_MAGIC"))
        {
            return TRUE;
        }
    }

    // Mind Trap power
    if(GetLocalInt(oTarget, "MindTrap") == TRUE && GetIsTelepathyPower())
    {
        int nPPLoss = d6();
        DelayCommand(1.0, LosePowerPoints(oManifester, nPPLoss));
    }
    // Ectoplasmic Form conc check
    if (GetLocalInt(oTarget, "EctoForm"))
    {
        int nPower = GetPowerLevel(oManifester);
        nContinue = GetIsSkillSuccessful(oManifester, SKILL_CONCENTRATION, (20 + nPower));
    }

    //---------------------------------------------------------------------------
    // Run Ectoplasmic Shambler Concentration Check
    //---------------------------------------------------------------------------
    if (nContinue)
        nContinue = EShamConc();

    //---------------------------------------------------------------------------
    // Run NullPsionicsField Check
    //---------------------------------------------------------------------------
    if (nContinue)
        nContinue = NullPsionicsField();

    if (nContinue)
    {
        //---------------------------------------------------------------------------
        // Run use magic device skill check
        //---------------------------------------------------------------------------
        nContinue = X2UseMagicDeviceCheck();
    }

    if (nContinue)
    {
        //-----------------------------------------------------------------------
        // run any user defined spellscript here
        //-----------------------------------------------------------------------
        nContinue = X2RunUserDefinedSpellScript();
    }

    //---------------------------------------------------------------------------
    // Check for the new restricted itemproperties
    //---------------------------------------------------------------------------
    if(nContinue
    && GetIsObjectValid(GetSpellCastItem())
    && !CheckPRCLimitations(GetSpellCastItem(), oManifester))
    {
        SendMessageToPC(oManifester, "You cannot use "+GetName(GetSpellCastItem()));
        nContinue = FALSE;
    }

    //---------------------------------------------------------------------------
    // The following code is only of interest if an item was targeted
    //---------------------------------------------------------------------------
    if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
    {

        //-----------------------------------------------------------------------
        // Check if spell was used to trigger item creation feat
        //-----------------------------------------------------------------------
        if (nContinue) {
            nContinue = !ExecuteScriptAndReturnInt("x2_pc_craft", oManifester);
        }

        //-----------------------------------------------------------------------
        // * Execute item OnSpellCast At routing script if activated
        //-----------------------------------------------------------------------
        if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
        {
            SetUserDefinedItemEventNumber(X2_ITEM_EVENT_SPELLCAST_AT);
            int nRet = ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oTarget), oManifester);
            if (nRet == X2_EXECUTE_SCRIPT_END)
            {
                return FALSE;
            }
        }

        //-----------------------------------------------------------------------
        // Prevent any spell that has no special coding to handle targetting of items
        // from being cast on items. We do this because we can not predict how
        // all the hundreds spells in NWN will react when cast on items
        //-----------------------------------------------------------------------
        if (nContinue) {
            nContinue = X2CastOnItemWasAllowed(oTarget);
        }
    }

    return nContinue;
}

