//::///////////////////////////////////////////////
//:: Truenaming Magic System include
//:: prc_inc_truename
//::///////////////////////////////////////////////
/** @file prc_inc_truename
    A set of constants and functions for managing
    truenaming. This is the main include for all of
    the functions that are used, including the skill
    checks that are required.

    Add more here as the functions are add


    @author Stratovarius
    @date   Created - 2006.07.02
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////


//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

/**
 * Calculates the DC of the utterance being currently truespoken.
 * Base value is 10 + utterance + ability modifier in truespeaking stat
 *
 * WARNING: Return value is not defined when an utterance is not being spoken.
 *
 */
int GetUtteranceDC(object oTrueSpeaker = OBJECT_SELF);

/**
 * Returns the main truespeaking ability of the class.
 *
 */
int GetAbilityOfClass(int nClass);

/**
 * Gets the level of the utterance
 *
 * @return            The level of the utterance
 */
int GetUtteranceLevel(int nSpellId);

//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

int GetUtteranceDC(object oTrueSpeaker = OBJECT_SELF)
{
    int nClass = GetTruespeakingClass(oTrueSpeaker);
    int nDC = 10;
    nDC += GetLevelByClass(CLASS_TYPE_TRUENAMER, oTrueSpeaker);
    nDC += GetAbilityModifier(GetAbilityOfClass(nClass), oTrueSpeaker);

    // Stuff that applies only to utterances, not utterance-like abilities goes inside
    // Update once the feats are in
    /*
    if(!GetLocalInt(oManifester, PRC_IS_PSILIKE))
    {
        if (GetLocalInt(oManifester, "PsionicEndowmentActive") == TRUE && UsePsionicFocus(oManifester))
        {
            nDC += GetHasFeat(FEAT_GREATER_PSIONIC_ENDOWMENT, oManifester) ? 4 : 2;
        }
    }
    */
    return nDC;
}

int GetAbilityOfClass(int nClass)
{
    switch(nClass)
    {
        case CLASS_TYPE_TRUENAMER:
            return ABILITY_CHARISMA;
        default:
            return ABILITY_CHARISMA;
    }

    // Technically, never gets here but the compiler does not realise that
    return -1;
}

int GetTruespeakingClass(object oTrueSpeaker)
{
	// Right now, this is the only class that speaks utterances
	return CLASS_TYPE_TRUENAMER;
}

int GetUtteranceLevel(int nSpellId)
{
	// Return the Utterance level
        return StringToInt(lookup_spell_innate(nSpellId));
}