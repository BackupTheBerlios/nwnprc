//:://////////////////////////////////////////////
//:: Alternate magic system gain evaluation script
//:: prc_amagsys_gain
//:://////////////////////////////////////////////
/** @file
    This file determines if the given character
    has gained new spells / powers / utterances /
    whathaveyou since the last time it was run.
    If so, it starts the relevant selection
    conversations.

    Add new classes to their respective magic
    user type block, or if such doesn't exist
    yet for the system the class belongs to,
    make a new block for them at the end of main().


    @author Ornedan
    @date   Created - 2006.12.14
 */
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "psi_inc_psifunc"
#include "inc_newspellbook"
#include "true_inc_trufunc"
#include "tob_inc_tobfunc"
#include "inv_inc_invfunc"

//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

int CheckMissingPowers(object oPC, int nClass);
int CheckMissingSpells(object oPC, int nClass, int nMinLevel, int nMaxLevel);
int CheckMissingUtterances(object oPC, int nClass, int nLexicon);
int CheckMissingManeuvers(object oPC, int nClass);
int CheckMissingInvocations(object oPC, int nClass);

//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

void main()
{
    object oPC = OBJECT_SELF;

    // Sanity checks - Shifted or polymorphed characters may have their hide fucked up, and might be missing access to their hide-feats
    // @todo Shifting probably doesn't do this anymore, could be ditchable - Ornedan, 20061214
    if(GetLocalInt(oPC, "nPCShifted"))
        return;
    effect eTest = GetFirstEffect(oPC);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH)
            return;
        eTest = GetNextEffect(oPC);
    }

    // Handle psionics
    if(CheckMissingPowers(oPC, CLASS_TYPE_PSION))
        return;
    if(CheckMissingPowers(oPC, CLASS_TYPE_WILDER))
        return;
    if(CheckMissingPowers(oPC, CLASS_TYPE_PSYWAR))
        return;
    if(CheckMissingPowers(oPC, CLASS_TYPE_FIST_OF_ZUOKEN))
        return;
    if(CheckMissingPowers(oPC, CLASS_TYPE_WARMIND))
        return;

    // Handle new spellbooks
    if(!GetPRCSwitch(PRC_BARD_DISALLOW_NEWSPELLBOOK) && CheckMissingSpells(oPC, CLASS_TYPE_BARD, 0, 6))
        return;
    if(!GetPRCSwitch(PRC_SORC_DISALLOW_NEWSPELLBOOK) && CheckMissingSpells(oPC, CLASS_TYPE_SORCERER, 0, 9))
        return;
    if(CheckMissingSpells(oPC, CLASS_TYPE_SUEL_ARCHANAMACH, 1, 5))
        return;
    if(CheckMissingSpells(oPC, CLASS_TYPE_FAVOURED_SOUL, 0, 9))
        return;
    if(CheckMissingSpells(oPC, CLASS_TYPE_WARMAGE, 0, 9))
        return;
    if(CheckMissingSpells(oPC, CLASS_TYPE_HEXBLADE, 1, 4))
        return;
    if(CheckMissingSpells(oPC, CLASS_TYPE_DUSKBLADE, 0, 5))
        return;

    // Handle Truenaming - Three different Lexicons to check
    if(CheckMissingUtterances(oPC, CLASS_TYPE_TRUENAMER, LEXICON_EVOLVING_MIND))
        return;
    if(CheckMissingUtterances(oPC, CLASS_TYPE_TRUENAMER, LEXICON_CRAFTED_TOOL))
        return;
    if(CheckMissingUtterances(oPC, CLASS_TYPE_TRUENAMER, LEXICON_PERFECTED_MAP))
        return;
        
    // Handle Tome of Battle
    if(CheckMissingManeuvers(oPC, CLASS_TYPE_CRUSADER))
        return;
    if(CheckMissingManeuvers(oPC, CLASS_TYPE_SWORDSAGE))
        return;
    if(CheckMissingManeuvers(oPC, CLASS_TYPE_WARBLADE))
        return;
        
    // Handle Invocations
    if(CheckMissingInvocations(oPC, CLASS_TYPE_DRAGONFIRE_ADEPT))
        return;   
    if(CheckMissingInvocations(oPC, CLASS_TYPE_WARLOCK))
        return;   
    //extra invocations
    if(CheckMissingInvocations(oPC, CLASS_TYPE_INVALID))
        return;   
    //epic extra invocations
    if(CheckMissingInvocations(oPC, -2))
        return;   
}


int CheckMissingPowers(object oPC, int nClass)
{
    int nLevel = GetLevelByClass(nClass, oPC);
    if(!nLevel)
        return FALSE;

    int nCurrentPowers = GetPowerCount(oPC, nClass);
    int nMaxPowers = GetMaxPowerCount(oPC, nClass);

    if(nCurrentPowers < nMaxPowers)
    {
        // Mark the class for which the PC is to gain powers and start the conversation
        SetLocalInt(oPC, "nClass", nClass);
        StartDynamicConversation("psi_powconv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);

        return TRUE;
    }
    return FALSE;
}

int CheckMissingSpells(object oPC, int nClass, int nMinLevel, int nMaxLevel)
{
    int nLevel = GetSpellslotLevel(nClass, oPC);
    if(!nLevel)
        return FALSE;
    if(nClass == CLASS_TYPE_BARD || nClass == CLASS_TYPE_SORCERER)
    {
        if((GetLevelByClass(nClass, oPC) == nLevel) //no PrC
            && !(GetHasFeat(FEAT_DRACONIC_GRACE, oPC) || GetHasFeat(FEAT_DRACONIC_BREATH, oPC))) //no Draconic feats that apply
            return FALSE;
    }
    int i;
    for(i = nMinLevel; i <= nMaxLevel; i++)
    {
        int nMaxSpells = GetSpellKnownMaxCount(nLevel, i, nClass, oPC);
        if(nMaxSpells > 0)
        {
            int nCurrentSpells = GetSpellKnownCurrentCount(oPC, i, nClass);
            int nSpellsAvailable = GetSpellUnknownCurrentCount(oPC, i, nClass);
            if(nCurrentSpells < nMaxSpells && nSpellsAvailable > 0)
            {
                // Mark the class for which the PC is to gain powers and start the conversation
                SetLocalInt(oPC, "SpellGainClass", nClass);
                SetLocalInt(oPC, "SpellbookMinSpelllevel", nMinLevel);
                SetLocalInt(oPC, "SpellbookMaxSpelllevel", nMaxLevel);
                StartDynamicConversation("prc_s_spellgain", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);

                return TRUE;
            }
        }
    }
    return FALSE;
}

int CheckMissingUtterances(object oPC, int nClass, int nLexicon)
{
    int nLevel = GetLevelByClass(nClass, oPC);
    if(!nLevel)
        return FALSE;

    int nCurrentUtterances = GetUtteranceCount(oPC, nClass, nLexicon);
    int nMaxUtterances = GetMaxUtteranceCount(oPC, nClass, nLexicon);
    if(DEBUG) DoDebug("CheckMissingUtterances(" + IntToString(nClass) + ", " + IntToString(nLexicon) + ", " + GetName(oPC) + ") = " + IntToString(nCurrentUtterances) + ", " + IntToString(nMaxUtterances));

    if(nCurrentUtterances < nMaxUtterances)
    {
        // Mark the class for which the PC is to gain Utterances and start the conversation
        SetLocalInt(oPC, "nClass", nClass);
        StartDynamicConversation("true_utterconv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);

        return TRUE;
    }
    return FALSE;
}

int CheckMissingManeuvers(object oPC, int nClass)
{
    int nLevel = GetLevelByClass(nClass, oPC);
    if(!nLevel)
        return FALSE;

    int nCurrentManeuvers = GetManeuverCount(oPC, nClass, MANEUVER_TYPE_MANEUVER);
    int nMaxManeuvers = GetMaxManeuverCount(oPC, nClass, MANEUVER_TYPE_MANEUVER);
    int nCurrentStances = GetManeuverCount(oPC, nClass, MANEUVER_TYPE_STANCE);
    int nMaxStances = GetMaxManeuverCount(oPC, nClass, MANEUVER_TYPE_STANCE);    

    if(nCurrentManeuvers < nMaxManeuvers || nCurrentStances < nMaxStances)
    {
        // Mark the class for which the PC is to gain powers and start the conversation
        SetLocalInt(oPC, "nClass", nClass);
        StartDynamicConversation("tob_moveconv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);

        return TRUE;
    }
    return FALSE;
}


int CheckMissingInvocations(object oPC, int nClass)
{
    int nLevel;
    if(DEBUG) DoDebug("Is this even running?");
    /*if(nClass == CLASS_TYPE_DRAGONFIRE_ADEPT)
    {
           if(DEBUG) DoDebug("DFA Levels " + IntToString(GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT, oPC)));
           if(GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT, oPC) < 1) return FALSE;
    }
    
    if(nClass == CLASS_TYPE_WARLOCK)
    {
           if(DEBUG) DoDebug("Warlock Levels " + IntToString(GetLevelByClass(CLASS_TYPE_WARLOCK, oPC)));
           if(GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) < 1) return FALSE;
    }
           
        //Extra Invocations
    if(nClass ==  CLASS_TYPE_INVALID)
    {
           if(!GetHasFeat(FEAT_EXTRA_INVOCATION_I, oPC))
               return FALSE;
    }
        //Epic Extra Invocations
    if(nClass == -2)
    {
           if(!GetHasFeat(FEAT_EPIC_EXTRA_INVOCATION_I, oPC))
               return FALSE;
    }*/
    if(DEBUG) DoDebug("RUnnign here?");

    int nCurrentInvocations = GetInvocationCount(oPC, nClass);
    if(DEBUG) DoDebug("Current Invocations: " + IntToString(nCurrentInvocations));
    int nMaxInvocations = GetMaxInvocationCount(oPC, nClass);
    if(DEBUG) DoDebug("Max Invocations: " + IntToString(nMaxInvocations));
    
    if(DEBUG) DoDebug("Stupid Debug");

    if(nCurrentInvocations < nMaxInvocations)
    {
        // Mark the class for which the PC is to gain invocations and start the conversation
        SetLocalInt(oPC, "nClass", nClass);
        StartDynamicConversation("inv_invokeconv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);

        return TRUE;
    }
    return FALSE;
}